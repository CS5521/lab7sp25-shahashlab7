
_tickettest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  printf(1, "parent pid: %d; tickets should be 10\n", getpid());
   9:	e8 67 05 00 00       	call   575 <getpid>
   e:	89 44 24 08          	mov    %eax,0x8(%esp)
  12:	c7 44 24 04 54 0a 00 	movl   $0xa54,0x4(%esp)
  19:	00 
  1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  21:	e8 5f 06 00 00       	call   685 <printf>
  ps();
  26:	e8 32 01 00 00       	call   15d <ps>
  int pid = fork();
  2b:	e8 bd 04 00 00       	call   4ed <fork>
  30:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  if (pid == 0)
  34:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  39:	75 27                	jne    62 <main+0x62>
  {
     printf(1, "first child pid: %d; tickets should be 10\n", getpid());
  3b:	e8 35 05 00 00       	call   575 <getpid>
  40:	89 44 24 08          	mov    %eax,0x8(%esp)
  44:	c7 44 24 04 7c 0a 00 	movl   $0xa7c,0x4(%esp)
  4b:	00 
  4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  53:	e8 2d 06 00 00       	call   685 <printf>
     ps();
  58:	e8 00 01 00 00       	call   15d <ps>
     exit();
  5d:	e8 93 04 00 00       	call   4f5 <exit>
  }
  wait();
  62:	e8 96 04 00 00       	call   4fd <wait>
  printf(1, "parent pid: %d; setting tickets to 20\n", getpid());
  67:	e8 09 05 00 00       	call   575 <getpid>
  6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  70:	c7 44 24 04 a8 0a 00 	movl   $0xaa8,0x4(%esp)
  77:	00 
  78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7f:	e8 01 06 00 00       	call   685 <printf>
  settickets(20);
  84:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
  8b:	e8 0d 05 00 00       	call   59d <settickets>
  ps();
  90:	e8 c8 00 00 00       	call   15d <ps>
  pid = fork();
  95:	e8 53 04 00 00       	call   4ed <fork>
  9a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  if (pid == 0)
  9e:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  a3:	0f 85 85 00 00 00    	jne    12e <main+0x12e>
  {
     printf(1, "second child pid: %d; tickets should be 20\n", getpid());
  a9:	e8 c7 04 00 00       	call   575 <getpid>
  ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  b2:	c7 44 24 04 d0 0a 00 	movl   $0xad0,0x4(%esp)
  b9:	00 
  ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c1:	e8 bf 05 00 00       	call   685 <printf>
     ps();
  c6:	e8 92 00 00 00       	call   15d <ps>
     settickets(30);
  cb:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
  d2:	e8 c6 04 00 00       	call   59d <settickets>
     printf(1, "second child pid: %d; tickets should now be 30\n");
  d7:	c7 44 24 04 fc 0a 00 	movl   $0xafc,0x4(%esp)
  de:	00 
  df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e6:	e8 9a 05 00 00       	call   685 <printf>
     ps();
  eb:	e8 6d 00 00 00       	call   15d <ps>
     pid = fork();
  f0:	e8 f8 03 00 00       	call   4ed <fork>
  f5:	89 44 24 1c          	mov    %eax,0x1c(%esp)
     if (pid == 0)
  f9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  fe:	75 24                	jne    124 <main+0x124>
     {
        printf(1, "child of second child pid: %d; tickets should be 30\n", getpid());
 100:	e8 70 04 00 00       	call   575 <getpid>
 105:	89 44 24 08          	mov    %eax,0x8(%esp)
 109:	c7 44 24 04 2c 0b 00 	movl   $0xb2c,0x4(%esp)
 110:	00 
 111:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 118:	e8 68 05 00 00       	call   685 <printf>
        ps();
 11d:	e8 3b 00 00 00       	call   15d <ps>
 122:	eb 0a                	jmp    12e <main+0x12e>
     } else
     {
        wait();
 124:	e8 d4 03 00 00       	call   4fd <wait>
        exit();
 129:	e8 c7 03 00 00       	call   4f5 <exit>
     }
  }
  wait();
 12e:	e8 ca 03 00 00       	call   4fd <wait>
  exit();
 133:	e8 bd 03 00 00       	call   4f5 <exit>

00000138 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 138:	55                   	push   %ebp
 139:	89 e5                	mov    %esp,%ebp
 13b:	57                   	push   %edi
 13c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 13d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 140:	8b 55 10             	mov    0x10(%ebp),%edx
 143:	8b 45 0c             	mov    0xc(%ebp),%eax
 146:	89 cb                	mov    %ecx,%ebx
 148:	89 df                	mov    %ebx,%edi
 14a:	89 d1                	mov    %edx,%ecx
 14c:	fc                   	cld    
 14d:	f3 aa                	rep stos %al,%es:(%edi)
 14f:	89 ca                	mov    %ecx,%edx
 151:	89 fb                	mov    %edi,%ebx
 153:	89 5d 08             	mov    %ebx,0x8(%ebp)
 156:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 159:	5b                   	pop    %ebx
 15a:	5f                   	pop    %edi
 15b:	5d                   	pop    %ebp
 15c:	c3                   	ret    

0000015d <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	57                   	push   %edi
 161:	56                   	push   %esi
 162:	53                   	push   %ebx
 163:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
 169:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
 16f:	89 04 24             	mov    %eax,(%esp)
 172:	e8 1e 04 00 00       	call   595 <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 177:	c7 44 24 04 64 0b 00 	movl   $0xb64,0x4(%esp)
 17e:	00 
 17f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 186:	e8 fa 04 00 00       	call   685 <printf>
    for (i = 0; i < NPROC; i++) {
 18b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 192:	e9 06 01 00 00       	jmp    29d <ps+0x140>
        if (ptable[i].inuse) {
 197:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 19a:	89 d0                	mov    %edx,%eax
 19c:	c1 e0 03             	shl    $0x3,%eax
 19f:	01 d0                	add    %edx,%eax
 1a1:	c1 e0 02             	shl    $0x2,%eax
 1a4:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 1a7:	01 d8                	add    %ebx,%eax
 1a9:	2d 08 09 00 00       	sub    $0x908,%eax
 1ae:	8b 00                	mov    (%eax),%eax
 1b0:	85 c0                	test   %eax,%eax
 1b2:	0f 84 e1 00 00 00    	je     299 <ps+0x13c>
            char stat = '?';
 1b8:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
 1bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1bf:	89 d0                	mov    %edx,%eax
 1c1:	c1 e0 03             	shl    $0x3,%eax
 1c4:	01 d0                	add    %edx,%eax
 1c6:	c1 e0 02             	shl    $0x2,%eax
 1c9:	8d 75 e8             	lea    -0x18(%ebp),%esi
 1cc:	01 f0                	add    %esi,%eax
 1ce:	2d e8 08 00 00       	sub    $0x8e8,%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	0f be c0             	movsbl %al,%eax
 1d9:	83 f8 05             	cmp    $0x5,%eax
 1dc:	77 27                	ja     205 <ps+0xa8>
 1de:	8b 04 85 90 0b 00 00 	mov    0xb90(,%eax,4),%eax
 1e5:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
 1e7:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
 1eb:	eb 1c                	jmp    209 <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
 1ed:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 1f1:	eb 16                	jmp    209 <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
 1f3:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
 1f7:	eb 10                	jmp    209 <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
 1f9:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
 1fd:	eb 0a                	jmp    209 <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
 1ff:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
 203:	eb 04                	jmp    209 <ps+0xac>
                default: stat = '?';
 205:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
 209:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
 20f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 212:	89 d0                	mov    %edx,%eax
 214:	c1 e0 03             	shl    $0x3,%eax
 217:	01 d0                	add    %edx,%eax
 219:	c1 e0 02             	shl    $0x2,%eax
 21c:	83 c0 10             	add    $0x10,%eax
 21f:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 222:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 226:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 229:	89 d0                	mov    %edx,%eax
 22b:	c1 e0 03             	shl    $0x3,%eax
 22e:	01 d0                	add    %edx,%eax
 230:	c1 e0 02             	shl    $0x2,%eax
 233:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 236:	01 c8                	add    %ecx,%eax
 238:	2d fc 08 00 00       	sub    $0x8fc,%eax
 23d:	8b 18                	mov    (%eax),%ebx
 23f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 242:	89 d0                	mov    %edx,%eax
 244:	c1 e0 03             	shl    $0x3,%eax
 247:	01 d0                	add    %edx,%eax
 249:	c1 e0 02             	shl    $0x2,%eax
 24c:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 24f:	01 c8                	add    %ecx,%eax
 251:	2d 04 09 00 00       	sub    $0x904,%eax
 256:	8b 08                	mov    (%eax),%ecx
 258:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 25b:	89 d0                	mov    %edx,%eax
 25d:	c1 e0 03             	shl    $0x3,%eax
 260:	01 d0                	add    %edx,%eax
 262:	c1 e0 02             	shl    $0x2,%eax
 265:	8d 55 e8             	lea    -0x18(%ebp),%edx
 268:	01 d0                	add    %edx,%eax
 26a:	2d 00 09 00 00       	sub    $0x900,%eax
 26f:	8b 00                	mov    (%eax),%eax
 271:	89 7c 24 18          	mov    %edi,0x18(%esp)
 275:	89 74 24 14          	mov    %esi,0x14(%esp)
 279:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 27d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 281:	89 44 24 08          	mov    %eax,0x8(%esp)
 285:	c7 44 24 04 7d 0b 00 	movl   $0xb7d,0x4(%esp)
 28c:	00 
 28d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 294:	e8 ec 03 00 00       	call   685 <printf>
    for (i = 0; i < NPROC; i++) {
 299:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 29d:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 2a1:	0f 8e f0 fe ff ff    	jle    197 <ps+0x3a>
        }
    }
}
 2a7:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 2ad:	5b                   	pop    %ebx
 2ae:	5e                   	pop    %esi
 2af:	5f                   	pop    %edi
 2b0:	5d                   	pop    %ebp
 2b1:	c3                   	ret    

000002b2 <strcpy>:


char*
strcpy(char *s, const char *t)
{
 2b2:	55                   	push   %ebp
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2be:	90                   	nop
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	8d 50 01             	lea    0x1(%eax),%edx
 2c5:	89 55 08             	mov    %edx,0x8(%ebp)
 2c8:	8b 55 0c             	mov    0xc(%ebp),%edx
 2cb:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ce:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2d1:	0f b6 12             	movzbl (%edx),%edx
 2d4:	88 10                	mov    %dl,(%eax)
 2d6:	0f b6 00             	movzbl (%eax),%eax
 2d9:	84 c0                	test   %al,%al
 2db:	75 e2                	jne    2bf <strcpy+0xd>
    ;
  return os;
 2dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2e5:	eb 08                	jmp    2ef <strcmp+0xd>
    p++, q++;
 2e7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2eb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	0f b6 00             	movzbl (%eax),%eax
 2f5:	84 c0                	test   %al,%al
 2f7:	74 10                	je     309 <strcmp+0x27>
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
 2fc:	0f b6 10             	movzbl (%eax),%edx
 2ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 302:	0f b6 00             	movzbl (%eax),%eax
 305:	38 c2                	cmp    %al,%dl
 307:	74 de                	je     2e7 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 309:	8b 45 08             	mov    0x8(%ebp),%eax
 30c:	0f b6 00             	movzbl (%eax),%eax
 30f:	0f b6 d0             	movzbl %al,%edx
 312:	8b 45 0c             	mov    0xc(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	0f b6 c0             	movzbl %al,%eax
 31b:	29 c2                	sub    %eax,%edx
 31d:	89 d0                	mov    %edx,%eax
}
 31f:	5d                   	pop    %ebp
 320:	c3                   	ret    

00000321 <strlen>:

uint
strlen(const char *s)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 327:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 32e:	eb 04                	jmp    334 <strlen+0x13>
 330:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 334:	8b 55 fc             	mov    -0x4(%ebp),%edx
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	01 d0                	add    %edx,%eax
 33c:	0f b6 00             	movzbl (%eax),%eax
 33f:	84 c0                	test   %al,%al
 341:	75 ed                	jne    330 <strlen+0xf>
    ;
  return n;
 343:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 346:	c9                   	leave  
 347:	c3                   	ret    

00000348 <memset>:

void*
memset(void *dst, int c, uint n)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 34e:	8b 45 10             	mov    0x10(%ebp),%eax
 351:	89 44 24 08          	mov    %eax,0x8(%esp)
 355:	8b 45 0c             	mov    0xc(%ebp),%eax
 358:	89 44 24 04          	mov    %eax,0x4(%esp)
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	89 04 24             	mov    %eax,(%esp)
 362:	e8 d1 fd ff ff       	call   138 <stosb>
  return dst;
 367:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36a:	c9                   	leave  
 36b:	c3                   	ret    

0000036c <strchr>:

char*
strchr(const char *s, char c)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 04             	sub    $0x4,%esp
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 378:	eb 14                	jmp    38e <strchr+0x22>
    if(*s == c)
 37a:	8b 45 08             	mov    0x8(%ebp),%eax
 37d:	0f b6 00             	movzbl (%eax),%eax
 380:	3a 45 fc             	cmp    -0x4(%ebp),%al
 383:	75 05                	jne    38a <strchr+0x1e>
      return (char*)s;
 385:	8b 45 08             	mov    0x8(%ebp),%eax
 388:	eb 13                	jmp    39d <strchr+0x31>
  for(; *s; s++)
 38a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	0f b6 00             	movzbl (%eax),%eax
 394:	84 c0                	test   %al,%al
 396:	75 e2                	jne    37a <strchr+0xe>
  return 0;
 398:	b8 00 00 00 00       	mov    $0x0,%eax
}
 39d:	c9                   	leave  
 39e:	c3                   	ret    

0000039f <gets>:

char*
gets(char *buf, int max)
{
 39f:	55                   	push   %ebp
 3a0:	89 e5                	mov    %esp,%ebp
 3a2:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3ac:	eb 4c                	jmp    3fa <gets+0x5b>
    cc = read(0, &c, 1);
 3ae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3b5:	00 
 3b6:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3c4:	e8 44 01 00 00       	call   50d <read>
 3c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d0:	7f 02                	jg     3d4 <gets+0x35>
      break;
 3d2:	eb 31                	jmp    405 <gets+0x66>
    buf[i++] = c;
 3d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d7:	8d 50 01             	lea    0x1(%eax),%edx
 3da:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3dd:	89 c2                	mov    %eax,%edx
 3df:	8b 45 08             	mov    0x8(%ebp),%eax
 3e2:	01 c2                	add    %eax,%edx
 3e4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3e8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3ea:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3ee:	3c 0a                	cmp    $0xa,%al
 3f0:	74 13                	je     405 <gets+0x66>
 3f2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f6:	3c 0d                	cmp    $0xd,%al
 3f8:	74 0b                	je     405 <gets+0x66>
  for(i=0; i+1 < max; ){
 3fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fd:	83 c0 01             	add    $0x1,%eax
 400:	3b 45 0c             	cmp    0xc(%ebp),%eax
 403:	7c a9                	jl     3ae <gets+0xf>
      break;
  }
  buf[i] = '\0';
 405:	8b 55 f4             	mov    -0xc(%ebp),%edx
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	01 d0                	add    %edx,%eax
 40d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 410:	8b 45 08             	mov    0x8(%ebp),%eax
}
 413:	c9                   	leave  
 414:	c3                   	ret    

00000415 <stat>:

int
stat(const char *n, struct stat *st)
{
 415:	55                   	push   %ebp
 416:	89 e5                	mov    %esp,%ebp
 418:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 41b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 422:	00 
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	89 04 24             	mov    %eax,(%esp)
 429:	e8 07 01 00 00       	call   535 <open>
 42e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 435:	79 07                	jns    43e <stat+0x29>
    return -1;
 437:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 43c:	eb 23                	jmp    461 <stat+0x4c>
  r = fstat(fd, st);
 43e:	8b 45 0c             	mov    0xc(%ebp),%eax
 441:	89 44 24 04          	mov    %eax,0x4(%esp)
 445:	8b 45 f4             	mov    -0xc(%ebp),%eax
 448:	89 04 24             	mov    %eax,(%esp)
 44b:	e8 fd 00 00 00       	call   54d <fstat>
 450:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 453:	8b 45 f4             	mov    -0xc(%ebp),%eax
 456:	89 04 24             	mov    %eax,(%esp)
 459:	e8 bf 00 00 00       	call   51d <close>
  return r;
 45e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 461:	c9                   	leave  
 462:	c3                   	ret    

00000463 <atoi>:

int
atoi(const char *s)
{
 463:	55                   	push   %ebp
 464:	89 e5                	mov    %esp,%ebp
 466:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 469:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 470:	eb 25                	jmp    497 <atoi+0x34>
    n = n*10 + *s++ - '0';
 472:	8b 55 fc             	mov    -0x4(%ebp),%edx
 475:	89 d0                	mov    %edx,%eax
 477:	c1 e0 02             	shl    $0x2,%eax
 47a:	01 d0                	add    %edx,%eax
 47c:	01 c0                	add    %eax,%eax
 47e:	89 c1                	mov    %eax,%ecx
 480:	8b 45 08             	mov    0x8(%ebp),%eax
 483:	8d 50 01             	lea    0x1(%eax),%edx
 486:	89 55 08             	mov    %edx,0x8(%ebp)
 489:	0f b6 00             	movzbl (%eax),%eax
 48c:	0f be c0             	movsbl %al,%eax
 48f:	01 c8                	add    %ecx,%eax
 491:	83 e8 30             	sub    $0x30,%eax
 494:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 497:	8b 45 08             	mov    0x8(%ebp),%eax
 49a:	0f b6 00             	movzbl (%eax),%eax
 49d:	3c 2f                	cmp    $0x2f,%al
 49f:	7e 0a                	jle    4ab <atoi+0x48>
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	0f b6 00             	movzbl (%eax),%eax
 4a7:	3c 39                	cmp    $0x39,%al
 4a9:	7e c7                	jle    472 <atoi+0xf>
  return n;
 4ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4ae:	c9                   	leave  
 4af:	c3                   	ret    

000004b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
 4b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4c2:	eb 17                	jmp    4db <memmove+0x2b>
    *dst++ = *src++;
 4c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4c7:	8d 50 01             	lea    0x1(%eax),%edx
 4ca:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4d0:	8d 4a 01             	lea    0x1(%edx),%ecx
 4d3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4d6:	0f b6 12             	movzbl (%edx),%edx
 4d9:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 4db:	8b 45 10             	mov    0x10(%ebp),%eax
 4de:	8d 50 ff             	lea    -0x1(%eax),%edx
 4e1:	89 55 10             	mov    %edx,0x10(%ebp)
 4e4:	85 c0                	test   %eax,%eax
 4e6:	7f dc                	jg     4c4 <memmove+0x14>
  return vdst;
 4e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4eb:	c9                   	leave  
 4ec:	c3                   	ret    

000004ed <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ed:	b8 01 00 00 00       	mov    $0x1,%eax
 4f2:	cd 40                	int    $0x40
 4f4:	c3                   	ret    

000004f5 <exit>:
SYSCALL(exit)
 4f5:	b8 02 00 00 00       	mov    $0x2,%eax
 4fa:	cd 40                	int    $0x40
 4fc:	c3                   	ret    

000004fd <wait>:
SYSCALL(wait)
 4fd:	b8 03 00 00 00       	mov    $0x3,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <pipe>:
SYSCALL(pipe)
 505:	b8 04 00 00 00       	mov    $0x4,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <read>:
SYSCALL(read)
 50d:	b8 05 00 00 00       	mov    $0x5,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <write>:
SYSCALL(write)
 515:	b8 10 00 00 00       	mov    $0x10,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <close>:
SYSCALL(close)
 51d:	b8 15 00 00 00       	mov    $0x15,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <kill>:
SYSCALL(kill)
 525:	b8 06 00 00 00       	mov    $0x6,%eax
 52a:	cd 40                	int    $0x40
 52c:	c3                   	ret    

0000052d <exec>:
SYSCALL(exec)
 52d:	b8 07 00 00 00       	mov    $0x7,%eax
 532:	cd 40                	int    $0x40
 534:	c3                   	ret    

00000535 <open>:
SYSCALL(open)
 535:	b8 0f 00 00 00       	mov    $0xf,%eax
 53a:	cd 40                	int    $0x40
 53c:	c3                   	ret    

0000053d <mknod>:
SYSCALL(mknod)
 53d:	b8 11 00 00 00       	mov    $0x11,%eax
 542:	cd 40                	int    $0x40
 544:	c3                   	ret    

00000545 <unlink>:
SYSCALL(unlink)
 545:	b8 12 00 00 00       	mov    $0x12,%eax
 54a:	cd 40                	int    $0x40
 54c:	c3                   	ret    

0000054d <fstat>:
SYSCALL(fstat)
 54d:	b8 08 00 00 00       	mov    $0x8,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    

00000555 <link>:
SYSCALL(link)
 555:	b8 13 00 00 00       	mov    $0x13,%eax
 55a:	cd 40                	int    $0x40
 55c:	c3                   	ret    

0000055d <mkdir>:
SYSCALL(mkdir)
 55d:	b8 14 00 00 00       	mov    $0x14,%eax
 562:	cd 40                	int    $0x40
 564:	c3                   	ret    

00000565 <chdir>:
SYSCALL(chdir)
 565:	b8 09 00 00 00       	mov    $0x9,%eax
 56a:	cd 40                	int    $0x40
 56c:	c3                   	ret    

0000056d <dup>:
SYSCALL(dup)
 56d:	b8 0a 00 00 00       	mov    $0xa,%eax
 572:	cd 40                	int    $0x40
 574:	c3                   	ret    

00000575 <getpid>:
SYSCALL(getpid)
 575:	b8 0b 00 00 00       	mov    $0xb,%eax
 57a:	cd 40                	int    $0x40
 57c:	c3                   	ret    

0000057d <sbrk>:
SYSCALL(sbrk)
 57d:	b8 0c 00 00 00       	mov    $0xc,%eax
 582:	cd 40                	int    $0x40
 584:	c3                   	ret    

00000585 <sleep>:
SYSCALL(sleep)
 585:	b8 0d 00 00 00       	mov    $0xd,%eax
 58a:	cd 40                	int    $0x40
 58c:	c3                   	ret    

0000058d <uptime>:
SYSCALL(uptime)
 58d:	b8 0e 00 00 00       	mov    $0xe,%eax
 592:	cd 40                	int    $0x40
 594:	c3                   	ret    

00000595 <getpinfo>:
SYSCALL(getpinfo)
 595:	b8 16 00 00 00       	mov    $0x16,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <settickets>:
SYSCALL(settickets)
 59d:	b8 17 00 00 00       	mov    $0x17,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5a5:	55                   	push   %ebp
 5a6:	89 e5                	mov    %esp,%ebp
 5a8:	83 ec 18             	sub    $0x18,%esp
 5ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ae:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5b8:	00 
 5b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	89 04 24             	mov    %eax,(%esp)
 5c6:	e8 4a ff ff ff       	call   515 <write>
}
 5cb:	c9                   	leave  
 5cc:	c3                   	ret    

000005cd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5cd:	55                   	push   %ebp
 5ce:	89 e5                	mov    %esp,%ebp
 5d0:	56                   	push   %esi
 5d1:	53                   	push   %ebx
 5d2:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5dc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5e0:	74 17                	je     5f9 <printint+0x2c>
 5e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5e6:	79 11                	jns    5f9 <printint+0x2c>
    neg = 1;
 5e8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f2:	f7 d8                	neg    %eax
 5f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5f7:	eb 06                	jmp    5ff <printint+0x32>
  } else {
    x = xx;
 5f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 5fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 606:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 609:	8d 41 01             	lea    0x1(%ecx),%eax
 60c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 60f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 612:	8b 45 ec             	mov    -0x14(%ebp),%eax
 615:	ba 00 00 00 00       	mov    $0x0,%edx
 61a:	f7 f3                	div    %ebx
 61c:	89 d0                	mov    %edx,%eax
 61e:	0f b6 80 24 0e 00 00 	movzbl 0xe24(%eax),%eax
 625:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 629:	8b 75 10             	mov    0x10(%ebp),%esi
 62c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 62f:	ba 00 00 00 00       	mov    $0x0,%edx
 634:	f7 f6                	div    %esi
 636:	89 45 ec             	mov    %eax,-0x14(%ebp)
 639:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 63d:	75 c7                	jne    606 <printint+0x39>
  if(neg)
 63f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 643:	74 10                	je     655 <printint+0x88>
    buf[i++] = '-';
 645:	8b 45 f4             	mov    -0xc(%ebp),%eax
 648:	8d 50 01             	lea    0x1(%eax),%edx
 64b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 64e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 653:	eb 1f                	jmp    674 <printint+0xa7>
 655:	eb 1d                	jmp    674 <printint+0xa7>
    putc(fd, buf[i]);
 657:	8d 55 dc             	lea    -0x24(%ebp),%edx
 65a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65d:	01 d0                	add    %edx,%eax
 65f:	0f b6 00             	movzbl (%eax),%eax
 662:	0f be c0             	movsbl %al,%eax
 665:	89 44 24 04          	mov    %eax,0x4(%esp)
 669:	8b 45 08             	mov    0x8(%ebp),%eax
 66c:	89 04 24             	mov    %eax,(%esp)
 66f:	e8 31 ff ff ff       	call   5a5 <putc>
  while(--i >= 0)
 674:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 67c:	79 d9                	jns    657 <printint+0x8a>
}
 67e:	83 c4 30             	add    $0x30,%esp
 681:	5b                   	pop    %ebx
 682:	5e                   	pop    %esi
 683:	5d                   	pop    %ebp
 684:	c3                   	ret    

00000685 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 685:	55                   	push   %ebp
 686:	89 e5                	mov    %esp,%ebp
 688:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 68b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 692:	8d 45 0c             	lea    0xc(%ebp),%eax
 695:	83 c0 04             	add    $0x4,%eax
 698:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 69b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6a2:	e9 7c 01 00 00       	jmp    823 <printf+0x19e>
    c = fmt[i] & 0xff;
 6a7:	8b 55 0c             	mov    0xc(%ebp),%edx
 6aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ad:	01 d0                	add    %edx,%eax
 6af:	0f b6 00             	movzbl (%eax),%eax
 6b2:	0f be c0             	movsbl %al,%eax
 6b5:	25 ff 00 00 00       	and    $0xff,%eax
 6ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6c1:	75 2c                	jne    6ef <printf+0x6a>
      if(c == '%'){
 6c3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c7:	75 0c                	jne    6d5 <printf+0x50>
        state = '%';
 6c9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6d0:	e9 4a 01 00 00       	jmp    81f <printf+0x19a>
      } else {
        putc(fd, c);
 6d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d8:	0f be c0             	movsbl %al,%eax
 6db:	89 44 24 04          	mov    %eax,0x4(%esp)
 6df:	8b 45 08             	mov    0x8(%ebp),%eax
 6e2:	89 04 24             	mov    %eax,(%esp)
 6e5:	e8 bb fe ff ff       	call   5a5 <putc>
 6ea:	e9 30 01 00 00       	jmp    81f <printf+0x19a>
      }
    } else if(state == '%'){
 6ef:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6f3:	0f 85 26 01 00 00    	jne    81f <printf+0x19a>
      if(c == 'd'){
 6f9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6fd:	75 2d                	jne    72c <printf+0xa7>
        printint(fd, *ap, 10, 1);
 6ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
 702:	8b 00                	mov    (%eax),%eax
 704:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 70b:	00 
 70c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 713:	00 
 714:	89 44 24 04          	mov    %eax,0x4(%esp)
 718:	8b 45 08             	mov    0x8(%ebp),%eax
 71b:	89 04 24             	mov    %eax,(%esp)
 71e:	e8 aa fe ff ff       	call   5cd <printint>
        ap++;
 723:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 727:	e9 ec 00 00 00       	jmp    818 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 72c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 730:	74 06                	je     738 <printf+0xb3>
 732:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 736:	75 2d                	jne    765 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 738:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73b:	8b 00                	mov    (%eax),%eax
 73d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 744:	00 
 745:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 74c:	00 
 74d:	89 44 24 04          	mov    %eax,0x4(%esp)
 751:	8b 45 08             	mov    0x8(%ebp),%eax
 754:	89 04 24             	mov    %eax,(%esp)
 757:	e8 71 fe ff ff       	call   5cd <printint>
        ap++;
 75c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 760:	e9 b3 00 00 00       	jmp    818 <printf+0x193>
      } else if(c == 's'){
 765:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 769:	75 45                	jne    7b0 <printf+0x12b>
        s = (char*)*ap;
 76b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 76e:	8b 00                	mov    (%eax),%eax
 770:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 773:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 777:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 77b:	75 09                	jne    786 <printf+0x101>
          s = "(null)";
 77d:	c7 45 f4 a8 0b 00 00 	movl   $0xba8,-0xc(%ebp)
        while(*s != 0){
 784:	eb 1e                	jmp    7a4 <printf+0x11f>
 786:	eb 1c                	jmp    7a4 <printf+0x11f>
          putc(fd, *s);
 788:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78b:	0f b6 00             	movzbl (%eax),%eax
 78e:	0f be c0             	movsbl %al,%eax
 791:	89 44 24 04          	mov    %eax,0x4(%esp)
 795:	8b 45 08             	mov    0x8(%ebp),%eax
 798:	89 04 24             	mov    %eax,(%esp)
 79b:	e8 05 fe ff ff       	call   5a5 <putc>
          s++;
 7a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	0f b6 00             	movzbl (%eax),%eax
 7aa:	84 c0                	test   %al,%al
 7ac:	75 da                	jne    788 <printf+0x103>
 7ae:	eb 68                	jmp    818 <printf+0x193>
        }
      } else if(c == 'c'){
 7b0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7b4:	75 1d                	jne    7d3 <printf+0x14e>
        putc(fd, *ap);
 7b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b9:	8b 00                	mov    (%eax),%eax
 7bb:	0f be c0             	movsbl %al,%eax
 7be:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c2:	8b 45 08             	mov    0x8(%ebp),%eax
 7c5:	89 04 24             	mov    %eax,(%esp)
 7c8:	e8 d8 fd ff ff       	call   5a5 <putc>
        ap++;
 7cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d1:	eb 45                	jmp    818 <printf+0x193>
      } else if(c == '%'){
 7d3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7d7:	75 17                	jne    7f0 <printf+0x16b>
        putc(fd, c);
 7d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7dc:	0f be c0             	movsbl %al,%eax
 7df:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e3:	8b 45 08             	mov    0x8(%ebp),%eax
 7e6:	89 04 24             	mov    %eax,(%esp)
 7e9:	e8 b7 fd ff ff       	call   5a5 <putc>
 7ee:	eb 28                	jmp    818 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7f0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7f7:	00 
 7f8:	8b 45 08             	mov    0x8(%ebp),%eax
 7fb:	89 04 24             	mov    %eax,(%esp)
 7fe:	e8 a2 fd ff ff       	call   5a5 <putc>
        putc(fd, c);
 803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 806:	0f be c0             	movsbl %al,%eax
 809:	89 44 24 04          	mov    %eax,0x4(%esp)
 80d:	8b 45 08             	mov    0x8(%ebp),%eax
 810:	89 04 24             	mov    %eax,(%esp)
 813:	e8 8d fd ff ff       	call   5a5 <putc>
      }
      state = 0;
 818:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 81f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 823:	8b 55 0c             	mov    0xc(%ebp),%edx
 826:	8b 45 f0             	mov    -0x10(%ebp),%eax
 829:	01 d0                	add    %edx,%eax
 82b:	0f b6 00             	movzbl (%eax),%eax
 82e:	84 c0                	test   %al,%al
 830:	0f 85 71 fe ff ff    	jne    6a7 <printf+0x22>
    }
  }
}
 836:	c9                   	leave  
 837:	c3                   	ret    

00000838 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 838:	55                   	push   %ebp
 839:	89 e5                	mov    %esp,%ebp
 83b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83e:	8b 45 08             	mov    0x8(%ebp),%eax
 841:	83 e8 08             	sub    $0x8,%eax
 844:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 847:	a1 40 0e 00 00       	mov    0xe40,%eax
 84c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 84f:	eb 24                	jmp    875 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 851:	8b 45 fc             	mov    -0x4(%ebp),%eax
 854:	8b 00                	mov    (%eax),%eax
 856:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 859:	77 12                	ja     86d <free+0x35>
 85b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 861:	77 24                	ja     887 <free+0x4f>
 863:	8b 45 fc             	mov    -0x4(%ebp),%eax
 866:	8b 00                	mov    (%eax),%eax
 868:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 86b:	77 1a                	ja     887 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 870:	8b 00                	mov    (%eax),%eax
 872:	89 45 fc             	mov    %eax,-0x4(%ebp)
 875:	8b 45 f8             	mov    -0x8(%ebp),%eax
 878:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 87b:	76 d4                	jbe    851 <free+0x19>
 87d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 880:	8b 00                	mov    (%eax),%eax
 882:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 885:	76 ca                	jbe    851 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 887:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88a:	8b 40 04             	mov    0x4(%eax),%eax
 88d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 894:	8b 45 f8             	mov    -0x8(%ebp),%eax
 897:	01 c2                	add    %eax,%edx
 899:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89c:	8b 00                	mov    (%eax),%eax
 89e:	39 c2                	cmp    %eax,%edx
 8a0:	75 24                	jne    8c6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a5:	8b 50 04             	mov    0x4(%eax),%edx
 8a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ab:	8b 00                	mov    (%eax),%eax
 8ad:	8b 40 04             	mov    0x4(%eax),%eax
 8b0:	01 c2                	add    %eax,%edx
 8b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bb:	8b 00                	mov    (%eax),%eax
 8bd:	8b 10                	mov    (%eax),%edx
 8bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c2:	89 10                	mov    %edx,(%eax)
 8c4:	eb 0a                	jmp    8d0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c9:	8b 10                	mov    (%eax),%edx
 8cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ce:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d3:	8b 40 04             	mov    0x4(%eax),%eax
 8d6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e0:	01 d0                	add    %edx,%eax
 8e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e5:	75 20                	jne    907 <free+0xcf>
    p->s.size += bp->s.size;
 8e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ea:	8b 50 04             	mov    0x4(%eax),%edx
 8ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f0:	8b 40 04             	mov    0x4(%eax),%eax
 8f3:	01 c2                	add    %eax,%edx
 8f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fe:	8b 10                	mov    (%eax),%edx
 900:	8b 45 fc             	mov    -0x4(%ebp),%eax
 903:	89 10                	mov    %edx,(%eax)
 905:	eb 08                	jmp    90f <free+0xd7>
  } else
    p->s.ptr = bp;
 907:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 90d:	89 10                	mov    %edx,(%eax)
  freep = p;
 90f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 912:	a3 40 0e 00 00       	mov    %eax,0xe40
}
 917:	c9                   	leave  
 918:	c3                   	ret    

00000919 <morecore>:

static Header*
morecore(uint nu)
{
 919:	55                   	push   %ebp
 91a:	89 e5                	mov    %esp,%ebp
 91c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 91f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 926:	77 07                	ja     92f <morecore+0x16>
    nu = 4096;
 928:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 92f:	8b 45 08             	mov    0x8(%ebp),%eax
 932:	c1 e0 03             	shl    $0x3,%eax
 935:	89 04 24             	mov    %eax,(%esp)
 938:	e8 40 fc ff ff       	call   57d <sbrk>
 93d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 940:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 944:	75 07                	jne    94d <morecore+0x34>
    return 0;
 946:	b8 00 00 00 00       	mov    $0x0,%eax
 94b:	eb 22                	jmp    96f <morecore+0x56>
  hp = (Header*)p;
 94d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 950:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 953:	8b 45 f0             	mov    -0x10(%ebp),%eax
 956:	8b 55 08             	mov    0x8(%ebp),%edx
 959:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 95c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95f:	83 c0 08             	add    $0x8,%eax
 962:	89 04 24             	mov    %eax,(%esp)
 965:	e8 ce fe ff ff       	call   838 <free>
  return freep;
 96a:	a1 40 0e 00 00       	mov    0xe40,%eax
}
 96f:	c9                   	leave  
 970:	c3                   	ret    

00000971 <malloc>:

void*
malloc(uint nbytes)
{
 971:	55                   	push   %ebp
 972:	89 e5                	mov    %esp,%ebp
 974:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 977:	8b 45 08             	mov    0x8(%ebp),%eax
 97a:	83 c0 07             	add    $0x7,%eax
 97d:	c1 e8 03             	shr    $0x3,%eax
 980:	83 c0 01             	add    $0x1,%eax
 983:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 986:	a1 40 0e 00 00       	mov    0xe40,%eax
 98b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 98e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 992:	75 23                	jne    9b7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 994:	c7 45 f0 38 0e 00 00 	movl   $0xe38,-0x10(%ebp)
 99b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99e:	a3 40 0e 00 00       	mov    %eax,0xe40
 9a3:	a1 40 0e 00 00       	mov    0xe40,%eax
 9a8:	a3 38 0e 00 00       	mov    %eax,0xe38
    base.s.size = 0;
 9ad:	c7 05 3c 0e 00 00 00 	movl   $0x0,0xe3c
 9b4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ba:	8b 00                	mov    (%eax),%eax
 9bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c2:	8b 40 04             	mov    0x4(%eax),%eax
 9c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9c8:	72 4d                	jb     a17 <malloc+0xa6>
      if(p->s.size == nunits)
 9ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cd:	8b 40 04             	mov    0x4(%eax),%eax
 9d0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9d3:	75 0c                	jne    9e1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d8:	8b 10                	mov    (%eax),%edx
 9da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9dd:	89 10                	mov    %edx,(%eax)
 9df:	eb 26                	jmp    a07 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e4:	8b 40 04             	mov    0x4(%eax),%eax
 9e7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9ea:	89 c2                	mov    %eax,%edx
 9ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ef:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f5:	8b 40 04             	mov    0x4(%eax),%eax
 9f8:	c1 e0 03             	shl    $0x3,%eax
 9fb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a01:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a04:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0a:	a3 40 0e 00 00       	mov    %eax,0xe40
      return (void*)(p + 1);
 a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a12:	83 c0 08             	add    $0x8,%eax
 a15:	eb 38                	jmp    a4f <malloc+0xde>
    }
    if(p == freep)
 a17:	a1 40 0e 00 00       	mov    0xe40,%eax
 a1c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a1f:	75 1b                	jne    a3c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a21:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a24:	89 04 24             	mov    %eax,(%esp)
 a27:	e8 ed fe ff ff       	call   919 <morecore>
 a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a33:	75 07                	jne    a3c <malloc+0xcb>
        return 0;
 a35:	b8 00 00 00 00       	mov    $0x0,%eax
 a3a:	eb 13                	jmp    a4f <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a45:	8b 00                	mov    (%eax),%eax
 a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 a4a:	e9 70 ff ff ff       	jmp    9bf <malloc+0x4e>
}
 a4f:	c9                   	leave  
 a50:	c3                   	ret    
