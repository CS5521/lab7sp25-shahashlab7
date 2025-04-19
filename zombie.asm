
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 ca 03 00 00       	call   3d8 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 52 04 00 00       	call   470 <sleep>
  exit();
  1e:	e8 bd 03 00 00       	call   3e0 <exit>

00000023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  23:	55                   	push   %ebp
  24:	89 e5                	mov    %esp,%ebp
  26:	57                   	push   %edi
  27:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2b:	8b 55 10             	mov    0x10(%ebp),%edx
  2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  31:	89 cb                	mov    %ecx,%ebx
  33:	89 df                	mov    %ebx,%edi
  35:	89 d1                	mov    %edx,%ecx
  37:	fc                   	cld    
  38:	f3 aa                	rep stos %al,%es:(%edi)
  3a:	89 ca                	mov    %ecx,%edx
  3c:	89 fb                	mov    %edi,%ebx
  3e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  41:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  44:	5b                   	pop    %ebx
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	57                   	push   %edi
  4c:	56                   	push   %esi
  4d:	53                   	push   %ebx
  4e:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
  54:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
  5a:	89 04 24             	mov    %eax,(%esp)
  5d:	e8 1e 04 00 00       	call   480 <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
  62:	c7 44 24 04 3c 09 00 	movl   $0x93c,0x4(%esp)
  69:	00 
  6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  71:	e8 fa 04 00 00       	call   570 <printf>
    for (i = 0; i < NPROC; i++) {
  76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  7d:	e9 06 01 00 00       	jmp    188 <ps+0x140>
        if (ptable[i].inuse) {
  82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  85:	89 d0                	mov    %edx,%eax
  87:	c1 e0 03             	shl    $0x3,%eax
  8a:	01 d0                	add    %edx,%eax
  8c:	c1 e0 02             	shl    $0x2,%eax
  8f:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  92:	01 d8                	add    %ebx,%eax
  94:	2d 08 09 00 00       	sub    $0x908,%eax
  99:	8b 00                	mov    (%eax),%eax
  9b:	85 c0                	test   %eax,%eax
  9d:	0f 84 e1 00 00 00    	je     184 <ps+0x13c>
            char stat = '?';
  a3:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
  a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  aa:	89 d0                	mov    %edx,%eax
  ac:	c1 e0 03             	shl    $0x3,%eax
  af:	01 d0                	add    %edx,%eax
  b1:	c1 e0 02             	shl    $0x2,%eax
  b4:	8d 75 e8             	lea    -0x18(%ebp),%esi
  b7:	01 f0                	add    %esi,%eax
  b9:	2d e8 08 00 00       	sub    $0x8e8,%eax
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	0f be c0             	movsbl %al,%eax
  c4:	83 f8 05             	cmp    $0x5,%eax
  c7:	77 27                	ja     f0 <ps+0xa8>
  c9:	8b 04 85 68 09 00 00 	mov    0x968(,%eax,4),%eax
  d0:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
  d2:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
  d6:	eb 1c                	jmp    f4 <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
  d8:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
  dc:	eb 16                	jmp    f4 <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
  de:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
  e2:	eb 10                	jmp    f4 <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
  e4:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
  e8:	eb 0a                	jmp    f4 <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
  ea:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
  ee:	eb 04                	jmp    f4 <ps+0xac>
                default: stat = '?';
  f0:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
  f4:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
  fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  fd:	89 d0                	mov    %edx,%eax
  ff:	c1 e0 03             	shl    $0x3,%eax
 102:	01 d0                	add    %edx,%eax
 104:	c1 e0 02             	shl    $0x2,%eax
 107:	83 c0 10             	add    $0x10,%eax
 10a:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 10d:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 111:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 114:	89 d0                	mov    %edx,%eax
 116:	c1 e0 03             	shl    $0x3,%eax
 119:	01 d0                	add    %edx,%eax
 11b:	c1 e0 02             	shl    $0x2,%eax
 11e:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 121:	01 c8                	add    %ecx,%eax
 123:	2d fc 08 00 00       	sub    $0x8fc,%eax
 128:	8b 18                	mov    (%eax),%ebx
 12a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 12d:	89 d0                	mov    %edx,%eax
 12f:	c1 e0 03             	shl    $0x3,%eax
 132:	01 d0                	add    %edx,%eax
 134:	c1 e0 02             	shl    $0x2,%eax
 137:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 13a:	01 c8                	add    %ecx,%eax
 13c:	2d 04 09 00 00       	sub    $0x904,%eax
 141:	8b 08                	mov    (%eax),%ecx
 143:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 146:	89 d0                	mov    %edx,%eax
 148:	c1 e0 03             	shl    $0x3,%eax
 14b:	01 d0                	add    %edx,%eax
 14d:	c1 e0 02             	shl    $0x2,%eax
 150:	8d 55 e8             	lea    -0x18(%ebp),%edx
 153:	01 d0                	add    %edx,%eax
 155:	2d 00 09 00 00       	sub    $0x900,%eax
 15a:	8b 00                	mov    (%eax),%eax
 15c:	89 7c 24 18          	mov    %edi,0x18(%esp)
 160:	89 74 24 14          	mov    %esi,0x14(%esp)
 164:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 168:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 16c:	89 44 24 08          	mov    %eax,0x8(%esp)
 170:	c7 44 24 04 55 09 00 	movl   $0x955,0x4(%esp)
 177:	00 
 178:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 17f:	e8 ec 03 00 00       	call   570 <printf>
    for (i = 0; i < NPROC; i++) {
 184:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 188:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 18c:	0f 8e f0 fe ff ff    	jle    82 <ps+0x3a>
        }
    }
}
 192:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 198:	5b                   	pop    %ebx
 199:	5e                   	pop    %esi
 19a:	5f                   	pop    %edi
 19b:	5d                   	pop    %ebp
 19c:	c3                   	ret    

0000019d <strcpy>:


char*
strcpy(char *s, const char *t)
{
 19d:	55                   	push   %ebp
 19e:	89 e5                	mov    %esp,%ebp
 1a0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1a9:	90                   	nop
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
 1ad:	8d 50 01             	lea    0x1(%eax),%edx
 1b0:	89 55 08             	mov    %edx,0x8(%ebp)
 1b3:	8b 55 0c             	mov    0xc(%ebp),%edx
 1b6:	8d 4a 01             	lea    0x1(%edx),%ecx
 1b9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1bc:	0f b6 12             	movzbl (%edx),%edx
 1bf:	88 10                	mov    %dl,(%eax)
 1c1:	0f b6 00             	movzbl (%eax),%eax
 1c4:	84 c0                	test   %al,%al
 1c6:	75 e2                	jne    1aa <strcpy+0xd>
    ;
  return os;
 1c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1cb:	c9                   	leave  
 1cc:	c3                   	ret    

000001cd <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1cd:	55                   	push   %ebp
 1ce:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1d0:	eb 08                	jmp    1da <strcmp+0xd>
    p++, q++;
 1d2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1d6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
 1dd:	0f b6 00             	movzbl (%eax),%eax
 1e0:	84 c0                	test   %al,%al
 1e2:	74 10                	je     1f4 <strcmp+0x27>
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	0f b6 10             	movzbl (%eax),%edx
 1ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ed:	0f b6 00             	movzbl (%eax),%eax
 1f0:	38 c2                	cmp    %al,%dl
 1f2:	74 de                	je     1d2 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	0f b6 00             	movzbl (%eax),%eax
 1fa:	0f b6 d0             	movzbl %al,%edx
 1fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 200:	0f b6 00             	movzbl (%eax),%eax
 203:	0f b6 c0             	movzbl %al,%eax
 206:	29 c2                	sub    %eax,%edx
 208:	89 d0                	mov    %edx,%eax
}
 20a:	5d                   	pop    %ebp
 20b:	c3                   	ret    

0000020c <strlen>:

uint
strlen(const char *s)
{
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 219:	eb 04                	jmp    21f <strlen+0x13>
 21b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 21f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 222:	8b 45 08             	mov    0x8(%ebp),%eax
 225:	01 d0                	add    %edx,%eax
 227:	0f b6 00             	movzbl (%eax),%eax
 22a:	84 c0                	test   %al,%al
 22c:	75 ed                	jne    21b <strlen+0xf>
    ;
  return n;
 22e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 231:	c9                   	leave  
 232:	c3                   	ret    

00000233 <memset>:

void*
memset(void *dst, int c, uint n)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 239:	8b 45 10             	mov    0x10(%ebp),%eax
 23c:	89 44 24 08          	mov    %eax,0x8(%esp)
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	89 44 24 04          	mov    %eax,0x4(%esp)
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	89 04 24             	mov    %eax,(%esp)
 24d:	e8 d1 fd ff ff       	call   23 <stosb>
  return dst;
 252:	8b 45 08             	mov    0x8(%ebp),%eax
}
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <strchr>:

char*
strchr(const char *s, char c)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	83 ec 04             	sub    $0x4,%esp
 25d:	8b 45 0c             	mov    0xc(%ebp),%eax
 260:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 263:	eb 14                	jmp    279 <strchr+0x22>
    if(*s == c)
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	0f b6 00             	movzbl (%eax),%eax
 26b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 26e:	75 05                	jne    275 <strchr+0x1e>
      return (char*)s;
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	eb 13                	jmp    288 <strchr+0x31>
  for(; *s; s++)
 275:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	0f b6 00             	movzbl (%eax),%eax
 27f:	84 c0                	test   %al,%al
 281:	75 e2                	jne    265 <strchr+0xe>
  return 0;
 283:	b8 00 00 00 00       	mov    $0x0,%eax
}
 288:	c9                   	leave  
 289:	c3                   	ret    

0000028a <gets>:

char*
gets(char *buf, int max)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 290:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 297:	eb 4c                	jmp    2e5 <gets+0x5b>
    cc = read(0, &c, 1);
 299:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2a0:	00 
 2a1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2a4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2af:	e8 44 01 00 00       	call   3f8 <read>
 2b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2bb:	7f 02                	jg     2bf <gets+0x35>
      break;
 2bd:	eb 31                	jmp    2f0 <gets+0x66>
    buf[i++] = c;
 2bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c2:	8d 50 01             	lea    0x1(%eax),%edx
 2c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2c8:	89 c2                	mov    %eax,%edx
 2ca:	8b 45 08             	mov    0x8(%ebp),%eax
 2cd:	01 c2                	add    %eax,%edx
 2cf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2d3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2d9:	3c 0a                	cmp    $0xa,%al
 2db:	74 13                	je     2f0 <gets+0x66>
 2dd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2e1:	3c 0d                	cmp    $0xd,%al
 2e3:	74 0b                	je     2f0 <gets+0x66>
  for(i=0; i+1 < max; ){
 2e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e8:	83 c0 01             	add    $0x1,%eax
 2eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2ee:	7c a9                	jl     299 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 2f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	01 d0                	add    %edx,%eax
 2f8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2fe:	c9                   	leave  
 2ff:	c3                   	ret    

00000300 <stat>:

int
stat(const char *n, struct stat *st)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 306:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 30d:	00 
 30e:	8b 45 08             	mov    0x8(%ebp),%eax
 311:	89 04 24             	mov    %eax,(%esp)
 314:	e8 07 01 00 00       	call   420 <open>
 319:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 31c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 320:	79 07                	jns    329 <stat+0x29>
    return -1;
 322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 327:	eb 23                	jmp    34c <stat+0x4c>
  r = fstat(fd, st);
 329:	8b 45 0c             	mov    0xc(%ebp),%eax
 32c:	89 44 24 04          	mov    %eax,0x4(%esp)
 330:	8b 45 f4             	mov    -0xc(%ebp),%eax
 333:	89 04 24             	mov    %eax,(%esp)
 336:	e8 fd 00 00 00       	call   438 <fstat>
 33b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 33e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 341:	89 04 24             	mov    %eax,(%esp)
 344:	e8 bf 00 00 00       	call   408 <close>
  return r;
 349:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 34c:	c9                   	leave  
 34d:	c3                   	ret    

0000034e <atoi>:

int
atoi(const char *s)
{
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp
 351:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 354:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 35b:	eb 25                	jmp    382 <atoi+0x34>
    n = n*10 + *s++ - '0';
 35d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 360:	89 d0                	mov    %edx,%eax
 362:	c1 e0 02             	shl    $0x2,%eax
 365:	01 d0                	add    %edx,%eax
 367:	01 c0                	add    %eax,%eax
 369:	89 c1                	mov    %eax,%ecx
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
 36e:	8d 50 01             	lea    0x1(%eax),%edx
 371:	89 55 08             	mov    %edx,0x8(%ebp)
 374:	0f b6 00             	movzbl (%eax),%eax
 377:	0f be c0             	movsbl %al,%eax
 37a:	01 c8                	add    %ecx,%eax
 37c:	83 e8 30             	sub    $0x30,%eax
 37f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 382:	8b 45 08             	mov    0x8(%ebp),%eax
 385:	0f b6 00             	movzbl (%eax),%eax
 388:	3c 2f                	cmp    $0x2f,%al
 38a:	7e 0a                	jle    396 <atoi+0x48>
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	0f b6 00             	movzbl (%eax),%eax
 392:	3c 39                	cmp    $0x39,%al
 394:	7e c7                	jle    35d <atoi+0xf>
  return n;
 396:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 399:	c9                   	leave  
 39a:	c3                   	ret    

0000039b <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 39b:	55                   	push   %ebp
 39c:	89 e5                	mov    %esp,%ebp
 39e:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3ad:	eb 17                	jmp    3c6 <memmove+0x2b>
    *dst++ = *src++;
 3af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3b2:	8d 50 01             	lea    0x1(%eax),%edx
 3b5:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3bb:	8d 4a 01             	lea    0x1(%edx),%ecx
 3be:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3c1:	0f b6 12             	movzbl (%edx),%edx
 3c4:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 3c6:	8b 45 10             	mov    0x10(%ebp),%eax
 3c9:	8d 50 ff             	lea    -0x1(%eax),%edx
 3cc:	89 55 10             	mov    %edx,0x10(%ebp)
 3cf:	85 c0                	test   %eax,%eax
 3d1:	7f dc                	jg     3af <memmove+0x14>
  return vdst;
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3d6:	c9                   	leave  
 3d7:	c3                   	ret    

000003d8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3d8:	b8 01 00 00 00       	mov    $0x1,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <exit>:
SYSCALL(exit)
 3e0:	b8 02 00 00 00       	mov    $0x2,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <wait>:
SYSCALL(wait)
 3e8:	b8 03 00 00 00       	mov    $0x3,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <pipe>:
SYSCALL(pipe)
 3f0:	b8 04 00 00 00       	mov    $0x4,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <read>:
SYSCALL(read)
 3f8:	b8 05 00 00 00       	mov    $0x5,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <write>:
SYSCALL(write)
 400:	b8 10 00 00 00       	mov    $0x10,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <close>:
SYSCALL(close)
 408:	b8 15 00 00 00       	mov    $0x15,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <kill>:
SYSCALL(kill)
 410:	b8 06 00 00 00       	mov    $0x6,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <exec>:
SYSCALL(exec)
 418:	b8 07 00 00 00       	mov    $0x7,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <open>:
SYSCALL(open)
 420:	b8 0f 00 00 00       	mov    $0xf,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <mknod>:
SYSCALL(mknod)
 428:	b8 11 00 00 00       	mov    $0x11,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <unlink>:
SYSCALL(unlink)
 430:	b8 12 00 00 00       	mov    $0x12,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <fstat>:
SYSCALL(fstat)
 438:	b8 08 00 00 00       	mov    $0x8,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <link>:
SYSCALL(link)
 440:	b8 13 00 00 00       	mov    $0x13,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <mkdir>:
SYSCALL(mkdir)
 448:	b8 14 00 00 00       	mov    $0x14,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <chdir>:
SYSCALL(chdir)
 450:	b8 09 00 00 00       	mov    $0x9,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <dup>:
SYSCALL(dup)
 458:	b8 0a 00 00 00       	mov    $0xa,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <getpid>:
SYSCALL(getpid)
 460:	b8 0b 00 00 00       	mov    $0xb,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <sbrk>:
SYSCALL(sbrk)
 468:	b8 0c 00 00 00       	mov    $0xc,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <sleep>:
SYSCALL(sleep)
 470:	b8 0d 00 00 00       	mov    $0xd,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <uptime>:
SYSCALL(uptime)
 478:	b8 0e 00 00 00       	mov    $0xe,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <getpinfo>:
SYSCALL(getpinfo)
 480:	b8 16 00 00 00       	mov    $0x16,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <settickets>:
SYSCALL(settickets)
 488:	b8 17 00 00 00       	mov    $0x17,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	83 ec 18             	sub    $0x18,%esp
 496:	8b 45 0c             	mov    0xc(%ebp),%eax
 499:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 49c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4a3:	00 
 4a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	89 04 24             	mov    %eax,(%esp)
 4b1:	e8 4a ff ff ff       	call   400 <write>
}
 4b6:	c9                   	leave  
 4b7:	c3                   	ret    

000004b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b8:	55                   	push   %ebp
 4b9:	89 e5                	mov    %esp,%ebp
 4bb:	56                   	push   %esi
 4bc:	53                   	push   %ebx
 4bd:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4c7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4cb:	74 17                	je     4e4 <printint+0x2c>
 4cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4d1:	79 11                	jns    4e4 <printint+0x2c>
    neg = 1;
 4d3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4da:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dd:	f7 d8                	neg    %eax
 4df:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e2:	eb 06                	jmp    4ea <printint+0x32>
  } else {
    x = xx;
 4e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4f1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4f4:	8d 41 01             	lea    0x1(%ecx),%eax
 4f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 500:	ba 00 00 00 00       	mov    $0x0,%edx
 505:	f7 f3                	div    %ebx
 507:	89 d0                	mov    %edx,%eax
 509:	0f b6 80 fc 0b 00 00 	movzbl 0xbfc(%eax),%eax
 510:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 514:	8b 75 10             	mov    0x10(%ebp),%esi
 517:	8b 45 ec             	mov    -0x14(%ebp),%eax
 51a:	ba 00 00 00 00       	mov    $0x0,%edx
 51f:	f7 f6                	div    %esi
 521:	89 45 ec             	mov    %eax,-0x14(%ebp)
 524:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 528:	75 c7                	jne    4f1 <printint+0x39>
  if(neg)
 52a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 52e:	74 10                	je     540 <printint+0x88>
    buf[i++] = '-';
 530:	8b 45 f4             	mov    -0xc(%ebp),%eax
 533:	8d 50 01             	lea    0x1(%eax),%edx
 536:	89 55 f4             	mov    %edx,-0xc(%ebp)
 539:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 53e:	eb 1f                	jmp    55f <printint+0xa7>
 540:	eb 1d                	jmp    55f <printint+0xa7>
    putc(fd, buf[i]);
 542:	8d 55 dc             	lea    -0x24(%ebp),%edx
 545:	8b 45 f4             	mov    -0xc(%ebp),%eax
 548:	01 d0                	add    %edx,%eax
 54a:	0f b6 00             	movzbl (%eax),%eax
 54d:	0f be c0             	movsbl %al,%eax
 550:	89 44 24 04          	mov    %eax,0x4(%esp)
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	89 04 24             	mov    %eax,(%esp)
 55a:	e8 31 ff ff ff       	call   490 <putc>
  while(--i >= 0)
 55f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 567:	79 d9                	jns    542 <printint+0x8a>
}
 569:	83 c4 30             	add    $0x30,%esp
 56c:	5b                   	pop    %ebx
 56d:	5e                   	pop    %esi
 56e:	5d                   	pop    %ebp
 56f:	c3                   	ret    

00000570 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 576:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 57d:	8d 45 0c             	lea    0xc(%ebp),%eax
 580:	83 c0 04             	add    $0x4,%eax
 583:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 586:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 58d:	e9 7c 01 00 00       	jmp    70e <printf+0x19e>
    c = fmt[i] & 0xff;
 592:	8b 55 0c             	mov    0xc(%ebp),%edx
 595:	8b 45 f0             	mov    -0x10(%ebp),%eax
 598:	01 d0                	add    %edx,%eax
 59a:	0f b6 00             	movzbl (%eax),%eax
 59d:	0f be c0             	movsbl %al,%eax
 5a0:	25 ff 00 00 00       	and    $0xff,%eax
 5a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ac:	75 2c                	jne    5da <printf+0x6a>
      if(c == '%'){
 5ae:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b2:	75 0c                	jne    5c0 <printf+0x50>
        state = '%';
 5b4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5bb:	e9 4a 01 00 00       	jmp    70a <printf+0x19a>
      } else {
        putc(fd, c);
 5c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c3:	0f be c0             	movsbl %al,%eax
 5c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ca:	8b 45 08             	mov    0x8(%ebp),%eax
 5cd:	89 04 24             	mov    %eax,(%esp)
 5d0:	e8 bb fe ff ff       	call   490 <putc>
 5d5:	e9 30 01 00 00       	jmp    70a <printf+0x19a>
      }
    } else if(state == '%'){
 5da:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5de:	0f 85 26 01 00 00    	jne    70a <printf+0x19a>
      if(c == 'd'){
 5e4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5e8:	75 2d                	jne    617 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ed:	8b 00                	mov    (%eax),%eax
 5ef:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5f6:	00 
 5f7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5fe:	00 
 5ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 603:	8b 45 08             	mov    0x8(%ebp),%eax
 606:	89 04 24             	mov    %eax,(%esp)
 609:	e8 aa fe ff ff       	call   4b8 <printint>
        ap++;
 60e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 612:	e9 ec 00 00 00       	jmp    703 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 617:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 61b:	74 06                	je     623 <printf+0xb3>
 61d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 621:	75 2d                	jne    650 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 623:	8b 45 e8             	mov    -0x18(%ebp),%eax
 626:	8b 00                	mov    (%eax),%eax
 628:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 62f:	00 
 630:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 637:	00 
 638:	89 44 24 04          	mov    %eax,0x4(%esp)
 63c:	8b 45 08             	mov    0x8(%ebp),%eax
 63f:	89 04 24             	mov    %eax,(%esp)
 642:	e8 71 fe ff ff       	call   4b8 <printint>
        ap++;
 647:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64b:	e9 b3 00 00 00       	jmp    703 <printf+0x193>
      } else if(c == 's'){
 650:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 654:	75 45                	jne    69b <printf+0x12b>
        s = (char*)*ap;
 656:	8b 45 e8             	mov    -0x18(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 65e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 666:	75 09                	jne    671 <printf+0x101>
          s = "(null)";
 668:	c7 45 f4 80 09 00 00 	movl   $0x980,-0xc(%ebp)
        while(*s != 0){
 66f:	eb 1e                	jmp    68f <printf+0x11f>
 671:	eb 1c                	jmp    68f <printf+0x11f>
          putc(fd, *s);
 673:	8b 45 f4             	mov    -0xc(%ebp),%eax
 676:	0f b6 00             	movzbl (%eax),%eax
 679:	0f be c0             	movsbl %al,%eax
 67c:	89 44 24 04          	mov    %eax,0x4(%esp)
 680:	8b 45 08             	mov    0x8(%ebp),%eax
 683:	89 04 24             	mov    %eax,(%esp)
 686:	e8 05 fe ff ff       	call   490 <putc>
          s++;
 68b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 68f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 692:	0f b6 00             	movzbl (%eax),%eax
 695:	84 c0                	test   %al,%al
 697:	75 da                	jne    673 <printf+0x103>
 699:	eb 68                	jmp    703 <printf+0x193>
        }
      } else if(c == 'c'){
 69b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 69f:	75 1d                	jne    6be <printf+0x14e>
        putc(fd, *ap);
 6a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	0f be c0             	movsbl %al,%eax
 6a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ad:	8b 45 08             	mov    0x8(%ebp),%eax
 6b0:	89 04 24             	mov    %eax,(%esp)
 6b3:	e8 d8 fd ff ff       	call   490 <putc>
        ap++;
 6b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6bc:	eb 45                	jmp    703 <printf+0x193>
      } else if(c == '%'){
 6be:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c2:	75 17                	jne    6db <printf+0x16b>
        putc(fd, c);
 6c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c7:	0f be c0             	movsbl %al,%eax
 6ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ce:	8b 45 08             	mov    0x8(%ebp),%eax
 6d1:	89 04 24             	mov    %eax,(%esp)
 6d4:	e8 b7 fd ff ff       	call   490 <putc>
 6d9:	eb 28                	jmp    703 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6db:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6e2:	00 
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
 6e6:	89 04 24             	mov    %eax,(%esp)
 6e9:	e8 a2 fd ff ff       	call   490 <putc>
        putc(fd, c);
 6ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f1:	0f be c0             	movsbl %al,%eax
 6f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f8:	8b 45 08             	mov    0x8(%ebp),%eax
 6fb:	89 04 24             	mov    %eax,(%esp)
 6fe:	e8 8d fd ff ff       	call   490 <putc>
      }
      state = 0;
 703:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 70a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 70e:	8b 55 0c             	mov    0xc(%ebp),%edx
 711:	8b 45 f0             	mov    -0x10(%ebp),%eax
 714:	01 d0                	add    %edx,%eax
 716:	0f b6 00             	movzbl (%eax),%eax
 719:	84 c0                	test   %al,%al
 71b:	0f 85 71 fe ff ff    	jne    592 <printf+0x22>
    }
  }
}
 721:	c9                   	leave  
 722:	c3                   	ret    

00000723 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 723:	55                   	push   %ebp
 724:	89 e5                	mov    %esp,%ebp
 726:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	83 e8 08             	sub    $0x8,%eax
 72f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 732:	a1 18 0c 00 00       	mov    0xc18,%eax
 737:	89 45 fc             	mov    %eax,-0x4(%ebp)
 73a:	eb 24                	jmp    760 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 744:	77 12                	ja     758 <free+0x35>
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74c:	77 24                	ja     772 <free+0x4f>
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	8b 00                	mov    (%eax),%eax
 753:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 756:	77 1a                	ja     772 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 760:	8b 45 f8             	mov    -0x8(%ebp),%eax
 763:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 766:	76 d4                	jbe    73c <free+0x19>
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 00                	mov    (%eax),%eax
 76d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 770:	76 ca                	jbe    73c <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 772:	8b 45 f8             	mov    -0x8(%ebp),%eax
 775:	8b 40 04             	mov    0x4(%eax),%eax
 778:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 782:	01 c2                	add    %eax,%edx
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	8b 00                	mov    (%eax),%eax
 789:	39 c2                	cmp    %eax,%edx
 78b:	75 24                	jne    7b1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 78d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 790:	8b 50 04             	mov    0x4(%eax),%edx
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	8b 40 04             	mov    0x4(%eax),%eax
 79b:	01 c2                	add    %eax,%edx
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	8b 00                	mov    (%eax),%eax
 7a8:	8b 10                	mov    (%eax),%edx
 7aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ad:	89 10                	mov    %edx,(%eax)
 7af:	eb 0a                	jmp    7bb <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 10                	mov    (%eax),%edx
 7b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7be:	8b 40 04             	mov    0x4(%eax),%eax
 7c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	01 d0                	add    %edx,%eax
 7cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d0:	75 20                	jne    7f2 <free+0xcf>
    p->s.size += bp->s.size;
 7d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d5:	8b 50 04             	mov    0x4(%eax),%edx
 7d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7db:	8b 40 04             	mov    0x4(%eax),%eax
 7de:	01 c2                	add    %eax,%edx
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e9:	8b 10                	mov    (%eax),%edx
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	89 10                	mov    %edx,(%eax)
 7f0:	eb 08                	jmp    7fa <free+0xd7>
  } else
    p->s.ptr = bp;
 7f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7f8:	89 10                	mov    %edx,(%eax)
  freep = p;
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	a3 18 0c 00 00       	mov    %eax,0xc18
}
 802:	c9                   	leave  
 803:	c3                   	ret    

00000804 <morecore>:

static Header*
morecore(uint nu)
{
 804:	55                   	push   %ebp
 805:	89 e5                	mov    %esp,%ebp
 807:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 80a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 811:	77 07                	ja     81a <morecore+0x16>
    nu = 4096;
 813:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 81a:	8b 45 08             	mov    0x8(%ebp),%eax
 81d:	c1 e0 03             	shl    $0x3,%eax
 820:	89 04 24             	mov    %eax,(%esp)
 823:	e8 40 fc ff ff       	call   468 <sbrk>
 828:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 82b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 82f:	75 07                	jne    838 <morecore+0x34>
    return 0;
 831:	b8 00 00 00 00       	mov    $0x0,%eax
 836:	eb 22                	jmp    85a <morecore+0x56>
  hp = (Header*)p;
 838:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 83e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 841:	8b 55 08             	mov    0x8(%ebp),%edx
 844:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 847:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84a:	83 c0 08             	add    $0x8,%eax
 84d:	89 04 24             	mov    %eax,(%esp)
 850:	e8 ce fe ff ff       	call   723 <free>
  return freep;
 855:	a1 18 0c 00 00       	mov    0xc18,%eax
}
 85a:	c9                   	leave  
 85b:	c3                   	ret    

0000085c <malloc>:

void*
malloc(uint nbytes)
{
 85c:	55                   	push   %ebp
 85d:	89 e5                	mov    %esp,%ebp
 85f:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 862:	8b 45 08             	mov    0x8(%ebp),%eax
 865:	83 c0 07             	add    $0x7,%eax
 868:	c1 e8 03             	shr    $0x3,%eax
 86b:	83 c0 01             	add    $0x1,%eax
 86e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 871:	a1 18 0c 00 00       	mov    0xc18,%eax
 876:	89 45 f0             	mov    %eax,-0x10(%ebp)
 879:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 87d:	75 23                	jne    8a2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 87f:	c7 45 f0 10 0c 00 00 	movl   $0xc10,-0x10(%ebp)
 886:	8b 45 f0             	mov    -0x10(%ebp),%eax
 889:	a3 18 0c 00 00       	mov    %eax,0xc18
 88e:	a1 18 0c 00 00       	mov    0xc18,%eax
 893:	a3 10 0c 00 00       	mov    %eax,0xc10
    base.s.size = 0;
 898:	c7 05 14 0c 00 00 00 	movl   $0x0,0xc14
 89f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a5:	8b 00                	mov    (%eax),%eax
 8a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ad:	8b 40 04             	mov    0x4(%eax),%eax
 8b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b3:	72 4d                	jb     902 <malloc+0xa6>
      if(p->s.size == nunits)
 8b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b8:	8b 40 04             	mov    0x4(%eax),%eax
 8bb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8be:	75 0c                	jne    8cc <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c3:	8b 10                	mov    (%eax),%edx
 8c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c8:	89 10                	mov    %edx,(%eax)
 8ca:	eb 26                	jmp    8f2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cf:	8b 40 04             	mov    0x4(%eax),%eax
 8d2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8d5:	89 c2                	mov    %eax,%edx
 8d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8da:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e0:	8b 40 04             	mov    0x4(%eax),%eax
 8e3:	c1 e0 03             	shl    $0x3,%eax
 8e6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ef:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f5:	a3 18 0c 00 00       	mov    %eax,0xc18
      return (void*)(p + 1);
 8fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fd:	83 c0 08             	add    $0x8,%eax
 900:	eb 38                	jmp    93a <malloc+0xde>
    }
    if(p == freep)
 902:	a1 18 0c 00 00       	mov    0xc18,%eax
 907:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 90a:	75 1b                	jne    927 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 90c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 90f:	89 04 24             	mov    %eax,(%esp)
 912:	e8 ed fe ff ff       	call   804 <morecore>
 917:	89 45 f4             	mov    %eax,-0xc(%ebp)
 91a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 91e:	75 07                	jne    927 <malloc+0xcb>
        return 0;
 920:	b8 00 00 00 00       	mov    $0x0,%eax
 925:	eb 13                	jmp    93a <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 927:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 92d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 930:	8b 00                	mov    (%eax),%eax
 932:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 935:	e9 70 ff ff ff       	jmp    8aa <malloc+0x4e>
}
 93a:	c9                   	leave  
 93b:	c3                   	ret    
