
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 80 09 00 	movl   $0x980,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 91 05 00 00       	call   5b4 <printf>
    exit();
  23:	e8 fc 03 00 00       	call   424 <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 27                	jmp    59 <main+0x59>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 46 03 00 00       	call   392 <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 00 04 00 00       	call   454 <kill>
  for(i=1; i<argc; i++)
  54:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  59:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  60:	7c d0                	jl     32 <main+0x32>
  exit();
  62:	e8 bd 03 00 00       	call   424 <exit>

00000067 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	57                   	push   %edi
  6b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6f:	8b 55 10             	mov    0x10(%ebp),%edx
  72:	8b 45 0c             	mov    0xc(%ebp),%eax
  75:	89 cb                	mov    %ecx,%ebx
  77:	89 df                	mov    %ebx,%edi
  79:	89 d1                	mov    %edx,%ecx
  7b:	fc                   	cld    
  7c:	f3 aa                	rep stos %al,%es:(%edi)
  7e:	89 ca                	mov    %ecx,%edx
  80:	89 fb                	mov    %edi,%ebx
  82:	89 5d 08             	mov    %ebx,0x8(%ebp)
  85:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  88:	5b                   	pop    %ebx
  89:	5f                   	pop    %edi
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	57                   	push   %edi
  90:	56                   	push   %esi
  91:	53                   	push   %ebx
  92:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
  98:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
  9e:	89 04 24             	mov    %eax,(%esp)
  a1:	e8 1e 04 00 00       	call   4c4 <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
  a6:	c7 44 24 04 94 09 00 	movl   $0x994,0x4(%esp)
  ad:	00 
  ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b5:	e8 fa 04 00 00       	call   5b4 <printf>
    for (i = 0; i < NPROC; i++) {
  ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  c1:	e9 06 01 00 00       	jmp    1cc <ps+0x140>
        if (ptable[i].inuse) {
  c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  c9:	89 d0                	mov    %edx,%eax
  cb:	c1 e0 03             	shl    $0x3,%eax
  ce:	01 d0                	add    %edx,%eax
  d0:	c1 e0 02             	shl    $0x2,%eax
  d3:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  d6:	01 d8                	add    %ebx,%eax
  d8:	2d 08 09 00 00       	sub    $0x908,%eax
  dd:	8b 00                	mov    (%eax),%eax
  df:	85 c0                	test   %eax,%eax
  e1:	0f 84 e1 00 00 00    	je     1c8 <ps+0x13c>
            char stat = '?';
  e7:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
  eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  ee:	89 d0                	mov    %edx,%eax
  f0:	c1 e0 03             	shl    $0x3,%eax
  f3:	01 d0                	add    %edx,%eax
  f5:	c1 e0 02             	shl    $0x2,%eax
  f8:	8d 75 e8             	lea    -0x18(%ebp),%esi
  fb:	01 f0                	add    %esi,%eax
  fd:	2d e8 08 00 00       	sub    $0x8e8,%eax
 102:	0f b6 00             	movzbl (%eax),%eax
 105:	0f be c0             	movsbl %al,%eax
 108:	83 f8 05             	cmp    $0x5,%eax
 10b:	77 27                	ja     134 <ps+0xa8>
 10d:	8b 04 85 c0 09 00 00 	mov    0x9c0(,%eax,4),%eax
 114:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
 116:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
 11a:	eb 1c                	jmp    138 <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
 11c:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 120:	eb 16                	jmp    138 <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
 122:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
 126:	eb 10                	jmp    138 <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
 128:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
 12c:	eb 0a                	jmp    138 <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
 12e:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
 132:	eb 04                	jmp    138 <ps+0xac>
                default: stat = '?';
 134:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
 138:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
 13e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 141:	89 d0                	mov    %edx,%eax
 143:	c1 e0 03             	shl    $0x3,%eax
 146:	01 d0                	add    %edx,%eax
 148:	c1 e0 02             	shl    $0x2,%eax
 14b:	83 c0 10             	add    $0x10,%eax
 14e:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 151:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 155:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 158:	89 d0                	mov    %edx,%eax
 15a:	c1 e0 03             	shl    $0x3,%eax
 15d:	01 d0                	add    %edx,%eax
 15f:	c1 e0 02             	shl    $0x2,%eax
 162:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 165:	01 c8                	add    %ecx,%eax
 167:	2d fc 08 00 00       	sub    $0x8fc,%eax
 16c:	8b 18                	mov    (%eax),%ebx
 16e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 171:	89 d0                	mov    %edx,%eax
 173:	c1 e0 03             	shl    $0x3,%eax
 176:	01 d0                	add    %edx,%eax
 178:	c1 e0 02             	shl    $0x2,%eax
 17b:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 17e:	01 c8                	add    %ecx,%eax
 180:	2d 04 09 00 00       	sub    $0x904,%eax
 185:	8b 08                	mov    (%eax),%ecx
 187:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 18a:	89 d0                	mov    %edx,%eax
 18c:	c1 e0 03             	shl    $0x3,%eax
 18f:	01 d0                	add    %edx,%eax
 191:	c1 e0 02             	shl    $0x2,%eax
 194:	8d 55 e8             	lea    -0x18(%ebp),%edx
 197:	01 d0                	add    %edx,%eax
 199:	2d 00 09 00 00       	sub    $0x900,%eax
 19e:	8b 00                	mov    (%eax),%eax
 1a0:	89 7c 24 18          	mov    %edi,0x18(%esp)
 1a4:	89 74 24 14          	mov    %esi,0x14(%esp)
 1a8:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 1ac:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 1b0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b4:	c7 44 24 04 ad 09 00 	movl   $0x9ad,0x4(%esp)
 1bb:	00 
 1bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c3:	e8 ec 03 00 00       	call   5b4 <printf>
    for (i = 0; i < NPROC; i++) {
 1c8:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 1cc:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 1d0:	0f 8e f0 fe ff ff    	jle    c6 <ps+0x3a>
        }
    }
}
 1d6:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 1dc:	5b                   	pop    %ebx
 1dd:	5e                   	pop    %esi
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    

000001e1 <strcpy>:


char*
strcpy(char *s, const char *t)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ed:	90                   	nop
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	8d 50 01             	lea    0x1(%eax),%edx
 1f4:	89 55 08             	mov    %edx,0x8(%ebp)
 1f7:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fa:	8d 4a 01             	lea    0x1(%edx),%ecx
 1fd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 200:	0f b6 12             	movzbl (%edx),%edx
 203:	88 10                	mov    %dl,(%eax)
 205:	0f b6 00             	movzbl (%eax),%eax
 208:	84 c0                	test   %al,%al
 20a:	75 e2                	jne    1ee <strcpy+0xd>
    ;
  return os;
 20c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20f:	c9                   	leave  
 210:	c3                   	ret    

00000211 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 211:	55                   	push   %ebp
 212:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 214:	eb 08                	jmp    21e <strcmp+0xd>
    p++, q++;
 216:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	0f b6 00             	movzbl (%eax),%eax
 224:	84 c0                	test   %al,%al
 226:	74 10                	je     238 <strcmp+0x27>
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	0f b6 10             	movzbl (%eax),%edx
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	38 c2                	cmp    %al,%dl
 236:	74 de                	je     216 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	0f b6 d0             	movzbl %al,%edx
 241:	8b 45 0c             	mov    0xc(%ebp),%eax
 244:	0f b6 00             	movzbl (%eax),%eax
 247:	0f b6 c0             	movzbl %al,%eax
 24a:	29 c2                	sub    %eax,%edx
 24c:	89 d0                	mov    %edx,%eax
}
 24e:	5d                   	pop    %ebp
 24f:	c3                   	ret    

00000250 <strlen>:

uint
strlen(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 256:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25d:	eb 04                	jmp    263 <strlen+0x13>
 25f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 263:	8b 55 fc             	mov    -0x4(%ebp),%edx
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	01 d0                	add    %edx,%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	84 c0                	test   %al,%al
 270:	75 ed                	jne    25f <strlen+0xf>
    ;
  return n;
 272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 275:	c9                   	leave  
 276:	c3                   	ret    

00000277 <memset>:

void*
memset(void *dst, int c, uint n)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 27d:	8b 45 10             	mov    0x10(%ebp),%eax
 280:	89 44 24 08          	mov    %eax,0x8(%esp)
 284:	8b 45 0c             	mov    0xc(%ebp),%eax
 287:	89 44 24 04          	mov    %eax,0x4(%esp)
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	89 04 24             	mov    %eax,(%esp)
 291:	e8 d1 fd ff ff       	call   67 <stosb>
  return dst;
 296:	8b 45 08             	mov    0x8(%ebp),%eax
}
 299:	c9                   	leave  
 29a:	c3                   	ret    

0000029b <strchr>:

char*
strchr(const char *s, char c)
{
 29b:	55                   	push   %ebp
 29c:	89 e5                	mov    %esp,%ebp
 29e:	83 ec 04             	sub    $0x4,%esp
 2a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2a7:	eb 14                	jmp    2bd <strchr+0x22>
    if(*s == c)
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	0f b6 00             	movzbl (%eax),%eax
 2af:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b2:	75 05                	jne    2b9 <strchr+0x1e>
      return (char*)s;
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	eb 13                	jmp    2cc <strchr+0x31>
  for(; *s; s++)
 2b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	84 c0                	test   %al,%al
 2c5:	75 e2                	jne    2a9 <strchr+0xe>
  return 0;
 2c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2cc:	c9                   	leave  
 2cd:	c3                   	ret    

000002ce <gets>:

char*
gets(char *buf, int max)
{
 2ce:	55                   	push   %ebp
 2cf:	89 e5                	mov    %esp,%ebp
 2d1:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2db:	eb 4c                	jmp    329 <gets+0x5b>
    cc = read(0, &c, 1);
 2dd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2e4:	00 
 2e5:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2f3:	e8 44 01 00 00       	call   43c <read>
 2f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ff:	7f 02                	jg     303 <gets+0x35>
      break;
 301:	eb 31                	jmp    334 <gets+0x66>
    buf[i++] = c;
 303:	8b 45 f4             	mov    -0xc(%ebp),%eax
 306:	8d 50 01             	lea    0x1(%eax),%edx
 309:	89 55 f4             	mov    %edx,-0xc(%ebp)
 30c:	89 c2                	mov    %eax,%edx
 30e:	8b 45 08             	mov    0x8(%ebp),%eax
 311:	01 c2                	add    %eax,%edx
 313:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 317:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 319:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31d:	3c 0a                	cmp    $0xa,%al
 31f:	74 13                	je     334 <gets+0x66>
 321:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 325:	3c 0d                	cmp    $0xd,%al
 327:	74 0b                	je     334 <gets+0x66>
  for(i=0; i+1 < max; ){
 329:	8b 45 f4             	mov    -0xc(%ebp),%eax
 32c:	83 c0 01             	add    $0x1,%eax
 32f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 332:	7c a9                	jl     2dd <gets+0xf>
      break;
  }
  buf[i] = '\0';
 334:	8b 55 f4             	mov    -0xc(%ebp),%edx
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	01 d0                	add    %edx,%eax
 33c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 342:	c9                   	leave  
 343:	c3                   	ret    

00000344 <stat>:

int
stat(const char *n, struct stat *st)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 34a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 351:	00 
 352:	8b 45 08             	mov    0x8(%ebp),%eax
 355:	89 04 24             	mov    %eax,(%esp)
 358:	e8 07 01 00 00       	call   464 <open>
 35d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 360:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 364:	79 07                	jns    36d <stat+0x29>
    return -1;
 366:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 36b:	eb 23                	jmp    390 <stat+0x4c>
  r = fstat(fd, st);
 36d:	8b 45 0c             	mov    0xc(%ebp),%eax
 370:	89 44 24 04          	mov    %eax,0x4(%esp)
 374:	8b 45 f4             	mov    -0xc(%ebp),%eax
 377:	89 04 24             	mov    %eax,(%esp)
 37a:	e8 fd 00 00 00       	call   47c <fstat>
 37f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 382:	8b 45 f4             	mov    -0xc(%ebp),%eax
 385:	89 04 24             	mov    %eax,(%esp)
 388:	e8 bf 00 00 00       	call   44c <close>
  return r;
 38d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 390:	c9                   	leave  
 391:	c3                   	ret    

00000392 <atoi>:

int
atoi(const char *s)
{
 392:	55                   	push   %ebp
 393:	89 e5                	mov    %esp,%ebp
 395:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 398:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 39f:	eb 25                	jmp    3c6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 3a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a4:	89 d0                	mov    %edx,%eax
 3a6:	c1 e0 02             	shl    $0x2,%eax
 3a9:	01 d0                	add    %edx,%eax
 3ab:	01 c0                	add    %eax,%eax
 3ad:	89 c1                	mov    %eax,%ecx
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	8d 50 01             	lea    0x1(%eax),%edx
 3b5:	89 55 08             	mov    %edx,0x8(%ebp)
 3b8:	0f b6 00             	movzbl (%eax),%eax
 3bb:	0f be c0             	movsbl %al,%eax
 3be:	01 c8                	add    %ecx,%eax
 3c0:	83 e8 30             	sub    $0x30,%eax
 3c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3c6:	8b 45 08             	mov    0x8(%ebp),%eax
 3c9:	0f b6 00             	movzbl (%eax),%eax
 3cc:	3c 2f                	cmp    $0x2f,%al
 3ce:	7e 0a                	jle    3da <atoi+0x48>
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	0f b6 00             	movzbl (%eax),%eax
 3d6:	3c 39                	cmp    $0x39,%al
 3d8:	7e c7                	jle    3a1 <atoi+0xf>
  return n;
 3da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3dd:	c9                   	leave  
 3de:	c3                   	ret    

000003df <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3df:	55                   	push   %ebp
 3e0:	89 e5                	mov    %esp,%ebp
 3e2:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 3e5:	8b 45 08             	mov    0x8(%ebp),%eax
 3e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3f1:	eb 17                	jmp    40a <memmove+0x2b>
    *dst++ = *src++;
 3f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3f6:	8d 50 01             	lea    0x1(%eax),%edx
 3f9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3ff:	8d 4a 01             	lea    0x1(%edx),%ecx
 402:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 405:	0f b6 12             	movzbl (%edx),%edx
 408:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 40a:	8b 45 10             	mov    0x10(%ebp),%eax
 40d:	8d 50 ff             	lea    -0x1(%eax),%edx
 410:	89 55 10             	mov    %edx,0x10(%ebp)
 413:	85 c0                	test   %eax,%eax
 415:	7f dc                	jg     3f3 <memmove+0x14>
  return vdst;
 417:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41a:	c9                   	leave  
 41b:	c3                   	ret    

0000041c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 41c:	b8 01 00 00 00       	mov    $0x1,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <exit>:
SYSCALL(exit)
 424:	b8 02 00 00 00       	mov    $0x2,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <wait>:
SYSCALL(wait)
 42c:	b8 03 00 00 00       	mov    $0x3,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <pipe>:
SYSCALL(pipe)
 434:	b8 04 00 00 00       	mov    $0x4,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <read>:
SYSCALL(read)
 43c:	b8 05 00 00 00       	mov    $0x5,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <write>:
SYSCALL(write)
 444:	b8 10 00 00 00       	mov    $0x10,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <close>:
SYSCALL(close)
 44c:	b8 15 00 00 00       	mov    $0x15,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <kill>:
SYSCALL(kill)
 454:	b8 06 00 00 00       	mov    $0x6,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <exec>:
SYSCALL(exec)
 45c:	b8 07 00 00 00       	mov    $0x7,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <open>:
SYSCALL(open)
 464:	b8 0f 00 00 00       	mov    $0xf,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <mknod>:
SYSCALL(mknod)
 46c:	b8 11 00 00 00       	mov    $0x11,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <unlink>:
SYSCALL(unlink)
 474:	b8 12 00 00 00       	mov    $0x12,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <fstat>:
SYSCALL(fstat)
 47c:	b8 08 00 00 00       	mov    $0x8,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <link>:
SYSCALL(link)
 484:	b8 13 00 00 00       	mov    $0x13,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <mkdir>:
SYSCALL(mkdir)
 48c:	b8 14 00 00 00       	mov    $0x14,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <chdir>:
SYSCALL(chdir)
 494:	b8 09 00 00 00       	mov    $0x9,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <dup>:
SYSCALL(dup)
 49c:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <getpid>:
SYSCALL(getpid)
 4a4:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <sbrk>:
SYSCALL(sbrk)
 4ac:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <sleep>:
SYSCALL(sleep)
 4b4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <uptime>:
SYSCALL(uptime)
 4bc:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <getpinfo>:
SYSCALL(getpinfo)
 4c4:	b8 16 00 00 00       	mov    $0x16,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <settickets>:
SYSCALL(settickets)
 4cc:	b8 17 00 00 00       	mov    $0x17,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
 4d7:	83 ec 18             	sub    $0x18,%esp
 4da:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4e0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e7:	00 
 4e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ef:	8b 45 08             	mov    0x8(%ebp),%eax
 4f2:	89 04 24             	mov    %eax,(%esp)
 4f5:	e8 4a ff ff ff       	call   444 <write>
}
 4fa:	c9                   	leave  
 4fb:	c3                   	ret    

000004fc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4fc:	55                   	push   %ebp
 4fd:	89 e5                	mov    %esp,%ebp
 4ff:	56                   	push   %esi
 500:	53                   	push   %ebx
 501:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 504:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 50b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 50f:	74 17                	je     528 <printint+0x2c>
 511:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 515:	79 11                	jns    528 <printint+0x2c>
    neg = 1;
 517:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 51e:	8b 45 0c             	mov    0xc(%ebp),%eax
 521:	f7 d8                	neg    %eax
 523:	89 45 ec             	mov    %eax,-0x14(%ebp)
 526:	eb 06                	jmp    52e <printint+0x32>
  } else {
    x = xx;
 528:	8b 45 0c             	mov    0xc(%ebp),%eax
 52b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 52e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 535:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 538:	8d 41 01             	lea    0x1(%ecx),%eax
 53b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 53e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 541:	8b 45 ec             	mov    -0x14(%ebp),%eax
 544:	ba 00 00 00 00       	mov    $0x0,%edx
 549:	f7 f3                	div    %ebx
 54b:	89 d0                	mov    %edx,%eax
 54d:	0f b6 80 54 0c 00 00 	movzbl 0xc54(%eax),%eax
 554:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 558:	8b 75 10             	mov    0x10(%ebp),%esi
 55b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 55e:	ba 00 00 00 00       	mov    $0x0,%edx
 563:	f7 f6                	div    %esi
 565:	89 45 ec             	mov    %eax,-0x14(%ebp)
 568:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 56c:	75 c7                	jne    535 <printint+0x39>
  if(neg)
 56e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 572:	74 10                	je     584 <printint+0x88>
    buf[i++] = '-';
 574:	8b 45 f4             	mov    -0xc(%ebp),%eax
 577:	8d 50 01             	lea    0x1(%eax),%edx
 57a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 57d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 582:	eb 1f                	jmp    5a3 <printint+0xa7>
 584:	eb 1d                	jmp    5a3 <printint+0xa7>
    putc(fd, buf[i]);
 586:	8d 55 dc             	lea    -0x24(%ebp),%edx
 589:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58c:	01 d0                	add    %edx,%eax
 58e:	0f b6 00             	movzbl (%eax),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	89 44 24 04          	mov    %eax,0x4(%esp)
 598:	8b 45 08             	mov    0x8(%ebp),%eax
 59b:	89 04 24             	mov    %eax,(%esp)
 59e:	e8 31 ff ff ff       	call   4d4 <putc>
  while(--i >= 0)
 5a3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ab:	79 d9                	jns    586 <printint+0x8a>
}
 5ad:	83 c4 30             	add    $0x30,%esp
 5b0:	5b                   	pop    %ebx
 5b1:	5e                   	pop    %esi
 5b2:	5d                   	pop    %ebp
 5b3:	c3                   	ret    

000005b4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5c1:	8d 45 0c             	lea    0xc(%ebp),%eax
 5c4:	83 c0 04             	add    $0x4,%eax
 5c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5d1:	e9 7c 01 00 00       	jmp    752 <printf+0x19e>
    c = fmt[i] & 0xff;
 5d6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5dc:	01 d0                	add    %edx,%eax
 5de:	0f b6 00             	movzbl (%eax),%eax
 5e1:	0f be c0             	movsbl %al,%eax
 5e4:	25 ff 00 00 00       	and    $0xff,%eax
 5e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5f0:	75 2c                	jne    61e <printf+0x6a>
      if(c == '%'){
 5f2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f6:	75 0c                	jne    604 <printf+0x50>
        state = '%';
 5f8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ff:	e9 4a 01 00 00       	jmp    74e <printf+0x19a>
      } else {
        putc(fd, c);
 604:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 607:	0f be c0             	movsbl %al,%eax
 60a:	89 44 24 04          	mov    %eax,0x4(%esp)
 60e:	8b 45 08             	mov    0x8(%ebp),%eax
 611:	89 04 24             	mov    %eax,(%esp)
 614:	e8 bb fe ff ff       	call   4d4 <putc>
 619:	e9 30 01 00 00       	jmp    74e <printf+0x19a>
      }
    } else if(state == '%'){
 61e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 622:	0f 85 26 01 00 00    	jne    74e <printf+0x19a>
      if(c == 'd'){
 628:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 62c:	75 2d                	jne    65b <printf+0xa7>
        printint(fd, *ap, 10, 1);
 62e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 631:	8b 00                	mov    (%eax),%eax
 633:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 63a:	00 
 63b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 642:	00 
 643:	89 44 24 04          	mov    %eax,0x4(%esp)
 647:	8b 45 08             	mov    0x8(%ebp),%eax
 64a:	89 04 24             	mov    %eax,(%esp)
 64d:	e8 aa fe ff ff       	call   4fc <printint>
        ap++;
 652:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 656:	e9 ec 00 00 00       	jmp    747 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 65b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 65f:	74 06                	je     667 <printf+0xb3>
 661:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 665:	75 2d                	jne    694 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 667:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 673:	00 
 674:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 67b:	00 
 67c:	89 44 24 04          	mov    %eax,0x4(%esp)
 680:	8b 45 08             	mov    0x8(%ebp),%eax
 683:	89 04 24             	mov    %eax,(%esp)
 686:	e8 71 fe ff ff       	call   4fc <printint>
        ap++;
 68b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 68f:	e9 b3 00 00 00       	jmp    747 <printf+0x193>
      } else if(c == 's'){
 694:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 698:	75 45                	jne    6df <printf+0x12b>
        s = (char*)*ap;
 69a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 69d:	8b 00                	mov    (%eax),%eax
 69f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6a2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6aa:	75 09                	jne    6b5 <printf+0x101>
          s = "(null)";
 6ac:	c7 45 f4 d8 09 00 00 	movl   $0x9d8,-0xc(%ebp)
        while(*s != 0){
 6b3:	eb 1e                	jmp    6d3 <printf+0x11f>
 6b5:	eb 1c                	jmp    6d3 <printf+0x11f>
          putc(fd, *s);
 6b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ba:	0f b6 00             	movzbl (%eax),%eax
 6bd:	0f be c0             	movsbl %al,%eax
 6c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
 6c7:	89 04 24             	mov    %eax,(%esp)
 6ca:	e8 05 fe ff ff       	call   4d4 <putc>
          s++;
 6cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d6:	0f b6 00             	movzbl (%eax),%eax
 6d9:	84 c0                	test   %al,%al
 6db:	75 da                	jne    6b7 <printf+0x103>
 6dd:	eb 68                	jmp    747 <printf+0x193>
        }
      } else if(c == 'c'){
 6df:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6e3:	75 1d                	jne    702 <printf+0x14e>
        putc(fd, *ap);
 6e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	0f be c0             	movsbl %al,%eax
 6ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	89 04 24             	mov    %eax,(%esp)
 6f7:	e8 d8 fd ff ff       	call   4d4 <putc>
        ap++;
 6fc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 700:	eb 45                	jmp    747 <printf+0x193>
      } else if(c == '%'){
 702:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 706:	75 17                	jne    71f <printf+0x16b>
        putc(fd, c);
 708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 70b:	0f be c0             	movsbl %al,%eax
 70e:	89 44 24 04          	mov    %eax,0x4(%esp)
 712:	8b 45 08             	mov    0x8(%ebp),%eax
 715:	89 04 24             	mov    %eax,(%esp)
 718:	e8 b7 fd ff ff       	call   4d4 <putc>
 71d:	eb 28                	jmp    747 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 71f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 726:	00 
 727:	8b 45 08             	mov    0x8(%ebp),%eax
 72a:	89 04 24             	mov    %eax,(%esp)
 72d:	e8 a2 fd ff ff       	call   4d4 <putc>
        putc(fd, c);
 732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 735:	0f be c0             	movsbl %al,%eax
 738:	89 44 24 04          	mov    %eax,0x4(%esp)
 73c:	8b 45 08             	mov    0x8(%ebp),%eax
 73f:	89 04 24             	mov    %eax,(%esp)
 742:	e8 8d fd ff ff       	call   4d4 <putc>
      }
      state = 0;
 747:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 74e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 752:	8b 55 0c             	mov    0xc(%ebp),%edx
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	01 d0                	add    %edx,%eax
 75a:	0f b6 00             	movzbl (%eax),%eax
 75d:	84 c0                	test   %al,%al
 75f:	0f 85 71 fe ff ff    	jne    5d6 <printf+0x22>
    }
  }
}
 765:	c9                   	leave  
 766:	c3                   	ret    

00000767 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 767:	55                   	push   %ebp
 768:	89 e5                	mov    %esp,%ebp
 76a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 76d:	8b 45 08             	mov    0x8(%ebp),%eax
 770:	83 e8 08             	sub    $0x8,%eax
 773:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 776:	a1 70 0c 00 00       	mov    0xc70,%eax
 77b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 77e:	eb 24                	jmp    7a4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	8b 45 fc             	mov    -0x4(%ebp),%eax
 783:	8b 00                	mov    (%eax),%eax
 785:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 788:	77 12                	ja     79c <free+0x35>
 78a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 790:	77 24                	ja     7b6 <free+0x4f>
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79a:	77 1a                	ja     7b6 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	8b 00                	mov    (%eax),%eax
 7a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7aa:	76 d4                	jbe    780 <free+0x19>
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	8b 00                	mov    (%eax),%eax
 7b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b4:	76 ca                	jbe    780 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b9:	8b 40 04             	mov    0x4(%eax),%eax
 7bc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c6:	01 c2                	add    %eax,%edx
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	8b 00                	mov    (%eax),%eax
 7cd:	39 c2                	cmp    %eax,%edx
 7cf:	75 24                	jne    7f5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d4:	8b 50 04             	mov    0x4(%eax),%edx
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	8b 00                	mov    (%eax),%eax
 7dc:	8b 40 04             	mov    0x4(%eax),%eax
 7df:	01 c2                	add    %eax,%edx
 7e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ea:	8b 00                	mov    (%eax),%eax
 7ec:	8b 10                	mov    (%eax),%edx
 7ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f1:	89 10                	mov    %edx,(%eax)
 7f3:	eb 0a                	jmp    7ff <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f8:	8b 10                	mov    (%eax),%edx
 7fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fd:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	8b 40 04             	mov    0x4(%eax),%eax
 805:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	01 d0                	add    %edx,%eax
 811:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 814:	75 20                	jne    836 <free+0xcf>
    p->s.size += bp->s.size;
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	8b 50 04             	mov    0x4(%eax),%edx
 81c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81f:	8b 40 04             	mov    0x4(%eax),%eax
 822:	01 c2                	add    %eax,%edx
 824:	8b 45 fc             	mov    -0x4(%ebp),%eax
 827:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 82a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82d:	8b 10                	mov    (%eax),%edx
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 832:	89 10                	mov    %edx,(%eax)
 834:	eb 08                	jmp    83e <free+0xd7>
  } else
    p->s.ptr = bp;
 836:	8b 45 fc             	mov    -0x4(%ebp),%eax
 839:	8b 55 f8             	mov    -0x8(%ebp),%edx
 83c:	89 10                	mov    %edx,(%eax)
  freep = p;
 83e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 841:	a3 70 0c 00 00       	mov    %eax,0xc70
}
 846:	c9                   	leave  
 847:	c3                   	ret    

00000848 <morecore>:

static Header*
morecore(uint nu)
{
 848:	55                   	push   %ebp
 849:	89 e5                	mov    %esp,%ebp
 84b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 84e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 855:	77 07                	ja     85e <morecore+0x16>
    nu = 4096;
 857:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 85e:	8b 45 08             	mov    0x8(%ebp),%eax
 861:	c1 e0 03             	shl    $0x3,%eax
 864:	89 04 24             	mov    %eax,(%esp)
 867:	e8 40 fc ff ff       	call   4ac <sbrk>
 86c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 86f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 873:	75 07                	jne    87c <morecore+0x34>
    return 0;
 875:	b8 00 00 00 00       	mov    $0x0,%eax
 87a:	eb 22                	jmp    89e <morecore+0x56>
  hp = (Header*)p;
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 882:	8b 45 f0             	mov    -0x10(%ebp),%eax
 885:	8b 55 08             	mov    0x8(%ebp),%edx
 888:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 88b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88e:	83 c0 08             	add    $0x8,%eax
 891:	89 04 24             	mov    %eax,(%esp)
 894:	e8 ce fe ff ff       	call   767 <free>
  return freep;
 899:	a1 70 0c 00 00       	mov    0xc70,%eax
}
 89e:	c9                   	leave  
 89f:	c3                   	ret    

000008a0 <malloc>:

void*
malloc(uint nbytes)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a6:	8b 45 08             	mov    0x8(%ebp),%eax
 8a9:	83 c0 07             	add    $0x7,%eax
 8ac:	c1 e8 03             	shr    $0x3,%eax
 8af:	83 c0 01             	add    $0x1,%eax
 8b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8b5:	a1 70 0c 00 00       	mov    0xc70,%eax
 8ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8c1:	75 23                	jne    8e6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8c3:	c7 45 f0 68 0c 00 00 	movl   $0xc68,-0x10(%ebp)
 8ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cd:	a3 70 0c 00 00       	mov    %eax,0xc70
 8d2:	a1 70 0c 00 00       	mov    0xc70,%eax
 8d7:	a3 68 0c 00 00       	mov    %eax,0xc68
    base.s.size = 0;
 8dc:	c7 05 6c 0c 00 00 00 	movl   $0x0,0xc6c
 8e3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e9:	8b 00                	mov    (%eax),%eax
 8eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f1:	8b 40 04             	mov    0x4(%eax),%eax
 8f4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f7:	72 4d                	jb     946 <malloc+0xa6>
      if(p->s.size == nunits)
 8f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fc:	8b 40 04             	mov    0x4(%eax),%eax
 8ff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 902:	75 0c                	jne    910 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 904:	8b 45 f4             	mov    -0xc(%ebp),%eax
 907:	8b 10                	mov    (%eax),%edx
 909:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90c:	89 10                	mov    %edx,(%eax)
 90e:	eb 26                	jmp    936 <malloc+0x96>
      else {
        p->s.size -= nunits;
 910:	8b 45 f4             	mov    -0xc(%ebp),%eax
 913:	8b 40 04             	mov    0x4(%eax),%eax
 916:	2b 45 ec             	sub    -0x14(%ebp),%eax
 919:	89 c2                	mov    %eax,%edx
 91b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 921:	8b 45 f4             	mov    -0xc(%ebp),%eax
 924:	8b 40 04             	mov    0x4(%eax),%eax
 927:	c1 e0 03             	shl    $0x3,%eax
 92a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 92d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 930:	8b 55 ec             	mov    -0x14(%ebp),%edx
 933:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 936:	8b 45 f0             	mov    -0x10(%ebp),%eax
 939:	a3 70 0c 00 00       	mov    %eax,0xc70
      return (void*)(p + 1);
 93e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 941:	83 c0 08             	add    $0x8,%eax
 944:	eb 38                	jmp    97e <malloc+0xde>
    }
    if(p == freep)
 946:	a1 70 0c 00 00       	mov    0xc70,%eax
 94b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 94e:	75 1b                	jne    96b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 950:	8b 45 ec             	mov    -0x14(%ebp),%eax
 953:	89 04 24             	mov    %eax,(%esp)
 956:	e8 ed fe ff ff       	call   848 <morecore>
 95b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 95e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 962:	75 07                	jne    96b <malloc+0xcb>
        return 0;
 964:	b8 00 00 00 00       	mov    $0x0,%eax
 969:	eb 13                	jmp    97e <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 971:	8b 45 f4             	mov    -0xc(%ebp),%eax
 974:	8b 00                	mov    (%eax),%eax
 976:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 979:	e9 70 ff ff ff       	jmp    8ee <malloc+0x4e>
}
 97e:	c9                   	leave  
 97f:	c3                   	ret    
