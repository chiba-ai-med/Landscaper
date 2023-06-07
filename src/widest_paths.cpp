// Based on the Dijkstra method with a binary heap by Rhyd Lewis (2023).
// The shortest distance problem was changed to solve the widest path problem
// that maximizes the "minimum-weight in the path".
// It was also modified so that the weights adapt to non-integer numerical values.

// #include <iostream>
#include <climits>
// #include <algorithm>
#include <vector>
#include <tuple>
// #include <set>
#include <queue>
// #include <ctime>
#include <Rcpp.h>

using namespace Rcpp;
using namespace std;
const double infty = numeric_limits<double>::infinity();

//Struct used for each element of the adjacency list.
struct Neighbour {
	int vertex;
	double weight; // Modify the type of weight from int to double
};
//Graph class (uses adjacency list)
class Graph {
	public:
	int n; //Num. vertices
	int m; //Num. arcs
	vector<vector<Neighbour> > adj;
	Graph(int n) {
		this->n = n;
		this->m = 0;
		this->adj.resize(n, vector<Neighbour>());
	}
	~Graph() {
		this->n = 0;
		this->m = 0;
		this->adj.clear();
	}
	void addArc(int u, int v, double w) { // Modify the type of w
		this->adj[u].push_back(Neighbour{ v, w });
		this->adj[v].push_back(Neighbour{ u, w }); // Add to be undirected graph
//		this->m++;
		this->m += 2;
	}
};

//Struct and comparison operators used with std::set std::priority_queue)
struct QueueItem {
	double label; // Modify the type from int to double
	int vertex;
};
struct minQueueItem {
	bool operator() (const QueueItem& lhs, const QueueItem& rhs) const {
		return tie(lhs.label, lhs.vertex) < tie(rhs.label, rhs.vertex);
	}
};
struct maxQueueItem {
	bool operator() (const QueueItem& lhs, const QueueItem& rhs) const {
		return tie(lhs.label, lhs.vertex) > tie(rhs.label, rhs.vertex);
	}
};

tuple<vector<double>, vector<int>> dijkstraHeap(Graph& G, int s) { // Modify the type
	//Dijkstra's algorithm using a binary heap (C++ priority_queue)
	int u, v;
	double w; // Modify the type from int to double
	priority_queue<QueueItem, vector<QueueItem>, minQueueItem> Q; // Modify max to min
	vector<double> L(G.n); // Modify the type
	vector<int> P(G.n); //
	vector<bool> D(G.n);
	for (u = 0; u < G.n; u++) {
		D[u] = false;
		L[u] = -infty; // Modify infty to -infty
		P[u] = -1;
	}
	L[s] = infty; // Modify 0 to infty
	Q.emplace(QueueItem{ L[s], s }); // Modify { 0, s } to { L[s], s }
	while (!Q.empty()) {
		u = Q.top().vertex;
		Q.pop();
		if (D[u] != true) {
			D[u] = true;
			for (auto& neighbour : G.adj[u]) {
				v = neighbour.vertex;
				w = neighbour.weight;
				if (D[v] == false) {
					double minWeight = min(L[u], w); // Add this line
					if (minWeight > L[v]) { // Modify here
						Q.emplace(QueueItem{ minWeight, v }); // Modify this also
						L[v] = minWeight;
						P[v] = u;
					}
				}
			}
		}
	}
	return make_tuple(L, P);
}

tuple<vector<int>, double> getPathAndWeight(int s, int u, vector<int>& P, vector<double>& L) {
    int v;
    vector<int> path;
    for (v = u; v != s; v = P[v]) {
        path.push_back(v);
    }
    path.push_back(s);
    reverse(path.begin(), path.end());
    return make_tuple(path, L[u]);
}

void createGraphFromDataFrame(DataFrame df, Graph &G) {
  // Access the columns of the DataFrame
  IntegerVector from_col = df["from"];
  IntegerVector to_col = df["to"];
  NumericVector weight_col = df["weight"];

  int n_edges = df.nrows();
  int n_vertices = std::max(max(from_col), max(to_col)) + 1; //  + 1

//  for (int i = 0; i < n_edges; ++i) {
//    from_col[i] -= 1;
//    to_col[i] -= 1;
//  }

  G.n = n_vertices;
  G.m = 0;
  G.adj.resize(n_vertices, vector<Neighbour>());

  for (int i = 0; i < n_edges; ++i) {
    G.addArc(from_col[i], to_col[i], weight_col[i]);
  }
}

// [[Rcpp::export]]
List widest_paths(DataFrame df, int source) {
  Graph G(0);  // Initialize an empty Graph with 0 vertices
  createGraphFromDataFrame(df, G);  // Build the Graph from the DataFrame

  // Execute Dijkstra's algorithm using a binary heap
  vector<double> L;
  vector<int> P;
  tie(L, P) = dijkstraHeap(G, source);

  // Create a List to store the results
  List result(G.n);

  // Get the widest paths for each vertex
  for (int u = 0; u < G.n; u++) {
    if (L[u] == -infty) {
      result[u] = List::create(Named("from") = source, Named("to") = u, Named("weight") = 0, Named("path") = source);
//      result[u] = "No path exists";
    } else {
      vector<int> path;
      double weight;
      tie(path, weight) = getPathAndWeight(source, u, P, L);
      result[u] = List::create(Named("from") = source, Named("to") = u, Named("weight") = weight, Named("path") = path);
    }
  }

  return result;
}