
_rm:     file format elf32-i386


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

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: rm files...\n");
   f:	c7 44 24 04 a8 09 00 	movl   $0x9a8,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 b9 05 00 00       	call   5dc <printf>
    exit();
  23:	e8 24 04 00 00       	call   44c <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4f                	jmp    81 <main+0x81>
    if(unlink(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 50 04 00 00       	call   49c <unlink>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 bc 09 00 	movl   $0x9bc,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 62 05 00 00       	call   5dc <printf>
      break;
  7a:	eb 0e                	jmp    8a <main+0x8a>
  for(i = 1; i < argc; i++){
  7c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  81:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  85:	3b 45 08             	cmp    0x8(%ebp),%eax
  88:	7c a8                	jl     32 <main+0x32>
    }
  }

  exit();
  8a:	e8 bd 03 00 00       	call   44c <exit>

0000008f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	57                   	push   %edi
  93:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  97:	8b 55 10             	mov    0x10(%ebp),%edx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	89 cb                	mov    %ecx,%ebx
  9f:	89 df                	mov    %ebx,%edi
  a1:	89 d1                	mov    %edx,%ecx
  a3:	fc                   	cld    
  a4:	f3 aa                	rep stos %al,%es:(%edi)
  a6:	89 ca                	mov    %ecx,%edx
  a8:	89 fb                	mov    %edi,%ebx
  aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b0:	5b                   	pop    %ebx
  b1:	5f                   	pop    %edi
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    

000000b4 <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	57                   	push   %edi
  b8:	56                   	push   %esi
  b9:	53                   	push   %ebx
  ba:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
  c0:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
  c6:	89 04 24             	mov    %eax,(%esp)
  c9:	e8 1e 04 00 00       	call   4ec <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
  ce:	c7 44 24 04 d8 09 00 	movl   $0x9d8,0x4(%esp)
  d5:	00 
  d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  dd:	e8 fa 04 00 00       	call   5dc <printf>
    for (i = 0; i < NPROC; i++) {
  e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  e9:	e9 06 01 00 00       	jmp    1f4 <ps+0x140>
        if (ptable[i].inuse) {
  ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f1:	89 d0                	mov    %edx,%eax
  f3:	c1 e0 03             	shl    $0x3,%eax
  f6:	01 d0                	add    %edx,%eax
  f8:	c1 e0 02             	shl    $0x2,%eax
  fb:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  fe:	01 d8                	add    %ebx,%eax
 100:	2d 08 09 00 00       	sub    $0x908,%eax
 105:	8b 00                	mov    (%eax),%eax
 107:	85 c0                	test   %eax,%eax
 109:	0f 84 e1 00 00 00    	je     1f0 <ps+0x13c>
            char stat = '?';
 10f:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
 113:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 116:	89 d0                	mov    %edx,%eax
 118:	c1 e0 03             	shl    $0x3,%eax
 11b:	01 d0                	add    %edx,%eax
 11d:	c1 e0 02             	shl    $0x2,%eax
 120:	8d 75 e8             	lea    -0x18(%ebp),%esi
 123:	01 f0                	add    %esi,%eax
 125:	2d e8 08 00 00       	sub    $0x8e8,%eax
 12a:	0f b6 00             	movzbl (%eax),%eax
 12d:	0f be c0             	movsbl %al,%eax
 130:	83 f8 05             	cmp    $0x5,%eax
 133:	77 27                	ja     15c <ps+0xa8>
 135:	8b 04 85 04 0a 00 00 	mov    0xa04(,%eax,4),%eax
 13c:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
 13e:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
 142:	eb 1c                	jmp    160 <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
 144:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 148:	eb 16                	jmp    160 <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
 14a:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
 14e:	eb 10                	jmp    160 <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
 150:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
 154:	eb 0a                	jmp    160 <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
 156:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
 15a:	eb 04                	jmp    160 <ps+0xac>
                default: stat = '?';
 15c:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
 160:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
 166:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 169:	89 d0                	mov    %edx,%eax
 16b:	c1 e0 03             	shl    $0x3,%eax
 16e:	01 d0                	add    %edx,%eax
 170:	c1 e0 02             	shl    $0x2,%eax
 173:	83 c0 10             	add    $0x10,%eax
 176:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 179:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 17d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 180:	89 d0                	mov    %edx,%eax
 182:	c1 e0 03             	shl    $0x3,%eax
 185:	01 d0                	add    %edx,%eax
 187:	c1 e0 02             	shl    $0x2,%eax
 18a:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 18d:	01 c8                	add    %ecx,%eax
 18f:	2d fc 08 00 00       	sub    $0x8fc,%eax
 194:	8b 18                	mov    (%eax),%ebx
 196:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 199:	89 d0                	mov    %edx,%eax
 19b:	c1 e0 03             	shl    $0x3,%eax
 19e:	01 d0                	add    %edx,%eax
 1a0:	c1 e0 02             	shl    $0x2,%eax
 1a3:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 1a6:	01 c8                	add    %ecx,%eax
 1a8:	2d 04 09 00 00       	sub    $0x904,%eax
 1ad:	8b 08                	mov    (%eax),%ecx
 1af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1b2:	89 d0                	mov    %edx,%eax
 1b4:	c1 e0 03             	shl    $0x3,%eax
 1b7:	01 d0                	add    %edx,%eax
 1b9:	c1 e0 02             	shl    $0x2,%eax
 1bc:	8d 55 e8             	lea    -0x18(%ebp),%edx
 1bf:	01 d0                	add    %edx,%eax
 1c1:	2d 00 09 00 00       	sub    $0x900,%eax
 1c6:	8b 00                	mov    (%eax),%eax
 1c8:	89 7c 24 18          	mov    %edi,0x18(%esp)
 1cc:	89 74 24 14          	mov    %esi,0x14(%esp)
 1d0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 1d4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 1d8:	89 44 24 08          	mov    %eax,0x8(%esp)
 1dc:	c7 44 24 04 f1 09 00 	movl   $0x9f1,0x4(%esp)
 1e3:	00 
 1e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1eb:	e8 ec 03 00 00       	call   5dc <printf>
    for (i = 0; i < NPROC; i++) {
 1f0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 1f4:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 1f8:	0f 8e f0 fe ff ff    	jle    ee <ps+0x3a>
        }
    }
}
 1fe:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 204:	5b                   	pop    %ebx
 205:	5e                   	pop    %esi
 206:	5f                   	pop    %edi
 207:	5d                   	pop    %ebp
 208:	c3                   	ret    

00000209 <strcpy>:


char*
strcpy(char *s, const char *t)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
 20c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 215:	90                   	nop
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	8d 50 01             	lea    0x1(%eax),%edx
 21c:	89 55 08             	mov    %edx,0x8(%ebp)
 21f:	8b 55 0c             	mov    0xc(%ebp),%edx
 222:	8d 4a 01             	lea    0x1(%edx),%ecx
 225:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 228:	0f b6 12             	movzbl (%edx),%edx
 22b:	88 10                	mov    %dl,(%eax)
 22d:	0f b6 00             	movzbl (%eax),%eax
 230:	84 c0                	test   %al,%al
 232:	75 e2                	jne    216 <strcpy+0xd>
    ;
  return os;
 234:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 23c:	eb 08                	jmp    246 <strcmp+0xd>
    p++, q++;
 23e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 242:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	0f b6 00             	movzbl (%eax),%eax
 24c:	84 c0                	test   %al,%al
 24e:	74 10                	je     260 <strcmp+0x27>
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	0f b6 10             	movzbl (%eax),%edx
 256:	8b 45 0c             	mov    0xc(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	38 c2                	cmp    %al,%dl
 25e:	74 de                	je     23e <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	0f b6 d0             	movzbl %al,%edx
 269:	8b 45 0c             	mov    0xc(%ebp),%eax
 26c:	0f b6 00             	movzbl (%eax),%eax
 26f:	0f b6 c0             	movzbl %al,%eax
 272:	29 c2                	sub    %eax,%edx
 274:	89 d0                	mov    %edx,%eax
}
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    

00000278 <strlen>:

uint
strlen(const char *s)
{
 278:	55                   	push   %ebp
 279:	89 e5                	mov    %esp,%ebp
 27b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 27e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 285:	eb 04                	jmp    28b <strlen+0x13>
 287:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 28b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	01 d0                	add    %edx,%eax
 293:	0f b6 00             	movzbl (%eax),%eax
 296:	84 c0                	test   %al,%al
 298:	75 ed                	jne    287 <strlen+0xf>
    ;
  return n;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29d:	c9                   	leave  
 29e:	c3                   	ret    

0000029f <memset>:

void*
memset(void *dst, int c, uint n)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
 2a2:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2a5:	8b 45 10             	mov    0x10(%ebp),%eax
 2a8:	89 44 24 08          	mov    %eax,0x8(%esp)
 2ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 2af:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	89 04 24             	mov    %eax,(%esp)
 2b9:	e8 d1 fd ff ff       	call   8f <stosb>
  return dst;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <strchr>:

char*
strchr(const char *s, char c)
{
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp
 2c6:	83 ec 04             	sub    $0x4,%esp
 2c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2cf:	eb 14                	jmp    2e5 <strchr+0x22>
    if(*s == c)
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	0f b6 00             	movzbl (%eax),%eax
 2d7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2da:	75 05                	jne    2e1 <strchr+0x1e>
      return (char*)s;
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	eb 13                	jmp    2f4 <strchr+0x31>
  for(; *s; s++)
 2e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e5:	8b 45 08             	mov    0x8(%ebp),%eax
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	84 c0                	test   %al,%al
 2ed:	75 e2                	jne    2d1 <strchr+0xe>
  return 0;
 2ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f4:	c9                   	leave  
 2f5:	c3                   	ret    

000002f6 <gets>:

char*
gets(char *buf, int max)
{
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 303:	eb 4c                	jmp    351 <gets+0x5b>
    cc = read(0, &c, 1);
 305:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 30c:	00 
 30d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 310:	89 44 24 04          	mov    %eax,0x4(%esp)
 314:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 31b:	e8 44 01 00 00       	call   464 <read>
 320:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 323:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 327:	7f 02                	jg     32b <gets+0x35>
      break;
 329:	eb 31                	jmp    35c <gets+0x66>
    buf[i++] = c;
 32b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 32e:	8d 50 01             	lea    0x1(%eax),%edx
 331:	89 55 f4             	mov    %edx,-0xc(%ebp)
 334:	89 c2                	mov    %eax,%edx
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	01 c2                	add    %eax,%edx
 33b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 33f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 341:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 345:	3c 0a                	cmp    $0xa,%al
 347:	74 13                	je     35c <gets+0x66>
 349:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 34d:	3c 0d                	cmp    $0xd,%al
 34f:	74 0b                	je     35c <gets+0x66>
  for(i=0; i+1 < max; ){
 351:	8b 45 f4             	mov    -0xc(%ebp),%eax
 354:	83 c0 01             	add    $0x1,%eax
 357:	3b 45 0c             	cmp    0xc(%ebp),%eax
 35a:	7c a9                	jl     305 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 35c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
 362:	01 d0                	add    %edx,%eax
 364:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 367:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36a:	c9                   	leave  
 36b:	c3                   	ret    

0000036c <stat>:

int
stat(const char *n, struct stat *st)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 372:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 379:	00 
 37a:	8b 45 08             	mov    0x8(%ebp),%eax
 37d:	89 04 24             	mov    %eax,(%esp)
 380:	e8 07 01 00 00       	call   48c <open>
 385:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 38c:	79 07                	jns    395 <stat+0x29>
    return -1;
 38e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 393:	eb 23                	jmp    3b8 <stat+0x4c>
  r = fstat(fd, st);
 395:	8b 45 0c             	mov    0xc(%ebp),%eax
 398:	89 44 24 04          	mov    %eax,0x4(%esp)
 39c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39f:	89 04 24             	mov    %eax,(%esp)
 3a2:	e8 fd 00 00 00       	call   4a4 <fstat>
 3a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ad:	89 04 24             	mov    %eax,(%esp)
 3b0:	e8 bf 00 00 00       	call   474 <close>
  return r;
 3b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3b8:	c9                   	leave  
 3b9:	c3                   	ret    

000003ba <atoi>:

int
atoi(const char *s)
{
 3ba:	55                   	push   %ebp
 3bb:	89 e5                	mov    %esp,%ebp
 3bd:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3c7:	eb 25                	jmp    3ee <atoi+0x34>
    n = n*10 + *s++ - '0';
 3c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3cc:	89 d0                	mov    %edx,%eax
 3ce:	c1 e0 02             	shl    $0x2,%eax
 3d1:	01 d0                	add    %edx,%eax
 3d3:	01 c0                	add    %eax,%eax
 3d5:	89 c1                	mov    %eax,%ecx
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	8d 50 01             	lea    0x1(%eax),%edx
 3dd:	89 55 08             	mov    %edx,0x8(%ebp)
 3e0:	0f b6 00             	movzbl (%eax),%eax
 3e3:	0f be c0             	movsbl %al,%eax
 3e6:	01 c8                	add    %ecx,%eax
 3e8:	83 e8 30             	sub    $0x30,%eax
 3eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	0f b6 00             	movzbl (%eax),%eax
 3f4:	3c 2f                	cmp    $0x2f,%al
 3f6:	7e 0a                	jle    402 <atoi+0x48>
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	0f b6 00             	movzbl (%eax),%eax
 3fe:	3c 39                	cmp    $0x39,%al
 400:	7e c7                	jle    3c9 <atoi+0xf>
  return n;
 402:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 405:	c9                   	leave  
 406:	c3                   	ret    

00000407 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 407:	55                   	push   %ebp
 408:	89 e5                	mov    %esp,%ebp
 40a:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 419:	eb 17                	jmp    432 <memmove+0x2b>
    *dst++ = *src++;
 41b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 41e:	8d 50 01             	lea    0x1(%eax),%edx
 421:	89 55 fc             	mov    %edx,-0x4(%ebp)
 424:	8b 55 f8             	mov    -0x8(%ebp),%edx
 427:	8d 4a 01             	lea    0x1(%edx),%ecx
 42a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 42d:	0f b6 12             	movzbl (%edx),%edx
 430:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 432:	8b 45 10             	mov    0x10(%ebp),%eax
 435:	8d 50 ff             	lea    -0x1(%eax),%edx
 438:	89 55 10             	mov    %edx,0x10(%ebp)
 43b:	85 c0                	test   %eax,%eax
 43d:	7f dc                	jg     41b <memmove+0x14>
  return vdst;
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 442:	c9                   	leave  
 443:	c3                   	ret    

00000444 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 444:	b8 01 00 00 00       	mov    $0x1,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <exit>:
SYSCALL(exit)
 44c:	b8 02 00 00 00       	mov    $0x2,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <wait>:
SYSCALL(wait)
 454:	b8 03 00 00 00       	mov    $0x3,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <pipe>:
SYSCALL(pipe)
 45c:	b8 04 00 00 00       	mov    $0x4,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <read>:
SYSCALL(read)
 464:	b8 05 00 00 00       	mov    $0x5,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <write>:
SYSCALL(write)
 46c:	b8 10 00 00 00       	mov    $0x10,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <close>:
SYSCALL(close)
 474:	b8 15 00 00 00       	mov    $0x15,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <kill>:
SYSCALL(kill)
 47c:	b8 06 00 00 00       	mov    $0x6,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <exec>:
SYSCALL(exec)
 484:	b8 07 00 00 00       	mov    $0x7,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <open>:
SYSCALL(open)
 48c:	b8 0f 00 00 00       	mov    $0xf,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <mknod>:
SYSCALL(mknod)
 494:	b8 11 00 00 00       	mov    $0x11,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <unlink>:
SYSCALL(unlink)
 49c:	b8 12 00 00 00       	mov    $0x12,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <fstat>:
SYSCALL(fstat)
 4a4:	b8 08 00 00 00       	mov    $0x8,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <link>:
SYSCALL(link)
 4ac:	b8 13 00 00 00       	mov    $0x13,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <mkdir>:
SYSCALL(mkdir)
 4b4:	b8 14 00 00 00       	mov    $0x14,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <chdir>:
SYSCALL(chdir)
 4bc:	b8 09 00 00 00       	mov    $0x9,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <dup>:
SYSCALL(dup)
 4c4:	b8 0a 00 00 00       	mov    $0xa,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <getpid>:
SYSCALL(getpid)
 4cc:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <sbrk>:
SYSCALL(sbrk)
 4d4:	b8 0c 00 00 00       	mov    $0xc,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <sleep>:
SYSCALL(sleep)
 4dc:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <uptime>:
SYSCALL(uptime)
 4e4:	b8 0e 00 00 00       	mov    $0xe,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <getpinfo>:
SYSCALL(getpinfo)
 4ec:	b8 16 00 00 00       	mov    $0x16,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <settickets>:
SYSCALL(settickets)
 4f4:	b8 17 00 00 00       	mov    $0x17,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4fc:	55                   	push   %ebp
 4fd:	89 e5                	mov    %esp,%ebp
 4ff:	83 ec 18             	sub    $0x18,%esp
 502:	8b 45 0c             	mov    0xc(%ebp),%eax
 505:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 508:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 50f:	00 
 510:	8d 45 f4             	lea    -0xc(%ebp),%eax
 513:	89 44 24 04          	mov    %eax,0x4(%esp)
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	89 04 24             	mov    %eax,(%esp)
 51d:	e8 4a ff ff ff       	call   46c <write>
}
 522:	c9                   	leave  
 523:	c3                   	ret    

00000524 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 524:	55                   	push   %ebp
 525:	89 e5                	mov    %esp,%ebp
 527:	56                   	push   %esi
 528:	53                   	push   %ebx
 529:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 52c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 533:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 537:	74 17                	je     550 <printint+0x2c>
 539:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 53d:	79 11                	jns    550 <printint+0x2c>
    neg = 1;
 53f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 546:	8b 45 0c             	mov    0xc(%ebp),%eax
 549:	f7 d8                	neg    %eax
 54b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 54e:	eb 06                	jmp    556 <printint+0x32>
  } else {
    x = xx;
 550:	8b 45 0c             	mov    0xc(%ebp),%eax
 553:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 55d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 560:	8d 41 01             	lea    0x1(%ecx),%eax
 563:	89 45 f4             	mov    %eax,-0xc(%ebp)
 566:	8b 5d 10             	mov    0x10(%ebp),%ebx
 569:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56c:	ba 00 00 00 00       	mov    $0x0,%edx
 571:	f7 f3                	div    %ebx
 573:	89 d0                	mov    %edx,%eax
 575:	0f b6 80 98 0c 00 00 	movzbl 0xc98(%eax),%eax
 57c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 580:	8b 75 10             	mov    0x10(%ebp),%esi
 583:	8b 45 ec             	mov    -0x14(%ebp),%eax
 586:	ba 00 00 00 00       	mov    $0x0,%edx
 58b:	f7 f6                	div    %esi
 58d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 590:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 594:	75 c7                	jne    55d <printint+0x39>
  if(neg)
 596:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 59a:	74 10                	je     5ac <printint+0x88>
    buf[i++] = '-';
 59c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59f:	8d 50 01             	lea    0x1(%eax),%edx
 5a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5a5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5aa:	eb 1f                	jmp    5cb <printint+0xa7>
 5ac:	eb 1d                	jmp    5cb <printint+0xa7>
    putc(fd, buf[i]);
 5ae:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b4:	01 d0                	add    %edx,%eax
 5b6:	0f b6 00             	movzbl (%eax),%eax
 5b9:	0f be c0             	movsbl %al,%eax
 5bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	89 04 24             	mov    %eax,(%esp)
 5c6:	e8 31 ff ff ff       	call   4fc <putc>
  while(--i >= 0)
 5cb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d3:	79 d9                	jns    5ae <printint+0x8a>
}
 5d5:	83 c4 30             	add    $0x30,%esp
 5d8:	5b                   	pop    %ebx
 5d9:	5e                   	pop    %esi
 5da:	5d                   	pop    %ebp
 5db:	c3                   	ret    

000005dc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5dc:	55                   	push   %ebp
 5dd:	89 e5                	mov    %esp,%ebp
 5df:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5e9:	8d 45 0c             	lea    0xc(%ebp),%eax
 5ec:	83 c0 04             	add    $0x4,%eax
 5ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5f9:	e9 7c 01 00 00       	jmp    77a <printf+0x19e>
    c = fmt[i] & 0xff;
 5fe:	8b 55 0c             	mov    0xc(%ebp),%edx
 601:	8b 45 f0             	mov    -0x10(%ebp),%eax
 604:	01 d0                	add    %edx,%eax
 606:	0f b6 00             	movzbl (%eax),%eax
 609:	0f be c0             	movsbl %al,%eax
 60c:	25 ff 00 00 00       	and    $0xff,%eax
 611:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 614:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 618:	75 2c                	jne    646 <printf+0x6a>
      if(c == '%'){
 61a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 61e:	75 0c                	jne    62c <printf+0x50>
        state = '%';
 620:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 627:	e9 4a 01 00 00       	jmp    776 <printf+0x19a>
      } else {
        putc(fd, c);
 62c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62f:	0f be c0             	movsbl %al,%eax
 632:	89 44 24 04          	mov    %eax,0x4(%esp)
 636:	8b 45 08             	mov    0x8(%ebp),%eax
 639:	89 04 24             	mov    %eax,(%esp)
 63c:	e8 bb fe ff ff       	call   4fc <putc>
 641:	e9 30 01 00 00       	jmp    776 <printf+0x19a>
      }
    } else if(state == '%'){
 646:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 64a:	0f 85 26 01 00 00    	jne    776 <printf+0x19a>
      if(c == 'd'){
 650:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 654:	75 2d                	jne    683 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 656:	8b 45 e8             	mov    -0x18(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 662:	00 
 663:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 66a:	00 
 66b:	89 44 24 04          	mov    %eax,0x4(%esp)
 66f:	8b 45 08             	mov    0x8(%ebp),%eax
 672:	89 04 24             	mov    %eax,(%esp)
 675:	e8 aa fe ff ff       	call   524 <printint>
        ap++;
 67a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67e:	e9 ec 00 00 00       	jmp    76f <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 683:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 687:	74 06                	je     68f <printf+0xb3>
 689:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 68d:	75 2d                	jne    6bc <printf+0xe0>
        printint(fd, *ap, 16, 0);
 68f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 69b:	00 
 69c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6a3:	00 
 6a4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a8:	8b 45 08             	mov    0x8(%ebp),%eax
 6ab:	89 04 24             	mov    %eax,(%esp)
 6ae:	e8 71 fe ff ff       	call   524 <printint>
        ap++;
 6b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b7:	e9 b3 00 00 00       	jmp    76f <printf+0x193>
      } else if(c == 's'){
 6bc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6c0:	75 45                	jne    707 <printf+0x12b>
        s = (char*)*ap;
 6c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c5:	8b 00                	mov    (%eax),%eax
 6c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6d2:	75 09                	jne    6dd <printf+0x101>
          s = "(null)";
 6d4:	c7 45 f4 1c 0a 00 00 	movl   $0xa1c,-0xc(%ebp)
        while(*s != 0){
 6db:	eb 1e                	jmp    6fb <printf+0x11f>
 6dd:	eb 1c                	jmp    6fb <printf+0x11f>
          putc(fd, *s);
 6df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e2:	0f b6 00             	movzbl (%eax),%eax
 6e5:	0f be c0             	movsbl %al,%eax
 6e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ec:	8b 45 08             	mov    0x8(%ebp),%eax
 6ef:	89 04 24             	mov    %eax,(%esp)
 6f2:	e8 05 fe ff ff       	call   4fc <putc>
          s++;
 6f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6fe:	0f b6 00             	movzbl (%eax),%eax
 701:	84 c0                	test   %al,%al
 703:	75 da                	jne    6df <printf+0x103>
 705:	eb 68                	jmp    76f <printf+0x193>
        }
      } else if(c == 'c'){
 707:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 70b:	75 1d                	jne    72a <printf+0x14e>
        putc(fd, *ap);
 70d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 710:	8b 00                	mov    (%eax),%eax
 712:	0f be c0             	movsbl %al,%eax
 715:	89 44 24 04          	mov    %eax,0x4(%esp)
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	89 04 24             	mov    %eax,(%esp)
 71f:	e8 d8 fd ff ff       	call   4fc <putc>
        ap++;
 724:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 728:	eb 45                	jmp    76f <printf+0x193>
      } else if(c == '%'){
 72a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 72e:	75 17                	jne    747 <printf+0x16b>
        putc(fd, c);
 730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 733:	0f be c0             	movsbl %al,%eax
 736:	89 44 24 04          	mov    %eax,0x4(%esp)
 73a:	8b 45 08             	mov    0x8(%ebp),%eax
 73d:	89 04 24             	mov    %eax,(%esp)
 740:	e8 b7 fd ff ff       	call   4fc <putc>
 745:	eb 28                	jmp    76f <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 747:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 74e:	00 
 74f:	8b 45 08             	mov    0x8(%ebp),%eax
 752:	89 04 24             	mov    %eax,(%esp)
 755:	e8 a2 fd ff ff       	call   4fc <putc>
        putc(fd, c);
 75a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 75d:	0f be c0             	movsbl %al,%eax
 760:	89 44 24 04          	mov    %eax,0x4(%esp)
 764:	8b 45 08             	mov    0x8(%ebp),%eax
 767:	89 04 24             	mov    %eax,(%esp)
 76a:	e8 8d fd ff ff       	call   4fc <putc>
      }
      state = 0;
 76f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 776:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 77a:	8b 55 0c             	mov    0xc(%ebp),%edx
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	01 d0                	add    %edx,%eax
 782:	0f b6 00             	movzbl (%eax),%eax
 785:	84 c0                	test   %al,%al
 787:	0f 85 71 fe ff ff    	jne    5fe <printf+0x22>
    }
  }
}
 78d:	c9                   	leave  
 78e:	c3                   	ret    

0000078f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 78f:	55                   	push   %ebp
 790:	89 e5                	mov    %esp,%ebp
 792:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 795:	8b 45 08             	mov    0x8(%ebp),%eax
 798:	83 e8 08             	sub    $0x8,%eax
 79b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	a1 b4 0c 00 00       	mov    0xcb4,%eax
 7a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7a6:	eb 24                	jmp    7cc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ab:	8b 00                	mov    (%eax),%eax
 7ad:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b0:	77 12                	ja     7c4 <free+0x35>
 7b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b8:	77 24                	ja     7de <free+0x4f>
 7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bd:	8b 00                	mov    (%eax),%eax
 7bf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c2:	77 1a                	ja     7de <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	8b 00                	mov    (%eax),%eax
 7c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d2:	76 d4                	jbe    7a8 <free+0x19>
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7dc:	76 ca                	jbe    7a8 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e1:	8b 40 04             	mov    0x4(%eax),%eax
 7e4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ee:	01 c2                	add    %eax,%edx
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f3:	8b 00                	mov    (%eax),%eax
 7f5:	39 c2                	cmp    %eax,%edx
 7f7:	75 24                	jne    81d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fc:	8b 50 04             	mov    0x4(%eax),%edx
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	8b 40 04             	mov    0x4(%eax),%eax
 807:	01 c2                	add    %eax,%edx
 809:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 812:	8b 00                	mov    (%eax),%eax
 814:	8b 10                	mov    (%eax),%edx
 816:	8b 45 f8             	mov    -0x8(%ebp),%eax
 819:	89 10                	mov    %edx,(%eax)
 81b:	eb 0a                	jmp    827 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	8b 10                	mov    (%eax),%edx
 822:	8b 45 f8             	mov    -0x8(%ebp),%eax
 825:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 827:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82a:	8b 40 04             	mov    0x4(%eax),%eax
 82d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 834:	8b 45 fc             	mov    -0x4(%ebp),%eax
 837:	01 d0                	add    %edx,%eax
 839:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 83c:	75 20                	jne    85e <free+0xcf>
    p->s.size += bp->s.size;
 83e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 841:	8b 50 04             	mov    0x4(%eax),%edx
 844:	8b 45 f8             	mov    -0x8(%ebp),%eax
 847:	8b 40 04             	mov    0x4(%eax),%eax
 84a:	01 c2                	add    %eax,%edx
 84c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 852:	8b 45 f8             	mov    -0x8(%ebp),%eax
 855:	8b 10                	mov    (%eax),%edx
 857:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85a:	89 10                	mov    %edx,(%eax)
 85c:	eb 08                	jmp    866 <free+0xd7>
  } else
    p->s.ptr = bp;
 85e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 861:	8b 55 f8             	mov    -0x8(%ebp),%edx
 864:	89 10                	mov    %edx,(%eax)
  freep = p;
 866:	8b 45 fc             	mov    -0x4(%ebp),%eax
 869:	a3 b4 0c 00 00       	mov    %eax,0xcb4
}
 86e:	c9                   	leave  
 86f:	c3                   	ret    

00000870 <morecore>:

static Header*
morecore(uint nu)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 876:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 87d:	77 07                	ja     886 <morecore+0x16>
    nu = 4096;
 87f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 886:	8b 45 08             	mov    0x8(%ebp),%eax
 889:	c1 e0 03             	shl    $0x3,%eax
 88c:	89 04 24             	mov    %eax,(%esp)
 88f:	e8 40 fc ff ff       	call   4d4 <sbrk>
 894:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 897:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 89b:	75 07                	jne    8a4 <morecore+0x34>
    return 0;
 89d:	b8 00 00 00 00       	mov    $0x0,%eax
 8a2:	eb 22                	jmp    8c6 <morecore+0x56>
  hp = (Header*)p;
 8a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ad:	8b 55 08             	mov    0x8(%ebp),%edx
 8b0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b6:	83 c0 08             	add    $0x8,%eax
 8b9:	89 04 24             	mov    %eax,(%esp)
 8bc:	e8 ce fe ff ff       	call   78f <free>
  return freep;
 8c1:	a1 b4 0c 00 00       	mov    0xcb4,%eax
}
 8c6:	c9                   	leave  
 8c7:	c3                   	ret    

000008c8 <malloc>:

void*
malloc(uint nbytes)
{
 8c8:	55                   	push   %ebp
 8c9:	89 e5                	mov    %esp,%ebp
 8cb:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ce:	8b 45 08             	mov    0x8(%ebp),%eax
 8d1:	83 c0 07             	add    $0x7,%eax
 8d4:	c1 e8 03             	shr    $0x3,%eax
 8d7:	83 c0 01             	add    $0x1,%eax
 8da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8dd:	a1 b4 0c 00 00       	mov    0xcb4,%eax
 8e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e9:	75 23                	jne    90e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8eb:	c7 45 f0 ac 0c 00 00 	movl   $0xcac,-0x10(%ebp)
 8f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f5:	a3 b4 0c 00 00       	mov    %eax,0xcb4
 8fa:	a1 b4 0c 00 00       	mov    0xcb4,%eax
 8ff:	a3 ac 0c 00 00       	mov    %eax,0xcac
    base.s.size = 0;
 904:	c7 05 b0 0c 00 00 00 	movl   $0x0,0xcb0
 90b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 911:	8b 00                	mov    (%eax),%eax
 913:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	8b 40 04             	mov    0x4(%eax),%eax
 91c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 91f:	72 4d                	jb     96e <malloc+0xa6>
      if(p->s.size == nunits)
 921:	8b 45 f4             	mov    -0xc(%ebp),%eax
 924:	8b 40 04             	mov    0x4(%eax),%eax
 927:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 92a:	75 0c                	jne    938 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 92c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92f:	8b 10                	mov    (%eax),%edx
 931:	8b 45 f0             	mov    -0x10(%ebp),%eax
 934:	89 10                	mov    %edx,(%eax)
 936:	eb 26                	jmp    95e <malloc+0x96>
      else {
        p->s.size -= nunits;
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	8b 40 04             	mov    0x4(%eax),%eax
 93e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 941:	89 c2                	mov    %eax,%edx
 943:	8b 45 f4             	mov    -0xc(%ebp),%eax
 946:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 949:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94c:	8b 40 04             	mov    0x4(%eax),%eax
 94f:	c1 e0 03             	shl    $0x3,%eax
 952:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	8b 55 ec             	mov    -0x14(%ebp),%edx
 95b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 95e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 961:	a3 b4 0c 00 00       	mov    %eax,0xcb4
      return (void*)(p + 1);
 966:	8b 45 f4             	mov    -0xc(%ebp),%eax
 969:	83 c0 08             	add    $0x8,%eax
 96c:	eb 38                	jmp    9a6 <malloc+0xde>
    }
    if(p == freep)
 96e:	a1 b4 0c 00 00       	mov    0xcb4,%eax
 973:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 976:	75 1b                	jne    993 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 978:	8b 45 ec             	mov    -0x14(%ebp),%eax
 97b:	89 04 24             	mov    %eax,(%esp)
 97e:	e8 ed fe ff ff       	call   870 <morecore>
 983:	89 45 f4             	mov    %eax,-0xc(%ebp)
 986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 98a:	75 07                	jne    993 <malloc+0xcb>
        return 0;
 98c:	b8 00 00 00 00       	mov    $0x0,%eax
 991:	eb 13                	jmp    9a6 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 993:	8b 45 f4             	mov    -0xc(%ebp),%eax
 996:	89 45 f0             	mov    %eax,-0x10(%ebp)
 999:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99c:	8b 00                	mov    (%eax),%eax
 99e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 9a1:	e9 70 ff ff ff       	jmp    916 <malloc+0x4e>
}
 9a6:	c9                   	leave  
 9a7:	c3                   	ret    
