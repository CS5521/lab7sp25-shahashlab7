
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;

  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 c6 00 00 00       	jmp    d8 <grep+0xd8>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 40 10 00 00       	add    $0x1040,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 40 10 00 00 	movl   $0x1040,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 51                	jmp    7d <grep+0x7d>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  35:	89 44 24 04          	mov    %eax,0x4(%esp)
  39:	8b 45 08             	mov    0x8(%ebp),%eax
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 bc 01 00 00       	call   200 <match>
  44:	85 c0                	test   %eax,%eax
  46:	74 2c                	je     74 <grep+0x74>
        *q = '\n';
  48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4b:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  51:	83 c0 01             	add    $0x1,%eax
  54:	89 c2                	mov    %eax,%edx
  56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  59:	29 c2                	sub    %eax,%edx
  5b:	89 d0                	mov    %edx,%eax
  5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  64:	89 44 24 04          	mov    %eax,0x4(%esp)
  68:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6f:	e8 c9 06 00 00       	call   73d <write>
      }
      p = q+1;
  74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  77:	83 c0 01             	add    $0x1,%eax
  7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  7d:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  84:	00 
  85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  88:	89 04 24             	mov    %eax,(%esp)
  8b:	e8 04 05 00 00       	call   594 <strchr>
  90:	89 45 e8             	mov    %eax,-0x18(%ebp)
  93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  97:	75 93                	jne    2c <grep+0x2c>
    }
    if(p == buf)
  99:	81 7d f0 40 10 00 00 	cmpl   $0x1040,-0x10(%ebp)
  a0:	75 07                	jne    a9 <grep+0xa9>
      m = 0;
  a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  ad:	7e 29                	jle    d8 <grep+0xd8>
      m -= p - buf;
  af:	ba 40 10 00 00       	mov    $0x1040,%edx
  b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b7:	29 c2                	sub    %eax,%edx
  b9:	89 d0                	mov    %edx,%eax
  bb:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  cc:	c7 04 24 40 10 00 00 	movl   $0x1040,(%esp)
  d3:	e8 00 06 00 00       	call   6d8 <memmove>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  db:	ba ff 03 00 00       	mov    $0x3ff,%edx
  e0:	29 c2                	sub    %eax,%edx
  e2:	89 d0                	mov    %edx,%eax
  e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  e7:	81 c2 40 10 00 00    	add    $0x1040,%edx
  ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	89 04 24             	mov    %eax,(%esp)
  fb:	e8 35 06 00 00       	call   735 <read>
 100:	89 45 ec             	mov    %eax,-0x14(%ebp)
 103:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 107:	0f 8f 05 ff ff ff    	jg     12 <grep+0x12>
    }
  }
}
 10d:	c9                   	leave  
 10e:	c3                   	ret    

0000010f <main>:

int
main(int argc, char *argv[])
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	83 e4 f0             	and    $0xfffffff0,%esp
 115:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;

  if(argc <= 1){
 118:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 11c:	7f 19                	jg     137 <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 11e:	c7 44 24 04 7c 0c 00 	movl   $0xc7c,0x4(%esp)
 125:	00 
 126:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 12d:	e8 7b 07 00 00       	call   8ad <printf>
    exit();
 132:	e8 e6 05 00 00       	call   71d <exit>
  }
  pattern = argv[1];
 137:	8b 45 0c             	mov    0xc(%ebp),%eax
 13a:	8b 40 04             	mov    0x4(%eax),%eax
 13d:	89 44 24 18          	mov    %eax,0x18(%esp)

  if(argc <= 2){
 141:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 145:	7f 19                	jg     160 <main+0x51>
    grep(pattern, 0);
 147:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 14e:	00 
 14f:	8b 44 24 18          	mov    0x18(%esp),%eax
 153:	89 04 24             	mov    %eax,(%esp)
 156:	e8 a5 fe ff ff       	call   0 <grep>
    exit();
 15b:	e8 bd 05 00 00       	call   71d <exit>
  }

  for(i = 2; i < argc; i++){
 160:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 167:	00 
 168:	e9 81 00 00 00       	jmp    1ee <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
 16d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 171:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 178:	8b 45 0c             	mov    0xc(%ebp),%eax
 17b:	01 d0                	add    %edx,%eax
 17d:	8b 00                	mov    (%eax),%eax
 17f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 186:	00 
 187:	89 04 24             	mov    %eax,(%esp)
 18a:	e8 ce 05 00 00       	call   75d <open>
 18f:	89 44 24 14          	mov    %eax,0x14(%esp)
 193:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 198:	79 2f                	jns    1c9 <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
 19a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 19e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a8:	01 d0                	add    %edx,%eax
 1aa:	8b 00                	mov    (%eax),%eax
 1ac:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b0:	c7 44 24 04 9c 0c 00 	movl   $0xc9c,0x4(%esp)
 1b7:	00 
 1b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1bf:	e8 e9 06 00 00       	call   8ad <printf>
      exit();
 1c4:	e8 54 05 00 00       	call   71d <exit>
    }
    grep(pattern, fd);
 1c9:	8b 44 24 14          	mov    0x14(%esp),%eax
 1cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d1:	8b 44 24 18          	mov    0x18(%esp),%eax
 1d5:	89 04 24             	mov    %eax,(%esp)
 1d8:	e8 23 fe ff ff       	call   0 <grep>
    close(fd);
 1dd:	8b 44 24 14          	mov    0x14(%esp),%eax
 1e1:	89 04 24             	mov    %eax,(%esp)
 1e4:	e8 5c 05 00 00       	call   745 <close>
  for(i = 2; i < argc; i++){
 1e9:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1ee:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1f2:	3b 45 08             	cmp    0x8(%ebp),%eax
 1f5:	0f 8c 72 ff ff ff    	jl     16d <main+0x5e>
  }
  exit();
 1fb:	e8 1d 05 00 00       	call   71d <exit>

00000200 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 206:	8b 45 08             	mov    0x8(%ebp),%eax
 209:	0f b6 00             	movzbl (%eax),%eax
 20c:	3c 5e                	cmp    $0x5e,%al
 20e:	75 17                	jne    227 <match+0x27>
    return matchhere(re+1, text);
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	8d 50 01             	lea    0x1(%eax),%edx
 216:	8b 45 0c             	mov    0xc(%ebp),%eax
 219:	89 44 24 04          	mov    %eax,0x4(%esp)
 21d:	89 14 24             	mov    %edx,(%esp)
 220:	e8 36 00 00 00       	call   25b <matchhere>
 225:	eb 32                	jmp    259 <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
 227:	8b 45 0c             	mov    0xc(%ebp),%eax
 22a:	89 44 24 04          	mov    %eax,0x4(%esp)
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	89 04 24             	mov    %eax,(%esp)
 234:	e8 22 00 00 00       	call   25b <matchhere>
 239:	85 c0                	test   %eax,%eax
 23b:	74 07                	je     244 <match+0x44>
      return 1;
 23d:	b8 01 00 00 00       	mov    $0x1,%eax
 242:	eb 15                	jmp    259 <match+0x59>
  }while(*text++ != '\0');
 244:	8b 45 0c             	mov    0xc(%ebp),%eax
 247:	8d 50 01             	lea    0x1(%eax),%edx
 24a:	89 55 0c             	mov    %edx,0xc(%ebp)
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 d3                	jne    227 <match+0x27>
  return 0;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	84 c0                	test   %al,%al
 269:	75 0a                	jne    275 <matchhere+0x1a>
    return 1;
 26b:	b8 01 00 00 00       	mov    $0x1,%eax
 270:	e9 9b 00 00 00       	jmp    310 <matchhere+0xb5>
  if(re[1] == '*')
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	83 c0 01             	add    $0x1,%eax
 27b:	0f b6 00             	movzbl (%eax),%eax
 27e:	3c 2a                	cmp    $0x2a,%al
 280:	75 24                	jne    2a6 <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	8d 48 02             	lea    0x2(%eax),%ecx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	0f b6 00             	movzbl (%eax),%eax
 28e:	0f be c0             	movsbl %al,%eax
 291:	8b 55 0c             	mov    0xc(%ebp),%edx
 294:	89 54 24 08          	mov    %edx,0x8(%esp)
 298:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 29c:	89 04 24             	mov    %eax,(%esp)
 29f:	e8 6e 00 00 00       	call   312 <matchstar>
 2a4:	eb 6a                	jmp    310 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	0f b6 00             	movzbl (%eax),%eax
 2ac:	3c 24                	cmp    $0x24,%al
 2ae:	75 1d                	jne    2cd <matchhere+0x72>
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	83 c0 01             	add    $0x1,%eax
 2b6:	0f b6 00             	movzbl (%eax),%eax
 2b9:	84 c0                	test   %al,%al
 2bb:	75 10                	jne    2cd <matchhere+0x72>
    return *text == '\0';
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	84 c0                	test   %al,%al
 2c5:	0f 94 c0             	sete   %al
 2c8:	0f b6 c0             	movzbl %al,%eax
 2cb:	eb 43                	jmp    310 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d0:	0f b6 00             	movzbl (%eax),%eax
 2d3:	84 c0                	test   %al,%al
 2d5:	74 34                	je     30b <matchhere+0xb0>
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	0f b6 00             	movzbl (%eax),%eax
 2dd:	3c 2e                	cmp    $0x2e,%al
 2df:	74 10                	je     2f1 <matchhere+0x96>
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	0f b6 10             	movzbl (%eax),%edx
 2e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ea:	0f b6 00             	movzbl (%eax),%eax
 2ed:	38 c2                	cmp    %al,%dl
 2ef:	75 1a                	jne    30b <matchhere+0xb0>
    return matchhere(re+1, text+1);
 2f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	83 c0 01             	add    $0x1,%eax
 2fd:	89 54 24 04          	mov    %edx,0x4(%esp)
 301:	89 04 24             	mov    %eax,(%esp)
 304:	e8 52 ff ff ff       	call   25b <matchhere>
 309:	eb 05                	jmp    310 <matchhere+0xb5>
  return 0;
 30b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 310:	c9                   	leave  
 311:	c3                   	ret    

00000312 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 318:	8b 45 10             	mov    0x10(%ebp),%eax
 31b:	89 44 24 04          	mov    %eax,0x4(%esp)
 31f:	8b 45 0c             	mov    0xc(%ebp),%eax
 322:	89 04 24             	mov    %eax,(%esp)
 325:	e8 31 ff ff ff       	call   25b <matchhere>
 32a:	85 c0                	test   %eax,%eax
 32c:	74 07                	je     335 <matchstar+0x23>
      return 1;
 32e:	b8 01 00 00 00       	mov    $0x1,%eax
 333:	eb 29                	jmp    35e <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
 335:	8b 45 10             	mov    0x10(%ebp),%eax
 338:	0f b6 00             	movzbl (%eax),%eax
 33b:	84 c0                	test   %al,%al
 33d:	74 1a                	je     359 <matchstar+0x47>
 33f:	8b 45 10             	mov    0x10(%ebp),%eax
 342:	8d 50 01             	lea    0x1(%eax),%edx
 345:	89 55 10             	mov    %edx,0x10(%ebp)
 348:	0f b6 00             	movzbl (%eax),%eax
 34b:	0f be c0             	movsbl %al,%eax
 34e:	3b 45 08             	cmp    0x8(%ebp),%eax
 351:	74 c5                	je     318 <matchstar+0x6>
 353:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 357:	74 bf                	je     318 <matchstar+0x6>
  return 0;
 359:	b8 00 00 00 00       	mov    $0x0,%eax
}
 35e:	c9                   	leave  
 35f:	c3                   	ret    

00000360 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 365:	8b 4d 08             	mov    0x8(%ebp),%ecx
 368:	8b 55 10             	mov    0x10(%ebp),%edx
 36b:	8b 45 0c             	mov    0xc(%ebp),%eax
 36e:	89 cb                	mov    %ecx,%ebx
 370:	89 df                	mov    %ebx,%edi
 372:	89 d1                	mov    %edx,%ecx
 374:	fc                   	cld    
 375:	f3 aa                	rep stos %al,%es:(%edi)
 377:	89 ca                	mov    %ecx,%edx
 379:	89 fb                	mov    %edi,%ebx
 37b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 37e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 381:	5b                   	pop    %ebx
 382:	5f                   	pop    %edi
 383:	5d                   	pop    %ebp
 384:	c3                   	ret    

00000385 <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
 385:	55                   	push   %ebp
 386:	89 e5                	mov    %esp,%ebp
 388:	57                   	push   %edi
 389:	56                   	push   %esi
 38a:	53                   	push   %ebx
 38b:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
 391:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
 397:	89 04 24             	mov    %eax,(%esp)
 39a:	e8 1e 04 00 00       	call   7bd <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 39f:	c7 44 24 04 b4 0c 00 	movl   $0xcb4,0x4(%esp)
 3a6:	00 
 3a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3ae:	e8 fa 04 00 00       	call   8ad <printf>
    for (i = 0; i < NPROC; i++) {
 3b3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 3ba:	e9 06 01 00 00       	jmp    4c5 <ps+0x140>
        if (ptable[i].inuse) {
 3bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3c2:	89 d0                	mov    %edx,%eax
 3c4:	c1 e0 03             	shl    $0x3,%eax
 3c7:	01 d0                	add    %edx,%eax
 3c9:	c1 e0 02             	shl    $0x2,%eax
 3cc:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 3cf:	01 d8                	add    %ebx,%eax
 3d1:	2d 08 09 00 00       	sub    $0x908,%eax
 3d6:	8b 00                	mov    (%eax),%eax
 3d8:	85 c0                	test   %eax,%eax
 3da:	0f 84 e1 00 00 00    	je     4c1 <ps+0x13c>
            char stat = '?';
 3e0:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
 3e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3e7:	89 d0                	mov    %edx,%eax
 3e9:	c1 e0 03             	shl    $0x3,%eax
 3ec:	01 d0                	add    %edx,%eax
 3ee:	c1 e0 02             	shl    $0x2,%eax
 3f1:	8d 75 e8             	lea    -0x18(%ebp),%esi
 3f4:	01 f0                	add    %esi,%eax
 3f6:	2d e8 08 00 00       	sub    $0x8e8,%eax
 3fb:	0f b6 00             	movzbl (%eax),%eax
 3fe:	0f be c0             	movsbl %al,%eax
 401:	83 f8 05             	cmp    $0x5,%eax
 404:	77 27                	ja     42d <ps+0xa8>
 406:	8b 04 85 e0 0c 00 00 	mov    0xce0(,%eax,4),%eax
 40d:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
 40f:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
 413:	eb 1c                	jmp    431 <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
 415:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 419:	eb 16                	jmp    431 <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
 41b:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
 41f:	eb 10                	jmp    431 <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
 421:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
 425:	eb 0a                	jmp    431 <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
 427:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
 42b:	eb 04                	jmp    431 <ps+0xac>
                default: stat = '?';
 42d:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
 431:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
 437:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 43a:	89 d0                	mov    %edx,%eax
 43c:	c1 e0 03             	shl    $0x3,%eax
 43f:	01 d0                	add    %edx,%eax
 441:	c1 e0 02             	shl    $0x2,%eax
 444:	83 c0 10             	add    $0x10,%eax
 447:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 44a:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 44e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 451:	89 d0                	mov    %edx,%eax
 453:	c1 e0 03             	shl    $0x3,%eax
 456:	01 d0                	add    %edx,%eax
 458:	c1 e0 02             	shl    $0x2,%eax
 45b:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 45e:	01 c8                	add    %ecx,%eax
 460:	2d fc 08 00 00       	sub    $0x8fc,%eax
 465:	8b 18                	mov    (%eax),%ebx
 467:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 46a:	89 d0                	mov    %edx,%eax
 46c:	c1 e0 03             	shl    $0x3,%eax
 46f:	01 d0                	add    %edx,%eax
 471:	c1 e0 02             	shl    $0x2,%eax
 474:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 477:	01 c8                	add    %ecx,%eax
 479:	2d 04 09 00 00       	sub    $0x904,%eax
 47e:	8b 08                	mov    (%eax),%ecx
 480:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 483:	89 d0                	mov    %edx,%eax
 485:	c1 e0 03             	shl    $0x3,%eax
 488:	01 d0                	add    %edx,%eax
 48a:	c1 e0 02             	shl    $0x2,%eax
 48d:	8d 55 e8             	lea    -0x18(%ebp),%edx
 490:	01 d0                	add    %edx,%eax
 492:	2d 00 09 00 00       	sub    $0x900,%eax
 497:	8b 00                	mov    (%eax),%eax
 499:	89 7c 24 18          	mov    %edi,0x18(%esp)
 49d:	89 74 24 14          	mov    %esi,0x14(%esp)
 4a1:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 4a5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 4a9:	89 44 24 08          	mov    %eax,0x8(%esp)
 4ad:	c7 44 24 04 cd 0c 00 	movl   $0xccd,0x4(%esp)
 4b4:	00 
 4b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4bc:	e8 ec 03 00 00       	call   8ad <printf>
    for (i = 0; i < NPROC; i++) {
 4c1:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 4c5:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 4c9:	0f 8e f0 fe ff ff    	jle    3bf <ps+0x3a>
        }
    }
}
 4cf:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 4d5:	5b                   	pop    %ebx
 4d6:	5e                   	pop    %esi
 4d7:	5f                   	pop    %edi
 4d8:	5d                   	pop    %ebp
 4d9:	c3                   	ret    

000004da <strcpy>:


char*
strcpy(char *s, const char *t)
{
 4da:	55                   	push   %ebp
 4db:	89 e5                	mov    %esp,%ebp
 4dd:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 4e0:	8b 45 08             	mov    0x8(%ebp),%eax
 4e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 4e6:	90                   	nop
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ea:	8d 50 01             	lea    0x1(%eax),%edx
 4ed:	89 55 08             	mov    %edx,0x8(%ebp)
 4f0:	8b 55 0c             	mov    0xc(%ebp),%edx
 4f3:	8d 4a 01             	lea    0x1(%edx),%ecx
 4f6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 4f9:	0f b6 12             	movzbl (%edx),%edx
 4fc:	88 10                	mov    %dl,(%eax)
 4fe:	0f b6 00             	movzbl (%eax),%eax
 501:	84 c0                	test   %al,%al
 503:	75 e2                	jne    4e7 <strcpy+0xd>
    ;
  return os;
 505:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 508:	c9                   	leave  
 509:	c3                   	ret    

0000050a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 50a:	55                   	push   %ebp
 50b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 50d:	eb 08                	jmp    517 <strcmp+0xd>
    p++, q++;
 50f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 513:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	0f b6 00             	movzbl (%eax),%eax
 51d:	84 c0                	test   %al,%al
 51f:	74 10                	je     531 <strcmp+0x27>
 521:	8b 45 08             	mov    0x8(%ebp),%eax
 524:	0f b6 10             	movzbl (%eax),%edx
 527:	8b 45 0c             	mov    0xc(%ebp),%eax
 52a:	0f b6 00             	movzbl (%eax),%eax
 52d:	38 c2                	cmp    %al,%dl
 52f:	74 de                	je     50f <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	0f b6 00             	movzbl (%eax),%eax
 537:	0f b6 d0             	movzbl %al,%edx
 53a:	8b 45 0c             	mov    0xc(%ebp),%eax
 53d:	0f b6 00             	movzbl (%eax),%eax
 540:	0f b6 c0             	movzbl %al,%eax
 543:	29 c2                	sub    %eax,%edx
 545:	89 d0                	mov    %edx,%eax
}
 547:	5d                   	pop    %ebp
 548:	c3                   	ret    

00000549 <strlen>:

uint
strlen(const char *s)
{
 549:	55                   	push   %ebp
 54a:	89 e5                	mov    %esp,%ebp
 54c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 54f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 556:	eb 04                	jmp    55c <strlen+0x13>
 558:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 55c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	01 d0                	add    %edx,%eax
 564:	0f b6 00             	movzbl (%eax),%eax
 567:	84 c0                	test   %al,%al
 569:	75 ed                	jne    558 <strlen+0xf>
    ;
  return n;
 56b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 56e:	c9                   	leave  
 56f:	c3                   	ret    

00000570 <memset>:

void*
memset(void *dst, int c, uint n)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 576:	8b 45 10             	mov    0x10(%ebp),%eax
 579:	89 44 24 08          	mov    %eax,0x8(%esp)
 57d:	8b 45 0c             	mov    0xc(%ebp),%eax
 580:	89 44 24 04          	mov    %eax,0x4(%esp)
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	89 04 24             	mov    %eax,(%esp)
 58a:	e8 d1 fd ff ff       	call   360 <stosb>
  return dst;
 58f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 592:	c9                   	leave  
 593:	c3                   	ret    

00000594 <strchr>:

char*
strchr(const char *s, char c)
{
 594:	55                   	push   %ebp
 595:	89 e5                	mov    %esp,%ebp
 597:	83 ec 04             	sub    $0x4,%esp
 59a:	8b 45 0c             	mov    0xc(%ebp),%eax
 59d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 5a0:	eb 14                	jmp    5b6 <strchr+0x22>
    if(*s == c)
 5a2:	8b 45 08             	mov    0x8(%ebp),%eax
 5a5:	0f b6 00             	movzbl (%eax),%eax
 5a8:	3a 45 fc             	cmp    -0x4(%ebp),%al
 5ab:	75 05                	jne    5b2 <strchr+0x1e>
      return (char*)s;
 5ad:	8b 45 08             	mov    0x8(%ebp),%eax
 5b0:	eb 13                	jmp    5c5 <strchr+0x31>
  for(; *s; s++)
 5b2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
 5b9:	0f b6 00             	movzbl (%eax),%eax
 5bc:	84 c0                	test   %al,%al
 5be:	75 e2                	jne    5a2 <strchr+0xe>
  return 0;
 5c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 5c5:	c9                   	leave  
 5c6:	c3                   	ret    

000005c7 <gets>:

char*
gets(char *buf, int max)
{
 5c7:	55                   	push   %ebp
 5c8:	89 e5                	mov    %esp,%ebp
 5ca:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 5d4:	eb 4c                	jmp    622 <gets+0x5b>
    cc = read(0, &c, 1);
 5d6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5dd:	00 
 5de:	8d 45 ef             	lea    -0x11(%ebp),%eax
 5e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5ec:	e8 44 01 00 00       	call   735 <read>
 5f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 5f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5f8:	7f 02                	jg     5fc <gets+0x35>
      break;
 5fa:	eb 31                	jmp    62d <gets+0x66>
    buf[i++] = c;
 5fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ff:	8d 50 01             	lea    0x1(%eax),%edx
 602:	89 55 f4             	mov    %edx,-0xc(%ebp)
 605:	89 c2                	mov    %eax,%edx
 607:	8b 45 08             	mov    0x8(%ebp),%eax
 60a:	01 c2                	add    %eax,%edx
 60c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 610:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 612:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 616:	3c 0a                	cmp    $0xa,%al
 618:	74 13                	je     62d <gets+0x66>
 61a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 61e:	3c 0d                	cmp    $0xd,%al
 620:	74 0b                	je     62d <gets+0x66>
  for(i=0; i+1 < max; ){
 622:	8b 45 f4             	mov    -0xc(%ebp),%eax
 625:	83 c0 01             	add    $0x1,%eax
 628:	3b 45 0c             	cmp    0xc(%ebp),%eax
 62b:	7c a9                	jl     5d6 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 62d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 630:	8b 45 08             	mov    0x8(%ebp),%eax
 633:	01 d0                	add    %edx,%eax
 635:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 638:	8b 45 08             	mov    0x8(%ebp),%eax
}
 63b:	c9                   	leave  
 63c:	c3                   	ret    

0000063d <stat>:

int
stat(const char *n, struct stat *st)
{
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 643:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 64a:	00 
 64b:	8b 45 08             	mov    0x8(%ebp),%eax
 64e:	89 04 24             	mov    %eax,(%esp)
 651:	e8 07 01 00 00       	call   75d <open>
 656:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 659:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 65d:	79 07                	jns    666 <stat+0x29>
    return -1;
 65f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 664:	eb 23                	jmp    689 <stat+0x4c>
  r = fstat(fd, st);
 666:	8b 45 0c             	mov    0xc(%ebp),%eax
 669:	89 44 24 04          	mov    %eax,0x4(%esp)
 66d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 670:	89 04 24             	mov    %eax,(%esp)
 673:	e8 fd 00 00 00       	call   775 <fstat>
 678:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 67b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67e:	89 04 24             	mov    %eax,(%esp)
 681:	e8 bf 00 00 00       	call   745 <close>
  return r;
 686:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 689:	c9                   	leave  
 68a:	c3                   	ret    

0000068b <atoi>:

int
atoi(const char *s)
{
 68b:	55                   	push   %ebp
 68c:	89 e5                	mov    %esp,%ebp
 68e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 691:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 698:	eb 25                	jmp    6bf <atoi+0x34>
    n = n*10 + *s++ - '0';
 69a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 69d:	89 d0                	mov    %edx,%eax
 69f:	c1 e0 02             	shl    $0x2,%eax
 6a2:	01 d0                	add    %edx,%eax
 6a4:	01 c0                	add    %eax,%eax
 6a6:	89 c1                	mov    %eax,%ecx
 6a8:	8b 45 08             	mov    0x8(%ebp),%eax
 6ab:	8d 50 01             	lea    0x1(%eax),%edx
 6ae:	89 55 08             	mov    %edx,0x8(%ebp)
 6b1:	0f b6 00             	movzbl (%eax),%eax
 6b4:	0f be c0             	movsbl %al,%eax
 6b7:	01 c8                	add    %ecx,%eax
 6b9:	83 e8 30             	sub    $0x30,%eax
 6bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6bf:	8b 45 08             	mov    0x8(%ebp),%eax
 6c2:	0f b6 00             	movzbl (%eax),%eax
 6c5:	3c 2f                	cmp    $0x2f,%al
 6c7:	7e 0a                	jle    6d3 <atoi+0x48>
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
 6cc:	0f b6 00             	movzbl (%eax),%eax
 6cf:	3c 39                	cmp    $0x39,%al
 6d1:	7e c7                	jle    69a <atoi+0xf>
  return n;
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6d6:	c9                   	leave  
 6d7:	c3                   	ret    

000006d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6d8:	55                   	push   %ebp
 6d9:	89 e5                	mov    %esp,%ebp
 6db:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 6de:	8b 45 08             	mov    0x8(%ebp),%eax
 6e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 6e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 6ea:	eb 17                	jmp    703 <memmove+0x2b>
    *dst++ = *src++;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8d 50 01             	lea    0x1(%eax),%edx
 6f2:	89 55 fc             	mov    %edx,-0x4(%ebp)
 6f5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f8:	8d 4a 01             	lea    0x1(%edx),%ecx
 6fb:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 6fe:	0f b6 12             	movzbl (%edx),%edx
 701:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 703:	8b 45 10             	mov    0x10(%ebp),%eax
 706:	8d 50 ff             	lea    -0x1(%eax),%edx
 709:	89 55 10             	mov    %edx,0x10(%ebp)
 70c:	85 c0                	test   %eax,%eax
 70e:	7f dc                	jg     6ec <memmove+0x14>
  return vdst;
 710:	8b 45 08             	mov    0x8(%ebp),%eax
}
 713:	c9                   	leave  
 714:	c3                   	ret    

00000715 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 715:	b8 01 00 00 00       	mov    $0x1,%eax
 71a:	cd 40                	int    $0x40
 71c:	c3                   	ret    

0000071d <exit>:
SYSCALL(exit)
 71d:	b8 02 00 00 00       	mov    $0x2,%eax
 722:	cd 40                	int    $0x40
 724:	c3                   	ret    

00000725 <wait>:
SYSCALL(wait)
 725:	b8 03 00 00 00       	mov    $0x3,%eax
 72a:	cd 40                	int    $0x40
 72c:	c3                   	ret    

0000072d <pipe>:
SYSCALL(pipe)
 72d:	b8 04 00 00 00       	mov    $0x4,%eax
 732:	cd 40                	int    $0x40
 734:	c3                   	ret    

00000735 <read>:
SYSCALL(read)
 735:	b8 05 00 00 00       	mov    $0x5,%eax
 73a:	cd 40                	int    $0x40
 73c:	c3                   	ret    

0000073d <write>:
SYSCALL(write)
 73d:	b8 10 00 00 00       	mov    $0x10,%eax
 742:	cd 40                	int    $0x40
 744:	c3                   	ret    

00000745 <close>:
SYSCALL(close)
 745:	b8 15 00 00 00       	mov    $0x15,%eax
 74a:	cd 40                	int    $0x40
 74c:	c3                   	ret    

0000074d <kill>:
SYSCALL(kill)
 74d:	b8 06 00 00 00       	mov    $0x6,%eax
 752:	cd 40                	int    $0x40
 754:	c3                   	ret    

00000755 <exec>:
SYSCALL(exec)
 755:	b8 07 00 00 00       	mov    $0x7,%eax
 75a:	cd 40                	int    $0x40
 75c:	c3                   	ret    

0000075d <open>:
SYSCALL(open)
 75d:	b8 0f 00 00 00       	mov    $0xf,%eax
 762:	cd 40                	int    $0x40
 764:	c3                   	ret    

00000765 <mknod>:
SYSCALL(mknod)
 765:	b8 11 00 00 00       	mov    $0x11,%eax
 76a:	cd 40                	int    $0x40
 76c:	c3                   	ret    

0000076d <unlink>:
SYSCALL(unlink)
 76d:	b8 12 00 00 00       	mov    $0x12,%eax
 772:	cd 40                	int    $0x40
 774:	c3                   	ret    

00000775 <fstat>:
SYSCALL(fstat)
 775:	b8 08 00 00 00       	mov    $0x8,%eax
 77a:	cd 40                	int    $0x40
 77c:	c3                   	ret    

0000077d <link>:
SYSCALL(link)
 77d:	b8 13 00 00 00       	mov    $0x13,%eax
 782:	cd 40                	int    $0x40
 784:	c3                   	ret    

00000785 <mkdir>:
SYSCALL(mkdir)
 785:	b8 14 00 00 00       	mov    $0x14,%eax
 78a:	cd 40                	int    $0x40
 78c:	c3                   	ret    

0000078d <chdir>:
SYSCALL(chdir)
 78d:	b8 09 00 00 00       	mov    $0x9,%eax
 792:	cd 40                	int    $0x40
 794:	c3                   	ret    

00000795 <dup>:
SYSCALL(dup)
 795:	b8 0a 00 00 00       	mov    $0xa,%eax
 79a:	cd 40                	int    $0x40
 79c:	c3                   	ret    

0000079d <getpid>:
SYSCALL(getpid)
 79d:	b8 0b 00 00 00       	mov    $0xb,%eax
 7a2:	cd 40                	int    $0x40
 7a4:	c3                   	ret    

000007a5 <sbrk>:
SYSCALL(sbrk)
 7a5:	b8 0c 00 00 00       	mov    $0xc,%eax
 7aa:	cd 40                	int    $0x40
 7ac:	c3                   	ret    

000007ad <sleep>:
SYSCALL(sleep)
 7ad:	b8 0d 00 00 00       	mov    $0xd,%eax
 7b2:	cd 40                	int    $0x40
 7b4:	c3                   	ret    

000007b5 <uptime>:
SYSCALL(uptime)
 7b5:	b8 0e 00 00 00       	mov    $0xe,%eax
 7ba:	cd 40                	int    $0x40
 7bc:	c3                   	ret    

000007bd <getpinfo>:
SYSCALL(getpinfo)
 7bd:	b8 16 00 00 00       	mov    $0x16,%eax
 7c2:	cd 40                	int    $0x40
 7c4:	c3                   	ret    

000007c5 <settickets>:
SYSCALL(settickets)
 7c5:	b8 17 00 00 00       	mov    $0x17,%eax
 7ca:	cd 40                	int    $0x40
 7cc:	c3                   	ret    

000007cd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7cd:	55                   	push   %ebp
 7ce:	89 e5                	mov    %esp,%ebp
 7d0:	83 ec 18             	sub    $0x18,%esp
 7d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 7d9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7e0:	00 
 7e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7e4:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e8:	8b 45 08             	mov    0x8(%ebp),%eax
 7eb:	89 04 24             	mov    %eax,(%esp)
 7ee:	e8 4a ff ff ff       	call   73d <write>
}
 7f3:	c9                   	leave  
 7f4:	c3                   	ret    

000007f5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7f5:	55                   	push   %ebp
 7f6:	89 e5                	mov    %esp,%ebp
 7f8:	56                   	push   %esi
 7f9:	53                   	push   %ebx
 7fa:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 804:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 808:	74 17                	je     821 <printint+0x2c>
 80a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 80e:	79 11                	jns    821 <printint+0x2c>
    neg = 1;
 810:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 817:	8b 45 0c             	mov    0xc(%ebp),%eax
 81a:	f7 d8                	neg    %eax
 81c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 81f:	eb 06                	jmp    827 <printint+0x32>
  } else {
    x = xx;
 821:	8b 45 0c             	mov    0xc(%ebp),%eax
 824:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 827:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 82e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 831:	8d 41 01             	lea    0x1(%ecx),%eax
 834:	89 45 f4             	mov    %eax,-0xc(%ebp)
 837:	8b 5d 10             	mov    0x10(%ebp),%ebx
 83a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 83d:	ba 00 00 00 00       	mov    $0x0,%edx
 842:	f7 f3                	div    %ebx
 844:	89 d0                	mov    %edx,%eax
 846:	0f b6 80 f4 0f 00 00 	movzbl 0xff4(%eax),%eax
 84d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 851:	8b 75 10             	mov    0x10(%ebp),%esi
 854:	8b 45 ec             	mov    -0x14(%ebp),%eax
 857:	ba 00 00 00 00       	mov    $0x0,%edx
 85c:	f7 f6                	div    %esi
 85e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 861:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 865:	75 c7                	jne    82e <printint+0x39>
  if(neg)
 867:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 86b:	74 10                	je     87d <printint+0x88>
    buf[i++] = '-';
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	8d 50 01             	lea    0x1(%eax),%edx
 873:	89 55 f4             	mov    %edx,-0xc(%ebp)
 876:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 87b:	eb 1f                	jmp    89c <printint+0xa7>
 87d:	eb 1d                	jmp    89c <printint+0xa7>
    putc(fd, buf[i]);
 87f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	01 d0                	add    %edx,%eax
 887:	0f b6 00             	movzbl (%eax),%eax
 88a:	0f be c0             	movsbl %al,%eax
 88d:	89 44 24 04          	mov    %eax,0x4(%esp)
 891:	8b 45 08             	mov    0x8(%ebp),%eax
 894:	89 04 24             	mov    %eax,(%esp)
 897:	e8 31 ff ff ff       	call   7cd <putc>
  while(--i >= 0)
 89c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 8a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a4:	79 d9                	jns    87f <printint+0x8a>
}
 8a6:	83 c4 30             	add    $0x30,%esp
 8a9:	5b                   	pop    %ebx
 8aa:	5e                   	pop    %esi
 8ab:	5d                   	pop    %ebp
 8ac:	c3                   	ret    

000008ad <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8ad:	55                   	push   %ebp
 8ae:	89 e5                	mov    %esp,%ebp
 8b0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 8b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8ba:	8d 45 0c             	lea    0xc(%ebp),%eax
 8bd:	83 c0 04             	add    $0x4,%eax
 8c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8ca:	e9 7c 01 00 00       	jmp    a4b <printf+0x19e>
    c = fmt[i] & 0xff;
 8cf:	8b 55 0c             	mov    0xc(%ebp),%edx
 8d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d5:	01 d0                	add    %edx,%eax
 8d7:	0f b6 00             	movzbl (%eax),%eax
 8da:	0f be c0             	movsbl %al,%eax
 8dd:	25 ff 00 00 00       	and    $0xff,%eax
 8e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8e9:	75 2c                	jne    917 <printf+0x6a>
      if(c == '%'){
 8eb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8ef:	75 0c                	jne    8fd <printf+0x50>
        state = '%';
 8f1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8f8:	e9 4a 01 00 00       	jmp    a47 <printf+0x19a>
      } else {
        putc(fd, c);
 8fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 900:	0f be c0             	movsbl %al,%eax
 903:	89 44 24 04          	mov    %eax,0x4(%esp)
 907:	8b 45 08             	mov    0x8(%ebp),%eax
 90a:	89 04 24             	mov    %eax,(%esp)
 90d:	e8 bb fe ff ff       	call   7cd <putc>
 912:	e9 30 01 00 00       	jmp    a47 <printf+0x19a>
      }
    } else if(state == '%'){
 917:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 91b:	0f 85 26 01 00 00    	jne    a47 <printf+0x19a>
      if(c == 'd'){
 921:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 925:	75 2d                	jne    954 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 927:	8b 45 e8             	mov    -0x18(%ebp),%eax
 92a:	8b 00                	mov    (%eax),%eax
 92c:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 933:	00 
 934:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 93b:	00 
 93c:	89 44 24 04          	mov    %eax,0x4(%esp)
 940:	8b 45 08             	mov    0x8(%ebp),%eax
 943:	89 04 24             	mov    %eax,(%esp)
 946:	e8 aa fe ff ff       	call   7f5 <printint>
        ap++;
 94b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 94f:	e9 ec 00 00 00       	jmp    a40 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 954:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 958:	74 06                	je     960 <printf+0xb3>
 95a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 95e:	75 2d                	jne    98d <printf+0xe0>
        printint(fd, *ap, 16, 0);
 960:	8b 45 e8             	mov    -0x18(%ebp),%eax
 963:	8b 00                	mov    (%eax),%eax
 965:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 96c:	00 
 96d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 974:	00 
 975:	89 44 24 04          	mov    %eax,0x4(%esp)
 979:	8b 45 08             	mov    0x8(%ebp),%eax
 97c:	89 04 24             	mov    %eax,(%esp)
 97f:	e8 71 fe ff ff       	call   7f5 <printint>
        ap++;
 984:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 988:	e9 b3 00 00 00       	jmp    a40 <printf+0x193>
      } else if(c == 's'){
 98d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 991:	75 45                	jne    9d8 <printf+0x12b>
        s = (char*)*ap;
 993:	8b 45 e8             	mov    -0x18(%ebp),%eax
 996:	8b 00                	mov    (%eax),%eax
 998:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 99b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 99f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9a3:	75 09                	jne    9ae <printf+0x101>
          s = "(null)";
 9a5:	c7 45 f4 f8 0c 00 00 	movl   $0xcf8,-0xc(%ebp)
        while(*s != 0){
 9ac:	eb 1e                	jmp    9cc <printf+0x11f>
 9ae:	eb 1c                	jmp    9cc <printf+0x11f>
          putc(fd, *s);
 9b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b3:	0f b6 00             	movzbl (%eax),%eax
 9b6:	0f be c0             	movsbl %al,%eax
 9b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 9bd:	8b 45 08             	mov    0x8(%ebp),%eax
 9c0:	89 04 24             	mov    %eax,(%esp)
 9c3:	e8 05 fe ff ff       	call   7cd <putc>
          s++;
 9c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 9cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cf:	0f b6 00             	movzbl (%eax),%eax
 9d2:	84 c0                	test   %al,%al
 9d4:	75 da                	jne    9b0 <printf+0x103>
 9d6:	eb 68                	jmp    a40 <printf+0x193>
        }
      } else if(c == 'c'){
 9d8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 9dc:	75 1d                	jne    9fb <printf+0x14e>
        putc(fd, *ap);
 9de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9e1:	8b 00                	mov    (%eax),%eax
 9e3:	0f be c0             	movsbl %al,%eax
 9e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 9ea:	8b 45 08             	mov    0x8(%ebp),%eax
 9ed:	89 04 24             	mov    %eax,(%esp)
 9f0:	e8 d8 fd ff ff       	call   7cd <putc>
        ap++;
 9f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9f9:	eb 45                	jmp    a40 <printf+0x193>
      } else if(c == '%'){
 9fb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9ff:	75 17                	jne    a18 <printf+0x16b>
        putc(fd, c);
 a01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a04:	0f be c0             	movsbl %al,%eax
 a07:	89 44 24 04          	mov    %eax,0x4(%esp)
 a0b:	8b 45 08             	mov    0x8(%ebp),%eax
 a0e:	89 04 24             	mov    %eax,(%esp)
 a11:	e8 b7 fd ff ff       	call   7cd <putc>
 a16:	eb 28                	jmp    a40 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a18:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 a1f:	00 
 a20:	8b 45 08             	mov    0x8(%ebp),%eax
 a23:	89 04 24             	mov    %eax,(%esp)
 a26:	e8 a2 fd ff ff       	call   7cd <putc>
        putc(fd, c);
 a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a2e:	0f be c0             	movsbl %al,%eax
 a31:	89 44 24 04          	mov    %eax,0x4(%esp)
 a35:	8b 45 08             	mov    0x8(%ebp),%eax
 a38:	89 04 24             	mov    %eax,(%esp)
 a3b:	e8 8d fd ff ff       	call   7cd <putc>
      }
      state = 0;
 a40:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 a47:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
 a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a51:	01 d0                	add    %edx,%eax
 a53:	0f b6 00             	movzbl (%eax),%eax
 a56:	84 c0                	test   %al,%al
 a58:	0f 85 71 fe ff ff    	jne    8cf <printf+0x22>
    }
  }
}
 a5e:	c9                   	leave  
 a5f:	c3                   	ret    

00000a60 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a60:	55                   	push   %ebp
 a61:	89 e5                	mov    %esp,%ebp
 a63:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a66:	8b 45 08             	mov    0x8(%ebp),%eax
 a69:	83 e8 08             	sub    $0x8,%eax
 a6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a6f:	a1 28 10 00 00       	mov    0x1028,%eax
 a74:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a77:	eb 24                	jmp    a9d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a79:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7c:	8b 00                	mov    (%eax),%eax
 a7e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a81:	77 12                	ja     a95 <free+0x35>
 a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a86:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a89:	77 24                	ja     aaf <free+0x4f>
 a8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8e:	8b 00                	mov    (%eax),%eax
 a90:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a93:	77 1a                	ja     aaf <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a98:	8b 00                	mov    (%eax),%eax
 a9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 aa3:	76 d4                	jbe    a79 <free+0x19>
 aa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa8:	8b 00                	mov    (%eax),%eax
 aaa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 aad:	76 ca                	jbe    a79 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 aaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab2:	8b 40 04             	mov    0x4(%eax),%eax
 ab5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 abc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 abf:	01 c2                	add    %eax,%edx
 ac1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac4:	8b 00                	mov    (%eax),%eax
 ac6:	39 c2                	cmp    %eax,%edx
 ac8:	75 24                	jne    aee <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 aca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 acd:	8b 50 04             	mov    0x4(%eax),%edx
 ad0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad3:	8b 00                	mov    (%eax),%eax
 ad5:	8b 40 04             	mov    0x4(%eax),%eax
 ad8:	01 c2                	add    %eax,%edx
 ada:	8b 45 f8             	mov    -0x8(%ebp),%eax
 add:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 ae0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae3:	8b 00                	mov    (%eax),%eax
 ae5:	8b 10                	mov    (%eax),%edx
 ae7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aea:	89 10                	mov    %edx,(%eax)
 aec:	eb 0a                	jmp    af8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 aee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af1:	8b 10                	mov    (%eax),%edx
 af3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 af6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 af8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 afb:	8b 40 04             	mov    0x4(%eax),%eax
 afe:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b08:	01 d0                	add    %edx,%eax
 b0a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b0d:	75 20                	jne    b2f <free+0xcf>
    p->s.size += bp->s.size;
 b0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b12:	8b 50 04             	mov    0x4(%eax),%edx
 b15:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b18:	8b 40 04             	mov    0x4(%eax),%eax
 b1b:	01 c2                	add    %eax,%edx
 b1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b20:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b23:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b26:	8b 10                	mov    (%eax),%edx
 b28:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b2b:	89 10                	mov    %edx,(%eax)
 b2d:	eb 08                	jmp    b37 <free+0xd7>
  } else
    p->s.ptr = bp;
 b2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b32:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b35:	89 10                	mov    %edx,(%eax)
  freep = p;
 b37:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b3a:	a3 28 10 00 00       	mov    %eax,0x1028
}
 b3f:	c9                   	leave  
 b40:	c3                   	ret    

00000b41 <morecore>:

static Header*
morecore(uint nu)
{
 b41:	55                   	push   %ebp
 b42:	89 e5                	mov    %esp,%ebp
 b44:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b47:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b4e:	77 07                	ja     b57 <morecore+0x16>
    nu = 4096;
 b50:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b57:	8b 45 08             	mov    0x8(%ebp),%eax
 b5a:	c1 e0 03             	shl    $0x3,%eax
 b5d:	89 04 24             	mov    %eax,(%esp)
 b60:	e8 40 fc ff ff       	call   7a5 <sbrk>
 b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b68:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b6c:	75 07                	jne    b75 <morecore+0x34>
    return 0;
 b6e:	b8 00 00 00 00       	mov    $0x0,%eax
 b73:	eb 22                	jmp    b97 <morecore+0x56>
  hp = (Header*)p;
 b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b7e:	8b 55 08             	mov    0x8(%ebp),%edx
 b81:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b87:	83 c0 08             	add    $0x8,%eax
 b8a:	89 04 24             	mov    %eax,(%esp)
 b8d:	e8 ce fe ff ff       	call   a60 <free>
  return freep;
 b92:	a1 28 10 00 00       	mov    0x1028,%eax
}
 b97:	c9                   	leave  
 b98:	c3                   	ret    

00000b99 <malloc>:

void*
malloc(uint nbytes)
{
 b99:	55                   	push   %ebp
 b9a:	89 e5                	mov    %esp,%ebp
 b9c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b9f:	8b 45 08             	mov    0x8(%ebp),%eax
 ba2:	83 c0 07             	add    $0x7,%eax
 ba5:	c1 e8 03             	shr    $0x3,%eax
 ba8:	83 c0 01             	add    $0x1,%eax
 bab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 bae:	a1 28 10 00 00       	mov    0x1028,%eax
 bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 bba:	75 23                	jne    bdf <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 bbc:	c7 45 f0 20 10 00 00 	movl   $0x1020,-0x10(%ebp)
 bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc6:	a3 28 10 00 00       	mov    %eax,0x1028
 bcb:	a1 28 10 00 00       	mov    0x1028,%eax
 bd0:	a3 20 10 00 00       	mov    %eax,0x1020
    base.s.size = 0;
 bd5:	c7 05 24 10 00 00 00 	movl   $0x0,0x1024
 bdc:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 be2:	8b 00                	mov    (%eax),%eax
 be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bea:	8b 40 04             	mov    0x4(%eax),%eax
 bed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bf0:	72 4d                	jb     c3f <malloc+0xa6>
      if(p->s.size == nunits)
 bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf5:	8b 40 04             	mov    0x4(%eax),%eax
 bf8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bfb:	75 0c                	jne    c09 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c00:	8b 10                	mov    (%eax),%edx
 c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c05:	89 10                	mov    %edx,(%eax)
 c07:	eb 26                	jmp    c2f <malloc+0x96>
      else {
        p->s.size -= nunits;
 c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c0c:	8b 40 04             	mov    0x4(%eax),%eax
 c0f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c12:	89 c2                	mov    %eax,%edx
 c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c17:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c1d:	8b 40 04             	mov    0x4(%eax),%eax
 c20:	c1 e0 03             	shl    $0x3,%eax
 c23:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c29:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c2c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c32:	a3 28 10 00 00       	mov    %eax,0x1028
      return (void*)(p + 1);
 c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c3a:	83 c0 08             	add    $0x8,%eax
 c3d:	eb 38                	jmp    c77 <malloc+0xde>
    }
    if(p == freep)
 c3f:	a1 28 10 00 00       	mov    0x1028,%eax
 c44:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c47:	75 1b                	jne    c64 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c4c:	89 04 24             	mov    %eax,(%esp)
 c4f:	e8 ed fe ff ff       	call   b41 <morecore>
 c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c5b:	75 07                	jne    c64 <malloc+0xcb>
        return 0;
 c5d:	b8 00 00 00 00       	mov    $0x0,%eax
 c62:	eb 13                	jmp    c77 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c6d:	8b 00                	mov    (%eax),%eax
 c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 c72:	e9 70 ff ff ff       	jmp    be7 <malloc+0x4e>
}
 c77:	c9                   	leave  
 c78:	c3                   	ret    
