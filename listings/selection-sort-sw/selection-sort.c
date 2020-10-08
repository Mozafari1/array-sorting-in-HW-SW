#include "platform.h"
#include "xil_printf.h"
#include <stdio.h>

typedef unsigned int uint;

#define DATA_LEN 9
uint data[DATA_LEN] = {14, 3, 8, 12, 5, 4, 5, 1, 77};

void sort(uint *array, uint length);
void print_array(uint *array, uint length);

int main() {
  init_platform();

  fputs("\rselection sort\rbefore: ", stdout);
  print_array(data, DATA_LEN);

  sort(data, DATA_LEN);

  fputs("\rafter : ", stdout);
  print_array(data, DATA_LEN);

  cleanup_platform();
  return 0;
}

// Sorts array inplace using selection sort.
void sort(uint *array, uint length) {

  for (int index_counter = 0; index_counter < length; ++index_counter) {
    // Set index_counter element as smallest found element
    uint smallest_index = index_counter;

    // Compare smallest element with rest of array and keep the smallest element
    // found (including index)
    for (int comparing_index_counter = index_counter + 1;
         comparing_index_counter < length; ++comparing_index_counter) {
      if (array[comparing_index_counter] < array[smallest_index]) {
        smallest_index = comparing_index_counter;
      }
    }

    // Swap first and smallest elements
    uint temp = array[index_counter];
    array[index_counter] = array[smallest_index];
    array[smallest_index] = temp;
  }
}

void print_array(uint *array, uint length) {
  for (int i = 0; i < length; ++i) {
    char buf[10];
    sprintf(buf, "%2d%s", array[i], i + 1 == length ? "" : ", ");
    fputs(buf, stdout);
  }
}
