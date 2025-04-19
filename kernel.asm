
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 74 37 10 80       	mov    $0x80103774,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 9c 84 10 	movl   $0x8010849c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 50 4f 00 00       	call   80104f9e <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 ac 0d 11 80 5c 	movl   $0x80110d5c,0x80110dac
80100055:	0d 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 b0 0d 11 80 5c 	movl   $0x80110d5c,0x80110db0
8010005f:	0d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 46                	jmp    801000b1 <binit+0x7d>
    b->next = bcache.head.next;
8010006b:	8b 15 b0 0d 11 80    	mov    0x80110db0,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 50 5c 0d 11 80 	movl   $0x80110d5c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	83 c0 0c             	add    $0xc,%eax
80100087:	c7 44 24 04 a3 84 10 	movl   $0x801084a3,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 a4 4d 00 00       	call   80104e3b <initsleeplock>
    bcache.head.next->prev = b;
80100097:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
8010009c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010009f:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a5:	a3 b0 0d 11 80       	mov    %eax,0x80110db0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b1:	81 7d f4 5c 0d 11 80 	cmpl   $0x80110d5c,-0xc(%ebp)
801000b8:	72 b1                	jb     8010006b <binit+0x37>
  }
}
801000ba:	c9                   	leave  
801000bb:	c3                   	ret    

801000bc <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000bc:	55                   	push   %ebp
801000bd:	89 e5                	mov    %esp,%ebp
801000bf:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c2:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000c9:	e8 f1 4e 00 00       	call   80104fbf <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ce:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
801000d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d6:	eb 50                	jmp    80100128 <bget+0x6c>
    if(b->dev == dev && b->blockno == blockno){
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 04             	mov    0x4(%eax),%eax
801000de:	3b 45 08             	cmp    0x8(%ebp),%eax
801000e1:	75 3c                	jne    8010011f <bget+0x63>
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 40 08             	mov    0x8(%eax),%eax
801000e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000ec:	75 31                	jne    8010011f <bget+0x63>
      b->refcnt++;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 40 4c             	mov    0x4c(%eax),%eax
801000f4:	8d 50 01             	lea    0x1(%eax),%edx
801000f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fa:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
801000fd:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100104:	e8 1e 4f 00 00       	call   80105027 <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 5e 4d 00 00       	call   80104e75 <acquiresleep>
      return b;
80100117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011a:	e9 94 00 00 00       	jmp    801001b3 <bget+0xf7>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100122:	8b 40 54             	mov    0x54(%eax),%eax
80100125:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100128:	81 7d f4 5c 0d 11 80 	cmpl   $0x80110d5c,-0xc(%ebp)
8010012f:	75 a7                	jne    801000d8 <bget+0x1c>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100131:	a1 ac 0d 11 80       	mov    0x80110dac,%eax
80100136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100139:	eb 63                	jmp    8010019e <bget+0xe2>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100141:	85 c0                	test   %eax,%eax
80100143:	75 50                	jne    80100195 <bget+0xd9>
80100145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100148:	8b 00                	mov    (%eax),%eax
8010014a:	83 e0 04             	and    $0x4,%eax
8010014d:	85 c0                	test   %eax,%eax
8010014f:	75 44                	jne    80100195 <bget+0xd9>
      b->dev = dev;
80100151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100154:	8b 55 08             	mov    0x8(%ebp),%edx
80100157:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100160:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017d:	e8 a5 4e 00 00       	call   80105027 <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 e5 4c 00 00       	call   80104e75 <acquiresleep>
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1e                	jmp    801001b3 <bget+0xf7>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 50             	mov    0x50(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 5c 0d 11 80 	cmpl   $0x80110d5c,-0xc(%ebp)
801001a5:	75 94                	jne    8010013b <bget+0x7f>
    }
  }
  panic("bget: no buffers");
801001a7:	c7 04 24 aa 84 10 80 	movl   $0x801084aa,(%esp)
801001ae:	e8 af 03 00 00       	call   80100562 <panic>
}
801001b3:	c9                   	leave  
801001b4:	c3                   	ret    

801001b5 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b5:	55                   	push   %ebp
801001b6:	89 e5                	mov    %esp,%ebp
801001b8:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801001be:	89 44 24 04          	mov    %eax,0x4(%esp)
801001c2:	8b 45 08             	mov    0x8(%ebp),%eax
801001c5:	89 04 24             	mov    %eax,(%esp)
801001c8:	e8 ef fe ff ff       	call   801000bc <bget>
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0b                	jne    801001e7 <bread+0x32>
    iderw(b);
801001dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001df:	89 04 24             	mov    %eax,(%esp)
801001e2:	e8 a4 26 00 00       	call   8010288b <iderw>
  }
  return b;
801001e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ea:	c9                   	leave  
801001eb:	c3                   	ret    

801001ec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001ec:	55                   	push   %ebp
801001ed:	89 e5                	mov    %esp,%ebp
801001ef:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
801001f2:	8b 45 08             	mov    0x8(%ebp),%eax
801001f5:	83 c0 0c             	add    $0xc,%eax
801001f8:	89 04 24             	mov    %eax,(%esp)
801001fb:	e8 12 4d 00 00       	call   80104f12 <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 bb 84 10 80 	movl   $0x801084bb,(%esp)
8010020b:	e8 52 03 00 00       	call   80100562 <panic>
  b->flags |= B_DIRTY;
80100210:	8b 45 08             	mov    0x8(%ebp),%eax
80100213:	8b 00                	mov    (%eax),%eax
80100215:	83 c8 04             	or     $0x4,%eax
80100218:	89 c2                	mov    %eax,%edx
8010021a:	8b 45 08             	mov    0x8(%ebp),%eax
8010021d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021f:	8b 45 08             	mov    0x8(%ebp),%eax
80100222:	89 04 24             	mov    %eax,(%esp)
80100225:	e8 61 26 00 00       	call   8010288b <iderw>
}
8010022a:	c9                   	leave  
8010022b:	c3                   	ret    

8010022c <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022c:	55                   	push   %ebp
8010022d:	89 e5                	mov    %esp,%ebp
8010022f:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
80100232:	8b 45 08             	mov    0x8(%ebp),%eax
80100235:	83 c0 0c             	add    $0xc,%eax
80100238:	89 04 24             	mov    %eax,(%esp)
8010023b:	e8 d2 4c 00 00       	call   80104f12 <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 c2 84 10 80 	movl   $0x801084c2,(%esp)
8010024b:	e8 12 03 00 00       	call   80100562 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 72 4c 00 00       	call   80104ed0 <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100265:	e8 55 4d 00 00       	call   80104fbf <acquire>
  b->refcnt--;
8010026a:	8b 45 08             	mov    0x8(%ebp),%eax
8010026d:	8b 40 4c             	mov    0x4c(%eax),%eax
80100270:	8d 50 ff             	lea    -0x1(%eax),%edx
80100273:	8b 45 08             	mov    0x8(%ebp),%eax
80100276:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010027f:	85 c0                	test   %eax,%eax
80100281:	75 47                	jne    801002ca <brelse+0x9e>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100283:	8b 45 08             	mov    0x8(%ebp),%eax
80100286:	8b 40 54             	mov    0x54(%eax),%eax
80100289:	8b 55 08             	mov    0x8(%ebp),%edx
8010028c:	8b 52 50             	mov    0x50(%edx),%edx
8010028f:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	8b 40 50             	mov    0x50(%eax),%eax
80100298:	8b 55 08             	mov    0x8(%ebp),%edx
8010029b:	8b 52 54             	mov    0x54(%edx),%edx
8010029e:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002a1:	8b 15 b0 0d 11 80    	mov    0x80110db0,%edx
801002a7:	8b 45 08             	mov    0x8(%ebp),%eax
801002aa:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002ad:	8b 45 08             	mov    0x8(%ebp),%eax
801002b0:	c7 40 50 5c 0d 11 80 	movl   $0x80110d5c,0x50(%eax)
    bcache.head.next->prev = b;
801002b7:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
801002bc:	8b 55 08             	mov    0x8(%ebp),%edx
801002bf:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002c2:	8b 45 08             	mov    0x8(%ebp),%eax
801002c5:	a3 b0 0d 11 80       	mov    %eax,0x80110db0
  }
  
  release(&bcache.lock);
801002ca:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002d1:	e8 51 4d 00 00       	call   80105027 <release>
}
801002d6:	c9                   	leave  
801002d7:	c3                   	ret    

801002d8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d8:	55                   	push   %ebp
801002d9:	89 e5                	mov    %esp,%ebp
801002db:	83 ec 14             	sub    $0x14,%esp
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e9:	89 c2                	mov    %eax,%edx
801002eb:	ec                   	in     (%dx),%al
801002ec:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002ef:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002f3:	c9                   	leave  
801002f4:	c3                   	ret    

801002f5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f5:	55                   	push   %ebp
801002f6:	89 e5                	mov    %esp,%ebp
801002f8:	83 ec 08             	sub    $0x8,%esp
801002fb:	8b 55 08             	mov    0x8(%ebp),%edx
801002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100301:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100305:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100308:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010030c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100310:	ee                   	out    %al,(%dx)
}
80100311:	c9                   	leave  
80100312:	c3                   	ret    

80100313 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100313:	55                   	push   %ebp
80100314:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100316:	fa                   	cli    
}
80100317:	5d                   	pop    %ebp
80100318:	c3                   	ret    

80100319 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100319:	55                   	push   %ebp
8010031a:	89 e5                	mov    %esp,%ebp
8010031c:	56                   	push   %esi
8010031d:	53                   	push   %ebx
8010031e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100321:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100325:	74 1c                	je     80100343 <printint+0x2a>
80100327:	8b 45 08             	mov    0x8(%ebp),%eax
8010032a:	c1 e8 1f             	shr    $0x1f,%eax
8010032d:	0f b6 c0             	movzbl %al,%eax
80100330:	89 45 10             	mov    %eax,0x10(%ebp)
80100333:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100337:	74 0a                	je     80100343 <printint+0x2a>
    x = -xx;
80100339:	8b 45 08             	mov    0x8(%ebp),%eax
8010033c:	f7 d8                	neg    %eax
8010033e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100341:	eb 06                	jmp    80100349 <printint+0x30>
  else
    x = xx;
80100343:	8b 45 08             	mov    0x8(%ebp),%eax
80100346:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100349:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100350:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100353:	8d 41 01             	lea    0x1(%ecx),%eax
80100356:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100359:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010035c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035f:	ba 00 00 00 00       	mov    $0x0,%edx
80100364:	f7 f3                	div    %ebx
80100366:	89 d0                	mov    %edx,%eax
80100368:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
8010036f:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100373:	8b 75 0c             	mov    0xc(%ebp),%esi
80100376:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100379:	ba 00 00 00 00       	mov    $0x0,%edx
8010037e:	f7 f6                	div    %esi
80100380:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100387:	75 c7                	jne    80100350 <printint+0x37>

  if(sign)
80100389:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038d:	74 10                	je     8010039f <printint+0x86>
    buf[i++] = '-';
8010038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100392:	8d 50 01             	lea    0x1(%eax),%edx
80100395:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100398:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039d:	eb 18                	jmp    801003b7 <printint+0x9e>
8010039f:	eb 16                	jmp    801003b7 <printint+0x9e>
    consputc(buf[i]);
801003a1:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a7:	01 d0                	add    %edx,%eax
801003a9:	0f b6 00             	movzbl (%eax),%eax
801003ac:	0f be c0             	movsbl %al,%eax
801003af:	89 04 24             	mov    %eax,(%esp)
801003b2:	e8 d5 03 00 00       	call   8010078c <consputc>
  while(--i >= 0)
801003b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003bf:	79 e0                	jns    801003a1 <printint+0x88>
}
801003c1:	83 c4 30             	add    $0x30,%esp
801003c4:	5b                   	pop    %ebx
801003c5:	5e                   	pop    %esi
801003c6:	5d                   	pop    %ebp
801003c7:	c3                   	ret    

801003c8 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c8:	55                   	push   %ebp
801003c9:	89 e5                	mov    %esp,%ebp
801003cb:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003ce:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003da:	74 0c                	je     801003e8 <cprintf+0x20>
    acquire(&cons.lock);
801003dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003e3:	e8 d7 4b 00 00       	call   80104fbf <acquire>

  if (fmt == 0)
801003e8:	8b 45 08             	mov    0x8(%ebp),%eax
801003eb:	85 c0                	test   %eax,%eax
801003ed:	75 0c                	jne    801003fb <cprintf+0x33>
    panic("null fmt");
801003ef:	c7 04 24 c9 84 10 80 	movl   $0x801084c9,(%esp)
801003f6:	e8 67 01 00 00       	call   80100562 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fb:	8d 45 0c             	lea    0xc(%ebp),%eax
801003fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100408:	e9 21 01 00 00       	jmp    8010052e <cprintf+0x166>
    if(c != '%'){
8010040d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100411:	74 10                	je     80100423 <cprintf+0x5b>
      consputc(c);
80100413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100416:	89 04 24             	mov    %eax,(%esp)
80100419:	e8 6e 03 00 00       	call   8010078c <consputc>
      continue;
8010041e:	e9 07 01 00 00       	jmp    8010052a <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
80100423:	8b 55 08             	mov    0x8(%ebp),%edx
80100426:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010042a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010042d:	01 d0                	add    %edx,%eax
8010042f:	0f b6 00             	movzbl (%eax),%eax
80100432:	0f be c0             	movsbl %al,%eax
80100435:	25 ff 00 00 00       	and    $0xff,%eax
8010043a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010043d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100441:	75 05                	jne    80100448 <cprintf+0x80>
      break;
80100443:	e9 06 01 00 00       	jmp    8010054e <cprintf+0x186>
    switch(c){
80100448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044b:	83 f8 70             	cmp    $0x70,%eax
8010044e:	74 4f                	je     8010049f <cprintf+0xd7>
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	7f 13                	jg     80100468 <cprintf+0xa0>
80100455:	83 f8 25             	cmp    $0x25,%eax
80100458:	0f 84 a6 00 00 00    	je     80100504 <cprintf+0x13c>
8010045e:	83 f8 64             	cmp    $0x64,%eax
80100461:	74 14                	je     80100477 <cprintf+0xaf>
80100463:	e9 aa 00 00 00       	jmp    80100512 <cprintf+0x14a>
80100468:	83 f8 73             	cmp    $0x73,%eax
8010046b:	74 57                	je     801004c4 <cprintf+0xfc>
8010046d:	83 f8 78             	cmp    $0x78,%eax
80100470:	74 2d                	je     8010049f <cprintf+0xd7>
80100472:	e9 9b 00 00 00       	jmp    80100512 <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 7f fe ff ff       	call   80100319 <printint>
      break;
8010049a:	e9 8b 00 00 00       	jmp    8010052a <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004a2:	8d 50 04             	lea    0x4(%eax),%edx
801004a5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a8:	8b 00                	mov    (%eax),%eax
801004aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801004b1:	00 
801004b2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801004b9:	00 
801004ba:	89 04 24             	mov    %eax,(%esp)
801004bd:	e8 57 fe ff ff       	call   80100319 <printint>
      break;
801004c2:	eb 66                	jmp    8010052a <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
801004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c7:	8d 50 04             	lea    0x4(%eax),%edx
801004ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004cd:	8b 00                	mov    (%eax),%eax
801004cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004d6:	75 09                	jne    801004e1 <cprintf+0x119>
        s = "(null)";
801004d8:	c7 45 ec d2 84 10 80 	movl   $0x801084d2,-0x14(%ebp)
      for(; *s; s++)
801004df:	eb 17                	jmp    801004f8 <cprintf+0x130>
801004e1:	eb 15                	jmp    801004f8 <cprintf+0x130>
        consputc(*s);
801004e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004e6:	0f b6 00             	movzbl (%eax),%eax
801004e9:	0f be c0             	movsbl %al,%eax
801004ec:	89 04 24             	mov    %eax,(%esp)
801004ef:	e8 98 02 00 00       	call   8010078c <consputc>
      for(; *s; s++)
801004f4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004fb:	0f b6 00             	movzbl (%eax),%eax
801004fe:	84 c0                	test   %al,%al
80100500:	75 e1                	jne    801004e3 <cprintf+0x11b>
      break;
80100502:	eb 26                	jmp    8010052a <cprintf+0x162>
    case '%':
      consputc('%');
80100504:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
8010050b:	e8 7c 02 00 00       	call   8010078c <consputc>
      break;
80100510:	eb 18                	jmp    8010052a <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100512:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
80100519:	e8 6e 02 00 00       	call   8010078c <consputc>
      consputc(c);
8010051e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100521:	89 04 24             	mov    %eax,(%esp)
80100524:	e8 63 02 00 00       	call   8010078c <consputc>
      break;
80100529:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010052a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052e:	8b 55 08             	mov    0x8(%ebp),%edx
80100531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100534:	01 d0                	add    %edx,%eax
80100536:	0f b6 00             	movzbl (%eax),%eax
80100539:	0f be c0             	movsbl %al,%eax
8010053c:	25 ff 00 00 00       	and    $0xff,%eax
80100541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100544:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100548:	0f 85 bf fe ff ff    	jne    8010040d <cprintf+0x45>
    }
  }

  if(locking)
8010054e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100552:	74 0c                	je     80100560 <cprintf+0x198>
    release(&cons.lock);
80100554:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010055b:	e8 c7 4a 00 00       	call   80105027 <release>
}
80100560:	c9                   	leave  
80100561:	c3                   	ret    

80100562 <panic>:

void
panic(char *s)
{
80100562:	55                   	push   %ebp
80100563:	89 e5                	mov    %esp,%ebp
80100565:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];

  cli();
80100568:	e8 a6 fd ff ff       	call   80100313 <cli>
  cons.locking = 0;
8010056d:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
80100574:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100577:	e8 b3 29 00 00       	call   80102f2f <lapicid>
8010057c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100580:	c7 04 24 d9 84 10 80 	movl   $0x801084d9,(%esp)
80100587:	e8 3c fe ff ff       	call   801003c8 <cprintf>
  cprintf(s);
8010058c:	8b 45 08             	mov    0x8(%ebp),%eax
8010058f:	89 04 24             	mov    %eax,(%esp)
80100592:	e8 31 fe ff ff       	call   801003c8 <cprintf>
  cprintf("\n");
80100597:	c7 04 24 ed 84 10 80 	movl   $0x801084ed,(%esp)
8010059e:	e8 25 fe ff ff       	call   801003c8 <cprintf>
  getcallerpcs(&s, pcs);
801005a3:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801005aa:	8d 45 08             	lea    0x8(%ebp),%eax
801005ad:	89 04 24             	mov    %eax,(%esp)
801005b0:	e8 bd 4a 00 00       	call   80105072 <getcallerpcs>
  for(i=0; i<10; i++)
801005b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005bc:	eb 1b                	jmp    801005d9 <panic+0x77>
    cprintf(" %p", pcs[i]);
801005be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005c1:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801005c9:	c7 04 24 ef 84 10 80 	movl   $0x801084ef,(%esp)
801005d0:	e8 f3 fd ff ff       	call   801003c8 <cprintf>
  for(i=0; i<10; i++)
801005d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005d9:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005dd:	7e df                	jle    801005be <panic+0x5c>
  panicked = 1; // freeze other CPU
801005df:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005e6:	00 00 00 
  for(;;)
    ;
801005e9:	eb fe                	jmp    801005e9 <panic+0x87>

801005eb <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005eb:	55                   	push   %ebp
801005ec:	89 e5                	mov    %esp,%ebp
801005ee:	83 ec 28             	sub    $0x28,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005f1:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005f8:	00 
801005f9:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100600:	e8 f0 fc ff ff       	call   801002f5 <outb>
  pos = inb(CRTPORT+1) << 8;
80100605:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010060c:	e8 c7 fc ff ff       	call   801002d8 <inb>
80100611:	0f b6 c0             	movzbl %al,%eax
80100614:	c1 e0 08             	shl    $0x8,%eax
80100617:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010061a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100621:	00 
80100622:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100629:	e8 c7 fc ff ff       	call   801002f5 <outb>
  pos |= inb(CRTPORT+1);
8010062e:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100635:	e8 9e fc ff ff       	call   801002d8 <inb>
8010063a:	0f b6 c0             	movzbl %al,%eax
8010063d:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100640:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100644:	75 30                	jne    80100676 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100646:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100649:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010064e:	89 c8                	mov    %ecx,%eax
80100650:	f7 ea                	imul   %edx
80100652:	c1 fa 05             	sar    $0x5,%edx
80100655:	89 c8                	mov    %ecx,%eax
80100657:	c1 f8 1f             	sar    $0x1f,%eax
8010065a:	29 c2                	sub    %eax,%edx
8010065c:	89 d0                	mov    %edx,%eax
8010065e:	c1 e0 02             	shl    $0x2,%eax
80100661:	01 d0                	add    %edx,%eax
80100663:	c1 e0 04             	shl    $0x4,%eax
80100666:	29 c1                	sub    %eax,%ecx
80100668:	89 ca                	mov    %ecx,%edx
8010066a:	b8 50 00 00 00       	mov    $0x50,%eax
8010066f:	29 d0                	sub    %edx,%eax
80100671:	01 45 f4             	add    %eax,-0xc(%ebp)
80100674:	eb 35                	jmp    801006ab <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100676:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010067d:	75 0c                	jne    8010068b <cgaputc+0xa0>
    if(pos > 0) --pos;
8010067f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100683:	7e 26                	jle    801006ab <cgaputc+0xc0>
80100685:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100689:	eb 20                	jmp    801006ab <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010068b:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100694:	8d 50 01             	lea    0x1(%eax),%edx
80100697:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010069a:	01 c0                	add    %eax,%eax
8010069c:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010069f:	8b 45 08             	mov    0x8(%ebp),%eax
801006a2:	0f b6 c0             	movzbl %al,%eax
801006a5:	80 cc 07             	or     $0x7,%ah
801006a8:	66 89 02             	mov    %ax,(%edx)

  if(pos < 0 || pos > 25*80)
801006ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006af:	78 09                	js     801006ba <cgaputc+0xcf>
801006b1:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006b8:	7e 0c                	jle    801006c6 <cgaputc+0xdb>
    panic("pos under/overflow");
801006ba:	c7 04 24 f3 84 10 80 	movl   $0x801084f3,(%esp)
801006c1:	e8 9c fe ff ff       	call   80100562 <panic>

  if((pos/80) >= 24){  // Scroll up.
801006c6:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006cd:	7e 53                	jle    80100722 <cgaputc+0x137>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006cf:	a1 00 90 10 80       	mov    0x80109000,%eax
801006d4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006da:	a1 00 90 10 80       	mov    0x80109000,%eax
801006df:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006e6:	00 
801006e7:	89 54 24 04          	mov    %edx,0x4(%esp)
801006eb:	89 04 24             	mov    %eax,(%esp)
801006ee:	e8 0d 4c 00 00       	call   80105300 <memmove>
    pos -= 80;
801006f3:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006f7:	b8 80 07 00 00       	mov    $0x780,%eax
801006fc:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006ff:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100702:	a1 00 90 10 80       	mov    0x80109000,%eax
80100707:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010070a:	01 c9                	add    %ecx,%ecx
8010070c:	01 c8                	add    %ecx,%eax
8010070e:	89 54 24 08          	mov    %edx,0x8(%esp)
80100712:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100719:	00 
8010071a:	89 04 24             	mov    %eax,(%esp)
8010071d:	e8 0f 4b 00 00       	call   80105231 <memset>
  }

  outb(CRTPORT, 14);
80100722:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100729:	00 
8010072a:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100731:	e8 bf fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT+1, pos>>8);
80100736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100739:	c1 f8 08             	sar    $0x8,%eax
8010073c:	0f b6 c0             	movzbl %al,%eax
8010073f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100743:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010074a:	e8 a6 fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT, 15);
8010074f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100756:	00 
80100757:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010075e:	e8 92 fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT+1, pos);
80100763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100766:	0f b6 c0             	movzbl %al,%eax
80100769:	89 44 24 04          	mov    %eax,0x4(%esp)
8010076d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100774:	e8 7c fb ff ff       	call   801002f5 <outb>
  crt[pos] = ' ' | 0x0700;
80100779:	a1 00 90 10 80       	mov    0x80109000,%eax
8010077e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100781:	01 d2                	add    %edx,%edx
80100783:	01 d0                	add    %edx,%eax
80100785:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078a:	c9                   	leave  
8010078b:	c3                   	ret    

8010078c <consputc>:

void
consputc(int c)
{
8010078c:	55                   	push   %ebp
8010078d:	89 e5                	mov    %esp,%ebp
8010078f:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100792:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
80100797:	85 c0                	test   %eax,%eax
80100799:	74 07                	je     801007a2 <consputc+0x16>
    cli();
8010079b:	e8 73 fb ff ff       	call   80100313 <cli>
    for(;;)
      ;
801007a0:	eb fe                	jmp    801007a0 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a2:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007a9:	75 26                	jne    801007d1 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007ab:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007b2:	e8 31 64 00 00       	call   80106be8 <uartputc>
801007b7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801007be:	e8 25 64 00 00       	call   80106be8 <uartputc>
801007c3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007ca:	e8 19 64 00 00       	call   80106be8 <uartputc>
801007cf:	eb 0b                	jmp    801007dc <consputc+0x50>
  } else
    uartputc(c);
801007d1:	8b 45 08             	mov    0x8(%ebp),%eax
801007d4:	89 04 24             	mov    %eax,(%esp)
801007d7:	e8 0c 64 00 00       	call   80106be8 <uartputc>
  cgaputc(c);
801007dc:	8b 45 08             	mov    0x8(%ebp),%eax
801007df:	89 04 24             	mov    %eax,(%esp)
801007e2:	e8 04 fe ff ff       	call   801005eb <cgaputc>
}
801007e7:	c9                   	leave  
801007e8:	c3                   	ret    

801007e9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007e9:	55                   	push   %ebp
801007ea:	89 e5                	mov    %esp,%ebp
801007ec:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007f6:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801007fd:	e8 bd 47 00 00       	call   80104fbf <acquire>
  while((c = getc()) >= 0){
80100802:	e9 39 01 00 00       	jmp    80100940 <consoleintr+0x157>
    switch(c){
80100807:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010080a:	83 f8 10             	cmp    $0x10,%eax
8010080d:	74 1e                	je     8010082d <consoleintr+0x44>
8010080f:	83 f8 10             	cmp    $0x10,%eax
80100812:	7f 0a                	jg     8010081e <consoleintr+0x35>
80100814:	83 f8 08             	cmp    $0x8,%eax
80100817:	74 66                	je     8010087f <consoleintr+0x96>
80100819:	e9 93 00 00 00       	jmp    801008b1 <consoleintr+0xc8>
8010081e:	83 f8 15             	cmp    $0x15,%eax
80100821:	74 31                	je     80100854 <consoleintr+0x6b>
80100823:	83 f8 7f             	cmp    $0x7f,%eax
80100826:	74 57                	je     8010087f <consoleintr+0x96>
80100828:	e9 84 00 00 00       	jmp    801008b1 <consoleintr+0xc8>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
8010082d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100834:	e9 07 01 00 00       	jmp    80100940 <consoleintr+0x157>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100839:	a1 48 10 11 80       	mov    0x80111048,%eax
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 48 10 11 80       	mov    %eax,0x80111048
        consputc(BACKSPACE);
80100846:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010084d:	e8 3a ff ff ff       	call   8010078c <consputc>
80100852:	eb 01                	jmp    80100855 <consoleintr+0x6c>
      while(input.e != input.w &&
80100854:	90                   	nop
80100855:	8b 15 48 10 11 80    	mov    0x80111048,%edx
8010085b:	a1 44 10 11 80       	mov    0x80111044,%eax
80100860:	39 c2                	cmp    %eax,%edx
80100862:	74 16                	je     8010087a <consoleintr+0x91>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100864:	a1 48 10 11 80       	mov    0x80111048,%eax
80100869:	83 e8 01             	sub    $0x1,%eax
8010086c:	83 e0 7f             	and    $0x7f,%eax
8010086f:	0f b6 80 c0 0f 11 80 	movzbl -0x7feef040(%eax),%eax
      while(input.e != input.w &&
80100876:	3c 0a                	cmp    $0xa,%al
80100878:	75 bf                	jne    80100839 <consoleintr+0x50>
      }
      break;
8010087a:	e9 c1 00 00 00       	jmp    80100940 <consoleintr+0x157>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010087f:	8b 15 48 10 11 80    	mov    0x80111048,%edx
80100885:	a1 44 10 11 80       	mov    0x80111044,%eax
8010088a:	39 c2                	cmp    %eax,%edx
8010088c:	74 1e                	je     801008ac <consoleintr+0xc3>
        input.e--;
8010088e:	a1 48 10 11 80       	mov    0x80111048,%eax
80100893:	83 e8 01             	sub    $0x1,%eax
80100896:	a3 48 10 11 80       	mov    %eax,0x80111048
        consputc(BACKSPACE);
8010089b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801008a2:	e8 e5 fe ff ff       	call   8010078c <consputc>
      }
      break;
801008a7:	e9 94 00 00 00       	jmp    80100940 <consoleintr+0x157>
801008ac:	e9 8f 00 00 00       	jmp    80100940 <consoleintr+0x157>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008b5:	0f 84 84 00 00 00    	je     8010093f <consoleintr+0x156>
801008bb:	8b 15 48 10 11 80    	mov    0x80111048,%edx
801008c1:	a1 40 10 11 80       	mov    0x80111040,%eax
801008c6:	29 c2                	sub    %eax,%edx
801008c8:	89 d0                	mov    %edx,%eax
801008ca:	83 f8 7f             	cmp    $0x7f,%eax
801008cd:	77 70                	ja     8010093f <consoleintr+0x156>
        c = (c == '\r') ? '\n' : c;
801008cf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008d3:	74 05                	je     801008da <consoleintr+0xf1>
801008d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008d8:	eb 05                	jmp    801008df <consoleintr+0xf6>
801008da:	b8 0a 00 00 00       	mov    $0xa,%eax
801008df:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008e2:	a1 48 10 11 80       	mov    0x80111048,%eax
801008e7:	8d 50 01             	lea    0x1(%eax),%edx
801008ea:	89 15 48 10 11 80    	mov    %edx,0x80111048
801008f0:	83 e0 7f             	and    $0x7f,%eax
801008f3:	89 c2                	mov    %eax,%edx
801008f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008f8:	88 82 c0 0f 11 80    	mov    %al,-0x7feef040(%edx)
        consputc(c);
801008fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100901:	89 04 24             	mov    %eax,(%esp)
80100904:	e8 83 fe ff ff       	call   8010078c <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100909:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
8010090d:	74 18                	je     80100927 <consoleintr+0x13e>
8010090f:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100913:	74 12                	je     80100927 <consoleintr+0x13e>
80100915:	a1 48 10 11 80       	mov    0x80111048,%eax
8010091a:	8b 15 40 10 11 80    	mov    0x80111040,%edx
80100920:	83 ea 80             	sub    $0xffffff80,%edx
80100923:	39 d0                	cmp    %edx,%eax
80100925:	75 18                	jne    8010093f <consoleintr+0x156>
          input.w = input.e;
80100927:	a1 48 10 11 80       	mov    0x80111048,%eax
8010092c:	a3 44 10 11 80       	mov    %eax,0x80111044
          wakeup(&input.r);
80100931:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80100938:	e8 5e 43 00 00       	call   80104c9b <wakeup>
        }
      }
      break;
8010093d:	eb 00                	jmp    8010093f <consoleintr+0x156>
8010093f:	90                   	nop
  while((c = getc()) >= 0){
80100940:	8b 45 08             	mov    0x8(%ebp),%eax
80100943:	ff d0                	call   *%eax
80100945:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100948:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010094c:	0f 89 b5 fe ff ff    	jns    80100807 <consoleintr+0x1e>
    }
  }
  release(&cons.lock);
80100952:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100959:	e8 c9 46 00 00       	call   80105027 <release>
  if(doprocdump) {
8010095e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100962:	74 05                	je     80100969 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
80100964:	e8 d8 43 00 00       	call   80104d41 <procdump>
  }
}
80100969:	c9                   	leave  
8010096a:	c3                   	ret    

8010096b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010096b:	55                   	push   %ebp
8010096c:	89 e5                	mov    %esp,%ebp
8010096e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100971:	8b 45 08             	mov    0x8(%ebp),%eax
80100974:	89 04 24             	mov    %eax,(%esp)
80100977:	e8 ee 10 00 00       	call   80101a6a <iunlock>
  target = n;
8010097c:	8b 45 10             	mov    0x10(%ebp),%eax
8010097f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100982:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100989:	e8 31 46 00 00       	call   80104fbf <acquire>
  while(n > 0){
8010098e:	e9 a9 00 00 00       	jmp    80100a3c <consoleread+0xd1>
    while(input.r == input.w){
80100993:	eb 41                	jmp    801009d6 <consoleread+0x6b>
      if(myproc()->killed){
80100995:	e8 14 39 00 00       	call   801042ae <myproc>
8010099a:	8b 40 24             	mov    0x24(%eax),%eax
8010099d:	85 c0                	test   %eax,%eax
8010099f:	74 21                	je     801009c2 <consoleread+0x57>
        release(&cons.lock);
801009a1:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801009a8:	e8 7a 46 00 00       	call   80105027 <release>
        ilock(ip);
801009ad:	8b 45 08             	mov    0x8(%ebp),%eax
801009b0:	89 04 24             	mov    %eax,(%esp)
801009b3:	e8 a5 0f 00 00       	call   8010195d <ilock>
        return -1;
801009b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009bd:	e9 a5 00 00 00       	jmp    80100a67 <consoleread+0xfc>
      }
      sleep(&input.r, &cons.lock);
801009c2:	c7 44 24 04 c0 b5 10 	movl   $0x8010b5c0,0x4(%esp)
801009c9:	80 
801009ca:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
801009d1:	e8 ee 41 00 00       	call   80104bc4 <sleep>
    while(input.r == input.w){
801009d6:	8b 15 40 10 11 80    	mov    0x80111040,%edx
801009dc:	a1 44 10 11 80       	mov    0x80111044,%eax
801009e1:	39 c2                	cmp    %eax,%edx
801009e3:	74 b0                	je     80100995 <consoleread+0x2a>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009e5:	a1 40 10 11 80       	mov    0x80111040,%eax
801009ea:	8d 50 01             	lea    0x1(%eax),%edx
801009ed:	89 15 40 10 11 80    	mov    %edx,0x80111040
801009f3:	83 e0 7f             	and    $0x7f,%eax
801009f6:	0f b6 80 c0 0f 11 80 	movzbl -0x7feef040(%eax),%eax
801009fd:	0f be c0             	movsbl %al,%eax
80100a00:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a03:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a07:	75 19                	jne    80100a22 <consoleread+0xb7>
      if(n < target){
80100a09:	8b 45 10             	mov    0x10(%ebp),%eax
80100a0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a0f:	73 0f                	jae    80100a20 <consoleread+0xb5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a11:	a1 40 10 11 80       	mov    0x80111040,%eax
80100a16:	83 e8 01             	sub    $0x1,%eax
80100a19:	a3 40 10 11 80       	mov    %eax,0x80111040
      }
      break;
80100a1e:	eb 26                	jmp    80100a46 <consoleread+0xdb>
80100a20:	eb 24                	jmp    80100a46 <consoleread+0xdb>
    }
    *dst++ = c;
80100a22:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a25:	8d 50 01             	lea    0x1(%eax),%edx
80100a28:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a2e:	88 10                	mov    %dl,(%eax)
    --n;
80100a30:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a34:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a38:	75 02                	jne    80100a3c <consoleread+0xd1>
      break;
80100a3a:	eb 0a                	jmp    80100a46 <consoleread+0xdb>
  while(n > 0){
80100a3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a40:	0f 8f 4d ff ff ff    	jg     80100993 <consoleread+0x28>
  }
  release(&cons.lock);
80100a46:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a4d:	e8 d5 45 00 00       	call   80105027 <release>
  ilock(ip);
80100a52:	8b 45 08             	mov    0x8(%ebp),%eax
80100a55:	89 04 24             	mov    %eax,(%esp)
80100a58:	e8 00 0f 00 00       	call   8010195d <ilock>

  return target - n;
80100a5d:	8b 45 10             	mov    0x10(%ebp),%eax
80100a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a63:	29 c2                	sub    %eax,%edx
80100a65:	89 d0                	mov    %edx,%eax
}
80100a67:	c9                   	leave  
80100a68:	c3                   	ret    

80100a69 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a69:	55                   	push   %ebp
80100a6a:	89 e5                	mov    %esp,%ebp
80100a6c:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100a72:	89 04 24             	mov    %eax,(%esp)
80100a75:	e8 f0 0f 00 00       	call   80101a6a <iunlock>
  acquire(&cons.lock);
80100a7a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a81:	e8 39 45 00 00       	call   80104fbf <acquire>
  for(i = 0; i < n; i++)
80100a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a8d:	eb 1d                	jmp    80100aac <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a92:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a95:	01 d0                	add    %edx,%eax
80100a97:	0f b6 00             	movzbl (%eax),%eax
80100a9a:	0f be c0             	movsbl %al,%eax
80100a9d:	0f b6 c0             	movzbl %al,%eax
80100aa0:	89 04 24             	mov    %eax,(%esp)
80100aa3:	e8 e4 fc ff ff       	call   8010078c <consputc>
  for(i = 0; i < n; i++)
80100aa8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100aaf:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ab2:	7c db                	jl     80100a8f <consolewrite+0x26>
  release(&cons.lock);
80100ab4:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100abb:	e8 67 45 00 00       	call   80105027 <release>
  ilock(ip);
80100ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80100ac3:	89 04 24             	mov    %eax,(%esp)
80100ac6:	e8 92 0e 00 00       	call   8010195d <ilock>

  return n;
80100acb:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ace:	c9                   	leave  
80100acf:	c3                   	ret    

80100ad0 <consoleinit>:

void
consoleinit(void)
{
80100ad0:	55                   	push   %ebp
80100ad1:	89 e5                	mov    %esp,%ebp
80100ad3:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100ad6:	c7 44 24 04 06 85 10 	movl   $0x80108506,0x4(%esp)
80100add:	80 
80100ade:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100ae5:	e8 b4 44 00 00       	call   80104f9e <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aea:	c7 05 0c 1a 11 80 69 	movl   $0x80100a69,0x80111a0c
80100af1:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100af4:	c7 05 08 1a 11 80 6b 	movl   $0x8010096b,0x80111a08
80100afb:	09 10 80 
  cons.locking = 1;
80100afe:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100b05:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100b0f:	00 
80100b10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100b17:	e8 23 1f 00 00       	call   80102a3f <ioapicenable>
}
80100b1c:	c9                   	leave  
80100b1d:	c3                   	ret    

80100b1e <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b1e:	55                   	push   %ebp
80100b1f:	89 e5                	mov    %esp,%ebp
80100b21:	81 ec 38 01 00 00    	sub    $0x138,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b27:	e8 82 37 00 00       	call   801042ae <myproc>
80100b2c:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100b2f:	e8 53 29 00 00       	call   80103487 <begin_op>

  if((ip = namei(path)) == 0){
80100b34:	8b 45 08             	mov    0x8(%ebp),%eax
80100b37:	89 04 24             	mov    %eax,(%esp)
80100b3a:	e8 58 19 00 00       	call   80102497 <namei>
80100b3f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b42:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b46:	75 1b                	jne    80100b63 <exec+0x45>
    end_op();
80100b48:	e8 be 29 00 00       	call   8010350b <end_op>
    cprintf("exec: fail\n");
80100b4d:	c7 04 24 0e 85 10 80 	movl   $0x8010850e,(%esp)
80100b54:	e8 6f f8 ff ff       	call   801003c8 <cprintf>
    return -1;
80100b59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b5e:	e9 04 04 00 00       	jmp    80100f67 <exec+0x449>
  }
  ilock(ip);
80100b63:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b66:	89 04 24             	mov    %eax,(%esp)
80100b69:	e8 ef 0d 00 00       	call   8010195d <ilock>
  pgdir = 0;
80100b6e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b75:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b7c:	00 
80100b7d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b84:	00 
80100b85:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b92:	89 04 24             	mov    %eax,(%esp)
80100b95:	e8 60 12 00 00       	call   80101dfa <readi>
80100b9a:	83 f8 34             	cmp    $0x34,%eax
80100b9d:	74 05                	je     80100ba4 <exec+0x86>
    goto bad;
80100b9f:	e9 97 03 00 00       	jmp    80100f3b <exec+0x41d>
  if(elf.magic != ELF_MAGIC)
80100ba4:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100baa:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100baf:	74 05                	je     80100bb6 <exec+0x98>
    goto bad;
80100bb1:	e9 85 03 00 00       	jmp    80100f3b <exec+0x41d>

  if((pgdir = setupkvm()) == 0)
80100bb6:	e8 2a 70 00 00       	call   80107be5 <setupkvm>
80100bbb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bbe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bc2:	75 05                	jne    80100bc9 <exec+0xab>
    goto bad;
80100bc4:	e9 72 03 00 00       	jmp    80100f3b <exec+0x41d>

  // Load program into memory.
  sz = 0;
80100bc9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bd7:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100bdd:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100be0:	e9 fc 00 00 00       	jmp    80100ce1 <exec+0x1c3>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100be8:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bef:	00 
80100bf0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bf4:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c01:	89 04 24             	mov    %eax,(%esp)
80100c04:	e8 f1 11 00 00       	call   80101dfa <readi>
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	74 05                	je     80100c13 <exec+0xf5>
      goto bad;
80100c0e:	e9 28 03 00 00       	jmp    80100f3b <exec+0x41d>
    if(ph.type != ELF_PROG_LOAD)
80100c13:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c19:	83 f8 01             	cmp    $0x1,%eax
80100c1c:	74 05                	je     80100c23 <exec+0x105>
      continue;
80100c1e:	e9 b1 00 00 00       	jmp    80100cd4 <exec+0x1b6>
    if(ph.memsz < ph.filesz)
80100c23:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c29:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c2f:	39 c2                	cmp    %eax,%edx
80100c31:	73 05                	jae    80100c38 <exec+0x11a>
      goto bad;
80100c33:	e9 03 03 00 00       	jmp    80100f3b <exec+0x41d>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c38:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c3e:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c44:	01 c2                	add    %eax,%edx
80100c46:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c4c:	39 c2                	cmp    %eax,%edx
80100c4e:	73 05                	jae    80100c55 <exec+0x137>
      goto bad;
80100c50:	e9 e6 02 00 00       	jmp    80100f3b <exec+0x41d>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c55:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c5b:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c61:	01 d0                	add    %edx,%eax
80100c63:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c67:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c71:	89 04 24             	mov    %eax,(%esp)
80100c74:	e8 42 73 00 00       	call   80107fbb <allocuvm>
80100c79:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c7c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c80:	75 05                	jne    80100c87 <exec+0x169>
      goto bad;
80100c82:	e9 b4 02 00 00       	jmp    80100f3b <exec+0x41d>
    if(ph.vaddr % PGSIZE != 0)
80100c87:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c8d:	25 ff 0f 00 00       	and    $0xfff,%eax
80100c92:	85 c0                	test   %eax,%eax
80100c94:	74 05                	je     80100c9b <exec+0x17d>
      goto bad;
80100c96:	e9 a0 02 00 00       	jmp    80100f3b <exec+0x41d>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c9b:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100ca1:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100ca7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cad:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100cb1:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100cb5:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100cb8:	89 54 24 08          	mov    %edx,0x8(%esp)
80100cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cc3:	89 04 24             	mov    %eax,(%esp)
80100cc6:	e8 0d 72 00 00       	call   80107ed8 <loaduvm>
80100ccb:	85 c0                	test   %eax,%eax
80100ccd:	79 05                	jns    80100cd4 <exec+0x1b6>
      goto bad;
80100ccf:	e9 67 02 00 00       	jmp    80100f3b <exec+0x41d>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cd4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100cd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cdb:	83 c0 20             	add    $0x20,%eax
80100cde:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ce1:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100ce8:	0f b7 c0             	movzwl %ax,%eax
80100ceb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cee:	0f 8f f1 fe ff ff    	jg     80100be5 <exec+0xc7>
  }
  iunlockput(ip);
80100cf4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cf7:	89 04 24             	mov    %eax,(%esp)
80100cfa:	e8 60 0e 00 00       	call   80101b5f <iunlockput>
  end_op();
80100cff:	e8 07 28 00 00       	call   8010350b <end_op>
  ip = 0;
80100d04:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0e:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d13:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d18:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d1e:	05 00 20 00 00       	add    $0x2000,%eax
80100d23:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d31:	89 04 24             	mov    %eax,(%esp)
80100d34:	e8 82 72 00 00       	call   80107fbb <allocuvm>
80100d39:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d40:	75 05                	jne    80100d47 <exec+0x229>
    goto bad;
80100d42:	e9 f4 01 00 00       	jmp    80100f3b <exec+0x41d>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d47:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d4a:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d56:	89 04 24             	mov    %eax,(%esp)
80100d59:	e8 d0 74 00 00       	call   8010822e <clearpteu>
  sp = sz;
80100d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d61:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d6b:	e9 9a 00 00 00       	jmp    80100e0a <exec+0x2ec>
    if(argc >= MAXARG)
80100d70:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d74:	76 05                	jbe    80100d7b <exec+0x25d>
      goto bad;
80100d76:	e9 c0 01 00 00       	jmp    80100f3b <exec+0x41d>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d85:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d88:	01 d0                	add    %edx,%eax
80100d8a:	8b 00                	mov    (%eax),%eax
80100d8c:	89 04 24             	mov    %eax,(%esp)
80100d8f:	e8 07 47 00 00       	call   8010549b <strlen>
80100d94:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d97:	29 c2                	sub    %eax,%edx
80100d99:	89 d0                	mov    %edx,%eax
80100d9b:	83 e8 01             	sub    $0x1,%eax
80100d9e:	83 e0 fc             	and    $0xfffffffc,%eax
80100da1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dae:	8b 45 0c             	mov    0xc(%ebp),%eax
80100db1:	01 d0                	add    %edx,%eax
80100db3:	8b 00                	mov    (%eax),%eax
80100db5:	89 04 24             	mov    %eax,(%esp)
80100db8:	e8 de 46 00 00       	call   8010549b <strlen>
80100dbd:	83 c0 01             	add    $0x1,%eax
80100dc0:	89 c2                	mov    %eax,%edx
80100dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dcf:	01 c8                	add    %ecx,%eax
80100dd1:	8b 00                	mov    (%eax),%eax
80100dd3:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100dd7:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ddb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dde:	89 44 24 04          	mov    %eax,0x4(%esp)
80100de2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100de5:	89 04 24             	mov    %eax,(%esp)
80100de8:	e8 04 76 00 00       	call   801083f1 <copyout>
80100ded:	85 c0                	test   %eax,%eax
80100def:	79 05                	jns    80100df6 <exec+0x2d8>
      goto bad;
80100df1:	e9 45 01 00 00       	jmp    80100f3b <exec+0x41d>
    ustack[3+argc] = sp;
80100df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df9:	8d 50 03             	lea    0x3(%eax),%edx
80100dfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dff:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e06:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e14:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e17:	01 d0                	add    %edx,%eax
80100e19:	8b 00                	mov    (%eax),%eax
80100e1b:	85 c0                	test   %eax,%eax
80100e1d:	0f 85 4d ff ff ff    	jne    80100d70 <exec+0x252>
  }
  ustack[3+argc] = 0;
80100e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e26:	83 c0 03             	add    $0x3,%eax
80100e29:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e30:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e34:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e3b:	ff ff ff 
  ustack[1] = argc;
80100e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e41:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4a:	83 c0 01             	add    $0x1,%eax
80100e4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e57:	29 d0                	sub    %edx,%eax
80100e59:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e62:	83 c0 04             	add    $0x4,%eax
80100e65:	c1 e0 02             	shl    $0x2,%eax
80100e68:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6e:	83 c0 04             	add    $0x4,%eax
80100e71:	c1 e0 02             	shl    $0x2,%eax
80100e74:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e78:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100e7e:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e82:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e85:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e8c:	89 04 24             	mov    %eax,(%esp)
80100e8f:	e8 5d 75 00 00       	call   801083f1 <copyout>
80100e94:	85 c0                	test   %eax,%eax
80100e96:	79 05                	jns    80100e9d <exec+0x37f>
    goto bad;
80100e98:	e9 9e 00 00 00       	jmp    80100f3b <exec+0x41d>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e9d:	8b 45 08             	mov    0x8(%ebp),%eax
80100ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ea9:	eb 17                	jmp    80100ec2 <exec+0x3a4>
    if(*s == '/')
80100eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eae:	0f b6 00             	movzbl (%eax),%eax
80100eb1:	3c 2f                	cmp    $0x2f,%al
80100eb3:	75 09                	jne    80100ebe <exec+0x3a0>
      last = s+1;
80100eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eb8:	83 c0 01             	add    $0x1,%eax
80100ebb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100ebe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ec5:	0f b6 00             	movzbl (%eax),%eax
80100ec8:	84 c0                	test   %al,%al
80100eca:	75 df                	jne    80100eab <exec+0x38d>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ecc:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ecf:	8d 50 6c             	lea    0x6c(%eax),%edx
80100ed2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ed9:	00 
80100eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100edd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ee1:	89 14 24             	mov    %edx,(%esp)
80100ee4:	e8 68 45 00 00       	call   80105451 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100ee9:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100eec:	8b 40 04             	mov    0x4(%eax),%eax
80100eef:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100ef2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ef5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ef8:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100efb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100efe:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f01:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f03:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f06:	8b 40 18             	mov    0x18(%eax),%eax
80100f09:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f0f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f12:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f15:	8b 40 18             	mov    0x18(%eax),%eax
80100f18:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f1b:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f1e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f21:	89 04 24             	mov    %eax,(%esp)
80100f24:	e8 96 6d 00 00       	call   80107cbf <switchuvm>
  freevm(oldpgdir);
80100f29:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100f2c:	89 04 24             	mov    %eax,(%esp)
80100f2f:	e8 63 72 00 00       	call   80108197 <freevm>
  return 0;
80100f34:	b8 00 00 00 00       	mov    $0x0,%eax
80100f39:	eb 2c                	jmp    80100f67 <exec+0x449>

 bad:
  if(pgdir)
80100f3b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f3f:	74 0b                	je     80100f4c <exec+0x42e>
    freevm(pgdir);
80100f41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f44:	89 04 24             	mov    %eax,(%esp)
80100f47:	e8 4b 72 00 00       	call   80108197 <freevm>
  if(ip){
80100f4c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f50:	74 10                	je     80100f62 <exec+0x444>
    iunlockput(ip);
80100f52:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f55:	89 04 24             	mov    %eax,(%esp)
80100f58:	e8 02 0c 00 00       	call   80101b5f <iunlockput>
    end_op();
80100f5d:	e8 a9 25 00 00       	call   8010350b <end_op>
  }
  return -1;
80100f62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f67:	c9                   	leave  
80100f68:	c3                   	ret    

80100f69 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f69:	55                   	push   %ebp
80100f6a:	89 e5                	mov    %esp,%ebp
80100f6c:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f6f:	c7 44 24 04 1a 85 10 	movl   $0x8010851a,0x4(%esp)
80100f76:	80 
80100f77:	c7 04 24 60 10 11 80 	movl   $0x80111060,(%esp)
80100f7e:	e8 1b 40 00 00       	call   80104f9e <initlock>
}
80100f83:	c9                   	leave  
80100f84:	c3                   	ret    

80100f85 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f85:	55                   	push   %ebp
80100f86:	89 e5                	mov    %esp,%ebp
80100f88:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f8b:	c7 04 24 60 10 11 80 	movl   $0x80111060,(%esp)
80100f92:	e8 28 40 00 00       	call   80104fbf <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f97:	c7 45 f4 94 10 11 80 	movl   $0x80111094,-0xc(%ebp)
80100f9e:	eb 29                	jmp    80100fc9 <filealloc+0x44>
    if(f->ref == 0){
80100fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa3:	8b 40 04             	mov    0x4(%eax),%eax
80100fa6:	85 c0                	test   %eax,%eax
80100fa8:	75 1b                	jne    80100fc5 <filealloc+0x40>
      f->ref = 1;
80100faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fad:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fb4:	c7 04 24 60 10 11 80 	movl   $0x80111060,(%esp)
80100fbb:	e8 67 40 00 00       	call   80105027 <release>
      return f;
80100fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fc3:	eb 1e                	jmp    80100fe3 <filealloc+0x5e>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fc5:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fc9:	81 7d f4 f4 19 11 80 	cmpl   $0x801119f4,-0xc(%ebp)
80100fd0:	72 ce                	jb     80100fa0 <filealloc+0x1b>
    }
  }
  release(&ftable.lock);
80100fd2:	c7 04 24 60 10 11 80 	movl   $0x80111060,(%esp)
80100fd9:	e8 49 40 00 00       	call   80105027 <release>
  return 0;
80100fde:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fe3:	c9                   	leave  
80100fe4:	c3                   	ret    

80100fe5 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fe5:	55                   	push   %ebp
80100fe6:	89 e5                	mov    %esp,%ebp
80100fe8:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100feb:	c7 04 24 60 10 11 80 	movl   $0x80111060,(%esp)
80100ff2:	e8 c8 3f 00 00       	call   80104fbf <acquire>
  if(f->ref < 1)
80100ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffa:	8b 40 04             	mov    0x4(%eax),%eax
80100ffd:	85 c0                	test   %eax,%eax
80100fff:	7f 0c                	jg     8010100d <filedup+0x28>
    panic("filedup");
80101001:	c7 04 24 21 85 10 80 	movl   $0x80108521,(%esp)
80101008:	e8 55 f5 ff ff       	call   80100562 <panic>
  f->ref++;
8010100d:	8b 45 08             	mov    0x8(%ebp),%eax
80101010:	8b 40 04             	mov    0x4(%eax),%eax
80101013:	8d 50 01             	lea    0x1(%eax),%edx
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010101c:	c7 04 24 60 10 11 80 	movl   $0x80111060,(%esp)
80101023:	e8 ff 3f 00 00       	call   80105027 <release>
  return f;
80101028:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010102b:	c9                   	leave  
8010102c:	c3                   	ret    

8010102d <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010102d:	55                   	push   %ebp
8010102e:	89 e5                	mov    %esp,%ebp
80101030:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80101033:	c7 04 24 60 10 11 80 	movl   $0x80111060,(%esp)
8010103a:	e8 80 3f 00 00       	call   80104fbf <acquire>
  if(f->ref < 1)
8010103f:	8b 45 08             	mov    0x8(%ebp),%eax
80101042:	8b 40 04             	mov    0x4(%eax),%eax
80101045:	85 c0                	test   %eax,%eax
80101047:	7f 0c                	jg     80101055 <fileclose+0x28>
    panic("fileclose");
80101049:	c7 04 24 29 85 10 80 	movl   $0x80108529,(%esp)
80101050:	e8 0d f5 ff ff       	call   80100562 <panic>
  if(--f->ref > 0){
80101055:	8b 45 08             	mov    0x8(%ebp),%eax
80101058:	8b 40 04             	mov    0x4(%eax),%eax
8010105b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010105e:	8b 45 08             	mov    0x8(%ebp),%eax
80101061:	89 50 04             	mov    %edx,0x4(%eax)
80101064:	8b 45 08             	mov    0x8(%ebp),%eax
80101067:	8b 40 04             	mov    0x4(%eax),%eax
8010106a:	85 c0                	test   %eax,%eax
8010106c:	7e 11                	jle    8010107f <fileclose+0x52>
    release(&ftable.lock);
8010106e:	c7 04 24 60 10 11 80 	movl   $0x80111060,(%esp)
80101075:	e8 ad 3f 00 00       	call   80105027 <release>
8010107a:	e9 82 00 00 00       	jmp    80101101 <fileclose+0xd4>
    return;
  }
  ff = *f;
8010107f:	8b 45 08             	mov    0x8(%ebp),%eax
80101082:	8b 10                	mov    (%eax),%edx
80101084:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101087:	8b 50 04             	mov    0x4(%eax),%edx
8010108a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010108d:	8b 50 08             	mov    0x8(%eax),%edx
80101090:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101093:	8b 50 0c             	mov    0xc(%eax),%edx
80101096:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101099:	8b 50 10             	mov    0x10(%eax),%edx
8010109c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010109f:	8b 40 14             	mov    0x14(%eax),%eax
801010a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010a5:	8b 45 08             	mov    0x8(%ebp),%eax
801010a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010af:	8b 45 08             	mov    0x8(%ebp),%eax
801010b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010b8:	c7 04 24 60 10 11 80 	movl   $0x80111060,(%esp)
801010bf:	e8 63 3f 00 00       	call   80105027 <release>

  if(ff.type == FD_PIPE)
801010c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010c7:	83 f8 01             	cmp    $0x1,%eax
801010ca:	75 18                	jne    801010e4 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
801010cc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010d0:	0f be d0             	movsbl %al,%edx
801010d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801010da:	89 04 24             	mov    %eax,(%esp)
801010dd:	e8 46 2d 00 00       	call   80103e28 <pipeclose>
801010e2:	eb 1d                	jmp    80101101 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e7:	83 f8 02             	cmp    $0x2,%eax
801010ea:	75 15                	jne    80101101 <fileclose+0xd4>
    begin_op();
801010ec:	e8 96 23 00 00       	call   80103487 <begin_op>
    iput(ff.ip);
801010f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010f4:	89 04 24             	mov    %eax,(%esp)
801010f7:	e8 b2 09 00 00       	call   80101aae <iput>
    end_op();
801010fc:	e8 0a 24 00 00       	call   8010350b <end_op>
  }
}
80101101:	c9                   	leave  
80101102:	c3                   	ret    

80101103 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101103:	55                   	push   %ebp
80101104:	89 e5                	mov    %esp,%ebp
80101106:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
80101109:	8b 45 08             	mov    0x8(%ebp),%eax
8010110c:	8b 00                	mov    (%eax),%eax
8010110e:	83 f8 02             	cmp    $0x2,%eax
80101111:	75 38                	jne    8010114b <filestat+0x48>
    ilock(f->ip);
80101113:	8b 45 08             	mov    0x8(%ebp),%eax
80101116:	8b 40 10             	mov    0x10(%eax),%eax
80101119:	89 04 24             	mov    %eax,(%esp)
8010111c:	e8 3c 08 00 00       	call   8010195d <ilock>
    stati(f->ip, st);
80101121:	8b 45 08             	mov    0x8(%ebp),%eax
80101124:	8b 40 10             	mov    0x10(%eax),%eax
80101127:	8b 55 0c             	mov    0xc(%ebp),%edx
8010112a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010112e:	89 04 24             	mov    %eax,(%esp)
80101131:	e8 7f 0c 00 00       	call   80101db5 <stati>
    iunlock(f->ip);
80101136:	8b 45 08             	mov    0x8(%ebp),%eax
80101139:	8b 40 10             	mov    0x10(%eax),%eax
8010113c:	89 04 24             	mov    %eax,(%esp)
8010113f:	e8 26 09 00 00       	call   80101a6a <iunlock>
    return 0;
80101144:	b8 00 00 00 00       	mov    $0x0,%eax
80101149:	eb 05                	jmp    80101150 <filestat+0x4d>
  }
  return -1;
8010114b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101150:	c9                   	leave  
80101151:	c3                   	ret    

80101152 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101152:	55                   	push   %ebp
80101153:	89 e5                	mov    %esp,%ebp
80101155:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101158:	8b 45 08             	mov    0x8(%ebp),%eax
8010115b:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010115f:	84 c0                	test   %al,%al
80101161:	75 0a                	jne    8010116d <fileread+0x1b>
    return -1;
80101163:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101168:	e9 9f 00 00 00       	jmp    8010120c <fileread+0xba>
  if(f->type == FD_PIPE)
8010116d:	8b 45 08             	mov    0x8(%ebp),%eax
80101170:	8b 00                	mov    (%eax),%eax
80101172:	83 f8 01             	cmp    $0x1,%eax
80101175:	75 1e                	jne    80101195 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101177:	8b 45 08             	mov    0x8(%ebp),%eax
8010117a:	8b 40 0c             	mov    0xc(%eax),%eax
8010117d:	8b 55 10             	mov    0x10(%ebp),%edx
80101180:	89 54 24 08          	mov    %edx,0x8(%esp)
80101184:	8b 55 0c             	mov    0xc(%ebp),%edx
80101187:	89 54 24 04          	mov    %edx,0x4(%esp)
8010118b:	89 04 24             	mov    %eax,(%esp)
8010118e:	e8 15 2e 00 00       	call   80103fa8 <piperead>
80101193:	eb 77                	jmp    8010120c <fileread+0xba>
  if(f->type == FD_INODE){
80101195:	8b 45 08             	mov    0x8(%ebp),%eax
80101198:	8b 00                	mov    (%eax),%eax
8010119a:	83 f8 02             	cmp    $0x2,%eax
8010119d:	75 61                	jne    80101200 <fileread+0xae>
    ilock(f->ip);
8010119f:	8b 45 08             	mov    0x8(%ebp),%eax
801011a2:	8b 40 10             	mov    0x10(%eax),%eax
801011a5:	89 04 24             	mov    %eax,(%esp)
801011a8:	e8 b0 07 00 00       	call   8010195d <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011b0:	8b 45 08             	mov    0x8(%ebp),%eax
801011b3:	8b 50 14             	mov    0x14(%eax),%edx
801011b6:	8b 45 08             	mov    0x8(%ebp),%eax
801011b9:	8b 40 10             	mov    0x10(%eax),%eax
801011bc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801011c0:	89 54 24 08          	mov    %edx,0x8(%esp)
801011c4:	8b 55 0c             	mov    0xc(%ebp),%edx
801011c7:	89 54 24 04          	mov    %edx,0x4(%esp)
801011cb:	89 04 24             	mov    %eax,(%esp)
801011ce:	e8 27 0c 00 00       	call   80101dfa <readi>
801011d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011da:	7e 11                	jle    801011ed <fileread+0x9b>
      f->off += r;
801011dc:	8b 45 08             	mov    0x8(%ebp),%eax
801011df:	8b 50 14             	mov    0x14(%eax),%edx
801011e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011e5:	01 c2                	add    %eax,%edx
801011e7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ea:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011ed:	8b 45 08             	mov    0x8(%ebp),%eax
801011f0:	8b 40 10             	mov    0x10(%eax),%eax
801011f3:	89 04 24             	mov    %eax,(%esp)
801011f6:	e8 6f 08 00 00       	call   80101a6a <iunlock>
    return r;
801011fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011fe:	eb 0c                	jmp    8010120c <fileread+0xba>
  }
  panic("fileread");
80101200:	c7 04 24 33 85 10 80 	movl   $0x80108533,(%esp)
80101207:	e8 56 f3 ff ff       	call   80100562 <panic>
}
8010120c:	c9                   	leave  
8010120d:	c3                   	ret    

8010120e <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010120e:	55                   	push   %ebp
8010120f:	89 e5                	mov    %esp,%ebp
80101211:	53                   	push   %ebx
80101212:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
80101215:	8b 45 08             	mov    0x8(%ebp),%eax
80101218:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010121c:	84 c0                	test   %al,%al
8010121e:	75 0a                	jne    8010122a <filewrite+0x1c>
    return -1;
80101220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101225:	e9 20 01 00 00       	jmp    8010134a <filewrite+0x13c>
  if(f->type == FD_PIPE)
8010122a:	8b 45 08             	mov    0x8(%ebp),%eax
8010122d:	8b 00                	mov    (%eax),%eax
8010122f:	83 f8 01             	cmp    $0x1,%eax
80101232:	75 21                	jne    80101255 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
80101234:	8b 45 08             	mov    0x8(%ebp),%eax
80101237:	8b 40 0c             	mov    0xc(%eax),%eax
8010123a:	8b 55 10             	mov    0x10(%ebp),%edx
8010123d:	89 54 24 08          	mov    %edx,0x8(%esp)
80101241:	8b 55 0c             	mov    0xc(%ebp),%edx
80101244:	89 54 24 04          	mov    %edx,0x4(%esp)
80101248:	89 04 24             	mov    %eax,(%esp)
8010124b:	e8 6a 2c 00 00       	call   80103eba <pipewrite>
80101250:	e9 f5 00 00 00       	jmp    8010134a <filewrite+0x13c>
  if(f->type == FD_INODE){
80101255:	8b 45 08             	mov    0x8(%ebp),%eax
80101258:	8b 00                	mov    (%eax),%eax
8010125a:	83 f8 02             	cmp    $0x2,%eax
8010125d:	0f 85 db 00 00 00    	jne    8010133e <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
80101263:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
8010126a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101271:	e9 a8 00 00 00       	jmp    8010131e <filewrite+0x110>
      int n1 = n - i;
80101276:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101279:	8b 55 10             	mov    0x10(%ebp),%edx
8010127c:	29 c2                	sub    %eax,%edx
8010127e:	89 d0                	mov    %edx,%eax
80101280:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101283:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101286:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101289:	7e 06                	jle    80101291 <filewrite+0x83>
        n1 = max;
8010128b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010128e:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101291:	e8 f1 21 00 00       	call   80103487 <begin_op>
      ilock(f->ip);
80101296:	8b 45 08             	mov    0x8(%ebp),%eax
80101299:	8b 40 10             	mov    0x10(%eax),%eax
8010129c:	89 04 24             	mov    %eax,(%esp)
8010129f:	e8 b9 06 00 00       	call   8010195d <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012a4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012a7:	8b 45 08             	mov    0x8(%ebp),%eax
801012aa:	8b 50 14             	mov    0x14(%eax),%edx
801012ad:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801012b3:	01 c3                	add    %eax,%ebx
801012b5:	8b 45 08             	mov    0x8(%ebp),%eax
801012b8:	8b 40 10             	mov    0x10(%eax),%eax
801012bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801012bf:	89 54 24 08          	mov    %edx,0x8(%esp)
801012c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801012c7:	89 04 24             	mov    %eax,(%esp)
801012ca:	e8 8f 0c 00 00       	call   80101f5e <writei>
801012cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012d6:	7e 11                	jle    801012e9 <filewrite+0xdb>
        f->off += r;
801012d8:	8b 45 08             	mov    0x8(%ebp),%eax
801012db:	8b 50 14             	mov    0x14(%eax),%edx
801012de:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012e1:	01 c2                	add    %eax,%edx
801012e3:	8b 45 08             	mov    0x8(%ebp),%eax
801012e6:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012e9:	8b 45 08             	mov    0x8(%ebp),%eax
801012ec:	8b 40 10             	mov    0x10(%eax),%eax
801012ef:	89 04 24             	mov    %eax,(%esp)
801012f2:	e8 73 07 00 00       	call   80101a6a <iunlock>
      end_op();
801012f7:	e8 0f 22 00 00       	call   8010350b <end_op>

      if(r < 0)
801012fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101300:	79 02                	jns    80101304 <filewrite+0xf6>
        break;
80101302:	eb 26                	jmp    8010132a <filewrite+0x11c>
      if(r != n1)
80101304:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101307:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010130a:	74 0c                	je     80101318 <filewrite+0x10a>
        panic("short filewrite");
8010130c:	c7 04 24 3c 85 10 80 	movl   $0x8010853c,(%esp)
80101313:	e8 4a f2 ff ff       	call   80100562 <panic>
      i += r;
80101318:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010131b:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
8010131e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101321:	3b 45 10             	cmp    0x10(%ebp),%eax
80101324:	0f 8c 4c ff ff ff    	jl     80101276 <filewrite+0x68>
    }
    return i == n ? n : -1;
8010132a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010132d:	3b 45 10             	cmp    0x10(%ebp),%eax
80101330:	75 05                	jne    80101337 <filewrite+0x129>
80101332:	8b 45 10             	mov    0x10(%ebp),%eax
80101335:	eb 05                	jmp    8010133c <filewrite+0x12e>
80101337:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010133c:	eb 0c                	jmp    8010134a <filewrite+0x13c>
  }
  panic("filewrite");
8010133e:	c7 04 24 4c 85 10 80 	movl   $0x8010854c,(%esp)
80101345:	e8 18 f2 ff ff       	call   80100562 <panic>
}
8010134a:	83 c4 24             	add    $0x24,%esp
8010134d:	5b                   	pop    %ebx
8010134e:	5d                   	pop    %ebp
8010134f:	c3                   	ret    

80101350 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101356:	8b 45 08             	mov    0x8(%ebp),%eax
80101359:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101360:	00 
80101361:	89 04 24             	mov    %eax,(%esp)
80101364:	e8 4c ee ff ff       	call   801001b5 <bread>
80101369:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010136c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136f:	83 c0 5c             	add    $0x5c,%eax
80101372:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101379:	00 
8010137a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010137e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101381:	89 04 24             	mov    %eax,(%esp)
80101384:	e8 77 3f 00 00       	call   80105300 <memmove>
  brelse(bp);
80101389:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010138c:	89 04 24             	mov    %eax,(%esp)
8010138f:	e8 98 ee ff ff       	call   8010022c <brelse>
}
80101394:	c9                   	leave  
80101395:	c3                   	ret    

80101396 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101396:	55                   	push   %ebp
80101397:	89 e5                	mov    %esp,%ebp
80101399:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
8010139c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010139f:	8b 45 08             	mov    0x8(%ebp),%eax
801013a2:	89 54 24 04          	mov    %edx,0x4(%esp)
801013a6:	89 04 24             	mov    %eax,(%esp)
801013a9:	e8 07 ee ff ff       	call   801001b5 <bread>
801013ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b4:	83 c0 5c             	add    $0x5c,%eax
801013b7:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801013be:	00 
801013bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801013c6:	00 
801013c7:	89 04 24             	mov    %eax,(%esp)
801013ca:	e8 62 3e 00 00       	call   80105231 <memset>
  log_write(bp);
801013cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d2:	89 04 24             	mov    %eax,(%esp)
801013d5:	e8 b8 22 00 00       	call   80103692 <log_write>
  brelse(bp);
801013da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013dd:	89 04 24             	mov    %eax,(%esp)
801013e0:	e8 47 ee ff ff       	call   8010022c <brelse>
}
801013e5:	c9                   	leave  
801013e6:	c3                   	ret    

801013e7 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013e7:	55                   	push   %ebp
801013e8:	89 e5                	mov    %esp,%ebp
801013ea:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801013ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013fb:	e9 07 01 00 00       	jmp    80101507 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
80101400:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101403:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101409:	85 c0                	test   %eax,%eax
8010140b:	0f 48 c2             	cmovs  %edx,%eax
8010140e:	c1 f8 0c             	sar    $0xc,%eax
80101411:	89 c2                	mov    %eax,%edx
80101413:	a1 78 1a 11 80       	mov    0x80111a78,%eax
80101418:	01 d0                	add    %edx,%eax
8010141a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010141e:	8b 45 08             	mov    0x8(%ebp),%eax
80101421:	89 04 24             	mov    %eax,(%esp)
80101424:	e8 8c ed ff ff       	call   801001b5 <bread>
80101429:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010142c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101433:	e9 9d 00 00 00       	jmp    801014d5 <balloc+0xee>
      m = 1 << (bi % 8);
80101438:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010143b:	99                   	cltd   
8010143c:	c1 ea 1d             	shr    $0x1d,%edx
8010143f:	01 d0                	add    %edx,%eax
80101441:	83 e0 07             	and    $0x7,%eax
80101444:	29 d0                	sub    %edx,%eax
80101446:	ba 01 00 00 00       	mov    $0x1,%edx
8010144b:	89 c1                	mov    %eax,%ecx
8010144d:	d3 e2                	shl    %cl,%edx
8010144f:	89 d0                	mov    %edx,%eax
80101451:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101454:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101457:	8d 50 07             	lea    0x7(%eax),%edx
8010145a:	85 c0                	test   %eax,%eax
8010145c:	0f 48 c2             	cmovs  %edx,%eax
8010145f:	c1 f8 03             	sar    $0x3,%eax
80101462:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101465:	0f b6 44 02 5c       	movzbl 0x5c(%edx,%eax,1),%eax
8010146a:	0f b6 c0             	movzbl %al,%eax
8010146d:	23 45 e8             	and    -0x18(%ebp),%eax
80101470:	85 c0                	test   %eax,%eax
80101472:	75 5d                	jne    801014d1 <balloc+0xea>
        bp->data[bi/8] |= m;  // Mark block in use.
80101474:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101477:	8d 50 07             	lea    0x7(%eax),%edx
8010147a:	85 c0                	test   %eax,%eax
8010147c:	0f 48 c2             	cmovs  %edx,%eax
8010147f:	c1 f8 03             	sar    $0x3,%eax
80101482:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101485:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010148a:	89 d1                	mov    %edx,%ecx
8010148c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010148f:	09 ca                	or     %ecx,%edx
80101491:	89 d1                	mov    %edx,%ecx
80101493:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101496:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
8010149a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010149d:	89 04 24             	mov    %eax,(%esp)
801014a0:	e8 ed 21 00 00       	call   80103692 <log_write>
        brelse(bp);
801014a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014a8:	89 04 24             	mov    %eax,(%esp)
801014ab:	e8 7c ed ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
801014b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014b6:	01 c2                	add    %eax,%edx
801014b8:	8b 45 08             	mov    0x8(%ebp),%eax
801014bb:	89 54 24 04          	mov    %edx,0x4(%esp)
801014bf:	89 04 24             	mov    %eax,(%esp)
801014c2:	e8 cf fe ff ff       	call   80101396 <bzero>
        return b + bi;
801014c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014cd:	01 d0                	add    %edx,%eax
801014cf:	eb 52                	jmp    80101523 <balloc+0x13c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014d1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014d5:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014dc:	7f 17                	jg     801014f5 <balloc+0x10e>
801014de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014e4:	01 d0                	add    %edx,%eax
801014e6:	89 c2                	mov    %eax,%edx
801014e8:	a1 60 1a 11 80       	mov    0x80111a60,%eax
801014ed:	39 c2                	cmp    %eax,%edx
801014ef:	0f 82 43 ff ff ff    	jb     80101438 <balloc+0x51>
      }
    }
    brelse(bp);
801014f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014f8:	89 04 24             	mov    %eax,(%esp)
801014fb:	e8 2c ed ff ff       	call   8010022c <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101500:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101507:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010150a:	a1 60 1a 11 80       	mov    0x80111a60,%eax
8010150f:	39 c2                	cmp    %eax,%edx
80101511:	0f 82 e9 fe ff ff    	jb     80101400 <balloc+0x19>
  }
  panic("balloc: out of blocks");
80101517:	c7 04 24 58 85 10 80 	movl   $0x80108558,(%esp)
8010151e:	e8 3f f0 ff ff       	call   80100562 <panic>
}
80101523:	c9                   	leave  
80101524:	c3                   	ret    

80101525 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101525:	55                   	push   %ebp
80101526:	89 e5                	mov    %esp,%ebp
80101528:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010152b:	c7 44 24 04 60 1a 11 	movl   $0x80111a60,0x4(%esp)
80101532:	80 
80101533:	8b 45 08             	mov    0x8(%ebp),%eax
80101536:	89 04 24             	mov    %eax,(%esp)
80101539:	e8 12 fe ff ff       	call   80101350 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010153e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101541:	c1 e8 0c             	shr    $0xc,%eax
80101544:	89 c2                	mov    %eax,%edx
80101546:	a1 78 1a 11 80       	mov    0x80111a78,%eax
8010154b:	01 c2                	add    %eax,%edx
8010154d:	8b 45 08             	mov    0x8(%ebp),%eax
80101550:	89 54 24 04          	mov    %edx,0x4(%esp)
80101554:	89 04 24             	mov    %eax,(%esp)
80101557:	e8 59 ec ff ff       	call   801001b5 <bread>
8010155c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010155f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101562:	25 ff 0f 00 00       	and    $0xfff,%eax
80101567:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010156a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156d:	99                   	cltd   
8010156e:	c1 ea 1d             	shr    $0x1d,%edx
80101571:	01 d0                	add    %edx,%eax
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	29 d0                	sub    %edx,%eax
80101578:	ba 01 00 00 00       	mov    $0x1,%edx
8010157d:	89 c1                	mov    %eax,%ecx
8010157f:	d3 e2                	shl    %cl,%edx
80101581:	89 d0                	mov    %edx,%eax
80101583:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101586:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101589:	8d 50 07             	lea    0x7(%eax),%edx
8010158c:	85 c0                	test   %eax,%eax
8010158e:	0f 48 c2             	cmovs  %edx,%eax
80101591:	c1 f8 03             	sar    $0x3,%eax
80101594:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101597:	0f b6 44 02 5c       	movzbl 0x5c(%edx,%eax,1),%eax
8010159c:	0f b6 c0             	movzbl %al,%eax
8010159f:	23 45 ec             	and    -0x14(%ebp),%eax
801015a2:	85 c0                	test   %eax,%eax
801015a4:	75 0c                	jne    801015b2 <bfree+0x8d>
    panic("freeing free block");
801015a6:	c7 04 24 6e 85 10 80 	movl   $0x8010856e,(%esp)
801015ad:	e8 b0 ef ff ff       	call   80100562 <panic>
  bp->data[bi/8] &= ~m;
801015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b5:	8d 50 07             	lea    0x7(%eax),%edx
801015b8:	85 c0                	test   %eax,%eax
801015ba:	0f 48 c2             	cmovs  %edx,%eax
801015bd:	c1 f8 03             	sar    $0x3,%eax
801015c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c3:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
801015c8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015cb:	f7 d1                	not    %ecx
801015cd:	21 ca                	and    %ecx,%edx
801015cf:	89 d1                	mov    %edx,%ecx
801015d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d4:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
801015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015db:	89 04 24             	mov    %eax,(%esp)
801015de:	e8 af 20 00 00       	call   80103692 <log_write>
  brelse(bp);
801015e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015e6:	89 04 24             	mov    %eax,(%esp)
801015e9:	e8 3e ec ff ff       	call   8010022c <brelse>
}
801015ee:	c9                   	leave  
801015ef:	c3                   	ret    

801015f0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	57                   	push   %edi
801015f4:	56                   	push   %esi
801015f5:	53                   	push   %ebx
801015f6:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
801015f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
80101600:	c7 44 24 04 81 85 10 	movl   $0x80108581,0x4(%esp)
80101607:	80 
80101608:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
8010160f:	e8 8a 39 00 00       	call   80104f9e <initlock>
  for(i = 0; i < NINODE; i++) {
80101614:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010161b:	eb 2c                	jmp    80101649 <iinit+0x59>
    initsleeplock(&icache.inode[i].lock, "inode");
8010161d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101620:	89 d0                	mov    %edx,%eax
80101622:	c1 e0 03             	shl    $0x3,%eax
80101625:	01 d0                	add    %edx,%eax
80101627:	c1 e0 04             	shl    $0x4,%eax
8010162a:	83 c0 30             	add    $0x30,%eax
8010162d:	05 80 1a 11 80       	add    $0x80111a80,%eax
80101632:	83 c0 10             	add    $0x10,%eax
80101635:	c7 44 24 04 88 85 10 	movl   $0x80108588,0x4(%esp)
8010163c:	80 
8010163d:	89 04 24             	mov    %eax,(%esp)
80101640:	e8 f6 37 00 00       	call   80104e3b <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101645:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80101649:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
8010164d:	7e ce                	jle    8010161d <iinit+0x2d>
  }

  readsb(dev, &sb);
8010164f:	c7 44 24 04 60 1a 11 	movl   $0x80111a60,0x4(%esp)
80101656:	80 
80101657:	8b 45 08             	mov    0x8(%ebp),%eax
8010165a:	89 04 24             	mov    %eax,(%esp)
8010165d:	e8 ee fc ff ff       	call   80101350 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101662:	a1 78 1a 11 80       	mov    0x80111a78,%eax
80101667:	8b 3d 74 1a 11 80    	mov    0x80111a74,%edi
8010166d:	8b 35 70 1a 11 80    	mov    0x80111a70,%esi
80101673:	8b 1d 6c 1a 11 80    	mov    0x80111a6c,%ebx
80101679:	8b 0d 68 1a 11 80    	mov    0x80111a68,%ecx
8010167f:	8b 15 64 1a 11 80    	mov    0x80111a64,%edx
80101685:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80101688:	8b 15 60 1a 11 80    	mov    0x80111a60,%edx
8010168e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101692:	89 7c 24 18          	mov    %edi,0x18(%esp)
80101696:	89 74 24 14          	mov    %esi,0x14(%esp)
8010169a:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010169e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801016a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801016a5:	89 44 24 08          	mov    %eax,0x8(%esp)
801016a9:	89 d0                	mov    %edx,%eax
801016ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801016af:	c7 04 24 90 85 10 80 	movl   $0x80108590,(%esp)
801016b6:	e8 0d ed ff ff       	call   801003c8 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801016bb:	83 c4 4c             	add    $0x4c,%esp
801016be:	5b                   	pop    %ebx
801016bf:	5e                   	pop    %esi
801016c0:	5f                   	pop    %edi
801016c1:	5d                   	pop    %ebp
801016c2:	c3                   	ret    

801016c3 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801016c3:	55                   	push   %ebp
801016c4:	89 e5                	mov    %esp,%ebp
801016c6:	83 ec 28             	sub    $0x28,%esp
801016c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801016cc:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016d0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801016d7:	e9 9e 00 00 00       	jmp    8010177a <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801016dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016df:	c1 e8 03             	shr    $0x3,%eax
801016e2:	89 c2                	mov    %eax,%edx
801016e4:	a1 74 1a 11 80       	mov    0x80111a74,%eax
801016e9:	01 d0                	add    %edx,%eax
801016eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801016ef:	8b 45 08             	mov    0x8(%ebp),%eax
801016f2:	89 04 24             	mov    %eax,(%esp)
801016f5:	e8 bb ea ff ff       	call   801001b5 <bread>
801016fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101700:	8d 50 5c             	lea    0x5c(%eax),%edx
80101703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101706:	83 e0 07             	and    $0x7,%eax
80101709:	c1 e0 06             	shl    $0x6,%eax
8010170c:	01 d0                	add    %edx,%eax
8010170e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101711:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101714:	0f b7 00             	movzwl (%eax),%eax
80101717:	66 85 c0             	test   %ax,%ax
8010171a:	75 4f                	jne    8010176b <ialloc+0xa8>
      memset(dip, 0, sizeof(*dip));
8010171c:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101723:	00 
80101724:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010172b:	00 
8010172c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010172f:	89 04 24             	mov    %eax,(%esp)
80101732:	e8 fa 3a 00 00       	call   80105231 <memset>
      dip->type = type;
80101737:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010173a:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010173e:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101741:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101744:	89 04 24             	mov    %eax,(%esp)
80101747:	e8 46 1f 00 00       	call   80103692 <log_write>
      brelse(bp);
8010174c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010174f:	89 04 24             	mov    %eax,(%esp)
80101752:	e8 d5 ea ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
80101757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010175e:	8b 45 08             	mov    0x8(%ebp),%eax
80101761:	89 04 24             	mov    %eax,(%esp)
80101764:	e8 ed 00 00 00       	call   80101856 <iget>
80101769:	eb 2b                	jmp    80101796 <ialloc+0xd3>
    }
    brelse(bp);
8010176b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176e:	89 04 24             	mov    %eax,(%esp)
80101771:	e8 b6 ea ff ff       	call   8010022c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101776:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010177a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010177d:	a1 68 1a 11 80       	mov    0x80111a68,%eax
80101782:	39 c2                	cmp    %eax,%edx
80101784:	0f 82 52 ff ff ff    	jb     801016dc <ialloc+0x19>
  }
  panic("ialloc: no inodes");
8010178a:	c7 04 24 e3 85 10 80 	movl   $0x801085e3,(%esp)
80101791:	e8 cc ed ff ff       	call   80100562 <panic>
}
80101796:	c9                   	leave  
80101797:	c3                   	ret    

80101798 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101798:	55                   	push   %ebp
80101799:	89 e5                	mov    %esp,%ebp
8010179b:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010179e:	8b 45 08             	mov    0x8(%ebp),%eax
801017a1:	8b 40 04             	mov    0x4(%eax),%eax
801017a4:	c1 e8 03             	shr    $0x3,%eax
801017a7:	89 c2                	mov    %eax,%edx
801017a9:	a1 74 1a 11 80       	mov    0x80111a74,%eax
801017ae:	01 c2                	add    %eax,%edx
801017b0:	8b 45 08             	mov    0x8(%ebp),%eax
801017b3:	8b 00                	mov    (%eax),%eax
801017b5:	89 54 24 04          	mov    %edx,0x4(%esp)
801017b9:	89 04 24             	mov    %eax,(%esp)
801017bc:	e8 f4 e9 ff ff       	call   801001b5 <bread>
801017c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c7:	8d 50 5c             	lea    0x5c(%eax),%edx
801017ca:	8b 45 08             	mov    0x8(%ebp),%eax
801017cd:	8b 40 04             	mov    0x4(%eax),%eax
801017d0:	83 e0 07             	and    $0x7,%eax
801017d3:	c1 e0 06             	shl    $0x6,%eax
801017d6:	01 d0                	add    %edx,%eax
801017d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801017db:	8b 45 08             	mov    0x8(%ebp),%eax
801017de:	0f b7 50 50          	movzwl 0x50(%eax),%edx
801017e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e5:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017e8:	8b 45 08             	mov    0x8(%ebp),%eax
801017eb:	0f b7 50 52          	movzwl 0x52(%eax),%edx
801017ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f2:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801017f6:	8b 45 08             	mov    0x8(%ebp),%eax
801017f9:	0f b7 50 54          	movzwl 0x54(%eax),%edx
801017fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101800:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101804:	8b 45 08             	mov    0x8(%ebp),%eax
80101807:	0f b7 50 56          	movzwl 0x56(%eax),%edx
8010180b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010180e:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101812:	8b 45 08             	mov    0x8(%ebp),%eax
80101815:	8b 50 58             	mov    0x58(%eax),%edx
80101818:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010181b:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010181e:	8b 45 08             	mov    0x8(%ebp),%eax
80101821:	8d 50 5c             	lea    0x5c(%eax),%edx
80101824:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101827:	83 c0 0c             	add    $0xc,%eax
8010182a:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101831:	00 
80101832:	89 54 24 04          	mov    %edx,0x4(%esp)
80101836:	89 04 24             	mov    %eax,(%esp)
80101839:	e8 c2 3a 00 00       	call   80105300 <memmove>
  log_write(bp);
8010183e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101841:	89 04 24             	mov    %eax,(%esp)
80101844:	e8 49 1e 00 00       	call   80103692 <log_write>
  brelse(bp);
80101849:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184c:	89 04 24             	mov    %eax,(%esp)
8010184f:	e8 d8 e9 ff ff       	call   8010022c <brelse>
}
80101854:	c9                   	leave  
80101855:	c3                   	ret    

80101856 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101856:	55                   	push   %ebp
80101857:	89 e5                	mov    %esp,%ebp
80101859:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010185c:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101863:	e8 57 37 00 00       	call   80104fbf <acquire>

  // Is the inode already cached?
  empty = 0;
80101868:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010186f:	c7 45 f4 b4 1a 11 80 	movl   $0x80111ab4,-0xc(%ebp)
80101876:	eb 5c                	jmp    801018d4 <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101878:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187b:	8b 40 08             	mov    0x8(%eax),%eax
8010187e:	85 c0                	test   %eax,%eax
80101880:	7e 35                	jle    801018b7 <iget+0x61>
80101882:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101885:	8b 00                	mov    (%eax),%eax
80101887:	3b 45 08             	cmp    0x8(%ebp),%eax
8010188a:	75 2b                	jne    801018b7 <iget+0x61>
8010188c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188f:	8b 40 04             	mov    0x4(%eax),%eax
80101892:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101895:	75 20                	jne    801018b7 <iget+0x61>
      ip->ref++;
80101897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010189a:	8b 40 08             	mov    0x8(%eax),%eax
8010189d:	8d 50 01             	lea    0x1(%eax),%edx
801018a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a3:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801018a6:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
801018ad:	e8 75 37 00 00       	call   80105027 <release>
      return ip;
801018b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b5:	eb 72                	jmp    80101929 <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018bb:	75 10                	jne    801018cd <iget+0x77>
801018bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c0:	8b 40 08             	mov    0x8(%eax),%eax
801018c3:	85 c0                	test   %eax,%eax
801018c5:	75 06                	jne    801018cd <iget+0x77>
      empty = ip;
801018c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018cd:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801018d4:	81 7d f4 d4 36 11 80 	cmpl   $0x801136d4,-0xc(%ebp)
801018db:	72 9b                	jb     80101878 <iget+0x22>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018e1:	75 0c                	jne    801018ef <iget+0x99>
    panic("iget: no inodes");
801018e3:	c7 04 24 f5 85 10 80 	movl   $0x801085f5,(%esp)
801018ea:	e8 73 ec ff ff       	call   80100562 <panic>

  ip = empty;
801018ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801018f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f8:	8b 55 08             	mov    0x8(%ebp),%edx
801018fb:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101900:	8b 55 0c             	mov    0xc(%ebp),%edx
80101903:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101909:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101910:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101913:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
8010191a:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101921:	e8 01 37 00 00       	call   80105027 <release>

  return ip;
80101926:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101929:	c9                   	leave  
8010192a:	c3                   	ret    

8010192b <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010192b:	55                   	push   %ebp
8010192c:	89 e5                	mov    %esp,%ebp
8010192e:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101931:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101938:	e8 82 36 00 00       	call   80104fbf <acquire>
  ip->ref++;
8010193d:	8b 45 08             	mov    0x8(%ebp),%eax
80101940:	8b 40 08             	mov    0x8(%eax),%eax
80101943:	8d 50 01             	lea    0x1(%eax),%edx
80101946:	8b 45 08             	mov    0x8(%ebp),%eax
80101949:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010194c:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101953:	e8 cf 36 00 00       	call   80105027 <release>
  return ip;
80101958:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010195b:	c9                   	leave  
8010195c:	c3                   	ret    

8010195d <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010195d:	55                   	push   %ebp
8010195e:	89 e5                	mov    %esp,%ebp
80101960:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101963:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101967:	74 0a                	je     80101973 <ilock+0x16>
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 40 08             	mov    0x8(%eax),%eax
8010196f:	85 c0                	test   %eax,%eax
80101971:	7f 0c                	jg     8010197f <ilock+0x22>
    panic("ilock");
80101973:	c7 04 24 05 86 10 80 	movl   $0x80108605,(%esp)
8010197a:	e8 e3 eb ff ff       	call   80100562 <panic>

  acquiresleep(&ip->lock);
8010197f:	8b 45 08             	mov    0x8(%ebp),%eax
80101982:	83 c0 0c             	add    $0xc,%eax
80101985:	89 04 24             	mov    %eax,(%esp)
80101988:	e8 e8 34 00 00       	call   80104e75 <acquiresleep>

  if(ip->valid == 0){
8010198d:	8b 45 08             	mov    0x8(%ebp),%eax
80101990:	8b 40 4c             	mov    0x4c(%eax),%eax
80101993:	85 c0                	test   %eax,%eax
80101995:	0f 85 cd 00 00 00    	jne    80101a68 <ilock+0x10b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010199b:	8b 45 08             	mov    0x8(%ebp),%eax
8010199e:	8b 40 04             	mov    0x4(%eax),%eax
801019a1:	c1 e8 03             	shr    $0x3,%eax
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	a1 74 1a 11 80       	mov    0x80111a74,%eax
801019ab:	01 c2                	add    %eax,%edx
801019ad:	8b 45 08             	mov    0x8(%ebp),%eax
801019b0:	8b 00                	mov    (%eax),%eax
801019b2:	89 54 24 04          	mov    %edx,0x4(%esp)
801019b6:	89 04 24             	mov    %eax,(%esp)
801019b9:	e8 f7 e7 ff ff       	call   801001b5 <bread>
801019be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c4:	8d 50 5c             	lea    0x5c(%eax),%edx
801019c7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ca:	8b 40 04             	mov    0x4(%eax),%eax
801019cd:	83 e0 07             	and    $0x7,%eax
801019d0:	c1 e0 06             	shl    $0x6,%eax
801019d3:	01 d0                	add    %edx,%eax
801019d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019db:	0f b7 10             	movzwl (%eax),%edx
801019de:	8b 45 08             	mov    0x8(%ebp),%eax
801019e1:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
801019e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019e8:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019ec:	8b 45 08             	mov    0x8(%ebp),%eax
801019ef:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
801019f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f6:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019fa:	8b 45 08             	mov    0x8(%ebp),%eax
801019fd:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a04:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a08:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0b:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a12:	8b 50 08             	mov    0x8(%eax),%edx
80101a15:	8b 45 08             	mov    0x8(%ebp),%eax
80101a18:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a1e:	8d 50 0c             	lea    0xc(%eax),%edx
80101a21:	8b 45 08             	mov    0x8(%ebp),%eax
80101a24:	83 c0 5c             	add    $0x5c,%eax
80101a27:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101a2e:	00 
80101a2f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a33:	89 04 24             	mov    %eax,(%esp)
80101a36:	e8 c5 38 00 00       	call   80105300 <memmove>
    brelse(bp);
80101a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a3e:	89 04 24             	mov    %eax,(%esp)
80101a41:	e8 e6 e7 ff ff       	call   8010022c <brelse>
    ip->valid = 1;
80101a46:	8b 45 08             	mov    0x8(%ebp),%eax
80101a49:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101a50:	8b 45 08             	mov    0x8(%ebp),%eax
80101a53:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101a57:	66 85 c0             	test   %ax,%ax
80101a5a:	75 0c                	jne    80101a68 <ilock+0x10b>
      panic("ilock: no type");
80101a5c:	c7 04 24 0b 86 10 80 	movl   $0x8010860b,(%esp)
80101a63:	e8 fa ea ff ff       	call   80100562 <panic>
  }
}
80101a68:	c9                   	leave  
80101a69:	c3                   	ret    

80101a6a <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a6a:	55                   	push   %ebp
80101a6b:	89 e5                	mov    %esp,%ebp
80101a6d:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a74:	74 1c                	je     80101a92 <iunlock+0x28>
80101a76:	8b 45 08             	mov    0x8(%ebp),%eax
80101a79:	83 c0 0c             	add    $0xc,%eax
80101a7c:	89 04 24             	mov    %eax,(%esp)
80101a7f:	e8 8e 34 00 00       	call   80104f12 <holdingsleep>
80101a84:	85 c0                	test   %eax,%eax
80101a86:	74 0a                	je     80101a92 <iunlock+0x28>
80101a88:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8b:	8b 40 08             	mov    0x8(%eax),%eax
80101a8e:	85 c0                	test   %eax,%eax
80101a90:	7f 0c                	jg     80101a9e <iunlock+0x34>
    panic("iunlock");
80101a92:	c7 04 24 1a 86 10 80 	movl   $0x8010861a,(%esp)
80101a99:	e8 c4 ea ff ff       	call   80100562 <panic>

  releasesleep(&ip->lock);
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	83 c0 0c             	add    $0xc,%eax
80101aa4:	89 04 24             	mov    %eax,(%esp)
80101aa7:	e8 24 34 00 00       	call   80104ed0 <releasesleep>
}
80101aac:	c9                   	leave  
80101aad:	c3                   	ret    

80101aae <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101aae:	55                   	push   %ebp
80101aaf:	89 e5                	mov    %esp,%ebp
80101ab1:	83 ec 28             	sub    $0x28,%esp
  acquiresleep(&ip->lock);
80101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab7:	83 c0 0c             	add    $0xc,%eax
80101aba:	89 04 24             	mov    %eax,(%esp)
80101abd:	e8 b3 33 00 00       	call   80104e75 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac5:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ac8:	85 c0                	test   %eax,%eax
80101aca:	74 5c                	je     80101b28 <iput+0x7a>
80101acc:	8b 45 08             	mov    0x8(%ebp),%eax
80101acf:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101ad3:	66 85 c0             	test   %ax,%ax
80101ad6:	75 50                	jne    80101b28 <iput+0x7a>
    acquire(&icache.lock);
80101ad8:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101adf:	e8 db 34 00 00       	call   80104fbf <acquire>
    int r = ip->ref;
80101ae4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae7:	8b 40 08             	mov    0x8(%eax),%eax
80101aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101aed:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101af4:	e8 2e 35 00 00       	call   80105027 <release>
    if(r == 1){
80101af9:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101afd:	75 29                	jne    80101b28 <iput+0x7a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101aff:	8b 45 08             	mov    0x8(%ebp),%eax
80101b02:	89 04 24             	mov    %eax,(%esp)
80101b05:	e8 86 01 00 00       	call   80101c90 <itrunc>
      ip->type = 0;
80101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0d:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101b13:	8b 45 08             	mov    0x8(%ebp),%eax
80101b16:	89 04 24             	mov    %eax,(%esp)
80101b19:	e8 7a fc ff ff       	call   80101798 <iupdate>
      ip->valid = 0;
80101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b21:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101b28:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2b:	83 c0 0c             	add    $0xc,%eax
80101b2e:	89 04 24             	mov    %eax,(%esp)
80101b31:	e8 9a 33 00 00       	call   80104ed0 <releasesleep>

  acquire(&icache.lock);
80101b36:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101b3d:	e8 7d 34 00 00       	call   80104fbf <acquire>
  ip->ref--;
80101b42:	8b 45 08             	mov    0x8(%ebp),%eax
80101b45:	8b 40 08             	mov    0x8(%eax),%eax
80101b48:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4e:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b51:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101b58:	e8 ca 34 00 00       	call   80105027 <release>
}
80101b5d:	c9                   	leave  
80101b5e:	c3                   	ret    

80101b5f <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b5f:	55                   	push   %ebp
80101b60:	89 e5                	mov    %esp,%ebp
80101b62:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b65:	8b 45 08             	mov    0x8(%ebp),%eax
80101b68:	89 04 24             	mov    %eax,(%esp)
80101b6b:	e8 fa fe ff ff       	call   80101a6a <iunlock>
  iput(ip);
80101b70:	8b 45 08             	mov    0x8(%ebp),%eax
80101b73:	89 04 24             	mov    %eax,(%esp)
80101b76:	e8 33 ff ff ff       	call   80101aae <iput>
}
80101b7b:	c9                   	leave  
80101b7c:	c3                   	ret    

80101b7d <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b7d:	55                   	push   %ebp
80101b7e:	89 e5                	mov    %esp,%ebp
80101b80:	53                   	push   %ebx
80101b81:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b84:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b88:	77 3e                	ja     80101bc8 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b90:	83 c2 14             	add    $0x14,%edx
80101b93:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b9e:	75 20                	jne    80101bc0 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101ba0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba3:	8b 00                	mov    (%eax),%eax
80101ba5:	89 04 24             	mov    %eax,(%esp)
80101ba8:	e8 3a f8 ff ff       	call   801013e7 <balloc>
80101bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bb6:	8d 4a 14             	lea    0x14(%edx),%ecx
80101bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bbc:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bc3:	e9 c2 00 00 00       	jmp    80101c8a <bmap+0x10d>
  }
  bn -= NDIRECT;
80101bc8:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bcc:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bd0:	0f 87 a8 00 00 00    	ja     80101c7e <bmap+0x101>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd9:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101be2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101be6:	75 1c                	jne    80101c04 <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101be8:	8b 45 08             	mov    0x8(%ebp),%eax
80101beb:	8b 00                	mov    (%eax),%eax
80101bed:	89 04 24             	mov    %eax,(%esp)
80101bf0:	e8 f2 f7 ff ff       	call   801013e7 <balloc>
80101bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bfe:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101c04:	8b 45 08             	mov    0x8(%ebp),%eax
80101c07:	8b 00                	mov    (%eax),%eax
80101c09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c0c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c10:	89 04 24             	mov    %eax,(%esp)
80101c13:	e8 9d e5 ff ff       	call   801001b5 <bread>
80101c18:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c1e:	83 c0 5c             	add    $0x5c,%eax
80101c21:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c24:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c31:	01 d0                	add    %edx,%eax
80101c33:	8b 00                	mov    (%eax),%eax
80101c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c3c:	75 30                	jne    80101c6e <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
80101c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c4b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c51:	8b 00                	mov    (%eax),%eax
80101c53:	89 04 24             	mov    %eax,(%esp)
80101c56:	e8 8c f7 ff ff       	call   801013e7 <balloc>
80101c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c61:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c66:	89 04 24             	mov    %eax,(%esp)
80101c69:	e8 24 1a 00 00       	call   80103692 <log_write>
    }
    brelse(bp);
80101c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c71:	89 04 24             	mov    %eax,(%esp)
80101c74:	e8 b3 e5 ff ff       	call   8010022c <brelse>
    return addr;
80101c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c7c:	eb 0c                	jmp    80101c8a <bmap+0x10d>
  }

  panic("bmap: out of range");
80101c7e:	c7 04 24 22 86 10 80 	movl   $0x80108622,(%esp)
80101c85:	e8 d8 e8 ff ff       	call   80100562 <panic>
}
80101c8a:	83 c4 24             	add    $0x24,%esp
80101c8d:	5b                   	pop    %ebx
80101c8e:	5d                   	pop    %ebp
80101c8f:	c3                   	ret    

80101c90 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c9d:	eb 44                	jmp    80101ce3 <itrunc+0x53>
    if(ip->addrs[i]){
80101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ca5:	83 c2 14             	add    $0x14,%edx
80101ca8:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cac:	85 c0                	test   %eax,%eax
80101cae:	74 2f                	je     80101cdf <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101cb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cb6:	83 c2 14             	add    $0x14,%edx
80101cb9:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc0:	8b 00                	mov    (%eax),%eax
80101cc2:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cc6:	89 04 24             	mov    %eax,(%esp)
80101cc9:	e8 57 f8 ff ff       	call   80101525 <bfree>
      ip->addrs[i] = 0;
80101cce:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cd4:	83 c2 14             	add    $0x14,%edx
80101cd7:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101cde:	00 
  for(i = 0; i < NDIRECT; i++){
80101cdf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101ce3:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101ce7:	7e b6                	jle    80101c9f <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
80101ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cec:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101cf2:	85 c0                	test   %eax,%eax
80101cf4:	0f 84 a4 00 00 00    	je     80101d9e <itrunc+0x10e>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfd:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101d03:	8b 45 08             	mov    0x8(%ebp),%eax
80101d06:	8b 00                	mov    (%eax),%eax
80101d08:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d0c:	89 04 24             	mov    %eax,(%esp)
80101d0f:	e8 a1 e4 ff ff       	call   801001b5 <bread>
80101d14:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d1a:	83 c0 5c             	add    $0x5c,%eax
80101d1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d20:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d27:	eb 3b                	jmp    80101d64 <itrunc+0xd4>
      if(a[j])
80101d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d33:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d36:	01 d0                	add    %edx,%eax
80101d38:	8b 00                	mov    (%eax),%eax
80101d3a:	85 c0                	test   %eax,%eax
80101d3c:	74 22                	je     80101d60 <itrunc+0xd0>
        bfree(ip->dev, a[j]);
80101d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d48:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d4b:	01 d0                	add    %edx,%eax
80101d4d:	8b 10                	mov    (%eax),%edx
80101d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d52:	8b 00                	mov    (%eax),%eax
80101d54:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d58:	89 04 24             	mov    %eax,(%esp)
80101d5b:	e8 c5 f7 ff ff       	call   80101525 <bfree>
    for(j = 0; j < NINDIRECT; j++){
80101d60:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d67:	83 f8 7f             	cmp    $0x7f,%eax
80101d6a:	76 bd                	jbe    80101d29 <itrunc+0x99>
    }
    brelse(bp);
80101d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d6f:	89 04 24             	mov    %eax,(%esp)
80101d72:	e8 b5 e4 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d77:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7a:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101d80:	8b 45 08             	mov    0x8(%ebp),%eax
80101d83:	8b 00                	mov    (%eax),%eax
80101d85:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d89:	89 04 24             	mov    %eax,(%esp)
80101d8c:	e8 94 f7 ff ff       	call   80101525 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d91:	8b 45 08             	mov    0x8(%ebp),%eax
80101d94:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101d9b:	00 00 00 
  }

  ip->size = 0;
80101d9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101da1:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101da8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dab:	89 04 24             	mov    %eax,(%esp)
80101dae:	e8 e5 f9 ff ff       	call   80101798 <iupdate>
}
80101db3:	c9                   	leave  
80101db4:	c3                   	ret    

80101db5 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101db5:	55                   	push   %ebp
80101db6:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101db8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbb:	8b 00                	mov    (%eax),%eax
80101dbd:	89 c2                	mov    %eax,%edx
80101dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dc2:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101dc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc8:	8b 50 04             	mov    0x4(%eax),%edx
80101dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dce:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd4:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ddb:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101dde:	8b 45 08             	mov    0x8(%ebp),%eax
80101de1:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101de5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101de8:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101dec:	8b 45 08             	mov    0x8(%ebp),%eax
80101def:	8b 50 58             	mov    0x58(%eax),%edx
80101df2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101df5:	89 50 10             	mov    %edx,0x10(%eax)
}
80101df8:	5d                   	pop    %ebp
80101df9:	c3                   	ret    

80101dfa <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101dfa:	55                   	push   %ebp
80101dfb:	89 e5                	mov    %esp,%ebp
80101dfd:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e00:	8b 45 08             	mov    0x8(%ebp),%eax
80101e03:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101e07:	66 83 f8 03          	cmp    $0x3,%ax
80101e0b:	75 60                	jne    80101e6d <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e10:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101e14:	66 85 c0             	test   %ax,%ax
80101e17:	78 20                	js     80101e39 <readi+0x3f>
80101e19:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1c:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101e20:	66 83 f8 09          	cmp    $0x9,%ax
80101e24:	7f 13                	jg     80101e39 <readi+0x3f>
80101e26:	8b 45 08             	mov    0x8(%ebp),%eax
80101e29:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101e2d:	98                   	cwtl   
80101e2e:	8b 04 c5 00 1a 11 80 	mov    -0x7feee600(,%eax,8),%eax
80101e35:	85 c0                	test   %eax,%eax
80101e37:	75 0a                	jne    80101e43 <readi+0x49>
      return -1;
80101e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e3e:	e9 19 01 00 00       	jmp    80101f5c <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101e43:	8b 45 08             	mov    0x8(%ebp),%eax
80101e46:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101e4a:	98                   	cwtl   
80101e4b:	8b 04 c5 00 1a 11 80 	mov    -0x7feee600(,%eax,8),%eax
80101e52:	8b 55 14             	mov    0x14(%ebp),%edx
80101e55:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e59:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e5c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e60:	8b 55 08             	mov    0x8(%ebp),%edx
80101e63:	89 14 24             	mov    %edx,(%esp)
80101e66:	ff d0                	call   *%eax
80101e68:	e9 ef 00 00 00       	jmp    80101f5c <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101e6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e70:	8b 40 58             	mov    0x58(%eax),%eax
80101e73:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e76:	72 0d                	jb     80101e85 <readi+0x8b>
80101e78:	8b 45 14             	mov    0x14(%ebp),%eax
80101e7b:	8b 55 10             	mov    0x10(%ebp),%edx
80101e7e:	01 d0                	add    %edx,%eax
80101e80:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e83:	73 0a                	jae    80101e8f <readi+0x95>
    return -1;
80101e85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e8a:	e9 cd 00 00 00       	jmp    80101f5c <readi+0x162>
  if(off + n > ip->size)
80101e8f:	8b 45 14             	mov    0x14(%ebp),%eax
80101e92:	8b 55 10             	mov    0x10(%ebp),%edx
80101e95:	01 c2                	add    %eax,%edx
80101e97:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9a:	8b 40 58             	mov    0x58(%eax),%eax
80101e9d:	39 c2                	cmp    %eax,%edx
80101e9f:	76 0c                	jbe    80101ead <readi+0xb3>
    n = ip->size - off;
80101ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea4:	8b 40 58             	mov    0x58(%eax),%eax
80101ea7:	2b 45 10             	sub    0x10(%ebp),%eax
80101eaa:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ead:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101eb4:	e9 94 00 00 00       	jmp    80101f4d <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101eb9:	8b 45 10             	mov    0x10(%ebp),%eax
80101ebc:	c1 e8 09             	shr    $0x9,%eax
80101ebf:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec6:	89 04 24             	mov    %eax,(%esp)
80101ec9:	e8 af fc ff ff       	call   80101b7d <bmap>
80101ece:	8b 55 08             	mov    0x8(%ebp),%edx
80101ed1:	8b 12                	mov    (%edx),%edx
80101ed3:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ed7:	89 14 24             	mov    %edx,(%esp)
80101eda:	e8 d6 e2 ff ff       	call   801001b5 <bread>
80101edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ee2:	8b 45 10             	mov    0x10(%ebp),%eax
80101ee5:	25 ff 01 00 00       	and    $0x1ff,%eax
80101eea:	89 c2                	mov    %eax,%edx
80101eec:	b8 00 02 00 00       	mov    $0x200,%eax
80101ef1:	29 d0                	sub    %edx,%eax
80101ef3:	89 c2                	mov    %eax,%edx
80101ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ef8:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101efb:	29 c1                	sub    %eax,%ecx
80101efd:	89 c8                	mov    %ecx,%eax
80101eff:	39 c2                	cmp    %eax,%edx
80101f01:	0f 46 c2             	cmovbe %edx,%eax
80101f04:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f07:	8b 45 10             	mov    0x10(%ebp),%eax
80101f0a:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f0f:	8d 50 50             	lea    0x50(%eax),%edx
80101f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f15:	01 d0                	add    %edx,%eax
80101f17:	8d 50 0c             	lea    0xc(%eax),%edx
80101f1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f1d:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f21:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f25:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f28:	89 04 24             	mov    %eax,(%esp)
80101f2b:	e8 d0 33 00 00       	call   80105300 <memmove>
    brelse(bp);
80101f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f33:	89 04 24             	mov    %eax,(%esp)
80101f36:	e8 f1 e2 ff ff       	call   8010022c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f3e:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f44:	01 45 10             	add    %eax,0x10(%ebp)
80101f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f4a:	01 45 0c             	add    %eax,0xc(%ebp)
80101f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f50:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f53:	0f 82 60 ff ff ff    	jb     80101eb9 <readi+0xbf>
  }
  return n;
80101f59:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f5c:	c9                   	leave  
80101f5d:	c3                   	ret    

80101f5e <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f5e:	55                   	push   %ebp
80101f5f:	89 e5                	mov    %esp,%ebp
80101f61:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f64:	8b 45 08             	mov    0x8(%ebp),%eax
80101f67:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101f6b:	66 83 f8 03          	cmp    $0x3,%ax
80101f6f:	75 60                	jne    80101fd1 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f71:	8b 45 08             	mov    0x8(%ebp),%eax
80101f74:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f78:	66 85 c0             	test   %ax,%ax
80101f7b:	78 20                	js     80101f9d <writei+0x3f>
80101f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f80:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f84:	66 83 f8 09          	cmp    $0x9,%ax
80101f88:	7f 13                	jg     80101f9d <writei+0x3f>
80101f8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f91:	98                   	cwtl   
80101f92:	8b 04 c5 04 1a 11 80 	mov    -0x7feee5fc(,%eax,8),%eax
80101f99:	85 c0                	test   %eax,%eax
80101f9b:	75 0a                	jne    80101fa7 <writei+0x49>
      return -1;
80101f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fa2:	e9 44 01 00 00       	jmp    801020eb <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80101faa:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101fae:	98                   	cwtl   
80101faf:	8b 04 c5 04 1a 11 80 	mov    -0x7feee5fc(,%eax,8),%eax
80101fb6:	8b 55 14             	mov    0x14(%ebp),%edx
80101fb9:	89 54 24 08          	mov    %edx,0x8(%esp)
80101fbd:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fc0:	89 54 24 04          	mov    %edx,0x4(%esp)
80101fc4:	8b 55 08             	mov    0x8(%ebp),%edx
80101fc7:	89 14 24             	mov    %edx,(%esp)
80101fca:	ff d0                	call   *%eax
80101fcc:	e9 1a 01 00 00       	jmp    801020eb <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101fd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd4:	8b 40 58             	mov    0x58(%eax),%eax
80101fd7:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fda:	72 0d                	jb     80101fe9 <writei+0x8b>
80101fdc:	8b 45 14             	mov    0x14(%ebp),%eax
80101fdf:	8b 55 10             	mov    0x10(%ebp),%edx
80101fe2:	01 d0                	add    %edx,%eax
80101fe4:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fe7:	73 0a                	jae    80101ff3 <writei+0x95>
    return -1;
80101fe9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fee:	e9 f8 00 00 00       	jmp    801020eb <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101ff3:	8b 45 14             	mov    0x14(%ebp),%eax
80101ff6:	8b 55 10             	mov    0x10(%ebp),%edx
80101ff9:	01 d0                	add    %edx,%eax
80101ffb:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102000:	76 0a                	jbe    8010200c <writei+0xae>
    return -1;
80102002:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102007:	e9 df 00 00 00       	jmp    801020eb <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010200c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102013:	e9 9f 00 00 00       	jmp    801020b7 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102018:	8b 45 10             	mov    0x10(%ebp),%eax
8010201b:	c1 e8 09             	shr    $0x9,%eax
8010201e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102022:	8b 45 08             	mov    0x8(%ebp),%eax
80102025:	89 04 24             	mov    %eax,(%esp)
80102028:	e8 50 fb ff ff       	call   80101b7d <bmap>
8010202d:	8b 55 08             	mov    0x8(%ebp),%edx
80102030:	8b 12                	mov    (%edx),%edx
80102032:	89 44 24 04          	mov    %eax,0x4(%esp)
80102036:	89 14 24             	mov    %edx,(%esp)
80102039:	e8 77 e1 ff ff       	call   801001b5 <bread>
8010203e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102041:	8b 45 10             	mov    0x10(%ebp),%eax
80102044:	25 ff 01 00 00       	and    $0x1ff,%eax
80102049:	89 c2                	mov    %eax,%edx
8010204b:	b8 00 02 00 00       	mov    $0x200,%eax
80102050:	29 d0                	sub    %edx,%eax
80102052:	89 c2                	mov    %eax,%edx
80102054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102057:	8b 4d 14             	mov    0x14(%ebp),%ecx
8010205a:	29 c1                	sub    %eax,%ecx
8010205c:	89 c8                	mov    %ecx,%eax
8010205e:	39 c2                	cmp    %eax,%edx
80102060:	0f 46 c2             	cmovbe %edx,%eax
80102063:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102066:	8b 45 10             	mov    0x10(%ebp),%eax
80102069:	25 ff 01 00 00       	and    $0x1ff,%eax
8010206e:	8d 50 50             	lea    0x50(%eax),%edx
80102071:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102074:	01 d0                	add    %edx,%eax
80102076:	8d 50 0c             	lea    0xc(%eax),%edx
80102079:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010207c:	89 44 24 08          	mov    %eax,0x8(%esp)
80102080:	8b 45 0c             	mov    0xc(%ebp),%eax
80102083:	89 44 24 04          	mov    %eax,0x4(%esp)
80102087:	89 14 24             	mov    %edx,(%esp)
8010208a:	e8 71 32 00 00       	call   80105300 <memmove>
    log_write(bp);
8010208f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102092:	89 04 24             	mov    %eax,(%esp)
80102095:	e8 f8 15 00 00       	call   80103692 <log_write>
    brelse(bp);
8010209a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010209d:	89 04 24             	mov    %eax,(%esp)
801020a0:	e8 87 e1 ff ff       	call   8010022c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020a8:	01 45 f4             	add    %eax,-0xc(%ebp)
801020ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020ae:	01 45 10             	add    %eax,0x10(%ebp)
801020b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020b4:	01 45 0c             	add    %eax,0xc(%ebp)
801020b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020ba:	3b 45 14             	cmp    0x14(%ebp),%eax
801020bd:	0f 82 55 ff ff ff    	jb     80102018 <writei+0xba>
  }

  if(n > 0 && off > ip->size){
801020c3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801020c7:	74 1f                	je     801020e8 <writei+0x18a>
801020c9:	8b 45 08             	mov    0x8(%ebp),%eax
801020cc:	8b 40 58             	mov    0x58(%eax),%eax
801020cf:	3b 45 10             	cmp    0x10(%ebp),%eax
801020d2:	73 14                	jae    801020e8 <writei+0x18a>
    ip->size = off;
801020d4:	8b 45 08             	mov    0x8(%ebp),%eax
801020d7:	8b 55 10             	mov    0x10(%ebp),%edx
801020da:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801020dd:	8b 45 08             	mov    0x8(%ebp),%eax
801020e0:	89 04 24             	mov    %eax,(%esp)
801020e3:	e8 b0 f6 ff ff       	call   80101798 <iupdate>
  }
  return n;
801020e8:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020eb:	c9                   	leave  
801020ec:	c3                   	ret    

801020ed <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020ed:	55                   	push   %ebp
801020ee:	89 e5                	mov    %esp,%ebp
801020f0:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801020f3:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020fa:	00 
801020fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801020fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102102:	8b 45 08             	mov    0x8(%ebp),%eax
80102105:	89 04 24             	mov    %eax,(%esp)
80102108:	e8 96 32 00 00       	call   801053a3 <strncmp>
}
8010210d:	c9                   	leave  
8010210e:	c3                   	ret    

8010210f <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010210f:	55                   	push   %ebp
80102110:	89 e5                	mov    %esp,%ebp
80102112:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102115:	8b 45 08             	mov    0x8(%ebp),%eax
80102118:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010211c:	66 83 f8 01          	cmp    $0x1,%ax
80102120:	74 0c                	je     8010212e <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102122:	c7 04 24 35 86 10 80 	movl   $0x80108635,(%esp)
80102129:	e8 34 e4 ff ff       	call   80100562 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010212e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102135:	e9 88 00 00 00       	jmp    801021c2 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010213a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102141:	00 
80102142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102145:	89 44 24 08          	mov    %eax,0x8(%esp)
80102149:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010214c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102150:	8b 45 08             	mov    0x8(%ebp),%eax
80102153:	89 04 24             	mov    %eax,(%esp)
80102156:	e8 9f fc ff ff       	call   80101dfa <readi>
8010215b:	83 f8 10             	cmp    $0x10,%eax
8010215e:	74 0c                	je     8010216c <dirlookup+0x5d>
      panic("dirlookup read");
80102160:	c7 04 24 47 86 10 80 	movl   $0x80108647,(%esp)
80102167:	e8 f6 e3 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
8010216c:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102170:	66 85 c0             	test   %ax,%ax
80102173:	75 02                	jne    80102177 <dirlookup+0x68>
      continue;
80102175:	eb 47                	jmp    801021be <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
80102177:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010217a:	83 c0 02             	add    $0x2,%eax
8010217d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102181:	8b 45 0c             	mov    0xc(%ebp),%eax
80102184:	89 04 24             	mov    %eax,(%esp)
80102187:	e8 61 ff ff ff       	call   801020ed <namecmp>
8010218c:	85 c0                	test   %eax,%eax
8010218e:	75 2e                	jne    801021be <dirlookup+0xaf>
      // entry matches path element
      if(poff)
80102190:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102194:	74 08                	je     8010219e <dirlookup+0x8f>
        *poff = off;
80102196:	8b 45 10             	mov    0x10(%ebp),%eax
80102199:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010219c:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010219e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021a2:	0f b7 c0             	movzwl %ax,%eax
801021a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801021a8:	8b 45 08             	mov    0x8(%ebp),%eax
801021ab:	8b 00                	mov    (%eax),%eax
801021ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
801021b0:	89 54 24 04          	mov    %edx,0x4(%esp)
801021b4:	89 04 24             	mov    %eax,(%esp)
801021b7:	e8 9a f6 ff ff       	call   80101856 <iget>
801021bc:	eb 18                	jmp    801021d6 <dirlookup+0xc7>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021be:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801021c2:	8b 45 08             	mov    0x8(%ebp),%eax
801021c5:	8b 40 58             	mov    0x58(%eax),%eax
801021c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801021cb:	0f 87 69 ff ff ff    	ja     8010213a <dirlookup+0x2b>
    }
  }

  return 0;
801021d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801021d6:	c9                   	leave  
801021d7:	c3                   	ret    

801021d8 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021d8:	55                   	push   %ebp
801021d9:	89 e5                	mov    %esp,%ebp
801021db:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801021e5:	00 
801021e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801021e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801021ed:	8b 45 08             	mov    0x8(%ebp),%eax
801021f0:	89 04 24             	mov    %eax,(%esp)
801021f3:	e8 17 ff ff ff       	call   8010210f <dirlookup>
801021f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801021ff:	74 15                	je     80102216 <dirlink+0x3e>
    iput(ip);
80102201:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102204:	89 04 24             	mov    %eax,(%esp)
80102207:	e8 a2 f8 ff ff       	call   80101aae <iput>
    return -1;
8010220c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102211:	e9 b7 00 00 00       	jmp    801022cd <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102216:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010221d:	eb 46                	jmp    80102265 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102222:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102229:	00 
8010222a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010222e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102231:	89 44 24 04          	mov    %eax,0x4(%esp)
80102235:	8b 45 08             	mov    0x8(%ebp),%eax
80102238:	89 04 24             	mov    %eax,(%esp)
8010223b:	e8 ba fb ff ff       	call   80101dfa <readi>
80102240:	83 f8 10             	cmp    $0x10,%eax
80102243:	74 0c                	je     80102251 <dirlink+0x79>
      panic("dirlink read");
80102245:	c7 04 24 56 86 10 80 	movl   $0x80108656,(%esp)
8010224c:	e8 11 e3 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
80102251:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102255:	66 85 c0             	test   %ax,%ax
80102258:	75 02                	jne    8010225c <dirlink+0x84>
      break;
8010225a:	eb 16                	jmp    80102272 <dirlink+0x9a>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010225f:	83 c0 10             	add    $0x10,%eax
80102262:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102265:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102268:	8b 45 08             	mov    0x8(%ebp),%eax
8010226b:	8b 40 58             	mov    0x58(%eax),%eax
8010226e:	39 c2                	cmp    %eax,%edx
80102270:	72 ad                	jb     8010221f <dirlink+0x47>
  }

  strncpy(de.name, name, DIRSIZ);
80102272:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102279:	00 
8010227a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010227d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102281:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102284:	83 c0 02             	add    $0x2,%eax
80102287:	89 04 24             	mov    %eax,(%esp)
8010228a:	e8 6a 31 00 00       	call   801053f9 <strncpy>
  de.inum = inum;
8010228f:	8b 45 10             	mov    0x10(%ebp),%eax
80102292:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102299:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801022a0:	00 
801022a1:	89 44 24 08          	mov    %eax,0x8(%esp)
801022a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801022ac:	8b 45 08             	mov    0x8(%ebp),%eax
801022af:	89 04 24             	mov    %eax,(%esp)
801022b2:	e8 a7 fc ff ff       	call   80101f5e <writei>
801022b7:	83 f8 10             	cmp    $0x10,%eax
801022ba:	74 0c                	je     801022c8 <dirlink+0xf0>
    panic("dirlink");
801022bc:	c7 04 24 63 86 10 80 	movl   $0x80108663,(%esp)
801022c3:	e8 9a e2 ff ff       	call   80100562 <panic>

  return 0;
801022c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022cd:	c9                   	leave  
801022ce:	c3                   	ret    

801022cf <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022cf:	55                   	push   %ebp
801022d0:	89 e5                	mov    %esp,%ebp
801022d2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
801022d5:	eb 04                	jmp    801022db <skipelem+0xc>
    path++;
801022d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801022db:	8b 45 08             	mov    0x8(%ebp),%eax
801022de:	0f b6 00             	movzbl (%eax),%eax
801022e1:	3c 2f                	cmp    $0x2f,%al
801022e3:	74 f2                	je     801022d7 <skipelem+0x8>
  if(*path == 0)
801022e5:	8b 45 08             	mov    0x8(%ebp),%eax
801022e8:	0f b6 00             	movzbl (%eax),%eax
801022eb:	84 c0                	test   %al,%al
801022ed:	75 0a                	jne    801022f9 <skipelem+0x2a>
    return 0;
801022ef:	b8 00 00 00 00       	mov    $0x0,%eax
801022f4:	e9 86 00 00 00       	jmp    8010237f <skipelem+0xb0>
  s = path;
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
801022fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022ff:	eb 04                	jmp    80102305 <skipelem+0x36>
    path++;
80102301:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
80102305:	8b 45 08             	mov    0x8(%ebp),%eax
80102308:	0f b6 00             	movzbl (%eax),%eax
8010230b:	3c 2f                	cmp    $0x2f,%al
8010230d:	74 0a                	je     80102319 <skipelem+0x4a>
8010230f:	8b 45 08             	mov    0x8(%ebp),%eax
80102312:	0f b6 00             	movzbl (%eax),%eax
80102315:	84 c0                	test   %al,%al
80102317:	75 e8                	jne    80102301 <skipelem+0x32>
  len = path - s;
80102319:	8b 55 08             	mov    0x8(%ebp),%edx
8010231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010231f:	29 c2                	sub    %eax,%edx
80102321:	89 d0                	mov    %edx,%eax
80102323:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102326:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010232a:	7e 1c                	jle    80102348 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
8010232c:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102333:	00 
80102334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102337:	89 44 24 04          	mov    %eax,0x4(%esp)
8010233b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010233e:	89 04 24             	mov    %eax,(%esp)
80102341:	e8 ba 2f 00 00       	call   80105300 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102346:	eb 2a                	jmp    80102372 <skipelem+0xa3>
    memmove(name, s, len);
80102348:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010234b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102352:	89 44 24 04          	mov    %eax,0x4(%esp)
80102356:	8b 45 0c             	mov    0xc(%ebp),%eax
80102359:	89 04 24             	mov    %eax,(%esp)
8010235c:	e8 9f 2f 00 00       	call   80105300 <memmove>
    name[len] = 0;
80102361:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102364:	8b 45 0c             	mov    0xc(%ebp),%eax
80102367:	01 d0                	add    %edx,%eax
80102369:	c6 00 00             	movb   $0x0,(%eax)
  while(*path == '/')
8010236c:	eb 04                	jmp    80102372 <skipelem+0xa3>
    path++;
8010236e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102372:	8b 45 08             	mov    0x8(%ebp),%eax
80102375:	0f b6 00             	movzbl (%eax),%eax
80102378:	3c 2f                	cmp    $0x2f,%al
8010237a:	74 f2                	je     8010236e <skipelem+0x9f>
  return path;
8010237c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010237f:	c9                   	leave  
80102380:	c3                   	ret    

80102381 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102381:	55                   	push   %ebp
80102382:	89 e5                	mov    %esp,%ebp
80102384:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102387:	8b 45 08             	mov    0x8(%ebp),%eax
8010238a:	0f b6 00             	movzbl (%eax),%eax
8010238d:	3c 2f                	cmp    $0x2f,%al
8010238f:	75 1c                	jne    801023ad <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102391:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102398:	00 
80102399:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801023a0:	e8 b1 f4 ff ff       	call   80101856 <iget>
801023a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
801023a8:	e9 ae 00 00 00       	jmp    8010245b <namex+0xda>
    ip = idup(myproc()->cwd);
801023ad:	e8 fc 1e 00 00       	call   801042ae <myproc>
801023b2:	8b 40 68             	mov    0x68(%eax),%eax
801023b5:	89 04 24             	mov    %eax,(%esp)
801023b8:	e8 6e f5 ff ff       	call   8010192b <idup>
801023bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801023c0:	e9 96 00 00 00       	jmp    8010245b <namex+0xda>
    ilock(ip);
801023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c8:	89 04 24             	mov    %eax,(%esp)
801023cb:	e8 8d f5 ff ff       	call   8010195d <ilock>
    if(ip->type != T_DIR){
801023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d3:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801023d7:	66 83 f8 01          	cmp    $0x1,%ax
801023db:	74 15                	je     801023f2 <namex+0x71>
      iunlockput(ip);
801023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e0:	89 04 24             	mov    %eax,(%esp)
801023e3:	e8 77 f7 ff ff       	call   80101b5f <iunlockput>
      return 0;
801023e8:	b8 00 00 00 00       	mov    $0x0,%eax
801023ed:	e9 a3 00 00 00       	jmp    80102495 <namex+0x114>
    }
    if(nameiparent && *path == '\0'){
801023f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023f6:	74 1d                	je     80102415 <namex+0x94>
801023f8:	8b 45 08             	mov    0x8(%ebp),%eax
801023fb:	0f b6 00             	movzbl (%eax),%eax
801023fe:	84 c0                	test   %al,%al
80102400:	75 13                	jne    80102415 <namex+0x94>
      // Stop one level early.
      iunlock(ip);
80102402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102405:	89 04 24             	mov    %eax,(%esp)
80102408:	e8 5d f6 ff ff       	call   80101a6a <iunlock>
      return ip;
8010240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102410:	e9 80 00 00 00       	jmp    80102495 <namex+0x114>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102415:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010241c:	00 
8010241d:	8b 45 10             	mov    0x10(%ebp),%eax
80102420:	89 44 24 04          	mov    %eax,0x4(%esp)
80102424:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102427:	89 04 24             	mov    %eax,(%esp)
8010242a:	e8 e0 fc ff ff       	call   8010210f <dirlookup>
8010242f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102432:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102436:	75 12                	jne    8010244a <namex+0xc9>
      iunlockput(ip);
80102438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010243b:	89 04 24             	mov    %eax,(%esp)
8010243e:	e8 1c f7 ff ff       	call   80101b5f <iunlockput>
      return 0;
80102443:	b8 00 00 00 00       	mov    $0x0,%eax
80102448:	eb 4b                	jmp    80102495 <namex+0x114>
    }
    iunlockput(ip);
8010244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010244d:	89 04 24             	mov    %eax,(%esp)
80102450:	e8 0a f7 ff ff       	call   80101b5f <iunlockput>
    ip = next;
80102455:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102458:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
8010245b:	8b 45 10             	mov    0x10(%ebp),%eax
8010245e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102462:	8b 45 08             	mov    0x8(%ebp),%eax
80102465:	89 04 24             	mov    %eax,(%esp)
80102468:	e8 62 fe ff ff       	call   801022cf <skipelem>
8010246d:	89 45 08             	mov    %eax,0x8(%ebp)
80102470:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102474:	0f 85 4b ff ff ff    	jne    801023c5 <namex+0x44>
  }
  if(nameiparent){
8010247a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010247e:	74 12                	je     80102492 <namex+0x111>
    iput(ip);
80102480:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102483:	89 04 24             	mov    %eax,(%esp)
80102486:	e8 23 f6 ff ff       	call   80101aae <iput>
    return 0;
8010248b:	b8 00 00 00 00       	mov    $0x0,%eax
80102490:	eb 03                	jmp    80102495 <namex+0x114>
  }
  return ip;
80102492:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102495:	c9                   	leave  
80102496:	c3                   	ret    

80102497 <namei>:

struct inode*
namei(char *path)
{
80102497:	55                   	push   %ebp
80102498:	89 e5                	mov    %esp,%ebp
8010249a:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010249d:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024a0:	89 44 24 08          	mov    %eax,0x8(%esp)
801024a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801024ab:	00 
801024ac:	8b 45 08             	mov    0x8(%ebp),%eax
801024af:	89 04 24             	mov    %eax,(%esp)
801024b2:	e8 ca fe ff ff       	call   80102381 <namex>
}
801024b7:	c9                   	leave  
801024b8:	c3                   	ret    

801024b9 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024b9:	55                   	push   %ebp
801024ba:	89 e5                	mov    %esp,%ebp
801024bc:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
801024bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801024c2:	89 44 24 08          	mov    %eax,0x8(%esp)
801024c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801024cd:	00 
801024ce:	8b 45 08             	mov    0x8(%ebp),%eax
801024d1:	89 04 24             	mov    %eax,(%esp)
801024d4:	e8 a8 fe ff ff       	call   80102381 <namex>
}
801024d9:	c9                   	leave  
801024da:	c3                   	ret    

801024db <inb>:
{
801024db:	55                   	push   %ebp
801024dc:	89 e5                	mov    %esp,%ebp
801024de:	83 ec 14             	sub    $0x14,%esp
801024e1:	8b 45 08             	mov    0x8(%ebp),%eax
801024e4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801024ec:	89 c2                	mov    %eax,%edx
801024ee:	ec                   	in     (%dx),%al
801024ef:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801024f2:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801024f6:	c9                   	leave  
801024f7:	c3                   	ret    

801024f8 <insl>:
{
801024f8:	55                   	push   %ebp
801024f9:	89 e5                	mov    %esp,%ebp
801024fb:	57                   	push   %edi
801024fc:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024fd:	8b 55 08             	mov    0x8(%ebp),%edx
80102500:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102503:	8b 45 10             	mov    0x10(%ebp),%eax
80102506:	89 cb                	mov    %ecx,%ebx
80102508:	89 df                	mov    %ebx,%edi
8010250a:	89 c1                	mov    %eax,%ecx
8010250c:	fc                   	cld    
8010250d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010250f:	89 c8                	mov    %ecx,%eax
80102511:	89 fb                	mov    %edi,%ebx
80102513:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102516:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102519:	5b                   	pop    %ebx
8010251a:	5f                   	pop    %edi
8010251b:	5d                   	pop    %ebp
8010251c:	c3                   	ret    

8010251d <outb>:
{
8010251d:	55                   	push   %ebp
8010251e:	89 e5                	mov    %esp,%ebp
80102520:	83 ec 08             	sub    $0x8,%esp
80102523:	8b 55 08             	mov    0x8(%ebp),%edx
80102526:	8b 45 0c             	mov    0xc(%ebp),%eax
80102529:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010252d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102530:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102534:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102538:	ee                   	out    %al,(%dx)
}
80102539:	c9                   	leave  
8010253a:	c3                   	ret    

8010253b <outsl>:
{
8010253b:	55                   	push   %ebp
8010253c:	89 e5                	mov    %esp,%ebp
8010253e:	56                   	push   %esi
8010253f:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102540:	8b 55 08             	mov    0x8(%ebp),%edx
80102543:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102546:	8b 45 10             	mov    0x10(%ebp),%eax
80102549:	89 cb                	mov    %ecx,%ebx
8010254b:	89 de                	mov    %ebx,%esi
8010254d:	89 c1                	mov    %eax,%ecx
8010254f:	fc                   	cld    
80102550:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102552:	89 c8                	mov    %ecx,%eax
80102554:	89 f3                	mov    %esi,%ebx
80102556:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102559:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010255c:	5b                   	pop    %ebx
8010255d:	5e                   	pop    %esi
8010255e:	5d                   	pop    %ebp
8010255f:	c3                   	ret    

80102560 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102566:	90                   	nop
80102567:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010256e:	e8 68 ff ff ff       	call   801024db <inb>
80102573:	0f b6 c0             	movzbl %al,%eax
80102576:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102579:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010257c:	25 c0 00 00 00       	and    $0xc0,%eax
80102581:	83 f8 40             	cmp    $0x40,%eax
80102584:	75 e1                	jne    80102567 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102586:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010258a:	74 11                	je     8010259d <idewait+0x3d>
8010258c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010258f:	83 e0 21             	and    $0x21,%eax
80102592:	85 c0                	test   %eax,%eax
80102594:	74 07                	je     8010259d <idewait+0x3d>
    return -1;
80102596:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010259b:	eb 05                	jmp    801025a2 <idewait+0x42>
  return 0;
8010259d:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025a2:	c9                   	leave  
801025a3:	c3                   	ret    

801025a4 <ideinit>:

void
ideinit(void)
{
801025a4:	55                   	push   %ebp
801025a5:	89 e5                	mov    %esp,%ebp
801025a7:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
801025aa:	c7 44 24 04 6b 86 10 	movl   $0x8010866b,0x4(%esp)
801025b1:	80 
801025b2:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801025b9:	e8 e0 29 00 00       	call   80104f9e <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801025be:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
801025c3:	83 e8 01             	sub    $0x1,%eax
801025c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801025ca:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025d1:	e8 69 04 00 00       	call   80102a3f <ioapicenable>
  idewait(0);
801025d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025dd:	e8 7e ff ff ff       	call   80102560 <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025e2:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025e9:	00 
801025ea:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025f1:	e8 27 ff ff ff       	call   8010251d <outb>
  for(i=0; i<1000; i++){
801025f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025fd:	eb 20                	jmp    8010261f <ideinit+0x7b>
    if(inb(0x1f7) != 0){
801025ff:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102606:	e8 d0 fe ff ff       	call   801024db <inb>
8010260b:	84 c0                	test   %al,%al
8010260d:	74 0c                	je     8010261b <ideinit+0x77>
      havedisk1 = 1;
8010260f:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
80102616:	00 00 00 
      break;
80102619:	eb 0d                	jmp    80102628 <ideinit+0x84>
  for(i=0; i<1000; i++){
8010261b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010261f:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102626:	7e d7                	jle    801025ff <ideinit+0x5b>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102628:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
8010262f:	00 
80102630:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102637:	e8 e1 fe ff ff       	call   8010251d <outb>
}
8010263c:	c9                   	leave  
8010263d:	c3                   	ret    

8010263e <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010263e:	55                   	push   %ebp
8010263f:	89 e5                	mov    %esp,%ebp
80102641:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
80102644:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102648:	75 0c                	jne    80102656 <idestart+0x18>
    panic("idestart");
8010264a:	c7 04 24 6f 86 10 80 	movl   $0x8010866f,(%esp)
80102651:	e8 0c df ff ff       	call   80100562 <panic>
  if(b->blockno >= FSSIZE)
80102656:	8b 45 08             	mov    0x8(%ebp),%eax
80102659:	8b 40 08             	mov    0x8(%eax),%eax
8010265c:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102661:	76 0c                	jbe    8010266f <idestart+0x31>
    panic("incorrect blockno");
80102663:	c7 04 24 78 86 10 80 	movl   $0x80108678,(%esp)
8010266a:	e8 f3 de ff ff       	call   80100562 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
8010266f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102676:	8b 45 08             	mov    0x8(%ebp),%eax
80102679:	8b 50 08             	mov    0x8(%eax),%edx
8010267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010267f:	0f af c2             	imul   %edx,%eax
80102682:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
80102685:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102689:	75 07                	jne    80102692 <idestart+0x54>
8010268b:	b8 20 00 00 00       	mov    $0x20,%eax
80102690:	eb 05                	jmp    80102697 <idestart+0x59>
80102692:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102697:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
8010269a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010269e:	75 07                	jne    801026a7 <idestart+0x69>
801026a0:	b8 30 00 00 00       	mov    $0x30,%eax
801026a5:	eb 05                	jmp    801026ac <idestart+0x6e>
801026a7:	b8 c5 00 00 00       	mov    $0xc5,%eax
801026ac:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
801026af:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801026b3:	7e 0c                	jle    801026c1 <idestart+0x83>
801026b5:	c7 04 24 6f 86 10 80 	movl   $0x8010866f,(%esp)
801026bc:	e8 a1 de ff ff       	call   80100562 <panic>

  idewait(0);
801026c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801026c8:	e8 93 fe ff ff       	call   80102560 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801026cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801026d4:	00 
801026d5:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801026dc:	e8 3c fe ff ff       	call   8010251d <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
801026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026e4:	0f b6 c0             	movzbl %al,%eax
801026e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801026eb:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801026f2:	e8 26 fe ff ff       	call   8010251d <outb>
  outb(0x1f3, sector & 0xff);
801026f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026fa:	0f b6 c0             	movzbl %al,%eax
801026fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80102701:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102708:	e8 10 fe ff ff       	call   8010251d <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
8010270d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102710:	c1 f8 08             	sar    $0x8,%eax
80102713:	0f b6 c0             	movzbl %al,%eax
80102716:	89 44 24 04          	mov    %eax,0x4(%esp)
8010271a:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102721:	e8 f7 fd ff ff       	call   8010251d <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
80102726:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102729:	c1 f8 10             	sar    $0x10,%eax
8010272c:	0f b6 c0             	movzbl %al,%eax
8010272f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102733:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
8010273a:	e8 de fd ff ff       	call   8010251d <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010273f:	8b 45 08             	mov    0x8(%ebp),%eax
80102742:	8b 40 04             	mov    0x4(%eax),%eax
80102745:	83 e0 01             	and    $0x1,%eax
80102748:	c1 e0 04             	shl    $0x4,%eax
8010274b:	89 c2                	mov    %eax,%edx
8010274d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102750:	c1 f8 18             	sar    $0x18,%eax
80102753:	83 e0 0f             	and    $0xf,%eax
80102756:	09 d0                	or     %edx,%eax
80102758:	83 c8 e0             	or     $0xffffffe0,%eax
8010275b:	0f b6 c0             	movzbl %al,%eax
8010275e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102762:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102769:	e8 af fd ff ff       	call   8010251d <outb>
  if(b->flags & B_DIRTY){
8010276e:	8b 45 08             	mov    0x8(%ebp),%eax
80102771:	8b 00                	mov    (%eax),%eax
80102773:	83 e0 04             	and    $0x4,%eax
80102776:	85 c0                	test   %eax,%eax
80102778:	74 36                	je     801027b0 <idestart+0x172>
    outb(0x1f7, write_cmd);
8010277a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010277d:	0f b6 c0             	movzbl %al,%eax
80102780:	89 44 24 04          	mov    %eax,0x4(%esp)
80102784:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010278b:	e8 8d fd ff ff       	call   8010251d <outb>
    outsl(0x1f0, b->data, BSIZE/4);
80102790:	8b 45 08             	mov    0x8(%ebp),%eax
80102793:	83 c0 5c             	add    $0x5c,%eax
80102796:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010279d:	00 
8010279e:	89 44 24 04          	mov    %eax,0x4(%esp)
801027a2:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801027a9:	e8 8d fd ff ff       	call   8010253b <outsl>
801027ae:	eb 16                	jmp    801027c6 <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
801027b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801027b3:	0f b6 c0             	movzbl %al,%eax
801027b6:	89 44 24 04          	mov    %eax,0x4(%esp)
801027ba:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801027c1:	e8 57 fd ff ff       	call   8010251d <outb>
  }
}
801027c6:	c9                   	leave  
801027c7:	c3                   	ret    

801027c8 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027c8:	55                   	push   %ebp
801027c9:	89 e5                	mov    %esp,%ebp
801027cb:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027ce:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027d5:	e8 e5 27 00 00       	call   80104fbf <acquire>

  if((b = idequeue) == 0){
801027da:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801027df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027e6:	75 11                	jne    801027f9 <ideintr+0x31>
    release(&idelock);
801027e8:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027ef:	e8 33 28 00 00       	call   80105027 <release>
    return;
801027f4:	e9 90 00 00 00       	jmp    80102889 <ideintr+0xc1>
  }
  idequeue = b->qnext;
801027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fc:	8b 40 58             	mov    0x58(%eax),%eax
801027ff:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102807:	8b 00                	mov    (%eax),%eax
80102809:	83 e0 04             	and    $0x4,%eax
8010280c:	85 c0                	test   %eax,%eax
8010280e:	75 2e                	jne    8010283e <ideintr+0x76>
80102810:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102817:	e8 44 fd ff ff       	call   80102560 <idewait>
8010281c:	85 c0                	test   %eax,%eax
8010281e:	78 1e                	js     8010283e <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
80102820:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102823:	83 c0 5c             	add    $0x5c,%eax
80102826:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010282d:	00 
8010282e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102832:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102839:	e8 ba fc ff ff       	call   801024f8 <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102841:	8b 00                	mov    (%eax),%eax
80102843:	83 c8 02             	or     $0x2,%eax
80102846:	89 c2                	mov    %eax,%edx
80102848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010284b:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102850:	8b 00                	mov    (%eax),%eax
80102852:	83 e0 fb             	and    $0xfffffffb,%eax
80102855:	89 c2                	mov    %eax,%edx
80102857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010285a:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010285f:	89 04 24             	mov    %eax,(%esp)
80102862:	e8 34 24 00 00       	call   80104c9b <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102867:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010286c:	85 c0                	test   %eax,%eax
8010286e:	74 0d                	je     8010287d <ideintr+0xb5>
    idestart(idequeue);
80102870:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102875:	89 04 24             	mov    %eax,(%esp)
80102878:	e8 c1 fd ff ff       	call   8010263e <idestart>

  release(&idelock);
8010287d:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102884:	e8 9e 27 00 00       	call   80105027 <release>
}
80102889:	c9                   	leave  
8010288a:	c3                   	ret    

8010288b <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010288b:	55                   	push   %ebp
8010288c:	89 e5                	mov    %esp,%ebp
8010288e:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102891:	8b 45 08             	mov    0x8(%ebp),%eax
80102894:	83 c0 0c             	add    $0xc,%eax
80102897:	89 04 24             	mov    %eax,(%esp)
8010289a:	e8 73 26 00 00       	call   80104f12 <holdingsleep>
8010289f:	85 c0                	test   %eax,%eax
801028a1:	75 0c                	jne    801028af <iderw+0x24>
    panic("iderw: buf not locked");
801028a3:	c7 04 24 8a 86 10 80 	movl   $0x8010868a,(%esp)
801028aa:	e8 b3 dc ff ff       	call   80100562 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801028af:	8b 45 08             	mov    0x8(%ebp),%eax
801028b2:	8b 00                	mov    (%eax),%eax
801028b4:	83 e0 06             	and    $0x6,%eax
801028b7:	83 f8 02             	cmp    $0x2,%eax
801028ba:	75 0c                	jne    801028c8 <iderw+0x3d>
    panic("iderw: nothing to do");
801028bc:	c7 04 24 a0 86 10 80 	movl   $0x801086a0,(%esp)
801028c3:	e8 9a dc ff ff       	call   80100562 <panic>
  if(b->dev != 0 && !havedisk1)
801028c8:	8b 45 08             	mov    0x8(%ebp),%eax
801028cb:	8b 40 04             	mov    0x4(%eax),%eax
801028ce:	85 c0                	test   %eax,%eax
801028d0:	74 15                	je     801028e7 <iderw+0x5c>
801028d2:	a1 38 b6 10 80       	mov    0x8010b638,%eax
801028d7:	85 c0                	test   %eax,%eax
801028d9:	75 0c                	jne    801028e7 <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
801028db:	c7 04 24 b5 86 10 80 	movl   $0x801086b5,(%esp)
801028e2:	e8 7b dc ff ff       	call   80100562 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028e7:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801028ee:	e8 cc 26 00 00       	call   80104fbf <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801028f3:	8b 45 08             	mov    0x8(%ebp),%eax
801028f6:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028fd:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
80102904:	eb 0b                	jmp    80102911 <iderw+0x86>
80102906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102909:	8b 00                	mov    (%eax),%eax
8010290b:	83 c0 58             	add    $0x58,%eax
8010290e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102911:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102914:	8b 00                	mov    (%eax),%eax
80102916:	85 c0                	test   %eax,%eax
80102918:	75 ec                	jne    80102906 <iderw+0x7b>
    ;
  *pp = b;
8010291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291d:	8b 55 08             	mov    0x8(%ebp),%edx
80102920:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102922:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102927:	3b 45 08             	cmp    0x8(%ebp),%eax
8010292a:	75 0d                	jne    80102939 <iderw+0xae>
    idestart(b);
8010292c:	8b 45 08             	mov    0x8(%ebp),%eax
8010292f:	89 04 24             	mov    %eax,(%esp)
80102932:	e8 07 fd ff ff       	call   8010263e <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102937:	eb 15                	jmp    8010294e <iderw+0xc3>
80102939:	eb 13                	jmp    8010294e <iderw+0xc3>
    sleep(b, &idelock);
8010293b:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
80102942:	80 
80102943:	8b 45 08             	mov    0x8(%ebp),%eax
80102946:	89 04 24             	mov    %eax,(%esp)
80102949:	e8 76 22 00 00       	call   80104bc4 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010294e:	8b 45 08             	mov    0x8(%ebp),%eax
80102951:	8b 00                	mov    (%eax),%eax
80102953:	83 e0 06             	and    $0x6,%eax
80102956:	83 f8 02             	cmp    $0x2,%eax
80102959:	75 e0                	jne    8010293b <iderw+0xb0>
  }


  release(&idelock);
8010295b:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102962:	e8 c0 26 00 00       	call   80105027 <release>
}
80102967:	c9                   	leave  
80102968:	c3                   	ret    

80102969 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102969:	55                   	push   %ebp
8010296a:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010296c:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102971:	8b 55 08             	mov    0x8(%ebp),%edx
80102974:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102976:	a1 d4 36 11 80       	mov    0x801136d4,%eax
8010297b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010297e:	5d                   	pop    %ebp
8010297f:	c3                   	ret    

80102980 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102983:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102988:	8b 55 08             	mov    0x8(%ebp),%edx
8010298b:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010298d:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102992:	8b 55 0c             	mov    0xc(%ebp),%edx
80102995:	89 50 10             	mov    %edx,0x10(%eax)
}
80102998:	5d                   	pop    %ebp
80102999:	c3                   	ret    

8010299a <ioapicinit>:

void
ioapicinit(void)
{
8010299a:	55                   	push   %ebp
8010299b:	89 e5                	mov    %esp,%ebp
8010299d:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801029a0:	c7 05 d4 36 11 80 00 	movl   $0xfec00000,0x801136d4
801029a7:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801029b1:	e8 b3 ff ff ff       	call   80102969 <ioapicread>
801029b6:	c1 e8 10             	shr    $0x10,%eax
801029b9:	25 ff 00 00 00       	and    $0xff,%eax
801029be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801029c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801029c8:	e8 9c ff ff ff       	call   80102969 <ioapicread>
801029cd:	c1 e8 18             	shr    $0x18,%eax
801029d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801029d3:	0f b6 05 00 38 11 80 	movzbl 0x80113800,%eax
801029da:	0f b6 c0             	movzbl %al,%eax
801029dd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801029e0:	74 0c                	je     801029ee <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029e2:	c7 04 24 d4 86 10 80 	movl   $0x801086d4,(%esp)
801029e9:	e8 da d9 ff ff       	call   801003c8 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029f5:	eb 3e                	jmp    80102a35 <ioapicinit+0x9b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029fa:	83 c0 20             	add    $0x20,%eax
801029fd:	0d 00 00 01 00       	or     $0x10000,%eax
80102a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102a05:	83 c2 08             	add    $0x8,%edx
80102a08:	01 d2                	add    %edx,%edx
80102a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a0e:	89 14 24             	mov    %edx,(%esp)
80102a11:	e8 6a ff ff ff       	call   80102980 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a19:	83 c0 08             	add    $0x8,%eax
80102a1c:	01 c0                	add    %eax,%eax
80102a1e:	83 c0 01             	add    $0x1,%eax
80102a21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102a28:	00 
80102a29:	89 04 24             	mov    %eax,(%esp)
80102a2c:	e8 4f ff ff ff       	call   80102980 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80102a31:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a38:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a3b:	7e ba                	jle    801029f7 <ioapicinit+0x5d>
  }
}
80102a3d:	c9                   	leave  
80102a3e:	c3                   	ret    

80102a3f <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a3f:	55                   	push   %ebp
80102a40:	89 e5                	mov    %esp,%ebp
80102a42:	83 ec 08             	sub    $0x8,%esp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a45:	8b 45 08             	mov    0x8(%ebp),%eax
80102a48:	83 c0 20             	add    $0x20,%eax
80102a4b:	8b 55 08             	mov    0x8(%ebp),%edx
80102a4e:	83 c2 08             	add    $0x8,%edx
80102a51:	01 d2                	add    %edx,%edx
80102a53:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a57:	89 14 24             	mov    %edx,(%esp)
80102a5a:	e8 21 ff ff ff       	call   80102980 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a62:	c1 e0 18             	shl    $0x18,%eax
80102a65:	8b 55 08             	mov    0x8(%ebp),%edx
80102a68:	83 c2 08             	add    $0x8,%edx
80102a6b:	01 d2                	add    %edx,%edx
80102a6d:	83 c2 01             	add    $0x1,%edx
80102a70:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a74:	89 14 24             	mov    %edx,(%esp)
80102a77:	e8 04 ff ff ff       	call   80102980 <ioapicwrite>
}
80102a7c:	c9                   	leave  
80102a7d:	c3                   	ret    

80102a7e <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a7e:	55                   	push   %ebp
80102a7f:	89 e5                	mov    %esp,%ebp
80102a81:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a84:	c7 44 24 04 06 87 10 	movl   $0x80108706,0x4(%esp)
80102a8b:	80 
80102a8c:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80102a93:	e8 06 25 00 00       	call   80104f9e <initlock>
  kmem.use_lock = 0;
80102a98:	c7 05 14 37 11 80 00 	movl   $0x0,0x80113714
80102a9f:	00 00 00 
  freerange(vstart, vend);
80102aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
80102aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80102aac:	89 04 24             	mov    %eax,(%esp)
80102aaf:	e8 26 00 00 00       	call   80102ada <freerange>
}
80102ab4:	c9                   	leave  
80102ab5:	c3                   	ret    

80102ab6 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ab6:	55                   	push   %ebp
80102ab7:	89 e5                	mov    %esp,%ebp
80102ab9:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80102abf:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac6:	89 04 24             	mov    %eax,(%esp)
80102ac9:	e8 0c 00 00 00       	call   80102ada <freerange>
  kmem.use_lock = 1;
80102ace:	c7 05 14 37 11 80 01 	movl   $0x1,0x80113714
80102ad5:	00 00 00 
}
80102ad8:	c9                   	leave  
80102ad9:	c3                   	ret    

80102ada <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ada:	55                   	push   %ebp
80102adb:	89 e5                	mov    %esp,%ebp
80102add:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae3:	05 ff 0f 00 00       	add    $0xfff,%eax
80102ae8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102af0:	eb 12                	jmp    80102b04 <freerange+0x2a>
    kfree(p);
80102af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102af5:	89 04 24             	mov    %eax,(%esp)
80102af8:	e8 16 00 00 00       	call   80102b13 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102afd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b07:	05 00 10 00 00       	add    $0x1000,%eax
80102b0c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b0f:	76 e1                	jbe    80102af2 <freerange+0x18>
}
80102b11:	c9                   	leave  
80102b12:	c3                   	ret    

80102b13 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b13:	55                   	push   %ebp
80102b14:	89 e5                	mov    %esp,%ebp
80102b16:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b19:	8b 45 08             	mov    0x8(%ebp),%eax
80102b1c:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b21:	85 c0                	test   %eax,%eax
80102b23:	75 18                	jne    80102b3d <kfree+0x2a>
80102b25:	81 7d 08 48 67 11 80 	cmpl   $0x80116748,0x8(%ebp)
80102b2c:	72 0f                	jb     80102b3d <kfree+0x2a>
80102b2e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b31:	05 00 00 00 80       	add    $0x80000000,%eax
80102b36:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b3b:	76 0c                	jbe    80102b49 <kfree+0x36>
    panic("kfree");
80102b3d:	c7 04 24 0b 87 10 80 	movl   $0x8010870b,(%esp)
80102b44:	e8 19 da ff ff       	call   80100562 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b49:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102b50:	00 
80102b51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b58:	00 
80102b59:	8b 45 08             	mov    0x8(%ebp),%eax
80102b5c:	89 04 24             	mov    %eax,(%esp)
80102b5f:	e8 cd 26 00 00       	call   80105231 <memset>

  if(kmem.use_lock)
80102b64:	a1 14 37 11 80       	mov    0x80113714,%eax
80102b69:	85 c0                	test   %eax,%eax
80102b6b:	74 0c                	je     80102b79 <kfree+0x66>
    acquire(&kmem.lock);
80102b6d:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80102b74:	e8 46 24 00 00       	call   80104fbf <acquire>
  r = (struct run*)v;
80102b79:	8b 45 08             	mov    0x8(%ebp),%eax
80102b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b7f:	8b 15 18 37 11 80    	mov    0x80113718,%edx
80102b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b88:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b8d:	a3 18 37 11 80       	mov    %eax,0x80113718
  if(kmem.use_lock)
80102b92:	a1 14 37 11 80       	mov    0x80113714,%eax
80102b97:	85 c0                	test   %eax,%eax
80102b99:	74 0c                	je     80102ba7 <kfree+0x94>
    release(&kmem.lock);
80102b9b:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80102ba2:	e8 80 24 00 00       	call   80105027 <release>
}
80102ba7:	c9                   	leave  
80102ba8:	c3                   	ret    

80102ba9 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ba9:	55                   	push   %ebp
80102baa:	89 e5                	mov    %esp,%ebp
80102bac:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102baf:	a1 14 37 11 80       	mov    0x80113714,%eax
80102bb4:	85 c0                	test   %eax,%eax
80102bb6:	74 0c                	je     80102bc4 <kalloc+0x1b>
    acquire(&kmem.lock);
80102bb8:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80102bbf:	e8 fb 23 00 00       	call   80104fbf <acquire>
  r = kmem.freelist;
80102bc4:	a1 18 37 11 80       	mov    0x80113718,%eax
80102bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102bcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bd0:	74 0a                	je     80102bdc <kalloc+0x33>
    kmem.freelist = r->next;
80102bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bd5:	8b 00                	mov    (%eax),%eax
80102bd7:	a3 18 37 11 80       	mov    %eax,0x80113718
  if(kmem.use_lock)
80102bdc:	a1 14 37 11 80       	mov    0x80113714,%eax
80102be1:	85 c0                	test   %eax,%eax
80102be3:	74 0c                	je     80102bf1 <kalloc+0x48>
    release(&kmem.lock);
80102be5:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80102bec:	e8 36 24 00 00       	call   80105027 <release>
  return (char*)r;
80102bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102bf4:	c9                   	leave  
80102bf5:	c3                   	ret    

80102bf6 <inb>:
{
80102bf6:	55                   	push   %ebp
80102bf7:	89 e5                	mov    %esp,%ebp
80102bf9:	83 ec 14             	sub    $0x14,%esp
80102bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80102bff:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c03:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c07:	89 c2                	mov    %eax,%edx
80102c09:	ec                   	in     (%dx),%al
80102c0a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c0d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c11:	c9                   	leave  
80102c12:	c3                   	ret    

80102c13 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c13:	55                   	push   %ebp
80102c14:	89 e5                	mov    %esp,%ebp
80102c16:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c19:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102c20:	e8 d1 ff ff ff       	call   80102bf6 <inb>
80102c25:	0f b6 c0             	movzbl %al,%eax
80102c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c2e:	83 e0 01             	and    $0x1,%eax
80102c31:	85 c0                	test   %eax,%eax
80102c33:	75 0a                	jne    80102c3f <kbdgetc+0x2c>
    return -1;
80102c35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c3a:	e9 25 01 00 00       	jmp    80102d64 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102c3f:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c46:	e8 ab ff ff ff       	call   80102bf6 <inb>
80102c4b:	0f b6 c0             	movzbl %al,%eax
80102c4e:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c51:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c58:	75 17                	jne    80102c71 <kbdgetc+0x5e>
    shift |= E0ESC;
80102c5a:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c5f:	83 c8 40             	or     $0x40,%eax
80102c62:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c67:	b8 00 00 00 00       	mov    $0x0,%eax
80102c6c:	e9 f3 00 00 00       	jmp    80102d64 <kbdgetc+0x151>
  } else if(data & 0x80){
80102c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c74:	25 80 00 00 00       	and    $0x80,%eax
80102c79:	85 c0                	test   %eax,%eax
80102c7b:	74 45                	je     80102cc2 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c7d:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c82:	83 e0 40             	and    $0x40,%eax
80102c85:	85 c0                	test   %eax,%eax
80102c87:	75 08                	jne    80102c91 <kbdgetc+0x7e>
80102c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c8c:	83 e0 7f             	and    $0x7f,%eax
80102c8f:	eb 03                	jmp    80102c94 <kbdgetc+0x81>
80102c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c94:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c9a:	05 20 90 10 80       	add    $0x80109020,%eax
80102c9f:	0f b6 00             	movzbl (%eax),%eax
80102ca2:	83 c8 40             	or     $0x40,%eax
80102ca5:	0f b6 c0             	movzbl %al,%eax
80102ca8:	f7 d0                	not    %eax
80102caa:	89 c2                	mov    %eax,%edx
80102cac:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cb1:	21 d0                	and    %edx,%eax
80102cb3:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102cb8:	b8 00 00 00 00       	mov    $0x0,%eax
80102cbd:	e9 a2 00 00 00       	jmp    80102d64 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102cc2:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cc7:	83 e0 40             	and    $0x40,%eax
80102cca:	85 c0                	test   %eax,%eax
80102ccc:	74 14                	je     80102ce2 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cce:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102cd5:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cda:	83 e0 bf             	and    $0xffffffbf,%eax
80102cdd:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102ce2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ce5:	05 20 90 10 80       	add    $0x80109020,%eax
80102cea:	0f b6 00             	movzbl (%eax),%eax
80102ced:	0f b6 d0             	movzbl %al,%edx
80102cf0:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cf5:	09 d0                	or     %edx,%eax
80102cf7:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cff:	05 20 91 10 80       	add    $0x80109120,%eax
80102d04:	0f b6 00             	movzbl (%eax),%eax
80102d07:	0f b6 d0             	movzbl %al,%edx
80102d0a:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d0f:	31 d0                	xor    %edx,%eax
80102d11:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d16:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d1b:	83 e0 03             	and    $0x3,%eax
80102d1e:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102d25:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d28:	01 d0                	add    %edx,%eax
80102d2a:	0f b6 00             	movzbl (%eax),%eax
80102d2d:	0f b6 c0             	movzbl %al,%eax
80102d30:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d33:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d38:	83 e0 08             	and    $0x8,%eax
80102d3b:	85 c0                	test   %eax,%eax
80102d3d:	74 22                	je     80102d61 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102d3f:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d43:	76 0c                	jbe    80102d51 <kbdgetc+0x13e>
80102d45:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d49:	77 06                	ja     80102d51 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102d4b:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d4f:	eb 10                	jmp    80102d61 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102d51:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d55:	76 0a                	jbe    80102d61 <kbdgetc+0x14e>
80102d57:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d5b:	77 04                	ja     80102d61 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102d5d:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d61:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d64:	c9                   	leave  
80102d65:	c3                   	ret    

80102d66 <kbdintr>:

void
kbdintr(void)
{
80102d66:	55                   	push   %ebp
80102d67:	89 e5                	mov    %esp,%ebp
80102d69:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102d6c:	c7 04 24 13 2c 10 80 	movl   $0x80102c13,(%esp)
80102d73:	e8 71 da ff ff       	call   801007e9 <consoleintr>
}
80102d78:	c9                   	leave  
80102d79:	c3                   	ret    

80102d7a <inb>:
{
80102d7a:	55                   	push   %ebp
80102d7b:	89 e5                	mov    %esp,%ebp
80102d7d:	83 ec 14             	sub    $0x14,%esp
80102d80:	8b 45 08             	mov    0x8(%ebp),%eax
80102d83:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d87:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d8b:	89 c2                	mov    %eax,%edx
80102d8d:	ec                   	in     (%dx),%al
80102d8e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d91:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d95:	c9                   	leave  
80102d96:	c3                   	ret    

80102d97 <outb>:
{
80102d97:	55                   	push   %ebp
80102d98:	89 e5                	mov    %esp,%ebp
80102d9a:	83 ec 08             	sub    $0x8,%esp
80102d9d:	8b 55 08             	mov    0x8(%ebp),%edx
80102da0:	8b 45 0c             	mov    0xc(%ebp),%eax
80102da3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102da7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102daa:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102dae:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102db2:	ee                   	out    %al,(%dx)
}
80102db3:	c9                   	leave  
80102db4:	c3                   	ret    

80102db5 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102db5:	55                   	push   %ebp
80102db6:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102db8:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102dbd:	8b 55 08             	mov    0x8(%ebp),%edx
80102dc0:	c1 e2 02             	shl    $0x2,%edx
80102dc3:	01 c2                	add    %eax,%edx
80102dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dc8:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102dca:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102dcf:	83 c0 20             	add    $0x20,%eax
80102dd2:	8b 00                	mov    (%eax),%eax
}
80102dd4:	5d                   	pop    %ebp
80102dd5:	c3                   	ret    

80102dd6 <lapicinit>:

void
lapicinit(void)
{
80102dd6:	55                   	push   %ebp
80102dd7:	89 e5                	mov    %esp,%ebp
80102dd9:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
80102ddc:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102de1:	85 c0                	test   %eax,%eax
80102de3:	75 05                	jne    80102dea <lapicinit+0x14>
    return;
80102de5:	e9 43 01 00 00       	jmp    80102f2d <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102dea:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102df1:	00 
80102df2:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102df9:	e8 b7 ff ff ff       	call   80102db5 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102dfe:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102e05:	00 
80102e06:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102e0d:	e8 a3 ff ff ff       	call   80102db5 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e12:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102e19:	00 
80102e1a:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102e21:	e8 8f ff ff ff       	call   80102db5 <lapicw>
  lapicw(TICR, 10000000);
80102e26:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e2d:	00 
80102e2e:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e35:	e8 7b ff ff ff       	call   80102db5 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e3a:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e41:	00 
80102e42:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e49:	e8 67 ff ff ff       	call   80102db5 <lapicw>
  lapicw(LINT1, MASKED);
80102e4e:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e55:	00 
80102e56:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e5d:	e8 53 ff ff ff       	call   80102db5 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e62:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102e67:	83 c0 30             	add    $0x30,%eax
80102e6a:	8b 00                	mov    (%eax),%eax
80102e6c:	c1 e8 10             	shr    $0x10,%eax
80102e6f:	0f b6 c0             	movzbl %al,%eax
80102e72:	83 f8 03             	cmp    $0x3,%eax
80102e75:	76 14                	jbe    80102e8b <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102e77:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e7e:	00 
80102e7f:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e86:	e8 2a ff ff ff       	call   80102db5 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e8b:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e92:	00 
80102e93:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e9a:	e8 16 ff ff ff       	call   80102db5 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e9f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ea6:	00 
80102ea7:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102eae:	e8 02 ff ff ff       	call   80102db5 <lapicw>
  lapicw(ESR, 0);
80102eb3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eba:	00 
80102ebb:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ec2:	e8 ee fe ff ff       	call   80102db5 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ec7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ece:	00 
80102ecf:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ed6:	e8 da fe ff ff       	call   80102db5 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102edb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ee2:	00 
80102ee3:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102eea:	e8 c6 fe ff ff       	call   80102db5 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102eef:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102ef6:	00 
80102ef7:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102efe:	e8 b2 fe ff ff       	call   80102db5 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102f03:	90                   	nop
80102f04:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102f09:	05 00 03 00 00       	add    $0x300,%eax
80102f0e:	8b 00                	mov    (%eax),%eax
80102f10:	25 00 10 00 00       	and    $0x1000,%eax
80102f15:	85 c0                	test   %eax,%eax
80102f17:	75 eb                	jne    80102f04 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f19:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f20:	00 
80102f21:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102f28:	e8 88 fe ff ff       	call   80102db5 <lapicw>
}
80102f2d:	c9                   	leave  
80102f2e:	c3                   	ret    

80102f2f <lapicid>:

int
lapicid(void)
{
80102f2f:	55                   	push   %ebp
80102f30:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102f32:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102f37:	85 c0                	test   %eax,%eax
80102f39:	75 07                	jne    80102f42 <lapicid+0x13>
    return 0;
80102f3b:	b8 00 00 00 00       	mov    $0x0,%eax
80102f40:	eb 0d                	jmp    80102f4f <lapicid+0x20>
  return lapic[ID] >> 24;
80102f42:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102f47:	83 c0 20             	add    $0x20,%eax
80102f4a:	8b 00                	mov    (%eax),%eax
80102f4c:	c1 e8 18             	shr    $0x18,%eax
}
80102f4f:	5d                   	pop    %ebp
80102f50:	c3                   	ret    

80102f51 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f51:	55                   	push   %ebp
80102f52:	89 e5                	mov    %esp,%ebp
80102f54:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f57:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102f5c:	85 c0                	test   %eax,%eax
80102f5e:	74 14                	je     80102f74 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f60:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f67:	00 
80102f68:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f6f:	e8 41 fe ff ff       	call   80102db5 <lapicw>
}
80102f74:	c9                   	leave  
80102f75:	c3                   	ret    

80102f76 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f76:	55                   	push   %ebp
80102f77:	89 e5                	mov    %esp,%ebp
}
80102f79:	5d                   	pop    %ebp
80102f7a:	c3                   	ret    

80102f7b <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f7b:	55                   	push   %ebp
80102f7c:	89 e5                	mov    %esp,%ebp
80102f7e:	83 ec 1c             	sub    $0x1c,%esp
80102f81:	8b 45 08             	mov    0x8(%ebp),%eax
80102f84:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f87:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f8e:	00 
80102f8f:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f96:	e8 fc fd ff ff       	call   80102d97 <outb>
  outb(CMOS_PORT+1, 0x0A);
80102f9b:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102fa2:	00 
80102fa3:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102faa:	e8 e8 fd ff ff       	call   80102d97 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102faf:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102fb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fb9:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102fbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fc1:	8d 50 02             	lea    0x2(%eax),%edx
80102fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fc7:	c1 e8 04             	shr    $0x4,%eax
80102fca:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fcd:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fd1:	c1 e0 18             	shl    $0x18,%eax
80102fd4:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fd8:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fdf:	e8 d1 fd ff ff       	call   80102db5 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102fe4:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102feb:	00 
80102fec:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102ff3:	e8 bd fd ff ff       	call   80102db5 <lapicw>
  microdelay(200);
80102ff8:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fff:	e8 72 ff ff ff       	call   80102f76 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103004:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
8010300b:	00 
8010300c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103013:	e8 9d fd ff ff       	call   80102db5 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103018:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
8010301f:	e8 52 ff ff ff       	call   80102f76 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103024:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010302b:	eb 40                	jmp    8010306d <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
8010302d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103031:	c1 e0 18             	shl    $0x18,%eax
80103034:	89 44 24 04          	mov    %eax,0x4(%esp)
80103038:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010303f:	e8 71 fd ff ff       	call   80102db5 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80103044:	8b 45 0c             	mov    0xc(%ebp),%eax
80103047:	c1 e8 0c             	shr    $0xc,%eax
8010304a:	80 cc 06             	or     $0x6,%ah
8010304d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103051:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103058:	e8 58 fd ff ff       	call   80102db5 <lapicw>
    microdelay(200);
8010305d:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103064:	e8 0d ff ff ff       	call   80102f76 <microdelay>
  for(i = 0; i < 2; i++){
80103069:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010306d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103071:	7e ba                	jle    8010302d <lapicstartap+0xb2>
  }
}
80103073:	c9                   	leave  
80103074:	c3                   	ret    

80103075 <cmos_read>:
#define MONTH   0x08
#define YEAR    0x09

static uint
cmos_read(uint reg)
{
80103075:	55                   	push   %ebp
80103076:	89 e5                	mov    %esp,%ebp
80103078:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
8010307b:	8b 45 08             	mov    0x8(%ebp),%eax
8010307e:	0f b6 c0             	movzbl %al,%eax
80103081:	89 44 24 04          	mov    %eax,0x4(%esp)
80103085:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
8010308c:	e8 06 fd ff ff       	call   80102d97 <outb>
  microdelay(200);
80103091:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103098:	e8 d9 fe ff ff       	call   80102f76 <microdelay>

  return inb(CMOS_RETURN);
8010309d:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801030a4:	e8 d1 fc ff ff       	call   80102d7a <inb>
801030a9:	0f b6 c0             	movzbl %al,%eax
}
801030ac:	c9                   	leave  
801030ad:	c3                   	ret    

801030ae <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801030ae:	55                   	push   %ebp
801030af:	89 e5                	mov    %esp,%ebp
801030b1:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
801030b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801030bb:	e8 b5 ff ff ff       	call   80103075 <cmos_read>
801030c0:	8b 55 08             	mov    0x8(%ebp),%edx
801030c3:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
801030c5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801030cc:	e8 a4 ff ff ff       	call   80103075 <cmos_read>
801030d1:	8b 55 08             	mov    0x8(%ebp),%edx
801030d4:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801030d7:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801030de:	e8 92 ff ff ff       	call   80103075 <cmos_read>
801030e3:	8b 55 08             	mov    0x8(%ebp),%edx
801030e6:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
801030e9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
801030f0:	e8 80 ff ff ff       	call   80103075 <cmos_read>
801030f5:	8b 55 08             	mov    0x8(%ebp),%edx
801030f8:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
801030fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103102:	e8 6e ff ff ff       	call   80103075 <cmos_read>
80103107:	8b 55 08             	mov    0x8(%ebp),%edx
8010310a:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010310d:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
80103114:	e8 5c ff ff ff       	call   80103075 <cmos_read>
80103119:	8b 55 08             	mov    0x8(%ebp),%edx
8010311c:	89 42 14             	mov    %eax,0x14(%edx)
}
8010311f:	c9                   	leave  
80103120:	c3                   	ret    

80103121 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103121:	55                   	push   %ebp
80103122:	89 e5                	mov    %esp,%ebp
80103124:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103127:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
8010312e:	e8 42 ff ff ff       	call   80103075 <cmos_read>
80103133:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103136:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103139:	83 e0 04             	and    $0x4,%eax
8010313c:	85 c0                	test   %eax,%eax
8010313e:	0f 94 c0             	sete   %al
80103141:	0f b6 c0             	movzbl %al,%eax
80103144:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80103147:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010314a:	89 04 24             	mov    %eax,(%esp)
8010314d:	e8 5c ff ff ff       	call   801030ae <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103152:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80103159:	e8 17 ff ff ff       	call   80103075 <cmos_read>
8010315e:	25 80 00 00 00       	and    $0x80,%eax
80103163:	85 c0                	test   %eax,%eax
80103165:	74 02                	je     80103169 <cmostime+0x48>
        continue;
80103167:	eb 36                	jmp    8010319f <cmostime+0x7e>
    fill_rtcdate(&t2);
80103169:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010316c:	89 04 24             	mov    %eax,(%esp)
8010316f:	e8 3a ff ff ff       	call   801030ae <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103174:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010317b:	00 
8010317c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010317f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103183:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103186:	89 04 24             	mov    %eax,(%esp)
80103189:	e8 1a 21 00 00       	call   801052a8 <memcmp>
8010318e:	85 c0                	test   %eax,%eax
80103190:	75 0d                	jne    8010319f <cmostime+0x7e>
      break;
80103192:	90                   	nop
  }

  // convert
  if(bcd) {
80103193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103197:	0f 84 ac 00 00 00    	je     80103249 <cmostime+0x128>
8010319d:	eb 02                	jmp    801031a1 <cmostime+0x80>
  }
8010319f:	eb a6                	jmp    80103147 <cmostime+0x26>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031a4:	c1 e8 04             	shr    $0x4,%eax
801031a7:	89 c2                	mov    %eax,%edx
801031a9:	89 d0                	mov    %edx,%eax
801031ab:	c1 e0 02             	shl    $0x2,%eax
801031ae:	01 d0                	add    %edx,%eax
801031b0:	01 c0                	add    %eax,%eax
801031b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
801031b5:	83 e2 0f             	and    $0xf,%edx
801031b8:	01 d0                	add    %edx,%eax
801031ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801031bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031c0:	c1 e8 04             	shr    $0x4,%eax
801031c3:	89 c2                	mov    %eax,%edx
801031c5:	89 d0                	mov    %edx,%eax
801031c7:	c1 e0 02             	shl    $0x2,%eax
801031ca:	01 d0                	add    %edx,%eax
801031cc:	01 c0                	add    %eax,%eax
801031ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
801031d1:	83 e2 0f             	and    $0xf,%edx
801031d4:	01 d0                	add    %edx,%eax
801031d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801031d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031dc:	c1 e8 04             	shr    $0x4,%eax
801031df:	89 c2                	mov    %eax,%edx
801031e1:	89 d0                	mov    %edx,%eax
801031e3:	c1 e0 02             	shl    $0x2,%eax
801031e6:	01 d0                	add    %edx,%eax
801031e8:	01 c0                	add    %eax,%eax
801031ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
801031ed:	83 e2 0f             	and    $0xf,%edx
801031f0:	01 d0                	add    %edx,%eax
801031f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801031f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031f8:	c1 e8 04             	shr    $0x4,%eax
801031fb:	89 c2                	mov    %eax,%edx
801031fd:	89 d0                	mov    %edx,%eax
801031ff:	c1 e0 02             	shl    $0x2,%eax
80103202:	01 d0                	add    %edx,%eax
80103204:	01 c0                	add    %eax,%eax
80103206:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103209:	83 e2 0f             	and    $0xf,%edx
8010320c:	01 d0                	add    %edx,%eax
8010320e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103211:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103214:	c1 e8 04             	shr    $0x4,%eax
80103217:	89 c2                	mov    %eax,%edx
80103219:	89 d0                	mov    %edx,%eax
8010321b:	c1 e0 02             	shl    $0x2,%eax
8010321e:	01 d0                	add    %edx,%eax
80103220:	01 c0                	add    %eax,%eax
80103222:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103225:	83 e2 0f             	and    $0xf,%edx
80103228:	01 d0                	add    %edx,%eax
8010322a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010322d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103230:	c1 e8 04             	shr    $0x4,%eax
80103233:	89 c2                	mov    %eax,%edx
80103235:	89 d0                	mov    %edx,%eax
80103237:	c1 e0 02             	shl    $0x2,%eax
8010323a:	01 d0                	add    %edx,%eax
8010323c:	01 c0                	add    %eax,%eax
8010323e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103241:	83 e2 0f             	and    $0xf,%edx
80103244:	01 d0                	add    %edx,%eax
80103246:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103249:	8b 45 08             	mov    0x8(%ebp),%eax
8010324c:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010324f:	89 10                	mov    %edx,(%eax)
80103251:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103254:	89 50 04             	mov    %edx,0x4(%eax)
80103257:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010325a:	89 50 08             	mov    %edx,0x8(%eax)
8010325d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103260:	89 50 0c             	mov    %edx,0xc(%eax)
80103263:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103266:	89 50 10             	mov    %edx,0x10(%eax)
80103269:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010326c:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
8010326f:	8b 45 08             	mov    0x8(%ebp),%eax
80103272:	8b 40 14             	mov    0x14(%eax),%eax
80103275:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010327b:	8b 45 08             	mov    0x8(%ebp),%eax
8010327e:	89 50 14             	mov    %edx,0x14(%eax)
}
80103281:	c9                   	leave  
80103282:	c3                   	ret    

80103283 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103283:	55                   	push   %ebp
80103284:	89 e5                	mov    %esp,%ebp
80103286:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103289:	c7 44 24 04 11 87 10 	movl   $0x80108711,0x4(%esp)
80103290:	80 
80103291:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80103298:	e8 01 1d 00 00       	call   80104f9e <initlock>
  readsb(dev, &sb);
8010329d:	8d 45 dc             	lea    -0x24(%ebp),%eax
801032a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801032a4:	8b 45 08             	mov    0x8(%ebp),%eax
801032a7:	89 04 24             	mov    %eax,(%esp)
801032aa:	e8 a1 e0 ff ff       	call   80101350 <readsb>
  log.start = sb.logstart;
801032af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032b2:	a3 54 37 11 80       	mov    %eax,0x80113754
  log.size = sb.nlog;
801032b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032ba:	a3 58 37 11 80       	mov    %eax,0x80113758
  log.dev = dev;
801032bf:	8b 45 08             	mov    0x8(%ebp),%eax
801032c2:	a3 64 37 11 80       	mov    %eax,0x80113764
  recover_from_log();
801032c7:	e8 9a 01 00 00       	call   80103466 <recover_from_log>
}
801032cc:	c9                   	leave  
801032cd:	c3                   	ret    

801032ce <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801032ce:	55                   	push   %ebp
801032cf:	89 e5                	mov    %esp,%ebp
801032d1:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032db:	e9 8c 00 00 00       	jmp    8010336c <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032e0:	8b 15 54 37 11 80    	mov    0x80113754,%edx
801032e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032e9:	01 d0                	add    %edx,%eax
801032eb:	83 c0 01             	add    $0x1,%eax
801032ee:	89 c2                	mov    %eax,%edx
801032f0:	a1 64 37 11 80       	mov    0x80113764,%eax
801032f5:	89 54 24 04          	mov    %edx,0x4(%esp)
801032f9:	89 04 24             	mov    %eax,(%esp)
801032fc:	e8 b4 ce ff ff       	call   801001b5 <bread>
80103301:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103307:	83 c0 10             	add    $0x10,%eax
8010330a:	8b 04 85 2c 37 11 80 	mov    -0x7feec8d4(,%eax,4),%eax
80103311:	89 c2                	mov    %eax,%edx
80103313:	a1 64 37 11 80       	mov    0x80113764,%eax
80103318:	89 54 24 04          	mov    %edx,0x4(%esp)
8010331c:	89 04 24             	mov    %eax,(%esp)
8010331f:	e8 91 ce ff ff       	call   801001b5 <bread>
80103324:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103327:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010332a:	8d 50 5c             	lea    0x5c(%eax),%edx
8010332d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103330:	83 c0 5c             	add    $0x5c,%eax
80103333:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010333a:	00 
8010333b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010333f:	89 04 24             	mov    %eax,(%esp)
80103342:	e8 b9 1f 00 00       	call   80105300 <memmove>
    bwrite(dbuf);  // write dst to disk
80103347:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010334a:	89 04 24             	mov    %eax,(%esp)
8010334d:	e8 9a ce ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
80103352:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103355:	89 04 24             	mov    %eax,(%esp)
80103358:	e8 cf ce ff ff       	call   8010022c <brelse>
    brelse(dbuf);
8010335d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103360:	89 04 24             	mov    %eax,(%esp)
80103363:	e8 c4 ce ff ff       	call   8010022c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103368:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010336c:	a1 68 37 11 80       	mov    0x80113768,%eax
80103371:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103374:	0f 8f 66 ff ff ff    	jg     801032e0 <install_trans+0x12>
  }
}
8010337a:	c9                   	leave  
8010337b:	c3                   	ret    

8010337c <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010337c:	55                   	push   %ebp
8010337d:	89 e5                	mov    %esp,%ebp
8010337f:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103382:	a1 54 37 11 80       	mov    0x80113754,%eax
80103387:	89 c2                	mov    %eax,%edx
80103389:	a1 64 37 11 80       	mov    0x80113764,%eax
8010338e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103392:	89 04 24             	mov    %eax,(%esp)
80103395:	e8 1b ce ff ff       	call   801001b5 <bread>
8010339a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010339d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033a0:	83 c0 5c             	add    $0x5c,%eax
801033a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801033a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033a9:	8b 00                	mov    (%eax),%eax
801033ab:	a3 68 37 11 80       	mov    %eax,0x80113768
  for (i = 0; i < log.lh.n; i++) {
801033b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033b7:	eb 1b                	jmp    801033d4 <read_head+0x58>
    log.lh.block[i] = lh->block[i];
801033b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033bf:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801033c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033c6:	83 c2 10             	add    $0x10,%edx
801033c9:	89 04 95 2c 37 11 80 	mov    %eax,-0x7feec8d4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801033d0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033d4:	a1 68 37 11 80       	mov    0x80113768,%eax
801033d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033dc:	7f db                	jg     801033b9 <read_head+0x3d>
  }
  brelse(buf);
801033de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033e1:	89 04 24             	mov    %eax,(%esp)
801033e4:	e8 43 ce ff ff       	call   8010022c <brelse>
}
801033e9:	c9                   	leave  
801033ea:	c3                   	ret    

801033eb <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801033eb:	55                   	push   %ebp
801033ec:	89 e5                	mov    %esp,%ebp
801033ee:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801033f1:	a1 54 37 11 80       	mov    0x80113754,%eax
801033f6:	89 c2                	mov    %eax,%edx
801033f8:	a1 64 37 11 80       	mov    0x80113764,%eax
801033fd:	89 54 24 04          	mov    %edx,0x4(%esp)
80103401:	89 04 24             	mov    %eax,(%esp)
80103404:	e8 ac cd ff ff       	call   801001b5 <bread>
80103409:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010340c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010340f:	83 c0 5c             	add    $0x5c,%eax
80103412:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103415:	8b 15 68 37 11 80    	mov    0x80113768,%edx
8010341b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010341e:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103420:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103427:	eb 1b                	jmp    80103444 <write_head+0x59>
    hb->block[i] = log.lh.block[i];
80103429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010342c:	83 c0 10             	add    $0x10,%eax
8010342f:	8b 0c 85 2c 37 11 80 	mov    -0x7feec8d4(,%eax,4),%ecx
80103436:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103439:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010343c:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103440:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103444:	a1 68 37 11 80       	mov    0x80113768,%eax
80103449:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010344c:	7f db                	jg     80103429 <write_head+0x3e>
  }
  bwrite(buf);
8010344e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103451:	89 04 24             	mov    %eax,(%esp)
80103454:	e8 93 cd ff ff       	call   801001ec <bwrite>
  brelse(buf);
80103459:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010345c:	89 04 24             	mov    %eax,(%esp)
8010345f:	e8 c8 cd ff ff       	call   8010022c <brelse>
}
80103464:	c9                   	leave  
80103465:	c3                   	ret    

80103466 <recover_from_log>:

static void
recover_from_log(void)
{
80103466:	55                   	push   %ebp
80103467:	89 e5                	mov    %esp,%ebp
80103469:	83 ec 08             	sub    $0x8,%esp
  read_head();
8010346c:	e8 0b ff ff ff       	call   8010337c <read_head>
  install_trans(); // if committed, copy from log to disk
80103471:	e8 58 fe ff ff       	call   801032ce <install_trans>
  log.lh.n = 0;
80103476:	c7 05 68 37 11 80 00 	movl   $0x0,0x80113768
8010347d:	00 00 00 
  write_head(); // clear the log
80103480:	e8 66 ff ff ff       	call   801033eb <write_head>
}
80103485:	c9                   	leave  
80103486:	c3                   	ret    

80103487 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103487:	55                   	push   %ebp
80103488:	89 e5                	mov    %esp,%ebp
8010348a:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
8010348d:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80103494:	e8 26 1b 00 00       	call   80104fbf <acquire>
  while(1){
    if(log.committing){
80103499:	a1 60 37 11 80       	mov    0x80113760,%eax
8010349e:	85 c0                	test   %eax,%eax
801034a0:	74 16                	je     801034b8 <begin_op+0x31>
      sleep(&log, &log.lock);
801034a2:	c7 44 24 04 20 37 11 	movl   $0x80113720,0x4(%esp)
801034a9:	80 
801034aa:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801034b1:	e8 0e 17 00 00       	call   80104bc4 <sleep>
801034b6:	eb 4f                	jmp    80103507 <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034b8:	8b 0d 68 37 11 80    	mov    0x80113768,%ecx
801034be:	a1 5c 37 11 80       	mov    0x8011375c,%eax
801034c3:	8d 50 01             	lea    0x1(%eax),%edx
801034c6:	89 d0                	mov    %edx,%eax
801034c8:	c1 e0 02             	shl    $0x2,%eax
801034cb:	01 d0                	add    %edx,%eax
801034cd:	01 c0                	add    %eax,%eax
801034cf:	01 c8                	add    %ecx,%eax
801034d1:	83 f8 1e             	cmp    $0x1e,%eax
801034d4:	7e 16                	jle    801034ec <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801034d6:	c7 44 24 04 20 37 11 	movl   $0x80113720,0x4(%esp)
801034dd:	80 
801034de:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801034e5:	e8 da 16 00 00       	call   80104bc4 <sleep>
801034ea:	eb 1b                	jmp    80103507 <begin_op+0x80>
    } else {
      log.outstanding += 1;
801034ec:	a1 5c 37 11 80       	mov    0x8011375c,%eax
801034f1:	83 c0 01             	add    $0x1,%eax
801034f4:	a3 5c 37 11 80       	mov    %eax,0x8011375c
      release(&log.lock);
801034f9:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80103500:	e8 22 1b 00 00       	call   80105027 <release>
      break;
80103505:	eb 02                	jmp    80103509 <begin_op+0x82>
    }
  }
80103507:	eb 90                	jmp    80103499 <begin_op+0x12>
}
80103509:	c9                   	leave  
8010350a:	c3                   	ret    

8010350b <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010350b:	55                   	push   %ebp
8010350c:	89 e5                	mov    %esp,%ebp
8010350e:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
80103511:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103518:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
8010351f:	e8 9b 1a 00 00       	call   80104fbf <acquire>
  log.outstanding -= 1;
80103524:	a1 5c 37 11 80       	mov    0x8011375c,%eax
80103529:	83 e8 01             	sub    $0x1,%eax
8010352c:	a3 5c 37 11 80       	mov    %eax,0x8011375c
  if(log.committing)
80103531:	a1 60 37 11 80       	mov    0x80113760,%eax
80103536:	85 c0                	test   %eax,%eax
80103538:	74 0c                	je     80103546 <end_op+0x3b>
    panic("log.committing");
8010353a:	c7 04 24 15 87 10 80 	movl   $0x80108715,(%esp)
80103541:	e8 1c d0 ff ff       	call   80100562 <panic>
  if(log.outstanding == 0){
80103546:	a1 5c 37 11 80       	mov    0x8011375c,%eax
8010354b:	85 c0                	test   %eax,%eax
8010354d:	75 13                	jne    80103562 <end_op+0x57>
    do_commit = 1;
8010354f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103556:	c7 05 60 37 11 80 01 	movl   $0x1,0x80113760
8010355d:	00 00 00 
80103560:	eb 0c                	jmp    8010356e <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103562:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80103569:	e8 2d 17 00 00       	call   80104c9b <wakeup>
  }
  release(&log.lock);
8010356e:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80103575:	e8 ad 1a 00 00       	call   80105027 <release>

  if(do_commit){
8010357a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010357e:	74 33                	je     801035b3 <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103580:	e8 de 00 00 00       	call   80103663 <commit>
    acquire(&log.lock);
80103585:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
8010358c:	e8 2e 1a 00 00       	call   80104fbf <acquire>
    log.committing = 0;
80103591:	c7 05 60 37 11 80 00 	movl   $0x0,0x80113760
80103598:	00 00 00 
    wakeup(&log);
8010359b:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801035a2:	e8 f4 16 00 00       	call   80104c9b <wakeup>
    release(&log.lock);
801035a7:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801035ae:	e8 74 1a 00 00       	call   80105027 <release>
  }
}
801035b3:	c9                   	leave  
801035b4:	c3                   	ret    

801035b5 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801035b5:	55                   	push   %ebp
801035b6:	89 e5                	mov    %esp,%ebp
801035b8:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035c2:	e9 8c 00 00 00       	jmp    80103653 <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801035c7:	8b 15 54 37 11 80    	mov    0x80113754,%edx
801035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035d0:	01 d0                	add    %edx,%eax
801035d2:	83 c0 01             	add    $0x1,%eax
801035d5:	89 c2                	mov    %eax,%edx
801035d7:	a1 64 37 11 80       	mov    0x80113764,%eax
801035dc:	89 54 24 04          	mov    %edx,0x4(%esp)
801035e0:	89 04 24             	mov    %eax,(%esp)
801035e3:	e8 cd cb ff ff       	call   801001b5 <bread>
801035e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801035eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035ee:	83 c0 10             	add    $0x10,%eax
801035f1:	8b 04 85 2c 37 11 80 	mov    -0x7feec8d4(,%eax,4),%eax
801035f8:	89 c2                	mov    %eax,%edx
801035fa:	a1 64 37 11 80       	mov    0x80113764,%eax
801035ff:	89 54 24 04          	mov    %edx,0x4(%esp)
80103603:	89 04 24             	mov    %eax,(%esp)
80103606:	e8 aa cb ff ff       	call   801001b5 <bread>
8010360b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010360e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103611:	8d 50 5c             	lea    0x5c(%eax),%edx
80103614:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103617:	83 c0 5c             	add    $0x5c,%eax
8010361a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103621:	00 
80103622:	89 54 24 04          	mov    %edx,0x4(%esp)
80103626:	89 04 24             	mov    %eax,(%esp)
80103629:	e8 d2 1c 00 00       	call   80105300 <memmove>
    bwrite(to);  // write the log
8010362e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103631:	89 04 24             	mov    %eax,(%esp)
80103634:	e8 b3 cb ff ff       	call   801001ec <bwrite>
    brelse(from);
80103639:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010363c:	89 04 24             	mov    %eax,(%esp)
8010363f:	e8 e8 cb ff ff       	call   8010022c <brelse>
    brelse(to);
80103644:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103647:	89 04 24             	mov    %eax,(%esp)
8010364a:	e8 dd cb ff ff       	call   8010022c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010364f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103653:	a1 68 37 11 80       	mov    0x80113768,%eax
80103658:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010365b:	0f 8f 66 ff ff ff    	jg     801035c7 <write_log+0x12>
  }
}
80103661:	c9                   	leave  
80103662:	c3                   	ret    

80103663 <commit>:

static void
commit()
{
80103663:	55                   	push   %ebp
80103664:	89 e5                	mov    %esp,%ebp
80103666:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103669:	a1 68 37 11 80       	mov    0x80113768,%eax
8010366e:	85 c0                	test   %eax,%eax
80103670:	7e 1e                	jle    80103690 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103672:	e8 3e ff ff ff       	call   801035b5 <write_log>
    write_head();    // Write header to disk -- the real commit
80103677:	e8 6f fd ff ff       	call   801033eb <write_head>
    install_trans(); // Now install writes to home locations
8010367c:	e8 4d fc ff ff       	call   801032ce <install_trans>
    log.lh.n = 0;
80103681:	c7 05 68 37 11 80 00 	movl   $0x0,0x80113768
80103688:	00 00 00 
    write_head();    // Erase the transaction from the log
8010368b:	e8 5b fd ff ff       	call   801033eb <write_head>
  }
}
80103690:	c9                   	leave  
80103691:	c3                   	ret    

80103692 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103692:	55                   	push   %ebp
80103693:	89 e5                	mov    %esp,%ebp
80103695:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103698:	a1 68 37 11 80       	mov    0x80113768,%eax
8010369d:	83 f8 1d             	cmp    $0x1d,%eax
801036a0:	7f 12                	jg     801036b4 <log_write+0x22>
801036a2:	a1 68 37 11 80       	mov    0x80113768,%eax
801036a7:	8b 15 58 37 11 80    	mov    0x80113758,%edx
801036ad:	83 ea 01             	sub    $0x1,%edx
801036b0:	39 d0                	cmp    %edx,%eax
801036b2:	7c 0c                	jl     801036c0 <log_write+0x2e>
    panic("too big a transaction");
801036b4:	c7 04 24 24 87 10 80 	movl   $0x80108724,(%esp)
801036bb:	e8 a2 ce ff ff       	call   80100562 <panic>
  if (log.outstanding < 1)
801036c0:	a1 5c 37 11 80       	mov    0x8011375c,%eax
801036c5:	85 c0                	test   %eax,%eax
801036c7:	7f 0c                	jg     801036d5 <log_write+0x43>
    panic("log_write outside of trans");
801036c9:	c7 04 24 3a 87 10 80 	movl   $0x8010873a,(%esp)
801036d0:	e8 8d ce ff ff       	call   80100562 <panic>

  acquire(&log.lock);
801036d5:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801036dc:	e8 de 18 00 00       	call   80104fbf <acquire>
  for (i = 0; i < log.lh.n; i++) {
801036e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036e8:	eb 1f                	jmp    80103709 <log_write+0x77>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ed:	83 c0 10             	add    $0x10,%eax
801036f0:	8b 04 85 2c 37 11 80 	mov    -0x7feec8d4(,%eax,4),%eax
801036f7:	89 c2                	mov    %eax,%edx
801036f9:	8b 45 08             	mov    0x8(%ebp),%eax
801036fc:	8b 40 08             	mov    0x8(%eax),%eax
801036ff:	39 c2                	cmp    %eax,%edx
80103701:	75 02                	jne    80103705 <log_write+0x73>
      break;
80103703:	eb 0e                	jmp    80103713 <log_write+0x81>
  for (i = 0; i < log.lh.n; i++) {
80103705:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103709:	a1 68 37 11 80       	mov    0x80113768,%eax
8010370e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103711:	7f d7                	jg     801036ea <log_write+0x58>
  }
  log.lh.block[i] = b->blockno;
80103713:	8b 45 08             	mov    0x8(%ebp),%eax
80103716:	8b 40 08             	mov    0x8(%eax),%eax
80103719:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010371c:	83 c2 10             	add    $0x10,%edx
8010371f:	89 04 95 2c 37 11 80 	mov    %eax,-0x7feec8d4(,%edx,4)
  if (i == log.lh.n)
80103726:	a1 68 37 11 80       	mov    0x80113768,%eax
8010372b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010372e:	75 0d                	jne    8010373d <log_write+0xab>
    log.lh.n++;
80103730:	a1 68 37 11 80       	mov    0x80113768,%eax
80103735:	83 c0 01             	add    $0x1,%eax
80103738:	a3 68 37 11 80       	mov    %eax,0x80113768
  b->flags |= B_DIRTY; // prevent eviction
8010373d:	8b 45 08             	mov    0x8(%ebp),%eax
80103740:	8b 00                	mov    (%eax),%eax
80103742:	83 c8 04             	or     $0x4,%eax
80103745:	89 c2                	mov    %eax,%edx
80103747:	8b 45 08             	mov    0x8(%ebp),%eax
8010374a:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010374c:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80103753:	e8 cf 18 00 00       	call   80105027 <release>
}
80103758:	c9                   	leave  
80103759:	c3                   	ret    

8010375a <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010375a:	55                   	push   %ebp
8010375b:	89 e5                	mov    %esp,%ebp
8010375d:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103760:	8b 55 08             	mov    0x8(%ebp),%edx
80103763:	8b 45 0c             	mov    0xc(%ebp),%eax
80103766:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103769:	f0 87 02             	lock xchg %eax,(%edx)
8010376c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010376f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103772:	c9                   	leave  
80103773:	c3                   	ret    

80103774 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103774:	55                   	push   %ebp
80103775:	89 e5                	mov    %esp,%ebp
80103777:	83 e4 f0             	and    $0xfffffff0,%esp
8010377a:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010377d:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103784:	80 
80103785:	c7 04 24 48 67 11 80 	movl   $0x80116748,(%esp)
8010378c:	e8 ed f2 ff ff       	call   80102a7e <kinit1>
  kvmalloc();      // kernel page table
80103791:	e8 f8 44 00 00       	call   80107c8e <kvmalloc>
  mpinit();        // detect other processors
80103796:	e8 cb 03 00 00       	call   80103b66 <mpinit>
  lapicinit();     // interrupt controller
8010379b:	e8 36 f6 ff ff       	call   80102dd6 <lapicinit>
  seginit();       // segment descriptors
801037a0:	e8 b5 3f 00 00       	call   8010775a <seginit>
  picinit();       // disable pic
801037a5:	e8 0b 05 00 00       	call   80103cb5 <picinit>
  ioapicinit();    // another interrupt controller
801037aa:	e8 eb f1 ff ff       	call   8010299a <ioapicinit>
  consoleinit();   // console hardware
801037af:	e8 1c d3 ff ff       	call   80100ad0 <consoleinit>
  uartinit();      // serial port
801037b4:	e8 2b 33 00 00       	call   80106ae4 <uartinit>
  pinit();         // process table
801037b9:	e8 3d 0a 00 00       	call   801041fb <pinit>
  tvinit();        // trap vectors
801037be:	e8 ea 2e 00 00       	call   801066ad <tvinit>
  binit();         // buffer cache
801037c3:	e8 6c c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801037c8:	e8 9c d7 ff ff       	call   80100f69 <fileinit>
  ideinit();       // disk 
801037cd:	e8 d2 ed ff ff       	call   801025a4 <ideinit>
  startothers();   // start other processors
801037d2:	e8 83 00 00 00       	call   8010385a <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037d7:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801037de:	8e 
801037df:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801037e6:	e8 cb f2 ff ff       	call   80102ab6 <kinit2>
  userinit();      // first user process
801037eb:	e8 f3 0b 00 00       	call   801043e3 <userinit>
  mpmain();        // finish this processor's setup
801037f0:	e8 1a 00 00 00       	call   8010380f <mpmain>

801037f5 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801037f5:	55                   	push   %ebp
801037f6:	89 e5                	mov    %esp,%ebp
801037f8:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801037fb:	e8 a5 44 00 00       	call   80107ca5 <switchkvm>
  seginit();
80103800:	e8 55 3f 00 00       	call   8010775a <seginit>
  lapicinit();
80103805:	e8 cc f5 ff ff       	call   80102dd6 <lapicinit>
  mpmain();
8010380a:	e8 00 00 00 00       	call   8010380f <mpmain>

8010380f <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010380f:	55                   	push   %ebp
80103810:	89 e5                	mov    %esp,%ebp
80103812:	53                   	push   %ebx
80103813:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103816:	e8 fc 09 00 00       	call   80104217 <cpuid>
8010381b:	89 c3                	mov    %eax,%ebx
8010381d:	e8 f5 09 00 00       	call   80104217 <cpuid>
80103822:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80103826:	89 44 24 04          	mov    %eax,0x4(%esp)
8010382a:	c7 04 24 55 87 10 80 	movl   $0x80108755,(%esp)
80103831:	e8 92 cb ff ff       	call   801003c8 <cprintf>
  idtinit();       // load idt register
80103836:	e8 e6 2f 00 00       	call   80106821 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
8010383b:	e8 f8 09 00 00       	call   80104238 <mycpu>
80103840:	05 a0 00 00 00       	add    $0xa0,%eax
80103845:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010384c:	00 
8010384d:	89 04 24             	mov    %eax,(%esp)
80103850:	e8 05 ff ff ff       	call   8010375a <xchg>
  scheduler();     // start running processes
80103855:	e8 12 11 00 00       	call   8010496c <scheduler>

8010385a <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010385a:	55                   	push   %ebp
8010385b:	89 e5                	mov    %esp,%ebp
8010385d:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103860:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103867:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010386c:	89 44 24 08          	mov    %eax,0x8(%esp)
80103870:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
80103877:	80 
80103878:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010387b:	89 04 24             	mov    %eax,(%esp)
8010387e:	e8 7d 1a 00 00       	call   80105300 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103883:	c7 45 f4 20 38 11 80 	movl   $0x80113820,-0xc(%ebp)
8010388a:	eb 76                	jmp    80103902 <startothers+0xa8>
    if(c == mycpu())  // We've started already.
8010388c:	e8 a7 09 00 00       	call   80104238 <mycpu>
80103891:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103894:	75 02                	jne    80103898 <startothers+0x3e>
      continue;
80103896:	eb 63                	jmp    801038fb <startothers+0xa1>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103898:	e8 0c f3 ff ff       	call   80102ba9 <kalloc>
8010389d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801038a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a3:	83 e8 04             	sub    $0x4,%eax
801038a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801038a9:	81 c2 00 10 00 00    	add    $0x1000,%edx
801038af:	89 10                	mov    %edx,(%eax)
    *(void(**)(void))(code-8) = mpenter;
801038b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038b4:	83 e8 08             	sub    $0x8,%eax
801038b7:	c7 00 f5 37 10 80    	movl   $0x801037f5,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801038bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c0:	8d 50 f4             	lea    -0xc(%eax),%edx
801038c3:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
801038c8:	05 00 00 00 80       	add    $0x80000000,%eax
801038cd:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
801038cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d2:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801038d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038db:	0f b6 00             	movzbl (%eax),%eax
801038de:	0f b6 c0             	movzbl %al,%eax
801038e1:	89 54 24 04          	mov    %edx,0x4(%esp)
801038e5:	89 04 24             	mov    %eax,(%esp)
801038e8:	e8 8e f6 ff ff       	call   80102f7b <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801038ed:	90                   	nop
801038ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038f1:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
801038f7:	85 c0                	test   %eax,%eax
801038f9:	74 f3                	je     801038ee <startothers+0x94>
  for(c = cpus; c < cpus+ncpu; c++){
801038fb:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103902:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
80103907:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010390d:	05 20 38 11 80       	add    $0x80113820,%eax
80103912:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103915:	0f 87 71 ff ff ff    	ja     8010388c <startothers+0x32>
      ;
  }
}
8010391b:	c9                   	leave  
8010391c:	c3                   	ret    

8010391d <inb>:
{
8010391d:	55                   	push   %ebp
8010391e:	89 e5                	mov    %esp,%ebp
80103920:	83 ec 14             	sub    $0x14,%esp
80103923:	8b 45 08             	mov    0x8(%ebp),%eax
80103926:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010392a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010392e:	89 c2                	mov    %eax,%edx
80103930:	ec                   	in     (%dx),%al
80103931:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103934:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103938:	c9                   	leave  
80103939:	c3                   	ret    

8010393a <outb>:
{
8010393a:	55                   	push   %ebp
8010393b:	89 e5                	mov    %esp,%ebp
8010393d:	83 ec 08             	sub    $0x8,%esp
80103940:	8b 55 08             	mov    0x8(%ebp),%edx
80103943:	8b 45 0c             	mov    0xc(%ebp),%eax
80103946:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010394a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010394d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103951:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103955:	ee                   	out    %al,(%dx)
}
80103956:	c9                   	leave  
80103957:	c3                   	ret    

80103958 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103958:	55                   	push   %ebp
80103959:	89 e5                	mov    %esp,%ebp
8010395b:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
8010395e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103965:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010396c:	eb 15                	jmp    80103983 <sum+0x2b>
    sum += addr[i];
8010396e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103971:	8b 45 08             	mov    0x8(%ebp),%eax
80103974:	01 d0                	add    %edx,%eax
80103976:	0f b6 00             	movzbl (%eax),%eax
80103979:	0f b6 c0             	movzbl %al,%eax
8010397c:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
8010397f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103983:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103986:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103989:	7c e3                	jl     8010396e <sum+0x16>
  return sum;
8010398b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010398e:	c9                   	leave  
8010398f:	c3                   	ret    

80103990 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103996:	8b 45 08             	mov    0x8(%ebp),%eax
80103999:	05 00 00 00 80       	add    $0x80000000,%eax
8010399e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801039a1:	8b 55 0c             	mov    0xc(%ebp),%edx
801039a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039a7:	01 d0                	add    %edx,%eax
801039a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801039ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039af:	89 45 f4             	mov    %eax,-0xc(%ebp)
801039b2:	eb 3f                	jmp    801039f3 <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039b4:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801039bb:	00 
801039bc:	c7 44 24 04 6c 87 10 	movl   $0x8010876c,0x4(%esp)
801039c3:	80 
801039c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039c7:	89 04 24             	mov    %eax,(%esp)
801039ca:	e8 d9 18 00 00       	call   801052a8 <memcmp>
801039cf:	85 c0                	test   %eax,%eax
801039d1:	75 1c                	jne    801039ef <mpsearch1+0x5f>
801039d3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801039da:	00 
801039db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039de:	89 04 24             	mov    %eax,(%esp)
801039e1:	e8 72 ff ff ff       	call   80103958 <sum>
801039e6:	84 c0                	test   %al,%al
801039e8:	75 05                	jne    801039ef <mpsearch1+0x5f>
      return (struct mp*)p;
801039ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ed:	eb 11                	jmp    80103a00 <mpsearch1+0x70>
  for(p = addr; p < e; p += sizeof(struct mp))
801039ef:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801039f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039f6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039f9:	72 b9                	jb     801039b4 <mpsearch1+0x24>
  return 0;
801039fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a00:	c9                   	leave  
80103a01:	c3                   	ret    

80103a02 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103a02:	55                   	push   %ebp
80103a03:	89 e5                	mov    %esp,%ebp
80103a05:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103a08:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a12:	83 c0 0f             	add    $0xf,%eax
80103a15:	0f b6 00             	movzbl (%eax),%eax
80103a18:	0f b6 c0             	movzbl %al,%eax
80103a1b:	c1 e0 08             	shl    $0x8,%eax
80103a1e:	89 c2                	mov    %eax,%edx
80103a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a23:	83 c0 0e             	add    $0xe,%eax
80103a26:	0f b6 00             	movzbl (%eax),%eax
80103a29:	0f b6 c0             	movzbl %al,%eax
80103a2c:	09 d0                	or     %edx,%eax
80103a2e:	c1 e0 04             	shl    $0x4,%eax
80103a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103a38:	74 21                	je     80103a5b <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103a3a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a41:	00 
80103a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a45:	89 04 24             	mov    %eax,(%esp)
80103a48:	e8 43 ff ff ff       	call   80103990 <mpsearch1>
80103a4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a50:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a54:	74 50                	je     80103aa6 <mpsearch+0xa4>
      return mp;
80103a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a59:	eb 5f                	jmp    80103aba <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a5e:	83 c0 14             	add    $0x14,%eax
80103a61:	0f b6 00             	movzbl (%eax),%eax
80103a64:	0f b6 c0             	movzbl %al,%eax
80103a67:	c1 e0 08             	shl    $0x8,%eax
80103a6a:	89 c2                	mov    %eax,%edx
80103a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a6f:	83 c0 13             	add    $0x13,%eax
80103a72:	0f b6 00             	movzbl (%eax),%eax
80103a75:	0f b6 c0             	movzbl %al,%eax
80103a78:	09 d0                	or     %edx,%eax
80103a7a:	c1 e0 0a             	shl    $0xa,%eax
80103a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a83:	2d 00 04 00 00       	sub    $0x400,%eax
80103a88:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a8f:	00 
80103a90:	89 04 24             	mov    %eax,(%esp)
80103a93:	e8 f8 fe ff ff       	call   80103990 <mpsearch1>
80103a98:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a9f:	74 05                	je     80103aa6 <mpsearch+0xa4>
      return mp;
80103aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103aa4:	eb 14                	jmp    80103aba <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103aa6:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103aad:	00 
80103aae:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103ab5:	e8 d6 fe ff ff       	call   80103990 <mpsearch1>
}
80103aba:	c9                   	leave  
80103abb:	c3                   	ret    

80103abc <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103abc:	55                   	push   %ebp
80103abd:	89 e5                	mov    %esp,%ebp
80103abf:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103ac2:	e8 3b ff ff ff       	call   80103a02 <mpsearch>
80103ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103aca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ace:	74 0a                	je     80103ada <mpconfig+0x1e>
80103ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ad3:	8b 40 04             	mov    0x4(%eax),%eax
80103ad6:	85 c0                	test   %eax,%eax
80103ad8:	75 0a                	jne    80103ae4 <mpconfig+0x28>
    return 0;
80103ada:	b8 00 00 00 00       	mov    $0x0,%eax
80103adf:	e9 80 00 00 00       	jmp    80103b64 <mpconfig+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae7:	8b 40 04             	mov    0x4(%eax),%eax
80103aea:	05 00 00 00 80       	add    $0x80000000,%eax
80103aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103af2:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103af9:	00 
80103afa:	c7 44 24 04 71 87 10 	movl   $0x80108771,0x4(%esp)
80103b01:	80 
80103b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b05:	89 04 24             	mov    %eax,(%esp)
80103b08:	e8 9b 17 00 00       	call   801052a8 <memcmp>
80103b0d:	85 c0                	test   %eax,%eax
80103b0f:	74 07                	je     80103b18 <mpconfig+0x5c>
    return 0;
80103b11:	b8 00 00 00 00       	mov    $0x0,%eax
80103b16:	eb 4c                	jmp    80103b64 <mpconfig+0xa8>
  if(conf->version != 1 && conf->version != 4)
80103b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b1b:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b1f:	3c 01                	cmp    $0x1,%al
80103b21:	74 12                	je     80103b35 <mpconfig+0x79>
80103b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b26:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b2a:	3c 04                	cmp    $0x4,%al
80103b2c:	74 07                	je     80103b35 <mpconfig+0x79>
    return 0;
80103b2e:	b8 00 00 00 00       	mov    $0x0,%eax
80103b33:	eb 2f                	jmp    80103b64 <mpconfig+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b38:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103b3c:	0f b7 c0             	movzwl %ax,%eax
80103b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b46:	89 04 24             	mov    %eax,(%esp)
80103b49:	e8 0a fe ff ff       	call   80103958 <sum>
80103b4e:	84 c0                	test   %al,%al
80103b50:	74 07                	je     80103b59 <mpconfig+0x9d>
    return 0;
80103b52:	b8 00 00 00 00       	mov    $0x0,%eax
80103b57:	eb 0b                	jmp    80103b64 <mpconfig+0xa8>
  *pmp = mp;
80103b59:	8b 45 08             	mov    0x8(%ebp),%eax
80103b5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b5f:	89 10                	mov    %edx,(%eax)
  return conf;
80103b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103b64:	c9                   	leave  
80103b65:	c3                   	ret    

80103b66 <mpinit>:

void
mpinit(void)
{
80103b66:	55                   	push   %ebp
80103b67:	89 e5                	mov    %esp,%ebp
80103b69:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103b6c:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103b6f:	89 04 24             	mov    %eax,(%esp)
80103b72:	e8 45 ff ff ff       	call   80103abc <mpconfig>
80103b77:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b7e:	75 0c                	jne    80103b8c <mpinit+0x26>
    panic("Expect to run on an SMP");
80103b80:	c7 04 24 76 87 10 80 	movl   $0x80108776,(%esp)
80103b87:	e8 d6 c9 ff ff       	call   80100562 <panic>
  ismp = 1;
80103b8c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b96:	8b 40 24             	mov    0x24(%eax),%eax
80103b99:	a3 1c 37 11 80       	mov    %eax,0x8011371c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ba1:	83 c0 2c             	add    $0x2c,%eax
80103ba4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103baa:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103bae:	0f b7 d0             	movzwl %ax,%edx
80103bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bb4:	01 d0                	add    %edx,%eax
80103bb6:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103bb9:	eb 7b                	jmp    80103c36 <mpinit+0xd0>
    switch(*p){
80103bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbe:	0f b6 00             	movzbl (%eax),%eax
80103bc1:	0f b6 c0             	movzbl %al,%eax
80103bc4:	83 f8 04             	cmp    $0x4,%eax
80103bc7:	77 65                	ja     80103c2e <mpinit+0xc8>
80103bc9:	8b 04 85 b0 87 10 80 	mov    -0x7fef7850(,%eax,4),%eax
80103bd0:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu < NCPU) {
80103bd8:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
80103bdd:	83 f8 07             	cmp    $0x7,%eax
80103be0:	7f 28                	jg     80103c0a <mpinit+0xa4>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103be2:	8b 15 a0 3d 11 80    	mov    0x80113da0,%edx
80103be8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103beb:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103bef:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80103bf5:	81 c2 20 38 11 80    	add    $0x80113820,%edx
80103bfb:	88 02                	mov    %al,(%edx)
        ncpu++;
80103bfd:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
80103c02:	83 c0 01             	add    $0x1,%eax
80103c05:	a3 a0 3d 11 80       	mov    %eax,0x80113da0
      }
      p += sizeof(struct mpproc);
80103c0a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103c0e:	eb 26                	jmp    80103c36 <mpinit+0xd0>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c13:	89 45 e0             	mov    %eax,-0x20(%ebp)
      ioapicid = ioapic->apicno;
80103c16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103c19:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c1d:	a2 00 38 11 80       	mov    %al,0x80113800
      p += sizeof(struct mpioapic);
80103c22:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103c26:	eb 0e                	jmp    80103c36 <mpinit+0xd0>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103c28:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103c2c:	eb 08                	jmp    80103c36 <mpinit+0xd0>
    default:
      ismp = 0;
80103c2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103c35:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c39:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103c3c:	0f 82 79 ff ff ff    	jb     80103bbb <mpinit+0x55>
    }
  }
  if(!ismp)
80103c42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c46:	75 0c                	jne    80103c54 <mpinit+0xee>
    panic("Didn't find a suitable machine");
80103c48:	c7 04 24 90 87 10 80 	movl   $0x80108790,(%esp)
80103c4f:	e8 0e c9 ff ff       	call   80100562 <panic>

  if(mp->imcrp){
80103c54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103c57:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103c5b:	84 c0                	test   %al,%al
80103c5d:	74 36                	je     80103c95 <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103c5f:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103c66:	00 
80103c67:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103c6e:	e8 c7 fc ff ff       	call   8010393a <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103c73:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103c7a:	e8 9e fc ff ff       	call   8010391d <inb>
80103c7f:	83 c8 01             	or     $0x1,%eax
80103c82:	0f b6 c0             	movzbl %al,%eax
80103c85:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c89:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103c90:	e8 a5 fc ff ff       	call   8010393a <outb>
  }
}
80103c95:	c9                   	leave  
80103c96:	c3                   	ret    

80103c97 <outb>:
{
80103c97:	55                   	push   %ebp
80103c98:	89 e5                	mov    %esp,%ebp
80103c9a:	83 ec 08             	sub    $0x8,%esp
80103c9d:	8b 55 08             	mov    0x8(%ebp),%edx
80103ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ca3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103ca7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103caa:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103cae:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103cb2:	ee                   	out    %al,(%dx)
}
80103cb3:	c9                   	leave  
80103cb4:	c3                   	ret    

80103cb5 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103cb5:	55                   	push   %ebp
80103cb6:	89 e5                	mov    %esp,%ebp
80103cb8:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103cbb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103cc2:	00 
80103cc3:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103cca:	e8 c8 ff ff ff       	call   80103c97 <outb>
  outb(IO_PIC2+1, 0xFF);
80103ccf:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103cd6:	00 
80103cd7:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103cde:	e8 b4 ff ff ff       	call   80103c97 <outb>
}
80103ce3:	c9                   	leave  
80103ce4:	c3                   	ret    

80103ce5 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103ce5:	55                   	push   %ebp
80103ce6:	89 e5                	mov    %esp,%ebp
80103ce8:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103ceb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cf5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cfe:	8b 10                	mov    (%eax),%edx
80103d00:	8b 45 08             	mov    0x8(%ebp),%eax
80103d03:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103d05:	e8 7b d2 ff ff       	call   80100f85 <filealloc>
80103d0a:	8b 55 08             	mov    0x8(%ebp),%edx
80103d0d:	89 02                	mov    %eax,(%edx)
80103d0f:	8b 45 08             	mov    0x8(%ebp),%eax
80103d12:	8b 00                	mov    (%eax),%eax
80103d14:	85 c0                	test   %eax,%eax
80103d16:	0f 84 c8 00 00 00    	je     80103de4 <pipealloc+0xff>
80103d1c:	e8 64 d2 ff ff       	call   80100f85 <filealloc>
80103d21:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d24:	89 02                	mov    %eax,(%edx)
80103d26:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d29:	8b 00                	mov    (%eax),%eax
80103d2b:	85 c0                	test   %eax,%eax
80103d2d:	0f 84 b1 00 00 00    	je     80103de4 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103d33:	e8 71 ee ff ff       	call   80102ba9 <kalloc>
80103d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d3f:	75 05                	jne    80103d46 <pipealloc+0x61>
    goto bad;
80103d41:	e9 9e 00 00 00       	jmp    80103de4 <pipealloc+0xff>
  p->readopen = 1;
80103d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d49:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d50:	00 00 00 
  p->writeopen = 1;
80103d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d56:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d5d:	00 00 00 
  p->nwrite = 0;
80103d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d63:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d6a:	00 00 00 
  p->nread = 0;
80103d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d70:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d77:	00 00 00 
  initlock(&p->lock, "pipe");
80103d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d7d:	c7 44 24 04 c4 87 10 	movl   $0x801087c4,0x4(%esp)
80103d84:	80 
80103d85:	89 04 24             	mov    %eax,(%esp)
80103d88:	e8 11 12 00 00       	call   80104f9e <initlock>
  (*f0)->type = FD_PIPE;
80103d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d90:	8b 00                	mov    (%eax),%eax
80103d92:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d98:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9b:	8b 00                	mov    (%eax),%eax
80103d9d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103da1:	8b 45 08             	mov    0x8(%ebp),%eax
80103da4:	8b 00                	mov    (%eax),%eax
80103da6:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103daa:	8b 45 08             	mov    0x8(%ebp),%eax
80103dad:	8b 00                	mov    (%eax),%eax
80103daf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103db2:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103db5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103db8:	8b 00                	mov    (%eax),%eax
80103dba:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dc3:	8b 00                	mov    (%eax),%eax
80103dc5:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dcc:	8b 00                	mov    (%eax),%eax
80103dce:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dd5:	8b 00                	mov    (%eax),%eax
80103dd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103dda:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103ddd:	b8 00 00 00 00       	mov    $0x0,%eax
80103de2:	eb 42                	jmp    80103e26 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103de4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103de8:	74 0b                	je     80103df5 <pipealloc+0x110>
    kfree((char*)p);
80103dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ded:	89 04 24             	mov    %eax,(%esp)
80103df0:	e8 1e ed ff ff       	call   80102b13 <kfree>
  if(*f0)
80103df5:	8b 45 08             	mov    0x8(%ebp),%eax
80103df8:	8b 00                	mov    (%eax),%eax
80103dfa:	85 c0                	test   %eax,%eax
80103dfc:	74 0d                	je     80103e0b <pipealloc+0x126>
    fileclose(*f0);
80103dfe:	8b 45 08             	mov    0x8(%ebp),%eax
80103e01:	8b 00                	mov    (%eax),%eax
80103e03:	89 04 24             	mov    %eax,(%esp)
80103e06:	e8 22 d2 ff ff       	call   8010102d <fileclose>
  if(*f1)
80103e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e0e:	8b 00                	mov    (%eax),%eax
80103e10:	85 c0                	test   %eax,%eax
80103e12:	74 0d                	je     80103e21 <pipealloc+0x13c>
    fileclose(*f1);
80103e14:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e17:	8b 00                	mov    (%eax),%eax
80103e19:	89 04 24             	mov    %eax,(%esp)
80103e1c:	e8 0c d2 ff ff       	call   8010102d <fileclose>
  return -1;
80103e21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e26:	c9                   	leave  
80103e27:	c3                   	ret    

80103e28 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103e28:	55                   	push   %ebp
80103e29:	89 e5                	mov    %esp,%ebp
80103e2b:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e31:	89 04 24             	mov    %eax,(%esp)
80103e34:	e8 86 11 00 00       	call   80104fbf <acquire>
  if(writable){
80103e39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103e3d:	74 1f                	je     80103e5e <pipeclose+0x36>
    p->writeopen = 0;
80103e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e42:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103e49:	00 00 00 
    wakeup(&p->nread);
80103e4c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e4f:	05 34 02 00 00       	add    $0x234,%eax
80103e54:	89 04 24             	mov    %eax,(%esp)
80103e57:	e8 3f 0e 00 00       	call   80104c9b <wakeup>
80103e5c:	eb 1d                	jmp    80103e7b <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103e5e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e61:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103e68:	00 00 00 
    wakeup(&p->nwrite);
80103e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6e:	05 38 02 00 00       	add    $0x238,%eax
80103e73:	89 04 24             	mov    %eax,(%esp)
80103e76:	e8 20 0e 00 00       	call   80104c9b <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e84:	85 c0                	test   %eax,%eax
80103e86:	75 25                	jne    80103ead <pipeclose+0x85>
80103e88:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8b:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103e91:	85 c0                	test   %eax,%eax
80103e93:	75 18                	jne    80103ead <pipeclose+0x85>
    release(&p->lock);
80103e95:	8b 45 08             	mov    0x8(%ebp),%eax
80103e98:	89 04 24             	mov    %eax,(%esp)
80103e9b:	e8 87 11 00 00       	call   80105027 <release>
    kfree((char*)p);
80103ea0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea3:	89 04 24             	mov    %eax,(%esp)
80103ea6:	e8 68 ec ff ff       	call   80102b13 <kfree>
80103eab:	eb 0b                	jmp    80103eb8 <pipeclose+0x90>
  } else
    release(&p->lock);
80103ead:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb0:	89 04 24             	mov    %eax,(%esp)
80103eb3:	e8 6f 11 00 00       	call   80105027 <release>
}
80103eb8:	c9                   	leave  
80103eb9:	c3                   	ret    

80103eba <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103eba:	55                   	push   %ebp
80103ebb:	89 e5                	mov    %esp,%ebp
80103ebd:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103ec0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec3:	89 04 24             	mov    %eax,(%esp)
80103ec6:	e8 f4 10 00 00       	call   80104fbf <acquire>
  for(i = 0; i < n; i++){
80103ecb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103ed2:	e9 a5 00 00 00       	jmp    80103f7c <pipewrite+0xc2>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ed7:	eb 56                	jmp    80103f2f <pipewrite+0x75>
      if(p->readopen == 0 || myproc()->killed){
80103ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80103edc:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103ee2:	85 c0                	test   %eax,%eax
80103ee4:	74 0c                	je     80103ef2 <pipewrite+0x38>
80103ee6:	e8 c3 03 00 00       	call   801042ae <myproc>
80103eeb:	8b 40 24             	mov    0x24(%eax),%eax
80103eee:	85 c0                	test   %eax,%eax
80103ef0:	74 15                	je     80103f07 <pipewrite+0x4d>
        release(&p->lock);
80103ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef5:	89 04 24             	mov    %eax,(%esp)
80103ef8:	e8 2a 11 00 00       	call   80105027 <release>
        return -1;
80103efd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f02:	e9 9f 00 00 00       	jmp    80103fa6 <pipewrite+0xec>
      }
      wakeup(&p->nread);
80103f07:	8b 45 08             	mov    0x8(%ebp),%eax
80103f0a:	05 34 02 00 00       	add    $0x234,%eax
80103f0f:	89 04 24             	mov    %eax,(%esp)
80103f12:	e8 84 0d 00 00       	call   80104c9b <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f17:	8b 45 08             	mov    0x8(%ebp),%eax
80103f1a:	8b 55 08             	mov    0x8(%ebp),%edx
80103f1d:	81 c2 38 02 00 00    	add    $0x238,%edx
80103f23:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f27:	89 14 24             	mov    %edx,(%esp)
80103f2a:	e8 95 0c 00 00       	call   80104bc4 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f32:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103f38:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3b:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f41:	05 00 02 00 00       	add    $0x200,%eax
80103f46:	39 c2                	cmp    %eax,%edx
80103f48:	74 8f                	je     80103ed9 <pipewrite+0x1f>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f4a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f53:	8d 48 01             	lea    0x1(%eax),%ecx
80103f56:	8b 55 08             	mov    0x8(%ebp),%edx
80103f59:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103f5f:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f64:	89 c1                	mov    %eax,%ecx
80103f66:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f69:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f6c:	01 d0                	add    %edx,%eax
80103f6e:	0f b6 10             	movzbl (%eax),%edx
80103f71:	8b 45 08             	mov    0x8(%ebp),%eax
80103f74:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80103f78:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f7f:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f82:	0f 8c 4f ff ff ff    	jl     80103ed7 <pipewrite+0x1d>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f88:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8b:	05 34 02 00 00       	add    $0x234,%eax
80103f90:	89 04 24             	mov    %eax,(%esp)
80103f93:	e8 03 0d 00 00       	call   80104c9b <wakeup>
  release(&p->lock);
80103f98:	8b 45 08             	mov    0x8(%ebp),%eax
80103f9b:	89 04 24             	mov    %eax,(%esp)
80103f9e:	e8 84 10 00 00       	call   80105027 <release>
  return n;
80103fa3:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103fa6:	c9                   	leave  
80103fa7:	c3                   	ret    

80103fa8 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103fa8:	55                   	push   %ebp
80103fa9:	89 e5                	mov    %esp,%ebp
80103fab:	53                   	push   %ebx
80103fac:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103faf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb2:	89 04 24             	mov    %eax,(%esp)
80103fb5:	e8 05 10 00 00       	call   80104fbf <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fba:	eb 39                	jmp    80103ff5 <piperead+0x4d>
    if(myproc()->killed){
80103fbc:	e8 ed 02 00 00       	call   801042ae <myproc>
80103fc1:	8b 40 24             	mov    0x24(%eax),%eax
80103fc4:	85 c0                	test   %eax,%eax
80103fc6:	74 15                	je     80103fdd <piperead+0x35>
      release(&p->lock);
80103fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80103fcb:	89 04 24             	mov    %eax,(%esp)
80103fce:	e8 54 10 00 00       	call   80105027 <release>
      return -1;
80103fd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fd8:	e9 b5 00 00 00       	jmp    80104092 <piperead+0xea>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103fdd:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe0:	8b 55 08             	mov    0x8(%ebp),%edx
80103fe3:	81 c2 34 02 00 00    	add    $0x234,%edx
80103fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fed:	89 14 24             	mov    %edx,(%esp)
80103ff0:	e8 cf 0b 00 00       	call   80104bc4 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff8:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103ffe:	8b 45 08             	mov    0x8(%ebp),%eax
80104001:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104007:	39 c2                	cmp    %eax,%edx
80104009:	75 0d                	jne    80104018 <piperead+0x70>
8010400b:	8b 45 08             	mov    0x8(%ebp),%eax
8010400e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104014:	85 c0                	test   %eax,%eax
80104016:	75 a4                	jne    80103fbc <piperead+0x14>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104018:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010401f:	eb 4b                	jmp    8010406c <piperead+0xc4>
    if(p->nread == p->nwrite)
80104021:	8b 45 08             	mov    0x8(%ebp),%eax
80104024:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010402a:	8b 45 08             	mov    0x8(%ebp),%eax
8010402d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104033:	39 c2                	cmp    %eax,%edx
80104035:	75 02                	jne    80104039 <piperead+0x91>
      break;
80104037:	eb 3b                	jmp    80104074 <piperead+0xcc>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104039:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010403c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010403f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104042:	8b 45 08             	mov    0x8(%ebp),%eax
80104045:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010404b:	8d 48 01             	lea    0x1(%eax),%ecx
8010404e:	8b 55 08             	mov    0x8(%ebp),%edx
80104051:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104057:	25 ff 01 00 00       	and    $0x1ff,%eax
8010405c:	89 c2                	mov    %eax,%edx
8010405e:	8b 45 08             	mov    0x8(%ebp),%eax
80104061:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104066:	88 03                	mov    %al,(%ebx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104068:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010406c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406f:	3b 45 10             	cmp    0x10(%ebp),%eax
80104072:	7c ad                	jl     80104021 <piperead+0x79>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104074:	8b 45 08             	mov    0x8(%ebp),%eax
80104077:	05 38 02 00 00       	add    $0x238,%eax
8010407c:	89 04 24             	mov    %eax,(%esp)
8010407f:	e8 17 0c 00 00       	call   80104c9b <wakeup>
  release(&p->lock);
80104084:	8b 45 08             	mov    0x8(%ebp),%eax
80104087:	89 04 24             	mov    %eax,(%esp)
8010408a:	e8 98 0f 00 00       	call   80105027 <release>
  return i;
8010408f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104092:	83 c4 24             	add    $0x24,%esp
80104095:	5b                   	pop    %ebx
80104096:	5d                   	pop    %ebp
80104097:	c3                   	ret    

80104098 <readeflags>:
{
80104098:	55                   	push   %ebp
80104099:	89 e5                	mov    %esp,%ebp
8010409b:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010409e:	9c                   	pushf  
8010409f:	58                   	pop    %eax
801040a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801040a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801040a6:	c9                   	leave  
801040a7:	c3                   	ret    

801040a8 <sti>:
{
801040a8:	55                   	push   %ebp
801040a9:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801040ab:	fb                   	sti    
}
801040ac:	5d                   	pop    %ebp
801040ad:	c3                   	ret    

801040ae <random>:

#define RAND_MAX ((1U << 31) - 1)
static int rseed = 1898888478;

int random()
{
801040ae:	55                   	push   %ebp
801040af:	89 e5                	mov    %esp,%ebp
  return rseed = (rseed * 1103515245 + 12345) & RAND_MAX;
801040b1:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801040b6:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
801040bc:	05 39 30 00 00       	add    $0x3039,%eax
801040c1:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
801040c6:	a3 00 b0 10 80       	mov    %eax,0x8010b000
801040cb:	a1 00 b0 10 80       	mov    0x8010b000,%eax
}
801040d0:	5d                   	pop    %ebp
801040d1:	c3                   	ret    

801040d2 <fillpstat>:
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;


void fillpstat(pstatTable *pstat) {
801040d2:	55                   	push   %ebp
801040d3:	89 e5                	mov    %esp,%ebp
801040d5:	53                   	push   %ebx
801040d6:	83 ec 24             	sub    $0x24,%esp
    int i;
    struct proc *p;

    acquire(&ptable.lock);
801040d9:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
801040e0:	e8 da 0e 00 00       	call   80104fbf <acquire>
    for (i = 0; i < NPROC; i++) {
801040e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801040ec:	e9 ee 00 00 00       	jmp    801041df <fillpstat+0x10d>
        p = &ptable.proc[i];
801040f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f4:	c1 e0 02             	shl    $0x2,%eax
801040f7:	89 c2                	mov    %eax,%edx
801040f9:	c1 e2 05             	shl    $0x5,%edx
801040fc:	01 d0                	add    %edx,%eax
801040fe:	83 c0 30             	add    $0x30,%eax
80104101:	05 c0 3d 11 80       	add    $0x80113dc0,%eax
80104106:	83 c0 04             	add    $0x4,%eax
80104109:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p->state == UNUSED)
8010410c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010410f:	8b 40 0c             	mov    0xc(%eax),%eax
80104112:	85 c0                	test   %eax,%eax
80104114:	75 05                	jne    8010411b <fillpstat+0x49>
            continue;
80104116:	e9 c0 00 00 00       	jmp    801041db <fillpstat+0x109>
        (*pstat)[i].pid = p->pid;
8010411b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010411e:	8b 48 10             	mov    0x10(%eax),%ecx
80104121:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104124:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104127:	89 d0                	mov    %edx,%eax
80104129:	c1 e0 03             	shl    $0x3,%eax
8010412c:	01 d0                	add    %edx,%eax
8010412e:	c1 e0 02             	shl    $0x2,%eax
80104131:	01 d8                	add    %ebx,%eax
80104133:	83 c0 08             	add    $0x8,%eax
80104136:	89 08                	mov    %ecx,(%eax)
        (*pstat)[i].tickets = p->tickets;
80104138:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010413b:	8b 48 7c             	mov    0x7c(%eax),%ecx
8010413e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104141:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104144:	89 d0                	mov    %edx,%eax
80104146:	c1 e0 03             	shl    $0x3,%eax
80104149:	01 d0                	add    %edx,%eax
8010414b:	c1 e0 02             	shl    $0x2,%eax
8010414e:	01 d8                	add    %ebx,%eax
80104150:	83 c0 04             	add    $0x4,%eax
80104153:	89 08                	mov    %ecx,(%eax)
        (*pstat)[i].ticks = p->ticks;
80104155:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104158:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
8010415e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104161:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104164:	89 d0                	mov    %edx,%eax
80104166:	c1 e0 03             	shl    $0x3,%eax
80104169:	01 d0                	add    %edx,%eax
8010416b:	c1 e0 02             	shl    $0x2,%eax
8010416e:	01 d8                	add    %ebx,%eax
80104170:	83 c0 0c             	add    $0xc,%eax
80104173:	89 08                	mov    %ecx,(%eax)
        (*pstat)[i].state = p->state;
80104175:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104178:	8b 40 0c             	mov    0xc(%eax),%eax
8010417b:	89 c1                	mov    %eax,%ecx
8010417d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104180:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104183:	89 d0                	mov    %edx,%eax
80104185:	c1 e0 03             	shl    $0x3,%eax
80104188:	01 d0                	add    %edx,%eax
8010418a:	c1 e0 02             	shl    $0x2,%eax
8010418d:	01 d8                	add    %ebx,%eax
8010418f:	83 c0 20             	add    $0x20,%eax
80104192:	88 08                	mov    %cl,(%eax)
        (*pstat)[i].inuse = 1;
80104194:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104197:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010419a:	89 d0                	mov    %edx,%eax
8010419c:	c1 e0 03             	shl    $0x3,%eax
8010419f:	01 d0                	add    %edx,%eax
801041a1:	c1 e0 02             	shl    $0x2,%eax
801041a4:	01 c8                	add    %ecx,%eax
801041a6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        safestrcpy((*pstat)[i].name, p->name, sizeof((*pstat)[i].name));
801041ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041af:	8d 48 6c             	lea    0x6c(%eax),%ecx
801041b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041b5:	89 d0                	mov    %edx,%eax
801041b7:	c1 e0 03             	shl    $0x3,%eax
801041ba:	01 d0                	add    %edx,%eax
801041bc:	c1 e0 02             	shl    $0x2,%eax
801041bf:	8d 50 10             	lea    0x10(%eax),%edx
801041c2:	8b 45 08             	mov    0x8(%ebp),%eax
801041c5:	01 d0                	add    %edx,%eax
801041c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801041ce:	00 
801041cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801041d3:	89 04 24             	mov    %eax,(%esp)
801041d6:	e8 76 12 00 00       	call   80105451 <safestrcpy>
    for (i = 0; i < NPROC; i++) {
801041db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801041df:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
801041e3:	0f 8e 08 ff ff ff    	jle    801040f1 <fillpstat+0x1f>
    }
    release(&ptable.lock);
801041e9:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
801041f0:	e8 32 0e 00 00       	call   80105027 <release>
}
801041f5:	83 c4 24             	add    $0x24,%esp
801041f8:	5b                   	pop    %ebx
801041f9:	5d                   	pop    %ebp
801041fa:	c3                   	ret    

801041fb <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801041fb:	55                   	push   %ebp
801041fc:	89 e5                	mov    %esp,%ebp
801041fe:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104201:	c7 44 24 04 cc 87 10 	movl   $0x801087cc,0x4(%esp)
80104208:	80 
80104209:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104210:	e8 89 0d 00 00       	call   80104f9e <initlock>
}
80104215:	c9                   	leave  
80104216:	c3                   	ret    

80104217 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
80104217:	55                   	push   %ebp
80104218:	89 e5                	mov    %esp,%ebp
8010421a:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010421d:	e8 16 00 00 00       	call   80104238 <mycpu>
80104222:	89 c2                	mov    %eax,%edx
80104224:	b8 20 38 11 80       	mov    $0x80113820,%eax
80104229:	29 c2                	sub    %eax,%edx
8010422b:	89 d0                	mov    %edx,%eax
8010422d:	c1 f8 04             	sar    $0x4,%eax
80104230:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104236:	c9                   	leave  
80104237:	c3                   	ret    

80104238 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80104238:	55                   	push   %ebp
80104239:	89 e5                	mov    %esp,%ebp
8010423b:	83 ec 28             	sub    $0x28,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010423e:	e8 55 fe ff ff       	call   80104098 <readeflags>
80104243:	25 00 02 00 00       	and    $0x200,%eax
80104248:	85 c0                	test   %eax,%eax
8010424a:	74 0c                	je     80104258 <mycpu+0x20>
    panic("mycpu called with interrupts enabled\n");
8010424c:	c7 04 24 d4 87 10 80 	movl   $0x801087d4,(%esp)
80104253:	e8 0a c3 ff ff       	call   80100562 <panic>
  
  apicid = lapicid();
80104258:	e8 d2 ec ff ff       	call   80102f2f <lapicid>
8010425d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80104260:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104267:	eb 2d                	jmp    80104296 <mycpu+0x5e>
    if (cpus[i].apicid == apicid)
80104269:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426c:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104272:	05 20 38 11 80       	add    $0x80113820,%eax
80104277:	0f b6 00             	movzbl (%eax),%eax
8010427a:	0f b6 c0             	movzbl %al,%eax
8010427d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104280:	75 10                	jne    80104292 <mycpu+0x5a>
      return &cpus[i];
80104282:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104285:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010428b:	05 20 38 11 80       	add    $0x80113820,%eax
80104290:	eb 1a                	jmp    801042ac <mycpu+0x74>
  for (i = 0; i < ncpu; ++i) {
80104292:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104296:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
8010429b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010429e:	7c c9                	jl     80104269 <mycpu+0x31>
  }
  panic("unknown apicid\n");
801042a0:	c7 04 24 fa 87 10 80 	movl   $0x801087fa,(%esp)
801042a7:	e8 b6 c2 ff ff       	call   80100562 <panic>
}
801042ac:	c9                   	leave  
801042ad:	c3                   	ret    

801042ae <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801042ae:	55                   	push   %ebp
801042af:	89 e5                	mov    %esp,%ebp
801042b1:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801042b4:	e8 73 0e 00 00       	call   8010512c <pushcli>
  c = mycpu();
801042b9:	e8 7a ff ff ff       	call   80104238 <mycpu>
801042be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
801042c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c4:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801042ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
801042cd:	e8 a6 0e 00 00       	call   80105178 <popcli>
  return p;
801042d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801042d5:	c9                   	leave  
801042d6:	c3                   	ret    

801042d7 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801042d7:	55                   	push   %ebp
801042d8:	89 e5                	mov    %esp,%ebp
801042da:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801042dd:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
801042e4:	e8 d6 0c 00 00       	call   80104fbf <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042e9:	c7 45 f4 f4 3d 11 80 	movl   $0x80113df4,-0xc(%ebp)
801042f0:	eb 5d                	jmp    8010434f <allocproc+0x78>
    if(p->state == UNUSED)
801042f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f5:	8b 40 0c             	mov    0xc(%eax),%eax
801042f8:	85 c0                	test   %eax,%eax
801042fa:	75 4c                	jne    80104348 <allocproc+0x71>
      goto found;
801042fc:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801042fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104300:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104307:	a1 04 b0 10 80       	mov    0x8010b004,%eax
8010430c:	8d 50 01             	lea    0x1(%eax),%edx
8010430f:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80104315:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104318:	89 42 10             	mov    %eax,0x10(%edx)
  p->tickets = 10; //default number of tickets
8010431b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010431e:	c7 40 7c 0a 00 00 00 	movl   $0xa,0x7c(%eax)

  release(&ptable.lock);
80104325:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
8010432c:	e8 f6 0c 00 00       	call   80105027 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104331:	e8 73 e8 ff ff       	call   80102ba9 <kalloc>
80104336:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104339:	89 42 08             	mov    %eax,0x8(%edx)
8010433c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010433f:	8b 40 08             	mov    0x8(%eax),%eax
80104342:	85 c0                	test   %eax,%eax
80104344:	75 36                	jne    8010437c <allocproc+0xa5>
80104346:	eb 23                	jmp    8010436b <allocproc+0x94>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104348:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
8010434f:	81 7d f4 f4 5e 11 80 	cmpl   $0x80115ef4,-0xc(%ebp)
80104356:	72 9a                	jb     801042f2 <allocproc+0x1b>
  release(&ptable.lock);
80104358:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
8010435f:	e8 c3 0c 00 00       	call   80105027 <release>
  return 0;
80104364:	b8 00 00 00 00       	mov    $0x0,%eax
80104369:	eb 76                	jmp    801043e1 <allocproc+0x10a>
    p->state = UNUSED;
8010436b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010436e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104375:	b8 00 00 00 00       	mov    $0x0,%eax
8010437a:	eb 65                	jmp    801043e1 <allocproc+0x10a>
  }
  sp = p->kstack + KSTACKSIZE;
8010437c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010437f:	8b 40 08             	mov    0x8(%eax),%eax
80104382:	05 00 10 00 00       	add    $0x1000,%eax
80104387:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010438a:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010438e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104391:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104394:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104397:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010439b:	ba 68 66 10 80       	mov    $0x80106668,%edx
801043a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043a3:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801043a5:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801043a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043af:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801043b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b5:	8b 40 1c             	mov    0x1c(%eax),%eax
801043b8:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801043bf:	00 
801043c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801043c7:	00 
801043c8:	89 04 24             	mov    %eax,(%esp)
801043cb:	e8 61 0e 00 00       	call   80105231 <memset>
  p->context->eip = (uint)forkret;
801043d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043d3:	8b 40 1c             	mov    0x1c(%eax),%eax
801043d6:	ba 85 4b 10 80       	mov    $0x80104b85,%edx
801043db:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801043de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043e1:	c9                   	leave  
801043e2:	c3                   	ret    

801043e3 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801043e3:	55                   	push   %ebp
801043e4:	89 e5                	mov    %esp,%ebp
801043e6:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc(); //allocates and initializes a process structure
801043e9:	e8 e9 fe ff ff       	call   801042d7 <allocproc>
801043ee:	89 45 f4             	mov    %eax,-0xc(%ebp)

  p->ticks = 0;
801043f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f4:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801043fb:	00 00 00 
  p->tickets = 10;
801043fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104401:	c7 40 7c 0a 00 00 00 	movl   $0xa,0x7c(%eax)
  initproc = p;
80104408:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010440b:	a3 40 b6 10 80       	mov    %eax,0x8010b640
  if((p->pgdir = setupkvm()) == 0)
80104410:	e8 d0 37 00 00       	call   80107be5 <setupkvm>
80104415:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104418:	89 42 04             	mov    %eax,0x4(%edx)
8010441b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441e:	8b 40 04             	mov    0x4(%eax),%eax
80104421:	85 c0                	test   %eax,%eax
80104423:	75 0c                	jne    80104431 <userinit+0x4e>
    panic("userinit: out of memory?");
80104425:	c7 04 24 0a 88 10 80 	movl   $0x8010880a,(%esp)
8010442c:	e8 31 c1 ff ff       	call   80100562 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104431:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104436:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104439:	8b 40 04             	mov    0x4(%eax),%eax
8010443c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104440:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
80104447:	80 
80104448:	89 04 24             	mov    %eax,(%esp)
8010444b:	e8 00 3a 00 00       	call   80107e50 <inituvm>
  p->sz = PGSIZE;
80104450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104453:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104459:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010445c:	8b 40 18             	mov    0x18(%eax),%eax
8010445f:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104466:	00 
80104467:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010446e:	00 
8010446f:	89 04 24             	mov    %eax,(%esp)
80104472:	e8 ba 0d 00 00       	call   80105231 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104477:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447a:	8b 40 18             	mov    0x18(%eax),%eax
8010447d:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104486:	8b 40 18             	mov    0x18(%eax),%eax
80104489:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010448f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104492:	8b 40 18             	mov    0x18(%eax),%eax
80104495:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104498:	8b 52 18             	mov    0x18(%edx),%edx
8010449b:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010449f:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801044a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a6:	8b 40 18             	mov    0x18(%eax),%eax
801044a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044ac:	8b 52 18             	mov    0x18(%edx),%edx
801044af:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801044b3:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801044b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ba:	8b 40 18             	mov    0x18(%eax),%eax
801044bd:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801044c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c7:	8b 40 18             	mov    0x18(%eax),%eax
801044ca:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801044d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d4:	8b 40 18             	mov    0x18(%eax),%eax
801044d7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801044de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e1:	83 c0 6c             	add    $0x6c,%eax
801044e4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801044eb:	00 
801044ec:	c7 44 24 04 23 88 10 	movl   $0x80108823,0x4(%esp)
801044f3:	80 
801044f4:	89 04 24             	mov    %eax,(%esp)
801044f7:	e8 55 0f 00 00       	call   80105451 <safestrcpy>
  p->cwd = namei("/");
801044fc:	c7 04 24 2c 88 10 80 	movl   $0x8010882c,(%esp)
80104503:	e8 8f df ff ff       	call   80102497 <namei>
80104508:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010450b:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
8010450e:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104515:	e8 a5 0a 00 00       	call   80104fbf <acquire>

  p->state = RUNNABLE;
8010451a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104524:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
8010452b:	e8 f7 0a 00 00       	call   80105027 <release>
}
80104530:	c9                   	leave  
80104531:	c3                   	ret    

80104532 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104532:	55                   	push   %ebp
80104533:	89 e5                	mov    %esp,%ebp
80104535:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *curproc = myproc();
80104538:	e8 71 fd ff ff       	call   801042ae <myproc>
8010453d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80104540:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104543:	8b 00                	mov    (%eax),%eax
80104545:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104548:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010454c:	7e 31                	jle    8010457f <growproc+0x4d>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010454e:	8b 55 08             	mov    0x8(%ebp),%edx
80104551:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104554:	01 c2                	add    %eax,%edx
80104556:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104559:	8b 40 04             	mov    0x4(%eax),%eax
8010455c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104560:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104563:	89 54 24 04          	mov    %edx,0x4(%esp)
80104567:	89 04 24             	mov    %eax,(%esp)
8010456a:	e8 4c 3a 00 00       	call   80107fbb <allocuvm>
8010456f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104572:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104576:	75 3e                	jne    801045b6 <growproc+0x84>
      return -1;
80104578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010457d:	eb 4f                	jmp    801045ce <growproc+0x9c>
  } else if(n < 0){
8010457f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104583:	79 31                	jns    801045b6 <growproc+0x84>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104585:	8b 55 08             	mov    0x8(%ebp),%edx
80104588:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458b:	01 c2                	add    %eax,%edx
8010458d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104590:	8b 40 04             	mov    0x4(%eax),%eax
80104593:	89 54 24 08          	mov    %edx,0x8(%esp)
80104597:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010459a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010459e:	89 04 24             	mov    %eax,(%esp)
801045a1:	e8 2b 3b 00 00       	call   801080d1 <deallocuvm>
801045a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801045a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045ad:	75 07                	jne    801045b6 <growproc+0x84>
      return -1;
801045af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045b4:	eb 18                	jmp    801045ce <growproc+0x9c>
  }
  curproc->sz = sz;
801045b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045bc:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
801045be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045c1:	89 04 24             	mov    %eax,(%esp)
801045c4:	e8 f6 36 00 00       	call   80107cbf <switchuvm>
  return 0;
801045c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801045ce:	c9                   	leave  
801045cf:	c3                   	ret    

801045d0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	56                   	push   %esi
801045d5:	53                   	push   %ebx
801045d6:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
801045d9:	e8 d0 fc ff ff       	call   801042ae <myproc>
801045de:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
801045e1:	e8 f1 fc ff ff       	call   801042d7 <allocproc>
801045e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
801045e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801045ed:	75 0a                	jne    801045f9 <fork+0x29>
    return -1;
801045ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045f4:	e9 4f 01 00 00       	jmp    80104748 <fork+0x178>
  }

  np->ticks = 0;
801045f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045fc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104603:	00 00 00 
  np->tickets = curproc->tickets; //inherit tickets from parent
80104606:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104609:	8b 50 7c             	mov    0x7c(%eax),%edx
8010460c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010460f:	89 50 7c             	mov    %edx,0x7c(%eax)


  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104612:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104615:	8b 10                	mov    (%eax),%edx
80104617:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010461a:	8b 40 04             	mov    0x4(%eax),%eax
8010461d:	89 54 24 04          	mov    %edx,0x4(%esp)
80104621:	89 04 24             	mov    %eax,(%esp)
80104624:	e8 4b 3c 00 00       	call   80108274 <copyuvm>
80104629:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010462c:	89 42 04             	mov    %eax,0x4(%edx)
8010462f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104632:	8b 40 04             	mov    0x4(%eax),%eax
80104635:	85 c0                	test   %eax,%eax
80104637:	75 2c                	jne    80104665 <fork+0x95>
    kfree(np->kstack);
80104639:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010463c:	8b 40 08             	mov    0x8(%eax),%eax
8010463f:	89 04 24             	mov    %eax,(%esp)
80104642:	e8 cc e4 ff ff       	call   80102b13 <kfree>
    np->kstack = 0;
80104647:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010464a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104651:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104654:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010465b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104660:	e9 e3 00 00 00       	jmp    80104748 <fork+0x178>
  }
  np->sz = curproc->sz;
80104665:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104668:	8b 10                	mov    (%eax),%edx
8010466a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010466d:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
8010466f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104672:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104675:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80104678:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010467b:	8b 50 18             	mov    0x18(%eax),%edx
8010467e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104681:	8b 40 18             	mov    0x18(%eax),%eax
80104684:	89 c3                	mov    %eax,%ebx
80104686:	b8 13 00 00 00       	mov    $0x13,%eax
8010468b:	89 d7                	mov    %edx,%edi
8010468d:	89 de                	mov    %ebx,%esi
8010468f:	89 c1                	mov    %eax,%ecx
80104691:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104693:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104696:	8b 40 18             	mov    0x18(%eax),%eax
80104699:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801046a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801046a7:	eb 37                	jmp    801046e0 <fork+0x110>
    if(curproc->ofile[i])
801046a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801046af:	83 c2 08             	add    $0x8,%edx
801046b2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046b6:	85 c0                	test   %eax,%eax
801046b8:	74 22                	je     801046dc <fork+0x10c>
      np->ofile[i] = filedup(curproc->ofile[i]);
801046ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801046c0:	83 c2 08             	add    $0x8,%edx
801046c3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046c7:	89 04 24             	mov    %eax,(%esp)
801046ca:	e8 16 c9 ff ff       	call   80100fe5 <filedup>
801046cf:	8b 55 dc             	mov    -0x24(%ebp),%edx
801046d2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801046d5:	83 c1 08             	add    $0x8,%ecx
801046d8:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
801046dc:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801046e0:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801046e4:	7e c3                	jle    801046a9 <fork+0xd9>
  np->cwd = idup(curproc->cwd);
801046e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046e9:	8b 40 68             	mov    0x68(%eax),%eax
801046ec:	89 04 24             	mov    %eax,(%esp)
801046ef:	e8 37 d2 ff ff       	call   8010192b <idup>
801046f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
801046f7:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801046fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046fd:	8d 50 6c             	lea    0x6c(%eax),%edx
80104700:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104703:	83 c0 6c             	add    $0x6c,%eax
80104706:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010470d:	00 
8010470e:	89 54 24 04          	mov    %edx,0x4(%esp)
80104712:	89 04 24             	mov    %eax,(%esp)
80104715:	e8 37 0d 00 00       	call   80105451 <safestrcpy>

  pid = np->pid;
8010471a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010471d:	8b 40 10             	mov    0x10(%eax),%eax
80104720:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80104723:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
8010472a:	e8 90 08 00 00       	call   80104fbf <acquire>

  np->state = RUNNABLE;
8010472f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104732:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104739:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104740:	e8 e2 08 00 00       	call   80105027 <release>

  return pid;
80104745:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104748:	83 c4 2c             	add    $0x2c,%esp
8010474b:	5b                   	pop    %ebx
8010474c:	5e                   	pop    %esi
8010474d:	5f                   	pop    %edi
8010474e:	5d                   	pop    %ebp
8010474f:	c3                   	ret    

80104750 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	83 ec 28             	sub    $0x28,%esp
  struct proc *curproc = myproc();
80104756:	e8 53 fb ff ff       	call   801042ae <myproc>
8010475b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010475e:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80104763:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104766:	75 0c                	jne    80104774 <exit+0x24>
    panic("init exiting");
80104768:	c7 04 24 2e 88 10 80 	movl   $0x8010882e,(%esp)
8010476f:	e8 ee bd ff ff       	call   80100562 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104774:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010477b:	eb 3b                	jmp    801047b8 <exit+0x68>
    if(curproc->ofile[fd]){
8010477d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104780:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104783:	83 c2 08             	add    $0x8,%edx
80104786:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010478a:	85 c0                	test   %eax,%eax
8010478c:	74 26                	je     801047b4 <exit+0x64>
      fileclose(curproc->ofile[fd]);
8010478e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104791:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104794:	83 c2 08             	add    $0x8,%edx
80104797:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010479b:	89 04 24             	mov    %eax,(%esp)
8010479e:	e8 8a c8 ff ff       	call   8010102d <fileclose>
      curproc->ofile[fd] = 0;
801047a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047a9:	83 c2 08             	add    $0x8,%edx
801047ac:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801047b3:	00 
  for(fd = 0; fd < NOFILE; fd++){
801047b4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801047b8:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801047bc:	7e bf                	jle    8010477d <exit+0x2d>
    }
  }

  begin_op();
801047be:	e8 c4 ec ff ff       	call   80103487 <begin_op>
  iput(curproc->cwd);
801047c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047c6:	8b 40 68             	mov    0x68(%eax),%eax
801047c9:	89 04 24             	mov    %eax,(%esp)
801047cc:	e8 dd d2 ff ff       	call   80101aae <iput>
  end_op();
801047d1:	e8 35 ed ff ff       	call   8010350b <end_op>
  curproc->cwd = 0;
801047d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047d9:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801047e0:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
801047e7:	e8 d3 07 00 00       	call   80104fbf <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801047ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047ef:	8b 40 14             	mov    0x14(%eax),%eax
801047f2:	89 04 24             	mov    %eax,(%esp)
801047f5:	e8 60 04 00 00       	call   80104c5a <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047fa:	c7 45 f4 f4 3d 11 80 	movl   $0x80113df4,-0xc(%ebp)
80104801:	eb 36                	jmp    80104839 <exit+0xe9>
    if(p->parent == curproc){
80104803:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104806:	8b 40 14             	mov    0x14(%eax),%eax
80104809:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010480c:	75 24                	jne    80104832 <exit+0xe2>
      p->parent = initproc;
8010480e:	8b 15 40 b6 10 80    	mov    0x8010b640,%edx
80104814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104817:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010481a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481d:	8b 40 0c             	mov    0xc(%eax),%eax
80104820:	83 f8 05             	cmp    $0x5,%eax
80104823:	75 0d                	jne    80104832 <exit+0xe2>
        wakeup1(initproc);
80104825:	a1 40 b6 10 80       	mov    0x8010b640,%eax
8010482a:	89 04 24             	mov    %eax,(%esp)
8010482d:	e8 28 04 00 00       	call   80104c5a <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104832:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104839:	81 7d f4 f4 5e 11 80 	cmpl   $0x80115ef4,-0xc(%ebp)
80104840:	72 c1                	jb     80104803 <exit+0xb3>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104842:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104845:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010484c:	e8 54 02 00 00       	call   80104aa5 <sched>
  panic("zombie exit");
80104851:	c7 04 24 3b 88 10 80 	movl   $0x8010883b,(%esp)
80104858:	e8 05 bd ff ff       	call   80100562 <panic>

8010485d <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010485d:	55                   	push   %ebp
8010485e:	89 e5                	mov    %esp,%ebp
80104860:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104863:	e8 46 fa ff ff       	call   801042ae <myproc>
80104868:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
8010486b:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104872:	e8 48 07 00 00       	call   80104fbf <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104877:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010487e:	c7 45 f4 f4 3d 11 80 	movl   $0x80113df4,-0xc(%ebp)
80104885:	e9 98 00 00 00       	jmp    80104922 <wait+0xc5>
      if(p->parent != curproc)
8010488a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010488d:	8b 40 14             	mov    0x14(%eax),%eax
80104890:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104893:	74 05                	je     8010489a <wait+0x3d>
        continue;
80104895:	e9 81 00 00 00       	jmp    8010491b <wait+0xbe>
      havekids = 1;
8010489a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801048a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a4:	8b 40 0c             	mov    0xc(%eax),%eax
801048a7:	83 f8 05             	cmp    $0x5,%eax
801048aa:	75 6f                	jne    8010491b <wait+0xbe>
        // Found one.
        pid = p->pid;
801048ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048af:	8b 40 10             	mov    0x10(%eax),%eax
801048b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
801048b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b8:	8b 40 08             	mov    0x8(%eax),%eax
801048bb:	89 04 24             	mov    %eax,(%esp)
801048be:	e8 50 e2 ff ff       	call   80102b13 <kfree>
        p->kstack = 0;
801048c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801048cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d0:	8b 40 04             	mov    0x4(%eax),%eax
801048d3:	89 04 24             	mov    %eax,(%esp)
801048d6:	e8 bc 38 00 00       	call   80108197 <freevm>
        p->pid = 0;
801048db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048de:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801048e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801048ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f2:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801048f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f9:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104903:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
8010490a:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104911:	e8 11 07 00 00       	call   80105027 <release>
        return pid;
80104916:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104919:	eb 4f                	jmp    8010496a <wait+0x10d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010491b:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104922:	81 7d f4 f4 5e 11 80 	cmpl   $0x80115ef4,-0xc(%ebp)
80104929:	0f 82 5b ff ff ff    	jb     8010488a <wait+0x2d>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
8010492f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104933:	74 0a                	je     8010493f <wait+0xe2>
80104935:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104938:	8b 40 24             	mov    0x24(%eax),%eax
8010493b:	85 c0                	test   %eax,%eax
8010493d:	74 13                	je     80104952 <wait+0xf5>
      release(&ptable.lock);
8010493f:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104946:	e8 dc 06 00 00       	call   80105027 <release>
      return -1;
8010494b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104950:	eb 18                	jmp    8010496a <wait+0x10d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104952:	c7 44 24 04 c0 3d 11 	movl   $0x80113dc0,0x4(%esp)
80104959:	80 
8010495a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010495d:	89 04 24             	mov    %eax,(%esp)
80104960:	e8 5f 02 00 00       	call   80104bc4 <sleep>
  }
80104965:	e9 0d ff ff ff       	jmp    80104877 <wait+0x1a>
}
8010496a:	c9                   	leave  
8010496b:	c3                   	ret    

8010496c <scheduler>:
//  - eventually that process transfers control
//      via swtch back to the scheduler.

void
scheduler(void)
{
8010496c:	55                   	push   %ebp
8010496d:	89 e5                	mov    %esp,%ebp
8010496f:	83 ec 38             	sub    $0x38,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104972:	e8 c1 f8 ff ff       	call   80104238 <mycpu>
80104977:	89 45 e8             	mov    %eax,-0x18(%ebp)
  c->proc = 0;
8010497a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010497d:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104984:	00 00 00 

  for(;;){
    sti(); 
80104987:	e8 1c f7 ff ff       	call   801040a8 <sti>

    acquire(&ptable.lock); 
8010498c:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104993:	e8 27 06 00 00       	call   80104fbf <acquire>

    //Calculates total tickets for RUNNABLE processes
    int total_tickets = 0;
80104998:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010499f:	c7 45 f4 f4 3d 11 80 	movl   $0x80113df4,-0xc(%ebp)
801049a6:	eb 1b                	jmp    801049c3 <scheduler+0x57>
      if(p->state == RUNNABLE){
801049a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ab:	8b 40 0c             	mov    0xc(%eax),%eax
801049ae:	83 f8 03             	cmp    $0x3,%eax
801049b1:	75 09                	jne    801049bc <scheduler+0x50>
        total_tickets += p->tickets;
801049b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b6:	8b 40 7c             	mov    0x7c(%eax),%eax
801049b9:	01 45 f0             	add    %eax,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049bc:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801049c3:	81 7d f4 f4 5e 11 80 	cmpl   $0x80115ef4,-0xc(%ebp)
801049ca:	72 dc                	jb     801049a8 <scheduler+0x3c>
      }
    }

    // no RUNNABLE processes then skip the scheduling
    if(total_tickets == 0){
801049cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801049d0:	75 0f                	jne    801049e1 <scheduler+0x75>
      release(&ptable.lock);
801049d2:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
801049d9:	e8 49 06 00 00       	call   80105027 <release>
      continue;
801049de:	90                   	nop
        break;  
      }
    }

    release(&ptable.lock);  // Unlock process table
  }
801049df:	eb a6                	jmp    80104987 <scheduler+0x1b>
    int winner_ticket = random() % total_tickets;
801049e1:	e8 c8 f6 ff ff       	call   801040ae <random>
801049e6:	99                   	cltd   
801049e7:	f7 7d f0             	idivl  -0x10(%ebp)
801049ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    int current_ticket_sum = 0;
801049ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049f4:	c7 45 f4 f4 3d 11 80 	movl   $0x80113df4,-0xc(%ebp)
801049fb:	e9 87 00 00 00       	jmp    80104a87 <scheduler+0x11b>
      if(p->state != RUNNABLE)
80104a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a03:	8b 40 0c             	mov    0xc(%eax),%eax
80104a06:	83 f8 03             	cmp    $0x3,%eax
80104a09:	74 02                	je     80104a0d <scheduler+0xa1>
        continue;
80104a0b:	eb 73                	jmp    80104a80 <scheduler+0x114>
      current_ticket_sum += p->tickets;
80104a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a10:	8b 40 7c             	mov    0x7c(%eax),%eax
80104a13:	01 45 ec             	add    %eax,-0x14(%ebp)
      if(current_ticket_sum > winner_ticket){
80104a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a19:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
80104a1c:	7e 62                	jle    80104a80 <scheduler+0x114>
        c->proc = p;
80104a1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104a21:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a24:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
        switchuvm(p);
80104a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a2d:	89 04 24             	mov    %eax,(%esp)
80104a30:	e8 8a 32 00 00       	call   80107cbf <switchuvm>
        p->state = RUNNING;
80104a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a38:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
        swtch(&(c->scheduler), p->context);
80104a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a42:	8b 40 1c             	mov    0x1c(%eax),%eax
80104a45:	8b 55 e8             	mov    -0x18(%ebp),%edx
80104a48:	83 c2 04             	add    $0x4,%edx
80104a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a4f:	89 14 24             	mov    %edx,(%esp)
80104a52:	e8 6b 0a 00 00       	call   801054c2 <swtch>
        switchkvm();
80104a57:	e8 49 32 00 00       	call   80107ca5 <switchkvm>
        p->ticks++;
80104a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a5f:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104a65:	8d 50 01             	lea    0x1(%eax),%edx
80104a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a6b:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
        c->proc = 0;
80104a71:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104a74:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104a7b:	00 00 00 
        break;  
80104a7e:	eb 14                	jmp    80104a94 <scheduler+0x128>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a80:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104a87:	81 7d f4 f4 5e 11 80 	cmpl   $0x80115ef4,-0xc(%ebp)
80104a8e:	0f 82 6c ff ff ff    	jb     80104a00 <scheduler+0x94>
    release(&ptable.lock);  // Unlock process table
80104a94:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104a9b:	e8 87 05 00 00       	call   80105027 <release>
  }
80104aa0:	e9 e2 fe ff ff       	jmp    80104987 <scheduler+0x1b>

80104aa5 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104aa5:	55                   	push   %ebp
80104aa6:	89 e5                	mov    %esp,%ebp
80104aa8:	83 ec 28             	sub    $0x28,%esp
  int intena;
  struct proc *p = myproc();
80104aab:	e8 fe f7 ff ff       	call   801042ae <myproc>
80104ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104ab3:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104aba:	e8 2c 06 00 00       	call   801050eb <holding>
80104abf:	85 c0                	test   %eax,%eax
80104ac1:	75 0c                	jne    80104acf <sched+0x2a>
    panic("sched ptable.lock");
80104ac3:	c7 04 24 47 88 10 80 	movl   $0x80108847,(%esp)
80104aca:	e8 93 ba ff ff       	call   80100562 <panic>
  if(mycpu()->ncli != 1)
80104acf:	e8 64 f7 ff ff       	call   80104238 <mycpu>
80104ad4:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ada:	83 f8 01             	cmp    $0x1,%eax
80104add:	74 0c                	je     80104aeb <sched+0x46>
    panic("sched locks");
80104adf:	c7 04 24 59 88 10 80 	movl   $0x80108859,(%esp)
80104ae6:	e8 77 ba ff ff       	call   80100562 <panic>
  if(p->state == RUNNING)
80104aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aee:	8b 40 0c             	mov    0xc(%eax),%eax
80104af1:	83 f8 04             	cmp    $0x4,%eax
80104af4:	75 0c                	jne    80104b02 <sched+0x5d>
    panic("sched running");
80104af6:	c7 04 24 65 88 10 80 	movl   $0x80108865,(%esp)
80104afd:	e8 60 ba ff ff       	call   80100562 <panic>
  if(readeflags()&FL_IF)
80104b02:	e8 91 f5 ff ff       	call   80104098 <readeflags>
80104b07:	25 00 02 00 00       	and    $0x200,%eax
80104b0c:	85 c0                	test   %eax,%eax
80104b0e:	74 0c                	je     80104b1c <sched+0x77>
    panic("sched interruptible");
80104b10:	c7 04 24 73 88 10 80 	movl   $0x80108873,(%esp)
80104b17:	e8 46 ba ff ff       	call   80100562 <panic>
  intena = mycpu()->intena;
80104b1c:	e8 17 f7 ff ff       	call   80104238 <mycpu>
80104b21:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104b2a:	e8 09 f7 ff ff       	call   80104238 <mycpu>
80104b2f:	8b 40 04             	mov    0x4(%eax),%eax
80104b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b35:	83 c2 1c             	add    $0x1c,%edx
80104b38:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b3c:	89 14 24             	mov    %edx,(%esp)
80104b3f:	e8 7e 09 00 00       	call   801054c2 <swtch>
  mycpu()->intena = intena;
80104b44:	e8 ef f6 ff ff       	call   80104238 <mycpu>
80104b49:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b4c:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104b52:	c9                   	leave  
80104b53:	c3                   	ret    

80104b54 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104b54:	55                   	push   %ebp
80104b55:	89 e5                	mov    %esp,%ebp
80104b57:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104b5a:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104b61:	e8 59 04 00 00       	call   80104fbf <acquire>
  myproc()->state = RUNNABLE;
80104b66:	e8 43 f7 ff ff       	call   801042ae <myproc>
80104b6b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104b72:	e8 2e ff ff ff       	call   80104aa5 <sched>
  release(&ptable.lock);
80104b77:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104b7e:	e8 a4 04 00 00       	call   80105027 <release>
}
80104b83:	c9                   	leave  
80104b84:	c3                   	ret    

80104b85 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104b85:	55                   	push   %ebp
80104b86:	89 e5                	mov    %esp,%ebp
80104b88:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104b8b:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104b92:	e8 90 04 00 00       	call   80105027 <release>

  if (first) {
80104b97:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104b9c:	85 c0                	test   %eax,%eax
80104b9e:	74 22                	je     80104bc2 <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104ba0:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104ba7:	00 00 00 
    iinit(ROOTDEV);
80104baa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104bb1:	e8 3a ca ff ff       	call   801015f0 <iinit>
    initlog(ROOTDEV);
80104bb6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104bbd:	e8 c1 e6 ff ff       	call   80103283 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104bc2:	c9                   	leave  
80104bc3:	c3                   	ret    

80104bc4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104bc4:	55                   	push   %ebp
80104bc5:	89 e5                	mov    %esp,%ebp
80104bc7:	83 ec 28             	sub    $0x28,%esp
  struct proc *p = myproc();
80104bca:	e8 df f6 ff ff       	call   801042ae <myproc>
80104bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104bd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104bd6:	75 0c                	jne    80104be4 <sleep+0x20>
    panic("sleep");
80104bd8:	c7 04 24 87 88 10 80 	movl   $0x80108887,(%esp)
80104bdf:	e8 7e b9 ff ff       	call   80100562 <panic>

  if(lk == 0)
80104be4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104be8:	75 0c                	jne    80104bf6 <sleep+0x32>
    panic("sleep without lk");
80104bea:	c7 04 24 8d 88 10 80 	movl   $0x8010888d,(%esp)
80104bf1:	e8 6c b9 ff ff       	call   80100562 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104bf6:	81 7d 0c c0 3d 11 80 	cmpl   $0x80113dc0,0xc(%ebp)
80104bfd:	74 17                	je     80104c16 <sleep+0x52>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104bff:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104c06:	e8 b4 03 00 00       	call   80104fbf <acquire>
    release(lk);
80104c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c0e:	89 04 24             	mov    %eax,(%esp)
80104c11:	e8 11 04 00 00       	call   80105027 <release>
  }
  // Go to sleep.
  p->chan = chan;
80104c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c19:	8b 55 08             	mov    0x8(%ebp),%edx
80104c1c:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c22:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104c29:	e8 77 fe ff ff       	call   80104aa5 <sched>

  // Tidy up.
  p->chan = 0;
80104c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c31:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104c38:	81 7d 0c c0 3d 11 80 	cmpl   $0x80113dc0,0xc(%ebp)
80104c3f:	74 17                	je     80104c58 <sleep+0x94>
    release(&ptable.lock);
80104c41:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104c48:	e8 da 03 00 00       	call   80105027 <release>
    acquire(lk);
80104c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c50:	89 04 24             	mov    %eax,(%esp)
80104c53:	e8 67 03 00 00       	call   80104fbf <acquire>
  }
}
80104c58:	c9                   	leave  
80104c59:	c3                   	ret    

80104c5a <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104c5a:	55                   	push   %ebp
80104c5b:	89 e5                	mov    %esp,%ebp
80104c5d:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c60:	c7 45 fc f4 3d 11 80 	movl   $0x80113df4,-0x4(%ebp)
80104c67:	eb 27                	jmp    80104c90 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c6c:	8b 40 0c             	mov    0xc(%eax),%eax
80104c6f:	83 f8 02             	cmp    $0x2,%eax
80104c72:	75 15                	jne    80104c89 <wakeup1+0x2f>
80104c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c77:	8b 40 20             	mov    0x20(%eax),%eax
80104c7a:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c7d:	75 0a                	jne    80104c89 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c82:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c89:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104c90:	81 7d fc f4 5e 11 80 	cmpl   $0x80115ef4,-0x4(%ebp)
80104c97:	72 d0                	jb     80104c69 <wakeup1+0xf>
}
80104c99:	c9                   	leave  
80104c9a:	c3                   	ret    

80104c9b <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104c9b:	55                   	push   %ebp
80104c9c:	89 e5                	mov    %esp,%ebp
80104c9e:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104ca1:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104ca8:	e8 12 03 00 00       	call   80104fbf <acquire>
  wakeup1(chan);
80104cad:	8b 45 08             	mov    0x8(%ebp),%eax
80104cb0:	89 04 24             	mov    %eax,(%esp)
80104cb3:	e8 a2 ff ff ff       	call   80104c5a <wakeup1>
  release(&ptable.lock);
80104cb8:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104cbf:	e8 63 03 00 00       	call   80105027 <release>
}
80104cc4:	c9                   	leave  
80104cc5:	c3                   	ret    

80104cc6 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104cc6:	55                   	push   %ebp
80104cc7:	89 e5                	mov    %esp,%ebp
80104cc9:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104ccc:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104cd3:	e8 e7 02 00 00       	call   80104fbf <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cd8:	c7 45 f4 f4 3d 11 80 	movl   $0x80113df4,-0xc(%ebp)
80104cdf:	eb 44                	jmp    80104d25 <kill+0x5f>
    if(p->pid == pid){
80104ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce4:	8b 40 10             	mov    0x10(%eax),%eax
80104ce7:	3b 45 08             	cmp    0x8(%ebp),%eax
80104cea:	75 32                	jne    80104d1e <kill+0x58>
      p->killed = 1;
80104cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cef:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf9:	8b 40 0c             	mov    0xc(%eax),%eax
80104cfc:	83 f8 02             	cmp    $0x2,%eax
80104cff:	75 0a                	jne    80104d0b <kill+0x45>
        p->state = RUNNABLE;
80104d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d04:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104d0b:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104d12:	e8 10 03 00 00       	call   80105027 <release>
      return 0;
80104d17:	b8 00 00 00 00       	mov    $0x0,%eax
80104d1c:	eb 21                	jmp    80104d3f <kill+0x79>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d1e:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104d25:	81 7d f4 f4 5e 11 80 	cmpl   $0x80115ef4,-0xc(%ebp)
80104d2c:	72 b3                	jb     80104ce1 <kill+0x1b>
    }
  }
  release(&ptable.lock);
80104d2e:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80104d35:	e8 ed 02 00 00       	call   80105027 <release>
  return -1;
80104d3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d3f:	c9                   	leave  
80104d40:	c3                   	ret    

80104d41 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104d41:	55                   	push   %ebp
80104d42:	89 e5                	mov    %esp,%ebp
80104d44:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d47:	c7 45 f0 f4 3d 11 80 	movl   $0x80113df4,-0x10(%ebp)
80104d4e:	e9 d9 00 00 00       	jmp    80104e2c <procdump+0xeb>
    if(p->state == UNUSED)
80104d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d56:	8b 40 0c             	mov    0xc(%eax),%eax
80104d59:	85 c0                	test   %eax,%eax
80104d5b:	75 05                	jne    80104d62 <procdump+0x21>
      continue;
80104d5d:	e9 c3 00 00 00       	jmp    80104e25 <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d65:	8b 40 0c             	mov    0xc(%eax),%eax
80104d68:	83 f8 05             	cmp    $0x5,%eax
80104d6b:	77 23                	ja     80104d90 <procdump+0x4f>
80104d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d70:	8b 40 0c             	mov    0xc(%eax),%eax
80104d73:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104d7a:	85 c0                	test   %eax,%eax
80104d7c:	74 12                	je     80104d90 <procdump+0x4f>
      state = states[p->state];
80104d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d81:	8b 40 0c             	mov    0xc(%eax),%eax
80104d84:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104d8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104d8e:	eb 07                	jmp    80104d97 <procdump+0x56>
    else
      state = "???";
80104d90:	c7 45 ec 9e 88 10 80 	movl   $0x8010889e,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d9a:	8d 50 6c             	lea    0x6c(%eax),%edx
80104d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104da0:	8b 40 10             	mov    0x10(%eax),%eax
80104da3:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104da7:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104daa:	89 54 24 08          	mov    %edx,0x8(%esp)
80104dae:	89 44 24 04          	mov    %eax,0x4(%esp)
80104db2:	c7 04 24 a2 88 10 80 	movl   $0x801088a2,(%esp)
80104db9:	e8 0a b6 ff ff       	call   801003c8 <cprintf>
    if(p->state == SLEEPING){
80104dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dc1:	8b 40 0c             	mov    0xc(%eax),%eax
80104dc4:	83 f8 02             	cmp    $0x2,%eax
80104dc7:	75 50                	jne    80104e19 <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dcc:	8b 40 1c             	mov    0x1c(%eax),%eax
80104dcf:	8b 40 0c             	mov    0xc(%eax),%eax
80104dd2:	83 c0 08             	add    $0x8,%eax
80104dd5:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104dd8:	89 54 24 04          	mov    %edx,0x4(%esp)
80104ddc:	89 04 24             	mov    %eax,(%esp)
80104ddf:	e8 8e 02 00 00       	call   80105072 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104de4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104deb:	eb 1b                	jmp    80104e08 <procdump+0xc7>
        cprintf(" %p", pc[i]);
80104ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df0:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104df4:	89 44 24 04          	mov    %eax,0x4(%esp)
80104df8:	c7 04 24 ab 88 10 80 	movl   $0x801088ab,(%esp)
80104dff:	e8 c4 b5 ff ff       	call   801003c8 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104e04:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104e08:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104e0c:	7f 0b                	jg     80104e19 <procdump+0xd8>
80104e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e11:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e15:	85 c0                	test   %eax,%eax
80104e17:	75 d4                	jne    80104ded <procdump+0xac>
    }
    cprintf("\n");
80104e19:	c7 04 24 af 88 10 80 	movl   $0x801088af,(%esp)
80104e20:	e8 a3 b5 ff ff       	call   801003c8 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e25:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104e2c:	81 7d f0 f4 5e 11 80 	cmpl   $0x80115ef4,-0x10(%ebp)
80104e33:	0f 82 1a ff ff ff    	jb     80104d53 <procdump+0x12>
  }
}
80104e39:	c9                   	leave  
80104e3a:	c3                   	ret    

80104e3b <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104e3b:	55                   	push   %ebp
80104e3c:	89 e5                	mov    %esp,%ebp
80104e3e:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
80104e41:	8b 45 08             	mov    0x8(%ebp),%eax
80104e44:	83 c0 04             	add    $0x4,%eax
80104e47:	c7 44 24 04 db 88 10 	movl   $0x801088db,0x4(%esp)
80104e4e:	80 
80104e4f:	89 04 24             	mov    %eax,(%esp)
80104e52:	e8 47 01 00 00       	call   80104f9e <initlock>
  lk->name = name;
80104e57:	8b 45 08             	mov    0x8(%ebp),%eax
80104e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e5d:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104e60:	8b 45 08             	mov    0x8(%ebp),%eax
80104e63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104e69:	8b 45 08             	mov    0x8(%ebp),%eax
80104e6c:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104e73:	c9                   	leave  
80104e74:	c3                   	ret    

80104e75 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104e75:	55                   	push   %ebp
80104e76:	89 e5                	mov    %esp,%ebp
80104e78:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80104e7e:	83 c0 04             	add    $0x4,%eax
80104e81:	89 04 24             	mov    %eax,(%esp)
80104e84:	e8 36 01 00 00       	call   80104fbf <acquire>
  while (lk->locked) {
80104e89:	eb 15                	jmp    80104ea0 <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
80104e8b:	8b 45 08             	mov    0x8(%ebp),%eax
80104e8e:	83 c0 04             	add    $0x4,%eax
80104e91:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e95:	8b 45 08             	mov    0x8(%ebp),%eax
80104e98:	89 04 24             	mov    %eax,(%esp)
80104e9b:	e8 24 fd ff ff       	call   80104bc4 <sleep>
  while (lk->locked) {
80104ea0:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea3:	8b 00                	mov    (%eax),%eax
80104ea5:	85 c0                	test   %eax,%eax
80104ea7:	75 e2                	jne    80104e8b <acquiresleep+0x16>
  }
  lk->locked = 1;
80104ea9:	8b 45 08             	mov    0x8(%ebp),%eax
80104eac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104eb2:	e8 f7 f3 ff ff       	call   801042ae <myproc>
80104eb7:	8b 50 10             	mov    0x10(%eax),%edx
80104eba:	8b 45 08             	mov    0x8(%ebp),%eax
80104ebd:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104ec0:	8b 45 08             	mov    0x8(%ebp),%eax
80104ec3:	83 c0 04             	add    $0x4,%eax
80104ec6:	89 04 24             	mov    %eax,(%esp)
80104ec9:	e8 59 01 00 00       	call   80105027 <release>
}
80104ece:	c9                   	leave  
80104ecf:	c3                   	ret    

80104ed0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104ed6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed9:	83 c0 04             	add    $0x4,%eax
80104edc:	89 04 24             	mov    %eax,(%esp)
80104edf:	e8 db 00 00 00       	call   80104fbf <acquire>
  lk->locked = 0;
80104ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80104ee7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104eed:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef0:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104ef7:	8b 45 08             	mov    0x8(%ebp),%eax
80104efa:	89 04 24             	mov    %eax,(%esp)
80104efd:	e8 99 fd ff ff       	call   80104c9b <wakeup>
  release(&lk->lk);
80104f02:	8b 45 08             	mov    0x8(%ebp),%eax
80104f05:	83 c0 04             	add    $0x4,%eax
80104f08:	89 04 24             	mov    %eax,(%esp)
80104f0b:	e8 17 01 00 00       	call   80105027 <release>
}
80104f10:	c9                   	leave  
80104f11:	c3                   	ret    

80104f12 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104f12:	55                   	push   %ebp
80104f13:	89 e5                	mov    %esp,%ebp
80104f15:	53                   	push   %ebx
80104f16:	83 ec 24             	sub    $0x24,%esp
  int r;
  
  acquire(&lk->lk);
80104f19:	8b 45 08             	mov    0x8(%ebp),%eax
80104f1c:	83 c0 04             	add    $0x4,%eax
80104f1f:	89 04 24             	mov    %eax,(%esp)
80104f22:	e8 98 00 00 00       	call   80104fbf <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104f27:	8b 45 08             	mov    0x8(%ebp),%eax
80104f2a:	8b 00                	mov    (%eax),%eax
80104f2c:	85 c0                	test   %eax,%eax
80104f2e:	74 19                	je     80104f49 <holdingsleep+0x37>
80104f30:	8b 45 08             	mov    0x8(%ebp),%eax
80104f33:	8b 58 3c             	mov    0x3c(%eax),%ebx
80104f36:	e8 73 f3 ff ff       	call   801042ae <myproc>
80104f3b:	8b 40 10             	mov    0x10(%eax),%eax
80104f3e:	39 c3                	cmp    %eax,%ebx
80104f40:	75 07                	jne    80104f49 <holdingsleep+0x37>
80104f42:	b8 01 00 00 00       	mov    $0x1,%eax
80104f47:	eb 05                	jmp    80104f4e <holdingsleep+0x3c>
80104f49:	b8 00 00 00 00       	mov    $0x0,%eax
80104f4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104f51:	8b 45 08             	mov    0x8(%ebp),%eax
80104f54:	83 c0 04             	add    $0x4,%eax
80104f57:	89 04 24             	mov    %eax,(%esp)
80104f5a:	e8 c8 00 00 00       	call   80105027 <release>
  return r;
80104f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104f62:	83 c4 24             	add    $0x24,%esp
80104f65:	5b                   	pop    %ebx
80104f66:	5d                   	pop    %ebp
80104f67:	c3                   	ret    

80104f68 <readeflags>:
{
80104f68:	55                   	push   %ebp
80104f69:	89 e5                	mov    %esp,%ebp
80104f6b:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f6e:	9c                   	pushf  
80104f6f:	58                   	pop    %eax
80104f70:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104f73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f76:	c9                   	leave  
80104f77:	c3                   	ret    

80104f78 <cli>:
{
80104f78:	55                   	push   %ebp
80104f79:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f7b:	fa                   	cli    
}
80104f7c:	5d                   	pop    %ebp
80104f7d:	c3                   	ret    

80104f7e <sti>:
{
80104f7e:	55                   	push   %ebp
80104f7f:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f81:	fb                   	sti    
}
80104f82:	5d                   	pop    %ebp
80104f83:	c3                   	ret    

80104f84 <xchg>:
{
80104f84:	55                   	push   %ebp
80104f85:	89 e5                	mov    %esp,%ebp
80104f87:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104f8a:	8b 55 08             	mov    0x8(%ebp),%edx
80104f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f90:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f93:	f0 87 02             	lock xchg %eax,(%edx)
80104f96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104f99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f9c:	c9                   	leave  
80104f9d:	c3                   	ret    

80104f9e <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f9e:	55                   	push   %ebp
80104f9f:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80104fa4:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fa7:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104faa:	8b 45 08             	mov    0x8(%ebp),%eax
80104fad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104fb3:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104fbd:	5d                   	pop    %ebp
80104fbe:	c3                   	ret    

80104fbf <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104fbf:	55                   	push   %ebp
80104fc0:	89 e5                	mov    %esp,%ebp
80104fc2:	53                   	push   %ebx
80104fc3:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104fc6:	e8 61 01 00 00       	call   8010512c <pushcli>
  if(holding(lk))
80104fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80104fce:	89 04 24             	mov    %eax,(%esp)
80104fd1:	e8 15 01 00 00       	call   801050eb <holding>
80104fd6:	85 c0                	test   %eax,%eax
80104fd8:	74 0c                	je     80104fe6 <acquire+0x27>
    panic("acquire");
80104fda:	c7 04 24 e6 88 10 80 	movl   $0x801088e6,(%esp)
80104fe1:	e8 7c b5 ff ff       	call   80100562 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104fe6:	90                   	nop
80104fe7:	8b 45 08             	mov    0x8(%ebp),%eax
80104fea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104ff1:	00 
80104ff2:	89 04 24             	mov    %eax,(%esp)
80104ff5:	e8 8a ff ff ff       	call   80104f84 <xchg>
80104ffa:	85 c0                	test   %eax,%eax
80104ffc:	75 e9                	jne    80104fe7 <acquire+0x28>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104ffe:	0f ae f0             	mfence 

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80105001:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105004:	e8 2f f2 ff ff       	call   80104238 <mycpu>
80105009:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010500c:	8b 45 08             	mov    0x8(%ebp),%eax
8010500f:	83 c0 0c             	add    $0xc,%eax
80105012:	89 44 24 04          	mov    %eax,0x4(%esp)
80105016:	8d 45 08             	lea    0x8(%ebp),%eax
80105019:	89 04 24             	mov    %eax,(%esp)
8010501c:	e8 51 00 00 00       	call   80105072 <getcallerpcs>
}
80105021:	83 c4 14             	add    $0x14,%esp
80105024:	5b                   	pop    %ebx
80105025:	5d                   	pop    %ebp
80105026:	c3                   	ret    

80105027 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105027:	55                   	push   %ebp
80105028:	89 e5                	mov    %esp,%ebp
8010502a:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
8010502d:	8b 45 08             	mov    0x8(%ebp),%eax
80105030:	89 04 24             	mov    %eax,(%esp)
80105033:	e8 b3 00 00 00       	call   801050eb <holding>
80105038:	85 c0                	test   %eax,%eax
8010503a:	75 0c                	jne    80105048 <release+0x21>
    panic("release");
8010503c:	c7 04 24 ee 88 10 80 	movl   $0x801088ee,(%esp)
80105043:	e8 1a b5 ff ff       	call   80100562 <panic>

  lk->pcs[0] = 0;
80105048:	8b 45 08             	mov    0x8(%ebp),%eax
8010504b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105052:	8b 45 08             	mov    0x8(%ebp),%eax
80105055:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010505c:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010505f:	8b 45 08             	mov    0x8(%ebp),%eax
80105062:	8b 55 08             	mov    0x8(%ebp),%edx
80105065:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
8010506b:	e8 08 01 00 00       	call   80105178 <popcli>
}
80105070:	c9                   	leave  
80105071:	c3                   	ret    

80105072 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105072:	55                   	push   %ebp
80105073:	89 e5                	mov    %esp,%ebp
80105075:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105078:	8b 45 08             	mov    0x8(%ebp),%eax
8010507b:	83 e8 08             	sub    $0x8,%eax
8010507e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105081:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105088:	eb 38                	jmp    801050c2 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010508a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010508e:	74 38                	je     801050c8 <getcallerpcs+0x56>
80105090:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105097:	76 2f                	jbe    801050c8 <getcallerpcs+0x56>
80105099:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010509d:	74 29                	je     801050c8 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010509f:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801050a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ac:	01 c2                	add    %eax,%edx
801050ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050b1:	8b 40 04             	mov    0x4(%eax),%eax
801050b4:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801050b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050b9:	8b 00                	mov    (%eax),%eax
801050bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801050be:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801050c2:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801050c6:	7e c2                	jle    8010508a <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
801050c8:	eb 19                	jmp    801050e3 <getcallerpcs+0x71>
    pcs[i] = 0;
801050ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801050d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801050d7:	01 d0                	add    %edx,%eax
801050d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801050df:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801050e3:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801050e7:	7e e1                	jle    801050ca <getcallerpcs+0x58>
}
801050e9:	c9                   	leave  
801050ea:	c3                   	ret    

801050eb <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801050eb:	55                   	push   %ebp
801050ec:	89 e5                	mov    %esp,%ebp
801050ee:	53                   	push   %ebx
801050ef:	83 ec 14             	sub    $0x14,%esp
  int r;
  pushcli();
801050f2:	e8 35 00 00 00       	call   8010512c <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801050f7:	8b 45 08             	mov    0x8(%ebp),%eax
801050fa:	8b 00                	mov    (%eax),%eax
801050fc:	85 c0                	test   %eax,%eax
801050fe:	74 16                	je     80105116 <holding+0x2b>
80105100:	8b 45 08             	mov    0x8(%ebp),%eax
80105103:	8b 58 08             	mov    0x8(%eax),%ebx
80105106:	e8 2d f1 ff ff       	call   80104238 <mycpu>
8010510b:	39 c3                	cmp    %eax,%ebx
8010510d:	75 07                	jne    80105116 <holding+0x2b>
8010510f:	b8 01 00 00 00       	mov    $0x1,%eax
80105114:	eb 05                	jmp    8010511b <holding+0x30>
80105116:	b8 00 00 00 00       	mov    $0x0,%eax
8010511b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
8010511e:	e8 55 00 00 00       	call   80105178 <popcli>
  return r;
80105123:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105126:	83 c4 14             	add    $0x14,%esp
80105129:	5b                   	pop    %ebx
8010512a:	5d                   	pop    %ebp
8010512b:	c3                   	ret    

8010512c <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010512c:	55                   	push   %ebp
8010512d:	89 e5                	mov    %esp,%ebp
8010512f:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80105132:	e8 31 fe ff ff       	call   80104f68 <readeflags>
80105137:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
8010513a:	e8 39 fe ff ff       	call   80104f78 <cli>
  if(mycpu()->ncli == 0)
8010513f:	e8 f4 f0 ff ff       	call   80104238 <mycpu>
80105144:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010514a:	85 c0                	test   %eax,%eax
8010514c:	75 14                	jne    80105162 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
8010514e:	e8 e5 f0 ff ff       	call   80104238 <mycpu>
80105153:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105156:	81 e2 00 02 00 00    	and    $0x200,%edx
8010515c:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80105162:	e8 d1 f0 ff ff       	call   80104238 <mycpu>
80105167:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010516d:	83 c2 01             	add    $0x1,%edx
80105170:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80105176:	c9                   	leave  
80105177:	c3                   	ret    

80105178 <popcli>:

void
popcli(void)
{
80105178:	55                   	push   %ebp
80105179:	89 e5                	mov    %esp,%ebp
8010517b:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
8010517e:	e8 e5 fd ff ff       	call   80104f68 <readeflags>
80105183:	25 00 02 00 00       	and    $0x200,%eax
80105188:	85 c0                	test   %eax,%eax
8010518a:	74 0c                	je     80105198 <popcli+0x20>
    panic("popcli - interruptible");
8010518c:	c7 04 24 f6 88 10 80 	movl   $0x801088f6,(%esp)
80105193:	e8 ca b3 ff ff       	call   80100562 <panic>
  if(--mycpu()->ncli < 0)
80105198:	e8 9b f0 ff ff       	call   80104238 <mycpu>
8010519d:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801051a3:	83 ea 01             	sub    $0x1,%edx
801051a6:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801051ac:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801051b2:	85 c0                	test   %eax,%eax
801051b4:	79 0c                	jns    801051c2 <popcli+0x4a>
    panic("popcli");
801051b6:	c7 04 24 0d 89 10 80 	movl   $0x8010890d,(%esp)
801051bd:	e8 a0 b3 ff ff       	call   80100562 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
801051c2:	e8 71 f0 ff ff       	call   80104238 <mycpu>
801051c7:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801051cd:	85 c0                	test   %eax,%eax
801051cf:	75 14                	jne    801051e5 <popcli+0x6d>
801051d1:	e8 62 f0 ff ff       	call   80104238 <mycpu>
801051d6:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801051dc:	85 c0                	test   %eax,%eax
801051de:	74 05                	je     801051e5 <popcli+0x6d>
    sti();
801051e0:	e8 99 fd ff ff       	call   80104f7e <sti>
}
801051e5:	c9                   	leave  
801051e6:	c3                   	ret    

801051e7 <stosb>:
{
801051e7:	55                   	push   %ebp
801051e8:	89 e5                	mov    %esp,%ebp
801051ea:	57                   	push   %edi
801051eb:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801051ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051ef:	8b 55 10             	mov    0x10(%ebp),%edx
801051f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801051f5:	89 cb                	mov    %ecx,%ebx
801051f7:	89 df                	mov    %ebx,%edi
801051f9:	89 d1                	mov    %edx,%ecx
801051fb:	fc                   	cld    
801051fc:	f3 aa                	rep stos %al,%es:(%edi)
801051fe:	89 ca                	mov    %ecx,%edx
80105200:	89 fb                	mov    %edi,%ebx
80105202:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105205:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105208:	5b                   	pop    %ebx
80105209:	5f                   	pop    %edi
8010520a:	5d                   	pop    %ebp
8010520b:	c3                   	ret    

8010520c <stosl>:
{
8010520c:	55                   	push   %ebp
8010520d:	89 e5                	mov    %esp,%ebp
8010520f:	57                   	push   %edi
80105210:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105211:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105214:	8b 55 10             	mov    0x10(%ebp),%edx
80105217:	8b 45 0c             	mov    0xc(%ebp),%eax
8010521a:	89 cb                	mov    %ecx,%ebx
8010521c:	89 df                	mov    %ebx,%edi
8010521e:	89 d1                	mov    %edx,%ecx
80105220:	fc                   	cld    
80105221:	f3 ab                	rep stos %eax,%es:(%edi)
80105223:	89 ca                	mov    %ecx,%edx
80105225:	89 fb                	mov    %edi,%ebx
80105227:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010522a:	89 55 10             	mov    %edx,0x10(%ebp)
}
8010522d:	5b                   	pop    %ebx
8010522e:	5f                   	pop    %edi
8010522f:	5d                   	pop    %ebp
80105230:	c3                   	ret    

80105231 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105231:	55                   	push   %ebp
80105232:	89 e5                	mov    %esp,%ebp
80105234:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105237:	8b 45 08             	mov    0x8(%ebp),%eax
8010523a:	83 e0 03             	and    $0x3,%eax
8010523d:	85 c0                	test   %eax,%eax
8010523f:	75 49                	jne    8010528a <memset+0x59>
80105241:	8b 45 10             	mov    0x10(%ebp),%eax
80105244:	83 e0 03             	and    $0x3,%eax
80105247:	85 c0                	test   %eax,%eax
80105249:	75 3f                	jne    8010528a <memset+0x59>
    c &= 0xFF;
8010524b:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105252:	8b 45 10             	mov    0x10(%ebp),%eax
80105255:	c1 e8 02             	shr    $0x2,%eax
80105258:	89 c2                	mov    %eax,%edx
8010525a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010525d:	c1 e0 18             	shl    $0x18,%eax
80105260:	89 c1                	mov    %eax,%ecx
80105262:	8b 45 0c             	mov    0xc(%ebp),%eax
80105265:	c1 e0 10             	shl    $0x10,%eax
80105268:	09 c1                	or     %eax,%ecx
8010526a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010526d:	c1 e0 08             	shl    $0x8,%eax
80105270:	09 c8                	or     %ecx,%eax
80105272:	0b 45 0c             	or     0xc(%ebp),%eax
80105275:	89 54 24 08          	mov    %edx,0x8(%esp)
80105279:	89 44 24 04          	mov    %eax,0x4(%esp)
8010527d:	8b 45 08             	mov    0x8(%ebp),%eax
80105280:	89 04 24             	mov    %eax,(%esp)
80105283:	e8 84 ff ff ff       	call   8010520c <stosl>
80105288:	eb 19                	jmp    801052a3 <memset+0x72>
  } else
    stosb(dst, c, n);
8010528a:	8b 45 10             	mov    0x10(%ebp),%eax
8010528d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105291:	8b 45 0c             	mov    0xc(%ebp),%eax
80105294:	89 44 24 04          	mov    %eax,0x4(%esp)
80105298:	8b 45 08             	mov    0x8(%ebp),%eax
8010529b:	89 04 24             	mov    %eax,(%esp)
8010529e:	e8 44 ff ff ff       	call   801051e7 <stosb>
  return dst;
801052a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801052a6:	c9                   	leave  
801052a7:	c3                   	ret    

801052a8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801052a8:	55                   	push   %ebp
801052a9:	89 e5                	mov    %esp,%ebp
801052ab:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
801052ae:	8b 45 08             	mov    0x8(%ebp),%eax
801052b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801052b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801052b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801052ba:	eb 30                	jmp    801052ec <memcmp+0x44>
    if(*s1 != *s2)
801052bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052bf:	0f b6 10             	movzbl (%eax),%edx
801052c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052c5:	0f b6 00             	movzbl (%eax),%eax
801052c8:	38 c2                	cmp    %al,%dl
801052ca:	74 18                	je     801052e4 <memcmp+0x3c>
      return *s1 - *s2;
801052cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052cf:	0f b6 00             	movzbl (%eax),%eax
801052d2:	0f b6 d0             	movzbl %al,%edx
801052d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052d8:	0f b6 00             	movzbl (%eax),%eax
801052db:	0f b6 c0             	movzbl %al,%eax
801052de:	29 c2                	sub    %eax,%edx
801052e0:	89 d0                	mov    %edx,%eax
801052e2:	eb 1a                	jmp    801052fe <memcmp+0x56>
    s1++, s2++;
801052e4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801052e8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
801052ec:	8b 45 10             	mov    0x10(%ebp),%eax
801052ef:	8d 50 ff             	lea    -0x1(%eax),%edx
801052f2:	89 55 10             	mov    %edx,0x10(%ebp)
801052f5:	85 c0                	test   %eax,%eax
801052f7:	75 c3                	jne    801052bc <memcmp+0x14>
  }

  return 0;
801052f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052fe:	c9                   	leave  
801052ff:	c3                   	ret    

80105300 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105306:	8b 45 0c             	mov    0xc(%ebp),%eax
80105309:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010530c:	8b 45 08             	mov    0x8(%ebp),%eax
8010530f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105312:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105315:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105318:	73 3d                	jae    80105357 <memmove+0x57>
8010531a:	8b 45 10             	mov    0x10(%ebp),%eax
8010531d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105320:	01 d0                	add    %edx,%eax
80105322:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105325:	76 30                	jbe    80105357 <memmove+0x57>
    s += n;
80105327:	8b 45 10             	mov    0x10(%ebp),%eax
8010532a:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010532d:	8b 45 10             	mov    0x10(%ebp),%eax
80105330:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105333:	eb 13                	jmp    80105348 <memmove+0x48>
      *--d = *--s;
80105335:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105339:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010533d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105340:	0f b6 10             	movzbl (%eax),%edx
80105343:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105346:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105348:	8b 45 10             	mov    0x10(%ebp),%eax
8010534b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010534e:	89 55 10             	mov    %edx,0x10(%ebp)
80105351:	85 c0                	test   %eax,%eax
80105353:	75 e0                	jne    80105335 <memmove+0x35>
  if(s < d && s + n > d){
80105355:	eb 26                	jmp    8010537d <memmove+0x7d>
  } else
    while(n-- > 0)
80105357:	eb 17                	jmp    80105370 <memmove+0x70>
      *d++ = *s++;
80105359:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010535c:	8d 50 01             	lea    0x1(%eax),%edx
8010535f:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105362:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105365:	8d 4a 01             	lea    0x1(%edx),%ecx
80105368:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010536b:	0f b6 12             	movzbl (%edx),%edx
8010536e:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105370:	8b 45 10             	mov    0x10(%ebp),%eax
80105373:	8d 50 ff             	lea    -0x1(%eax),%edx
80105376:	89 55 10             	mov    %edx,0x10(%ebp)
80105379:	85 c0                	test   %eax,%eax
8010537b:	75 dc                	jne    80105359 <memmove+0x59>

  return dst;
8010537d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105380:	c9                   	leave  
80105381:	c3                   	ret    

80105382 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105382:	55                   	push   %ebp
80105383:	89 e5                	mov    %esp,%ebp
80105385:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105388:	8b 45 10             	mov    0x10(%ebp),%eax
8010538b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010538f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105392:	89 44 24 04          	mov    %eax,0x4(%esp)
80105396:	8b 45 08             	mov    0x8(%ebp),%eax
80105399:	89 04 24             	mov    %eax,(%esp)
8010539c:	e8 5f ff ff ff       	call   80105300 <memmove>
}
801053a1:	c9                   	leave  
801053a2:	c3                   	ret    

801053a3 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801053a3:	55                   	push   %ebp
801053a4:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801053a6:	eb 0c                	jmp    801053b4 <strncmp+0x11>
    n--, p++, q++;
801053a8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801053ac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801053b0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
801053b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053b8:	74 1a                	je     801053d4 <strncmp+0x31>
801053ba:	8b 45 08             	mov    0x8(%ebp),%eax
801053bd:	0f b6 00             	movzbl (%eax),%eax
801053c0:	84 c0                	test   %al,%al
801053c2:	74 10                	je     801053d4 <strncmp+0x31>
801053c4:	8b 45 08             	mov    0x8(%ebp),%eax
801053c7:	0f b6 10             	movzbl (%eax),%edx
801053ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801053cd:	0f b6 00             	movzbl (%eax),%eax
801053d0:	38 c2                	cmp    %al,%dl
801053d2:	74 d4                	je     801053a8 <strncmp+0x5>
  if(n == 0)
801053d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053d8:	75 07                	jne    801053e1 <strncmp+0x3e>
    return 0;
801053da:	b8 00 00 00 00       	mov    $0x0,%eax
801053df:	eb 16                	jmp    801053f7 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801053e1:	8b 45 08             	mov    0x8(%ebp),%eax
801053e4:	0f b6 00             	movzbl (%eax),%eax
801053e7:	0f b6 d0             	movzbl %al,%edx
801053ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ed:	0f b6 00             	movzbl (%eax),%eax
801053f0:	0f b6 c0             	movzbl %al,%eax
801053f3:	29 c2                	sub    %eax,%edx
801053f5:	89 d0                	mov    %edx,%eax
}
801053f7:	5d                   	pop    %ebp
801053f8:	c3                   	ret    

801053f9 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053f9:	55                   	push   %ebp
801053fa:	89 e5                	mov    %esp,%ebp
801053fc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801053ff:	8b 45 08             	mov    0x8(%ebp),%eax
80105402:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105405:	90                   	nop
80105406:	8b 45 10             	mov    0x10(%ebp),%eax
80105409:	8d 50 ff             	lea    -0x1(%eax),%edx
8010540c:	89 55 10             	mov    %edx,0x10(%ebp)
8010540f:	85 c0                	test   %eax,%eax
80105411:	7e 1e                	jle    80105431 <strncpy+0x38>
80105413:	8b 45 08             	mov    0x8(%ebp),%eax
80105416:	8d 50 01             	lea    0x1(%eax),%edx
80105419:	89 55 08             	mov    %edx,0x8(%ebp)
8010541c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010541f:	8d 4a 01             	lea    0x1(%edx),%ecx
80105422:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105425:	0f b6 12             	movzbl (%edx),%edx
80105428:	88 10                	mov    %dl,(%eax)
8010542a:	0f b6 00             	movzbl (%eax),%eax
8010542d:	84 c0                	test   %al,%al
8010542f:	75 d5                	jne    80105406 <strncpy+0xd>
    ;
  while(n-- > 0)
80105431:	eb 0c                	jmp    8010543f <strncpy+0x46>
    *s++ = 0;
80105433:	8b 45 08             	mov    0x8(%ebp),%eax
80105436:	8d 50 01             	lea    0x1(%eax),%edx
80105439:	89 55 08             	mov    %edx,0x8(%ebp)
8010543c:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
8010543f:	8b 45 10             	mov    0x10(%ebp),%eax
80105442:	8d 50 ff             	lea    -0x1(%eax),%edx
80105445:	89 55 10             	mov    %edx,0x10(%ebp)
80105448:	85 c0                	test   %eax,%eax
8010544a:	7f e7                	jg     80105433 <strncpy+0x3a>
  return os;
8010544c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010544f:	c9                   	leave  
80105450:	c3                   	ret    

80105451 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105451:	55                   	push   %ebp
80105452:	89 e5                	mov    %esp,%ebp
80105454:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105457:	8b 45 08             	mov    0x8(%ebp),%eax
8010545a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010545d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105461:	7f 05                	jg     80105468 <safestrcpy+0x17>
    return os;
80105463:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105466:	eb 31                	jmp    80105499 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105468:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010546c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105470:	7e 1e                	jle    80105490 <safestrcpy+0x3f>
80105472:	8b 45 08             	mov    0x8(%ebp),%eax
80105475:	8d 50 01             	lea    0x1(%eax),%edx
80105478:	89 55 08             	mov    %edx,0x8(%ebp)
8010547b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010547e:	8d 4a 01             	lea    0x1(%edx),%ecx
80105481:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105484:	0f b6 12             	movzbl (%edx),%edx
80105487:	88 10                	mov    %dl,(%eax)
80105489:	0f b6 00             	movzbl (%eax),%eax
8010548c:	84 c0                	test   %al,%al
8010548e:	75 d8                	jne    80105468 <safestrcpy+0x17>
    ;
  *s = 0;
80105490:	8b 45 08             	mov    0x8(%ebp),%eax
80105493:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105496:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105499:	c9                   	leave  
8010549a:	c3                   	ret    

8010549b <strlen>:

int
strlen(const char *s)
{
8010549b:	55                   	push   %ebp
8010549c:	89 e5                	mov    %esp,%ebp
8010549e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801054a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801054a8:	eb 04                	jmp    801054ae <strlen+0x13>
801054aa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801054ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054b1:	8b 45 08             	mov    0x8(%ebp),%eax
801054b4:	01 d0                	add    %edx,%eax
801054b6:	0f b6 00             	movzbl (%eax),%eax
801054b9:	84 c0                	test   %al,%al
801054bb:	75 ed                	jne    801054aa <strlen+0xf>
    ;
  return n;
801054bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054c0:	c9                   	leave  
801054c1:	c3                   	ret    

801054c2 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801054c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801054c6:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801054ca:	55                   	push   %ebp
  pushl %ebx
801054cb:	53                   	push   %ebx
  pushl %esi
801054cc:	56                   	push   %esi
  pushl %edi
801054cd:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801054ce:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801054d0:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801054d2:	5f                   	pop    %edi
  popl %esi
801054d3:	5e                   	pop    %esi
  popl %ebx
801054d4:	5b                   	pop    %ebx
  popl %ebp
801054d5:	5d                   	pop    %ebp
  ret
801054d6:	c3                   	ret    

801054d7 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801054d7:	55                   	push   %ebp
801054d8:	89 e5                	mov    %esp,%ebp
801054da:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
801054dd:	e8 cc ed ff ff       	call   801042ae <myproc>
801054e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e8:	8b 00                	mov    (%eax),%eax
801054ea:	3b 45 08             	cmp    0x8(%ebp),%eax
801054ed:	76 0f                	jbe    801054fe <fetchint+0x27>
801054ef:	8b 45 08             	mov    0x8(%ebp),%eax
801054f2:	8d 50 04             	lea    0x4(%eax),%edx
801054f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f8:	8b 00                	mov    (%eax),%eax
801054fa:	39 c2                	cmp    %eax,%edx
801054fc:	76 07                	jbe    80105505 <fetchint+0x2e>
    return -1;
801054fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105503:	eb 0f                	jmp    80105514 <fetchint+0x3d>
  *ip = *(int*)(addr);
80105505:	8b 45 08             	mov    0x8(%ebp),%eax
80105508:	8b 10                	mov    (%eax),%edx
8010550a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010550d:	89 10                	mov    %edx,(%eax)
  return 0;
8010550f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105514:	c9                   	leave  
80105515:	c3                   	ret    

80105516 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105516:	55                   	push   %ebp
80105517:	89 e5                	mov    %esp,%ebp
80105519:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
8010551c:	e8 8d ed ff ff       	call   801042ae <myproc>
80105521:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80105524:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105527:	8b 00                	mov    (%eax),%eax
80105529:	3b 45 08             	cmp    0x8(%ebp),%eax
8010552c:	77 07                	ja     80105535 <fetchstr+0x1f>
    return -1;
8010552e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105533:	eb 43                	jmp    80105578 <fetchstr+0x62>
  *pp = (char*)addr;
80105535:	8b 55 08             	mov    0x8(%ebp),%edx
80105538:	8b 45 0c             	mov    0xc(%ebp),%eax
8010553b:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
8010553d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105540:	8b 00                	mov    (%eax),%eax
80105542:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80105545:	8b 45 0c             	mov    0xc(%ebp),%eax
80105548:	8b 00                	mov    (%eax),%eax
8010554a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010554d:	eb 1c                	jmp    8010556b <fetchstr+0x55>
    if(*s == 0)
8010554f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105552:	0f b6 00             	movzbl (%eax),%eax
80105555:	84 c0                	test   %al,%al
80105557:	75 0e                	jne    80105567 <fetchstr+0x51>
      return s - *pp;
80105559:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010555c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010555f:	8b 00                	mov    (%eax),%eax
80105561:	29 c2                	sub    %eax,%edx
80105563:	89 d0                	mov    %edx,%eax
80105565:	eb 11                	jmp    80105578 <fetchstr+0x62>
  for(s = *pp; s < ep; s++){
80105567:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010556b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010556e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105571:	72 dc                	jb     8010554f <fetchstr+0x39>
  }
  return -1;
80105573:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105578:	c9                   	leave  
80105579:	c3                   	ret    

8010557a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010557a:	55                   	push   %ebp
8010557b:	89 e5                	mov    %esp,%ebp
8010557d:	83 ec 18             	sub    $0x18,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105580:	e8 29 ed ff ff       	call   801042ae <myproc>
80105585:	8b 40 18             	mov    0x18(%eax),%eax
80105588:	8b 50 44             	mov    0x44(%eax),%edx
8010558b:	8b 45 08             	mov    0x8(%ebp),%eax
8010558e:	c1 e0 02             	shl    $0x2,%eax
80105591:	01 d0                	add    %edx,%eax
80105593:	8d 50 04             	lea    0x4(%eax),%edx
80105596:	8b 45 0c             	mov    0xc(%ebp),%eax
80105599:	89 44 24 04          	mov    %eax,0x4(%esp)
8010559d:	89 14 24             	mov    %edx,(%esp)
801055a0:	e8 32 ff ff ff       	call   801054d7 <fetchint>
}
801055a5:	c9                   	leave  
801055a6:	c3                   	ret    

801055a7 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801055a7:	55                   	push   %ebp
801055a8:	89 e5                	mov    %esp,%ebp
801055aa:	83 ec 28             	sub    $0x28,%esp
  int i;
  struct proc *curproc = myproc();
801055ad:	e8 fc ec ff ff       	call   801042ae <myproc>
801055b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
801055b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801055bc:	8b 45 08             	mov    0x8(%ebp),%eax
801055bf:	89 04 24             	mov    %eax,(%esp)
801055c2:	e8 b3 ff ff ff       	call   8010557a <argint>
801055c7:	85 c0                	test   %eax,%eax
801055c9:	79 07                	jns    801055d2 <argptr+0x2b>
    return -1;
801055cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d0:	eb 3d                	jmp    8010560f <argptr+0x68>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801055d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055d6:	78 21                	js     801055f9 <argptr+0x52>
801055d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055db:	89 c2                	mov    %eax,%edx
801055dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055e0:	8b 00                	mov    (%eax),%eax
801055e2:	39 c2                	cmp    %eax,%edx
801055e4:	73 13                	jae    801055f9 <argptr+0x52>
801055e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055e9:	89 c2                	mov    %eax,%edx
801055eb:	8b 45 10             	mov    0x10(%ebp),%eax
801055ee:	01 c2                	add    %eax,%edx
801055f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f3:	8b 00                	mov    (%eax),%eax
801055f5:	39 c2                	cmp    %eax,%edx
801055f7:	76 07                	jbe    80105600 <argptr+0x59>
    return -1;
801055f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055fe:	eb 0f                	jmp    8010560f <argptr+0x68>
  *pp = (char*)i;
80105600:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105603:	89 c2                	mov    %eax,%edx
80105605:	8b 45 0c             	mov    0xc(%ebp),%eax
80105608:	89 10                	mov    %edx,(%eax)
  return 0;
8010560a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010560f:	c9                   	leave  
80105610:	c3                   	ret    

80105611 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105611:	55                   	push   %ebp
80105612:	89 e5                	mov    %esp,%ebp
80105614:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105617:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010561a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010561e:	8b 45 08             	mov    0x8(%ebp),%eax
80105621:	89 04 24             	mov    %eax,(%esp)
80105624:	e8 51 ff ff ff       	call   8010557a <argint>
80105629:	85 c0                	test   %eax,%eax
8010562b:	79 07                	jns    80105634 <argstr+0x23>
    return -1;
8010562d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105632:	eb 12                	jmp    80105646 <argstr+0x35>
  return fetchstr(addr, pp);
80105634:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105637:	8b 55 0c             	mov    0xc(%ebp),%edx
8010563a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010563e:	89 04 24             	mov    %eax,(%esp)
80105641:	e8 d0 fe ff ff       	call   80105516 <fetchstr>
}
80105646:	c9                   	leave  
80105647:	c3                   	ret    

80105648 <syscall>:

};

void
syscall(void)
{
80105648:	55                   	push   %ebp
80105649:	89 e5                	mov    %esp,%ebp
8010564b:	53                   	push   %ebx
8010564c:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
8010564f:	e8 5a ec ff ff       	call   801042ae <myproc>
80105654:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80105657:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010565a:	8b 40 18             	mov    0x18(%eax),%eax
8010565d:	8b 40 1c             	mov    0x1c(%eax),%eax
80105660:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105663:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105667:	7e 2d                	jle    80105696 <syscall+0x4e>
80105669:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010566c:	83 f8 17             	cmp    $0x17,%eax
8010566f:	77 25                	ja     80105696 <syscall+0x4e>
80105671:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105674:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010567b:	85 c0                	test   %eax,%eax
8010567d:	74 17                	je     80105696 <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
8010567f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105682:	8b 58 18             	mov    0x18(%eax),%ebx
80105685:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105688:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010568f:	ff d0                	call   *%eax
80105691:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105694:	eb 34                	jmp    801056ca <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105696:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105699:	8d 48 6c             	lea    0x6c(%eax),%ecx
    cprintf("%d %s: unknown sys call %d\n",
8010569c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010569f:	8b 40 10             	mov    0x10(%eax),%eax
801056a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
801056a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801056ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801056b1:	c7 04 24 14 89 10 80 	movl   $0x80108914,(%esp)
801056b8:	e8 0b ad ff ff       	call   801003c8 <cprintf>
    curproc->tf->eax = -1;
801056bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056c0:	8b 40 18             	mov    0x18(%eax),%eax
801056c3:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801056ca:	83 c4 24             	add    $0x24,%esp
801056cd:	5b                   	pop    %ebx
801056ce:	5d                   	pop    %ebp
801056cf:	c3                   	ret    

801056d0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801056d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801056dd:	8b 45 08             	mov    0x8(%ebp),%eax
801056e0:	89 04 24             	mov    %eax,(%esp)
801056e3:	e8 92 fe ff ff       	call   8010557a <argint>
801056e8:	85 c0                	test   %eax,%eax
801056ea:	79 07                	jns    801056f3 <argfd+0x23>
    return -1;
801056ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f1:	eb 4f                	jmp    80105742 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801056f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f6:	85 c0                	test   %eax,%eax
801056f8:	78 20                	js     8010571a <argfd+0x4a>
801056fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056fd:	83 f8 0f             	cmp    $0xf,%eax
80105700:	7f 18                	jg     8010571a <argfd+0x4a>
80105702:	e8 a7 eb ff ff       	call   801042ae <myproc>
80105707:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010570a:	83 c2 08             	add    $0x8,%edx
8010570d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105711:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105714:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105718:	75 07                	jne    80105721 <argfd+0x51>
    return -1;
8010571a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571f:	eb 21                	jmp    80105742 <argfd+0x72>
  if(pfd)
80105721:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105725:	74 08                	je     8010572f <argfd+0x5f>
    *pfd = fd;
80105727:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010572a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010572d:	89 10                	mov    %edx,(%eax)
  if(pf)
8010572f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105733:	74 08                	je     8010573d <argfd+0x6d>
    *pf = f;
80105735:	8b 45 10             	mov    0x10(%ebp),%eax
80105738:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010573b:	89 10                	mov    %edx,(%eax)
  return 0;
8010573d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105742:	c9                   	leave  
80105743:	c3                   	ret    

80105744 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105744:	55                   	push   %ebp
80105745:	89 e5                	mov    %esp,%ebp
80105747:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
8010574a:	e8 5f eb ff ff       	call   801042ae <myproc>
8010574f:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105752:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105759:	eb 2a                	jmp    80105785 <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
8010575b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010575e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105761:	83 c2 08             	add    $0x8,%edx
80105764:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105768:	85 c0                	test   %eax,%eax
8010576a:	75 15                	jne    80105781 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
8010576c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010576f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105772:	8d 4a 08             	lea    0x8(%edx),%ecx
80105775:	8b 55 08             	mov    0x8(%ebp),%edx
80105778:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010577c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010577f:	eb 0f                	jmp    80105790 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
80105781:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105785:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105789:	7e d0                	jle    8010575b <fdalloc+0x17>
    }
  }
  return -1;
8010578b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105790:	c9                   	leave  
80105791:	c3                   	ret    

80105792 <sys_dup>:

int
sys_dup(void)
{
80105792:	55                   	push   %ebp
80105793:	89 e5                	mov    %esp,%ebp
80105795:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105798:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010579b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010579f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801057a6:	00 
801057a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057ae:	e8 1d ff ff ff       	call   801056d0 <argfd>
801057b3:	85 c0                	test   %eax,%eax
801057b5:	79 07                	jns    801057be <sys_dup+0x2c>
    return -1;
801057b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057bc:	eb 29                	jmp    801057e7 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801057be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057c1:	89 04 24             	mov    %eax,(%esp)
801057c4:	e8 7b ff ff ff       	call   80105744 <fdalloc>
801057c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057d0:	79 07                	jns    801057d9 <sys_dup+0x47>
    return -1;
801057d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d7:	eb 0e                	jmp    801057e7 <sys_dup+0x55>
  filedup(f);
801057d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057dc:	89 04 24             	mov    %eax,(%esp)
801057df:	e8 01 b8 ff ff       	call   80100fe5 <filedup>
  return fd;
801057e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801057e7:	c9                   	leave  
801057e8:	c3                   	ret    

801057e9 <sys_read>:

int
sys_read(void)
{
801057e9:	55                   	push   %ebp
801057ea:	89 e5                	mov    %esp,%ebp
801057ec:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057f2:	89 44 24 08          	mov    %eax,0x8(%esp)
801057f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801057fd:	00 
801057fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105805:	e8 c6 fe ff ff       	call   801056d0 <argfd>
8010580a:	85 c0                	test   %eax,%eax
8010580c:	78 35                	js     80105843 <sys_read+0x5a>
8010580e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105811:	89 44 24 04          	mov    %eax,0x4(%esp)
80105815:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010581c:	e8 59 fd ff ff       	call   8010557a <argint>
80105821:	85 c0                	test   %eax,%eax
80105823:	78 1e                	js     80105843 <sys_read+0x5a>
80105825:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105828:	89 44 24 08          	mov    %eax,0x8(%esp)
8010582c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010582f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105833:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010583a:	e8 68 fd ff ff       	call   801055a7 <argptr>
8010583f:	85 c0                	test   %eax,%eax
80105841:	79 07                	jns    8010584a <sys_read+0x61>
    return -1;
80105843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105848:	eb 19                	jmp    80105863 <sys_read+0x7a>
  return fileread(f, p, n);
8010584a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010584d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105853:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105857:	89 54 24 04          	mov    %edx,0x4(%esp)
8010585b:	89 04 24             	mov    %eax,(%esp)
8010585e:	e8 ef b8 ff ff       	call   80101152 <fileread>
}
80105863:	c9                   	leave  
80105864:	c3                   	ret    

80105865 <sys_write>:

int
sys_write(void)
{
80105865:	55                   	push   %ebp
80105866:	89 e5                	mov    %esp,%ebp
80105868:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010586b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010586e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105872:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105879:	00 
8010587a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105881:	e8 4a fe ff ff       	call   801056d0 <argfd>
80105886:	85 c0                	test   %eax,%eax
80105888:	78 35                	js     801058bf <sys_write+0x5a>
8010588a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010588d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105891:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105898:	e8 dd fc ff ff       	call   8010557a <argint>
8010589d:	85 c0                	test   %eax,%eax
8010589f:	78 1e                	js     801058bf <sys_write+0x5a>
801058a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a4:	89 44 24 08          	mov    %eax,0x8(%esp)
801058a8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801058af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058b6:	e8 ec fc ff ff       	call   801055a7 <argptr>
801058bb:	85 c0                	test   %eax,%eax
801058bd:	79 07                	jns    801058c6 <sys_write+0x61>
    return -1;
801058bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c4:	eb 19                	jmp    801058df <sys_write+0x7a>
  return filewrite(f, p, n);
801058c6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801058c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801058cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801058d3:	89 54 24 04          	mov    %edx,0x4(%esp)
801058d7:	89 04 24             	mov    %eax,(%esp)
801058da:	e8 2f b9 ff ff       	call   8010120e <filewrite>
}
801058df:	c9                   	leave  
801058e0:	c3                   	ret    

801058e1 <sys_close>:

int
sys_close(void)
{
801058e1:	55                   	push   %ebp
801058e2:	89 e5                	mov    %esp,%ebp
801058e4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801058e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058ea:	89 44 24 08          	mov    %eax,0x8(%esp)
801058ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801058f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058fc:	e8 cf fd ff ff       	call   801056d0 <argfd>
80105901:	85 c0                	test   %eax,%eax
80105903:	79 07                	jns    8010590c <sys_close+0x2b>
    return -1;
80105905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010590a:	eb 23                	jmp    8010592f <sys_close+0x4e>
  myproc()->ofile[fd] = 0;
8010590c:	e8 9d e9 ff ff       	call   801042ae <myproc>
80105911:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105914:	83 c2 08             	add    $0x8,%edx
80105917:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010591e:	00 
  fileclose(f);
8010591f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105922:	89 04 24             	mov    %eax,(%esp)
80105925:	e8 03 b7 ff ff       	call   8010102d <fileclose>
  return 0;
8010592a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010592f:	c9                   	leave  
80105930:	c3                   	ret    

80105931 <sys_fstat>:

int
sys_fstat(void)
{
80105931:	55                   	push   %ebp
80105932:	89 e5                	mov    %esp,%ebp
80105934:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105937:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010593a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010593e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105945:	00 
80105946:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010594d:	e8 7e fd ff ff       	call   801056d0 <argfd>
80105952:	85 c0                	test   %eax,%eax
80105954:	78 1f                	js     80105975 <sys_fstat+0x44>
80105956:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010595d:	00 
8010595e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105961:	89 44 24 04          	mov    %eax,0x4(%esp)
80105965:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010596c:	e8 36 fc ff ff       	call   801055a7 <argptr>
80105971:	85 c0                	test   %eax,%eax
80105973:	79 07                	jns    8010597c <sys_fstat+0x4b>
    return -1;
80105975:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010597a:	eb 12                	jmp    8010598e <sys_fstat+0x5d>
  return filestat(f, st);
8010597c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010597f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105982:	89 54 24 04          	mov    %edx,0x4(%esp)
80105986:	89 04 24             	mov    %eax,(%esp)
80105989:	e8 75 b7 ff ff       	call   80101103 <filestat>
}
8010598e:	c9                   	leave  
8010598f:	c3                   	ret    

80105990 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105996:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105999:	89 44 24 04          	mov    %eax,0x4(%esp)
8010599d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059a4:	e8 68 fc ff ff       	call   80105611 <argstr>
801059a9:	85 c0                	test   %eax,%eax
801059ab:	78 17                	js     801059c4 <sys_link+0x34>
801059ad:	8d 45 dc             	lea    -0x24(%ebp),%eax
801059b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801059b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801059bb:	e8 51 fc ff ff       	call   80105611 <argstr>
801059c0:	85 c0                	test   %eax,%eax
801059c2:	79 0a                	jns    801059ce <sys_link+0x3e>
    return -1;
801059c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c9:	e9 42 01 00 00       	jmp    80105b10 <sys_link+0x180>

  begin_op();
801059ce:	e8 b4 da ff ff       	call   80103487 <begin_op>
  if((ip = namei(old)) == 0){
801059d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801059d6:	89 04 24             	mov    %eax,(%esp)
801059d9:	e8 b9 ca ff ff       	call   80102497 <namei>
801059de:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059e5:	75 0f                	jne    801059f6 <sys_link+0x66>
    end_op();
801059e7:	e8 1f db ff ff       	call   8010350b <end_op>
    return -1;
801059ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f1:	e9 1a 01 00 00       	jmp    80105b10 <sys_link+0x180>
  }

  ilock(ip);
801059f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f9:	89 04 24             	mov    %eax,(%esp)
801059fc:	e8 5c bf ff ff       	call   8010195d <ilock>
  if(ip->type == T_DIR){
80105a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a04:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105a08:	66 83 f8 01          	cmp    $0x1,%ax
80105a0c:	75 1a                	jne    80105a28 <sys_link+0x98>
    iunlockput(ip);
80105a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a11:	89 04 24             	mov    %eax,(%esp)
80105a14:	e8 46 c1 ff ff       	call   80101b5f <iunlockput>
    end_op();
80105a19:	e8 ed da ff ff       	call   8010350b <end_op>
    return -1;
80105a1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a23:	e9 e8 00 00 00       	jmp    80105b10 <sys_link+0x180>
  }

  ip->nlink++;
80105a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a2b:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105a2f:	8d 50 01             	lea    0x1(%eax),%edx
80105a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a35:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3c:	89 04 24             	mov    %eax,(%esp)
80105a3f:	e8 54 bd ff ff       	call   80101798 <iupdate>
  iunlock(ip);
80105a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a47:	89 04 24             	mov    %eax,(%esp)
80105a4a:	e8 1b c0 ff ff       	call   80101a6a <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105a4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a52:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105a55:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a59:	89 04 24             	mov    %eax,(%esp)
80105a5c:	e8 58 ca ff ff       	call   801024b9 <nameiparent>
80105a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a68:	75 02                	jne    80105a6c <sys_link+0xdc>
    goto bad;
80105a6a:	eb 68                	jmp    80105ad4 <sys_link+0x144>
  ilock(dp);
80105a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a6f:	89 04 24             	mov    %eax,(%esp)
80105a72:	e8 e6 be ff ff       	call   8010195d <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a7a:	8b 10                	mov    (%eax),%edx
80105a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a7f:	8b 00                	mov    (%eax),%eax
80105a81:	39 c2                	cmp    %eax,%edx
80105a83:	75 20                	jne    80105aa5 <sys_link+0x115>
80105a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a88:	8b 40 04             	mov    0x4(%eax),%eax
80105a8b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a8f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105a92:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a99:	89 04 24             	mov    %eax,(%esp)
80105a9c:	e8 37 c7 ff ff       	call   801021d8 <dirlink>
80105aa1:	85 c0                	test   %eax,%eax
80105aa3:	79 0d                	jns    80105ab2 <sys_link+0x122>
    iunlockput(dp);
80105aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa8:	89 04 24             	mov    %eax,(%esp)
80105aab:	e8 af c0 ff ff       	call   80101b5f <iunlockput>
    goto bad;
80105ab0:	eb 22                	jmp    80105ad4 <sys_link+0x144>
  }
  iunlockput(dp);
80105ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab5:	89 04 24             	mov    %eax,(%esp)
80105ab8:	e8 a2 c0 ff ff       	call   80101b5f <iunlockput>
  iput(ip);
80105abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac0:	89 04 24             	mov    %eax,(%esp)
80105ac3:	e8 e6 bf ff ff       	call   80101aae <iput>

  end_op();
80105ac8:	e8 3e da ff ff       	call   8010350b <end_op>

  return 0;
80105acd:	b8 00 00 00 00       	mov    $0x0,%eax
80105ad2:	eb 3c                	jmp    80105b10 <sys_link+0x180>

bad:
  ilock(ip);
80105ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad7:	89 04 24             	mov    %eax,(%esp)
80105ada:	e8 7e be ff ff       	call   8010195d <ilock>
  ip->nlink--;
80105adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae2:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105ae6:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aec:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af3:	89 04 24             	mov    %eax,(%esp)
80105af6:	e8 9d bc ff ff       	call   80101798 <iupdate>
  iunlockput(ip);
80105afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105afe:	89 04 24             	mov    %eax,(%esp)
80105b01:	e8 59 c0 ff ff       	call   80101b5f <iunlockput>
  end_op();
80105b06:	e8 00 da ff ff       	call   8010350b <end_op>
  return -1;
80105b0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b10:	c9                   	leave  
80105b11:	c3                   	ret    

80105b12 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105b12:	55                   	push   %ebp
80105b13:	89 e5                	mov    %esp,%ebp
80105b15:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b18:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105b1f:	eb 4b                	jmp    80105b6c <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b24:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105b2b:	00 
80105b2c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b30:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b33:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b37:	8b 45 08             	mov    0x8(%ebp),%eax
80105b3a:	89 04 24             	mov    %eax,(%esp)
80105b3d:	e8 b8 c2 ff ff       	call   80101dfa <readi>
80105b42:	83 f8 10             	cmp    $0x10,%eax
80105b45:	74 0c                	je     80105b53 <isdirempty+0x41>
      panic("isdirempty: readi");
80105b47:	c7 04 24 30 89 10 80 	movl   $0x80108930,(%esp)
80105b4e:	e8 0f aa ff ff       	call   80100562 <panic>
    if(de.inum != 0)
80105b53:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105b57:	66 85 c0             	test   %ax,%ax
80105b5a:	74 07                	je     80105b63 <isdirempty+0x51>
      return 0;
80105b5c:	b8 00 00 00 00       	mov    $0x0,%eax
80105b61:	eb 1b                	jmp    80105b7e <isdirempty+0x6c>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b66:	83 c0 10             	add    $0x10,%eax
80105b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b6f:	8b 45 08             	mov    0x8(%ebp),%eax
80105b72:	8b 40 58             	mov    0x58(%eax),%eax
80105b75:	39 c2                	cmp    %eax,%edx
80105b77:	72 a8                	jb     80105b21 <isdirempty+0xf>
  }
  return 1;
80105b79:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b7e:	c9                   	leave  
80105b7f:	c3                   	ret    

80105b80 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b86:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105b89:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b94:	e8 78 fa ff ff       	call   80105611 <argstr>
80105b99:	85 c0                	test   %eax,%eax
80105b9b:	79 0a                	jns    80105ba7 <sys_unlink+0x27>
    return -1;
80105b9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba2:	e9 af 01 00 00       	jmp    80105d56 <sys_unlink+0x1d6>

  begin_op();
80105ba7:	e8 db d8 ff ff       	call   80103487 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105bac:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105baf:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105bb2:	89 54 24 04          	mov    %edx,0x4(%esp)
80105bb6:	89 04 24             	mov    %eax,(%esp)
80105bb9:	e8 fb c8 ff ff       	call   801024b9 <nameiparent>
80105bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bc5:	75 0f                	jne    80105bd6 <sys_unlink+0x56>
    end_op();
80105bc7:	e8 3f d9 ff ff       	call   8010350b <end_op>
    return -1;
80105bcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd1:	e9 80 01 00 00       	jmp    80105d56 <sys_unlink+0x1d6>
  }

  ilock(dp);
80105bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd9:	89 04 24             	mov    %eax,(%esp)
80105bdc:	e8 7c bd ff ff       	call   8010195d <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105be1:	c7 44 24 04 42 89 10 	movl   $0x80108942,0x4(%esp)
80105be8:	80 
80105be9:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105bec:	89 04 24             	mov    %eax,(%esp)
80105bef:	e8 f9 c4 ff ff       	call   801020ed <namecmp>
80105bf4:	85 c0                	test   %eax,%eax
80105bf6:	0f 84 45 01 00 00    	je     80105d41 <sys_unlink+0x1c1>
80105bfc:	c7 44 24 04 44 89 10 	movl   $0x80108944,0x4(%esp)
80105c03:	80 
80105c04:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c07:	89 04 24             	mov    %eax,(%esp)
80105c0a:	e8 de c4 ff ff       	call   801020ed <namecmp>
80105c0f:	85 c0                	test   %eax,%eax
80105c11:	0f 84 2a 01 00 00    	je     80105d41 <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105c17:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105c1a:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c1e:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c21:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c28:	89 04 24             	mov    %eax,(%esp)
80105c2b:	e8 df c4 ff ff       	call   8010210f <dirlookup>
80105c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c37:	75 05                	jne    80105c3e <sys_unlink+0xbe>
    goto bad;
80105c39:	e9 03 01 00 00       	jmp    80105d41 <sys_unlink+0x1c1>
  ilock(ip);
80105c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c41:	89 04 24             	mov    %eax,(%esp)
80105c44:	e8 14 bd ff ff       	call   8010195d <ilock>

  if(ip->nlink < 1)
80105c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c4c:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105c50:	66 85 c0             	test   %ax,%ax
80105c53:	7f 0c                	jg     80105c61 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105c55:	c7 04 24 47 89 10 80 	movl   $0x80108947,(%esp)
80105c5c:	e8 01 a9 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c64:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105c68:	66 83 f8 01          	cmp    $0x1,%ax
80105c6c:	75 1f                	jne    80105c8d <sys_unlink+0x10d>
80105c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c71:	89 04 24             	mov    %eax,(%esp)
80105c74:	e8 99 fe ff ff       	call   80105b12 <isdirempty>
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	75 10                	jne    80105c8d <sys_unlink+0x10d>
    iunlockput(ip);
80105c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c80:	89 04 24             	mov    %eax,(%esp)
80105c83:	e8 d7 be ff ff       	call   80101b5f <iunlockput>
    goto bad;
80105c88:	e9 b4 00 00 00       	jmp    80105d41 <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80105c8d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105c94:	00 
80105c95:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c9c:	00 
80105c9d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ca0:	89 04 24             	mov    %eax,(%esp)
80105ca3:	e8 89 f5 ff ff       	call   80105231 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ca8:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105cab:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105cb2:	00 
80105cb3:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cb7:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105cba:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc1:	89 04 24             	mov    %eax,(%esp)
80105cc4:	e8 95 c2 ff ff       	call   80101f5e <writei>
80105cc9:	83 f8 10             	cmp    $0x10,%eax
80105ccc:	74 0c                	je     80105cda <sys_unlink+0x15a>
    panic("unlink: writei");
80105cce:	c7 04 24 59 89 10 80 	movl   $0x80108959,(%esp)
80105cd5:	e8 88 a8 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR){
80105cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cdd:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105ce1:	66 83 f8 01          	cmp    $0x1,%ax
80105ce5:	75 1c                	jne    80105d03 <sys_unlink+0x183>
    dp->nlink--;
80105ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cea:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105cee:	8d 50 ff             	lea    -0x1(%eax),%edx
80105cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf4:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfb:	89 04 24             	mov    %eax,(%esp)
80105cfe:	e8 95 ba ff ff       	call   80101798 <iupdate>
  }
  iunlockput(dp);
80105d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d06:	89 04 24             	mov    %eax,(%esp)
80105d09:	e8 51 be ff ff       	call   80101b5f <iunlockput>

  ip->nlink--;
80105d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d11:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105d15:	8d 50 ff             	lea    -0x1(%eax),%edx
80105d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d1b:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d22:	89 04 24             	mov    %eax,(%esp)
80105d25:	e8 6e ba ff ff       	call   80101798 <iupdate>
  iunlockput(ip);
80105d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d2d:	89 04 24             	mov    %eax,(%esp)
80105d30:	e8 2a be ff ff       	call   80101b5f <iunlockput>

  end_op();
80105d35:	e8 d1 d7 ff ff       	call   8010350b <end_op>

  return 0;
80105d3a:	b8 00 00 00 00       	mov    $0x0,%eax
80105d3f:	eb 15                	jmp    80105d56 <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
80105d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d44:	89 04 24             	mov    %eax,(%esp)
80105d47:	e8 13 be ff ff       	call   80101b5f <iunlockput>
  end_op();
80105d4c:	e8 ba d7 ff ff       	call   8010350b <end_op>
  return -1;
80105d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d56:	c9                   	leave  
80105d57:	c3                   	ret    

80105d58 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105d58:	55                   	push   %ebp
80105d59:	89 e5                	mov    %esp,%ebp
80105d5b:	83 ec 48             	sub    $0x48,%esp
80105d5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105d61:	8b 55 10             	mov    0x10(%ebp),%edx
80105d64:	8b 45 14             	mov    0x14(%ebp),%eax
80105d67:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105d6b:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105d6f:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d73:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d76:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d7a:	8b 45 08             	mov    0x8(%ebp),%eax
80105d7d:	89 04 24             	mov    %eax,(%esp)
80105d80:	e8 34 c7 ff ff       	call   801024b9 <nameiparent>
80105d85:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d8c:	75 0a                	jne    80105d98 <create+0x40>
    return 0;
80105d8e:	b8 00 00 00 00       	mov    $0x0,%eax
80105d93:	e9 7e 01 00 00       	jmp    80105f16 <create+0x1be>
  ilock(dp);
80105d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d9b:	89 04 24             	mov    %eax,(%esp)
80105d9e:	e8 ba bb ff ff       	call   8010195d <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105da3:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105da6:	89 44 24 08          	mov    %eax,0x8(%esp)
80105daa:	8d 45 de             	lea    -0x22(%ebp),%eax
80105dad:	89 44 24 04          	mov    %eax,0x4(%esp)
80105db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db4:	89 04 24             	mov    %eax,(%esp)
80105db7:	e8 53 c3 ff ff       	call   8010210f <dirlookup>
80105dbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105dbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105dc3:	74 47                	je     80105e0c <create+0xb4>
    iunlockput(dp);
80105dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc8:	89 04 24             	mov    %eax,(%esp)
80105dcb:	e8 8f bd ff ff       	call   80101b5f <iunlockput>
    ilock(ip);
80105dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd3:	89 04 24             	mov    %eax,(%esp)
80105dd6:	e8 82 bb ff ff       	call   8010195d <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105ddb:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105de0:	75 15                	jne    80105df7 <create+0x9f>
80105de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de5:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105de9:	66 83 f8 02          	cmp    $0x2,%ax
80105ded:	75 08                	jne    80105df7 <create+0x9f>
      return ip;
80105def:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105df2:	e9 1f 01 00 00       	jmp    80105f16 <create+0x1be>
    iunlockput(ip);
80105df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dfa:	89 04 24             	mov    %eax,(%esp)
80105dfd:	e8 5d bd ff ff       	call   80101b5f <iunlockput>
    return 0;
80105e02:	b8 00 00 00 00       	mov    $0x0,%eax
80105e07:	e9 0a 01 00 00       	jmp    80105f16 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105e0c:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e13:	8b 00                	mov    (%eax),%eax
80105e15:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e19:	89 04 24             	mov    %eax,(%esp)
80105e1c:	e8 a2 b8 ff ff       	call   801016c3 <ialloc>
80105e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e28:	75 0c                	jne    80105e36 <create+0xde>
    panic("create: ialloc");
80105e2a:	c7 04 24 68 89 10 80 	movl   $0x80108968,(%esp)
80105e31:	e8 2c a7 ff ff       	call   80100562 <panic>

  ilock(ip);
80105e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e39:	89 04 24             	mov    %eax,(%esp)
80105e3c:	e8 1c bb ff ff       	call   8010195d <ilock>
  ip->major = major;
80105e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e44:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105e48:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e4f:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105e53:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5a:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e63:	89 04 24             	mov    %eax,(%esp)
80105e66:	e8 2d b9 ff ff       	call   80101798 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105e6b:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e70:	75 6a                	jne    80105edc <create+0x184>
    dp->nlink++;  // for ".."
80105e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e75:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105e79:	8d 50 01             	lea    0x1(%eax),%edx
80105e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e7f:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e86:	89 04 24             	mov    %eax,(%esp)
80105e89:	e8 0a b9 ff ff       	call   80101798 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e91:	8b 40 04             	mov    0x4(%eax),%eax
80105e94:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e98:	c7 44 24 04 42 89 10 	movl   $0x80108942,0x4(%esp)
80105e9f:	80 
80105ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea3:	89 04 24             	mov    %eax,(%esp)
80105ea6:	e8 2d c3 ff ff       	call   801021d8 <dirlink>
80105eab:	85 c0                	test   %eax,%eax
80105ead:	78 21                	js     80105ed0 <create+0x178>
80105eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb2:	8b 40 04             	mov    0x4(%eax),%eax
80105eb5:	89 44 24 08          	mov    %eax,0x8(%esp)
80105eb9:	c7 44 24 04 44 89 10 	movl   $0x80108944,0x4(%esp)
80105ec0:	80 
80105ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ec4:	89 04 24             	mov    %eax,(%esp)
80105ec7:	e8 0c c3 ff ff       	call   801021d8 <dirlink>
80105ecc:	85 c0                	test   %eax,%eax
80105ece:	79 0c                	jns    80105edc <create+0x184>
      panic("create dots");
80105ed0:	c7 04 24 77 89 10 80 	movl   $0x80108977,(%esp)
80105ed7:	e8 86 a6 ff ff       	call   80100562 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105edf:	8b 40 04             	mov    0x4(%eax),%eax
80105ee2:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ee6:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef0:	89 04 24             	mov    %eax,(%esp)
80105ef3:	e8 e0 c2 ff ff       	call   801021d8 <dirlink>
80105ef8:	85 c0                	test   %eax,%eax
80105efa:	79 0c                	jns    80105f08 <create+0x1b0>
    panic("create: dirlink");
80105efc:	c7 04 24 83 89 10 80 	movl   $0x80108983,(%esp)
80105f03:	e8 5a a6 ff ff       	call   80100562 <panic>

  iunlockput(dp);
80105f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f0b:	89 04 24             	mov    %eax,(%esp)
80105f0e:	e8 4c bc ff ff       	call   80101b5f <iunlockput>

  return ip;
80105f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105f16:	c9                   	leave  
80105f17:	c3                   	ret    

80105f18 <sys_open>:

int
sys_open(void)
{
80105f18:	55                   	push   %ebp
80105f19:	89 e5                	mov    %esp,%ebp
80105f1b:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f1e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105f21:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f2c:	e8 e0 f6 ff ff       	call   80105611 <argstr>
80105f31:	85 c0                	test   %eax,%eax
80105f33:	78 17                	js     80105f4c <sys_open+0x34>
80105f35:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f38:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f43:	e8 32 f6 ff ff       	call   8010557a <argint>
80105f48:	85 c0                	test   %eax,%eax
80105f4a:	79 0a                	jns    80105f56 <sys_open+0x3e>
    return -1;
80105f4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f51:	e9 5c 01 00 00       	jmp    801060b2 <sys_open+0x19a>

  begin_op();
80105f56:	e8 2c d5 ff ff       	call   80103487 <begin_op>

  if(omode & O_CREATE){
80105f5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f5e:	25 00 02 00 00       	and    $0x200,%eax
80105f63:	85 c0                	test   %eax,%eax
80105f65:	74 3b                	je     80105fa2 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105f67:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f6a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105f71:	00 
80105f72:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105f79:	00 
80105f7a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105f81:	00 
80105f82:	89 04 24             	mov    %eax,(%esp)
80105f85:	e8 ce fd ff ff       	call   80105d58 <create>
80105f8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105f8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f91:	75 6b                	jne    80105ffe <sys_open+0xe6>
      end_op();
80105f93:	e8 73 d5 ff ff       	call   8010350b <end_op>
      return -1;
80105f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f9d:	e9 10 01 00 00       	jmp    801060b2 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
80105fa2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105fa5:	89 04 24             	mov    %eax,(%esp)
80105fa8:	e8 ea c4 ff ff       	call   80102497 <namei>
80105fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fb4:	75 0f                	jne    80105fc5 <sys_open+0xad>
      end_op();
80105fb6:	e8 50 d5 ff ff       	call   8010350b <end_op>
      return -1;
80105fbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc0:	e9 ed 00 00 00       	jmp    801060b2 <sys_open+0x19a>
    }
    ilock(ip);
80105fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc8:	89 04 24             	mov    %eax,(%esp)
80105fcb:	e8 8d b9 ff ff       	call   8010195d <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fd3:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105fd7:	66 83 f8 01          	cmp    $0x1,%ax
80105fdb:	75 21                	jne    80105ffe <sys_open+0xe6>
80105fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fe0:	85 c0                	test   %eax,%eax
80105fe2:	74 1a                	je     80105ffe <sys_open+0xe6>
      iunlockput(ip);
80105fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe7:	89 04 24             	mov    %eax,(%esp)
80105fea:	e8 70 bb ff ff       	call   80101b5f <iunlockput>
      end_op();
80105fef:	e8 17 d5 ff ff       	call   8010350b <end_op>
      return -1;
80105ff4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ff9:	e9 b4 00 00 00       	jmp    801060b2 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105ffe:	e8 82 af ff ff       	call   80100f85 <filealloc>
80106003:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106006:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010600a:	74 14                	je     80106020 <sys_open+0x108>
8010600c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010600f:	89 04 24             	mov    %eax,(%esp)
80106012:	e8 2d f7 ff ff       	call   80105744 <fdalloc>
80106017:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010601a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010601e:	79 28                	jns    80106048 <sys_open+0x130>
    if(f)
80106020:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106024:	74 0b                	je     80106031 <sys_open+0x119>
      fileclose(f);
80106026:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106029:	89 04 24             	mov    %eax,(%esp)
8010602c:	e8 fc af ff ff       	call   8010102d <fileclose>
    iunlockput(ip);
80106031:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106034:	89 04 24             	mov    %eax,(%esp)
80106037:	e8 23 bb ff ff       	call   80101b5f <iunlockput>
    end_op();
8010603c:	e8 ca d4 ff ff       	call   8010350b <end_op>
    return -1;
80106041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106046:	eb 6a                	jmp    801060b2 <sys_open+0x19a>
  }
  iunlock(ip);
80106048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010604b:	89 04 24             	mov    %eax,(%esp)
8010604e:	e8 17 ba ff ff       	call   80101a6a <iunlock>
  end_op();
80106053:	e8 b3 d4 ff ff       	call   8010350b <end_op>

  f->type = FD_INODE;
80106058:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010605b:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106061:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106064:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106067:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010606a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010606d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106074:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106077:	83 e0 01             	and    $0x1,%eax
8010607a:	85 c0                	test   %eax,%eax
8010607c:	0f 94 c0             	sete   %al
8010607f:	89 c2                	mov    %eax,%edx
80106081:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106084:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010608a:	83 e0 01             	and    $0x1,%eax
8010608d:	85 c0                	test   %eax,%eax
8010608f:	75 0a                	jne    8010609b <sys_open+0x183>
80106091:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106094:	83 e0 02             	and    $0x2,%eax
80106097:	85 c0                	test   %eax,%eax
80106099:	74 07                	je     801060a2 <sys_open+0x18a>
8010609b:	b8 01 00 00 00       	mov    $0x1,%eax
801060a0:	eb 05                	jmp    801060a7 <sys_open+0x18f>
801060a2:	b8 00 00 00 00       	mov    $0x0,%eax
801060a7:	89 c2                	mov    %eax,%edx
801060a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ac:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801060af:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801060b2:	c9                   	leave  
801060b3:	c3                   	ret    

801060b4 <sys_mkdir>:

int
sys_mkdir(void)
{
801060b4:	55                   	push   %ebp
801060b5:	89 e5                	mov    %esp,%ebp
801060b7:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801060ba:	e8 c8 d3 ff ff       	call   80103487 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801060bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801060c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060cd:	e8 3f f5 ff ff       	call   80105611 <argstr>
801060d2:	85 c0                	test   %eax,%eax
801060d4:	78 2c                	js     80106102 <sys_mkdir+0x4e>
801060d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060d9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801060e0:	00 
801060e1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801060e8:	00 
801060e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801060f0:	00 
801060f1:	89 04 24             	mov    %eax,(%esp)
801060f4:	e8 5f fc ff ff       	call   80105d58 <create>
801060f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106100:	75 0c                	jne    8010610e <sys_mkdir+0x5a>
    end_op();
80106102:	e8 04 d4 ff ff       	call   8010350b <end_op>
    return -1;
80106107:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010610c:	eb 15                	jmp    80106123 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
8010610e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106111:	89 04 24             	mov    %eax,(%esp)
80106114:	e8 46 ba ff ff       	call   80101b5f <iunlockput>
  end_op();
80106119:	e8 ed d3 ff ff       	call   8010350b <end_op>
  return 0;
8010611e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106123:	c9                   	leave  
80106124:	c3                   	ret    

80106125 <sys_mknod>:

int
sys_mknod(void)
{
80106125:	55                   	push   %ebp
80106126:	89 e5                	mov    %esp,%ebp
80106128:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010612b:	e8 57 d3 ff ff       	call   80103487 <begin_op>
  if((argstr(0, &path)) < 0 ||
80106130:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106133:	89 44 24 04          	mov    %eax,0x4(%esp)
80106137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010613e:	e8 ce f4 ff ff       	call   80105611 <argstr>
80106143:	85 c0                	test   %eax,%eax
80106145:	78 5e                	js     801061a5 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106147:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010614a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010614e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106155:	e8 20 f4 ff ff       	call   8010557a <argint>
  if((argstr(0, &path)) < 0 ||
8010615a:	85 c0                	test   %eax,%eax
8010615c:	78 47                	js     801061a5 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010615e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106161:	89 44 24 04          	mov    %eax,0x4(%esp)
80106165:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010616c:	e8 09 f4 ff ff       	call   8010557a <argint>
     argint(1, &major) < 0 ||
80106171:	85 c0                	test   %eax,%eax
80106173:	78 30                	js     801061a5 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106175:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106178:	0f bf c8             	movswl %ax,%ecx
8010617b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010617e:	0f bf d0             	movswl %ax,%edx
80106181:	8b 45 f0             	mov    -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80106184:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106188:	89 54 24 08          	mov    %edx,0x8(%esp)
8010618c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106193:	00 
80106194:	89 04 24             	mov    %eax,(%esp)
80106197:	e8 bc fb ff ff       	call   80105d58 <create>
8010619c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010619f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061a3:	75 0c                	jne    801061b1 <sys_mknod+0x8c>
    end_op();
801061a5:	e8 61 d3 ff ff       	call   8010350b <end_op>
    return -1;
801061aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061af:	eb 15                	jmp    801061c6 <sys_mknod+0xa1>
  }
  iunlockput(ip);
801061b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b4:	89 04 24             	mov    %eax,(%esp)
801061b7:	e8 a3 b9 ff ff       	call   80101b5f <iunlockput>
  end_op();
801061bc:	e8 4a d3 ff ff       	call   8010350b <end_op>
  return 0;
801061c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061c6:	c9                   	leave  
801061c7:	c3                   	ret    

801061c8 <sys_chdir>:

int
sys_chdir(void)
{
801061c8:	55                   	push   %ebp
801061c9:	89 e5                	mov    %esp,%ebp
801061cb:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801061ce:	e8 db e0 ff ff       	call   801042ae <myproc>
801061d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
801061d6:	e8 ac d2 ff ff       	call   80103487 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801061db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061de:	89 44 24 04          	mov    %eax,0x4(%esp)
801061e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061e9:	e8 23 f4 ff ff       	call   80105611 <argstr>
801061ee:	85 c0                	test   %eax,%eax
801061f0:	78 14                	js     80106206 <sys_chdir+0x3e>
801061f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801061f5:	89 04 24             	mov    %eax,(%esp)
801061f8:	e8 9a c2 ff ff       	call   80102497 <namei>
801061fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106200:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106204:	75 0c                	jne    80106212 <sys_chdir+0x4a>
    end_op();
80106206:	e8 00 d3 ff ff       	call   8010350b <end_op>
    return -1;
8010620b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106210:	eb 5b                	jmp    8010626d <sys_chdir+0xa5>
  }
  ilock(ip);
80106212:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106215:	89 04 24             	mov    %eax,(%esp)
80106218:	e8 40 b7 ff ff       	call   8010195d <ilock>
  if(ip->type != T_DIR){
8010621d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106220:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106224:	66 83 f8 01          	cmp    $0x1,%ax
80106228:	74 17                	je     80106241 <sys_chdir+0x79>
    iunlockput(ip);
8010622a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010622d:	89 04 24             	mov    %eax,(%esp)
80106230:	e8 2a b9 ff ff       	call   80101b5f <iunlockput>
    end_op();
80106235:	e8 d1 d2 ff ff       	call   8010350b <end_op>
    return -1;
8010623a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010623f:	eb 2c                	jmp    8010626d <sys_chdir+0xa5>
  }
  iunlock(ip);
80106241:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106244:	89 04 24             	mov    %eax,(%esp)
80106247:	e8 1e b8 ff ff       	call   80101a6a <iunlock>
  iput(curproc->cwd);
8010624c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010624f:	8b 40 68             	mov    0x68(%eax),%eax
80106252:	89 04 24             	mov    %eax,(%esp)
80106255:	e8 54 b8 ff ff       	call   80101aae <iput>
  end_op();
8010625a:	e8 ac d2 ff ff       	call   8010350b <end_op>
  curproc->cwd = ip;
8010625f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106262:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106265:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106268:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010626d:	c9                   	leave  
8010626e:	c3                   	ret    

8010626f <sys_exec>:

int
sys_exec(void)
{
8010626f:	55                   	push   %ebp
80106270:	89 e5                	mov    %esp,%ebp
80106272:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106278:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010627b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010627f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106286:	e8 86 f3 ff ff       	call   80105611 <argstr>
8010628b:	85 c0                	test   %eax,%eax
8010628d:	78 1a                	js     801062a9 <sys_exec+0x3a>
8010628f:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106295:	89 44 24 04          	mov    %eax,0x4(%esp)
80106299:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801062a0:	e8 d5 f2 ff ff       	call   8010557a <argint>
801062a5:	85 c0                	test   %eax,%eax
801062a7:	79 0a                	jns    801062b3 <sys_exec+0x44>
    return -1;
801062a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ae:	e9 c8 00 00 00       	jmp    8010637b <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
801062b3:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801062ba:	00 
801062bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801062c2:	00 
801062c3:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801062c9:	89 04 24             	mov    %eax,(%esp)
801062cc:	e8 60 ef ff ff       	call   80105231 <memset>
  for(i=0;; i++){
801062d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801062d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062db:	83 f8 1f             	cmp    $0x1f,%eax
801062de:	76 0a                	jbe    801062ea <sys_exec+0x7b>
      return -1;
801062e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e5:	e9 91 00 00 00       	jmp    8010637b <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801062ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ed:	c1 e0 02             	shl    $0x2,%eax
801062f0:	89 c2                	mov    %eax,%edx
801062f2:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801062f8:	01 c2                	add    %eax,%edx
801062fa:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106300:	89 44 24 04          	mov    %eax,0x4(%esp)
80106304:	89 14 24             	mov    %edx,(%esp)
80106307:	e8 cb f1 ff ff       	call   801054d7 <fetchint>
8010630c:	85 c0                	test   %eax,%eax
8010630e:	79 07                	jns    80106317 <sys_exec+0xa8>
      return -1;
80106310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106315:	eb 64                	jmp    8010637b <sys_exec+0x10c>
    if(uarg == 0){
80106317:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010631d:	85 c0                	test   %eax,%eax
8010631f:	75 26                	jne    80106347 <sys_exec+0xd8>
      argv[i] = 0;
80106321:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106324:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010632b:	00 00 00 00 
      break;
8010632f:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106330:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106333:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106339:	89 54 24 04          	mov    %edx,0x4(%esp)
8010633d:	89 04 24             	mov    %eax,(%esp)
80106340:	e8 d9 a7 ff ff       	call   80100b1e <exec>
80106345:	eb 34                	jmp    8010637b <sys_exec+0x10c>
    if(fetchstr(uarg, &argv[i]) < 0)
80106347:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010634d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106350:	c1 e2 02             	shl    $0x2,%edx
80106353:	01 c2                	add    %eax,%edx
80106355:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010635b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010635f:	89 04 24             	mov    %eax,(%esp)
80106362:	e8 af f1 ff ff       	call   80105516 <fetchstr>
80106367:	85 c0                	test   %eax,%eax
80106369:	79 07                	jns    80106372 <sys_exec+0x103>
      return -1;
8010636b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106370:	eb 09                	jmp    8010637b <sys_exec+0x10c>
  for(i=0;; i++){
80106372:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }
80106376:	e9 5d ff ff ff       	jmp    801062d8 <sys_exec+0x69>
}
8010637b:	c9                   	leave  
8010637c:	c3                   	ret    

8010637d <sys_pipe>:

int
sys_pipe(void)
{
8010637d:	55                   	push   %ebp
8010637e:	89 e5                	mov    %esp,%ebp
80106380:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106383:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
8010638a:	00 
8010638b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010638e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106392:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106399:	e8 09 f2 ff ff       	call   801055a7 <argptr>
8010639e:	85 c0                	test   %eax,%eax
801063a0:	79 0a                	jns    801063ac <sys_pipe+0x2f>
    return -1;
801063a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a7:	e9 9a 00 00 00       	jmp    80106446 <sys_pipe+0xc9>
  if(pipealloc(&rf, &wf) < 0)
801063ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801063af:	89 44 24 04          	mov    %eax,0x4(%esp)
801063b3:	8d 45 e8             	lea    -0x18(%ebp),%eax
801063b6:	89 04 24             	mov    %eax,(%esp)
801063b9:	e8 27 d9 ff ff       	call   80103ce5 <pipealloc>
801063be:	85 c0                	test   %eax,%eax
801063c0:	79 07                	jns    801063c9 <sys_pipe+0x4c>
    return -1;
801063c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063c7:	eb 7d                	jmp    80106446 <sys_pipe+0xc9>
  fd0 = -1;
801063c9:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801063d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063d3:	89 04 24             	mov    %eax,(%esp)
801063d6:	e8 69 f3 ff ff       	call   80105744 <fdalloc>
801063db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063e2:	78 14                	js     801063f8 <sys_pipe+0x7b>
801063e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063e7:	89 04 24             	mov    %eax,(%esp)
801063ea:	e8 55 f3 ff ff       	call   80105744 <fdalloc>
801063ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063f6:	79 36                	jns    8010642e <sys_pipe+0xb1>
    if(fd0 >= 0)
801063f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063fc:	78 13                	js     80106411 <sys_pipe+0x94>
      myproc()->ofile[fd0] = 0;
801063fe:	e8 ab de ff ff       	call   801042ae <myproc>
80106403:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106406:	83 c2 08             	add    $0x8,%edx
80106409:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106410:	00 
    fileclose(rf);
80106411:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106414:	89 04 24             	mov    %eax,(%esp)
80106417:	e8 11 ac ff ff       	call   8010102d <fileclose>
    fileclose(wf);
8010641c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010641f:	89 04 24             	mov    %eax,(%esp)
80106422:	e8 06 ac ff ff       	call   8010102d <fileclose>
    return -1;
80106427:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010642c:	eb 18                	jmp    80106446 <sys_pipe+0xc9>
  }
  fd[0] = fd0;
8010642e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106431:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106434:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106436:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106439:	8d 50 04             	lea    0x4(%eax),%edx
8010643c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010643f:	89 02                	mov    %eax,(%edx)
  return 0;
80106441:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106446:	c9                   	leave  
80106447:	c3                   	ret    

80106448 <sys_getpinfo>:
  struct proc proc[NPROC];
} ptable;



int sys_getpinfo(void) {
80106448:	55                   	push   %ebp
80106449:	89 e5                	mov    %esp,%ebp
8010644b:	83 ec 28             	sub    $0x28,%esp
    pstatTable *pstat;
    
    
    if (argptr(0, (void*)&pstat, sizeof(pstatTable)) < 0)
8010644e:	c7 44 24 08 00 09 00 	movl   $0x900,0x8(%esp)
80106455:	00 
80106456:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106459:	89 44 24 04          	mov    %eax,0x4(%esp)
8010645d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106464:	e8 3e f1 ff ff       	call   801055a7 <argptr>
80106469:	85 c0                	test   %eax,%eax
8010646b:	79 07                	jns    80106474 <sys_getpinfo+0x2c>
        return -1;
8010646d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106472:	eb 10                	jmp    80106484 <sys_getpinfo+0x3c>
    
    fillpstat(pstat);
80106474:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106477:	89 04 24             	mov    %eax,(%esp)
8010647a:	e8 53 dc ff ff       	call   801040d2 <fillpstat>
    
    return 0;  
8010647f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106484:	c9                   	leave  
80106485:	c3                   	ret    

80106486 <sys_settickets>:

int
sys_settickets(void)
{
80106486:	55                   	push   %ebp
80106487:	89 e5                	mov    %esp,%ebp
80106489:	83 ec 28             	sub    $0x28,%esp
  int n;

  
  if(argint(0, &n) < 0)
8010648c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010648f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106493:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010649a:	e8 db f0 ff ff       	call   8010557a <argint>
8010649f:	85 c0                	test   %eax,%eax
801064a1:	79 07                	jns    801064aa <sys_settickets+0x24>
    return -1;
801064a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064a8:	eb 32                	jmp    801064dc <sys_settickets+0x56>

  if(n < 10)
801064aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064ad:	83 f8 09             	cmp    $0x9,%eax
801064b0:	7f 07                	jg     801064b9 <sys_settickets+0x33>
    return -1;
801064b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064b7:	eb 23                	jmp    801064dc <sys_settickets+0x56>

  struct proc *curproc = myproc();
801064b9:	e8 f0 dd ff ff       	call   801042ae <myproc>
801064be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(curproc == 0)
801064c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064c5:	75 07                	jne    801064ce <sys_settickets+0x48>
    return -1;
801064c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064cc:	eb 0e                	jmp    801064dc <sys_settickets+0x56>

  
  curproc->tickets = n;
801064ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
801064d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d4:	89 50 7c             	mov    %edx,0x7c(%eax)
  return 0;
801064d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064dc:	c9                   	leave  
801064dd:	c3                   	ret    

801064de <sys_fork>:



int
sys_fork(void)
{
801064de:	55                   	push   %ebp
801064df:	89 e5                	mov    %esp,%ebp
801064e1:	83 ec 08             	sub    $0x8,%esp
  return fork();
801064e4:	e8 e7 e0 ff ff       	call   801045d0 <fork>
}
801064e9:	c9                   	leave  
801064ea:	c3                   	ret    

801064eb <sys_exit>:

int
sys_exit(void)
{
801064eb:	55                   	push   %ebp
801064ec:	89 e5                	mov    %esp,%ebp
801064ee:	83 ec 08             	sub    $0x8,%esp
  exit();
801064f1:	e8 5a e2 ff ff       	call   80104750 <exit>
  return 0;  // not reached
801064f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064fb:	c9                   	leave  
801064fc:	c3                   	ret    

801064fd <sys_wait>:

int
sys_wait(void)
{
801064fd:	55                   	push   %ebp
801064fe:	89 e5                	mov    %esp,%ebp
80106500:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106503:	e8 55 e3 ff ff       	call   8010485d <wait>
}
80106508:	c9                   	leave  
80106509:	c3                   	ret    

8010650a <sys_kill>:

int
sys_kill(void)
{
8010650a:	55                   	push   %ebp
8010650b:	89 e5                	mov    %esp,%ebp
8010650d:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106510:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106513:	89 44 24 04          	mov    %eax,0x4(%esp)
80106517:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010651e:	e8 57 f0 ff ff       	call   8010557a <argint>
80106523:	85 c0                	test   %eax,%eax
80106525:	79 07                	jns    8010652e <sys_kill+0x24>
    return -1;
80106527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010652c:	eb 0b                	jmp    80106539 <sys_kill+0x2f>
  return kill(pid);
8010652e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106531:	89 04 24             	mov    %eax,(%esp)
80106534:	e8 8d e7 ff ff       	call   80104cc6 <kill>
}
80106539:	c9                   	leave  
8010653a:	c3                   	ret    

8010653b <sys_getpid>:

int
sys_getpid(void)
{
8010653b:	55                   	push   %ebp
8010653c:	89 e5                	mov    %esp,%ebp
8010653e:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106541:	e8 68 dd ff ff       	call   801042ae <myproc>
80106546:	8b 40 10             	mov    0x10(%eax),%eax
}
80106549:	c9                   	leave  
8010654a:	c3                   	ret    

8010654b <sys_sbrk>:

int
sys_sbrk(void)
{
8010654b:	55                   	push   %ebp
8010654c:	89 e5                	mov    %esp,%ebp
8010654e:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106551:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106554:	89 44 24 04          	mov    %eax,0x4(%esp)
80106558:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010655f:	e8 16 f0 ff ff       	call   8010557a <argint>
80106564:	85 c0                	test   %eax,%eax
80106566:	79 07                	jns    8010656f <sys_sbrk+0x24>
    return -1;
80106568:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010656d:	eb 23                	jmp    80106592 <sys_sbrk+0x47>
  addr = myproc()->sz;
8010656f:	e8 3a dd ff ff       	call   801042ae <myproc>
80106574:	8b 00                	mov    (%eax),%eax
80106576:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106579:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010657c:	89 04 24             	mov    %eax,(%esp)
8010657f:	e8 ae df ff ff       	call   80104532 <growproc>
80106584:	85 c0                	test   %eax,%eax
80106586:	79 07                	jns    8010658f <sys_sbrk+0x44>
    return -1;
80106588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010658d:	eb 03                	jmp    80106592 <sys_sbrk+0x47>
  return addr;
8010658f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106592:	c9                   	leave  
80106593:	c3                   	ret    

80106594 <sys_sleep>:

int
sys_sleep(void)
{
80106594:	55                   	push   %ebp
80106595:	89 e5                	mov    %esp,%ebp
80106597:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010659a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010659d:	89 44 24 04          	mov    %eax,0x4(%esp)
801065a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065a8:	e8 cd ef ff ff       	call   8010557a <argint>
801065ad:	85 c0                	test   %eax,%eax
801065af:	79 07                	jns    801065b8 <sys_sleep+0x24>
    return -1;
801065b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065b6:	eb 6b                	jmp    80106623 <sys_sleep+0x8f>
  acquire(&tickslock);
801065b8:	c7 04 24 00 5f 11 80 	movl   $0x80115f00,(%esp)
801065bf:	e8 fb e9 ff ff       	call   80104fbf <acquire>
  ticks0 = ticks;
801065c4:	a1 40 67 11 80       	mov    0x80116740,%eax
801065c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801065cc:	eb 33                	jmp    80106601 <sys_sleep+0x6d>
    if(myproc()->killed){
801065ce:	e8 db dc ff ff       	call   801042ae <myproc>
801065d3:	8b 40 24             	mov    0x24(%eax),%eax
801065d6:	85 c0                	test   %eax,%eax
801065d8:	74 13                	je     801065ed <sys_sleep+0x59>
      release(&tickslock);
801065da:	c7 04 24 00 5f 11 80 	movl   $0x80115f00,(%esp)
801065e1:	e8 41 ea ff ff       	call   80105027 <release>
      return -1;
801065e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065eb:	eb 36                	jmp    80106623 <sys_sleep+0x8f>
    }
    sleep(&ticks, &tickslock);
801065ed:	c7 44 24 04 00 5f 11 	movl   $0x80115f00,0x4(%esp)
801065f4:	80 
801065f5:	c7 04 24 40 67 11 80 	movl   $0x80116740,(%esp)
801065fc:	e8 c3 e5 ff ff       	call   80104bc4 <sleep>
  while(ticks - ticks0 < n){
80106601:	a1 40 67 11 80       	mov    0x80116740,%eax
80106606:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106609:	89 c2                	mov    %eax,%edx
8010660b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010660e:	39 c2                	cmp    %eax,%edx
80106610:	72 bc                	jb     801065ce <sys_sleep+0x3a>
  }
  release(&tickslock);
80106612:	c7 04 24 00 5f 11 80 	movl   $0x80115f00,(%esp)
80106619:	e8 09 ea ff ff       	call   80105027 <release>
  return 0;
8010661e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106623:	c9                   	leave  
80106624:	c3                   	ret    

80106625 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106625:	55                   	push   %ebp
80106626:	89 e5                	mov    %esp,%ebp
80106628:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
8010662b:	c7 04 24 00 5f 11 80 	movl   $0x80115f00,(%esp)
80106632:	e8 88 e9 ff ff       	call   80104fbf <acquire>
  xticks = ticks;
80106637:	a1 40 67 11 80       	mov    0x80116740,%eax
8010663c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010663f:	c7 04 24 00 5f 11 80 	movl   $0x80115f00,(%esp)
80106646:	e8 dc e9 ff ff       	call   80105027 <release>
  return xticks;
8010664b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010664e:	c9                   	leave  
8010664f:	c3                   	ret    

80106650 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106650:	1e                   	push   %ds
  pushl %es
80106651:	06                   	push   %es
  pushl %fs
80106652:	0f a0                	push   %fs
  pushl %gs
80106654:	0f a8                	push   %gs
  pushal
80106656:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106657:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010665b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010665d:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010665f:	54                   	push   %esp
  call trap
80106660:	e8 d8 01 00 00       	call   8010683d <trap>
  addl $4, %esp
80106665:	83 c4 04             	add    $0x4,%esp

80106668 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106668:	61                   	popa   
  popl %gs
80106669:	0f a9                	pop    %gs
  popl %fs
8010666b:	0f a1                	pop    %fs
  popl %es
8010666d:	07                   	pop    %es
  popl %ds
8010666e:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010666f:	83 c4 08             	add    $0x8,%esp
  iret
80106672:	cf                   	iret   

80106673 <lidt>:
{
80106673:	55                   	push   %ebp
80106674:	89 e5                	mov    %esp,%ebp
80106676:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106679:	8b 45 0c             	mov    0xc(%ebp),%eax
8010667c:	83 e8 01             	sub    $0x1,%eax
8010667f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106683:	8b 45 08             	mov    0x8(%ebp),%eax
80106686:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010668a:	8b 45 08             	mov    0x8(%ebp),%eax
8010668d:	c1 e8 10             	shr    $0x10,%eax
80106690:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106694:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106697:	0f 01 18             	lidtl  (%eax)
}
8010669a:	c9                   	leave  
8010669b:	c3                   	ret    

8010669c <rcr2>:

static inline uint
rcr2(void)
{
8010669c:	55                   	push   %ebp
8010669d:	89 e5                	mov    %esp,%ebp
8010669f:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801066a2:	0f 20 d0             	mov    %cr2,%eax
801066a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801066a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801066ab:	c9                   	leave  
801066ac:	c3                   	ret    

801066ad <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801066ad:	55                   	push   %ebp
801066ae:	89 e5                	mov    %esp,%ebp
801066b0:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801066b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801066ba:	e9 c3 00 00 00       	jmp    80106782 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801066bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c2:	8b 04 85 a0 b0 10 80 	mov    -0x7fef4f60(,%eax,4),%eax
801066c9:	89 c2                	mov    %eax,%edx
801066cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066ce:	66 89 14 c5 40 5f 11 	mov    %dx,-0x7feea0c0(,%eax,8)
801066d5:	80 
801066d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066d9:	66 c7 04 c5 42 5f 11 	movw   $0x8,-0x7feea0be(,%eax,8)
801066e0:	80 08 00 
801066e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066e6:	0f b6 14 c5 44 5f 11 	movzbl -0x7feea0bc(,%eax,8),%edx
801066ed:	80 
801066ee:	83 e2 e0             	and    $0xffffffe0,%edx
801066f1:	88 14 c5 44 5f 11 80 	mov    %dl,-0x7feea0bc(,%eax,8)
801066f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066fb:	0f b6 14 c5 44 5f 11 	movzbl -0x7feea0bc(,%eax,8),%edx
80106702:	80 
80106703:	83 e2 1f             	and    $0x1f,%edx
80106706:	88 14 c5 44 5f 11 80 	mov    %dl,-0x7feea0bc(,%eax,8)
8010670d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106710:	0f b6 14 c5 45 5f 11 	movzbl -0x7feea0bb(,%eax,8),%edx
80106717:	80 
80106718:	83 e2 f0             	and    $0xfffffff0,%edx
8010671b:	83 ca 0e             	or     $0xe,%edx
8010671e:	88 14 c5 45 5f 11 80 	mov    %dl,-0x7feea0bb(,%eax,8)
80106725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106728:	0f b6 14 c5 45 5f 11 	movzbl -0x7feea0bb(,%eax,8),%edx
8010672f:	80 
80106730:	83 e2 ef             	and    $0xffffffef,%edx
80106733:	88 14 c5 45 5f 11 80 	mov    %dl,-0x7feea0bb(,%eax,8)
8010673a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010673d:	0f b6 14 c5 45 5f 11 	movzbl -0x7feea0bb(,%eax,8),%edx
80106744:	80 
80106745:	83 e2 9f             	and    $0xffffff9f,%edx
80106748:	88 14 c5 45 5f 11 80 	mov    %dl,-0x7feea0bb(,%eax,8)
8010674f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106752:	0f b6 14 c5 45 5f 11 	movzbl -0x7feea0bb(,%eax,8),%edx
80106759:	80 
8010675a:	83 ca 80             	or     $0xffffff80,%edx
8010675d:	88 14 c5 45 5f 11 80 	mov    %dl,-0x7feea0bb(,%eax,8)
80106764:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106767:	8b 04 85 a0 b0 10 80 	mov    -0x7fef4f60(,%eax,4),%eax
8010676e:	c1 e8 10             	shr    $0x10,%eax
80106771:	89 c2                	mov    %eax,%edx
80106773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106776:	66 89 14 c5 46 5f 11 	mov    %dx,-0x7feea0ba(,%eax,8)
8010677d:	80 
  for(i = 0; i < 256; i++)
8010677e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106782:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106789:	0f 8e 30 ff ff ff    	jle    801066bf <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010678f:	a1 a0 b1 10 80       	mov    0x8010b1a0,%eax
80106794:	66 a3 40 61 11 80    	mov    %ax,0x80116140
8010679a:	66 c7 05 42 61 11 80 	movw   $0x8,0x80116142
801067a1:	08 00 
801067a3:	0f b6 05 44 61 11 80 	movzbl 0x80116144,%eax
801067aa:	83 e0 e0             	and    $0xffffffe0,%eax
801067ad:	a2 44 61 11 80       	mov    %al,0x80116144
801067b2:	0f b6 05 44 61 11 80 	movzbl 0x80116144,%eax
801067b9:	83 e0 1f             	and    $0x1f,%eax
801067bc:	a2 44 61 11 80       	mov    %al,0x80116144
801067c1:	0f b6 05 45 61 11 80 	movzbl 0x80116145,%eax
801067c8:	83 c8 0f             	or     $0xf,%eax
801067cb:	a2 45 61 11 80       	mov    %al,0x80116145
801067d0:	0f b6 05 45 61 11 80 	movzbl 0x80116145,%eax
801067d7:	83 e0 ef             	and    $0xffffffef,%eax
801067da:	a2 45 61 11 80       	mov    %al,0x80116145
801067df:	0f b6 05 45 61 11 80 	movzbl 0x80116145,%eax
801067e6:	83 c8 60             	or     $0x60,%eax
801067e9:	a2 45 61 11 80       	mov    %al,0x80116145
801067ee:	0f b6 05 45 61 11 80 	movzbl 0x80116145,%eax
801067f5:	83 c8 80             	or     $0xffffff80,%eax
801067f8:	a2 45 61 11 80       	mov    %al,0x80116145
801067fd:	a1 a0 b1 10 80       	mov    0x8010b1a0,%eax
80106802:	c1 e8 10             	shr    $0x10,%eax
80106805:	66 a3 46 61 11 80    	mov    %ax,0x80116146

  initlock(&tickslock, "time");
8010680b:	c7 44 24 04 94 89 10 	movl   $0x80108994,0x4(%esp)
80106812:	80 
80106813:	c7 04 24 00 5f 11 80 	movl   $0x80115f00,(%esp)
8010681a:	e8 7f e7 ff ff       	call   80104f9e <initlock>
}
8010681f:	c9                   	leave  
80106820:	c3                   	ret    

80106821 <idtinit>:

void
idtinit(void)
{
80106821:	55                   	push   %ebp
80106822:	89 e5                	mov    %esp,%ebp
80106824:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106827:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
8010682e:	00 
8010682f:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
80106836:	e8 38 fe ff ff       	call   80106673 <lidt>
}
8010683b:	c9                   	leave  
8010683c:	c3                   	ret    

8010683d <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010683d:	55                   	push   %ebp
8010683e:	89 e5                	mov    %esp,%ebp
80106840:	57                   	push   %edi
80106841:	56                   	push   %esi
80106842:	53                   	push   %ebx
80106843:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106846:	8b 45 08             	mov    0x8(%ebp),%eax
80106849:	8b 40 30             	mov    0x30(%eax),%eax
8010684c:	83 f8 40             	cmp    $0x40,%eax
8010684f:	75 3c                	jne    8010688d <trap+0x50>
    if(myproc()->killed)
80106851:	e8 58 da ff ff       	call   801042ae <myproc>
80106856:	8b 40 24             	mov    0x24(%eax),%eax
80106859:	85 c0                	test   %eax,%eax
8010685b:	74 05                	je     80106862 <trap+0x25>
      exit();
8010685d:	e8 ee de ff ff       	call   80104750 <exit>
    myproc()->tf = tf;
80106862:	e8 47 da ff ff       	call   801042ae <myproc>
80106867:	8b 55 08             	mov    0x8(%ebp),%edx
8010686a:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010686d:	e8 d6 ed ff ff       	call   80105648 <syscall>
    if(myproc()->killed)
80106872:	e8 37 da ff ff       	call   801042ae <myproc>
80106877:	8b 40 24             	mov    0x24(%eax),%eax
8010687a:	85 c0                	test   %eax,%eax
8010687c:	74 0a                	je     80106888 <trap+0x4b>
      exit();
8010687e:	e8 cd de ff ff       	call   80104750 <exit>
    return;
80106883:	e9 19 02 00 00       	jmp    80106aa1 <trap+0x264>
80106888:	e9 14 02 00 00       	jmp    80106aa1 <trap+0x264>
  }

  switch(tf->trapno){
8010688d:	8b 45 08             	mov    0x8(%ebp),%eax
80106890:	8b 40 30             	mov    0x30(%eax),%eax
80106893:	83 e8 20             	sub    $0x20,%eax
80106896:	83 f8 1f             	cmp    $0x1f,%eax
80106899:	0f 87 b1 00 00 00    	ja     80106950 <trap+0x113>
8010689f:	8b 04 85 3c 8a 10 80 	mov    -0x7fef75c4(,%eax,4),%eax
801068a6:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801068a8:	e8 6a d9 ff ff       	call   80104217 <cpuid>
801068ad:	85 c0                	test   %eax,%eax
801068af:	75 31                	jne    801068e2 <trap+0xa5>
      acquire(&tickslock);
801068b1:	c7 04 24 00 5f 11 80 	movl   $0x80115f00,(%esp)
801068b8:	e8 02 e7 ff ff       	call   80104fbf <acquire>
      ticks++;
801068bd:	a1 40 67 11 80       	mov    0x80116740,%eax
801068c2:	83 c0 01             	add    $0x1,%eax
801068c5:	a3 40 67 11 80       	mov    %eax,0x80116740
      wakeup(&ticks);
801068ca:	c7 04 24 40 67 11 80 	movl   $0x80116740,(%esp)
801068d1:	e8 c5 e3 ff ff       	call   80104c9b <wakeup>
      release(&tickslock);
801068d6:	c7 04 24 00 5f 11 80 	movl   $0x80115f00,(%esp)
801068dd:	e8 45 e7 ff ff       	call   80105027 <release>
    }
    lapiceoi();
801068e2:	e8 6a c6 ff ff       	call   80102f51 <lapiceoi>
    break;
801068e7:	e9 37 01 00 00       	jmp    80106a23 <trap+0x1e6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801068ec:	e8 d7 be ff ff       	call   801027c8 <ideintr>
    lapiceoi();
801068f1:	e8 5b c6 ff ff       	call   80102f51 <lapiceoi>
    break;
801068f6:	e9 28 01 00 00       	jmp    80106a23 <trap+0x1e6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801068fb:	e8 66 c4 ff ff       	call   80102d66 <kbdintr>
    lapiceoi();
80106900:	e8 4c c6 ff ff       	call   80102f51 <lapiceoi>
    break;
80106905:	e9 19 01 00 00       	jmp    80106a23 <trap+0x1e6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010690a:	e8 7b 03 00 00       	call   80106c8a <uartintr>
    lapiceoi();
8010690f:	e8 3d c6 ff ff       	call   80102f51 <lapiceoi>
    break;
80106914:	e9 0a 01 00 00       	jmp    80106a23 <trap+0x1e6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106919:	8b 45 08             	mov    0x8(%ebp),%eax
8010691c:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
8010691f:	8b 45 08             	mov    0x8(%ebp),%eax
80106922:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106926:	0f b7 d8             	movzwl %ax,%ebx
80106929:	e8 e9 d8 ff ff       	call   80104217 <cpuid>
8010692e:	89 74 24 0c          	mov    %esi,0xc(%esp)
80106932:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80106936:	89 44 24 04          	mov    %eax,0x4(%esp)
8010693a:	c7 04 24 9c 89 10 80 	movl   $0x8010899c,(%esp)
80106941:	e8 82 9a ff ff       	call   801003c8 <cprintf>
    lapiceoi();
80106946:	e8 06 c6 ff ff       	call   80102f51 <lapiceoi>
    break;
8010694b:	e9 d3 00 00 00       	jmp    80106a23 <trap+0x1e6>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106950:	e8 59 d9 ff ff       	call   801042ae <myproc>
80106955:	85 c0                	test   %eax,%eax
80106957:	74 11                	je     8010696a <trap+0x12d>
80106959:	8b 45 08             	mov    0x8(%ebp),%eax
8010695c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106960:	0f b7 c0             	movzwl %ax,%eax
80106963:	83 e0 03             	and    $0x3,%eax
80106966:	85 c0                	test   %eax,%eax
80106968:	75 40                	jne    801069aa <trap+0x16d>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010696a:	e8 2d fd ff ff       	call   8010669c <rcr2>
8010696f:	89 c3                	mov    %eax,%ebx
80106971:	8b 45 08             	mov    0x8(%ebp),%eax
80106974:	8b 70 38             	mov    0x38(%eax),%esi
80106977:	e8 9b d8 ff ff       	call   80104217 <cpuid>
8010697c:	8b 55 08             	mov    0x8(%ebp),%edx
8010697f:	8b 52 30             	mov    0x30(%edx),%edx
80106982:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106986:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010698a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010698e:	89 54 24 04          	mov    %edx,0x4(%esp)
80106992:	c7 04 24 c0 89 10 80 	movl   $0x801089c0,(%esp)
80106999:	e8 2a 9a ff ff       	call   801003c8 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
8010699e:	c7 04 24 f2 89 10 80 	movl   $0x801089f2,(%esp)
801069a5:	e8 b8 9b ff ff       	call   80100562 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069aa:	e8 ed fc ff ff       	call   8010669c <rcr2>
801069af:	89 c6                	mov    %eax,%esi
801069b1:	8b 45 08             	mov    0x8(%ebp),%eax
801069b4:	8b 40 38             	mov    0x38(%eax),%eax
801069b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069ba:	e8 58 d8 ff ff       	call   80104217 <cpuid>
801069bf:	89 c3                	mov    %eax,%ebx
801069c1:	8b 45 08             	mov    0x8(%ebp),%eax
801069c4:	8b 78 34             	mov    0x34(%eax),%edi
801069c7:	89 7d e0             	mov    %edi,-0x20(%ebp)
801069ca:	8b 45 08             	mov    0x8(%ebp),%eax
801069cd:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801069d0:	e8 d9 d8 ff ff       	call   801042ae <myproc>
801069d5:	8d 50 6c             	lea    0x6c(%eax),%edx
801069d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
801069db:	e8 ce d8 ff ff       	call   801042ae <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069e0:	8b 40 10             	mov    0x10(%eax),%eax
801069e3:	89 74 24 1c          	mov    %esi,0x1c(%esp)
801069e7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801069ea:	89 4c 24 18          	mov    %ecx,0x18(%esp)
801069ee:	89 5c 24 14          	mov    %ebx,0x14(%esp)
801069f2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801069f5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801069f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801069fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106a00:	89 54 24 08          	mov    %edx,0x8(%esp)
80106a04:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a08:	c7 04 24 f8 89 10 80 	movl   $0x801089f8,(%esp)
80106a0f:	e8 b4 99 ff ff       	call   801003c8 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106a14:	e8 95 d8 ff ff       	call   801042ae <myproc>
80106a19:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106a20:	eb 01                	jmp    80106a23 <trap+0x1e6>
    break;
80106a22:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a23:	e8 86 d8 ff ff       	call   801042ae <myproc>
80106a28:	85 c0                	test   %eax,%eax
80106a2a:	74 23                	je     80106a4f <trap+0x212>
80106a2c:	e8 7d d8 ff ff       	call   801042ae <myproc>
80106a31:	8b 40 24             	mov    0x24(%eax),%eax
80106a34:	85 c0                	test   %eax,%eax
80106a36:	74 17                	je     80106a4f <trap+0x212>
80106a38:	8b 45 08             	mov    0x8(%ebp),%eax
80106a3b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a3f:	0f b7 c0             	movzwl %ax,%eax
80106a42:	83 e0 03             	and    $0x3,%eax
80106a45:	83 f8 03             	cmp    $0x3,%eax
80106a48:	75 05                	jne    80106a4f <trap+0x212>
    exit();
80106a4a:	e8 01 dd ff ff       	call   80104750 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106a4f:	e8 5a d8 ff ff       	call   801042ae <myproc>
80106a54:	85 c0                	test   %eax,%eax
80106a56:	74 1d                	je     80106a75 <trap+0x238>
80106a58:	e8 51 d8 ff ff       	call   801042ae <myproc>
80106a5d:	8b 40 0c             	mov    0xc(%eax),%eax
80106a60:	83 f8 04             	cmp    $0x4,%eax
80106a63:	75 10                	jne    80106a75 <trap+0x238>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106a65:	8b 45 08             	mov    0x8(%ebp),%eax
80106a68:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106a6b:	83 f8 20             	cmp    $0x20,%eax
80106a6e:	75 05                	jne    80106a75 <trap+0x238>
    yield();
80106a70:	e8 df e0 ff ff       	call   80104b54 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a75:	e8 34 d8 ff ff       	call   801042ae <myproc>
80106a7a:	85 c0                	test   %eax,%eax
80106a7c:	74 23                	je     80106aa1 <trap+0x264>
80106a7e:	e8 2b d8 ff ff       	call   801042ae <myproc>
80106a83:	8b 40 24             	mov    0x24(%eax),%eax
80106a86:	85 c0                	test   %eax,%eax
80106a88:	74 17                	je     80106aa1 <trap+0x264>
80106a8a:	8b 45 08             	mov    0x8(%ebp),%eax
80106a8d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a91:	0f b7 c0             	movzwl %ax,%eax
80106a94:	83 e0 03             	and    $0x3,%eax
80106a97:	83 f8 03             	cmp    $0x3,%eax
80106a9a:	75 05                	jne    80106aa1 <trap+0x264>
    exit();
80106a9c:	e8 af dc ff ff       	call   80104750 <exit>
}
80106aa1:	83 c4 3c             	add    $0x3c,%esp
80106aa4:	5b                   	pop    %ebx
80106aa5:	5e                   	pop    %esi
80106aa6:	5f                   	pop    %edi
80106aa7:	5d                   	pop    %ebp
80106aa8:	c3                   	ret    

80106aa9 <inb>:
{
80106aa9:	55                   	push   %ebp
80106aaa:	89 e5                	mov    %esp,%ebp
80106aac:	83 ec 14             	sub    $0x14,%esp
80106aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80106ab2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106ab6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106aba:	89 c2                	mov    %eax,%edx
80106abc:	ec                   	in     (%dx),%al
80106abd:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106ac0:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106ac4:	c9                   	leave  
80106ac5:	c3                   	ret    

80106ac6 <outb>:
{
80106ac6:	55                   	push   %ebp
80106ac7:	89 e5                	mov    %esp,%ebp
80106ac9:	83 ec 08             	sub    $0x8,%esp
80106acc:	8b 55 08             	mov    0x8(%ebp),%edx
80106acf:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ad2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106ad6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106ad9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106add:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106ae1:	ee                   	out    %al,(%dx)
}
80106ae2:	c9                   	leave  
80106ae3:	c3                   	ret    

80106ae4 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106ae4:	55                   	push   %ebp
80106ae5:	89 e5                	mov    %esp,%ebp
80106ae7:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106aea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106af1:	00 
80106af2:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106af9:	e8 c8 ff ff ff       	call   80106ac6 <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106afe:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106b05:	00 
80106b06:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106b0d:	e8 b4 ff ff ff       	call   80106ac6 <outb>
  outb(COM1+0, 115200/9600);
80106b12:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106b19:	00 
80106b1a:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b21:	e8 a0 ff ff ff       	call   80106ac6 <outb>
  outb(COM1+1, 0);
80106b26:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b2d:	00 
80106b2e:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106b35:	e8 8c ff ff ff       	call   80106ac6 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106b3a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106b41:	00 
80106b42:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106b49:	e8 78 ff ff ff       	call   80106ac6 <outb>
  outb(COM1+4, 0);
80106b4e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b55:	00 
80106b56:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106b5d:	e8 64 ff ff ff       	call   80106ac6 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106b62:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106b69:	00 
80106b6a:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106b71:	e8 50 ff ff ff       	call   80106ac6 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106b76:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106b7d:	e8 27 ff ff ff       	call   80106aa9 <inb>
80106b82:	3c ff                	cmp    $0xff,%al
80106b84:	75 02                	jne    80106b88 <uartinit+0xa4>
    return;
80106b86:	eb 5e                	jmp    80106be6 <uartinit+0x102>
  uart = 1;
80106b88:	c7 05 44 b6 10 80 01 	movl   $0x1,0x8010b644
80106b8f:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106b92:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106b99:	e8 0b ff ff ff       	call   80106aa9 <inb>
  inb(COM1+0);
80106b9e:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106ba5:	e8 ff fe ff ff       	call   80106aa9 <inb>
  ioapicenable(IRQ_COM1, 0);
80106baa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106bb1:	00 
80106bb2:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106bb9:	e8 81 be ff ff       	call   80102a3f <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106bbe:	c7 45 f4 bc 8a 10 80 	movl   $0x80108abc,-0xc(%ebp)
80106bc5:	eb 15                	jmp    80106bdc <uartinit+0xf8>
    uartputc(*p);
80106bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bca:	0f b6 00             	movzbl (%eax),%eax
80106bcd:	0f be c0             	movsbl %al,%eax
80106bd0:	89 04 24             	mov    %eax,(%esp)
80106bd3:	e8 10 00 00 00       	call   80106be8 <uartputc>
  for(p="xv6...\n"; *p; p++)
80106bd8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bdf:	0f b6 00             	movzbl (%eax),%eax
80106be2:	84 c0                	test   %al,%al
80106be4:	75 e1                	jne    80106bc7 <uartinit+0xe3>
}
80106be6:	c9                   	leave  
80106be7:	c3                   	ret    

80106be8 <uartputc>:

void
uartputc(int c)
{
80106be8:	55                   	push   %ebp
80106be9:	89 e5                	mov    %esp,%ebp
80106beb:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106bee:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80106bf3:	85 c0                	test   %eax,%eax
80106bf5:	75 02                	jne    80106bf9 <uartputc+0x11>
    return;
80106bf7:	eb 4b                	jmp    80106c44 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106bf9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106c00:	eb 10                	jmp    80106c12 <uartputc+0x2a>
    microdelay(10);
80106c02:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106c09:	e8 68 c3 ff ff       	call   80102f76 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c0e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c12:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106c16:	7f 16                	jg     80106c2e <uartputc+0x46>
80106c18:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106c1f:	e8 85 fe ff ff       	call   80106aa9 <inb>
80106c24:	0f b6 c0             	movzbl %al,%eax
80106c27:	83 e0 20             	and    $0x20,%eax
80106c2a:	85 c0                	test   %eax,%eax
80106c2c:	74 d4                	je     80106c02 <uartputc+0x1a>
  outb(COM1+0, c);
80106c2e:	8b 45 08             	mov    0x8(%ebp),%eax
80106c31:	0f b6 c0             	movzbl %al,%eax
80106c34:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c38:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c3f:	e8 82 fe ff ff       	call   80106ac6 <outb>
}
80106c44:	c9                   	leave  
80106c45:	c3                   	ret    

80106c46 <uartgetc>:

static int
uartgetc(void)
{
80106c46:	55                   	push   %ebp
80106c47:	89 e5                	mov    %esp,%ebp
80106c49:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106c4c:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80106c51:	85 c0                	test   %eax,%eax
80106c53:	75 07                	jne    80106c5c <uartgetc+0x16>
    return -1;
80106c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c5a:	eb 2c                	jmp    80106c88 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106c5c:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106c63:	e8 41 fe ff ff       	call   80106aa9 <inb>
80106c68:	0f b6 c0             	movzbl %al,%eax
80106c6b:	83 e0 01             	and    $0x1,%eax
80106c6e:	85 c0                	test   %eax,%eax
80106c70:	75 07                	jne    80106c79 <uartgetc+0x33>
    return -1;
80106c72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c77:	eb 0f                	jmp    80106c88 <uartgetc+0x42>
  return inb(COM1+0);
80106c79:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c80:	e8 24 fe ff ff       	call   80106aa9 <inb>
80106c85:	0f b6 c0             	movzbl %al,%eax
}
80106c88:	c9                   	leave  
80106c89:	c3                   	ret    

80106c8a <uartintr>:

void
uartintr(void)
{
80106c8a:	55                   	push   %ebp
80106c8b:	89 e5                	mov    %esp,%ebp
80106c8d:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106c90:	c7 04 24 46 6c 10 80 	movl   $0x80106c46,(%esp)
80106c97:	e8 4d 9b ff ff       	call   801007e9 <consoleintr>
}
80106c9c:	c9                   	leave  
80106c9d:	c3                   	ret    

80106c9e <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106c9e:	6a 00                	push   $0x0
  pushl $0
80106ca0:	6a 00                	push   $0x0
  jmp alltraps
80106ca2:	e9 a9 f9 ff ff       	jmp    80106650 <alltraps>

80106ca7 <vector1>:
.globl vector1
vector1:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $1
80106ca9:	6a 01                	push   $0x1
  jmp alltraps
80106cab:	e9 a0 f9 ff ff       	jmp    80106650 <alltraps>

80106cb0 <vector2>:
.globl vector2
vector2:
  pushl $0
80106cb0:	6a 00                	push   $0x0
  pushl $2
80106cb2:	6a 02                	push   $0x2
  jmp alltraps
80106cb4:	e9 97 f9 ff ff       	jmp    80106650 <alltraps>

80106cb9 <vector3>:
.globl vector3
vector3:
  pushl $0
80106cb9:	6a 00                	push   $0x0
  pushl $3
80106cbb:	6a 03                	push   $0x3
  jmp alltraps
80106cbd:	e9 8e f9 ff ff       	jmp    80106650 <alltraps>

80106cc2 <vector4>:
.globl vector4
vector4:
  pushl $0
80106cc2:	6a 00                	push   $0x0
  pushl $4
80106cc4:	6a 04                	push   $0x4
  jmp alltraps
80106cc6:	e9 85 f9 ff ff       	jmp    80106650 <alltraps>

80106ccb <vector5>:
.globl vector5
vector5:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $5
80106ccd:	6a 05                	push   $0x5
  jmp alltraps
80106ccf:	e9 7c f9 ff ff       	jmp    80106650 <alltraps>

80106cd4 <vector6>:
.globl vector6
vector6:
  pushl $0
80106cd4:	6a 00                	push   $0x0
  pushl $6
80106cd6:	6a 06                	push   $0x6
  jmp alltraps
80106cd8:	e9 73 f9 ff ff       	jmp    80106650 <alltraps>

80106cdd <vector7>:
.globl vector7
vector7:
  pushl $0
80106cdd:	6a 00                	push   $0x0
  pushl $7
80106cdf:	6a 07                	push   $0x7
  jmp alltraps
80106ce1:	e9 6a f9 ff ff       	jmp    80106650 <alltraps>

80106ce6 <vector8>:
.globl vector8
vector8:
  pushl $8
80106ce6:	6a 08                	push   $0x8
  jmp alltraps
80106ce8:	e9 63 f9 ff ff       	jmp    80106650 <alltraps>

80106ced <vector9>:
.globl vector9
vector9:
  pushl $0
80106ced:	6a 00                	push   $0x0
  pushl $9
80106cef:	6a 09                	push   $0x9
  jmp alltraps
80106cf1:	e9 5a f9 ff ff       	jmp    80106650 <alltraps>

80106cf6 <vector10>:
.globl vector10
vector10:
  pushl $10
80106cf6:	6a 0a                	push   $0xa
  jmp alltraps
80106cf8:	e9 53 f9 ff ff       	jmp    80106650 <alltraps>

80106cfd <vector11>:
.globl vector11
vector11:
  pushl $11
80106cfd:	6a 0b                	push   $0xb
  jmp alltraps
80106cff:	e9 4c f9 ff ff       	jmp    80106650 <alltraps>

80106d04 <vector12>:
.globl vector12
vector12:
  pushl $12
80106d04:	6a 0c                	push   $0xc
  jmp alltraps
80106d06:	e9 45 f9 ff ff       	jmp    80106650 <alltraps>

80106d0b <vector13>:
.globl vector13
vector13:
  pushl $13
80106d0b:	6a 0d                	push   $0xd
  jmp alltraps
80106d0d:	e9 3e f9 ff ff       	jmp    80106650 <alltraps>

80106d12 <vector14>:
.globl vector14
vector14:
  pushl $14
80106d12:	6a 0e                	push   $0xe
  jmp alltraps
80106d14:	e9 37 f9 ff ff       	jmp    80106650 <alltraps>

80106d19 <vector15>:
.globl vector15
vector15:
  pushl $0
80106d19:	6a 00                	push   $0x0
  pushl $15
80106d1b:	6a 0f                	push   $0xf
  jmp alltraps
80106d1d:	e9 2e f9 ff ff       	jmp    80106650 <alltraps>

80106d22 <vector16>:
.globl vector16
vector16:
  pushl $0
80106d22:	6a 00                	push   $0x0
  pushl $16
80106d24:	6a 10                	push   $0x10
  jmp alltraps
80106d26:	e9 25 f9 ff ff       	jmp    80106650 <alltraps>

80106d2b <vector17>:
.globl vector17
vector17:
  pushl $17
80106d2b:	6a 11                	push   $0x11
  jmp alltraps
80106d2d:	e9 1e f9 ff ff       	jmp    80106650 <alltraps>

80106d32 <vector18>:
.globl vector18
vector18:
  pushl $0
80106d32:	6a 00                	push   $0x0
  pushl $18
80106d34:	6a 12                	push   $0x12
  jmp alltraps
80106d36:	e9 15 f9 ff ff       	jmp    80106650 <alltraps>

80106d3b <vector19>:
.globl vector19
vector19:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $19
80106d3d:	6a 13                	push   $0x13
  jmp alltraps
80106d3f:	e9 0c f9 ff ff       	jmp    80106650 <alltraps>

80106d44 <vector20>:
.globl vector20
vector20:
  pushl $0
80106d44:	6a 00                	push   $0x0
  pushl $20
80106d46:	6a 14                	push   $0x14
  jmp alltraps
80106d48:	e9 03 f9 ff ff       	jmp    80106650 <alltraps>

80106d4d <vector21>:
.globl vector21
vector21:
  pushl $0
80106d4d:	6a 00                	push   $0x0
  pushl $21
80106d4f:	6a 15                	push   $0x15
  jmp alltraps
80106d51:	e9 fa f8 ff ff       	jmp    80106650 <alltraps>

80106d56 <vector22>:
.globl vector22
vector22:
  pushl $0
80106d56:	6a 00                	push   $0x0
  pushl $22
80106d58:	6a 16                	push   $0x16
  jmp alltraps
80106d5a:	e9 f1 f8 ff ff       	jmp    80106650 <alltraps>

80106d5f <vector23>:
.globl vector23
vector23:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $23
80106d61:	6a 17                	push   $0x17
  jmp alltraps
80106d63:	e9 e8 f8 ff ff       	jmp    80106650 <alltraps>

80106d68 <vector24>:
.globl vector24
vector24:
  pushl $0
80106d68:	6a 00                	push   $0x0
  pushl $24
80106d6a:	6a 18                	push   $0x18
  jmp alltraps
80106d6c:	e9 df f8 ff ff       	jmp    80106650 <alltraps>

80106d71 <vector25>:
.globl vector25
vector25:
  pushl $0
80106d71:	6a 00                	push   $0x0
  pushl $25
80106d73:	6a 19                	push   $0x19
  jmp alltraps
80106d75:	e9 d6 f8 ff ff       	jmp    80106650 <alltraps>

80106d7a <vector26>:
.globl vector26
vector26:
  pushl $0
80106d7a:	6a 00                	push   $0x0
  pushl $26
80106d7c:	6a 1a                	push   $0x1a
  jmp alltraps
80106d7e:	e9 cd f8 ff ff       	jmp    80106650 <alltraps>

80106d83 <vector27>:
.globl vector27
vector27:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $27
80106d85:	6a 1b                	push   $0x1b
  jmp alltraps
80106d87:	e9 c4 f8 ff ff       	jmp    80106650 <alltraps>

80106d8c <vector28>:
.globl vector28
vector28:
  pushl $0
80106d8c:	6a 00                	push   $0x0
  pushl $28
80106d8e:	6a 1c                	push   $0x1c
  jmp alltraps
80106d90:	e9 bb f8 ff ff       	jmp    80106650 <alltraps>

80106d95 <vector29>:
.globl vector29
vector29:
  pushl $0
80106d95:	6a 00                	push   $0x0
  pushl $29
80106d97:	6a 1d                	push   $0x1d
  jmp alltraps
80106d99:	e9 b2 f8 ff ff       	jmp    80106650 <alltraps>

80106d9e <vector30>:
.globl vector30
vector30:
  pushl $0
80106d9e:	6a 00                	push   $0x0
  pushl $30
80106da0:	6a 1e                	push   $0x1e
  jmp alltraps
80106da2:	e9 a9 f8 ff ff       	jmp    80106650 <alltraps>

80106da7 <vector31>:
.globl vector31
vector31:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $31
80106da9:	6a 1f                	push   $0x1f
  jmp alltraps
80106dab:	e9 a0 f8 ff ff       	jmp    80106650 <alltraps>

80106db0 <vector32>:
.globl vector32
vector32:
  pushl $0
80106db0:	6a 00                	push   $0x0
  pushl $32
80106db2:	6a 20                	push   $0x20
  jmp alltraps
80106db4:	e9 97 f8 ff ff       	jmp    80106650 <alltraps>

80106db9 <vector33>:
.globl vector33
vector33:
  pushl $0
80106db9:	6a 00                	push   $0x0
  pushl $33
80106dbb:	6a 21                	push   $0x21
  jmp alltraps
80106dbd:	e9 8e f8 ff ff       	jmp    80106650 <alltraps>

80106dc2 <vector34>:
.globl vector34
vector34:
  pushl $0
80106dc2:	6a 00                	push   $0x0
  pushl $34
80106dc4:	6a 22                	push   $0x22
  jmp alltraps
80106dc6:	e9 85 f8 ff ff       	jmp    80106650 <alltraps>

80106dcb <vector35>:
.globl vector35
vector35:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $35
80106dcd:	6a 23                	push   $0x23
  jmp alltraps
80106dcf:	e9 7c f8 ff ff       	jmp    80106650 <alltraps>

80106dd4 <vector36>:
.globl vector36
vector36:
  pushl $0
80106dd4:	6a 00                	push   $0x0
  pushl $36
80106dd6:	6a 24                	push   $0x24
  jmp alltraps
80106dd8:	e9 73 f8 ff ff       	jmp    80106650 <alltraps>

80106ddd <vector37>:
.globl vector37
vector37:
  pushl $0
80106ddd:	6a 00                	push   $0x0
  pushl $37
80106ddf:	6a 25                	push   $0x25
  jmp alltraps
80106de1:	e9 6a f8 ff ff       	jmp    80106650 <alltraps>

80106de6 <vector38>:
.globl vector38
vector38:
  pushl $0
80106de6:	6a 00                	push   $0x0
  pushl $38
80106de8:	6a 26                	push   $0x26
  jmp alltraps
80106dea:	e9 61 f8 ff ff       	jmp    80106650 <alltraps>

80106def <vector39>:
.globl vector39
vector39:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $39
80106df1:	6a 27                	push   $0x27
  jmp alltraps
80106df3:	e9 58 f8 ff ff       	jmp    80106650 <alltraps>

80106df8 <vector40>:
.globl vector40
vector40:
  pushl $0
80106df8:	6a 00                	push   $0x0
  pushl $40
80106dfa:	6a 28                	push   $0x28
  jmp alltraps
80106dfc:	e9 4f f8 ff ff       	jmp    80106650 <alltraps>

80106e01 <vector41>:
.globl vector41
vector41:
  pushl $0
80106e01:	6a 00                	push   $0x0
  pushl $41
80106e03:	6a 29                	push   $0x29
  jmp alltraps
80106e05:	e9 46 f8 ff ff       	jmp    80106650 <alltraps>

80106e0a <vector42>:
.globl vector42
vector42:
  pushl $0
80106e0a:	6a 00                	push   $0x0
  pushl $42
80106e0c:	6a 2a                	push   $0x2a
  jmp alltraps
80106e0e:	e9 3d f8 ff ff       	jmp    80106650 <alltraps>

80106e13 <vector43>:
.globl vector43
vector43:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $43
80106e15:	6a 2b                	push   $0x2b
  jmp alltraps
80106e17:	e9 34 f8 ff ff       	jmp    80106650 <alltraps>

80106e1c <vector44>:
.globl vector44
vector44:
  pushl $0
80106e1c:	6a 00                	push   $0x0
  pushl $44
80106e1e:	6a 2c                	push   $0x2c
  jmp alltraps
80106e20:	e9 2b f8 ff ff       	jmp    80106650 <alltraps>

80106e25 <vector45>:
.globl vector45
vector45:
  pushl $0
80106e25:	6a 00                	push   $0x0
  pushl $45
80106e27:	6a 2d                	push   $0x2d
  jmp alltraps
80106e29:	e9 22 f8 ff ff       	jmp    80106650 <alltraps>

80106e2e <vector46>:
.globl vector46
vector46:
  pushl $0
80106e2e:	6a 00                	push   $0x0
  pushl $46
80106e30:	6a 2e                	push   $0x2e
  jmp alltraps
80106e32:	e9 19 f8 ff ff       	jmp    80106650 <alltraps>

80106e37 <vector47>:
.globl vector47
vector47:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $47
80106e39:	6a 2f                	push   $0x2f
  jmp alltraps
80106e3b:	e9 10 f8 ff ff       	jmp    80106650 <alltraps>

80106e40 <vector48>:
.globl vector48
vector48:
  pushl $0
80106e40:	6a 00                	push   $0x0
  pushl $48
80106e42:	6a 30                	push   $0x30
  jmp alltraps
80106e44:	e9 07 f8 ff ff       	jmp    80106650 <alltraps>

80106e49 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e49:	6a 00                	push   $0x0
  pushl $49
80106e4b:	6a 31                	push   $0x31
  jmp alltraps
80106e4d:	e9 fe f7 ff ff       	jmp    80106650 <alltraps>

80106e52 <vector50>:
.globl vector50
vector50:
  pushl $0
80106e52:	6a 00                	push   $0x0
  pushl $50
80106e54:	6a 32                	push   $0x32
  jmp alltraps
80106e56:	e9 f5 f7 ff ff       	jmp    80106650 <alltraps>

80106e5b <vector51>:
.globl vector51
vector51:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $51
80106e5d:	6a 33                	push   $0x33
  jmp alltraps
80106e5f:	e9 ec f7 ff ff       	jmp    80106650 <alltraps>

80106e64 <vector52>:
.globl vector52
vector52:
  pushl $0
80106e64:	6a 00                	push   $0x0
  pushl $52
80106e66:	6a 34                	push   $0x34
  jmp alltraps
80106e68:	e9 e3 f7 ff ff       	jmp    80106650 <alltraps>

80106e6d <vector53>:
.globl vector53
vector53:
  pushl $0
80106e6d:	6a 00                	push   $0x0
  pushl $53
80106e6f:	6a 35                	push   $0x35
  jmp alltraps
80106e71:	e9 da f7 ff ff       	jmp    80106650 <alltraps>

80106e76 <vector54>:
.globl vector54
vector54:
  pushl $0
80106e76:	6a 00                	push   $0x0
  pushl $54
80106e78:	6a 36                	push   $0x36
  jmp alltraps
80106e7a:	e9 d1 f7 ff ff       	jmp    80106650 <alltraps>

80106e7f <vector55>:
.globl vector55
vector55:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $55
80106e81:	6a 37                	push   $0x37
  jmp alltraps
80106e83:	e9 c8 f7 ff ff       	jmp    80106650 <alltraps>

80106e88 <vector56>:
.globl vector56
vector56:
  pushl $0
80106e88:	6a 00                	push   $0x0
  pushl $56
80106e8a:	6a 38                	push   $0x38
  jmp alltraps
80106e8c:	e9 bf f7 ff ff       	jmp    80106650 <alltraps>

80106e91 <vector57>:
.globl vector57
vector57:
  pushl $0
80106e91:	6a 00                	push   $0x0
  pushl $57
80106e93:	6a 39                	push   $0x39
  jmp alltraps
80106e95:	e9 b6 f7 ff ff       	jmp    80106650 <alltraps>

80106e9a <vector58>:
.globl vector58
vector58:
  pushl $0
80106e9a:	6a 00                	push   $0x0
  pushl $58
80106e9c:	6a 3a                	push   $0x3a
  jmp alltraps
80106e9e:	e9 ad f7 ff ff       	jmp    80106650 <alltraps>

80106ea3 <vector59>:
.globl vector59
vector59:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $59
80106ea5:	6a 3b                	push   $0x3b
  jmp alltraps
80106ea7:	e9 a4 f7 ff ff       	jmp    80106650 <alltraps>

80106eac <vector60>:
.globl vector60
vector60:
  pushl $0
80106eac:	6a 00                	push   $0x0
  pushl $60
80106eae:	6a 3c                	push   $0x3c
  jmp alltraps
80106eb0:	e9 9b f7 ff ff       	jmp    80106650 <alltraps>

80106eb5 <vector61>:
.globl vector61
vector61:
  pushl $0
80106eb5:	6a 00                	push   $0x0
  pushl $61
80106eb7:	6a 3d                	push   $0x3d
  jmp alltraps
80106eb9:	e9 92 f7 ff ff       	jmp    80106650 <alltraps>

80106ebe <vector62>:
.globl vector62
vector62:
  pushl $0
80106ebe:	6a 00                	push   $0x0
  pushl $62
80106ec0:	6a 3e                	push   $0x3e
  jmp alltraps
80106ec2:	e9 89 f7 ff ff       	jmp    80106650 <alltraps>

80106ec7 <vector63>:
.globl vector63
vector63:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $63
80106ec9:	6a 3f                	push   $0x3f
  jmp alltraps
80106ecb:	e9 80 f7 ff ff       	jmp    80106650 <alltraps>

80106ed0 <vector64>:
.globl vector64
vector64:
  pushl $0
80106ed0:	6a 00                	push   $0x0
  pushl $64
80106ed2:	6a 40                	push   $0x40
  jmp alltraps
80106ed4:	e9 77 f7 ff ff       	jmp    80106650 <alltraps>

80106ed9 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ed9:	6a 00                	push   $0x0
  pushl $65
80106edb:	6a 41                	push   $0x41
  jmp alltraps
80106edd:	e9 6e f7 ff ff       	jmp    80106650 <alltraps>

80106ee2 <vector66>:
.globl vector66
vector66:
  pushl $0
80106ee2:	6a 00                	push   $0x0
  pushl $66
80106ee4:	6a 42                	push   $0x42
  jmp alltraps
80106ee6:	e9 65 f7 ff ff       	jmp    80106650 <alltraps>

80106eeb <vector67>:
.globl vector67
vector67:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $67
80106eed:	6a 43                	push   $0x43
  jmp alltraps
80106eef:	e9 5c f7 ff ff       	jmp    80106650 <alltraps>

80106ef4 <vector68>:
.globl vector68
vector68:
  pushl $0
80106ef4:	6a 00                	push   $0x0
  pushl $68
80106ef6:	6a 44                	push   $0x44
  jmp alltraps
80106ef8:	e9 53 f7 ff ff       	jmp    80106650 <alltraps>

80106efd <vector69>:
.globl vector69
vector69:
  pushl $0
80106efd:	6a 00                	push   $0x0
  pushl $69
80106eff:	6a 45                	push   $0x45
  jmp alltraps
80106f01:	e9 4a f7 ff ff       	jmp    80106650 <alltraps>

80106f06 <vector70>:
.globl vector70
vector70:
  pushl $0
80106f06:	6a 00                	push   $0x0
  pushl $70
80106f08:	6a 46                	push   $0x46
  jmp alltraps
80106f0a:	e9 41 f7 ff ff       	jmp    80106650 <alltraps>

80106f0f <vector71>:
.globl vector71
vector71:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $71
80106f11:	6a 47                	push   $0x47
  jmp alltraps
80106f13:	e9 38 f7 ff ff       	jmp    80106650 <alltraps>

80106f18 <vector72>:
.globl vector72
vector72:
  pushl $0
80106f18:	6a 00                	push   $0x0
  pushl $72
80106f1a:	6a 48                	push   $0x48
  jmp alltraps
80106f1c:	e9 2f f7 ff ff       	jmp    80106650 <alltraps>

80106f21 <vector73>:
.globl vector73
vector73:
  pushl $0
80106f21:	6a 00                	push   $0x0
  pushl $73
80106f23:	6a 49                	push   $0x49
  jmp alltraps
80106f25:	e9 26 f7 ff ff       	jmp    80106650 <alltraps>

80106f2a <vector74>:
.globl vector74
vector74:
  pushl $0
80106f2a:	6a 00                	push   $0x0
  pushl $74
80106f2c:	6a 4a                	push   $0x4a
  jmp alltraps
80106f2e:	e9 1d f7 ff ff       	jmp    80106650 <alltraps>

80106f33 <vector75>:
.globl vector75
vector75:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $75
80106f35:	6a 4b                	push   $0x4b
  jmp alltraps
80106f37:	e9 14 f7 ff ff       	jmp    80106650 <alltraps>

80106f3c <vector76>:
.globl vector76
vector76:
  pushl $0
80106f3c:	6a 00                	push   $0x0
  pushl $76
80106f3e:	6a 4c                	push   $0x4c
  jmp alltraps
80106f40:	e9 0b f7 ff ff       	jmp    80106650 <alltraps>

80106f45 <vector77>:
.globl vector77
vector77:
  pushl $0
80106f45:	6a 00                	push   $0x0
  pushl $77
80106f47:	6a 4d                	push   $0x4d
  jmp alltraps
80106f49:	e9 02 f7 ff ff       	jmp    80106650 <alltraps>

80106f4e <vector78>:
.globl vector78
vector78:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $78
80106f50:	6a 4e                	push   $0x4e
  jmp alltraps
80106f52:	e9 f9 f6 ff ff       	jmp    80106650 <alltraps>

80106f57 <vector79>:
.globl vector79
vector79:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $79
80106f59:	6a 4f                	push   $0x4f
  jmp alltraps
80106f5b:	e9 f0 f6 ff ff       	jmp    80106650 <alltraps>

80106f60 <vector80>:
.globl vector80
vector80:
  pushl $0
80106f60:	6a 00                	push   $0x0
  pushl $80
80106f62:	6a 50                	push   $0x50
  jmp alltraps
80106f64:	e9 e7 f6 ff ff       	jmp    80106650 <alltraps>

80106f69 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f69:	6a 00                	push   $0x0
  pushl $81
80106f6b:	6a 51                	push   $0x51
  jmp alltraps
80106f6d:	e9 de f6 ff ff       	jmp    80106650 <alltraps>

80106f72 <vector82>:
.globl vector82
vector82:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $82
80106f74:	6a 52                	push   $0x52
  jmp alltraps
80106f76:	e9 d5 f6 ff ff       	jmp    80106650 <alltraps>

80106f7b <vector83>:
.globl vector83
vector83:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $83
80106f7d:	6a 53                	push   $0x53
  jmp alltraps
80106f7f:	e9 cc f6 ff ff       	jmp    80106650 <alltraps>

80106f84 <vector84>:
.globl vector84
vector84:
  pushl $0
80106f84:	6a 00                	push   $0x0
  pushl $84
80106f86:	6a 54                	push   $0x54
  jmp alltraps
80106f88:	e9 c3 f6 ff ff       	jmp    80106650 <alltraps>

80106f8d <vector85>:
.globl vector85
vector85:
  pushl $0
80106f8d:	6a 00                	push   $0x0
  pushl $85
80106f8f:	6a 55                	push   $0x55
  jmp alltraps
80106f91:	e9 ba f6 ff ff       	jmp    80106650 <alltraps>

80106f96 <vector86>:
.globl vector86
vector86:
  pushl $0
80106f96:	6a 00                	push   $0x0
  pushl $86
80106f98:	6a 56                	push   $0x56
  jmp alltraps
80106f9a:	e9 b1 f6 ff ff       	jmp    80106650 <alltraps>

80106f9f <vector87>:
.globl vector87
vector87:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $87
80106fa1:	6a 57                	push   $0x57
  jmp alltraps
80106fa3:	e9 a8 f6 ff ff       	jmp    80106650 <alltraps>

80106fa8 <vector88>:
.globl vector88
vector88:
  pushl $0
80106fa8:	6a 00                	push   $0x0
  pushl $88
80106faa:	6a 58                	push   $0x58
  jmp alltraps
80106fac:	e9 9f f6 ff ff       	jmp    80106650 <alltraps>

80106fb1 <vector89>:
.globl vector89
vector89:
  pushl $0
80106fb1:	6a 00                	push   $0x0
  pushl $89
80106fb3:	6a 59                	push   $0x59
  jmp alltraps
80106fb5:	e9 96 f6 ff ff       	jmp    80106650 <alltraps>

80106fba <vector90>:
.globl vector90
vector90:
  pushl $0
80106fba:	6a 00                	push   $0x0
  pushl $90
80106fbc:	6a 5a                	push   $0x5a
  jmp alltraps
80106fbe:	e9 8d f6 ff ff       	jmp    80106650 <alltraps>

80106fc3 <vector91>:
.globl vector91
vector91:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $91
80106fc5:	6a 5b                	push   $0x5b
  jmp alltraps
80106fc7:	e9 84 f6 ff ff       	jmp    80106650 <alltraps>

80106fcc <vector92>:
.globl vector92
vector92:
  pushl $0
80106fcc:	6a 00                	push   $0x0
  pushl $92
80106fce:	6a 5c                	push   $0x5c
  jmp alltraps
80106fd0:	e9 7b f6 ff ff       	jmp    80106650 <alltraps>

80106fd5 <vector93>:
.globl vector93
vector93:
  pushl $0
80106fd5:	6a 00                	push   $0x0
  pushl $93
80106fd7:	6a 5d                	push   $0x5d
  jmp alltraps
80106fd9:	e9 72 f6 ff ff       	jmp    80106650 <alltraps>

80106fde <vector94>:
.globl vector94
vector94:
  pushl $0
80106fde:	6a 00                	push   $0x0
  pushl $94
80106fe0:	6a 5e                	push   $0x5e
  jmp alltraps
80106fe2:	e9 69 f6 ff ff       	jmp    80106650 <alltraps>

80106fe7 <vector95>:
.globl vector95
vector95:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $95
80106fe9:	6a 5f                	push   $0x5f
  jmp alltraps
80106feb:	e9 60 f6 ff ff       	jmp    80106650 <alltraps>

80106ff0 <vector96>:
.globl vector96
vector96:
  pushl $0
80106ff0:	6a 00                	push   $0x0
  pushl $96
80106ff2:	6a 60                	push   $0x60
  jmp alltraps
80106ff4:	e9 57 f6 ff ff       	jmp    80106650 <alltraps>

80106ff9 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ff9:	6a 00                	push   $0x0
  pushl $97
80106ffb:	6a 61                	push   $0x61
  jmp alltraps
80106ffd:	e9 4e f6 ff ff       	jmp    80106650 <alltraps>

80107002 <vector98>:
.globl vector98
vector98:
  pushl $0
80107002:	6a 00                	push   $0x0
  pushl $98
80107004:	6a 62                	push   $0x62
  jmp alltraps
80107006:	e9 45 f6 ff ff       	jmp    80106650 <alltraps>

8010700b <vector99>:
.globl vector99
vector99:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $99
8010700d:	6a 63                	push   $0x63
  jmp alltraps
8010700f:	e9 3c f6 ff ff       	jmp    80106650 <alltraps>

80107014 <vector100>:
.globl vector100
vector100:
  pushl $0
80107014:	6a 00                	push   $0x0
  pushl $100
80107016:	6a 64                	push   $0x64
  jmp alltraps
80107018:	e9 33 f6 ff ff       	jmp    80106650 <alltraps>

8010701d <vector101>:
.globl vector101
vector101:
  pushl $0
8010701d:	6a 00                	push   $0x0
  pushl $101
8010701f:	6a 65                	push   $0x65
  jmp alltraps
80107021:	e9 2a f6 ff ff       	jmp    80106650 <alltraps>

80107026 <vector102>:
.globl vector102
vector102:
  pushl $0
80107026:	6a 00                	push   $0x0
  pushl $102
80107028:	6a 66                	push   $0x66
  jmp alltraps
8010702a:	e9 21 f6 ff ff       	jmp    80106650 <alltraps>

8010702f <vector103>:
.globl vector103
vector103:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $103
80107031:	6a 67                	push   $0x67
  jmp alltraps
80107033:	e9 18 f6 ff ff       	jmp    80106650 <alltraps>

80107038 <vector104>:
.globl vector104
vector104:
  pushl $0
80107038:	6a 00                	push   $0x0
  pushl $104
8010703a:	6a 68                	push   $0x68
  jmp alltraps
8010703c:	e9 0f f6 ff ff       	jmp    80106650 <alltraps>

80107041 <vector105>:
.globl vector105
vector105:
  pushl $0
80107041:	6a 00                	push   $0x0
  pushl $105
80107043:	6a 69                	push   $0x69
  jmp alltraps
80107045:	e9 06 f6 ff ff       	jmp    80106650 <alltraps>

8010704a <vector106>:
.globl vector106
vector106:
  pushl $0
8010704a:	6a 00                	push   $0x0
  pushl $106
8010704c:	6a 6a                	push   $0x6a
  jmp alltraps
8010704e:	e9 fd f5 ff ff       	jmp    80106650 <alltraps>

80107053 <vector107>:
.globl vector107
vector107:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $107
80107055:	6a 6b                	push   $0x6b
  jmp alltraps
80107057:	e9 f4 f5 ff ff       	jmp    80106650 <alltraps>

8010705c <vector108>:
.globl vector108
vector108:
  pushl $0
8010705c:	6a 00                	push   $0x0
  pushl $108
8010705e:	6a 6c                	push   $0x6c
  jmp alltraps
80107060:	e9 eb f5 ff ff       	jmp    80106650 <alltraps>

80107065 <vector109>:
.globl vector109
vector109:
  pushl $0
80107065:	6a 00                	push   $0x0
  pushl $109
80107067:	6a 6d                	push   $0x6d
  jmp alltraps
80107069:	e9 e2 f5 ff ff       	jmp    80106650 <alltraps>

8010706e <vector110>:
.globl vector110
vector110:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $110
80107070:	6a 6e                	push   $0x6e
  jmp alltraps
80107072:	e9 d9 f5 ff ff       	jmp    80106650 <alltraps>

80107077 <vector111>:
.globl vector111
vector111:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $111
80107079:	6a 6f                	push   $0x6f
  jmp alltraps
8010707b:	e9 d0 f5 ff ff       	jmp    80106650 <alltraps>

80107080 <vector112>:
.globl vector112
vector112:
  pushl $0
80107080:	6a 00                	push   $0x0
  pushl $112
80107082:	6a 70                	push   $0x70
  jmp alltraps
80107084:	e9 c7 f5 ff ff       	jmp    80106650 <alltraps>

80107089 <vector113>:
.globl vector113
vector113:
  pushl $0
80107089:	6a 00                	push   $0x0
  pushl $113
8010708b:	6a 71                	push   $0x71
  jmp alltraps
8010708d:	e9 be f5 ff ff       	jmp    80106650 <alltraps>

80107092 <vector114>:
.globl vector114
vector114:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $114
80107094:	6a 72                	push   $0x72
  jmp alltraps
80107096:	e9 b5 f5 ff ff       	jmp    80106650 <alltraps>

8010709b <vector115>:
.globl vector115
vector115:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $115
8010709d:	6a 73                	push   $0x73
  jmp alltraps
8010709f:	e9 ac f5 ff ff       	jmp    80106650 <alltraps>

801070a4 <vector116>:
.globl vector116
vector116:
  pushl $0
801070a4:	6a 00                	push   $0x0
  pushl $116
801070a6:	6a 74                	push   $0x74
  jmp alltraps
801070a8:	e9 a3 f5 ff ff       	jmp    80106650 <alltraps>

801070ad <vector117>:
.globl vector117
vector117:
  pushl $0
801070ad:	6a 00                	push   $0x0
  pushl $117
801070af:	6a 75                	push   $0x75
  jmp alltraps
801070b1:	e9 9a f5 ff ff       	jmp    80106650 <alltraps>

801070b6 <vector118>:
.globl vector118
vector118:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $118
801070b8:	6a 76                	push   $0x76
  jmp alltraps
801070ba:	e9 91 f5 ff ff       	jmp    80106650 <alltraps>

801070bf <vector119>:
.globl vector119
vector119:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $119
801070c1:	6a 77                	push   $0x77
  jmp alltraps
801070c3:	e9 88 f5 ff ff       	jmp    80106650 <alltraps>

801070c8 <vector120>:
.globl vector120
vector120:
  pushl $0
801070c8:	6a 00                	push   $0x0
  pushl $120
801070ca:	6a 78                	push   $0x78
  jmp alltraps
801070cc:	e9 7f f5 ff ff       	jmp    80106650 <alltraps>

801070d1 <vector121>:
.globl vector121
vector121:
  pushl $0
801070d1:	6a 00                	push   $0x0
  pushl $121
801070d3:	6a 79                	push   $0x79
  jmp alltraps
801070d5:	e9 76 f5 ff ff       	jmp    80106650 <alltraps>

801070da <vector122>:
.globl vector122
vector122:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $122
801070dc:	6a 7a                	push   $0x7a
  jmp alltraps
801070de:	e9 6d f5 ff ff       	jmp    80106650 <alltraps>

801070e3 <vector123>:
.globl vector123
vector123:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $123
801070e5:	6a 7b                	push   $0x7b
  jmp alltraps
801070e7:	e9 64 f5 ff ff       	jmp    80106650 <alltraps>

801070ec <vector124>:
.globl vector124
vector124:
  pushl $0
801070ec:	6a 00                	push   $0x0
  pushl $124
801070ee:	6a 7c                	push   $0x7c
  jmp alltraps
801070f0:	e9 5b f5 ff ff       	jmp    80106650 <alltraps>

801070f5 <vector125>:
.globl vector125
vector125:
  pushl $0
801070f5:	6a 00                	push   $0x0
  pushl $125
801070f7:	6a 7d                	push   $0x7d
  jmp alltraps
801070f9:	e9 52 f5 ff ff       	jmp    80106650 <alltraps>

801070fe <vector126>:
.globl vector126
vector126:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $126
80107100:	6a 7e                	push   $0x7e
  jmp alltraps
80107102:	e9 49 f5 ff ff       	jmp    80106650 <alltraps>

80107107 <vector127>:
.globl vector127
vector127:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $127
80107109:	6a 7f                	push   $0x7f
  jmp alltraps
8010710b:	e9 40 f5 ff ff       	jmp    80106650 <alltraps>

80107110 <vector128>:
.globl vector128
vector128:
  pushl $0
80107110:	6a 00                	push   $0x0
  pushl $128
80107112:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107117:	e9 34 f5 ff ff       	jmp    80106650 <alltraps>

8010711c <vector129>:
.globl vector129
vector129:
  pushl $0
8010711c:	6a 00                	push   $0x0
  pushl $129
8010711e:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107123:	e9 28 f5 ff ff       	jmp    80106650 <alltraps>

80107128 <vector130>:
.globl vector130
vector130:
  pushl $0
80107128:	6a 00                	push   $0x0
  pushl $130
8010712a:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010712f:	e9 1c f5 ff ff       	jmp    80106650 <alltraps>

80107134 <vector131>:
.globl vector131
vector131:
  pushl $0
80107134:	6a 00                	push   $0x0
  pushl $131
80107136:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010713b:	e9 10 f5 ff ff       	jmp    80106650 <alltraps>

80107140 <vector132>:
.globl vector132
vector132:
  pushl $0
80107140:	6a 00                	push   $0x0
  pushl $132
80107142:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107147:	e9 04 f5 ff ff       	jmp    80106650 <alltraps>

8010714c <vector133>:
.globl vector133
vector133:
  pushl $0
8010714c:	6a 00                	push   $0x0
  pushl $133
8010714e:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107153:	e9 f8 f4 ff ff       	jmp    80106650 <alltraps>

80107158 <vector134>:
.globl vector134
vector134:
  pushl $0
80107158:	6a 00                	push   $0x0
  pushl $134
8010715a:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010715f:	e9 ec f4 ff ff       	jmp    80106650 <alltraps>

80107164 <vector135>:
.globl vector135
vector135:
  pushl $0
80107164:	6a 00                	push   $0x0
  pushl $135
80107166:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010716b:	e9 e0 f4 ff ff       	jmp    80106650 <alltraps>

80107170 <vector136>:
.globl vector136
vector136:
  pushl $0
80107170:	6a 00                	push   $0x0
  pushl $136
80107172:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107177:	e9 d4 f4 ff ff       	jmp    80106650 <alltraps>

8010717c <vector137>:
.globl vector137
vector137:
  pushl $0
8010717c:	6a 00                	push   $0x0
  pushl $137
8010717e:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107183:	e9 c8 f4 ff ff       	jmp    80106650 <alltraps>

80107188 <vector138>:
.globl vector138
vector138:
  pushl $0
80107188:	6a 00                	push   $0x0
  pushl $138
8010718a:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010718f:	e9 bc f4 ff ff       	jmp    80106650 <alltraps>

80107194 <vector139>:
.globl vector139
vector139:
  pushl $0
80107194:	6a 00                	push   $0x0
  pushl $139
80107196:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010719b:	e9 b0 f4 ff ff       	jmp    80106650 <alltraps>

801071a0 <vector140>:
.globl vector140
vector140:
  pushl $0
801071a0:	6a 00                	push   $0x0
  pushl $140
801071a2:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801071a7:	e9 a4 f4 ff ff       	jmp    80106650 <alltraps>

801071ac <vector141>:
.globl vector141
vector141:
  pushl $0
801071ac:	6a 00                	push   $0x0
  pushl $141
801071ae:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801071b3:	e9 98 f4 ff ff       	jmp    80106650 <alltraps>

801071b8 <vector142>:
.globl vector142
vector142:
  pushl $0
801071b8:	6a 00                	push   $0x0
  pushl $142
801071ba:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801071bf:	e9 8c f4 ff ff       	jmp    80106650 <alltraps>

801071c4 <vector143>:
.globl vector143
vector143:
  pushl $0
801071c4:	6a 00                	push   $0x0
  pushl $143
801071c6:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801071cb:	e9 80 f4 ff ff       	jmp    80106650 <alltraps>

801071d0 <vector144>:
.globl vector144
vector144:
  pushl $0
801071d0:	6a 00                	push   $0x0
  pushl $144
801071d2:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801071d7:	e9 74 f4 ff ff       	jmp    80106650 <alltraps>

801071dc <vector145>:
.globl vector145
vector145:
  pushl $0
801071dc:	6a 00                	push   $0x0
  pushl $145
801071de:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801071e3:	e9 68 f4 ff ff       	jmp    80106650 <alltraps>

801071e8 <vector146>:
.globl vector146
vector146:
  pushl $0
801071e8:	6a 00                	push   $0x0
  pushl $146
801071ea:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801071ef:	e9 5c f4 ff ff       	jmp    80106650 <alltraps>

801071f4 <vector147>:
.globl vector147
vector147:
  pushl $0
801071f4:	6a 00                	push   $0x0
  pushl $147
801071f6:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801071fb:	e9 50 f4 ff ff       	jmp    80106650 <alltraps>

80107200 <vector148>:
.globl vector148
vector148:
  pushl $0
80107200:	6a 00                	push   $0x0
  pushl $148
80107202:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107207:	e9 44 f4 ff ff       	jmp    80106650 <alltraps>

8010720c <vector149>:
.globl vector149
vector149:
  pushl $0
8010720c:	6a 00                	push   $0x0
  pushl $149
8010720e:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107213:	e9 38 f4 ff ff       	jmp    80106650 <alltraps>

80107218 <vector150>:
.globl vector150
vector150:
  pushl $0
80107218:	6a 00                	push   $0x0
  pushl $150
8010721a:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010721f:	e9 2c f4 ff ff       	jmp    80106650 <alltraps>

80107224 <vector151>:
.globl vector151
vector151:
  pushl $0
80107224:	6a 00                	push   $0x0
  pushl $151
80107226:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010722b:	e9 20 f4 ff ff       	jmp    80106650 <alltraps>

80107230 <vector152>:
.globl vector152
vector152:
  pushl $0
80107230:	6a 00                	push   $0x0
  pushl $152
80107232:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107237:	e9 14 f4 ff ff       	jmp    80106650 <alltraps>

8010723c <vector153>:
.globl vector153
vector153:
  pushl $0
8010723c:	6a 00                	push   $0x0
  pushl $153
8010723e:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107243:	e9 08 f4 ff ff       	jmp    80106650 <alltraps>

80107248 <vector154>:
.globl vector154
vector154:
  pushl $0
80107248:	6a 00                	push   $0x0
  pushl $154
8010724a:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010724f:	e9 fc f3 ff ff       	jmp    80106650 <alltraps>

80107254 <vector155>:
.globl vector155
vector155:
  pushl $0
80107254:	6a 00                	push   $0x0
  pushl $155
80107256:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010725b:	e9 f0 f3 ff ff       	jmp    80106650 <alltraps>

80107260 <vector156>:
.globl vector156
vector156:
  pushl $0
80107260:	6a 00                	push   $0x0
  pushl $156
80107262:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107267:	e9 e4 f3 ff ff       	jmp    80106650 <alltraps>

8010726c <vector157>:
.globl vector157
vector157:
  pushl $0
8010726c:	6a 00                	push   $0x0
  pushl $157
8010726e:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107273:	e9 d8 f3 ff ff       	jmp    80106650 <alltraps>

80107278 <vector158>:
.globl vector158
vector158:
  pushl $0
80107278:	6a 00                	push   $0x0
  pushl $158
8010727a:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010727f:	e9 cc f3 ff ff       	jmp    80106650 <alltraps>

80107284 <vector159>:
.globl vector159
vector159:
  pushl $0
80107284:	6a 00                	push   $0x0
  pushl $159
80107286:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010728b:	e9 c0 f3 ff ff       	jmp    80106650 <alltraps>

80107290 <vector160>:
.globl vector160
vector160:
  pushl $0
80107290:	6a 00                	push   $0x0
  pushl $160
80107292:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107297:	e9 b4 f3 ff ff       	jmp    80106650 <alltraps>

8010729c <vector161>:
.globl vector161
vector161:
  pushl $0
8010729c:	6a 00                	push   $0x0
  pushl $161
8010729e:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801072a3:	e9 a8 f3 ff ff       	jmp    80106650 <alltraps>

801072a8 <vector162>:
.globl vector162
vector162:
  pushl $0
801072a8:	6a 00                	push   $0x0
  pushl $162
801072aa:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801072af:	e9 9c f3 ff ff       	jmp    80106650 <alltraps>

801072b4 <vector163>:
.globl vector163
vector163:
  pushl $0
801072b4:	6a 00                	push   $0x0
  pushl $163
801072b6:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801072bb:	e9 90 f3 ff ff       	jmp    80106650 <alltraps>

801072c0 <vector164>:
.globl vector164
vector164:
  pushl $0
801072c0:	6a 00                	push   $0x0
  pushl $164
801072c2:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801072c7:	e9 84 f3 ff ff       	jmp    80106650 <alltraps>

801072cc <vector165>:
.globl vector165
vector165:
  pushl $0
801072cc:	6a 00                	push   $0x0
  pushl $165
801072ce:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801072d3:	e9 78 f3 ff ff       	jmp    80106650 <alltraps>

801072d8 <vector166>:
.globl vector166
vector166:
  pushl $0
801072d8:	6a 00                	push   $0x0
  pushl $166
801072da:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801072df:	e9 6c f3 ff ff       	jmp    80106650 <alltraps>

801072e4 <vector167>:
.globl vector167
vector167:
  pushl $0
801072e4:	6a 00                	push   $0x0
  pushl $167
801072e6:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801072eb:	e9 60 f3 ff ff       	jmp    80106650 <alltraps>

801072f0 <vector168>:
.globl vector168
vector168:
  pushl $0
801072f0:	6a 00                	push   $0x0
  pushl $168
801072f2:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801072f7:	e9 54 f3 ff ff       	jmp    80106650 <alltraps>

801072fc <vector169>:
.globl vector169
vector169:
  pushl $0
801072fc:	6a 00                	push   $0x0
  pushl $169
801072fe:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107303:	e9 48 f3 ff ff       	jmp    80106650 <alltraps>

80107308 <vector170>:
.globl vector170
vector170:
  pushl $0
80107308:	6a 00                	push   $0x0
  pushl $170
8010730a:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010730f:	e9 3c f3 ff ff       	jmp    80106650 <alltraps>

80107314 <vector171>:
.globl vector171
vector171:
  pushl $0
80107314:	6a 00                	push   $0x0
  pushl $171
80107316:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010731b:	e9 30 f3 ff ff       	jmp    80106650 <alltraps>

80107320 <vector172>:
.globl vector172
vector172:
  pushl $0
80107320:	6a 00                	push   $0x0
  pushl $172
80107322:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107327:	e9 24 f3 ff ff       	jmp    80106650 <alltraps>

8010732c <vector173>:
.globl vector173
vector173:
  pushl $0
8010732c:	6a 00                	push   $0x0
  pushl $173
8010732e:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107333:	e9 18 f3 ff ff       	jmp    80106650 <alltraps>

80107338 <vector174>:
.globl vector174
vector174:
  pushl $0
80107338:	6a 00                	push   $0x0
  pushl $174
8010733a:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010733f:	e9 0c f3 ff ff       	jmp    80106650 <alltraps>

80107344 <vector175>:
.globl vector175
vector175:
  pushl $0
80107344:	6a 00                	push   $0x0
  pushl $175
80107346:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010734b:	e9 00 f3 ff ff       	jmp    80106650 <alltraps>

80107350 <vector176>:
.globl vector176
vector176:
  pushl $0
80107350:	6a 00                	push   $0x0
  pushl $176
80107352:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107357:	e9 f4 f2 ff ff       	jmp    80106650 <alltraps>

8010735c <vector177>:
.globl vector177
vector177:
  pushl $0
8010735c:	6a 00                	push   $0x0
  pushl $177
8010735e:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107363:	e9 e8 f2 ff ff       	jmp    80106650 <alltraps>

80107368 <vector178>:
.globl vector178
vector178:
  pushl $0
80107368:	6a 00                	push   $0x0
  pushl $178
8010736a:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010736f:	e9 dc f2 ff ff       	jmp    80106650 <alltraps>

80107374 <vector179>:
.globl vector179
vector179:
  pushl $0
80107374:	6a 00                	push   $0x0
  pushl $179
80107376:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010737b:	e9 d0 f2 ff ff       	jmp    80106650 <alltraps>

80107380 <vector180>:
.globl vector180
vector180:
  pushl $0
80107380:	6a 00                	push   $0x0
  pushl $180
80107382:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107387:	e9 c4 f2 ff ff       	jmp    80106650 <alltraps>

8010738c <vector181>:
.globl vector181
vector181:
  pushl $0
8010738c:	6a 00                	push   $0x0
  pushl $181
8010738e:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107393:	e9 b8 f2 ff ff       	jmp    80106650 <alltraps>

80107398 <vector182>:
.globl vector182
vector182:
  pushl $0
80107398:	6a 00                	push   $0x0
  pushl $182
8010739a:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010739f:	e9 ac f2 ff ff       	jmp    80106650 <alltraps>

801073a4 <vector183>:
.globl vector183
vector183:
  pushl $0
801073a4:	6a 00                	push   $0x0
  pushl $183
801073a6:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801073ab:	e9 a0 f2 ff ff       	jmp    80106650 <alltraps>

801073b0 <vector184>:
.globl vector184
vector184:
  pushl $0
801073b0:	6a 00                	push   $0x0
  pushl $184
801073b2:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801073b7:	e9 94 f2 ff ff       	jmp    80106650 <alltraps>

801073bc <vector185>:
.globl vector185
vector185:
  pushl $0
801073bc:	6a 00                	push   $0x0
  pushl $185
801073be:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801073c3:	e9 88 f2 ff ff       	jmp    80106650 <alltraps>

801073c8 <vector186>:
.globl vector186
vector186:
  pushl $0
801073c8:	6a 00                	push   $0x0
  pushl $186
801073ca:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801073cf:	e9 7c f2 ff ff       	jmp    80106650 <alltraps>

801073d4 <vector187>:
.globl vector187
vector187:
  pushl $0
801073d4:	6a 00                	push   $0x0
  pushl $187
801073d6:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801073db:	e9 70 f2 ff ff       	jmp    80106650 <alltraps>

801073e0 <vector188>:
.globl vector188
vector188:
  pushl $0
801073e0:	6a 00                	push   $0x0
  pushl $188
801073e2:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801073e7:	e9 64 f2 ff ff       	jmp    80106650 <alltraps>

801073ec <vector189>:
.globl vector189
vector189:
  pushl $0
801073ec:	6a 00                	push   $0x0
  pushl $189
801073ee:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801073f3:	e9 58 f2 ff ff       	jmp    80106650 <alltraps>

801073f8 <vector190>:
.globl vector190
vector190:
  pushl $0
801073f8:	6a 00                	push   $0x0
  pushl $190
801073fa:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801073ff:	e9 4c f2 ff ff       	jmp    80106650 <alltraps>

80107404 <vector191>:
.globl vector191
vector191:
  pushl $0
80107404:	6a 00                	push   $0x0
  pushl $191
80107406:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010740b:	e9 40 f2 ff ff       	jmp    80106650 <alltraps>

80107410 <vector192>:
.globl vector192
vector192:
  pushl $0
80107410:	6a 00                	push   $0x0
  pushl $192
80107412:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107417:	e9 34 f2 ff ff       	jmp    80106650 <alltraps>

8010741c <vector193>:
.globl vector193
vector193:
  pushl $0
8010741c:	6a 00                	push   $0x0
  pushl $193
8010741e:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107423:	e9 28 f2 ff ff       	jmp    80106650 <alltraps>

80107428 <vector194>:
.globl vector194
vector194:
  pushl $0
80107428:	6a 00                	push   $0x0
  pushl $194
8010742a:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010742f:	e9 1c f2 ff ff       	jmp    80106650 <alltraps>

80107434 <vector195>:
.globl vector195
vector195:
  pushl $0
80107434:	6a 00                	push   $0x0
  pushl $195
80107436:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010743b:	e9 10 f2 ff ff       	jmp    80106650 <alltraps>

80107440 <vector196>:
.globl vector196
vector196:
  pushl $0
80107440:	6a 00                	push   $0x0
  pushl $196
80107442:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107447:	e9 04 f2 ff ff       	jmp    80106650 <alltraps>

8010744c <vector197>:
.globl vector197
vector197:
  pushl $0
8010744c:	6a 00                	push   $0x0
  pushl $197
8010744e:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107453:	e9 f8 f1 ff ff       	jmp    80106650 <alltraps>

80107458 <vector198>:
.globl vector198
vector198:
  pushl $0
80107458:	6a 00                	push   $0x0
  pushl $198
8010745a:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010745f:	e9 ec f1 ff ff       	jmp    80106650 <alltraps>

80107464 <vector199>:
.globl vector199
vector199:
  pushl $0
80107464:	6a 00                	push   $0x0
  pushl $199
80107466:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010746b:	e9 e0 f1 ff ff       	jmp    80106650 <alltraps>

80107470 <vector200>:
.globl vector200
vector200:
  pushl $0
80107470:	6a 00                	push   $0x0
  pushl $200
80107472:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107477:	e9 d4 f1 ff ff       	jmp    80106650 <alltraps>

8010747c <vector201>:
.globl vector201
vector201:
  pushl $0
8010747c:	6a 00                	push   $0x0
  pushl $201
8010747e:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107483:	e9 c8 f1 ff ff       	jmp    80106650 <alltraps>

80107488 <vector202>:
.globl vector202
vector202:
  pushl $0
80107488:	6a 00                	push   $0x0
  pushl $202
8010748a:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010748f:	e9 bc f1 ff ff       	jmp    80106650 <alltraps>

80107494 <vector203>:
.globl vector203
vector203:
  pushl $0
80107494:	6a 00                	push   $0x0
  pushl $203
80107496:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010749b:	e9 b0 f1 ff ff       	jmp    80106650 <alltraps>

801074a0 <vector204>:
.globl vector204
vector204:
  pushl $0
801074a0:	6a 00                	push   $0x0
  pushl $204
801074a2:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801074a7:	e9 a4 f1 ff ff       	jmp    80106650 <alltraps>

801074ac <vector205>:
.globl vector205
vector205:
  pushl $0
801074ac:	6a 00                	push   $0x0
  pushl $205
801074ae:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801074b3:	e9 98 f1 ff ff       	jmp    80106650 <alltraps>

801074b8 <vector206>:
.globl vector206
vector206:
  pushl $0
801074b8:	6a 00                	push   $0x0
  pushl $206
801074ba:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801074bf:	e9 8c f1 ff ff       	jmp    80106650 <alltraps>

801074c4 <vector207>:
.globl vector207
vector207:
  pushl $0
801074c4:	6a 00                	push   $0x0
  pushl $207
801074c6:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801074cb:	e9 80 f1 ff ff       	jmp    80106650 <alltraps>

801074d0 <vector208>:
.globl vector208
vector208:
  pushl $0
801074d0:	6a 00                	push   $0x0
  pushl $208
801074d2:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801074d7:	e9 74 f1 ff ff       	jmp    80106650 <alltraps>

801074dc <vector209>:
.globl vector209
vector209:
  pushl $0
801074dc:	6a 00                	push   $0x0
  pushl $209
801074de:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801074e3:	e9 68 f1 ff ff       	jmp    80106650 <alltraps>

801074e8 <vector210>:
.globl vector210
vector210:
  pushl $0
801074e8:	6a 00                	push   $0x0
  pushl $210
801074ea:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801074ef:	e9 5c f1 ff ff       	jmp    80106650 <alltraps>

801074f4 <vector211>:
.globl vector211
vector211:
  pushl $0
801074f4:	6a 00                	push   $0x0
  pushl $211
801074f6:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801074fb:	e9 50 f1 ff ff       	jmp    80106650 <alltraps>

80107500 <vector212>:
.globl vector212
vector212:
  pushl $0
80107500:	6a 00                	push   $0x0
  pushl $212
80107502:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107507:	e9 44 f1 ff ff       	jmp    80106650 <alltraps>

8010750c <vector213>:
.globl vector213
vector213:
  pushl $0
8010750c:	6a 00                	push   $0x0
  pushl $213
8010750e:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107513:	e9 38 f1 ff ff       	jmp    80106650 <alltraps>

80107518 <vector214>:
.globl vector214
vector214:
  pushl $0
80107518:	6a 00                	push   $0x0
  pushl $214
8010751a:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010751f:	e9 2c f1 ff ff       	jmp    80106650 <alltraps>

80107524 <vector215>:
.globl vector215
vector215:
  pushl $0
80107524:	6a 00                	push   $0x0
  pushl $215
80107526:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010752b:	e9 20 f1 ff ff       	jmp    80106650 <alltraps>

80107530 <vector216>:
.globl vector216
vector216:
  pushl $0
80107530:	6a 00                	push   $0x0
  pushl $216
80107532:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107537:	e9 14 f1 ff ff       	jmp    80106650 <alltraps>

8010753c <vector217>:
.globl vector217
vector217:
  pushl $0
8010753c:	6a 00                	push   $0x0
  pushl $217
8010753e:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107543:	e9 08 f1 ff ff       	jmp    80106650 <alltraps>

80107548 <vector218>:
.globl vector218
vector218:
  pushl $0
80107548:	6a 00                	push   $0x0
  pushl $218
8010754a:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010754f:	e9 fc f0 ff ff       	jmp    80106650 <alltraps>

80107554 <vector219>:
.globl vector219
vector219:
  pushl $0
80107554:	6a 00                	push   $0x0
  pushl $219
80107556:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010755b:	e9 f0 f0 ff ff       	jmp    80106650 <alltraps>

80107560 <vector220>:
.globl vector220
vector220:
  pushl $0
80107560:	6a 00                	push   $0x0
  pushl $220
80107562:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107567:	e9 e4 f0 ff ff       	jmp    80106650 <alltraps>

8010756c <vector221>:
.globl vector221
vector221:
  pushl $0
8010756c:	6a 00                	push   $0x0
  pushl $221
8010756e:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107573:	e9 d8 f0 ff ff       	jmp    80106650 <alltraps>

80107578 <vector222>:
.globl vector222
vector222:
  pushl $0
80107578:	6a 00                	push   $0x0
  pushl $222
8010757a:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010757f:	e9 cc f0 ff ff       	jmp    80106650 <alltraps>

80107584 <vector223>:
.globl vector223
vector223:
  pushl $0
80107584:	6a 00                	push   $0x0
  pushl $223
80107586:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010758b:	e9 c0 f0 ff ff       	jmp    80106650 <alltraps>

80107590 <vector224>:
.globl vector224
vector224:
  pushl $0
80107590:	6a 00                	push   $0x0
  pushl $224
80107592:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107597:	e9 b4 f0 ff ff       	jmp    80106650 <alltraps>

8010759c <vector225>:
.globl vector225
vector225:
  pushl $0
8010759c:	6a 00                	push   $0x0
  pushl $225
8010759e:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801075a3:	e9 a8 f0 ff ff       	jmp    80106650 <alltraps>

801075a8 <vector226>:
.globl vector226
vector226:
  pushl $0
801075a8:	6a 00                	push   $0x0
  pushl $226
801075aa:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801075af:	e9 9c f0 ff ff       	jmp    80106650 <alltraps>

801075b4 <vector227>:
.globl vector227
vector227:
  pushl $0
801075b4:	6a 00                	push   $0x0
  pushl $227
801075b6:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801075bb:	e9 90 f0 ff ff       	jmp    80106650 <alltraps>

801075c0 <vector228>:
.globl vector228
vector228:
  pushl $0
801075c0:	6a 00                	push   $0x0
  pushl $228
801075c2:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801075c7:	e9 84 f0 ff ff       	jmp    80106650 <alltraps>

801075cc <vector229>:
.globl vector229
vector229:
  pushl $0
801075cc:	6a 00                	push   $0x0
  pushl $229
801075ce:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801075d3:	e9 78 f0 ff ff       	jmp    80106650 <alltraps>

801075d8 <vector230>:
.globl vector230
vector230:
  pushl $0
801075d8:	6a 00                	push   $0x0
  pushl $230
801075da:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801075df:	e9 6c f0 ff ff       	jmp    80106650 <alltraps>

801075e4 <vector231>:
.globl vector231
vector231:
  pushl $0
801075e4:	6a 00                	push   $0x0
  pushl $231
801075e6:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801075eb:	e9 60 f0 ff ff       	jmp    80106650 <alltraps>

801075f0 <vector232>:
.globl vector232
vector232:
  pushl $0
801075f0:	6a 00                	push   $0x0
  pushl $232
801075f2:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801075f7:	e9 54 f0 ff ff       	jmp    80106650 <alltraps>

801075fc <vector233>:
.globl vector233
vector233:
  pushl $0
801075fc:	6a 00                	push   $0x0
  pushl $233
801075fe:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107603:	e9 48 f0 ff ff       	jmp    80106650 <alltraps>

80107608 <vector234>:
.globl vector234
vector234:
  pushl $0
80107608:	6a 00                	push   $0x0
  pushl $234
8010760a:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010760f:	e9 3c f0 ff ff       	jmp    80106650 <alltraps>

80107614 <vector235>:
.globl vector235
vector235:
  pushl $0
80107614:	6a 00                	push   $0x0
  pushl $235
80107616:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010761b:	e9 30 f0 ff ff       	jmp    80106650 <alltraps>

80107620 <vector236>:
.globl vector236
vector236:
  pushl $0
80107620:	6a 00                	push   $0x0
  pushl $236
80107622:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107627:	e9 24 f0 ff ff       	jmp    80106650 <alltraps>

8010762c <vector237>:
.globl vector237
vector237:
  pushl $0
8010762c:	6a 00                	push   $0x0
  pushl $237
8010762e:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107633:	e9 18 f0 ff ff       	jmp    80106650 <alltraps>

80107638 <vector238>:
.globl vector238
vector238:
  pushl $0
80107638:	6a 00                	push   $0x0
  pushl $238
8010763a:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010763f:	e9 0c f0 ff ff       	jmp    80106650 <alltraps>

80107644 <vector239>:
.globl vector239
vector239:
  pushl $0
80107644:	6a 00                	push   $0x0
  pushl $239
80107646:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010764b:	e9 00 f0 ff ff       	jmp    80106650 <alltraps>

80107650 <vector240>:
.globl vector240
vector240:
  pushl $0
80107650:	6a 00                	push   $0x0
  pushl $240
80107652:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107657:	e9 f4 ef ff ff       	jmp    80106650 <alltraps>

8010765c <vector241>:
.globl vector241
vector241:
  pushl $0
8010765c:	6a 00                	push   $0x0
  pushl $241
8010765e:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107663:	e9 e8 ef ff ff       	jmp    80106650 <alltraps>

80107668 <vector242>:
.globl vector242
vector242:
  pushl $0
80107668:	6a 00                	push   $0x0
  pushl $242
8010766a:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010766f:	e9 dc ef ff ff       	jmp    80106650 <alltraps>

80107674 <vector243>:
.globl vector243
vector243:
  pushl $0
80107674:	6a 00                	push   $0x0
  pushl $243
80107676:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010767b:	e9 d0 ef ff ff       	jmp    80106650 <alltraps>

80107680 <vector244>:
.globl vector244
vector244:
  pushl $0
80107680:	6a 00                	push   $0x0
  pushl $244
80107682:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107687:	e9 c4 ef ff ff       	jmp    80106650 <alltraps>

8010768c <vector245>:
.globl vector245
vector245:
  pushl $0
8010768c:	6a 00                	push   $0x0
  pushl $245
8010768e:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107693:	e9 b8 ef ff ff       	jmp    80106650 <alltraps>

80107698 <vector246>:
.globl vector246
vector246:
  pushl $0
80107698:	6a 00                	push   $0x0
  pushl $246
8010769a:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010769f:	e9 ac ef ff ff       	jmp    80106650 <alltraps>

801076a4 <vector247>:
.globl vector247
vector247:
  pushl $0
801076a4:	6a 00                	push   $0x0
  pushl $247
801076a6:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801076ab:	e9 a0 ef ff ff       	jmp    80106650 <alltraps>

801076b0 <vector248>:
.globl vector248
vector248:
  pushl $0
801076b0:	6a 00                	push   $0x0
  pushl $248
801076b2:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801076b7:	e9 94 ef ff ff       	jmp    80106650 <alltraps>

801076bc <vector249>:
.globl vector249
vector249:
  pushl $0
801076bc:	6a 00                	push   $0x0
  pushl $249
801076be:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801076c3:	e9 88 ef ff ff       	jmp    80106650 <alltraps>

801076c8 <vector250>:
.globl vector250
vector250:
  pushl $0
801076c8:	6a 00                	push   $0x0
  pushl $250
801076ca:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801076cf:	e9 7c ef ff ff       	jmp    80106650 <alltraps>

801076d4 <vector251>:
.globl vector251
vector251:
  pushl $0
801076d4:	6a 00                	push   $0x0
  pushl $251
801076d6:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801076db:	e9 70 ef ff ff       	jmp    80106650 <alltraps>

801076e0 <vector252>:
.globl vector252
vector252:
  pushl $0
801076e0:	6a 00                	push   $0x0
  pushl $252
801076e2:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801076e7:	e9 64 ef ff ff       	jmp    80106650 <alltraps>

801076ec <vector253>:
.globl vector253
vector253:
  pushl $0
801076ec:	6a 00                	push   $0x0
  pushl $253
801076ee:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801076f3:	e9 58 ef ff ff       	jmp    80106650 <alltraps>

801076f8 <vector254>:
.globl vector254
vector254:
  pushl $0
801076f8:	6a 00                	push   $0x0
  pushl $254
801076fa:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801076ff:	e9 4c ef ff ff       	jmp    80106650 <alltraps>

80107704 <vector255>:
.globl vector255
vector255:
  pushl $0
80107704:	6a 00                	push   $0x0
  pushl $255
80107706:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010770b:	e9 40 ef ff ff       	jmp    80106650 <alltraps>

80107710 <lgdt>:
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107716:	8b 45 0c             	mov    0xc(%ebp),%eax
80107719:	83 e8 01             	sub    $0x1,%eax
8010771c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107720:	8b 45 08             	mov    0x8(%ebp),%eax
80107723:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107727:	8b 45 08             	mov    0x8(%ebp),%eax
8010772a:	c1 e8 10             	shr    $0x10,%eax
8010772d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107731:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107734:	0f 01 10             	lgdtl  (%eax)
}
80107737:	c9                   	leave  
80107738:	c3                   	ret    

80107739 <ltr>:
{
80107739:	55                   	push   %ebp
8010773a:	89 e5                	mov    %esp,%ebp
8010773c:	83 ec 04             	sub    $0x4,%esp
8010773f:	8b 45 08             	mov    0x8(%ebp),%eax
80107742:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107746:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010774a:	0f 00 d8             	ltr    %ax
}
8010774d:	c9                   	leave  
8010774e:	c3                   	ret    

8010774f <lcr3>:

static inline void
lcr3(uint val)
{
8010774f:	55                   	push   %ebp
80107750:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107752:	8b 45 08             	mov    0x8(%ebp),%eax
80107755:	0f 22 d8             	mov    %eax,%cr3
}
80107758:	5d                   	pop    %ebp
80107759:	c3                   	ret    

8010775a <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010775a:	55                   	push   %ebp
8010775b:	89 e5                	mov    %esp,%ebp
8010775d:	83 ec 28             	sub    $0x28,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107760:	e8 b2 ca ff ff       	call   80104217 <cpuid>
80107765:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010776b:	05 20 38 11 80       	add    $0x80113820,%eax
80107770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107776:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010777c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010777f:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107788:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010778c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010778f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107793:	83 e2 f0             	and    $0xfffffff0,%edx
80107796:	83 ca 0a             	or     $0xa,%edx
80107799:	88 50 7d             	mov    %dl,0x7d(%eax)
8010779c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077a3:	83 ca 10             	or     $0x10,%edx
801077a6:	88 50 7d             	mov    %dl,0x7d(%eax)
801077a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ac:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077b0:	83 e2 9f             	and    $0xffffff9f,%edx
801077b3:	88 50 7d             	mov    %dl,0x7d(%eax)
801077b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b9:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077bd:	83 ca 80             	or     $0xffffff80,%edx
801077c0:	88 50 7d             	mov    %dl,0x7d(%eax)
801077c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077ca:	83 ca 0f             	or     $0xf,%edx
801077cd:	88 50 7e             	mov    %dl,0x7e(%eax)
801077d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077d7:	83 e2 ef             	and    $0xffffffef,%edx
801077da:	88 50 7e             	mov    %dl,0x7e(%eax)
801077dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077e4:	83 e2 df             	and    $0xffffffdf,%edx
801077e7:	88 50 7e             	mov    %dl,0x7e(%eax)
801077ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ed:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077f1:	83 ca 40             	or     $0x40,%edx
801077f4:	88 50 7e             	mov    %dl,0x7e(%eax)
801077f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077fa:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077fe:	83 ca 80             	or     $0xffffff80,%edx
80107801:	88 50 7e             	mov    %dl,0x7e(%eax)
80107804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107807:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010780b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780e:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107815:	ff ff 
80107817:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010781a:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107821:	00 00 
80107823:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107826:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010782d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107830:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107837:	83 e2 f0             	and    $0xfffffff0,%edx
8010783a:	83 ca 02             	or     $0x2,%edx
8010783d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107846:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010784d:	83 ca 10             	or     $0x10,%edx
80107850:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107859:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107860:	83 e2 9f             	and    $0xffffff9f,%edx
80107863:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107869:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010786c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107873:	83 ca 80             	or     $0xffffff80,%edx
80107876:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010787c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107886:	83 ca 0f             	or     $0xf,%edx
80107889:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010788f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107892:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107899:	83 e2 ef             	and    $0xffffffef,%edx
8010789c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078ac:	83 e2 df             	and    $0xffffffdf,%edx
801078af:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b8:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078bf:	83 ca 40             	or     $0x40,%edx
801078c2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078cb:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078d2:	83 ca 80             	or     $0xffffff80,%edx
801078d5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078de:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801078e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e8:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801078ef:	ff ff 
801078f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f4:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
801078fb:	00 00 
801078fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107900:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010790a:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107911:	83 e2 f0             	and    $0xfffffff0,%edx
80107914:	83 ca 0a             	or     $0xa,%edx
80107917:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010791d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107920:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107927:	83 ca 10             	or     $0x10,%edx
8010792a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107933:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010793a:	83 ca 60             	or     $0x60,%edx
8010793d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107943:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107946:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010794d:	83 ca 80             	or     $0xffffff80,%edx
80107950:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107956:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107959:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107960:	83 ca 0f             	or     $0xf,%edx
80107963:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107973:	83 e2 ef             	and    $0xffffffef,%edx
80107976:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010797c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010797f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107986:	83 e2 df             	and    $0xffffffdf,%edx
80107989:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010798f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107992:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107999:	83 ca 40             	or     $0x40,%edx
8010799c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801079a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a5:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801079ac:	83 ca 80             	or     $0xffffff80,%edx
801079af:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801079b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b8:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801079bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c2:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801079c9:	ff ff 
801079cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ce:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801079d5:	00 00 
801079d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079da:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801079e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e4:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801079eb:	83 e2 f0             	and    $0xfffffff0,%edx
801079ee:	83 ca 02             	or     $0x2,%edx
801079f1:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801079f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079fa:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a01:	83 ca 10             	or     $0x10,%edx
80107a04:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a0d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a14:	83 ca 60             	or     $0x60,%edx
80107a17:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a20:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a27:	83 ca 80             	or     $0xffffff80,%edx
80107a2a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a33:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107a3a:	83 ca 0f             	or     $0xf,%edx
80107a3d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a46:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107a4d:	83 e2 ef             	and    $0xffffffef,%edx
80107a50:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a59:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107a60:	83 e2 df             	and    $0xffffffdf,%edx
80107a63:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107a73:	83 ca 40             	or     $0x40,%edx
80107a76:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a7f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107a86:	83 ca 80             	or     $0xffffff80,%edx
80107a89:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a92:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a9c:	83 c0 70             	add    $0x70,%eax
80107a9f:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80107aa6:	00 
80107aa7:	89 04 24             	mov    %eax,(%esp)
80107aaa:	e8 61 fc ff ff       	call   80107710 <lgdt>
}
80107aaf:	c9                   	leave  
80107ab0:	c3                   	ret    

80107ab1 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107ab1:	55                   	push   %ebp
80107ab2:	89 e5                	mov    %esp,%ebp
80107ab4:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aba:	c1 e8 16             	shr    $0x16,%eax
80107abd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80107ac7:	01 d0                	add    %edx,%eax
80107ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107acf:	8b 00                	mov    (%eax),%eax
80107ad1:	83 e0 01             	and    $0x1,%eax
80107ad4:	85 c0                	test   %eax,%eax
80107ad6:	74 14                	je     80107aec <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107adb:	8b 00                	mov    (%eax),%eax
80107add:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ae2:	05 00 00 00 80       	add    $0x80000000,%eax
80107ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107aea:	eb 48                	jmp    80107b34 <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107aec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107af0:	74 0e                	je     80107b00 <walkpgdir+0x4f>
80107af2:	e8 b2 b0 ff ff       	call   80102ba9 <kalloc>
80107af7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107afe:	75 07                	jne    80107b07 <walkpgdir+0x56>
      return 0;
80107b00:	b8 00 00 00 00       	mov    $0x0,%eax
80107b05:	eb 44                	jmp    80107b4b <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107b07:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107b0e:	00 
80107b0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107b16:	00 
80107b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1a:	89 04 24             	mov    %eax,(%esp)
80107b1d:	e8 0f d7 ff ff       	call   80105231 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b25:	05 00 00 00 80       	add    $0x80000000,%eax
80107b2a:	83 c8 07             	or     $0x7,%eax
80107b2d:	89 c2                	mov    %eax,%edx
80107b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b32:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107b34:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b37:	c1 e8 0c             	shr    $0xc,%eax
80107b3a:	25 ff 03 00 00       	and    $0x3ff,%eax
80107b3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b49:	01 d0                	add    %edx,%eax
}
80107b4b:	c9                   	leave  
80107b4c:	c3                   	ret    

80107b4d <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107b4d:	55                   	push   %ebp
80107b4e:	89 e5                	mov    %esp,%ebp
80107b50:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107b53:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b56:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b61:	8b 45 10             	mov    0x10(%ebp),%eax
80107b64:	01 d0                	add    %edx,%eax
80107b66:	83 e8 01             	sub    $0x1,%eax
80107b69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107b71:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107b78:	00 
80107b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80107b80:	8b 45 08             	mov    0x8(%ebp),%eax
80107b83:	89 04 24             	mov    %eax,(%esp)
80107b86:	e8 26 ff ff ff       	call   80107ab1 <walkpgdir>
80107b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107b8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107b92:	75 07                	jne    80107b9b <mappages+0x4e>
      return -1;
80107b94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b99:	eb 48                	jmp    80107be3 <mappages+0x96>
    if(*pte & PTE_P)
80107b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b9e:	8b 00                	mov    (%eax),%eax
80107ba0:	83 e0 01             	and    $0x1,%eax
80107ba3:	85 c0                	test   %eax,%eax
80107ba5:	74 0c                	je     80107bb3 <mappages+0x66>
      panic("remap");
80107ba7:	c7 04 24 c4 8a 10 80 	movl   $0x80108ac4,(%esp)
80107bae:	e8 af 89 ff ff       	call   80100562 <panic>
    *pte = pa | perm | PTE_P;
80107bb3:	8b 45 18             	mov    0x18(%ebp),%eax
80107bb6:	0b 45 14             	or     0x14(%ebp),%eax
80107bb9:	83 c8 01             	or     $0x1,%eax
80107bbc:	89 c2                	mov    %eax,%edx
80107bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107bc1:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107bc9:	75 08                	jne    80107bd3 <mappages+0x86>
      break;
80107bcb:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107bcc:	b8 00 00 00 00       	mov    $0x0,%eax
80107bd1:	eb 10                	jmp    80107be3 <mappages+0x96>
    a += PGSIZE;
80107bd3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107bda:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107be1:	eb 8e                	jmp    80107b71 <mappages+0x24>
}
80107be3:	c9                   	leave  
80107be4:	c3                   	ret    

80107be5 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107be5:	55                   	push   %ebp
80107be6:	89 e5                	mov    %esp,%ebp
80107be8:	53                   	push   %ebx
80107be9:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107bec:	e8 b8 af ff ff       	call   80102ba9 <kalloc>
80107bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107bf4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107bf8:	75 0a                	jne    80107c04 <setupkvm+0x1f>
    return 0;
80107bfa:	b8 00 00 00 00       	mov    $0x0,%eax
80107bff:	e9 84 00 00 00       	jmp    80107c88 <setupkvm+0xa3>
  memset(pgdir, 0, PGSIZE);
80107c04:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c0b:	00 
80107c0c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c13:	00 
80107c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c17:	89 04 24             	mov    %eax,(%esp)
80107c1a:	e8 12 d6 ff ff       	call   80105231 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c1f:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107c26:	eb 54                	jmp    80107c7c <setupkvm+0x97>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c2b:	8b 48 0c             	mov    0xc(%eax),%ecx
80107c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c31:	8b 50 04             	mov    0x4(%eax),%edx
80107c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c37:	8b 58 08             	mov    0x8(%eax),%ebx
80107c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c3d:	8b 40 04             	mov    0x4(%eax),%eax
80107c40:	29 c3                	sub    %eax,%ebx
80107c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c45:	8b 00                	mov    (%eax),%eax
80107c47:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107c4b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107c4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107c53:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c5a:	89 04 24             	mov    %eax,(%esp)
80107c5d:	e8 eb fe ff ff       	call   80107b4d <mappages>
80107c62:	85 c0                	test   %eax,%eax
80107c64:	79 12                	jns    80107c78 <setupkvm+0x93>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c69:	89 04 24             	mov    %eax,(%esp)
80107c6c:	e8 26 05 00 00       	call   80108197 <freevm>
      return 0;
80107c71:	b8 00 00 00 00       	mov    $0x0,%eax
80107c76:	eb 10                	jmp    80107c88 <setupkvm+0xa3>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c78:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107c7c:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107c83:	72 a3                	jb     80107c28 <setupkvm+0x43>
    }
  return pgdir;
80107c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107c88:	83 c4 34             	add    $0x34,%esp
80107c8b:	5b                   	pop    %ebx
80107c8c:	5d                   	pop    %ebp
80107c8d:	c3                   	ret    

80107c8e <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107c8e:	55                   	push   %ebp
80107c8f:	89 e5                	mov    %esp,%ebp
80107c91:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107c94:	e8 4c ff ff ff       	call   80107be5 <setupkvm>
80107c99:	a3 44 67 11 80       	mov    %eax,0x80116744
  switchkvm();
80107c9e:	e8 02 00 00 00       	call   80107ca5 <switchkvm>
}
80107ca3:	c9                   	leave  
80107ca4:	c3                   	ret    

80107ca5 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107ca5:	55                   	push   %ebp
80107ca6:	89 e5                	mov    %esp,%ebp
80107ca8:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107cab:	a1 44 67 11 80       	mov    0x80116744,%eax
80107cb0:	05 00 00 00 80       	add    $0x80000000,%eax
80107cb5:	89 04 24             	mov    %eax,(%esp)
80107cb8:	e8 92 fa ff ff       	call   8010774f <lcr3>
}
80107cbd:	c9                   	leave  
80107cbe:	c3                   	ret    

80107cbf <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107cbf:	55                   	push   %ebp
80107cc0:	89 e5                	mov    %esp,%ebp
80107cc2:	57                   	push   %edi
80107cc3:	56                   	push   %esi
80107cc4:	53                   	push   %ebx
80107cc5:	83 ec 1c             	sub    $0x1c,%esp
  if(p == 0)
80107cc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107ccc:	75 0c                	jne    80107cda <switchuvm+0x1b>
    panic("switchuvm: no process");
80107cce:	c7 04 24 ca 8a 10 80 	movl   $0x80108aca,(%esp)
80107cd5:	e8 88 88 ff ff       	call   80100562 <panic>
  if(p->kstack == 0)
80107cda:	8b 45 08             	mov    0x8(%ebp),%eax
80107cdd:	8b 40 08             	mov    0x8(%eax),%eax
80107ce0:	85 c0                	test   %eax,%eax
80107ce2:	75 0c                	jne    80107cf0 <switchuvm+0x31>
    panic("switchuvm: no kstack");
80107ce4:	c7 04 24 e0 8a 10 80 	movl   $0x80108ae0,(%esp)
80107ceb:	e8 72 88 ff ff       	call   80100562 <panic>
  if(p->pgdir == 0)
80107cf0:	8b 45 08             	mov    0x8(%ebp),%eax
80107cf3:	8b 40 04             	mov    0x4(%eax),%eax
80107cf6:	85 c0                	test   %eax,%eax
80107cf8:	75 0c                	jne    80107d06 <switchuvm+0x47>
    panic("switchuvm: no pgdir");
80107cfa:	c7 04 24 f5 8a 10 80 	movl   $0x80108af5,(%esp)
80107d01:	e8 5c 88 ff ff       	call   80100562 <panic>

  pushcli();
80107d06:	e8 21 d4 ff ff       	call   8010512c <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107d0b:	e8 28 c5 ff ff       	call   80104238 <mycpu>
80107d10:	89 c3                	mov    %eax,%ebx
80107d12:	e8 21 c5 ff ff       	call   80104238 <mycpu>
80107d17:	83 c0 08             	add    $0x8,%eax
80107d1a:	89 c7                	mov    %eax,%edi
80107d1c:	e8 17 c5 ff ff       	call   80104238 <mycpu>
80107d21:	83 c0 08             	add    $0x8,%eax
80107d24:	c1 e8 10             	shr    $0x10,%eax
80107d27:	89 c6                	mov    %eax,%esi
80107d29:	e8 0a c5 ff ff       	call   80104238 <mycpu>
80107d2e:	83 c0 08             	add    $0x8,%eax
80107d31:	c1 e8 18             	shr    $0x18,%eax
80107d34:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107d3b:	67 00 
80107d3d:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107d44:	89 f1                	mov    %esi,%ecx
80107d46:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107d4c:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107d53:	83 e2 f0             	and    $0xfffffff0,%edx
80107d56:	83 ca 09             	or     $0x9,%edx
80107d59:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107d5f:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107d66:	83 ca 10             	or     $0x10,%edx
80107d69:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107d6f:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107d76:	83 e2 9f             	and    $0xffffff9f,%edx
80107d79:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107d7f:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107d86:	83 ca 80             	or     $0xffffff80,%edx
80107d89:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107d8f:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107d96:	83 e2 f0             	and    $0xfffffff0,%edx
80107d99:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107d9f:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107da6:	83 e2 ef             	and    $0xffffffef,%edx
80107da9:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107daf:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107db6:	83 e2 df             	and    $0xffffffdf,%edx
80107db9:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107dbf:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107dc6:	83 ca 40             	or     $0x40,%edx
80107dc9:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107dcf:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107dd6:	83 e2 7f             	and    $0x7f,%edx
80107dd9:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107ddf:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107de5:	e8 4e c4 ff ff       	call   80104238 <mycpu>
80107dea:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107df1:	83 e2 ef             	and    $0xffffffef,%edx
80107df4:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107dfa:	e8 39 c4 ff ff       	call   80104238 <mycpu>
80107dff:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107e05:	e8 2e c4 ff ff       	call   80104238 <mycpu>
80107e0a:	8b 55 08             	mov    0x8(%ebp),%edx
80107e0d:	8b 52 08             	mov    0x8(%edx),%edx
80107e10:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107e16:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107e19:	e8 1a c4 ff ff       	call   80104238 <mycpu>
80107e1e:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107e24:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
80107e2b:	e8 09 f9 ff ff       	call   80107739 <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107e30:	8b 45 08             	mov    0x8(%ebp),%eax
80107e33:	8b 40 04             	mov    0x4(%eax),%eax
80107e36:	05 00 00 00 80       	add    $0x80000000,%eax
80107e3b:	89 04 24             	mov    %eax,(%esp)
80107e3e:	e8 0c f9 ff ff       	call   8010774f <lcr3>
  popcli();
80107e43:	e8 30 d3 ff ff       	call   80105178 <popcli>
}
80107e48:	83 c4 1c             	add    $0x1c,%esp
80107e4b:	5b                   	pop    %ebx
80107e4c:	5e                   	pop    %esi
80107e4d:	5f                   	pop    %edi
80107e4e:	5d                   	pop    %ebp
80107e4f:	c3                   	ret    

80107e50 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107e50:	55                   	push   %ebp
80107e51:	89 e5                	mov    %esp,%ebp
80107e53:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
80107e56:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107e5d:	76 0c                	jbe    80107e6b <inituvm+0x1b>
    panic("inituvm: more than a page");
80107e5f:	c7 04 24 09 8b 10 80 	movl   $0x80108b09,(%esp)
80107e66:	e8 f7 86 ff ff       	call   80100562 <panic>
  mem = kalloc();
80107e6b:	e8 39 ad ff ff       	call   80102ba9 <kalloc>
80107e70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107e73:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e7a:	00 
80107e7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107e82:	00 
80107e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e86:	89 04 24             	mov    %eax,(%esp)
80107e89:	e8 a3 d3 ff ff       	call   80105231 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e91:	05 00 00 00 80       	add    $0x80000000,%eax
80107e96:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107e9d:	00 
80107e9e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107ea2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ea9:	00 
80107eaa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107eb1:	00 
80107eb2:	8b 45 08             	mov    0x8(%ebp),%eax
80107eb5:	89 04 24             	mov    %eax,(%esp)
80107eb8:	e8 90 fc ff ff       	call   80107b4d <mappages>
  memmove(mem, init, sz);
80107ebd:	8b 45 10             	mov    0x10(%ebp),%eax
80107ec0:	89 44 24 08          	mov    %eax,0x8(%esp)
80107ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ec7:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ece:	89 04 24             	mov    %eax,(%esp)
80107ed1:	e8 2a d4 ff ff       	call   80105300 <memmove>
}
80107ed6:	c9                   	leave  
80107ed7:	c3                   	ret    

80107ed8 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107ed8:	55                   	push   %ebp
80107ed9:	89 e5                	mov    %esp,%ebp
80107edb:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107ede:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ee1:	25 ff 0f 00 00       	and    $0xfff,%eax
80107ee6:	85 c0                	test   %eax,%eax
80107ee8:	74 0c                	je     80107ef6 <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
80107eea:	c7 04 24 24 8b 10 80 	movl   $0x80108b24,(%esp)
80107ef1:	e8 6c 86 ff ff       	call   80100562 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107ef6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107efd:	e9 a6 00 00 00       	jmp    80107fa8 <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f05:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f08:	01 d0                	add    %edx,%eax
80107f0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f11:	00 
80107f12:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f16:	8b 45 08             	mov    0x8(%ebp),%eax
80107f19:	89 04 24             	mov    %eax,(%esp)
80107f1c:	e8 90 fb ff ff       	call   80107ab1 <walkpgdir>
80107f21:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f24:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f28:	75 0c                	jne    80107f36 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
80107f2a:	c7 04 24 47 8b 10 80 	movl   $0x80108b47,(%esp)
80107f31:	e8 2c 86 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
80107f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f39:	8b 00                	mov    (%eax),%eax
80107f3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f40:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f46:	8b 55 18             	mov    0x18(%ebp),%edx
80107f49:	29 c2                	sub    %eax,%edx
80107f4b:	89 d0                	mov    %edx,%eax
80107f4d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107f52:	77 0f                	ja     80107f63 <loaduvm+0x8b>
      n = sz - i;
80107f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f57:	8b 55 18             	mov    0x18(%ebp),%edx
80107f5a:	29 c2                	sub    %eax,%edx
80107f5c:	89 d0                	mov    %edx,%eax
80107f5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107f61:	eb 07                	jmp    80107f6a <loaduvm+0x92>
    else
      n = PGSIZE;
80107f63:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6d:	8b 55 14             	mov    0x14(%ebp),%edx
80107f70:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80107f73:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f76:	05 00 00 00 80       	add    $0x80000000,%eax
80107f7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107f7e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107f82:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80107f86:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f8a:	8b 45 10             	mov    0x10(%ebp),%eax
80107f8d:	89 04 24             	mov    %eax,(%esp)
80107f90:	e8 65 9e ff ff       	call   80101dfa <readi>
80107f95:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107f98:	74 07                	je     80107fa1 <loaduvm+0xc9>
      return -1;
80107f9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f9f:	eb 18                	jmp    80107fb9 <loaduvm+0xe1>
  for(i = 0; i < sz; i += PGSIZE){
80107fa1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fab:	3b 45 18             	cmp    0x18(%ebp),%eax
80107fae:	0f 82 4e ff ff ff    	jb     80107f02 <loaduvm+0x2a>
  }
  return 0;
80107fb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fb9:	c9                   	leave  
80107fba:	c3                   	ret    

80107fbb <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107fbb:	55                   	push   %ebp
80107fbc:	89 e5                	mov    %esp,%ebp
80107fbe:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107fc1:	8b 45 10             	mov    0x10(%ebp),%eax
80107fc4:	85 c0                	test   %eax,%eax
80107fc6:	79 0a                	jns    80107fd2 <allocuvm+0x17>
    return 0;
80107fc8:	b8 00 00 00 00       	mov    $0x0,%eax
80107fcd:	e9 fd 00 00 00       	jmp    801080cf <allocuvm+0x114>
  if(newsz < oldsz)
80107fd2:	8b 45 10             	mov    0x10(%ebp),%eax
80107fd5:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107fd8:	73 08                	jae    80107fe2 <allocuvm+0x27>
    return oldsz;
80107fda:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fdd:	e9 ed 00 00 00       	jmp    801080cf <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
80107fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fe5:	05 ff 0f 00 00       	add    $0xfff,%eax
80107fea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107ff2:	e9 c9 00 00 00       	jmp    801080c0 <allocuvm+0x105>
    mem = kalloc();
80107ff7:	e8 ad ab ff ff       	call   80102ba9 <kalloc>
80107ffc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107fff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108003:	75 2f                	jne    80108034 <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
80108005:	c7 04 24 65 8b 10 80 	movl   $0x80108b65,(%esp)
8010800c:	e8 b7 83 ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108011:	8b 45 0c             	mov    0xc(%ebp),%eax
80108014:	89 44 24 08          	mov    %eax,0x8(%esp)
80108018:	8b 45 10             	mov    0x10(%ebp),%eax
8010801b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010801f:	8b 45 08             	mov    0x8(%ebp),%eax
80108022:	89 04 24             	mov    %eax,(%esp)
80108025:	e8 a7 00 00 00       	call   801080d1 <deallocuvm>
      return 0;
8010802a:	b8 00 00 00 00       	mov    $0x0,%eax
8010802f:	e9 9b 00 00 00       	jmp    801080cf <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
80108034:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010803b:	00 
8010803c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108043:	00 
80108044:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108047:	89 04 24             	mov    %eax,(%esp)
8010804a:	e8 e2 d1 ff ff       	call   80105231 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010804f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108052:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108058:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805b:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108062:	00 
80108063:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108067:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010806e:	00 
8010806f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108073:	8b 45 08             	mov    0x8(%ebp),%eax
80108076:	89 04 24             	mov    %eax,(%esp)
80108079:	e8 cf fa ff ff       	call   80107b4d <mappages>
8010807e:	85 c0                	test   %eax,%eax
80108080:	79 37                	jns    801080b9 <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
80108082:	c7 04 24 7d 8b 10 80 	movl   $0x80108b7d,(%esp)
80108089:	e8 3a 83 ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010808e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108091:	89 44 24 08          	mov    %eax,0x8(%esp)
80108095:	8b 45 10             	mov    0x10(%ebp),%eax
80108098:	89 44 24 04          	mov    %eax,0x4(%esp)
8010809c:	8b 45 08             	mov    0x8(%ebp),%eax
8010809f:	89 04 24             	mov    %eax,(%esp)
801080a2:	e8 2a 00 00 00       	call   801080d1 <deallocuvm>
      kfree(mem);
801080a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080aa:	89 04 24             	mov    %eax,(%esp)
801080ad:	e8 61 aa ff ff       	call   80102b13 <kfree>
      return 0;
801080b2:	b8 00 00 00 00       	mov    $0x0,%eax
801080b7:	eb 16                	jmp    801080cf <allocuvm+0x114>
  for(; a < newsz; a += PGSIZE){
801080b9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c3:	3b 45 10             	cmp    0x10(%ebp),%eax
801080c6:	0f 82 2b ff ff ff    	jb     80107ff7 <allocuvm+0x3c>
    }
  }
  return newsz;
801080cc:	8b 45 10             	mov    0x10(%ebp),%eax
}
801080cf:	c9                   	leave  
801080d0:	c3                   	ret    

801080d1 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801080d1:	55                   	push   %ebp
801080d2:	89 e5                	mov    %esp,%ebp
801080d4:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801080d7:	8b 45 10             	mov    0x10(%ebp),%eax
801080da:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080dd:	72 08                	jb     801080e7 <deallocuvm+0x16>
    return oldsz;
801080df:	8b 45 0c             	mov    0xc(%ebp),%eax
801080e2:	e9 ae 00 00 00       	jmp    80108195 <deallocuvm+0xc4>

  a = PGROUNDUP(newsz);
801080e7:	8b 45 10             	mov    0x10(%ebp),%eax
801080ea:	05 ff 0f 00 00       	add    $0xfff,%eax
801080ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801080f7:	e9 8a 00 00 00       	jmp    80108186 <deallocuvm+0xb5>
    pte = walkpgdir(pgdir, (char*)a, 0);
801080fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108106:	00 
80108107:	89 44 24 04          	mov    %eax,0x4(%esp)
8010810b:	8b 45 08             	mov    0x8(%ebp),%eax
8010810e:	89 04 24             	mov    %eax,(%esp)
80108111:	e8 9b f9 ff ff       	call   80107ab1 <walkpgdir>
80108116:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108119:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010811d:	75 16                	jne    80108135 <deallocuvm+0x64>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010811f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108122:	c1 e8 16             	shr    $0x16,%eax
80108125:	83 c0 01             	add    $0x1,%eax
80108128:	c1 e0 16             	shl    $0x16,%eax
8010812b:	2d 00 10 00 00       	sub    $0x1000,%eax
80108130:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108133:	eb 4a                	jmp    8010817f <deallocuvm+0xae>
    else if((*pte & PTE_P) != 0){
80108135:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108138:	8b 00                	mov    (%eax),%eax
8010813a:	83 e0 01             	and    $0x1,%eax
8010813d:	85 c0                	test   %eax,%eax
8010813f:	74 3e                	je     8010817f <deallocuvm+0xae>
      pa = PTE_ADDR(*pte);
80108141:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108144:	8b 00                	mov    (%eax),%eax
80108146:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010814b:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
8010814e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108152:	75 0c                	jne    80108160 <deallocuvm+0x8f>
        panic("kfree");
80108154:	c7 04 24 99 8b 10 80 	movl   $0x80108b99,(%esp)
8010815b:	e8 02 84 ff ff       	call   80100562 <panic>
      char *v = P2V(pa);
80108160:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108163:	05 00 00 00 80       	add    $0x80000000,%eax
80108168:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
8010816b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010816e:	89 04 24             	mov    %eax,(%esp)
80108171:	e8 9d a9 ff ff       	call   80102b13 <kfree>
      *pte = 0;
80108176:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108179:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
8010817f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108189:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010818c:	0f 82 6a ff ff ff    	jb     801080fc <deallocuvm+0x2b>
    }
  }
  return newsz;
80108192:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108195:	c9                   	leave  
80108196:	c3                   	ret    

80108197 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108197:	55                   	push   %ebp
80108198:	89 e5                	mov    %esp,%ebp
8010819a:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
8010819d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801081a1:	75 0c                	jne    801081af <freevm+0x18>
    panic("freevm: no pgdir");
801081a3:	c7 04 24 9f 8b 10 80 	movl   $0x80108b9f,(%esp)
801081aa:	e8 b3 83 ff ff       	call   80100562 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801081af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801081b6:	00 
801081b7:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
801081be:	80 
801081bf:	8b 45 08             	mov    0x8(%ebp),%eax
801081c2:	89 04 24             	mov    %eax,(%esp)
801081c5:	e8 07 ff ff ff       	call   801080d1 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801081ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801081d1:	eb 45                	jmp    80108218 <freevm+0x81>
    if(pgdir[i] & PTE_P){
801081d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081dd:	8b 45 08             	mov    0x8(%ebp),%eax
801081e0:	01 d0                	add    %edx,%eax
801081e2:	8b 00                	mov    (%eax),%eax
801081e4:	83 e0 01             	and    $0x1,%eax
801081e7:	85 c0                	test   %eax,%eax
801081e9:	74 29                	je     80108214 <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801081eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081f5:	8b 45 08             	mov    0x8(%ebp),%eax
801081f8:	01 d0                	add    %edx,%eax
801081fa:	8b 00                	mov    (%eax),%eax
801081fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108201:	05 00 00 00 80       	add    $0x80000000,%eax
80108206:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108209:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010820c:	89 04 24             	mov    %eax,(%esp)
8010820f:	e8 ff a8 ff ff       	call   80102b13 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80108214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108218:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010821f:	76 b2                	jbe    801081d3 <freevm+0x3c>
    }
  }
  kfree((char*)pgdir);
80108221:	8b 45 08             	mov    0x8(%ebp),%eax
80108224:	89 04 24             	mov    %eax,(%esp)
80108227:	e8 e7 a8 ff ff       	call   80102b13 <kfree>
}
8010822c:	c9                   	leave  
8010822d:	c3                   	ret    

8010822e <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010822e:	55                   	push   %ebp
8010822f:	89 e5                	mov    %esp,%ebp
80108231:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108234:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010823b:	00 
8010823c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010823f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108243:	8b 45 08             	mov    0x8(%ebp),%eax
80108246:	89 04 24             	mov    %eax,(%esp)
80108249:	e8 63 f8 ff ff       	call   80107ab1 <walkpgdir>
8010824e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108251:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108255:	75 0c                	jne    80108263 <clearpteu+0x35>
    panic("clearpteu");
80108257:	c7 04 24 b0 8b 10 80 	movl   $0x80108bb0,(%esp)
8010825e:	e8 ff 82 ff ff       	call   80100562 <panic>
  *pte &= ~PTE_U;
80108263:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108266:	8b 00                	mov    (%eax),%eax
80108268:	83 e0 fb             	and    $0xfffffffb,%eax
8010826b:	89 c2                	mov    %eax,%edx
8010826d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108270:	89 10                	mov    %edx,(%eax)
}
80108272:	c9                   	leave  
80108273:	c3                   	ret    

80108274 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108274:	55                   	push   %ebp
80108275:	89 e5                	mov    %esp,%ebp
80108277:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010827a:	e8 66 f9 ff ff       	call   80107be5 <setupkvm>
8010827f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108282:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108286:	75 0a                	jne    80108292 <copyuvm+0x1e>
    return 0;
80108288:	b8 00 00 00 00       	mov    $0x0,%eax
8010828d:	e9 03 01 00 00       	jmp    80108395 <copyuvm+0x121>
  for(i = 0; i < sz; i += PGSIZE){
80108292:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108299:	e9 d6 00 00 00       	jmp    80108374 <copyuvm+0x100>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010829e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801082a8:	00 
801082a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801082ad:	8b 45 08             	mov    0x8(%ebp),%eax
801082b0:	89 04 24             	mov    %eax,(%esp)
801082b3:	e8 f9 f7 ff ff       	call   80107ab1 <walkpgdir>
801082b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801082bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801082bf:	75 0c                	jne    801082cd <copyuvm+0x59>
      panic("copyuvm: pte should exist");
801082c1:	c7 04 24 ba 8b 10 80 	movl   $0x80108bba,(%esp)
801082c8:	e8 95 82 ff ff       	call   80100562 <panic>
    if(!(*pte & PTE_P))
801082cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082d0:	8b 00                	mov    (%eax),%eax
801082d2:	83 e0 01             	and    $0x1,%eax
801082d5:	85 c0                	test   %eax,%eax
801082d7:	75 0c                	jne    801082e5 <copyuvm+0x71>
      panic("copyuvm: page not present");
801082d9:	c7 04 24 d4 8b 10 80 	movl   $0x80108bd4,(%esp)
801082e0:	e8 7d 82 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
801082e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082e8:	8b 00                	mov    (%eax),%eax
801082ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801082f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082f5:	8b 00                	mov    (%eax),%eax
801082f7:	25 ff 0f 00 00       	and    $0xfff,%eax
801082fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801082ff:	e8 a5 a8 ff ff       	call   80102ba9 <kalloc>
80108304:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108307:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010830b:	75 02                	jne    8010830f <copyuvm+0x9b>
      goto bad;
8010830d:	eb 76                	jmp    80108385 <copyuvm+0x111>
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010830f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108312:	05 00 00 00 80       	add    $0x80000000,%eax
80108317:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010831e:	00 
8010831f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108323:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108326:	89 04 24             	mov    %eax,(%esp)
80108329:	e8 d2 cf ff ff       	call   80105300 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010832e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108331:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108334:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010833a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010833d:	89 54 24 10          	mov    %edx,0x10(%esp)
80108341:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80108345:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010834c:	00 
8010834d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108351:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108354:	89 04 24             	mov    %eax,(%esp)
80108357:	e8 f1 f7 ff ff       	call   80107b4d <mappages>
8010835c:	85 c0                	test   %eax,%eax
8010835e:	79 0d                	jns    8010836d <copyuvm+0xf9>
      kfree(mem);
80108360:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108363:	89 04 24             	mov    %eax,(%esp)
80108366:	e8 a8 a7 ff ff       	call   80102b13 <kfree>
      goto bad;
8010836b:	eb 18                	jmp    80108385 <copyuvm+0x111>
  for(i = 0; i < sz; i += PGSIZE){
8010836d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108377:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010837a:	0f 82 1e ff ff ff    	jb     8010829e <copyuvm+0x2a>
    }
  }
  return d;
80108380:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108383:	eb 10                	jmp    80108395 <copyuvm+0x121>

bad:
  freevm(d);
80108385:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108388:	89 04 24             	mov    %eax,(%esp)
8010838b:	e8 07 fe ff ff       	call   80108197 <freevm>
  return 0;
80108390:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108395:	c9                   	leave  
80108396:	c3                   	ret    

80108397 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108397:	55                   	push   %ebp
80108398:	89 e5                	mov    %esp,%ebp
8010839a:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010839d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801083a4:	00 
801083a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801083a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801083ac:	8b 45 08             	mov    0x8(%ebp),%eax
801083af:	89 04 24             	mov    %eax,(%esp)
801083b2:	e8 fa f6 ff ff       	call   80107ab1 <walkpgdir>
801083b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801083ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083bd:	8b 00                	mov    (%eax),%eax
801083bf:	83 e0 01             	and    $0x1,%eax
801083c2:	85 c0                	test   %eax,%eax
801083c4:	75 07                	jne    801083cd <uva2ka+0x36>
    return 0;
801083c6:	b8 00 00 00 00       	mov    $0x0,%eax
801083cb:	eb 22                	jmp    801083ef <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801083cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d0:	8b 00                	mov    (%eax),%eax
801083d2:	83 e0 04             	and    $0x4,%eax
801083d5:	85 c0                	test   %eax,%eax
801083d7:	75 07                	jne    801083e0 <uva2ka+0x49>
    return 0;
801083d9:	b8 00 00 00 00       	mov    $0x0,%eax
801083de:	eb 0f                	jmp    801083ef <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
801083e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e3:	8b 00                	mov    (%eax),%eax
801083e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083ea:	05 00 00 00 80       	add    $0x80000000,%eax
}
801083ef:	c9                   	leave  
801083f0:	c3                   	ret    

801083f1 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801083f1:	55                   	push   %ebp
801083f2:	89 e5                	mov    %esp,%ebp
801083f4:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801083f7:	8b 45 10             	mov    0x10(%ebp),%eax
801083fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801083fd:	e9 87 00 00 00       	jmp    80108489 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108402:	8b 45 0c             	mov    0xc(%ebp),%eax
80108405:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010840a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010840d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108410:	89 44 24 04          	mov    %eax,0x4(%esp)
80108414:	8b 45 08             	mov    0x8(%ebp),%eax
80108417:	89 04 24             	mov    %eax,(%esp)
8010841a:	e8 78 ff ff ff       	call   80108397 <uva2ka>
8010841f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108422:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108426:	75 07                	jne    8010842f <copyout+0x3e>
      return -1;
80108428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010842d:	eb 69                	jmp    80108498 <copyout+0xa7>
    n = PGSIZE - (va - va0);
8010842f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108432:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108435:	29 c2                	sub    %eax,%edx
80108437:	89 d0                	mov    %edx,%eax
80108439:	05 00 10 00 00       	add    $0x1000,%eax
8010843e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108441:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108444:	3b 45 14             	cmp    0x14(%ebp),%eax
80108447:	76 06                	jbe    8010844f <copyout+0x5e>
      n = len;
80108449:	8b 45 14             	mov    0x14(%ebp),%eax
8010844c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010844f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108452:	8b 55 0c             	mov    0xc(%ebp),%edx
80108455:	29 c2                	sub    %eax,%edx
80108457:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010845a:	01 c2                	add    %eax,%edx
8010845c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010845f:	89 44 24 08          	mov    %eax,0x8(%esp)
80108463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108466:	89 44 24 04          	mov    %eax,0x4(%esp)
8010846a:	89 14 24             	mov    %edx,(%esp)
8010846d:	e8 8e ce ff ff       	call   80105300 <memmove>
    len -= n;
80108472:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108475:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108478:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010847b:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010847e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108481:	05 00 10 00 00       	add    $0x1000,%eax
80108486:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108489:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010848d:	0f 85 6f ff ff ff    	jne    80108402 <copyout+0x11>
  }
  return 0;
80108493:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108498:	c9                   	leave  
80108499:	c3                   	ret    
