
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"


int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  ps(); //calling the ps() wrapper
   6:	e8 2a 00 00 00       	call   35 <ps>
  exit();
   b:	e8 bd 03 00 00       	call   3cd <exit>

00000010 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	57                   	push   %edi
  14:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  18:	8b 55 10             	mov    0x10(%ebp),%edx
  1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  1e:	89 cb                	mov    %ecx,%ebx
  20:	89 df                	mov    %ebx,%edi
  22:	89 d1                	mov    %edx,%ecx
  24:	fc                   	cld    
  25:	f3 aa                	rep stos %al,%es:(%edi)
  27:	89 ca                	mov    %ecx,%edx
  29:	89 fb                	mov    %edi,%ebx
  2b:	89 5d 08             	mov    %ebx,0x8(%ebp)
  2e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  31:	5b                   	pop    %ebx
  32:	5f                   	pop    %edi
  33:	5d                   	pop    %ebp
  34:	c3                   	ret    

00000035 <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
  35:	55                   	push   %ebp
  36:	89 e5                	mov    %esp,%ebp
  38:	57                   	push   %edi
  39:	56                   	push   %esi
  3a:	53                   	push   %ebx
  3b:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
  41:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
  47:	89 04 24             	mov    %eax,(%esp)
  4a:	e8 1e 04 00 00       	call   46d <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
  4f:	c7 44 24 04 2c 09 00 	movl   $0x92c,0x4(%esp)
  56:	00 
  57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5e:	e8 fa 04 00 00       	call   55d <printf>
    for (i = 0; i < NPROC; i++) {
  63:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6a:	e9 06 01 00 00       	jmp    175 <ps+0x140>
        if (ptable[i].inuse) {
  6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  72:	89 d0                	mov    %edx,%eax
  74:	c1 e0 03             	shl    $0x3,%eax
  77:	01 d0                	add    %edx,%eax
  79:	c1 e0 02             	shl    $0x2,%eax
  7c:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  7f:	01 d8                	add    %ebx,%eax
  81:	2d 08 09 00 00       	sub    $0x908,%eax
  86:	8b 00                	mov    (%eax),%eax
  88:	85 c0                	test   %eax,%eax
  8a:	0f 84 e1 00 00 00    	je     171 <ps+0x13c>
            char stat = '?';
  90:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
  94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  97:	89 d0                	mov    %edx,%eax
  99:	c1 e0 03             	shl    $0x3,%eax
  9c:	01 d0                	add    %edx,%eax
  9e:	c1 e0 02             	shl    $0x2,%eax
  a1:	8d 75 e8             	lea    -0x18(%ebp),%esi
  a4:	01 f0                	add    %esi,%eax
  a6:	2d e8 08 00 00       	sub    $0x8e8,%eax
  ab:	0f b6 00             	movzbl (%eax),%eax
  ae:	0f be c0             	movsbl %al,%eax
  b1:	83 f8 05             	cmp    $0x5,%eax
  b4:	77 27                	ja     dd <ps+0xa8>
  b6:	8b 04 85 58 09 00 00 	mov    0x958(,%eax,4),%eax
  bd:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
  bf:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
  c3:	eb 1c                	jmp    e1 <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
  c5:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
  c9:	eb 16                	jmp    e1 <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
  cb:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
  cf:	eb 10                	jmp    e1 <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
  d1:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
  d5:	eb 0a                	jmp    e1 <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
  d7:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
  db:	eb 04                	jmp    e1 <ps+0xac>
                default: stat = '?';
  dd:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
  e1:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
  e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  ea:	89 d0                	mov    %edx,%eax
  ec:	c1 e0 03             	shl    $0x3,%eax
  ef:	01 d0                	add    %edx,%eax
  f1:	c1 e0 02             	shl    $0x2,%eax
  f4:	83 c0 10             	add    $0x10,%eax
  f7:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
  fa:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 101:	89 d0                	mov    %edx,%eax
 103:	c1 e0 03             	shl    $0x3,%eax
 106:	01 d0                	add    %edx,%eax
 108:	c1 e0 02             	shl    $0x2,%eax
 10b:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 10e:	01 c8                	add    %ecx,%eax
 110:	2d fc 08 00 00       	sub    $0x8fc,%eax
 115:	8b 18                	mov    (%eax),%ebx
 117:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 11a:	89 d0                	mov    %edx,%eax
 11c:	c1 e0 03             	shl    $0x3,%eax
 11f:	01 d0                	add    %edx,%eax
 121:	c1 e0 02             	shl    $0x2,%eax
 124:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 127:	01 c8                	add    %ecx,%eax
 129:	2d 04 09 00 00       	sub    $0x904,%eax
 12e:	8b 08                	mov    (%eax),%ecx
 130:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 133:	89 d0                	mov    %edx,%eax
 135:	c1 e0 03             	shl    $0x3,%eax
 138:	01 d0                	add    %edx,%eax
 13a:	c1 e0 02             	shl    $0x2,%eax
 13d:	8d 55 e8             	lea    -0x18(%ebp),%edx
 140:	01 d0                	add    %edx,%eax
 142:	2d 00 09 00 00       	sub    $0x900,%eax
 147:	8b 00                	mov    (%eax),%eax
 149:	89 7c 24 18          	mov    %edi,0x18(%esp)
 14d:	89 74 24 14          	mov    %esi,0x14(%esp)
 151:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 155:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 159:	89 44 24 08          	mov    %eax,0x8(%esp)
 15d:	c7 44 24 04 45 09 00 	movl   $0x945,0x4(%esp)
 164:	00 
 165:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 16c:	e8 ec 03 00 00       	call   55d <printf>
    for (i = 0; i < NPROC; i++) {
 171:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 175:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 179:	0f 8e f0 fe ff ff    	jle    6f <ps+0x3a>
        }
    }
}
 17f:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 185:	5b                   	pop    %ebx
 186:	5e                   	pop    %esi
 187:	5f                   	pop    %edi
 188:	5d                   	pop    %ebp
 189:	c3                   	ret    

0000018a <strcpy>:


char*
strcpy(char *s, const char *t)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 196:	90                   	nop
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	8d 50 01             	lea    0x1(%eax),%edx
 19d:	89 55 08             	mov    %edx,0x8(%ebp)
 1a0:	8b 55 0c             	mov    0xc(%ebp),%edx
 1a3:	8d 4a 01             	lea    0x1(%edx),%ecx
 1a6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1a9:	0f b6 12             	movzbl (%edx),%edx
 1ac:	88 10                	mov    %dl,(%eax)
 1ae:	0f b6 00             	movzbl (%eax),%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	75 e2                	jne    197 <strcpy+0xd>
    ;
  return os;
 1b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b8:	c9                   	leave  
 1b9:	c3                   	ret    

000001ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1bd:	eb 08                	jmp    1c7 <strcmp+0xd>
    p++, q++;
 1bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	0f b6 00             	movzbl (%eax),%eax
 1cd:	84 c0                	test   %al,%al
 1cf:	74 10                	je     1e1 <strcmp+0x27>
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	0f b6 10             	movzbl (%eax),%edx
 1d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1da:	0f b6 00             	movzbl (%eax),%eax
 1dd:	38 c2                	cmp    %al,%dl
 1df:	74 de                	je     1bf <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	0f b6 00             	movzbl (%eax),%eax
 1e7:	0f b6 d0             	movzbl %al,%edx
 1ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ed:	0f b6 00             	movzbl (%eax),%eax
 1f0:	0f b6 c0             	movzbl %al,%eax
 1f3:	29 c2                	sub    %eax,%edx
 1f5:	89 d0                	mov    %edx,%eax
}
 1f7:	5d                   	pop    %ebp
 1f8:	c3                   	ret    

000001f9 <strlen>:

uint
strlen(const char *s)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 206:	eb 04                	jmp    20c <strlen+0x13>
 208:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 20c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	01 d0                	add    %edx,%eax
 214:	0f b6 00             	movzbl (%eax),%eax
 217:	84 c0                	test   %al,%al
 219:	75 ed                	jne    208 <strlen+0xf>
    ;
  return n;
 21b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21e:	c9                   	leave  
 21f:	c3                   	ret    

00000220 <memset>:

void*
memset(void *dst, int c, uint n)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 226:	8b 45 10             	mov    0x10(%ebp),%eax
 229:	89 44 24 08          	mov    %eax,0x8(%esp)
 22d:	8b 45 0c             	mov    0xc(%ebp),%eax
 230:	89 44 24 04          	mov    %eax,0x4(%esp)
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	89 04 24             	mov    %eax,(%esp)
 23a:	e8 d1 fd ff ff       	call   10 <stosb>
  return dst;
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 242:	c9                   	leave  
 243:	c3                   	ret    

00000244 <strchr>:

char*
strchr(const char *s, char c)
{
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	83 ec 04             	sub    $0x4,%esp
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 250:	eb 14                	jmp    266 <strchr+0x22>
    if(*s == c)
 252:	8b 45 08             	mov    0x8(%ebp),%eax
 255:	0f b6 00             	movzbl (%eax),%eax
 258:	3a 45 fc             	cmp    -0x4(%ebp),%al
 25b:	75 05                	jne    262 <strchr+0x1e>
      return (char*)s;
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	eb 13                	jmp    275 <strchr+0x31>
  for(; *s; s++)
 262:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	84 c0                	test   %al,%al
 26e:	75 e2                	jne    252 <strchr+0xe>
  return 0;
 270:	b8 00 00 00 00       	mov    $0x0,%eax
}
 275:	c9                   	leave  
 276:	c3                   	ret    

00000277 <gets>:

char*
gets(char *buf, int max)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 284:	eb 4c                	jmp    2d2 <gets+0x5b>
    cc = read(0, &c, 1);
 286:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 28d:	00 
 28e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 291:	89 44 24 04          	mov    %eax,0x4(%esp)
 295:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 29c:	e8 44 01 00 00       	call   3e5 <read>
 2a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2a8:	7f 02                	jg     2ac <gets+0x35>
      break;
 2aa:	eb 31                	jmp    2dd <gets+0x66>
    buf[i++] = c;
 2ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2af:	8d 50 01             	lea    0x1(%eax),%edx
 2b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2b5:	89 c2                	mov    %eax,%edx
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	01 c2                	add    %eax,%edx
 2bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2c0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2c2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2c6:	3c 0a                	cmp    $0xa,%al
 2c8:	74 13                	je     2dd <gets+0x66>
 2ca:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ce:	3c 0d                	cmp    $0xd,%al
 2d0:	74 0b                	je     2dd <gets+0x66>
  for(i=0; i+1 < max; ){
 2d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d5:	83 c0 01             	add    $0x1,%eax
 2d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2db:	7c a9                	jl     286 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 2dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	01 d0                	add    %edx,%eax
 2e5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    

000002ed <stat>:

int
stat(const char *n, struct stat *st)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2fa:	00 
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	89 04 24             	mov    %eax,(%esp)
 301:	e8 07 01 00 00       	call   40d <open>
 306:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 309:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 30d:	79 07                	jns    316 <stat+0x29>
    return -1;
 30f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 314:	eb 23                	jmp    339 <stat+0x4c>
  r = fstat(fd, st);
 316:	8b 45 0c             	mov    0xc(%ebp),%eax
 319:	89 44 24 04          	mov    %eax,0x4(%esp)
 31d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 320:	89 04 24             	mov    %eax,(%esp)
 323:	e8 fd 00 00 00       	call   425 <fstat>
 328:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 32b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 32e:	89 04 24             	mov    %eax,(%esp)
 331:	e8 bf 00 00 00       	call   3f5 <close>
  return r;
 336:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 339:	c9                   	leave  
 33a:	c3                   	ret    

0000033b <atoi>:

int
atoi(const char *s)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 341:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 348:	eb 25                	jmp    36f <atoi+0x34>
    n = n*10 + *s++ - '0';
 34a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 34d:	89 d0                	mov    %edx,%eax
 34f:	c1 e0 02             	shl    $0x2,%eax
 352:	01 d0                	add    %edx,%eax
 354:	01 c0                	add    %eax,%eax
 356:	89 c1                	mov    %eax,%ecx
 358:	8b 45 08             	mov    0x8(%ebp),%eax
 35b:	8d 50 01             	lea    0x1(%eax),%edx
 35e:	89 55 08             	mov    %edx,0x8(%ebp)
 361:	0f b6 00             	movzbl (%eax),%eax
 364:	0f be c0             	movsbl %al,%eax
 367:	01 c8                	add    %ecx,%eax
 369:	83 e8 30             	sub    $0x30,%eax
 36c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	0f b6 00             	movzbl (%eax),%eax
 375:	3c 2f                	cmp    $0x2f,%al
 377:	7e 0a                	jle    383 <atoi+0x48>
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	0f b6 00             	movzbl (%eax),%eax
 37f:	3c 39                	cmp    $0x39,%al
 381:	7e c7                	jle    34a <atoi+0xf>
  return n;
 383:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 386:	c9                   	leave  
 387:	c3                   	ret    

00000388 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 388:	55                   	push   %ebp
 389:	89 e5                	mov    %esp,%ebp
 38b:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 394:	8b 45 0c             	mov    0xc(%ebp),%eax
 397:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 39a:	eb 17                	jmp    3b3 <memmove+0x2b>
    *dst++ = *src++;
 39c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 39f:	8d 50 01             	lea    0x1(%eax),%edx
 3a2:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3a5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3a8:	8d 4a 01             	lea    0x1(%edx),%ecx
 3ab:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3ae:	0f b6 12             	movzbl (%edx),%edx
 3b1:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 3b3:	8b 45 10             	mov    0x10(%ebp),%eax
 3b6:	8d 50 ff             	lea    -0x1(%eax),%edx
 3b9:	89 55 10             	mov    %edx,0x10(%ebp)
 3bc:	85 c0                	test   %eax,%eax
 3be:	7f dc                	jg     39c <memmove+0x14>
  return vdst;
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c3:	c9                   	leave  
 3c4:	c3                   	ret    

000003c5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3c5:	b8 01 00 00 00       	mov    $0x1,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <exit>:
SYSCALL(exit)
 3cd:	b8 02 00 00 00       	mov    $0x2,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <wait>:
SYSCALL(wait)
 3d5:	b8 03 00 00 00       	mov    $0x3,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <pipe>:
SYSCALL(pipe)
 3dd:	b8 04 00 00 00       	mov    $0x4,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <read>:
SYSCALL(read)
 3e5:	b8 05 00 00 00       	mov    $0x5,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <write>:
SYSCALL(write)
 3ed:	b8 10 00 00 00       	mov    $0x10,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <close>:
SYSCALL(close)
 3f5:	b8 15 00 00 00       	mov    $0x15,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <kill>:
SYSCALL(kill)
 3fd:	b8 06 00 00 00       	mov    $0x6,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <exec>:
SYSCALL(exec)
 405:	b8 07 00 00 00       	mov    $0x7,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <open>:
SYSCALL(open)
 40d:	b8 0f 00 00 00       	mov    $0xf,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <mknod>:
SYSCALL(mknod)
 415:	b8 11 00 00 00       	mov    $0x11,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <unlink>:
SYSCALL(unlink)
 41d:	b8 12 00 00 00       	mov    $0x12,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <fstat>:
SYSCALL(fstat)
 425:	b8 08 00 00 00       	mov    $0x8,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <link>:
SYSCALL(link)
 42d:	b8 13 00 00 00       	mov    $0x13,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <mkdir>:
SYSCALL(mkdir)
 435:	b8 14 00 00 00       	mov    $0x14,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <chdir>:
SYSCALL(chdir)
 43d:	b8 09 00 00 00       	mov    $0x9,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <dup>:
SYSCALL(dup)
 445:	b8 0a 00 00 00       	mov    $0xa,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <getpid>:
SYSCALL(getpid)
 44d:	b8 0b 00 00 00       	mov    $0xb,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <sbrk>:
SYSCALL(sbrk)
 455:	b8 0c 00 00 00       	mov    $0xc,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <sleep>:
SYSCALL(sleep)
 45d:	b8 0d 00 00 00       	mov    $0xd,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <uptime>:
SYSCALL(uptime)
 465:	b8 0e 00 00 00       	mov    $0xe,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <getpinfo>:
SYSCALL(getpinfo)
 46d:	b8 16 00 00 00       	mov    $0x16,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <settickets>:
SYSCALL(settickets)
 475:	b8 17 00 00 00       	mov    $0x17,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 47d:	55                   	push   %ebp
 47e:	89 e5                	mov    %esp,%ebp
 480:	83 ec 18             	sub    $0x18,%esp
 483:	8b 45 0c             	mov    0xc(%ebp),%eax
 486:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 489:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 490:	00 
 491:	8d 45 f4             	lea    -0xc(%ebp),%eax
 494:	89 44 24 04          	mov    %eax,0x4(%esp)
 498:	8b 45 08             	mov    0x8(%ebp),%eax
 49b:	89 04 24             	mov    %eax,(%esp)
 49e:	e8 4a ff ff ff       	call   3ed <write>
}
 4a3:	c9                   	leave  
 4a4:	c3                   	ret    

000004a5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a5:	55                   	push   %ebp
 4a6:	89 e5                	mov    %esp,%ebp
 4a8:	56                   	push   %esi
 4a9:	53                   	push   %ebx
 4aa:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4b4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4b8:	74 17                	je     4d1 <printint+0x2c>
 4ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4be:	79 11                	jns    4d1 <printint+0x2c>
    neg = 1;
 4c0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ca:	f7 d8                	neg    %eax
 4cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4cf:	eb 06                	jmp    4d7 <printint+0x32>
  } else {
    x = xx;
 4d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4de:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4e1:	8d 41 01             	lea    0x1(%ecx),%eax
 4e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ed:	ba 00 00 00 00       	mov    $0x0,%edx
 4f2:	f7 f3                	div    %ebx
 4f4:	89 d0                	mov    %edx,%eax
 4f6:	0f b6 80 ec 0b 00 00 	movzbl 0xbec(%eax),%eax
 4fd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 501:	8b 75 10             	mov    0x10(%ebp),%esi
 504:	8b 45 ec             	mov    -0x14(%ebp),%eax
 507:	ba 00 00 00 00       	mov    $0x0,%edx
 50c:	f7 f6                	div    %esi
 50e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 511:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 515:	75 c7                	jne    4de <printint+0x39>
  if(neg)
 517:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 51b:	74 10                	je     52d <printint+0x88>
    buf[i++] = '-';
 51d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 520:	8d 50 01             	lea    0x1(%eax),%edx
 523:	89 55 f4             	mov    %edx,-0xc(%ebp)
 526:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 52b:	eb 1f                	jmp    54c <printint+0xa7>
 52d:	eb 1d                	jmp    54c <printint+0xa7>
    putc(fd, buf[i]);
 52f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 532:	8b 45 f4             	mov    -0xc(%ebp),%eax
 535:	01 d0                	add    %edx,%eax
 537:	0f b6 00             	movzbl (%eax),%eax
 53a:	0f be c0             	movsbl %al,%eax
 53d:	89 44 24 04          	mov    %eax,0x4(%esp)
 541:	8b 45 08             	mov    0x8(%ebp),%eax
 544:	89 04 24             	mov    %eax,(%esp)
 547:	e8 31 ff ff ff       	call   47d <putc>
  while(--i >= 0)
 54c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 554:	79 d9                	jns    52f <printint+0x8a>
}
 556:	83 c4 30             	add    $0x30,%esp
 559:	5b                   	pop    %ebx
 55a:	5e                   	pop    %esi
 55b:	5d                   	pop    %ebp
 55c:	c3                   	ret    

0000055d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 55d:	55                   	push   %ebp
 55e:	89 e5                	mov    %esp,%ebp
 560:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 563:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 56a:	8d 45 0c             	lea    0xc(%ebp),%eax
 56d:	83 c0 04             	add    $0x4,%eax
 570:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 573:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 57a:	e9 7c 01 00 00       	jmp    6fb <printf+0x19e>
    c = fmt[i] & 0xff;
 57f:	8b 55 0c             	mov    0xc(%ebp),%edx
 582:	8b 45 f0             	mov    -0x10(%ebp),%eax
 585:	01 d0                	add    %edx,%eax
 587:	0f b6 00             	movzbl (%eax),%eax
 58a:	0f be c0             	movsbl %al,%eax
 58d:	25 ff 00 00 00       	and    $0xff,%eax
 592:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 595:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 599:	75 2c                	jne    5c7 <printf+0x6a>
      if(c == '%'){
 59b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 59f:	75 0c                	jne    5ad <printf+0x50>
        state = '%';
 5a1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5a8:	e9 4a 01 00 00       	jmp    6f7 <printf+0x19a>
      } else {
        putc(fd, c);
 5ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	89 04 24             	mov    %eax,(%esp)
 5bd:	e8 bb fe ff ff       	call   47d <putc>
 5c2:	e9 30 01 00 00       	jmp    6f7 <printf+0x19a>
      }
    } else if(state == '%'){
 5c7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5cb:	0f 85 26 01 00 00    	jne    6f7 <printf+0x19a>
      if(c == 'd'){
 5d1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5d5:	75 2d                	jne    604 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5da:	8b 00                	mov    (%eax),%eax
 5dc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5e3:	00 
 5e4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5eb:	00 
 5ec:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f0:	8b 45 08             	mov    0x8(%ebp),%eax
 5f3:	89 04 24             	mov    %eax,(%esp)
 5f6:	e8 aa fe ff ff       	call   4a5 <printint>
        ap++;
 5fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ff:	e9 ec 00 00 00       	jmp    6f0 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 604:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 608:	74 06                	je     610 <printf+0xb3>
 60a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 60e:	75 2d                	jne    63d <printf+0xe0>
        printint(fd, *ap, 16, 0);
 610:	8b 45 e8             	mov    -0x18(%ebp),%eax
 613:	8b 00                	mov    (%eax),%eax
 615:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 61c:	00 
 61d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 624:	00 
 625:	89 44 24 04          	mov    %eax,0x4(%esp)
 629:	8b 45 08             	mov    0x8(%ebp),%eax
 62c:	89 04 24             	mov    %eax,(%esp)
 62f:	e8 71 fe ff ff       	call   4a5 <printint>
        ap++;
 634:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 638:	e9 b3 00 00 00       	jmp    6f0 <printf+0x193>
      } else if(c == 's'){
 63d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 641:	75 45                	jne    688 <printf+0x12b>
        s = (char*)*ap;
 643:	8b 45 e8             	mov    -0x18(%ebp),%eax
 646:	8b 00                	mov    (%eax),%eax
 648:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 64b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 64f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 653:	75 09                	jne    65e <printf+0x101>
          s = "(null)";
 655:	c7 45 f4 70 09 00 00 	movl   $0x970,-0xc(%ebp)
        while(*s != 0){
 65c:	eb 1e                	jmp    67c <printf+0x11f>
 65e:	eb 1c                	jmp    67c <printf+0x11f>
          putc(fd, *s);
 660:	8b 45 f4             	mov    -0xc(%ebp),%eax
 663:	0f b6 00             	movzbl (%eax),%eax
 666:	0f be c0             	movsbl %al,%eax
 669:	89 44 24 04          	mov    %eax,0x4(%esp)
 66d:	8b 45 08             	mov    0x8(%ebp),%eax
 670:	89 04 24             	mov    %eax,(%esp)
 673:	e8 05 fe ff ff       	call   47d <putc>
          s++;
 678:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 67c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67f:	0f b6 00             	movzbl (%eax),%eax
 682:	84 c0                	test   %al,%al
 684:	75 da                	jne    660 <printf+0x103>
 686:	eb 68                	jmp    6f0 <printf+0x193>
        }
      } else if(c == 'c'){
 688:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 68c:	75 1d                	jne    6ab <printf+0x14e>
        putc(fd, *ap);
 68e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 691:	8b 00                	mov    (%eax),%eax
 693:	0f be c0             	movsbl %al,%eax
 696:	89 44 24 04          	mov    %eax,0x4(%esp)
 69a:	8b 45 08             	mov    0x8(%ebp),%eax
 69d:	89 04 24             	mov    %eax,(%esp)
 6a0:	e8 d8 fd ff ff       	call   47d <putc>
        ap++;
 6a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a9:	eb 45                	jmp    6f0 <printf+0x193>
      } else if(c == '%'){
 6ab:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6af:	75 17                	jne    6c8 <printf+0x16b>
        putc(fd, c);
 6b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b4:	0f be c0             	movsbl %al,%eax
 6b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bb:	8b 45 08             	mov    0x8(%ebp),%eax
 6be:	89 04 24             	mov    %eax,(%esp)
 6c1:	e8 b7 fd ff ff       	call   47d <putc>
 6c6:	eb 28                	jmp    6f0 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6cf:	00 
 6d0:	8b 45 08             	mov    0x8(%ebp),%eax
 6d3:	89 04 24             	mov    %eax,(%esp)
 6d6:	e8 a2 fd ff ff       	call   47d <putc>
        putc(fd, c);
 6db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6de:	0f be c0             	movsbl %al,%eax
 6e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
 6e8:	89 04 24             	mov    %eax,(%esp)
 6eb:	e8 8d fd ff ff       	call   47d <putc>
      }
      state = 0;
 6f0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6f7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6fb:	8b 55 0c             	mov    0xc(%ebp),%edx
 6fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 701:	01 d0                	add    %edx,%eax
 703:	0f b6 00             	movzbl (%eax),%eax
 706:	84 c0                	test   %al,%al
 708:	0f 85 71 fe ff ff    	jne    57f <printf+0x22>
    }
  }
}
 70e:	c9                   	leave  
 70f:	c3                   	ret    

00000710 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 716:	8b 45 08             	mov    0x8(%ebp),%eax
 719:	83 e8 08             	sub    $0x8,%eax
 71c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71f:	a1 08 0c 00 00       	mov    0xc08,%eax
 724:	89 45 fc             	mov    %eax,-0x4(%ebp)
 727:	eb 24                	jmp    74d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 00                	mov    (%eax),%eax
 72e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 731:	77 12                	ja     745 <free+0x35>
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 739:	77 24                	ja     75f <free+0x4f>
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	8b 00                	mov    (%eax),%eax
 740:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 743:	77 1a                	ja     75f <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 00                	mov    (%eax),%eax
 74a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 750:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 753:	76 d4                	jbe    729 <free+0x19>
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75d:	76 ca                	jbe    729 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	8b 40 04             	mov    0x4(%eax),%eax
 765:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76f:	01 c2                	add    %eax,%edx
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	39 c2                	cmp    %eax,%edx
 778:	75 24                	jne    79e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 77a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77d:	8b 50 04             	mov    0x4(%eax),%edx
 780:	8b 45 fc             	mov    -0x4(%ebp),%eax
 783:	8b 00                	mov    (%eax),%eax
 785:	8b 40 04             	mov    0x4(%eax),%eax
 788:	01 c2                	add    %eax,%edx
 78a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 790:	8b 45 fc             	mov    -0x4(%ebp),%eax
 793:	8b 00                	mov    (%eax),%eax
 795:	8b 10                	mov    (%eax),%edx
 797:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79a:	89 10                	mov    %edx,(%eax)
 79c:	eb 0a                	jmp    7a8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 79e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a1:	8b 10                	mov    (%eax),%edx
 7a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ab:	8b 40 04             	mov    0x4(%eax),%eax
 7ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b8:	01 d0                	add    %edx,%eax
 7ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7bd:	75 20                	jne    7df <free+0xcf>
    p->s.size += bp->s.size;
 7bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c2:	8b 50 04             	mov    0x4(%eax),%edx
 7c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c8:	8b 40 04             	mov    0x4(%eax),%eax
 7cb:	01 c2                	add    %eax,%edx
 7cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d6:	8b 10                	mov    (%eax),%edx
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	89 10                	mov    %edx,(%eax)
 7dd:	eb 08                	jmp    7e7 <free+0xd7>
  } else
    p->s.ptr = bp;
 7df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e5:	89 10                	mov    %edx,(%eax)
  freep = p;
 7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ea:	a3 08 0c 00 00       	mov    %eax,0xc08
}
 7ef:	c9                   	leave  
 7f0:	c3                   	ret    

000007f1 <morecore>:

static Header*
morecore(uint nu)
{
 7f1:	55                   	push   %ebp
 7f2:	89 e5                	mov    %esp,%ebp
 7f4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7f7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7fe:	77 07                	ja     807 <morecore+0x16>
    nu = 4096;
 800:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 807:	8b 45 08             	mov    0x8(%ebp),%eax
 80a:	c1 e0 03             	shl    $0x3,%eax
 80d:	89 04 24             	mov    %eax,(%esp)
 810:	e8 40 fc ff ff       	call   455 <sbrk>
 815:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 818:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 81c:	75 07                	jne    825 <morecore+0x34>
    return 0;
 81e:	b8 00 00 00 00       	mov    $0x0,%eax
 823:	eb 22                	jmp    847 <morecore+0x56>
  hp = (Header*)p;
 825:	8b 45 f4             	mov    -0xc(%ebp),%eax
 828:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 82b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82e:	8b 55 08             	mov    0x8(%ebp),%edx
 831:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 834:	8b 45 f0             	mov    -0x10(%ebp),%eax
 837:	83 c0 08             	add    $0x8,%eax
 83a:	89 04 24             	mov    %eax,(%esp)
 83d:	e8 ce fe ff ff       	call   710 <free>
  return freep;
 842:	a1 08 0c 00 00       	mov    0xc08,%eax
}
 847:	c9                   	leave  
 848:	c3                   	ret    

00000849 <malloc>:

void*
malloc(uint nbytes)
{
 849:	55                   	push   %ebp
 84a:	89 e5                	mov    %esp,%ebp
 84c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84f:	8b 45 08             	mov    0x8(%ebp),%eax
 852:	83 c0 07             	add    $0x7,%eax
 855:	c1 e8 03             	shr    $0x3,%eax
 858:	83 c0 01             	add    $0x1,%eax
 85b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 85e:	a1 08 0c 00 00       	mov    0xc08,%eax
 863:	89 45 f0             	mov    %eax,-0x10(%ebp)
 866:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 86a:	75 23                	jne    88f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 86c:	c7 45 f0 00 0c 00 00 	movl   $0xc00,-0x10(%ebp)
 873:	8b 45 f0             	mov    -0x10(%ebp),%eax
 876:	a3 08 0c 00 00       	mov    %eax,0xc08
 87b:	a1 08 0c 00 00       	mov    0xc08,%eax
 880:	a3 00 0c 00 00       	mov    %eax,0xc00
    base.s.size = 0;
 885:	c7 05 04 0c 00 00 00 	movl   $0x0,0xc04
 88c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 892:	8b 00                	mov    (%eax),%eax
 894:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	8b 40 04             	mov    0x4(%eax),%eax
 89d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a0:	72 4d                	jb     8ef <malloc+0xa6>
      if(p->s.size == nunits)
 8a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a5:	8b 40 04             	mov    0x4(%eax),%eax
 8a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ab:	75 0c                	jne    8b9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	8b 10                	mov    (%eax),%edx
 8b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b5:	89 10                	mov    %edx,(%eax)
 8b7:	eb 26                	jmp    8df <malloc+0x96>
      else {
        p->s.size -= nunits;
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	8b 40 04             	mov    0x4(%eax),%eax
 8bf:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8c2:	89 c2                	mov    %eax,%edx
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cd:	8b 40 04             	mov    0x4(%eax),%eax
 8d0:	c1 e0 03             	shl    $0x3,%eax
 8d3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8dc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e2:	a3 08 0c 00 00       	mov    %eax,0xc08
      return (void*)(p + 1);
 8e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ea:	83 c0 08             	add    $0x8,%eax
 8ed:	eb 38                	jmp    927 <malloc+0xde>
    }
    if(p == freep)
 8ef:	a1 08 0c 00 00       	mov    0xc08,%eax
 8f4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f7:	75 1b                	jne    914 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8fc:	89 04 24             	mov    %eax,(%esp)
 8ff:	e8 ed fe ff ff       	call   7f1 <morecore>
 904:	89 45 f4             	mov    %eax,-0xc(%ebp)
 907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 90b:	75 07                	jne    914 <malloc+0xcb>
        return 0;
 90d:	b8 00 00 00 00       	mov    $0x0,%eax
 912:	eb 13                	jmp    927 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	89 45 f0             	mov    %eax,-0x10(%ebp)
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	8b 00                	mov    (%eax),%eax
 91f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 922:	e9 70 ff ff ff       	jmp    897 <malloc+0x4e>
}
 927:	c9                   	leave  
 928:	c3                   	ret    
