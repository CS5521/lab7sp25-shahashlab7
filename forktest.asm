
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, const char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  write(fd, s, strlen(s));
   6:	8b 45 0c             	mov    0xc(%ebp),%eax
   9:	89 04 24             	mov    %eax,(%esp)
   c:	e8 ed 02 00 00       	call   2fe <strlen>
  11:	89 44 24 08          	mov    %eax,0x8(%esp)
  15:	8b 45 0c             	mov    0xc(%ebp),%eax
  18:	89 44 24 04          	mov    %eax,0x4(%esp)
  1c:	8b 45 08             	mov    0x8(%ebp),%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 cb 04 00 00       	call   4f2 <write>
}
  27:	c9                   	leave  
  28:	c3                   	ret    

00000029 <forktest>:

void
forktest(void)
{
  29:	55                   	push   %ebp
  2a:	89 e5                	mov    %esp,%ebp
  2c:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
  2f:	c7 44 24 04 84 05 00 	movl   $0x584,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 bd ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  4a:	eb 1f                	jmp    6b <forktest+0x42>
    pid = fork();
  4c:	e8 79 04 00 00       	call   4ca <fork>
  51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  58:	79 02                	jns    5c <forktest+0x33>
      break;
  5a:	eb 18                	jmp    74 <forktest+0x4b>
    if(pid == 0)
  5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  60:	75 05                	jne    67 <forktest+0x3e>
      exit();
  62:	e8 6b 04 00 00       	call   4d2 <exit>
  for(n=0; n<N; n++){
  67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  6b:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  72:	7e d8                	jle    4c <forktest+0x23>
  }

  if(n == N){
  74:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  7b:	75 21                	jne    9e <forktest+0x75>
    printf(1, "fork claimed to work N times!\n", N);
  7d:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
  84:	00 
  85:	c7 44 24 04 90 05 00 	movl   $0x590,0x4(%esp)
  8c:	00 
  8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  94:	e8 67 ff ff ff       	call   0 <printf>
    exit();
  99:	e8 34 04 00 00       	call   4d2 <exit>
  }

  for(; n > 0; n--){
  9e:	eb 26                	jmp    c6 <forktest+0x9d>
    if(wait() < 0){
  a0:	e8 35 04 00 00       	call   4da <wait>
  a5:	85 c0                	test   %eax,%eax
  a7:	79 19                	jns    c2 <forktest+0x99>
      printf(1, "wait stopped early\n");
  a9:	c7 44 24 04 af 05 00 	movl   $0x5af,0x4(%esp)
  b0:	00 
  b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b8:	e8 43 ff ff ff       	call   0 <printf>
      exit();
  bd:	e8 10 04 00 00       	call   4d2 <exit>
  for(; n > 0; n--){
  c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  ca:	7f d4                	jg     a0 <forktest+0x77>
    }
  }

  if(wait() != -1){
  cc:	e8 09 04 00 00       	call   4da <wait>
  d1:	83 f8 ff             	cmp    $0xffffffff,%eax
  d4:	74 19                	je     ef <forktest+0xc6>
    printf(1, "wait got too many\n");
  d6:	c7 44 24 04 c3 05 00 	movl   $0x5c3,0x4(%esp)
  dd:	00 
  de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e5:	e8 16 ff ff ff       	call   0 <printf>
    exit();
  ea:	e8 e3 03 00 00       	call   4d2 <exit>
  }

  printf(1, "fork test OK\n");
  ef:	c7 44 24 04 d6 05 00 	movl   $0x5d6,0x4(%esp)
  f6:	00 
  f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fe:	e8 fd fe ff ff       	call   0 <printf>
}
 103:	c9                   	leave  
 104:	c3                   	ret    

00000105 <main>:

int
main(void)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
 10b:	e8 19 ff ff ff       	call   29 <forktest>
  exit();
 110:	e8 bd 03 00 00       	call   4d2 <exit>

00000115 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 115:	55                   	push   %ebp
 116:	89 e5                	mov    %esp,%ebp
 118:	57                   	push   %edi
 119:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 11a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11d:	8b 55 10             	mov    0x10(%ebp),%edx
 120:	8b 45 0c             	mov    0xc(%ebp),%eax
 123:	89 cb                	mov    %ecx,%ebx
 125:	89 df                	mov    %ebx,%edi
 127:	89 d1                	mov    %edx,%ecx
 129:	fc                   	cld    
 12a:	f3 aa                	rep stos %al,%es:(%edi)
 12c:	89 ca                	mov    %ecx,%edx
 12e:	89 fb                	mov    %edi,%ebx
 130:	89 5d 08             	mov    %ebx,0x8(%ebp)
 133:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 136:	5b                   	pop    %ebx
 137:	5f                   	pop    %edi
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	57                   	push   %edi
 13e:	56                   	push   %esi
 13f:	53                   	push   %ebx
 140:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
 146:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
 14c:	89 04 24             	mov    %eax,(%esp)
 14f:	e8 1e 04 00 00       	call   572 <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 154:	c7 44 24 04 e4 05 00 	movl   $0x5e4,0x4(%esp)
 15b:	00 
 15c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 163:	e8 98 fe ff ff       	call   0 <printf>
    for (i = 0; i < NPROC; i++) {
 168:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 16f:	e9 06 01 00 00       	jmp    27a <ps+0x140>
        if (ptable[i].inuse) {
 174:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 177:	89 d0                	mov    %edx,%eax
 179:	c1 e0 03             	shl    $0x3,%eax
 17c:	01 d0                	add    %edx,%eax
 17e:	c1 e0 02             	shl    $0x2,%eax
 181:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 184:	01 d8                	add    %ebx,%eax
 186:	2d 08 09 00 00       	sub    $0x908,%eax
 18b:	8b 00                	mov    (%eax),%eax
 18d:	85 c0                	test   %eax,%eax
 18f:	0f 84 e1 00 00 00    	je     276 <ps+0x13c>
            char stat = '?';
 195:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
 199:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 19c:	89 d0                	mov    %edx,%eax
 19e:	c1 e0 03             	shl    $0x3,%eax
 1a1:	01 d0                	add    %edx,%eax
 1a3:	c1 e0 02             	shl    $0x2,%eax
 1a6:	8d 75 e8             	lea    -0x18(%ebp),%esi
 1a9:	01 f0                	add    %esi,%eax
 1ab:	2d e8 08 00 00       	sub    $0x8e8,%eax
 1b0:	0f b6 00             	movzbl (%eax),%eax
 1b3:	0f be c0             	movsbl %al,%eax
 1b6:	83 f8 05             	cmp    $0x5,%eax
 1b9:	77 27                	ja     1e2 <ps+0xa8>
 1bb:	8b 04 85 10 06 00 00 	mov    0x610(,%eax,4),%eax
 1c2:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
 1c4:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
 1c8:	eb 1c                	jmp    1e6 <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
 1ca:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 1ce:	eb 16                	jmp    1e6 <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
 1d0:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
 1d4:	eb 10                	jmp    1e6 <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
 1d6:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
 1da:	eb 0a                	jmp    1e6 <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
 1dc:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
 1e0:	eb 04                	jmp    1e6 <ps+0xac>
                default: stat = '?';
 1e2:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
 1e6:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
 1ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1ef:	89 d0                	mov    %edx,%eax
 1f1:	c1 e0 03             	shl    $0x3,%eax
 1f4:	01 d0                	add    %edx,%eax
 1f6:	c1 e0 02             	shl    $0x2,%eax
 1f9:	83 c0 10             	add    $0x10,%eax
 1fc:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 1ff:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 203:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 206:	89 d0                	mov    %edx,%eax
 208:	c1 e0 03             	shl    $0x3,%eax
 20b:	01 d0                	add    %edx,%eax
 20d:	c1 e0 02             	shl    $0x2,%eax
 210:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 213:	01 c8                	add    %ecx,%eax
 215:	2d fc 08 00 00       	sub    $0x8fc,%eax
 21a:	8b 18                	mov    (%eax),%ebx
 21c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 21f:	89 d0                	mov    %edx,%eax
 221:	c1 e0 03             	shl    $0x3,%eax
 224:	01 d0                	add    %edx,%eax
 226:	c1 e0 02             	shl    $0x2,%eax
 229:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 22c:	01 c8                	add    %ecx,%eax
 22e:	2d 04 09 00 00       	sub    $0x904,%eax
 233:	8b 08                	mov    (%eax),%ecx
 235:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 238:	89 d0                	mov    %edx,%eax
 23a:	c1 e0 03             	shl    $0x3,%eax
 23d:	01 d0                	add    %edx,%eax
 23f:	c1 e0 02             	shl    $0x2,%eax
 242:	8d 55 e8             	lea    -0x18(%ebp),%edx
 245:	01 d0                	add    %edx,%eax
 247:	2d 00 09 00 00       	sub    $0x900,%eax
 24c:	8b 00                	mov    (%eax),%eax
 24e:	89 7c 24 18          	mov    %edi,0x18(%esp)
 252:	89 74 24 14          	mov    %esi,0x14(%esp)
 256:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 25a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 25e:	89 44 24 08          	mov    %eax,0x8(%esp)
 262:	c7 44 24 04 fd 05 00 	movl   $0x5fd,0x4(%esp)
 269:	00 
 26a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 271:	e8 8a fd ff ff       	call   0 <printf>
    for (i = 0; i < NPROC; i++) {
 276:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 27a:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 27e:	0f 8e f0 fe ff ff    	jle    174 <ps+0x3a>
        }
    }
}
 284:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 28a:	5b                   	pop    %ebx
 28b:	5e                   	pop    %esi
 28c:	5f                   	pop    %edi
 28d:	5d                   	pop    %ebp
 28e:	c3                   	ret    

0000028f <strcpy>:


char*
strcpy(char *s, const char *t)
{
 28f:	55                   	push   %ebp
 290:	89 e5                	mov    %esp,%ebp
 292:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 29b:	90                   	nop
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	8d 50 01             	lea    0x1(%eax),%edx
 2a2:	89 55 08             	mov    %edx,0x8(%ebp)
 2a5:	8b 55 0c             	mov    0xc(%ebp),%edx
 2a8:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2ae:	0f b6 12             	movzbl (%edx),%edx
 2b1:	88 10                	mov    %dl,(%eax)
 2b3:	0f b6 00             	movzbl (%eax),%eax
 2b6:	84 c0                	test   %al,%al
 2b8:	75 e2                	jne    29c <strcpy+0xd>
    ;
  return os;
 2ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2bd:	c9                   	leave  
 2be:	c3                   	ret    

000002bf <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2bf:	55                   	push   %ebp
 2c0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2c2:	eb 08                	jmp    2cc <strcmp+0xd>
    p++, q++;
 2c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	0f b6 00             	movzbl (%eax),%eax
 2d2:	84 c0                	test   %al,%al
 2d4:	74 10                	je     2e6 <strcmp+0x27>
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	0f b6 10             	movzbl (%eax),%edx
 2dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2df:	0f b6 00             	movzbl (%eax),%eax
 2e2:	38 c2                	cmp    %al,%dl
 2e4:	74 de                	je     2c4 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	0f b6 00             	movzbl (%eax),%eax
 2ec:	0f b6 d0             	movzbl %al,%edx
 2ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f2:	0f b6 00             	movzbl (%eax),%eax
 2f5:	0f b6 c0             	movzbl %al,%eax
 2f8:	29 c2                	sub    %eax,%edx
 2fa:	89 d0                	mov    %edx,%eax
}
 2fc:	5d                   	pop    %ebp
 2fd:	c3                   	ret    

000002fe <strlen>:

uint
strlen(const char *s)
{
 2fe:	55                   	push   %ebp
 2ff:	89 e5                	mov    %esp,%ebp
 301:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 304:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 30b:	eb 04                	jmp    311 <strlen+0x13>
 30d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 311:	8b 55 fc             	mov    -0x4(%ebp),%edx
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	01 d0                	add    %edx,%eax
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	84 c0                	test   %al,%al
 31e:	75 ed                	jne    30d <strlen+0xf>
    ;
  return n;
 320:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 323:	c9                   	leave  
 324:	c3                   	ret    

00000325 <memset>:

void*
memset(void *dst, int c, uint n)
{
 325:	55                   	push   %ebp
 326:	89 e5                	mov    %esp,%ebp
 328:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 32b:	8b 45 10             	mov    0x10(%ebp),%eax
 32e:	89 44 24 08          	mov    %eax,0x8(%esp)
 332:	8b 45 0c             	mov    0xc(%ebp),%eax
 335:	89 44 24 04          	mov    %eax,0x4(%esp)
 339:	8b 45 08             	mov    0x8(%ebp),%eax
 33c:	89 04 24             	mov    %eax,(%esp)
 33f:	e8 d1 fd ff ff       	call   115 <stosb>
  return dst;
 344:	8b 45 08             	mov    0x8(%ebp),%eax
}
 347:	c9                   	leave  
 348:	c3                   	ret    

00000349 <strchr>:

char*
strchr(const char *s, char c)
{
 349:	55                   	push   %ebp
 34a:	89 e5                	mov    %esp,%ebp
 34c:	83 ec 04             	sub    $0x4,%esp
 34f:	8b 45 0c             	mov    0xc(%ebp),%eax
 352:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 355:	eb 14                	jmp    36b <strchr+0x22>
    if(*s == c)
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	0f b6 00             	movzbl (%eax),%eax
 35d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 360:	75 05                	jne    367 <strchr+0x1e>
      return (char*)s;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	eb 13                	jmp    37a <strchr+0x31>
  for(; *s; s++)
 367:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
 36e:	0f b6 00             	movzbl (%eax),%eax
 371:	84 c0                	test   %al,%al
 373:	75 e2                	jne    357 <strchr+0xe>
  return 0;
 375:	b8 00 00 00 00       	mov    $0x0,%eax
}
 37a:	c9                   	leave  
 37b:	c3                   	ret    

0000037c <gets>:

char*
gets(char *buf, int max)
{
 37c:	55                   	push   %ebp
 37d:	89 e5                	mov    %esp,%ebp
 37f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 389:	eb 4c                	jmp    3d7 <gets+0x5b>
    cc = read(0, &c, 1);
 38b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 392:	00 
 393:	8d 45 ef             	lea    -0x11(%ebp),%eax
 396:	89 44 24 04          	mov    %eax,0x4(%esp)
 39a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3a1:	e8 44 01 00 00       	call   4ea <read>
 3a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3ad:	7f 02                	jg     3b1 <gets+0x35>
      break;
 3af:	eb 31                	jmp    3e2 <gets+0x66>
    buf[i++] = c;
 3b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b4:	8d 50 01             	lea    0x1(%eax),%edx
 3b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3ba:	89 c2                	mov    %eax,%edx
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
 3bf:	01 c2                	add    %eax,%edx
 3c1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3c5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3c7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3cb:	3c 0a                	cmp    $0xa,%al
 3cd:	74 13                	je     3e2 <gets+0x66>
 3cf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3d3:	3c 0d                	cmp    $0xd,%al
 3d5:	74 0b                	je     3e2 <gets+0x66>
  for(i=0; i+1 < max; ){
 3d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3da:	83 c0 01             	add    $0x1,%eax
 3dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3e0:	7c a9                	jl     38b <gets+0xf>
      break;
  }
  buf[i] = '\0';
 3e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3e5:	8b 45 08             	mov    0x8(%ebp),%eax
 3e8:	01 d0                	add    %edx,%eax
 3ea:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3ff:	00 
 400:	8b 45 08             	mov    0x8(%ebp),%eax
 403:	89 04 24             	mov    %eax,(%esp)
 406:	e8 07 01 00 00       	call   512 <open>
 40b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 40e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 412:	79 07                	jns    41b <stat+0x29>
    return -1;
 414:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 419:	eb 23                	jmp    43e <stat+0x4c>
  r = fstat(fd, st);
 41b:	8b 45 0c             	mov    0xc(%ebp),%eax
 41e:	89 44 24 04          	mov    %eax,0x4(%esp)
 422:	8b 45 f4             	mov    -0xc(%ebp),%eax
 425:	89 04 24             	mov    %eax,(%esp)
 428:	e8 fd 00 00 00       	call   52a <fstat>
 42d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 430:	8b 45 f4             	mov    -0xc(%ebp),%eax
 433:	89 04 24             	mov    %eax,(%esp)
 436:	e8 bf 00 00 00       	call   4fa <close>
  return r;
 43b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 43e:	c9                   	leave  
 43f:	c3                   	ret    

00000440 <atoi>:

int
atoi(const char *s)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 446:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 44d:	eb 25                	jmp    474 <atoi+0x34>
    n = n*10 + *s++ - '0';
 44f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 452:	89 d0                	mov    %edx,%eax
 454:	c1 e0 02             	shl    $0x2,%eax
 457:	01 d0                	add    %edx,%eax
 459:	01 c0                	add    %eax,%eax
 45b:	89 c1                	mov    %eax,%ecx
 45d:	8b 45 08             	mov    0x8(%ebp),%eax
 460:	8d 50 01             	lea    0x1(%eax),%edx
 463:	89 55 08             	mov    %edx,0x8(%ebp)
 466:	0f b6 00             	movzbl (%eax),%eax
 469:	0f be c0             	movsbl %al,%eax
 46c:	01 c8                	add    %ecx,%eax
 46e:	83 e8 30             	sub    $0x30,%eax
 471:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 474:	8b 45 08             	mov    0x8(%ebp),%eax
 477:	0f b6 00             	movzbl (%eax),%eax
 47a:	3c 2f                	cmp    $0x2f,%al
 47c:	7e 0a                	jle    488 <atoi+0x48>
 47e:	8b 45 08             	mov    0x8(%ebp),%eax
 481:	0f b6 00             	movzbl (%eax),%eax
 484:	3c 39                	cmp    $0x39,%al
 486:	7e c7                	jle    44f <atoi+0xf>
  return n;
 488:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 48b:	c9                   	leave  
 48c:	c3                   	ret    

0000048d <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 48d:	55                   	push   %ebp
 48e:	89 e5                	mov    %esp,%ebp
 490:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 493:	8b 45 08             	mov    0x8(%ebp),%eax
 496:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 499:	8b 45 0c             	mov    0xc(%ebp),%eax
 49c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 49f:	eb 17                	jmp    4b8 <memmove+0x2b>
    *dst++ = *src++;
 4a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4a4:	8d 50 01             	lea    0x1(%eax),%edx
 4a7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4aa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4ad:	8d 4a 01             	lea    0x1(%edx),%ecx
 4b0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4b3:	0f b6 12             	movzbl (%edx),%edx
 4b6:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 4b8:	8b 45 10             	mov    0x10(%ebp),%eax
 4bb:	8d 50 ff             	lea    -0x1(%eax),%edx
 4be:	89 55 10             	mov    %edx,0x10(%ebp)
 4c1:	85 c0                	test   %eax,%eax
 4c3:	7f dc                	jg     4a1 <memmove+0x14>
  return vdst;
 4c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4c8:	c9                   	leave  
 4c9:	c3                   	ret    

000004ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ca:	b8 01 00 00 00       	mov    $0x1,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <exit>:
SYSCALL(exit)
 4d2:	b8 02 00 00 00       	mov    $0x2,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <wait>:
SYSCALL(wait)
 4da:	b8 03 00 00 00       	mov    $0x3,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <pipe>:
SYSCALL(pipe)
 4e2:	b8 04 00 00 00       	mov    $0x4,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <read>:
SYSCALL(read)
 4ea:	b8 05 00 00 00       	mov    $0x5,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <write>:
SYSCALL(write)
 4f2:	b8 10 00 00 00       	mov    $0x10,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <close>:
SYSCALL(close)
 4fa:	b8 15 00 00 00       	mov    $0x15,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <kill>:
SYSCALL(kill)
 502:	b8 06 00 00 00       	mov    $0x6,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <exec>:
SYSCALL(exec)
 50a:	b8 07 00 00 00       	mov    $0x7,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <open>:
SYSCALL(open)
 512:	b8 0f 00 00 00       	mov    $0xf,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <mknod>:
SYSCALL(mknod)
 51a:	b8 11 00 00 00       	mov    $0x11,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <unlink>:
SYSCALL(unlink)
 522:	b8 12 00 00 00       	mov    $0x12,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <fstat>:
SYSCALL(fstat)
 52a:	b8 08 00 00 00       	mov    $0x8,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <link>:
SYSCALL(link)
 532:	b8 13 00 00 00       	mov    $0x13,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <mkdir>:
SYSCALL(mkdir)
 53a:	b8 14 00 00 00       	mov    $0x14,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <chdir>:
SYSCALL(chdir)
 542:	b8 09 00 00 00       	mov    $0x9,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <dup>:
SYSCALL(dup)
 54a:	b8 0a 00 00 00       	mov    $0xa,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <getpid>:
SYSCALL(getpid)
 552:	b8 0b 00 00 00       	mov    $0xb,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <sbrk>:
SYSCALL(sbrk)
 55a:	b8 0c 00 00 00       	mov    $0xc,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <sleep>:
SYSCALL(sleep)
 562:	b8 0d 00 00 00       	mov    $0xd,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <uptime>:
SYSCALL(uptime)
 56a:	b8 0e 00 00 00       	mov    $0xe,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <getpinfo>:
SYSCALL(getpinfo)
 572:	b8 16 00 00 00       	mov    $0x16,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <settickets>:
SYSCALL(settickets)
 57a:	b8 17 00 00 00       	mov    $0x17,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    
