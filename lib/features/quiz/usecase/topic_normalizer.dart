class TopicNormalizer {
  static String normalize(String t) {
    t = t.toLowerCase().trim();

    switch (t) {
      case "addition":
      case "subtraction":
      case "multiplication":
      case "division":
      case "percentage":
      case "average":
        return t;

      case "squares":
      case "square":
        return "square";

      case "cubes":
      case "cube":
        return "cube";

      case "square root":
      case "sqrt":
        return "square root";

      case "cube root":
      case "cbrt":
        return "cube root";

      default:
        return "addition"; // SAME fallback as your original
    }
  }
}
