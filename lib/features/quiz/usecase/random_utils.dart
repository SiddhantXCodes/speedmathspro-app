import 'dart:math';

int randInt(Random rnd, int min, int max) =>
    min + rnd.nextInt(max - min + 1);

T choice<T>(Random rnd, List<T> list) =>
    list[rnd.nextInt(list.length)];
