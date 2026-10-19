#include <iostream>
#include <cmath>

using namespace std;

class SplitComplex {
private:
    double a; // Część rzeczywista
    double b; // Część "urojona" (hiperboliczna) j

public:
    // Konstruktor
    SplitComplex(double a = 0.0, double b = 0.0) : a(a), b(b) {}

    // Gettery
    double getA() const { return a; }
    double getB() const { return b; }

    // Dodawanie: (a1 + b1 j) + (a2 + b2 j) = (a1 + a2) + (b1 + b2) j
    SplitComplex operator+(const SplitComplex& other) const {
        return SplitComplex(a + other.a, b + other.b);
    }

    // Odejmowanie: (a1 + b1 j) - (a2 + b2 j) = (a1 - a2) + (b1 - b2) j
    SplitComplex operator-(const SplitComplex& other) const {
        return SplitComplex(a - other.a, b - other.b);
    }

    // Mnożenie: (a1 + b1 j) * (a2 + b2 j) = (a1*a2 + b1*b2) + (a1*b2 + b1*a2) j
    // Wynika to z faktu, że j^2 = 1
    SplitComplex operator*(const SplitComplex& other) const {
        return SplitComplex(
            a * other.a + b * other.b, 
            a * other.b + b * other.a
        );
    }

    // Norma: N(a + bj) = a^2 - b^2
    double norm() const {
        return a * a - b * b;
    }

    // Przeciążenie operatora strumienia (do wygodnego wypisywania)
    friend ostream& operator<<(ostream& os, const SplitComplex& num) {
        os << num.a;
        if (num.b >= 0) {
            os << " + " << num.b << "j";
        } else {
            os << " - " << abs(num.b) << "j";
        }
        return os;
    }
};

// --- Przykład użycia ---
int main() {
    SplitComplex z1(3.0, 2.0);  // 3 + 2j
    SplitComplex z2(1.0, 4.0);  // 1 + 4j

    cout << "z1 = " << z1 << "\n";
    cout << "z2 = " << z2 << "\n\n";

    cout << "z1 + z2 = " << (z1 + z2) << "\n";
    cout << "z1 - z2 = " << (z1 - z2) << "\n";
    cout << "z1 * z2 = " << (z1 * z2) << "\n\n";

    cout << "Norma z1: N(" << z1 << ") = " << z1.norm() << "\n";
    cout << "Norma z2: N(" << z2 << ") = " << z2.norm() << "\n";

    return 0;
}