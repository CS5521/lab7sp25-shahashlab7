
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 cc 0a 00 	movl   $0xacc,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 c0 06 00 00       	call   700 <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 67 03 00 00       	call   3c3 <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 13                	jmp    7c <main+0x7c>
    if(fork() > 0)
  69:	e8 fa 04 00 00       	call   568 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7e 02                	jle    74 <main+0x74>
      break;
  72:	eb 12                	jmp    86 <main+0x86>
  for(i = 0; i < 4; i++)
  74:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  7b:	01 
  7c:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  83:	03 
  84:	7e e3                	jle    69 <main+0x69>

  printf(1, "write %d\n", i);
  86:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  91:	c7 44 24 04 df 0a 00 	movl   $0xadf,0x4(%esp)
  98:	00 
  99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a0:	e8 5b 06 00 00       	call   700 <printf>

  path[8] += i;
  a5:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ac:	00 
  ad:	89 c2                	mov    %eax,%edx
  af:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b6:	01 d0                	add    %edx,%eax
  b8:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  bf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c6:	00 
  c7:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  ce:	89 04 24             	mov    %eax,(%esp)
  d1:	e8 da 04 00 00       	call   5b0 <open>
  d6:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  dd:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e4:	00 00 00 00 
  e8:	eb 27                	jmp    111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ea:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f1:	00 
  f2:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  fa:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 101:	89 04 24             	mov    %eax,(%esp)
 104:	e8 87 04 00 00       	call   590 <write>
  for(i = 0; i < 20; i++)
 109:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 110:	01 
 111:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 118:	13 
 119:	7e cf                	jle    ea <main+0xea>
  close(fd);
 11b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 122:	89 04 24             	mov    %eax,(%esp)
 125:	e8 6e 04 00 00       	call   598 <close>

  printf(1, "read\n");
 12a:	c7 44 24 04 e9 0a 00 	movl   $0xae9,0x4(%esp)
 131:	00 
 132:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 139:	e8 c2 05 00 00       	call   700 <printf>

  fd = open(path, O_RDONLY);
 13e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 145:	00 
 146:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14d:	89 04 24             	mov    %eax,(%esp)
 150:	e8 5b 04 00 00       	call   5b0 <open>
 155:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 163:	00 00 00 00 
 167:	eb 27                	jmp    190 <main+0x190>
    read(fd, data, sizeof(data));
 169:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 170:	00 
 171:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 175:	89 44 24 04          	mov    %eax,0x4(%esp)
 179:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 180:	89 04 24             	mov    %eax,(%esp)
 183:	e8 00 04 00 00       	call   588 <read>
  for (i = 0; i < 20; i++)
 188:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 18f:	01 
 190:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 197:	13 
 198:	7e cf                	jle    169 <main+0x169>
  close(fd);
 19a:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a1:	89 04 24             	mov    %eax,(%esp)
 1a4:	e8 ef 03 00 00       	call   598 <close>

  wait();
 1a9:	e8 ca 03 00 00       	call   578 <wait>

  exit();
 1ae:	e8 bd 03 00 00       	call   570 <exit>

000001b3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	57                   	push   %edi
 1b7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bb:	8b 55 10             	mov    0x10(%ebp),%edx
 1be:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c1:	89 cb                	mov    %ecx,%ebx
 1c3:	89 df                	mov    %ebx,%edi
 1c5:	89 d1                	mov    %edx,%ecx
 1c7:	fc                   	cld    
 1c8:	f3 aa                	rep stos %al,%es:(%edi)
 1ca:	89 ca                	mov    %ecx,%edx
 1cc:	89 fb                	mov    %edi,%ebx
 1ce:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d4:	5b                   	pop    %ebx
 1d5:	5f                   	pop    %edi
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    

000001d8 <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	57                   	push   %edi
 1dc:	56                   	push   %esi
 1dd:	53                   	push   %ebx
 1de:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
 1e4:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
 1ea:	89 04 24             	mov    %eax,(%esp)
 1ed:	e8 1e 04 00 00       	call   610 <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 1f2:	c7 44 24 04 f0 0a 00 	movl   $0xaf0,0x4(%esp)
 1f9:	00 
 1fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 201:	e8 fa 04 00 00       	call   700 <printf>
    for (i = 0; i < NPROC; i++) {
 206:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 20d:	e9 06 01 00 00       	jmp    318 <ps+0x140>
        if (ptable[i].inuse) {
 212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 215:	89 d0                	mov    %edx,%eax
 217:	c1 e0 03             	shl    $0x3,%eax
 21a:	01 d0                	add    %edx,%eax
 21c:	c1 e0 02             	shl    $0x2,%eax
 21f:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 222:	01 d8                	add    %ebx,%eax
 224:	2d 08 09 00 00       	sub    $0x908,%eax
 229:	8b 00                	mov    (%eax),%eax
 22b:	85 c0                	test   %eax,%eax
 22d:	0f 84 e1 00 00 00    	je     314 <ps+0x13c>
            char stat = '?';
 233:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
 237:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 23a:	89 d0                	mov    %edx,%eax
 23c:	c1 e0 03             	shl    $0x3,%eax
 23f:	01 d0                	add    %edx,%eax
 241:	c1 e0 02             	shl    $0x2,%eax
 244:	8d 75 e8             	lea    -0x18(%ebp),%esi
 247:	01 f0                	add    %esi,%eax
 249:	2d e8 08 00 00       	sub    $0x8e8,%eax
 24e:	0f b6 00             	movzbl (%eax),%eax
 251:	0f be c0             	movsbl %al,%eax
 254:	83 f8 05             	cmp    $0x5,%eax
 257:	77 27                	ja     280 <ps+0xa8>
 259:	8b 04 85 1c 0b 00 00 	mov    0xb1c(,%eax,4),%eax
 260:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
 262:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
 266:	eb 1c                	jmp    284 <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
 268:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 26c:	eb 16                	jmp    284 <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
 26e:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
 272:	eb 10                	jmp    284 <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
 274:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
 278:	eb 0a                	jmp    284 <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
 27a:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
 27e:	eb 04                	jmp    284 <ps+0xac>
                default: stat = '?';
 280:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
 284:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
 28a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 28d:	89 d0                	mov    %edx,%eax
 28f:	c1 e0 03             	shl    $0x3,%eax
 292:	01 d0                	add    %edx,%eax
 294:	c1 e0 02             	shl    $0x2,%eax
 297:	83 c0 10             	add    $0x10,%eax
 29a:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 29d:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 2a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2a4:	89 d0                	mov    %edx,%eax
 2a6:	c1 e0 03             	shl    $0x3,%eax
 2a9:	01 d0                	add    %edx,%eax
 2ab:	c1 e0 02             	shl    $0x2,%eax
 2ae:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 2b1:	01 c8                	add    %ecx,%eax
 2b3:	2d fc 08 00 00       	sub    $0x8fc,%eax
 2b8:	8b 18                	mov    (%eax),%ebx
 2ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2bd:	89 d0                	mov    %edx,%eax
 2bf:	c1 e0 03             	shl    $0x3,%eax
 2c2:	01 d0                	add    %edx,%eax
 2c4:	c1 e0 02             	shl    $0x2,%eax
 2c7:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 2ca:	01 c8                	add    %ecx,%eax
 2cc:	2d 04 09 00 00       	sub    $0x904,%eax
 2d1:	8b 08                	mov    (%eax),%ecx
 2d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2d6:	89 d0                	mov    %edx,%eax
 2d8:	c1 e0 03             	shl    $0x3,%eax
 2db:	01 d0                	add    %edx,%eax
 2dd:	c1 e0 02             	shl    $0x2,%eax
 2e0:	8d 55 e8             	lea    -0x18(%ebp),%edx
 2e3:	01 d0                	add    %edx,%eax
 2e5:	2d 00 09 00 00       	sub    $0x900,%eax
 2ea:	8b 00                	mov    (%eax),%eax
 2ec:	89 7c 24 18          	mov    %edi,0x18(%esp)
 2f0:	89 74 24 14          	mov    %esi,0x14(%esp)
 2f4:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 2f8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 2fc:	89 44 24 08          	mov    %eax,0x8(%esp)
 300:	c7 44 24 04 09 0b 00 	movl   $0xb09,0x4(%esp)
 307:	00 
 308:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 30f:	e8 ec 03 00 00       	call   700 <printf>
    for (i = 0; i < NPROC; i++) {
 314:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 318:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 31c:	0f 8e f0 fe ff ff    	jle    212 <ps+0x3a>
        }
    }
}
 322:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 328:	5b                   	pop    %ebx
 329:	5e                   	pop    %esi
 32a:	5f                   	pop    %edi
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    

0000032d <strcpy>:


char*
strcpy(char *s, const char *t)
{
 32d:	55                   	push   %ebp
 32e:	89 e5                	mov    %esp,%ebp
 330:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 339:	90                   	nop
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	8d 50 01             	lea    0x1(%eax),%edx
 340:	89 55 08             	mov    %edx,0x8(%ebp)
 343:	8b 55 0c             	mov    0xc(%ebp),%edx
 346:	8d 4a 01             	lea    0x1(%edx),%ecx
 349:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 34c:	0f b6 12             	movzbl (%edx),%edx
 34f:	88 10                	mov    %dl,(%eax)
 351:	0f b6 00             	movzbl (%eax),%eax
 354:	84 c0                	test   %al,%al
 356:	75 e2                	jne    33a <strcpy+0xd>
    ;
  return os;
 358:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35b:	c9                   	leave  
 35c:	c3                   	ret    

0000035d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 35d:	55                   	push   %ebp
 35e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 360:	eb 08                	jmp    36a <strcmp+0xd>
    p++, q++;
 362:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 366:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	0f b6 00             	movzbl (%eax),%eax
 370:	84 c0                	test   %al,%al
 372:	74 10                	je     384 <strcmp+0x27>
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	0f b6 10             	movzbl (%eax),%edx
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	0f b6 00             	movzbl (%eax),%eax
 380:	38 c2                	cmp    %al,%dl
 382:	74 de                	je     362 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 384:	8b 45 08             	mov    0x8(%ebp),%eax
 387:	0f b6 00             	movzbl (%eax),%eax
 38a:	0f b6 d0             	movzbl %al,%edx
 38d:	8b 45 0c             	mov    0xc(%ebp),%eax
 390:	0f b6 00             	movzbl (%eax),%eax
 393:	0f b6 c0             	movzbl %al,%eax
 396:	29 c2                	sub    %eax,%edx
 398:	89 d0                	mov    %edx,%eax
}
 39a:	5d                   	pop    %ebp
 39b:	c3                   	ret    

0000039c <strlen>:

uint
strlen(const char *s)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3a9:	eb 04                	jmp    3af <strlen+0x13>
 3ab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3af:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3b2:	8b 45 08             	mov    0x8(%ebp),%eax
 3b5:	01 d0                	add    %edx,%eax
 3b7:	0f b6 00             	movzbl (%eax),%eax
 3ba:	84 c0                	test   %al,%al
 3bc:	75 ed                	jne    3ab <strlen+0xf>
    ;
  return n;
 3be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3c1:	c9                   	leave  
 3c2:	c3                   	ret    

000003c3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3c3:	55                   	push   %ebp
 3c4:	89 e5                	mov    %esp,%ebp
 3c6:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 3c9:	8b 45 10             	mov    0x10(%ebp),%eax
 3cc:	89 44 24 08          	mov    %eax,0x8(%esp)
 3d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	89 04 24             	mov    %eax,(%esp)
 3dd:	e8 d1 fd ff ff       	call   1b3 <stosb>
  return dst;
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3e5:	c9                   	leave  
 3e6:	c3                   	ret    

000003e7 <strchr>:

char*
strchr(const char *s, char c)
{
 3e7:	55                   	push   %ebp
 3e8:	89 e5                	mov    %esp,%ebp
 3ea:	83 ec 04             	sub    $0x4,%esp
 3ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3f3:	eb 14                	jmp    409 <strchr+0x22>
    if(*s == c)
 3f5:	8b 45 08             	mov    0x8(%ebp),%eax
 3f8:	0f b6 00             	movzbl (%eax),%eax
 3fb:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3fe:	75 05                	jne    405 <strchr+0x1e>
      return (char*)s;
 400:	8b 45 08             	mov    0x8(%ebp),%eax
 403:	eb 13                	jmp    418 <strchr+0x31>
  for(; *s; s++)
 405:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 409:	8b 45 08             	mov    0x8(%ebp),%eax
 40c:	0f b6 00             	movzbl (%eax),%eax
 40f:	84 c0                	test   %al,%al
 411:	75 e2                	jne    3f5 <strchr+0xe>
  return 0;
 413:	b8 00 00 00 00       	mov    $0x0,%eax
}
 418:	c9                   	leave  
 419:	c3                   	ret    

0000041a <gets>:

char*
gets(char *buf, int max)
{
 41a:	55                   	push   %ebp
 41b:	89 e5                	mov    %esp,%ebp
 41d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 420:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 427:	eb 4c                	jmp    475 <gets+0x5b>
    cc = read(0, &c, 1);
 429:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 430:	00 
 431:	8d 45 ef             	lea    -0x11(%ebp),%eax
 434:	89 44 24 04          	mov    %eax,0x4(%esp)
 438:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 43f:	e8 44 01 00 00       	call   588 <read>
 444:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 447:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 44b:	7f 02                	jg     44f <gets+0x35>
      break;
 44d:	eb 31                	jmp    480 <gets+0x66>
    buf[i++] = c;
 44f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 452:	8d 50 01             	lea    0x1(%eax),%edx
 455:	89 55 f4             	mov    %edx,-0xc(%ebp)
 458:	89 c2                	mov    %eax,%edx
 45a:	8b 45 08             	mov    0x8(%ebp),%eax
 45d:	01 c2                	add    %eax,%edx
 45f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 463:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 465:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 469:	3c 0a                	cmp    $0xa,%al
 46b:	74 13                	je     480 <gets+0x66>
 46d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 471:	3c 0d                	cmp    $0xd,%al
 473:	74 0b                	je     480 <gets+0x66>
  for(i=0; i+1 < max; ){
 475:	8b 45 f4             	mov    -0xc(%ebp),%eax
 478:	83 c0 01             	add    $0x1,%eax
 47b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 47e:	7c a9                	jl     429 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 480:	8b 55 f4             	mov    -0xc(%ebp),%edx
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	01 d0                	add    %edx,%eax
 488:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 48e:	c9                   	leave  
 48f:	c3                   	ret    

00000490 <stat>:

int
stat(const char *n, struct stat *st)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 496:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 49d:	00 
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
 4a1:	89 04 24             	mov    %eax,(%esp)
 4a4:	e8 07 01 00 00       	call   5b0 <open>
 4a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b0:	79 07                	jns    4b9 <stat+0x29>
    return -1;
 4b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4b7:	eb 23                	jmp    4dc <stat+0x4c>
  r = fstat(fd, st);
 4b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c3:	89 04 24             	mov    %eax,(%esp)
 4c6:	e8 fd 00 00 00       	call   5c8 <fstat>
 4cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d1:	89 04 24             	mov    %eax,(%esp)
 4d4:	e8 bf 00 00 00       	call   598 <close>
  return r;
 4d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4dc:	c9                   	leave  
 4dd:	c3                   	ret    

000004de <atoi>:

int
atoi(const char *s)
{
 4de:	55                   	push   %ebp
 4df:	89 e5                	mov    %esp,%ebp
 4e1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4eb:	eb 25                	jmp    512 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4f0:	89 d0                	mov    %edx,%eax
 4f2:	c1 e0 02             	shl    $0x2,%eax
 4f5:	01 d0                	add    %edx,%eax
 4f7:	01 c0                	add    %eax,%eax
 4f9:	89 c1                	mov    %eax,%ecx
 4fb:	8b 45 08             	mov    0x8(%ebp),%eax
 4fe:	8d 50 01             	lea    0x1(%eax),%edx
 501:	89 55 08             	mov    %edx,0x8(%ebp)
 504:	0f b6 00             	movzbl (%eax),%eax
 507:	0f be c0             	movsbl %al,%eax
 50a:	01 c8                	add    %ecx,%eax
 50c:	83 e8 30             	sub    $0x30,%eax
 50f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 512:	8b 45 08             	mov    0x8(%ebp),%eax
 515:	0f b6 00             	movzbl (%eax),%eax
 518:	3c 2f                	cmp    $0x2f,%al
 51a:	7e 0a                	jle    526 <atoi+0x48>
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
 51f:	0f b6 00             	movzbl (%eax),%eax
 522:	3c 39                	cmp    $0x39,%al
 524:	7e c7                	jle    4ed <atoi+0xf>
  return n;
 526:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 529:	c9                   	leave  
 52a:	c3                   	ret    

0000052b <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 52b:	55                   	push   %ebp
 52c:	89 e5                	mov    %esp,%ebp
 52e:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 537:	8b 45 0c             	mov    0xc(%ebp),%eax
 53a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 53d:	eb 17                	jmp    556 <memmove+0x2b>
    *dst++ = *src++;
 53f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 542:	8d 50 01             	lea    0x1(%eax),%edx
 545:	89 55 fc             	mov    %edx,-0x4(%ebp)
 548:	8b 55 f8             	mov    -0x8(%ebp),%edx
 54b:	8d 4a 01             	lea    0x1(%edx),%ecx
 54e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 551:	0f b6 12             	movzbl (%edx),%edx
 554:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 556:	8b 45 10             	mov    0x10(%ebp),%eax
 559:	8d 50 ff             	lea    -0x1(%eax),%edx
 55c:	89 55 10             	mov    %edx,0x10(%ebp)
 55f:	85 c0                	test   %eax,%eax
 561:	7f dc                	jg     53f <memmove+0x14>
  return vdst;
 563:	8b 45 08             	mov    0x8(%ebp),%eax
}
 566:	c9                   	leave  
 567:	c3                   	ret    

00000568 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 568:	b8 01 00 00 00       	mov    $0x1,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <exit>:
SYSCALL(exit)
 570:	b8 02 00 00 00       	mov    $0x2,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <wait>:
SYSCALL(wait)
 578:	b8 03 00 00 00       	mov    $0x3,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <pipe>:
SYSCALL(pipe)
 580:	b8 04 00 00 00       	mov    $0x4,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <read>:
SYSCALL(read)
 588:	b8 05 00 00 00       	mov    $0x5,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <write>:
SYSCALL(write)
 590:	b8 10 00 00 00       	mov    $0x10,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <close>:
SYSCALL(close)
 598:	b8 15 00 00 00       	mov    $0x15,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <kill>:
SYSCALL(kill)
 5a0:	b8 06 00 00 00       	mov    $0x6,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <exec>:
SYSCALL(exec)
 5a8:	b8 07 00 00 00       	mov    $0x7,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <open>:
SYSCALL(open)
 5b0:	b8 0f 00 00 00       	mov    $0xf,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <mknod>:
SYSCALL(mknod)
 5b8:	b8 11 00 00 00       	mov    $0x11,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <unlink>:
SYSCALL(unlink)
 5c0:	b8 12 00 00 00       	mov    $0x12,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <fstat>:
SYSCALL(fstat)
 5c8:	b8 08 00 00 00       	mov    $0x8,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <link>:
SYSCALL(link)
 5d0:	b8 13 00 00 00       	mov    $0x13,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <mkdir>:
SYSCALL(mkdir)
 5d8:	b8 14 00 00 00       	mov    $0x14,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <chdir>:
SYSCALL(chdir)
 5e0:	b8 09 00 00 00       	mov    $0x9,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <dup>:
SYSCALL(dup)
 5e8:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <getpid>:
SYSCALL(getpid)
 5f0:	b8 0b 00 00 00       	mov    $0xb,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <sbrk>:
SYSCALL(sbrk)
 5f8:	b8 0c 00 00 00       	mov    $0xc,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <sleep>:
SYSCALL(sleep)
 600:	b8 0d 00 00 00       	mov    $0xd,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <uptime>:
SYSCALL(uptime)
 608:	b8 0e 00 00 00       	mov    $0xe,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <getpinfo>:
SYSCALL(getpinfo)
 610:	b8 16 00 00 00       	mov    $0x16,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <settickets>:
SYSCALL(settickets)
 618:	b8 17 00 00 00       	mov    $0x17,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	83 ec 18             	sub    $0x18,%esp
 626:	8b 45 0c             	mov    0xc(%ebp),%eax
 629:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 62c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 633:	00 
 634:	8d 45 f4             	lea    -0xc(%ebp),%eax
 637:	89 44 24 04          	mov    %eax,0x4(%esp)
 63b:	8b 45 08             	mov    0x8(%ebp),%eax
 63e:	89 04 24             	mov    %eax,(%esp)
 641:	e8 4a ff ff ff       	call   590 <write>
}
 646:	c9                   	leave  
 647:	c3                   	ret    

00000648 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 648:	55                   	push   %ebp
 649:	89 e5                	mov    %esp,%ebp
 64b:	56                   	push   %esi
 64c:	53                   	push   %ebx
 64d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 650:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 657:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 65b:	74 17                	je     674 <printint+0x2c>
 65d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 661:	79 11                	jns    674 <printint+0x2c>
    neg = 1;
 663:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 66a:	8b 45 0c             	mov    0xc(%ebp),%eax
 66d:	f7 d8                	neg    %eax
 66f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 672:	eb 06                	jmp    67a <printint+0x32>
  } else {
    x = xx;
 674:	8b 45 0c             	mov    0xc(%ebp),%eax
 677:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 67a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 681:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 684:	8d 41 01             	lea    0x1(%ecx),%eax
 687:	89 45 f4             	mov    %eax,-0xc(%ebp)
 68a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 68d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 690:	ba 00 00 00 00       	mov    $0x0,%edx
 695:	f7 f3                	div    %ebx
 697:	89 d0                	mov    %edx,%eax
 699:	0f b6 80 b0 0d 00 00 	movzbl 0xdb0(%eax),%eax
 6a0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6a4:	8b 75 10             	mov    0x10(%ebp),%esi
 6a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6aa:	ba 00 00 00 00       	mov    $0x0,%edx
 6af:	f7 f6                	div    %esi
 6b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6b8:	75 c7                	jne    681 <printint+0x39>
  if(neg)
 6ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6be:	74 10                	je     6d0 <printint+0x88>
    buf[i++] = '-';
 6c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c3:	8d 50 01             	lea    0x1(%eax),%edx
 6c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6c9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6ce:	eb 1f                	jmp    6ef <printint+0xa7>
 6d0:	eb 1d                	jmp    6ef <printint+0xa7>
    putc(fd, buf[i]);
 6d2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d8:	01 d0                	add    %edx,%eax
 6da:	0f b6 00             	movzbl (%eax),%eax
 6dd:	0f be c0             	movsbl %al,%eax
 6e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e4:	8b 45 08             	mov    0x8(%ebp),%eax
 6e7:	89 04 24             	mov    %eax,(%esp)
 6ea:	e8 31 ff ff ff       	call   620 <putc>
  while(--i >= 0)
 6ef:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f7:	79 d9                	jns    6d2 <printint+0x8a>
}
 6f9:	83 c4 30             	add    $0x30,%esp
 6fc:	5b                   	pop    %ebx
 6fd:	5e                   	pop    %esi
 6fe:	5d                   	pop    %ebp
 6ff:	c3                   	ret    

00000700 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 706:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 70d:	8d 45 0c             	lea    0xc(%ebp),%eax
 710:	83 c0 04             	add    $0x4,%eax
 713:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 716:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 71d:	e9 7c 01 00 00       	jmp    89e <printf+0x19e>
    c = fmt[i] & 0xff;
 722:	8b 55 0c             	mov    0xc(%ebp),%edx
 725:	8b 45 f0             	mov    -0x10(%ebp),%eax
 728:	01 d0                	add    %edx,%eax
 72a:	0f b6 00             	movzbl (%eax),%eax
 72d:	0f be c0             	movsbl %al,%eax
 730:	25 ff 00 00 00       	and    $0xff,%eax
 735:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 738:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 73c:	75 2c                	jne    76a <printf+0x6a>
      if(c == '%'){
 73e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 742:	75 0c                	jne    750 <printf+0x50>
        state = '%';
 744:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 74b:	e9 4a 01 00 00       	jmp    89a <printf+0x19a>
      } else {
        putc(fd, c);
 750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 753:	0f be c0             	movsbl %al,%eax
 756:	89 44 24 04          	mov    %eax,0x4(%esp)
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
 75d:	89 04 24             	mov    %eax,(%esp)
 760:	e8 bb fe ff ff       	call   620 <putc>
 765:	e9 30 01 00 00       	jmp    89a <printf+0x19a>
      }
    } else if(state == '%'){
 76a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 76e:	0f 85 26 01 00 00    	jne    89a <printf+0x19a>
      if(c == 'd'){
 774:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 778:	75 2d                	jne    7a7 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 77a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 77d:	8b 00                	mov    (%eax),%eax
 77f:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 786:	00 
 787:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 78e:	00 
 78f:	89 44 24 04          	mov    %eax,0x4(%esp)
 793:	8b 45 08             	mov    0x8(%ebp),%eax
 796:	89 04 24             	mov    %eax,(%esp)
 799:	e8 aa fe ff ff       	call   648 <printint>
        ap++;
 79e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a2:	e9 ec 00 00 00       	jmp    893 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 7a7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7ab:	74 06                	je     7b3 <printf+0xb3>
 7ad:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7b1:	75 2d                	jne    7e0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 7b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7bf:	00 
 7c0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7c7:	00 
 7c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7cc:	8b 45 08             	mov    0x8(%ebp),%eax
 7cf:	89 04 24             	mov    %eax,(%esp)
 7d2:	e8 71 fe ff ff       	call   648 <printint>
        ap++;
 7d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7db:	e9 b3 00 00 00       	jmp    893 <printf+0x193>
      } else if(c == 's'){
 7e0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7e4:	75 45                	jne    82b <printf+0x12b>
        s = (char*)*ap;
 7e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e9:	8b 00                	mov    (%eax),%eax
 7eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f6:	75 09                	jne    801 <printf+0x101>
          s = "(null)";
 7f8:	c7 45 f4 34 0b 00 00 	movl   $0xb34,-0xc(%ebp)
        while(*s != 0){
 7ff:	eb 1e                	jmp    81f <printf+0x11f>
 801:	eb 1c                	jmp    81f <printf+0x11f>
          putc(fd, *s);
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	0f b6 00             	movzbl (%eax),%eax
 809:	0f be c0             	movsbl %al,%eax
 80c:	89 44 24 04          	mov    %eax,0x4(%esp)
 810:	8b 45 08             	mov    0x8(%ebp),%eax
 813:	89 04 24             	mov    %eax,(%esp)
 816:	e8 05 fe ff ff       	call   620 <putc>
          s++;
 81b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	0f b6 00             	movzbl (%eax),%eax
 825:	84 c0                	test   %al,%al
 827:	75 da                	jne    803 <printf+0x103>
 829:	eb 68                	jmp    893 <printf+0x193>
        }
      } else if(c == 'c'){
 82b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 82f:	75 1d                	jne    84e <printf+0x14e>
        putc(fd, *ap);
 831:	8b 45 e8             	mov    -0x18(%ebp),%eax
 834:	8b 00                	mov    (%eax),%eax
 836:	0f be c0             	movsbl %al,%eax
 839:	89 44 24 04          	mov    %eax,0x4(%esp)
 83d:	8b 45 08             	mov    0x8(%ebp),%eax
 840:	89 04 24             	mov    %eax,(%esp)
 843:	e8 d8 fd ff ff       	call   620 <putc>
        ap++;
 848:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 84c:	eb 45                	jmp    893 <printf+0x193>
      } else if(c == '%'){
 84e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 852:	75 17                	jne    86b <printf+0x16b>
        putc(fd, c);
 854:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 857:	0f be c0             	movsbl %al,%eax
 85a:	89 44 24 04          	mov    %eax,0x4(%esp)
 85e:	8b 45 08             	mov    0x8(%ebp),%eax
 861:	89 04 24             	mov    %eax,(%esp)
 864:	e8 b7 fd ff ff       	call   620 <putc>
 869:	eb 28                	jmp    893 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 86b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 872:	00 
 873:	8b 45 08             	mov    0x8(%ebp),%eax
 876:	89 04 24             	mov    %eax,(%esp)
 879:	e8 a2 fd ff ff       	call   620 <putc>
        putc(fd, c);
 87e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 881:	0f be c0             	movsbl %al,%eax
 884:	89 44 24 04          	mov    %eax,0x4(%esp)
 888:	8b 45 08             	mov    0x8(%ebp),%eax
 88b:	89 04 24             	mov    %eax,(%esp)
 88e:	e8 8d fd ff ff       	call   620 <putc>
      }
      state = 0;
 893:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 89a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 89e:	8b 55 0c             	mov    0xc(%ebp),%edx
 8a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a4:	01 d0                	add    %edx,%eax
 8a6:	0f b6 00             	movzbl (%eax),%eax
 8a9:	84 c0                	test   %al,%al
 8ab:	0f 85 71 fe ff ff    	jne    722 <printf+0x22>
    }
  }
}
 8b1:	c9                   	leave  
 8b2:	c3                   	ret    

000008b3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b3:	55                   	push   %ebp
 8b4:	89 e5                	mov    %esp,%ebp
 8b6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b9:	8b 45 08             	mov    0x8(%ebp),%eax
 8bc:	83 e8 08             	sub    $0x8,%eax
 8bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c2:	a1 cc 0d 00 00       	mov    0xdcc,%eax
 8c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8ca:	eb 24                	jmp    8f0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cf:	8b 00                	mov    (%eax),%eax
 8d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d4:	77 12                	ja     8e8 <free+0x35>
 8d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8dc:	77 24                	ja     902 <free+0x4f>
 8de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e1:	8b 00                	mov    (%eax),%eax
 8e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e6:	77 1a                	ja     902 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8eb:	8b 00                	mov    (%eax),%eax
 8ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8f6:	76 d4                	jbe    8cc <free+0x19>
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	8b 00                	mov    (%eax),%eax
 8fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 900:	76 ca                	jbe    8cc <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 902:	8b 45 f8             	mov    -0x8(%ebp),%eax
 905:	8b 40 04             	mov    0x4(%eax),%eax
 908:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 90f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 912:	01 c2                	add    %eax,%edx
 914:	8b 45 fc             	mov    -0x4(%ebp),%eax
 917:	8b 00                	mov    (%eax),%eax
 919:	39 c2                	cmp    %eax,%edx
 91b:	75 24                	jne    941 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 91d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 920:	8b 50 04             	mov    0x4(%eax),%edx
 923:	8b 45 fc             	mov    -0x4(%ebp),%eax
 926:	8b 00                	mov    (%eax),%eax
 928:	8b 40 04             	mov    0x4(%eax),%eax
 92b:	01 c2                	add    %eax,%edx
 92d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 930:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 933:	8b 45 fc             	mov    -0x4(%ebp),%eax
 936:	8b 00                	mov    (%eax),%eax
 938:	8b 10                	mov    (%eax),%edx
 93a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93d:	89 10                	mov    %edx,(%eax)
 93f:	eb 0a                	jmp    94b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 941:	8b 45 fc             	mov    -0x4(%ebp),%eax
 944:	8b 10                	mov    (%eax),%edx
 946:	8b 45 f8             	mov    -0x8(%ebp),%eax
 949:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 94b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94e:	8b 40 04             	mov    0x4(%eax),%eax
 951:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 958:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95b:	01 d0                	add    %edx,%eax
 95d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 960:	75 20                	jne    982 <free+0xcf>
    p->s.size += bp->s.size;
 962:	8b 45 fc             	mov    -0x4(%ebp),%eax
 965:	8b 50 04             	mov    0x4(%eax),%edx
 968:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96b:	8b 40 04             	mov    0x4(%eax),%eax
 96e:	01 c2                	add    %eax,%edx
 970:	8b 45 fc             	mov    -0x4(%ebp),%eax
 973:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 976:	8b 45 f8             	mov    -0x8(%ebp),%eax
 979:	8b 10                	mov    (%eax),%edx
 97b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97e:	89 10                	mov    %edx,(%eax)
 980:	eb 08                	jmp    98a <free+0xd7>
  } else
    p->s.ptr = bp;
 982:	8b 45 fc             	mov    -0x4(%ebp),%eax
 985:	8b 55 f8             	mov    -0x8(%ebp),%edx
 988:	89 10                	mov    %edx,(%eax)
  freep = p;
 98a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98d:	a3 cc 0d 00 00       	mov    %eax,0xdcc
}
 992:	c9                   	leave  
 993:	c3                   	ret    

00000994 <morecore>:

static Header*
morecore(uint nu)
{
 994:	55                   	push   %ebp
 995:	89 e5                	mov    %esp,%ebp
 997:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 99a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9a1:	77 07                	ja     9aa <morecore+0x16>
    nu = 4096;
 9a3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9aa:	8b 45 08             	mov    0x8(%ebp),%eax
 9ad:	c1 e0 03             	shl    $0x3,%eax
 9b0:	89 04 24             	mov    %eax,(%esp)
 9b3:	e8 40 fc ff ff       	call   5f8 <sbrk>
 9b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9bb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9bf:	75 07                	jne    9c8 <morecore+0x34>
    return 0;
 9c1:	b8 00 00 00 00       	mov    $0x0,%eax
 9c6:	eb 22                	jmp    9ea <morecore+0x56>
  hp = (Header*)p;
 9c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d1:	8b 55 08             	mov    0x8(%ebp),%edx
 9d4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9da:	83 c0 08             	add    $0x8,%eax
 9dd:	89 04 24             	mov    %eax,(%esp)
 9e0:	e8 ce fe ff ff       	call   8b3 <free>
  return freep;
 9e5:	a1 cc 0d 00 00       	mov    0xdcc,%eax
}
 9ea:	c9                   	leave  
 9eb:	c3                   	ret    

000009ec <malloc>:

void*
malloc(uint nbytes)
{
 9ec:	55                   	push   %ebp
 9ed:	89 e5                	mov    %esp,%ebp
 9ef:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f2:	8b 45 08             	mov    0x8(%ebp),%eax
 9f5:	83 c0 07             	add    $0x7,%eax
 9f8:	c1 e8 03             	shr    $0x3,%eax
 9fb:	83 c0 01             	add    $0x1,%eax
 9fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a01:	a1 cc 0d 00 00       	mov    0xdcc,%eax
 a06:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a0d:	75 23                	jne    a32 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a0f:	c7 45 f0 c4 0d 00 00 	movl   $0xdc4,-0x10(%ebp)
 a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a19:	a3 cc 0d 00 00       	mov    %eax,0xdcc
 a1e:	a1 cc 0d 00 00       	mov    0xdcc,%eax
 a23:	a3 c4 0d 00 00       	mov    %eax,0xdc4
    base.s.size = 0;
 a28:	c7 05 c8 0d 00 00 00 	movl   $0x0,0xdc8
 a2f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a35:	8b 00                	mov    (%eax),%eax
 a37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3d:	8b 40 04             	mov    0x4(%eax),%eax
 a40:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a43:	72 4d                	jb     a92 <malloc+0xa6>
      if(p->s.size == nunits)
 a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a48:	8b 40 04             	mov    0x4(%eax),%eax
 a4b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a4e:	75 0c                	jne    a5c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a53:	8b 10                	mov    (%eax),%edx
 a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a58:	89 10                	mov    %edx,(%eax)
 a5a:	eb 26                	jmp    a82 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5f:	8b 40 04             	mov    0x4(%eax),%eax
 a62:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a65:	89 c2                	mov    %eax,%edx
 a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a70:	8b 40 04             	mov    0x4(%eax),%eax
 a73:	c1 e0 03             	shl    $0x3,%eax
 a76:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a7f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a85:	a3 cc 0d 00 00       	mov    %eax,0xdcc
      return (void*)(p + 1);
 a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8d:	83 c0 08             	add    $0x8,%eax
 a90:	eb 38                	jmp    aca <malloc+0xde>
    }
    if(p == freep)
 a92:	a1 cc 0d 00 00       	mov    0xdcc,%eax
 a97:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a9a:	75 1b                	jne    ab7 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a9f:	89 04 24             	mov    %eax,(%esp)
 aa2:	e8 ed fe ff ff       	call   994 <morecore>
 aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aae:	75 07                	jne    ab7 <malloc+0xcb>
        return 0;
 ab0:	b8 00 00 00 00       	mov    $0x0,%eax
 ab5:	eb 13                	jmp    aca <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	89 45 f0             	mov    %eax,-0x10(%ebp)
 abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac0:	8b 00                	mov    (%eax),%eax
 ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 ac5:	e9 70 ff ff ff       	jmp    a3a <malloc+0x4e>
}
 aca:	c9                   	leave  
 acb:	c3                   	ret    
