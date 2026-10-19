#include <iostream>
#include <vector>
#include <string>
#include <map>
#include <set>
#include <iomanip>
#include <fstream>

using namespace std;

vector<map<char, int>> buildAndPrintDFA(const string& P, const string& Sigma) {
    int m = P.length();
    // delta[q][c] przechowuje stan po wczytaniu znaku 'c' w stanie 'q'
    vector<map<char, int>> delta(m + 1);
    
    // Inicjalizacja zerami
    for (int q = 0; q <= m; ++q) {
        for (char c : Sigma) delta[q][c] = 0;
    }

    // Stan początkowy dla pierwszego znaku wzorca
    if (m > 0 && Sigma.find(P[0]) != string::npos) {
        delta[0][P[0]] = 1;
    }

    int X = 0; // Stan cofania (fallback state)
    for (int q = 1; q <= m; ++q) {
        // Skopiuj przejścia ze stanu cofania
        for (char c : Sigma) {
            delta[q][c] = delta[X][c];
        }
        
        if (q < m) {
            // Nadpisz przejście w przód dla kolejnego pasującego znaku
            delta[q][P[q]] = q + 1;
            // Zaktualizuj stan cofania na kolejny krok
            X = delta[X][P[q]]; 
        }
    }

    // --- Wyświetlanie tabeli ---
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

vector<int> searchDFA(const string& T, int m, const vector<map<char, int>>& delta) {
    vector<int> occurrences;
    int q = 0;

    for (int i = 0; i < T.length(); ++i) {
        char c = T[i];

        if(delta[q].count(c)) {
            q = delta[q].at(c);
        } else {
            q = 0;
        }

        if(q == m) {
            occurrences.push_back(i - m + 1);
        }
    }

    return occurrences;
}

void printResult(vector<int>& result) {
    cout << "\nLiczba powtórzeń:" << result.size() << "\n";
    for(const int& i : result) {
        cout<< "i =" << " " << i << "\n";
    }
}

string createAlphabet(const string& P) {
    // set automatycznie usuwa duplikaty i sortuje elementy
    set<char> unique_chars(P.begin(), P.end());

    // ciąg znaków na podstawie unikalnych elementów z seta
    return string(unique_chars.begin(), unique_chars.end());
}

void workflow(const string& pattern, const string& fileName) {

    string sigma = createAlphabet(pattern);

    ifstream file;
    file.open(fileName);
    string input;
    file >> input;
    
    auto delta = buildAndPrintDFA(pattern, sigma);
    vector<int> result = searchDFA(input, pattern.length(), delta);
    printResult(result);
} 

int main(int argc, char *argv[]) {
    string pattern = argv[1];
    string fileName = argv[2];

    workflow(pattern, fileName);
    return 0;
}

