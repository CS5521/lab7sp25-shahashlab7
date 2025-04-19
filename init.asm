
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 2b 0a 00 00 	movl   $0xa2b,(%esp)
  18:	e8 ef 04 00 00       	call   50c <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 2b 0a 00 00 	movl   $0xa2b,(%esp)
  38:	e8 d7 04 00 00       	call   514 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 2b 0a 00 00 	movl   $0xa2b,(%esp)
  4c:	e8 bb 04 00 00       	call   50c <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 e7 04 00 00       	call   544 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 db 04 00 00       	call   544 <dup>

  for(;;){
    printf(1, "init: starting sh\n");
  69:	c7 44 24 04 33 0a 00 	movl   $0xa33,0x4(%esp)
  70:	00 
  71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  78:	e8 df 05 00 00       	call   65c <printf>
    pid = fork();
  7d:	e8 42 04 00 00       	call   4c4 <fork>
  82:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  86:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8b:	79 19                	jns    a6 <main+0xa6>
      printf(1, "init: fork failed\n");
  8d:	c7 44 24 04 46 0a 00 	movl   $0xa46,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 bb 05 00 00       	call   65c <printf>
      exit();
  a1:	e8 26 04 00 00       	call   4cc <exit>
    }
    if(pid == 0){
  a6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ab:	75 2d                	jne    da <main+0xda>
      exec("sh", argv);
  ad:	c7 44 24 04 38 0d 00 	movl   $0xd38,0x4(%esp)
  b4:	00 
  b5:	c7 04 24 28 0a 00 00 	movl   $0xa28,(%esp)
  bc:	e8 43 04 00 00       	call   504 <exec>
      printf(1, "init: exec sh failed\n");
  c1:	c7 44 24 04 59 0a 00 	movl   $0xa59,0x4(%esp)
  c8:	00 
  c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d0:	e8 87 05 00 00       	call   65c <printf>
      exit();
  d5:	e8 f2 03 00 00       	call   4cc <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  da:	eb 14                	jmp    f0 <main+0xf0>
      printf(1, "zombie!\n");
  dc:	c7 44 24 04 6f 0a 00 	movl   $0xa6f,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  eb:	e8 6c 05 00 00       	call   65c <printf>
    while((wpid=wait()) >= 0 && wpid != pid)
  f0:	e8 df 03 00 00       	call   4d4 <wait>
  f5:	89 44 24 18          	mov    %eax,0x18(%esp)
  f9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  fe:	78 0a                	js     10a <main+0x10a>
 100:	8b 44 24 18          	mov    0x18(%esp),%eax
 104:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 108:	75 d2                	jne    dc <main+0xdc>
  }
 10a:	e9 5a ff ff ff       	jmp    69 <main+0x69>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	5b                   	pop    %ebx
 131:	5f                   	pop    %edi
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    

00000134 <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	57                   	push   %edi
 138:	56                   	push   %esi
 139:	53                   	push   %ebx
 13a:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
 140:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
 146:	89 04 24             	mov    %eax,(%esp)
 149:	e8 1e 04 00 00       	call   56c <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 14e:	c7 44 24 04 78 0a 00 	movl   $0xa78,0x4(%esp)
 155:	00 
 156:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 15d:	e8 fa 04 00 00       	call   65c <printf>
    for (i = 0; i < NPROC; i++) {
 162:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 169:	e9 06 01 00 00       	jmp    274 <ps+0x140>
        if (ptable[i].inuse) {
 16e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 171:	89 d0                	mov    %edx,%eax
 173:	c1 e0 03             	shl    $0x3,%eax
 176:	01 d0                	add    %edx,%eax
 178:	c1 e0 02             	shl    $0x2,%eax
 17b:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 17e:	01 d8                	add    %ebx,%eax
 180:	2d 08 09 00 00       	sub    $0x908,%eax
 185:	8b 00                	mov    (%eax),%eax
 187:	85 c0                	test   %eax,%eax
 189:	0f 84 e1 00 00 00    	je     270 <ps+0x13c>
            char stat = '?';
 18f:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
 193:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 196:	89 d0                	mov    %edx,%eax
 198:	c1 e0 03             	shl    $0x3,%eax
 19b:	01 d0                	add    %edx,%eax
 19d:	c1 e0 02             	shl    $0x2,%eax
 1a0:	8d 75 e8             	lea    -0x18(%ebp),%esi
 1a3:	01 f0                	add    %esi,%eax
 1a5:	2d e8 08 00 00       	sub    $0x8e8,%eax
 1aa:	0f b6 00             	movzbl (%eax),%eax
 1ad:	0f be c0             	movsbl %al,%eax
 1b0:	83 f8 05             	cmp    $0x5,%eax
 1b3:	77 27                	ja     1dc <ps+0xa8>
 1b5:	8b 04 85 a4 0a 00 00 	mov    0xaa4(,%eax,4),%eax
 1bc:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
 1be:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
 1c2:	eb 1c                	jmp    1e0 <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
 1c4:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 1c8:	eb 16                	jmp    1e0 <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
 1ca:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
 1ce:	eb 10                	jmp    1e0 <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
 1d0:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
 1d4:	eb 0a                	jmp    1e0 <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
 1d6:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
 1da:	eb 04                	jmp    1e0 <ps+0xac>
                default: stat = '?';
 1dc:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
 1e0:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
 1e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1e9:	89 d0                	mov    %edx,%eax
 1eb:	c1 e0 03             	shl    $0x3,%eax
 1ee:	01 d0                	add    %edx,%eax
 1f0:	c1 e0 02             	shl    $0x2,%eax
 1f3:	83 c0 10             	add    $0x10,%eax
 1f6:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 1f9:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 1fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 200:	89 d0                	mov    %edx,%eax
 202:	c1 e0 03             	shl    $0x3,%eax
 205:	01 d0                	add    %edx,%eax
 207:	c1 e0 02             	shl    $0x2,%eax
 20a:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 20d:	01 c8                	add    %ecx,%eax
 20f:	2d fc 08 00 00       	sub    $0x8fc,%eax
 214:	8b 18                	mov    (%eax),%ebx
 216:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 219:	89 d0                	mov    %edx,%eax
 21b:	c1 e0 03             	shl    $0x3,%eax
 21e:	01 d0                	add    %edx,%eax
 220:	c1 e0 02             	shl    $0x2,%eax
 223:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 226:	01 c8                	add    %ecx,%eax
 228:	2d 04 09 00 00       	sub    $0x904,%eax
 22d:	8b 08                	mov    (%eax),%ecx
 22f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 232:	89 d0                	mov    %edx,%eax
 234:	c1 e0 03             	shl    $0x3,%eax
 237:	01 d0                	add    %edx,%eax
 239:	c1 e0 02             	shl    $0x2,%eax
 23c:	8d 55 e8             	lea    -0x18(%ebp),%edx
 23f:	01 d0                	add    %edx,%eax
 241:	2d 00 09 00 00       	sub    $0x900,%eax
 246:	8b 00                	mov    (%eax),%eax
 248:	89 7c 24 18          	mov    %edi,0x18(%esp)
 24c:	89 74 24 14          	mov    %esi,0x14(%esp)
 250:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 254:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 258:	89 44 24 08          	mov    %eax,0x8(%esp)
 25c:	c7 44 24 04 91 0a 00 	movl   $0xa91,0x4(%esp)
 263:	00 
 264:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 26b:	e8 ec 03 00 00       	call   65c <printf>
    for (i = 0; i < NPROC; i++) {
 270:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 274:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 278:	0f 8e f0 fe ff ff    	jle    16e <ps+0x3a>
        }
    }
}
 27e:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 284:	5b                   	pop    %ebx
 285:	5e                   	pop    %esi
 286:	5f                   	pop    %edi
 287:	5d                   	pop    %ebp
 288:	c3                   	ret    

00000289 <strcpy>:


char*
strcpy(char *s, const char *t)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 295:	90                   	nop
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	8d 50 01             	lea    0x1(%eax),%edx
 29c:	89 55 08             	mov    %edx,0x8(%ebp)
 29f:	8b 55 0c             	mov    0xc(%ebp),%edx
 2a2:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2a8:	0f b6 12             	movzbl (%edx),%edx
 2ab:	88 10                	mov    %dl,(%eax)
 2ad:	0f b6 00             	movzbl (%eax),%eax
 2b0:	84 c0                	test   %al,%al
 2b2:	75 e2                	jne    296 <strcpy+0xd>
    ;
  return os;
 2b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b7:	c9                   	leave  
 2b8:	c3                   	ret    

000002b9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2b9:	55                   	push   %ebp
 2ba:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2bc:	eb 08                	jmp    2c6 <strcmp+0xd>
    p++, q++;
 2be:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	0f b6 00             	movzbl (%eax),%eax
 2cc:	84 c0                	test   %al,%al
 2ce:	74 10                	je     2e0 <strcmp+0x27>
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	0f b6 10             	movzbl (%eax),%edx
 2d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d9:	0f b6 00             	movzbl (%eax),%eax
 2dc:	38 c2                	cmp    %al,%dl
 2de:	74 de                	je     2be <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	0f b6 00             	movzbl (%eax),%eax
 2e6:	0f b6 d0             	movzbl %al,%edx
 2e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	0f b6 c0             	movzbl %al,%eax
 2f2:	29 c2                	sub    %eax,%edx
 2f4:	89 d0                	mov    %edx,%eax
}
 2f6:	5d                   	pop    %ebp
 2f7:	c3                   	ret    

000002f8 <strlen>:

uint
strlen(const char *s)
{
 2f8:	55                   	push   %ebp
 2f9:	89 e5                	mov    %esp,%ebp
 2fb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 305:	eb 04                	jmp    30b <strlen+0x13>
 307:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 30b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30e:	8b 45 08             	mov    0x8(%ebp),%eax
 311:	01 d0                	add    %edx,%eax
 313:	0f b6 00             	movzbl (%eax),%eax
 316:	84 c0                	test   %al,%al
 318:	75 ed                	jne    307 <strlen+0xf>
    ;
  return n;
 31a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31d:	c9                   	leave  
 31e:	c3                   	ret    

0000031f <memset>:

void*
memset(void *dst, int c, uint n)
{
 31f:	55                   	push   %ebp
 320:	89 e5                	mov    %esp,%ebp
 322:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 325:	8b 45 10             	mov    0x10(%ebp),%eax
 328:	89 44 24 08          	mov    %eax,0x8(%esp)
 32c:	8b 45 0c             	mov    0xc(%ebp),%eax
 32f:	89 44 24 04          	mov    %eax,0x4(%esp)
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	89 04 24             	mov    %eax,(%esp)
 339:	e8 d1 fd ff ff       	call   10f <stosb>
  return dst;
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 341:	c9                   	leave  
 342:	c3                   	ret    

00000343 <strchr>:

char*
strchr(const char *s, char c)
{
 343:	55                   	push   %ebp
 344:	89 e5                	mov    %esp,%ebp
 346:	83 ec 04             	sub    $0x4,%esp
 349:	8b 45 0c             	mov    0xc(%ebp),%eax
 34c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 34f:	eb 14                	jmp    365 <strchr+0x22>
    if(*s == c)
 351:	8b 45 08             	mov    0x8(%ebp),%eax
 354:	0f b6 00             	movzbl (%eax),%eax
 357:	3a 45 fc             	cmp    -0x4(%ebp),%al
 35a:	75 05                	jne    361 <strchr+0x1e>
      return (char*)s;
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	eb 13                	jmp    374 <strchr+0x31>
  for(; *s; s++)
 361:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	0f b6 00             	movzbl (%eax),%eax
 36b:	84 c0                	test   %al,%al
 36d:	75 e2                	jne    351 <strchr+0xe>
  return 0;
 36f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 374:	c9                   	leave  
 375:	c3                   	ret    

00000376 <gets>:

char*
gets(char *buf, int max)
{
 376:	55                   	push   %ebp
 377:	89 e5                	mov    %esp,%ebp
 379:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 37c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 383:	eb 4c                	jmp    3d1 <gets+0x5b>
    cc = read(0, &c, 1);
 385:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 38c:	00 
 38d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 390:	89 44 24 04          	mov    %eax,0x4(%esp)
 394:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 39b:	e8 44 01 00 00       	call   4e4 <read>
 3a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3a7:	7f 02                	jg     3ab <gets+0x35>
      break;
 3a9:	eb 31                	jmp    3dc <gets+0x66>
    buf[i++] = c;
 3ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ae:	8d 50 01             	lea    0x1(%eax),%edx
 3b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3b4:	89 c2                	mov    %eax,%edx
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	01 c2                	add    %eax,%edx
 3bb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3bf:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3c1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3c5:	3c 0a                	cmp    $0xa,%al
 3c7:	74 13                	je     3dc <gets+0x66>
 3c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3cd:	3c 0d                	cmp    $0xd,%al
 3cf:	74 0b                	je     3dc <gets+0x66>
  for(i=0; i+1 < max; ){
 3d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d4:	83 c0 01             	add    $0x1,%eax
 3d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3da:	7c a9                	jl     385 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 3dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3df:	8b 45 08             	mov    0x8(%ebp),%eax
 3e2:	01 d0                	add    %edx,%eax
 3e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ea:	c9                   	leave  
 3eb:	c3                   	ret    

000003ec <stat>:

int
stat(const char *n, struct stat *st)
{
 3ec:	55                   	push   %ebp
 3ed:	89 e5                	mov    %esp,%ebp
 3ef:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3f9:	00 
 3fa:	8b 45 08             	mov    0x8(%ebp),%eax
 3fd:	89 04 24             	mov    %eax,(%esp)
 400:	e8 07 01 00 00       	call   50c <open>
 405:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 408:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 40c:	79 07                	jns    415 <stat+0x29>
    return -1;
 40e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 413:	eb 23                	jmp    438 <stat+0x4c>
  r = fstat(fd, st);
 415:	8b 45 0c             	mov    0xc(%ebp),%eax
 418:	89 44 24 04          	mov    %eax,0x4(%esp)
 41c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41f:	89 04 24             	mov    %eax,(%esp)
 422:	e8 fd 00 00 00       	call   524 <fstat>
 427:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 42a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42d:	89 04 24             	mov    %eax,(%esp)
 430:	e8 bf 00 00 00       	call   4f4 <close>
  return r;
 435:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 438:	c9                   	leave  
 439:	c3                   	ret    

0000043a <atoi>:

int
atoi(const char *s)
{
 43a:	55                   	push   %ebp
 43b:	89 e5                	mov    %esp,%ebp
 43d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 447:	eb 25                	jmp    46e <atoi+0x34>
    n = n*10 + *s++ - '0';
 449:	8b 55 fc             	mov    -0x4(%ebp),%edx
 44c:	89 d0                	mov    %edx,%eax
 44e:	c1 e0 02             	shl    $0x2,%eax
 451:	01 d0                	add    %edx,%eax
 453:	01 c0                	add    %eax,%eax
 455:	89 c1                	mov    %eax,%ecx
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	8d 50 01             	lea    0x1(%eax),%edx
 45d:	89 55 08             	mov    %edx,0x8(%ebp)
 460:	0f b6 00             	movzbl (%eax),%eax
 463:	0f be c0             	movsbl %al,%eax
 466:	01 c8                	add    %ecx,%eax
 468:	83 e8 30             	sub    $0x30,%eax
 46b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 46e:	8b 45 08             	mov    0x8(%ebp),%eax
 471:	0f b6 00             	movzbl (%eax),%eax
 474:	3c 2f                	cmp    $0x2f,%al
 476:	7e 0a                	jle    482 <atoi+0x48>
 478:	8b 45 08             	mov    0x8(%ebp),%eax
 47b:	0f b6 00             	movzbl (%eax),%eax
 47e:	3c 39                	cmp    $0x39,%al
 480:	7e c7                	jle    449 <atoi+0xf>
  return n;
 482:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 485:	c9                   	leave  
 486:	c3                   	ret    

00000487 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 487:	55                   	push   %ebp
 488:	89 e5                	mov    %esp,%ebp
 48a:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 493:	8b 45 0c             	mov    0xc(%ebp),%eax
 496:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 499:	eb 17                	jmp    4b2 <memmove+0x2b>
    *dst++ = *src++;
 49b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 49e:	8d 50 01             	lea    0x1(%eax),%edx
 4a1:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4a4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4a7:	8d 4a 01             	lea    0x1(%edx),%ecx
 4aa:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4ad:	0f b6 12             	movzbl (%edx),%edx
 4b0:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 4b2:	8b 45 10             	mov    0x10(%ebp),%eax
 4b5:	8d 50 ff             	lea    -0x1(%eax),%edx
 4b8:	89 55 10             	mov    %edx,0x10(%ebp)
 4bb:	85 c0                	test   %eax,%eax
 4bd:	7f dc                	jg     49b <memmove+0x14>
  return vdst;
 4bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4c2:	c9                   	leave  
 4c3:	c3                   	ret    

000004c4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4c4:	b8 01 00 00 00       	mov    $0x1,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <exit>:
SYSCALL(exit)
 4cc:	b8 02 00 00 00       	mov    $0x2,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <wait>:
SYSCALL(wait)
 4d4:	b8 03 00 00 00       	mov    $0x3,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <pipe>:
SYSCALL(pipe)
 4dc:	b8 04 00 00 00       	mov    $0x4,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <read>:
SYSCALL(read)
 4e4:	b8 05 00 00 00       	mov    $0x5,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <write>:
SYSCALL(write)
 4ec:	b8 10 00 00 00       	mov    $0x10,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <close>:
SYSCALL(close)
 4f4:	b8 15 00 00 00       	mov    $0x15,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <kill>:
SYSCALL(kill)
 4fc:	b8 06 00 00 00       	mov    $0x6,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <exec>:
SYSCALL(exec)
 504:	b8 07 00 00 00       	mov    $0x7,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <open>:
SYSCALL(open)
 50c:	b8 0f 00 00 00       	mov    $0xf,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <mknod>:
SYSCALL(mknod)
 514:	b8 11 00 00 00       	mov    $0x11,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <unlink>:
SYSCALL(unlink)
 51c:	b8 12 00 00 00       	mov    $0x12,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <fstat>:
SYSCALL(fstat)
 524:	b8 08 00 00 00       	mov    $0x8,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <link>:
SYSCALL(link)
 52c:	b8 13 00 00 00       	mov    $0x13,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <mkdir>:
SYSCALL(mkdir)
 534:	b8 14 00 00 00       	mov    $0x14,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <chdir>:
SYSCALL(chdir)
 53c:	b8 09 00 00 00       	mov    $0x9,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <dup>:
SYSCALL(dup)
 544:	b8 0a 00 00 00       	mov    $0xa,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <getpid>:
SYSCALL(getpid)
 54c:	b8 0b 00 00 00       	mov    $0xb,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <sbrk>:
SYSCALL(sbrk)
 554:	b8 0c 00 00 00       	mov    $0xc,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <sleep>:
SYSCALL(sleep)
 55c:	b8 0d 00 00 00       	mov    $0xd,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <uptime>:
SYSCALL(uptime)
 564:	b8 0e 00 00 00       	mov    $0xe,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <getpinfo>:
SYSCALL(getpinfo)
 56c:	b8 16 00 00 00       	mov    $0x16,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <settickets>:
SYSCALL(settickets)
 574:	b8 17 00 00 00       	mov    $0x17,%eax
 579:	cd 40                	int    $0x40
 57b:	c3                   	ret    

0000057c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 57c:	55                   	push   %ebp
 57d:	89 e5                	mov    %esp,%ebp
 57f:	83 ec 18             	sub    $0x18,%esp
 582:	8b 45 0c             	mov    0xc(%ebp),%eax
 585:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 588:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 58f:	00 
 590:	8d 45 f4             	lea    -0xc(%ebp),%eax
 593:	89 44 24 04          	mov    %eax,0x4(%esp)
 597:	8b 45 08             	mov    0x8(%ebp),%eax
 59a:	89 04 24             	mov    %eax,(%esp)
 59d:	e8 4a ff ff ff       	call   4ec <write>
}
 5a2:	c9                   	leave  
 5a3:	c3                   	ret    

000005a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a4:	55                   	push   %ebp
 5a5:	89 e5                	mov    %esp,%ebp
 5a7:	56                   	push   %esi
 5a8:	53                   	push   %ebx
 5a9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5b3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5b7:	74 17                	je     5d0 <printint+0x2c>
 5b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5bd:	79 11                	jns    5d0 <printint+0x2c>
    neg = 1;
 5bf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c9:	f7 d8                	neg    %eax
 5cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5ce:	eb 06                	jmp    5d6 <printint+0x32>
  } else {
    x = xx;
 5d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5dd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5e0:	8d 41 01             	lea    0x1(%ecx),%eax
 5e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5ec:	ba 00 00 00 00       	mov    $0x0,%edx
 5f1:	f7 f3                	div    %ebx
 5f3:	89 d0                	mov    %edx,%eax
 5f5:	0f b6 80 40 0d 00 00 	movzbl 0xd40(%eax),%eax
 5fc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 600:	8b 75 10             	mov    0x10(%ebp),%esi
 603:	8b 45 ec             	mov    -0x14(%ebp),%eax
 606:	ba 00 00 00 00       	mov    $0x0,%edx
 60b:	f7 f6                	div    %esi
 60d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 610:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 614:	75 c7                	jne    5dd <printint+0x39>
  if(neg)
 616:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 61a:	74 10                	je     62c <printint+0x88>
    buf[i++] = '-';
 61c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61f:	8d 50 01             	lea    0x1(%eax),%edx
 622:	89 55 f4             	mov    %edx,-0xc(%ebp)
 625:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 62a:	eb 1f                	jmp    64b <printint+0xa7>
 62c:	eb 1d                	jmp    64b <printint+0xa7>
    putc(fd, buf[i]);
 62e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 631:	8b 45 f4             	mov    -0xc(%ebp),%eax
 634:	01 d0                	add    %edx,%eax
 636:	0f b6 00             	movzbl (%eax),%eax
 639:	0f be c0             	movsbl %al,%eax
 63c:	89 44 24 04          	mov    %eax,0x4(%esp)
 640:	8b 45 08             	mov    0x8(%ebp),%eax
 643:	89 04 24             	mov    %eax,(%esp)
 646:	e8 31 ff ff ff       	call   57c <putc>
  while(--i >= 0)
 64b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 64f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 653:	79 d9                	jns    62e <printint+0x8a>
}
 655:	83 c4 30             	add    $0x30,%esp
 658:	5b                   	pop    %ebx
 659:	5e                   	pop    %esi
 65a:	5d                   	pop    %ebp
 65b:	c3                   	ret    

0000065c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 65c:	55                   	push   %ebp
 65d:	89 e5                	mov    %esp,%ebp
 65f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 662:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 669:	8d 45 0c             	lea    0xc(%ebp),%eax
 66c:	83 c0 04             	add    $0x4,%eax
 66f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 672:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 679:	e9 7c 01 00 00       	jmp    7fa <printf+0x19e>
    c = fmt[i] & 0xff;
 67e:	8b 55 0c             	mov    0xc(%ebp),%edx
 681:	8b 45 f0             	mov    -0x10(%ebp),%eax
 684:	01 d0                	add    %edx,%eax
 686:	0f b6 00             	movzbl (%eax),%eax
 689:	0f be c0             	movsbl %al,%eax
 68c:	25 ff 00 00 00       	and    $0xff,%eax
 691:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 694:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 698:	75 2c                	jne    6c6 <printf+0x6a>
      if(c == '%'){
 69a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 69e:	75 0c                	jne    6ac <printf+0x50>
        state = '%';
 6a0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6a7:	e9 4a 01 00 00       	jmp    7f6 <printf+0x19a>
      } else {
        putc(fd, c);
 6ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6af:	0f be c0             	movsbl %al,%eax
 6b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	89 04 24             	mov    %eax,(%esp)
 6bc:	e8 bb fe ff ff       	call   57c <putc>
 6c1:	e9 30 01 00 00       	jmp    7f6 <printf+0x19a>
      }
    } else if(state == '%'){
 6c6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6ca:	0f 85 26 01 00 00    	jne    7f6 <printf+0x19a>
      if(c == 'd'){
 6d0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6d4:	75 2d                	jne    703 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 6d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6e2:	00 
 6e3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6ea:	00 
 6eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ef:	8b 45 08             	mov    0x8(%ebp),%eax
 6f2:	89 04 24             	mov    %eax,(%esp)
 6f5:	e8 aa fe ff ff       	call   5a4 <printint>
        ap++;
 6fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6fe:	e9 ec 00 00 00       	jmp    7ef <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 703:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 707:	74 06                	je     70f <printf+0xb3>
 709:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 70d:	75 2d                	jne    73c <printf+0xe0>
        printint(fd, *ap, 16, 0);
 70f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 712:	8b 00                	mov    (%eax),%eax
 714:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 71b:	00 
 71c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 723:	00 
 724:	89 44 24 04          	mov    %eax,0x4(%esp)
 728:	8b 45 08             	mov    0x8(%ebp),%eax
 72b:	89 04 24             	mov    %eax,(%esp)
 72e:	e8 71 fe ff ff       	call   5a4 <printint>
        ap++;
 733:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 737:	e9 b3 00 00 00       	jmp    7ef <printf+0x193>
      } else if(c == 's'){
 73c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 740:	75 45                	jne    787 <printf+0x12b>
        s = (char*)*ap;
 742:	8b 45 e8             	mov    -0x18(%ebp),%eax
 745:	8b 00                	mov    (%eax),%eax
 747:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 74a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 74e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 752:	75 09                	jne    75d <printf+0x101>
          s = "(null)";
 754:	c7 45 f4 bc 0a 00 00 	movl   $0xabc,-0xc(%ebp)
        while(*s != 0){
 75b:	eb 1e                	jmp    77b <printf+0x11f>
 75d:	eb 1c                	jmp    77b <printf+0x11f>
          putc(fd, *s);
 75f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 762:	0f b6 00             	movzbl (%eax),%eax
 765:	0f be c0             	movsbl %al,%eax
 768:	89 44 24 04          	mov    %eax,0x4(%esp)
 76c:	8b 45 08             	mov    0x8(%ebp),%eax
 76f:	89 04 24             	mov    %eax,(%esp)
 772:	e8 05 fe ff ff       	call   57c <putc>
          s++;
 777:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77e:	0f b6 00             	movzbl (%eax),%eax
 781:	84 c0                	test   %al,%al
 783:	75 da                	jne    75f <printf+0x103>
 785:	eb 68                	jmp    7ef <printf+0x193>
        }
      } else if(c == 'c'){
 787:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 78b:	75 1d                	jne    7aa <printf+0x14e>
        putc(fd, *ap);
 78d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 790:	8b 00                	mov    (%eax),%eax
 792:	0f be c0             	movsbl %al,%eax
 795:	89 44 24 04          	mov    %eax,0x4(%esp)
 799:	8b 45 08             	mov    0x8(%ebp),%eax
 79c:	89 04 24             	mov    %eax,(%esp)
 79f:	e8 d8 fd ff ff       	call   57c <putc>
        ap++;
 7a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a8:	eb 45                	jmp    7ef <printf+0x193>
      } else if(c == '%'){
 7aa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ae:	75 17                	jne    7c7 <printf+0x16b>
        putc(fd, c);
 7b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b3:	0f be c0             	movsbl %al,%eax
 7b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ba:	8b 45 08             	mov    0x8(%ebp),%eax
 7bd:	89 04 24             	mov    %eax,(%esp)
 7c0:	e8 b7 fd ff ff       	call   57c <putc>
 7c5:	eb 28                	jmp    7ef <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7c7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7ce:	00 
 7cf:	8b 45 08             	mov    0x8(%ebp),%eax
 7d2:	89 04 24             	mov    %eax,(%esp)
 7d5:	e8 a2 fd ff ff       	call   57c <putc>
        putc(fd, c);
 7da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7dd:	0f be c0             	movsbl %al,%eax
 7e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e4:	8b 45 08             	mov    0x8(%ebp),%eax
 7e7:	89 04 24             	mov    %eax,(%esp)
 7ea:	e8 8d fd ff ff       	call   57c <putc>
      }
      state = 0;
 7ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 7f6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7fa:	8b 55 0c             	mov    0xc(%ebp),%edx
 7fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 800:	01 d0                	add    %edx,%eax
 802:	0f b6 00             	movzbl (%eax),%eax
 805:	84 c0                	test   %al,%al
 807:	0f 85 71 fe ff ff    	jne    67e <printf+0x22>
    }
  }
}
 80d:	c9                   	leave  
 80e:	c3                   	ret    

0000080f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80f:	55                   	push   %ebp
 810:	89 e5                	mov    %esp,%ebp
 812:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 815:	8b 45 08             	mov    0x8(%ebp),%eax
 818:	83 e8 08             	sub    $0x8,%eax
 81b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81e:	a1 5c 0d 00 00       	mov    0xd5c,%eax
 823:	89 45 fc             	mov    %eax,-0x4(%ebp)
 826:	eb 24                	jmp    84c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	8b 00                	mov    (%eax),%eax
 82d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 830:	77 12                	ja     844 <free+0x35>
 832:	8b 45 f8             	mov    -0x8(%ebp),%eax
 835:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 838:	77 24                	ja     85e <free+0x4f>
 83a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83d:	8b 00                	mov    (%eax),%eax
 83f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 842:	77 1a                	ja     85e <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 844:	8b 45 fc             	mov    -0x4(%ebp),%eax
 847:	8b 00                	mov    (%eax),%eax
 849:	89 45 fc             	mov    %eax,-0x4(%ebp)
 84c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 852:	76 d4                	jbe    828 <free+0x19>
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 85c:	76 ca                	jbe    828 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 85e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 861:	8b 40 04             	mov    0x4(%eax),%eax
 864:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 86b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86e:	01 c2                	add    %eax,%edx
 870:	8b 45 fc             	mov    -0x4(%ebp),%eax
 873:	8b 00                	mov    (%eax),%eax
 875:	39 c2                	cmp    %eax,%edx
 877:	75 24                	jne    89d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 879:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87c:	8b 50 04             	mov    0x4(%eax),%edx
 87f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 882:	8b 00                	mov    (%eax),%eax
 884:	8b 40 04             	mov    0x4(%eax),%eax
 887:	01 c2                	add    %eax,%edx
 889:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 88f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 892:	8b 00                	mov    (%eax),%eax
 894:	8b 10                	mov    (%eax),%edx
 896:	8b 45 f8             	mov    -0x8(%ebp),%eax
 899:	89 10                	mov    %edx,(%eax)
 89b:	eb 0a                	jmp    8a7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 89d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a0:	8b 10                	mov    (%eax),%edx
 8a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8aa:	8b 40 04             	mov    0x4(%eax),%eax
 8ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b7:	01 d0                	add    %edx,%eax
 8b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8bc:	75 20                	jne    8de <free+0xcf>
    p->s.size += bp->s.size;
 8be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c1:	8b 50 04             	mov    0x4(%eax),%edx
 8c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c7:	8b 40 04             	mov    0x4(%eax),%eax
 8ca:	01 c2                	add    %eax,%edx
 8cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d5:	8b 10                	mov    (%eax),%edx
 8d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8da:	89 10                	mov    %edx,(%eax)
 8dc:	eb 08                	jmp    8e6 <free+0xd7>
  } else
    p->s.ptr = bp;
 8de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8e4:	89 10                	mov    %edx,(%eax)
  freep = p;
 8e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e9:	a3 5c 0d 00 00       	mov    %eax,0xd5c
}
 8ee:	c9                   	leave  
 8ef:	c3                   	ret    

000008f0 <morecore>:

static Header*
morecore(uint nu)
{
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8f6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8fd:	77 07                	ja     906 <morecore+0x16>
    nu = 4096;
 8ff:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 906:	8b 45 08             	mov    0x8(%ebp),%eax
 909:	c1 e0 03             	shl    $0x3,%eax
 90c:	89 04 24             	mov    %eax,(%esp)
 90f:	e8 40 fc ff ff       	call   554 <sbrk>
 914:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 917:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 91b:	75 07                	jne    924 <morecore+0x34>
    return 0;
 91d:	b8 00 00 00 00       	mov    $0x0,%eax
 922:	eb 22                	jmp    946 <morecore+0x56>
  hp = (Header*)p;
 924:	8b 45 f4             	mov    -0xc(%ebp),%eax
 927:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 92a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92d:	8b 55 08             	mov    0x8(%ebp),%edx
 930:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 933:	8b 45 f0             	mov    -0x10(%ebp),%eax
 936:	83 c0 08             	add    $0x8,%eax
 939:	89 04 24             	mov    %eax,(%esp)
 93c:	e8 ce fe ff ff       	call   80f <free>
  return freep;
 941:	a1 5c 0d 00 00       	mov    0xd5c,%eax
}
 946:	c9                   	leave  
 947:	c3                   	ret    

00000948 <malloc>:

void*
malloc(uint nbytes)
{
 948:	55                   	push   %ebp
 949:	89 e5                	mov    %esp,%ebp
 94b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 94e:	8b 45 08             	mov    0x8(%ebp),%eax
 951:	83 c0 07             	add    $0x7,%eax
 954:	c1 e8 03             	shr    $0x3,%eax
 957:	83 c0 01             	add    $0x1,%eax
 95a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 95d:	a1 5c 0d 00 00       	mov    0xd5c,%eax
 962:	89 45 f0             	mov    %eax,-0x10(%ebp)
 965:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 969:	75 23                	jne    98e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 96b:	c7 45 f0 54 0d 00 00 	movl   $0xd54,-0x10(%ebp)
 972:	8b 45 f0             	mov    -0x10(%ebp),%eax
 975:	a3 5c 0d 00 00       	mov    %eax,0xd5c
 97a:	a1 5c 0d 00 00       	mov    0xd5c,%eax
 97f:	a3 54 0d 00 00       	mov    %eax,0xd54
    base.s.size = 0;
 984:	c7 05 58 0d 00 00 00 	movl   $0x0,0xd58
 98b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 991:	8b 00                	mov    (%eax),%eax
 993:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 996:	8b 45 f4             	mov    -0xc(%ebp),%eax
 999:	8b 40 04             	mov    0x4(%eax),%eax
 99c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 99f:	72 4d                	jb     9ee <malloc+0xa6>
      if(p->s.size == nunits)
 9a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a4:	8b 40 04             	mov    0x4(%eax),%eax
 9a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9aa:	75 0c                	jne    9b8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9af:	8b 10                	mov    (%eax),%edx
 9b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b4:	89 10                	mov    %edx,(%eax)
 9b6:	eb 26                	jmp    9de <malloc+0x96>
      else {
        p->s.size -= nunits;
 9b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bb:	8b 40 04             	mov    0x4(%eax),%eax
 9be:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9c1:	89 c2                	mov    %eax,%edx
 9c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cc:	8b 40 04             	mov    0x4(%eax),%eax
 9cf:	c1 e0 03             	shl    $0x3,%eax
 9d2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9db:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e1:	a3 5c 0d 00 00       	mov    %eax,0xd5c
      return (void*)(p + 1);
 9e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e9:	83 c0 08             	add    $0x8,%eax
 9ec:	eb 38                	jmp    a26 <malloc+0xde>
    }
    if(p == freep)
 9ee:	a1 5c 0d 00 00       	mov    0xd5c,%eax
 9f3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9f6:	75 1b                	jne    a13 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 9f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9fb:	89 04 24             	mov    %eax,(%esp)
 9fe:	e8 ed fe ff ff       	call   8f0 <morecore>
 a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a0a:	75 07                	jne    a13 <malloc+0xcb>
        return 0;
 a0c:	b8 00 00 00 00       	mov    $0x0,%eax
 a11:	eb 13                	jmp    a26 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1c:	8b 00                	mov    (%eax),%eax
 a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 a21:	e9 70 ff ff ff       	jmp    996 <malloc+0x4e>
}
 a26:	c9                   	leave  
 a27:	c3                   	ret    
