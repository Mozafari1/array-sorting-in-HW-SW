#include "platform.h"
#include "xil_printf.h"
#include <stdio.h>

typedef unsigned int uint;

#define DATA_LEN 10
uint data[DATA_LEN] = {14, 3, 8, 88, 12, 5, 4, 5, 1, 77};

void sort(uint *array, uint length);
void print_array(uint *array, uint length);

uint partner(uint index, uint layer, uint in_layer);
void swap(uint *a, uint *b);
uint hibit(uint n);

int main() {
  init_platform();

  fputs("\rodd-even merge sort\rbefore: ", stdout);
  print_array(data, DATA_LEN);

  sort(data, DATA_LEN);

  fputs("\rafter : ", stdout);
  print_array(data, DATA_LEN);

  cleanup_platform();
  return 0;
}

// Sorts array inplace using odd-even-merge sort.
void sort(uint *array, uint length) {

  uint layers = hibit(length);

  // If length is not exactly 2^layers, then add another layer. This is to
  // ensure that the entire array is sorted.
  if (length - (1 << layers) > 0)
    layers++;

  // Iterate over sorting layers
  for (uint layer = 1; layer <= layers; ++layer) {

    // Iterate over in-layer steps
    for (uint in_layer = 1; in_layer <= layer; ++in_layer) {

      // Iterate over comparators for current layer and step
      for (uint i = 0; i < length; ++i) {
        uint p = partner(i, layer, in_layer);

        if (i != p && p < length && array[i] < array[p]) {
          swap(&array[i], &array[p]);
        }
      }
    }
  }
}

void swap(uint *a, uint *b) {
  uint temp = *a;
  *a = *b;
  *b = temp;
}

// Gets position of highest order bit in number
//
// E.g. 8 -> 3, 9 -> 3, 16 -> 4
uint hibit(uint n) {
  n |= (n >> 1);
  n |= (n >> 2);
  n |= (n >> 4);
  n |= (n >> 8);
  n |= (n >> 16);
  return n - (n >> 1);
}

// Gets partner index based on index, layer and in_layer indicies.
uint partner(uint index, uint layer, uint in_layer) {
  if (in_layer == 1) {
    return index ^ (1 << (layer - 1));
  } else {
    uint scale = 1 << (layer - in_layer);
    uint box = 1 << in_layer;
    uint sn = index / scale - (index / scale / box) * box;

    return sn == 0 || sn == box - 1
               ? index
               : sn % 2 == 0 ? index - scale : index + scale;
  }
}

void print_array(uint *array, uint length) {
  for (int i = 0; i < length; ++i) {
    char buf[10];
    sprintf(buf, "%2d%s", array[i], i + 1 == length ? "" : ", ");
    fputs(buf, stdout);
  }
}
