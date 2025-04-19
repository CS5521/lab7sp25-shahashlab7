
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 94 09 00 	movl   $0x994,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 a3 05 00 00       	call   5c6 <printf>
    exit();
  23:	e8 0e 04 00 00       	call   436 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 52 04 00 00       	call   496 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 a7 09 00 	movl   $0x9a7,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 52 05 00 00       	call   5c6 <printf>
  exit();
  74:	e8 bd 03 00 00       	call   436 <exit>

00000079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	57                   	push   %edi
  7d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  81:	8b 55 10             	mov    0x10(%ebp),%edx
  84:	8b 45 0c             	mov    0xc(%ebp),%eax
  87:	89 cb                	mov    %ecx,%ebx
  89:	89 df                	mov    %ebx,%edi
  8b:	89 d1                	mov    %edx,%ecx
  8d:	fc                   	cld    
  8e:	f3 aa                	rep stos %al,%es:(%edi)
  90:	89 ca                	mov    %ecx,%edx
  92:	89 fb                	mov    %edi,%ebx
  94:	89 5d 08             	mov    %ebx,0x8(%ebp)
  97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9a:	5b                   	pop    %ebx
  9b:	5f                   	pop    %edi
  9c:	5d                   	pop    %ebp
  9d:	c3                   	ret    

0000009e <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	57                   	push   %edi
  a2:	56                   	push   %esi
  a3:	53                   	push   %ebx
  a4:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
  aa:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
  b0:	89 04 24             	mov    %eax,(%esp)
  b3:	e8 1e 04 00 00       	call   4d6 <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
  b8:	c7 44 24 04 bc 09 00 	movl   $0x9bc,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 fa 04 00 00       	call   5c6 <printf>
    for (i = 0; i < NPROC; i++) {
  cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  d3:	e9 06 01 00 00       	jmp    1de <ps+0x140>
        if (ptable[i].inuse) {
  d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  db:	89 d0                	mov    %edx,%eax
  dd:	c1 e0 03             	shl    $0x3,%eax
  e0:	01 d0                	add    %edx,%eax
  e2:	c1 e0 02             	shl    $0x2,%eax
  e5:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  e8:	01 d8                	add    %ebx,%eax
  ea:	2d 08 09 00 00       	sub    $0x908,%eax
  ef:	8b 00                	mov    (%eax),%eax
  f1:	85 c0                	test   %eax,%eax
  f3:	0f 84 e1 00 00 00    	je     1da <ps+0x13c>
            char stat = '?';
  f9:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
  fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 100:	89 d0                	mov    %edx,%eax
 102:	c1 e0 03             	shl    $0x3,%eax
 105:	01 d0                	add    %edx,%eax
 107:	c1 e0 02             	shl    $0x2,%eax
 10a:	8d 75 e8             	lea    -0x18(%ebp),%esi
 10d:	01 f0                	add    %esi,%eax
 10f:	2d e8 08 00 00       	sub    $0x8e8,%eax
 114:	0f b6 00             	movzbl (%eax),%eax
 117:	0f be c0             	movsbl %al,%eax
 11a:	83 f8 05             	cmp    $0x5,%eax
 11d:	77 27                	ja     146 <ps+0xa8>
 11f:	8b 04 85 e8 09 00 00 	mov    0x9e8(,%eax,4),%eax
 126:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
 128:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
 12c:	eb 1c                	jmp    14a <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
 12e:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 132:	eb 16                	jmp    14a <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
 134:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
 138:	eb 10                	jmp    14a <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
 13a:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
 13e:	eb 0a                	jmp    14a <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
 140:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
 144:	eb 04                	jmp    14a <ps+0xac>
                default: stat = '?';
 146:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
 14a:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
 150:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 153:	89 d0                	mov    %edx,%eax
 155:	c1 e0 03             	shl    $0x3,%eax
 158:	01 d0                	add    %edx,%eax
 15a:	c1 e0 02             	shl    $0x2,%eax
 15d:	83 c0 10             	add    $0x10,%eax
 160:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 163:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 167:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 16a:	89 d0                	mov    %edx,%eax
 16c:	c1 e0 03             	shl    $0x3,%eax
 16f:	01 d0                	add    %edx,%eax
 171:	c1 e0 02             	shl    $0x2,%eax
 174:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 177:	01 c8                	add    %ecx,%eax
 179:	2d fc 08 00 00       	sub    $0x8fc,%eax
 17e:	8b 18                	mov    (%eax),%ebx
 180:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 183:	89 d0                	mov    %edx,%eax
 185:	c1 e0 03             	shl    $0x3,%eax
 188:	01 d0                	add    %edx,%eax
 18a:	c1 e0 02             	shl    $0x2,%eax
 18d:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 190:	01 c8                	add    %ecx,%eax
 192:	2d 04 09 00 00       	sub    $0x904,%eax
 197:	8b 08                	mov    (%eax),%ecx
 199:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 19c:	89 d0                	mov    %edx,%eax
 19e:	c1 e0 03             	shl    $0x3,%eax
 1a1:	01 d0                	add    %edx,%eax
 1a3:	c1 e0 02             	shl    $0x2,%eax
 1a6:	8d 55 e8             	lea    -0x18(%ebp),%edx
 1a9:	01 d0                	add    %edx,%eax
 1ab:	2d 00 09 00 00       	sub    $0x900,%eax
 1b0:	8b 00                	mov    (%eax),%eax
 1b2:	89 7c 24 18          	mov    %edi,0x18(%esp)
 1b6:	89 74 24 14          	mov    %esi,0x14(%esp)
 1ba:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 1be:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 1c2:	89 44 24 08          	mov    %eax,0x8(%esp)
 1c6:	c7 44 24 04 d5 09 00 	movl   $0x9d5,0x4(%esp)
 1cd:	00 
 1ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d5:	e8 ec 03 00 00       	call   5c6 <printf>
    for (i = 0; i < NPROC; i++) {
 1da:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 1de:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 1e2:	0f 8e f0 fe ff ff    	jle    d8 <ps+0x3a>
        }
    }
}
 1e8:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 1ee:	5b                   	pop    %ebx
 1ef:	5e                   	pop    %esi
 1f0:	5f                   	pop    %edi
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    

000001f3 <strcpy>:


char*
strcpy(char *s, const char *t)
{
 1f3:	55                   	push   %ebp
 1f4:	89 e5                	mov    %esp,%ebp
 1f6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ff:	90                   	nop
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	8d 50 01             	lea    0x1(%eax),%edx
 206:	89 55 08             	mov    %edx,0x8(%ebp)
 209:	8b 55 0c             	mov    0xc(%ebp),%edx
 20c:	8d 4a 01             	lea    0x1(%edx),%ecx
 20f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 212:	0f b6 12             	movzbl (%edx),%edx
 215:	88 10                	mov    %dl,(%eax)
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	84 c0                	test   %al,%al
 21c:	75 e2                	jne    200 <strcpy+0xd>
    ;
  return os;
 21e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 221:	c9                   	leave  
 222:	c3                   	ret    

00000223 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 223:	55                   	push   %ebp
 224:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 226:	eb 08                	jmp    230 <strcmp+0xd>
    p++, q++;
 228:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 22c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	84 c0                	test   %al,%al
 238:	74 10                	je     24a <strcmp+0x27>
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 10             	movzbl (%eax),%edx
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	38 c2                	cmp    %al,%dl
 248:	74 de                	je     228 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	0f b6 d0             	movzbl %al,%edx
 253:	8b 45 0c             	mov    0xc(%ebp),%eax
 256:	0f b6 00             	movzbl (%eax),%eax
 259:	0f b6 c0             	movzbl %al,%eax
 25c:	29 c2                	sub    %eax,%edx
 25e:	89 d0                	mov    %edx,%eax
}
 260:	5d                   	pop    %ebp
 261:	c3                   	ret    

00000262 <strlen>:

uint
strlen(const char *s)
{
 262:	55                   	push   %ebp
 263:	89 e5                	mov    %esp,%ebp
 265:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 26f:	eb 04                	jmp    275 <strlen+0x13>
 271:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 275:	8b 55 fc             	mov    -0x4(%ebp),%edx
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	01 d0                	add    %edx,%eax
 27d:	0f b6 00             	movzbl (%eax),%eax
 280:	84 c0                	test   %al,%al
 282:	75 ed                	jne    271 <strlen+0xf>
    ;
  return n;
 284:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 287:	c9                   	leave  
 288:	c3                   	ret    

00000289 <memset>:

void*
memset(void *dst, int c, uint n)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 28f:	8b 45 10             	mov    0x10(%ebp),%eax
 292:	89 44 24 08          	mov    %eax,0x8(%esp)
 296:	8b 45 0c             	mov    0xc(%ebp),%eax
 299:	89 44 24 04          	mov    %eax,0x4(%esp)
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	89 04 24             	mov    %eax,(%esp)
 2a3:	e8 d1 fd ff ff       	call   79 <stosb>
  return dst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ab:	c9                   	leave  
 2ac:	c3                   	ret    

000002ad <strchr>:

char*
strchr(const char *s, char c)
{
 2ad:	55                   	push   %ebp
 2ae:	89 e5                	mov    %esp,%ebp
 2b0:	83 ec 04             	sub    $0x4,%esp
 2b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b6:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2b9:	eb 14                	jmp    2cf <strchr+0x22>
    if(*s == c)
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2c4:	75 05                	jne    2cb <strchr+0x1e>
      return (char*)s;
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	eb 13                	jmp    2de <strchr+0x31>
  for(; *s; s++)
 2cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	0f b6 00             	movzbl (%eax),%eax
 2d5:	84 c0                	test   %al,%al
 2d7:	75 e2                	jne    2bb <strchr+0xe>
  return 0;
 2d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2de:	c9                   	leave  
 2df:	c3                   	ret    

000002e0 <gets>:

char*
gets(char *buf, int max)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2ed:	eb 4c                	jmp    33b <gets+0x5b>
    cc = read(0, &c, 1);
 2ef:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2f6:	00 
 2f7:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 2fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 305:	e8 44 01 00 00       	call   44e <read>
 30a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 30d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 311:	7f 02                	jg     315 <gets+0x35>
      break;
 313:	eb 31                	jmp    346 <gets+0x66>
    buf[i++] = c;
 315:	8b 45 f4             	mov    -0xc(%ebp),%eax
 318:	8d 50 01             	lea    0x1(%eax),%edx
 31b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 31e:	89 c2                	mov    %eax,%edx
 320:	8b 45 08             	mov    0x8(%ebp),%eax
 323:	01 c2                	add    %eax,%edx
 325:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 329:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 32b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32f:	3c 0a                	cmp    $0xa,%al
 331:	74 13                	je     346 <gets+0x66>
 333:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 337:	3c 0d                	cmp    $0xd,%al
 339:	74 0b                	je     346 <gets+0x66>
  for(i=0; i+1 < max; ){
 33b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33e:	83 c0 01             	add    $0x1,%eax
 341:	3b 45 0c             	cmp    0xc(%ebp),%eax
 344:	7c a9                	jl     2ef <gets+0xf>
      break;
  }
  buf[i] = '\0';
 346:	8b 55 f4             	mov    -0xc(%ebp),%edx
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	01 d0                	add    %edx,%eax
 34e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 351:	8b 45 08             	mov    0x8(%ebp),%eax
}
 354:	c9                   	leave  
 355:	c3                   	ret    

00000356 <stat>:

int
stat(const char *n, struct stat *st)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
 359:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 363:	00 
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	89 04 24             	mov    %eax,(%esp)
 36a:	e8 07 01 00 00       	call   476 <open>
 36f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 376:	79 07                	jns    37f <stat+0x29>
    return -1;
 378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 37d:	eb 23                	jmp    3a2 <stat+0x4c>
  r = fstat(fd, st);
 37f:	8b 45 0c             	mov    0xc(%ebp),%eax
 382:	89 44 24 04          	mov    %eax,0x4(%esp)
 386:	8b 45 f4             	mov    -0xc(%ebp),%eax
 389:	89 04 24             	mov    %eax,(%esp)
 38c:	e8 fd 00 00 00       	call   48e <fstat>
 391:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 394:	8b 45 f4             	mov    -0xc(%ebp),%eax
 397:	89 04 24             	mov    %eax,(%esp)
 39a:	e8 bf 00 00 00       	call   45e <close>
  return r;
 39f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3a2:	c9                   	leave  
 3a3:	c3                   	ret    

000003a4 <atoi>:

int
atoi(const char *s)
{
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3b1:	eb 25                	jmp    3d8 <atoi+0x34>
    n = n*10 + *s++ - '0';
 3b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3b6:	89 d0                	mov    %edx,%eax
 3b8:	c1 e0 02             	shl    $0x2,%eax
 3bb:	01 d0                	add    %edx,%eax
 3bd:	01 c0                	add    %eax,%eax
 3bf:	89 c1                	mov    %eax,%ecx
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	8d 50 01             	lea    0x1(%eax),%edx
 3c7:	89 55 08             	mov    %edx,0x8(%ebp)
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	0f be c0             	movsbl %al,%eax
 3d0:	01 c8                	add    %ecx,%eax
 3d2:	83 e8 30             	sub    $0x30,%eax
 3d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3d8:	8b 45 08             	mov    0x8(%ebp),%eax
 3db:	0f b6 00             	movzbl (%eax),%eax
 3de:	3c 2f                	cmp    $0x2f,%al
 3e0:	7e 0a                	jle    3ec <atoi+0x48>
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	0f b6 00             	movzbl (%eax),%eax
 3e8:	3c 39                	cmp    $0x39,%al
 3ea:	7e c7                	jle    3b3 <atoi+0xf>
  return n;
 3ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ef:	c9                   	leave  
 3f0:	c3                   	ret    

000003f1 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f1:	55                   	push   %ebp
 3f2:	89 e5                	mov    %esp,%ebp
 3f4:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 400:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 403:	eb 17                	jmp    41c <memmove+0x2b>
    *dst++ = *src++;
 405:	8b 45 fc             	mov    -0x4(%ebp),%eax
 408:	8d 50 01             	lea    0x1(%eax),%edx
 40b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 40e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 411:	8d 4a 01             	lea    0x1(%edx),%ecx
 414:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 417:	0f b6 12             	movzbl (%edx),%edx
 41a:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 41c:	8b 45 10             	mov    0x10(%ebp),%eax
 41f:	8d 50 ff             	lea    -0x1(%eax),%edx
 422:	89 55 10             	mov    %edx,0x10(%ebp)
 425:	85 c0                	test   %eax,%eax
 427:	7f dc                	jg     405 <memmove+0x14>
  return vdst;
 429:	8b 45 08             	mov    0x8(%ebp),%eax
}
 42c:	c9                   	leave  
 42d:	c3                   	ret    

0000042e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42e:	b8 01 00 00 00       	mov    $0x1,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <exit>:
SYSCALL(exit)
 436:	b8 02 00 00 00       	mov    $0x2,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <wait>:
SYSCALL(wait)
 43e:	b8 03 00 00 00       	mov    $0x3,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <pipe>:
SYSCALL(pipe)
 446:	b8 04 00 00 00       	mov    $0x4,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <read>:
SYSCALL(read)
 44e:	b8 05 00 00 00       	mov    $0x5,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <write>:
SYSCALL(write)
 456:	b8 10 00 00 00       	mov    $0x10,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <close>:
SYSCALL(close)
 45e:	b8 15 00 00 00       	mov    $0x15,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <kill>:
SYSCALL(kill)
 466:	b8 06 00 00 00       	mov    $0x6,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <exec>:
SYSCALL(exec)
 46e:	b8 07 00 00 00       	mov    $0x7,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <open>:
SYSCALL(open)
 476:	b8 0f 00 00 00       	mov    $0xf,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <mknod>:
SYSCALL(mknod)
 47e:	b8 11 00 00 00       	mov    $0x11,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <unlink>:
SYSCALL(unlink)
 486:	b8 12 00 00 00       	mov    $0x12,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <fstat>:
SYSCALL(fstat)
 48e:	b8 08 00 00 00       	mov    $0x8,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <link>:
SYSCALL(link)
 496:	b8 13 00 00 00       	mov    $0x13,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <mkdir>:
SYSCALL(mkdir)
 49e:	b8 14 00 00 00       	mov    $0x14,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <chdir>:
SYSCALL(chdir)
 4a6:	b8 09 00 00 00       	mov    $0x9,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <dup>:
SYSCALL(dup)
 4ae:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <getpid>:
SYSCALL(getpid)
 4b6:	b8 0b 00 00 00       	mov    $0xb,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <sbrk>:
SYSCALL(sbrk)
 4be:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <sleep>:
SYSCALL(sleep)
 4c6:	b8 0d 00 00 00       	mov    $0xd,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <uptime>:
SYSCALL(uptime)
 4ce:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <getpinfo>:
SYSCALL(getpinfo)
 4d6:	b8 16 00 00 00       	mov    $0x16,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <settickets>:
SYSCALL(settickets)
 4de:	b8 17 00 00 00       	mov    $0x17,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e6:	55                   	push   %ebp
 4e7:	89 e5                	mov    %esp,%ebp
 4e9:	83 ec 18             	sub    $0x18,%esp
 4ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ef:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4f2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f9:	00 
 4fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 501:	8b 45 08             	mov    0x8(%ebp),%eax
 504:	89 04 24             	mov    %eax,(%esp)
 507:	e8 4a ff ff ff       	call   456 <write>
}
 50c:	c9                   	leave  
 50d:	c3                   	ret    

0000050e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 50e:	55                   	push   %ebp
 50f:	89 e5                	mov    %esp,%ebp
 511:	56                   	push   %esi
 512:	53                   	push   %ebx
 513:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 516:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 51d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 521:	74 17                	je     53a <printint+0x2c>
 523:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 527:	79 11                	jns    53a <printint+0x2c>
    neg = 1;
 529:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 530:	8b 45 0c             	mov    0xc(%ebp),%eax
 533:	f7 d8                	neg    %eax
 535:	89 45 ec             	mov    %eax,-0x14(%ebp)
 538:	eb 06                	jmp    540 <printint+0x32>
  } else {
    x = xx;
 53a:	8b 45 0c             	mov    0xc(%ebp),%eax
 53d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 540:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 547:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 54a:	8d 41 01             	lea    0x1(%ecx),%eax
 54d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 550:	8b 5d 10             	mov    0x10(%ebp),%ebx
 553:	8b 45 ec             	mov    -0x14(%ebp),%eax
 556:	ba 00 00 00 00       	mov    $0x0,%edx
 55b:	f7 f3                	div    %ebx
 55d:	89 d0                	mov    %edx,%eax
 55f:	0f b6 80 7c 0c 00 00 	movzbl 0xc7c(%eax),%eax
 566:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 56a:	8b 75 10             	mov    0x10(%ebp),%esi
 56d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 570:	ba 00 00 00 00       	mov    $0x0,%edx
 575:	f7 f6                	div    %esi
 577:	89 45 ec             	mov    %eax,-0x14(%ebp)
 57a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 57e:	75 c7                	jne    547 <printint+0x39>
  if(neg)
 580:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 584:	74 10                	je     596 <printint+0x88>
    buf[i++] = '-';
 586:	8b 45 f4             	mov    -0xc(%ebp),%eax
 589:	8d 50 01             	lea    0x1(%eax),%edx
 58c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 58f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 594:	eb 1f                	jmp    5b5 <printint+0xa7>
 596:	eb 1d                	jmp    5b5 <printint+0xa7>
    putc(fd, buf[i]);
 598:	8d 55 dc             	lea    -0x24(%ebp),%edx
 59b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59e:	01 d0                	add    %edx,%eax
 5a0:	0f b6 00             	movzbl (%eax),%eax
 5a3:	0f be c0             	movsbl %al,%eax
 5a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5aa:	8b 45 08             	mov    0x8(%ebp),%eax
 5ad:	89 04 24             	mov    %eax,(%esp)
 5b0:	e8 31 ff ff ff       	call   4e6 <putc>
  while(--i >= 0)
 5b5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5bd:	79 d9                	jns    598 <printint+0x8a>
}
 5bf:	83 c4 30             	add    $0x30,%esp
 5c2:	5b                   	pop    %ebx
 5c3:	5e                   	pop    %esi
 5c4:	5d                   	pop    %ebp
 5c5:	c3                   	ret    

000005c6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5c6:	55                   	push   %ebp
 5c7:	89 e5                	mov    %esp,%ebp
 5c9:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5d3:	8d 45 0c             	lea    0xc(%ebp),%eax
 5d6:	83 c0 04             	add    $0x4,%eax
 5d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5e3:	e9 7c 01 00 00       	jmp    764 <printf+0x19e>
    c = fmt[i] & 0xff;
 5e8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ee:	01 d0                	add    %edx,%eax
 5f0:	0f b6 00             	movzbl (%eax),%eax
 5f3:	0f be c0             	movsbl %al,%eax
 5f6:	25 ff 00 00 00       	and    $0xff,%eax
 5fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 602:	75 2c                	jne    630 <printf+0x6a>
      if(c == '%'){
 604:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 608:	75 0c                	jne    616 <printf+0x50>
        state = '%';
 60a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 611:	e9 4a 01 00 00       	jmp    760 <printf+0x19a>
      } else {
        putc(fd, c);
 616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 619:	0f be c0             	movsbl %al,%eax
 61c:	89 44 24 04          	mov    %eax,0x4(%esp)
 620:	8b 45 08             	mov    0x8(%ebp),%eax
 623:	89 04 24             	mov    %eax,(%esp)
 626:	e8 bb fe ff ff       	call   4e6 <putc>
 62b:	e9 30 01 00 00       	jmp    760 <printf+0x19a>
      }
    } else if(state == '%'){
 630:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 634:	0f 85 26 01 00 00    	jne    760 <printf+0x19a>
      if(c == 'd'){
 63a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 63e:	75 2d                	jne    66d <printf+0xa7>
        printint(fd, *ap, 10, 1);
 640:	8b 45 e8             	mov    -0x18(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 64c:	00 
 64d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 654:	00 
 655:	89 44 24 04          	mov    %eax,0x4(%esp)
 659:	8b 45 08             	mov    0x8(%ebp),%eax
 65c:	89 04 24             	mov    %eax,(%esp)
 65f:	e8 aa fe ff ff       	call   50e <printint>
        ap++;
 664:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 668:	e9 ec 00 00 00       	jmp    759 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 66d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 671:	74 06                	je     679 <printf+0xb3>
 673:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 677:	75 2d                	jne    6a6 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 679:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67c:	8b 00                	mov    (%eax),%eax
 67e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 685:	00 
 686:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 68d:	00 
 68e:	89 44 24 04          	mov    %eax,0x4(%esp)
 692:	8b 45 08             	mov    0x8(%ebp),%eax
 695:	89 04 24             	mov    %eax,(%esp)
 698:	e8 71 fe ff ff       	call   50e <printint>
        ap++;
 69d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a1:	e9 b3 00 00 00       	jmp    759 <printf+0x193>
      } else if(c == 's'){
 6a6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6aa:	75 45                	jne    6f1 <printf+0x12b>
        s = (char*)*ap;
 6ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6af:	8b 00                	mov    (%eax),%eax
 6b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6bc:	75 09                	jne    6c7 <printf+0x101>
          s = "(null)";
 6be:	c7 45 f4 00 0a 00 00 	movl   $0xa00,-0xc(%ebp)
        while(*s != 0){
 6c5:	eb 1e                	jmp    6e5 <printf+0x11f>
 6c7:	eb 1c                	jmp    6e5 <printf+0x11f>
          putc(fd, *s);
 6c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6cc:	0f b6 00             	movzbl (%eax),%eax
 6cf:	0f be c0             	movsbl %al,%eax
 6d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d6:	8b 45 08             	mov    0x8(%ebp),%eax
 6d9:	89 04 24             	mov    %eax,(%esp)
 6dc:	e8 05 fe ff ff       	call   4e6 <putc>
          s++;
 6e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e8:	0f b6 00             	movzbl (%eax),%eax
 6eb:	84 c0                	test   %al,%al
 6ed:	75 da                	jne    6c9 <printf+0x103>
 6ef:	eb 68                	jmp    759 <printf+0x193>
        }
      } else if(c == 'c'){
 6f1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6f5:	75 1d                	jne    714 <printf+0x14e>
        putc(fd, *ap);
 6f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	0f be c0             	movsbl %al,%eax
 6ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	89 04 24             	mov    %eax,(%esp)
 709:	e8 d8 fd ff ff       	call   4e6 <putc>
        ap++;
 70e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 712:	eb 45                	jmp    759 <printf+0x193>
      } else if(c == '%'){
 714:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 718:	75 17                	jne    731 <printf+0x16b>
        putc(fd, c);
 71a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71d:	0f be c0             	movsbl %al,%eax
 720:	89 44 24 04          	mov    %eax,0x4(%esp)
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	89 04 24             	mov    %eax,(%esp)
 72a:	e8 b7 fd ff ff       	call   4e6 <putc>
 72f:	eb 28                	jmp    759 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 731:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 738:	00 
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	89 04 24             	mov    %eax,(%esp)
 73f:	e8 a2 fd ff ff       	call   4e6 <putc>
        putc(fd, c);
 744:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 747:	0f be c0             	movsbl %al,%eax
 74a:	89 44 24 04          	mov    %eax,0x4(%esp)
 74e:	8b 45 08             	mov    0x8(%ebp),%eax
 751:	89 04 24             	mov    %eax,(%esp)
 754:	e8 8d fd ff ff       	call   4e6 <putc>
      }
      state = 0;
 759:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 760:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 764:	8b 55 0c             	mov    0xc(%ebp),%edx
 767:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76a:	01 d0                	add    %edx,%eax
 76c:	0f b6 00             	movzbl (%eax),%eax
 76f:	84 c0                	test   %al,%al
 771:	0f 85 71 fe ff ff    	jne    5e8 <printf+0x22>
    }
  }
}
 777:	c9                   	leave  
 778:	c3                   	ret    

00000779 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 779:	55                   	push   %ebp
 77a:	89 e5                	mov    %esp,%ebp
 77c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77f:	8b 45 08             	mov    0x8(%ebp),%eax
 782:	83 e8 08             	sub    $0x8,%eax
 785:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 788:	a1 98 0c 00 00       	mov    0xc98,%eax
 78d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 790:	eb 24                	jmp    7b6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79a:	77 12                	ja     7ae <free+0x35>
 79c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a2:	77 24                	ja     7c8 <free+0x4f>
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ac:	77 1a                	ja     7c8 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b1:	8b 00                	mov    (%eax),%eax
 7b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bc:	76 d4                	jbe    792 <free+0x19>
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 00                	mov    (%eax),%eax
 7c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c6:	76 ca                	jbe    792 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cb:	8b 40 04             	mov    0x4(%eax),%eax
 7ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d8:	01 c2                	add    %eax,%edx
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	8b 00                	mov    (%eax),%eax
 7df:	39 c2                	cmp    %eax,%edx
 7e1:	75 24                	jne    807 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	8b 50 04             	mov    0x4(%eax),%edx
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	8b 40 04             	mov    0x4(%eax),%eax
 7f1:	01 c2                	add    %eax,%edx
 7f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	8b 10                	mov    (%eax),%edx
 800:	8b 45 f8             	mov    -0x8(%ebp),%eax
 803:	89 10                	mov    %edx,(%eax)
 805:	eb 0a                	jmp    811 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	8b 10                	mov    (%eax),%edx
 80c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 81e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 821:	01 d0                	add    %edx,%eax
 823:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 826:	75 20                	jne    848 <free+0xcf>
    p->s.size += bp->s.size;
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	8b 50 04             	mov    0x4(%eax),%edx
 82e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 831:	8b 40 04             	mov    0x4(%eax),%eax
 834:	01 c2                	add    %eax,%edx
 836:	8b 45 fc             	mov    -0x4(%ebp),%eax
 839:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 83c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83f:	8b 10                	mov    (%eax),%edx
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
 844:	89 10                	mov    %edx,(%eax)
 846:	eb 08                	jmp    850 <free+0xd7>
  } else
    p->s.ptr = bp;
 848:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 84e:	89 10                	mov    %edx,(%eax)
  freep = p;
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	a3 98 0c 00 00       	mov    %eax,0xc98
}
 858:	c9                   	leave  
 859:	c3                   	ret    

0000085a <morecore>:

static Header*
morecore(uint nu)
{
 85a:	55                   	push   %ebp
 85b:	89 e5                	mov    %esp,%ebp
 85d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 860:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 867:	77 07                	ja     870 <morecore+0x16>
    nu = 4096;
 869:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 870:	8b 45 08             	mov    0x8(%ebp),%eax
 873:	c1 e0 03             	shl    $0x3,%eax
 876:	89 04 24             	mov    %eax,(%esp)
 879:	e8 40 fc ff ff       	call   4be <sbrk>
 87e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 881:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 885:	75 07                	jne    88e <morecore+0x34>
    return 0;
 887:	b8 00 00 00 00       	mov    $0x0,%eax
 88c:	eb 22                	jmp    8b0 <morecore+0x56>
  hp = (Header*)p;
 88e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 891:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 894:	8b 45 f0             	mov    -0x10(%ebp),%eax
 897:	8b 55 08             	mov    0x8(%ebp),%edx
 89a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 89d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a0:	83 c0 08             	add    $0x8,%eax
 8a3:	89 04 24             	mov    %eax,(%esp)
 8a6:	e8 ce fe ff ff       	call   779 <free>
  return freep;
 8ab:	a1 98 0c 00 00       	mov    0xc98,%eax
}
 8b0:	c9                   	leave  
 8b1:	c3                   	ret    

000008b2 <malloc>:

void*
malloc(uint nbytes)
{
 8b2:	55                   	push   %ebp
 8b3:	89 e5                	mov    %esp,%ebp
 8b5:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b8:	8b 45 08             	mov    0x8(%ebp),%eax
 8bb:	83 c0 07             	add    $0x7,%eax
 8be:	c1 e8 03             	shr    $0x3,%eax
 8c1:	83 c0 01             	add    $0x1,%eax
 8c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8c7:	a1 98 0c 00 00       	mov    0xc98,%eax
 8cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8d3:	75 23                	jne    8f8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8d5:	c7 45 f0 90 0c 00 00 	movl   $0xc90,-0x10(%ebp)
 8dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8df:	a3 98 0c 00 00       	mov    %eax,0xc98
 8e4:	a1 98 0c 00 00       	mov    0xc98,%eax
 8e9:	a3 90 0c 00 00       	mov    %eax,0xc90
    base.s.size = 0;
 8ee:	c7 05 94 0c 00 00 00 	movl   $0x0,0xc94
 8f5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fb:	8b 00                	mov    (%eax),%eax
 8fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	8b 40 04             	mov    0x4(%eax),%eax
 906:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 909:	72 4d                	jb     958 <malloc+0xa6>
      if(p->s.size == nunits)
 90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90e:	8b 40 04             	mov    0x4(%eax),%eax
 911:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 914:	75 0c                	jne    922 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	8b 10                	mov    (%eax),%edx
 91b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91e:	89 10                	mov    %edx,(%eax)
 920:	eb 26                	jmp    948 <malloc+0x96>
      else {
        p->s.size -= nunits;
 922:	8b 45 f4             	mov    -0xc(%ebp),%eax
 925:	8b 40 04             	mov    0x4(%eax),%eax
 928:	2b 45 ec             	sub    -0x14(%ebp),%eax
 92b:	89 c2                	mov    %eax,%edx
 92d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 930:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 933:	8b 45 f4             	mov    -0xc(%ebp),%eax
 936:	8b 40 04             	mov    0x4(%eax),%eax
 939:	c1 e0 03             	shl    $0x3,%eax
 93c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 93f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 942:	8b 55 ec             	mov    -0x14(%ebp),%edx
 945:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 948:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94b:	a3 98 0c 00 00       	mov    %eax,0xc98
      return (void*)(p + 1);
 950:	8b 45 f4             	mov    -0xc(%ebp),%eax
 953:	83 c0 08             	add    $0x8,%eax
 956:	eb 38                	jmp    990 <malloc+0xde>
    }
    if(p == freep)
 958:	a1 98 0c 00 00       	mov    0xc98,%eax
 95d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 960:	75 1b                	jne    97d <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 962:	8b 45 ec             	mov    -0x14(%ebp),%eax
 965:	89 04 24             	mov    %eax,(%esp)
 968:	e8 ed fe ff ff       	call   85a <morecore>
 96d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 970:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 974:	75 07                	jne    97d <malloc+0xcb>
        return 0;
 976:	b8 00 00 00 00       	mov    $0x0,%eax
 97b:	eb 13                	jmp    990 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 980:	89 45 f0             	mov    %eax,-0x10(%ebp)
 983:	8b 45 f4             	mov    -0xc(%ebp),%eax
 986:	8b 00                	mov    (%eax),%eax
 988:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 98b:	e9 70 ff ff ff       	jmp    900 <malloc+0x4e>
}
 990:	c9                   	leave  
 991:	c3                   	ret    
