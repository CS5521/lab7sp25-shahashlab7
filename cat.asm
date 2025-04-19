
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   6:	eb 39                	jmp    41 <cat+0x41>
    if (write(1, buf, n) != n) {
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 a0 0d 00 	movl   $0xda0,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 f5 04 00 00       	call   518 <write>
  23:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  26:	74 19                	je     41 <cat+0x41>
      printf(1, "cat: write error\n");
  28:	c7 44 24 04 54 0a 00 	movl   $0xa54,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 4c 06 00 00       	call   688 <printf>
      exit();
  3c:	e8 b7 04 00 00       	call   4f8 <exit>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  41:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  48:	00 
  49:	c7 44 24 04 a0 0d 00 	movl   $0xda0,0x4(%esp)
  50:	00 
  51:	8b 45 08             	mov    0x8(%ebp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 b4 04 00 00       	call   510 <read>
  5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  63:	7f a3                	jg     8 <cat+0x8>
    }
  }
  if(n < 0){
  65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  69:	79 19                	jns    84 <cat+0x84>
    printf(1, "cat: read error\n");
  6b:	c7 44 24 04 66 0a 00 	movl   $0xa66,0x4(%esp)
  72:	00 
  73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7a:	e8 09 06 00 00       	call   688 <printf>
    exit();
  7f:	e8 74 04 00 00       	call   4f8 <exit>
  }
}
  84:	c9                   	leave  
  85:	c3                   	ret    

00000086 <main>:

int
main(int argc, char *argv[])
{
  86:	55                   	push   %ebp
  87:	89 e5                	mov    %esp,%ebp
  89:	83 e4 f0             	and    $0xfffffff0,%esp
  8c:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  8f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  93:	7f 11                	jg     a6 <main+0x20>
    cat(0);
  95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  9c:	e8 5f ff ff ff       	call   0 <cat>
    exit();
  a1:	e8 52 04 00 00       	call   4f8 <exit>
  }

  for(i = 1; i < argc; i++){
  a6:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  ad:	00 
  ae:	eb 79                	jmp    129 <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
  b0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  be:	01 d0                	add    %edx,%eax
  c0:	8b 00                	mov    (%eax),%eax
  c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c9:	00 
  ca:	89 04 24             	mov    %eax,(%esp)
  cd:	e8 66 04 00 00       	call   538 <open>
  d2:	89 44 24 18          	mov    %eax,0x18(%esp)
  d6:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  db:	79 2f                	jns    10c <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  dd:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  eb:	01 d0                	add    %edx,%eax
  ed:	8b 00                	mov    (%eax),%eax
  ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  f3:	c7 44 24 04 77 0a 00 	movl   $0xa77,0x4(%esp)
  fa:	00 
  fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 102:	e8 81 05 00 00       	call   688 <printf>
      exit();
 107:	e8 ec 03 00 00       	call   4f8 <exit>
    }
    cat(fd);
 10c:	8b 44 24 18          	mov    0x18(%esp),%eax
 110:	89 04 24             	mov    %eax,(%esp)
 113:	e8 e8 fe ff ff       	call   0 <cat>
    close(fd);
 118:	8b 44 24 18          	mov    0x18(%esp),%eax
 11c:	89 04 24             	mov    %eax,(%esp)
 11f:	e8 fc 03 00 00       	call   520 <close>
  for(i = 1; i < argc; i++){
 124:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 129:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 12d:	3b 45 08             	cmp    0x8(%ebp),%eax
 130:	0f 8c 7a ff ff ff    	jl     b0 <main+0x2a>
  }
  exit();
 136:	e8 bd 03 00 00       	call   4f8 <exit>

0000013b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	57                   	push   %edi
 13f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 140:	8b 4d 08             	mov    0x8(%ebp),%ecx
 143:	8b 55 10             	mov    0x10(%ebp),%edx
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	89 cb                	mov    %ecx,%ebx
 14b:	89 df                	mov    %ebx,%edi
 14d:	89 d1                	mov    %edx,%ecx
 14f:	fc                   	cld    
 150:	f3 aa                	rep stos %al,%es:(%edi)
 152:	89 ca                	mov    %ecx,%edx
 154:	89 fb                	mov    %edi,%ebx
 156:	89 5d 08             	mov    %ebx,0x8(%ebp)
 159:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 15c:	5b                   	pop    %ebx
 15d:	5f                   	pop    %edi
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	56                   	push   %esi
 165:	53                   	push   %ebx
 166:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
 16c:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
 172:	89 04 24             	mov    %eax,(%esp)
 175:	e8 1e 04 00 00       	call   598 <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 17a:	c7 44 24 04 8c 0a 00 	movl   $0xa8c,0x4(%esp)
 181:	00 
 182:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 189:	e8 fa 04 00 00       	call   688 <printf>
    for (i = 0; i < NPROC; i++) {
 18e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 195:	e9 06 01 00 00       	jmp    2a0 <ps+0x140>
        if (ptable[i].inuse) {
 19a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 19d:	89 d0                	mov    %edx,%eax
 19f:	c1 e0 03             	shl    $0x3,%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	c1 e0 02             	shl    $0x2,%eax
 1a7:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 1aa:	01 d8                	add    %ebx,%eax
 1ac:	2d 08 09 00 00       	sub    $0x908,%eax
 1b1:	8b 00                	mov    (%eax),%eax
 1b3:	85 c0                	test   %eax,%eax
 1b5:	0f 84 e1 00 00 00    	je     29c <ps+0x13c>
            char stat = '?';
 1bb:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
 1bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1c2:	89 d0                	mov    %edx,%eax
 1c4:	c1 e0 03             	shl    $0x3,%eax
 1c7:	01 d0                	add    %edx,%eax
 1c9:	c1 e0 02             	shl    $0x2,%eax
 1cc:	8d 75 e8             	lea    -0x18(%ebp),%esi
 1cf:	01 f0                	add    %esi,%eax
 1d1:	2d e8 08 00 00       	sub    $0x8e8,%eax
 1d6:	0f b6 00             	movzbl (%eax),%eax
 1d9:	0f be c0             	movsbl %al,%eax
 1dc:	83 f8 05             	cmp    $0x5,%eax
 1df:	77 27                	ja     208 <ps+0xa8>
 1e1:	8b 04 85 b8 0a 00 00 	mov    0xab8(,%eax,4),%eax
 1e8:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
 1ea:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
 1ee:	eb 1c                	jmp    20c <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
 1f0:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 1f4:	eb 16                	jmp    20c <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
 1f6:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
 1fa:	eb 10                	jmp    20c <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
 1fc:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
 200:	eb 0a                	jmp    20c <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
 202:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
 206:	eb 04                	jmp    20c <ps+0xac>
                default: stat = '?';
 208:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
 20c:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
 212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 215:	89 d0                	mov    %edx,%eax
 217:	c1 e0 03             	shl    $0x3,%eax
 21a:	01 d0                	add    %edx,%eax
 21c:	c1 e0 02             	shl    $0x2,%eax
 21f:	83 c0 10             	add    $0x10,%eax
 222:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 225:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 229:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 22c:	89 d0                	mov    %edx,%eax
 22e:	c1 e0 03             	shl    $0x3,%eax
 231:	01 d0                	add    %edx,%eax
 233:	c1 e0 02             	shl    $0x2,%eax
 236:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 239:	01 c8                	add    %ecx,%eax
 23b:	2d fc 08 00 00       	sub    $0x8fc,%eax
 240:	8b 18                	mov    (%eax),%ebx
 242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 245:	89 d0                	mov    %edx,%eax
 247:	c1 e0 03             	shl    $0x3,%eax
 24a:	01 d0                	add    %edx,%eax
 24c:	c1 e0 02             	shl    $0x2,%eax
 24f:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 252:	01 c8                	add    %ecx,%eax
 254:	2d 04 09 00 00       	sub    $0x904,%eax
 259:	8b 08                	mov    (%eax),%ecx
 25b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 25e:	89 d0                	mov    %edx,%eax
 260:	c1 e0 03             	shl    $0x3,%eax
 263:	01 d0                	add    %edx,%eax
 265:	c1 e0 02             	shl    $0x2,%eax
 268:	8d 55 e8             	lea    -0x18(%ebp),%edx
 26b:	01 d0                	add    %edx,%eax
 26d:	2d 00 09 00 00       	sub    $0x900,%eax
 272:	8b 00                	mov    (%eax),%eax
 274:	89 7c 24 18          	mov    %edi,0x18(%esp)
 278:	89 74 24 14          	mov    %esi,0x14(%esp)
 27c:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 280:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 284:	89 44 24 08          	mov    %eax,0x8(%esp)
 288:	c7 44 24 04 a5 0a 00 	movl   $0xaa5,0x4(%esp)
 28f:	00 
 290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 297:	e8 ec 03 00 00       	call   688 <printf>
    for (i = 0; i < NPROC; i++) {
 29c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 2a0:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 2a4:	0f 8e f0 fe ff ff    	jle    19a <ps+0x3a>
        }
    }
}
 2aa:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 2b0:	5b                   	pop    %ebx
 2b1:	5e                   	pop    %esi
 2b2:	5f                   	pop    %edi
 2b3:	5d                   	pop    %ebp
 2b4:	c3                   	ret    

000002b5 <strcpy>:


char*
strcpy(char *s, const char *t)
{
 2b5:	55                   	push   %ebp
 2b6:	89 e5                	mov    %esp,%ebp
 2b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2c1:	90                   	nop
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	8d 50 01             	lea    0x1(%eax),%edx
 2c8:	89 55 08             	mov    %edx,0x8(%ebp)
 2cb:	8b 55 0c             	mov    0xc(%ebp),%edx
 2ce:	8d 4a 01             	lea    0x1(%edx),%ecx
 2d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2d4:	0f b6 12             	movzbl (%edx),%edx
 2d7:	88 10                	mov    %dl,(%eax)
 2d9:	0f b6 00             	movzbl (%eax),%eax
 2dc:	84 c0                	test   %al,%al
 2de:	75 e2                	jne    2c2 <strcpy+0xd>
    ;
  return os;
 2e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e3:	c9                   	leave  
 2e4:	c3                   	ret    

000002e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e5:	55                   	push   %ebp
 2e6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2e8:	eb 08                	jmp    2f2 <strcmp+0xd>
    p++, q++;
 2ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	0f b6 00             	movzbl (%eax),%eax
 2f8:	84 c0                	test   %al,%al
 2fa:	74 10                	je     30c <strcmp+0x27>
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	0f b6 10             	movzbl (%eax),%edx
 302:	8b 45 0c             	mov    0xc(%ebp),%eax
 305:	0f b6 00             	movzbl (%eax),%eax
 308:	38 c2                	cmp    %al,%dl
 30a:	74 de                	je     2ea <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	0f b6 00             	movzbl (%eax),%eax
 312:	0f b6 d0             	movzbl %al,%edx
 315:	8b 45 0c             	mov    0xc(%ebp),%eax
 318:	0f b6 00             	movzbl (%eax),%eax
 31b:	0f b6 c0             	movzbl %al,%eax
 31e:	29 c2                	sub    %eax,%edx
 320:	89 d0                	mov    %edx,%eax
}
 322:	5d                   	pop    %ebp
 323:	c3                   	ret    

00000324 <strlen>:

uint
strlen(const char *s)
{
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 32a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 331:	eb 04                	jmp    337 <strlen+0x13>
 333:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 337:	8b 55 fc             	mov    -0x4(%ebp),%edx
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	01 d0                	add    %edx,%eax
 33f:	0f b6 00             	movzbl (%eax),%eax
 342:	84 c0                	test   %al,%al
 344:	75 ed                	jne    333 <strlen+0xf>
    ;
  return n;
 346:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 349:	c9                   	leave  
 34a:	c3                   	ret    

0000034b <memset>:

void*
memset(void *dst, int c, uint n)
{
 34b:	55                   	push   %ebp
 34c:	89 e5                	mov    %esp,%ebp
 34e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 351:	8b 45 10             	mov    0x10(%ebp),%eax
 354:	89 44 24 08          	mov    %eax,0x8(%esp)
 358:	8b 45 0c             	mov    0xc(%ebp),%eax
 35b:	89 44 24 04          	mov    %eax,0x4(%esp)
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
 362:	89 04 24             	mov    %eax,(%esp)
 365:	e8 d1 fd ff ff       	call   13b <stosb>
  return dst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <strchr>:

char*
strchr(const char *s, char c)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 04             	sub    $0x4,%esp
 375:	8b 45 0c             	mov    0xc(%ebp),%eax
 378:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 37b:	eb 14                	jmp    391 <strchr+0x22>
    if(*s == c)
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	3a 45 fc             	cmp    -0x4(%ebp),%al
 386:	75 05                	jne    38d <strchr+0x1e>
      return (char*)s;
 388:	8b 45 08             	mov    0x8(%ebp),%eax
 38b:	eb 13                	jmp    3a0 <strchr+0x31>
  for(; *s; s++)
 38d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 391:	8b 45 08             	mov    0x8(%ebp),%eax
 394:	0f b6 00             	movzbl (%eax),%eax
 397:	84 c0                	test   %al,%al
 399:	75 e2                	jne    37d <strchr+0xe>
  return 0;
 39b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3a0:	c9                   	leave  
 3a1:	c3                   	ret    

000003a2 <gets>:

char*
gets(char *buf, int max)
{
 3a2:	55                   	push   %ebp
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3af:	eb 4c                	jmp    3fd <gets+0x5b>
    cc = read(0, &c, 1);
 3b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3b8:	00 
 3b9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3c7:	e8 44 01 00 00       	call   510 <read>
 3cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d3:	7f 02                	jg     3d7 <gets+0x35>
      break;
 3d5:	eb 31                	jmp    408 <gets+0x66>
    buf[i++] = c;
 3d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3da:	8d 50 01             	lea    0x1(%eax),%edx
 3dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3e0:	89 c2                	mov    %eax,%edx
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	01 c2                	add    %eax,%edx
 3e7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3eb:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3ed:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f1:	3c 0a                	cmp    $0xa,%al
 3f3:	74 13                	je     408 <gets+0x66>
 3f5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f9:	3c 0d                	cmp    $0xd,%al
 3fb:	74 0b                	je     408 <gets+0x66>
  for(i=0; i+1 < max; ){
 3fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 400:	83 c0 01             	add    $0x1,%eax
 403:	3b 45 0c             	cmp    0xc(%ebp),%eax
 406:	7c a9                	jl     3b1 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 408:	8b 55 f4             	mov    -0xc(%ebp),%edx
 40b:	8b 45 08             	mov    0x8(%ebp),%eax
 40e:	01 d0                	add    %edx,%eax
 410:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 413:	8b 45 08             	mov    0x8(%ebp),%eax
}
 416:	c9                   	leave  
 417:	c3                   	ret    

00000418 <stat>:

int
stat(const char *n, struct stat *st)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 41e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 425:	00 
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	89 04 24             	mov    %eax,(%esp)
 42c:	e8 07 01 00 00       	call   538 <open>
 431:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 438:	79 07                	jns    441 <stat+0x29>
    return -1;
 43a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 43f:	eb 23                	jmp    464 <stat+0x4c>
  r = fstat(fd, st);
 441:	8b 45 0c             	mov    0xc(%ebp),%eax
 444:	89 44 24 04          	mov    %eax,0x4(%esp)
 448:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44b:	89 04 24             	mov    %eax,(%esp)
 44e:	e8 fd 00 00 00       	call   550 <fstat>
 453:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 456:	8b 45 f4             	mov    -0xc(%ebp),%eax
 459:	89 04 24             	mov    %eax,(%esp)
 45c:	e8 bf 00 00 00       	call   520 <close>
  return r;
 461:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 464:	c9                   	leave  
 465:	c3                   	ret    

00000466 <atoi>:

int
atoi(const char *s)
{
 466:	55                   	push   %ebp
 467:	89 e5                	mov    %esp,%ebp
 469:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 46c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 473:	eb 25                	jmp    49a <atoi+0x34>
    n = n*10 + *s++ - '0';
 475:	8b 55 fc             	mov    -0x4(%ebp),%edx
 478:	89 d0                	mov    %edx,%eax
 47a:	c1 e0 02             	shl    $0x2,%eax
 47d:	01 d0                	add    %edx,%eax
 47f:	01 c0                	add    %eax,%eax
 481:	89 c1                	mov    %eax,%ecx
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	8d 50 01             	lea    0x1(%eax),%edx
 489:	89 55 08             	mov    %edx,0x8(%ebp)
 48c:	0f b6 00             	movzbl (%eax),%eax
 48f:	0f be c0             	movsbl %al,%eax
 492:	01 c8                	add    %ecx,%eax
 494:	83 e8 30             	sub    $0x30,%eax
 497:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	0f b6 00             	movzbl (%eax),%eax
 4a0:	3c 2f                	cmp    $0x2f,%al
 4a2:	7e 0a                	jle    4ae <atoi+0x48>
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	0f b6 00             	movzbl (%eax),%eax
 4aa:	3c 39                	cmp    $0x39,%al
 4ac:	7e c7                	jle    475 <atoi+0xf>
  return n;
 4ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4b1:	c9                   	leave  
 4b2:	c3                   	ret    

000004b3 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b3:	55                   	push   %ebp
 4b4:	89 e5                	mov    %esp,%ebp
 4b6:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
 4bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4c5:	eb 17                	jmp    4de <memmove+0x2b>
    *dst++ = *src++;
 4c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4ca:	8d 50 01             	lea    0x1(%eax),%edx
 4cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4d3:	8d 4a 01             	lea    0x1(%edx),%ecx
 4d6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4d9:	0f b6 12             	movzbl (%edx),%edx
 4dc:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 4de:	8b 45 10             	mov    0x10(%ebp),%eax
 4e1:	8d 50 ff             	lea    -0x1(%eax),%edx
 4e4:	89 55 10             	mov    %edx,0x10(%ebp)
 4e7:	85 c0                	test   %eax,%eax
 4e9:	7f dc                	jg     4c7 <memmove+0x14>
  return vdst;
 4eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ee:	c9                   	leave  
 4ef:	c3                   	ret    

000004f0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4f0:	b8 01 00 00 00       	mov    $0x1,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <exit>:
SYSCALL(exit)
 4f8:	b8 02 00 00 00       	mov    $0x2,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <wait>:
SYSCALL(wait)
 500:	b8 03 00 00 00       	mov    $0x3,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <pipe>:
SYSCALL(pipe)
 508:	b8 04 00 00 00       	mov    $0x4,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <read>:
SYSCALL(read)
 510:	b8 05 00 00 00       	mov    $0x5,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <write>:
SYSCALL(write)
 518:	b8 10 00 00 00       	mov    $0x10,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <close>:
SYSCALL(close)
 520:	b8 15 00 00 00       	mov    $0x15,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <kill>:
SYSCALL(kill)
 528:	b8 06 00 00 00       	mov    $0x6,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <exec>:
SYSCALL(exec)
 530:	b8 07 00 00 00       	mov    $0x7,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <open>:
SYSCALL(open)
 538:	b8 0f 00 00 00       	mov    $0xf,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <mknod>:
SYSCALL(mknod)
 540:	b8 11 00 00 00       	mov    $0x11,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <unlink>:
SYSCALL(unlink)
 548:	b8 12 00 00 00       	mov    $0x12,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <fstat>:
SYSCALL(fstat)
 550:	b8 08 00 00 00       	mov    $0x8,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <link>:
SYSCALL(link)
 558:	b8 13 00 00 00       	mov    $0x13,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <mkdir>:
SYSCALL(mkdir)
 560:	b8 14 00 00 00       	mov    $0x14,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <chdir>:
SYSCALL(chdir)
 568:	b8 09 00 00 00       	mov    $0x9,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <dup>:
SYSCALL(dup)
 570:	b8 0a 00 00 00       	mov    $0xa,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <getpid>:
SYSCALL(getpid)
 578:	b8 0b 00 00 00       	mov    $0xb,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <sbrk>:
SYSCALL(sbrk)
 580:	b8 0c 00 00 00       	mov    $0xc,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <sleep>:
SYSCALL(sleep)
 588:	b8 0d 00 00 00       	mov    $0xd,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <uptime>:
SYSCALL(uptime)
 590:	b8 0e 00 00 00       	mov    $0xe,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <getpinfo>:
SYSCALL(getpinfo)
 598:	b8 16 00 00 00       	mov    $0x16,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <settickets>:
SYSCALL(settickets)
 5a0:	b8 17 00 00 00       	mov    $0x17,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5a8:	55                   	push   %ebp
 5a9:	89 e5                	mov    %esp,%ebp
 5ab:	83 ec 18             	sub    $0x18,%esp
 5ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5bb:	00 
 5bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	89 04 24             	mov    %eax,(%esp)
 5c9:	e8 4a ff ff ff       	call   518 <write>
}
 5ce:	c9                   	leave  
 5cf:	c3                   	ret    

000005d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	56                   	push   %esi
 5d4:	53                   	push   %ebx
 5d5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5df:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5e3:	74 17                	je     5fc <printint+0x2c>
 5e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5e9:	79 11                	jns    5fc <printint+0x2c>
    neg = 1;
 5eb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f5:	f7 d8                	neg    %eax
 5f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5fa:	eb 06                	jmp    602 <printint+0x32>
  } else {
    x = xx;
 5fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 602:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 609:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 60c:	8d 41 01             	lea    0x1(%ecx),%eax
 60f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 612:	8b 5d 10             	mov    0x10(%ebp),%ebx
 615:	8b 45 ec             	mov    -0x14(%ebp),%eax
 618:	ba 00 00 00 00       	mov    $0x0,%edx
 61d:	f7 f3                	div    %ebx
 61f:	89 d0                	mov    %edx,%eax
 621:	0f b6 80 6c 0d 00 00 	movzbl 0xd6c(%eax),%eax
 628:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 62c:	8b 75 10             	mov    0x10(%ebp),%esi
 62f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 632:	ba 00 00 00 00       	mov    $0x0,%edx
 637:	f7 f6                	div    %esi
 639:	89 45 ec             	mov    %eax,-0x14(%ebp)
 63c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 640:	75 c7                	jne    609 <printint+0x39>
  if(neg)
 642:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 646:	74 10                	je     658 <printint+0x88>
    buf[i++] = '-';
 648:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64b:	8d 50 01             	lea    0x1(%eax),%edx
 64e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 651:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 656:	eb 1f                	jmp    677 <printint+0xa7>
 658:	eb 1d                	jmp    677 <printint+0xa7>
    putc(fd, buf[i]);
 65a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 65d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 660:	01 d0                	add    %edx,%eax
 662:	0f b6 00             	movzbl (%eax),%eax
 665:	0f be c0             	movsbl %al,%eax
 668:	89 44 24 04          	mov    %eax,0x4(%esp)
 66c:	8b 45 08             	mov    0x8(%ebp),%eax
 66f:	89 04 24             	mov    %eax,(%esp)
 672:	e8 31 ff ff ff       	call   5a8 <putc>
  while(--i >= 0)
 677:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 67b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 67f:	79 d9                	jns    65a <printint+0x8a>
}
 681:	83 c4 30             	add    $0x30,%esp
 684:	5b                   	pop    %ebx
 685:	5e                   	pop    %esi
 686:	5d                   	pop    %ebp
 687:	c3                   	ret    

00000688 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 688:	55                   	push   %ebp
 689:	89 e5                	mov    %esp,%ebp
 68b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 68e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 695:	8d 45 0c             	lea    0xc(%ebp),%eax
 698:	83 c0 04             	add    $0x4,%eax
 69b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 69e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6a5:	e9 7c 01 00 00       	jmp    826 <printf+0x19e>
    c = fmt[i] & 0xff;
 6aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b0:	01 d0                	add    %edx,%eax
 6b2:	0f b6 00             	movzbl (%eax),%eax
 6b5:	0f be c0             	movsbl %al,%eax
 6b8:	25 ff 00 00 00       	and    $0xff,%eax
 6bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6c4:	75 2c                	jne    6f2 <printf+0x6a>
      if(c == '%'){
 6c6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ca:	75 0c                	jne    6d8 <printf+0x50>
        state = '%';
 6cc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6d3:	e9 4a 01 00 00       	jmp    822 <printf+0x19a>
      } else {
        putc(fd, c);
 6d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6db:	0f be c0             	movsbl %al,%eax
 6de:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e2:	8b 45 08             	mov    0x8(%ebp),%eax
 6e5:	89 04 24             	mov    %eax,(%esp)
 6e8:	e8 bb fe ff ff       	call   5a8 <putc>
 6ed:	e9 30 01 00 00       	jmp    822 <printf+0x19a>
      }
    } else if(state == '%'){
 6f2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6f6:	0f 85 26 01 00 00    	jne    822 <printf+0x19a>
      if(c == 'd'){
 6fc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 700:	75 2d                	jne    72f <printf+0xa7>
        printint(fd, *ap, 10, 1);
 702:	8b 45 e8             	mov    -0x18(%ebp),%eax
 705:	8b 00                	mov    (%eax),%eax
 707:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 70e:	00 
 70f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 716:	00 
 717:	89 44 24 04          	mov    %eax,0x4(%esp)
 71b:	8b 45 08             	mov    0x8(%ebp),%eax
 71e:	89 04 24             	mov    %eax,(%esp)
 721:	e8 aa fe ff ff       	call   5d0 <printint>
        ap++;
 726:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 72a:	e9 ec 00 00 00       	jmp    81b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 72f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 733:	74 06                	je     73b <printf+0xb3>
 735:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 739:	75 2d                	jne    768 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 73b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73e:	8b 00                	mov    (%eax),%eax
 740:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 747:	00 
 748:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 74f:	00 
 750:	89 44 24 04          	mov    %eax,0x4(%esp)
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	89 04 24             	mov    %eax,(%esp)
 75a:	e8 71 fe ff ff       	call   5d0 <printint>
        ap++;
 75f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 763:	e9 b3 00 00 00       	jmp    81b <printf+0x193>
      } else if(c == 's'){
 768:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 76c:	75 45                	jne    7b3 <printf+0x12b>
        s = (char*)*ap;
 76e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 771:	8b 00                	mov    (%eax),%eax
 773:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 776:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 77a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 77e:	75 09                	jne    789 <printf+0x101>
          s = "(null)";
 780:	c7 45 f4 d0 0a 00 00 	movl   $0xad0,-0xc(%ebp)
        while(*s != 0){
 787:	eb 1e                	jmp    7a7 <printf+0x11f>
 789:	eb 1c                	jmp    7a7 <printf+0x11f>
          putc(fd, *s);
 78b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78e:	0f b6 00             	movzbl (%eax),%eax
 791:	0f be c0             	movsbl %al,%eax
 794:	89 44 24 04          	mov    %eax,0x4(%esp)
 798:	8b 45 08             	mov    0x8(%ebp),%eax
 79b:	89 04 24             	mov    %eax,(%esp)
 79e:	e8 05 fe ff ff       	call   5a8 <putc>
          s++;
 7a3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	0f b6 00             	movzbl (%eax),%eax
 7ad:	84 c0                	test   %al,%al
 7af:	75 da                	jne    78b <printf+0x103>
 7b1:	eb 68                	jmp    81b <printf+0x193>
        }
      } else if(c == 'c'){
 7b3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7b7:	75 1d                	jne    7d6 <printf+0x14e>
        putc(fd, *ap);
 7b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7bc:	8b 00                	mov    (%eax),%eax
 7be:	0f be c0             	movsbl %al,%eax
 7c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c5:	8b 45 08             	mov    0x8(%ebp),%eax
 7c8:	89 04 24             	mov    %eax,(%esp)
 7cb:	e8 d8 fd ff ff       	call   5a8 <putc>
        ap++;
 7d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d4:	eb 45                	jmp    81b <printf+0x193>
      } else if(c == '%'){
 7d6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7da:	75 17                	jne    7f3 <printf+0x16b>
        putc(fd, c);
 7dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7df:	0f be c0             	movsbl %al,%eax
 7e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e6:	8b 45 08             	mov    0x8(%ebp),%eax
 7e9:	89 04 24             	mov    %eax,(%esp)
 7ec:	e8 b7 fd ff ff       	call   5a8 <putc>
 7f1:	eb 28                	jmp    81b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7f3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7fa:	00 
 7fb:	8b 45 08             	mov    0x8(%ebp),%eax
 7fe:	89 04 24             	mov    %eax,(%esp)
 801:	e8 a2 fd ff ff       	call   5a8 <putc>
        putc(fd, c);
 806:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 809:	0f be c0             	movsbl %al,%eax
 80c:	89 44 24 04          	mov    %eax,0x4(%esp)
 810:	8b 45 08             	mov    0x8(%ebp),%eax
 813:	89 04 24             	mov    %eax,(%esp)
 816:	e8 8d fd ff ff       	call   5a8 <putc>
      }
      state = 0;
 81b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 822:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 826:	8b 55 0c             	mov    0xc(%ebp),%edx
 829:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82c:	01 d0                	add    %edx,%eax
 82e:	0f b6 00             	movzbl (%eax),%eax
 831:	84 c0                	test   %al,%al
 833:	0f 85 71 fe ff ff    	jne    6aa <printf+0x22>
    }
  }
}
 839:	c9                   	leave  
 83a:	c3                   	ret    

0000083b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83b:	55                   	push   %ebp
 83c:	89 e5                	mov    %esp,%ebp
 83e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 841:	8b 45 08             	mov    0x8(%ebp),%eax
 844:	83 e8 08             	sub    $0x8,%eax
 847:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84a:	a1 88 0d 00 00       	mov    0xd88,%eax
 84f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 852:	eb 24                	jmp    878 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 85c:	77 12                	ja     870 <free+0x35>
 85e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 861:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 864:	77 24                	ja     88a <free+0x4f>
 866:	8b 45 fc             	mov    -0x4(%ebp),%eax
 869:	8b 00                	mov    (%eax),%eax
 86b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 86e:	77 1a                	ja     88a <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 870:	8b 45 fc             	mov    -0x4(%ebp),%eax
 873:	8b 00                	mov    (%eax),%eax
 875:	89 45 fc             	mov    %eax,-0x4(%ebp)
 878:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 87e:	76 d4                	jbe    854 <free+0x19>
 880:	8b 45 fc             	mov    -0x4(%ebp),%eax
 883:	8b 00                	mov    (%eax),%eax
 885:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 888:	76 ca                	jbe    854 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 88a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88d:	8b 40 04             	mov    0x4(%eax),%eax
 890:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 897:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89a:	01 c2                	add    %eax,%edx
 89c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89f:	8b 00                	mov    (%eax),%eax
 8a1:	39 c2                	cmp    %eax,%edx
 8a3:	75 24                	jne    8c9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a8:	8b 50 04             	mov    0x4(%eax),%edx
 8ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ae:	8b 00                	mov    (%eax),%eax
 8b0:	8b 40 04             	mov    0x4(%eax),%eax
 8b3:	01 c2                	add    %eax,%edx
 8b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8be:	8b 00                	mov    (%eax),%eax
 8c0:	8b 10                	mov    (%eax),%edx
 8c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c5:	89 10                	mov    %edx,(%eax)
 8c7:	eb 0a                	jmp    8d3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cc:	8b 10                	mov    (%eax),%edx
 8ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d6:	8b 40 04             	mov    0x4(%eax),%eax
 8d9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e3:	01 d0                	add    %edx,%eax
 8e5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e8:	75 20                	jne    90a <free+0xcf>
    p->s.size += bp->s.size;
 8ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ed:	8b 50 04             	mov    0x4(%eax),%edx
 8f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f3:	8b 40 04             	mov    0x4(%eax),%eax
 8f6:	01 c2                	add    %eax,%edx
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 901:	8b 10                	mov    (%eax),%edx
 903:	8b 45 fc             	mov    -0x4(%ebp),%eax
 906:	89 10                	mov    %edx,(%eax)
 908:	eb 08                	jmp    912 <free+0xd7>
  } else
    p->s.ptr = bp;
 90a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 910:	89 10                	mov    %edx,(%eax)
  freep = p;
 912:	8b 45 fc             	mov    -0x4(%ebp),%eax
 915:	a3 88 0d 00 00       	mov    %eax,0xd88
}
 91a:	c9                   	leave  
 91b:	c3                   	ret    

0000091c <morecore>:

static Header*
morecore(uint nu)
{
 91c:	55                   	push   %ebp
 91d:	89 e5                	mov    %esp,%ebp
 91f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 922:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 929:	77 07                	ja     932 <morecore+0x16>
    nu = 4096;
 92b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 932:	8b 45 08             	mov    0x8(%ebp),%eax
 935:	c1 e0 03             	shl    $0x3,%eax
 938:	89 04 24             	mov    %eax,(%esp)
 93b:	e8 40 fc ff ff       	call   580 <sbrk>
 940:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 943:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 947:	75 07                	jne    950 <morecore+0x34>
    return 0;
 949:	b8 00 00 00 00       	mov    $0x0,%eax
 94e:	eb 22                	jmp    972 <morecore+0x56>
  hp = (Header*)p;
 950:	8b 45 f4             	mov    -0xc(%ebp),%eax
 953:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 956:	8b 45 f0             	mov    -0x10(%ebp),%eax
 959:	8b 55 08             	mov    0x8(%ebp),%edx
 95c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 95f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 962:	83 c0 08             	add    $0x8,%eax
 965:	89 04 24             	mov    %eax,(%esp)
 968:	e8 ce fe ff ff       	call   83b <free>
  return freep;
 96d:	a1 88 0d 00 00       	mov    0xd88,%eax
}
 972:	c9                   	leave  
 973:	c3                   	ret    

00000974 <malloc>:

void*
malloc(uint nbytes)
{
 974:	55                   	push   %ebp
 975:	89 e5                	mov    %esp,%ebp
 977:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 97a:	8b 45 08             	mov    0x8(%ebp),%eax
 97d:	83 c0 07             	add    $0x7,%eax
 980:	c1 e8 03             	shr    $0x3,%eax
 983:	83 c0 01             	add    $0x1,%eax
 986:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 989:	a1 88 0d 00 00       	mov    0xd88,%eax
 98e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 991:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 995:	75 23                	jne    9ba <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 997:	c7 45 f0 80 0d 00 00 	movl   $0xd80,-0x10(%ebp)
 99e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a1:	a3 88 0d 00 00       	mov    %eax,0xd88
 9a6:	a1 88 0d 00 00       	mov    0xd88,%eax
 9ab:	a3 80 0d 00 00       	mov    %eax,0xd80
    base.s.size = 0;
 9b0:	c7 05 84 0d 00 00 00 	movl   $0x0,0xd84
 9b7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bd:	8b 00                	mov    (%eax),%eax
 9bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c5:	8b 40 04             	mov    0x4(%eax),%eax
 9c8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9cb:	72 4d                	jb     a1a <malloc+0xa6>
      if(p->s.size == nunits)
 9cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d0:	8b 40 04             	mov    0x4(%eax),%eax
 9d3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9d6:	75 0c                	jne    9e4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9db:	8b 10                	mov    (%eax),%edx
 9dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e0:	89 10                	mov    %edx,(%eax)
 9e2:	eb 26                	jmp    a0a <malloc+0x96>
      else {
        p->s.size -= nunits;
 9e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e7:	8b 40 04             	mov    0x4(%eax),%eax
 9ea:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9ed:	89 c2                	mov    %eax,%edx
 9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f8:	8b 40 04             	mov    0x4(%eax),%eax
 9fb:	c1 e0 03             	shl    $0x3,%eax
 9fe:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a04:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a07:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0d:	a3 88 0d 00 00       	mov    %eax,0xd88
      return (void*)(p + 1);
 a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a15:	83 c0 08             	add    $0x8,%eax
 a18:	eb 38                	jmp    a52 <malloc+0xde>
    }
    if(p == freep)
 a1a:	a1 88 0d 00 00       	mov    0xd88,%eax
 a1f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a22:	75 1b                	jne    a3f <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a24:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a27:	89 04 24             	mov    %eax,(%esp)
 a2a:	e8 ed fe ff ff       	call   91c <morecore>
 a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a36:	75 07                	jne    a3f <malloc+0xcb>
        return 0;
 a38:	b8 00 00 00 00       	mov    $0x0,%eax
 a3d:	eb 13                	jmp    a52 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a48:	8b 00                	mov    (%eax),%eax
 a4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 a4d:	e9 70 ff ff ff       	jmp    9c2 <malloc+0x4e>
}
 a52:	c9                   	leave  
 a53:	c3                   	ret    
