
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 68                	jmp    8a <wc+0x8a>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 57                	jmp    82 <wc+0x82>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 40 0e 00 00       	add    $0xe40,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 40 0e 00 00       	add    $0xe40,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	89 44 24 04          	mov    %eax,0x4(%esp)
  54:	c7 04 24 f4 0a 00 00 	movl   $0xaf4,(%esp)
  5b:	e8 ad 03 00 00       	call   40d <strchr>
  60:	85 c0                	test   %eax,%eax
  62:	74 09                	je     6d <wc+0x6d>
        inword = 0;
  64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6b:	eb 11                	jmp    7e <wc+0x7e>
      else if(!inword){
  6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  71:	75 0b                	jne    7e <wc+0x7e>
        w++;
  73:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  77:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
  7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  85:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  88:	7c a1                	jl     2b <wc+0x2b>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  91:	00 
  92:	c7 44 24 04 40 0e 00 	movl   $0xe40,0x4(%esp)
  99:	00 
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 09 05 00 00       	call   5ae <read>
  a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ac:	0f 8f 70 ff ff ff    	jg     22 <wc+0x22>
      }
    }
  }
  if(n < 0){
  b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b6:	79 19                	jns    d1 <wc+0xd1>
    printf(1, "wc: read error\n");
  b8:	c7 44 24 04 fa 0a 00 	movl   $0xafa,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 5a 06 00 00       	call   726 <printf>
    exit();
  cc:	e8 c5 04 00 00       	call   596 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  d4:	89 44 24 14          	mov    %eax,0x14(%esp)
  d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  db:	89 44 24 10          	mov    %eax,0x10(%esp)
  df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  ed:	c7 44 24 04 0a 0b 00 	movl   $0xb0a,0x4(%esp)
  f4:	00 
  f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fc:	e8 25 06 00 00       	call   726 <printf>
}
 101:	c9                   	leave  
 102:	c3                   	ret    

00000103 <main>:

int
main(int argc, char *argv[])
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	83 e4 f0             	and    $0xfffffff0,%esp
 109:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 10c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 110:	7f 19                	jg     12b <main+0x28>
    wc(0, "");
 112:	c7 44 24 04 17 0b 00 	movl   $0xb17,0x4(%esp)
 119:	00 
 11a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 121:	e8 da fe ff ff       	call   0 <wc>
    exit();
 126:	e8 6b 04 00 00       	call   596 <exit>
  }

  for(i = 1; i < argc; i++){
 12b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 132:	00 
 133:	e9 8f 00 00 00       	jmp    1c7 <main+0xc4>
    if((fd = open(argv[i], 0)) < 0){
 138:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 13c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 143:	8b 45 0c             	mov    0xc(%ebp),%eax
 146:	01 d0                	add    %edx,%eax
 148:	8b 00                	mov    (%eax),%eax
 14a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 151:	00 
 152:	89 04 24             	mov    %eax,(%esp)
 155:	e8 7c 04 00 00       	call   5d6 <open>
 15a:	89 44 24 18          	mov    %eax,0x18(%esp)
 15e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 163:	79 2f                	jns    194 <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
 165:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 170:	8b 45 0c             	mov    0xc(%ebp),%eax
 173:	01 d0                	add    %edx,%eax
 175:	8b 00                	mov    (%eax),%eax
 177:	89 44 24 08          	mov    %eax,0x8(%esp)
 17b:	c7 44 24 04 18 0b 00 	movl   $0xb18,0x4(%esp)
 182:	00 
 183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18a:	e8 97 05 00 00       	call   726 <printf>
      exit();
 18f:	e8 02 04 00 00       	call   596 <exit>
    }
    wc(fd, argv[i]);
 194:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 198:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 19f:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	8b 00                	mov    (%eax),%eax
 1a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1aa:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ae:	89 04 24             	mov    %eax,(%esp)
 1b1:	e8 4a fe ff ff       	call   0 <wc>
    close(fd);
 1b6:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ba:	89 04 24             	mov    %eax,(%esp)
 1bd:	e8 fc 03 00 00       	call   5be <close>
  for(i = 1; i < argc; i++){
 1c2:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1cb:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ce:	0f 8c 64 ff ff ff    	jl     138 <main+0x35>
  }
  exit();
 1d4:	e8 bd 03 00 00       	call   596 <exit>

000001d9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	57                   	push   %edi
 1dd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1de:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e1:	8b 55 10             	mov    0x10(%ebp),%edx
 1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e7:	89 cb                	mov    %ecx,%ebx
 1e9:	89 df                	mov    %ebx,%edi
 1eb:	89 d1                	mov    %edx,%ecx
 1ed:	fc                   	cld    
 1ee:	f3 aa                	rep stos %al,%es:(%edi)
 1f0:	89 ca                	mov    %ecx,%edx
 1f2:	89 fb                	mov    %edi,%ebx
 1f4:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1f7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1fa:	5b                   	pop    %ebx
 1fb:	5f                   	pop    %edi
 1fc:	5d                   	pop    %ebp
 1fd:	c3                   	ret    

000001fe <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
 201:	57                   	push   %edi
 202:	56                   	push   %esi
 203:	53                   	push   %ebx
 204:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
 20a:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
 210:	89 04 24             	mov    %eax,(%esp)
 213:	e8 1e 04 00 00       	call   636 <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 218:	c7 44 24 04 2c 0b 00 	movl   $0xb2c,0x4(%esp)
 21f:	00 
 220:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 227:	e8 fa 04 00 00       	call   726 <printf>
    for (i = 0; i < NPROC; i++) {
 22c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 233:	e9 06 01 00 00       	jmp    33e <ps+0x140>
        if (ptable[i].inuse) {
 238:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 23b:	89 d0                	mov    %edx,%eax
 23d:	c1 e0 03             	shl    $0x3,%eax
 240:	01 d0                	add    %edx,%eax
 242:	c1 e0 02             	shl    $0x2,%eax
 245:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 248:	01 d8                	add    %ebx,%eax
 24a:	2d 08 09 00 00       	sub    $0x908,%eax
 24f:	8b 00                	mov    (%eax),%eax
 251:	85 c0                	test   %eax,%eax
 253:	0f 84 e1 00 00 00    	je     33a <ps+0x13c>
            char stat = '?';
 259:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
 25d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 260:	89 d0                	mov    %edx,%eax
 262:	c1 e0 03             	shl    $0x3,%eax
 265:	01 d0                	add    %edx,%eax
 267:	c1 e0 02             	shl    $0x2,%eax
 26a:	8d 75 e8             	lea    -0x18(%ebp),%esi
 26d:	01 f0                	add    %esi,%eax
 26f:	2d e8 08 00 00       	sub    $0x8e8,%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	0f be c0             	movsbl %al,%eax
 27a:	83 f8 05             	cmp    $0x5,%eax
 27d:	77 27                	ja     2a6 <ps+0xa8>
 27f:	8b 04 85 58 0b 00 00 	mov    0xb58(,%eax,4),%eax
 286:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
 288:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
 28c:	eb 1c                	jmp    2aa <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
 28e:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 292:	eb 16                	jmp    2aa <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
 294:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
 298:	eb 10                	jmp    2aa <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
 29a:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
 29e:	eb 0a                	jmp    2aa <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
 2a0:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
 2a4:	eb 04                	jmp    2aa <ps+0xac>
                default: stat = '?';
 2a6:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
 2aa:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
 2b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2b3:	89 d0                	mov    %edx,%eax
 2b5:	c1 e0 03             	shl    $0x3,%eax
 2b8:	01 d0                	add    %edx,%eax
 2ba:	c1 e0 02             	shl    $0x2,%eax
 2bd:	83 c0 10             	add    $0x10,%eax
 2c0:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 2c3:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 2c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2ca:	89 d0                	mov    %edx,%eax
 2cc:	c1 e0 03             	shl    $0x3,%eax
 2cf:	01 d0                	add    %edx,%eax
 2d1:	c1 e0 02             	shl    $0x2,%eax
 2d4:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 2d7:	01 c8                	add    %ecx,%eax
 2d9:	2d fc 08 00 00       	sub    $0x8fc,%eax
 2de:	8b 18                	mov    (%eax),%ebx
 2e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2e3:	89 d0                	mov    %edx,%eax
 2e5:	c1 e0 03             	shl    $0x3,%eax
 2e8:	01 d0                	add    %edx,%eax
 2ea:	c1 e0 02             	shl    $0x2,%eax
 2ed:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 2f0:	01 c8                	add    %ecx,%eax
 2f2:	2d 04 09 00 00       	sub    $0x904,%eax
 2f7:	8b 08                	mov    (%eax),%ecx
 2f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2fc:	89 d0                	mov    %edx,%eax
 2fe:	c1 e0 03             	shl    $0x3,%eax
 301:	01 d0                	add    %edx,%eax
 303:	c1 e0 02             	shl    $0x2,%eax
 306:	8d 55 e8             	lea    -0x18(%ebp),%edx
 309:	01 d0                	add    %edx,%eax
 30b:	2d 00 09 00 00       	sub    $0x900,%eax
 310:	8b 00                	mov    (%eax),%eax
 312:	89 7c 24 18          	mov    %edi,0x18(%esp)
 316:	89 74 24 14          	mov    %esi,0x14(%esp)
 31a:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 31e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 322:	89 44 24 08          	mov    %eax,0x8(%esp)
 326:	c7 44 24 04 45 0b 00 	movl   $0xb45,0x4(%esp)
 32d:	00 
 32e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 335:	e8 ec 03 00 00       	call   726 <printf>
    for (i = 0; i < NPROC; i++) {
 33a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 33e:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 342:	0f 8e f0 fe ff ff    	jle    238 <ps+0x3a>
        }
    }
}
 348:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 34e:	5b                   	pop    %ebx
 34f:	5e                   	pop    %esi
 350:	5f                   	pop    %edi
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    

00000353 <strcpy>:


char*
strcpy(char *s, const char *t)
{
 353:	55                   	push   %ebp
 354:	89 e5                	mov    %esp,%ebp
 356:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 359:	8b 45 08             	mov    0x8(%ebp),%eax
 35c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 35f:	90                   	nop
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	8d 50 01             	lea    0x1(%eax),%edx
 366:	89 55 08             	mov    %edx,0x8(%ebp)
 369:	8b 55 0c             	mov    0xc(%ebp),%edx
 36c:	8d 4a 01             	lea    0x1(%edx),%ecx
 36f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 372:	0f b6 12             	movzbl (%edx),%edx
 375:	88 10                	mov    %dl,(%eax)
 377:	0f b6 00             	movzbl (%eax),%eax
 37a:	84 c0                	test   %al,%al
 37c:	75 e2                	jne    360 <strcpy+0xd>
    ;
  return os;
 37e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 381:	c9                   	leave  
 382:	c3                   	ret    

00000383 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 383:	55                   	push   %ebp
 384:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 386:	eb 08                	jmp    390 <strcmp+0xd>
    p++, q++;
 388:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 38c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	0f b6 00             	movzbl (%eax),%eax
 396:	84 c0                	test   %al,%al
 398:	74 10                	je     3aa <strcmp+0x27>
 39a:	8b 45 08             	mov    0x8(%ebp),%eax
 39d:	0f b6 10             	movzbl (%eax),%edx
 3a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a3:	0f b6 00             	movzbl (%eax),%eax
 3a6:	38 c2                	cmp    %al,%dl
 3a8:	74 de                	je     388 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3aa:	8b 45 08             	mov    0x8(%ebp),%eax
 3ad:	0f b6 00             	movzbl (%eax),%eax
 3b0:	0f b6 d0             	movzbl %al,%edx
 3b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	0f b6 c0             	movzbl %al,%eax
 3bc:	29 c2                	sub    %eax,%edx
 3be:	89 d0                	mov    %edx,%eax
}
 3c0:	5d                   	pop    %ebp
 3c1:	c3                   	ret    

000003c2 <strlen>:

uint
strlen(const char *s)
{
 3c2:	55                   	push   %ebp
 3c3:	89 e5                	mov    %esp,%ebp
 3c5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3cf:	eb 04                	jmp    3d5 <strlen+0x13>
 3d1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d8:	8b 45 08             	mov    0x8(%ebp),%eax
 3db:	01 d0                	add    %edx,%eax
 3dd:	0f b6 00             	movzbl (%eax),%eax
 3e0:	84 c0                	test   %al,%al
 3e2:	75 ed                	jne    3d1 <strlen+0xf>
    ;
  return n;
 3e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e7:	c9                   	leave  
 3e8:	c3                   	ret    

000003e9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3e9:	55                   	push   %ebp
 3ea:	89 e5                	mov    %esp,%ebp
 3ec:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 3ef:	8b 45 10             	mov    0x10(%ebp),%eax
 3f2:	89 44 24 08          	mov    %eax,0x8(%esp)
 3f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3fd:	8b 45 08             	mov    0x8(%ebp),%eax
 400:	89 04 24             	mov    %eax,(%esp)
 403:	e8 d1 fd ff ff       	call   1d9 <stosb>
  return dst;
 408:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40b:	c9                   	leave  
 40c:	c3                   	ret    

0000040d <strchr>:

char*
strchr(const char *s, char c)
{
 40d:	55                   	push   %ebp
 40e:	89 e5                	mov    %esp,%ebp
 410:	83 ec 04             	sub    $0x4,%esp
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 419:	eb 14                	jmp    42f <strchr+0x22>
    if(*s == c)
 41b:	8b 45 08             	mov    0x8(%ebp),%eax
 41e:	0f b6 00             	movzbl (%eax),%eax
 421:	3a 45 fc             	cmp    -0x4(%ebp),%al
 424:	75 05                	jne    42b <strchr+0x1e>
      return (char*)s;
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	eb 13                	jmp    43e <strchr+0x31>
  for(; *s; s++)
 42b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 42f:	8b 45 08             	mov    0x8(%ebp),%eax
 432:	0f b6 00             	movzbl (%eax),%eax
 435:	84 c0                	test   %al,%al
 437:	75 e2                	jne    41b <strchr+0xe>
  return 0;
 439:	b8 00 00 00 00       	mov    $0x0,%eax
}
 43e:	c9                   	leave  
 43f:	c3                   	ret    

00000440 <gets>:

char*
gets(char *buf, int max)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 446:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 44d:	eb 4c                	jmp    49b <gets+0x5b>
    cc = read(0, &c, 1);
 44f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 456:	00 
 457:	8d 45 ef             	lea    -0x11(%ebp),%eax
 45a:	89 44 24 04          	mov    %eax,0x4(%esp)
 45e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 465:	e8 44 01 00 00       	call   5ae <read>
 46a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 46d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 471:	7f 02                	jg     475 <gets+0x35>
      break;
 473:	eb 31                	jmp    4a6 <gets+0x66>
    buf[i++] = c;
 475:	8b 45 f4             	mov    -0xc(%ebp),%eax
 478:	8d 50 01             	lea    0x1(%eax),%edx
 47b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 47e:	89 c2                	mov    %eax,%edx
 480:	8b 45 08             	mov    0x8(%ebp),%eax
 483:	01 c2                	add    %eax,%edx
 485:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 489:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 48b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48f:	3c 0a                	cmp    $0xa,%al
 491:	74 13                	je     4a6 <gets+0x66>
 493:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 497:	3c 0d                	cmp    $0xd,%al
 499:	74 0b                	je     4a6 <gets+0x66>
  for(i=0; i+1 < max; ){
 49b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49e:	83 c0 01             	add    $0x1,%eax
 4a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4a4:	7c a9                	jl     44f <gets+0xf>
      break;
  }
  buf[i] = '\0';
 4a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ac:	01 d0                	add    %edx,%eax
 4ae:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4b4:	c9                   	leave  
 4b5:	c3                   	ret    

000004b6 <stat>:

int
stat(const char *n, struct stat *st)
{
 4b6:	55                   	push   %ebp
 4b7:	89 e5                	mov    %esp,%ebp
 4b9:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4c3:	00 
 4c4:	8b 45 08             	mov    0x8(%ebp),%eax
 4c7:	89 04 24             	mov    %eax,(%esp)
 4ca:	e8 07 01 00 00       	call   5d6 <open>
 4cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d6:	79 07                	jns    4df <stat+0x29>
    return -1;
 4d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4dd:	eb 23                	jmp    502 <stat+0x4c>
  r = fstat(fd, st);
 4df:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e9:	89 04 24             	mov    %eax,(%esp)
 4ec:	e8 fd 00 00 00       	call   5ee <fstat>
 4f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f7:	89 04 24             	mov    %eax,(%esp)
 4fa:	e8 bf 00 00 00       	call   5be <close>
  return r;
 4ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 502:	c9                   	leave  
 503:	c3                   	ret    

00000504 <atoi>:

int
atoi(const char *s)
{
 504:	55                   	push   %ebp
 505:	89 e5                	mov    %esp,%ebp
 507:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 50a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 511:	eb 25                	jmp    538 <atoi+0x34>
    n = n*10 + *s++ - '0';
 513:	8b 55 fc             	mov    -0x4(%ebp),%edx
 516:	89 d0                	mov    %edx,%eax
 518:	c1 e0 02             	shl    $0x2,%eax
 51b:	01 d0                	add    %edx,%eax
 51d:	01 c0                	add    %eax,%eax
 51f:	89 c1                	mov    %eax,%ecx
 521:	8b 45 08             	mov    0x8(%ebp),%eax
 524:	8d 50 01             	lea    0x1(%eax),%edx
 527:	89 55 08             	mov    %edx,0x8(%ebp)
 52a:	0f b6 00             	movzbl (%eax),%eax
 52d:	0f be c0             	movsbl %al,%eax
 530:	01 c8                	add    %ecx,%eax
 532:	83 e8 30             	sub    $0x30,%eax
 535:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 538:	8b 45 08             	mov    0x8(%ebp),%eax
 53b:	0f b6 00             	movzbl (%eax),%eax
 53e:	3c 2f                	cmp    $0x2f,%al
 540:	7e 0a                	jle    54c <atoi+0x48>
 542:	8b 45 08             	mov    0x8(%ebp),%eax
 545:	0f b6 00             	movzbl (%eax),%eax
 548:	3c 39                	cmp    $0x39,%al
 54a:	7e c7                	jle    513 <atoi+0xf>
  return n;
 54c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 54f:	c9                   	leave  
 550:	c3                   	ret    

00000551 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 551:	55                   	push   %ebp
 552:	89 e5                	mov    %esp,%ebp
 554:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 557:	8b 45 08             	mov    0x8(%ebp),%eax
 55a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 55d:	8b 45 0c             	mov    0xc(%ebp),%eax
 560:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 563:	eb 17                	jmp    57c <memmove+0x2b>
    *dst++ = *src++;
 565:	8b 45 fc             	mov    -0x4(%ebp),%eax
 568:	8d 50 01             	lea    0x1(%eax),%edx
 56b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 56e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 571:	8d 4a 01             	lea    0x1(%edx),%ecx
 574:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 577:	0f b6 12             	movzbl (%edx),%edx
 57a:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 57c:	8b 45 10             	mov    0x10(%ebp),%eax
 57f:	8d 50 ff             	lea    -0x1(%eax),%edx
 582:	89 55 10             	mov    %edx,0x10(%ebp)
 585:	85 c0                	test   %eax,%eax
 587:	7f dc                	jg     565 <memmove+0x14>
  return vdst;
 589:	8b 45 08             	mov    0x8(%ebp),%eax
}
 58c:	c9                   	leave  
 58d:	c3                   	ret    

0000058e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 58e:	b8 01 00 00 00       	mov    $0x1,%eax
 593:	cd 40                	int    $0x40
 595:	c3                   	ret    

00000596 <exit>:
SYSCALL(exit)
 596:	b8 02 00 00 00       	mov    $0x2,%eax
 59b:	cd 40                	int    $0x40
 59d:	c3                   	ret    

0000059e <wait>:
SYSCALL(wait)
 59e:	b8 03 00 00 00       	mov    $0x3,%eax
 5a3:	cd 40                	int    $0x40
 5a5:	c3                   	ret    

000005a6 <pipe>:
SYSCALL(pipe)
 5a6:	b8 04 00 00 00       	mov    $0x4,%eax
 5ab:	cd 40                	int    $0x40
 5ad:	c3                   	ret    

000005ae <read>:
SYSCALL(read)
 5ae:	b8 05 00 00 00       	mov    $0x5,%eax
 5b3:	cd 40                	int    $0x40
 5b5:	c3                   	ret    

000005b6 <write>:
SYSCALL(write)
 5b6:	b8 10 00 00 00       	mov    $0x10,%eax
 5bb:	cd 40                	int    $0x40
 5bd:	c3                   	ret    

000005be <close>:
SYSCALL(close)
 5be:	b8 15 00 00 00       	mov    $0x15,%eax
 5c3:	cd 40                	int    $0x40
 5c5:	c3                   	ret    

000005c6 <kill>:
SYSCALL(kill)
 5c6:	b8 06 00 00 00       	mov    $0x6,%eax
 5cb:	cd 40                	int    $0x40
 5cd:	c3                   	ret    

000005ce <exec>:
SYSCALL(exec)
 5ce:	b8 07 00 00 00       	mov    $0x7,%eax
 5d3:	cd 40                	int    $0x40
 5d5:	c3                   	ret    

000005d6 <open>:
SYSCALL(open)
 5d6:	b8 0f 00 00 00       	mov    $0xf,%eax
 5db:	cd 40                	int    $0x40
 5dd:	c3                   	ret    

000005de <mknod>:
SYSCALL(mknod)
 5de:	b8 11 00 00 00       	mov    $0x11,%eax
 5e3:	cd 40                	int    $0x40
 5e5:	c3                   	ret    

000005e6 <unlink>:
SYSCALL(unlink)
 5e6:	b8 12 00 00 00       	mov    $0x12,%eax
 5eb:	cd 40                	int    $0x40
 5ed:	c3                   	ret    

000005ee <fstat>:
SYSCALL(fstat)
 5ee:	b8 08 00 00 00       	mov    $0x8,%eax
 5f3:	cd 40                	int    $0x40
 5f5:	c3                   	ret    

000005f6 <link>:
SYSCALL(link)
 5f6:	b8 13 00 00 00       	mov    $0x13,%eax
 5fb:	cd 40                	int    $0x40
 5fd:	c3                   	ret    

000005fe <mkdir>:
SYSCALL(mkdir)
 5fe:	b8 14 00 00 00       	mov    $0x14,%eax
 603:	cd 40                	int    $0x40
 605:	c3                   	ret    

00000606 <chdir>:
SYSCALL(chdir)
 606:	b8 09 00 00 00       	mov    $0x9,%eax
 60b:	cd 40                	int    $0x40
 60d:	c3                   	ret    

0000060e <dup>:
SYSCALL(dup)
 60e:	b8 0a 00 00 00       	mov    $0xa,%eax
 613:	cd 40                	int    $0x40
 615:	c3                   	ret    

00000616 <getpid>:
SYSCALL(getpid)
 616:	b8 0b 00 00 00       	mov    $0xb,%eax
 61b:	cd 40                	int    $0x40
 61d:	c3                   	ret    

0000061e <sbrk>:
SYSCALL(sbrk)
 61e:	b8 0c 00 00 00       	mov    $0xc,%eax
 623:	cd 40                	int    $0x40
 625:	c3                   	ret    

00000626 <sleep>:
SYSCALL(sleep)
 626:	b8 0d 00 00 00       	mov    $0xd,%eax
 62b:	cd 40                	int    $0x40
 62d:	c3                   	ret    

0000062e <uptime>:
SYSCALL(uptime)
 62e:	b8 0e 00 00 00       	mov    $0xe,%eax
 633:	cd 40                	int    $0x40
 635:	c3                   	ret    

00000636 <getpinfo>:
SYSCALL(getpinfo)
 636:	b8 16 00 00 00       	mov    $0x16,%eax
 63b:	cd 40                	int    $0x40
 63d:	c3                   	ret    

0000063e <settickets>:
SYSCALL(settickets)
 63e:	b8 17 00 00 00       	mov    $0x17,%eax
 643:	cd 40                	int    $0x40
 645:	c3                   	ret    

00000646 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 646:	55                   	push   %ebp
 647:	89 e5                	mov    %esp,%ebp
 649:	83 ec 18             	sub    $0x18,%esp
 64c:	8b 45 0c             	mov    0xc(%ebp),%eax
 64f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 652:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 659:	00 
 65a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 65d:	89 44 24 04          	mov    %eax,0x4(%esp)
 661:	8b 45 08             	mov    0x8(%ebp),%eax
 664:	89 04 24             	mov    %eax,(%esp)
 667:	e8 4a ff ff ff       	call   5b6 <write>
}
 66c:	c9                   	leave  
 66d:	c3                   	ret    

0000066e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 66e:	55                   	push   %ebp
 66f:	89 e5                	mov    %esp,%ebp
 671:	56                   	push   %esi
 672:	53                   	push   %ebx
 673:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 676:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 67d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 681:	74 17                	je     69a <printint+0x2c>
 683:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 687:	79 11                	jns    69a <printint+0x2c>
    neg = 1;
 689:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 690:	8b 45 0c             	mov    0xc(%ebp),%eax
 693:	f7 d8                	neg    %eax
 695:	89 45 ec             	mov    %eax,-0x14(%ebp)
 698:	eb 06                	jmp    6a0 <printint+0x32>
  } else {
    x = xx;
 69a:	8b 45 0c             	mov    0xc(%ebp),%eax
 69d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6a7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6aa:	8d 41 01             	lea    0x1(%ecx),%eax
 6ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6b6:	ba 00 00 00 00       	mov    $0x0,%edx
 6bb:	f7 f3                	div    %ebx
 6bd:	89 d0                	mov    %edx,%eax
 6bf:	0f b6 80 0c 0e 00 00 	movzbl 0xe0c(%eax),%eax
 6c6:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6ca:	8b 75 10             	mov    0x10(%ebp),%esi
 6cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6d0:	ba 00 00 00 00       	mov    $0x0,%edx
 6d5:	f7 f6                	div    %esi
 6d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6de:	75 c7                	jne    6a7 <printint+0x39>
  if(neg)
 6e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6e4:	74 10                	je     6f6 <printint+0x88>
    buf[i++] = '-';
 6e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e9:	8d 50 01             	lea    0x1(%eax),%edx
 6ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6ef:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6f4:	eb 1f                	jmp    715 <printint+0xa7>
 6f6:	eb 1d                	jmp    715 <printint+0xa7>
    putc(fd, buf[i]);
 6f8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6fe:	01 d0                	add    %edx,%eax
 700:	0f b6 00             	movzbl (%eax),%eax
 703:	0f be c0             	movsbl %al,%eax
 706:	89 44 24 04          	mov    %eax,0x4(%esp)
 70a:	8b 45 08             	mov    0x8(%ebp),%eax
 70d:	89 04 24             	mov    %eax,(%esp)
 710:	e8 31 ff ff ff       	call   646 <putc>
  while(--i >= 0)
 715:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 719:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 71d:	79 d9                	jns    6f8 <printint+0x8a>
}
 71f:	83 c4 30             	add    $0x30,%esp
 722:	5b                   	pop    %ebx
 723:	5e                   	pop    %esi
 724:	5d                   	pop    %ebp
 725:	c3                   	ret    

00000726 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 726:	55                   	push   %ebp
 727:	89 e5                	mov    %esp,%ebp
 729:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 72c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 733:	8d 45 0c             	lea    0xc(%ebp),%eax
 736:	83 c0 04             	add    $0x4,%eax
 739:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 73c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 743:	e9 7c 01 00 00       	jmp    8c4 <printf+0x19e>
    c = fmt[i] & 0xff;
 748:	8b 55 0c             	mov    0xc(%ebp),%edx
 74b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74e:	01 d0                	add    %edx,%eax
 750:	0f b6 00             	movzbl (%eax),%eax
 753:	0f be c0             	movsbl %al,%eax
 756:	25 ff 00 00 00       	and    $0xff,%eax
 75b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 75e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 762:	75 2c                	jne    790 <printf+0x6a>
      if(c == '%'){
 764:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 768:	75 0c                	jne    776 <printf+0x50>
        state = '%';
 76a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 771:	e9 4a 01 00 00       	jmp    8c0 <printf+0x19a>
      } else {
        putc(fd, c);
 776:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 779:	0f be c0             	movsbl %al,%eax
 77c:	89 44 24 04          	mov    %eax,0x4(%esp)
 780:	8b 45 08             	mov    0x8(%ebp),%eax
 783:	89 04 24             	mov    %eax,(%esp)
 786:	e8 bb fe ff ff       	call   646 <putc>
 78b:	e9 30 01 00 00       	jmp    8c0 <printf+0x19a>
      }
    } else if(state == '%'){
 790:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 794:	0f 85 26 01 00 00    	jne    8c0 <printf+0x19a>
      if(c == 'd'){
 79a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 79e:	75 2d                	jne    7cd <printf+0xa7>
        printint(fd, *ap, 10, 1);
 7a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a3:	8b 00                	mov    (%eax),%eax
 7a5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7ac:	00 
 7ad:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7b4:	00 
 7b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
 7bc:	89 04 24             	mov    %eax,(%esp)
 7bf:	e8 aa fe ff ff       	call   66e <printint>
        ap++;
 7c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7c8:	e9 ec 00 00 00       	jmp    8b9 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 7cd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7d1:	74 06                	je     7d9 <printf+0xb3>
 7d3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7d7:	75 2d                	jne    806 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 7d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7e5:	00 
 7e6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7ed:	00 
 7ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 7f2:	8b 45 08             	mov    0x8(%ebp),%eax
 7f5:	89 04 24             	mov    %eax,(%esp)
 7f8:	e8 71 fe ff ff       	call   66e <printint>
        ap++;
 7fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 801:	e9 b3 00 00 00       	jmp    8b9 <printf+0x193>
      } else if(c == 's'){
 806:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 80a:	75 45                	jne    851 <printf+0x12b>
        s = (char*)*ap;
 80c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80f:	8b 00                	mov    (%eax),%eax
 811:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 814:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 818:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 81c:	75 09                	jne    827 <printf+0x101>
          s = "(null)";
 81e:	c7 45 f4 70 0b 00 00 	movl   $0xb70,-0xc(%ebp)
        while(*s != 0){
 825:	eb 1e                	jmp    845 <printf+0x11f>
 827:	eb 1c                	jmp    845 <printf+0x11f>
          putc(fd, *s);
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	0f b6 00             	movzbl (%eax),%eax
 82f:	0f be c0             	movsbl %al,%eax
 832:	89 44 24 04          	mov    %eax,0x4(%esp)
 836:	8b 45 08             	mov    0x8(%ebp),%eax
 839:	89 04 24             	mov    %eax,(%esp)
 83c:	e8 05 fe ff ff       	call   646 <putc>
          s++;
 841:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	0f b6 00             	movzbl (%eax),%eax
 84b:	84 c0                	test   %al,%al
 84d:	75 da                	jne    829 <printf+0x103>
 84f:	eb 68                	jmp    8b9 <printf+0x193>
        }
      } else if(c == 'c'){
 851:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 855:	75 1d                	jne    874 <printf+0x14e>
        putc(fd, *ap);
 857:	8b 45 e8             	mov    -0x18(%ebp),%eax
 85a:	8b 00                	mov    (%eax),%eax
 85c:	0f be c0             	movsbl %al,%eax
 85f:	89 44 24 04          	mov    %eax,0x4(%esp)
 863:	8b 45 08             	mov    0x8(%ebp),%eax
 866:	89 04 24             	mov    %eax,(%esp)
 869:	e8 d8 fd ff ff       	call   646 <putc>
        ap++;
 86e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 872:	eb 45                	jmp    8b9 <printf+0x193>
      } else if(c == '%'){
 874:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 878:	75 17                	jne    891 <printf+0x16b>
        putc(fd, c);
 87a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 87d:	0f be c0             	movsbl %al,%eax
 880:	89 44 24 04          	mov    %eax,0x4(%esp)
 884:	8b 45 08             	mov    0x8(%ebp),%eax
 887:	89 04 24             	mov    %eax,(%esp)
 88a:	e8 b7 fd ff ff       	call   646 <putc>
 88f:	eb 28                	jmp    8b9 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 891:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 898:	00 
 899:	8b 45 08             	mov    0x8(%ebp),%eax
 89c:	89 04 24             	mov    %eax,(%esp)
 89f:	e8 a2 fd ff ff       	call   646 <putc>
        putc(fd, c);
 8a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8a7:	0f be c0             	movsbl %al,%eax
 8aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ae:	8b 45 08             	mov    0x8(%ebp),%eax
 8b1:	89 04 24             	mov    %eax,(%esp)
 8b4:	e8 8d fd ff ff       	call   646 <putc>
      }
      state = 0;
 8b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 8c0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8c4:	8b 55 0c             	mov    0xc(%ebp),%edx
 8c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ca:	01 d0                	add    %edx,%eax
 8cc:	0f b6 00             	movzbl (%eax),%eax
 8cf:	84 c0                	test   %al,%al
 8d1:	0f 85 71 fe ff ff    	jne    748 <printf+0x22>
    }
  }
}
 8d7:	c9                   	leave  
 8d8:	c3                   	ret    

000008d9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d9:	55                   	push   %ebp
 8da:	89 e5                	mov    %esp,%ebp
 8dc:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8df:	8b 45 08             	mov    0x8(%ebp),%eax
 8e2:	83 e8 08             	sub    $0x8,%eax
 8e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e8:	a1 28 0e 00 00       	mov    0xe28,%eax
 8ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8f0:	eb 24                	jmp    916 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f5:	8b 00                	mov    (%eax),%eax
 8f7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8fa:	77 12                	ja     90e <free+0x35>
 8fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 902:	77 24                	ja     928 <free+0x4f>
 904:	8b 45 fc             	mov    -0x4(%ebp),%eax
 907:	8b 00                	mov    (%eax),%eax
 909:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 90c:	77 1a                	ja     928 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 911:	8b 00                	mov    (%eax),%eax
 913:	89 45 fc             	mov    %eax,-0x4(%ebp)
 916:	8b 45 f8             	mov    -0x8(%ebp),%eax
 919:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 91c:	76 d4                	jbe    8f2 <free+0x19>
 91e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 921:	8b 00                	mov    (%eax),%eax
 923:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 926:	76 ca                	jbe    8f2 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 928:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92b:	8b 40 04             	mov    0x4(%eax),%eax
 92e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 935:	8b 45 f8             	mov    -0x8(%ebp),%eax
 938:	01 c2                	add    %eax,%edx
 93a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93d:	8b 00                	mov    (%eax),%eax
 93f:	39 c2                	cmp    %eax,%edx
 941:	75 24                	jne    967 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 943:	8b 45 f8             	mov    -0x8(%ebp),%eax
 946:	8b 50 04             	mov    0x4(%eax),%edx
 949:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94c:	8b 00                	mov    (%eax),%eax
 94e:	8b 40 04             	mov    0x4(%eax),%eax
 951:	01 c2                	add    %eax,%edx
 953:	8b 45 f8             	mov    -0x8(%ebp),%eax
 956:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 959:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95c:	8b 00                	mov    (%eax),%eax
 95e:	8b 10                	mov    (%eax),%edx
 960:	8b 45 f8             	mov    -0x8(%ebp),%eax
 963:	89 10                	mov    %edx,(%eax)
 965:	eb 0a                	jmp    971 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 967:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96a:	8b 10                	mov    (%eax),%edx
 96c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 971:	8b 45 fc             	mov    -0x4(%ebp),%eax
 974:	8b 40 04             	mov    0x4(%eax),%eax
 977:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 97e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 981:	01 d0                	add    %edx,%eax
 983:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 986:	75 20                	jne    9a8 <free+0xcf>
    p->s.size += bp->s.size;
 988:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98b:	8b 50 04             	mov    0x4(%eax),%edx
 98e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 991:	8b 40 04             	mov    0x4(%eax),%eax
 994:	01 c2                	add    %eax,%edx
 996:	8b 45 fc             	mov    -0x4(%ebp),%eax
 999:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 99c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99f:	8b 10                	mov    (%eax),%edx
 9a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a4:	89 10                	mov    %edx,(%eax)
 9a6:	eb 08                	jmp    9b0 <free+0xd7>
  } else
    p->s.ptr = bp;
 9a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ab:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9ae:	89 10                	mov    %edx,(%eax)
  freep = p;
 9b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b3:	a3 28 0e 00 00       	mov    %eax,0xe28
}
 9b8:	c9                   	leave  
 9b9:	c3                   	ret    

000009ba <morecore>:

static Header*
morecore(uint nu)
{
 9ba:	55                   	push   %ebp
 9bb:	89 e5                	mov    %esp,%ebp
 9bd:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9c0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9c7:	77 07                	ja     9d0 <morecore+0x16>
    nu = 4096;
 9c9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9d0:	8b 45 08             	mov    0x8(%ebp),%eax
 9d3:	c1 e0 03             	shl    $0x3,%eax
 9d6:	89 04 24             	mov    %eax,(%esp)
 9d9:	e8 40 fc ff ff       	call   61e <sbrk>
 9de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9e1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9e5:	75 07                	jne    9ee <morecore+0x34>
    return 0;
 9e7:	b8 00 00 00 00       	mov    $0x0,%eax
 9ec:	eb 22                	jmp    a10 <morecore+0x56>
  hp = (Header*)p;
 9ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f7:	8b 55 08             	mov    0x8(%ebp),%edx
 9fa:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a00:	83 c0 08             	add    $0x8,%eax
 a03:	89 04 24             	mov    %eax,(%esp)
 a06:	e8 ce fe ff ff       	call   8d9 <free>
  return freep;
 a0b:	a1 28 0e 00 00       	mov    0xe28,%eax
}
 a10:	c9                   	leave  
 a11:	c3                   	ret    

00000a12 <malloc>:

void*
malloc(uint nbytes)
{
 a12:	55                   	push   %ebp
 a13:	89 e5                	mov    %esp,%ebp
 a15:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a18:	8b 45 08             	mov    0x8(%ebp),%eax
 a1b:	83 c0 07             	add    $0x7,%eax
 a1e:	c1 e8 03             	shr    $0x3,%eax
 a21:	83 c0 01             	add    $0x1,%eax
 a24:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a27:	a1 28 0e 00 00       	mov    0xe28,%eax
 a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a33:	75 23                	jne    a58 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a35:	c7 45 f0 20 0e 00 00 	movl   $0xe20,-0x10(%ebp)
 a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3f:	a3 28 0e 00 00       	mov    %eax,0xe28
 a44:	a1 28 0e 00 00       	mov    0xe28,%eax
 a49:	a3 20 0e 00 00       	mov    %eax,0xe20
    base.s.size = 0;
 a4e:	c7 05 24 0e 00 00 00 	movl   $0x0,0xe24
 a55:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5b:	8b 00                	mov    (%eax),%eax
 a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a63:	8b 40 04             	mov    0x4(%eax),%eax
 a66:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a69:	72 4d                	jb     ab8 <malloc+0xa6>
      if(p->s.size == nunits)
 a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6e:	8b 40 04             	mov    0x4(%eax),%eax
 a71:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a74:	75 0c                	jne    a82 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a79:	8b 10                	mov    (%eax),%edx
 a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7e:	89 10                	mov    %edx,(%eax)
 a80:	eb 26                	jmp    aa8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a85:	8b 40 04             	mov    0x4(%eax),%eax
 a88:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a8b:	89 c2                	mov    %eax,%edx
 a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a90:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a96:	8b 40 04             	mov    0x4(%eax),%eax
 a99:	c1 e0 03             	shl    $0x3,%eax
 a9c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aa5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aab:	a3 28 0e 00 00       	mov    %eax,0xe28
      return (void*)(p + 1);
 ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab3:	83 c0 08             	add    $0x8,%eax
 ab6:	eb 38                	jmp    af0 <malloc+0xde>
    }
    if(p == freep)
 ab8:	a1 28 0e 00 00       	mov    0xe28,%eax
 abd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ac0:	75 1b                	jne    add <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ac5:	89 04 24             	mov    %eax,(%esp)
 ac8:	e8 ed fe ff ff       	call   9ba <morecore>
 acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ad0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ad4:	75 07                	jne    add <malloc+0xcb>
        return 0;
 ad6:	b8 00 00 00 00       	mov    $0x0,%eax
 adb:	eb 13                	jmp    af0 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 add:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae6:	8b 00                	mov    (%eax),%eax
 ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 aeb:	e9 70 ff ff ff       	jmp    a60 <malloc+0x4e>
}
 af0:	c9                   	leave  
 af1:	c3                   	ret    
