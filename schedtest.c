#include "types.h"
#include "stat.h"
#include "user.h"

#define MAX_CHILDREN 7

void usage() {
  printf(2, "usage: schedtest loops tickets1 [ tickets2 ... ticketsN ]\n");
  printf(2, "    loops must be greater than 0\n");
  printf(2, "    tickets must be greater than or equal to 10\n");
  printf(2, "    up to 7 tickets can be provided\n");
}

int main(int argc, char *argv[]) {
  if (argc < 3 || argc > MAX_CHILDREN + 2) {
    usage();
    exit();
  }

  int loops = atoi(argv[1]);
  if (loops <= 0) {
    usage();
    exit();
  }

  int num_children = argc - 2;
  int pids[MAX_CHILDREN];
  int i;

  // Fork child processes
  for (i = 0; i < num_children; i++) {
    int tickets = atoi(argv[i + 2]);
    if (tickets < 10) {
      usage();
      exit();
    }

    int pid = fork();
    if (pid < 0) {
      printf(2, "Fork failed\n");
      exit();
    }

    if (pid == 0) {
      // In child
      settickets(tickets);
      while (1); // infinite loop 
    } else {
      // In parent
      pids[i] = pid;
    }
  }

  // Parent process
  for (i = 0; i < loops; i++) {
    ps();
    sleep(3);
  }

  // Kill childrens 
  for (i = 0; i < num_children; i++) {
    kill(pids[i]);
  }
    // Wait for all children to exit
  for (i = 0; i < num_children; i++) {
    wait();
  }

  exit();
}
