
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	89 04 24             	mov    %eax,(%esp)
   d:	e8 32 05 00 00       	call   544 <strlen>
  12:	8b 55 08             	mov    0x8(%ebp),%edx
  15:	01 d0                	add    %edx,%eax
  17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1a:	eb 04                	jmp    20 <fmtname+0x20>
  1c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  23:	3b 45 08             	cmp    0x8(%ebp),%eax
  26:	72 0a                	jb     32 <fmtname+0x32>
  28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2b:	0f b6 00             	movzbl (%eax),%eax
  2e:	3c 2f                	cmp    $0x2f,%al
  30:	75 ea                	jne    1c <fmtname+0x1c>
    ;
  p++;
  32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  39:	89 04 24             	mov    %eax,(%esp)
  3c:	e8 03 05 00 00       	call   544 <strlen>
  41:	83 f8 0d             	cmp    $0xd,%eax
  44:	76 05                	jbe    4b <fmtname+0x4b>
    return p;
  46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  49:	eb 5f                	jmp    aa <fmtname+0xaa>
  memmove(buf, p, strlen(p));
  4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4e:	89 04 24             	mov    %eax,(%esp)
  51:	e8 ee 04 00 00       	call   544 <strlen>
  56:	89 44 24 08          	mov    %eax,0x8(%esp)
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  61:	c7 04 24 e8 0f 00 00 	movl   $0xfe8,(%esp)
  68:	e8 66 06 00 00       	call   6d3 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  70:	89 04 24             	mov    %eax,(%esp)
  73:	e8 cc 04 00 00       	call   544 <strlen>
  78:	ba 0e 00 00 00       	mov    $0xe,%edx
  7d:	89 d3                	mov    %edx,%ebx
  7f:	29 c3                	sub    %eax,%ebx
  81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  84:	89 04 24             	mov    %eax,(%esp)
  87:	e8 b8 04 00 00       	call   544 <strlen>
  8c:	05 e8 0f 00 00       	add    $0xfe8,%eax
  91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  95:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  9c:	00 
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 c6 04 00 00       	call   56b <memset>
  return buf;
  a5:	b8 e8 0f 00 00       	mov    $0xfe8,%eax
}
  aa:	83 c4 24             	add    $0x24,%esp
  ad:	5b                   	pop    %ebx
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <ls>:

void
ls(char *path)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	57                   	push   %edi
  b4:	56                   	push   %esi
  b5:	53                   	push   %ebx
  b6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c3:	00 
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 04 24             	mov    %eax,(%esp)
  ca:	e8 89 06 00 00       	call   758 <open>
  cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d6:	79 20                	jns    f8 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	89 44 24 08          	mov    %eax,0x8(%esp)
  df:	c7 44 24 04 74 0c 00 	movl   $0xc74,0x4(%esp)
  e6:	00 
  e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ee:	e8 b5 07 00 00       	call   8a8 <printf>
    return;
  f3:	e9 01 02 00 00       	jmp    2f9 <ls+0x249>
  }

  if(fstat(fd, &st) < 0){
  f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 105:	89 04 24             	mov    %eax,(%esp)
 108:	e8 63 06 00 00       	call   770 <fstat>
 10d:	85 c0                	test   %eax,%eax
 10f:	79 2b                	jns    13c <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	89 44 24 08          	mov    %eax,0x8(%esp)
 118:	c7 44 24 04 88 0c 00 	movl   $0xc88,0x4(%esp)
 11f:	00 
 120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 127:	e8 7c 07 00 00       	call   8a8 <printf>
    close(fd);
 12c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12f:	89 04 24             	mov    %eax,(%esp)
 132:	e8 09 06 00 00       	call   740 <close>
    return;
 137:	e9 bd 01 00 00       	jmp    2f9 <ls+0x249>
  }

  switch(st.type){
 13c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 143:	98                   	cwtl   
 144:	83 f8 01             	cmp    $0x1,%eax
 147:	74 53                	je     19c <ls+0xec>
 149:	83 f8 02             	cmp    $0x2,%eax
 14c:	0f 85 9c 01 00 00    	jne    2ee <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 152:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 158:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15e:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 165:	0f bf d8             	movswl %ax,%ebx
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	89 04 24             	mov    %eax,(%esp)
 16e:	e8 8d fe ff ff       	call   0 <fmtname>
 173:	89 7c 24 14          	mov    %edi,0x14(%esp)
 177:	89 74 24 10          	mov    %esi,0x10(%esp)
 17b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 17f:	89 44 24 08          	mov    %eax,0x8(%esp)
 183:	c7 44 24 04 9c 0c 00 	movl   $0xc9c,0x4(%esp)
 18a:	00 
 18b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 192:	e8 11 07 00 00       	call   8a8 <printf>
    break;
 197:	e9 52 01 00 00       	jmp    2ee <ls+0x23e>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	89 04 24             	mov    %eax,(%esp)
 1a2:	e8 9d 03 00 00       	call   544 <strlen>
 1a7:	83 c0 10             	add    $0x10,%eax
 1aa:	3d 00 02 00 00       	cmp    $0x200,%eax
 1af:	76 19                	jbe    1ca <ls+0x11a>
      printf(1, "ls: path too long\n");
 1b1:	c7 44 24 04 a9 0c 00 	movl   $0xca9,0x4(%esp)
 1b8:	00 
 1b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c0:	e8 e3 06 00 00       	call   8a8 <printf>
      break;
 1c5:	e9 24 01 00 00       	jmp    2ee <ls+0x23e>
    }
    strcpy(buf, path);
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d7:	89 04 24             	mov    %eax,(%esp)
 1da:	e8 f6 02 00 00       	call   4d5 <strcpy>
    p = buf+strlen(buf);
 1df:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e5:	89 04 24             	mov    %eax,(%esp)
 1e8:	e8 57 03 00 00       	call   544 <strlen>
 1ed:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1f3:	01 d0                	add    %edx,%eax
 1f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1fb:	8d 50 01             	lea    0x1(%eax),%edx
 1fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
 201:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 204:	e9 be 00 00 00       	jmp    2c7 <ls+0x217>
      if(de.inum == 0)
 209:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 210:	66 85 c0             	test   %ax,%ax
 213:	75 05                	jne    21a <ls+0x16a>
        continue;
 215:	e9 ad 00 00 00       	jmp    2c7 <ls+0x217>
      memmove(p, de.name, DIRSIZ);
 21a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 221:	00 
 222:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 228:	83 c0 02             	add    $0x2,%eax
 22b:	89 44 24 04          	mov    %eax,0x4(%esp)
 22f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 232:	89 04 24             	mov    %eax,(%esp)
 235:	e8 99 04 00 00       	call   6d3 <memmove>
      p[DIRSIZ] = 0;
 23a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 23d:	83 c0 0e             	add    $0xe,%eax
 240:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 243:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 249:	89 44 24 04          	mov    %eax,0x4(%esp)
 24d:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 253:	89 04 24             	mov    %eax,(%esp)
 256:	e8 dd 03 00 00       	call   638 <stat>
 25b:	85 c0                	test   %eax,%eax
 25d:	79 20                	jns    27f <ls+0x1cf>
        printf(1, "ls: cannot stat %s\n", buf);
 25f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 265:	89 44 24 08          	mov    %eax,0x8(%esp)
 269:	c7 44 24 04 88 0c 00 	movl   $0xc88,0x4(%esp)
 270:	00 
 271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 278:	e8 2b 06 00 00       	call   8a8 <printf>
        continue;
 27d:	eb 48                	jmp    2c7 <ls+0x217>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 27f:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 285:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 28b:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 292:	0f bf d8             	movswl %ax,%ebx
 295:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 29b:	89 04 24             	mov    %eax,(%esp)
 29e:	e8 5d fd ff ff       	call   0 <fmtname>
 2a3:	89 7c 24 14          	mov    %edi,0x14(%esp)
 2a7:	89 74 24 10          	mov    %esi,0x10(%esp)
 2ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2af:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b3:	c7 44 24 04 9c 0c 00 	movl   $0xc9c,0x4(%esp)
 2ba:	00 
 2bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2c2:	e8 e1 05 00 00       	call   8a8 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 2ce:	00 
 2cf:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2dc:	89 04 24             	mov    %eax,(%esp)
 2df:	e8 4c 04 00 00       	call   730 <read>
 2e4:	83 f8 10             	cmp    $0x10,%eax
 2e7:	0f 84 1c ff ff ff    	je     209 <ls+0x159>
    }
    break;
 2ed:	90                   	nop
  }
  close(fd);
 2ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2f1:	89 04 24             	mov    %eax,(%esp)
 2f4:	e8 47 04 00 00       	call   740 <close>
}
 2f9:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2ff:	5b                   	pop    %ebx
 300:	5e                   	pop    %esi
 301:	5f                   	pop    %edi
 302:	5d                   	pop    %ebp
 303:	c3                   	ret    

00000304 <main>:

int
main(int argc, char *argv[])
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	83 e4 f0             	and    $0xfffffff0,%esp
 30a:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
 30d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 311:	7f 11                	jg     324 <main+0x20>
    ls(".");
 313:	c7 04 24 bc 0c 00 00 	movl   $0xcbc,(%esp)
 31a:	e8 91 fd ff ff       	call   b0 <ls>
    exit();
 31f:	e8 f4 03 00 00       	call   718 <exit>
  }
  for(i=1; i<argc; i++)
 324:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 32b:	00 
 32c:	eb 1f                	jmp    34d <main+0x49>
    ls(argv[i]);
 32e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 339:	8b 45 0c             	mov    0xc(%ebp),%eax
 33c:	01 d0                	add    %edx,%eax
 33e:	8b 00                	mov    (%eax),%eax
 340:	89 04 24             	mov    %eax,(%esp)
 343:	e8 68 fd ff ff       	call   b0 <ls>
  for(i=1; i<argc; i++)
 348:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 34d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 351:	3b 45 08             	cmp    0x8(%ebp),%eax
 354:	7c d8                	jl     32e <main+0x2a>
  exit();
 356:	e8 bd 03 00 00       	call   718 <exit>

0000035b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	57                   	push   %edi
 35f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 360:	8b 4d 08             	mov    0x8(%ebp),%ecx
 363:	8b 55 10             	mov    0x10(%ebp),%edx
 366:	8b 45 0c             	mov    0xc(%ebp),%eax
 369:	89 cb                	mov    %ecx,%ebx
 36b:	89 df                	mov    %ebx,%edi
 36d:	89 d1                	mov    %edx,%ecx
 36f:	fc                   	cld    
 370:	f3 aa                	rep stos %al,%es:(%edi)
 372:	89 ca                	mov    %ecx,%edx
 374:	89 fb                	mov    %edi,%ebx
 376:	89 5d 08             	mov    %ebx,0x8(%ebp)
 379:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 37c:	5b                   	pop    %ebx
 37d:	5f                   	pop    %edi
 37e:	5d                   	pop    %ebp
 37f:	c3                   	ret    

00000380 <ps>:
#include "pstat.h"
#include "syscall.h"



void ps(void) {
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	53                   	push   %ebx
 386:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable ptable;
  int i; 
  getpinfo(&ptable);  // Calling the kernel function to get process infomation
 38c:	8d 85 e0 f6 ff ff    	lea    -0x920(%ebp),%eax
 392:	89 04 24             	mov    %eax,(%esp)
 395:	e8 1e 04 00 00       	call   7b8 <getpinfo>
  
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 39a:	c7 44 24 04 c0 0c 00 	movl   $0xcc0,0x4(%esp)
 3a1:	00 
 3a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3a9:	e8 fa 04 00 00       	call   8a8 <printf>
    for (i = 0; i < NPROC; i++) {
 3ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 3b5:	e9 06 01 00 00       	jmp    4c0 <ps+0x140>
        if (ptable[i].inuse) {
 3ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3bd:	89 d0                	mov    %edx,%eax
 3bf:	c1 e0 03             	shl    $0x3,%eax
 3c2:	01 d0                	add    %edx,%eax
 3c4:	c1 e0 02             	shl    $0x2,%eax
 3c7:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 3ca:	01 d8                	add    %ebx,%eax
 3cc:	2d 08 09 00 00       	sub    $0x908,%eax
 3d1:	8b 00                	mov    (%eax),%eax
 3d3:	85 c0                	test   %eax,%eax
 3d5:	0f 84 e1 00 00 00    	je     4bc <ps+0x13c>
            char stat = '?';
 3db:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            switch (ptable[i].state) {
 3df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3e2:	89 d0                	mov    %edx,%eax
 3e4:	c1 e0 03             	shl    $0x3,%eax
 3e7:	01 d0                	add    %edx,%eax
 3e9:	c1 e0 02             	shl    $0x2,%eax
 3ec:	8d 75 e8             	lea    -0x18(%ebp),%esi
 3ef:	01 f0                	add    %esi,%eax
 3f1:	2d e8 08 00 00       	sub    $0x8e8,%eax
 3f6:	0f b6 00             	movzbl (%eax),%eax
 3f9:	0f be c0             	movsbl %al,%eax
 3fc:	83 f8 05             	cmp    $0x5,%eax
 3ff:	77 27                	ja     428 <ps+0xa8>
 401:	8b 04 85 ec 0c 00 00 	mov    0xcec(,%eax,4),%eax
 408:	ff e0                	jmp    *%eax
                case 1: stat = 'E'; break; // EMBRYO
 40a:	c6 45 e3 45          	movb   $0x45,-0x1d(%ebp)
 40e:	eb 1c                	jmp    42c <ps+0xac>
                case 2: stat = 'S'; break; // SLEEPING
 410:	c6 45 e3 53          	movb   $0x53,-0x1d(%ebp)
 414:	eb 16                	jmp    42c <ps+0xac>
                case 3: stat = 'A'; break; // RUNNABLE
 416:	c6 45 e3 41          	movb   $0x41,-0x1d(%ebp)
 41a:	eb 10                	jmp    42c <ps+0xac>
                case 4: stat = 'R'; break; // RUNNING
 41c:	c6 45 e3 52          	movb   $0x52,-0x1d(%ebp)
 420:	eb 0a                	jmp    42c <ps+0xac>
                case 5: stat = 'Z'; break; // ZOMBIE
 422:	c6 45 e3 5a          	movb   $0x5a,-0x1d(%ebp)
 426:	eb 04                	jmp    42c <ps+0xac>
                default: stat = '?';
 428:	c6 45 e3 3f          	movb   $0x3f,-0x1d(%ebp)
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
                   ptable[i].pid,
                   ptable[i].tickets,
                   ptable[i].ticks,
                   stat,
                   ptable[i].name);
 42c:	8d 8d e0 f6 ff ff    	lea    -0x920(%ebp),%ecx
 432:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 435:	89 d0                	mov    %edx,%eax
 437:	c1 e0 03             	shl    $0x3,%eax
 43a:	01 d0                	add    %edx,%eax
 43c:	c1 e0 02             	shl    $0x2,%eax
 43f:	83 c0 10             	add    $0x10,%eax
 442:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
            printf(1, "%d\t%d\t%d\t%c\t%s\n",
 445:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
 449:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 44c:	89 d0                	mov    %edx,%eax
 44e:	c1 e0 03             	shl    $0x3,%eax
 451:	01 d0                	add    %edx,%eax
 453:	c1 e0 02             	shl    $0x2,%eax
 456:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 459:	01 c8                	add    %ecx,%eax
 45b:	2d fc 08 00 00       	sub    $0x8fc,%eax
 460:	8b 18                	mov    (%eax),%ebx
 462:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 465:	89 d0                	mov    %edx,%eax
 467:	c1 e0 03             	shl    $0x3,%eax
 46a:	01 d0                	add    %edx,%eax
 46c:	c1 e0 02             	shl    $0x2,%eax
 46f:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 472:	01 c8                	add    %ecx,%eax
 474:	2d 04 09 00 00       	sub    $0x904,%eax
 479:	8b 08                	mov    (%eax),%ecx
 47b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 47e:	89 d0                	mov    %edx,%eax
 480:	c1 e0 03             	shl    $0x3,%eax
 483:	01 d0                	add    %edx,%eax
 485:	c1 e0 02             	shl    $0x2,%eax
 488:	8d 55 e8             	lea    -0x18(%ebp),%edx
 48b:	01 d0                	add    %edx,%eax
 48d:	2d 00 09 00 00       	sub    $0x900,%eax
 492:	8b 00                	mov    (%eax),%eax
 494:	89 7c 24 18          	mov    %edi,0x18(%esp)
 498:	89 74 24 14          	mov    %esi,0x14(%esp)
 49c:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 4a0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 4a4:	89 44 24 08          	mov    %eax,0x8(%esp)
 4a8:	c7 44 24 04 d9 0c 00 	movl   $0xcd9,0x4(%esp)
 4af:	00 
 4b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4b7:	e8 ec 03 00 00       	call   8a8 <printf>
    for (i = 0; i < NPROC; i++) {
 4bc:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 4c0:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 4c4:	0f 8e f0 fe ff ff    	jle    3ba <ps+0x3a>
        }
    }
}
 4ca:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 4d0:	5b                   	pop    %ebx
 4d1:	5e                   	pop    %esi
 4d2:	5f                   	pop    %edi
 4d3:	5d                   	pop    %ebp
 4d4:	c3                   	ret    

000004d5 <strcpy>:


char*
strcpy(char *s, const char *t)
{
 4d5:	55                   	push   %ebp
 4d6:	89 e5                	mov    %esp,%ebp
 4d8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 4e1:	90                   	nop
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
 4e5:	8d 50 01             	lea    0x1(%eax),%edx
 4e8:	89 55 08             	mov    %edx,0x8(%ebp)
 4eb:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ee:	8d 4a 01             	lea    0x1(%edx),%ecx
 4f1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 4f4:	0f b6 12             	movzbl (%edx),%edx
 4f7:	88 10                	mov    %dl,(%eax)
 4f9:	0f b6 00             	movzbl (%eax),%eax
 4fc:	84 c0                	test   %al,%al
 4fe:	75 e2                	jne    4e2 <strcpy+0xd>
    ;
  return os;
 500:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 503:	c9                   	leave  
 504:	c3                   	ret    

00000505 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 505:	55                   	push   %ebp
 506:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 508:	eb 08                	jmp    512 <strcmp+0xd>
    p++, q++;
 50a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 50e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 512:	8b 45 08             	mov    0x8(%ebp),%eax
 515:	0f b6 00             	movzbl (%eax),%eax
 518:	84 c0                	test   %al,%al
 51a:	74 10                	je     52c <strcmp+0x27>
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
 51f:	0f b6 10             	movzbl (%eax),%edx
 522:	8b 45 0c             	mov    0xc(%ebp),%eax
 525:	0f b6 00             	movzbl (%eax),%eax
 528:	38 c2                	cmp    %al,%dl
 52a:	74 de                	je     50a <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 52c:	8b 45 08             	mov    0x8(%ebp),%eax
 52f:	0f b6 00             	movzbl (%eax),%eax
 532:	0f b6 d0             	movzbl %al,%edx
 535:	8b 45 0c             	mov    0xc(%ebp),%eax
 538:	0f b6 00             	movzbl (%eax),%eax
 53b:	0f b6 c0             	movzbl %al,%eax
 53e:	29 c2                	sub    %eax,%edx
 540:	89 d0                	mov    %edx,%eax
}
 542:	5d                   	pop    %ebp
 543:	c3                   	ret    

00000544 <strlen>:

uint
strlen(const char *s)
{
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
 547:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 54a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 551:	eb 04                	jmp    557 <strlen+0x13>
 553:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 557:	8b 55 fc             	mov    -0x4(%ebp),%edx
 55a:	8b 45 08             	mov    0x8(%ebp),%eax
 55d:	01 d0                	add    %edx,%eax
 55f:	0f b6 00             	movzbl (%eax),%eax
 562:	84 c0                	test   %al,%al
 564:	75 ed                	jne    553 <strlen+0xf>
    ;
  return n;
 566:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 569:	c9                   	leave  
 56a:	c3                   	ret    

0000056b <memset>:

void*
memset(void *dst, int c, uint n)
{
 56b:	55                   	push   %ebp
 56c:	89 e5                	mov    %esp,%ebp
 56e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 571:	8b 45 10             	mov    0x10(%ebp),%eax
 574:	89 44 24 08          	mov    %eax,0x8(%esp)
 578:	8b 45 0c             	mov    0xc(%ebp),%eax
 57b:	89 44 24 04          	mov    %eax,0x4(%esp)
 57f:	8b 45 08             	mov    0x8(%ebp),%eax
 582:	89 04 24             	mov    %eax,(%esp)
 585:	e8 d1 fd ff ff       	call   35b <stosb>
  return dst;
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 58d:	c9                   	leave  
 58e:	c3                   	ret    

0000058f <strchr>:

char*
strchr(const char *s, char c)
{
 58f:	55                   	push   %ebp
 590:	89 e5                	mov    %esp,%ebp
 592:	83 ec 04             	sub    $0x4,%esp
 595:	8b 45 0c             	mov    0xc(%ebp),%eax
 598:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 59b:	eb 14                	jmp    5b1 <strchr+0x22>
    if(*s == c)
 59d:	8b 45 08             	mov    0x8(%ebp),%eax
 5a0:	0f b6 00             	movzbl (%eax),%eax
 5a3:	3a 45 fc             	cmp    -0x4(%ebp),%al
 5a6:	75 05                	jne    5ad <strchr+0x1e>
      return (char*)s;
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	eb 13                	jmp    5c0 <strchr+0x31>
  for(; *s; s++)
 5ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 5b1:	8b 45 08             	mov    0x8(%ebp),%eax
 5b4:	0f b6 00             	movzbl (%eax),%eax
 5b7:	84 c0                	test   %al,%al
 5b9:	75 e2                	jne    59d <strchr+0xe>
  return 0;
 5bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 5c0:	c9                   	leave  
 5c1:	c3                   	ret    

000005c2 <gets>:

char*
gets(char *buf, int max)
{
 5c2:	55                   	push   %ebp
 5c3:	89 e5                	mov    %esp,%ebp
 5c5:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 5cf:	eb 4c                	jmp    61d <gets+0x5b>
    cc = read(0, &c, 1);
 5d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5d8:	00 
 5d9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 5dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5e7:	e8 44 01 00 00       	call   730 <read>
 5ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 5ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5f3:	7f 02                	jg     5f7 <gets+0x35>
      break;
 5f5:	eb 31                	jmp    628 <gets+0x66>
    buf[i++] = c;
 5f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fa:	8d 50 01             	lea    0x1(%eax),%edx
 5fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 600:	89 c2                	mov    %eax,%edx
 602:	8b 45 08             	mov    0x8(%ebp),%eax
 605:	01 c2                	add    %eax,%edx
 607:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 60b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 60d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 611:	3c 0a                	cmp    $0xa,%al
 613:	74 13                	je     628 <gets+0x66>
 615:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 619:	3c 0d                	cmp    $0xd,%al
 61b:	74 0b                	je     628 <gets+0x66>
  for(i=0; i+1 < max; ){
 61d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 620:	83 c0 01             	add    $0x1,%eax
 623:	3b 45 0c             	cmp    0xc(%ebp),%eax
 626:	7c a9                	jl     5d1 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 628:	8b 55 f4             	mov    -0xc(%ebp),%edx
 62b:	8b 45 08             	mov    0x8(%ebp),%eax
 62e:	01 d0                	add    %edx,%eax
 630:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 633:	8b 45 08             	mov    0x8(%ebp),%eax
}
 636:	c9                   	leave  
 637:	c3                   	ret    

00000638 <stat>:

int
stat(const char *n, struct stat *st)
{
 638:	55                   	push   %ebp
 639:	89 e5                	mov    %esp,%ebp
 63b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 63e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 645:	00 
 646:	8b 45 08             	mov    0x8(%ebp),%eax
 649:	89 04 24             	mov    %eax,(%esp)
 64c:	e8 07 01 00 00       	call   758 <open>
 651:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 654:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 658:	79 07                	jns    661 <stat+0x29>
    return -1;
 65a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 65f:	eb 23                	jmp    684 <stat+0x4c>
  r = fstat(fd, st);
 661:	8b 45 0c             	mov    0xc(%ebp),%eax
 664:	89 44 24 04          	mov    %eax,0x4(%esp)
 668:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66b:	89 04 24             	mov    %eax,(%esp)
 66e:	e8 fd 00 00 00       	call   770 <fstat>
 673:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 676:	8b 45 f4             	mov    -0xc(%ebp),%eax
 679:	89 04 24             	mov    %eax,(%esp)
 67c:	e8 bf 00 00 00       	call   740 <close>
  return r;
 681:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 684:	c9                   	leave  
 685:	c3                   	ret    

00000686 <atoi>:

int
atoi(const char *s)
{
 686:	55                   	push   %ebp
 687:	89 e5                	mov    %esp,%ebp
 689:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 68c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 693:	eb 25                	jmp    6ba <atoi+0x34>
    n = n*10 + *s++ - '0';
 695:	8b 55 fc             	mov    -0x4(%ebp),%edx
 698:	89 d0                	mov    %edx,%eax
 69a:	c1 e0 02             	shl    $0x2,%eax
 69d:	01 d0                	add    %edx,%eax
 69f:	01 c0                	add    %eax,%eax
 6a1:	89 c1                	mov    %eax,%ecx
 6a3:	8b 45 08             	mov    0x8(%ebp),%eax
 6a6:	8d 50 01             	lea    0x1(%eax),%edx
 6a9:	89 55 08             	mov    %edx,0x8(%ebp)
 6ac:	0f b6 00             	movzbl (%eax),%eax
 6af:	0f be c0             	movsbl %al,%eax
 6b2:	01 c8                	add    %ecx,%eax
 6b4:	83 e8 30             	sub    $0x30,%eax
 6b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6ba:	8b 45 08             	mov    0x8(%ebp),%eax
 6bd:	0f b6 00             	movzbl (%eax),%eax
 6c0:	3c 2f                	cmp    $0x2f,%al
 6c2:	7e 0a                	jle    6ce <atoi+0x48>
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
 6c7:	0f b6 00             	movzbl (%eax),%eax
 6ca:	3c 39                	cmp    $0x39,%al
 6cc:	7e c7                	jle    695 <atoi+0xf>
  return n;
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6d1:	c9                   	leave  
 6d2:	c3                   	ret    

000006d3 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6d3:	55                   	push   %ebp
 6d4:	89 e5                	mov    %esp,%ebp
 6d6:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
 6dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 6df:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 6e5:	eb 17                	jmp    6fe <memmove+0x2b>
    *dst++ = *src++;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8d 50 01             	lea    0x1(%eax),%edx
 6ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
 6f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f3:	8d 4a 01             	lea    0x1(%edx),%ecx
 6f6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 6f9:	0f b6 12             	movzbl (%edx),%edx
 6fc:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 6fe:	8b 45 10             	mov    0x10(%ebp),%eax
 701:	8d 50 ff             	lea    -0x1(%eax),%edx
 704:	89 55 10             	mov    %edx,0x10(%ebp)
 707:	85 c0                	test   %eax,%eax
 709:	7f dc                	jg     6e7 <memmove+0x14>
  return vdst;
 70b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 70e:	c9                   	leave  
 70f:	c3                   	ret    

00000710 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 710:	b8 01 00 00 00       	mov    $0x1,%eax
 715:	cd 40                	int    $0x40
 717:	c3                   	ret    

00000718 <exit>:
SYSCALL(exit)
 718:	b8 02 00 00 00       	mov    $0x2,%eax
 71d:	cd 40                	int    $0x40
 71f:	c3                   	ret    

00000720 <wait>:
SYSCALL(wait)
 720:	b8 03 00 00 00       	mov    $0x3,%eax
 725:	cd 40                	int    $0x40
 727:	c3                   	ret    

00000728 <pipe>:
SYSCALL(pipe)
 728:	b8 04 00 00 00       	mov    $0x4,%eax
 72d:	cd 40                	int    $0x40
 72f:	c3                   	ret    

00000730 <read>:
SYSCALL(read)
 730:	b8 05 00 00 00       	mov    $0x5,%eax
 735:	cd 40                	int    $0x40
 737:	c3                   	ret    

00000738 <write>:
SYSCALL(write)
 738:	b8 10 00 00 00       	mov    $0x10,%eax
 73d:	cd 40                	int    $0x40
 73f:	c3                   	ret    

00000740 <close>:
SYSCALL(close)
 740:	b8 15 00 00 00       	mov    $0x15,%eax
 745:	cd 40                	int    $0x40
 747:	c3                   	ret    

00000748 <kill>:
SYSCALL(kill)
 748:	b8 06 00 00 00       	mov    $0x6,%eax
 74d:	cd 40                	int    $0x40
 74f:	c3                   	ret    

00000750 <exec>:
SYSCALL(exec)
 750:	b8 07 00 00 00       	mov    $0x7,%eax
 755:	cd 40                	int    $0x40
 757:	c3                   	ret    

00000758 <open>:
SYSCALL(open)
 758:	b8 0f 00 00 00       	mov    $0xf,%eax
 75d:	cd 40                	int    $0x40
 75f:	c3                   	ret    

00000760 <mknod>:
SYSCALL(mknod)
 760:	b8 11 00 00 00       	mov    $0x11,%eax
 765:	cd 40                	int    $0x40
 767:	c3                   	ret    

00000768 <unlink>:
SYSCALL(unlink)
 768:	b8 12 00 00 00       	mov    $0x12,%eax
 76d:	cd 40                	int    $0x40
 76f:	c3                   	ret    

00000770 <fstat>:
SYSCALL(fstat)
 770:	b8 08 00 00 00       	mov    $0x8,%eax
 775:	cd 40                	int    $0x40
 777:	c3                   	ret    

00000778 <link>:
SYSCALL(link)
 778:	b8 13 00 00 00       	mov    $0x13,%eax
 77d:	cd 40                	int    $0x40
 77f:	c3                   	ret    

00000780 <mkdir>:
SYSCALL(mkdir)
 780:	b8 14 00 00 00       	mov    $0x14,%eax
 785:	cd 40                	int    $0x40
 787:	c3                   	ret    

00000788 <chdir>:
SYSCALL(chdir)
 788:	b8 09 00 00 00       	mov    $0x9,%eax
 78d:	cd 40                	int    $0x40
 78f:	c3                   	ret    

00000790 <dup>:
SYSCALL(dup)
 790:	b8 0a 00 00 00       	mov    $0xa,%eax
 795:	cd 40                	int    $0x40
 797:	c3                   	ret    

00000798 <getpid>:
SYSCALL(getpid)
 798:	b8 0b 00 00 00       	mov    $0xb,%eax
 79d:	cd 40                	int    $0x40
 79f:	c3                   	ret    

000007a0 <sbrk>:
SYSCALL(sbrk)
 7a0:	b8 0c 00 00 00       	mov    $0xc,%eax
 7a5:	cd 40                	int    $0x40
 7a7:	c3                   	ret    

000007a8 <sleep>:
SYSCALL(sleep)
 7a8:	b8 0d 00 00 00       	mov    $0xd,%eax
 7ad:	cd 40                	int    $0x40
 7af:	c3                   	ret    

000007b0 <uptime>:
SYSCALL(uptime)
 7b0:	b8 0e 00 00 00       	mov    $0xe,%eax
 7b5:	cd 40                	int    $0x40
 7b7:	c3                   	ret    

000007b8 <getpinfo>:
SYSCALL(getpinfo)
 7b8:	b8 16 00 00 00       	mov    $0x16,%eax
 7bd:	cd 40                	int    $0x40
 7bf:	c3                   	ret    

000007c0 <settickets>:
SYSCALL(settickets)
 7c0:	b8 17 00 00 00       	mov    $0x17,%eax
 7c5:	cd 40                	int    $0x40
 7c7:	c3                   	ret    

000007c8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7c8:	55                   	push   %ebp
 7c9:	89 e5                	mov    %esp,%ebp
 7cb:	83 ec 18             	sub    $0x18,%esp
 7ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 7d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7db:	00 
 7dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7df:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e3:	8b 45 08             	mov    0x8(%ebp),%eax
 7e6:	89 04 24             	mov    %eax,(%esp)
 7e9:	e8 4a ff ff ff       	call   738 <write>
}
 7ee:	c9                   	leave  
 7ef:	c3                   	ret    

000007f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7f0:	55                   	push   %ebp
 7f1:	89 e5                	mov    %esp,%ebp
 7f3:	56                   	push   %esi
 7f4:	53                   	push   %ebx
 7f5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7ff:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 803:	74 17                	je     81c <printint+0x2c>
 805:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 809:	79 11                	jns    81c <printint+0x2c>
    neg = 1;
 80b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 812:	8b 45 0c             	mov    0xc(%ebp),%eax
 815:	f7 d8                	neg    %eax
 817:	89 45 ec             	mov    %eax,-0x14(%ebp)
 81a:	eb 06                	jmp    822 <printint+0x32>
  } else {
    x = xx;
 81c:	8b 45 0c             	mov    0xc(%ebp),%eax
 81f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 822:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 829:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 82c:	8d 41 01             	lea    0x1(%ecx),%eax
 82f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 832:	8b 5d 10             	mov    0x10(%ebp),%ebx
 835:	8b 45 ec             	mov    -0x14(%ebp),%eax
 838:	ba 00 00 00 00       	mov    $0x0,%edx
 83d:	f7 f3                	div    %ebx
 83f:	89 d0                	mov    %edx,%eax
 841:	0f b6 80 d4 0f 00 00 	movzbl 0xfd4(%eax),%eax
 848:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 84c:	8b 75 10             	mov    0x10(%ebp),%esi
 84f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 852:	ba 00 00 00 00       	mov    $0x0,%edx
 857:	f7 f6                	div    %esi
 859:	89 45 ec             	mov    %eax,-0x14(%ebp)
 85c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 860:	75 c7                	jne    829 <printint+0x39>
  if(neg)
 862:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 866:	74 10                	je     878 <printint+0x88>
    buf[i++] = '-';
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	8d 50 01             	lea    0x1(%eax),%edx
 86e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 871:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 876:	eb 1f                	jmp    897 <printint+0xa7>
 878:	eb 1d                	jmp    897 <printint+0xa7>
    putc(fd, buf[i]);
 87a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	01 d0                	add    %edx,%eax
 882:	0f b6 00             	movzbl (%eax),%eax
 885:	0f be c0             	movsbl %al,%eax
 888:	89 44 24 04          	mov    %eax,0x4(%esp)
 88c:	8b 45 08             	mov    0x8(%ebp),%eax
 88f:	89 04 24             	mov    %eax,(%esp)
 892:	e8 31 ff ff ff       	call   7c8 <putc>
  while(--i >= 0)
 897:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 89b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 89f:	79 d9                	jns    87a <printint+0x8a>
}
 8a1:	83 c4 30             	add    $0x30,%esp
 8a4:	5b                   	pop    %ebx
 8a5:	5e                   	pop    %esi
 8a6:	5d                   	pop    %ebp
 8a7:	c3                   	ret    

000008a8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8a8:	55                   	push   %ebp
 8a9:	89 e5                	mov    %esp,%ebp
 8ab:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 8ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8b5:	8d 45 0c             	lea    0xc(%ebp),%eax
 8b8:	83 c0 04             	add    $0x4,%eax
 8bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8c5:	e9 7c 01 00 00       	jmp    a46 <printf+0x19e>
    c = fmt[i] & 0xff;
 8ca:	8b 55 0c             	mov    0xc(%ebp),%edx
 8cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d0:	01 d0                	add    %edx,%eax
 8d2:	0f b6 00             	movzbl (%eax),%eax
 8d5:	0f be c0             	movsbl %al,%eax
 8d8:	25 ff 00 00 00       	and    $0xff,%eax
 8dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8e4:	75 2c                	jne    912 <printf+0x6a>
      if(c == '%'){
 8e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8ea:	75 0c                	jne    8f8 <printf+0x50>
        state = '%';
 8ec:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8f3:	e9 4a 01 00 00       	jmp    a42 <printf+0x19a>
      } else {
        putc(fd, c);
 8f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8fb:	0f be c0             	movsbl %al,%eax
 8fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 902:	8b 45 08             	mov    0x8(%ebp),%eax
 905:	89 04 24             	mov    %eax,(%esp)
 908:	e8 bb fe ff ff       	call   7c8 <putc>
 90d:	e9 30 01 00 00       	jmp    a42 <printf+0x19a>
      }
    } else if(state == '%'){
 912:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 916:	0f 85 26 01 00 00    	jne    a42 <printf+0x19a>
      if(c == 'd'){
 91c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 920:	75 2d                	jne    94f <printf+0xa7>
        printint(fd, *ap, 10, 1);
 922:	8b 45 e8             	mov    -0x18(%ebp),%eax
 925:	8b 00                	mov    (%eax),%eax
 927:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 92e:	00 
 92f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 936:	00 
 937:	89 44 24 04          	mov    %eax,0x4(%esp)
 93b:	8b 45 08             	mov    0x8(%ebp),%eax
 93e:	89 04 24             	mov    %eax,(%esp)
 941:	e8 aa fe ff ff       	call   7f0 <printint>
        ap++;
 946:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 94a:	e9 ec 00 00 00       	jmp    a3b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 94f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 953:	74 06                	je     95b <printf+0xb3>
 955:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 959:	75 2d                	jne    988 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 95b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 95e:	8b 00                	mov    (%eax),%eax
 960:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 967:	00 
 968:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 96f:	00 
 970:	89 44 24 04          	mov    %eax,0x4(%esp)
 974:	8b 45 08             	mov    0x8(%ebp),%eax
 977:	89 04 24             	mov    %eax,(%esp)
 97a:	e8 71 fe ff ff       	call   7f0 <printint>
        ap++;
 97f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 983:	e9 b3 00 00 00       	jmp    a3b <printf+0x193>
      } else if(c == 's'){
 988:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 98c:	75 45                	jne    9d3 <printf+0x12b>
        s = (char*)*ap;
 98e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 991:	8b 00                	mov    (%eax),%eax
 993:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 996:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 99a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 99e:	75 09                	jne    9a9 <printf+0x101>
          s = "(null)";
 9a0:	c7 45 f4 04 0d 00 00 	movl   $0xd04,-0xc(%ebp)
        while(*s != 0){
 9a7:	eb 1e                	jmp    9c7 <printf+0x11f>
 9a9:	eb 1c                	jmp    9c7 <printf+0x11f>
          putc(fd, *s);
 9ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ae:	0f b6 00             	movzbl (%eax),%eax
 9b1:	0f be c0             	movsbl %al,%eax
 9b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 9b8:	8b 45 08             	mov    0x8(%ebp),%eax
 9bb:	89 04 24             	mov    %eax,(%esp)
 9be:	e8 05 fe ff ff       	call   7c8 <putc>
          s++;
 9c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 9c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ca:	0f b6 00             	movzbl (%eax),%eax
 9cd:	84 c0                	test   %al,%al
 9cf:	75 da                	jne    9ab <printf+0x103>
 9d1:	eb 68                	jmp    a3b <printf+0x193>
        }
      } else if(c == 'c'){
 9d3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 9d7:	75 1d                	jne    9f6 <printf+0x14e>
        putc(fd, *ap);
 9d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9dc:	8b 00                	mov    (%eax),%eax
 9de:	0f be c0             	movsbl %al,%eax
 9e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 9e5:	8b 45 08             	mov    0x8(%ebp),%eax
 9e8:	89 04 24             	mov    %eax,(%esp)
 9eb:	e8 d8 fd ff ff       	call   7c8 <putc>
        ap++;
 9f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9f4:	eb 45                	jmp    a3b <printf+0x193>
      } else if(c == '%'){
 9f6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9fa:	75 17                	jne    a13 <printf+0x16b>
        putc(fd, c);
 9fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9ff:	0f be c0             	movsbl %al,%eax
 a02:	89 44 24 04          	mov    %eax,0x4(%esp)
 a06:	8b 45 08             	mov    0x8(%ebp),%eax
 a09:	89 04 24             	mov    %eax,(%esp)
 a0c:	e8 b7 fd ff ff       	call   7c8 <putc>
 a11:	eb 28                	jmp    a3b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a13:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 a1a:	00 
 a1b:	8b 45 08             	mov    0x8(%ebp),%eax
 a1e:	89 04 24             	mov    %eax,(%esp)
 a21:	e8 a2 fd ff ff       	call   7c8 <putc>
        putc(fd, c);
 a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a29:	0f be c0             	movsbl %al,%eax
 a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
 a30:	8b 45 08             	mov    0x8(%ebp),%eax
 a33:	89 04 24             	mov    %eax,(%esp)
 a36:	e8 8d fd ff ff       	call   7c8 <putc>
      }
      state = 0;
 a3b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 a42:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a46:	8b 55 0c             	mov    0xc(%ebp),%edx
 a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4c:	01 d0                	add    %edx,%eax
 a4e:	0f b6 00             	movzbl (%eax),%eax
 a51:	84 c0                	test   %al,%al
 a53:	0f 85 71 fe ff ff    	jne    8ca <printf+0x22>
    }
  }
}
 a59:	c9                   	leave  
 a5a:	c3                   	ret    

00000a5b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a5b:	55                   	push   %ebp
 a5c:	89 e5                	mov    %esp,%ebp
 a5e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a61:	8b 45 08             	mov    0x8(%ebp),%eax
 a64:	83 e8 08             	sub    $0x8,%eax
 a67:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a6a:	a1 00 10 00 00       	mov    0x1000,%eax
 a6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a72:	eb 24                	jmp    a98 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a74:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a77:	8b 00                	mov    (%eax),%eax
 a79:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a7c:	77 12                	ja     a90 <free+0x35>
 a7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a81:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a84:	77 24                	ja     aaa <free+0x4f>
 a86:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a89:	8b 00                	mov    (%eax),%eax
 a8b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a8e:	77 1a                	ja     aaa <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a90:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a93:	8b 00                	mov    (%eax),%eax
 a95:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a98:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a9b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a9e:	76 d4                	jbe    a74 <free+0x19>
 aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa3:	8b 00                	mov    (%eax),%eax
 aa5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 aa8:	76 ca                	jbe    a74 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 aaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aad:	8b 40 04             	mov    0x4(%eax),%eax
 ab0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ab7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aba:	01 c2                	add    %eax,%edx
 abc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 abf:	8b 00                	mov    (%eax),%eax
 ac1:	39 c2                	cmp    %eax,%edx
 ac3:	75 24                	jne    ae9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 ac5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac8:	8b 50 04             	mov    0x4(%eax),%edx
 acb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ace:	8b 00                	mov    (%eax),%eax
 ad0:	8b 40 04             	mov    0x4(%eax),%eax
 ad3:	01 c2                	add    %eax,%edx
 ad5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 adb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ade:	8b 00                	mov    (%eax),%eax
 ae0:	8b 10                	mov    (%eax),%edx
 ae2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae5:	89 10                	mov    %edx,(%eax)
 ae7:	eb 0a                	jmp    af3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aec:	8b 10                	mov    (%eax),%edx
 aee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 af1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 af3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af6:	8b 40 04             	mov    0x4(%eax),%eax
 af9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b03:	01 d0                	add    %edx,%eax
 b05:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b08:	75 20                	jne    b2a <free+0xcf>
    p->s.size += bp->s.size;
 b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b0d:	8b 50 04             	mov    0x4(%eax),%edx
 b10:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b13:	8b 40 04             	mov    0x4(%eax),%eax
 b16:	01 c2                	add    %eax,%edx
 b18:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b1b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b21:	8b 10                	mov    (%eax),%edx
 b23:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b26:	89 10                	mov    %edx,(%eax)
 b28:	eb 08                	jmp    b32 <free+0xd7>
  } else
    p->s.ptr = bp;
 b2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b2d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b30:	89 10                	mov    %edx,(%eax)
  freep = p;
 b32:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b35:	a3 00 10 00 00       	mov    %eax,0x1000
}
 b3a:	c9                   	leave  
 b3b:	c3                   	ret    

00000b3c <morecore>:

static Header*
morecore(uint nu)
{
 b3c:	55                   	push   %ebp
 b3d:	89 e5                	mov    %esp,%ebp
 b3f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b42:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b49:	77 07                	ja     b52 <morecore+0x16>
    nu = 4096;
 b4b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b52:	8b 45 08             	mov    0x8(%ebp),%eax
 b55:	c1 e0 03             	shl    $0x3,%eax
 b58:	89 04 24             	mov    %eax,(%esp)
 b5b:	e8 40 fc ff ff       	call   7a0 <sbrk>
 b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b63:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b67:	75 07                	jne    b70 <morecore+0x34>
    return 0;
 b69:	b8 00 00 00 00       	mov    $0x0,%eax
 b6e:	eb 22                	jmp    b92 <morecore+0x56>
  hp = (Header*)p;
 b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b79:	8b 55 08             	mov    0x8(%ebp),%edx
 b7c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b82:	83 c0 08             	add    $0x8,%eax
 b85:	89 04 24             	mov    %eax,(%esp)
 b88:	e8 ce fe ff ff       	call   a5b <free>
  return freep;
 b8d:	a1 00 10 00 00       	mov    0x1000,%eax
}
 b92:	c9                   	leave  
 b93:	c3                   	ret    

00000b94 <malloc>:

void*
malloc(uint nbytes)
{
 b94:	55                   	push   %ebp
 b95:	89 e5                	mov    %esp,%ebp
 b97:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b9a:	8b 45 08             	mov    0x8(%ebp),%eax
 b9d:	83 c0 07             	add    $0x7,%eax
 ba0:	c1 e8 03             	shr    $0x3,%eax
 ba3:	83 c0 01             	add    $0x1,%eax
 ba6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ba9:	a1 00 10 00 00       	mov    0x1000,%eax
 bae:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 bb5:	75 23                	jne    bda <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 bb7:	c7 45 f0 f8 0f 00 00 	movl   $0xff8,-0x10(%ebp)
 bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc1:	a3 00 10 00 00       	mov    %eax,0x1000
 bc6:	a1 00 10 00 00       	mov    0x1000,%eax
 bcb:	a3 f8 0f 00 00       	mov    %eax,0xff8
    base.s.size = 0;
 bd0:	c7 05 fc 0f 00 00 00 	movl   $0x0,0xffc
 bd7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bdd:	8b 00                	mov    (%eax),%eax
 bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be5:	8b 40 04             	mov    0x4(%eax),%eax
 be8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 beb:	72 4d                	jb     c3a <malloc+0xa6>
      if(p->s.size == nunits)
 bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf0:	8b 40 04             	mov    0x4(%eax),%eax
 bf3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bf6:	75 0c                	jne    c04 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bfb:	8b 10                	mov    (%eax),%edx
 bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c00:	89 10                	mov    %edx,(%eax)
 c02:	eb 26                	jmp    c2a <malloc+0x96>
      else {
        p->s.size -= nunits;
 c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c07:	8b 40 04             	mov    0x4(%eax),%eax
 c0a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c0d:	89 c2                	mov    %eax,%edx
 c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c12:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c18:	8b 40 04             	mov    0x4(%eax),%eax
 c1b:	c1 e0 03             	shl    $0x3,%eax
 c1e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c24:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c27:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c2d:	a3 00 10 00 00       	mov    %eax,0x1000
      return (void*)(p + 1);
 c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c35:	83 c0 08             	add    $0x8,%eax
 c38:	eb 38                	jmp    c72 <malloc+0xde>
    }
    if(p == freep)
 c3a:	a1 00 10 00 00       	mov    0x1000,%eax
 c3f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c42:	75 1b                	jne    c5f <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c47:	89 04 24             	mov    %eax,(%esp)
 c4a:	e8 ed fe ff ff       	call   b3c <morecore>
 c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c56:	75 07                	jne    c5f <malloc+0xcb>
        return 0;
 c58:	b8 00 00 00 00       	mov    $0x0,%eax
 c5d:	eb 13                	jmp    c72 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c62:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c68:	8b 00                	mov    (%eax),%eax
 c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 c6d:	e9 70 ff ff ff       	jmp    be2 <malloc+0x4e>
}
 c72:	c9                   	leave  
 c73:	c3                   	ret    
