
_schedtest:     file format elf32-i386


Disassembly of section .text:

00000000 <usage>:
#include "stat.h"
#include "user.h"

#define MAX_CHILDREN 7

void usage() {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  printf(2, "usage: schedtest loops tickets1 [ tickets2 ... ticketsN ]\n");
   6:	c7 44 24 04 d4 0a 00 	movl   $0xad4,0x4(%esp)
   d:	00 
   e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  15:	e8 eb 06 00 00       	call   705 <printf>
  printf(2, "    loops must be greater than 0\n");
  1a:	c7 44 24 04 10 0b 00 	movl   $0xb10,0x4(%esp)
  21:	00 
  22:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  29:	e8 d7 06 00 00       	call   705 <printf>
  printf(2, "    tickets must be greater than or equal to 10\n");
  2e:	c7 44 24 04 34 0b 00 	movl   $0xb34,0x4(%esp)
  35:	00 
  36:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  3d:	e8 c3 06 00 00       	call   705 <printf>
  printf(2, "    up to 7 tickets can be provided\n");
  42:	c7 44 24 04 68 0b 00 	movl   $0xb68,0x4(%esp)
  49:	00 
  4a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  51:	e8 af 06 00 00       	call   705 <printf>
}
  56:	c9                   	leave  
  57:	c3                   	ret    

00000058 <main>:

int main(int argc, char *argv[]) {
  58:	55                   	push   %ebp
  59:	89 e5                	mov    %esp,%ebp
  5b:	83 e4 f0             	and    $0xfffffff0,%esp
  5e:	83 ec 40             	sub    $0x40,%esp
  if (argc < 3 || argc > MAX_CHILDREN + 2) {
  61:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  65:	7e 06                	jle    6d <main+0x15>
  67:	83 7d 08 09          	cmpl   $0x9,0x8(%ebp)
  6b:	7e 0a                	jle    77 <main+0x1f>
    usage();
  6d:	e8 8e ff ff ff       	call   0 <usage>
    exit();
  72:	e8 fe 04 00 00       	call   575 <exit>
  }

  int loops = atoi(argv[1]);
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	83 c0 04             	add    $0x4,%eax
  7d:	8b 00                	mov    (%eax),%eax
  7f:	89 04 24             	mov    %eax,(%esp)
  82:	e8 5c 04 00 00       	call   4e3 <atoi>
  87:	89 44 24 38          	mov    %eax,0x38(%esp)
  if (loops <= 0) {
  8b:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
  90:	7f 0a                	jg     9c <main+0x44>
    usage();
  92:	e8 69 ff ff ff       	call   0 <usage>
    exit();
  97:	e8 d9 04 00 00       	call   575 <exit>
  }

  int num_children = argc - 2;
  9c:	8b 45 08             	mov    0x8(%ebp),%eax
  9f:	83 e8 02             	sub    $0x2,%eax
  a2:	89 44 24 34          	mov    %eax,0x34(%esp)
  int pids[MAX_CHILDREN];
  int i;

  // Fork child processes
  for (i = 0; i < num_children; i++) {
  a6:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%esp)
  ad:	00 
  ae:	e9 81 00 00 00       	jmp    134 <main+0xdc>
    int tickets = atoi(argv[i + 2]);
  b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  b7:	83 c0 02             	add    $0x2,%eax
  ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  c4:	01 d0                	add    %edx,%eax
  c6:	8b 00                	mov    (%eax),%eax
  c8:	89 04 24             	mov    %eax,(%esp)
  cb:	e8 13 04 00 00       	call   4e3 <atoi>
  d0:	89 44 24 30          	mov    %eax,0x30(%esp)
    if (tickets < 10) {
  d4:	83 7c 24 30 09       	cmpl   $0x9,0x30(%esp)
  d9:	7f 0a                	jg     e5 <main+0x8d>
      usage();
  db:	e8 20 ff ff ff       	call   0 <usage>
      exit();
  e0:	e8 90 04 00 00       	call   575 <exit>
    }

    int pid = fork();
  e5:	e8 83 04 00 00       	call   56d <fork>
  ea:	89 44 24 2c          	mov    %eax,0x2c(%esp)
    if (pid < 0) {
  ee:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
  f3:	79 19                	jns    10e <main+0xb6>
      printf(2, "Fork failed\n");
  f5:	c7 44 24 04 8d 0b 00 	movl   $0xb8d,0x4(%esp)
  fc:	00 
  fd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 104:	e8 fc 05 00 00       	call   705 <printf>
      exit();
 109:	e8 67 04 00 00       	call   575 <exit>
    }

    if (pid == 0) {
 10e:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
 113:	75 0e                	jne    123 <main+0xcb>
      // In child
      settickets(tickets);
 115:	8b 44 24 30          	mov    0x30(%esp),%eax
 119:	89 04 24             	mov    %eax,(%esp)
 11c:	e8 fc 04 00 00       	call   61d <settickets>
      while (1); // infinite loop 
 121:	eb fe                	jmp    121 <main+0xc9>
    } else {
      // In parent
      pids[i] = pid;
 123:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 127:	8b 54 24 2c          	mov    0x2c(%esp),%edx
 12b:	89 54 84 10          	mov    %edx,0x10(%esp,%eax,4)
  for (i = 0; i < num_children; i++) {
 12f:	83 44 24 3c 01       	addl   $0x1,0x3c(%esp)
 134:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 138:	3b 44 24 34          	cmp    0x34(%esp),%eax
 13c:	0f 8c 71 ff ff ff    	jl     b3 <main+0x5b>
    }
  }

  // Parent process
  for (i = 0; i < loops; i++) {
 142:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%esp)
 149:	00 
 14a:	eb 16                	jmp    162 <main+0x10a>
    ps();
 14c:	e8 8c 00 00 00       	call   1dd <ps>
    sleep(3);
 151:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
 158:	e8 a8 04 00 00       	call   605 <sleep>
  for (i = 0; i < loops; i++) {
 15d:	83 44 24 3c 01       	addl   $0x1,0x3c(%esp)
 162:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 166:	3b 44 24 38          	cmp    0x38(%esp),%eax
 16a:	7c e0                	jl     14c <main+0xf4>
  }

  // Kill childrens 
  for (i = 0; i < num_children; i++) {
 16c:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%esp)
 173:	00 
 174:	eb 15                	jmp    18b <main+0x133>
    kill(pids[i]);
 176:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 17a:	8b 44 84 10          	mov    0x10(%esp,%eax,4),%eax
 17e:	89 04 24             	mov    %eax,(%esp)
 181:	e8 1f 04 00 00       	call   5a5 <kill>
  for (i = 0; i < num_children; i++) {
 186:	83 44 24 3c 01       	addl   $0x1,0x3c(%esp)
 18b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 18f:	3b 44 24 34          	cmp    0x34(%esp),%eax
 193:	7c e1                	jl     176 <main+0x11e>
  }
    // Wait for all children to exit
  for (i = 0; i < num_children; i++) {
 195:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%esp)
 19c:	00 
 19d:	eb 0a                	jmp    1a9 <main+0x151>
    wait();
 19f:	e8 d9 03 00 00       	call   57d <wait>
  for (i = 0; i < num_children; i++) {
 1a4:	83 44 24 3c 01       	addl   $0x1,0x3c(%esp)
 1a9:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 1ad:	3b 44 24 34          	cmp    0x34(%esp),%eax
 1b1:	7c ec                	jl     19f <main+0x147>
  }

  exit();
 1b3:	e8 bd 03 00 00       	call   575 <exit>

000001b8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	57                   	push   %edi
 1bc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c0:	8b 55 10             	mov    0x10(%ebp),%edx
 1c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c6:	89 cb                	mov    %ecx,%ebx
 1c8:	89 df                	mov    %ebx,%edi
 1ca:	89 d1                	mov    %edx,%ecx
 1cc:	fc                   	cld    
 1cd:	f3 aa                	rep stos %al,%es:(%edi)
 1cf:	89 ca                	mov    %ecx,%edx
 1d1:	89 fb                	mov    %edi,%ebx
 1d3:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d9:	5b                   	pop    %ebx
 1da:	5f                   	pop    %edi
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    

000001dd <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	57                   	push   %edi
 1e1:	56                   	push   %esi
 1e2:	53                   	push   %ebx
 1e3:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
 1e9:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
 1ef:	89 04 24             	mov    %eax,(%esp)
 1f2:	e8 1e 04 00 00       	call   615 <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 1f7:	c7 44 24 04 9c 0b 00 	movl   $0xb9c,0x4(%esp)
 1fe:	00 
 1ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 206:	e8 fa 04 00 00       	call   705 <printf>
    for (i = 0; i < NPROC; i++) {
 20b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 212:	e9 06 01 00 00       	jmp    31d <ps+0x140>
        if (ptable[i].inuse) {
 217:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 21a:	89 d0                	mov    %edx,%eax
 21c:	c1 e0 03             	shl    $0x3,%eax
 21f:	01 d0                	add    %edx,%eax
 221:	c1 e0 02             	shl    $0x2,%eax
 224:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 227:	01 d8                	add    %ebx,%eax
 229:	2d 08 09 00 00       	sub    $0x908,%eax
 22e:	8b 00                	mov    (%eax),%eax
 230:	85 c0                	test   %eax,%eax
 232:	0f 84 e1 00 00 00    	je     319 <ps+0x13c>
            char stat = '?';
 238:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
 23c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 23f:	89 d0                	mov    %edx,%eax
 241:	c1 e0 03             	shl    $0x3,%eax
 244:	01 d0                	add    %edx,%eax
 246:	c1 e0 02             	shl    $0x2,%eax
 249:	8d 75 e8             	lea    -0x18(%ebp),%esi
 24c:	01 f0                	add    %esi,%eax
 24e:	2d e8 08 00 00       	sub    $0x8e8,%eax
 253:	0f b6 00             	movzbl (%eax),%eax
 256:	0f be c0             	movsbl %al,%eax
 259:	83 f8 05             	cmp    $0x5,%eax
 25c:	77 27                	ja     285 <ps+0xa8>
 25e:	8b 04 85 c8 0b 00 00 	mov    0xbc8(,%eax,4),%eax
 265:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
 267:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
 26b:	eb 1c                	jmp    289 <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
 26d:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 271:	eb 16                	jmp    289 <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
 273:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
 277:	eb 10                	jmp    289 <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
 279:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
 27d:	eb 0a                	jmp    289 <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
 27f:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
 283:	eb 04                	jmp    289 <ps+0xac>
                default: stat = '?';
 285:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
 289:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
 28f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 292:	89 d0                	mov    %edx,%eax
 294:	c1 e0 03             	shl    $0x3,%eax
 297:	01 d0                	add    %edx,%eax
 299:	c1 e0 02             	shl    $0x2,%eax
 29c:	83 c0 10             	add    $0x10,%eax
 29f:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 2a2:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 2a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2a9:	89 d0                	mov    %edx,%eax
 2ab:	c1 e0 03             	shl    $0x3,%eax
 2ae:	01 d0                	add    %edx,%eax
 2b0:	c1 e0 02             	shl    $0x2,%eax
 2b3:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 2b6:	01 c8                	add    %ecx,%eax
 2b8:	2d fc 08 00 00       	sub    $0x8fc,%eax
 2bd:	8b 18                	mov    (%eax),%ebx
 2bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2c2:	89 d0                	mov    %edx,%eax
 2c4:	c1 e0 03             	shl    $0x3,%eax
 2c7:	01 d0                	add    %edx,%eax
 2c9:	c1 e0 02             	shl    $0x2,%eax
 2cc:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 2cf:	01 c8                	add    %ecx,%eax
 2d1:	2d 04 09 00 00       	sub    $0x904,%eax
 2d6:	8b 08                	mov    (%eax),%ecx
 2d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2db:	89 d0                	mov    %edx,%eax
 2dd:	c1 e0 03             	shl    $0x3,%eax
 2e0:	01 d0                	add    %edx,%eax
 2e2:	c1 e0 02             	shl    $0x2,%eax
 2e5:	8d 55 e8             	lea    -0x18(%ebp),%edx
 2e8:	01 d0                	add    %edx,%eax
 2ea:	2d 00 09 00 00       	sub    $0x900,%eax
 2ef:	8b 00                	mov    (%eax),%eax
 2f1:	89 7c 24 18          	mov    %edi,0x18(%esp)
 2f5:	89 74 24 14          	mov    %esi,0x14(%esp)
 2f9:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 2fd:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 301:	89 44 24 08          	mov    %eax,0x8(%esp)
 305:	c7 44 24 04 b5 0b 00 	movl   $0xbb5,0x4(%esp)
 30c:	00 
 30d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 314:	e8 ec 03 00 00       	call   705 <printf>
    for (i = 0; i < NPROC; i++) {
 319:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 31d:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 321:	0f 8e f0 fe ff ff    	jle    217 <ps+0x3a>
        }
    }
}
 327:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 32d:	5b                   	pop    %ebx
 32e:	5e                   	pop    %esi
 32f:	5f                   	pop    %edi
 330:	5d                   	pop    %ebp
 331:	c3                   	ret    

00000332 <strcpy>:


char*
strcpy(char *s, const char *t)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 33e:	90                   	nop
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	8d 50 01             	lea    0x1(%eax),%edx
 345:	89 55 08             	mov    %edx,0x8(%ebp)
 348:	8b 55 0c             	mov    0xc(%ebp),%edx
 34b:	8d 4a 01             	lea    0x1(%edx),%ecx
 34e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 351:	0f b6 12             	movzbl (%edx),%edx
 354:	88 10                	mov    %dl,(%eax)
 356:	0f b6 00             	movzbl (%eax),%eax
 359:	84 c0                	test   %al,%al
 35b:	75 e2                	jne    33f <strcpy+0xd>
    ;
  return os;
 35d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 360:	c9                   	leave  
 361:	c3                   	ret    

00000362 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 365:	eb 08                	jmp    36f <strcmp+0xd>
    p++, q++;
 367:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 36b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	0f b6 00             	movzbl (%eax),%eax
 375:	84 c0                	test   %al,%al
 377:	74 10                	je     389 <strcmp+0x27>
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	0f b6 10             	movzbl (%eax),%edx
 37f:	8b 45 0c             	mov    0xc(%ebp),%eax
 382:	0f b6 00             	movzbl (%eax),%eax
 385:	38 c2                	cmp    %al,%dl
 387:	74 de                	je     367 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 389:	8b 45 08             	mov    0x8(%ebp),%eax
 38c:	0f b6 00             	movzbl (%eax),%eax
 38f:	0f b6 d0             	movzbl %al,%edx
 392:	8b 45 0c             	mov    0xc(%ebp),%eax
 395:	0f b6 00             	movzbl (%eax),%eax
 398:	0f b6 c0             	movzbl %al,%eax
 39b:	29 c2                	sub    %eax,%edx
 39d:	89 d0                	mov    %edx,%eax
}
 39f:	5d                   	pop    %ebp
 3a0:	c3                   	ret    

000003a1 <strlen>:

uint
strlen(const char *s)
{
 3a1:	55                   	push   %ebp
 3a2:	89 e5                	mov    %esp,%ebp
 3a4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3ae:	eb 04                	jmp    3b4 <strlen+0x13>
 3b0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	01 d0                	add    %edx,%eax
 3bc:	0f b6 00             	movzbl (%eax),%eax
 3bf:	84 c0                	test   %al,%al
 3c1:	75 ed                	jne    3b0 <strlen+0xf>
    ;
  return n;
 3c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3c6:	c9                   	leave  
 3c7:	c3                   	ret    

000003c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3c8:	55                   	push   %ebp
 3c9:	89 e5                	mov    %esp,%ebp
 3cb:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 3ce:	8b 45 10             	mov    0x10(%ebp),%eax
 3d1:	89 44 24 08          	mov    %eax,0x8(%esp)
 3d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	89 04 24             	mov    %eax,(%esp)
 3e2:	e8 d1 fd ff ff       	call   1b8 <stosb>
  return dst;
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ea:	c9                   	leave  
 3eb:	c3                   	ret    

000003ec <strchr>:

char*
strchr(const char *s, char c)
{
 3ec:	55                   	push   %ebp
 3ed:	89 e5                	mov    %esp,%ebp
 3ef:	83 ec 04             	sub    $0x4,%esp
 3f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3f8:	eb 14                	jmp    40e <strchr+0x22>
    if(*s == c)
 3fa:	8b 45 08             	mov    0x8(%ebp),%eax
 3fd:	0f b6 00             	movzbl (%eax),%eax
 400:	3a 45 fc             	cmp    -0x4(%ebp),%al
 403:	75 05                	jne    40a <strchr+0x1e>
      return (char*)s;
 405:	8b 45 08             	mov    0x8(%ebp),%eax
 408:	eb 13                	jmp    41d <strchr+0x31>
  for(; *s; s++)
 40a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
 411:	0f b6 00             	movzbl (%eax),%eax
 414:	84 c0                	test   %al,%al
 416:	75 e2                	jne    3fa <strchr+0xe>
  return 0;
 418:	b8 00 00 00 00       	mov    $0x0,%eax
}
 41d:	c9                   	leave  
 41e:	c3                   	ret    

0000041f <gets>:

char*
gets(char *buf, int max)
{
 41f:	55                   	push   %ebp
 420:	89 e5                	mov    %esp,%ebp
 422:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 425:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 42c:	eb 4c                	jmp    47a <gets+0x5b>
    cc = read(0, &c, 1);
 42e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 435:	00 
 436:	8d 45 ef             	lea    -0x11(%ebp),%eax
 439:	89 44 24 04          	mov    %eax,0x4(%esp)
 43d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 444:	e8 44 01 00 00       	call   58d <read>
 449:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 44c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 450:	7f 02                	jg     454 <gets+0x35>
      break;
 452:	eb 31                	jmp    485 <gets+0x66>
    buf[i++] = c;
 454:	8b 45 f4             	mov    -0xc(%ebp),%eax
 457:	8d 50 01             	lea    0x1(%eax),%edx
 45a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45d:	89 c2                	mov    %eax,%edx
 45f:	8b 45 08             	mov    0x8(%ebp),%eax
 462:	01 c2                	add    %eax,%edx
 464:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 468:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 46a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 46e:	3c 0a                	cmp    $0xa,%al
 470:	74 13                	je     485 <gets+0x66>
 472:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 476:	3c 0d                	cmp    $0xd,%al
 478:	74 0b                	je     485 <gets+0x66>
  for(i=0; i+1 < max; ){
 47a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47d:	83 c0 01             	add    $0x1,%eax
 480:	3b 45 0c             	cmp    0xc(%ebp),%eax
 483:	7c a9                	jl     42e <gets+0xf>
      break;
  }
  buf[i] = '\0';
 485:	8b 55 f4             	mov    -0xc(%ebp),%edx
 488:	8b 45 08             	mov    0x8(%ebp),%eax
 48b:	01 d0                	add    %edx,%eax
 48d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 490:	8b 45 08             	mov    0x8(%ebp),%eax
}
 493:	c9                   	leave  
 494:	c3                   	ret    

00000495 <stat>:

int
stat(const char *n, struct stat *st)
{
 495:	55                   	push   %ebp
 496:	89 e5                	mov    %esp,%ebp
 498:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 49b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4a2:	00 
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	89 04 24             	mov    %eax,(%esp)
 4a9:	e8 07 01 00 00       	call   5b5 <open>
 4ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b5:	79 07                	jns    4be <stat+0x29>
    return -1;
 4b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4bc:	eb 23                	jmp    4e1 <stat+0x4c>
  r = fstat(fd, st);
 4be:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c8:	89 04 24             	mov    %eax,(%esp)
 4cb:	e8 fd 00 00 00       	call   5cd <fstat>
 4d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d6:	89 04 24             	mov    %eax,(%esp)
 4d9:	e8 bf 00 00 00       	call   59d <close>
  return r;
 4de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4e1:	c9                   	leave  
 4e2:	c3                   	ret    

000004e3 <atoi>:

int
atoi(const char *s)
{
 4e3:	55                   	push   %ebp
 4e4:	89 e5                	mov    %esp,%ebp
 4e6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4f0:	eb 25                	jmp    517 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4f5:	89 d0                	mov    %edx,%eax
 4f7:	c1 e0 02             	shl    $0x2,%eax
 4fa:	01 d0                	add    %edx,%eax
 4fc:	01 c0                	add    %eax,%eax
 4fe:	89 c1                	mov    %eax,%ecx
 500:	8b 45 08             	mov    0x8(%ebp),%eax
 503:	8d 50 01             	lea    0x1(%eax),%edx
 506:	89 55 08             	mov    %edx,0x8(%ebp)
 509:	0f b6 00             	movzbl (%eax),%eax
 50c:	0f be c0             	movsbl %al,%eax
 50f:	01 c8                	add    %ecx,%eax
 511:	83 e8 30             	sub    $0x30,%eax
 514:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	0f b6 00             	movzbl (%eax),%eax
 51d:	3c 2f                	cmp    $0x2f,%al
 51f:	7e 0a                	jle    52b <atoi+0x48>
 521:	8b 45 08             	mov    0x8(%ebp),%eax
 524:	0f b6 00             	movzbl (%eax),%eax
 527:	3c 39                	cmp    $0x39,%al
 529:	7e c7                	jle    4f2 <atoi+0xf>
  return n;
 52b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 52e:	c9                   	leave  
 52f:	c3                   	ret    

00000530 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 536:	8b 45 08             	mov    0x8(%ebp),%eax
 539:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 53c:	8b 45 0c             	mov    0xc(%ebp),%eax
 53f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 542:	eb 17                	jmp    55b <memmove+0x2b>
    *dst++ = *src++;
 544:	8b 45 fc             	mov    -0x4(%ebp),%eax
 547:	8d 50 01             	lea    0x1(%eax),%edx
 54a:	89 55 fc             	mov    %edx,-0x4(%ebp)
 54d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 550:	8d 4a 01             	lea    0x1(%edx),%ecx
 553:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 556:	0f b6 12             	movzbl (%edx),%edx
 559:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 55b:	8b 45 10             	mov    0x10(%ebp),%eax
 55e:	8d 50 ff             	lea    -0x1(%eax),%edx
 561:	89 55 10             	mov    %edx,0x10(%ebp)
 564:	85 c0                	test   %eax,%eax
 566:	7f dc                	jg     544 <memmove+0x14>
  return vdst;
 568:	8b 45 08             	mov    0x8(%ebp),%eax
}
 56b:	c9                   	leave  
 56c:	c3                   	ret    

0000056d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 56d:	b8 01 00 00 00       	mov    $0x1,%eax
 572:	cd 40                	int    $0x40
 574:	c3                   	ret    

00000575 <exit>:
SYSCALL(exit)
 575:	b8 02 00 00 00       	mov    $0x2,%eax
 57a:	cd 40                	int    $0x40
 57c:	c3                   	ret    

0000057d <wait>:
SYSCALL(wait)
 57d:	b8 03 00 00 00       	mov    $0x3,%eax
 582:	cd 40                	int    $0x40
 584:	c3                   	ret    

00000585 <pipe>:
SYSCALL(pipe)
 585:	b8 04 00 00 00       	mov    $0x4,%eax
 58a:	cd 40                	int    $0x40
 58c:	c3                   	ret    

0000058d <read>:
SYSCALL(read)
 58d:	b8 05 00 00 00       	mov    $0x5,%eax
 592:	cd 40                	int    $0x40
 594:	c3                   	ret    

00000595 <write>:
SYSCALL(write)
 595:	b8 10 00 00 00       	mov    $0x10,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <close>:
SYSCALL(close)
 59d:	b8 15 00 00 00       	mov    $0x15,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <kill>:
SYSCALL(kill)
 5a5:	b8 06 00 00 00       	mov    $0x6,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <exec>:
SYSCALL(exec)
 5ad:	b8 07 00 00 00       	mov    $0x7,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <open>:
SYSCALL(open)
 5b5:	b8 0f 00 00 00       	mov    $0xf,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <mknod>:
SYSCALL(mknod)
 5bd:	b8 11 00 00 00       	mov    $0x11,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <unlink>:
SYSCALL(unlink)
 5c5:	b8 12 00 00 00       	mov    $0x12,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <fstat>:
SYSCALL(fstat)
 5cd:	b8 08 00 00 00       	mov    $0x8,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <link>:
SYSCALL(link)
 5d5:	b8 13 00 00 00       	mov    $0x13,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <mkdir>:
SYSCALL(mkdir)
 5dd:	b8 14 00 00 00       	mov    $0x14,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <chdir>:
SYSCALL(chdir)
 5e5:	b8 09 00 00 00       	mov    $0x9,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <dup>:
SYSCALL(dup)
 5ed:	b8 0a 00 00 00       	mov    $0xa,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <getpid>:
SYSCALL(getpid)
 5f5:	b8 0b 00 00 00       	mov    $0xb,%eax
 5fa:	cd 40                	int    $0x40
 5fc:	c3                   	ret    

000005fd <sbrk>:
SYSCALL(sbrk)
 5fd:	b8 0c 00 00 00       	mov    $0xc,%eax
 602:	cd 40                	int    $0x40
 604:	c3                   	ret    

00000605 <sleep>:
SYSCALL(sleep)
 605:	b8 0d 00 00 00       	mov    $0xd,%eax
 60a:	cd 40                	int    $0x40
 60c:	c3                   	ret    

0000060d <uptime>:
SYSCALL(uptime)
 60d:	b8 0e 00 00 00       	mov    $0xe,%eax
 612:	cd 40                	int    $0x40
 614:	c3                   	ret    

00000615 <getpinfo>:
SYSCALL(getpinfo)
 615:	b8 16 00 00 00       	mov    $0x16,%eax
 61a:	cd 40                	int    $0x40
 61c:	c3                   	ret    

0000061d <settickets>:
SYSCALL(settickets)
 61d:	b8 17 00 00 00       	mov    $0x17,%eax
 622:	cd 40                	int    $0x40
 624:	c3                   	ret    

00000625 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 625:	55                   	push   %ebp
 626:	89 e5                	mov    %esp,%ebp
 628:	83 ec 18             	sub    $0x18,%esp
 62b:	8b 45 0c             	mov    0xc(%ebp),%eax
 62e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 631:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 638:	00 
 639:	8d 45 f4             	lea    -0xc(%ebp),%eax
 63c:	89 44 24 04          	mov    %eax,0x4(%esp)
 640:	8b 45 08             	mov    0x8(%ebp),%eax
 643:	89 04 24             	mov    %eax,(%esp)
 646:	e8 4a ff ff ff       	call   595 <write>
}
 64b:	c9                   	leave  
 64c:	c3                   	ret    

0000064d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 64d:	55                   	push   %ebp
 64e:	89 e5                	mov    %esp,%ebp
 650:	56                   	push   %esi
 651:	53                   	push   %ebx
 652:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 655:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 65c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 660:	74 17                	je     679 <printint+0x2c>
 662:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 666:	79 11                	jns    679 <printint+0x2c>
    neg = 1;
 668:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 66f:	8b 45 0c             	mov    0xc(%ebp),%eax
 672:	f7 d8                	neg    %eax
 674:	89 45 ec             	mov    %eax,-0x14(%ebp)
 677:	eb 06                	jmp    67f <printint+0x32>
  } else {
    x = xx;
 679:	8b 45 0c             	mov    0xc(%ebp),%eax
 67c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 67f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 686:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 689:	8d 41 01             	lea    0x1(%ecx),%eax
 68c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 68f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 692:	8b 45 ec             	mov    -0x14(%ebp),%eax
 695:	ba 00 00 00 00       	mov    $0x0,%edx
 69a:	f7 f3                	div    %ebx
 69c:	89 d0                	mov    %edx,%eax
 69e:	0f b6 80 7c 0e 00 00 	movzbl 0xe7c(%eax),%eax
 6a5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6a9:	8b 75 10             	mov    0x10(%ebp),%esi
 6ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6af:	ba 00 00 00 00       	mov    $0x0,%edx
 6b4:	f7 f6                	div    %esi
 6b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6bd:	75 c7                	jne    686 <printint+0x39>
  if(neg)
 6bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6c3:	74 10                	je     6d5 <printint+0x88>
    buf[i++] = '-';
 6c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c8:	8d 50 01             	lea    0x1(%eax),%edx
 6cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6ce:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6d3:	eb 1f                	jmp    6f4 <printint+0xa7>
 6d5:	eb 1d                	jmp    6f4 <printint+0xa7>
    putc(fd, buf[i]);
 6d7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6dd:	01 d0                	add    %edx,%eax
 6df:	0f b6 00             	movzbl (%eax),%eax
 6e2:	0f be c0             	movsbl %al,%eax
 6e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ec:	89 04 24             	mov    %eax,(%esp)
 6ef:	e8 31 ff ff ff       	call   625 <putc>
  while(--i >= 0)
 6f4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6fc:	79 d9                	jns    6d7 <printint+0x8a>
}
 6fe:	83 c4 30             	add    $0x30,%esp
 701:	5b                   	pop    %ebx
 702:	5e                   	pop    %esi
 703:	5d                   	pop    %ebp
 704:	c3                   	ret    

00000705 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 705:	55                   	push   %ebp
 706:	89 e5                	mov    %esp,%ebp
 708:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 70b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 712:	8d 45 0c             	lea    0xc(%ebp),%eax
 715:	83 c0 04             	add    $0x4,%eax
 718:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 71b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 722:	e9 7c 01 00 00       	jmp    8a3 <printf+0x19e>
    c = fmt[i] & 0xff;
 727:	8b 55 0c             	mov    0xc(%ebp),%edx
 72a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72d:	01 d0                	add    %edx,%eax
 72f:	0f b6 00             	movzbl (%eax),%eax
 732:	0f be c0             	movsbl %al,%eax
 735:	25 ff 00 00 00       	and    $0xff,%eax
 73a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 73d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 741:	75 2c                	jne    76f <printf+0x6a>
      if(c == '%'){
 743:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 747:	75 0c                	jne    755 <printf+0x50>
        state = '%';
 749:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 750:	e9 4a 01 00 00       	jmp    89f <printf+0x19a>
      } else {
        putc(fd, c);
 755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 758:	0f be c0             	movsbl %al,%eax
 75b:	89 44 24 04          	mov    %eax,0x4(%esp)
 75f:	8b 45 08             	mov    0x8(%ebp),%eax
 762:	89 04 24             	mov    %eax,(%esp)
 765:	e8 bb fe ff ff       	call   625 <putc>
 76a:	e9 30 01 00 00       	jmp    89f <printf+0x19a>
      }
    } else if(state == '%'){
 76f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 773:	0f 85 26 01 00 00    	jne    89f <printf+0x19a>
      if(c == 'd'){
 779:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 77d:	75 2d                	jne    7ac <printf+0xa7>
        printint(fd, *ap, 10, 1);
 77f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 782:	8b 00                	mov    (%eax),%eax
 784:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 78b:	00 
 78c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 793:	00 
 794:	89 44 24 04          	mov    %eax,0x4(%esp)
 798:	8b 45 08             	mov    0x8(%ebp),%eax
 79b:	89 04 24             	mov    %eax,(%esp)
 79e:	e8 aa fe ff ff       	call   64d <printint>
        ap++;
 7a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a7:	e9 ec 00 00 00       	jmp    898 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 7ac:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7b0:	74 06                	je     7b8 <printf+0xb3>
 7b2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7b6:	75 2d                	jne    7e5 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 7b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7bb:	8b 00                	mov    (%eax),%eax
 7bd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7c4:	00 
 7c5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7cc:	00 
 7cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d1:	8b 45 08             	mov    0x8(%ebp),%eax
 7d4:	89 04 24             	mov    %eax,(%esp)
 7d7:	e8 71 fe ff ff       	call   64d <printint>
        ap++;
 7dc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e0:	e9 b3 00 00 00       	jmp    898 <printf+0x193>
      } else if(c == 's'){
 7e5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7e9:	75 45                	jne    830 <printf+0x12b>
        s = (char*)*ap;
 7eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ee:	8b 00                	mov    (%eax),%eax
 7f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7fb:	75 09                	jne    806 <printf+0x101>
          s = "(null)";
 7fd:	c7 45 f4 e0 0b 00 00 	movl   $0xbe0,-0xc(%ebp)
        while(*s != 0){
 804:	eb 1e                	jmp    824 <printf+0x11f>
 806:	eb 1c                	jmp    824 <printf+0x11f>
          putc(fd, *s);
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	0f b6 00             	movzbl (%eax),%eax
 80e:	0f be c0             	movsbl %al,%eax
 811:	89 44 24 04          	mov    %eax,0x4(%esp)
 815:	8b 45 08             	mov    0x8(%ebp),%eax
 818:	89 04 24             	mov    %eax,(%esp)
 81b:	e8 05 fe ff ff       	call   625 <putc>
          s++;
 820:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	0f b6 00             	movzbl (%eax),%eax
 82a:	84 c0                	test   %al,%al
 82c:	75 da                	jne    808 <printf+0x103>
 82e:	eb 68                	jmp    898 <printf+0x193>
        }
      } else if(c == 'c'){
 830:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 834:	75 1d                	jne    853 <printf+0x14e>
        putc(fd, *ap);
 836:	8b 45 e8             	mov    -0x18(%ebp),%eax
 839:	8b 00                	mov    (%eax),%eax
 83b:	0f be c0             	movsbl %al,%eax
 83e:	89 44 24 04          	mov    %eax,0x4(%esp)
 842:	8b 45 08             	mov    0x8(%ebp),%eax
 845:	89 04 24             	mov    %eax,(%esp)
 848:	e8 d8 fd ff ff       	call   625 <putc>
        ap++;
 84d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 851:	eb 45                	jmp    898 <printf+0x193>
      } else if(c == '%'){
 853:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 857:	75 17                	jne    870 <printf+0x16b>
        putc(fd, c);
 859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 85c:	0f be c0             	movsbl %al,%eax
 85f:	89 44 24 04          	mov    %eax,0x4(%esp)
 863:	8b 45 08             	mov    0x8(%ebp),%eax
 866:	89 04 24             	mov    %eax,(%esp)
 869:	e8 b7 fd ff ff       	call   625 <putc>
 86e:	eb 28                	jmp    898 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 870:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 877:	00 
 878:	8b 45 08             	mov    0x8(%ebp),%eax
 87b:	89 04 24             	mov    %eax,(%esp)
 87e:	e8 a2 fd ff ff       	call   625 <putc>
        putc(fd, c);
 883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 886:	0f be c0             	movsbl %al,%eax
 889:	89 44 24 04          	mov    %eax,0x4(%esp)
 88d:	8b 45 08             	mov    0x8(%ebp),%eax
 890:	89 04 24             	mov    %eax,(%esp)
 893:	e8 8d fd ff ff       	call   625 <putc>
      }
      state = 0;
 898:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 89f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 8a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a9:	01 d0                	add    %edx,%eax
 8ab:	0f b6 00             	movzbl (%eax),%eax
 8ae:	84 c0                	test   %al,%al
 8b0:	0f 85 71 fe ff ff    	jne    727 <printf+0x22>
    }
  }
}
 8b6:	c9                   	leave  
 8b7:	c3                   	ret    

000008b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b8:	55                   	push   %ebp
 8b9:	89 e5                	mov    %esp,%ebp
 8bb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8be:	8b 45 08             	mov    0x8(%ebp),%eax
 8c1:	83 e8 08             	sub    $0x8,%eax
 8c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c7:	a1 98 0e 00 00       	mov    0xe98,%eax
 8cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8cf:	eb 24                	jmp    8f5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d4:	8b 00                	mov    (%eax),%eax
 8d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d9:	77 12                	ja     8ed <free+0x35>
 8db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8e1:	77 24                	ja     907 <free+0x4f>
 8e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e6:	8b 00                	mov    (%eax),%eax
 8e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8eb:	77 1a                	ja     907 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f0:	8b 00                	mov    (%eax),%eax
 8f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8fb:	76 d4                	jbe    8d1 <free+0x19>
 8fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 900:	8b 00                	mov    (%eax),%eax
 902:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 905:	76 ca                	jbe    8d1 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 907:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90a:	8b 40 04             	mov    0x4(%eax),%eax
 90d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 914:	8b 45 f8             	mov    -0x8(%ebp),%eax
 917:	01 c2                	add    %eax,%edx
 919:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91c:	8b 00                	mov    (%eax),%eax
 91e:	39 c2                	cmp    %eax,%edx
 920:	75 24                	jne    946 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 922:	8b 45 f8             	mov    -0x8(%ebp),%eax
 925:	8b 50 04             	mov    0x4(%eax),%edx
 928:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92b:	8b 00                	mov    (%eax),%eax
 92d:	8b 40 04             	mov    0x4(%eax),%eax
 930:	01 c2                	add    %eax,%edx
 932:	8b 45 f8             	mov    -0x8(%ebp),%eax
 935:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 938:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93b:	8b 00                	mov    (%eax),%eax
 93d:	8b 10                	mov    (%eax),%edx
 93f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 942:	89 10                	mov    %edx,(%eax)
 944:	eb 0a                	jmp    950 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 946:	8b 45 fc             	mov    -0x4(%ebp),%eax
 949:	8b 10                	mov    (%eax),%edx
 94b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 950:	8b 45 fc             	mov    -0x4(%ebp),%eax
 953:	8b 40 04             	mov    0x4(%eax),%eax
 956:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 95d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 960:	01 d0                	add    %edx,%eax
 962:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 965:	75 20                	jne    987 <free+0xcf>
    p->s.size += bp->s.size;
 967:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96a:	8b 50 04             	mov    0x4(%eax),%edx
 96d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 970:	8b 40 04             	mov    0x4(%eax),%eax
 973:	01 c2                	add    %eax,%edx
 975:	8b 45 fc             	mov    -0x4(%ebp),%eax
 978:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 97b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97e:	8b 10                	mov    (%eax),%edx
 980:	8b 45 fc             	mov    -0x4(%ebp),%eax
 983:	89 10                	mov    %edx,(%eax)
 985:	eb 08                	jmp    98f <free+0xd7>
  } else
    p->s.ptr = bp;
 987:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 98d:	89 10                	mov    %edx,(%eax)
  freep = p;
 98f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 992:	a3 98 0e 00 00       	mov    %eax,0xe98
}
 997:	c9                   	leave  
 998:	c3                   	ret    

00000999 <morecore>:

static Header*
morecore(uint nu)
{
 999:	55                   	push   %ebp
 99a:	89 e5                	mov    %esp,%ebp
 99c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 99f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9a6:	77 07                	ja     9af <morecore+0x16>
    nu = 4096;
 9a8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9af:	8b 45 08             	mov    0x8(%ebp),%eax
 9b2:	c1 e0 03             	shl    $0x3,%eax
 9b5:	89 04 24             	mov    %eax,(%esp)
 9b8:	e8 40 fc ff ff       	call   5fd <sbrk>
 9bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9c0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9c4:	75 07                	jne    9cd <morecore+0x34>
    return 0;
 9c6:	b8 00 00 00 00       	mov    $0x0,%eax
 9cb:	eb 22                	jmp    9ef <morecore+0x56>
  hp = (Header*)p;
 9cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d6:	8b 55 08             	mov    0x8(%ebp),%edx
 9d9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9df:	83 c0 08             	add    $0x8,%eax
 9e2:	89 04 24             	mov    %eax,(%esp)
 9e5:	e8 ce fe ff ff       	call   8b8 <free>
  return freep;
 9ea:	a1 98 0e 00 00       	mov    0xe98,%eax
}
 9ef:	c9                   	leave  
 9f0:	c3                   	ret    

000009f1 <malloc>:

void*
malloc(uint nbytes)
{
 9f1:	55                   	push   %ebp
 9f2:	89 e5                	mov    %esp,%ebp
 9f4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f7:	8b 45 08             	mov    0x8(%ebp),%eax
 9fa:	83 c0 07             	add    $0x7,%eax
 9fd:	c1 e8 03             	shr    $0x3,%eax
 a00:	83 c0 01             	add    $0x1,%eax
 a03:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a06:	a1 98 0e 00 00       	mov    0xe98,%eax
 a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a12:	75 23                	jne    a37 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a14:	c7 45 f0 90 0e 00 00 	movl   $0xe90,-0x10(%ebp)
 a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1e:	a3 98 0e 00 00       	mov    %eax,0xe98
 a23:	a1 98 0e 00 00       	mov    0xe98,%eax
 a28:	a3 90 0e 00 00       	mov    %eax,0xe90
    base.s.size = 0;
 a2d:	c7 05 94 0e 00 00 00 	movl   $0x0,0xe94
 a34:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3a:	8b 00                	mov    (%eax),%eax
 a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a42:	8b 40 04             	mov    0x4(%eax),%eax
 a45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a48:	72 4d                	jb     a97 <malloc+0xa6>
      if(p->s.size == nunits)
 a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4d:	8b 40 04             	mov    0x4(%eax),%eax
 a50:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a53:	75 0c                	jne    a61 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a58:	8b 10                	mov    (%eax),%edx
 a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5d:	89 10                	mov    %edx,(%eax)
 a5f:	eb 26                	jmp    a87 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a64:	8b 40 04             	mov    0x4(%eax),%eax
 a67:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a6a:	89 c2                	mov    %eax,%edx
 a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a75:	8b 40 04             	mov    0x4(%eax),%eax
 a78:	c1 e0 03             	shl    $0x3,%eax
 a7b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a81:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a84:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a8a:	a3 98 0e 00 00       	mov    %eax,0xe98
      return (void*)(p + 1);
 a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a92:	83 c0 08             	add    $0x8,%eax
 a95:	eb 38                	jmp    acf <malloc+0xde>
    }
    if(p == freep)
 a97:	a1 98 0e 00 00       	mov    0xe98,%eax
 a9c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a9f:	75 1b                	jne    abc <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aa4:	89 04 24             	mov    %eax,(%esp)
 aa7:	e8 ed fe ff ff       	call   999 <morecore>
 aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ab3:	75 07                	jne    abc <malloc+0xcb>
        return 0;
 ab5:	b8 00 00 00 00       	mov    $0x0,%eax
 aba:	eb 13                	jmp    acf <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac5:	8b 00                	mov    (%eax),%eax
 ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 aca:	e9 70 ff ff ff       	jmp    a3f <malloc+0x4e>
}
 acf:	c9                   	leave  
 ad0:	c3                   	ret    
