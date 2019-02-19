
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 2f 10 80       	mov    $0x80102f10,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 6f 10 80       	push   $0x80106f20
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 15 42 00 00       	call   80104270 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 6f 10 80       	push   $0x80106f27
80100097:	50                   	push   %eax
80100098:	e8 a3 40 00 00       	call   80104140 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 c7 42 00 00       	call   801043b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 09 43 00 00       	call   80104470 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 40 00 00       	call   80104180 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 0d 20 00 00       	call   80102190 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 6f 10 80       	push   $0x80106f2e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 6d 40 00 00       	call   80104220 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 c7 1f 00 00       	jmp    80102190 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 6f 10 80       	push   $0x80106f3f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 2c 40 00 00       	call   80104220 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 3f 00 00       	call   801041e0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 a0 41 00 00       	call   801043b0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 0f 42 00 00       	jmp    80104470 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 6f 10 80       	push   $0x80106f46
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 4b 15 00 00       	call   801017d0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 1f 41 00 00       	call   801043b0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 26 3b 00 00       	call   80103df0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 70 35 00 00       	call   80103850 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 7c 41 00 00       	call   80104470 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 f4 13 00 00       	call   801016f0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 1e 41 00 00       	call   80104470 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 96 13 00 00       	call   801016f0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 f2 23 00 00       	call   801027a0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 6f 10 80       	push   $0x80106f4d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 97 78 10 80 	movl   $0x80107897,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 b3 3e 00 00       	call   80104290 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 6f 10 80       	push   $0x80106f61
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 f1 56 00 00       	call   80105b30 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 3f 56 00 00       	call   80105b30 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 33 56 00 00       	call   80105b30 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 27 56 00 00       	call   80105b30 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 47 40 00 00       	call   80104570 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 7a 3f 00 00       	call   801044c0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 6f 10 80       	push   $0x80106f65
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 90 6f 10 80 	movzbl -0x7fef9070(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 bc 11 00 00       	call   801017d0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 90 3d 00 00       	call   801043b0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 24 3e 00 00       	call   80104470 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 9b 10 00 00       	call   801016f0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 4c 3d 00 00       	call   80104470 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 78 6f 10 80       	mov    $0x80106f78,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 bb 3b 00 00       	call   801043b0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 6f 10 80       	push   $0x80106f7f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 88 3b 00 00       	call   801043b0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 30                	js     80100868 <consoleintr+0x58>
    switch(c){
80100838:	83 ff 15             	cmp    $0x15,%edi
8010083b:	0f 84 5f 01 00 00    	je     801009a0 <consoleintr+0x190>
80100841:	7f 4d                	jg     80100890 <consoleintr+0x80>
80100843:	83 ff 08             	cmp    $0x8,%edi
80100846:	0f 84 2c 01 00 00    	je     80100978 <consoleintr+0x168>
8010084c:	83 ff 10             	cmp    $0x10,%edi
8010084f:	0f 85 9b 00 00 00    	jne    801008f0 <consoleintr+0xe0>
  while((c = getc()) >= 0){
80100855:	ff d3                	call   *%ebx
80100857:	85 c0                	test   %eax,%eax
      doprocdump = 1;
80100859:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
8010085e:	89 c7                	mov    %eax,%edi
80100860:	79 d6                	jns    80100838 <consoleintr+0x28>
80100862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&cons.lock);
80100868:	83 ec 0c             	sub    $0xc,%esp
8010086b:	68 20 a5 10 80       	push   $0x8010a520
80100870:	e8 fb 3b 00 00       	call   80104470 <release>
  if(doprocdump) {
80100875:	83 c4 10             	add    $0x10,%esp
80100878:	85 f6                	test   %esi,%esi
8010087a:	0f 85 70 01 00 00    	jne    801009f0 <consoleintr+0x1e0>
}
80100880:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100883:	5b                   	pop    %ebx
80100884:	5e                   	pop    %esi
80100885:	5f                   	pop    %edi
80100886:	5d                   	pop    %ebp
80100887:	c3                   	ret    
80100888:	90                   	nop
80100889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100890:	83 ff 7f             	cmp    $0x7f,%edi
80100893:	0f 84 df 00 00 00    	je     80100978 <consoleintr+0x168>
80100899:	81 ff e2 00 00 00    	cmp    $0xe2,%edi
8010089f:	75 4f                	jne    801008f0 <consoleintr+0xe0>
      while(input.e != input.w &&
801008a1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008a6:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
801008ac:	75 22                	jne    801008d0 <consoleintr+0xc0>
801008ae:	eb 80                	jmp    80100830 <consoleintr+0x20>
        input.e--;
801008b0:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008b5:	b8 00 01 00 00       	mov    $0x100,%eax
801008ba:	e8 51 fb ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
801008bf:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c4:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008ca:	0f 84 60 ff ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008d0:	83 e8 01             	sub    $0x1,%eax
801008d3:	89 c2                	mov    %eax,%edx
801008d5:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801008d8:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
801008df:	75 cf                	jne    801008b0 <consoleintr+0xa0>
801008e1:	e9 4a ff ff ff       	jmp    80100830 <consoleintr+0x20>
801008e6:	8d 76 00             	lea    0x0(%esi),%esi
801008e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008f0:	85 ff                	test   %edi,%edi
801008f2:	0f 84 38 ff ff ff    	je     80100830 <consoleintr+0x20>
801008f8:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008fd:	89 c2                	mov    %eax,%edx
801008ff:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100905:	83 fa 7f             	cmp    $0x7f,%edx
80100908:	0f 87 22 ff ff ff    	ja     80100830 <consoleintr+0x20>
8010090e:	8d 50 01             	lea    0x1(%eax),%edx
80100911:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100914:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100917:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010091d:	0f 84 dd 00 00 00    	je     80100a00 <consoleintr+0x1f0>
        input.buf[input.e++ % INPUT_BUF] = c;
80100923:	89 f9                	mov    %edi,%ecx
80100925:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010092b:	89 f8                	mov    %edi,%eax
8010092d:	e8 de fa ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100932:	83 ff 0a             	cmp    $0xa,%edi
80100935:	0f 84 d6 00 00 00    	je     80100a11 <consoleintr+0x201>
8010093b:	83 ff 04             	cmp    $0x4,%edi
8010093e:	0f 84 cd 00 00 00    	je     80100a11 <consoleintr+0x201>
80100944:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80100949:	83 e8 80             	sub    $0xffffff80,%eax
8010094c:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100952:	0f 85 d8 fe ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100958:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010095b:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100960:	68 a0 ff 10 80       	push   $0x8010ffa0
80100965:	e8 36 36 00 00       	call   80103fa0 <wakeup>
8010096a:	83 c4 10             	add    $0x10,%esp
8010096d:	e9 be fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
80100978:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010097d:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100983:	0f 84 a7 fe ff ff    	je     80100830 <consoleintr+0x20>
        input.e--;
80100989:	83 e8 01             	sub    $0x1,%eax
8010098c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100991:	b8 00 01 00 00       	mov    $0x100,%eax
80100996:	e8 75 fa ff ff       	call   80100410 <consputc>
8010099b:	e9 90 fe ff ff       	jmp    80100830 <consoleintr+0x20>
      while(input.e != input.w &&
801009a0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009a5:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
801009ab:	75 2b                	jne    801009d8 <consoleintr+0x1c8>
801009ad:	e9 7e fe ff ff       	jmp    80100830 <consoleintr+0x20>
801009b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801009b8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801009bd:	b8 00 01 00 00       	mov    $0x100,%eax
801009c2:	e8 49 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
801009c7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009cc:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801009d2:	0f 84 58 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801009d8:	83 e8 01             	sub    $0x1,%eax
801009db:	89 c2                	mov    %eax,%edx
801009dd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801009e0:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
801009e7:	75 cf                	jne    801009b8 <consoleintr+0x1a8>
801009e9:	e9 42 fe ff ff       	jmp    80100830 <consoleintr+0x20>
801009ee:	66 90                	xchg   %ax,%ax
}
801009f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009f3:	5b                   	pop    %ebx
801009f4:	5e                   	pop    %esi
801009f5:	5f                   	pop    %edi
801009f6:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009f7:	e9 84 36 00 00       	jmp    80104080 <procdump>
801009fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100a00:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100a07:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a0c:	e8 ff f9 ff ff       	call   80100410 <consputc>
80100a11:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100a16:	e9 3d ff ff ff       	jmp    80100958 <consoleintr+0x148>
80100a1b:	90                   	nop
80100a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a20 <consoleinit>:

void
consoleinit(void)
{
80100a20:	55                   	push   %ebp
80100a21:	89 e5                	mov    %esp,%ebp
80100a23:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a26:	68 88 6f 10 80       	push   $0x80106f88
80100a2b:	68 20 a5 10 80       	push   $0x8010a520
80100a30:	e8 3b 38 00 00       	call   80104270 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a35:	58                   	pop    %eax
80100a36:	5a                   	pop    %edx
80100a37:	6a 00                	push   $0x0
80100a39:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a3b:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
80100a42:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a45:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
80100a4c:	02 10 80 
  cons.locking = 1;
80100a4f:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a56:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a59:	e8 e2 18 00 00       	call   80102340 <ioapicenable>
}
80100a5e:	83 c4 10             	add    $0x10,%esp
80100a61:	c9                   	leave  
80100a62:	c3                   	ret    
80100a63:	66 90                	xchg   %ax,%ax
80100a65:	66 90                	xchg   %ax,%ax
80100a67:	66 90                	xchg   %ax,%ax
80100a69:	66 90                	xchg   %ax,%ax
80100a6b:	66 90                	xchg   %ax,%ax
80100a6d:	66 90                	xchg   %ax,%ax
80100a6f:	90                   	nop

80100a70 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a70:	55                   	push   %ebp
80100a71:	89 e5                	mov    %esp,%ebp
80100a73:	57                   	push   %edi
80100a74:	56                   	push   %esi
80100a75:	53                   	push   %ebx
80100a76:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a7c:	e8 cf 2d 00 00       	call   80103850 <myproc>
80100a81:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a87:	e8 84 21 00 00       	call   80102c10 <begin_op>

  if((ip = namei(path)) == 0){
80100a8c:	83 ec 0c             	sub    $0xc,%esp
80100a8f:	ff 75 08             	pushl  0x8(%ebp)
80100a92:	e8 b9 14 00 00       	call   80101f50 <namei>
80100a97:	83 c4 10             	add    $0x10,%esp
80100a9a:	85 c0                	test   %eax,%eax
80100a9c:	0f 84 91 01 00 00    	je     80100c33 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100aa2:	83 ec 0c             	sub    $0xc,%esp
80100aa5:	89 c3                	mov    %eax,%ebx
80100aa7:	50                   	push   %eax
80100aa8:	e8 43 0c 00 00       	call   801016f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aad:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ab3:	6a 34                	push   $0x34
80100ab5:	6a 00                	push   $0x0
80100ab7:	50                   	push   %eax
80100ab8:	53                   	push   %ebx
80100ab9:	e8 12 0f 00 00       	call   801019d0 <readi>
80100abe:	83 c4 20             	add    $0x20,%esp
80100ac1:	83 f8 34             	cmp    $0x34,%eax
80100ac4:	74 22                	je     80100ae8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ac6:	83 ec 0c             	sub    $0xc,%esp
80100ac9:	53                   	push   %ebx
80100aca:	e8 b1 0e 00 00       	call   80101980 <iunlockput>
    end_op();
80100acf:	e8 ac 21 00 00       	call   80102c80 <end_op>
80100ad4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ad7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100adc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100adf:	5b                   	pop    %ebx
80100ae0:	5e                   	pop    %esi
80100ae1:	5f                   	pop    %edi
80100ae2:	5d                   	pop    %ebp
80100ae3:	c3                   	ret    
80100ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100ae8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aef:	45 4c 46 
80100af2:	75 d2                	jne    80100ac6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100af4:	e8 87 61 00 00       	call   80106c80 <setupkvm>
80100af9:	85 c0                	test   %eax,%eax
80100afb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b01:	74 c3                	je     80100ac6 <exec+0x56>
  sz = 0;
80100b03:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b05:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b0c:	00 
80100b0d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100b13:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b19:	0f 84 8c 02 00 00    	je     80100dab <exec+0x33b>
80100b1f:	31 f6                	xor    %esi,%esi
80100b21:	eb 7f                	jmp    80100ba2 <exec+0x132>
80100b23:	90                   	nop
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100b28:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b2f:	75 63                	jne    80100b94 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100b31:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b37:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b3d:	0f 82 86 00 00 00    	jb     80100bc9 <exec+0x159>
80100b43:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b49:	72 7e                	jb     80100bc9 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b4b:	83 ec 04             	sub    $0x4,%esp
80100b4e:	50                   	push   %eax
80100b4f:	57                   	push   %edi
80100b50:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b56:	e8 45 5f 00 00       	call   80106aa0 <allocuvm>
80100b5b:	83 c4 10             	add    $0x10,%esp
80100b5e:	85 c0                	test   %eax,%eax
80100b60:	89 c7                	mov    %eax,%edi
80100b62:	74 65                	je     80100bc9 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b64:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b6a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b6f:	75 58                	jne    80100bc9 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b71:	83 ec 0c             	sub    $0xc,%esp
80100b74:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b7a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b80:	53                   	push   %ebx
80100b81:	50                   	push   %eax
80100b82:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b88:	e8 53 5e 00 00       	call   801069e0 <loaduvm>
80100b8d:	83 c4 20             	add    $0x20,%esp
80100b90:	85 c0                	test   %eax,%eax
80100b92:	78 35                	js     80100bc9 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b94:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b9b:	83 c6 01             	add    $0x1,%esi
80100b9e:	39 f0                	cmp    %esi,%eax
80100ba0:	7e 3d                	jle    80100bdf <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ba2:	89 f0                	mov    %esi,%eax
80100ba4:	6a 20                	push   $0x20
80100ba6:	c1 e0 05             	shl    $0x5,%eax
80100ba9:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100baf:	50                   	push   %eax
80100bb0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bb6:	50                   	push   %eax
80100bb7:	53                   	push   %ebx
80100bb8:	e8 13 0e 00 00       	call   801019d0 <readi>
80100bbd:	83 c4 10             	add    $0x10,%esp
80100bc0:	83 f8 20             	cmp    $0x20,%eax
80100bc3:	0f 84 5f ff ff ff    	je     80100b28 <exec+0xb8>
    freevm(pgdir);
80100bc9:	83 ec 0c             	sub    $0xc,%esp
80100bcc:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bd2:	e8 29 60 00 00       	call   80106c00 <freevm>
80100bd7:	83 c4 10             	add    $0x10,%esp
80100bda:	e9 e7 fe ff ff       	jmp    80100ac6 <exec+0x56>
80100bdf:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100be5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100beb:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100bf1:	83 ec 0c             	sub    $0xc,%esp
80100bf4:	53                   	push   %ebx
80100bf5:	e8 86 0d 00 00       	call   80101980 <iunlockput>
  end_op();
80100bfa:	e8 81 20 00 00       	call   80102c80 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bff:	83 c4 0c             	add    $0xc,%esp
80100c02:	56                   	push   %esi
80100c03:	57                   	push   %edi
80100c04:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c0a:	e8 91 5e 00 00       	call   80106aa0 <allocuvm>
80100c0f:	83 c4 10             	add    $0x10,%esp
80100c12:	85 c0                	test   %eax,%eax
80100c14:	89 c6                	mov    %eax,%esi
80100c16:	75 3a                	jne    80100c52 <exec+0x1e2>
    freevm(pgdir);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c21:	e8 da 5f 00 00       	call   80106c00 <freevm>
80100c26:	83 c4 10             	add    $0x10,%esp
  return -1;
80100c29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c2e:	e9 a9 fe ff ff       	jmp    80100adc <exec+0x6c>
    end_op();
80100c33:	e8 48 20 00 00       	call   80102c80 <end_op>
    cprintf("exec: fail\n");
80100c38:	83 ec 0c             	sub    $0xc,%esp
80100c3b:	68 a1 6f 10 80       	push   $0x80106fa1
80100c40:	e8 1b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100c45:	83 c4 10             	add    $0x10,%esp
80100c48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c4d:	e9 8a fe ff ff       	jmp    80100adc <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c52:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c58:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100c5b:	31 ff                	xor    %edi,%edi
80100c5d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c5f:	50                   	push   %eax
80100c60:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c66:	e8 b5 60 00 00       	call   80106d20 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c6e:	83 c4 10             	add    $0x10,%esp
80100c71:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c77:	8b 00                	mov    (%eax),%eax
80100c79:	85 c0                	test   %eax,%eax
80100c7b:	74 70                	je     80100ced <exec+0x27d>
80100c7d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c83:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c89:	eb 0a                	jmp    80100c95 <exec+0x225>
80100c8b:	90                   	nop
80100c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c90:	83 ff 20             	cmp    $0x20,%edi
80100c93:	74 83                	je     80100c18 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c95:	83 ec 0c             	sub    $0xc,%esp
80100c98:	50                   	push   %eax
80100c99:	e8 42 3a 00 00       	call   801046e0 <strlen>
80100c9e:	f7 d0                	not    %eax
80100ca0:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ca5:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ca6:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ca9:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cac:	e8 2f 3a 00 00       	call   801046e0 <strlen>
80100cb1:	83 c0 01             	add    $0x1,%eax
80100cb4:	50                   	push   %eax
80100cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cb8:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cbb:	53                   	push   %ebx
80100cbc:	56                   	push   %esi
80100cbd:	e8 be 61 00 00       	call   80106e80 <copyout>
80100cc2:	83 c4 20             	add    $0x20,%esp
80100cc5:	85 c0                	test   %eax,%eax
80100cc7:	0f 88 4b ff ff ff    	js     80100c18 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cd0:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cd7:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cda:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100ce0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100ce3:	85 c0                	test   %eax,%eax
80100ce5:	75 a9                	jne    80100c90 <exec+0x220>
80100ce7:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ced:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100cf4:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100cf6:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100cfd:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100d01:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d08:	ff ff ff 
  ustack[1] = argc;
80100d0b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d11:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d13:	83 c0 0c             	add    $0xc,%eax
80100d16:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d18:	50                   	push   %eax
80100d19:	52                   	push   %edx
80100d1a:	53                   	push   %ebx
80100d1b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d21:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d27:	e8 54 61 00 00       	call   80106e80 <copyout>
80100d2c:	83 c4 10             	add    $0x10,%esp
80100d2f:	85 c0                	test   %eax,%eax
80100d31:	0f 88 e1 fe ff ff    	js     80100c18 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100d37:	8b 45 08             	mov    0x8(%ebp),%eax
80100d3a:	0f b6 00             	movzbl (%eax),%eax
80100d3d:	84 c0                	test   %al,%al
80100d3f:	74 17                	je     80100d58 <exec+0x2e8>
80100d41:	8b 55 08             	mov    0x8(%ebp),%edx
80100d44:	89 d1                	mov    %edx,%ecx
80100d46:	83 c1 01             	add    $0x1,%ecx
80100d49:	3c 2f                	cmp    $0x2f,%al
80100d4b:	0f b6 01             	movzbl (%ecx),%eax
80100d4e:	0f 44 d1             	cmove  %ecx,%edx
80100d51:	84 c0                	test   %al,%al
80100d53:	75 f1                	jne    80100d46 <exec+0x2d6>
80100d55:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d58:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d5e:	50                   	push   %eax
80100d5f:	6a 10                	push   $0x10
80100d61:	ff 75 08             	pushl  0x8(%ebp)
80100d64:	89 f8                	mov    %edi,%eax
80100d66:	83 c0 6c             	add    $0x6c,%eax
80100d69:	50                   	push   %eax
80100d6a:	e8 31 39 00 00       	call   801046a0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d6f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d75:	89 f9                	mov    %edi,%ecx
80100d77:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d7a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d7d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d7f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d82:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d88:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d8b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d8e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d91:	89 0c 24             	mov    %ecx,(%esp)
80100d94:	e8 b7 5a 00 00       	call   80106850 <switchuvm>
  freevm(oldpgdir);
80100d99:	89 3c 24             	mov    %edi,(%esp)
80100d9c:	e8 5f 5e 00 00       	call   80106c00 <freevm>
  return 0;
80100da1:	83 c4 10             	add    $0x10,%esp
80100da4:	31 c0                	xor    %eax,%eax
80100da6:	e9 31 fd ff ff       	jmp    80100adc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dab:	be 00 20 00 00       	mov    $0x2000,%esi
80100db0:	e9 3c fe ff ff       	jmp    80100bf1 <exec+0x181>
80100db5:	66 90                	xchg   %ax,%ax
80100db7:	66 90                	xchg   %ax,%ax
80100db9:	66 90                	xchg   %ax,%ax
80100dbb:	66 90                	xchg   %ax,%ax
80100dbd:	66 90                	xchg   %ax,%ax
80100dbf:	90                   	nop

80100dc0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dc6:	68 ad 6f 10 80       	push   $0x80106fad
80100dcb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dd0:	e8 9b 34 00 00       	call   80104270 <initlock>
}
80100dd5:	83 c4 10             	add    $0x10,%esp
80100dd8:	c9                   	leave  
80100dd9:	c3                   	ret    
80100dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100de0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100de4:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100de9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dec:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df1:	e8 ba 35 00 00       	call   801043b0 <acquire>
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	eb 10                	jmp    80100e0b <filealloc+0x2b>
80100dfb:	90                   	nop
80100dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e00:	83 c3 18             	add    $0x18,%ebx
80100e03:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e09:	73 25                	jae    80100e30 <filealloc+0x50>
    if(f->ref == 0){
80100e0b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e0e:	85 c0                	test   %eax,%eax
80100e10:	75 ee                	jne    80100e00 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e12:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e15:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e1c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e21:	e8 4a 36 00 00       	call   80104470 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e26:	89 d8                	mov    %ebx,%eax
      return f;
80100e28:	83 c4 10             	add    $0x10,%esp
}
80100e2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e2e:	c9                   	leave  
80100e2f:	c3                   	ret    
  release(&ftable.lock);
80100e30:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e33:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e35:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e3a:	e8 31 36 00 00       	call   80104470 <release>
}
80100e3f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e41:	83 c4 10             	add    $0x10,%esp
}
80100e44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e47:	c9                   	leave  
80100e48:	c3                   	ret    
80100e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e50 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
80100e54:	83 ec 10             	sub    $0x10,%esp
80100e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e5a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5f:	e8 4c 35 00 00       	call   801043b0 <acquire>
  if(f->ref < 1)
80100e64:	8b 43 04             	mov    0x4(%ebx),%eax
80100e67:	83 c4 10             	add    $0x10,%esp
80100e6a:	85 c0                	test   %eax,%eax
80100e6c:	7e 1a                	jle    80100e88 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e6e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e71:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e74:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e77:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e7c:	e8 ef 35 00 00       	call   80104470 <release>
  return f;
}
80100e81:	89 d8                	mov    %ebx,%eax
80100e83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e86:	c9                   	leave  
80100e87:	c3                   	ret    
    panic("filedup");
80100e88:	83 ec 0c             	sub    $0xc,%esp
80100e8b:	68 b4 6f 10 80       	push   $0x80106fb4
80100e90:	e8 fb f4 ff ff       	call   80100390 <panic>
80100e95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ea0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	57                   	push   %edi
80100ea4:	56                   	push   %esi
80100ea5:	53                   	push   %ebx
80100ea6:	83 ec 28             	sub    $0x28,%esp
80100ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100eac:	68 c0 ff 10 80       	push   $0x8010ffc0
80100eb1:	e8 fa 34 00 00       	call   801043b0 <acquire>
  if(f->ref < 1)
80100eb6:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb9:	83 c4 10             	add    $0x10,%esp
80100ebc:	85 c0                	test   %eax,%eax
80100ebe:	0f 8e 9b 00 00 00    	jle    80100f5f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100ec4:	83 e8 01             	sub    $0x1,%eax
80100ec7:	85 c0                	test   %eax,%eax
80100ec9:	89 43 04             	mov    %eax,0x4(%ebx)
80100ecc:	74 1a                	je     80100ee8 <fileclose+0x48>
    release(&ftable.lock);
80100ece:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ed5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ed8:	5b                   	pop    %ebx
80100ed9:	5e                   	pop    %esi
80100eda:	5f                   	pop    %edi
80100edb:	5d                   	pop    %ebp
    release(&ftable.lock);
80100edc:	e9 8f 35 00 00       	jmp    80104470 <release>
80100ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100ee8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100eec:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100eee:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100ef4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100efa:	88 45 e7             	mov    %al,-0x19(%ebp)
80100efd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f00:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f05:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f08:	e8 63 35 00 00       	call   80104470 <release>
  if(ff.type == FD_PIPE)
80100f0d:	83 c4 10             	add    $0x10,%esp
80100f10:	83 ff 01             	cmp    $0x1,%edi
80100f13:	74 13                	je     80100f28 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100f15:	83 ff 02             	cmp    $0x2,%edi
80100f18:	74 26                	je     80100f40 <fileclose+0xa0>
}
80100f1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f1d:	5b                   	pop    %ebx
80100f1e:	5e                   	pop    %esi
80100f1f:	5f                   	pop    %edi
80100f20:	5d                   	pop    %ebp
80100f21:	c3                   	ret    
80100f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f28:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f2c:	83 ec 08             	sub    $0x8,%esp
80100f2f:	53                   	push   %ebx
80100f30:	56                   	push   %esi
80100f31:	e8 8a 24 00 00       	call   801033c0 <pipeclose>
80100f36:	83 c4 10             	add    $0x10,%esp
80100f39:	eb df                	jmp    80100f1a <fileclose+0x7a>
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f40:	e8 cb 1c 00 00       	call   80102c10 <begin_op>
    iput(ff.ip);
80100f45:	83 ec 0c             	sub    $0xc,%esp
80100f48:	ff 75 e0             	pushl  -0x20(%ebp)
80100f4b:	e8 d0 08 00 00       	call   80101820 <iput>
    end_op();
80100f50:	83 c4 10             	add    $0x10,%esp
}
80100f53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f56:	5b                   	pop    %ebx
80100f57:	5e                   	pop    %esi
80100f58:	5f                   	pop    %edi
80100f59:	5d                   	pop    %ebp
    end_op();
80100f5a:	e9 21 1d 00 00       	jmp    80102c80 <end_op>
    panic("fileclose");
80100f5f:	83 ec 0c             	sub    $0xc,%esp
80100f62:	68 bc 6f 10 80       	push   $0x80106fbc
80100f67:	e8 24 f4 ff ff       	call   80100390 <panic>
80100f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f70 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	53                   	push   %ebx
80100f74:	83 ec 04             	sub    $0x4,%esp
80100f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f7a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f7d:	75 31                	jne    80100fb0 <filestat+0x40>
    ilock(f->ip);
80100f7f:	83 ec 0c             	sub    $0xc,%esp
80100f82:	ff 73 10             	pushl  0x10(%ebx)
80100f85:	e8 66 07 00 00       	call   801016f0 <ilock>
    stati(f->ip, st);
80100f8a:	58                   	pop    %eax
80100f8b:	5a                   	pop    %edx
80100f8c:	ff 75 0c             	pushl  0xc(%ebp)
80100f8f:	ff 73 10             	pushl  0x10(%ebx)
80100f92:	e8 09 0a 00 00       	call   801019a0 <stati>
    iunlock(f->ip);
80100f97:	59                   	pop    %ecx
80100f98:	ff 73 10             	pushl  0x10(%ebx)
80100f9b:	e8 30 08 00 00       	call   801017d0 <iunlock>
    return 0;
80100fa0:	83 c4 10             	add    $0x10,%esp
80100fa3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fa8:	c9                   	leave  
80100fa9:	c3                   	ret    
80100faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fb5:	eb ee                	jmp    80100fa5 <filestat+0x35>
80100fb7:	89 f6                	mov    %esi,%esi
80100fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fc0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 0c             	sub    $0xc,%esp
80100fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fcc:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fcf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fd2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fd6:	74 60                	je     80101038 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100fd8:	8b 03                	mov    (%ebx),%eax
80100fda:	83 f8 01             	cmp    $0x1,%eax
80100fdd:	74 41                	je     80101020 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fdf:	83 f8 02             	cmp    $0x2,%eax
80100fe2:	75 5b                	jne    8010103f <fileread+0x7f>
    ilock(f->ip);
80100fe4:	83 ec 0c             	sub    $0xc,%esp
80100fe7:	ff 73 10             	pushl  0x10(%ebx)
80100fea:	e8 01 07 00 00       	call   801016f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fef:	57                   	push   %edi
80100ff0:	ff 73 14             	pushl  0x14(%ebx)
80100ff3:	56                   	push   %esi
80100ff4:	ff 73 10             	pushl  0x10(%ebx)
80100ff7:	e8 d4 09 00 00       	call   801019d0 <readi>
80100ffc:	83 c4 20             	add    $0x20,%esp
80100fff:	85 c0                	test   %eax,%eax
80101001:	89 c6                	mov    %eax,%esi
80101003:	7e 03                	jle    80101008 <fileread+0x48>
      f->off += r;
80101005:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101008:	83 ec 0c             	sub    $0xc,%esp
8010100b:	ff 73 10             	pushl  0x10(%ebx)
8010100e:	e8 bd 07 00 00       	call   801017d0 <iunlock>
    return r;
80101013:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101016:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101019:	89 f0                	mov    %esi,%eax
8010101b:	5b                   	pop    %ebx
8010101c:	5e                   	pop    %esi
8010101d:	5f                   	pop    %edi
8010101e:	5d                   	pop    %ebp
8010101f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101020:	8b 43 0c             	mov    0xc(%ebx),%eax
80101023:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101026:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101029:	5b                   	pop    %ebx
8010102a:	5e                   	pop    %esi
8010102b:	5f                   	pop    %edi
8010102c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010102d:	e9 3e 25 00 00       	jmp    80103570 <piperead>
80101032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101038:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010103d:	eb d7                	jmp    80101016 <fileread+0x56>
  panic("fileread");
8010103f:	83 ec 0c             	sub    $0xc,%esp
80101042:	68 c6 6f 10 80       	push   $0x80106fc6
80101047:	e8 44 f3 ff ff       	call   80100390 <panic>
8010104c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101050 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101050:	55                   	push   %ebp
80101051:	89 e5                	mov    %esp,%ebp
80101053:	57                   	push   %edi
80101054:	56                   	push   %esi
80101055:	53                   	push   %ebx
80101056:	83 ec 1c             	sub    $0x1c,%esp
80101059:	8b 75 08             	mov    0x8(%ebp),%esi
8010105c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010105f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101063:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101066:	8b 45 10             	mov    0x10(%ebp),%eax
80101069:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010106c:	0f 84 aa 00 00 00    	je     8010111c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101072:	8b 06                	mov    (%esi),%eax
80101074:	83 f8 01             	cmp    $0x1,%eax
80101077:	0f 84 c3 00 00 00    	je     80101140 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010107d:	83 f8 02             	cmp    $0x2,%eax
80101080:	0f 85 d9 00 00 00    	jne    8010115f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101089:	31 ff                	xor    %edi,%edi
    while(i < n){
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 34                	jg     801010c3 <filewrite+0x73>
8010108f:	e9 9c 00 00 00       	jmp    80101130 <filewrite+0xe0>
80101094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101098:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010109b:	83 ec 0c             	sub    $0xc,%esp
8010109e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010a4:	e8 27 07 00 00       	call   801017d0 <iunlock>
      end_op();
801010a9:	e8 d2 1b 00 00       	call   80102c80 <end_op>
801010ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801010b4:	39 c3                	cmp    %eax,%ebx
801010b6:	0f 85 96 00 00 00    	jne    80101152 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801010bc:	01 df                	add    %ebx,%edi
    while(i < n){
801010be:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010c1:	7e 6d                	jle    80101130 <filewrite+0xe0>
      int n1 = n - i;
801010c3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010c6:	b8 00 06 00 00       	mov    $0x600,%eax
801010cb:	29 fb                	sub    %edi,%ebx
801010cd:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010d3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010d6:	e8 35 1b 00 00       	call   80102c10 <begin_op>
      ilock(f->ip);
801010db:	83 ec 0c             	sub    $0xc,%esp
801010de:	ff 76 10             	pushl  0x10(%esi)
801010e1:	e8 0a 06 00 00       	call   801016f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010e9:	53                   	push   %ebx
801010ea:	ff 76 14             	pushl  0x14(%esi)
801010ed:	01 f8                	add    %edi,%eax
801010ef:	50                   	push   %eax
801010f0:	ff 76 10             	pushl  0x10(%esi)
801010f3:	e8 d8 09 00 00       	call   80101ad0 <writei>
801010f8:	83 c4 20             	add    $0x20,%esp
801010fb:	85 c0                	test   %eax,%eax
801010fd:	7f 99                	jg     80101098 <filewrite+0x48>
      iunlock(f->ip);
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	ff 76 10             	pushl  0x10(%esi)
80101105:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101108:	e8 c3 06 00 00       	call   801017d0 <iunlock>
      end_op();
8010110d:	e8 6e 1b 00 00       	call   80102c80 <end_op>
      if(r < 0)
80101112:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101115:	83 c4 10             	add    $0x10,%esp
80101118:	85 c0                	test   %eax,%eax
8010111a:	74 98                	je     801010b4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010111c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010111f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101124:	89 f8                	mov    %edi,%eax
80101126:	5b                   	pop    %ebx
80101127:	5e                   	pop    %esi
80101128:	5f                   	pop    %edi
80101129:	5d                   	pop    %ebp
8010112a:	c3                   	ret    
8010112b:	90                   	nop
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101130:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101133:	75 e7                	jne    8010111c <filewrite+0xcc>
}
80101135:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101138:	89 f8                	mov    %edi,%eax
8010113a:	5b                   	pop    %ebx
8010113b:	5e                   	pop    %esi
8010113c:	5f                   	pop    %edi
8010113d:	5d                   	pop    %ebp
8010113e:	c3                   	ret    
8010113f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101140:	8b 46 0c             	mov    0xc(%esi),%eax
80101143:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101146:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101149:	5b                   	pop    %ebx
8010114a:	5e                   	pop    %esi
8010114b:	5f                   	pop    %edi
8010114c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010114d:	e9 0e 23 00 00       	jmp    80103460 <pipewrite>
        panic("short filewrite");
80101152:	83 ec 0c             	sub    $0xc,%esp
80101155:	68 cf 6f 10 80       	push   $0x80106fcf
8010115a:	e8 31 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	68 d5 6f 10 80       	push   $0x80106fd5
80101167:	e8 24 f2 ff ff       	call   80100390 <panic>
8010116c:	66 90                	xchg   %ax,%ax
8010116e:	66 90                	xchg   %ax,%ax

80101170 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	57                   	push   %edi
80101174:	56                   	push   %esi
80101175:	53                   	push   %ebx
80101176:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101179:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010117f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101182:	85 c9                	test   %ecx,%ecx
80101184:	0f 84 87 00 00 00    	je     80101211 <balloc+0xa1>
8010118a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101191:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101194:	83 ec 08             	sub    $0x8,%esp
80101197:	89 f0                	mov    %esi,%eax
80101199:	c1 f8 0c             	sar    $0xc,%eax
8010119c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011a2:	50                   	push   %eax
801011a3:	ff 75 d8             	pushl  -0x28(%ebp)
801011a6:	e8 25 ef ff ff       	call   801000d0 <bread>
801011ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ae:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011b3:	83 c4 10             	add    $0x10,%esp
801011b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011b9:	31 c0                	xor    %eax,%eax
801011bb:	eb 2f                	jmp    801011ec <balloc+0x7c>
801011bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011c0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011c5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011ca:	83 e1 07             	and    $0x7,%ecx
801011cd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011cf:	89 c1                	mov    %eax,%ecx
801011d1:	c1 f9 03             	sar    $0x3,%ecx
801011d4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011d9:	85 df                	test   %ebx,%edi
801011db:	89 fa                	mov    %edi,%edx
801011dd:	74 41                	je     80101220 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011df:	83 c0 01             	add    $0x1,%eax
801011e2:	83 c6 01             	add    $0x1,%esi
801011e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011ea:	74 05                	je     801011f1 <balloc+0x81>
801011ec:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ef:	77 cf                	ja     801011c0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801011f7:	e8 e4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801011fc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101203:	83 c4 10             	add    $0x10,%esp
80101206:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101209:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010120f:	77 80                	ja     80101191 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101211:	83 ec 0c             	sub    $0xc,%esp
80101214:	68 df 6f 10 80       	push   $0x80106fdf
80101219:	e8 72 f1 ff ff       	call   80100390 <panic>
8010121e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101220:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101223:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101226:	09 da                	or     %ebx,%edx
80101228:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010122c:	57                   	push   %edi
8010122d:	e8 ae 1b 00 00       	call   80102de0 <log_write>
        brelse(bp);
80101232:	89 3c 24             	mov    %edi,(%esp)
80101235:	e8 a6 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010123a:	58                   	pop    %eax
8010123b:	5a                   	pop    %edx
8010123c:	56                   	push   %esi
8010123d:	ff 75 d8             	pushl  -0x28(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101247:	8d 40 5c             	lea    0x5c(%eax),%eax
8010124a:	83 c4 0c             	add    $0xc,%esp
8010124d:	68 00 02 00 00       	push   $0x200
80101252:	6a 00                	push   $0x0
80101254:	50                   	push   %eax
80101255:	e8 66 32 00 00       	call   801044c0 <memset>
  log_write(bp);
8010125a:	89 1c 24             	mov    %ebx,(%esp)
8010125d:	e8 7e 1b 00 00       	call   80102de0 <log_write>
  brelse(bp);
80101262:	89 1c 24             	mov    %ebx,(%esp)
80101265:	e8 76 ef ff ff       	call   801001e0 <brelse>
}
8010126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126d:	89 f0                	mov    %esi,%eax
8010126f:	5b                   	pop    %ebx
80101270:	5e                   	pop    %esi
80101271:	5f                   	pop    %edi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret    
80101274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010127a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101280 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101288:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010128f:	83 ec 28             	sub    $0x28,%esp
80101292:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101295:	68 e0 09 11 80       	push   $0x801109e0
8010129a:	e8 11 31 00 00       	call   801043b0 <acquire>
8010129f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012a5:	eb 17                	jmp    801012be <iget+0x3e>
801012a7:	89 f6                	mov    %esi,%esi
801012a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012b0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012b6:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012bc:	73 22                	jae    801012e0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012c1:	85 c9                	test   %ecx,%ecx
801012c3:	7e 04                	jle    801012c9 <iget+0x49>
801012c5:	39 3b                	cmp    %edi,(%ebx)
801012c7:	74 4f                	je     80101318 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012c9:	85 f6                	test   %esi,%esi
801012cb:	75 e3                	jne    801012b0 <iget+0x30>
801012cd:	85 c9                	test   %ecx,%ecx
801012cf:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012d2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012d8:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012de:	72 de                	jb     801012be <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012e0:	85 f6                	test   %esi,%esi
801012e2:	74 5b                	je     8010133f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012e4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012e7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012e9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012ec:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012f3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012fa:	68 e0 09 11 80       	push   $0x801109e0
801012ff:	e8 6c 31 00 00       	call   80104470 <release>

  return ip;
80101304:	83 c4 10             	add    $0x10,%esp
}
80101307:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130a:	89 f0                	mov    %esi,%eax
8010130c:	5b                   	pop    %ebx
8010130d:	5e                   	pop    %esi
8010130e:	5f                   	pop    %edi
8010130f:	5d                   	pop    %ebp
80101310:	c3                   	ret    
80101311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101318:	39 53 04             	cmp    %edx,0x4(%ebx)
8010131b:	75 ac                	jne    801012c9 <iget+0x49>
      release(&icache.lock);
8010131d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101320:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101323:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101325:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
8010132a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010132d:	e8 3e 31 00 00       	call   80104470 <release>
      return ip;
80101332:	83 c4 10             	add    $0x10,%esp
}
80101335:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101338:	89 f0                	mov    %esi,%eax
8010133a:	5b                   	pop    %ebx
8010133b:	5e                   	pop    %esi
8010133c:	5f                   	pop    %edi
8010133d:	5d                   	pop    %ebp
8010133e:	c3                   	ret    
    panic("iget: no inodes");
8010133f:	83 ec 0c             	sub    $0xc,%esp
80101342:	68 f5 6f 10 80       	push   $0x80106ff5
80101347:	e8 44 f0 ff ff       	call   80100390 <panic>
8010134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101350 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	89 c6                	mov    %eax,%esi
80101358:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010135b:	83 fa 0b             	cmp    $0xb,%edx
8010135e:	77 18                	ja     80101378 <bmap+0x28>
80101360:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101363:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101366:	85 db                	test   %ebx,%ebx
80101368:	74 76                	je     801013e0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010136a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010136d:	89 d8                	mov    %ebx,%eax
8010136f:	5b                   	pop    %ebx
80101370:	5e                   	pop    %esi
80101371:	5f                   	pop    %edi
80101372:	5d                   	pop    %ebp
80101373:	c3                   	ret    
80101374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101378:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010137b:	83 fb 7f             	cmp    $0x7f,%ebx
8010137e:	0f 87 90 00 00 00    	ja     80101414 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101384:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010138a:	8b 00                	mov    (%eax),%eax
8010138c:	85 d2                	test   %edx,%edx
8010138e:	74 70                	je     80101400 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101390:	83 ec 08             	sub    $0x8,%esp
80101393:	52                   	push   %edx
80101394:	50                   	push   %eax
80101395:	e8 36 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010139a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010139e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013a1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013a3:	8b 1a                	mov    (%edx),%ebx
801013a5:	85 db                	test   %ebx,%ebx
801013a7:	75 1d                	jne    801013c6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013a9:	8b 06                	mov    (%esi),%eax
801013ab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013ae:	e8 bd fd ff ff       	call   80101170 <balloc>
801013b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013b6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013b9:	89 c3                	mov    %eax,%ebx
801013bb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013bd:	57                   	push   %edi
801013be:	e8 1d 1a 00 00       	call   80102de0 <log_write>
801013c3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
801013c9:	57                   	push   %edi
801013ca:	e8 11 ee ff ff       	call   801001e0 <brelse>
801013cf:	83 c4 10             	add    $0x10,%esp
}
801013d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d5:	89 d8                	mov    %ebx,%eax
801013d7:	5b                   	pop    %ebx
801013d8:	5e                   	pop    %esi
801013d9:	5f                   	pop    %edi
801013da:	5d                   	pop    %ebp
801013db:	c3                   	ret    
801013dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013e0:	8b 00                	mov    (%eax),%eax
801013e2:	e8 89 fd ff ff       	call   80101170 <balloc>
801013e7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013ed:	89 c3                	mov    %eax,%ebx
}
801013ef:	89 d8                	mov    %ebx,%eax
801013f1:	5b                   	pop    %ebx
801013f2:	5e                   	pop    %esi
801013f3:	5f                   	pop    %edi
801013f4:	5d                   	pop    %ebp
801013f5:	c3                   	ret    
801013f6:	8d 76 00             	lea    0x0(%esi),%esi
801013f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101400:	e8 6b fd ff ff       	call   80101170 <balloc>
80101405:	89 c2                	mov    %eax,%edx
80101407:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010140d:	8b 06                	mov    (%esi),%eax
8010140f:	e9 7c ff ff ff       	jmp    80101390 <bmap+0x40>
  panic("bmap: out of range");
80101414:	83 ec 0c             	sub    $0xc,%esp
80101417:	68 05 70 10 80       	push   $0x80107005
8010141c:	e8 6f ef ff ff       	call   80100390 <panic>
80101421:	eb 0d                	jmp    80101430 <readsb>
80101423:	90                   	nop
80101424:	90                   	nop
80101425:	90                   	nop
80101426:	90                   	nop
80101427:	90                   	nop
80101428:	90                   	nop
80101429:	90                   	nop
8010142a:	90                   	nop
8010142b:	90                   	nop
8010142c:	90                   	nop
8010142d:	90                   	nop
8010142e:	90                   	nop
8010142f:	90                   	nop

80101430 <readsb>:
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	56                   	push   %esi
80101434:	53                   	push   %ebx
80101435:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101438:	83 ec 08             	sub    $0x8,%esp
8010143b:	6a 01                	push   $0x1
8010143d:	ff 75 08             	pushl  0x8(%ebp)
80101440:	e8 8b ec ff ff       	call   801000d0 <bread>
80101445:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101447:	8d 40 5c             	lea    0x5c(%eax),%eax
8010144a:	83 c4 0c             	add    $0xc,%esp
8010144d:	6a 1c                	push   $0x1c
8010144f:	50                   	push   %eax
80101450:	56                   	push   %esi
80101451:	e8 1a 31 00 00       	call   80104570 <memmove>
  brelse(bp);
80101456:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101459:	83 c4 10             	add    $0x10,%esp
}
8010145c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5d                   	pop    %ebp
  brelse(bp);
80101462:	e9 79 ed ff ff       	jmp    801001e0 <brelse>
80101467:	89 f6                	mov    %esi,%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <bfree>:
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	56                   	push   %esi
80101474:	53                   	push   %ebx
80101475:	89 d3                	mov    %edx,%ebx
80101477:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101479:	83 ec 08             	sub    $0x8,%esp
8010147c:	68 c0 09 11 80       	push   $0x801109c0
80101481:	50                   	push   %eax
80101482:	e8 a9 ff ff ff       	call   80101430 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101487:	58                   	pop    %eax
80101488:	5a                   	pop    %edx
80101489:	89 da                	mov    %ebx,%edx
8010148b:	c1 ea 0c             	shr    $0xc,%edx
8010148e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101494:	52                   	push   %edx
80101495:	56                   	push   %esi
80101496:	e8 35 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010149b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010149d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014a0:	ba 01 00 00 00       	mov    $0x1,%edx
801014a5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014a8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014ae:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014b1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014b3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014b8:	85 d1                	test   %edx,%ecx
801014ba:	74 25                	je     801014e1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801014bc:	f7 d2                	not    %edx
801014be:	89 c6                	mov    %eax,%esi
  log_write(bp);
801014c0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014c3:	21 ca                	and    %ecx,%edx
801014c5:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801014c9:	56                   	push   %esi
801014ca:	e8 11 19 00 00       	call   80102de0 <log_write>
  brelse(bp);
801014cf:	89 34 24             	mov    %esi,(%esp)
801014d2:	e8 09 ed ff ff       	call   801001e0 <brelse>
}
801014d7:	83 c4 10             	add    $0x10,%esp
801014da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014dd:	5b                   	pop    %ebx
801014de:	5e                   	pop    %esi
801014df:	5d                   	pop    %ebp
801014e0:	c3                   	ret    
    panic("freeing free block");
801014e1:	83 ec 0c             	sub    $0xc,%esp
801014e4:	68 18 70 10 80       	push   $0x80107018
801014e9:	e8 a2 ee ff ff       	call   80100390 <panic>
801014ee:	66 90                	xchg   %ax,%ax

801014f0 <iinit>:
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	53                   	push   %ebx
801014f4:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
801014f9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014fc:	68 2b 70 10 80       	push   $0x8010702b
80101501:	68 e0 09 11 80       	push   $0x801109e0
80101506:	e8 65 2d 00 00       	call   80104270 <initlock>
8010150b:	83 c4 10             	add    $0x10,%esp
8010150e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101510:	83 ec 08             	sub    $0x8,%esp
80101513:	68 32 70 10 80       	push   $0x80107032
80101518:	53                   	push   %ebx
80101519:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010151f:	e8 1c 2c 00 00       	call   80104140 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101524:	83 c4 10             	add    $0x10,%esp
80101527:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010152d:	75 e1                	jne    80101510 <iinit+0x20>
  readsb(dev, &sb);
8010152f:	83 ec 08             	sub    $0x8,%esp
80101532:	68 c0 09 11 80       	push   $0x801109c0
80101537:	ff 75 08             	pushl  0x8(%ebp)
8010153a:	e8 f1 fe ff ff       	call   80101430 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010153f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101545:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010154b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101551:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101557:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010155d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101563:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101569:	68 98 70 10 80       	push   $0x80107098
8010156e:	e8 ed f0 ff ff       	call   80100660 <cprintf>
}
80101573:	83 c4 30             	add    $0x30,%esp
80101576:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101579:	c9                   	leave  
8010157a:	c3                   	ret    
8010157b:	90                   	nop
8010157c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101580 <ialloc>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	57                   	push   %edi
80101584:	56                   	push   %esi
80101585:	53                   	push   %ebx
80101586:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101589:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101590:	8b 45 0c             	mov    0xc(%ebp),%eax
80101593:	8b 75 08             	mov    0x8(%ebp),%esi
80101596:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101599:	0f 86 91 00 00 00    	jbe    80101630 <ialloc+0xb0>
8010159f:	bb 01 00 00 00       	mov    $0x1,%ebx
801015a4:	eb 21                	jmp    801015c7 <ialloc+0x47>
801015a6:	8d 76 00             	lea    0x0(%esi),%esi
801015a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801015b0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015b3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015b6:	57                   	push   %edi
801015b7:	e8 24 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015bc:	83 c4 10             	add    $0x10,%esp
801015bf:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
801015c5:	76 69                	jbe    80101630 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015c7:	89 d8                	mov    %ebx,%eax
801015c9:	83 ec 08             	sub    $0x8,%esp
801015cc:	c1 e8 03             	shr    $0x3,%eax
801015cf:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015d5:	50                   	push   %eax
801015d6:	56                   	push   %esi
801015d7:	e8 f4 ea ff ff       	call   801000d0 <bread>
801015dc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015de:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015e0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801015e3:	83 e0 07             	and    $0x7,%eax
801015e6:	c1 e0 06             	shl    $0x6,%eax
801015e9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ed:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015f1:	75 bd                	jne    801015b0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015f3:	83 ec 04             	sub    $0x4,%esp
801015f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015f9:	6a 40                	push   $0x40
801015fb:	6a 00                	push   $0x0
801015fd:	51                   	push   %ecx
801015fe:	e8 bd 2e 00 00       	call   801044c0 <memset>
      dip->type = type;
80101603:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101607:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010160a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010160d:	89 3c 24             	mov    %edi,(%esp)
80101610:	e8 cb 17 00 00       	call   80102de0 <log_write>
      brelse(bp);
80101615:	89 3c 24             	mov    %edi,(%esp)
80101618:	e8 c3 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010161d:	83 c4 10             	add    $0x10,%esp
}
80101620:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101623:	89 da                	mov    %ebx,%edx
80101625:	89 f0                	mov    %esi,%eax
}
80101627:	5b                   	pop    %ebx
80101628:	5e                   	pop    %esi
80101629:	5f                   	pop    %edi
8010162a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010162b:	e9 50 fc ff ff       	jmp    80101280 <iget>
  panic("ialloc: no inodes");
80101630:	83 ec 0c             	sub    $0xc,%esp
80101633:	68 38 70 10 80       	push   $0x80107038
80101638:	e8 53 ed ff ff       	call   80100390 <panic>
8010163d:	8d 76 00             	lea    0x0(%esi),%esi

80101640 <iupdate>:
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	56                   	push   %esi
80101644:	53                   	push   %ebx
80101645:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101648:	83 ec 08             	sub    $0x8,%esp
8010164b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010164e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101651:	c1 e8 03             	shr    $0x3,%eax
80101654:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010165a:	50                   	push   %eax
8010165b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010165e:	e8 6d ea ff ff       	call   801000d0 <bread>
80101663:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101665:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101668:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010166f:	83 e0 07             	and    $0x7,%eax
80101672:	c1 e0 06             	shl    $0x6,%eax
80101675:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101679:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010167c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101680:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101683:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101687:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010168b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010168f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101693:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101697:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010169a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010169d:	6a 34                	push   $0x34
8010169f:	53                   	push   %ebx
801016a0:	50                   	push   %eax
801016a1:	e8 ca 2e 00 00       	call   80104570 <memmove>
  log_write(bp);
801016a6:	89 34 24             	mov    %esi,(%esp)
801016a9:	e8 32 17 00 00       	call   80102de0 <log_write>
  brelse(bp);
801016ae:	89 75 08             	mov    %esi,0x8(%ebp)
801016b1:	83 c4 10             	add    $0x10,%esp
}
801016b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b7:	5b                   	pop    %ebx
801016b8:	5e                   	pop    %esi
801016b9:	5d                   	pop    %ebp
  brelse(bp);
801016ba:	e9 21 eb ff ff       	jmp    801001e0 <brelse>
801016bf:	90                   	nop

801016c0 <idup>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	53                   	push   %ebx
801016c4:	83 ec 10             	sub    $0x10,%esp
801016c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ca:	68 e0 09 11 80       	push   $0x801109e0
801016cf:	e8 dc 2c 00 00       	call   801043b0 <acquire>
  ip->ref++;
801016d4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016d8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016df:	e8 8c 2d 00 00       	call   80104470 <release>
}
801016e4:	89 d8                	mov    %ebx,%eax
801016e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016e9:	c9                   	leave  
801016ea:	c3                   	ret    
801016eb:	90                   	nop
801016ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016f0 <ilock>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016f8:	85 db                	test   %ebx,%ebx
801016fa:	0f 84 b7 00 00 00    	je     801017b7 <ilock+0xc7>
80101700:	8b 53 08             	mov    0x8(%ebx),%edx
80101703:	85 d2                	test   %edx,%edx
80101705:	0f 8e ac 00 00 00    	jle    801017b7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010170b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010170e:	83 ec 0c             	sub    $0xc,%esp
80101711:	50                   	push   %eax
80101712:	e8 69 2a 00 00       	call   80104180 <acquiresleep>
  if(ip->valid == 0){
80101717:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010171a:	83 c4 10             	add    $0x10,%esp
8010171d:	85 c0                	test   %eax,%eax
8010171f:	74 0f                	je     80101730 <ilock+0x40>
}
80101721:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101724:	5b                   	pop    %ebx
80101725:	5e                   	pop    %esi
80101726:	5d                   	pop    %ebp
80101727:	c3                   	ret    
80101728:	90                   	nop
80101729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101730:	8b 43 04             	mov    0x4(%ebx),%eax
80101733:	83 ec 08             	sub    $0x8,%esp
80101736:	c1 e8 03             	shr    $0x3,%eax
80101739:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010173f:	50                   	push   %eax
80101740:	ff 33                	pushl  (%ebx)
80101742:	e8 89 e9 ff ff       	call   801000d0 <bread>
80101747:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101749:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010174c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010174f:	83 e0 07             	and    $0x7,%eax
80101752:	c1 e0 06             	shl    $0x6,%eax
80101755:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101759:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010175c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010175f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101763:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101767:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010176b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010176f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101773:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101777:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010177b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010177e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101781:	6a 34                	push   $0x34
80101783:	50                   	push   %eax
80101784:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101787:	50                   	push   %eax
80101788:	e8 e3 2d 00 00       	call   80104570 <memmove>
    brelse(bp);
8010178d:	89 34 24             	mov    %esi,(%esp)
80101790:	e8 4b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101795:	83 c4 10             	add    $0x10,%esp
80101798:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010179d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017a4:	0f 85 77 ff ff ff    	jne    80101721 <ilock+0x31>
      panic("ilock: no type");
801017aa:	83 ec 0c             	sub    $0xc,%esp
801017ad:	68 50 70 10 80       	push   $0x80107050
801017b2:	e8 d9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017b7:	83 ec 0c             	sub    $0xc,%esp
801017ba:	68 4a 70 10 80       	push   $0x8010704a
801017bf:	e8 cc eb ff ff       	call   80100390 <panic>
801017c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017d0 <iunlock>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	56                   	push   %esi
801017d4:	53                   	push   %ebx
801017d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017d8:	85 db                	test   %ebx,%ebx
801017da:	74 28                	je     80101804 <iunlock+0x34>
801017dc:	8d 73 0c             	lea    0xc(%ebx),%esi
801017df:	83 ec 0c             	sub    $0xc,%esp
801017e2:	56                   	push   %esi
801017e3:	e8 38 2a 00 00       	call   80104220 <holdingsleep>
801017e8:	83 c4 10             	add    $0x10,%esp
801017eb:	85 c0                	test   %eax,%eax
801017ed:	74 15                	je     80101804 <iunlock+0x34>
801017ef:	8b 43 08             	mov    0x8(%ebx),%eax
801017f2:	85 c0                	test   %eax,%eax
801017f4:	7e 0e                	jle    80101804 <iunlock+0x34>
  releasesleep(&ip->lock);
801017f6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017ff:	e9 dc 29 00 00       	jmp    801041e0 <releasesleep>
    panic("iunlock");
80101804:	83 ec 0c             	sub    $0xc,%esp
80101807:	68 5f 70 10 80       	push   $0x8010705f
8010180c:	e8 7f eb ff ff       	call   80100390 <panic>
80101811:	eb 0d                	jmp    80101820 <iput>
80101813:	90                   	nop
80101814:	90                   	nop
80101815:	90                   	nop
80101816:	90                   	nop
80101817:	90                   	nop
80101818:	90                   	nop
80101819:	90                   	nop
8010181a:	90                   	nop
8010181b:	90                   	nop
8010181c:	90                   	nop
8010181d:	90                   	nop
8010181e:	90                   	nop
8010181f:	90                   	nop

80101820 <iput>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	57                   	push   %edi
80101824:	56                   	push   %esi
80101825:	53                   	push   %ebx
80101826:	83 ec 28             	sub    $0x28,%esp
80101829:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010182c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010182f:	57                   	push   %edi
80101830:	e8 4b 29 00 00       	call   80104180 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101835:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101838:	83 c4 10             	add    $0x10,%esp
8010183b:	85 d2                	test   %edx,%edx
8010183d:	74 07                	je     80101846 <iput+0x26>
8010183f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101844:	74 32                	je     80101878 <iput+0x58>
  releasesleep(&ip->lock);
80101846:	83 ec 0c             	sub    $0xc,%esp
80101849:	57                   	push   %edi
8010184a:	e8 91 29 00 00       	call   801041e0 <releasesleep>
  acquire(&icache.lock);
8010184f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101856:	e8 55 2b 00 00       	call   801043b0 <acquire>
  ip->ref--;
8010185b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010185f:	83 c4 10             	add    $0x10,%esp
80101862:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101869:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010186c:	5b                   	pop    %ebx
8010186d:	5e                   	pop    %esi
8010186e:	5f                   	pop    %edi
8010186f:	5d                   	pop    %ebp
  release(&icache.lock);
80101870:	e9 fb 2b 00 00       	jmp    80104470 <release>
80101875:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 e0 09 11 80       	push   $0x801109e0
80101880:	e8 2b 2b 00 00       	call   801043b0 <acquire>
    int r = ip->ref;
80101885:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101888:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010188f:	e8 dc 2b 00 00       	call   80104470 <release>
    if(r == 1){
80101894:	83 c4 10             	add    $0x10,%esp
80101897:	83 fe 01             	cmp    $0x1,%esi
8010189a:	75 aa                	jne    80101846 <iput+0x26>
8010189c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018a2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018a8:	89 cf                	mov    %ecx,%edi
801018aa:	eb 0b                	jmp    801018b7 <iput+0x97>
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018b0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018b3:	39 fe                	cmp    %edi,%esi
801018b5:	74 19                	je     801018d0 <iput+0xb0>
    if(ip->addrs[i]){
801018b7:	8b 16                	mov    (%esi),%edx
801018b9:	85 d2                	test   %edx,%edx
801018bb:	74 f3                	je     801018b0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018bd:	8b 03                	mov    (%ebx),%eax
801018bf:	e8 ac fb ff ff       	call   80101470 <bfree>
      ip->addrs[i] = 0;
801018c4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018ca:	eb e4                	jmp    801018b0 <iput+0x90>
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018d0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018d9:	85 c0                	test   %eax,%eax
801018db:	75 33                	jne    80101910 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018dd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018e0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018e7:	53                   	push   %ebx
801018e8:	e8 53 fd ff ff       	call   80101640 <iupdate>
      ip->type = 0;
801018ed:	31 c0                	xor    %eax,%eax
801018ef:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018f3:	89 1c 24             	mov    %ebx,(%esp)
801018f6:	e8 45 fd ff ff       	call   80101640 <iupdate>
      ip->valid = 0;
801018fb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101902:	83 c4 10             	add    $0x10,%esp
80101905:	e9 3c ff ff ff       	jmp    80101846 <iput+0x26>
8010190a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101910:	83 ec 08             	sub    $0x8,%esp
80101913:	50                   	push   %eax
80101914:	ff 33                	pushl  (%ebx)
80101916:	e8 b5 e7 ff ff       	call   801000d0 <bread>
8010191b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101921:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101924:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101927:	8d 70 5c             	lea    0x5c(%eax),%esi
8010192a:	83 c4 10             	add    $0x10,%esp
8010192d:	89 cf                	mov    %ecx,%edi
8010192f:	eb 0e                	jmp    8010193f <iput+0x11f>
80101931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101938:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010193b:	39 fe                	cmp    %edi,%esi
8010193d:	74 0f                	je     8010194e <iput+0x12e>
      if(a[j])
8010193f:	8b 16                	mov    (%esi),%edx
80101941:	85 d2                	test   %edx,%edx
80101943:	74 f3                	je     80101938 <iput+0x118>
        bfree(ip->dev, a[j]);
80101945:	8b 03                	mov    (%ebx),%eax
80101947:	e8 24 fb ff ff       	call   80101470 <bfree>
8010194c:	eb ea                	jmp    80101938 <iput+0x118>
    brelse(bp);
8010194e:	83 ec 0c             	sub    $0xc,%esp
80101951:	ff 75 e4             	pushl  -0x1c(%ebp)
80101954:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101957:	e8 84 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010195c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101962:	8b 03                	mov    (%ebx),%eax
80101964:	e8 07 fb ff ff       	call   80101470 <bfree>
    ip->addrs[NDIRECT] = 0;
80101969:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101970:	00 00 00 
80101973:	83 c4 10             	add    $0x10,%esp
80101976:	e9 62 ff ff ff       	jmp    801018dd <iput+0xbd>
8010197b:	90                   	nop
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101980 <iunlockput>:
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	53                   	push   %ebx
80101984:	83 ec 10             	sub    $0x10,%esp
80101987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010198a:	53                   	push   %ebx
8010198b:	e8 40 fe ff ff       	call   801017d0 <iunlock>
  iput(ip);
80101990:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101993:	83 c4 10             	add    $0x10,%esp
}
80101996:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101999:	c9                   	leave  
  iput(ip);
8010199a:	e9 81 fe ff ff       	jmp    80101820 <iput>
8010199f:	90                   	nop

801019a0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	8b 55 08             	mov    0x8(%ebp),%edx
801019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019a9:	8b 0a                	mov    (%edx),%ecx
801019ab:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019ae:	8b 4a 04             	mov    0x4(%edx),%ecx
801019b1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019b4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019b8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019bb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019bf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019c3:	8b 52 58             	mov    0x58(%edx),%edx
801019c6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019c9:	5d                   	pop    %ebp
801019ca:	c3                   	ret    
801019cb:	90                   	nop
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019d0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	57                   	push   %edi
801019d4:	56                   	push   %esi
801019d5:	53                   	push   %ebx
801019d6:	83 ec 1c             	sub    $0x1c,%esp
801019d9:	8b 45 08             	mov    0x8(%ebp),%eax
801019dc:	8b 75 0c             	mov    0xc(%ebp),%esi
801019df:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019e2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801019e7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019ed:	8b 75 10             	mov    0x10(%ebp),%esi
801019f0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019f3:	0f 84 a7 00 00 00    	je     80101aa0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019fc:	8b 40 58             	mov    0x58(%eax),%eax
801019ff:	39 c6                	cmp    %eax,%esi
80101a01:	0f 87 ba 00 00 00    	ja     80101ac1 <readi+0xf1>
80101a07:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a0a:	89 f9                	mov    %edi,%ecx
80101a0c:	01 f1                	add    %esi,%ecx
80101a0e:	0f 82 ad 00 00 00    	jb     80101ac1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a14:	89 c2                	mov    %eax,%edx
80101a16:	29 f2                	sub    %esi,%edx
80101a18:	39 c8                	cmp    %ecx,%eax
80101a1a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a1d:	31 ff                	xor    %edi,%edi
80101a1f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101a21:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a24:	74 6c                	je     80101a92 <readi+0xc2>
80101a26:	8d 76 00             	lea    0x0(%esi),%esi
80101a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a30:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a33:	89 f2                	mov    %esi,%edx
80101a35:	c1 ea 09             	shr    $0x9,%edx
80101a38:	89 d8                	mov    %ebx,%eax
80101a3a:	e8 11 f9 ff ff       	call   80101350 <bmap>
80101a3f:	83 ec 08             	sub    $0x8,%esp
80101a42:	50                   	push   %eax
80101a43:	ff 33                	pushl  (%ebx)
80101a45:	e8 86 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a4a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a4d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a4f:	89 f0                	mov    %esi,%eax
80101a51:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a56:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a5b:	83 c4 0c             	add    $0xc,%esp
80101a5e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a60:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a64:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a67:	29 fb                	sub    %edi,%ebx
80101a69:	39 d9                	cmp    %ebx,%ecx
80101a6b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a6e:	53                   	push   %ebx
80101a6f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a70:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a72:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a75:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a77:	e8 f4 2a 00 00       	call   80104570 <memmove>
    brelse(bp);
80101a7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a7f:	89 14 24             	mov    %edx,(%esp)
80101a82:	e8 59 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a87:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a8a:	83 c4 10             	add    $0x10,%esp
80101a8d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a90:	77 9e                	ja     80101a30 <readi+0x60>
  }
  return n;
80101a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a98:	5b                   	pop    %ebx
80101a99:	5e                   	pop    %esi
80101a9a:	5f                   	pop    %edi
80101a9b:	5d                   	pop    %ebp
80101a9c:	c3                   	ret    
80101a9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101aa0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101aa4:	66 83 f8 09          	cmp    $0x9,%ax
80101aa8:	77 17                	ja     80101ac1 <readi+0xf1>
80101aaa:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101ab1:	85 c0                	test   %eax,%eax
80101ab3:	74 0c                	je     80101ac1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ab5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ab8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101abb:	5b                   	pop    %ebx
80101abc:	5e                   	pop    %esi
80101abd:	5f                   	pop    %edi
80101abe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101abf:	ff e0                	jmp    *%eax
      return -1;
80101ac1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ac6:	eb cd                	jmp    80101a95 <readi+0xc5>
80101ac8:	90                   	nop
80101ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ad0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	57                   	push   %edi
80101ad4:	56                   	push   %esi
80101ad5:	53                   	push   %ebx
80101ad6:	83 ec 1c             	sub    $0x1c,%esp
80101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80101adc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101adf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ae2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ae7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aea:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aed:	8b 75 10             	mov    0x10(%ebp),%esi
80101af0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101af3:	0f 84 b7 00 00 00    	je     80101bb0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101af9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101afc:	39 70 58             	cmp    %esi,0x58(%eax)
80101aff:	0f 82 eb 00 00 00    	jb     80101bf0 <writei+0x120>
80101b05:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b08:	31 d2                	xor    %edx,%edx
80101b0a:	89 f8                	mov    %edi,%eax
80101b0c:	01 f0                	add    %esi,%eax
80101b0e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b11:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b16:	0f 87 d4 00 00 00    	ja     80101bf0 <writei+0x120>
80101b1c:	85 d2                	test   %edx,%edx
80101b1e:	0f 85 cc 00 00 00    	jne    80101bf0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b24:	85 ff                	test   %edi,%edi
80101b26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b2d:	74 72                	je     80101ba1 <writei+0xd1>
80101b2f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b30:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b33:	89 f2                	mov    %esi,%edx
80101b35:	c1 ea 09             	shr    $0x9,%edx
80101b38:	89 f8                	mov    %edi,%eax
80101b3a:	e8 11 f8 ff ff       	call   80101350 <bmap>
80101b3f:	83 ec 08             	sub    $0x8,%esp
80101b42:	50                   	push   %eax
80101b43:	ff 37                	pushl  (%edi)
80101b45:	e8 86 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b4a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b4d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b50:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b52:	89 f0                	mov    %esi,%eax
80101b54:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b59:	83 c4 0c             	add    $0xc,%esp
80101b5c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b61:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b63:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b67:	39 d9                	cmp    %ebx,%ecx
80101b69:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b6c:	53                   	push   %ebx
80101b6d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b70:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b72:	50                   	push   %eax
80101b73:	e8 f8 29 00 00       	call   80104570 <memmove>
    log_write(bp);
80101b78:	89 3c 24             	mov    %edi,(%esp)
80101b7b:	e8 60 12 00 00       	call   80102de0 <log_write>
    brelse(bp);
80101b80:	89 3c 24             	mov    %edi,(%esp)
80101b83:	e8 58 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b88:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b8b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b8e:	83 c4 10             	add    $0x10,%esp
80101b91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b94:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b97:	77 97                	ja     80101b30 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b9c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b9f:	77 37                	ja     80101bd8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ba1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ba4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ba7:	5b                   	pop    %ebx
80101ba8:	5e                   	pop    %esi
80101ba9:	5f                   	pop    %edi
80101baa:	5d                   	pop    %ebp
80101bab:	c3                   	ret    
80101bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bb0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bb4:	66 83 f8 09          	cmp    $0x9,%ax
80101bb8:	77 36                	ja     80101bf0 <writei+0x120>
80101bba:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101bc1:	85 c0                	test   %eax,%eax
80101bc3:	74 2b                	je     80101bf0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101bc5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bcb:	5b                   	pop    %ebx
80101bcc:	5e                   	pop    %esi
80101bcd:	5f                   	pop    %edi
80101bce:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bcf:	ff e0                	jmp    *%eax
80101bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101bd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bdb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101bde:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101be1:	50                   	push   %eax
80101be2:	e8 59 fa ff ff       	call   80101640 <iupdate>
80101be7:	83 c4 10             	add    $0x10,%esp
80101bea:	eb b5                	jmp    80101ba1 <writei+0xd1>
80101bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bf5:	eb ad                	jmp    80101ba4 <writei+0xd4>
80101bf7:	89 f6                	mov    %esi,%esi
80101bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c00 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c06:	6a 0e                	push   $0xe
80101c08:	ff 75 0c             	pushl  0xc(%ebp)
80101c0b:	ff 75 08             	pushl  0x8(%ebp)
80101c0e:	e8 cd 29 00 00       	call   801045e0 <strncmp>
}
80101c13:	c9                   	leave  
80101c14:	c3                   	ret    
80101c15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	83 ec 1c             	sub    $0x1c,%esp
80101c29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c2c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c31:	0f 85 85 00 00 00    	jne    80101cbc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c37:	8b 53 58             	mov    0x58(%ebx),%edx
80101c3a:	31 ff                	xor    %edi,%edi
80101c3c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c3f:	85 d2                	test   %edx,%edx
80101c41:	74 3e                	je     80101c81 <dirlookup+0x61>
80101c43:	90                   	nop
80101c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c48:	6a 10                	push   $0x10
80101c4a:	57                   	push   %edi
80101c4b:	56                   	push   %esi
80101c4c:	53                   	push   %ebx
80101c4d:	e8 7e fd ff ff       	call   801019d0 <readi>
80101c52:	83 c4 10             	add    $0x10,%esp
80101c55:	83 f8 10             	cmp    $0x10,%eax
80101c58:	75 55                	jne    80101caf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c5a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c5f:	74 18                	je     80101c79 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c61:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c64:	83 ec 04             	sub    $0x4,%esp
80101c67:	6a 0e                	push   $0xe
80101c69:	50                   	push   %eax
80101c6a:	ff 75 0c             	pushl  0xc(%ebp)
80101c6d:	e8 6e 29 00 00       	call   801045e0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c72:	83 c4 10             	add    $0x10,%esp
80101c75:	85 c0                	test   %eax,%eax
80101c77:	74 17                	je     80101c90 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c79:	83 c7 10             	add    $0x10,%edi
80101c7c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c7f:	72 c7                	jb     80101c48 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c84:	31 c0                	xor    %eax,%eax
}
80101c86:	5b                   	pop    %ebx
80101c87:	5e                   	pop    %esi
80101c88:	5f                   	pop    %edi
80101c89:	5d                   	pop    %ebp
80101c8a:	c3                   	ret    
80101c8b:	90                   	nop
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c90:	8b 45 10             	mov    0x10(%ebp),%eax
80101c93:	85 c0                	test   %eax,%eax
80101c95:	74 05                	je     80101c9c <dirlookup+0x7c>
        *poff = off;
80101c97:	8b 45 10             	mov    0x10(%ebp),%eax
80101c9a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c9c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ca0:	8b 03                	mov    (%ebx),%eax
80101ca2:	e8 d9 f5 ff ff       	call   80101280 <iget>
}
80101ca7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101caa:	5b                   	pop    %ebx
80101cab:	5e                   	pop    %esi
80101cac:	5f                   	pop    %edi
80101cad:	5d                   	pop    %ebp
80101cae:	c3                   	ret    
      panic("dirlookup read");
80101caf:	83 ec 0c             	sub    $0xc,%esp
80101cb2:	68 79 70 10 80       	push   $0x80107079
80101cb7:	e8 d4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cbc:	83 ec 0c             	sub    $0xc,%esp
80101cbf:	68 67 70 10 80       	push   $0x80107067
80101cc4:	e8 c7 e6 ff ff       	call   80100390 <panic>
80101cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cd0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	57                   	push   %edi
80101cd4:	56                   	push   %esi
80101cd5:	53                   	push   %ebx
80101cd6:	89 cf                	mov    %ecx,%edi
80101cd8:	89 c3                	mov    %eax,%ebx
80101cda:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cdd:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ce0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101ce3:	0f 84 67 01 00 00    	je     80101e50 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ce9:	e8 62 1b 00 00       	call   80103850 <myproc>
  acquire(&icache.lock);
80101cee:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cf1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cf4:	68 e0 09 11 80       	push   $0x801109e0
80101cf9:	e8 b2 26 00 00       	call   801043b0 <acquire>
  ip->ref++;
80101cfe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d02:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d09:	e8 62 27 00 00       	call   80104470 <release>
80101d0e:	83 c4 10             	add    $0x10,%esp
80101d11:	eb 08                	jmp    80101d1b <namex+0x4b>
80101d13:	90                   	nop
80101d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101d18:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d1b:	0f b6 03             	movzbl (%ebx),%eax
80101d1e:	3c 2f                	cmp    $0x2f,%al
80101d20:	74 f6                	je     80101d18 <namex+0x48>
  if(*path == 0)
80101d22:	84 c0                	test   %al,%al
80101d24:	0f 84 ee 00 00 00    	je     80101e18 <namex+0x148>
  while(*path != '/' && *path != 0)
80101d2a:	0f b6 03             	movzbl (%ebx),%eax
80101d2d:	3c 2f                	cmp    $0x2f,%al
80101d2f:	0f 84 b3 00 00 00    	je     80101de8 <namex+0x118>
80101d35:	84 c0                	test   %al,%al
80101d37:	89 da                	mov    %ebx,%edx
80101d39:	75 09                	jne    80101d44 <namex+0x74>
80101d3b:	e9 a8 00 00 00       	jmp    80101de8 <namex+0x118>
80101d40:	84 c0                	test   %al,%al
80101d42:	74 0a                	je     80101d4e <namex+0x7e>
    path++;
80101d44:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d47:	0f b6 02             	movzbl (%edx),%eax
80101d4a:	3c 2f                	cmp    $0x2f,%al
80101d4c:	75 f2                	jne    80101d40 <namex+0x70>
80101d4e:	89 d1                	mov    %edx,%ecx
80101d50:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d52:	83 f9 0d             	cmp    $0xd,%ecx
80101d55:	0f 8e 91 00 00 00    	jle    80101dec <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d5b:	83 ec 04             	sub    $0x4,%esp
80101d5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d61:	6a 0e                	push   $0xe
80101d63:	53                   	push   %ebx
80101d64:	57                   	push   %edi
80101d65:	e8 06 28 00 00       	call   80104570 <memmove>
    path++;
80101d6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d6d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d70:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d72:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d75:	75 11                	jne    80101d88 <namex+0xb8>
80101d77:	89 f6                	mov    %esi,%esi
80101d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d80:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d83:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d86:	74 f8                	je     80101d80 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d88:	83 ec 0c             	sub    $0xc,%esp
80101d8b:	56                   	push   %esi
80101d8c:	e8 5f f9 ff ff       	call   801016f0 <ilock>
    if(ip->type != T_DIR){
80101d91:	83 c4 10             	add    $0x10,%esp
80101d94:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d99:	0f 85 91 00 00 00    	jne    80101e30 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101da2:	85 d2                	test   %edx,%edx
80101da4:	74 09                	je     80101daf <namex+0xdf>
80101da6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101da9:	0f 84 b7 00 00 00    	je     80101e66 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101daf:	83 ec 04             	sub    $0x4,%esp
80101db2:	6a 00                	push   $0x0
80101db4:	57                   	push   %edi
80101db5:	56                   	push   %esi
80101db6:	e8 65 fe ff ff       	call   80101c20 <dirlookup>
80101dbb:	83 c4 10             	add    $0x10,%esp
80101dbe:	85 c0                	test   %eax,%eax
80101dc0:	74 6e                	je     80101e30 <namex+0x160>
  iunlock(ip);
80101dc2:	83 ec 0c             	sub    $0xc,%esp
80101dc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101dc8:	56                   	push   %esi
80101dc9:	e8 02 fa ff ff       	call   801017d0 <iunlock>
  iput(ip);
80101dce:	89 34 24             	mov    %esi,(%esp)
80101dd1:	e8 4a fa ff ff       	call   80101820 <iput>
80101dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dd9:	83 c4 10             	add    $0x10,%esp
80101ddc:	89 c6                	mov    %eax,%esi
80101dde:	e9 38 ff ff ff       	jmp    80101d1b <namex+0x4b>
80101de3:	90                   	nop
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101de8:	89 da                	mov    %ebx,%edx
80101dea:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101dec:	83 ec 04             	sub    $0x4,%esp
80101def:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101df2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101df5:	51                   	push   %ecx
80101df6:	53                   	push   %ebx
80101df7:	57                   	push   %edi
80101df8:	e8 73 27 00 00       	call   80104570 <memmove>
    name[len] = 0;
80101dfd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e00:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e03:	83 c4 10             	add    $0x10,%esp
80101e06:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e0a:	89 d3                	mov    %edx,%ebx
80101e0c:	e9 61 ff ff ff       	jmp    80101d72 <namex+0xa2>
80101e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e1b:	85 c0                	test   %eax,%eax
80101e1d:	75 5d                	jne    80101e7c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e22:	89 f0                	mov    %esi,%eax
80101e24:	5b                   	pop    %ebx
80101e25:	5e                   	pop    %esi
80101e26:	5f                   	pop    %edi
80101e27:	5d                   	pop    %ebp
80101e28:	c3                   	ret    
80101e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 97 f9 ff ff       	call   801017d0 <iunlock>
  iput(ip);
80101e39:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e3c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e3e:	e8 dd f9 ff ff       	call   80101820 <iput>
      return 0;
80101e43:	83 c4 10             	add    $0x10,%esp
}
80101e46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e49:	89 f0                	mov    %esi,%eax
80101e4b:	5b                   	pop    %ebx
80101e4c:	5e                   	pop    %esi
80101e4d:	5f                   	pop    %edi
80101e4e:	5d                   	pop    %ebp
80101e4f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e50:	ba 01 00 00 00       	mov    $0x1,%edx
80101e55:	b8 01 00 00 00       	mov    $0x1,%eax
80101e5a:	e8 21 f4 ff ff       	call   80101280 <iget>
80101e5f:	89 c6                	mov    %eax,%esi
80101e61:	e9 b5 fe ff ff       	jmp    80101d1b <namex+0x4b>
      iunlock(ip);
80101e66:	83 ec 0c             	sub    $0xc,%esp
80101e69:	56                   	push   %esi
80101e6a:	e8 61 f9 ff ff       	call   801017d0 <iunlock>
      return ip;
80101e6f:	83 c4 10             	add    $0x10,%esp
}
80101e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e75:	89 f0                	mov    %esi,%eax
80101e77:	5b                   	pop    %ebx
80101e78:	5e                   	pop    %esi
80101e79:	5f                   	pop    %edi
80101e7a:	5d                   	pop    %ebp
80101e7b:	c3                   	ret    
    iput(ip);
80101e7c:	83 ec 0c             	sub    $0xc,%esp
80101e7f:	56                   	push   %esi
    return 0;
80101e80:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e82:	e8 99 f9 ff ff       	call   80101820 <iput>
    return 0;
80101e87:	83 c4 10             	add    $0x10,%esp
80101e8a:	eb 93                	jmp    80101e1f <namex+0x14f>
80101e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e90 <dirlink>:
{
80101e90:	55                   	push   %ebp
80101e91:	89 e5                	mov    %esp,%ebp
80101e93:	57                   	push   %edi
80101e94:	56                   	push   %esi
80101e95:	53                   	push   %ebx
80101e96:	83 ec 20             	sub    $0x20,%esp
80101e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e9c:	6a 00                	push   $0x0
80101e9e:	ff 75 0c             	pushl  0xc(%ebp)
80101ea1:	53                   	push   %ebx
80101ea2:	e8 79 fd ff ff       	call   80101c20 <dirlookup>
80101ea7:	83 c4 10             	add    $0x10,%esp
80101eaa:	85 c0                	test   %eax,%eax
80101eac:	75 67                	jne    80101f15 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101eae:	8b 7b 58             	mov    0x58(%ebx),%edi
80101eb1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101eb4:	85 ff                	test   %edi,%edi
80101eb6:	74 29                	je     80101ee1 <dirlink+0x51>
80101eb8:	31 ff                	xor    %edi,%edi
80101eba:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ebd:	eb 09                	jmp    80101ec8 <dirlink+0x38>
80101ebf:	90                   	nop
80101ec0:	83 c7 10             	add    $0x10,%edi
80101ec3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ec6:	73 19                	jae    80101ee1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec8:	6a 10                	push   $0x10
80101eca:	57                   	push   %edi
80101ecb:	56                   	push   %esi
80101ecc:	53                   	push   %ebx
80101ecd:	e8 fe fa ff ff       	call   801019d0 <readi>
80101ed2:	83 c4 10             	add    $0x10,%esp
80101ed5:	83 f8 10             	cmp    $0x10,%eax
80101ed8:	75 4e                	jne    80101f28 <dirlink+0x98>
    if(de.inum == 0)
80101eda:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101edf:	75 df                	jne    80101ec0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101ee1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ee4:	83 ec 04             	sub    $0x4,%esp
80101ee7:	6a 0e                	push   $0xe
80101ee9:	ff 75 0c             	pushl  0xc(%ebp)
80101eec:	50                   	push   %eax
80101eed:	e8 4e 27 00 00       	call   80104640 <strncpy>
  de.inum = inum;
80101ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ef5:	6a 10                	push   $0x10
80101ef7:	57                   	push   %edi
80101ef8:	56                   	push   %esi
80101ef9:	53                   	push   %ebx
  de.inum = inum;
80101efa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101efe:	e8 cd fb ff ff       	call   80101ad0 <writei>
80101f03:	83 c4 20             	add    $0x20,%esp
80101f06:	83 f8 10             	cmp    $0x10,%eax
80101f09:	75 2a                	jne    80101f35 <dirlink+0xa5>
  return 0;
80101f0b:	31 c0                	xor    %eax,%eax
}
80101f0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret    
    iput(ip);
80101f15:	83 ec 0c             	sub    $0xc,%esp
80101f18:	50                   	push   %eax
80101f19:	e8 02 f9 ff ff       	call   80101820 <iput>
    return -1;
80101f1e:	83 c4 10             	add    $0x10,%esp
80101f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f26:	eb e5                	jmp    80101f0d <dirlink+0x7d>
      panic("dirlink read");
80101f28:	83 ec 0c             	sub    $0xc,%esp
80101f2b:	68 88 70 10 80       	push   $0x80107088
80101f30:	e8 5b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f35:	83 ec 0c             	sub    $0xc,%esp
80101f38:	68 7e 76 10 80       	push   $0x8010767e
80101f3d:	e8 4e e4 ff ff       	call   80100390 <panic>
80101f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f50 <namei>:

struct inode*
namei(char *path)
{
80101f50:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f51:	31 d2                	xor    %edx,%edx
{
80101f53:	89 e5                	mov    %esp,%ebp
80101f55:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f58:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f5e:	e8 6d fd ff ff       	call   80101cd0 <namex>
}
80101f63:	c9                   	leave  
80101f64:	c3                   	ret    
80101f65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f70 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f70:	55                   	push   %ebp
  return namex(path, 1, name);
80101f71:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f76:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f7b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f7e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f7f:	e9 4c fd ff ff       	jmp    80101cd0 <namex>
80101f84:	66 90                	xchg   %ax,%ax
80101f86:	66 90                	xchg   %ax,%ax
80101f88:	66 90                	xchg   %ax,%ax
80101f8a:	66 90                	xchg   %ax,%ax
80101f8c:	66 90                	xchg   %ax,%ax
80101f8e:	66 90                	xchg   %ax,%ax

80101f90 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	57                   	push   %edi
80101f94:	56                   	push   %esi
80101f95:	53                   	push   %ebx
80101f96:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f99:	85 c0                	test   %eax,%eax
80101f9b:	0f 84 b4 00 00 00    	je     80102055 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fa1:	8b 58 08             	mov    0x8(%eax),%ebx
80101fa4:	89 c6                	mov    %eax,%esi
80101fa6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101fac:	0f 87 96 00 00 00    	ja     80102048 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fb2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101fb7:	89 f6                	mov    %esi,%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101fc0:	89 ca                	mov    %ecx,%edx
80101fc2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fc3:	83 e0 c0             	and    $0xffffffc0,%eax
80101fc6:	3c 40                	cmp    $0x40,%al
80101fc8:	75 f6                	jne    80101fc0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fca:	31 ff                	xor    %edi,%edi
80101fcc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fd1:	89 f8                	mov    %edi,%eax
80101fd3:	ee                   	out    %al,(%dx)
80101fd4:	b8 01 00 00 00       	mov    $0x1,%eax
80101fd9:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fde:	ee                   	out    %al,(%dx)
80101fdf:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101fe4:	89 d8                	mov    %ebx,%eax
80101fe6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fe7:	89 d8                	mov    %ebx,%eax
80101fe9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101fee:	c1 f8 08             	sar    $0x8,%eax
80101ff1:	ee                   	out    %al,(%dx)
80101ff2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101ff7:	89 f8                	mov    %edi,%eax
80101ff9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101ffa:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101ffe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102003:	c1 e0 04             	shl    $0x4,%eax
80102006:	83 e0 10             	and    $0x10,%eax
80102009:	83 c8 e0             	or     $0xffffffe0,%eax
8010200c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010200d:	f6 06 04             	testb  $0x4,(%esi)
80102010:	75 16                	jne    80102028 <idestart+0x98>
80102012:	b8 20 00 00 00       	mov    $0x20,%eax
80102017:	89 ca                	mov    %ecx,%edx
80102019:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010201a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010201d:	5b                   	pop    %ebx
8010201e:	5e                   	pop    %esi
8010201f:	5f                   	pop    %edi
80102020:	5d                   	pop    %ebp
80102021:	c3                   	ret    
80102022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102028:	b8 30 00 00 00       	mov    $0x30,%eax
8010202d:	89 ca                	mov    %ecx,%edx
8010202f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102030:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102035:	83 c6 5c             	add    $0x5c,%esi
80102038:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010203d:	fc                   	cld    
8010203e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102040:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102043:	5b                   	pop    %ebx
80102044:	5e                   	pop    %esi
80102045:	5f                   	pop    %edi
80102046:	5d                   	pop    %ebp
80102047:	c3                   	ret    
    panic("incorrect blockno");
80102048:	83 ec 0c             	sub    $0xc,%esp
8010204b:	68 f4 70 10 80       	push   $0x801070f4
80102050:	e8 3b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102055:	83 ec 0c             	sub    $0xc,%esp
80102058:	68 eb 70 10 80       	push   $0x801070eb
8010205d:	e8 2e e3 ff ff       	call   80100390 <panic>
80102062:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102070 <ideinit>:
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102076:	68 06 71 10 80       	push   $0x80107106
8010207b:	68 80 a5 10 80       	push   $0x8010a580
80102080:	e8 eb 21 00 00       	call   80104270 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102085:	58                   	pop    %eax
80102086:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010208b:	5a                   	pop    %edx
8010208c:	83 e8 01             	sub    $0x1,%eax
8010208f:	50                   	push   %eax
80102090:	6a 0e                	push   $0xe
80102092:	e8 a9 02 00 00       	call   80102340 <ioapicenable>
80102097:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010209a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010209f:	90                   	nop
801020a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a1:	83 e0 c0             	and    $0xffffffc0,%eax
801020a4:	3c 40                	cmp    $0x40,%al
801020a6:	75 f8                	jne    801020a0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020a8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801020ad:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020b2:	ee                   	out    %al,(%dx)
801020b3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020bd:	eb 06                	jmp    801020c5 <ideinit+0x55>
801020bf:	90                   	nop
  for(i=0; i<1000; i++){
801020c0:	83 e9 01             	sub    $0x1,%ecx
801020c3:	74 0f                	je     801020d4 <ideinit+0x64>
801020c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020c6:	84 c0                	test   %al,%al
801020c8:	74 f6                	je     801020c0 <ideinit+0x50>
      havedisk1 = 1;
801020ca:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801020d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020de:	ee                   	out    %al,(%dx)
}
801020df:	c9                   	leave  
801020e0:	c3                   	ret    
801020e1:	eb 0d                	jmp    801020f0 <ideintr>
801020e3:	90                   	nop
801020e4:	90                   	nop
801020e5:	90                   	nop
801020e6:	90                   	nop
801020e7:	90                   	nop
801020e8:	90                   	nop
801020e9:	90                   	nop
801020ea:	90                   	nop
801020eb:	90                   	nop
801020ec:	90                   	nop
801020ed:	90                   	nop
801020ee:	90                   	nop
801020ef:	90                   	nop

801020f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020f9:	68 80 a5 10 80       	push   $0x8010a580
801020fe:	e8 ad 22 00 00       	call   801043b0 <acquire>

  if((b = idequeue) == 0){
80102103:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102109:	83 c4 10             	add    $0x10,%esp
8010210c:	85 db                	test   %ebx,%ebx
8010210e:	74 67                	je     80102177 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102110:	8b 43 58             	mov    0x58(%ebx),%eax
80102113:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102118:	8b 3b                	mov    (%ebx),%edi
8010211a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102120:	75 31                	jne    80102153 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102122:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102127:	89 f6                	mov    %esi,%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102130:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102131:	89 c6                	mov    %eax,%esi
80102133:	83 e6 c0             	and    $0xffffffc0,%esi
80102136:	89 f1                	mov    %esi,%ecx
80102138:	80 f9 40             	cmp    $0x40,%cl
8010213b:	75 f3                	jne    80102130 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010213d:	a8 21                	test   $0x21,%al
8010213f:	75 12                	jne    80102153 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102141:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102144:	b9 80 00 00 00       	mov    $0x80,%ecx
80102149:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010214e:	fc                   	cld    
8010214f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102151:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102153:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102156:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102159:	89 f9                	mov    %edi,%ecx
8010215b:	83 c9 02             	or     $0x2,%ecx
8010215e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102160:	53                   	push   %ebx
80102161:	e8 3a 1e 00 00       	call   80103fa0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102166:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010216b:	83 c4 10             	add    $0x10,%esp
8010216e:	85 c0                	test   %eax,%eax
80102170:	74 05                	je     80102177 <ideintr+0x87>
    idestart(idequeue);
80102172:	e8 19 fe ff ff       	call   80101f90 <idestart>
    release(&idelock);
80102177:	83 ec 0c             	sub    $0xc,%esp
8010217a:	68 80 a5 10 80       	push   $0x8010a580
8010217f:	e8 ec 22 00 00       	call   80104470 <release>

  release(&idelock);
}
80102184:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102187:	5b                   	pop    %ebx
80102188:	5e                   	pop    %esi
80102189:	5f                   	pop    %edi
8010218a:	5d                   	pop    %ebp
8010218b:	c3                   	ret    
8010218c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102190 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	53                   	push   %ebx
80102194:	83 ec 10             	sub    $0x10,%esp
80102197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010219a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010219d:	50                   	push   %eax
8010219e:	e8 7d 20 00 00       	call   80104220 <holdingsleep>
801021a3:	83 c4 10             	add    $0x10,%esp
801021a6:	85 c0                	test   %eax,%eax
801021a8:	0f 84 c6 00 00 00    	je     80102274 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801021ae:	8b 03                	mov    (%ebx),%eax
801021b0:	83 e0 06             	and    $0x6,%eax
801021b3:	83 f8 02             	cmp    $0x2,%eax
801021b6:	0f 84 ab 00 00 00    	je     80102267 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801021bc:	8b 53 04             	mov    0x4(%ebx),%edx
801021bf:	85 d2                	test   %edx,%edx
801021c1:	74 0d                	je     801021d0 <iderw+0x40>
801021c3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801021c8:	85 c0                	test   %eax,%eax
801021ca:	0f 84 b1 00 00 00    	je     80102281 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021d0:	83 ec 0c             	sub    $0xc,%esp
801021d3:	68 80 a5 10 80       	push   $0x8010a580
801021d8:	e8 d3 21 00 00       	call   801043b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021dd:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
801021e3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801021e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ed:	85 d2                	test   %edx,%edx
801021ef:	75 09                	jne    801021fa <iderw+0x6a>
801021f1:	eb 6d                	jmp    80102260 <iderw+0xd0>
801021f3:	90                   	nop
801021f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021f8:	89 c2                	mov    %eax,%edx
801021fa:	8b 42 58             	mov    0x58(%edx),%eax
801021fd:	85 c0                	test   %eax,%eax
801021ff:	75 f7                	jne    801021f8 <iderw+0x68>
80102201:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102204:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102206:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010220c:	74 42                	je     80102250 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010220e:	8b 03                	mov    (%ebx),%eax
80102210:	83 e0 06             	and    $0x6,%eax
80102213:	83 f8 02             	cmp    $0x2,%eax
80102216:	74 23                	je     8010223b <iderw+0xab>
80102218:	90                   	nop
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102220:	83 ec 08             	sub    $0x8,%esp
80102223:	68 80 a5 10 80       	push   $0x8010a580
80102228:	53                   	push   %ebx
80102229:	e8 c2 1b 00 00       	call   80103df0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010222e:	8b 03                	mov    (%ebx),%eax
80102230:	83 c4 10             	add    $0x10,%esp
80102233:	83 e0 06             	and    $0x6,%eax
80102236:	83 f8 02             	cmp    $0x2,%eax
80102239:	75 e5                	jne    80102220 <iderw+0x90>
  }


  release(&idelock);
8010223b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102242:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102245:	c9                   	leave  
  release(&idelock);
80102246:	e9 25 22 00 00       	jmp    80104470 <release>
8010224b:	90                   	nop
8010224c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102250:	89 d8                	mov    %ebx,%eax
80102252:	e8 39 fd ff ff       	call   80101f90 <idestart>
80102257:	eb b5                	jmp    8010220e <iderw+0x7e>
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102260:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102265:	eb 9d                	jmp    80102204 <iderw+0x74>
    panic("iderw: nothing to do");
80102267:	83 ec 0c             	sub    $0xc,%esp
8010226a:	68 20 71 10 80       	push   $0x80107120
8010226f:	e8 1c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102274:	83 ec 0c             	sub    $0xc,%esp
80102277:	68 0a 71 10 80       	push   $0x8010710a
8010227c:	e8 0f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102281:	83 ec 0c             	sub    $0xc,%esp
80102284:	68 35 71 10 80       	push   $0x80107135
80102289:	e8 02 e1 ff ff       	call   80100390 <panic>
8010228e:	66 90                	xchg   %ax,%ax

80102290 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102290:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102291:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102298:	00 c0 fe 
{
8010229b:	89 e5                	mov    %esp,%ebp
8010229d:	56                   	push   %esi
8010229e:	53                   	push   %ebx
  ioapic->reg = reg;
8010229f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801022a6:	00 00 00 
  return ioapic->data;
801022a9:	a1 34 26 11 80       	mov    0x80112634,%eax
801022ae:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801022b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801022b7:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022bd:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022c4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801022c7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022ca:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801022cd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801022d0:	39 c2                	cmp    %eax,%edx
801022d2:	74 16                	je     801022ea <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	68 54 71 10 80       	push   $0x80107154
801022dc:	e8 7f e3 ff ff       	call   80100660 <cprintf>
801022e1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022e7:	83 c4 10             	add    $0x10,%esp
801022ea:	83 c3 21             	add    $0x21,%ebx
{
801022ed:	ba 10 00 00 00       	mov    $0x10,%edx
801022f2:	b8 20 00 00 00       	mov    $0x20,%eax
801022f7:	89 f6                	mov    %esi,%esi
801022f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102300:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102302:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102308:	89 c6                	mov    %eax,%esi
8010230a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102310:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102313:	89 71 10             	mov    %esi,0x10(%ecx)
80102316:	8d 72 01             	lea    0x1(%edx),%esi
80102319:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010231c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010231e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102320:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102326:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010232d:	75 d1                	jne    80102300 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010232f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102332:	5b                   	pop    %ebx
80102333:	5e                   	pop    %esi
80102334:	5d                   	pop    %ebp
80102335:	c3                   	ret    
80102336:	8d 76 00             	lea    0x0(%esi),%esi
80102339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102340 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102340:	55                   	push   %ebp
  ioapic->reg = reg;
80102341:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102347:	89 e5                	mov    %esp,%ebp
80102349:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010234c:	8d 50 20             	lea    0x20(%eax),%edx
8010234f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102353:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102355:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010235b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010235e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102361:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102364:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102366:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010236b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010236e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102371:	5d                   	pop    %ebp
80102372:	c3                   	ret    
80102373:	66 90                	xchg   %ax,%ax
80102375:	66 90                	xchg   %ax,%ax
80102377:	66 90                	xchg   %ax,%ax
80102379:	66 90                	xchg   %ax,%ax
8010237b:	66 90                	xchg   %ax,%ax
8010237d:	66 90                	xchg   %ax,%ax
8010237f:	90                   	nop

80102380 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	53                   	push   %ebx
80102384:	83 ec 04             	sub    $0x4,%esp
80102387:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010238a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102390:	75 70                	jne    80102402 <kfree+0x82>
80102392:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80102398:	72 68                	jb     80102402 <kfree+0x82>
8010239a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801023a0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801023a5:	77 5b                	ja     80102402 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801023a7:	83 ec 04             	sub    $0x4,%esp
801023aa:	68 00 10 00 00       	push   $0x1000
801023af:	6a 01                	push   $0x1
801023b1:	53                   	push   %ebx
801023b2:	e8 09 21 00 00       	call   801044c0 <memset>

  if(kmem.use_lock)
801023b7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	85 d2                	test   %edx,%edx
801023c2:	75 2c                	jne    801023f0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023c4:	a1 78 26 11 80       	mov    0x80112678,%eax
801023c9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023cb:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801023d0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801023d6:	85 c0                	test   %eax,%eax
801023d8:	75 06                	jne    801023e0 <kfree+0x60>
    release(&kmem.lock);
}
801023da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023dd:	c9                   	leave  
801023de:	c3                   	ret    
801023df:	90                   	nop
    release(&kmem.lock);
801023e0:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801023e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ea:	c9                   	leave  
    release(&kmem.lock);
801023eb:	e9 80 20 00 00       	jmp    80104470 <release>
    acquire(&kmem.lock);
801023f0:	83 ec 0c             	sub    $0xc,%esp
801023f3:	68 40 26 11 80       	push   $0x80112640
801023f8:	e8 b3 1f 00 00       	call   801043b0 <acquire>
801023fd:	83 c4 10             	add    $0x10,%esp
80102400:	eb c2                	jmp    801023c4 <kfree+0x44>
    panic("kfree");
80102402:	83 ec 0c             	sub    $0xc,%esp
80102405:	68 86 71 10 80       	push   $0x80107186
8010240a:	e8 81 df ff ff       	call   80100390 <panic>
8010240f:	90                   	nop

80102410 <freerange>:
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102415:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102418:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010241b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102421:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102427:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242d:	39 de                	cmp    %ebx,%esi
8010242f:	72 23                	jb     80102454 <freerange+0x44>
80102431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102438:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010243e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102441:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102447:	50                   	push   %eax
80102448:	e8 33 ff ff ff       	call   80102380 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	39 f3                	cmp    %esi,%ebx
80102452:	76 e4                	jbe    80102438 <freerange+0x28>
}
80102454:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102457:	5b                   	pop    %ebx
80102458:	5e                   	pop    %esi
80102459:	5d                   	pop    %ebp
8010245a:	c3                   	ret    
8010245b:	90                   	nop
8010245c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102460 <kinit1>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
80102465:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102468:	83 ec 08             	sub    $0x8,%esp
8010246b:	68 8c 71 10 80       	push   $0x8010718c
80102470:	68 40 26 11 80       	push   $0x80112640
80102475:	e8 f6 1d 00 00       	call   80104270 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010247a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010247d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102480:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102487:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010248a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102490:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102496:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010249c:	39 de                	cmp    %ebx,%esi
8010249e:	72 1c                	jb     801024bc <kinit1+0x5c>
    kfree(p);
801024a0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024a6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024af:	50                   	push   %eax
801024b0:	e8 cb fe ff ff       	call   80102380 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b5:	83 c4 10             	add    $0x10,%esp
801024b8:	39 de                	cmp    %ebx,%esi
801024ba:	73 e4                	jae    801024a0 <kinit1+0x40>
}
801024bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024bf:	5b                   	pop    %ebx
801024c0:	5e                   	pop    %esi
801024c1:	5d                   	pop    %ebp
801024c2:	c3                   	ret    
801024c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024d0 <kinit2>:
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	56                   	push   %esi
801024d4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024d5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024ed:	39 de                	cmp    %ebx,%esi
801024ef:	72 23                	jb     80102514 <kinit2+0x44>
801024f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024fe:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102501:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102507:	50                   	push   %eax
80102508:	e8 73 fe ff ff       	call   80102380 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	39 de                	cmp    %ebx,%esi
80102512:	73 e4                	jae    801024f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102514:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010251b:	00 00 00 
}
8010251e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102521:	5b                   	pop    %ebx
80102522:	5e                   	pop    %esi
80102523:	5d                   	pop    %ebp
80102524:	c3                   	ret    
80102525:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102530 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102530:	a1 74 26 11 80       	mov    0x80112674,%eax
80102535:	85 c0                	test   %eax,%eax
80102537:	75 1f                	jne    80102558 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102539:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010253e:	85 c0                	test   %eax,%eax
80102540:	74 0e                	je     80102550 <kalloc+0x20>
    kmem.freelist = r->next;
80102542:	8b 10                	mov    (%eax),%edx
80102544:	89 15 78 26 11 80    	mov    %edx,0x80112678
8010254a:	c3                   	ret    
8010254b:	90                   	nop
8010254c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102550:	f3 c3                	repz ret 
80102552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102558:	55                   	push   %ebp
80102559:	89 e5                	mov    %esp,%ebp
8010255b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010255e:	68 40 26 11 80       	push   $0x80112640
80102563:	e8 48 1e 00 00       	call   801043b0 <acquire>
  r = kmem.freelist;
80102568:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102576:	85 c0                	test   %eax,%eax
80102578:	74 08                	je     80102582 <kalloc+0x52>
    kmem.freelist = r->next;
8010257a:	8b 08                	mov    (%eax),%ecx
8010257c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102582:	85 d2                	test   %edx,%edx
80102584:	74 16                	je     8010259c <kalloc+0x6c>
    release(&kmem.lock);
80102586:	83 ec 0c             	sub    $0xc,%esp
80102589:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010258c:	68 40 26 11 80       	push   $0x80112640
80102591:	e8 da 1e 00 00       	call   80104470 <release>
  return (char*)r;
80102596:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102599:	83 c4 10             	add    $0x10,%esp
}
8010259c:	c9                   	leave  
8010259d:	c3                   	ret    
8010259e:	66 90                	xchg   %ax,%ax

801025a0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025a0:	ba 64 00 00 00       	mov    $0x64,%edx
801025a5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801025a6:	a8 01                	test   $0x1,%al
801025a8:	0f 84 c2 00 00 00    	je     80102670 <kbdgetc+0xd0>
801025ae:	ba 60 00 00 00       	mov    $0x60,%edx
801025b3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801025b4:	0f b6 d0             	movzbl %al,%edx
801025b7:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
801025bd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801025c3:	0f 84 7f 00 00 00    	je     80102648 <kbdgetc+0xa8>
{
801025c9:	55                   	push   %ebp
801025ca:	89 e5                	mov    %esp,%ebp
801025cc:	53                   	push   %ebx
801025cd:	89 cb                	mov    %ecx,%ebx
801025cf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025d2:	84 c0                	test   %al,%al
801025d4:	78 4a                	js     80102620 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025d6:	85 db                	test   %ebx,%ebx
801025d8:	74 09                	je     801025e3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025da:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025dd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801025e0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801025e3:	0f b6 82 c0 72 10 80 	movzbl -0x7fef8d40(%edx),%eax
801025ea:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025ec:	0f b6 82 c0 71 10 80 	movzbl -0x7fef8e40(%edx),%eax
801025f3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025f5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025f7:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025fd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102600:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102603:	8b 04 85 a0 71 10 80 	mov    -0x7fef8e60(,%eax,4),%eax
8010260a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010260e:	74 31                	je     80102641 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102610:	8d 50 9f             	lea    -0x61(%eax),%edx
80102613:	83 fa 19             	cmp    $0x19,%edx
80102616:	77 40                	ja     80102658 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102618:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010261b:	5b                   	pop    %ebx
8010261c:	5d                   	pop    %ebp
8010261d:	c3                   	ret    
8010261e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102620:	83 e0 7f             	and    $0x7f,%eax
80102623:	85 db                	test   %ebx,%ebx
80102625:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102628:	0f b6 82 c0 72 10 80 	movzbl -0x7fef8d40(%edx),%eax
8010262f:	83 c8 40             	or     $0x40,%eax
80102632:	0f b6 c0             	movzbl %al,%eax
80102635:	f7 d0                	not    %eax
80102637:	21 c1                	and    %eax,%ecx
    return 0;
80102639:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010263b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102641:	5b                   	pop    %ebx
80102642:	5d                   	pop    %ebp
80102643:	c3                   	ret    
80102644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102648:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010264b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010264d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102653:	c3                   	ret    
80102654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102658:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010265b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010265e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010265f:	83 f9 1a             	cmp    $0x1a,%ecx
80102662:	0f 42 c2             	cmovb  %edx,%eax
}
80102665:	5d                   	pop    %ebp
80102666:	c3                   	ret    
80102667:	89 f6                	mov    %esi,%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102675:	c3                   	ret    
80102676:	8d 76 00             	lea    0x0(%esi),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <kbdintr>:

void
kbdintr(void)
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102686:	68 a0 25 10 80       	push   $0x801025a0
8010268b:	e8 80 e1 ff ff       	call   80100810 <consoleintr>
}
80102690:	83 c4 10             	add    $0x10,%esp
80102693:	c9                   	leave  
80102694:	c3                   	ret    
80102695:	66 90                	xchg   %ax,%ax
80102697:	66 90                	xchg   %ax,%ax
80102699:	66 90                	xchg   %ax,%ax
8010269b:	66 90                	xchg   %ax,%ax
8010269d:	66 90                	xchg   %ax,%ax
8010269f:	90                   	nop

801026a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801026a0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801026a5:	55                   	push   %ebp
801026a6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026a8:	85 c0                	test   %eax,%eax
801026aa:	0f 84 c8 00 00 00    	je     80102778 <lapicinit+0xd8>
  lapic[index] = value;
801026b0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026b7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026bd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ca:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026d1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026de:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026eb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026fe:	8b 50 30             	mov    0x30(%eax),%edx
80102701:	c1 ea 10             	shr    $0x10,%edx
80102704:	80 fa 03             	cmp    $0x3,%dl
80102707:	77 77                	ja     80102780 <lapicinit+0xe0>
  lapic[index] = value;
80102709:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102710:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102713:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102716:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010271d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102720:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102723:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010272a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102730:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102737:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010273d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102744:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102747:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010274a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102751:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102754:	8b 50 20             	mov    0x20(%eax),%edx
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102760:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102766:	80 e6 10             	and    $0x10,%dh
80102769:	75 f5                	jne    80102760 <lapicinit+0xc0>
  lapic[index] = value;
8010276b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102772:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102775:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102778:	5d                   	pop    %ebp
80102779:	c3                   	ret    
8010277a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102780:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102787:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010278a:	8b 50 20             	mov    0x20(%eax),%edx
8010278d:	e9 77 ff ff ff       	jmp    80102709 <lapicinit+0x69>
80102792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801027a0:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
801027a6:	55                   	push   %ebp
801027a7:	31 c0                	xor    %eax,%eax
801027a9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027ab:	85 d2                	test   %edx,%edx
801027ad:	74 06                	je     801027b5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801027af:	8b 42 20             	mov    0x20(%edx),%eax
801027b2:	c1 e8 18             	shr    $0x18,%eax
}
801027b5:	5d                   	pop    %ebp
801027b6:	c3                   	ret    
801027b7:	89 f6                	mov    %esi,%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801027c5:	55                   	push   %ebp
801027c6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027c8:	85 c0                	test   %eax,%eax
801027ca:	74 0d                	je     801027d9 <lapiceoi+0x19>
  lapic[index] = value;
801027cc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027d3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801027d9:	5d                   	pop    %ebp
801027da:	c3                   	ret    
801027db:	90                   	nop
801027dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027e0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
}
801027e3:	5d                   	pop    %ebp
801027e4:	c3                   	ret    
801027e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027f0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027f6:	ba 70 00 00 00       	mov    $0x70,%edx
801027fb:	89 e5                	mov    %esp,%ebp
801027fd:	53                   	push   %ebx
801027fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102801:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102804:	ee                   	out    %al,(%dx)
80102805:	b8 0a 00 00 00       	mov    $0xa,%eax
8010280a:	ba 71 00 00 00       	mov    $0x71,%edx
8010280f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102810:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102812:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102815:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010281b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010281d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102820:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102823:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102825:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102828:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010282e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102833:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102839:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010283c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102843:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102846:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102849:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102850:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102853:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102856:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010285c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010285f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102865:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102868:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010286e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102871:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010287a:	5b                   	pop    %ebx
8010287b:	5d                   	pop    %ebp
8010287c:	c3                   	ret    
8010287d:	8d 76 00             	lea    0x0(%esi),%esi

80102880 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102880:	55                   	push   %ebp
80102881:	b8 0b 00 00 00       	mov    $0xb,%eax
80102886:	ba 70 00 00 00       	mov    $0x70,%edx
8010288b:	89 e5                	mov    %esp,%ebp
8010288d:	57                   	push   %edi
8010288e:	56                   	push   %esi
8010288f:	53                   	push   %ebx
80102890:	83 ec 4c             	sub    $0x4c,%esp
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	ba 71 00 00 00       	mov    $0x71,%edx
80102899:	ec                   	in     (%dx),%al
8010289a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010289d:	bb 70 00 00 00       	mov    $0x70,%ebx
801028a2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801028a5:	8d 76 00             	lea    0x0(%esi),%esi
801028a8:	31 c0                	xor    %eax,%eax
801028aa:	89 da                	mov    %ebx,%edx
801028ac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ad:	b9 71 00 00 00       	mov    $0x71,%ecx
801028b2:	89 ca                	mov    %ecx,%edx
801028b4:	ec                   	in     (%dx),%al
801028b5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b8:	89 da                	mov    %ebx,%edx
801028ba:	b8 02 00 00 00       	mov    $0x2,%eax
801028bf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c0:	89 ca                	mov    %ecx,%edx
801028c2:	ec                   	in     (%dx),%al
801028c3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c6:	89 da                	mov    %ebx,%edx
801028c8:	b8 04 00 00 00       	mov    $0x4,%eax
801028cd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ce:	89 ca                	mov    %ecx,%edx
801028d0:	ec                   	in     (%dx),%al
801028d1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d4:	89 da                	mov    %ebx,%edx
801028d6:	b8 07 00 00 00       	mov    $0x7,%eax
801028db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dc:	89 ca                	mov    %ecx,%edx
801028de:	ec                   	in     (%dx),%al
801028df:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e2:	89 da                	mov    %ebx,%edx
801028e4:	b8 08 00 00 00       	mov    $0x8,%eax
801028e9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ea:	89 ca                	mov    %ecx,%edx
801028ec:	ec                   	in     (%dx),%al
801028ed:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ef:	89 da                	mov    %ebx,%edx
801028f1:	b8 09 00 00 00       	mov    $0x9,%eax
801028f6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f7:	89 ca                	mov    %ecx,%edx
801028f9:	ec                   	in     (%dx),%al
801028fa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028fc:	89 da                	mov    %ebx,%edx
801028fe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102903:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102904:	89 ca                	mov    %ecx,%edx
80102906:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102907:	84 c0                	test   %al,%al
80102909:	78 9d                	js     801028a8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010290b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010290f:	89 fa                	mov    %edi,%edx
80102911:	0f b6 fa             	movzbl %dl,%edi
80102914:	89 f2                	mov    %esi,%edx
80102916:	0f b6 f2             	movzbl %dl,%esi
80102919:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010291c:	89 da                	mov    %ebx,%edx
8010291e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102921:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102924:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102928:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010292b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010292f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102932:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102936:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102939:	31 c0                	xor    %eax,%eax
8010293b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293c:	89 ca                	mov    %ecx,%edx
8010293e:	ec                   	in     (%dx),%al
8010293f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102942:	89 da                	mov    %ebx,%edx
80102944:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102947:	b8 02 00 00 00       	mov    $0x2,%eax
8010294c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294d:	89 ca                	mov    %ecx,%edx
8010294f:	ec                   	in     (%dx),%al
80102950:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102953:	89 da                	mov    %ebx,%edx
80102955:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102958:	b8 04 00 00 00       	mov    $0x4,%eax
8010295d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295e:	89 ca                	mov    %ecx,%edx
80102960:	ec                   	in     (%dx),%al
80102961:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102964:	89 da                	mov    %ebx,%edx
80102966:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102969:	b8 07 00 00 00       	mov    $0x7,%eax
8010296e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296f:	89 ca                	mov    %ecx,%edx
80102971:	ec                   	in     (%dx),%al
80102972:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102975:	89 da                	mov    %ebx,%edx
80102977:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010297a:	b8 08 00 00 00       	mov    $0x8,%eax
8010297f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102980:	89 ca                	mov    %ecx,%edx
80102982:	ec                   	in     (%dx),%al
80102983:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102986:	89 da                	mov    %ebx,%edx
80102988:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010298b:	b8 09 00 00 00       	mov    $0x9,%eax
80102990:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102991:	89 ca                	mov    %ecx,%edx
80102993:	ec                   	in     (%dx),%al
80102994:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102997:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010299a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010299d:	8d 45 d0             	lea    -0x30(%ebp),%eax
801029a0:	6a 18                	push   $0x18
801029a2:	50                   	push   %eax
801029a3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801029a6:	50                   	push   %eax
801029a7:	e8 64 1b 00 00       	call   80104510 <memcmp>
801029ac:	83 c4 10             	add    $0x10,%esp
801029af:	85 c0                	test   %eax,%eax
801029b1:	0f 85 f1 fe ff ff    	jne    801028a8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801029b7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801029bb:	75 78                	jne    80102a35 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801029bd:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029c0:	89 c2                	mov    %eax,%edx
801029c2:	83 e0 0f             	and    $0xf,%eax
801029c5:	c1 ea 04             	shr    $0x4,%edx
801029c8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801029d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d4:	89 c2                	mov    %eax,%edx
801029d6:	83 e0 0f             	and    $0xf,%eax
801029d9:	c1 ea 04             	shr    $0x4,%edx
801029dc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029df:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029e2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029e8:	89 c2                	mov    %eax,%edx
801029ea:	83 e0 0f             	and    $0xf,%eax
801029ed:	c1 ea 04             	shr    $0x4,%edx
801029f0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029f3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029f6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029fc:	89 c2                	mov    %eax,%edx
801029fe:	83 e0 0f             	and    $0xf,%eax
80102a01:	c1 ea 04             	shr    $0x4,%edx
80102a04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a0a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a0d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a10:	89 c2                	mov    %eax,%edx
80102a12:	83 e0 0f             	and    $0xf,%eax
80102a15:	c1 ea 04             	shr    $0x4,%edx
80102a18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a1e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a21:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a24:	89 c2                	mov    %eax,%edx
80102a26:	83 e0 0f             	and    $0xf,%eax
80102a29:	c1 ea 04             	shr    $0x4,%edx
80102a2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a32:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a35:	8b 75 08             	mov    0x8(%ebp),%esi
80102a38:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a3b:	89 06                	mov    %eax,(%esi)
80102a3d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a40:	89 46 04             	mov    %eax,0x4(%esi)
80102a43:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a46:	89 46 08             	mov    %eax,0x8(%esi)
80102a49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a4c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a52:	89 46 10             	mov    %eax,0x10(%esi)
80102a55:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a58:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a5b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a65:	5b                   	pop    %ebx
80102a66:	5e                   	pop    %esi
80102a67:	5f                   	pop    %edi
80102a68:	5d                   	pop    %ebp
80102a69:	c3                   	ret    
80102a6a:	66 90                	xchg   %ax,%ax
80102a6c:	66 90                	xchg   %ax,%ax
80102a6e:	66 90                	xchg   %ax,%ax

80102a70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a70:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a76:	85 c9                	test   %ecx,%ecx
80102a78:	0f 8e 8a 00 00 00    	jle    80102b08 <install_trans+0x98>
{
80102a7e:	55                   	push   %ebp
80102a7f:	89 e5                	mov    %esp,%ebp
80102a81:	57                   	push   %edi
80102a82:	56                   	push   %esi
80102a83:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a84:	31 db                	xor    %ebx,%ebx
{
80102a86:	83 ec 0c             	sub    $0xc,%esp
80102a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a90:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a95:	83 ec 08             	sub    $0x8,%esp
80102a98:	01 d8                	add    %ebx,%eax
80102a9a:	83 c0 01             	add    $0x1,%eax
80102a9d:	50                   	push   %eax
80102a9e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102aa4:	e8 27 d6 ff ff       	call   801000d0 <bread>
80102aa9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102aab:	58                   	pop    %eax
80102aac:	5a                   	pop    %edx
80102aad:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102ab4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102aba:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102abd:	e8 0e d6 ff ff       	call   801000d0 <bread>
80102ac2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ac4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102ac7:	83 c4 0c             	add    $0xc,%esp
80102aca:	68 00 02 00 00       	push   $0x200
80102acf:	50                   	push   %eax
80102ad0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ad3:	50                   	push   %eax
80102ad4:	e8 97 1a 00 00       	call   80104570 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ad9:	89 34 24             	mov    %esi,(%esp)
80102adc:	e8 bf d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ae1:	89 3c 24             	mov    %edi,(%esp)
80102ae4:	e8 f7 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ae9:	89 34 24             	mov    %esi,(%esp)
80102aec:	e8 ef d6 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102af1:	83 c4 10             	add    $0x10,%esp
80102af4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102afa:	7f 94                	jg     80102a90 <install_trans+0x20>
  }
}
80102afc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102aff:	5b                   	pop    %ebx
80102b00:	5e                   	pop    %esi
80102b01:	5f                   	pop    %edi
80102b02:	5d                   	pop    %ebp
80102b03:	c3                   	ret    
80102b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b08:	f3 c3                	repz ret 
80102b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	56                   	push   %esi
80102b14:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102b15:	83 ec 08             	sub    $0x8,%esp
80102b18:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102b1e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b24:	e8 a7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b29:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b2f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b32:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102b34:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102b36:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b39:	7e 16                	jle    80102b51 <write_head+0x41>
80102b3b:	c1 e3 02             	shl    $0x2,%ebx
80102b3e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b40:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102b46:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b4a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b4d:	39 da                	cmp    %ebx,%edx
80102b4f:	75 ef                	jne    80102b40 <write_head+0x30>
  }
  bwrite(buf);
80102b51:	83 ec 0c             	sub    $0xc,%esp
80102b54:	56                   	push   %esi
80102b55:	e8 46 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b5a:	89 34 24             	mov    %esi,(%esp)
80102b5d:	e8 7e d6 ff ff       	call   801001e0 <brelse>
}
80102b62:	83 c4 10             	add    $0x10,%esp
80102b65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b68:	5b                   	pop    %ebx
80102b69:	5e                   	pop    %esi
80102b6a:	5d                   	pop    %ebp
80102b6b:	c3                   	ret    
80102b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b70 <initlog>:
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	53                   	push   %ebx
80102b74:	83 ec 2c             	sub    $0x2c,%esp
80102b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b7a:	68 c0 73 10 80       	push   $0x801073c0
80102b7f:	68 80 26 11 80       	push   $0x80112680
80102b84:	e8 e7 16 00 00       	call   80104270 <initlock>
  readsb(dev, &sb);
80102b89:	58                   	pop    %eax
80102b8a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b8d:	5a                   	pop    %edx
80102b8e:	50                   	push   %eax
80102b8f:	53                   	push   %ebx
80102b90:	e8 9b e8 ff ff       	call   80101430 <readsb>
  log.size = sb.nlog;
80102b95:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b9b:	59                   	pop    %ecx
  log.dev = dev;
80102b9c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102ba2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102ba8:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102bad:	5a                   	pop    %edx
80102bae:	50                   	push   %eax
80102baf:	53                   	push   %ebx
80102bb0:	e8 1b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102bb5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102bb8:	83 c4 10             	add    $0x10,%esp
80102bbb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102bbd:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102bc3:	7e 1c                	jle    80102be1 <initlog+0x71>
80102bc5:	c1 e3 02             	shl    $0x2,%ebx
80102bc8:	31 d2                	xor    %edx,%edx
80102bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102bd0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102bd4:	83 c2 04             	add    $0x4,%edx
80102bd7:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102bdd:	39 d3                	cmp    %edx,%ebx
80102bdf:	75 ef                	jne    80102bd0 <initlog+0x60>
  brelse(buf);
80102be1:	83 ec 0c             	sub    $0xc,%esp
80102be4:	50                   	push   %eax
80102be5:	e8 f6 d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bea:	e8 81 fe ff ff       	call   80102a70 <install_trans>
  log.lh.n = 0;
80102bef:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102bf6:	00 00 00 
  write_head(); // clear the log
80102bf9:	e8 12 ff ff ff       	call   80102b10 <write_head>
}
80102bfe:	83 c4 10             	add    $0x10,%esp
80102c01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c16:	68 80 26 11 80       	push   $0x80112680
80102c1b:	e8 90 17 00 00       	call   801043b0 <acquire>
80102c20:	83 c4 10             	add    $0x10,%esp
80102c23:	eb 18                	jmp    80102c3d <begin_op+0x2d>
80102c25:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c28:	83 ec 08             	sub    $0x8,%esp
80102c2b:	68 80 26 11 80       	push   $0x80112680
80102c30:	68 80 26 11 80       	push   $0x80112680
80102c35:	e8 b6 11 00 00       	call   80103df0 <sleep>
80102c3a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c3d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102c42:	85 c0                	test   %eax,%eax
80102c44:	75 e2                	jne    80102c28 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c46:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c4b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c51:	83 c0 01             	add    $0x1,%eax
80102c54:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c57:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c5a:	83 fa 1e             	cmp    $0x1e,%edx
80102c5d:	7f c9                	jg     80102c28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c5f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c62:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102c67:	68 80 26 11 80       	push   $0x80112680
80102c6c:	e8 ff 17 00 00       	call   80104470 <release>
      break;
    }
  }
}
80102c71:	83 c4 10             	add    $0x10,%esp
80102c74:	c9                   	leave  
80102c75:	c3                   	ret    
80102c76:	8d 76 00             	lea    0x0(%esi),%esi
80102c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	57                   	push   %edi
80102c84:	56                   	push   %esi
80102c85:	53                   	push   %ebx
80102c86:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c89:	68 80 26 11 80       	push   $0x80112680
80102c8e:	e8 1d 17 00 00       	call   801043b0 <acquire>
  log.outstanding -= 1;
80102c93:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102c98:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102c9e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ca1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102ca4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102ca6:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102cac:	0f 85 1a 01 00 00    	jne    80102dcc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102cb2:	85 db                	test   %ebx,%ebx
80102cb4:	0f 85 ee 00 00 00    	jne    80102da8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102cba:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102cbd:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102cc4:	00 00 00 
  release(&log.lock);
80102cc7:	68 80 26 11 80       	push   $0x80112680
80102ccc:	e8 9f 17 00 00       	call   80104470 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102cd1:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102cd7:	83 c4 10             	add    $0x10,%esp
80102cda:	85 c9                	test   %ecx,%ecx
80102cdc:	0f 8e 85 00 00 00    	jle    80102d67 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ce2:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102ce7:	83 ec 08             	sub    $0x8,%esp
80102cea:	01 d8                	add    %ebx,%eax
80102cec:	83 c0 01             	add    $0x1,%eax
80102cef:	50                   	push   %eax
80102cf0:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102cf6:	e8 d5 d3 ff ff       	call   801000d0 <bread>
80102cfb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cfd:	58                   	pop    %eax
80102cfe:	5a                   	pop    %edx
80102cff:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102d06:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d0c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d0f:	e8 bc d3 ff ff       	call   801000d0 <bread>
80102d14:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d16:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d19:	83 c4 0c             	add    $0xc,%esp
80102d1c:	68 00 02 00 00       	push   $0x200
80102d21:	50                   	push   %eax
80102d22:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d25:	50                   	push   %eax
80102d26:	e8 45 18 00 00       	call   80104570 <memmove>
    bwrite(to);  // write the log
80102d2b:	89 34 24             	mov    %esi,(%esp)
80102d2e:	e8 6d d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d33:	89 3c 24             	mov    %edi,(%esp)
80102d36:	e8 a5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d3b:	89 34 24             	mov    %esi,(%esp)
80102d3e:	e8 9d d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d43:	83 c4 10             	add    $0x10,%esp
80102d46:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102d4c:	7c 94                	jl     80102ce2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d4e:	e8 bd fd ff ff       	call   80102b10 <write_head>
    install_trans(); // Now install writes to home locations
80102d53:	e8 18 fd ff ff       	call   80102a70 <install_trans>
    log.lh.n = 0;
80102d58:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d5f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d62:	e8 a9 fd ff ff       	call   80102b10 <write_head>
    acquire(&log.lock);
80102d67:	83 ec 0c             	sub    $0xc,%esp
80102d6a:	68 80 26 11 80       	push   $0x80112680
80102d6f:	e8 3c 16 00 00       	call   801043b0 <acquire>
    wakeup(&log);
80102d74:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d7b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d82:	00 00 00 
    wakeup(&log);
80102d85:	e8 16 12 00 00       	call   80103fa0 <wakeup>
    release(&log.lock);
80102d8a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d91:	e8 da 16 00 00       	call   80104470 <release>
80102d96:	83 c4 10             	add    $0x10,%esp
}
80102d99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d9c:	5b                   	pop    %ebx
80102d9d:	5e                   	pop    %esi
80102d9e:	5f                   	pop    %edi
80102d9f:	5d                   	pop    %ebp
80102da0:	c3                   	ret    
80102da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102da8:	83 ec 0c             	sub    $0xc,%esp
80102dab:	68 80 26 11 80       	push   $0x80112680
80102db0:	e8 eb 11 00 00       	call   80103fa0 <wakeup>
  release(&log.lock);
80102db5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102dbc:	e8 af 16 00 00       	call   80104470 <release>
80102dc1:	83 c4 10             	add    $0x10,%esp
}
80102dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dc7:	5b                   	pop    %ebx
80102dc8:	5e                   	pop    %esi
80102dc9:	5f                   	pop    %edi
80102dca:	5d                   	pop    %ebp
80102dcb:	c3                   	ret    
    panic("log.committing");
80102dcc:	83 ec 0c             	sub    $0xc,%esp
80102dcf:	68 c4 73 10 80       	push   $0x801073c4
80102dd4:	e8 b7 d5 ff ff       	call   80100390 <panic>
80102dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102de0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
80102de4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102de7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102ded:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102df0:	83 fa 1d             	cmp    $0x1d,%edx
80102df3:	0f 8f 9d 00 00 00    	jg     80102e96 <log_write+0xb6>
80102df9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102dfe:	83 e8 01             	sub    $0x1,%eax
80102e01:	39 c2                	cmp    %eax,%edx
80102e03:	0f 8d 8d 00 00 00    	jge    80102e96 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e09:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e0e:	85 c0                	test   %eax,%eax
80102e10:	0f 8e 8d 00 00 00    	jle    80102ea3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e16:	83 ec 0c             	sub    $0xc,%esp
80102e19:	68 80 26 11 80       	push   $0x80112680
80102e1e:	e8 8d 15 00 00       	call   801043b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e23:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102e29:	83 c4 10             	add    $0x10,%esp
80102e2c:	83 f9 00             	cmp    $0x0,%ecx
80102e2f:	7e 57                	jle    80102e88 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e31:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e34:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e36:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102e3c:	75 0b                	jne    80102e49 <log_write+0x69>
80102e3e:	eb 38                	jmp    80102e78 <log_write+0x98>
80102e40:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102e47:	74 2f                	je     80102e78 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e49:	83 c0 01             	add    $0x1,%eax
80102e4c:	39 c1                	cmp    %eax,%ecx
80102e4e:	75 f0                	jne    80102e40 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e50:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e57:	83 c0 01             	add    $0x1,%eax
80102e5a:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102e5f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e62:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102e69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e6c:	c9                   	leave  
  release(&log.lock);
80102e6d:	e9 fe 15 00 00       	jmp    80104470 <release>
80102e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e78:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102e7f:	eb de                	jmp    80102e5f <log_write+0x7f>
80102e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e88:	8b 43 08             	mov    0x8(%ebx),%eax
80102e8b:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102e90:	75 cd                	jne    80102e5f <log_write+0x7f>
80102e92:	31 c0                	xor    %eax,%eax
80102e94:	eb c1                	jmp    80102e57 <log_write+0x77>
    panic("too big a transaction");
80102e96:	83 ec 0c             	sub    $0xc,%esp
80102e99:	68 d3 73 10 80       	push   $0x801073d3
80102e9e:	e8 ed d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102ea3:	83 ec 0c             	sub    $0xc,%esp
80102ea6:	68 e9 73 10 80       	push   $0x801073e9
80102eab:	e8 e0 d4 ff ff       	call   80100390 <panic>

80102eb0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	53                   	push   %ebx
80102eb4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102eb7:	e8 74 09 00 00       	call   80103830 <cpuid>
80102ebc:	89 c3                	mov    %eax,%ebx
80102ebe:	e8 6d 09 00 00       	call   80103830 <cpuid>
80102ec3:	83 ec 04             	sub    $0x4,%esp
80102ec6:	53                   	push   %ebx
80102ec7:	50                   	push   %eax
80102ec8:	68 04 74 10 80       	push   $0x80107404
80102ecd:	e8 8e d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ed2:	e8 69 28 00 00       	call   80105740 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ed7:	e8 d4 08 00 00       	call   801037b0 <mycpu>
80102edc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ede:	b8 01 00 00 00       	mov    $0x1,%eax
80102ee3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eea:	e8 21 0c 00 00       	call   80103b10 <scheduler>
80102eef:	90                   	nop

80102ef0 <mpenter>:
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ef6:	e8 35 39 00 00       	call   80106830 <switchkvm>
  seginit();
80102efb:	e8 a0 38 00 00       	call   801067a0 <seginit>
  lapicinit();
80102f00:	e8 9b f7 ff ff       	call   801026a0 <lapicinit>
  mpmain();
80102f05:	e8 a6 ff ff ff       	call   80102eb0 <mpmain>
80102f0a:	66 90                	xchg   %ax,%ax
80102f0c:	66 90                	xchg   %ax,%ax
80102f0e:	66 90                	xchg   %ax,%ax

80102f10 <main>:
{
80102f10:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f14:	83 e4 f0             	and    $0xfffffff0,%esp
80102f17:	ff 71 fc             	pushl  -0x4(%ecx)
80102f1a:	55                   	push   %ebp
80102f1b:	89 e5                	mov    %esp,%ebp
80102f1d:	53                   	push   %ebx
80102f1e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f1f:	83 ec 08             	sub    $0x8,%esp
80102f22:	68 00 00 40 80       	push   $0x80400000
80102f27:	68 a8 54 11 80       	push   $0x801154a8
80102f2c:	e8 2f f5 ff ff       	call   80102460 <kinit1>
  kvmalloc();      // kernel page table
80102f31:	e8 ca 3d 00 00       	call   80106d00 <kvmalloc>
  mpinit();        // detect other processors
80102f36:	e8 75 01 00 00       	call   801030b0 <mpinit>
  lapicinit();     // interrupt controller
80102f3b:	e8 60 f7 ff ff       	call   801026a0 <lapicinit>
  seginit();       // segment descriptors
80102f40:	e8 5b 38 00 00       	call   801067a0 <seginit>
  picinit();       // disable pic
80102f45:	e8 46 03 00 00       	call   80103290 <picinit>
  ioapicinit();    // another interrupt controller
80102f4a:	e8 41 f3 ff ff       	call   80102290 <ioapicinit>
  consoleinit();   // console hardware
80102f4f:	e8 cc da ff ff       	call   80100a20 <consoleinit>
  uartinit();      // serial port
80102f54:	e8 17 2b 00 00       	call   80105a70 <uartinit>
  pinit();         // process table
80102f59:	e8 32 08 00 00       	call   80103790 <pinit>
  tvinit();        // trap vectors
80102f5e:	e8 5d 27 00 00       	call   801056c0 <tvinit>
  binit();         // buffer cache
80102f63:	e8 d8 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f68:	e8 53 de ff ff       	call   80100dc0 <fileinit>
  ideinit();       // disk 
80102f6d:	e8 fe f0 ff ff       	call   80102070 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f72:	83 c4 0c             	add    $0xc,%esp
80102f75:	68 8a 00 00 00       	push   $0x8a
80102f7a:	68 8c a4 10 80       	push   $0x8010a48c
80102f7f:	68 00 70 00 80       	push   $0x80007000
80102f84:	e8 e7 15 00 00       	call   80104570 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f89:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f90:	00 00 00 
80102f93:	83 c4 10             	add    $0x10,%esp
80102f96:	05 80 27 11 80       	add    $0x80112780,%eax
80102f9b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102fa0:	76 71                	jbe    80103013 <main+0x103>
80102fa2:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102fa7:	89 f6                	mov    %esi,%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102fb0:	e8 fb 07 00 00       	call   801037b0 <mycpu>
80102fb5:	39 d8                	cmp    %ebx,%eax
80102fb7:	74 41                	je     80102ffa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102fb9:	e8 72 f5 ff ff       	call   80102530 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fbe:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102fc3:	c7 05 f8 6f 00 80 f0 	movl   $0x80102ef0,0x80006ff8
80102fca:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fcd:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102fd4:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fd7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102fdc:	0f b6 03             	movzbl (%ebx),%eax
80102fdf:	83 ec 08             	sub    $0x8,%esp
80102fe2:	68 00 70 00 00       	push   $0x7000
80102fe7:	50                   	push   %eax
80102fe8:	e8 03 f8 ff ff       	call   801027f0 <lapicstartap>
80102fed:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ff0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ff6:	85 c0                	test   %eax,%eax
80102ff8:	74 f6                	je     80102ff0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102ffa:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103001:	00 00 00 
80103004:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010300a:	05 80 27 11 80       	add    $0x80112780,%eax
8010300f:	39 c3                	cmp    %eax,%ebx
80103011:	72 9d                	jb     80102fb0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103013:	83 ec 08             	sub    $0x8,%esp
80103016:	68 00 00 00 8e       	push   $0x8e000000
8010301b:	68 00 00 40 80       	push   $0x80400000
80103020:	e8 ab f4 ff ff       	call   801024d0 <kinit2>
  userinit();      // first user process
80103025:	e8 56 08 00 00       	call   80103880 <userinit>
  mpmain();        // finish this processor's setup
8010302a:	e8 81 fe ff ff       	call   80102eb0 <mpmain>
8010302f:	90                   	nop

80103030 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	57                   	push   %edi
80103034:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103035:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010303b:	53                   	push   %ebx
  e = addr+len;
8010303c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010303f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103042:	39 de                	cmp    %ebx,%esi
80103044:	72 10                	jb     80103056 <mpsearch1+0x26>
80103046:	eb 50                	jmp    80103098 <mpsearch1+0x68>
80103048:	90                   	nop
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103050:	39 fb                	cmp    %edi,%ebx
80103052:	89 fe                	mov    %edi,%esi
80103054:	76 42                	jbe    80103098 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103056:	83 ec 04             	sub    $0x4,%esp
80103059:	8d 7e 10             	lea    0x10(%esi),%edi
8010305c:	6a 04                	push   $0x4
8010305e:	68 18 74 10 80       	push   $0x80107418
80103063:	56                   	push   %esi
80103064:	e8 a7 14 00 00       	call   80104510 <memcmp>
80103069:	83 c4 10             	add    $0x10,%esp
8010306c:	85 c0                	test   %eax,%eax
8010306e:	75 e0                	jne    80103050 <mpsearch1+0x20>
80103070:	89 f1                	mov    %esi,%ecx
80103072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103078:	0f b6 11             	movzbl (%ecx),%edx
8010307b:	83 c1 01             	add    $0x1,%ecx
8010307e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103080:	39 f9                	cmp    %edi,%ecx
80103082:	75 f4                	jne    80103078 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103084:	84 c0                	test   %al,%al
80103086:	75 c8                	jne    80103050 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103088:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010308b:	89 f0                	mov    %esi,%eax
8010308d:	5b                   	pop    %ebx
8010308e:	5e                   	pop    %esi
8010308f:	5f                   	pop    %edi
80103090:	5d                   	pop    %ebp
80103091:	c3                   	ret    
80103092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103098:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010309b:	31 f6                	xor    %esi,%esi
}
8010309d:	89 f0                	mov    %esi,%eax
8010309f:	5b                   	pop    %ebx
801030a0:	5e                   	pop    %esi
801030a1:	5f                   	pop    %edi
801030a2:	5d                   	pop    %ebp
801030a3:	c3                   	ret    
801030a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801030b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	57                   	push   %edi
801030b4:	56                   	push   %esi
801030b5:	53                   	push   %ebx
801030b6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030c7:	c1 e0 08             	shl    $0x8,%eax
801030ca:	09 d0                	or     %edx,%eax
801030cc:	c1 e0 04             	shl    $0x4,%eax
801030cf:	85 c0                	test   %eax,%eax
801030d1:	75 1b                	jne    801030ee <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030d3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030da:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030e1:	c1 e0 08             	shl    $0x8,%eax
801030e4:	09 d0                	or     %edx,%eax
801030e6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030e9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030ee:	ba 00 04 00 00       	mov    $0x400,%edx
801030f3:	e8 38 ff ff ff       	call   80103030 <mpsearch1>
801030f8:	85 c0                	test   %eax,%eax
801030fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030fd:	0f 84 3d 01 00 00    	je     80103240 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103106:	8b 58 04             	mov    0x4(%eax),%ebx
80103109:	85 db                	test   %ebx,%ebx
8010310b:	0f 84 4f 01 00 00    	je     80103260 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103111:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103117:	83 ec 04             	sub    $0x4,%esp
8010311a:	6a 04                	push   $0x4
8010311c:	68 35 74 10 80       	push   $0x80107435
80103121:	56                   	push   %esi
80103122:	e8 e9 13 00 00       	call   80104510 <memcmp>
80103127:	83 c4 10             	add    $0x10,%esp
8010312a:	85 c0                	test   %eax,%eax
8010312c:	0f 85 2e 01 00 00    	jne    80103260 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103132:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103139:	3c 01                	cmp    $0x1,%al
8010313b:	0f 95 c2             	setne  %dl
8010313e:	3c 04                	cmp    $0x4,%al
80103140:	0f 95 c0             	setne  %al
80103143:	20 c2                	and    %al,%dl
80103145:	0f 85 15 01 00 00    	jne    80103260 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010314b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103152:	66 85 ff             	test   %di,%di
80103155:	74 1a                	je     80103171 <mpinit+0xc1>
80103157:	89 f0                	mov    %esi,%eax
80103159:	01 f7                	add    %esi,%edi
  sum = 0;
8010315b:	31 d2                	xor    %edx,%edx
8010315d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103160:	0f b6 08             	movzbl (%eax),%ecx
80103163:	83 c0 01             	add    $0x1,%eax
80103166:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103168:	39 c7                	cmp    %eax,%edi
8010316a:	75 f4                	jne    80103160 <mpinit+0xb0>
8010316c:	84 d2                	test   %dl,%dl
8010316e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103171:	85 f6                	test   %esi,%esi
80103173:	0f 84 e7 00 00 00    	je     80103260 <mpinit+0x1b0>
80103179:	84 d2                	test   %dl,%dl
8010317b:	0f 85 df 00 00 00    	jne    80103260 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103181:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103187:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010318c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103193:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103199:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010319e:	01 d6                	add    %edx,%esi
801031a0:	39 c6                	cmp    %eax,%esi
801031a2:	76 23                	jbe    801031c7 <mpinit+0x117>
    switch(*p){
801031a4:	0f b6 10             	movzbl (%eax),%edx
801031a7:	80 fa 04             	cmp    $0x4,%dl
801031aa:	0f 87 ca 00 00 00    	ja     8010327a <mpinit+0x1ca>
801031b0:	ff 24 95 5c 74 10 80 	jmp    *-0x7fef8ba4(,%edx,4)
801031b7:	89 f6                	mov    %esi,%esi
801031b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801031c0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031c3:	39 c6                	cmp    %eax,%esi
801031c5:	77 dd                	ja     801031a4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801031c7:	85 db                	test   %ebx,%ebx
801031c9:	0f 84 9e 00 00 00    	je     8010326d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801031cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031d2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031d6:	74 15                	je     801031ed <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031d8:	b8 70 00 00 00       	mov    $0x70,%eax
801031dd:	ba 22 00 00 00       	mov    $0x22,%edx
801031e2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031e3:	ba 23 00 00 00       	mov    $0x23,%edx
801031e8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031e9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ec:	ee                   	out    %al,(%dx)
  }
}
801031ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031f0:	5b                   	pop    %ebx
801031f1:	5e                   	pop    %esi
801031f2:	5f                   	pop    %edi
801031f3:	5d                   	pop    %ebp
801031f4:	c3                   	ret    
801031f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031f8:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
801031fe:	83 f9 07             	cmp    $0x7,%ecx
80103201:	7f 19                	jg     8010321c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103203:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103207:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010320d:	83 c1 01             	add    $0x1,%ecx
80103210:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103216:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
8010321c:	83 c0 14             	add    $0x14,%eax
      continue;
8010321f:	e9 7c ff ff ff       	jmp    801031a0 <mpinit+0xf0>
80103224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103228:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010322c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010322f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103235:	e9 66 ff ff ff       	jmp    801031a0 <mpinit+0xf0>
8010323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103240:	ba 00 00 01 00       	mov    $0x10000,%edx
80103245:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010324a:	e8 e1 fd ff ff       	call   80103030 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010324f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103254:	0f 85 a9 fe ff ff    	jne    80103103 <mpinit+0x53>
8010325a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103260:	83 ec 0c             	sub    $0xc,%esp
80103263:	68 1d 74 10 80       	push   $0x8010741d
80103268:	e8 23 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010326d:	83 ec 0c             	sub    $0xc,%esp
80103270:	68 3c 74 10 80       	push   $0x8010743c
80103275:	e8 16 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010327a:	31 db                	xor    %ebx,%ebx
8010327c:	e9 26 ff ff ff       	jmp    801031a7 <mpinit+0xf7>
80103281:	66 90                	xchg   %ax,%ax
80103283:	66 90                	xchg   %ax,%ax
80103285:	66 90                	xchg   %ax,%ax
80103287:	66 90                	xchg   %ax,%ax
80103289:	66 90                	xchg   %ax,%ax
8010328b:	66 90                	xchg   %ax,%ax
8010328d:	66 90                	xchg   %ax,%ax
8010328f:	90                   	nop

80103290 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103290:	55                   	push   %ebp
80103291:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103296:	ba 21 00 00 00       	mov    $0x21,%edx
8010329b:	89 e5                	mov    %esp,%ebp
8010329d:	ee                   	out    %al,(%dx)
8010329e:	ba a1 00 00 00       	mov    $0xa1,%edx
801032a3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801032a4:	5d                   	pop    %ebp
801032a5:	c3                   	ret    
801032a6:	66 90                	xchg   %ax,%ax
801032a8:	66 90                	xchg   %ax,%ax
801032aa:	66 90                	xchg   %ax,%ax
801032ac:	66 90                	xchg   %ax,%ax
801032ae:	66 90                	xchg   %ax,%ax

801032b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	57                   	push   %edi
801032b4:	56                   	push   %esi
801032b5:	53                   	push   %ebx
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032bf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801032c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801032cb:	e8 10 db ff ff       	call   80100de0 <filealloc>
801032d0:	85 c0                	test   %eax,%eax
801032d2:	89 03                	mov    %eax,(%ebx)
801032d4:	74 22                	je     801032f8 <pipealloc+0x48>
801032d6:	e8 05 db ff ff       	call   80100de0 <filealloc>
801032db:	85 c0                	test   %eax,%eax
801032dd:	89 06                	mov    %eax,(%esi)
801032df:	74 3f                	je     80103320 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032e1:	e8 4a f2 ff ff       	call   80102530 <kalloc>
801032e6:	85 c0                	test   %eax,%eax
801032e8:	89 c7                	mov    %eax,%edi
801032ea:	75 54                	jne    80103340 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032ec:	8b 03                	mov    (%ebx),%eax
801032ee:	85 c0                	test   %eax,%eax
801032f0:	75 34                	jne    80103326 <pipealloc+0x76>
801032f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032f8:	8b 06                	mov    (%esi),%eax
801032fa:	85 c0                	test   %eax,%eax
801032fc:	74 0c                	je     8010330a <pipealloc+0x5a>
    fileclose(*f1);
801032fe:	83 ec 0c             	sub    $0xc,%esp
80103301:	50                   	push   %eax
80103302:	e8 99 db ff ff       	call   80100ea0 <fileclose>
80103307:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010330a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010330d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103312:	5b                   	pop    %ebx
80103313:	5e                   	pop    %esi
80103314:	5f                   	pop    %edi
80103315:	5d                   	pop    %ebp
80103316:	c3                   	ret    
80103317:	89 f6                	mov    %esi,%esi
80103319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103320:	8b 03                	mov    (%ebx),%eax
80103322:	85 c0                	test   %eax,%eax
80103324:	74 e4                	je     8010330a <pipealloc+0x5a>
    fileclose(*f0);
80103326:	83 ec 0c             	sub    $0xc,%esp
80103329:	50                   	push   %eax
8010332a:	e8 71 db ff ff       	call   80100ea0 <fileclose>
  if(*f1)
8010332f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103331:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103334:	85 c0                	test   %eax,%eax
80103336:	75 c6                	jne    801032fe <pipealloc+0x4e>
80103338:	eb d0                	jmp    8010330a <pipealloc+0x5a>
8010333a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103340:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103343:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010334a:	00 00 00 
  p->writeopen = 1;
8010334d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103354:	00 00 00 
  p->nwrite = 0;
80103357:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010335e:	00 00 00 
  p->nread = 0;
80103361:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103368:	00 00 00 
  initlock(&p->lock, "pipe");
8010336b:	68 70 74 10 80       	push   $0x80107470
80103370:	50                   	push   %eax
80103371:	e8 fa 0e 00 00       	call   80104270 <initlock>
  (*f0)->type = FD_PIPE;
80103376:	8b 03                	mov    (%ebx),%eax
  return 0;
80103378:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010337b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103381:	8b 03                	mov    (%ebx),%eax
80103383:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103387:	8b 03                	mov    (%ebx),%eax
80103389:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010338d:	8b 03                	mov    (%ebx),%eax
8010338f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103392:	8b 06                	mov    (%esi),%eax
80103394:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010339a:	8b 06                	mov    (%esi),%eax
8010339c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033a0:	8b 06                	mov    (%esi),%eax
801033a2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033a6:	8b 06                	mov    (%esi),%eax
801033a8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801033ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033ae:	31 c0                	xor    %eax,%eax
}
801033b0:	5b                   	pop    %ebx
801033b1:	5e                   	pop    %esi
801033b2:	5f                   	pop    %edi
801033b3:	5d                   	pop    %ebp
801033b4:	c3                   	ret    
801033b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033c0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	56                   	push   %esi
801033c4:	53                   	push   %ebx
801033c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033cb:	83 ec 0c             	sub    $0xc,%esp
801033ce:	53                   	push   %ebx
801033cf:	e8 dc 0f 00 00       	call   801043b0 <acquire>
  if(writable){
801033d4:	83 c4 10             	add    $0x10,%esp
801033d7:	85 f6                	test   %esi,%esi
801033d9:	74 45                	je     80103420 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033db:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033e1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033e4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033eb:	00 00 00 
    wakeup(&p->nread);
801033ee:	50                   	push   %eax
801033ef:	e8 ac 0b 00 00       	call   80103fa0 <wakeup>
801033f4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033f7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033fd:	85 d2                	test   %edx,%edx
801033ff:	75 0a                	jne    8010340b <pipeclose+0x4b>
80103401:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103407:	85 c0                	test   %eax,%eax
80103409:	74 35                	je     80103440 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010340b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010340e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103411:	5b                   	pop    %ebx
80103412:	5e                   	pop    %esi
80103413:	5d                   	pop    %ebp
    release(&p->lock);
80103414:	e9 57 10 00 00       	jmp    80104470 <release>
80103419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103420:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103426:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103429:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103430:	00 00 00 
    wakeup(&p->nwrite);
80103433:	50                   	push   %eax
80103434:	e8 67 0b 00 00       	call   80103fa0 <wakeup>
80103439:	83 c4 10             	add    $0x10,%esp
8010343c:	eb b9                	jmp    801033f7 <pipeclose+0x37>
8010343e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103440:	83 ec 0c             	sub    $0xc,%esp
80103443:	53                   	push   %ebx
80103444:	e8 27 10 00 00       	call   80104470 <release>
    kfree((char*)p);
80103449:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010344c:	83 c4 10             	add    $0x10,%esp
}
8010344f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103452:	5b                   	pop    %ebx
80103453:	5e                   	pop    %esi
80103454:	5d                   	pop    %ebp
    kfree((char*)p);
80103455:	e9 26 ef ff ff       	jmp    80102380 <kfree>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103460 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 28             	sub    $0x28,%esp
80103469:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010346c:	53                   	push   %ebx
8010346d:	e8 3e 0f 00 00       	call   801043b0 <acquire>
  for(i = 0; i < n; i++){
80103472:	8b 45 10             	mov    0x10(%ebp),%eax
80103475:	83 c4 10             	add    $0x10,%esp
80103478:	85 c0                	test   %eax,%eax
8010347a:	0f 8e c9 00 00 00    	jle    80103549 <pipewrite+0xe9>
80103480:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103483:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103489:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010348f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103492:	03 4d 10             	add    0x10(%ebp),%ecx
80103495:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103498:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010349e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801034a4:	39 d0                	cmp    %edx,%eax
801034a6:	75 71                	jne    80103519 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801034a8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034ae:	85 c0                	test   %eax,%eax
801034b0:	74 4e                	je     80103500 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034b2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801034b8:	eb 3a                	jmp    801034f4 <pipewrite+0x94>
801034ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	57                   	push   %edi
801034c4:	e8 d7 0a 00 00       	call   80103fa0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034c9:	5a                   	pop    %edx
801034ca:	59                   	pop    %ecx
801034cb:	53                   	push   %ebx
801034cc:	56                   	push   %esi
801034cd:	e8 1e 09 00 00       	call   80103df0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034d2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034d8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034de:	83 c4 10             	add    $0x10,%esp
801034e1:	05 00 02 00 00       	add    $0x200,%eax
801034e6:	39 c2                	cmp    %eax,%edx
801034e8:	75 36                	jne    80103520 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034ea:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034f0:	85 c0                	test   %eax,%eax
801034f2:	74 0c                	je     80103500 <pipewrite+0xa0>
801034f4:	e8 57 03 00 00       	call   80103850 <myproc>
801034f9:	8b 40 24             	mov    0x24(%eax),%eax
801034fc:	85 c0                	test   %eax,%eax
801034fe:	74 c0                	je     801034c0 <pipewrite+0x60>
        release(&p->lock);
80103500:	83 ec 0c             	sub    $0xc,%esp
80103503:	53                   	push   %ebx
80103504:	e8 67 0f 00 00       	call   80104470 <release>
        return -1;
80103509:	83 c4 10             	add    $0x10,%esp
8010350c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103511:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103514:	5b                   	pop    %ebx
80103515:	5e                   	pop    %esi
80103516:	5f                   	pop    %edi
80103517:	5d                   	pop    %ebp
80103518:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103519:	89 c2                	mov    %eax,%edx
8010351b:	90                   	nop
8010351c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103520:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103523:	8d 42 01             	lea    0x1(%edx),%eax
80103526:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010352c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103532:	83 c6 01             	add    $0x1,%esi
80103535:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103539:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010353c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010353f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103543:	0f 85 4f ff ff ff    	jne    80103498 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103549:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010354f:	83 ec 0c             	sub    $0xc,%esp
80103552:	50                   	push   %eax
80103553:	e8 48 0a 00 00       	call   80103fa0 <wakeup>
  release(&p->lock);
80103558:	89 1c 24             	mov    %ebx,(%esp)
8010355b:	e8 10 0f 00 00       	call   80104470 <release>
  return n;
80103560:	83 c4 10             	add    $0x10,%esp
80103563:	8b 45 10             	mov    0x10(%ebp),%eax
80103566:	eb a9                	jmp    80103511 <pipewrite+0xb1>
80103568:	90                   	nop
80103569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103570 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	57                   	push   %edi
80103574:	56                   	push   %esi
80103575:	53                   	push   %ebx
80103576:	83 ec 18             	sub    $0x18,%esp
80103579:	8b 75 08             	mov    0x8(%ebp),%esi
8010357c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010357f:	56                   	push   %esi
80103580:	e8 2b 0e 00 00       	call   801043b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103585:	83 c4 10             	add    $0x10,%esp
80103588:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010358e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103594:	75 6a                	jne    80103600 <piperead+0x90>
80103596:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010359c:	85 db                	test   %ebx,%ebx
8010359e:	0f 84 c4 00 00 00    	je     80103668 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801035a4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801035aa:	eb 2d                	jmp    801035d9 <piperead+0x69>
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b0:	83 ec 08             	sub    $0x8,%esp
801035b3:	56                   	push   %esi
801035b4:	53                   	push   %ebx
801035b5:	e8 36 08 00 00       	call   80103df0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035ba:	83 c4 10             	add    $0x10,%esp
801035bd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035c3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035c9:	75 35                	jne    80103600 <piperead+0x90>
801035cb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035d1:	85 d2                	test   %edx,%edx
801035d3:	0f 84 8f 00 00 00    	je     80103668 <piperead+0xf8>
    if(myproc()->killed){
801035d9:	e8 72 02 00 00       	call   80103850 <myproc>
801035de:	8b 48 24             	mov    0x24(%eax),%ecx
801035e1:	85 c9                	test   %ecx,%ecx
801035e3:	74 cb                	je     801035b0 <piperead+0x40>
      release(&p->lock);
801035e5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035e8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035ed:	56                   	push   %esi
801035ee:	e8 7d 0e 00 00       	call   80104470 <release>
      return -1;
801035f3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035f9:	89 d8                	mov    %ebx,%eax
801035fb:	5b                   	pop    %ebx
801035fc:	5e                   	pop    %esi
801035fd:	5f                   	pop    %edi
801035fe:	5d                   	pop    %ebp
801035ff:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103600:	8b 45 10             	mov    0x10(%ebp),%eax
80103603:	85 c0                	test   %eax,%eax
80103605:	7e 61                	jle    80103668 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103607:	31 db                	xor    %ebx,%ebx
80103609:	eb 13                	jmp    8010361e <piperead+0xae>
8010360b:	90                   	nop
8010360c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103610:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103616:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010361c:	74 1f                	je     8010363d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010361e:	8d 41 01             	lea    0x1(%ecx),%eax
80103621:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103627:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010362d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103632:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103635:	83 c3 01             	add    $0x1,%ebx
80103638:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010363b:	75 d3                	jne    80103610 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010363d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103643:	83 ec 0c             	sub    $0xc,%esp
80103646:	50                   	push   %eax
80103647:	e8 54 09 00 00       	call   80103fa0 <wakeup>
  release(&p->lock);
8010364c:	89 34 24             	mov    %esi,(%esp)
8010364f:	e8 1c 0e 00 00       	call   80104470 <release>
  return i;
80103654:	83 c4 10             	add    $0x10,%esp
}
80103657:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365a:	89 d8                	mov    %ebx,%eax
8010365c:	5b                   	pop    %ebx
8010365d:	5e                   	pop    %esi
8010365e:	5f                   	pop    %edi
8010365f:	5d                   	pop    %ebp
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103668:	31 db                	xor    %ebx,%ebx
8010366a:	eb d1                	jmp    8010363d <piperead+0xcd>
8010366c:	66 90                	xchg   %ax,%ax
8010366e:	66 90                	xchg   %ax,%ax

80103670 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103674:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103679:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010367c:	68 20 2d 11 80       	push   $0x80112d20
80103681:	e8 2a 0d 00 00       	call   801043b0 <acquire>
80103686:	83 c4 10             	add    $0x10,%esp
80103689:	eb 10                	jmp    8010369b <allocproc+0x2b>
8010368b:	90                   	nop
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103690:	83 c3 7c             	add    $0x7c,%ebx
80103693:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103699:	73 75                	jae    80103710 <allocproc+0xa0>
    if(p->state == UNUSED)
8010369b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010369e:	85 c0                	test   %eax,%eax
801036a0:	75 ee                	jne    80103690 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801036a2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801036a7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801036aa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801036b1:	8d 50 01             	lea    0x1(%eax),%edx
801036b4:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801036b7:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801036bc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801036c2:	e8 a9 0d 00 00       	call   80104470 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036c7:	e8 64 ee ff ff       	call   80102530 <kalloc>
801036cc:	83 c4 10             	add    $0x10,%esp
801036cf:	85 c0                	test   %eax,%eax
801036d1:	89 43 08             	mov    %eax,0x8(%ebx)
801036d4:	74 53                	je     80103729 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036d6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036dc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036df:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036e4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801036e7:	c7 40 14 b2 56 10 80 	movl   $0x801056b2,0x14(%eax)
  p->context = (struct context*)sp;
801036ee:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036f1:	6a 14                	push   $0x14
801036f3:	6a 00                	push   $0x0
801036f5:	50                   	push   %eax
801036f6:	e8 c5 0d 00 00       	call   801044c0 <memset>
  p->context->eip = (uint)forkret;
801036fb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801036fe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103701:	c7 40 10 40 37 10 80 	movl   $0x80103740,0x10(%eax)
}
80103708:	89 d8                	mov    %ebx,%eax
8010370a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010370d:	c9                   	leave  
8010370e:	c3                   	ret    
8010370f:	90                   	nop
  release(&ptable.lock);
80103710:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103713:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103715:	68 20 2d 11 80       	push   $0x80112d20
8010371a:	e8 51 0d 00 00       	call   80104470 <release>
}
8010371f:	89 d8                	mov    %ebx,%eax
  return 0;
80103721:	83 c4 10             	add    $0x10,%esp
}
80103724:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103727:	c9                   	leave  
80103728:	c3                   	ret    
    p->state = UNUSED;
80103729:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103730:	31 db                	xor    %ebx,%ebx
80103732:	eb d4                	jmp    80103708 <allocproc+0x98>
80103734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010373a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103740 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103746:	68 20 2d 11 80       	push   $0x80112d20
8010374b:	e8 20 0d 00 00       	call   80104470 <release>

  if (first) {
80103750:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	85 c0                	test   %eax,%eax
8010375a:	75 04                	jne    80103760 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010375c:	c9                   	leave  
8010375d:	c3                   	ret    
8010375e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103760:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103763:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010376a:	00 00 00 
    iinit(ROOTDEV);
8010376d:	6a 01                	push   $0x1
8010376f:	e8 7c dd ff ff       	call   801014f0 <iinit>
    initlog(ROOTDEV);
80103774:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010377b:	e8 f0 f3 ff ff       	call   80102b70 <initlog>
80103780:	83 c4 10             	add    $0x10,%esp
}
80103783:	c9                   	leave  
80103784:	c3                   	ret    
80103785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103790 <pinit>:
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103796:	68 75 74 10 80       	push   $0x80107475
8010379b:	68 20 2d 11 80       	push   $0x80112d20
801037a0:	e8 cb 0a 00 00       	call   80104270 <initlock>
}
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	c9                   	leave  
801037a9:	c3                   	ret    
801037aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037b0 <mycpu>:
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	56                   	push   %esi
801037b4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037b5:	9c                   	pushf  
801037b6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801037b7:	f6 c4 02             	test   $0x2,%ah
801037ba:	75 5e                	jne    8010381a <mycpu+0x6a>
  apicid = lapicid();
801037bc:	e8 df ef ff ff       	call   801027a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801037c1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801037c7:	85 f6                	test   %esi,%esi
801037c9:	7e 42                	jle    8010380d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801037cb:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801037d2:	39 d0                	cmp    %edx,%eax
801037d4:	74 30                	je     80103806 <mycpu+0x56>
801037d6:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
801037db:	31 d2                	xor    %edx,%edx
801037dd:	8d 76 00             	lea    0x0(%esi),%esi
801037e0:	83 c2 01             	add    $0x1,%edx
801037e3:	39 f2                	cmp    %esi,%edx
801037e5:	74 26                	je     8010380d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801037e7:	0f b6 19             	movzbl (%ecx),%ebx
801037ea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037f0:	39 c3                	cmp    %eax,%ebx
801037f2:	75 ec                	jne    801037e0 <mycpu+0x30>
801037f4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801037fa:	05 80 27 11 80       	add    $0x80112780,%eax
}
801037ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103802:	5b                   	pop    %ebx
80103803:	5e                   	pop    %esi
80103804:	5d                   	pop    %ebp
80103805:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103806:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
8010380b:	eb f2                	jmp    801037ff <mycpu+0x4f>
  panic("unknown apicid\n");
8010380d:	83 ec 0c             	sub    $0xc,%esp
80103810:	68 7c 74 10 80       	push   $0x8010747c
80103815:	e8 76 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010381a:	83 ec 0c             	sub    $0xc,%esp
8010381d:	68 58 75 10 80       	push   $0x80107558
80103822:	e8 69 cb ff ff       	call   80100390 <panic>
80103827:	89 f6                	mov    %esi,%esi
80103829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103830 <cpuid>:
cpuid() {
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103836:	e8 75 ff ff ff       	call   801037b0 <mycpu>
8010383b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103840:	c9                   	leave  
  return mycpu()-cpus;
80103841:	c1 f8 04             	sar    $0x4,%eax
80103844:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010384a:	c3                   	ret    
8010384b:	90                   	nop
8010384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103850 <myproc>:
myproc(void) {
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	53                   	push   %ebx
80103854:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103857:	e8 84 0a 00 00       	call   801042e0 <pushcli>
  c = mycpu();
8010385c:	e8 4f ff ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103861:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103867:	e8 b4 0a 00 00       	call   80104320 <popcli>
}
8010386c:	83 c4 04             	add    $0x4,%esp
8010386f:	89 d8                	mov    %ebx,%eax
80103871:	5b                   	pop    %ebx
80103872:	5d                   	pop    %ebp
80103873:	c3                   	ret    
80103874:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010387a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103880 <userinit>:
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	53                   	push   %ebx
80103884:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103887:	e8 e4 fd ff ff       	call   80103670 <allocproc>
8010388c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010388e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103893:	e8 e8 33 00 00       	call   80106c80 <setupkvm>
80103898:	85 c0                	test   %eax,%eax
8010389a:	89 43 04             	mov    %eax,0x4(%ebx)
8010389d:	0f 84 bd 00 00 00    	je     80103960 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038a3:	83 ec 04             	sub    $0x4,%esp
801038a6:	68 2c 00 00 00       	push   $0x2c
801038ab:	68 60 a4 10 80       	push   $0x8010a460
801038b0:	50                   	push   %eax
801038b1:	e8 aa 30 00 00       	call   80106960 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801038b6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801038b9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038bf:	6a 4c                	push   $0x4c
801038c1:	6a 00                	push   $0x0
801038c3:	ff 73 18             	pushl  0x18(%ebx)
801038c6:	e8 f5 0b 00 00       	call   801044c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038cb:	8b 43 18             	mov    0x18(%ebx),%eax
801038ce:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038d3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038d8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038db:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038df:	8b 43 18             	mov    0x18(%ebx),%eax
801038e2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801038e6:	8b 43 18             	mov    0x18(%ebx),%eax
801038e9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038ed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801038f1:	8b 43 18             	mov    0x18(%ebx),%eax
801038f4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038f8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801038fc:	8b 43 18             	mov    0x18(%ebx),%eax
801038ff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103906:	8b 43 18             	mov    0x18(%ebx),%eax
80103909:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103910:	8b 43 18             	mov    0x18(%ebx),%eax
80103913:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010391a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010391d:	6a 10                	push   $0x10
8010391f:	68 a5 74 10 80       	push   $0x801074a5
80103924:	50                   	push   %eax
80103925:	e8 76 0d 00 00       	call   801046a0 <safestrcpy>
  p->cwd = namei("/");
8010392a:	c7 04 24 ae 74 10 80 	movl   $0x801074ae,(%esp)
80103931:	e8 1a e6 ff ff       	call   80101f50 <namei>
80103936:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103939:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103940:	e8 6b 0a 00 00       	call   801043b0 <acquire>
  p->state = RUNNABLE;
80103945:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010394c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103953:	e8 18 0b 00 00       	call   80104470 <release>
}
80103958:	83 c4 10             	add    $0x10,%esp
8010395b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010395e:	c9                   	leave  
8010395f:	c3                   	ret    
    panic("userinit: out of memory?");
80103960:	83 ec 0c             	sub    $0xc,%esp
80103963:	68 8c 74 10 80       	push   $0x8010748c
80103968:	e8 23 ca ff ff       	call   80100390 <panic>
8010396d:	8d 76 00             	lea    0x0(%esi),%esi

80103970 <growproc>:
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	56                   	push   %esi
80103974:	53                   	push   %ebx
80103975:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103978:	e8 63 09 00 00       	call   801042e0 <pushcli>
  c = mycpu();
8010397d:	e8 2e fe ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103982:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103988:	e8 93 09 00 00       	call   80104320 <popcli>
  if(n > 0){
8010398d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103990:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103992:	7f 1c                	jg     801039b0 <growproc+0x40>
  } else if(n < 0){
80103994:	75 3a                	jne    801039d0 <growproc+0x60>
  switchuvm(curproc);
80103996:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103999:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010399b:	53                   	push   %ebx
8010399c:	e8 af 2e 00 00       	call   80106850 <switchuvm>
  return 0;
801039a1:	83 c4 10             	add    $0x10,%esp
801039a4:	31 c0                	xor    %eax,%eax
}
801039a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039a9:	5b                   	pop    %ebx
801039aa:	5e                   	pop    %esi
801039ab:	5d                   	pop    %ebp
801039ac:	c3                   	ret    
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039b0:	83 ec 04             	sub    $0x4,%esp
801039b3:	01 c6                	add    %eax,%esi
801039b5:	56                   	push   %esi
801039b6:	50                   	push   %eax
801039b7:	ff 73 04             	pushl  0x4(%ebx)
801039ba:	e8 e1 30 00 00       	call   80106aa0 <allocuvm>
801039bf:	83 c4 10             	add    $0x10,%esp
801039c2:	85 c0                	test   %eax,%eax
801039c4:	75 d0                	jne    80103996 <growproc+0x26>
      return -1;
801039c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039cb:	eb d9                	jmp    801039a6 <growproc+0x36>
801039cd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039d0:	83 ec 04             	sub    $0x4,%esp
801039d3:	01 c6                	add    %eax,%esi
801039d5:	56                   	push   %esi
801039d6:	50                   	push   %eax
801039d7:	ff 73 04             	pushl  0x4(%ebx)
801039da:	e8 f1 31 00 00       	call   80106bd0 <deallocuvm>
801039df:	83 c4 10             	add    $0x10,%esp
801039e2:	85 c0                	test   %eax,%eax
801039e4:	75 b0                	jne    80103996 <growproc+0x26>
801039e6:	eb de                	jmp    801039c6 <growproc+0x56>
801039e8:	90                   	nop
801039e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039f0 <fork>:
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	57                   	push   %edi
801039f4:	56                   	push   %esi
801039f5:	53                   	push   %ebx
801039f6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801039f9:	e8 e2 08 00 00       	call   801042e0 <pushcli>
  c = mycpu();
801039fe:	e8 ad fd ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103a03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a09:	e8 12 09 00 00       	call   80104320 <popcli>
  if((np = allocproc()) == 0){
80103a0e:	e8 5d fc ff ff       	call   80103670 <allocproc>
80103a13:	85 c0                	test   %eax,%eax
80103a15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a18:	0f 84 b7 00 00 00    	je     80103ad5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103a1e:	83 ec 08             	sub    $0x8,%esp
80103a21:	ff 33                	pushl  (%ebx)
80103a23:	ff 73 04             	pushl  0x4(%ebx)
80103a26:	89 c7                	mov    %eax,%edi
80103a28:	e8 23 33 00 00       	call   80106d50 <copyuvm>
80103a2d:	83 c4 10             	add    $0x10,%esp
80103a30:	85 c0                	test   %eax,%eax
80103a32:	89 47 04             	mov    %eax,0x4(%edi)
80103a35:	0f 84 a1 00 00 00    	je     80103adc <fork+0xec>
  np->sz = curproc->sz;
80103a3b:	8b 03                	mov    (%ebx),%eax
80103a3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103a40:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103a42:	89 59 14             	mov    %ebx,0x14(%ecx)
80103a45:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103a47:	8b 79 18             	mov    0x18(%ecx),%edi
80103a4a:	8b 73 18             	mov    0x18(%ebx),%esi
80103a4d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103a54:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103a56:	8b 40 18             	mov    0x18(%eax),%eax
80103a59:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103a60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a64:	85 c0                	test   %eax,%eax
80103a66:	74 13                	je     80103a7b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a68:	83 ec 0c             	sub    $0xc,%esp
80103a6b:	50                   	push   %eax
80103a6c:	e8 df d3 ff ff       	call   80100e50 <filedup>
80103a71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a74:	83 c4 10             	add    $0x10,%esp
80103a77:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103a7b:	83 c6 01             	add    $0x1,%esi
80103a7e:	83 fe 10             	cmp    $0x10,%esi
80103a81:	75 dd                	jne    80103a60 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103a83:	83 ec 0c             	sub    $0xc,%esp
80103a86:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a89:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103a8c:	e8 2f dc ff ff       	call   801016c0 <idup>
80103a91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a94:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103a97:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a9a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103a9d:	6a 10                	push   $0x10
80103a9f:	53                   	push   %ebx
80103aa0:	50                   	push   %eax
80103aa1:	e8 fa 0b 00 00       	call   801046a0 <safestrcpy>
  pid = np->pid;
80103aa6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103aa9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ab0:	e8 fb 08 00 00       	call   801043b0 <acquire>
  np->state = RUNNABLE;
80103ab5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103abc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ac3:	e8 a8 09 00 00       	call   80104470 <release>
  return pid;
80103ac8:	83 c4 10             	add    $0x10,%esp
}
80103acb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ace:	89 d8                	mov    %ebx,%eax
80103ad0:	5b                   	pop    %ebx
80103ad1:	5e                   	pop    %esi
80103ad2:	5f                   	pop    %edi
80103ad3:	5d                   	pop    %ebp
80103ad4:	c3                   	ret    
    return -1;
80103ad5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ada:	eb ef                	jmp    80103acb <fork+0xdb>
    kfree(np->kstack);
80103adc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103adf:	83 ec 0c             	sub    $0xc,%esp
80103ae2:	ff 73 08             	pushl  0x8(%ebx)
80103ae5:	e8 96 e8 ff ff       	call   80102380 <kfree>
    np->kstack = 0;
80103aea:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103af1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103af8:	83 c4 10             	add    $0x10,%esp
80103afb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b00:	eb c9                	jmp    80103acb <fork+0xdb>
80103b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b10 <scheduler>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	57                   	push   %edi
80103b14:	56                   	push   %esi
80103b15:	53                   	push   %ebx
80103b16:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103b19:	e8 92 fc ff ff       	call   801037b0 <mycpu>
80103b1e:	8d 78 04             	lea    0x4(%eax),%edi
80103b21:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103b23:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b2a:	00 00 00 
80103b2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103b30:	fb                   	sti    
    acquire(&ptable.lock);
80103b31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b34:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103b39:	68 20 2d 11 80       	push   $0x80112d20
80103b3e:	e8 6d 08 00 00       	call   801043b0 <acquire>
80103b43:	83 c4 10             	add    $0x10,%esp
80103b46:	8d 76 00             	lea    0x0(%esi),%esi
80103b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103b50:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b54:	75 33                	jne    80103b89 <scheduler+0x79>
      switchuvm(p);
80103b56:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103b59:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103b5f:	53                   	push   %ebx
80103b60:	e8 eb 2c 00 00       	call   80106850 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103b65:	58                   	pop    %eax
80103b66:	5a                   	pop    %edx
80103b67:	ff 73 1c             	pushl  0x1c(%ebx)
80103b6a:	57                   	push   %edi
      p->state = RUNNING;
80103b6b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103b72:	e8 84 0b 00 00       	call   801046fb <swtch>
      switchkvm();
80103b77:	e8 b4 2c 00 00       	call   80106830 <switchkvm>
      c->proc = 0;
80103b7c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b83:	00 00 00 
80103b86:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b89:	83 c3 7c             	add    $0x7c,%ebx
80103b8c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103b92:	72 bc                	jb     80103b50 <scheduler+0x40>
    release(&ptable.lock);
80103b94:	83 ec 0c             	sub    $0xc,%esp
80103b97:	68 20 2d 11 80       	push   $0x80112d20
80103b9c:	e8 cf 08 00 00       	call   80104470 <release>
    sti();
80103ba1:	83 c4 10             	add    $0x10,%esp
80103ba4:	eb 8a                	jmp    80103b30 <scheduler+0x20>
80103ba6:	8d 76 00             	lea    0x0(%esi),%esi
80103ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bb0 <sched>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	56                   	push   %esi
80103bb4:	53                   	push   %ebx
  pushcli();
80103bb5:	e8 26 07 00 00       	call   801042e0 <pushcli>
  c = mycpu();
80103bba:	e8 f1 fb ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103bbf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bc5:	e8 56 07 00 00       	call   80104320 <popcli>
  if(!holding(&ptable.lock))
80103bca:	83 ec 0c             	sub    $0xc,%esp
80103bcd:	68 20 2d 11 80       	push   $0x80112d20
80103bd2:	e8 a9 07 00 00       	call   80104380 <holding>
80103bd7:	83 c4 10             	add    $0x10,%esp
80103bda:	85 c0                	test   %eax,%eax
80103bdc:	74 4f                	je     80103c2d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103bde:	e8 cd fb ff ff       	call   801037b0 <mycpu>
80103be3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103bea:	75 68                	jne    80103c54 <sched+0xa4>
  if(p->state == RUNNING)
80103bec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103bf0:	74 55                	je     80103c47 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bf2:	9c                   	pushf  
80103bf3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103bf4:	f6 c4 02             	test   $0x2,%ah
80103bf7:	75 41                	jne    80103c3a <sched+0x8a>
  intena = mycpu()->intena;
80103bf9:	e8 b2 fb ff ff       	call   801037b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103bfe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103c01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c07:	e8 a4 fb ff ff       	call   801037b0 <mycpu>
80103c0c:	83 ec 08             	sub    $0x8,%esp
80103c0f:	ff 70 04             	pushl  0x4(%eax)
80103c12:	53                   	push   %ebx
80103c13:	e8 e3 0a 00 00       	call   801046fb <swtch>
  mycpu()->intena = intena;
80103c18:	e8 93 fb ff ff       	call   801037b0 <mycpu>
}
80103c1d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103c20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103c26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c29:	5b                   	pop    %ebx
80103c2a:	5e                   	pop    %esi
80103c2b:	5d                   	pop    %ebp
80103c2c:	c3                   	ret    
    panic("sched ptable.lock");
80103c2d:	83 ec 0c             	sub    $0xc,%esp
80103c30:	68 b0 74 10 80       	push   $0x801074b0
80103c35:	e8 56 c7 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103c3a:	83 ec 0c             	sub    $0xc,%esp
80103c3d:	68 dc 74 10 80       	push   $0x801074dc
80103c42:	e8 49 c7 ff ff       	call   80100390 <panic>
    panic("sched running");
80103c47:	83 ec 0c             	sub    $0xc,%esp
80103c4a:	68 ce 74 10 80       	push   $0x801074ce
80103c4f:	e8 3c c7 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103c54:	83 ec 0c             	sub    $0xc,%esp
80103c57:	68 c2 74 10 80       	push   $0x801074c2
80103c5c:	e8 2f c7 ff ff       	call   80100390 <panic>
80103c61:	eb 0d                	jmp    80103c70 <exit>
80103c63:	90                   	nop
80103c64:	90                   	nop
80103c65:	90                   	nop
80103c66:	90                   	nop
80103c67:	90                   	nop
80103c68:	90                   	nop
80103c69:	90                   	nop
80103c6a:	90                   	nop
80103c6b:	90                   	nop
80103c6c:	90                   	nop
80103c6d:	90                   	nop
80103c6e:	90                   	nop
80103c6f:	90                   	nop

80103c70 <exit>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	57                   	push   %edi
80103c74:	56                   	push   %esi
80103c75:	53                   	push   %ebx
80103c76:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103c79:	e8 62 06 00 00       	call   801042e0 <pushcli>
  c = mycpu();
80103c7e:	e8 2d fb ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103c83:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c89:	e8 92 06 00 00       	call   80104320 <popcli>
  if(curproc == initproc)
80103c8e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103c94:	8d 5e 28             	lea    0x28(%esi),%ebx
80103c97:	8d 7e 68             	lea    0x68(%esi),%edi
80103c9a:	0f 84 e7 00 00 00    	je     80103d87 <exit+0x117>
    if(curproc->ofile[fd]){
80103ca0:	8b 03                	mov    (%ebx),%eax
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	74 12                	je     80103cb8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103ca6:	83 ec 0c             	sub    $0xc,%esp
80103ca9:	50                   	push   %eax
80103caa:	e8 f1 d1 ff ff       	call   80100ea0 <fileclose>
      curproc->ofile[fd] = 0;
80103caf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103cb5:	83 c4 10             	add    $0x10,%esp
80103cb8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103cbb:	39 fb                	cmp    %edi,%ebx
80103cbd:	75 e1                	jne    80103ca0 <exit+0x30>
  begin_op();
80103cbf:	e8 4c ef ff ff       	call   80102c10 <begin_op>
  iput(curproc->cwd);
80103cc4:	83 ec 0c             	sub    $0xc,%esp
80103cc7:	ff 76 68             	pushl  0x68(%esi)
80103cca:	e8 51 db ff ff       	call   80101820 <iput>
  end_op();
80103ccf:	e8 ac ef ff ff       	call   80102c80 <end_op>
  curproc->cwd = 0;
80103cd4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103cdb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ce2:	e8 c9 06 00 00       	call   801043b0 <acquire>
  wakeup1(curproc->parent);
80103ce7:	8b 56 14             	mov    0x14(%esi),%edx
80103cea:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ced:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103cf2:	eb 0e                	jmp    80103d02 <exit+0x92>
80103cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cf8:	83 c0 7c             	add    $0x7c,%eax
80103cfb:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d00:	73 1c                	jae    80103d1e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103d02:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d06:	75 f0                	jne    80103cf8 <exit+0x88>
80103d08:	3b 50 20             	cmp    0x20(%eax),%edx
80103d0b:	75 eb                	jne    80103cf8 <exit+0x88>
      p->state = RUNNABLE;
80103d0d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d14:	83 c0 7c             	add    $0x7c,%eax
80103d17:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d1c:	72 e4                	jb     80103d02 <exit+0x92>
      p->parent = initproc;
80103d1e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d24:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103d29:	eb 10                	jmp    80103d3b <exit+0xcb>
80103d2b:	90                   	nop
80103d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d30:	83 c2 7c             	add    $0x7c,%edx
80103d33:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103d39:	73 33                	jae    80103d6e <exit+0xfe>
    if(p->parent == curproc){
80103d3b:	39 72 14             	cmp    %esi,0x14(%edx)
80103d3e:	75 f0                	jne    80103d30 <exit+0xc0>
      if(p->state == ZOMBIE)
80103d40:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103d44:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d47:	75 e7                	jne    80103d30 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d49:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d4e:	eb 0a                	jmp    80103d5a <exit+0xea>
80103d50:	83 c0 7c             	add    $0x7c,%eax
80103d53:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d58:	73 d6                	jae    80103d30 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103d5a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d5e:	75 f0                	jne    80103d50 <exit+0xe0>
80103d60:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d63:	75 eb                	jne    80103d50 <exit+0xe0>
      p->state = RUNNABLE;
80103d65:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d6c:	eb e2                	jmp    80103d50 <exit+0xe0>
  curproc->state = ZOMBIE;
80103d6e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d75:	e8 36 fe ff ff       	call   80103bb0 <sched>
  panic("zombie exit");
80103d7a:	83 ec 0c             	sub    $0xc,%esp
80103d7d:	68 fd 74 10 80       	push   $0x801074fd
80103d82:	e8 09 c6 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103d87:	83 ec 0c             	sub    $0xc,%esp
80103d8a:	68 f0 74 10 80       	push   $0x801074f0
80103d8f:	e8 fc c5 ff ff       	call   80100390 <panic>
80103d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103da0 <yield>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	53                   	push   %ebx
80103da4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103da7:	68 20 2d 11 80       	push   $0x80112d20
80103dac:	e8 ff 05 00 00       	call   801043b0 <acquire>
  pushcli();
80103db1:	e8 2a 05 00 00       	call   801042e0 <pushcli>
  c = mycpu();
80103db6:	e8 f5 f9 ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103dbb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dc1:	e8 5a 05 00 00       	call   80104320 <popcli>
  myproc()->state = RUNNABLE;
80103dc6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103dcd:	e8 de fd ff ff       	call   80103bb0 <sched>
  release(&ptable.lock);
80103dd2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dd9:	e8 92 06 00 00       	call   80104470 <release>
}
80103dde:	83 c4 10             	add    $0x10,%esp
80103de1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103de4:	c9                   	leave  
80103de5:	c3                   	ret    
80103de6:	8d 76 00             	lea    0x0(%esi),%esi
80103de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103df0 <sleep>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	57                   	push   %edi
80103df4:	56                   	push   %esi
80103df5:	53                   	push   %ebx
80103df6:	83 ec 0c             	sub    $0xc,%esp
80103df9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103dfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103dff:	e8 dc 04 00 00       	call   801042e0 <pushcli>
  c = mycpu();
80103e04:	e8 a7 f9 ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103e09:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e0f:	e8 0c 05 00 00       	call   80104320 <popcli>
  if(p == 0)
80103e14:	85 db                	test   %ebx,%ebx
80103e16:	0f 84 87 00 00 00    	je     80103ea3 <sleep+0xb3>
  if(lk == 0)
80103e1c:	85 f6                	test   %esi,%esi
80103e1e:	74 76                	je     80103e96 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e20:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103e26:	74 50                	je     80103e78 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e28:	83 ec 0c             	sub    $0xc,%esp
80103e2b:	68 20 2d 11 80       	push   $0x80112d20
80103e30:	e8 7b 05 00 00       	call   801043b0 <acquire>
    release(lk);
80103e35:	89 34 24             	mov    %esi,(%esp)
80103e38:	e8 33 06 00 00       	call   80104470 <release>
  p->chan = chan;
80103e3d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e40:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e47:	e8 64 fd ff ff       	call   80103bb0 <sched>
  p->chan = 0;
80103e4c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103e53:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e5a:	e8 11 06 00 00       	call   80104470 <release>
    acquire(lk);
80103e5f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e62:	83 c4 10             	add    $0x10,%esp
}
80103e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e68:	5b                   	pop    %ebx
80103e69:	5e                   	pop    %esi
80103e6a:	5f                   	pop    %edi
80103e6b:	5d                   	pop    %ebp
    acquire(lk);
80103e6c:	e9 3f 05 00 00       	jmp    801043b0 <acquire>
80103e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103e78:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e7b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e82:	e8 29 fd ff ff       	call   80103bb0 <sched>
  p->chan = 0;
80103e87:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e91:	5b                   	pop    %ebx
80103e92:	5e                   	pop    %esi
80103e93:	5f                   	pop    %edi
80103e94:	5d                   	pop    %ebp
80103e95:	c3                   	ret    
    panic("sleep without lk");
80103e96:	83 ec 0c             	sub    $0xc,%esp
80103e99:	68 0f 75 10 80       	push   $0x8010750f
80103e9e:	e8 ed c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ea3:	83 ec 0c             	sub    $0xc,%esp
80103ea6:	68 09 75 10 80       	push   $0x80107509
80103eab:	e8 e0 c4 ff ff       	call   80100390 <panic>

80103eb0 <wait>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
  pushcli();
80103eb5:	e8 26 04 00 00       	call   801042e0 <pushcli>
  c = mycpu();
80103eba:	e8 f1 f8 ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103ebf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ec5:	e8 56 04 00 00       	call   80104320 <popcli>
  acquire(&ptable.lock);
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 20 2d 11 80       	push   $0x80112d20
80103ed2:	e8 d9 04 00 00       	call   801043b0 <acquire>
80103ed7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103eda:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103edc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103ee1:	eb 10                	jmp    80103ef3 <wait+0x43>
80103ee3:	90                   	nop
80103ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ee8:	83 c3 7c             	add    $0x7c,%ebx
80103eeb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103ef1:	73 1b                	jae    80103f0e <wait+0x5e>
      if(p->parent != curproc)
80103ef3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ef6:	75 f0                	jne    80103ee8 <wait+0x38>
      if(p->state == ZOMBIE){
80103ef8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103efc:	74 32                	je     80103f30 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103efe:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f01:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f06:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f0c:	72 e5                	jb     80103ef3 <wait+0x43>
    if(!havekids || curproc->killed){
80103f0e:	85 c0                	test   %eax,%eax
80103f10:	74 74                	je     80103f86 <wait+0xd6>
80103f12:	8b 46 24             	mov    0x24(%esi),%eax
80103f15:	85 c0                	test   %eax,%eax
80103f17:	75 6d                	jne    80103f86 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f19:	83 ec 08             	sub    $0x8,%esp
80103f1c:	68 20 2d 11 80       	push   $0x80112d20
80103f21:	56                   	push   %esi
80103f22:	e8 c9 fe ff ff       	call   80103df0 <sleep>
    havekids = 0;
80103f27:	83 c4 10             	add    $0x10,%esp
80103f2a:	eb ae                	jmp    80103eda <wait+0x2a>
80103f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103f30:	83 ec 0c             	sub    $0xc,%esp
80103f33:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103f36:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f39:	e8 42 e4 ff ff       	call   80102380 <kfree>
        freevm(p->pgdir);
80103f3e:	5a                   	pop    %edx
80103f3f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103f42:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f49:	e8 b2 2c 00 00       	call   80106c00 <freevm>
        release(&ptable.lock);
80103f4e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103f55:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f5c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f63:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f67:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f6e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f75:	e8 f6 04 00 00       	call   80104470 <release>
        return pid;
80103f7a:	83 c4 10             	add    $0x10,%esp
}
80103f7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f80:	89 f0                	mov    %esi,%eax
80103f82:	5b                   	pop    %ebx
80103f83:	5e                   	pop    %esi
80103f84:	5d                   	pop    %ebp
80103f85:	c3                   	ret    
      release(&ptable.lock);
80103f86:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f89:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103f8e:	68 20 2d 11 80       	push   $0x80112d20
80103f93:	e8 d8 04 00 00       	call   80104470 <release>
      return -1;
80103f98:	83 c4 10             	add    $0x10,%esp
80103f9b:	eb e0                	jmp    80103f7d <wait+0xcd>
80103f9d:	8d 76 00             	lea    0x0(%esi),%esi

80103fa0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	53                   	push   %ebx
80103fa4:	83 ec 10             	sub    $0x10,%esp
80103fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103faa:	68 20 2d 11 80       	push   $0x80112d20
80103faf:	e8 fc 03 00 00       	call   801043b0 <acquire>
80103fb4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103fbc:	eb 0c                	jmp    80103fca <wakeup+0x2a>
80103fbe:	66 90                	xchg   %ax,%ax
80103fc0:	83 c0 7c             	add    $0x7c,%eax
80103fc3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103fc8:	73 1c                	jae    80103fe6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103fca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fce:	75 f0                	jne    80103fc0 <wakeup+0x20>
80103fd0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103fd3:	75 eb                	jne    80103fc0 <wakeup+0x20>
      p->state = RUNNABLE;
80103fd5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fdc:	83 c0 7c             	add    $0x7c,%eax
80103fdf:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103fe4:	72 e4                	jb     80103fca <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80103fe6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103fed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ff0:	c9                   	leave  
  release(&ptable.lock);
80103ff1:	e9 7a 04 00 00       	jmp    80104470 <release>
80103ff6:	8d 76 00             	lea    0x0(%esi),%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104000 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 10             	sub    $0x10,%esp
80104007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010400a:	68 20 2d 11 80       	push   $0x80112d20
8010400f:	e8 9c 03 00 00       	call   801043b0 <acquire>
80104014:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104017:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010401c:	eb 0c                	jmp    8010402a <kill+0x2a>
8010401e:	66 90                	xchg   %ax,%ax
80104020:	83 c0 7c             	add    $0x7c,%eax
80104023:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104028:	73 36                	jae    80104060 <kill+0x60>
    if(p->pid == pid){
8010402a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010402d:	75 f1                	jne    80104020 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010402f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104033:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010403a:	75 07                	jne    80104043 <kill+0x43>
        p->state = RUNNABLE;
8010403c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104043:	83 ec 0c             	sub    $0xc,%esp
80104046:	68 20 2d 11 80       	push   $0x80112d20
8010404b:	e8 20 04 00 00       	call   80104470 <release>
      return 0;
80104050:	83 c4 10             	add    $0x10,%esp
80104053:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104058:	c9                   	leave  
80104059:	c3                   	ret    
8010405a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104060:	83 ec 0c             	sub    $0xc,%esp
80104063:	68 20 2d 11 80       	push   $0x80112d20
80104068:	e8 03 04 00 00       	call   80104470 <release>
  return -1;
8010406d:	83 c4 10             	add    $0x10,%esp
80104070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104078:	c9                   	leave  
80104079:	c3                   	ret    
8010407a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104080 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	57                   	push   %edi
80104084:	56                   	push   %esi
80104085:	53                   	push   %ebx
80104086:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104089:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010408e:	83 ec 3c             	sub    $0x3c,%esp
80104091:	eb 24                	jmp    801040b7 <procdump+0x37>
80104093:	90                   	nop
80104094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104098:	83 ec 0c             	sub    $0xc,%esp
8010409b:	68 97 78 10 80       	push   $0x80107897
801040a0:	e8 bb c5 ff ff       	call   80100660 <cprintf>
801040a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040a8:	83 c3 7c             	add    $0x7c,%ebx
801040ab:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801040b1:	0f 83 81 00 00 00    	jae    80104138 <procdump+0xb8>
    if(p->state == UNUSED)
801040b7:	8b 43 0c             	mov    0xc(%ebx),%eax
801040ba:	85 c0                	test   %eax,%eax
801040bc:	74 ea                	je     801040a8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040be:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801040c1:	ba 20 75 10 80       	mov    $0x80107520,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040c6:	77 11                	ja     801040d9 <procdump+0x59>
801040c8:	8b 14 85 80 75 10 80 	mov    -0x7fef8a80(,%eax,4),%edx
      state = "???";
801040cf:	b8 20 75 10 80       	mov    $0x80107520,%eax
801040d4:	85 d2                	test   %edx,%edx
801040d6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040d9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801040dc:	50                   	push   %eax
801040dd:	52                   	push   %edx
801040de:	ff 73 10             	pushl  0x10(%ebx)
801040e1:	68 24 75 10 80       	push   $0x80107524
801040e6:	e8 75 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801040eb:	83 c4 10             	add    $0x10,%esp
801040ee:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801040f2:	75 a4                	jne    80104098 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801040f4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801040f7:	83 ec 08             	sub    $0x8,%esp
801040fa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801040fd:	50                   	push   %eax
801040fe:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104101:	8b 40 0c             	mov    0xc(%eax),%eax
80104104:	83 c0 08             	add    $0x8,%eax
80104107:	50                   	push   %eax
80104108:	e8 83 01 00 00       	call   80104290 <getcallerpcs>
8010410d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104110:	8b 17                	mov    (%edi),%edx
80104112:	85 d2                	test   %edx,%edx
80104114:	74 82                	je     80104098 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104116:	83 ec 08             	sub    $0x8,%esp
80104119:	83 c7 04             	add    $0x4,%edi
8010411c:	52                   	push   %edx
8010411d:	68 61 6f 10 80       	push   $0x80106f61
80104122:	e8 39 c5 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104127:	83 c4 10             	add    $0x10,%esp
8010412a:	39 fe                	cmp    %edi,%esi
8010412c:	75 e2                	jne    80104110 <procdump+0x90>
8010412e:	e9 65 ff ff ff       	jmp    80104098 <procdump+0x18>
80104133:	90                   	nop
80104134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104138:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010413b:	5b                   	pop    %ebx
8010413c:	5e                   	pop    %esi
8010413d:	5f                   	pop    %edi
8010413e:	5d                   	pop    %ebp
8010413f:	c3                   	ret    

80104140 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 0c             	sub    $0xc,%esp
80104147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010414a:	68 98 75 10 80       	push   $0x80107598
8010414f:	8d 43 04             	lea    0x4(%ebx),%eax
80104152:	50                   	push   %eax
80104153:	e8 18 01 00 00       	call   80104270 <initlock>
  lk->name = name;
80104158:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010415b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104161:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104164:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010416b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010416e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104171:	c9                   	leave  
80104172:	c3                   	ret    
80104173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104180 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	56                   	push   %esi
80104184:	53                   	push   %ebx
80104185:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104188:	83 ec 0c             	sub    $0xc,%esp
8010418b:	8d 73 04             	lea    0x4(%ebx),%esi
8010418e:	56                   	push   %esi
8010418f:	e8 1c 02 00 00       	call   801043b0 <acquire>
  while (lk->locked) {
80104194:	8b 13                	mov    (%ebx),%edx
80104196:	83 c4 10             	add    $0x10,%esp
80104199:	85 d2                	test   %edx,%edx
8010419b:	74 16                	je     801041b3 <acquiresleep+0x33>
8010419d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801041a0:	83 ec 08             	sub    $0x8,%esp
801041a3:	56                   	push   %esi
801041a4:	53                   	push   %ebx
801041a5:	e8 46 fc ff ff       	call   80103df0 <sleep>
  while (lk->locked) {
801041aa:	8b 03                	mov    (%ebx),%eax
801041ac:	83 c4 10             	add    $0x10,%esp
801041af:	85 c0                	test   %eax,%eax
801041b1:	75 ed                	jne    801041a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801041b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801041b9:	e8 92 f6 ff ff       	call   80103850 <myproc>
801041be:	8b 40 10             	mov    0x10(%eax),%eax
801041c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801041c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041ca:	5b                   	pop    %ebx
801041cb:	5e                   	pop    %esi
801041cc:	5d                   	pop    %ebp
  release(&lk->lk);
801041cd:	e9 9e 02 00 00       	jmp    80104470 <release>
801041d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	56                   	push   %esi
801041e4:	53                   	push   %ebx
801041e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041e8:	83 ec 0c             	sub    $0xc,%esp
801041eb:	8d 73 04             	lea    0x4(%ebx),%esi
801041ee:	56                   	push   %esi
801041ef:	e8 bc 01 00 00       	call   801043b0 <acquire>
  lk->locked = 0;
801041f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801041fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104201:	89 1c 24             	mov    %ebx,(%esp)
80104204:	e8 97 fd ff ff       	call   80103fa0 <wakeup>
  release(&lk->lk);
80104209:	89 75 08             	mov    %esi,0x8(%ebp)
8010420c:	83 c4 10             	add    $0x10,%esp
}
8010420f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104212:	5b                   	pop    %ebx
80104213:	5e                   	pop    %esi
80104214:	5d                   	pop    %ebp
  release(&lk->lk);
80104215:	e9 56 02 00 00       	jmp    80104470 <release>
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	57                   	push   %edi
80104224:	56                   	push   %esi
80104225:	53                   	push   %ebx
80104226:	31 ff                	xor    %edi,%edi
80104228:	83 ec 18             	sub    $0x18,%esp
8010422b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010422e:	8d 73 04             	lea    0x4(%ebx),%esi
80104231:	56                   	push   %esi
80104232:	e8 79 01 00 00       	call   801043b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104237:	8b 03                	mov    (%ebx),%eax
80104239:	83 c4 10             	add    $0x10,%esp
8010423c:	85 c0                	test   %eax,%eax
8010423e:	74 13                	je     80104253 <holdingsleep+0x33>
80104240:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104243:	e8 08 f6 ff ff       	call   80103850 <myproc>
80104248:	39 58 10             	cmp    %ebx,0x10(%eax)
8010424b:	0f 94 c0             	sete   %al
8010424e:	0f b6 c0             	movzbl %al,%eax
80104251:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104253:	83 ec 0c             	sub    $0xc,%esp
80104256:	56                   	push   %esi
80104257:	e8 14 02 00 00       	call   80104470 <release>
  return r;
}
8010425c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010425f:	89 f8                	mov    %edi,%eax
80104261:	5b                   	pop    %ebx
80104262:	5e                   	pop    %esi
80104263:	5f                   	pop    %edi
80104264:	5d                   	pop    %ebp
80104265:	c3                   	ret    
80104266:	66 90                	xchg   %ax,%ax
80104268:	66 90                	xchg   %ax,%ax
8010426a:	66 90                	xchg   %ax,%ax
8010426c:	66 90                	xchg   %ax,%ax
8010426e:	66 90                	xchg   %ax,%ax

80104270 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104276:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104279:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010427f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104282:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104289:	5d                   	pop    %ebp
8010428a:	c3                   	ret    
8010428b:	90                   	nop
8010428c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104290 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104290:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104291:	31 d2                	xor    %edx,%edx
{
80104293:	89 e5                	mov    %esp,%ebp
80104295:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104296:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104299:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010429c:	83 e8 08             	sub    $0x8,%eax
8010429f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801042a0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801042a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801042ac:	77 1a                	ja     801042c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801042ae:	8b 58 04             	mov    0x4(%eax),%ebx
801042b1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801042b4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801042b7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801042b9:	83 fa 0a             	cmp    $0xa,%edx
801042bc:	75 e2                	jne    801042a0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801042be:	5b                   	pop    %ebx
801042bf:	5d                   	pop    %ebp
801042c0:	c3                   	ret    
801042c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042c8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801042cb:	83 c1 28             	add    $0x28,%ecx
801042ce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801042d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801042d6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801042d9:	39 c1                	cmp    %eax,%ecx
801042db:	75 f3                	jne    801042d0 <getcallerpcs+0x40>
}
801042dd:	5b                   	pop    %ebx
801042de:	5d                   	pop    %ebp
801042df:	c3                   	ret    

801042e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 04             	sub    $0x4,%esp
801042e7:	9c                   	pushf  
801042e8:	5b                   	pop    %ebx
  asm volatile("cli");
801042e9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801042ea:	e8 c1 f4 ff ff       	call   801037b0 <mycpu>
801042ef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801042f5:	85 c0                	test   %eax,%eax
801042f7:	75 11                	jne    8010430a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801042f9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801042ff:	e8 ac f4 ff ff       	call   801037b0 <mycpu>
80104304:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010430a:	e8 a1 f4 ff ff       	call   801037b0 <mycpu>
8010430f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104316:	83 c4 04             	add    $0x4,%esp
80104319:	5b                   	pop    %ebx
8010431a:	5d                   	pop    %ebp
8010431b:	c3                   	ret    
8010431c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104320 <popcli>:

void
popcli(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104326:	9c                   	pushf  
80104327:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104328:	f6 c4 02             	test   $0x2,%ah
8010432b:	75 35                	jne    80104362 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010432d:	e8 7e f4 ff ff       	call   801037b0 <mycpu>
80104332:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104339:	78 34                	js     8010436f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010433b:	e8 70 f4 ff ff       	call   801037b0 <mycpu>
80104340:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104346:	85 d2                	test   %edx,%edx
80104348:	74 06                	je     80104350 <popcli+0x30>
    sti();
}
8010434a:	c9                   	leave  
8010434b:	c3                   	ret    
8010434c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104350:	e8 5b f4 ff ff       	call   801037b0 <mycpu>
80104355:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010435b:	85 c0                	test   %eax,%eax
8010435d:	74 eb                	je     8010434a <popcli+0x2a>
  asm volatile("sti");
8010435f:	fb                   	sti    
}
80104360:	c9                   	leave  
80104361:	c3                   	ret    
    panic("popcli - interruptible");
80104362:	83 ec 0c             	sub    $0xc,%esp
80104365:	68 a3 75 10 80       	push   $0x801075a3
8010436a:	e8 21 c0 ff ff       	call   80100390 <panic>
    panic("popcli");
8010436f:	83 ec 0c             	sub    $0xc,%esp
80104372:	68 ba 75 10 80       	push   $0x801075ba
80104377:	e8 14 c0 ff ff       	call   80100390 <panic>
8010437c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104380 <holding>:
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
80104385:	8b 75 08             	mov    0x8(%ebp),%esi
80104388:	31 db                	xor    %ebx,%ebx
  pushcli();
8010438a:	e8 51 ff ff ff       	call   801042e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010438f:	8b 06                	mov    (%esi),%eax
80104391:	85 c0                	test   %eax,%eax
80104393:	74 10                	je     801043a5 <holding+0x25>
80104395:	8b 5e 08             	mov    0x8(%esi),%ebx
80104398:	e8 13 f4 ff ff       	call   801037b0 <mycpu>
8010439d:	39 c3                	cmp    %eax,%ebx
8010439f:	0f 94 c3             	sete   %bl
801043a2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801043a5:	e8 76 ff ff ff       	call   80104320 <popcli>
}
801043aa:	89 d8                	mov    %ebx,%eax
801043ac:	5b                   	pop    %ebx
801043ad:	5e                   	pop    %esi
801043ae:	5d                   	pop    %ebp
801043af:	c3                   	ret    

801043b0 <acquire>:
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	56                   	push   %esi
801043b4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801043b5:	e8 26 ff ff ff       	call   801042e0 <pushcli>
  if(holding(lk))
801043ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043bd:	83 ec 0c             	sub    $0xc,%esp
801043c0:	53                   	push   %ebx
801043c1:	e8 ba ff ff ff       	call   80104380 <holding>
801043c6:	83 c4 10             	add    $0x10,%esp
801043c9:	85 c0                	test   %eax,%eax
801043cb:	0f 85 83 00 00 00    	jne    80104454 <acquire+0xa4>
801043d1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801043d3:	ba 01 00 00 00       	mov    $0x1,%edx
801043d8:	eb 09                	jmp    801043e3 <acquire+0x33>
801043da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043e3:	89 d0                	mov    %edx,%eax
801043e5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801043e8:	85 c0                	test   %eax,%eax
801043ea:	75 f4                	jne    801043e0 <acquire+0x30>
  __sync_synchronize();
801043ec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801043f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043f4:	e8 b7 f3 ff ff       	call   801037b0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801043f9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801043fc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801043ff:	89 e8                	mov    %ebp,%eax
80104401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104408:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010440e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104414:	77 1a                	ja     80104430 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104416:	8b 48 04             	mov    0x4(%eax),%ecx
80104419:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010441c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010441f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104421:	83 fe 0a             	cmp    $0xa,%esi
80104424:	75 e2                	jne    80104408 <acquire+0x58>
}
80104426:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104429:	5b                   	pop    %ebx
8010442a:	5e                   	pop    %esi
8010442b:	5d                   	pop    %ebp
8010442c:	c3                   	ret    
8010442d:	8d 76 00             	lea    0x0(%esi),%esi
80104430:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104433:	83 c2 28             	add    $0x28,%edx
80104436:	8d 76 00             	lea    0x0(%esi),%esi
80104439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104446:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104449:	39 d0                	cmp    %edx,%eax
8010444b:	75 f3                	jne    80104440 <acquire+0x90>
}
8010444d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104450:	5b                   	pop    %ebx
80104451:	5e                   	pop    %esi
80104452:	5d                   	pop    %ebp
80104453:	c3                   	ret    
    panic("acquire");
80104454:	83 ec 0c             	sub    $0xc,%esp
80104457:	68 c1 75 10 80       	push   $0x801075c1
8010445c:	e8 2f bf ff ff       	call   80100390 <panic>
80104461:	eb 0d                	jmp    80104470 <release>
80104463:	90                   	nop
80104464:	90                   	nop
80104465:	90                   	nop
80104466:	90                   	nop
80104467:	90                   	nop
80104468:	90                   	nop
80104469:	90                   	nop
8010446a:	90                   	nop
8010446b:	90                   	nop
8010446c:	90                   	nop
8010446d:	90                   	nop
8010446e:	90                   	nop
8010446f:	90                   	nop

80104470 <release>:
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	53                   	push   %ebx
80104474:	83 ec 10             	sub    $0x10,%esp
80104477:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010447a:	53                   	push   %ebx
8010447b:	e8 00 ff ff ff       	call   80104380 <holding>
80104480:	83 c4 10             	add    $0x10,%esp
80104483:	85 c0                	test   %eax,%eax
80104485:	74 22                	je     801044a9 <release+0x39>
  lk->pcs[0] = 0;
80104487:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010448e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104495:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010449a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801044a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a3:	c9                   	leave  
  popcli();
801044a4:	e9 77 fe ff ff       	jmp    80104320 <popcli>
    panic("release");
801044a9:	83 ec 0c             	sub    $0xc,%esp
801044ac:	68 c9 75 10 80       	push   $0x801075c9
801044b1:	e8 da be ff ff       	call   80100390 <panic>
801044b6:	66 90                	xchg   %ax,%ax
801044b8:	66 90                	xchg   %ax,%ax
801044ba:	66 90                	xchg   %ax,%ax
801044bc:	66 90                	xchg   %ax,%ax
801044be:	66 90                	xchg   %ax,%ax

801044c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	57                   	push   %edi
801044c4:	53                   	push   %ebx
801044c5:	8b 55 08             	mov    0x8(%ebp),%edx
801044c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801044cb:	f6 c2 03             	test   $0x3,%dl
801044ce:	75 05                	jne    801044d5 <memset+0x15>
801044d0:	f6 c1 03             	test   $0x3,%cl
801044d3:	74 13                	je     801044e8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801044d5:	89 d7                	mov    %edx,%edi
801044d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044da:	fc                   	cld    
801044db:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044dd:	5b                   	pop    %ebx
801044de:	89 d0                	mov    %edx,%eax
801044e0:	5f                   	pop    %edi
801044e1:	5d                   	pop    %ebp
801044e2:	c3                   	ret    
801044e3:	90                   	nop
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801044e8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801044ec:	c1 e9 02             	shr    $0x2,%ecx
801044ef:	89 f8                	mov    %edi,%eax
801044f1:	89 fb                	mov    %edi,%ebx
801044f3:	c1 e0 18             	shl    $0x18,%eax
801044f6:	c1 e3 10             	shl    $0x10,%ebx
801044f9:	09 d8                	or     %ebx,%eax
801044fb:	09 f8                	or     %edi,%eax
801044fd:	c1 e7 08             	shl    $0x8,%edi
80104500:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104502:	89 d7                	mov    %edx,%edi
80104504:	fc                   	cld    
80104505:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104507:	5b                   	pop    %ebx
80104508:	89 d0                	mov    %edx,%eax
8010450a:	5f                   	pop    %edi
8010450b:	5d                   	pop    %ebp
8010450c:	c3                   	ret    
8010450d:	8d 76 00             	lea    0x0(%esi),%esi

80104510 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	57                   	push   %edi
80104514:	56                   	push   %esi
80104515:	53                   	push   %ebx
80104516:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104519:	8b 75 08             	mov    0x8(%ebp),%esi
8010451c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010451f:	85 db                	test   %ebx,%ebx
80104521:	74 29                	je     8010454c <memcmp+0x3c>
    if(*s1 != *s2)
80104523:	0f b6 16             	movzbl (%esi),%edx
80104526:	0f b6 0f             	movzbl (%edi),%ecx
80104529:	38 d1                	cmp    %dl,%cl
8010452b:	75 2b                	jne    80104558 <memcmp+0x48>
8010452d:	b8 01 00 00 00       	mov    $0x1,%eax
80104532:	eb 14                	jmp    80104548 <memcmp+0x38>
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104538:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010453c:	83 c0 01             	add    $0x1,%eax
8010453f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104544:	38 ca                	cmp    %cl,%dl
80104546:	75 10                	jne    80104558 <memcmp+0x48>
  while(n-- > 0){
80104548:	39 d8                	cmp    %ebx,%eax
8010454a:	75 ec                	jne    80104538 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010454c:	5b                   	pop    %ebx
  return 0;
8010454d:	31 c0                	xor    %eax,%eax
}
8010454f:	5e                   	pop    %esi
80104550:	5f                   	pop    %edi
80104551:	5d                   	pop    %ebp
80104552:	c3                   	ret    
80104553:	90                   	nop
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104558:	0f b6 c2             	movzbl %dl,%eax
}
8010455b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010455c:	29 c8                	sub    %ecx,%eax
}
8010455e:	5e                   	pop    %esi
8010455f:	5f                   	pop    %edi
80104560:	5d                   	pop    %ebp
80104561:	c3                   	ret    
80104562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 45 08             	mov    0x8(%ebp),%eax
80104578:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010457b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010457e:	39 c3                	cmp    %eax,%ebx
80104580:	73 26                	jae    801045a8 <memmove+0x38>
80104582:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104585:	39 c8                	cmp    %ecx,%eax
80104587:	73 1f                	jae    801045a8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104589:	85 f6                	test   %esi,%esi
8010458b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010458e:	74 0f                	je     8010459f <memmove+0x2f>
      *--d = *--s;
80104590:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104594:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104597:	83 ea 01             	sub    $0x1,%edx
8010459a:	83 fa ff             	cmp    $0xffffffff,%edx
8010459d:	75 f1                	jne    80104590 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010459f:	5b                   	pop    %ebx
801045a0:	5e                   	pop    %esi
801045a1:	5d                   	pop    %ebp
801045a2:	c3                   	ret    
801045a3:	90                   	nop
801045a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801045a8:	31 d2                	xor    %edx,%edx
801045aa:	85 f6                	test   %esi,%esi
801045ac:	74 f1                	je     8010459f <memmove+0x2f>
801045ae:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801045b0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801045b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801045b7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801045ba:	39 d6                	cmp    %edx,%esi
801045bc:	75 f2                	jne    801045b0 <memmove+0x40>
}
801045be:	5b                   	pop    %ebx
801045bf:	5e                   	pop    %esi
801045c0:	5d                   	pop    %ebp
801045c1:	c3                   	ret    
801045c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801045d3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801045d4:	eb 9a                	jmp    80104570 <memmove>
801045d6:	8d 76 00             	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	56                   	push   %esi
801045e5:	8b 7d 10             	mov    0x10(%ebp),%edi
801045e8:	53                   	push   %ebx
801045e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801045ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801045ef:	85 ff                	test   %edi,%edi
801045f1:	74 2f                	je     80104622 <strncmp+0x42>
801045f3:	0f b6 01             	movzbl (%ecx),%eax
801045f6:	0f b6 1e             	movzbl (%esi),%ebx
801045f9:	84 c0                	test   %al,%al
801045fb:	74 37                	je     80104634 <strncmp+0x54>
801045fd:	38 c3                	cmp    %al,%bl
801045ff:	75 33                	jne    80104634 <strncmp+0x54>
80104601:	01 f7                	add    %esi,%edi
80104603:	eb 13                	jmp    80104618 <strncmp+0x38>
80104605:	8d 76 00             	lea    0x0(%esi),%esi
80104608:	0f b6 01             	movzbl (%ecx),%eax
8010460b:	84 c0                	test   %al,%al
8010460d:	74 21                	je     80104630 <strncmp+0x50>
8010460f:	0f b6 1a             	movzbl (%edx),%ebx
80104612:	89 d6                	mov    %edx,%esi
80104614:	38 d8                	cmp    %bl,%al
80104616:	75 1c                	jne    80104634 <strncmp+0x54>
    n--, p++, q++;
80104618:	8d 56 01             	lea    0x1(%esi),%edx
8010461b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010461e:	39 fa                	cmp    %edi,%edx
80104620:	75 e6                	jne    80104608 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104622:	5b                   	pop    %ebx
    return 0;
80104623:	31 c0                	xor    %eax,%eax
}
80104625:	5e                   	pop    %esi
80104626:	5f                   	pop    %edi
80104627:	5d                   	pop    %ebp
80104628:	c3                   	ret    
80104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104630:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104634:	29 d8                	sub    %ebx,%eax
}
80104636:	5b                   	pop    %ebx
80104637:	5e                   	pop    %esi
80104638:	5f                   	pop    %edi
80104639:	5d                   	pop    %ebp
8010463a:	c3                   	ret    
8010463b:	90                   	nop
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104640 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 45 08             	mov    0x8(%ebp),%eax
80104648:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010464b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010464e:	89 c2                	mov    %eax,%edx
80104650:	eb 19                	jmp    8010466b <strncpy+0x2b>
80104652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104658:	83 c3 01             	add    $0x1,%ebx
8010465b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010465f:	83 c2 01             	add    $0x1,%edx
80104662:	84 c9                	test   %cl,%cl
80104664:	88 4a ff             	mov    %cl,-0x1(%edx)
80104667:	74 09                	je     80104672 <strncpy+0x32>
80104669:	89 f1                	mov    %esi,%ecx
8010466b:	85 c9                	test   %ecx,%ecx
8010466d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104670:	7f e6                	jg     80104658 <strncpy+0x18>
    ;
  while(n-- > 0)
80104672:	31 c9                	xor    %ecx,%ecx
80104674:	85 f6                	test   %esi,%esi
80104676:	7e 17                	jle    8010468f <strncpy+0x4f>
80104678:	90                   	nop
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104680:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104684:	89 f3                	mov    %esi,%ebx
80104686:	83 c1 01             	add    $0x1,%ecx
80104689:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010468b:	85 db                	test   %ebx,%ebx
8010468d:	7f f1                	jg     80104680 <strncpy+0x40>
  return os;
}
8010468f:	5b                   	pop    %ebx
80104690:	5e                   	pop    %esi
80104691:	5d                   	pop    %ebp
80104692:	c3                   	ret    
80104693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046a8:	8b 45 08             	mov    0x8(%ebp),%eax
801046ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801046ae:	85 c9                	test   %ecx,%ecx
801046b0:	7e 26                	jle    801046d8 <safestrcpy+0x38>
801046b2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801046b6:	89 c1                	mov    %eax,%ecx
801046b8:	eb 17                	jmp    801046d1 <safestrcpy+0x31>
801046ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801046c0:	83 c2 01             	add    $0x1,%edx
801046c3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801046c7:	83 c1 01             	add    $0x1,%ecx
801046ca:	84 db                	test   %bl,%bl
801046cc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801046cf:	74 04                	je     801046d5 <safestrcpy+0x35>
801046d1:	39 f2                	cmp    %esi,%edx
801046d3:	75 eb                	jne    801046c0 <safestrcpy+0x20>
    ;
  *s = 0;
801046d5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801046d8:	5b                   	pop    %ebx
801046d9:	5e                   	pop    %esi
801046da:	5d                   	pop    %ebp
801046db:	c3                   	ret    
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046e0 <strlen>:

int
strlen(const char *s)
{
801046e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801046e1:	31 c0                	xor    %eax,%eax
{
801046e3:	89 e5                	mov    %esp,%ebp
801046e5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801046e8:	80 3a 00             	cmpb   $0x0,(%edx)
801046eb:	74 0c                	je     801046f9 <strlen+0x19>
801046ed:	8d 76 00             	lea    0x0(%esi),%esi
801046f0:	83 c0 01             	add    $0x1,%eax
801046f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801046f7:	75 f7                	jne    801046f0 <strlen+0x10>
    ;
  return n;
}
801046f9:	5d                   	pop    %ebp
801046fa:	c3                   	ret    

801046fb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801046fb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801046ff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104703:	55                   	push   %ebp
  pushl %ebx
80104704:	53                   	push   %ebx
  pushl %esi
80104705:	56                   	push   %esi
  pushl %edi
80104706:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104707:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104709:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010470b:	5f                   	pop    %edi
  popl %esi
8010470c:	5e                   	pop    %esi
  popl %ebx
8010470d:	5b                   	pop    %ebx
  popl %ebp
8010470e:	5d                   	pop    %ebp
  ret
8010470f:	c3                   	ret    

80104710 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 04             	sub    $0x4,%esp
80104717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010471a:	e8 31 f1 ff ff       	call   80103850 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010471f:	8b 00                	mov    (%eax),%eax
80104721:	39 d8                	cmp    %ebx,%eax
80104723:	76 1b                	jbe    80104740 <fetchint+0x30>
80104725:	8d 53 04             	lea    0x4(%ebx),%edx
80104728:	39 d0                	cmp    %edx,%eax
8010472a:	72 14                	jb     80104740 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010472c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010472f:	8b 13                	mov    (%ebx),%edx
80104731:	89 10                	mov    %edx,(%eax)
  return 0;
80104733:	31 c0                	xor    %eax,%eax
}
80104735:	83 c4 04             	add    $0x4,%esp
80104738:	5b                   	pop    %ebx
80104739:	5d                   	pop    %ebp
8010473a:	c3                   	ret    
8010473b:	90                   	nop
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104745:	eb ee                	jmp    80104735 <fetchint+0x25>
80104747:	89 f6                	mov    %esi,%esi
80104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104750 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 04             	sub    $0x4,%esp
80104757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010475a:	e8 f1 f0 ff ff       	call   80103850 <myproc>

  if(addr >= curproc->sz)
8010475f:	39 18                	cmp    %ebx,(%eax)
80104761:	76 29                	jbe    8010478c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104763:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104766:	89 da                	mov    %ebx,%edx
80104768:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010476a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010476c:	39 c3                	cmp    %eax,%ebx
8010476e:	73 1c                	jae    8010478c <fetchstr+0x3c>
    if(*s == 0)
80104770:	80 3b 00             	cmpb   $0x0,(%ebx)
80104773:	75 10                	jne    80104785 <fetchstr+0x35>
80104775:	eb 39                	jmp    801047b0 <fetchstr+0x60>
80104777:	89 f6                	mov    %esi,%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104780:	80 3a 00             	cmpb   $0x0,(%edx)
80104783:	74 1b                	je     801047a0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104785:	83 c2 01             	add    $0x1,%edx
80104788:	39 d0                	cmp    %edx,%eax
8010478a:	77 f4                	ja     80104780 <fetchstr+0x30>
    return -1;
8010478c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104791:	83 c4 04             	add    $0x4,%esp
80104794:	5b                   	pop    %ebx
80104795:	5d                   	pop    %ebp
80104796:	c3                   	ret    
80104797:	89 f6                	mov    %esi,%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801047a0:	83 c4 04             	add    $0x4,%esp
801047a3:	89 d0                	mov    %edx,%eax
801047a5:	29 d8                	sub    %ebx,%eax
801047a7:	5b                   	pop    %ebx
801047a8:	5d                   	pop    %ebp
801047a9:	c3                   	ret    
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801047b0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801047b2:	eb dd                	jmp    80104791 <fetchstr+0x41>
801047b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801047c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047c5:	e8 86 f0 ff ff       	call   80103850 <myproc>
801047ca:	8b 40 18             	mov    0x18(%eax),%eax
801047cd:	8b 55 08             	mov    0x8(%ebp),%edx
801047d0:	8b 40 44             	mov    0x44(%eax),%eax
801047d3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801047d6:	e8 75 f0 ff ff       	call   80103850 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047db:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047dd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047e0:	39 c6                	cmp    %eax,%esi
801047e2:	73 1c                	jae    80104800 <argint+0x40>
801047e4:	8d 53 08             	lea    0x8(%ebx),%edx
801047e7:	39 d0                	cmp    %edx,%eax
801047e9:	72 15                	jb     80104800 <argint+0x40>
  *ip = *(int*)(addr);
801047eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801047ee:	8b 53 04             	mov    0x4(%ebx),%edx
801047f1:	89 10                	mov    %edx,(%eax)
  return 0;
801047f3:	31 c0                	xor    %eax,%eax
}
801047f5:	5b                   	pop    %ebx
801047f6:	5e                   	pop    %esi
801047f7:	5d                   	pop    %ebp
801047f8:	c3                   	ret    
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104805:	eb ee                	jmp    801047f5 <argint+0x35>
80104807:	89 f6                	mov    %esi,%esi
80104809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104810 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
80104815:	83 ec 10             	sub    $0x10,%esp
80104818:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010481b:	e8 30 f0 ff ff       	call   80103850 <myproc>
80104820:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104822:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104825:	83 ec 08             	sub    $0x8,%esp
80104828:	50                   	push   %eax
80104829:	ff 75 08             	pushl  0x8(%ebp)
8010482c:	e8 8f ff ff ff       	call   801047c0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104831:	83 c4 10             	add    $0x10,%esp
80104834:	85 c0                	test   %eax,%eax
80104836:	78 28                	js     80104860 <argptr+0x50>
80104838:	85 db                	test   %ebx,%ebx
8010483a:	78 24                	js     80104860 <argptr+0x50>
8010483c:	8b 16                	mov    (%esi),%edx
8010483e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104841:	39 c2                	cmp    %eax,%edx
80104843:	76 1b                	jbe    80104860 <argptr+0x50>
80104845:	01 c3                	add    %eax,%ebx
80104847:	39 da                	cmp    %ebx,%edx
80104849:	72 15                	jb     80104860 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010484b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010484e:	89 02                	mov    %eax,(%edx)
  return 0;
80104850:	31 c0                	xor    %eax,%eax
}
80104852:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104855:	5b                   	pop    %ebx
80104856:	5e                   	pop    %esi
80104857:	5d                   	pop    %ebp
80104858:	c3                   	ret    
80104859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104865:	eb eb                	jmp    80104852 <argptr+0x42>
80104867:	89 f6                	mov    %esi,%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104876:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104879:	50                   	push   %eax
8010487a:	ff 75 08             	pushl  0x8(%ebp)
8010487d:	e8 3e ff ff ff       	call   801047c0 <argint>
80104882:	83 c4 10             	add    $0x10,%esp
80104885:	85 c0                	test   %eax,%eax
80104887:	78 17                	js     801048a0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104889:	83 ec 08             	sub    $0x8,%esp
8010488c:	ff 75 0c             	pushl  0xc(%ebp)
8010488f:	ff 75 f4             	pushl  -0xc(%ebp)
80104892:	e8 b9 fe ff ff       	call   80104750 <fetchstr>
80104897:	83 c4 10             	add    $0x10,%esp
}
8010489a:	c9                   	leave  
8010489b:	c3                   	ret    
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048a5:	c9                   	leave  
801048a6:	c3                   	ret    
801048a7:	89 f6                	mov    %esi,%esi
801048a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048b0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801048b7:	e8 94 ef ff ff       	call   80103850 <myproc>
801048bc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801048be:	8b 40 18             	mov    0x18(%eax),%eax
801048c1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801048c4:	8d 50 ff             	lea    -0x1(%eax),%edx
801048c7:	83 fa 14             	cmp    $0x14,%edx
801048ca:	77 1c                	ja     801048e8 <syscall+0x38>
801048cc:	8b 14 85 00 76 10 80 	mov    -0x7fef8a00(,%eax,4),%edx
801048d3:	85 d2                	test   %edx,%edx
801048d5:	74 11                	je     801048e8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801048d7:	ff d2                	call   *%edx
801048d9:	8b 53 18             	mov    0x18(%ebx),%edx
801048dc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801048df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e2:	c9                   	leave  
801048e3:	c3                   	ret    
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801048e8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801048e9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801048ec:	50                   	push   %eax
801048ed:	ff 73 10             	pushl  0x10(%ebx)
801048f0:	68 d1 75 10 80       	push   $0x801075d1
801048f5:	e8 66 bd ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801048fa:	8b 43 18             	mov    0x18(%ebx),%eax
801048fd:	83 c4 10             	add    $0x10,%esp
80104900:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104907:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010490a:	c9                   	leave  
8010490b:	c3                   	ret    
8010490c:	66 90                	xchg   %ax,%ax
8010490e:	66 90                	xchg   %ax,%ax

80104910 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	56                   	push   %esi
80104915:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104916:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104919:	83 ec 44             	sub    $0x44,%esp
8010491c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010491f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104922:	56                   	push   %esi
80104923:	50                   	push   %eax
{
80104924:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104927:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010492a:	e8 41 d6 ff ff       	call   80101f70 <nameiparent>
8010492f:	83 c4 10             	add    $0x10,%esp
80104932:	85 c0                	test   %eax,%eax
80104934:	0f 84 46 01 00 00    	je     80104a80 <create+0x170>
    return 0;
  ilock(dp);
8010493a:	83 ec 0c             	sub    $0xc,%esp
8010493d:	89 c3                	mov    %eax,%ebx
8010493f:	50                   	push   %eax
80104940:	e8 ab cd ff ff       	call   801016f0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104945:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104948:	83 c4 0c             	add    $0xc,%esp
8010494b:	50                   	push   %eax
8010494c:	56                   	push   %esi
8010494d:	53                   	push   %ebx
8010494e:	e8 cd d2 ff ff       	call   80101c20 <dirlookup>
80104953:	83 c4 10             	add    $0x10,%esp
80104956:	85 c0                	test   %eax,%eax
80104958:	89 c7                	mov    %eax,%edi
8010495a:	74 34                	je     80104990 <create+0x80>
    iunlockput(dp);
8010495c:	83 ec 0c             	sub    $0xc,%esp
8010495f:	53                   	push   %ebx
80104960:	e8 1b d0 ff ff       	call   80101980 <iunlockput>
    ilock(ip);
80104965:	89 3c 24             	mov    %edi,(%esp)
80104968:	e8 83 cd ff ff       	call   801016f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010496d:	83 c4 10             	add    $0x10,%esp
80104970:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104975:	0f 85 95 00 00 00    	jne    80104a10 <create+0x100>
8010497b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104980:	0f 85 8a 00 00 00    	jne    80104a10 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104986:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104989:	89 f8                	mov    %edi,%eax
8010498b:	5b                   	pop    %ebx
8010498c:	5e                   	pop    %esi
8010498d:	5f                   	pop    %edi
8010498e:	5d                   	pop    %ebp
8010498f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104990:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104994:	83 ec 08             	sub    $0x8,%esp
80104997:	50                   	push   %eax
80104998:	ff 33                	pushl  (%ebx)
8010499a:	e8 e1 cb ff ff       	call   80101580 <ialloc>
8010499f:	83 c4 10             	add    $0x10,%esp
801049a2:	85 c0                	test   %eax,%eax
801049a4:	89 c7                	mov    %eax,%edi
801049a6:	0f 84 e8 00 00 00    	je     80104a94 <create+0x184>
  ilock(ip);
801049ac:	83 ec 0c             	sub    $0xc,%esp
801049af:	50                   	push   %eax
801049b0:	e8 3b cd ff ff       	call   801016f0 <ilock>
  ip->major = major;
801049b5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801049b9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801049bd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801049c1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801049c5:	b8 01 00 00 00       	mov    $0x1,%eax
801049ca:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801049ce:	89 3c 24             	mov    %edi,(%esp)
801049d1:	e8 6a cc ff ff       	call   80101640 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801049d6:	83 c4 10             	add    $0x10,%esp
801049d9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801049de:	74 50                	je     80104a30 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801049e0:	83 ec 04             	sub    $0x4,%esp
801049e3:	ff 77 04             	pushl  0x4(%edi)
801049e6:	56                   	push   %esi
801049e7:	53                   	push   %ebx
801049e8:	e8 a3 d4 ff ff       	call   80101e90 <dirlink>
801049ed:	83 c4 10             	add    $0x10,%esp
801049f0:	85 c0                	test   %eax,%eax
801049f2:	0f 88 8f 00 00 00    	js     80104a87 <create+0x177>
  iunlockput(dp);
801049f8:	83 ec 0c             	sub    $0xc,%esp
801049fb:	53                   	push   %ebx
801049fc:	e8 7f cf ff ff       	call   80101980 <iunlockput>
  return ip;
80104a01:	83 c4 10             	add    $0x10,%esp
}
80104a04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a07:	89 f8                	mov    %edi,%eax
80104a09:	5b                   	pop    %ebx
80104a0a:	5e                   	pop    %esi
80104a0b:	5f                   	pop    %edi
80104a0c:	5d                   	pop    %ebp
80104a0d:	c3                   	ret    
80104a0e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104a10:	83 ec 0c             	sub    $0xc,%esp
80104a13:	57                   	push   %edi
    return 0;
80104a14:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104a16:	e8 65 cf ff ff       	call   80101980 <iunlockput>
    return 0;
80104a1b:	83 c4 10             	add    $0x10,%esp
}
80104a1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a21:	89 f8                	mov    %edi,%eax
80104a23:	5b                   	pop    %ebx
80104a24:	5e                   	pop    %esi
80104a25:	5f                   	pop    %edi
80104a26:	5d                   	pop    %ebp
80104a27:	c3                   	ret    
80104a28:	90                   	nop
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104a30:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104a35:	83 ec 0c             	sub    $0xc,%esp
80104a38:	53                   	push   %ebx
80104a39:	e8 02 cc ff ff       	call   80101640 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a3e:	83 c4 0c             	add    $0xc,%esp
80104a41:	ff 77 04             	pushl  0x4(%edi)
80104a44:	68 74 76 10 80       	push   $0x80107674
80104a49:	57                   	push   %edi
80104a4a:	e8 41 d4 ff ff       	call   80101e90 <dirlink>
80104a4f:	83 c4 10             	add    $0x10,%esp
80104a52:	85 c0                	test   %eax,%eax
80104a54:	78 1c                	js     80104a72 <create+0x162>
80104a56:	83 ec 04             	sub    $0x4,%esp
80104a59:	ff 73 04             	pushl  0x4(%ebx)
80104a5c:	68 73 76 10 80       	push   $0x80107673
80104a61:	57                   	push   %edi
80104a62:	e8 29 d4 ff ff       	call   80101e90 <dirlink>
80104a67:	83 c4 10             	add    $0x10,%esp
80104a6a:	85 c0                	test   %eax,%eax
80104a6c:	0f 89 6e ff ff ff    	jns    801049e0 <create+0xd0>
      panic("create dots");
80104a72:	83 ec 0c             	sub    $0xc,%esp
80104a75:	68 67 76 10 80       	push   $0x80107667
80104a7a:	e8 11 b9 ff ff       	call   80100390 <panic>
80104a7f:	90                   	nop
    return 0;
80104a80:	31 ff                	xor    %edi,%edi
80104a82:	e9 ff fe ff ff       	jmp    80104986 <create+0x76>
    panic("create: dirlink");
80104a87:	83 ec 0c             	sub    $0xc,%esp
80104a8a:	68 76 76 10 80       	push   $0x80107676
80104a8f:	e8 fc b8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104a94:	83 ec 0c             	sub    $0xc,%esp
80104a97:	68 58 76 10 80       	push   $0x80107658
80104a9c:	e8 ef b8 ff ff       	call   80100390 <panic>
80104aa1:	eb 0d                	jmp    80104ab0 <argfd.constprop.0>
80104aa3:	90                   	nop
80104aa4:	90                   	nop
80104aa5:	90                   	nop
80104aa6:	90                   	nop
80104aa7:	90                   	nop
80104aa8:	90                   	nop
80104aa9:	90                   	nop
80104aaa:	90                   	nop
80104aab:	90                   	nop
80104aac:	90                   	nop
80104aad:	90                   	nop
80104aae:	90                   	nop
80104aaf:	90                   	nop

80104ab0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	56                   	push   %esi
80104ab4:	53                   	push   %ebx
80104ab5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104ab7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104aba:	89 d6                	mov    %edx,%esi
80104abc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104abf:	50                   	push   %eax
80104ac0:	6a 00                	push   $0x0
80104ac2:	e8 f9 fc ff ff       	call   801047c0 <argint>
80104ac7:	83 c4 10             	add    $0x10,%esp
80104aca:	85 c0                	test   %eax,%eax
80104acc:	78 2a                	js     80104af8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ace:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ad2:	77 24                	ja     80104af8 <argfd.constprop.0+0x48>
80104ad4:	e8 77 ed ff ff       	call   80103850 <myproc>
80104ad9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104adc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104ae0:	85 c0                	test   %eax,%eax
80104ae2:	74 14                	je     80104af8 <argfd.constprop.0+0x48>
  if(pfd)
80104ae4:	85 db                	test   %ebx,%ebx
80104ae6:	74 02                	je     80104aea <argfd.constprop.0+0x3a>
    *pfd = fd;
80104ae8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104aea:	89 06                	mov    %eax,(%esi)
  return 0;
80104aec:	31 c0                	xor    %eax,%eax
}
80104aee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104af1:	5b                   	pop    %ebx
80104af2:	5e                   	pop    %esi
80104af3:	5d                   	pop    %ebp
80104af4:	c3                   	ret    
80104af5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104afd:	eb ef                	jmp    80104aee <argfd.constprop.0+0x3e>
80104aff:	90                   	nop

80104b00 <sys_dup>:
{
80104b00:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104b01:	31 c0                	xor    %eax,%eax
{
80104b03:	89 e5                	mov    %esp,%ebp
80104b05:	56                   	push   %esi
80104b06:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104b07:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104b0a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104b0d:	e8 9e ff ff ff       	call   80104ab0 <argfd.constprop.0>
80104b12:	85 c0                	test   %eax,%eax
80104b14:	78 42                	js     80104b58 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104b16:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104b19:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104b1b:	e8 30 ed ff ff       	call   80103850 <myproc>
80104b20:	eb 0e                	jmp    80104b30 <sys_dup+0x30>
80104b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104b28:	83 c3 01             	add    $0x1,%ebx
80104b2b:	83 fb 10             	cmp    $0x10,%ebx
80104b2e:	74 28                	je     80104b58 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104b30:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104b34:	85 d2                	test   %edx,%edx
80104b36:	75 f0                	jne    80104b28 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104b38:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104b3c:	83 ec 0c             	sub    $0xc,%esp
80104b3f:	ff 75 f4             	pushl  -0xc(%ebp)
80104b42:	e8 09 c3 ff ff       	call   80100e50 <filedup>
  return fd;
80104b47:	83 c4 10             	add    $0x10,%esp
}
80104b4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b4d:	89 d8                	mov    %ebx,%eax
80104b4f:	5b                   	pop    %ebx
80104b50:	5e                   	pop    %esi
80104b51:	5d                   	pop    %ebp
80104b52:	c3                   	ret    
80104b53:	90                   	nop
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b58:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104b5b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104b60:	89 d8                	mov    %ebx,%eax
80104b62:	5b                   	pop    %ebx
80104b63:	5e                   	pop    %esi
80104b64:	5d                   	pop    %ebp
80104b65:	c3                   	ret    
80104b66:	8d 76 00             	lea    0x0(%esi),%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b70 <sys_read>:
{
80104b70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b71:	31 c0                	xor    %eax,%eax
{
80104b73:	89 e5                	mov    %esp,%ebp
80104b75:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b78:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b7b:	e8 30 ff ff ff       	call   80104ab0 <argfd.constprop.0>
80104b80:	85 c0                	test   %eax,%eax
80104b82:	78 4c                	js     80104bd0 <sys_read+0x60>
80104b84:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b87:	83 ec 08             	sub    $0x8,%esp
80104b8a:	50                   	push   %eax
80104b8b:	6a 02                	push   $0x2
80104b8d:	e8 2e fc ff ff       	call   801047c0 <argint>
80104b92:	83 c4 10             	add    $0x10,%esp
80104b95:	85 c0                	test   %eax,%eax
80104b97:	78 37                	js     80104bd0 <sys_read+0x60>
80104b99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b9c:	83 ec 04             	sub    $0x4,%esp
80104b9f:	ff 75 f0             	pushl  -0x10(%ebp)
80104ba2:	50                   	push   %eax
80104ba3:	6a 01                	push   $0x1
80104ba5:	e8 66 fc ff ff       	call   80104810 <argptr>
80104baa:	83 c4 10             	add    $0x10,%esp
80104bad:	85 c0                	test   %eax,%eax
80104baf:	78 1f                	js     80104bd0 <sys_read+0x60>
  return fileread(f, p, n);
80104bb1:	83 ec 04             	sub    $0x4,%esp
80104bb4:	ff 75 f0             	pushl  -0x10(%ebp)
80104bb7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bba:	ff 75 ec             	pushl  -0x14(%ebp)
80104bbd:	e8 fe c3 ff ff       	call   80100fc0 <fileread>
80104bc2:	83 c4 10             	add    $0x10,%esp
}
80104bc5:	c9                   	leave  
80104bc6:	c3                   	ret    
80104bc7:	89 f6                	mov    %esi,%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bd5:	c9                   	leave  
80104bd6:	c3                   	ret    
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <sys_write>:
{
80104be0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be1:	31 c0                	xor    %eax,%eax
{
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104be8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104beb:	e8 c0 fe ff ff       	call   80104ab0 <argfd.constprop.0>
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	78 4c                	js     80104c40 <sys_write+0x60>
80104bf4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bf7:	83 ec 08             	sub    $0x8,%esp
80104bfa:	50                   	push   %eax
80104bfb:	6a 02                	push   $0x2
80104bfd:	e8 be fb ff ff       	call   801047c0 <argint>
80104c02:	83 c4 10             	add    $0x10,%esp
80104c05:	85 c0                	test   %eax,%eax
80104c07:	78 37                	js     80104c40 <sys_write+0x60>
80104c09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c0c:	83 ec 04             	sub    $0x4,%esp
80104c0f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c12:	50                   	push   %eax
80104c13:	6a 01                	push   $0x1
80104c15:	e8 f6 fb ff ff       	call   80104810 <argptr>
80104c1a:	83 c4 10             	add    $0x10,%esp
80104c1d:	85 c0                	test   %eax,%eax
80104c1f:	78 1f                	js     80104c40 <sys_write+0x60>
  return filewrite(f, p, n);
80104c21:	83 ec 04             	sub    $0x4,%esp
80104c24:	ff 75 f0             	pushl  -0x10(%ebp)
80104c27:	ff 75 f4             	pushl  -0xc(%ebp)
80104c2a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c2d:	e8 1e c4 ff ff       	call   80101050 <filewrite>
80104c32:	83 c4 10             	add    $0x10,%esp
}
80104c35:	c9                   	leave  
80104c36:	c3                   	ret    
80104c37:	89 f6                	mov    %esi,%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c45:	c9                   	leave  
80104c46:	c3                   	ret    
80104c47:	89 f6                	mov    %esi,%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c50 <sys_close>:
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104c56:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c5c:	e8 4f fe ff ff       	call   80104ab0 <argfd.constprop.0>
80104c61:	85 c0                	test   %eax,%eax
80104c63:	78 2b                	js     80104c90 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104c65:	e8 e6 eb ff ff       	call   80103850 <myproc>
80104c6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104c6d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104c70:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104c77:	00 
  fileclose(f);
80104c78:	ff 75 f4             	pushl  -0xc(%ebp)
80104c7b:	e8 20 c2 ff ff       	call   80100ea0 <fileclose>
  return 0;
80104c80:	83 c4 10             	add    $0x10,%esp
80104c83:	31 c0                	xor    %eax,%eax
}
80104c85:	c9                   	leave  
80104c86:	c3                   	ret    
80104c87:	89 f6                	mov    %esi,%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c95:	c9                   	leave  
80104c96:	c3                   	ret    
80104c97:	89 f6                	mov    %esi,%esi
80104c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ca0 <sys_fstat>:
{
80104ca0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ca1:	31 c0                	xor    %eax,%eax
{
80104ca3:	89 e5                	mov    %esp,%ebp
80104ca5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ca8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104cab:	e8 00 fe ff ff       	call   80104ab0 <argfd.constprop.0>
80104cb0:	85 c0                	test   %eax,%eax
80104cb2:	78 2c                	js     80104ce0 <sys_fstat+0x40>
80104cb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cb7:	83 ec 04             	sub    $0x4,%esp
80104cba:	6a 14                	push   $0x14
80104cbc:	50                   	push   %eax
80104cbd:	6a 01                	push   $0x1
80104cbf:	e8 4c fb ff ff       	call   80104810 <argptr>
80104cc4:	83 c4 10             	add    $0x10,%esp
80104cc7:	85 c0                	test   %eax,%eax
80104cc9:	78 15                	js     80104ce0 <sys_fstat+0x40>
  return filestat(f, st);
80104ccb:	83 ec 08             	sub    $0x8,%esp
80104cce:	ff 75 f4             	pushl  -0xc(%ebp)
80104cd1:	ff 75 f0             	pushl  -0x10(%ebp)
80104cd4:	e8 97 c2 ff ff       	call   80100f70 <filestat>
80104cd9:	83 c4 10             	add    $0x10,%esp
}
80104cdc:	c9                   	leave  
80104cdd:	c3                   	ret    
80104cde:	66 90                	xchg   %ax,%ax
    return -1;
80104ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ce5:	c9                   	leave  
80104ce6:	c3                   	ret    
80104ce7:	89 f6                	mov    %esi,%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <sys_link>:
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	56                   	push   %esi
80104cf5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cf6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104cf9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cfc:	50                   	push   %eax
80104cfd:	6a 00                	push   $0x0
80104cff:	e8 6c fb ff ff       	call   80104870 <argstr>
80104d04:	83 c4 10             	add    $0x10,%esp
80104d07:	85 c0                	test   %eax,%eax
80104d09:	0f 88 fb 00 00 00    	js     80104e0a <sys_link+0x11a>
80104d0f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d12:	83 ec 08             	sub    $0x8,%esp
80104d15:	50                   	push   %eax
80104d16:	6a 01                	push   $0x1
80104d18:	e8 53 fb ff ff       	call   80104870 <argstr>
80104d1d:	83 c4 10             	add    $0x10,%esp
80104d20:	85 c0                	test   %eax,%eax
80104d22:	0f 88 e2 00 00 00    	js     80104e0a <sys_link+0x11a>
  begin_op();
80104d28:	e8 e3 de ff ff       	call   80102c10 <begin_op>
  if((ip = namei(old)) == 0){
80104d2d:	83 ec 0c             	sub    $0xc,%esp
80104d30:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d33:	e8 18 d2 ff ff       	call   80101f50 <namei>
80104d38:	83 c4 10             	add    $0x10,%esp
80104d3b:	85 c0                	test   %eax,%eax
80104d3d:	89 c3                	mov    %eax,%ebx
80104d3f:	0f 84 ea 00 00 00    	je     80104e2f <sys_link+0x13f>
  ilock(ip);
80104d45:	83 ec 0c             	sub    $0xc,%esp
80104d48:	50                   	push   %eax
80104d49:	e8 a2 c9 ff ff       	call   801016f0 <ilock>
  if(ip->type == T_DIR){
80104d4e:	83 c4 10             	add    $0x10,%esp
80104d51:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d56:	0f 84 bb 00 00 00    	je     80104e17 <sys_link+0x127>
  ip->nlink++;
80104d5c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d61:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104d64:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104d67:	53                   	push   %ebx
80104d68:	e8 d3 c8 ff ff       	call   80101640 <iupdate>
  iunlock(ip);
80104d6d:	89 1c 24             	mov    %ebx,(%esp)
80104d70:	e8 5b ca ff ff       	call   801017d0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104d75:	58                   	pop    %eax
80104d76:	5a                   	pop    %edx
80104d77:	57                   	push   %edi
80104d78:	ff 75 d0             	pushl  -0x30(%ebp)
80104d7b:	e8 f0 d1 ff ff       	call   80101f70 <nameiparent>
80104d80:	83 c4 10             	add    $0x10,%esp
80104d83:	85 c0                	test   %eax,%eax
80104d85:	89 c6                	mov    %eax,%esi
80104d87:	74 5b                	je     80104de4 <sys_link+0xf4>
  ilock(dp);
80104d89:	83 ec 0c             	sub    $0xc,%esp
80104d8c:	50                   	push   %eax
80104d8d:	e8 5e c9 ff ff       	call   801016f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d92:	83 c4 10             	add    $0x10,%esp
80104d95:	8b 03                	mov    (%ebx),%eax
80104d97:	39 06                	cmp    %eax,(%esi)
80104d99:	75 3d                	jne    80104dd8 <sys_link+0xe8>
80104d9b:	83 ec 04             	sub    $0x4,%esp
80104d9e:	ff 73 04             	pushl  0x4(%ebx)
80104da1:	57                   	push   %edi
80104da2:	56                   	push   %esi
80104da3:	e8 e8 d0 ff ff       	call   80101e90 <dirlink>
80104da8:	83 c4 10             	add    $0x10,%esp
80104dab:	85 c0                	test   %eax,%eax
80104dad:	78 29                	js     80104dd8 <sys_link+0xe8>
  iunlockput(dp);
80104daf:	83 ec 0c             	sub    $0xc,%esp
80104db2:	56                   	push   %esi
80104db3:	e8 c8 cb ff ff       	call   80101980 <iunlockput>
  iput(ip);
80104db8:	89 1c 24             	mov    %ebx,(%esp)
80104dbb:	e8 60 ca ff ff       	call   80101820 <iput>
  end_op();
80104dc0:	e8 bb de ff ff       	call   80102c80 <end_op>
  return 0;
80104dc5:	83 c4 10             	add    $0x10,%esp
80104dc8:	31 c0                	xor    %eax,%eax
}
80104dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dcd:	5b                   	pop    %ebx
80104dce:	5e                   	pop    %esi
80104dcf:	5f                   	pop    %edi
80104dd0:	5d                   	pop    %ebp
80104dd1:	c3                   	ret    
80104dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104dd8:	83 ec 0c             	sub    $0xc,%esp
80104ddb:	56                   	push   %esi
80104ddc:	e8 9f cb ff ff       	call   80101980 <iunlockput>
    goto bad;
80104de1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104de4:	83 ec 0c             	sub    $0xc,%esp
80104de7:	53                   	push   %ebx
80104de8:	e8 03 c9 ff ff       	call   801016f0 <ilock>
  ip->nlink--;
80104ded:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104df2:	89 1c 24             	mov    %ebx,(%esp)
80104df5:	e8 46 c8 ff ff       	call   80101640 <iupdate>
  iunlockput(ip);
80104dfa:	89 1c 24             	mov    %ebx,(%esp)
80104dfd:	e8 7e cb ff ff       	call   80101980 <iunlockput>
  end_op();
80104e02:	e8 79 de ff ff       	call   80102c80 <end_op>
  return -1;
80104e07:	83 c4 10             	add    $0x10,%esp
}
80104e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e12:	5b                   	pop    %ebx
80104e13:	5e                   	pop    %esi
80104e14:	5f                   	pop    %edi
80104e15:	5d                   	pop    %ebp
80104e16:	c3                   	ret    
    iunlockput(ip);
80104e17:	83 ec 0c             	sub    $0xc,%esp
80104e1a:	53                   	push   %ebx
80104e1b:	e8 60 cb ff ff       	call   80101980 <iunlockput>
    end_op();
80104e20:	e8 5b de ff ff       	call   80102c80 <end_op>
    return -1;
80104e25:	83 c4 10             	add    $0x10,%esp
80104e28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e2d:	eb 9b                	jmp    80104dca <sys_link+0xda>
    end_op();
80104e2f:	e8 4c de ff ff       	call   80102c80 <end_op>
    return -1;
80104e34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e39:	eb 8f                	jmp    80104dca <sys_link+0xda>
80104e3b:	90                   	nop
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e40 <sys_unlink>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	57                   	push   %edi
80104e44:	56                   	push   %esi
80104e45:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80104e46:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104e49:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80104e4c:	50                   	push   %eax
80104e4d:	6a 00                	push   $0x0
80104e4f:	e8 1c fa ff ff       	call   80104870 <argstr>
80104e54:	83 c4 10             	add    $0x10,%esp
80104e57:	85 c0                	test   %eax,%eax
80104e59:	0f 88 77 01 00 00    	js     80104fd6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80104e5f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80104e62:	e8 a9 dd ff ff       	call   80102c10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104e67:	83 ec 08             	sub    $0x8,%esp
80104e6a:	53                   	push   %ebx
80104e6b:	ff 75 c0             	pushl  -0x40(%ebp)
80104e6e:	e8 fd d0 ff ff       	call   80101f70 <nameiparent>
80104e73:	83 c4 10             	add    $0x10,%esp
80104e76:	85 c0                	test   %eax,%eax
80104e78:	89 c6                	mov    %eax,%esi
80104e7a:	0f 84 60 01 00 00    	je     80104fe0 <sys_unlink+0x1a0>
  ilock(dp);
80104e80:	83 ec 0c             	sub    $0xc,%esp
80104e83:	50                   	push   %eax
80104e84:	e8 67 c8 ff ff       	call   801016f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104e89:	58                   	pop    %eax
80104e8a:	5a                   	pop    %edx
80104e8b:	68 74 76 10 80       	push   $0x80107674
80104e90:	53                   	push   %ebx
80104e91:	e8 6a cd ff ff       	call   80101c00 <namecmp>
80104e96:	83 c4 10             	add    $0x10,%esp
80104e99:	85 c0                	test   %eax,%eax
80104e9b:	0f 84 03 01 00 00    	je     80104fa4 <sys_unlink+0x164>
80104ea1:	83 ec 08             	sub    $0x8,%esp
80104ea4:	68 73 76 10 80       	push   $0x80107673
80104ea9:	53                   	push   %ebx
80104eaa:	e8 51 cd ff ff       	call   80101c00 <namecmp>
80104eaf:	83 c4 10             	add    $0x10,%esp
80104eb2:	85 c0                	test   %eax,%eax
80104eb4:	0f 84 ea 00 00 00    	je     80104fa4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104eba:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ebd:	83 ec 04             	sub    $0x4,%esp
80104ec0:	50                   	push   %eax
80104ec1:	53                   	push   %ebx
80104ec2:	56                   	push   %esi
80104ec3:	e8 58 cd ff ff       	call   80101c20 <dirlookup>
80104ec8:	83 c4 10             	add    $0x10,%esp
80104ecb:	85 c0                	test   %eax,%eax
80104ecd:	89 c3                	mov    %eax,%ebx
80104ecf:	0f 84 cf 00 00 00    	je     80104fa4 <sys_unlink+0x164>
  ilock(ip);
80104ed5:	83 ec 0c             	sub    $0xc,%esp
80104ed8:	50                   	push   %eax
80104ed9:	e8 12 c8 ff ff       	call   801016f0 <ilock>
  if(ip->nlink < 1)
80104ede:	83 c4 10             	add    $0x10,%esp
80104ee1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104ee6:	0f 8e 10 01 00 00    	jle    80104ffc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104eec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ef1:	74 6d                	je     80104f60 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104ef3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104ef6:	83 ec 04             	sub    $0x4,%esp
80104ef9:	6a 10                	push   $0x10
80104efb:	6a 00                	push   $0x0
80104efd:	50                   	push   %eax
80104efe:	e8 bd f5 ff ff       	call   801044c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f03:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104f06:	6a 10                	push   $0x10
80104f08:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f0b:	50                   	push   %eax
80104f0c:	56                   	push   %esi
80104f0d:	e8 be cb ff ff       	call   80101ad0 <writei>
80104f12:	83 c4 20             	add    $0x20,%esp
80104f15:	83 f8 10             	cmp    $0x10,%eax
80104f18:	0f 85 eb 00 00 00    	jne    80105009 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104f1e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f23:	0f 84 97 00 00 00    	je     80104fc0 <sys_unlink+0x180>
  iunlockput(dp);
80104f29:	83 ec 0c             	sub    $0xc,%esp
80104f2c:	56                   	push   %esi
80104f2d:	e8 4e ca ff ff       	call   80101980 <iunlockput>
  ip->nlink--;
80104f32:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f37:	89 1c 24             	mov    %ebx,(%esp)
80104f3a:	e8 01 c7 ff ff       	call   80101640 <iupdate>
  iunlockput(ip);
80104f3f:	89 1c 24             	mov    %ebx,(%esp)
80104f42:	e8 39 ca ff ff       	call   80101980 <iunlockput>
  end_op();
80104f47:	e8 34 dd ff ff       	call   80102c80 <end_op>
  return 0;
80104f4c:	83 c4 10             	add    $0x10,%esp
80104f4f:	31 c0                	xor    %eax,%eax
}
80104f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f54:	5b                   	pop    %ebx
80104f55:	5e                   	pop    %esi
80104f56:	5f                   	pop    %edi
80104f57:	5d                   	pop    %ebp
80104f58:	c3                   	ret    
80104f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104f60:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104f64:	76 8d                	jbe    80104ef3 <sys_unlink+0xb3>
80104f66:	bf 20 00 00 00       	mov    $0x20,%edi
80104f6b:	eb 0f                	jmp    80104f7c <sys_unlink+0x13c>
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
80104f70:	83 c7 10             	add    $0x10,%edi
80104f73:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104f76:	0f 83 77 ff ff ff    	jae    80104ef3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f7c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104f7f:	6a 10                	push   $0x10
80104f81:	57                   	push   %edi
80104f82:	50                   	push   %eax
80104f83:	53                   	push   %ebx
80104f84:	e8 47 ca ff ff       	call   801019d0 <readi>
80104f89:	83 c4 10             	add    $0x10,%esp
80104f8c:	83 f8 10             	cmp    $0x10,%eax
80104f8f:	75 5e                	jne    80104fef <sys_unlink+0x1af>
    if(de.inum != 0)
80104f91:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104f96:	74 d8                	je     80104f70 <sys_unlink+0x130>
    iunlockput(ip);
80104f98:	83 ec 0c             	sub    $0xc,%esp
80104f9b:	53                   	push   %ebx
80104f9c:	e8 df c9 ff ff       	call   80101980 <iunlockput>
    goto bad;
80104fa1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104fa4:	83 ec 0c             	sub    $0xc,%esp
80104fa7:	56                   	push   %esi
80104fa8:	e8 d3 c9 ff ff       	call   80101980 <iunlockput>
  end_op();
80104fad:	e8 ce dc ff ff       	call   80102c80 <end_op>
  return -1;
80104fb2:	83 c4 10             	add    $0x10,%esp
80104fb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fba:	eb 95                	jmp    80104f51 <sys_unlink+0x111>
80104fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80104fc0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80104fc5:	83 ec 0c             	sub    $0xc,%esp
80104fc8:	56                   	push   %esi
80104fc9:	e8 72 c6 ff ff       	call   80101640 <iupdate>
80104fce:	83 c4 10             	add    $0x10,%esp
80104fd1:	e9 53 ff ff ff       	jmp    80104f29 <sys_unlink+0xe9>
    return -1;
80104fd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdb:	e9 71 ff ff ff       	jmp    80104f51 <sys_unlink+0x111>
    end_op();
80104fe0:	e8 9b dc ff ff       	call   80102c80 <end_op>
    return -1;
80104fe5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fea:	e9 62 ff ff ff       	jmp    80104f51 <sys_unlink+0x111>
      panic("isdirempty: readi");
80104fef:	83 ec 0c             	sub    $0xc,%esp
80104ff2:	68 98 76 10 80       	push   $0x80107698
80104ff7:	e8 94 b3 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80104ffc:	83 ec 0c             	sub    $0xc,%esp
80104fff:	68 86 76 10 80       	push   $0x80107686
80105004:	e8 87 b3 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105009:	83 ec 0c             	sub    $0xc,%esp
8010500c:	68 aa 76 10 80       	push   $0x801076aa
80105011:	e8 7a b3 ff ff       	call   80100390 <panic>
80105016:	8d 76 00             	lea    0x0(%esi),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <sys_open>:

int
sys_open(void)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	57                   	push   %edi
80105024:	56                   	push   %esi
80105025:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105026:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105029:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010502c:	50                   	push   %eax
8010502d:	6a 00                	push   $0x0
8010502f:	e8 3c f8 ff ff       	call   80104870 <argstr>
80105034:	83 c4 10             	add    $0x10,%esp
80105037:	85 c0                	test   %eax,%eax
80105039:	0f 88 1d 01 00 00    	js     8010515c <sys_open+0x13c>
8010503f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105042:	83 ec 08             	sub    $0x8,%esp
80105045:	50                   	push   %eax
80105046:	6a 01                	push   $0x1
80105048:	e8 73 f7 ff ff       	call   801047c0 <argint>
8010504d:	83 c4 10             	add    $0x10,%esp
80105050:	85 c0                	test   %eax,%eax
80105052:	0f 88 04 01 00 00    	js     8010515c <sys_open+0x13c>
    return -1;

  begin_op();
80105058:	e8 b3 db ff ff       	call   80102c10 <begin_op>

  if(omode & O_CREATE){
8010505d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105061:	0f 85 a9 00 00 00    	jne    80105110 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105067:	83 ec 0c             	sub    $0xc,%esp
8010506a:	ff 75 e0             	pushl  -0x20(%ebp)
8010506d:	e8 de ce ff ff       	call   80101f50 <namei>
80105072:	83 c4 10             	add    $0x10,%esp
80105075:	85 c0                	test   %eax,%eax
80105077:	89 c6                	mov    %eax,%esi
80105079:	0f 84 b2 00 00 00    	je     80105131 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010507f:	83 ec 0c             	sub    $0xc,%esp
80105082:	50                   	push   %eax
80105083:	e8 68 c6 ff ff       	call   801016f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105088:	83 c4 10             	add    $0x10,%esp
8010508b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105090:	0f 84 aa 00 00 00    	je     80105140 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105096:	e8 45 bd ff ff       	call   80100de0 <filealloc>
8010509b:	85 c0                	test   %eax,%eax
8010509d:	89 c7                	mov    %eax,%edi
8010509f:	0f 84 a6 00 00 00    	je     8010514b <sys_open+0x12b>
  struct proc *curproc = myproc();
801050a5:	e8 a6 e7 ff ff       	call   80103850 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801050aa:	31 db                	xor    %ebx,%ebx
801050ac:	eb 0e                	jmp    801050bc <sys_open+0x9c>
801050ae:	66 90                	xchg   %ax,%ax
801050b0:	83 c3 01             	add    $0x1,%ebx
801050b3:	83 fb 10             	cmp    $0x10,%ebx
801050b6:	0f 84 ac 00 00 00    	je     80105168 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801050bc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801050c0:	85 d2                	test   %edx,%edx
801050c2:	75 ec                	jne    801050b0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801050c4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801050c7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801050cb:	56                   	push   %esi
801050cc:	e8 ff c6 ff ff       	call   801017d0 <iunlock>
  end_op();
801050d1:	e8 aa db ff ff       	call   80102c80 <end_op>

  f->type = FD_INODE;
801050d6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801050dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050df:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801050e2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801050e5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801050ec:	89 d0                	mov    %edx,%eax
801050ee:	f7 d0                	not    %eax
801050f0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050f3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801050f6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050f9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801050fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105100:	89 d8                	mov    %ebx,%eax
80105102:	5b                   	pop    %ebx
80105103:	5e                   	pop    %esi
80105104:	5f                   	pop    %edi
80105105:	5d                   	pop    %ebp
80105106:	c3                   	ret    
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105110:	83 ec 0c             	sub    $0xc,%esp
80105113:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105116:	31 c9                	xor    %ecx,%ecx
80105118:	6a 00                	push   $0x0
8010511a:	ba 02 00 00 00       	mov    $0x2,%edx
8010511f:	e8 ec f7 ff ff       	call   80104910 <create>
    if(ip == 0){
80105124:	83 c4 10             	add    $0x10,%esp
80105127:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105129:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010512b:	0f 85 65 ff ff ff    	jne    80105096 <sys_open+0x76>
      end_op();
80105131:	e8 4a db ff ff       	call   80102c80 <end_op>
      return -1;
80105136:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010513b:	eb c0                	jmp    801050fd <sys_open+0xdd>
8010513d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105140:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105143:	85 c9                	test   %ecx,%ecx
80105145:	0f 84 4b ff ff ff    	je     80105096 <sys_open+0x76>
    iunlockput(ip);
8010514b:	83 ec 0c             	sub    $0xc,%esp
8010514e:	56                   	push   %esi
8010514f:	e8 2c c8 ff ff       	call   80101980 <iunlockput>
    end_op();
80105154:	e8 27 db ff ff       	call   80102c80 <end_op>
    return -1;
80105159:	83 c4 10             	add    $0x10,%esp
8010515c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105161:	eb 9a                	jmp    801050fd <sys_open+0xdd>
80105163:	90                   	nop
80105164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105168:	83 ec 0c             	sub    $0xc,%esp
8010516b:	57                   	push   %edi
8010516c:	e8 2f bd ff ff       	call   80100ea0 <fileclose>
80105171:	83 c4 10             	add    $0x10,%esp
80105174:	eb d5                	jmp    8010514b <sys_open+0x12b>
80105176:	8d 76 00             	lea    0x0(%esi),%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <sys_mkdir>:

int
sys_mkdir(void)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105186:	e8 85 da ff ff       	call   80102c10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010518b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010518e:	83 ec 08             	sub    $0x8,%esp
80105191:	50                   	push   %eax
80105192:	6a 00                	push   $0x0
80105194:	e8 d7 f6 ff ff       	call   80104870 <argstr>
80105199:	83 c4 10             	add    $0x10,%esp
8010519c:	85 c0                	test   %eax,%eax
8010519e:	78 30                	js     801051d0 <sys_mkdir+0x50>
801051a0:	83 ec 0c             	sub    $0xc,%esp
801051a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a6:	31 c9                	xor    %ecx,%ecx
801051a8:	6a 00                	push   $0x0
801051aa:	ba 01 00 00 00       	mov    $0x1,%edx
801051af:	e8 5c f7 ff ff       	call   80104910 <create>
801051b4:	83 c4 10             	add    $0x10,%esp
801051b7:	85 c0                	test   %eax,%eax
801051b9:	74 15                	je     801051d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801051bb:	83 ec 0c             	sub    $0xc,%esp
801051be:	50                   	push   %eax
801051bf:	e8 bc c7 ff ff       	call   80101980 <iunlockput>
  end_op();
801051c4:	e8 b7 da ff ff       	call   80102c80 <end_op>
  return 0;
801051c9:	83 c4 10             	add    $0x10,%esp
801051cc:	31 c0                	xor    %eax,%eax
}
801051ce:	c9                   	leave  
801051cf:	c3                   	ret    
    end_op();
801051d0:	e8 ab da ff ff       	call   80102c80 <end_op>
    return -1;
801051d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051da:	c9                   	leave  
801051db:	c3                   	ret    
801051dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051e0 <sys_mknod>:

int
sys_mknod(void)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801051e6:	e8 25 da ff ff       	call   80102c10 <begin_op>
  if((argstr(0, &path)) < 0 ||
801051eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051ee:	83 ec 08             	sub    $0x8,%esp
801051f1:	50                   	push   %eax
801051f2:	6a 00                	push   $0x0
801051f4:	e8 77 f6 ff ff       	call   80104870 <argstr>
801051f9:	83 c4 10             	add    $0x10,%esp
801051fc:	85 c0                	test   %eax,%eax
801051fe:	78 60                	js     80105260 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105200:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105203:	83 ec 08             	sub    $0x8,%esp
80105206:	50                   	push   %eax
80105207:	6a 01                	push   $0x1
80105209:	e8 b2 f5 ff ff       	call   801047c0 <argint>
  if((argstr(0, &path)) < 0 ||
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	85 c0                	test   %eax,%eax
80105213:	78 4b                	js     80105260 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105215:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105218:	83 ec 08             	sub    $0x8,%esp
8010521b:	50                   	push   %eax
8010521c:	6a 02                	push   $0x2
8010521e:	e8 9d f5 ff ff       	call   801047c0 <argint>
     argint(1, &major) < 0 ||
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	78 36                	js     80105260 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010522a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010522e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105231:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105235:	ba 03 00 00 00       	mov    $0x3,%edx
8010523a:	50                   	push   %eax
8010523b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010523e:	e8 cd f6 ff ff       	call   80104910 <create>
80105243:	83 c4 10             	add    $0x10,%esp
80105246:	85 c0                	test   %eax,%eax
80105248:	74 16                	je     80105260 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010524a:	83 ec 0c             	sub    $0xc,%esp
8010524d:	50                   	push   %eax
8010524e:	e8 2d c7 ff ff       	call   80101980 <iunlockput>
  end_op();
80105253:	e8 28 da ff ff       	call   80102c80 <end_op>
  return 0;
80105258:	83 c4 10             	add    $0x10,%esp
8010525b:	31 c0                	xor    %eax,%eax
}
8010525d:	c9                   	leave  
8010525e:	c3                   	ret    
8010525f:	90                   	nop
    end_op();
80105260:	e8 1b da ff ff       	call   80102c80 <end_op>
    return -1;
80105265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010526a:	c9                   	leave  
8010526b:	c3                   	ret    
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105270 <sys_chdir>:

int
sys_chdir(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	56                   	push   %esi
80105274:	53                   	push   %ebx
80105275:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105278:	e8 d3 e5 ff ff       	call   80103850 <myproc>
8010527d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010527f:	e8 8c d9 ff ff       	call   80102c10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105284:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105287:	83 ec 08             	sub    $0x8,%esp
8010528a:	50                   	push   %eax
8010528b:	6a 00                	push   $0x0
8010528d:	e8 de f5 ff ff       	call   80104870 <argstr>
80105292:	83 c4 10             	add    $0x10,%esp
80105295:	85 c0                	test   %eax,%eax
80105297:	78 77                	js     80105310 <sys_chdir+0xa0>
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	ff 75 f4             	pushl  -0xc(%ebp)
8010529f:	e8 ac cc ff ff       	call   80101f50 <namei>
801052a4:	83 c4 10             	add    $0x10,%esp
801052a7:	85 c0                	test   %eax,%eax
801052a9:	89 c3                	mov    %eax,%ebx
801052ab:	74 63                	je     80105310 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801052ad:	83 ec 0c             	sub    $0xc,%esp
801052b0:	50                   	push   %eax
801052b1:	e8 3a c4 ff ff       	call   801016f0 <ilock>
  if(ip->type != T_DIR){
801052b6:	83 c4 10             	add    $0x10,%esp
801052b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052be:	75 30                	jne    801052f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	53                   	push   %ebx
801052c4:	e8 07 c5 ff ff       	call   801017d0 <iunlock>
  iput(curproc->cwd);
801052c9:	58                   	pop    %eax
801052ca:	ff 76 68             	pushl  0x68(%esi)
801052cd:	e8 4e c5 ff ff       	call   80101820 <iput>
  end_op();
801052d2:	e8 a9 d9 ff ff       	call   80102c80 <end_op>
  curproc->cwd = ip;
801052d7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801052da:	83 c4 10             	add    $0x10,%esp
801052dd:	31 c0                	xor    %eax,%eax
}
801052df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052e2:	5b                   	pop    %ebx
801052e3:	5e                   	pop    %esi
801052e4:	5d                   	pop    %ebp
801052e5:	c3                   	ret    
801052e6:	8d 76 00             	lea    0x0(%esi),%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	53                   	push   %ebx
801052f4:	e8 87 c6 ff ff       	call   80101980 <iunlockput>
    end_op();
801052f9:	e8 82 d9 ff ff       	call   80102c80 <end_op>
    return -1;
801052fe:	83 c4 10             	add    $0x10,%esp
80105301:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105306:	eb d7                	jmp    801052df <sys_chdir+0x6f>
80105308:	90                   	nop
80105309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105310:	e8 6b d9 ff ff       	call   80102c80 <end_op>
    return -1;
80105315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531a:	eb c3                	jmp    801052df <sys_chdir+0x6f>
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105320 <sys_exec>:

int
sys_exec(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	57                   	push   %edi
80105324:	56                   	push   %esi
80105325:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105326:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010532c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105332:	50                   	push   %eax
80105333:	6a 00                	push   $0x0
80105335:	e8 36 f5 ff ff       	call   80104870 <argstr>
8010533a:	83 c4 10             	add    $0x10,%esp
8010533d:	85 c0                	test   %eax,%eax
8010533f:	0f 88 87 00 00 00    	js     801053cc <sys_exec+0xac>
80105345:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010534b:	83 ec 08             	sub    $0x8,%esp
8010534e:	50                   	push   %eax
8010534f:	6a 01                	push   $0x1
80105351:	e8 6a f4 ff ff       	call   801047c0 <argint>
80105356:	83 c4 10             	add    $0x10,%esp
80105359:	85 c0                	test   %eax,%eax
8010535b:	78 6f                	js     801053cc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010535d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105363:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105366:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105368:	68 80 00 00 00       	push   $0x80
8010536d:	6a 00                	push   $0x0
8010536f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105375:	50                   	push   %eax
80105376:	e8 45 f1 ff ff       	call   801044c0 <memset>
8010537b:	83 c4 10             	add    $0x10,%esp
8010537e:	eb 2c                	jmp    801053ac <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105380:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105386:	85 c0                	test   %eax,%eax
80105388:	74 56                	je     801053e0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010538a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105390:	83 ec 08             	sub    $0x8,%esp
80105393:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105396:	52                   	push   %edx
80105397:	50                   	push   %eax
80105398:	e8 b3 f3 ff ff       	call   80104750 <fetchstr>
8010539d:	83 c4 10             	add    $0x10,%esp
801053a0:	85 c0                	test   %eax,%eax
801053a2:	78 28                	js     801053cc <sys_exec+0xac>
  for(i=0;; i++){
801053a4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801053a7:	83 fb 20             	cmp    $0x20,%ebx
801053aa:	74 20                	je     801053cc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801053ac:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801053b2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801053b9:	83 ec 08             	sub    $0x8,%esp
801053bc:	57                   	push   %edi
801053bd:	01 f0                	add    %esi,%eax
801053bf:	50                   	push   %eax
801053c0:	e8 4b f3 ff ff       	call   80104710 <fetchint>
801053c5:	83 c4 10             	add    $0x10,%esp
801053c8:	85 c0                	test   %eax,%eax
801053ca:	79 b4                	jns    80105380 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801053cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801053cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053d4:	5b                   	pop    %ebx
801053d5:	5e                   	pop    %esi
801053d6:	5f                   	pop    %edi
801053d7:	5d                   	pop    %ebp
801053d8:	c3                   	ret    
801053d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801053e0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053e6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801053e9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801053f0:	00 00 00 00 
  return exec(path, argv);
801053f4:	50                   	push   %eax
801053f5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801053fb:	e8 70 b6 ff ff       	call   80100a70 <exec>
80105400:	83 c4 10             	add    $0x10,%esp
}
80105403:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105406:	5b                   	pop    %ebx
80105407:	5e                   	pop    %esi
80105408:	5f                   	pop    %edi
80105409:	5d                   	pop    %ebp
8010540a:	c3                   	ret    
8010540b:	90                   	nop
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105410 <sys_pipe>:

int
sys_pipe(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	57                   	push   %edi
80105414:	56                   	push   %esi
80105415:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105416:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105419:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010541c:	6a 08                	push   $0x8
8010541e:	50                   	push   %eax
8010541f:	6a 00                	push   $0x0
80105421:	e8 ea f3 ff ff       	call   80104810 <argptr>
80105426:	83 c4 10             	add    $0x10,%esp
80105429:	85 c0                	test   %eax,%eax
8010542b:	0f 88 ae 00 00 00    	js     801054df <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105431:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105434:	83 ec 08             	sub    $0x8,%esp
80105437:	50                   	push   %eax
80105438:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010543b:	50                   	push   %eax
8010543c:	e8 6f de ff ff       	call   801032b0 <pipealloc>
80105441:	83 c4 10             	add    $0x10,%esp
80105444:	85 c0                	test   %eax,%eax
80105446:	0f 88 93 00 00 00    	js     801054df <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010544c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010544f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105451:	e8 fa e3 ff ff       	call   80103850 <myproc>
80105456:	eb 10                	jmp    80105468 <sys_pipe+0x58>
80105458:	90                   	nop
80105459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105460:	83 c3 01             	add    $0x1,%ebx
80105463:	83 fb 10             	cmp    $0x10,%ebx
80105466:	74 60                	je     801054c8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105468:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010546c:	85 f6                	test   %esi,%esi
8010546e:	75 f0                	jne    80105460 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105470:	8d 73 08             	lea    0x8(%ebx),%esi
80105473:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105477:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010547a:	e8 d1 e3 ff ff       	call   80103850 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010547f:	31 d2                	xor    %edx,%edx
80105481:	eb 0d                	jmp    80105490 <sys_pipe+0x80>
80105483:	90                   	nop
80105484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105488:	83 c2 01             	add    $0x1,%edx
8010548b:	83 fa 10             	cmp    $0x10,%edx
8010548e:	74 28                	je     801054b8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105490:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105494:	85 c9                	test   %ecx,%ecx
80105496:	75 f0                	jne    80105488 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105498:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010549c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010549f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801054a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054a4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801054a7:	31 c0                	xor    %eax,%eax
}
801054a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054ac:	5b                   	pop    %ebx
801054ad:	5e                   	pop    %esi
801054ae:	5f                   	pop    %edi
801054af:	5d                   	pop    %ebp
801054b0:	c3                   	ret    
801054b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801054b8:	e8 93 e3 ff ff       	call   80103850 <myproc>
801054bd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801054c4:	00 
801054c5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801054c8:	83 ec 0c             	sub    $0xc,%esp
801054cb:	ff 75 e0             	pushl  -0x20(%ebp)
801054ce:	e8 cd b9 ff ff       	call   80100ea0 <fileclose>
    fileclose(wf);
801054d3:	58                   	pop    %eax
801054d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801054d7:	e8 c4 b9 ff ff       	call   80100ea0 <fileclose>
    return -1;
801054dc:	83 c4 10             	add    $0x10,%esp
801054df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e4:	eb c3                	jmp    801054a9 <sys_pipe+0x99>
801054e6:	66 90                	xchg   %ax,%ax
801054e8:	66 90                	xchg   %ax,%ax
801054ea:	66 90                	xchg   %ax,%ax
801054ec:	66 90                	xchg   %ax,%ax
801054ee:	66 90                	xchg   %ax,%ax

801054f0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801054f3:	5d                   	pop    %ebp
  return fork();
801054f4:	e9 f7 e4 ff ff       	jmp    801039f0 <fork>
801054f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_exit>:

int
sys_exit(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	83 ec 08             	sub    $0x8,%esp
  exit();
80105506:	e8 65 e7 ff ff       	call   80103c70 <exit>
  return 0;  // not reached
}
8010550b:	31 c0                	xor    %eax,%eax
8010550d:	c9                   	leave  
8010550e:	c3                   	ret    
8010550f:	90                   	nop

80105510 <sys_wait>:

int
sys_wait(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105513:	5d                   	pop    %ebp
  return wait();
80105514:	e9 97 e9 ff ff       	jmp    80103eb0 <wait>
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_kill>:

int
sys_kill(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105526:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105529:	50                   	push   %eax
8010552a:	6a 00                	push   $0x0
8010552c:	e8 8f f2 ff ff       	call   801047c0 <argint>
80105531:	83 c4 10             	add    $0x10,%esp
80105534:	85 c0                	test   %eax,%eax
80105536:	78 18                	js     80105550 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105538:	83 ec 0c             	sub    $0xc,%esp
8010553b:	ff 75 f4             	pushl  -0xc(%ebp)
8010553e:	e8 bd ea ff ff       	call   80104000 <kill>
80105543:	83 c4 10             	add    $0x10,%esp
}
80105546:	c9                   	leave  
80105547:	c3                   	ret    
80105548:	90                   	nop
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105555:	c9                   	leave  
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105560 <sys_getpid>:

int
sys_getpid(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105566:	e8 e5 e2 ff ff       	call   80103850 <myproc>
8010556b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010556e:	c9                   	leave  
8010556f:	c3                   	ret    

80105570 <sys_sbrk>:

int
sys_sbrk(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105574:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105577:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010557a:	50                   	push   %eax
8010557b:	6a 00                	push   $0x0
8010557d:	e8 3e f2 ff ff       	call   801047c0 <argint>
80105582:	83 c4 10             	add    $0x10,%esp
80105585:	85 c0                	test   %eax,%eax
80105587:	78 27                	js     801055b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105589:	e8 c2 e2 ff ff       	call   80103850 <myproc>
  if(growproc(n) < 0)
8010558e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105591:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105593:	ff 75 f4             	pushl  -0xc(%ebp)
80105596:	e8 d5 e3 ff ff       	call   80103970 <growproc>
8010559b:	83 c4 10             	add    $0x10,%esp
8010559e:	85 c0                	test   %eax,%eax
801055a0:	78 0e                	js     801055b0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801055a2:	89 d8                	mov    %ebx,%eax
801055a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055a7:	c9                   	leave  
801055a8:	c3                   	ret    
801055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055b5:	eb eb                	jmp    801055a2 <sys_sbrk+0x32>
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <sys_sleep>:

int
sys_sleep(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801055c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801055c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801055ca:	50                   	push   %eax
801055cb:	6a 00                	push   $0x0
801055cd:	e8 ee f1 ff ff       	call   801047c0 <argint>
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	85 c0                	test   %eax,%eax
801055d7:	0f 88 8a 00 00 00    	js     80105667 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801055dd:	83 ec 0c             	sub    $0xc,%esp
801055e0:	68 60 4c 11 80       	push   $0x80114c60
801055e5:	e8 c6 ed ff ff       	call   801043b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801055ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055ed:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801055f0:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
801055f6:	85 d2                	test   %edx,%edx
801055f8:	75 27                	jne    80105621 <sys_sleep+0x61>
801055fa:	eb 54                	jmp    80105650 <sys_sleep+0x90>
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105600:	83 ec 08             	sub    $0x8,%esp
80105603:	68 60 4c 11 80       	push   $0x80114c60
80105608:	68 a0 54 11 80       	push   $0x801154a0
8010560d:	e8 de e7 ff ff       	call   80103df0 <sleep>
  while(ticks - ticks0 < n){
80105612:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105617:	83 c4 10             	add    $0x10,%esp
8010561a:	29 d8                	sub    %ebx,%eax
8010561c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010561f:	73 2f                	jae    80105650 <sys_sleep+0x90>
    if(myproc()->killed){
80105621:	e8 2a e2 ff ff       	call   80103850 <myproc>
80105626:	8b 40 24             	mov    0x24(%eax),%eax
80105629:	85 c0                	test   %eax,%eax
8010562b:	74 d3                	je     80105600 <sys_sleep+0x40>
      release(&tickslock);
8010562d:	83 ec 0c             	sub    $0xc,%esp
80105630:	68 60 4c 11 80       	push   $0x80114c60
80105635:	e8 36 ee ff ff       	call   80104470 <release>
      return -1;
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105645:	c9                   	leave  
80105646:	c3                   	ret    
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	68 60 4c 11 80       	push   $0x80114c60
80105658:	e8 13 ee ff ff       	call   80104470 <release>
  return 0;
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	31 c0                	xor    %eax,%eax
}
80105662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105665:	c9                   	leave  
80105666:	c3                   	ret    
    return -1;
80105667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566c:	eb f4                	jmp    80105662 <sys_sleep+0xa2>
8010566e:	66 90                	xchg   %ax,%ax

80105670 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	53                   	push   %ebx
80105674:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105677:	68 60 4c 11 80       	push   $0x80114c60
8010567c:	e8 2f ed ff ff       	call   801043b0 <acquire>
  xticks = ticks;
80105681:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105687:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010568e:	e8 dd ed ff ff       	call   80104470 <release>
  return xticks;
}
80105693:	89 d8                	mov    %ebx,%eax
80105695:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105698:	c9                   	leave  
80105699:	c3                   	ret    

8010569a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010569a:	1e                   	push   %ds
  pushl %es
8010569b:	06                   	push   %es
  pushl %fs
8010569c:	0f a0                	push   %fs
  pushl %gs
8010569e:	0f a8                	push   %gs
  pushal
801056a0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801056a1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801056a5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801056a7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801056a9:	54                   	push   %esp
  call trap
801056aa:	e8 c1 00 00 00       	call   80105770 <trap>
  addl $4, %esp
801056af:	83 c4 04             	add    $0x4,%esp

801056b2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801056b2:	61                   	popa   
  popl %gs
801056b3:	0f a9                	pop    %gs
  popl %fs
801056b5:	0f a1                	pop    %fs
  popl %es
801056b7:	07                   	pop    %es
  popl %ds
801056b8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801056b9:	83 c4 08             	add    $0x8,%esp
  iret
801056bc:	cf                   	iret   
801056bd:	66 90                	xchg   %ax,%ax
801056bf:	90                   	nop

801056c0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801056c0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801056c1:	31 c0                	xor    %eax,%eax
{
801056c3:	89 e5                	mov    %esp,%ebp
801056c5:	83 ec 08             	sub    $0x8,%esp
801056c8:	90                   	nop
801056c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801056d0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801056d7:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
801056de:	08 00 00 8e 
801056e2:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
801056e9:	80 
801056ea:	c1 ea 10             	shr    $0x10,%edx
801056ed:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
801056f4:	80 
  for(i = 0; i < 256; i++)
801056f5:	83 c0 01             	add    $0x1,%eax
801056f8:	3d 00 01 00 00       	cmp    $0x100,%eax
801056fd:	75 d1                	jne    801056d0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801056ff:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105704:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105707:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
8010570e:	00 00 ef 
  initlock(&tickslock, "time");
80105711:	68 b9 76 10 80       	push   $0x801076b9
80105716:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010571b:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
80105721:	c1 e8 10             	shr    $0x10,%eax
80105724:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
8010572a:	e8 41 eb ff ff       	call   80104270 <initlock>
}
8010572f:	83 c4 10             	add    $0x10,%esp
80105732:	c9                   	leave  
80105733:	c3                   	ret    
80105734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010573a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105740 <idtinit>:

void
idtinit(void)
{
80105740:	55                   	push   %ebp
  pd[0] = size-1;
80105741:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105746:	89 e5                	mov    %esp,%ebp
80105748:	83 ec 10             	sub    $0x10,%esp
8010574b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010574f:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105754:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105758:	c1 e8 10             	shr    $0x10,%eax
8010575b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010575f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105762:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105765:	c9                   	leave  
80105766:	c3                   	ret    
80105767:	89 f6                	mov    %esi,%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105770 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	57                   	push   %edi
80105774:	56                   	push   %esi
80105775:	53                   	push   %ebx
80105776:	83 ec 1c             	sub    $0x1c,%esp
80105779:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010577c:	8b 47 30             	mov    0x30(%edi),%eax
8010577f:	83 f8 40             	cmp    $0x40,%eax
80105782:	0f 84 f0 00 00 00    	je     80105878 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105788:	83 e8 20             	sub    $0x20,%eax
8010578b:	83 f8 1f             	cmp    $0x1f,%eax
8010578e:	77 10                	ja     801057a0 <trap+0x30>
80105790:	ff 24 85 60 77 10 80 	jmp    *-0x7fef88a0(,%eax,4)
80105797:	89 f6                	mov    %esi,%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801057a0:	e8 ab e0 ff ff       	call   80103850 <myproc>
801057a5:	85 c0                	test   %eax,%eax
801057a7:	8b 5f 38             	mov    0x38(%edi),%ebx
801057aa:	0f 84 14 02 00 00    	je     801059c4 <trap+0x254>
801057b0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801057b4:	0f 84 0a 02 00 00    	je     801059c4 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801057ba:	0f 20 d1             	mov    %cr2,%ecx
801057bd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057c0:	e8 6b e0 ff ff       	call   80103830 <cpuid>
801057c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801057c8:	8b 47 34             	mov    0x34(%edi),%eax
801057cb:	8b 77 30             	mov    0x30(%edi),%esi
801057ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801057d1:	e8 7a e0 ff ff       	call   80103850 <myproc>
801057d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801057d9:	e8 72 e0 ff ff       	call   80103850 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057de:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801057e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801057e4:	51                   	push   %ecx
801057e5:	53                   	push   %ebx
801057e6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801057e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057ea:	ff 75 e4             	pushl  -0x1c(%ebp)
801057ed:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801057ee:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057f1:	52                   	push   %edx
801057f2:	ff 70 10             	pushl  0x10(%eax)
801057f5:	68 1c 77 10 80       	push   $0x8010771c
801057fa:	e8 61 ae ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801057ff:	83 c4 20             	add    $0x20,%esp
80105802:	e8 49 e0 ff ff       	call   80103850 <myproc>
80105807:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010580e:	e8 3d e0 ff ff       	call   80103850 <myproc>
80105813:	85 c0                	test   %eax,%eax
80105815:	74 1d                	je     80105834 <trap+0xc4>
80105817:	e8 34 e0 ff ff       	call   80103850 <myproc>
8010581c:	8b 50 24             	mov    0x24(%eax),%edx
8010581f:	85 d2                	test   %edx,%edx
80105821:	74 11                	je     80105834 <trap+0xc4>
80105823:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105827:	83 e0 03             	and    $0x3,%eax
8010582a:	66 83 f8 03          	cmp    $0x3,%ax
8010582e:	0f 84 4c 01 00 00    	je     80105980 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105834:	e8 17 e0 ff ff       	call   80103850 <myproc>
80105839:	85 c0                	test   %eax,%eax
8010583b:	74 0b                	je     80105848 <trap+0xd8>
8010583d:	e8 0e e0 ff ff       	call   80103850 <myproc>
80105842:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105846:	74 68                	je     801058b0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105848:	e8 03 e0 ff ff       	call   80103850 <myproc>
8010584d:	85 c0                	test   %eax,%eax
8010584f:	74 19                	je     8010586a <trap+0xfa>
80105851:	e8 fa df ff ff       	call   80103850 <myproc>
80105856:	8b 40 24             	mov    0x24(%eax),%eax
80105859:	85 c0                	test   %eax,%eax
8010585b:	74 0d                	je     8010586a <trap+0xfa>
8010585d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105861:	83 e0 03             	and    $0x3,%eax
80105864:	66 83 f8 03          	cmp    $0x3,%ax
80105868:	74 37                	je     801058a1 <trap+0x131>
    exit();
}
8010586a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010586d:	5b                   	pop    %ebx
8010586e:	5e                   	pop    %esi
8010586f:	5f                   	pop    %edi
80105870:	5d                   	pop    %ebp
80105871:	c3                   	ret    
80105872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105878:	e8 d3 df ff ff       	call   80103850 <myproc>
8010587d:	8b 58 24             	mov    0x24(%eax),%ebx
80105880:	85 db                	test   %ebx,%ebx
80105882:	0f 85 e8 00 00 00    	jne    80105970 <trap+0x200>
    myproc()->tf = tf;
80105888:	e8 c3 df ff ff       	call   80103850 <myproc>
8010588d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105890:	e8 1b f0 ff ff       	call   801048b0 <syscall>
    if(myproc()->killed)
80105895:	e8 b6 df ff ff       	call   80103850 <myproc>
8010589a:	8b 48 24             	mov    0x24(%eax),%ecx
8010589d:	85 c9                	test   %ecx,%ecx
8010589f:	74 c9                	je     8010586a <trap+0xfa>
}
801058a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058a4:	5b                   	pop    %ebx
801058a5:	5e                   	pop    %esi
801058a6:	5f                   	pop    %edi
801058a7:	5d                   	pop    %ebp
      exit();
801058a8:	e9 c3 e3 ff ff       	jmp    80103c70 <exit>
801058ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801058b0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801058b4:	75 92                	jne    80105848 <trap+0xd8>
    yield();
801058b6:	e8 e5 e4 ff ff       	call   80103da0 <yield>
801058bb:	eb 8b                	jmp    80105848 <trap+0xd8>
801058bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
801058c0:	e8 6b df ff ff       	call   80103830 <cpuid>
801058c5:	85 c0                	test   %eax,%eax
801058c7:	0f 84 c3 00 00 00    	je     80105990 <trap+0x220>
    lapiceoi();
801058cd:	e8 ee ce ff ff       	call   801027c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058d2:	e8 79 df ff ff       	call   80103850 <myproc>
801058d7:	85 c0                	test   %eax,%eax
801058d9:	0f 85 38 ff ff ff    	jne    80105817 <trap+0xa7>
801058df:	e9 50 ff ff ff       	jmp    80105834 <trap+0xc4>
801058e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801058e8:	e8 93 cd ff ff       	call   80102680 <kbdintr>
    lapiceoi();
801058ed:	e8 ce ce ff ff       	call   801027c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058f2:	e8 59 df ff ff       	call   80103850 <myproc>
801058f7:	85 c0                	test   %eax,%eax
801058f9:	0f 85 18 ff ff ff    	jne    80105817 <trap+0xa7>
801058ff:	e9 30 ff ff ff       	jmp    80105834 <trap+0xc4>
80105904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105908:	e8 53 02 00 00       	call   80105b60 <uartintr>
    lapiceoi();
8010590d:	e8 ae ce ff ff       	call   801027c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105912:	e8 39 df ff ff       	call   80103850 <myproc>
80105917:	85 c0                	test   %eax,%eax
80105919:	0f 85 f8 fe ff ff    	jne    80105817 <trap+0xa7>
8010591f:	e9 10 ff ff ff       	jmp    80105834 <trap+0xc4>
80105924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105928:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010592c:	8b 77 38             	mov    0x38(%edi),%esi
8010592f:	e8 fc de ff ff       	call   80103830 <cpuid>
80105934:	56                   	push   %esi
80105935:	53                   	push   %ebx
80105936:	50                   	push   %eax
80105937:	68 c4 76 10 80       	push   $0x801076c4
8010593c:	e8 1f ad ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105941:	e8 7a ce ff ff       	call   801027c0 <lapiceoi>
    break;
80105946:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105949:	e8 02 df ff ff       	call   80103850 <myproc>
8010594e:	85 c0                	test   %eax,%eax
80105950:	0f 85 c1 fe ff ff    	jne    80105817 <trap+0xa7>
80105956:	e9 d9 fe ff ff       	jmp    80105834 <trap+0xc4>
8010595b:	90                   	nop
8010595c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105960:	e8 8b c7 ff ff       	call   801020f0 <ideintr>
80105965:	e9 63 ff ff ff       	jmp    801058cd <trap+0x15d>
8010596a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105970:	e8 fb e2 ff ff       	call   80103c70 <exit>
80105975:	e9 0e ff ff ff       	jmp    80105888 <trap+0x118>
8010597a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105980:	e8 eb e2 ff ff       	call   80103c70 <exit>
80105985:	e9 aa fe ff ff       	jmp    80105834 <trap+0xc4>
8010598a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105990:	83 ec 0c             	sub    $0xc,%esp
80105993:	68 60 4c 11 80       	push   $0x80114c60
80105998:	e8 13 ea ff ff       	call   801043b0 <acquire>
      wakeup(&ticks);
8010599d:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
801059a4:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
801059ab:	e8 f0 e5 ff ff       	call   80103fa0 <wakeup>
      release(&tickslock);
801059b0:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801059b7:	e8 b4 ea ff ff       	call   80104470 <release>
801059bc:	83 c4 10             	add    $0x10,%esp
801059bf:	e9 09 ff ff ff       	jmp    801058cd <trap+0x15d>
801059c4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801059c7:	e8 64 de ff ff       	call   80103830 <cpuid>
801059cc:	83 ec 0c             	sub    $0xc,%esp
801059cf:	56                   	push   %esi
801059d0:	53                   	push   %ebx
801059d1:	50                   	push   %eax
801059d2:	ff 77 30             	pushl  0x30(%edi)
801059d5:	68 e8 76 10 80       	push   $0x801076e8
801059da:	e8 81 ac ff ff       	call   80100660 <cprintf>
      panic("trap");
801059df:	83 c4 14             	add    $0x14,%esp
801059e2:	68 be 76 10 80       	push   $0x801076be
801059e7:	e8 a4 a9 ff ff       	call   80100390 <panic>
801059ec:	66 90                	xchg   %ax,%ax
801059ee:	66 90                	xchg   %ax,%ax

801059f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801059f0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
801059f5:	55                   	push   %ebp
801059f6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801059f8:	85 c0                	test   %eax,%eax
801059fa:	74 1c                	je     80105a18 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059fc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a01:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a02:	a8 01                	test   $0x1,%al
80105a04:	74 12                	je     80105a18 <uartgetc+0x28>
80105a06:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a0b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a0c:	0f b6 c0             	movzbl %al,%eax
}
80105a0f:	5d                   	pop    %ebp
80105a10:	c3                   	ret    
80105a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a1d:	5d                   	pop    %ebp
80105a1e:	c3                   	ret    
80105a1f:	90                   	nop

80105a20 <uartputc.part.0>:
uartputc(int c)
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	57                   	push   %edi
80105a24:	56                   	push   %esi
80105a25:	53                   	push   %ebx
80105a26:	89 c7                	mov    %eax,%edi
80105a28:	bb 80 00 00 00       	mov    $0x80,%ebx
80105a2d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105a32:	83 ec 0c             	sub    $0xc,%esp
80105a35:	eb 1b                	jmp    80105a52 <uartputc.part.0+0x32>
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105a40:	83 ec 0c             	sub    $0xc,%esp
80105a43:	6a 0a                	push   $0xa
80105a45:	e8 96 cd ff ff       	call   801027e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105a4a:	83 c4 10             	add    $0x10,%esp
80105a4d:	83 eb 01             	sub    $0x1,%ebx
80105a50:	74 07                	je     80105a59 <uartputc.part.0+0x39>
80105a52:	89 f2                	mov    %esi,%edx
80105a54:	ec                   	in     (%dx),%al
80105a55:	a8 20                	test   $0x20,%al
80105a57:	74 e7                	je     80105a40 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a59:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a5e:	89 f8                	mov    %edi,%eax
80105a60:	ee                   	out    %al,(%dx)
}
80105a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a64:	5b                   	pop    %ebx
80105a65:	5e                   	pop    %esi
80105a66:	5f                   	pop    %edi
80105a67:	5d                   	pop    %ebp
80105a68:	c3                   	ret    
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a70 <uartinit>:
{
80105a70:	55                   	push   %ebp
80105a71:	31 c9                	xor    %ecx,%ecx
80105a73:	89 c8                	mov    %ecx,%eax
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	57                   	push   %edi
80105a78:	56                   	push   %esi
80105a79:	53                   	push   %ebx
80105a7a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105a7f:	89 da                	mov    %ebx,%edx
80105a81:	83 ec 0c             	sub    $0xc,%esp
80105a84:	ee                   	out    %al,(%dx)
80105a85:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105a8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105a8f:	89 fa                	mov    %edi,%edx
80105a91:	ee                   	out    %al,(%dx)
80105a92:	b8 0c 00 00 00       	mov    $0xc,%eax
80105a97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a9c:	ee                   	out    %al,(%dx)
80105a9d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105aa2:	89 c8                	mov    %ecx,%eax
80105aa4:	89 f2                	mov    %esi,%edx
80105aa6:	ee                   	out    %al,(%dx)
80105aa7:	b8 03 00 00 00       	mov    $0x3,%eax
80105aac:	89 fa                	mov    %edi,%edx
80105aae:	ee                   	out    %al,(%dx)
80105aaf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ab4:	89 c8                	mov    %ecx,%eax
80105ab6:	ee                   	out    %al,(%dx)
80105ab7:	b8 01 00 00 00       	mov    $0x1,%eax
80105abc:	89 f2                	mov    %esi,%edx
80105abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105abf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ac4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105ac5:	3c ff                	cmp    $0xff,%al
80105ac7:	74 5a                	je     80105b23 <uartinit+0xb3>
  uart = 1;
80105ac9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ad0:	00 00 00 
80105ad3:	89 da                	mov    %ebx,%edx
80105ad5:	ec                   	in     (%dx),%al
80105ad6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105adb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105adc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105adf:	bb e0 77 10 80       	mov    $0x801077e0,%ebx
  ioapicenable(IRQ_COM1, 0);
80105ae4:	6a 00                	push   $0x0
80105ae6:	6a 04                	push   $0x4
80105ae8:	e8 53 c8 ff ff       	call   80102340 <ioapicenable>
80105aed:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105af0:	b8 78 00 00 00       	mov    $0x78,%eax
80105af5:	eb 13                	jmp    80105b0a <uartinit+0x9a>
80105af7:	89 f6                	mov    %esi,%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105b00:	83 c3 01             	add    $0x1,%ebx
80105b03:	0f be 03             	movsbl (%ebx),%eax
80105b06:	84 c0                	test   %al,%al
80105b08:	74 19                	je     80105b23 <uartinit+0xb3>
  if(!uart)
80105b0a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105b10:	85 d2                	test   %edx,%edx
80105b12:	74 ec                	je     80105b00 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105b14:	83 c3 01             	add    $0x1,%ebx
80105b17:	e8 04 ff ff ff       	call   80105a20 <uartputc.part.0>
80105b1c:	0f be 03             	movsbl (%ebx),%eax
80105b1f:	84 c0                	test   %al,%al
80105b21:	75 e7                	jne    80105b0a <uartinit+0x9a>
}
80105b23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b26:	5b                   	pop    %ebx
80105b27:	5e                   	pop    %esi
80105b28:	5f                   	pop    %edi
80105b29:	5d                   	pop    %ebp
80105b2a:	c3                   	ret    
80105b2b:	90                   	nop
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b30 <uartputc>:
  if(!uart)
80105b30:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105b36:	55                   	push   %ebp
80105b37:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105b39:	85 d2                	test   %edx,%edx
{
80105b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105b3e:	74 10                	je     80105b50 <uartputc+0x20>
}
80105b40:	5d                   	pop    %ebp
80105b41:	e9 da fe ff ff       	jmp    80105a20 <uartputc.part.0>
80105b46:	8d 76 00             	lea    0x0(%esi),%esi
80105b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105b50:	5d                   	pop    %ebp
80105b51:	c3                   	ret    
80105b52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b60 <uartintr>:

void
uartintr(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105b66:	68 f0 59 10 80       	push   $0x801059f0
80105b6b:	e8 a0 ac ff ff       	call   80100810 <consoleintr>
}
80105b70:	83 c4 10             	add    $0x10,%esp
80105b73:	c9                   	leave  
80105b74:	c3                   	ret    

80105b75 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $0
80105b77:	6a 00                	push   $0x0
  jmp alltraps
80105b79:	e9 1c fb ff ff       	jmp    8010569a <alltraps>

80105b7e <vector1>:
.globl vector1
vector1:
  pushl $0
80105b7e:	6a 00                	push   $0x0
  pushl $1
80105b80:	6a 01                	push   $0x1
  jmp alltraps
80105b82:	e9 13 fb ff ff       	jmp    8010569a <alltraps>

80105b87 <vector2>:
.globl vector2
vector2:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $2
80105b89:	6a 02                	push   $0x2
  jmp alltraps
80105b8b:	e9 0a fb ff ff       	jmp    8010569a <alltraps>

80105b90 <vector3>:
.globl vector3
vector3:
  pushl $0
80105b90:	6a 00                	push   $0x0
  pushl $3
80105b92:	6a 03                	push   $0x3
  jmp alltraps
80105b94:	e9 01 fb ff ff       	jmp    8010569a <alltraps>

80105b99 <vector4>:
.globl vector4
vector4:
  pushl $0
80105b99:	6a 00                	push   $0x0
  pushl $4
80105b9b:	6a 04                	push   $0x4
  jmp alltraps
80105b9d:	e9 f8 fa ff ff       	jmp    8010569a <alltraps>

80105ba2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ba2:	6a 00                	push   $0x0
  pushl $5
80105ba4:	6a 05                	push   $0x5
  jmp alltraps
80105ba6:	e9 ef fa ff ff       	jmp    8010569a <alltraps>

80105bab <vector6>:
.globl vector6
vector6:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $6
80105bad:	6a 06                	push   $0x6
  jmp alltraps
80105baf:	e9 e6 fa ff ff       	jmp    8010569a <alltraps>

80105bb4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105bb4:	6a 00                	push   $0x0
  pushl $7
80105bb6:	6a 07                	push   $0x7
  jmp alltraps
80105bb8:	e9 dd fa ff ff       	jmp    8010569a <alltraps>

80105bbd <vector8>:
.globl vector8
vector8:
  pushl $8
80105bbd:	6a 08                	push   $0x8
  jmp alltraps
80105bbf:	e9 d6 fa ff ff       	jmp    8010569a <alltraps>

80105bc4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105bc4:	6a 00                	push   $0x0
  pushl $9
80105bc6:	6a 09                	push   $0x9
  jmp alltraps
80105bc8:	e9 cd fa ff ff       	jmp    8010569a <alltraps>

80105bcd <vector10>:
.globl vector10
vector10:
  pushl $10
80105bcd:	6a 0a                	push   $0xa
  jmp alltraps
80105bcf:	e9 c6 fa ff ff       	jmp    8010569a <alltraps>

80105bd4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105bd4:	6a 0b                	push   $0xb
  jmp alltraps
80105bd6:	e9 bf fa ff ff       	jmp    8010569a <alltraps>

80105bdb <vector12>:
.globl vector12
vector12:
  pushl $12
80105bdb:	6a 0c                	push   $0xc
  jmp alltraps
80105bdd:	e9 b8 fa ff ff       	jmp    8010569a <alltraps>

80105be2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105be2:	6a 0d                	push   $0xd
  jmp alltraps
80105be4:	e9 b1 fa ff ff       	jmp    8010569a <alltraps>

80105be9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105be9:	6a 0e                	push   $0xe
  jmp alltraps
80105beb:	e9 aa fa ff ff       	jmp    8010569a <alltraps>

80105bf0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105bf0:	6a 00                	push   $0x0
  pushl $15
80105bf2:	6a 0f                	push   $0xf
  jmp alltraps
80105bf4:	e9 a1 fa ff ff       	jmp    8010569a <alltraps>

80105bf9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105bf9:	6a 00                	push   $0x0
  pushl $16
80105bfb:	6a 10                	push   $0x10
  jmp alltraps
80105bfd:	e9 98 fa ff ff       	jmp    8010569a <alltraps>

80105c02 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c02:	6a 11                	push   $0x11
  jmp alltraps
80105c04:	e9 91 fa ff ff       	jmp    8010569a <alltraps>

80105c09 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c09:	6a 00                	push   $0x0
  pushl $18
80105c0b:	6a 12                	push   $0x12
  jmp alltraps
80105c0d:	e9 88 fa ff ff       	jmp    8010569a <alltraps>

80105c12 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c12:	6a 00                	push   $0x0
  pushl $19
80105c14:	6a 13                	push   $0x13
  jmp alltraps
80105c16:	e9 7f fa ff ff       	jmp    8010569a <alltraps>

80105c1b <vector20>:
.globl vector20
vector20:
  pushl $0
80105c1b:	6a 00                	push   $0x0
  pushl $20
80105c1d:	6a 14                	push   $0x14
  jmp alltraps
80105c1f:	e9 76 fa ff ff       	jmp    8010569a <alltraps>

80105c24 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c24:	6a 00                	push   $0x0
  pushl $21
80105c26:	6a 15                	push   $0x15
  jmp alltraps
80105c28:	e9 6d fa ff ff       	jmp    8010569a <alltraps>

80105c2d <vector22>:
.globl vector22
vector22:
  pushl $0
80105c2d:	6a 00                	push   $0x0
  pushl $22
80105c2f:	6a 16                	push   $0x16
  jmp alltraps
80105c31:	e9 64 fa ff ff       	jmp    8010569a <alltraps>

80105c36 <vector23>:
.globl vector23
vector23:
  pushl $0
80105c36:	6a 00                	push   $0x0
  pushl $23
80105c38:	6a 17                	push   $0x17
  jmp alltraps
80105c3a:	e9 5b fa ff ff       	jmp    8010569a <alltraps>

80105c3f <vector24>:
.globl vector24
vector24:
  pushl $0
80105c3f:	6a 00                	push   $0x0
  pushl $24
80105c41:	6a 18                	push   $0x18
  jmp alltraps
80105c43:	e9 52 fa ff ff       	jmp    8010569a <alltraps>

80105c48 <vector25>:
.globl vector25
vector25:
  pushl $0
80105c48:	6a 00                	push   $0x0
  pushl $25
80105c4a:	6a 19                	push   $0x19
  jmp alltraps
80105c4c:	e9 49 fa ff ff       	jmp    8010569a <alltraps>

80105c51 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c51:	6a 00                	push   $0x0
  pushl $26
80105c53:	6a 1a                	push   $0x1a
  jmp alltraps
80105c55:	e9 40 fa ff ff       	jmp    8010569a <alltraps>

80105c5a <vector27>:
.globl vector27
vector27:
  pushl $0
80105c5a:	6a 00                	push   $0x0
  pushl $27
80105c5c:	6a 1b                	push   $0x1b
  jmp alltraps
80105c5e:	e9 37 fa ff ff       	jmp    8010569a <alltraps>

80105c63 <vector28>:
.globl vector28
vector28:
  pushl $0
80105c63:	6a 00                	push   $0x0
  pushl $28
80105c65:	6a 1c                	push   $0x1c
  jmp alltraps
80105c67:	e9 2e fa ff ff       	jmp    8010569a <alltraps>

80105c6c <vector29>:
.globl vector29
vector29:
  pushl $0
80105c6c:	6a 00                	push   $0x0
  pushl $29
80105c6e:	6a 1d                	push   $0x1d
  jmp alltraps
80105c70:	e9 25 fa ff ff       	jmp    8010569a <alltraps>

80105c75 <vector30>:
.globl vector30
vector30:
  pushl $0
80105c75:	6a 00                	push   $0x0
  pushl $30
80105c77:	6a 1e                	push   $0x1e
  jmp alltraps
80105c79:	e9 1c fa ff ff       	jmp    8010569a <alltraps>

80105c7e <vector31>:
.globl vector31
vector31:
  pushl $0
80105c7e:	6a 00                	push   $0x0
  pushl $31
80105c80:	6a 1f                	push   $0x1f
  jmp alltraps
80105c82:	e9 13 fa ff ff       	jmp    8010569a <alltraps>

80105c87 <vector32>:
.globl vector32
vector32:
  pushl $0
80105c87:	6a 00                	push   $0x0
  pushl $32
80105c89:	6a 20                	push   $0x20
  jmp alltraps
80105c8b:	e9 0a fa ff ff       	jmp    8010569a <alltraps>

80105c90 <vector33>:
.globl vector33
vector33:
  pushl $0
80105c90:	6a 00                	push   $0x0
  pushl $33
80105c92:	6a 21                	push   $0x21
  jmp alltraps
80105c94:	e9 01 fa ff ff       	jmp    8010569a <alltraps>

80105c99 <vector34>:
.globl vector34
vector34:
  pushl $0
80105c99:	6a 00                	push   $0x0
  pushl $34
80105c9b:	6a 22                	push   $0x22
  jmp alltraps
80105c9d:	e9 f8 f9 ff ff       	jmp    8010569a <alltraps>

80105ca2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ca2:	6a 00                	push   $0x0
  pushl $35
80105ca4:	6a 23                	push   $0x23
  jmp alltraps
80105ca6:	e9 ef f9 ff ff       	jmp    8010569a <alltraps>

80105cab <vector36>:
.globl vector36
vector36:
  pushl $0
80105cab:	6a 00                	push   $0x0
  pushl $36
80105cad:	6a 24                	push   $0x24
  jmp alltraps
80105caf:	e9 e6 f9 ff ff       	jmp    8010569a <alltraps>

80105cb4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105cb4:	6a 00                	push   $0x0
  pushl $37
80105cb6:	6a 25                	push   $0x25
  jmp alltraps
80105cb8:	e9 dd f9 ff ff       	jmp    8010569a <alltraps>

80105cbd <vector38>:
.globl vector38
vector38:
  pushl $0
80105cbd:	6a 00                	push   $0x0
  pushl $38
80105cbf:	6a 26                	push   $0x26
  jmp alltraps
80105cc1:	e9 d4 f9 ff ff       	jmp    8010569a <alltraps>

80105cc6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $39
80105cc8:	6a 27                	push   $0x27
  jmp alltraps
80105cca:	e9 cb f9 ff ff       	jmp    8010569a <alltraps>

80105ccf <vector40>:
.globl vector40
vector40:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $40
80105cd1:	6a 28                	push   $0x28
  jmp alltraps
80105cd3:	e9 c2 f9 ff ff       	jmp    8010569a <alltraps>

80105cd8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105cd8:	6a 00                	push   $0x0
  pushl $41
80105cda:	6a 29                	push   $0x29
  jmp alltraps
80105cdc:	e9 b9 f9 ff ff       	jmp    8010569a <alltraps>

80105ce1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ce1:	6a 00                	push   $0x0
  pushl $42
80105ce3:	6a 2a                	push   $0x2a
  jmp alltraps
80105ce5:	e9 b0 f9 ff ff       	jmp    8010569a <alltraps>

80105cea <vector43>:
.globl vector43
vector43:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $43
80105cec:	6a 2b                	push   $0x2b
  jmp alltraps
80105cee:	e9 a7 f9 ff ff       	jmp    8010569a <alltraps>

80105cf3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $44
80105cf5:	6a 2c                	push   $0x2c
  jmp alltraps
80105cf7:	e9 9e f9 ff ff       	jmp    8010569a <alltraps>

80105cfc <vector45>:
.globl vector45
vector45:
  pushl $0
80105cfc:	6a 00                	push   $0x0
  pushl $45
80105cfe:	6a 2d                	push   $0x2d
  jmp alltraps
80105d00:	e9 95 f9 ff ff       	jmp    8010569a <alltraps>

80105d05 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d05:	6a 00                	push   $0x0
  pushl $46
80105d07:	6a 2e                	push   $0x2e
  jmp alltraps
80105d09:	e9 8c f9 ff ff       	jmp    8010569a <alltraps>

80105d0e <vector47>:
.globl vector47
vector47:
  pushl $0
80105d0e:	6a 00                	push   $0x0
  pushl $47
80105d10:	6a 2f                	push   $0x2f
  jmp alltraps
80105d12:	e9 83 f9 ff ff       	jmp    8010569a <alltraps>

80105d17 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d17:	6a 00                	push   $0x0
  pushl $48
80105d19:	6a 30                	push   $0x30
  jmp alltraps
80105d1b:	e9 7a f9 ff ff       	jmp    8010569a <alltraps>

80105d20 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d20:	6a 00                	push   $0x0
  pushl $49
80105d22:	6a 31                	push   $0x31
  jmp alltraps
80105d24:	e9 71 f9 ff ff       	jmp    8010569a <alltraps>

80105d29 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d29:	6a 00                	push   $0x0
  pushl $50
80105d2b:	6a 32                	push   $0x32
  jmp alltraps
80105d2d:	e9 68 f9 ff ff       	jmp    8010569a <alltraps>

80105d32 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $51
80105d34:	6a 33                	push   $0x33
  jmp alltraps
80105d36:	e9 5f f9 ff ff       	jmp    8010569a <alltraps>

80105d3b <vector52>:
.globl vector52
vector52:
  pushl $0
80105d3b:	6a 00                	push   $0x0
  pushl $52
80105d3d:	6a 34                	push   $0x34
  jmp alltraps
80105d3f:	e9 56 f9 ff ff       	jmp    8010569a <alltraps>

80105d44 <vector53>:
.globl vector53
vector53:
  pushl $0
80105d44:	6a 00                	push   $0x0
  pushl $53
80105d46:	6a 35                	push   $0x35
  jmp alltraps
80105d48:	e9 4d f9 ff ff       	jmp    8010569a <alltraps>

80105d4d <vector54>:
.globl vector54
vector54:
  pushl $0
80105d4d:	6a 00                	push   $0x0
  pushl $54
80105d4f:	6a 36                	push   $0x36
  jmp alltraps
80105d51:	e9 44 f9 ff ff       	jmp    8010569a <alltraps>

80105d56 <vector55>:
.globl vector55
vector55:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $55
80105d58:	6a 37                	push   $0x37
  jmp alltraps
80105d5a:	e9 3b f9 ff ff       	jmp    8010569a <alltraps>

80105d5f <vector56>:
.globl vector56
vector56:
  pushl $0
80105d5f:	6a 00                	push   $0x0
  pushl $56
80105d61:	6a 38                	push   $0x38
  jmp alltraps
80105d63:	e9 32 f9 ff ff       	jmp    8010569a <alltraps>

80105d68 <vector57>:
.globl vector57
vector57:
  pushl $0
80105d68:	6a 00                	push   $0x0
  pushl $57
80105d6a:	6a 39                	push   $0x39
  jmp alltraps
80105d6c:	e9 29 f9 ff ff       	jmp    8010569a <alltraps>

80105d71 <vector58>:
.globl vector58
vector58:
  pushl $0
80105d71:	6a 00                	push   $0x0
  pushl $58
80105d73:	6a 3a                	push   $0x3a
  jmp alltraps
80105d75:	e9 20 f9 ff ff       	jmp    8010569a <alltraps>

80105d7a <vector59>:
.globl vector59
vector59:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $59
80105d7c:	6a 3b                	push   $0x3b
  jmp alltraps
80105d7e:	e9 17 f9 ff ff       	jmp    8010569a <alltraps>

80105d83 <vector60>:
.globl vector60
vector60:
  pushl $0
80105d83:	6a 00                	push   $0x0
  pushl $60
80105d85:	6a 3c                	push   $0x3c
  jmp alltraps
80105d87:	e9 0e f9 ff ff       	jmp    8010569a <alltraps>

80105d8c <vector61>:
.globl vector61
vector61:
  pushl $0
80105d8c:	6a 00                	push   $0x0
  pushl $61
80105d8e:	6a 3d                	push   $0x3d
  jmp alltraps
80105d90:	e9 05 f9 ff ff       	jmp    8010569a <alltraps>

80105d95 <vector62>:
.globl vector62
vector62:
  pushl $0
80105d95:	6a 00                	push   $0x0
  pushl $62
80105d97:	6a 3e                	push   $0x3e
  jmp alltraps
80105d99:	e9 fc f8 ff ff       	jmp    8010569a <alltraps>

80105d9e <vector63>:
.globl vector63
vector63:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $63
80105da0:	6a 3f                	push   $0x3f
  jmp alltraps
80105da2:	e9 f3 f8 ff ff       	jmp    8010569a <alltraps>

80105da7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105da7:	6a 00                	push   $0x0
  pushl $64
80105da9:	6a 40                	push   $0x40
  jmp alltraps
80105dab:	e9 ea f8 ff ff       	jmp    8010569a <alltraps>

80105db0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105db0:	6a 00                	push   $0x0
  pushl $65
80105db2:	6a 41                	push   $0x41
  jmp alltraps
80105db4:	e9 e1 f8 ff ff       	jmp    8010569a <alltraps>

80105db9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105db9:	6a 00                	push   $0x0
  pushl $66
80105dbb:	6a 42                	push   $0x42
  jmp alltraps
80105dbd:	e9 d8 f8 ff ff       	jmp    8010569a <alltraps>

80105dc2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $67
80105dc4:	6a 43                	push   $0x43
  jmp alltraps
80105dc6:	e9 cf f8 ff ff       	jmp    8010569a <alltraps>

80105dcb <vector68>:
.globl vector68
vector68:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $68
80105dcd:	6a 44                	push   $0x44
  jmp alltraps
80105dcf:	e9 c6 f8 ff ff       	jmp    8010569a <alltraps>

80105dd4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105dd4:	6a 00                	push   $0x0
  pushl $69
80105dd6:	6a 45                	push   $0x45
  jmp alltraps
80105dd8:	e9 bd f8 ff ff       	jmp    8010569a <alltraps>

80105ddd <vector70>:
.globl vector70
vector70:
  pushl $0
80105ddd:	6a 00                	push   $0x0
  pushl $70
80105ddf:	6a 46                	push   $0x46
  jmp alltraps
80105de1:	e9 b4 f8 ff ff       	jmp    8010569a <alltraps>

80105de6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $71
80105de8:	6a 47                	push   $0x47
  jmp alltraps
80105dea:	e9 ab f8 ff ff       	jmp    8010569a <alltraps>

80105def <vector72>:
.globl vector72
vector72:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $72
80105df1:	6a 48                	push   $0x48
  jmp alltraps
80105df3:	e9 a2 f8 ff ff       	jmp    8010569a <alltraps>

80105df8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105df8:	6a 00                	push   $0x0
  pushl $73
80105dfa:	6a 49                	push   $0x49
  jmp alltraps
80105dfc:	e9 99 f8 ff ff       	jmp    8010569a <alltraps>

80105e01 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e01:	6a 00                	push   $0x0
  pushl $74
80105e03:	6a 4a                	push   $0x4a
  jmp alltraps
80105e05:	e9 90 f8 ff ff       	jmp    8010569a <alltraps>

80105e0a <vector75>:
.globl vector75
vector75:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $75
80105e0c:	6a 4b                	push   $0x4b
  jmp alltraps
80105e0e:	e9 87 f8 ff ff       	jmp    8010569a <alltraps>

80105e13 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $76
80105e15:	6a 4c                	push   $0x4c
  jmp alltraps
80105e17:	e9 7e f8 ff ff       	jmp    8010569a <alltraps>

80105e1c <vector77>:
.globl vector77
vector77:
  pushl $0
80105e1c:	6a 00                	push   $0x0
  pushl $77
80105e1e:	6a 4d                	push   $0x4d
  jmp alltraps
80105e20:	e9 75 f8 ff ff       	jmp    8010569a <alltraps>

80105e25 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e25:	6a 00                	push   $0x0
  pushl $78
80105e27:	6a 4e                	push   $0x4e
  jmp alltraps
80105e29:	e9 6c f8 ff ff       	jmp    8010569a <alltraps>

80105e2e <vector79>:
.globl vector79
vector79:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $79
80105e30:	6a 4f                	push   $0x4f
  jmp alltraps
80105e32:	e9 63 f8 ff ff       	jmp    8010569a <alltraps>

80105e37 <vector80>:
.globl vector80
vector80:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $80
80105e39:	6a 50                	push   $0x50
  jmp alltraps
80105e3b:	e9 5a f8 ff ff       	jmp    8010569a <alltraps>

80105e40 <vector81>:
.globl vector81
vector81:
  pushl $0
80105e40:	6a 00                	push   $0x0
  pushl $81
80105e42:	6a 51                	push   $0x51
  jmp alltraps
80105e44:	e9 51 f8 ff ff       	jmp    8010569a <alltraps>

80105e49 <vector82>:
.globl vector82
vector82:
  pushl $0
80105e49:	6a 00                	push   $0x0
  pushl $82
80105e4b:	6a 52                	push   $0x52
  jmp alltraps
80105e4d:	e9 48 f8 ff ff       	jmp    8010569a <alltraps>

80105e52 <vector83>:
.globl vector83
vector83:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $83
80105e54:	6a 53                	push   $0x53
  jmp alltraps
80105e56:	e9 3f f8 ff ff       	jmp    8010569a <alltraps>

80105e5b <vector84>:
.globl vector84
vector84:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $84
80105e5d:	6a 54                	push   $0x54
  jmp alltraps
80105e5f:	e9 36 f8 ff ff       	jmp    8010569a <alltraps>

80105e64 <vector85>:
.globl vector85
vector85:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $85
80105e66:	6a 55                	push   $0x55
  jmp alltraps
80105e68:	e9 2d f8 ff ff       	jmp    8010569a <alltraps>

80105e6d <vector86>:
.globl vector86
vector86:
  pushl $0
80105e6d:	6a 00                	push   $0x0
  pushl $86
80105e6f:	6a 56                	push   $0x56
  jmp alltraps
80105e71:	e9 24 f8 ff ff       	jmp    8010569a <alltraps>

80105e76 <vector87>:
.globl vector87
vector87:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $87
80105e78:	6a 57                	push   $0x57
  jmp alltraps
80105e7a:	e9 1b f8 ff ff       	jmp    8010569a <alltraps>

80105e7f <vector88>:
.globl vector88
vector88:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $88
80105e81:	6a 58                	push   $0x58
  jmp alltraps
80105e83:	e9 12 f8 ff ff       	jmp    8010569a <alltraps>

80105e88 <vector89>:
.globl vector89
vector89:
  pushl $0
80105e88:	6a 00                	push   $0x0
  pushl $89
80105e8a:	6a 59                	push   $0x59
  jmp alltraps
80105e8c:	e9 09 f8 ff ff       	jmp    8010569a <alltraps>

80105e91 <vector90>:
.globl vector90
vector90:
  pushl $0
80105e91:	6a 00                	push   $0x0
  pushl $90
80105e93:	6a 5a                	push   $0x5a
  jmp alltraps
80105e95:	e9 00 f8 ff ff       	jmp    8010569a <alltraps>

80105e9a <vector91>:
.globl vector91
vector91:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $91
80105e9c:	6a 5b                	push   $0x5b
  jmp alltraps
80105e9e:	e9 f7 f7 ff ff       	jmp    8010569a <alltraps>

80105ea3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $92
80105ea5:	6a 5c                	push   $0x5c
  jmp alltraps
80105ea7:	e9 ee f7 ff ff       	jmp    8010569a <alltraps>

80105eac <vector93>:
.globl vector93
vector93:
  pushl $0
80105eac:	6a 00                	push   $0x0
  pushl $93
80105eae:	6a 5d                	push   $0x5d
  jmp alltraps
80105eb0:	e9 e5 f7 ff ff       	jmp    8010569a <alltraps>

80105eb5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $94
80105eb7:	6a 5e                	push   $0x5e
  jmp alltraps
80105eb9:	e9 dc f7 ff ff       	jmp    8010569a <alltraps>

80105ebe <vector95>:
.globl vector95
vector95:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $95
80105ec0:	6a 5f                	push   $0x5f
  jmp alltraps
80105ec2:	e9 d3 f7 ff ff       	jmp    8010569a <alltraps>

80105ec7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $96
80105ec9:	6a 60                	push   $0x60
  jmp alltraps
80105ecb:	e9 ca f7 ff ff       	jmp    8010569a <alltraps>

80105ed0 <vector97>:
.globl vector97
vector97:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $97
80105ed2:	6a 61                	push   $0x61
  jmp alltraps
80105ed4:	e9 c1 f7 ff ff       	jmp    8010569a <alltraps>

80105ed9 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $98
80105edb:	6a 62                	push   $0x62
  jmp alltraps
80105edd:	e9 b8 f7 ff ff       	jmp    8010569a <alltraps>

80105ee2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $99
80105ee4:	6a 63                	push   $0x63
  jmp alltraps
80105ee6:	e9 af f7 ff ff       	jmp    8010569a <alltraps>

80105eeb <vector100>:
.globl vector100
vector100:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $100
80105eed:	6a 64                	push   $0x64
  jmp alltraps
80105eef:	e9 a6 f7 ff ff       	jmp    8010569a <alltraps>

80105ef4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $101
80105ef6:	6a 65                	push   $0x65
  jmp alltraps
80105ef8:	e9 9d f7 ff ff       	jmp    8010569a <alltraps>

80105efd <vector102>:
.globl vector102
vector102:
  pushl $0
80105efd:	6a 00                	push   $0x0
  pushl $102
80105eff:	6a 66                	push   $0x66
  jmp alltraps
80105f01:	e9 94 f7 ff ff       	jmp    8010569a <alltraps>

80105f06 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $103
80105f08:	6a 67                	push   $0x67
  jmp alltraps
80105f0a:	e9 8b f7 ff ff       	jmp    8010569a <alltraps>

80105f0f <vector104>:
.globl vector104
vector104:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $104
80105f11:	6a 68                	push   $0x68
  jmp alltraps
80105f13:	e9 82 f7 ff ff       	jmp    8010569a <alltraps>

80105f18 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f18:	6a 00                	push   $0x0
  pushl $105
80105f1a:	6a 69                	push   $0x69
  jmp alltraps
80105f1c:	e9 79 f7 ff ff       	jmp    8010569a <alltraps>

80105f21 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f21:	6a 00                	push   $0x0
  pushl $106
80105f23:	6a 6a                	push   $0x6a
  jmp alltraps
80105f25:	e9 70 f7 ff ff       	jmp    8010569a <alltraps>

80105f2a <vector107>:
.globl vector107
vector107:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $107
80105f2c:	6a 6b                	push   $0x6b
  jmp alltraps
80105f2e:	e9 67 f7 ff ff       	jmp    8010569a <alltraps>

80105f33 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $108
80105f35:	6a 6c                	push   $0x6c
  jmp alltraps
80105f37:	e9 5e f7 ff ff       	jmp    8010569a <alltraps>

80105f3c <vector109>:
.globl vector109
vector109:
  pushl $0
80105f3c:	6a 00                	push   $0x0
  pushl $109
80105f3e:	6a 6d                	push   $0x6d
  jmp alltraps
80105f40:	e9 55 f7 ff ff       	jmp    8010569a <alltraps>

80105f45 <vector110>:
.globl vector110
vector110:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $110
80105f47:	6a 6e                	push   $0x6e
  jmp alltraps
80105f49:	e9 4c f7 ff ff       	jmp    8010569a <alltraps>

80105f4e <vector111>:
.globl vector111
vector111:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $111
80105f50:	6a 6f                	push   $0x6f
  jmp alltraps
80105f52:	e9 43 f7 ff ff       	jmp    8010569a <alltraps>

80105f57 <vector112>:
.globl vector112
vector112:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $112
80105f59:	6a 70                	push   $0x70
  jmp alltraps
80105f5b:	e9 3a f7 ff ff       	jmp    8010569a <alltraps>

80105f60 <vector113>:
.globl vector113
vector113:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $113
80105f62:	6a 71                	push   $0x71
  jmp alltraps
80105f64:	e9 31 f7 ff ff       	jmp    8010569a <alltraps>

80105f69 <vector114>:
.globl vector114
vector114:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $114
80105f6b:	6a 72                	push   $0x72
  jmp alltraps
80105f6d:	e9 28 f7 ff ff       	jmp    8010569a <alltraps>

80105f72 <vector115>:
.globl vector115
vector115:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $115
80105f74:	6a 73                	push   $0x73
  jmp alltraps
80105f76:	e9 1f f7 ff ff       	jmp    8010569a <alltraps>

80105f7b <vector116>:
.globl vector116
vector116:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $116
80105f7d:	6a 74                	push   $0x74
  jmp alltraps
80105f7f:	e9 16 f7 ff ff       	jmp    8010569a <alltraps>

80105f84 <vector117>:
.globl vector117
vector117:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $117
80105f86:	6a 75                	push   $0x75
  jmp alltraps
80105f88:	e9 0d f7 ff ff       	jmp    8010569a <alltraps>

80105f8d <vector118>:
.globl vector118
vector118:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $118
80105f8f:	6a 76                	push   $0x76
  jmp alltraps
80105f91:	e9 04 f7 ff ff       	jmp    8010569a <alltraps>

80105f96 <vector119>:
.globl vector119
vector119:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $119
80105f98:	6a 77                	push   $0x77
  jmp alltraps
80105f9a:	e9 fb f6 ff ff       	jmp    8010569a <alltraps>

80105f9f <vector120>:
.globl vector120
vector120:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $120
80105fa1:	6a 78                	push   $0x78
  jmp alltraps
80105fa3:	e9 f2 f6 ff ff       	jmp    8010569a <alltraps>

80105fa8 <vector121>:
.globl vector121
vector121:
  pushl $0
80105fa8:	6a 00                	push   $0x0
  pushl $121
80105faa:	6a 79                	push   $0x79
  jmp alltraps
80105fac:	e9 e9 f6 ff ff       	jmp    8010569a <alltraps>

80105fb1 <vector122>:
.globl vector122
vector122:
  pushl $0
80105fb1:	6a 00                	push   $0x0
  pushl $122
80105fb3:	6a 7a                	push   $0x7a
  jmp alltraps
80105fb5:	e9 e0 f6 ff ff       	jmp    8010569a <alltraps>

80105fba <vector123>:
.globl vector123
vector123:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $123
80105fbc:	6a 7b                	push   $0x7b
  jmp alltraps
80105fbe:	e9 d7 f6 ff ff       	jmp    8010569a <alltraps>

80105fc3 <vector124>:
.globl vector124
vector124:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $124
80105fc5:	6a 7c                	push   $0x7c
  jmp alltraps
80105fc7:	e9 ce f6 ff ff       	jmp    8010569a <alltraps>

80105fcc <vector125>:
.globl vector125
vector125:
  pushl $0
80105fcc:	6a 00                	push   $0x0
  pushl $125
80105fce:	6a 7d                	push   $0x7d
  jmp alltraps
80105fd0:	e9 c5 f6 ff ff       	jmp    8010569a <alltraps>

80105fd5 <vector126>:
.globl vector126
vector126:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $126
80105fd7:	6a 7e                	push   $0x7e
  jmp alltraps
80105fd9:	e9 bc f6 ff ff       	jmp    8010569a <alltraps>

80105fde <vector127>:
.globl vector127
vector127:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $127
80105fe0:	6a 7f                	push   $0x7f
  jmp alltraps
80105fe2:	e9 b3 f6 ff ff       	jmp    8010569a <alltraps>

80105fe7 <vector128>:
.globl vector128
vector128:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $128
80105fe9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105fee:	e9 a7 f6 ff ff       	jmp    8010569a <alltraps>

80105ff3 <vector129>:
.globl vector129
vector129:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $129
80105ff5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105ffa:	e9 9b f6 ff ff       	jmp    8010569a <alltraps>

80105fff <vector130>:
.globl vector130
vector130:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $130
80106001:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106006:	e9 8f f6 ff ff       	jmp    8010569a <alltraps>

8010600b <vector131>:
.globl vector131
vector131:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $131
8010600d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106012:	e9 83 f6 ff ff       	jmp    8010569a <alltraps>

80106017 <vector132>:
.globl vector132
vector132:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $132
80106019:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010601e:	e9 77 f6 ff ff       	jmp    8010569a <alltraps>

80106023 <vector133>:
.globl vector133
vector133:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $133
80106025:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010602a:	e9 6b f6 ff ff       	jmp    8010569a <alltraps>

8010602f <vector134>:
.globl vector134
vector134:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $134
80106031:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106036:	e9 5f f6 ff ff       	jmp    8010569a <alltraps>

8010603b <vector135>:
.globl vector135
vector135:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $135
8010603d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106042:	e9 53 f6 ff ff       	jmp    8010569a <alltraps>

80106047 <vector136>:
.globl vector136
vector136:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $136
80106049:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010604e:	e9 47 f6 ff ff       	jmp    8010569a <alltraps>

80106053 <vector137>:
.globl vector137
vector137:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $137
80106055:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010605a:	e9 3b f6 ff ff       	jmp    8010569a <alltraps>

8010605f <vector138>:
.globl vector138
vector138:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $138
80106061:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106066:	e9 2f f6 ff ff       	jmp    8010569a <alltraps>

8010606b <vector139>:
.globl vector139
vector139:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $139
8010606d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106072:	e9 23 f6 ff ff       	jmp    8010569a <alltraps>

80106077 <vector140>:
.globl vector140
vector140:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $140
80106079:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010607e:	e9 17 f6 ff ff       	jmp    8010569a <alltraps>

80106083 <vector141>:
.globl vector141
vector141:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $141
80106085:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010608a:	e9 0b f6 ff ff       	jmp    8010569a <alltraps>

8010608f <vector142>:
.globl vector142
vector142:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $142
80106091:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106096:	e9 ff f5 ff ff       	jmp    8010569a <alltraps>

8010609b <vector143>:
.globl vector143
vector143:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $143
8010609d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801060a2:	e9 f3 f5 ff ff       	jmp    8010569a <alltraps>

801060a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $144
801060a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801060ae:	e9 e7 f5 ff ff       	jmp    8010569a <alltraps>

801060b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $145
801060b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801060ba:	e9 db f5 ff ff       	jmp    8010569a <alltraps>

801060bf <vector146>:
.globl vector146
vector146:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $146
801060c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801060c6:	e9 cf f5 ff ff       	jmp    8010569a <alltraps>

801060cb <vector147>:
.globl vector147
vector147:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $147
801060cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801060d2:	e9 c3 f5 ff ff       	jmp    8010569a <alltraps>

801060d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $148
801060d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801060de:	e9 b7 f5 ff ff       	jmp    8010569a <alltraps>

801060e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $149
801060e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801060ea:	e9 ab f5 ff ff       	jmp    8010569a <alltraps>

801060ef <vector150>:
.globl vector150
vector150:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $150
801060f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801060f6:	e9 9f f5 ff ff       	jmp    8010569a <alltraps>

801060fb <vector151>:
.globl vector151
vector151:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $151
801060fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106102:	e9 93 f5 ff ff       	jmp    8010569a <alltraps>

80106107 <vector152>:
.globl vector152
vector152:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $152
80106109:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010610e:	e9 87 f5 ff ff       	jmp    8010569a <alltraps>

80106113 <vector153>:
.globl vector153
vector153:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $153
80106115:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010611a:	e9 7b f5 ff ff       	jmp    8010569a <alltraps>

8010611f <vector154>:
.globl vector154
vector154:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $154
80106121:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106126:	e9 6f f5 ff ff       	jmp    8010569a <alltraps>

8010612b <vector155>:
.globl vector155
vector155:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $155
8010612d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106132:	e9 63 f5 ff ff       	jmp    8010569a <alltraps>

80106137 <vector156>:
.globl vector156
vector156:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $156
80106139:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010613e:	e9 57 f5 ff ff       	jmp    8010569a <alltraps>

80106143 <vector157>:
.globl vector157
vector157:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $157
80106145:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010614a:	e9 4b f5 ff ff       	jmp    8010569a <alltraps>

8010614f <vector158>:
.globl vector158
vector158:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $158
80106151:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106156:	e9 3f f5 ff ff       	jmp    8010569a <alltraps>

8010615b <vector159>:
.globl vector159
vector159:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $159
8010615d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106162:	e9 33 f5 ff ff       	jmp    8010569a <alltraps>

80106167 <vector160>:
.globl vector160
vector160:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $160
80106169:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010616e:	e9 27 f5 ff ff       	jmp    8010569a <alltraps>

80106173 <vector161>:
.globl vector161
vector161:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $161
80106175:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010617a:	e9 1b f5 ff ff       	jmp    8010569a <alltraps>

8010617f <vector162>:
.globl vector162
vector162:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $162
80106181:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106186:	e9 0f f5 ff ff       	jmp    8010569a <alltraps>

8010618b <vector163>:
.globl vector163
vector163:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $163
8010618d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106192:	e9 03 f5 ff ff       	jmp    8010569a <alltraps>

80106197 <vector164>:
.globl vector164
vector164:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $164
80106199:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010619e:	e9 f7 f4 ff ff       	jmp    8010569a <alltraps>

801061a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $165
801061a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801061aa:	e9 eb f4 ff ff       	jmp    8010569a <alltraps>

801061af <vector166>:
.globl vector166
vector166:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $166
801061b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801061b6:	e9 df f4 ff ff       	jmp    8010569a <alltraps>

801061bb <vector167>:
.globl vector167
vector167:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $167
801061bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801061c2:	e9 d3 f4 ff ff       	jmp    8010569a <alltraps>

801061c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $168
801061c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801061ce:	e9 c7 f4 ff ff       	jmp    8010569a <alltraps>

801061d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $169
801061d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801061da:	e9 bb f4 ff ff       	jmp    8010569a <alltraps>

801061df <vector170>:
.globl vector170
vector170:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $170
801061e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801061e6:	e9 af f4 ff ff       	jmp    8010569a <alltraps>

801061eb <vector171>:
.globl vector171
vector171:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $171
801061ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801061f2:	e9 a3 f4 ff ff       	jmp    8010569a <alltraps>

801061f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $172
801061f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801061fe:	e9 97 f4 ff ff       	jmp    8010569a <alltraps>

80106203 <vector173>:
.globl vector173
vector173:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $173
80106205:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010620a:	e9 8b f4 ff ff       	jmp    8010569a <alltraps>

8010620f <vector174>:
.globl vector174
vector174:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $174
80106211:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106216:	e9 7f f4 ff ff       	jmp    8010569a <alltraps>

8010621b <vector175>:
.globl vector175
vector175:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $175
8010621d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106222:	e9 73 f4 ff ff       	jmp    8010569a <alltraps>

80106227 <vector176>:
.globl vector176
vector176:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $176
80106229:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010622e:	e9 67 f4 ff ff       	jmp    8010569a <alltraps>

80106233 <vector177>:
.globl vector177
vector177:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $177
80106235:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010623a:	e9 5b f4 ff ff       	jmp    8010569a <alltraps>

8010623f <vector178>:
.globl vector178
vector178:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $178
80106241:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106246:	e9 4f f4 ff ff       	jmp    8010569a <alltraps>

8010624b <vector179>:
.globl vector179
vector179:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $179
8010624d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106252:	e9 43 f4 ff ff       	jmp    8010569a <alltraps>

80106257 <vector180>:
.globl vector180
vector180:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $180
80106259:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010625e:	e9 37 f4 ff ff       	jmp    8010569a <alltraps>

80106263 <vector181>:
.globl vector181
vector181:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $181
80106265:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010626a:	e9 2b f4 ff ff       	jmp    8010569a <alltraps>

8010626f <vector182>:
.globl vector182
vector182:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $182
80106271:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106276:	e9 1f f4 ff ff       	jmp    8010569a <alltraps>

8010627b <vector183>:
.globl vector183
vector183:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $183
8010627d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106282:	e9 13 f4 ff ff       	jmp    8010569a <alltraps>

80106287 <vector184>:
.globl vector184
vector184:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $184
80106289:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010628e:	e9 07 f4 ff ff       	jmp    8010569a <alltraps>

80106293 <vector185>:
.globl vector185
vector185:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $185
80106295:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010629a:	e9 fb f3 ff ff       	jmp    8010569a <alltraps>

8010629f <vector186>:
.globl vector186
vector186:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $186
801062a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801062a6:	e9 ef f3 ff ff       	jmp    8010569a <alltraps>

801062ab <vector187>:
.globl vector187
vector187:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $187
801062ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801062b2:	e9 e3 f3 ff ff       	jmp    8010569a <alltraps>

801062b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $188
801062b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801062be:	e9 d7 f3 ff ff       	jmp    8010569a <alltraps>

801062c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $189
801062c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801062ca:	e9 cb f3 ff ff       	jmp    8010569a <alltraps>

801062cf <vector190>:
.globl vector190
vector190:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $190
801062d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801062d6:	e9 bf f3 ff ff       	jmp    8010569a <alltraps>

801062db <vector191>:
.globl vector191
vector191:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $191
801062dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801062e2:	e9 b3 f3 ff ff       	jmp    8010569a <alltraps>

801062e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $192
801062e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801062ee:	e9 a7 f3 ff ff       	jmp    8010569a <alltraps>

801062f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $193
801062f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801062fa:	e9 9b f3 ff ff       	jmp    8010569a <alltraps>

801062ff <vector194>:
.globl vector194
vector194:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $194
80106301:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106306:	e9 8f f3 ff ff       	jmp    8010569a <alltraps>

8010630b <vector195>:
.globl vector195
vector195:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $195
8010630d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106312:	e9 83 f3 ff ff       	jmp    8010569a <alltraps>

80106317 <vector196>:
.globl vector196
vector196:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $196
80106319:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010631e:	e9 77 f3 ff ff       	jmp    8010569a <alltraps>

80106323 <vector197>:
.globl vector197
vector197:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $197
80106325:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010632a:	e9 6b f3 ff ff       	jmp    8010569a <alltraps>

8010632f <vector198>:
.globl vector198
vector198:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $198
80106331:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106336:	e9 5f f3 ff ff       	jmp    8010569a <alltraps>

8010633b <vector199>:
.globl vector199
vector199:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $199
8010633d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106342:	e9 53 f3 ff ff       	jmp    8010569a <alltraps>

80106347 <vector200>:
.globl vector200
vector200:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $200
80106349:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010634e:	e9 47 f3 ff ff       	jmp    8010569a <alltraps>

80106353 <vector201>:
.globl vector201
vector201:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $201
80106355:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010635a:	e9 3b f3 ff ff       	jmp    8010569a <alltraps>

8010635f <vector202>:
.globl vector202
vector202:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $202
80106361:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106366:	e9 2f f3 ff ff       	jmp    8010569a <alltraps>

8010636b <vector203>:
.globl vector203
vector203:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $203
8010636d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106372:	e9 23 f3 ff ff       	jmp    8010569a <alltraps>

80106377 <vector204>:
.globl vector204
vector204:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $204
80106379:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010637e:	e9 17 f3 ff ff       	jmp    8010569a <alltraps>

80106383 <vector205>:
.globl vector205
vector205:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $205
80106385:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010638a:	e9 0b f3 ff ff       	jmp    8010569a <alltraps>

8010638f <vector206>:
.globl vector206
vector206:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $206
80106391:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106396:	e9 ff f2 ff ff       	jmp    8010569a <alltraps>

8010639b <vector207>:
.globl vector207
vector207:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $207
8010639d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801063a2:	e9 f3 f2 ff ff       	jmp    8010569a <alltraps>

801063a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $208
801063a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801063ae:	e9 e7 f2 ff ff       	jmp    8010569a <alltraps>

801063b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $209
801063b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801063ba:	e9 db f2 ff ff       	jmp    8010569a <alltraps>

801063bf <vector210>:
.globl vector210
vector210:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $210
801063c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801063c6:	e9 cf f2 ff ff       	jmp    8010569a <alltraps>

801063cb <vector211>:
.globl vector211
vector211:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $211
801063cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801063d2:	e9 c3 f2 ff ff       	jmp    8010569a <alltraps>

801063d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $212
801063d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801063de:	e9 b7 f2 ff ff       	jmp    8010569a <alltraps>

801063e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $213
801063e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801063ea:	e9 ab f2 ff ff       	jmp    8010569a <alltraps>

801063ef <vector214>:
.globl vector214
vector214:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $214
801063f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801063f6:	e9 9f f2 ff ff       	jmp    8010569a <alltraps>

801063fb <vector215>:
.globl vector215
vector215:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $215
801063fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106402:	e9 93 f2 ff ff       	jmp    8010569a <alltraps>

80106407 <vector216>:
.globl vector216
vector216:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $216
80106409:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010640e:	e9 87 f2 ff ff       	jmp    8010569a <alltraps>

80106413 <vector217>:
.globl vector217
vector217:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $217
80106415:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010641a:	e9 7b f2 ff ff       	jmp    8010569a <alltraps>

8010641f <vector218>:
.globl vector218
vector218:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $218
80106421:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106426:	e9 6f f2 ff ff       	jmp    8010569a <alltraps>

8010642b <vector219>:
.globl vector219
vector219:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $219
8010642d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106432:	e9 63 f2 ff ff       	jmp    8010569a <alltraps>

80106437 <vector220>:
.globl vector220
vector220:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $220
80106439:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010643e:	e9 57 f2 ff ff       	jmp    8010569a <alltraps>

80106443 <vector221>:
.globl vector221
vector221:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $221
80106445:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010644a:	e9 4b f2 ff ff       	jmp    8010569a <alltraps>

8010644f <vector222>:
.globl vector222
vector222:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $222
80106451:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106456:	e9 3f f2 ff ff       	jmp    8010569a <alltraps>

8010645b <vector223>:
.globl vector223
vector223:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $223
8010645d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106462:	e9 33 f2 ff ff       	jmp    8010569a <alltraps>

80106467 <vector224>:
.globl vector224
vector224:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $224
80106469:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010646e:	e9 27 f2 ff ff       	jmp    8010569a <alltraps>

80106473 <vector225>:
.globl vector225
vector225:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $225
80106475:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010647a:	e9 1b f2 ff ff       	jmp    8010569a <alltraps>

8010647f <vector226>:
.globl vector226
vector226:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $226
80106481:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106486:	e9 0f f2 ff ff       	jmp    8010569a <alltraps>

8010648b <vector227>:
.globl vector227
vector227:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $227
8010648d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106492:	e9 03 f2 ff ff       	jmp    8010569a <alltraps>

80106497 <vector228>:
.globl vector228
vector228:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $228
80106499:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010649e:	e9 f7 f1 ff ff       	jmp    8010569a <alltraps>

801064a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $229
801064a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801064aa:	e9 eb f1 ff ff       	jmp    8010569a <alltraps>

801064af <vector230>:
.globl vector230
vector230:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $230
801064b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801064b6:	e9 df f1 ff ff       	jmp    8010569a <alltraps>

801064bb <vector231>:
.globl vector231
vector231:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $231
801064bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801064c2:	e9 d3 f1 ff ff       	jmp    8010569a <alltraps>

801064c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $232
801064c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801064ce:	e9 c7 f1 ff ff       	jmp    8010569a <alltraps>

801064d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $233
801064d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801064da:	e9 bb f1 ff ff       	jmp    8010569a <alltraps>

801064df <vector234>:
.globl vector234
vector234:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $234
801064e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801064e6:	e9 af f1 ff ff       	jmp    8010569a <alltraps>

801064eb <vector235>:
.globl vector235
vector235:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $235
801064ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801064f2:	e9 a3 f1 ff ff       	jmp    8010569a <alltraps>

801064f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $236
801064f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801064fe:	e9 97 f1 ff ff       	jmp    8010569a <alltraps>

80106503 <vector237>:
.globl vector237
vector237:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $237
80106505:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010650a:	e9 8b f1 ff ff       	jmp    8010569a <alltraps>

8010650f <vector238>:
.globl vector238
vector238:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $238
80106511:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106516:	e9 7f f1 ff ff       	jmp    8010569a <alltraps>

8010651b <vector239>:
.globl vector239
vector239:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $239
8010651d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106522:	e9 73 f1 ff ff       	jmp    8010569a <alltraps>

80106527 <vector240>:
.globl vector240
vector240:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $240
80106529:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010652e:	e9 67 f1 ff ff       	jmp    8010569a <alltraps>

80106533 <vector241>:
.globl vector241
vector241:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $241
80106535:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010653a:	e9 5b f1 ff ff       	jmp    8010569a <alltraps>

8010653f <vector242>:
.globl vector242
vector242:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $242
80106541:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106546:	e9 4f f1 ff ff       	jmp    8010569a <alltraps>

8010654b <vector243>:
.globl vector243
vector243:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $243
8010654d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106552:	e9 43 f1 ff ff       	jmp    8010569a <alltraps>

80106557 <vector244>:
.globl vector244
vector244:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $244
80106559:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010655e:	e9 37 f1 ff ff       	jmp    8010569a <alltraps>

80106563 <vector245>:
.globl vector245
vector245:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $245
80106565:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010656a:	e9 2b f1 ff ff       	jmp    8010569a <alltraps>

8010656f <vector246>:
.globl vector246
vector246:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $246
80106571:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106576:	e9 1f f1 ff ff       	jmp    8010569a <alltraps>

8010657b <vector247>:
.globl vector247
vector247:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $247
8010657d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106582:	e9 13 f1 ff ff       	jmp    8010569a <alltraps>

80106587 <vector248>:
.globl vector248
vector248:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $248
80106589:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010658e:	e9 07 f1 ff ff       	jmp    8010569a <alltraps>

80106593 <vector249>:
.globl vector249
vector249:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $249
80106595:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010659a:	e9 fb f0 ff ff       	jmp    8010569a <alltraps>

8010659f <vector250>:
.globl vector250
vector250:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $250
801065a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801065a6:	e9 ef f0 ff ff       	jmp    8010569a <alltraps>

801065ab <vector251>:
.globl vector251
vector251:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $251
801065ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801065b2:	e9 e3 f0 ff ff       	jmp    8010569a <alltraps>

801065b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $252
801065b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801065be:	e9 d7 f0 ff ff       	jmp    8010569a <alltraps>

801065c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $253
801065c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801065ca:	e9 cb f0 ff ff       	jmp    8010569a <alltraps>

801065cf <vector254>:
.globl vector254
vector254:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $254
801065d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801065d6:	e9 bf f0 ff ff       	jmp    8010569a <alltraps>

801065db <vector255>:
.globl vector255
vector255:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $255
801065dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801065e2:	e9 b3 f0 ff ff       	jmp    8010569a <alltraps>
801065e7:	66 90                	xchg   %ax,%ax
801065e9:	66 90                	xchg   %ax,%ax
801065eb:	66 90                	xchg   %ax,%ax
801065ed:	66 90                	xchg   %ax,%ax
801065ef:	90                   	nop

801065f0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	57                   	push   %edi
801065f4:	56                   	push   %esi
801065f5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801065f6:	89 d3                	mov    %edx,%ebx
{
801065f8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801065fa:	c1 eb 16             	shr    $0x16,%ebx
801065fd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106600:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106603:	8b 06                	mov    (%esi),%eax
80106605:	a8 01                	test   $0x1,%al
80106607:	74 27                	je     80106630 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106609:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010660e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106614:	c1 ef 0a             	shr    $0xa,%edi
}
80106617:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010661a:	89 fa                	mov    %edi,%edx
8010661c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106622:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106625:	5b                   	pop    %ebx
80106626:	5e                   	pop    %esi
80106627:	5f                   	pop    %edi
80106628:	5d                   	pop    %ebp
80106629:	c3                   	ret    
8010662a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106630:	85 c9                	test   %ecx,%ecx
80106632:	74 2c                	je     80106660 <walkpgdir+0x70>
80106634:	e8 f7 be ff ff       	call   80102530 <kalloc>
80106639:	85 c0                	test   %eax,%eax
8010663b:	89 c3                	mov    %eax,%ebx
8010663d:	74 21                	je     80106660 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010663f:	83 ec 04             	sub    $0x4,%esp
80106642:	68 00 10 00 00       	push   $0x1000
80106647:	6a 00                	push   $0x0
80106649:	50                   	push   %eax
8010664a:	e8 71 de ff ff       	call   801044c0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010664f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106655:	83 c4 10             	add    $0x10,%esp
80106658:	83 c8 07             	or     $0x7,%eax
8010665b:	89 06                	mov    %eax,(%esi)
8010665d:	eb b5                	jmp    80106614 <walkpgdir+0x24>
8010665f:	90                   	nop
}
80106660:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106663:	31 c0                	xor    %eax,%eax
}
80106665:	5b                   	pop    %ebx
80106666:	5e                   	pop    %esi
80106667:	5f                   	pop    %edi
80106668:	5d                   	pop    %ebp
80106669:	c3                   	ret    
8010666a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106670 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	57                   	push   %edi
80106674:	56                   	push   %esi
80106675:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106676:	89 d3                	mov    %edx,%ebx
80106678:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010667e:	83 ec 1c             	sub    $0x1c,%esp
80106681:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106684:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106688:	8b 7d 08             	mov    0x8(%ebp),%edi
8010668b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106690:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106693:	8b 45 0c             	mov    0xc(%ebp),%eax
80106696:	29 df                	sub    %ebx,%edi
80106698:	83 c8 01             	or     $0x1,%eax
8010669b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010669e:	eb 15                	jmp    801066b5 <mappages+0x45>
    if(*pte & PTE_P)
801066a0:	f6 00 01             	testb  $0x1,(%eax)
801066a3:	75 45                	jne    801066ea <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801066a5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801066a8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801066ab:	89 30                	mov    %esi,(%eax)
    if(a == last)
801066ad:	74 31                	je     801066e0 <mappages+0x70>
      break;
    a += PGSIZE;
801066af:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801066b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066b8:	b9 01 00 00 00       	mov    $0x1,%ecx
801066bd:	89 da                	mov    %ebx,%edx
801066bf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801066c2:	e8 29 ff ff ff       	call   801065f0 <walkpgdir>
801066c7:	85 c0                	test   %eax,%eax
801066c9:	75 d5                	jne    801066a0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801066cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801066ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066d3:	5b                   	pop    %ebx
801066d4:	5e                   	pop    %esi
801066d5:	5f                   	pop    %edi
801066d6:	5d                   	pop    %ebp
801066d7:	c3                   	ret    
801066d8:	90                   	nop
801066d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801066e3:	31 c0                	xor    %eax,%eax
}
801066e5:	5b                   	pop    %ebx
801066e6:	5e                   	pop    %esi
801066e7:	5f                   	pop    %edi
801066e8:	5d                   	pop    %ebp
801066e9:	c3                   	ret    
      panic("remap");
801066ea:	83 ec 0c             	sub    $0xc,%esp
801066ed:	68 e8 77 10 80       	push   $0x801077e8
801066f2:	e8 99 9c ff ff       	call   80100390 <panic>
801066f7:	89 f6                	mov    %esi,%esi
801066f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106700 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	57                   	push   %edi
80106704:	56                   	push   %esi
80106705:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106706:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010670c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010670e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106714:	83 ec 1c             	sub    $0x1c,%esp
80106717:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010671a:	39 d3                	cmp    %edx,%ebx
8010671c:	73 66                	jae    80106784 <deallocuvm.part.0+0x84>
8010671e:	89 d6                	mov    %edx,%esi
80106720:	eb 3d                	jmp    8010675f <deallocuvm.part.0+0x5f>
80106722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106728:	8b 10                	mov    (%eax),%edx
8010672a:	f6 c2 01             	test   $0x1,%dl
8010672d:	74 26                	je     80106755 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010672f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106735:	74 58                	je     8010678f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106737:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010673a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106743:	52                   	push   %edx
80106744:	e8 37 bc ff ff       	call   80102380 <kfree>
      *pte = 0;
80106749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010674c:	83 c4 10             	add    $0x10,%esp
8010674f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106755:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010675b:	39 f3                	cmp    %esi,%ebx
8010675d:	73 25                	jae    80106784 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010675f:	31 c9                	xor    %ecx,%ecx
80106761:	89 da                	mov    %ebx,%edx
80106763:	89 f8                	mov    %edi,%eax
80106765:	e8 86 fe ff ff       	call   801065f0 <walkpgdir>
    if(!pte)
8010676a:	85 c0                	test   %eax,%eax
8010676c:	75 ba                	jne    80106728 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010676e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106774:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010677a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106780:	39 f3                	cmp    %esi,%ebx
80106782:	72 db                	jb     8010675f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106784:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106787:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010678a:	5b                   	pop    %ebx
8010678b:	5e                   	pop    %esi
8010678c:	5f                   	pop    %edi
8010678d:	5d                   	pop    %ebp
8010678e:	c3                   	ret    
        panic("kfree");
8010678f:	83 ec 0c             	sub    $0xc,%esp
80106792:	68 86 71 10 80       	push   $0x80107186
80106797:	e8 f4 9b ff ff       	call   80100390 <panic>
8010679c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801067a0 <seginit>:
{
801067a0:	55                   	push   %ebp
801067a1:	89 e5                	mov    %esp,%ebp
801067a3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801067a6:	e8 85 d0 ff ff       	call   80103830 <cpuid>
801067ab:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801067b1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801067b6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801067ba:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
801067c1:	ff 00 00 
801067c4:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
801067cb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067ce:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
801067d5:	ff 00 00 
801067d8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
801067df:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067e2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
801067e9:	ff 00 00 
801067ec:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
801067f3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801067f6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
801067fd:	ff 00 00 
80106800:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106807:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010680a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
8010680f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106813:	c1 e8 10             	shr    $0x10,%eax
80106816:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010681a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010681d:	0f 01 10             	lgdtl  (%eax)
}
80106820:	c9                   	leave  
80106821:	c3                   	ret    
80106822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106830 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106830:	a1 a4 54 11 80       	mov    0x801154a4,%eax
{
80106835:	55                   	push   %ebp
80106836:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106838:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010683d:	0f 22 d8             	mov    %eax,%cr3
}
80106840:	5d                   	pop    %ebp
80106841:	c3                   	ret    
80106842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106850 <switchuvm>:
{
80106850:	55                   	push   %ebp
80106851:	89 e5                	mov    %esp,%ebp
80106853:	57                   	push   %edi
80106854:	56                   	push   %esi
80106855:	53                   	push   %ebx
80106856:	83 ec 1c             	sub    $0x1c,%esp
80106859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010685c:	85 db                	test   %ebx,%ebx
8010685e:	0f 84 cb 00 00 00    	je     8010692f <switchuvm+0xdf>
  if(p->kstack == 0)
80106864:	8b 43 08             	mov    0x8(%ebx),%eax
80106867:	85 c0                	test   %eax,%eax
80106869:	0f 84 da 00 00 00    	je     80106949 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010686f:	8b 43 04             	mov    0x4(%ebx),%eax
80106872:	85 c0                	test   %eax,%eax
80106874:	0f 84 c2 00 00 00    	je     8010693c <switchuvm+0xec>
  pushcli();
8010687a:	e8 61 da ff ff       	call   801042e0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010687f:	e8 2c cf ff ff       	call   801037b0 <mycpu>
80106884:	89 c6                	mov    %eax,%esi
80106886:	e8 25 cf ff ff       	call   801037b0 <mycpu>
8010688b:	89 c7                	mov    %eax,%edi
8010688d:	e8 1e cf ff ff       	call   801037b0 <mycpu>
80106892:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106895:	83 c7 08             	add    $0x8,%edi
80106898:	e8 13 cf ff ff       	call   801037b0 <mycpu>
8010689d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801068a0:	83 c0 08             	add    $0x8,%eax
801068a3:	ba 67 00 00 00       	mov    $0x67,%edx
801068a8:	c1 e8 18             	shr    $0x18,%eax
801068ab:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801068b2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801068b9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801068bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801068c4:	83 c1 08             	add    $0x8,%ecx
801068c7:	c1 e9 10             	shr    $0x10,%ecx
801068ca:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801068d0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801068d5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801068dc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801068e1:	e8 ca ce ff ff       	call   801037b0 <mycpu>
801068e6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801068ed:	e8 be ce ff ff       	call   801037b0 <mycpu>
801068f2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801068f6:	8b 73 08             	mov    0x8(%ebx),%esi
801068f9:	e8 b2 ce ff ff       	call   801037b0 <mycpu>
801068fe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106904:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106907:	e8 a4 ce ff ff       	call   801037b0 <mycpu>
8010690c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106910:	b8 28 00 00 00       	mov    $0x28,%eax
80106915:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106918:	8b 43 04             	mov    0x4(%ebx),%eax
8010691b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106920:	0f 22 d8             	mov    %eax,%cr3
}
80106923:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106926:	5b                   	pop    %ebx
80106927:	5e                   	pop    %esi
80106928:	5f                   	pop    %edi
80106929:	5d                   	pop    %ebp
  popcli();
8010692a:	e9 f1 d9 ff ff       	jmp    80104320 <popcli>
    panic("switchuvm: no process");
8010692f:	83 ec 0c             	sub    $0xc,%esp
80106932:	68 ee 77 10 80       	push   $0x801077ee
80106937:	e8 54 9a ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010693c:	83 ec 0c             	sub    $0xc,%esp
8010693f:	68 19 78 10 80       	push   $0x80107819
80106944:	e8 47 9a ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106949:	83 ec 0c             	sub    $0xc,%esp
8010694c:	68 04 78 10 80       	push   $0x80107804
80106951:	e8 3a 9a ff ff       	call   80100390 <panic>
80106956:	8d 76 00             	lea    0x0(%esi),%esi
80106959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106960 <inituvm>:
{
80106960:	55                   	push   %ebp
80106961:	89 e5                	mov    %esp,%ebp
80106963:	57                   	push   %edi
80106964:	56                   	push   %esi
80106965:	53                   	push   %ebx
80106966:	83 ec 1c             	sub    $0x1c,%esp
80106969:	8b 75 10             	mov    0x10(%ebp),%esi
8010696c:	8b 45 08             	mov    0x8(%ebp),%eax
8010696f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106972:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010697b:	77 49                	ja     801069c6 <inituvm+0x66>
  mem = kalloc();
8010697d:	e8 ae bb ff ff       	call   80102530 <kalloc>
  memset(mem, 0, PGSIZE);
80106982:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106985:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106987:	68 00 10 00 00       	push   $0x1000
8010698c:	6a 00                	push   $0x0
8010698e:	50                   	push   %eax
8010698f:	e8 2c db ff ff       	call   801044c0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106994:	58                   	pop    %eax
80106995:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010699b:	b9 00 10 00 00       	mov    $0x1000,%ecx
801069a0:	5a                   	pop    %edx
801069a1:	6a 06                	push   $0x6
801069a3:	50                   	push   %eax
801069a4:	31 d2                	xor    %edx,%edx
801069a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069a9:	e8 c2 fc ff ff       	call   80106670 <mappages>
  memmove(mem, init, sz);
801069ae:	89 75 10             	mov    %esi,0x10(%ebp)
801069b1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801069b4:	83 c4 10             	add    $0x10,%esp
801069b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801069ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069bd:	5b                   	pop    %ebx
801069be:	5e                   	pop    %esi
801069bf:	5f                   	pop    %edi
801069c0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801069c1:	e9 aa db ff ff       	jmp    80104570 <memmove>
    panic("inituvm: more than a page");
801069c6:	83 ec 0c             	sub    $0xc,%esp
801069c9:	68 2d 78 10 80       	push   $0x8010782d
801069ce:	e8 bd 99 ff ff       	call   80100390 <panic>
801069d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069e0 <loaduvm>:
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	57                   	push   %edi
801069e4:	56                   	push   %esi
801069e5:	53                   	push   %ebx
801069e6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801069e9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801069f0:	0f 85 91 00 00 00    	jne    80106a87 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801069f6:	8b 75 18             	mov    0x18(%ebp),%esi
801069f9:	31 db                	xor    %ebx,%ebx
801069fb:	85 f6                	test   %esi,%esi
801069fd:	75 1a                	jne    80106a19 <loaduvm+0x39>
801069ff:	eb 6f                	jmp    80106a70 <loaduvm+0x90>
80106a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a08:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a0e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106a14:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106a17:	76 57                	jbe    80106a70 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106a19:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a1f:	31 c9                	xor    %ecx,%ecx
80106a21:	01 da                	add    %ebx,%edx
80106a23:	e8 c8 fb ff ff       	call   801065f0 <walkpgdir>
80106a28:	85 c0                	test   %eax,%eax
80106a2a:	74 4e                	je     80106a7a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106a2c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106a2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106a31:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106a36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106a3b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106a41:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106a44:	01 d9                	add    %ebx,%ecx
80106a46:	05 00 00 00 80       	add    $0x80000000,%eax
80106a4b:	57                   	push   %edi
80106a4c:	51                   	push   %ecx
80106a4d:	50                   	push   %eax
80106a4e:	ff 75 10             	pushl  0x10(%ebp)
80106a51:	e8 7a af ff ff       	call   801019d0 <readi>
80106a56:	83 c4 10             	add    $0x10,%esp
80106a59:	39 f8                	cmp    %edi,%eax
80106a5b:	74 ab                	je     80106a08 <loaduvm+0x28>
}
80106a5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a65:	5b                   	pop    %ebx
80106a66:	5e                   	pop    %esi
80106a67:	5f                   	pop    %edi
80106a68:	5d                   	pop    %ebp
80106a69:	c3                   	ret    
80106a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106a73:	31 c0                	xor    %eax,%eax
}
80106a75:	5b                   	pop    %ebx
80106a76:	5e                   	pop    %esi
80106a77:	5f                   	pop    %edi
80106a78:	5d                   	pop    %ebp
80106a79:	c3                   	ret    
      panic("loaduvm: address should exist");
80106a7a:	83 ec 0c             	sub    $0xc,%esp
80106a7d:	68 47 78 10 80       	push   $0x80107847
80106a82:	e8 09 99 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106a87:	83 ec 0c             	sub    $0xc,%esp
80106a8a:	68 e8 78 10 80       	push   $0x801078e8
80106a8f:	e8 fc 98 ff ff       	call   80100390 <panic>
80106a94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106aa0 <allocuvm>:
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106aa9:	8b 7d 10             	mov    0x10(%ebp),%edi
80106aac:	85 ff                	test   %edi,%edi
80106aae:	0f 88 8e 00 00 00    	js     80106b42 <allocuvm+0xa2>
  if(newsz < oldsz)
80106ab4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ab7:	0f 82 93 00 00 00    	jb     80106b50 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106abd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ac0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106ac6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106acc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106acf:	0f 86 7e 00 00 00    	jbe    80106b53 <allocuvm+0xb3>
80106ad5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106ad8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106adb:	eb 42                	jmp    80106b1f <allocuvm+0x7f>
80106add:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106ae0:	83 ec 04             	sub    $0x4,%esp
80106ae3:	68 00 10 00 00       	push   $0x1000
80106ae8:	6a 00                	push   $0x0
80106aea:	50                   	push   %eax
80106aeb:	e8 d0 d9 ff ff       	call   801044c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106af0:	58                   	pop    %eax
80106af1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106af7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106afc:	5a                   	pop    %edx
80106afd:	6a 06                	push   $0x6
80106aff:	50                   	push   %eax
80106b00:	89 da                	mov    %ebx,%edx
80106b02:	89 f8                	mov    %edi,%eax
80106b04:	e8 67 fb ff ff       	call   80106670 <mappages>
80106b09:	83 c4 10             	add    $0x10,%esp
80106b0c:	85 c0                	test   %eax,%eax
80106b0e:	78 50                	js     80106b60 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106b10:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b16:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106b19:	0f 86 81 00 00 00    	jbe    80106ba0 <allocuvm+0x100>
    mem = kalloc();
80106b1f:	e8 0c ba ff ff       	call   80102530 <kalloc>
    if(mem == 0){
80106b24:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106b26:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106b28:	75 b6                	jne    80106ae0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106b2a:	83 ec 0c             	sub    $0xc,%esp
80106b2d:	68 65 78 10 80       	push   $0x80107865
80106b32:	e8 29 9b ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106b37:	83 c4 10             	add    $0x10,%esp
80106b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b3d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106b40:	77 6e                	ja     80106bb0 <allocuvm+0x110>
}
80106b42:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106b45:	31 ff                	xor    %edi,%edi
}
80106b47:	89 f8                	mov    %edi,%eax
80106b49:	5b                   	pop    %ebx
80106b4a:	5e                   	pop    %esi
80106b4b:	5f                   	pop    %edi
80106b4c:	5d                   	pop    %ebp
80106b4d:	c3                   	ret    
80106b4e:	66 90                	xchg   %ax,%ax
    return oldsz;
80106b50:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106b53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b56:	89 f8                	mov    %edi,%eax
80106b58:	5b                   	pop    %ebx
80106b59:	5e                   	pop    %esi
80106b5a:	5f                   	pop    %edi
80106b5b:	5d                   	pop    %ebp
80106b5c:	c3                   	ret    
80106b5d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106b60:	83 ec 0c             	sub    $0xc,%esp
80106b63:	68 7d 78 10 80       	push   $0x8010787d
80106b68:	e8 f3 9a ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106b6d:	83 c4 10             	add    $0x10,%esp
80106b70:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b73:	39 45 10             	cmp    %eax,0x10(%ebp)
80106b76:	76 0d                	jbe    80106b85 <allocuvm+0xe5>
80106b78:	89 c1                	mov    %eax,%ecx
80106b7a:	8b 55 10             	mov    0x10(%ebp),%edx
80106b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80106b80:	e8 7b fb ff ff       	call   80106700 <deallocuvm.part.0>
      kfree(mem);
80106b85:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106b88:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106b8a:	56                   	push   %esi
80106b8b:	e8 f0 b7 ff ff       	call   80102380 <kfree>
      return 0;
80106b90:	83 c4 10             	add    $0x10,%esp
}
80106b93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b96:	89 f8                	mov    %edi,%eax
80106b98:	5b                   	pop    %ebx
80106b99:	5e                   	pop    %esi
80106b9a:	5f                   	pop    %edi
80106b9b:	5d                   	pop    %ebp
80106b9c:	c3                   	ret    
80106b9d:	8d 76 00             	lea    0x0(%esi),%esi
80106ba0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106ba3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ba6:	5b                   	pop    %ebx
80106ba7:	89 f8                	mov    %edi,%eax
80106ba9:	5e                   	pop    %esi
80106baa:	5f                   	pop    %edi
80106bab:	5d                   	pop    %ebp
80106bac:	c3                   	ret    
80106bad:	8d 76 00             	lea    0x0(%esi),%esi
80106bb0:	89 c1                	mov    %eax,%ecx
80106bb2:	8b 55 10             	mov    0x10(%ebp),%edx
80106bb5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106bb8:	31 ff                	xor    %edi,%edi
80106bba:	e8 41 fb ff ff       	call   80106700 <deallocuvm.part.0>
80106bbf:	eb 92                	jmp    80106b53 <allocuvm+0xb3>
80106bc1:	eb 0d                	jmp    80106bd0 <deallocuvm>
80106bc3:	90                   	nop
80106bc4:	90                   	nop
80106bc5:	90                   	nop
80106bc6:	90                   	nop
80106bc7:	90                   	nop
80106bc8:	90                   	nop
80106bc9:	90                   	nop
80106bca:	90                   	nop
80106bcb:	90                   	nop
80106bcc:	90                   	nop
80106bcd:	90                   	nop
80106bce:	90                   	nop
80106bcf:	90                   	nop

80106bd0 <deallocuvm>:
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106bdc:	39 d1                	cmp    %edx,%ecx
80106bde:	73 10                	jae    80106bf0 <deallocuvm+0x20>
}
80106be0:	5d                   	pop    %ebp
80106be1:	e9 1a fb ff ff       	jmp    80106700 <deallocuvm.part.0>
80106be6:	8d 76 00             	lea    0x0(%esi),%esi
80106be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106bf0:	89 d0                	mov    %edx,%eax
80106bf2:	5d                   	pop    %ebp
80106bf3:	c3                   	ret    
80106bf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c00 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
80106c06:	83 ec 0c             	sub    $0xc,%esp
80106c09:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106c0c:	85 f6                	test   %esi,%esi
80106c0e:	74 59                	je     80106c69 <freevm+0x69>
80106c10:	31 c9                	xor    %ecx,%ecx
80106c12:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106c17:	89 f0                	mov    %esi,%eax
80106c19:	e8 e2 fa ff ff       	call   80106700 <deallocuvm.part.0>
80106c1e:	89 f3                	mov    %esi,%ebx
80106c20:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106c26:	eb 0f                	jmp    80106c37 <freevm+0x37>
80106c28:	90                   	nop
80106c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c30:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c33:	39 fb                	cmp    %edi,%ebx
80106c35:	74 23                	je     80106c5a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106c37:	8b 03                	mov    (%ebx),%eax
80106c39:	a8 01                	test   $0x1,%al
80106c3b:	74 f3                	je     80106c30 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106c3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106c42:	83 ec 0c             	sub    $0xc,%esp
80106c45:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106c48:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106c4d:	50                   	push   %eax
80106c4e:	e8 2d b7 ff ff       	call   80102380 <kfree>
80106c53:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106c56:	39 fb                	cmp    %edi,%ebx
80106c58:	75 dd                	jne    80106c37 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106c5a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106c5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c60:	5b                   	pop    %ebx
80106c61:	5e                   	pop    %esi
80106c62:	5f                   	pop    %edi
80106c63:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106c64:	e9 17 b7 ff ff       	jmp    80102380 <kfree>
    panic("freevm: no pgdir");
80106c69:	83 ec 0c             	sub    $0xc,%esp
80106c6c:	68 99 78 10 80       	push   $0x80107899
80106c71:	e8 1a 97 ff ff       	call   80100390 <panic>
80106c76:	8d 76 00             	lea    0x0(%esi),%esi
80106c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c80 <setupkvm>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	56                   	push   %esi
80106c84:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106c85:	e8 a6 b8 ff ff       	call   80102530 <kalloc>
80106c8a:	85 c0                	test   %eax,%eax
80106c8c:	89 c6                	mov    %eax,%esi
80106c8e:	74 42                	je     80106cd2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106c90:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106c93:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106c98:	68 00 10 00 00       	push   $0x1000
80106c9d:	6a 00                	push   $0x0
80106c9f:	50                   	push   %eax
80106ca0:	e8 1b d8 ff ff       	call   801044c0 <memset>
80106ca5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106ca8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106cab:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106cae:	83 ec 08             	sub    $0x8,%esp
80106cb1:	8b 13                	mov    (%ebx),%edx
80106cb3:	ff 73 0c             	pushl  0xc(%ebx)
80106cb6:	50                   	push   %eax
80106cb7:	29 c1                	sub    %eax,%ecx
80106cb9:	89 f0                	mov    %esi,%eax
80106cbb:	e8 b0 f9 ff ff       	call   80106670 <mappages>
80106cc0:	83 c4 10             	add    $0x10,%esp
80106cc3:	85 c0                	test   %eax,%eax
80106cc5:	78 19                	js     80106ce0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106cc7:	83 c3 10             	add    $0x10,%ebx
80106cca:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106cd0:	75 d6                	jne    80106ca8 <setupkvm+0x28>
}
80106cd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106cd5:	89 f0                	mov    %esi,%eax
80106cd7:	5b                   	pop    %ebx
80106cd8:	5e                   	pop    %esi
80106cd9:	5d                   	pop    %ebp
80106cda:	c3                   	ret    
80106cdb:	90                   	nop
80106cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106ce0:	83 ec 0c             	sub    $0xc,%esp
80106ce3:	56                   	push   %esi
      return 0;
80106ce4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106ce6:	e8 15 ff ff ff       	call   80106c00 <freevm>
      return 0;
80106ceb:	83 c4 10             	add    $0x10,%esp
}
80106cee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106cf1:	89 f0                	mov    %esi,%eax
80106cf3:	5b                   	pop    %ebx
80106cf4:	5e                   	pop    %esi
80106cf5:	5d                   	pop    %ebp
80106cf6:	c3                   	ret    
80106cf7:	89 f6                	mov    %esi,%esi
80106cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d00 <kvmalloc>:
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106d06:	e8 75 ff ff ff       	call   80106c80 <setupkvm>
80106d0b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d10:	05 00 00 00 80       	add    $0x80000000,%eax
80106d15:	0f 22 d8             	mov    %eax,%cr3
}
80106d18:	c9                   	leave  
80106d19:	c3                   	ret    
80106d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d20 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106d20:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d21:	31 c9                	xor    %ecx,%ecx
{
80106d23:	89 e5                	mov    %esp,%ebp
80106d25:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106d28:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d2e:	e8 bd f8 ff ff       	call   801065f0 <walkpgdir>
  if(pte == 0)
80106d33:	85 c0                	test   %eax,%eax
80106d35:	74 05                	je     80106d3c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106d37:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106d3a:	c9                   	leave  
80106d3b:	c3                   	ret    
    panic("clearpteu");
80106d3c:	83 ec 0c             	sub    $0xc,%esp
80106d3f:	68 aa 78 10 80       	push   $0x801078aa
80106d44:	e8 47 96 ff ff       	call   80100390 <panic>
80106d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d50 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	57                   	push   %edi
80106d54:	56                   	push   %esi
80106d55:	53                   	push   %ebx
80106d56:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106d59:	e8 22 ff ff ff       	call   80106c80 <setupkvm>
80106d5e:	85 c0                	test   %eax,%eax
80106d60:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d63:	0f 84 9f 00 00 00    	je     80106e08 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d6c:	85 c9                	test   %ecx,%ecx
80106d6e:	0f 84 94 00 00 00    	je     80106e08 <copyuvm+0xb8>
80106d74:	31 ff                	xor    %edi,%edi
80106d76:	eb 4a                	jmp    80106dc2 <copyuvm+0x72>
80106d78:	90                   	nop
80106d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106d80:	83 ec 04             	sub    $0x4,%esp
80106d83:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106d89:	68 00 10 00 00       	push   $0x1000
80106d8e:	53                   	push   %ebx
80106d8f:	50                   	push   %eax
80106d90:	e8 db d7 ff ff       	call   80104570 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106d95:	58                   	pop    %eax
80106d96:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d9c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106da1:	5a                   	pop    %edx
80106da2:	ff 75 e4             	pushl  -0x1c(%ebp)
80106da5:	50                   	push   %eax
80106da6:	89 fa                	mov    %edi,%edx
80106da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106dab:	e8 c0 f8 ff ff       	call   80106670 <mappages>
80106db0:	83 c4 10             	add    $0x10,%esp
80106db3:	85 c0                	test   %eax,%eax
80106db5:	78 61                	js     80106e18 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106db7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106dbd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106dc0:	76 46                	jbe    80106e08 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106dc2:	8b 45 08             	mov    0x8(%ebp),%eax
80106dc5:	31 c9                	xor    %ecx,%ecx
80106dc7:	89 fa                	mov    %edi,%edx
80106dc9:	e8 22 f8 ff ff       	call   801065f0 <walkpgdir>
80106dce:	85 c0                	test   %eax,%eax
80106dd0:	74 61                	je     80106e33 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106dd2:	8b 00                	mov    (%eax),%eax
80106dd4:	a8 01                	test   $0x1,%al
80106dd6:	74 4e                	je     80106e26 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106dd8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106dda:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80106ddf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80106de5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80106de8:	e8 43 b7 ff ff       	call   80102530 <kalloc>
80106ded:	85 c0                	test   %eax,%eax
80106def:	89 c6                	mov    %eax,%esi
80106df1:	75 8d                	jne    80106d80 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106df3:	83 ec 0c             	sub    $0xc,%esp
80106df6:	ff 75 e0             	pushl  -0x20(%ebp)
80106df9:	e8 02 fe ff ff       	call   80106c00 <freevm>
  return 0;
80106dfe:	83 c4 10             	add    $0x10,%esp
80106e01:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e0e:	5b                   	pop    %ebx
80106e0f:	5e                   	pop    %esi
80106e10:	5f                   	pop    %edi
80106e11:	5d                   	pop    %ebp
80106e12:	c3                   	ret    
80106e13:	90                   	nop
80106e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80106e18:	83 ec 0c             	sub    $0xc,%esp
80106e1b:	56                   	push   %esi
80106e1c:	e8 5f b5 ff ff       	call   80102380 <kfree>
      goto bad;
80106e21:	83 c4 10             	add    $0x10,%esp
80106e24:	eb cd                	jmp    80106df3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80106e26:	83 ec 0c             	sub    $0xc,%esp
80106e29:	68 ce 78 10 80       	push   $0x801078ce
80106e2e:	e8 5d 95 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80106e33:	83 ec 0c             	sub    $0xc,%esp
80106e36:	68 b4 78 10 80       	push   $0x801078b4
80106e3b:	e8 50 95 ff ff       	call   80100390 <panic>

80106e40 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106e40:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e41:	31 c9                	xor    %ecx,%ecx
{
80106e43:	89 e5                	mov    %esp,%ebp
80106e45:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106e48:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e4e:	e8 9d f7 ff ff       	call   801065f0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106e53:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106e55:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106e56:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106e58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106e5d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106e60:	05 00 00 00 80       	add    $0x80000000,%eax
80106e65:	83 fa 05             	cmp    $0x5,%edx
80106e68:	ba 00 00 00 00       	mov    $0x0,%edx
80106e6d:	0f 45 c2             	cmovne %edx,%eax
}
80106e70:	c3                   	ret    
80106e71:	eb 0d                	jmp    80106e80 <copyout>
80106e73:	90                   	nop
80106e74:	90                   	nop
80106e75:	90                   	nop
80106e76:	90                   	nop
80106e77:	90                   	nop
80106e78:	90                   	nop
80106e79:	90                   	nop
80106e7a:	90                   	nop
80106e7b:	90                   	nop
80106e7c:	90                   	nop
80106e7d:	90                   	nop
80106e7e:	90                   	nop
80106e7f:	90                   	nop

80106e80 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	53                   	push   %ebx
80106e86:	83 ec 1c             	sub    $0x1c,%esp
80106e89:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e8f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106e92:	85 db                	test   %ebx,%ebx
80106e94:	75 40                	jne    80106ed6 <copyout+0x56>
80106e96:	eb 70                	jmp    80106f08 <copyout+0x88>
80106e98:	90                   	nop
80106e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ea3:	89 f1                	mov    %esi,%ecx
80106ea5:	29 d1                	sub    %edx,%ecx
80106ea7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106ead:	39 d9                	cmp    %ebx,%ecx
80106eaf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106eb2:	29 f2                	sub    %esi,%edx
80106eb4:	83 ec 04             	sub    $0x4,%esp
80106eb7:	01 d0                	add    %edx,%eax
80106eb9:	51                   	push   %ecx
80106eba:	57                   	push   %edi
80106ebb:	50                   	push   %eax
80106ebc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106ebf:	e8 ac d6 ff ff       	call   80104570 <memmove>
    len -= n;
    buf += n;
80106ec4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80106ec7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80106eca:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80106ed0:	01 cf                	add    %ecx,%edi
  while(len > 0){
80106ed2:	29 cb                	sub    %ecx,%ebx
80106ed4:	74 32                	je     80106f08 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106ed6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106ed8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106edb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106ede:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106ee4:	56                   	push   %esi
80106ee5:	ff 75 08             	pushl  0x8(%ebp)
80106ee8:	e8 53 ff ff ff       	call   80106e40 <uva2ka>
    if(pa0 == 0)
80106eed:	83 c4 10             	add    $0x10,%esp
80106ef0:	85 c0                	test   %eax,%eax
80106ef2:	75 ac                	jne    80106ea0 <copyout+0x20>
  }
  return 0;
}
80106ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ef7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106efc:	5b                   	pop    %ebx
80106efd:	5e                   	pop    %esi
80106efe:	5f                   	pop    %edi
80106eff:	5d                   	pop    %ebp
80106f00:	c3                   	ret    
80106f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f0b:	31 c0                	xor    %eax,%eax
}
80106f0d:	5b                   	pop    %ebx
80106f0e:	5e                   	pop    %esi
80106f0f:	5f                   	pop    %edi
80106f10:	5d                   	pop    %ebp
80106f11:	c3                   	ret    
