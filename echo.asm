
_echo:     file format elf32-i386


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
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 4b                	jmp    5e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 88 09 00 00       	mov    $0x988,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 8a 09 00 00       	mov    $0x98a,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  39:	01 ca                	add    %ecx,%edx
  3b:	8b 12                	mov    (%edx),%edx
  3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  41:	89 54 24 08          	mov    %edx,0x8(%esp)
  45:	c7 44 24 04 8c 09 00 	movl   $0x98c,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 60 05 00 00       	call   5b9 <printf>
  for(i = 1; i < argc; i++)
  59:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  5e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  62:	3b 45 08             	cmp    0x8(%ebp),%eax
  65:	7c ac                	jl     13 <main+0x13>
  exit();
  67:	e8 bd 03 00 00       	call   429 <exit>

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	57                   	push   %edi
  95:	56                   	push   %esi
  96:	53                   	push   %ebx
  97:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
  9d:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
  a3:	89 04 24             	mov    %eax,(%esp)
  a6:	e8 1e 04 00 00       	call   4c9 <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
  ab:	c7 44 24 04 94 09 00 	movl   $0x994,0x4(%esp)
  b2:	00 
  b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ba:	e8 fa 04 00 00       	call   5b9 <printf>
    for (i = 0; i < NPROC; i++) {
  bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  c6:	e9 06 01 00 00       	jmp    1d1 <ps+0x140>
        if (ptable[i].inuse) {
  cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  ce:	89 d0                	mov    %edx,%eax
  d0:	c1 e0 03             	shl    $0x3,%eax
  d3:	01 d0                	add    %edx,%eax
  d5:	c1 e0 02             	shl    $0x2,%eax
  d8:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  db:	01 d8                	add    %ebx,%eax
  dd:	2d 08 09 00 00       	sub    $0x908,%eax
  e2:	8b 00                	mov    (%eax),%eax
  e4:	85 c0                	test   %eax,%eax
  e6:	0f 84 e1 00 00 00    	je     1cd <ps+0x13c>
            char stat = '?';
  ec:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
  f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f3:	89 d0                	mov    %edx,%eax
  f5:	c1 e0 03             	shl    $0x3,%eax
  f8:	01 d0                	add    %edx,%eax
  fa:	c1 e0 02             	shl    $0x2,%eax
  fd:	8d 75 e8             	lea    -0x18(%ebp),%esi
 100:	01 f0                	add    %esi,%eax
 102:	2d e8 08 00 00       	sub    $0x8e8,%eax
 107:	0f b6 00             	movzbl (%eax),%eax
 10a:	0f be c0             	movsbl %al,%eax
 10d:	83 f8 05             	cmp    $0x5,%eax
 110:	77 27                	ja     139 <ps+0xa8>
 112:	8b 04 85 c0 09 00 00 	mov    0x9c0(,%eax,4),%eax
 119:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
 11b:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
 11f:	eb 1c                	jmp    13d <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
 121:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 125:	eb 16                	jmp    13d <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
 127:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
 12b:	eb 10                	jmp    13d <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
 12d:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
 131:	eb 0a                	jmp    13d <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
 133:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
 137:	eb 04                	jmp    13d <ps+0xac>
                default: stat = '?';
 139:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
 13d:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
 143:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 146:	89 d0                	mov    %edx,%eax
 148:	c1 e0 03             	shl    $0x3,%eax
 14b:	01 d0                	add    %edx,%eax
 14d:	c1 e0 02             	shl    $0x2,%eax
 150:	83 c0 10             	add    $0x10,%eax
 153:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 156:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 15a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 15d:	89 d0                	mov    %edx,%eax
 15f:	c1 e0 03             	shl    $0x3,%eax
 162:	01 d0                	add    %edx,%eax
 164:	c1 e0 02             	shl    $0x2,%eax
 167:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 16a:	01 c8                	add    %ecx,%eax
 16c:	2d fc 08 00 00       	sub    $0x8fc,%eax
 171:	8b 18                	mov    (%eax),%ebx
 173:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 176:	89 d0                	mov    %edx,%eax
 178:	c1 e0 03             	shl    $0x3,%eax
 17b:	01 d0                	add    %edx,%eax
 17d:	c1 e0 02             	shl    $0x2,%eax
 180:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 183:	01 c8                	add    %ecx,%eax
 185:	2d 04 09 00 00       	sub    $0x904,%eax
 18a:	8b 08                	mov    (%eax),%ecx
 18c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 18f:	89 d0                	mov    %edx,%eax
 191:	c1 e0 03             	shl    $0x3,%eax
 194:	01 d0                	add    %edx,%eax
 196:	c1 e0 02             	shl    $0x2,%eax
 199:	8d 55 e8             	lea    -0x18(%ebp),%edx
 19c:	01 d0                	add    %edx,%eax
 19e:	2d 00 09 00 00       	sub    $0x900,%eax
 1a3:	8b 00                	mov    (%eax),%eax
 1a5:	89 7c 24 18          	mov    %edi,0x18(%esp)
 1a9:	89 74 24 14          	mov    %esi,0x14(%esp)
 1ad:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 1b1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 1b5:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b9:	c7 44 24 04 ad 09 00 	movl   $0x9ad,0x4(%esp)
 1c0:	00 
 1c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c8:	e8 ec 03 00 00       	call   5b9 <printf>
    for (i = 0; i < NPROC; i++) {
 1cd:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 1d1:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 1d5:	0f 8e f0 fe ff ff    	jle    cb <ps+0x3a>
        }
    }
}
 1db:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 1e1:	5b                   	pop    %ebx
 1e2:	5e                   	pop    %esi
 1e3:	5f                   	pop    %edi
 1e4:	5d                   	pop    %ebp
 1e5:	c3                   	ret    

000001e6 <strcpy>:


char*
strcpy(char *s, const char *t)
{
 1e6:	55                   	push   %ebp
 1e7:	89 e5                	mov    %esp,%ebp
 1e9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1f2:	90                   	nop
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	8d 50 01             	lea    0x1(%eax),%edx
 1f9:	89 55 08             	mov    %edx,0x8(%ebp)
 1fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ff:	8d 4a 01             	lea    0x1(%edx),%ecx
 202:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 205:	0f b6 12             	movzbl (%edx),%edx
 208:	88 10                	mov    %dl,(%eax)
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 e2                	jne    1f3 <strcpy+0xd>
    ;
  return os;
 211:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 214:	c9                   	leave  
 215:	c3                   	ret    

00000216 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 216:	55                   	push   %ebp
 217:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 219:	eb 08                	jmp    223 <strcmp+0xd>
    p++, q++;
 21b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	74 10                	je     23d <strcmp+0x27>
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 10             	movzbl (%eax),%edx
 233:	8b 45 0c             	mov    0xc(%ebp),%eax
 236:	0f b6 00             	movzbl (%eax),%eax
 239:	38 c2                	cmp    %al,%dl
 23b:	74 de                	je     21b <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	0f b6 00             	movzbl (%eax),%eax
 243:	0f b6 d0             	movzbl %al,%edx
 246:	8b 45 0c             	mov    0xc(%ebp),%eax
 249:	0f b6 00             	movzbl (%eax),%eax
 24c:	0f b6 c0             	movzbl %al,%eax
 24f:	29 c2                	sub    %eax,%edx
 251:	89 d0                	mov    %edx,%eax
}
 253:	5d                   	pop    %ebp
 254:	c3                   	ret    

00000255 <strlen>:

uint
strlen(const char *s)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 25b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 262:	eb 04                	jmp    268 <strlen+0x13>
 264:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 268:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	01 d0                	add    %edx,%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	84 c0                	test   %al,%al
 275:	75 ed                	jne    264 <strlen+0xf>
    ;
  return n;
 277:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 27a:	c9                   	leave  
 27b:	c3                   	ret    

0000027c <memset>:

void*
memset(void *dst, int c, uint n)
{
 27c:	55                   	push   %ebp
 27d:	89 e5                	mov    %esp,%ebp
 27f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 282:	8b 45 10             	mov    0x10(%ebp),%eax
 285:	89 44 24 08          	mov    %eax,0x8(%esp)
 289:	8b 45 0c             	mov    0xc(%ebp),%eax
 28c:	89 44 24 04          	mov    %eax,0x4(%esp)
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	89 04 24             	mov    %eax,(%esp)
 296:	e8 d1 fd ff ff       	call   6c <stosb>
  return dst;
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29e:	c9                   	leave  
 29f:	c3                   	ret    

000002a0 <strchr>:

char*
strchr(const char *s, char c)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 04             	sub    $0x4,%esp
 2a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2ac:	eb 14                	jmp    2c2 <strchr+0x22>
    if(*s == c)
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b7:	75 05                	jne    2be <strchr+0x1e>
      return (char*)s;
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	eb 13                	jmp    2d1 <strchr+0x31>
  for(; *s; s++)
 2be:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	0f b6 00             	movzbl (%eax),%eax
 2c8:	84 c0                	test   %al,%al
 2ca:	75 e2                	jne    2ae <strchr+0xe>
  return 0;
 2cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d1:	c9                   	leave  
 2d2:	c3                   	ret    

000002d3 <gets>:

char*
gets(char *buf, int max)
{
 2d3:	55                   	push   %ebp
 2d4:	89 e5                	mov    %esp,%ebp
 2d6:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2e0:	eb 4c                	jmp    32e <gets+0x5b>
    cc = read(0, &c, 1);
 2e2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2e9:	00 
 2ea:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2f8:	e8 44 01 00 00       	call   441 <read>
 2fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 300:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 304:	7f 02                	jg     308 <gets+0x35>
      break;
 306:	eb 31                	jmp    339 <gets+0x66>
    buf[i++] = c;
 308:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30b:	8d 50 01             	lea    0x1(%eax),%edx
 30e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 311:	89 c2                	mov    %eax,%edx
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	01 c2                	add    %eax,%edx
 318:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 31e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 322:	3c 0a                	cmp    $0xa,%al
 324:	74 13                	je     339 <gets+0x66>
 326:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32a:	3c 0d                	cmp    $0xd,%al
 32c:	74 0b                	je     339 <gets+0x66>
  for(i=0; i+1 < max; ){
 32e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 331:	83 c0 01             	add    $0x1,%eax
 334:	3b 45 0c             	cmp    0xc(%ebp),%eax
 337:	7c a9                	jl     2e2 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 339:	8b 55 f4             	mov    -0xc(%ebp),%edx
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	01 d0                	add    %edx,%eax
 341:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 344:	8b 45 08             	mov    0x8(%ebp),%eax
}
 347:	c9                   	leave  
 348:	c3                   	ret    

00000349 <stat>:

int
stat(const char *n, struct stat *st)
{
 349:	55                   	push   %ebp
 34a:	89 e5                	mov    %esp,%ebp
 34c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 34f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 356:	00 
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	89 04 24             	mov    %eax,(%esp)
 35d:	e8 07 01 00 00       	call   469 <open>
 362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 369:	79 07                	jns    372 <stat+0x29>
    return -1;
 36b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 370:	eb 23                	jmp    395 <stat+0x4c>
  r = fstat(fd, st);
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	89 44 24 04          	mov    %eax,0x4(%esp)
 379:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37c:	89 04 24             	mov    %eax,(%esp)
 37f:	e8 fd 00 00 00       	call   481 <fstat>
 384:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 387:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38a:	89 04 24             	mov    %eax,(%esp)
 38d:	e8 bf 00 00 00       	call   451 <close>
  return r;
 392:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 395:	c9                   	leave  
 396:	c3                   	ret    

00000397 <atoi>:

int
atoi(const char *s)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 39d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3a4:	eb 25                	jmp    3cb <atoi+0x34>
    n = n*10 + *s++ - '0';
 3a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a9:	89 d0                	mov    %edx,%eax
 3ab:	c1 e0 02             	shl    $0x2,%eax
 3ae:	01 d0                	add    %edx,%eax
 3b0:	01 c0                	add    %eax,%eax
 3b2:	89 c1                	mov    %eax,%ecx
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	8d 50 01             	lea    0x1(%eax),%edx
 3ba:	89 55 08             	mov    %edx,0x8(%ebp)
 3bd:	0f b6 00             	movzbl (%eax),%eax
 3c0:	0f be c0             	movsbl %al,%eax
 3c3:	01 c8                	add    %ecx,%eax
 3c5:	83 e8 30             	sub    $0x30,%eax
 3c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3cb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ce:	0f b6 00             	movzbl (%eax),%eax
 3d1:	3c 2f                	cmp    $0x2f,%al
 3d3:	7e 0a                	jle    3df <atoi+0x48>
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	0f b6 00             	movzbl (%eax),%eax
 3db:	3c 39                	cmp    $0x39,%al
 3dd:	7e c7                	jle    3a6 <atoi+0xf>
  return n;
 3df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e2:	c9                   	leave  
 3e3:	c3                   	ret    

000003e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 3ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3f6:	eb 17                	jmp    40f <memmove+0x2b>
    *dst++ = *src++;
 3f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3fb:	8d 50 01             	lea    0x1(%eax),%edx
 3fe:	89 55 fc             	mov    %edx,-0x4(%ebp)
 401:	8b 55 f8             	mov    -0x8(%ebp),%edx
 404:	8d 4a 01             	lea    0x1(%edx),%ecx
 407:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 40a:	0f b6 12             	movzbl (%edx),%edx
 40d:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 40f:	8b 45 10             	mov    0x10(%ebp),%eax
 412:	8d 50 ff             	lea    -0x1(%eax),%edx
 415:	89 55 10             	mov    %edx,0x10(%ebp)
 418:	85 c0                	test   %eax,%eax
 41a:	7f dc                	jg     3f8 <memmove+0x14>
  return vdst;
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41f:	c9                   	leave  
 420:	c3                   	ret    

00000421 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 421:	b8 01 00 00 00       	mov    $0x1,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <exit>:
SYSCALL(exit)
 429:	b8 02 00 00 00       	mov    $0x2,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <wait>:
SYSCALL(wait)
 431:	b8 03 00 00 00       	mov    $0x3,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <pipe>:
SYSCALL(pipe)
 439:	b8 04 00 00 00       	mov    $0x4,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <read>:
SYSCALL(read)
 441:	b8 05 00 00 00       	mov    $0x5,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <write>:
SYSCALL(write)
 449:	b8 10 00 00 00       	mov    $0x10,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <close>:
SYSCALL(close)
 451:	b8 15 00 00 00       	mov    $0x15,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <kill>:
SYSCALL(kill)
 459:	b8 06 00 00 00       	mov    $0x6,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <exec>:
SYSCALL(exec)
 461:	b8 07 00 00 00       	mov    $0x7,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <open>:
SYSCALL(open)
 469:	b8 0f 00 00 00       	mov    $0xf,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <mknod>:
SYSCALL(mknod)
 471:	b8 11 00 00 00       	mov    $0x11,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <unlink>:
SYSCALL(unlink)
 479:	b8 12 00 00 00       	mov    $0x12,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <fstat>:
SYSCALL(fstat)
 481:	b8 08 00 00 00       	mov    $0x8,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <link>:
SYSCALL(link)
 489:	b8 13 00 00 00       	mov    $0x13,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <mkdir>:
SYSCALL(mkdir)
 491:	b8 14 00 00 00       	mov    $0x14,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <chdir>:
SYSCALL(chdir)
 499:	b8 09 00 00 00       	mov    $0x9,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <dup>:
SYSCALL(dup)
 4a1:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <getpid>:
SYSCALL(getpid)
 4a9:	b8 0b 00 00 00       	mov    $0xb,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <sbrk>:
SYSCALL(sbrk)
 4b1:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <sleep>:
SYSCALL(sleep)
 4b9:	b8 0d 00 00 00       	mov    $0xd,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <uptime>:
SYSCALL(uptime)
 4c1:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <getpinfo>:
SYSCALL(getpinfo)
 4c9:	b8 16 00 00 00       	mov    $0x16,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <settickets>:
SYSCALL(settickets)
 4d1:	b8 17 00 00 00       	mov    $0x17,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4d9:	55                   	push   %ebp
 4da:	89 e5                	mov    %esp,%ebp
 4dc:	83 ec 18             	sub    $0x18,%esp
 4df:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4e5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4ec:	00 
 4ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	89 04 24             	mov    %eax,(%esp)
 4fa:	e8 4a ff ff ff       	call   449 <write>
}
 4ff:	c9                   	leave  
 500:	c3                   	ret    

00000501 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 501:	55                   	push   %ebp
 502:	89 e5                	mov    %esp,%ebp
 504:	56                   	push   %esi
 505:	53                   	push   %ebx
 506:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 509:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 510:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 514:	74 17                	je     52d <printint+0x2c>
 516:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 51a:	79 11                	jns    52d <printint+0x2c>
    neg = 1;
 51c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 523:	8b 45 0c             	mov    0xc(%ebp),%eax
 526:	f7 d8                	neg    %eax
 528:	89 45 ec             	mov    %eax,-0x14(%ebp)
 52b:	eb 06                	jmp    533 <printint+0x32>
  } else {
    x = xx;
 52d:	8b 45 0c             	mov    0xc(%ebp),%eax
 530:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 533:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 53a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 53d:	8d 41 01             	lea    0x1(%ecx),%eax
 540:	89 45 f4             	mov    %eax,-0xc(%ebp)
 543:	8b 5d 10             	mov    0x10(%ebp),%ebx
 546:	8b 45 ec             	mov    -0x14(%ebp),%eax
 549:	ba 00 00 00 00       	mov    $0x0,%edx
 54e:	f7 f3                	div    %ebx
 550:	89 d0                	mov    %edx,%eax
 552:	0f b6 80 54 0c 00 00 	movzbl 0xc54(%eax),%eax
 559:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 55d:	8b 75 10             	mov    0x10(%ebp),%esi
 560:	8b 45 ec             	mov    -0x14(%ebp),%eax
 563:	ba 00 00 00 00       	mov    $0x0,%edx
 568:	f7 f6                	div    %esi
 56a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 56d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 571:	75 c7                	jne    53a <printint+0x39>
  if(neg)
 573:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 577:	74 10                	je     589 <printint+0x88>
    buf[i++] = '-';
 579:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57c:	8d 50 01             	lea    0x1(%eax),%edx
 57f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 582:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 587:	eb 1f                	jmp    5a8 <printint+0xa7>
 589:	eb 1d                	jmp    5a8 <printint+0xa7>
    putc(fd, buf[i]);
 58b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 58e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 591:	01 d0                	add    %edx,%eax
 593:	0f b6 00             	movzbl (%eax),%eax
 596:	0f be c0             	movsbl %al,%eax
 599:	89 44 24 04          	mov    %eax,0x4(%esp)
 59d:	8b 45 08             	mov    0x8(%ebp),%eax
 5a0:	89 04 24             	mov    %eax,(%esp)
 5a3:	e8 31 ff ff ff       	call   4d9 <putc>
  while(--i >= 0)
 5a8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b0:	79 d9                	jns    58b <printint+0x8a>
}
 5b2:	83 c4 30             	add    $0x30,%esp
 5b5:	5b                   	pop    %ebx
 5b6:	5e                   	pop    %esi
 5b7:	5d                   	pop    %ebp
 5b8:	c3                   	ret    

000005b9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b9:	55                   	push   %ebp
 5ba:	89 e5                	mov    %esp,%ebp
 5bc:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5c6:	8d 45 0c             	lea    0xc(%ebp),%eax
 5c9:	83 c0 04             	add    $0x4,%eax
 5cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5d6:	e9 7c 01 00 00       	jmp    757 <printf+0x19e>
    c = fmt[i] & 0xff;
 5db:	8b 55 0c             	mov    0xc(%ebp),%edx
 5de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e1:	01 d0                	add    %edx,%eax
 5e3:	0f b6 00             	movzbl (%eax),%eax
 5e6:	0f be c0             	movsbl %al,%eax
 5e9:	25 ff 00 00 00       	and    $0xff,%eax
 5ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5f5:	75 2c                	jne    623 <printf+0x6a>
      if(c == '%'){
 5f7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5fb:	75 0c                	jne    609 <printf+0x50>
        state = '%';
 5fd:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 604:	e9 4a 01 00 00       	jmp    753 <printf+0x19a>
      } else {
        putc(fd, c);
 609:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60c:	0f be c0             	movsbl %al,%eax
 60f:	89 44 24 04          	mov    %eax,0x4(%esp)
 613:	8b 45 08             	mov    0x8(%ebp),%eax
 616:	89 04 24             	mov    %eax,(%esp)
 619:	e8 bb fe ff ff       	call   4d9 <putc>
 61e:	e9 30 01 00 00       	jmp    753 <printf+0x19a>
      }
    } else if(state == '%'){
 623:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 627:	0f 85 26 01 00 00    	jne    753 <printf+0x19a>
      if(c == 'd'){
 62d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 631:	75 2d                	jne    660 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 633:	8b 45 e8             	mov    -0x18(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 63f:	00 
 640:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 647:	00 
 648:	89 44 24 04          	mov    %eax,0x4(%esp)
 64c:	8b 45 08             	mov    0x8(%ebp),%eax
 64f:	89 04 24             	mov    %eax,(%esp)
 652:	e8 aa fe ff ff       	call   501 <printint>
        ap++;
 657:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65b:	e9 ec 00 00 00       	jmp    74c <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 660:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 664:	74 06                	je     66c <printf+0xb3>
 666:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 66a:	75 2d                	jne    699 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 66c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66f:	8b 00                	mov    (%eax),%eax
 671:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 678:	00 
 679:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 680:	00 
 681:	89 44 24 04          	mov    %eax,0x4(%esp)
 685:	8b 45 08             	mov    0x8(%ebp),%eax
 688:	89 04 24             	mov    %eax,(%esp)
 68b:	e8 71 fe ff ff       	call   501 <printint>
        ap++;
 690:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 694:	e9 b3 00 00 00       	jmp    74c <printf+0x193>
      } else if(c == 's'){
 699:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 69d:	75 45                	jne    6e4 <printf+0x12b>
        s = (char*)*ap;
 69f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6af:	75 09                	jne    6ba <printf+0x101>
          s = "(null)";
 6b1:	c7 45 f4 d8 09 00 00 	movl   $0x9d8,-0xc(%ebp)
        while(*s != 0){
 6b8:	eb 1e                	jmp    6d8 <printf+0x11f>
 6ba:	eb 1c                	jmp    6d8 <printf+0x11f>
          putc(fd, *s);
 6bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bf:	0f b6 00             	movzbl (%eax),%eax
 6c2:	0f be c0             	movsbl %al,%eax
 6c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
 6cc:	89 04 24             	mov    %eax,(%esp)
 6cf:	e8 05 fe ff ff       	call   4d9 <putc>
          s++;
 6d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6db:	0f b6 00             	movzbl (%eax),%eax
 6de:	84 c0                	test   %al,%al
 6e0:	75 da                	jne    6bc <printf+0x103>
 6e2:	eb 68                	jmp    74c <printf+0x193>
        }
      } else if(c == 'c'){
 6e4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6e8:	75 1d                	jne    707 <printf+0x14e>
        putc(fd, *ap);
 6ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ed:	8b 00                	mov    (%eax),%eax
 6ef:	0f be c0             	movsbl %al,%eax
 6f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f6:	8b 45 08             	mov    0x8(%ebp),%eax
 6f9:	89 04 24             	mov    %eax,(%esp)
 6fc:	e8 d8 fd ff ff       	call   4d9 <putc>
        ap++;
 701:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 705:	eb 45                	jmp    74c <printf+0x193>
      } else if(c == '%'){
 707:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 70b:	75 17                	jne    724 <printf+0x16b>
        putc(fd, c);
 70d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 710:	0f be c0             	movsbl %al,%eax
 713:	89 44 24 04          	mov    %eax,0x4(%esp)
 717:	8b 45 08             	mov    0x8(%ebp),%eax
 71a:	89 04 24             	mov    %eax,(%esp)
 71d:	e8 b7 fd ff ff       	call   4d9 <putc>
 722:	eb 28                	jmp    74c <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 724:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 72b:	00 
 72c:	8b 45 08             	mov    0x8(%ebp),%eax
 72f:	89 04 24             	mov    %eax,(%esp)
 732:	e8 a2 fd ff ff       	call   4d9 <putc>
        putc(fd, c);
 737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 73a:	0f be c0             	movsbl %al,%eax
 73d:	89 44 24 04          	mov    %eax,0x4(%esp)
 741:	8b 45 08             	mov    0x8(%ebp),%eax
 744:	89 04 24             	mov    %eax,(%esp)
 747:	e8 8d fd ff ff       	call   4d9 <putc>
      }
      state = 0;
 74c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 753:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 757:	8b 55 0c             	mov    0xc(%ebp),%edx
 75a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75d:	01 d0                	add    %edx,%eax
 75f:	0f b6 00             	movzbl (%eax),%eax
 762:	84 c0                	test   %al,%al
 764:	0f 85 71 fe ff ff    	jne    5db <printf+0x22>
    }
  }
}
 76a:	c9                   	leave  
 76b:	c3                   	ret    

0000076c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76c:	55                   	push   %ebp
 76d:	89 e5                	mov    %esp,%ebp
 76f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 772:	8b 45 08             	mov    0x8(%ebp),%eax
 775:	83 e8 08             	sub    $0x8,%eax
 778:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77b:	a1 70 0c 00 00       	mov    0xc70,%eax
 780:	89 45 fc             	mov    %eax,-0x4(%ebp)
 783:	eb 24                	jmp    7a9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 78d:	77 12                	ja     7a1 <free+0x35>
 78f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 792:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 795:	77 24                	ja     7bb <free+0x4f>
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79f:	77 1a                	ja     7bb <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7af:	76 d4                	jbe    785 <free+0x19>
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 00                	mov    (%eax),%eax
 7b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b9:	76 ca                	jbe    785 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	8b 40 04             	mov    0x4(%eax),%eax
 7c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cb:	01 c2                	add    %eax,%edx
 7cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d0:	8b 00                	mov    (%eax),%eax
 7d2:	39 c2                	cmp    %eax,%edx
 7d4:	75 24                	jne    7fa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d9:	8b 50 04             	mov    0x4(%eax),%edx
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	8b 00                	mov    (%eax),%eax
 7e1:	8b 40 04             	mov    0x4(%eax),%eax
 7e4:	01 c2                	add    %eax,%edx
 7e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ef:	8b 00                	mov    (%eax),%eax
 7f1:	8b 10                	mov    (%eax),%edx
 7f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f6:	89 10                	mov    %edx,(%eax)
 7f8:	eb 0a                	jmp    804 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	8b 10                	mov    (%eax),%edx
 7ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 802:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 804:	8b 45 fc             	mov    -0x4(%ebp),%eax
 807:	8b 40 04             	mov    0x4(%eax),%eax
 80a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	01 d0                	add    %edx,%eax
 816:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 819:	75 20                	jne    83b <free+0xcf>
    p->s.size += bp->s.size;
 81b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81e:	8b 50 04             	mov    0x4(%eax),%edx
 821:	8b 45 f8             	mov    -0x8(%ebp),%eax
 824:	8b 40 04             	mov    0x4(%eax),%eax
 827:	01 c2                	add    %eax,%edx
 829:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 82f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 832:	8b 10                	mov    (%eax),%edx
 834:	8b 45 fc             	mov    -0x4(%ebp),%eax
 837:	89 10                	mov    %edx,(%eax)
 839:	eb 08                	jmp    843 <free+0xd7>
  } else
    p->s.ptr = bp;
 83b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 841:	89 10                	mov    %edx,(%eax)
  freep = p;
 843:	8b 45 fc             	mov    -0x4(%ebp),%eax
 846:	a3 70 0c 00 00       	mov    %eax,0xc70
}
 84b:	c9                   	leave  
 84c:	c3                   	ret    

0000084d <morecore>:

static Header*
morecore(uint nu)
{
 84d:	55                   	push   %ebp
 84e:	89 e5                	mov    %esp,%ebp
 850:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 853:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 85a:	77 07                	ja     863 <morecore+0x16>
    nu = 4096;
 85c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 863:	8b 45 08             	mov    0x8(%ebp),%eax
 866:	c1 e0 03             	shl    $0x3,%eax
 869:	89 04 24             	mov    %eax,(%esp)
 86c:	e8 40 fc ff ff       	call   4b1 <sbrk>
 871:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 874:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 878:	75 07                	jne    881 <morecore+0x34>
    return 0;
 87a:	b8 00 00 00 00       	mov    $0x0,%eax
 87f:	eb 22                	jmp    8a3 <morecore+0x56>
  hp = (Header*)p;
 881:	8b 45 f4             	mov    -0xc(%ebp),%eax
 884:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 887:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88a:	8b 55 08             	mov    0x8(%ebp),%edx
 88d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 890:	8b 45 f0             	mov    -0x10(%ebp),%eax
 893:	83 c0 08             	add    $0x8,%eax
 896:	89 04 24             	mov    %eax,(%esp)
 899:	e8 ce fe ff ff       	call   76c <free>
  return freep;
 89e:	a1 70 0c 00 00       	mov    0xc70,%eax
}
 8a3:	c9                   	leave  
 8a4:	c3                   	ret    

000008a5 <malloc>:

void*
malloc(uint nbytes)
{
 8a5:	55                   	push   %ebp
 8a6:	89 e5                	mov    %esp,%ebp
 8a8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ab:	8b 45 08             	mov    0x8(%ebp),%eax
 8ae:	83 c0 07             	add    $0x7,%eax
 8b1:	c1 e8 03             	shr    $0x3,%eax
 8b4:	83 c0 01             	add    $0x1,%eax
 8b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8ba:	a1 70 0c 00 00       	mov    0xc70,%eax
 8bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8c6:	75 23                	jne    8eb <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8c8:	c7 45 f0 68 0c 00 00 	movl   $0xc68,-0x10(%ebp)
 8cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d2:	a3 70 0c 00 00       	mov    %eax,0xc70
 8d7:	a1 70 0c 00 00       	mov    0xc70,%eax
 8dc:	a3 68 0c 00 00       	mov    %eax,0xc68
    base.s.size = 0;
 8e1:	c7 05 6c 0c 00 00 00 	movl   $0x0,0xc6c
 8e8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ee:	8b 00                	mov    (%eax),%eax
 8f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f6:	8b 40 04             	mov    0x4(%eax),%eax
 8f9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8fc:	72 4d                	jb     94b <malloc+0xa6>
      if(p->s.size == nunits)
 8fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 901:	8b 40 04             	mov    0x4(%eax),%eax
 904:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 907:	75 0c                	jne    915 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 909:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90c:	8b 10                	mov    (%eax),%edx
 90e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 911:	89 10                	mov    %edx,(%eax)
 913:	eb 26                	jmp    93b <malloc+0x96>
      else {
        p->s.size -= nunits;
 915:	8b 45 f4             	mov    -0xc(%ebp),%eax
 918:	8b 40 04             	mov    0x4(%eax),%eax
 91b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 91e:	89 c2                	mov    %eax,%edx
 920:	8b 45 f4             	mov    -0xc(%ebp),%eax
 923:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 926:	8b 45 f4             	mov    -0xc(%ebp),%eax
 929:	8b 40 04             	mov    0x4(%eax),%eax
 92c:	c1 e0 03             	shl    $0x3,%eax
 92f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 932:	8b 45 f4             	mov    -0xc(%ebp),%eax
 935:	8b 55 ec             	mov    -0x14(%ebp),%edx
 938:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 93b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93e:	a3 70 0c 00 00       	mov    %eax,0xc70
      return (void*)(p + 1);
 943:	8b 45 f4             	mov    -0xc(%ebp),%eax
 946:	83 c0 08             	add    $0x8,%eax
 949:	eb 38                	jmp    983 <malloc+0xde>
    }
    if(p == freep)
 94b:	a1 70 0c 00 00       	mov    0xc70,%eax
 950:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 953:	75 1b                	jne    970 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 955:	8b 45 ec             	mov    -0x14(%ebp),%eax
 958:	89 04 24             	mov    %eax,(%esp)
 95b:	e8 ed fe ff ff       	call   84d <morecore>
 960:	89 45 f4             	mov    %eax,-0xc(%ebp)
 963:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 967:	75 07                	jne    970 <malloc+0xcb>
        return 0;
 969:	b8 00 00 00 00       	mov    $0x0,%eax
 96e:	eb 13                	jmp    983 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 970:	8b 45 f4             	mov    -0xc(%ebp),%eax
 973:	89 45 f0             	mov    %eax,-0x10(%ebp)
 976:	8b 45 f4             	mov    -0xc(%ebp),%eax
 979:	8b 00                	mov    (%eax),%eax
 97b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 97e:	e9 70 ff ff ff       	jmp    8f3 <malloc+0x4e>
}
 983:	c9                   	leave  
 984:	c3                   	ret    
