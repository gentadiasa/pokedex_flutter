bool validName(String name) {
  bool isInitial(String term) {
    return term.length == 2 && term[0].toUpperCase() == term[0] && term[1] == '.';
  }

  bool isWord(String term) {
    if (term.length < 2) return false;
    if (term[0].toUpperCase() != term[0]) return false;
    for (int i = 1; i < term.length; i++) {
      if (term[i].toLowerCase() != term[i]) return false;
    }
    return !term.contains('.');
  }

  List<String> terms = name.split(' ');

  if (terms.length != 2 && terms.length != 3) {
    return false;
  }

  if (terms.length == 2) {
    String first = terms[0];
    String last = terms[1];
    if ((isInitial(first) || isWord(first)) && isWord(last)) {
      return true;
    }
  }

  if (terms.length == 3) {
    String first = terms[0];
    String middle = terms[1];
    String last = terms[2];
    if ((isInitial(first) && isInitial(middle) && isWord(last)) ||
        (isWord(first) && isInitial(middle) && isWord(last)) ||
        (isWord(first) && isWord(middle) && isWord(last))) {
      return true;
    }
  }

  return false;
}

// Test cases
void main() {
  print(validName("M. Genta"));          // true
  print(validName("A. Kesya"));          // true
  print(validName("A. K. Putri"));       // true
  print(validName("Angelina K. Putri")); // true
  print(validName("Angelina"));          // false
  print(validName("a. Kesya"));          // false
  print(validName("A Kesya"));           // false
  print(validName("A. Kesya Putri"));    // false
  print(validName("A. Kesya P."));       // false
  print(validName("Angelina. Kesya Putri")); // false
}
