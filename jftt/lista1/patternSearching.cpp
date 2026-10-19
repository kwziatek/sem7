#include <iostream>
#include <vector>
#include <string>
#include <map>
#include <set>
#include <iomanip>
#include <fstream>
#include <sstream>

using namespace std;

vector<int> computeLPS(const string& P) {
    int m = P.length();
    vector<int> lps(m, 0);
    int len = 0;
    int i = 1;

    while (i < m) {
        if (P[i] == P[len]) {
            len++;
            lps[i] = len;
            i++;
        } else {
            if (len != 0) {
                len = lps[len - 1];
            } else {
                lps[i] = 0;
                i++;
            }
        }
    }
    return lps;
}

vector<map<char, int>> buildAndPrintDFA(const string& P, const string& Sigma) {
    int m = P.length();
    vector<map<char, int>> delta(m + 1);
    
    for (int q = 0; q <= m; ++q) {
        for (char c : Sigma) delta[q][c] = 0;
    }

    if (m > 0 && Sigma.find(P[0]) != string::npos) {
        delta[0][P[0]] = 1;
    }

    int X = 0;
    for (int q = 1; q <= m; ++q) {
        for (char c : Sigma) {
            delta[q][c] = delta[X][c];
        }
        
        if (q < m) {
            delta[q][P[q]] = q + 1;
            X = delta[X][P[q]]; 
        }
    }

    cout << left << setw(10) << "Stan (q)" << "| ";
    for (char c : Sigma) cout << setw(3) << c << " | ";
    cout << "\n" << string(12 + Sigma.length() * 6, '-') << "\n";

    for (int q = 0; q <= m; ++q) {
        cout << left << setw(10) << q << "| ";
        for (char c : Sigma) {
            cout << setw(3) << delta[q][c] << " | ";
        }
        cout << "\n";
    }

    return delta;
}

vector<int> searchKMP(const string& T, const string& P, const vector<int>& lspTable) {
    vector<int> occurrences;
    int q = 0;
    int i = 0;
    const int m = P.length();
    if (m == 0) return occurrences;

    while (i < T.length()) {
        if (T[i] == P[q]) {
            i++;
            q++;
            if (q == m) {
                occurrences.push_back(i - m); // Indeks początku dopasowania
                q = lspTable[q - 1];          // Przesunięcie po dopasowaniu
            }
        } else {
            if (q != 0) {
                q = lspTable[q - 1];
            } else {
                i++; // Poprawione z i + 1;
            }
        }
    }
    return occurrences;
}

vector<int> searchDFA(const string& T, int m, const vector<map<char, int>>& delta) {
    vector<int> occurrences;
    int q = 0;

    for (int i = 0; i < T.length(); ++i) {
        char c = T[i];

        if (delta[q].count(c)) {
            q = delta[q].at(c);
        } else {
            q = 0;
        }

        if (q == m) {
            occurrences.push_back(i - m + 1);
        }
    }

    return occurrences;
}

void printResult(const vector<int>& result) {
    cout << "\nLiczba powtórzeń: " << result.size() << "\n";
    for (const int& i : result) {
        cout << "i = " << i << "\n";
    }
}

string createAlphabet(const string& P) {
    set<char> unique_chars(P.begin(), P.end());
    return string(unique_chars.begin(), unique_chars.end());
}

void workflow(const string& alg, const string& pattern, const string& fileName) {
    ifstream file(fileName);
    if (!file.is_open()) {
        cerr << "Błąd: Nie można otworzyć pliku " << fileName << "\n";
        return;
    }

    stringstream buffer;
    buffer << file.rdbuf();
    string input = buffer.str();

    if (alg == "FA" || alg == "./FA") {
        string sigma = createAlphabet(pattern);
        auto delta = buildAndPrintDFA(pattern, sigma);
        vector<int> result = searchDFA(input, pattern.length(), delta);
        printResult(result);
    } else if (alg == "KMP" || alg == "./KMP") {
        vector<int> lspTable = computeLPS(pattern);
        vector<int> result = searchKMP(input, pattern, lspTable);
        printResult(result);
    } else {
        cerr << "Nieznana opcja: " << alg << ". Użyj FA lub KMP.\n";
    }
} 

int main(int argc, char *argv[]) {
    if (argc < 4) {
        cout << "Użycie: " << argv[0] << " <FA|KMP> <wzorzec> <nazwa_pliku>\n";
        return 1;
    }

    string alg = argv[1];
    string pattern = argv[2];
    string fileName = argv[3];

    workflow(alg, pattern, fileName);
    return 0;
}