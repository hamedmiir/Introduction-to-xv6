
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc 00 b6 10 80       	mov    $0x8010b600,%esp
8010002d:	b8 d0 31 10 80       	mov    $0x801031d0,%eax
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
80100044:	bb 34 b6 10 80       	mov    $0x8010b634,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 71 10 80       	push   $0x801071e0
80100051:	68 00 b6 10 80       	push   $0x8010b600
80100056:	e8 d5 44 00 00       	call   80104530 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 4c fd 10 80 fc 	movl   $0x8010fcfc,0x8010fd4c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 50 fd 10 80 fc 	movl   $0x8010fcfc,0x8010fd50
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba fc fc 10 80       	mov    $0x8010fcfc,%edx
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
8010008b:	c7 43 50 fc fc 10 80 	movl   $0x8010fcfc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 71 10 80       	push   $0x801071e7
80100097:	50                   	push   %eax
80100098:	e8 63 43 00 00       	call   80104400 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 fd 10 80       	mov    0x8010fd50,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 50 fd 10 80    	mov    %ebx,0x8010fd50
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d fc fc 10 80       	cmp    $0x8010fcfc,%eax
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
801000df:	68 00 b6 10 80       	push   $0x8010b600
801000e4:	e8 87 45 00 00       	call   80104670 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 50 fd 10 80    	mov    0x8010fd50,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb fc fc 10 80    	cmp    $0x8010fcfc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc fc 10 80    	cmp    $0x8010fcfc,%ebx
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
80100120:	8b 1d 4c fd 10 80    	mov    0x8010fd4c,%ebx
80100126:	81 fb fc fc 10 80    	cmp    $0x8010fcfc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc fc 10 80    	cmp    $0x8010fcfc,%ebx
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
8010015d:	68 00 b6 10 80       	push   $0x8010b600
80100162:	e8 c9 45 00 00       	call   80104730 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 42 00 00       	call   80104440 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 cd 22 00 00       	call   80102450 <iderw>
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
80100193:	68 ee 71 10 80       	push   $0x801071ee
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
801001ae:	e8 2d 43 00 00       	call   801044e0 <holdingsleep>
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
801001c4:	e9 87 22 00 00       	jmp    80102450 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 71 10 80       	push   $0x801071ff
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
801001ef:	e8 ec 42 00 00       	call   801044e0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 9c 42 00 00       	call   801044a0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010020b:	e8 60 44 00 00       	call   80104670 <acquire>
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
80100232:	a1 50 fd 10 80       	mov    0x8010fd50,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 fc fc 10 80 	movl   $0x8010fcfc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 50 fd 10 80       	mov    0x8010fd50,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 50 fd 10 80    	mov    %ebx,0x8010fd50
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 00 b6 10 80 	movl   $0x8010b600,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 cf 44 00 00       	jmp    80104730 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 72 10 80       	push   $0x80107206
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
80100280:	e8 0b 18 00 00       	call   80101a90 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
8010028c:	e8 df 43 00 00       	call   80104670 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 e0 ff 10 80    	mov    0x8010ffe0,%edx
801002a7:	39 15 e4 ff 10 80    	cmp    %edx,0x8010ffe4
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
801002bb:	68 60 a5 10 80       	push   $0x8010a560
801002c0:	68 e0 ff 10 80       	push   $0x8010ffe0
801002c5:	e8 e6 3d 00 00       	call   801040b0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 ff 10 80    	mov    0x8010ffe0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 ff 10 80    	cmp    0x8010ffe4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 30 38 00 00       	call   80103b10 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 60 a5 10 80       	push   $0x8010a560
801002ef:	e8 3c 44 00 00       	call   80104730 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 b4 16 00 00       	call   801019b0 <ilock>
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
80100313:	a3 e0 ff 10 80       	mov    %eax,0x8010ffe0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 60 ff 10 80 	movsbl -0x7fef00a0(%eax),%eax
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
80100348:	68 60 a5 10 80       	push   $0x8010a560
8010034d:	e8 de 43 00 00       	call   80104730 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 56 16 00 00       	call   801019b0 <ilock>
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
80100372:	89 15 e0 ff 10 80    	mov    %edx,0x8010ffe0
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
80100399:	c7 05 94 a5 10 80 00 	movl   $0x0,0x8010a594
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 b2 26 00 00       	call   80102a60 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 0d 72 10 80       	push   $0x8010720d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 57 7b 10 80 	movl   $0x80107b57,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 73 41 00 00       	call   80104550 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 72 10 80       	push   $0x80107221
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 98 a5 10 80 01 	movl   $0x1,0x8010a598
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 98 a5 10 80    	mov    0x8010a598,%ecx
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
8010043a:	e8 b1 59 00 00       	call   80105df0 <uartputc>
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
801004ec:	e8 ff 58 00 00       	call   80105df0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 f3 58 00 00       	call   80105df0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 e7 58 00 00       	call   80105df0 <uartputc>
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
80100524:	e8 07 43 00 00       	call   80104830 <memmove>
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
80100541:	e8 3a 42 00 00       	call   80104780 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 25 72 10 80       	push   $0x80107225
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
801005b1:	0f b6 92 50 72 10 80 	movzbl -0x7fef8db0(%edx),%edx
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
8010060f:	e8 7c 14 00 00       	call   80101a90 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
8010061b:	e8 50 40 00 00       	call   80104670 <acquire>
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
80100642:	68 60 a5 10 80       	push   $0x8010a560
80100647:	e8 e4 40 00 00       	call   80104730 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 5b 13 00 00       	call   801019b0 <ilock>

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
80100669:	a1 94 a5 10 80       	mov    0x8010a594,%eax
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
8010071a:	68 60 a5 10 80       	push   $0x8010a560
8010071f:	e8 0c 40 00 00       	call   80104730 <release>
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
801007d0:	ba 38 72 10 80       	mov    $0x80107238,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 60 a5 10 80       	push   $0x8010a560
801007f0:	e8 7b 3e 00 00       	call   80104670 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 3f 72 10 80       	push   $0x8010723f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <InsertNewCmd>:
{
80100810:	55                   	push   %ebp
    int i = input.w , temp_cur = history.cmd_count % 5;
80100811:	ba 67 66 66 66       	mov    $0x66666667,%edx
{
80100816:	89 e5                	mov    %esp,%ebp
80100818:	57                   	push   %edi
80100819:	56                   	push   %esi
8010081a:	53                   	push   %ebx
8010081b:	83 ec 10             	sub    $0x10,%esp
    int i = input.w , temp_cur = history.cmd_count % 5;
8010081e:	8b 35 34 a5 10 80    	mov    0x8010a534,%esi
80100824:	8b 1d e4 ff 10 80    	mov    0x8010ffe4,%ebx
    memset(temp_buf[temp_cur] ,'\0' ,INPUT_BUF * sizeof(char));
8010082a:	68 80 00 00 00       	push   $0x80
8010082f:	6a 00                	push   $0x0
    int i = input.w , temp_cur = history.cmd_count % 5;
80100831:	89 f0                	mov    %esi,%eax
80100833:	f7 ea                	imul   %edx
80100835:	89 f0                	mov    %esi,%eax
80100837:	c1 f8 1f             	sar    $0x1f,%eax
8010083a:	d1 fa                	sar    %edx
8010083c:	29 c2                	sub    %eax,%edx
8010083e:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100841:	29 c6                	sub    %eax,%esi
80100843:	c1 e6 07             	shl    $0x7,%esi
    memset(temp_buf[temp_cur] ,'\0' ,INPUT_BUF * sizeof(char));
80100846:	8d be 00 00 11 80    	lea    -0x7fef0000(%esi),%edi
8010084c:	57                   	push   %edi
8010084d:	e8 2e 3f 00 00       	call   80104780 <memset>
    while( i != ((input.e - 1)%INPUT_BUF)){
80100852:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100857:	83 c4 10             	add    $0x10,%esp
    int j = 0;
8010085a:	31 d2                	xor    %edx,%edx
    while( i != ((input.e - 1)%INPUT_BUF)){
8010085c:	8d 48 ff             	lea    -0x1(%eax),%ecx
8010085f:	83 e1 7f             	and    $0x7f,%ecx
80100862:	39 cb                	cmp    %ecx,%ebx
80100864:	74 31                	je     80100897 <InsertNewCmd+0x87>
80100866:	8d 76 00             	lea    0x0(%esi),%esi
80100869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                  temp_buf[temp_cur][j] = input.buf[i];
80100870:	0f b6 83 60 ff 10 80 	movzbl -0x7fef00a0(%ebx),%eax
                  i = (i + 1) % INPUT_BUF;
80100877:	83 c3 01             	add    $0x1,%ebx
                  temp_buf[temp_cur][j] = input.buf[i];
8010087a:	88 84 16 00 00 11 80 	mov    %al,-0x7fef0000(%esi,%edx,1)
                  i = (i + 1) % INPUT_BUF;
80100881:	89 d8                	mov    %ebx,%eax
                  j++;
80100883:	83 c2 01             	add    $0x1,%edx
                  i = (i + 1) % INPUT_BUF;
80100886:	c1 f8 1f             	sar    $0x1f,%eax
80100889:	c1 e8 19             	shr    $0x19,%eax
8010088c:	01 c3                	add    %eax,%ebx
8010088e:	83 e3 7f             	and    $0x7f,%ebx
80100891:	29 c3                	sub    %eax,%ebx
    while( i != ((input.e - 1)%INPUT_BUF)){
80100893:	39 cb                	cmp    %ecx,%ebx
80100895:	75 d9                	jne    80100870 <InsertNewCmd+0x60>
80100897:	b8 20 a5 10 80       	mov    $0x8010a520,%eax
      history.PervCmd[i] = history.PervCmd[i-1];
8010089c:	8b 48 0c             	mov    0xc(%eax),%ecx
8010089f:	83 e8 04             	sub    $0x4,%eax
801008a2:	89 48 14             	mov    %ecx,0x14(%eax)
      history.size[i] = history.size[i-1];
801008a5:	8b 48 2c             	mov    0x2c(%eax),%ecx
801008a8:	89 48 30             	mov    %ecx,0x30(%eax)
    for(int i = 4 ; i > 0 ; i--){
801008ab:	3d 10 a5 10 80       	cmp    $0x8010a510,%eax
801008b0:	75 ea                	jne    8010089c <InsertNewCmd+0x8c>
    history.PervCmd[0] = temp_buf[temp_cur];
801008b2:	89 3d 20 a5 10 80    	mov    %edi,0x8010a520
    history.size[0] = j;
801008b8:	89 15 3c a5 10 80    	mov    %edx,0x8010a53c
}
801008be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008c1:	5b                   	pop    %ebx
801008c2:	5e                   	pop    %esi
801008c3:	5f                   	pop    %edi
801008c4:	5d                   	pop    %ebp
801008c5:	c3                   	ret    
801008c6:	8d 76 00             	lea    0x0(%esi),%esi
801008c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801008d0 <killLine>:
  while(input.e != input.w &&
801008d0:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
801008d5:	3b 05 e4 ff 10 80    	cmp    0x8010ffe4,%eax
801008db:	74 53                	je     80100930 <killLine+0x60>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008dd:	83 e8 01             	sub    $0x1,%eax
801008e0:	89 c2                	mov    %eax,%edx
801008e2:	83 e2 7f             	and    $0x7f,%edx
  while(input.e != input.w &&
801008e5:	80 ba 60 ff 10 80 0a 	cmpb   $0xa,-0x7fef00a0(%edx)
801008ec:	74 42                	je     80100930 <killLine+0x60>
{
801008ee:	55                   	push   %ebp
801008ef:	89 e5                	mov    %esp,%ebp
801008f1:	83 ec 08             	sub    $0x8,%esp
801008f4:	eb 1b                	jmp    80100911 <killLine+0x41>
801008f6:	8d 76 00             	lea    0x0(%esi),%esi
801008f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100900:	83 e8 01             	sub    $0x1,%eax
80100903:	89 c2                	mov    %eax,%edx
80100905:	83 e2 7f             	and    $0x7f,%edx
  while(input.e != input.w &&
80100908:	80 ba 60 ff 10 80 0a 	cmpb   $0xa,-0x7fef00a0(%edx)
8010090f:	74 1c                	je     8010092d <killLine+0x5d>
        input.e--;
80100911:	a3 e8 ff 10 80       	mov    %eax,0x8010ffe8
        consputc(BACKSPACE);
80100916:	b8 00 01 00 00       	mov    $0x100,%eax
8010091b:	e8 f0 fa ff ff       	call   80100410 <consputc>
  while(input.e != input.w &&
80100920:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100925:	3b 05 e4 ff 10 80    	cmp    0x8010ffe4,%eax
8010092b:	75 d3                	jne    80100900 <killLine+0x30>
}
8010092d:	c9                   	leave  
8010092e:	c3                   	ret    
8010092f:	90                   	nop
80100930:	f3 c3                	repz ret 
80100932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100940 <fillBuf>:
{
80100940:	55                   	push   %ebp
80100941:	89 e5                	mov    %esp,%ebp
80100943:	56                   	push   %esi
80100944:	53                   	push   %ebx
  killLine();
80100945:	e8 86 ff ff ff       	call   801008d0 <killLine>
  for(int i = 0; i < history.size[history.cursor] ; i++)
8010094a:	a1 38 a5 10 80       	mov    0x8010a538,%eax
8010094f:	8b 1c 85 3c a5 10 80 	mov    -0x7fef5ac4(,%eax,4),%ebx
80100956:	85 db                	test   %ebx,%ebx
80100958:	7e 32                	jle    8010098c <fillBuf+0x4c>
    input.buf[input.e++ % INPUT_BUF] = history.PervCmd[history.cursor][i];
8010095a:	8b 34 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%esi
80100961:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100966:	01 c3                	add    %eax,%ebx
80100968:	29 c6                	sub    %eax,%esi
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100970:	8d 50 01             	lea    0x1(%eax),%edx
80100973:	89 15 e8 ff 10 80    	mov    %edx,0x8010ffe8
80100979:	0f b6 0c 30          	movzbl (%eax,%esi,1),%ecx
8010097d:	83 e0 7f             	and    $0x7f,%eax
  for(int i = 0; i < history.size[history.cursor] ; i++)
80100980:	39 da                	cmp    %ebx,%edx
    input.buf[input.e++ % INPUT_BUF] = history.PervCmd[history.cursor][i];
80100982:	88 88 60 ff 10 80    	mov    %cl,-0x7fef00a0(%eax)
80100988:	89 d0                	mov    %edx,%eax
  for(int i = 0; i < history.size[history.cursor] ; i++)
8010098a:	75 e4                	jne    80100970 <fillBuf+0x30>
}
8010098c:	5b                   	pop    %ebx
8010098d:	5e                   	pop    %esi
8010098e:	5d                   	pop    %ebp
8010098f:	c3                   	ret    

80100990 <IncCursor>:
  if (history.cursor == 4)
80100990:	8b 0d 38 a5 10 80    	mov    0x8010a538,%ecx
{
80100996:	55                   	push   %ebp
80100997:	89 e5                	mov    %esp,%ebp
  if (history.cursor == 4)
80100999:	83 f9 04             	cmp    $0x4,%ecx
8010099c:	74 2a                	je     801009c8 <IncCursor+0x38>
  history.cursor = (history.cursor + 1) % 5;
8010099e:	83 c1 01             	add    $0x1,%ecx
801009a1:	ba 67 66 66 66       	mov    $0x66666667,%edx
801009a6:	89 c8                	mov    %ecx,%eax
801009a8:	f7 ea                	imul   %edx
801009aa:	89 c8                	mov    %ecx,%eax
801009ac:	c1 f8 1f             	sar    $0x1f,%eax
801009af:	d1 fa                	sar    %edx
801009b1:	29 c2                	sub    %eax,%edx
801009b3:	8d 04 92             	lea    (%edx,%edx,4),%eax
801009b6:	29 c1                	sub    %eax,%ecx
      if ( history.cursor == history.cmd_count) 
801009b8:	3b 0d 34 a5 10 80    	cmp    0x8010a534,%ecx
  history.cursor = (history.cursor + 1) % 5;
801009be:	89 ca                	mov    %ecx,%edx
801009c0:	89 0d 38 a5 10 80    	mov    %ecx,0x8010a538
      if ( history.cursor == history.cmd_count) 
801009c6:	74 08                	je     801009d0 <IncCursor+0x40>
}
801009c8:	5d                   	pop    %ebp
801009c9:	c3                   	ret    
801009ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        history.cursor = history.cmd_count - 1;
801009d0:	83 ea 01             	sub    $0x1,%edx
801009d3:	89 15 38 a5 10 80    	mov    %edx,0x8010a538
}
801009d9:	5d                   	pop    %ebp
801009da:	c3                   	ret    
801009db:	90                   	nop
801009dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009e0 <DecCursor>:
  if ( history.cursor <= 0){
801009e0:	8b 15 38 a5 10 80    	mov    0x8010a538,%edx
{
801009e6:	55                   	push   %ebp
      history.cursor = 0;
801009e7:	b8 00 00 00 00       	mov    $0x0,%eax
{
801009ec:	89 e5                	mov    %esp,%ebp
      history.cursor = 0;
801009ee:	8d 4a ff             	lea    -0x1(%edx),%ecx
801009f1:	85 d2                	test   %edx,%edx
}
801009f3:	5d                   	pop    %ebp
      history.cursor = 0;
801009f4:	0f 4f c1             	cmovg  %ecx,%eax
801009f7:	a3 38 a5 10 80       	mov    %eax,0x8010a538
}
801009fc:	c3                   	ret    
801009fd:	8d 76 00             	lea    0x0(%esi),%esi

80100a00 <printInput>:
{
80100a00:	55                   	push   %ebp
80100a01:	89 e5                	mov    %esp,%ebp
80100a03:	53                   	push   %ebx
80100a04:	83 ec 04             	sub    $0x4,%esp
  while( i != (input.e % INPUT_BUF)){ 
80100a07:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
  int i = input.w;
80100a0c:	8b 1d e4 ff 10 80    	mov    0x8010ffe4,%ebx
  while( i != (input.e % INPUT_BUF)){ 
80100a12:	83 e0 7f             	and    $0x7f,%eax
80100a15:	39 c3                	cmp    %eax,%ebx
80100a17:	74 31                	je     80100a4a <printInput+0x4a>
80100a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(input.buf[i]);
80100a20:	0f be 83 60 ff 10 80 	movsbl -0x7fef00a0(%ebx),%eax
    i = (i + 1) % INPUT_BUF;
80100a27:	83 c3 01             	add    $0x1,%ebx
    consputc(input.buf[i]);
80100a2a:	e8 e1 f9 ff ff       	call   80100410 <consputc>
    i = (i + 1) % INPUT_BUF;
80100a2f:	89 d8                	mov    %ebx,%eax
80100a31:	c1 f8 1f             	sar    $0x1f,%eax
80100a34:	c1 e8 19             	shr    $0x19,%eax
80100a37:	01 c3                	add    %eax,%ebx
80100a39:	83 e3 7f             	and    $0x7f,%ebx
80100a3c:	29 c3                	sub    %eax,%ebx
  while( i != (input.e % INPUT_BUF)){ 
80100a3e:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100a43:	83 e0 7f             	and    $0x7f,%eax
80100a46:	39 d8                	cmp    %ebx,%eax
80100a48:	75 d6                	jne    80100a20 <printInput+0x20>
}
80100a4a:	83 c4 04             	add    $0x4,%esp
80100a4d:	5b                   	pop    %ebx
80100a4e:	5d                   	pop    %ebp
80100a4f:	c3                   	ret    

80100a50 <KeyDownPressed.part.0>:
KeyDownPressed()
80100a50:	55                   	push   %ebp
      history.cursor = 0;
80100a51:	b8 00 00 00 00       	mov    $0x0,%eax
KeyDownPressed()
80100a56:	89 e5                	mov    %esp,%ebp
80100a58:	83 ec 08             	sub    $0x8,%esp
  if ( history.cursor <= 0){
80100a5b:	8b 15 38 a5 10 80    	mov    0x8010a538,%edx
      history.cursor = 0;
80100a61:	8d 4a ff             	lea    -0x1(%edx),%ecx
80100a64:	85 d2                	test   %edx,%edx
80100a66:	0f 4f c1             	cmovg  %ecx,%eax
80100a69:	a3 38 a5 10 80       	mov    %eax,0x8010a538
  fillBuf();
80100a6e:	e8 cd fe ff ff       	call   80100940 <fillBuf>
}
80100a73:	c9                   	leave  
  printInput();
80100a74:	eb 8a                	jmp    80100a00 <printInput>
80100a76:	8d 76 00             	lea    0x0(%esi),%esi
80100a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100a80 <KeyUpPressed>:
{
80100a80:	55                   	push   %ebp
80100a81:	89 e5                	mov    %esp,%ebp
80100a83:	53                   	push   %ebx
80100a84:	83 ec 04             	sub    $0x4,%esp
  if ( history.cmd_count == 0) 
80100a87:	8b 1d 34 a5 10 80    	mov    0x8010a534,%ebx
80100a8d:	85 db                	test   %ebx,%ebx
80100a8f:	74 47                	je     80100ad8 <KeyUpPressed+0x58>
  if (history.cursor == 4)
80100a91:	8b 0d 38 a5 10 80    	mov    0x8010a538,%ecx
80100a97:	83 f9 04             	cmp    $0x4,%ecx
80100a9a:	74 2a                	je     80100ac6 <KeyUpPressed+0x46>
  history.cursor = (history.cursor + 1) % 5;
80100a9c:	83 c1 01             	add    $0x1,%ecx
80100a9f:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100aa4:	89 c8                	mov    %ecx,%eax
80100aa6:	f7 ea                	imul   %edx
80100aa8:	89 c8                	mov    %ecx,%eax
80100aaa:	c1 f8 1f             	sar    $0x1f,%eax
80100aad:	d1 fa                	sar    %edx
80100aaf:	29 c2                	sub    %eax,%edx
80100ab1:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100ab4:	29 c1                	sub    %eax,%ecx
80100ab6:	8d 43 ff             	lea    -0x1(%ebx),%eax
80100ab9:	89 ca                	mov    %ecx,%edx
80100abb:	39 cb                	cmp    %ecx,%ebx
80100abd:	0f 44 d0             	cmove  %eax,%edx
80100ac0:	89 15 38 a5 10 80    	mov    %edx,0x8010a538
  fillBuf();
80100ac6:	e8 75 fe ff ff       	call   80100940 <fillBuf>
}
80100acb:	83 c4 04             	add    $0x4,%esp
80100ace:	5b                   	pop    %ebx
80100acf:	5d                   	pop    %ebp
  printInput();
80100ad0:	e9 2b ff ff ff       	jmp    80100a00 <printInput>
80100ad5:	8d 76 00             	lea    0x0(%esi),%esi
}
80100ad8:	83 c4 04             	add    $0x4,%esp
80100adb:	5b                   	pop    %ebx
80100adc:	5d                   	pop    %ebp
80100add:	c3                   	ret    
80100ade:	66 90                	xchg   %ax,%ax

80100ae0 <KeyDownPressed>:
  if ( history.cmd_count == 0) 
80100ae0:	a1 34 a5 10 80       	mov    0x8010a534,%eax
{
80100ae5:	55                   	push   %ebp
80100ae6:	89 e5                	mov    %esp,%ebp
  if ( history.cmd_count == 0) 
80100ae8:	85 c0                	test   %eax,%eax
80100aea:	74 0c                	je     80100af8 <KeyDownPressed+0x18>
}
80100aec:	5d                   	pop    %ebp
80100aed:	e9 5e ff ff ff       	jmp    80100a50 <KeyDownPressed.part.0>
80100af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100af8:	5d                   	pop    %ebp
80100af9:	c3                   	ret    
80100afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b00 <consoleintr>:
{
80100b00:	55                   	push   %ebp
80100b01:	89 e5                	mov    %esp,%ebp
80100b03:	57                   	push   %edi
80100b04:	56                   	push   %esi
80100b05:	53                   	push   %ebx
  int c, doprocdump = 0;
80100b06:	31 ff                	xor    %edi,%edi
{
80100b08:	83 ec 18             	sub    $0x18,%esp
80100b0b:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
80100b0e:	68 60 a5 10 80       	push   $0x8010a560
80100b13:	e8 58 3b 00 00       	call   80104670 <acquire>
  while((c = getc()) >= 0){
80100b18:	83 c4 10             	add    $0x10,%esp
80100b1b:	90                   	nop
80100b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b20:	ff d6                	call   *%esi
80100b22:	85 c0                	test   %eax,%eax
80100b24:	89 c3                	mov    %eax,%ebx
80100b26:	0f 88 b4 00 00 00    	js     80100be0 <consoleintr+0xe0>
    switch(c){
80100b2c:	83 fb 15             	cmp    $0x15,%ebx
80100b2f:	0f 84 cb 00 00 00    	je     80100c00 <consoleintr+0x100>
80100b35:	0f 8e 85 00 00 00    	jle    80100bc0 <consoleintr+0xc0>
80100b3b:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
80100b41:	0f 84 19 01 00 00    	je     80100c60 <consoleintr+0x160>
80100b47:	81 fb e3 00 00 00    	cmp    $0xe3,%ebx
80100b4d:	0f 84 ed 00 00 00    	je     80100c40 <consoleintr+0x140>
80100b53:	83 fb 7f             	cmp    $0x7f,%ebx
80100b56:	0f 84 b4 00 00 00    	je     80100c10 <consoleintr+0x110>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100b5c:	85 db                	test   %ebx,%ebx
80100b5e:	74 c0                	je     80100b20 <consoleintr+0x20>
80100b60:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100b65:	89 c2                	mov    %eax,%edx
80100b67:	2b 15 e0 ff 10 80    	sub    0x8010ffe0,%edx
80100b6d:	83 fa 7f             	cmp    $0x7f,%edx
80100b70:	77 ae                	ja     80100b20 <consoleintr+0x20>
80100b72:	8d 50 01             	lea    0x1(%eax),%edx
80100b75:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100b78:	83 fb 0d             	cmp    $0xd,%ebx
        input.buf[input.e++ % INPUT_BUF] = c;
80100b7b:	89 15 e8 ff 10 80    	mov    %edx,0x8010ffe8
        c = (c == '\r') ? '\n' : c;
80100b81:	0f 84 f9 00 00 00    	je     80100c80 <consoleintr+0x180>
        input.buf[input.e++ % INPUT_BUF] = c;
80100b87:	88 98 60 ff 10 80    	mov    %bl,-0x7fef00a0(%eax)
        consputc(c);
80100b8d:	89 d8                	mov    %ebx,%eax
80100b8f:	e8 7c f8 ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100b94:	83 fb 0a             	cmp    $0xa,%ebx
80100b97:	0f 84 f4 00 00 00    	je     80100c91 <consoleintr+0x191>
80100b9d:	83 fb 04             	cmp    $0x4,%ebx
80100ba0:	0f 84 eb 00 00 00    	je     80100c91 <consoleintr+0x191>
80100ba6:	a1 e0 ff 10 80       	mov    0x8010ffe0,%eax
80100bab:	83 e8 80             	sub    $0xffffff80,%eax
80100bae:	39 05 e8 ff 10 80    	cmp    %eax,0x8010ffe8
80100bb4:	0f 85 66 ff ff ff    	jne    80100b20 <consoleintr+0x20>
80100bba:	e9 d7 00 00 00       	jmp    80100c96 <consoleintr+0x196>
80100bbf:	90                   	nop
    switch(c){
80100bc0:	83 fb 08             	cmp    $0x8,%ebx
80100bc3:	74 4b                	je     80100c10 <consoleintr+0x110>
80100bc5:	83 fb 10             	cmp    $0x10,%ebx
80100bc8:	75 92                	jne    80100b5c <consoleintr+0x5c>
  while((c = getc()) >= 0){
80100bca:	ff d6                	call   *%esi
80100bcc:	85 c0                	test   %eax,%eax
      doprocdump = 1;
80100bce:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
80100bd3:	89 c3                	mov    %eax,%ebx
80100bd5:	0f 89 51 ff ff ff    	jns    80100b2c <consoleintr+0x2c>
80100bdb:	90                   	nop
80100bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100be0:	83 ec 0c             	sub    $0xc,%esp
80100be3:	68 60 a5 10 80       	push   $0x8010a560
80100be8:	e8 43 3b 00 00       	call   80104730 <release>
  if(doprocdump) {
80100bed:	83 c4 10             	add    $0x10,%esp
80100bf0:	85 ff                	test   %edi,%edi
80100bf2:	75 7c                	jne    80100c70 <consoleintr+0x170>
}
80100bf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100bf7:	5b                   	pop    %ebx
80100bf8:	5e                   	pop    %esi
80100bf9:	5f                   	pop    %edi
80100bfa:	5d                   	pop    %ebp
80100bfb:	c3                   	ret    
80100bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      killLine();
80100c00:	e8 cb fc ff ff       	call   801008d0 <killLine>
      break;
80100c05:	e9 16 ff ff ff       	jmp    80100b20 <consoleintr+0x20>
80100c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
80100c10:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100c15:	3b 05 e4 ff 10 80    	cmp    0x8010ffe4,%eax
80100c1b:	0f 84 ff fe ff ff    	je     80100b20 <consoleintr+0x20>
        input.e--;
80100c21:	83 e8 01             	sub    $0x1,%eax
80100c24:	a3 e8 ff 10 80       	mov    %eax,0x8010ffe8
        consputc(BACKSPACE);
80100c29:	b8 00 01 00 00       	mov    $0x100,%eax
80100c2e:	e8 dd f7 ff ff       	call   80100410 <consputc>
80100c33:	e9 e8 fe ff ff       	jmp    80100b20 <consoleintr+0x20>
80100c38:	90                   	nop
80100c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if ( history.cmd_count == 0) 
80100c40:	a1 34 a5 10 80       	mov    0x8010a534,%eax
80100c45:	85 c0                	test   %eax,%eax
80100c47:	0f 84 d3 fe ff ff    	je     80100b20 <consoleintr+0x20>
80100c4d:	e8 fe fd ff ff       	call   80100a50 <KeyDownPressed.part.0>
80100c52:	e9 c9 fe ff ff       	jmp    80100b20 <consoleintr+0x20>
80100c57:	89 f6                	mov    %esi,%esi
80100c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      KeyUpPressed();
80100c60:	e8 1b fe ff ff       	call   80100a80 <KeyUpPressed>
      break;
80100c65:	e9 b6 fe ff ff       	jmp    80100b20 <consoleintr+0x20>
80100c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c73:	5b                   	pop    %ebx
80100c74:	5e                   	pop    %esi
80100c75:	5f                   	pop    %edi
80100c76:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100c77:	e9 c4 36 00 00       	jmp    80104340 <procdump>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100c80:	c6 80 60 ff 10 80 0a 	movb   $0xa,-0x7fef00a0(%eax)
        consputc(c);
80100c87:	b8 0a 00 00 00       	mov    $0xa,%eax
80100c8c:	e8 7f f7 ff ff       	call   80100410 <consputc>
80100c91:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
          if ( (input.e - input.w) != 1) {
80100c96:	89 c2                	mov    %eax,%edx
80100c98:	2b 15 e4 ff 10 80    	sub    0x8010ffe4,%edx
80100c9e:	83 fa 01             	cmp    $0x1,%edx
80100ca1:	74 1b                	je     80100cbe <consoleintr+0x1be>
            InsertNewCmd();
80100ca3:	e8 68 fb ff ff       	call   80100810 <InsertNewCmd>
            history.cmd_count++;
80100ca8:	83 05 34 a5 10 80 01 	addl   $0x1,0x8010a534
80100caf:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
            history.cursor = -1;
80100cb4:	c7 05 38 a5 10 80 ff 	movl   $0xffffffff,0x8010a538
80100cbb:	ff ff ff 
          wakeup(&input.r);
80100cbe:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100cc1:	a3 e4 ff 10 80       	mov    %eax,0x8010ffe4
          wakeup(&input.r);
80100cc6:	68 e0 ff 10 80       	push   $0x8010ffe0
80100ccb:	e8 90 35 00 00       	call   80104260 <wakeup>
80100cd0:	83 c4 10             	add    $0x10,%esp
80100cd3:	e9 48 fe ff ff       	jmp    80100b20 <consoleintr+0x20>
80100cd8:	90                   	nop
80100cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ce0 <consoleinit>:

void
consoleinit(void)
{
80100ce0:	55                   	push   %ebp
80100ce1:	89 e5                	mov    %esp,%ebp
80100ce3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ce6:	68 48 72 10 80       	push   $0x80107248
80100ceb:	68 60 a5 10 80       	push   $0x8010a560
80100cf0:	e8 3b 38 00 00       	call   80104530 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100cf5:	58                   	pop    %eax
80100cf6:	5a                   	pop    %edx
80100cf7:	6a 00                	push   $0x0
80100cf9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100cfb:	c7 05 2c 0c 11 80 00 	movl   $0x80100600,0x80110c2c
80100d02:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100d05:	c7 05 28 0c 11 80 70 	movl   $0x80100270,0x80110c28
80100d0c:	02 10 80 
  cons.locking = 1;
80100d0f:	c7 05 94 a5 10 80 01 	movl   $0x1,0x8010a594
80100d16:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100d19:	e8 e2 18 00 00       	call   80102600 <ioapicenable>
}
80100d1e:	83 c4 10             	add    $0x10,%esp
80100d21:	c9                   	leave  
80100d22:	c3                   	ret    
80100d23:	66 90                	xchg   %ax,%ax
80100d25:	66 90                	xchg   %ax,%ax
80100d27:	66 90                	xchg   %ax,%ax
80100d29:	66 90                	xchg   %ax,%ax
80100d2b:	66 90                	xchg   %ax,%ax
80100d2d:	66 90                	xchg   %ax,%ax
80100d2f:	90                   	nop

80100d30 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100d30:	55                   	push   %ebp
80100d31:	89 e5                	mov    %esp,%ebp
80100d33:	57                   	push   %edi
80100d34:	56                   	push   %esi
80100d35:	53                   	push   %ebx
80100d36:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100d3c:	e8 cf 2d 00 00       	call   80103b10 <myproc>
80100d41:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100d47:	e8 84 21 00 00       	call   80102ed0 <begin_op>

  if((ip = namei(path)) == 0){
80100d4c:	83 ec 0c             	sub    $0xc,%esp
80100d4f:	ff 75 08             	pushl  0x8(%ebp)
80100d52:	e8 b9 14 00 00       	call   80102210 <namei>
80100d57:	83 c4 10             	add    $0x10,%esp
80100d5a:	85 c0                	test   %eax,%eax
80100d5c:	0f 84 91 01 00 00    	je     80100ef3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100d62:	83 ec 0c             	sub    $0xc,%esp
80100d65:	89 c3                	mov    %eax,%ebx
80100d67:	50                   	push   %eax
80100d68:	e8 43 0c 00 00       	call   801019b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100d6d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100d73:	6a 34                	push   $0x34
80100d75:	6a 00                	push   $0x0
80100d77:	50                   	push   %eax
80100d78:	53                   	push   %ebx
80100d79:	e8 12 0f 00 00       	call   80101c90 <readi>
80100d7e:	83 c4 20             	add    $0x20,%esp
80100d81:	83 f8 34             	cmp    $0x34,%eax
80100d84:	74 22                	je     80100da8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100d86:	83 ec 0c             	sub    $0xc,%esp
80100d89:	53                   	push   %ebx
80100d8a:	e8 b1 0e 00 00       	call   80101c40 <iunlockput>
    end_op();
80100d8f:	e8 ac 21 00 00       	call   80102f40 <end_op>
80100d94:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100d97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d9f:	5b                   	pop    %ebx
80100da0:	5e                   	pop    %esi
80100da1:	5f                   	pop    %edi
80100da2:	5d                   	pop    %ebp
80100da3:	c3                   	ret    
80100da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100da8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100daf:	45 4c 46 
80100db2:	75 d2                	jne    80100d86 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100db4:	e8 87 61 00 00       	call   80106f40 <setupkvm>
80100db9:	85 c0                	test   %eax,%eax
80100dbb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100dc1:	74 c3                	je     80100d86 <exec+0x56>
  sz = 0;
80100dc3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dc5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100dcc:	00 
80100dcd:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100dd3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100dd9:	0f 84 8c 02 00 00    	je     8010106b <exec+0x33b>
80100ddf:	31 f6                	xor    %esi,%esi
80100de1:	eb 7f                	jmp    80100e62 <exec+0x132>
80100de3:	90                   	nop
80100de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100de8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100def:	75 63                	jne    80100e54 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100df1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100df7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100dfd:	0f 82 86 00 00 00    	jb     80100e89 <exec+0x159>
80100e03:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100e09:	72 7e                	jb     80100e89 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100e0b:	83 ec 04             	sub    $0x4,%esp
80100e0e:	50                   	push   %eax
80100e0f:	57                   	push   %edi
80100e10:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100e16:	e8 45 5f 00 00       	call   80106d60 <allocuvm>
80100e1b:	83 c4 10             	add    $0x10,%esp
80100e1e:	85 c0                	test   %eax,%eax
80100e20:	89 c7                	mov    %eax,%edi
80100e22:	74 65                	je     80100e89 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100e24:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100e2a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100e2f:	75 58                	jne    80100e89 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100e31:	83 ec 0c             	sub    $0xc,%esp
80100e34:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100e3a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100e40:	53                   	push   %ebx
80100e41:	50                   	push   %eax
80100e42:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100e48:	e8 53 5e 00 00       	call   80106ca0 <loaduvm>
80100e4d:	83 c4 20             	add    $0x20,%esp
80100e50:	85 c0                	test   %eax,%eax
80100e52:	78 35                	js     80100e89 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e54:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100e5b:	83 c6 01             	add    $0x1,%esi
80100e5e:	39 f0                	cmp    %esi,%eax
80100e60:	7e 3d                	jle    80100e9f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100e62:	89 f0                	mov    %esi,%eax
80100e64:	6a 20                	push   $0x20
80100e66:	c1 e0 05             	shl    $0x5,%eax
80100e69:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100e6f:	50                   	push   %eax
80100e70:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100e76:	50                   	push   %eax
80100e77:	53                   	push   %ebx
80100e78:	e8 13 0e 00 00       	call   80101c90 <readi>
80100e7d:	83 c4 10             	add    $0x10,%esp
80100e80:	83 f8 20             	cmp    $0x20,%eax
80100e83:	0f 84 5f ff ff ff    	je     80100de8 <exec+0xb8>
    freevm(pgdir);
80100e89:	83 ec 0c             	sub    $0xc,%esp
80100e8c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100e92:	e8 29 60 00 00       	call   80106ec0 <freevm>
80100e97:	83 c4 10             	add    $0x10,%esp
80100e9a:	e9 e7 fe ff ff       	jmp    80100d86 <exec+0x56>
80100e9f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100ea5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100eab:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100eb1:	83 ec 0c             	sub    $0xc,%esp
80100eb4:	53                   	push   %ebx
80100eb5:	e8 86 0d 00 00       	call   80101c40 <iunlockput>
  end_op();
80100eba:	e8 81 20 00 00       	call   80102f40 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ebf:	83 c4 0c             	add    $0xc,%esp
80100ec2:	56                   	push   %esi
80100ec3:	57                   	push   %edi
80100ec4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100eca:	e8 91 5e 00 00       	call   80106d60 <allocuvm>
80100ecf:	83 c4 10             	add    $0x10,%esp
80100ed2:	85 c0                	test   %eax,%eax
80100ed4:	89 c6                	mov    %eax,%esi
80100ed6:	75 3a                	jne    80100f12 <exec+0x1e2>
    freevm(pgdir);
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ee1:	e8 da 5f 00 00       	call   80106ec0 <freevm>
80100ee6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ee9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100eee:	e9 a9 fe ff ff       	jmp    80100d9c <exec+0x6c>
    end_op();
80100ef3:	e8 48 20 00 00       	call   80102f40 <end_op>
    cprintf("exec: fail\n");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 61 72 10 80       	push   $0x80107261
80100f00:	e8 5b f7 ff ff       	call   80100660 <cprintf>
    return -1;
80100f05:	83 c4 10             	add    $0x10,%esp
80100f08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f0d:	e9 8a fe ff ff       	jmp    80100d9c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f12:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100f18:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100f1b:	31 ff                	xor    %edi,%edi
80100f1d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f1f:	50                   	push   %eax
80100f20:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100f26:	e8 b5 60 00 00       	call   80106fe0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f2e:	83 c4 10             	add    $0x10,%esp
80100f31:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100f37:	8b 00                	mov    (%eax),%eax
80100f39:	85 c0                	test   %eax,%eax
80100f3b:	74 70                	je     80100fad <exec+0x27d>
80100f3d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100f43:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100f49:	eb 0a                	jmp    80100f55 <exec+0x225>
80100f4b:	90                   	nop
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100f50:	83 ff 20             	cmp    $0x20,%edi
80100f53:	74 83                	je     80100ed8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f55:	83 ec 0c             	sub    $0xc,%esp
80100f58:	50                   	push   %eax
80100f59:	e8 42 3a 00 00       	call   801049a0 <strlen>
80100f5e:	f7 d0                	not    %eax
80100f60:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f62:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f65:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f66:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f69:	ff 34 b8             	pushl  (%eax,%edi,4)
80100f6c:	e8 2f 3a 00 00       	call   801049a0 <strlen>
80100f71:	83 c0 01             	add    $0x1,%eax
80100f74:	50                   	push   %eax
80100f75:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f78:	ff 34 b8             	pushl  (%eax,%edi,4)
80100f7b:	53                   	push   %ebx
80100f7c:	56                   	push   %esi
80100f7d:	e8 be 61 00 00       	call   80107140 <copyout>
80100f82:	83 c4 20             	add    $0x20,%esp
80100f85:	85 c0                	test   %eax,%eax
80100f87:	0f 88 4b ff ff ff    	js     80100ed8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100f90:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100f97:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100f9a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100fa0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100fa3:	85 c0                	test   %eax,%eax
80100fa5:	75 a9                	jne    80100f50 <exec+0x220>
80100fa7:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100fad:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100fb4:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100fb6:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100fbd:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100fc1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100fc8:	ff ff ff 
  ustack[1] = argc;
80100fcb:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100fd1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100fd3:	83 c0 0c             	add    $0xc,%eax
80100fd6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100fd8:	50                   	push   %eax
80100fd9:	52                   	push   %edx
80100fda:	53                   	push   %ebx
80100fdb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100fe1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100fe7:	e8 54 61 00 00       	call   80107140 <copyout>
80100fec:	83 c4 10             	add    $0x10,%esp
80100fef:	85 c0                	test   %eax,%eax
80100ff1:	0f 88 e1 fe ff ff    	js     80100ed8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffa:	0f b6 00             	movzbl (%eax),%eax
80100ffd:	84 c0                	test   %al,%al
80100fff:	74 17                	je     80101018 <exec+0x2e8>
80101001:	8b 55 08             	mov    0x8(%ebp),%edx
80101004:	89 d1                	mov    %edx,%ecx
80101006:	83 c1 01             	add    $0x1,%ecx
80101009:	3c 2f                	cmp    $0x2f,%al
8010100b:	0f b6 01             	movzbl (%ecx),%eax
8010100e:	0f 44 d1             	cmove  %ecx,%edx
80101011:	84 c0                	test   %al,%al
80101013:	75 f1                	jne    80101006 <exec+0x2d6>
80101015:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101018:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
8010101e:	50                   	push   %eax
8010101f:	6a 10                	push   $0x10
80101021:	ff 75 08             	pushl  0x8(%ebp)
80101024:	89 f8                	mov    %edi,%eax
80101026:	83 c0 6c             	add    $0x6c,%eax
80101029:	50                   	push   %eax
8010102a:	e8 31 39 00 00       	call   80104960 <safestrcpy>
  curproc->pgdir = pgdir;
8010102f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80101035:	89 f9                	mov    %edi,%ecx
80101037:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
8010103a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
8010103d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
8010103f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80101042:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80101048:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
8010104b:	8b 41 18             	mov    0x18(%ecx),%eax
8010104e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80101051:	89 0c 24             	mov    %ecx,(%esp)
80101054:	e8 b7 5a 00 00       	call   80106b10 <switchuvm>
  freevm(oldpgdir);
80101059:	89 3c 24             	mov    %edi,(%esp)
8010105c:	e8 5f 5e 00 00       	call   80106ec0 <freevm>
  return 0;
80101061:	83 c4 10             	add    $0x10,%esp
80101064:	31 c0                	xor    %eax,%eax
80101066:	e9 31 fd ff ff       	jmp    80100d9c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010106b:	be 00 20 00 00       	mov    $0x2000,%esi
80101070:	e9 3c fe ff ff       	jmp    80100eb1 <exec+0x181>
80101075:	66 90                	xchg   %ax,%ax
80101077:	66 90                	xchg   %ax,%ax
80101079:	66 90                	xchg   %ax,%ax
8010107b:	66 90                	xchg   %ax,%ax
8010107d:	66 90                	xchg   %ax,%ax
8010107f:	90                   	nop

80101080 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101086:	68 6d 72 10 80       	push   $0x8010726d
8010108b:	68 80 02 11 80       	push   $0x80110280
80101090:	e8 9b 34 00 00       	call   80104530 <initlock>
}
80101095:	83 c4 10             	add    $0x10,%esp
80101098:	c9                   	leave  
80101099:	c3                   	ret    
8010109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010a0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801010a0:	55                   	push   %ebp
801010a1:	89 e5                	mov    %esp,%ebp
801010a3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010a4:	bb b4 02 11 80       	mov    $0x801102b4,%ebx
{
801010a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801010ac:	68 80 02 11 80       	push   $0x80110280
801010b1:	e8 ba 35 00 00       	call   80104670 <acquire>
801010b6:	83 c4 10             	add    $0x10,%esp
801010b9:	eb 10                	jmp    801010cb <filealloc+0x2b>
801010bb:	90                   	nop
801010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010c0:	83 c3 18             	add    $0x18,%ebx
801010c3:	81 fb 14 0c 11 80    	cmp    $0x80110c14,%ebx
801010c9:	73 25                	jae    801010f0 <filealloc+0x50>
    if(f->ref == 0){
801010cb:	8b 43 04             	mov    0x4(%ebx),%eax
801010ce:	85 c0                	test   %eax,%eax
801010d0:	75 ee                	jne    801010c0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801010d2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801010d5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801010dc:	68 80 02 11 80       	push   $0x80110280
801010e1:	e8 4a 36 00 00       	call   80104730 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801010e6:	89 d8                	mov    %ebx,%eax
      return f;
801010e8:	83 c4 10             	add    $0x10,%esp
}
801010eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010ee:	c9                   	leave  
801010ef:	c3                   	ret    
  release(&ftable.lock);
801010f0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801010f3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801010f5:	68 80 02 11 80       	push   $0x80110280
801010fa:	e8 31 36 00 00       	call   80104730 <release>
}
801010ff:	89 d8                	mov    %ebx,%eax
  return 0;
80101101:	83 c4 10             	add    $0x10,%esp
}
80101104:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101107:	c9                   	leave  
80101108:	c3                   	ret    
80101109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101110 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	53                   	push   %ebx
80101114:	83 ec 10             	sub    $0x10,%esp
80101117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010111a:	68 80 02 11 80       	push   $0x80110280
8010111f:	e8 4c 35 00 00       	call   80104670 <acquire>
  if(f->ref < 1)
80101124:	8b 43 04             	mov    0x4(%ebx),%eax
80101127:	83 c4 10             	add    $0x10,%esp
8010112a:	85 c0                	test   %eax,%eax
8010112c:	7e 1a                	jle    80101148 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010112e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101131:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101134:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101137:	68 80 02 11 80       	push   $0x80110280
8010113c:	e8 ef 35 00 00       	call   80104730 <release>
  return f;
}
80101141:	89 d8                	mov    %ebx,%eax
80101143:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101146:	c9                   	leave  
80101147:	c3                   	ret    
    panic("filedup");
80101148:	83 ec 0c             	sub    $0xc,%esp
8010114b:	68 74 72 10 80       	push   $0x80107274
80101150:	e8 3b f2 ff ff       	call   80100390 <panic>
80101155:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101160 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101160:	55                   	push   %ebp
80101161:	89 e5                	mov    %esp,%ebp
80101163:	57                   	push   %edi
80101164:	56                   	push   %esi
80101165:	53                   	push   %ebx
80101166:	83 ec 28             	sub    $0x28,%esp
80101169:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010116c:	68 80 02 11 80       	push   $0x80110280
80101171:	e8 fa 34 00 00       	call   80104670 <acquire>
  if(f->ref < 1)
80101176:	8b 43 04             	mov    0x4(%ebx),%eax
80101179:	83 c4 10             	add    $0x10,%esp
8010117c:	85 c0                	test   %eax,%eax
8010117e:	0f 8e 9b 00 00 00    	jle    8010121f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101184:	83 e8 01             	sub    $0x1,%eax
80101187:	85 c0                	test   %eax,%eax
80101189:	89 43 04             	mov    %eax,0x4(%ebx)
8010118c:	74 1a                	je     801011a8 <fileclose+0x48>
    release(&ftable.lock);
8010118e:	c7 45 08 80 02 11 80 	movl   $0x80110280,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101195:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101198:	5b                   	pop    %ebx
80101199:	5e                   	pop    %esi
8010119a:	5f                   	pop    %edi
8010119b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010119c:	e9 8f 35 00 00       	jmp    80104730 <release>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
801011a8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
801011ac:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
801011ae:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801011b1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
801011b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801011ba:	88 45 e7             	mov    %al,-0x19(%ebp)
801011bd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801011c0:	68 80 02 11 80       	push   $0x80110280
  ff = *f;
801011c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801011c8:	e8 63 35 00 00       	call   80104730 <release>
  if(ff.type == FD_PIPE)
801011cd:	83 c4 10             	add    $0x10,%esp
801011d0:	83 ff 01             	cmp    $0x1,%edi
801011d3:	74 13                	je     801011e8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
801011d5:	83 ff 02             	cmp    $0x2,%edi
801011d8:	74 26                	je     80101200 <fileclose+0xa0>
}
801011da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011dd:	5b                   	pop    %ebx
801011de:	5e                   	pop    %esi
801011df:	5f                   	pop    %edi
801011e0:	5d                   	pop    %ebp
801011e1:	c3                   	ret    
801011e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
801011e8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801011ec:	83 ec 08             	sub    $0x8,%esp
801011ef:	53                   	push   %ebx
801011f0:	56                   	push   %esi
801011f1:	e8 8a 24 00 00       	call   80103680 <pipeclose>
801011f6:	83 c4 10             	add    $0x10,%esp
801011f9:	eb df                	jmp    801011da <fileclose+0x7a>
801011fb:	90                   	nop
801011fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101200:	e8 cb 1c 00 00       	call   80102ed0 <begin_op>
    iput(ff.ip);
80101205:	83 ec 0c             	sub    $0xc,%esp
80101208:	ff 75 e0             	pushl  -0x20(%ebp)
8010120b:	e8 d0 08 00 00       	call   80101ae0 <iput>
    end_op();
80101210:	83 c4 10             	add    $0x10,%esp
}
80101213:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101216:	5b                   	pop    %ebx
80101217:	5e                   	pop    %esi
80101218:	5f                   	pop    %edi
80101219:	5d                   	pop    %ebp
    end_op();
8010121a:	e9 21 1d 00 00       	jmp    80102f40 <end_op>
    panic("fileclose");
8010121f:	83 ec 0c             	sub    $0xc,%esp
80101222:	68 7c 72 10 80       	push   $0x8010727c
80101227:	e8 64 f1 ff ff       	call   80100390 <panic>
8010122c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101230 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	53                   	push   %ebx
80101234:	83 ec 04             	sub    $0x4,%esp
80101237:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010123a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010123d:	75 31                	jne    80101270 <filestat+0x40>
    ilock(f->ip);
8010123f:	83 ec 0c             	sub    $0xc,%esp
80101242:	ff 73 10             	pushl  0x10(%ebx)
80101245:	e8 66 07 00 00       	call   801019b0 <ilock>
    stati(f->ip, st);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	ff 75 0c             	pushl  0xc(%ebp)
8010124f:	ff 73 10             	pushl  0x10(%ebx)
80101252:	e8 09 0a 00 00       	call   80101c60 <stati>
    iunlock(f->ip);
80101257:	59                   	pop    %ecx
80101258:	ff 73 10             	pushl  0x10(%ebx)
8010125b:	e8 30 08 00 00       	call   80101a90 <iunlock>
    return 0;
80101260:	83 c4 10             	add    $0x10,%esp
80101263:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101265:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101268:	c9                   	leave  
80101269:	c3                   	ret    
8010126a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101275:	eb ee                	jmp    80101265 <filestat+0x35>
80101277:	89 f6                	mov    %esi,%esi
80101279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101280 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	83 ec 0c             	sub    $0xc,%esp
80101289:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010128c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010128f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101292:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101296:	74 60                	je     801012f8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101298:	8b 03                	mov    (%ebx),%eax
8010129a:	83 f8 01             	cmp    $0x1,%eax
8010129d:	74 41                	je     801012e0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010129f:	83 f8 02             	cmp    $0x2,%eax
801012a2:	75 5b                	jne    801012ff <fileread+0x7f>
    ilock(f->ip);
801012a4:	83 ec 0c             	sub    $0xc,%esp
801012a7:	ff 73 10             	pushl  0x10(%ebx)
801012aa:	e8 01 07 00 00       	call   801019b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801012af:	57                   	push   %edi
801012b0:	ff 73 14             	pushl  0x14(%ebx)
801012b3:	56                   	push   %esi
801012b4:	ff 73 10             	pushl  0x10(%ebx)
801012b7:	e8 d4 09 00 00       	call   80101c90 <readi>
801012bc:	83 c4 20             	add    $0x20,%esp
801012bf:	85 c0                	test   %eax,%eax
801012c1:	89 c6                	mov    %eax,%esi
801012c3:	7e 03                	jle    801012c8 <fileread+0x48>
      f->off += r;
801012c5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801012c8:	83 ec 0c             	sub    $0xc,%esp
801012cb:	ff 73 10             	pushl  0x10(%ebx)
801012ce:	e8 bd 07 00 00       	call   80101a90 <iunlock>
    return r;
801012d3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801012d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d9:	89 f0                	mov    %esi,%eax
801012db:	5b                   	pop    %ebx
801012dc:	5e                   	pop    %esi
801012dd:	5f                   	pop    %edi
801012de:	5d                   	pop    %ebp
801012df:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801012e0:	8b 43 0c             	mov    0xc(%ebx),%eax
801012e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e9:	5b                   	pop    %ebx
801012ea:	5e                   	pop    %esi
801012eb:	5f                   	pop    %edi
801012ec:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801012ed:	e9 3e 25 00 00       	jmp    80103830 <piperead>
801012f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801012f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801012fd:	eb d7                	jmp    801012d6 <fileread+0x56>
  panic("fileread");
801012ff:	83 ec 0c             	sub    $0xc,%esp
80101302:	68 86 72 10 80       	push   $0x80107286
80101307:	e8 84 f0 ff ff       	call   80100390 <panic>
8010130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101310 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	57                   	push   %edi
80101314:	56                   	push   %esi
80101315:	53                   	push   %ebx
80101316:	83 ec 1c             	sub    $0x1c,%esp
80101319:	8b 75 08             	mov    0x8(%ebp),%esi
8010131c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010131f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101323:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101326:	8b 45 10             	mov    0x10(%ebp),%eax
80101329:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010132c:	0f 84 aa 00 00 00    	je     801013dc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101332:	8b 06                	mov    (%esi),%eax
80101334:	83 f8 01             	cmp    $0x1,%eax
80101337:	0f 84 c3 00 00 00    	je     80101400 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010133d:	83 f8 02             	cmp    $0x2,%eax
80101340:	0f 85 d9 00 00 00    	jne    8010141f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101346:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101349:	31 ff                	xor    %edi,%edi
    while(i < n){
8010134b:	85 c0                	test   %eax,%eax
8010134d:	7f 34                	jg     80101383 <filewrite+0x73>
8010134f:	e9 9c 00 00 00       	jmp    801013f0 <filewrite+0xe0>
80101354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101358:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010135b:	83 ec 0c             	sub    $0xc,%esp
8010135e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101361:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101364:	e8 27 07 00 00       	call   80101a90 <iunlock>
      end_op();
80101369:	e8 d2 1b 00 00       	call   80102f40 <end_op>
8010136e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101371:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101374:	39 c3                	cmp    %eax,%ebx
80101376:	0f 85 96 00 00 00    	jne    80101412 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010137c:	01 df                	add    %ebx,%edi
    while(i < n){
8010137e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101381:	7e 6d                	jle    801013f0 <filewrite+0xe0>
      int n1 = n - i;
80101383:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101386:	b8 00 06 00 00       	mov    $0x600,%eax
8010138b:	29 fb                	sub    %edi,%ebx
8010138d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101393:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101396:	e8 35 1b 00 00       	call   80102ed0 <begin_op>
      ilock(f->ip);
8010139b:	83 ec 0c             	sub    $0xc,%esp
8010139e:	ff 76 10             	pushl  0x10(%esi)
801013a1:	e8 0a 06 00 00       	call   801019b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801013a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801013a9:	53                   	push   %ebx
801013aa:	ff 76 14             	pushl  0x14(%esi)
801013ad:	01 f8                	add    %edi,%eax
801013af:	50                   	push   %eax
801013b0:	ff 76 10             	pushl  0x10(%esi)
801013b3:	e8 d8 09 00 00       	call   80101d90 <writei>
801013b8:	83 c4 20             	add    $0x20,%esp
801013bb:	85 c0                	test   %eax,%eax
801013bd:	7f 99                	jg     80101358 <filewrite+0x48>
      iunlock(f->ip);
801013bf:	83 ec 0c             	sub    $0xc,%esp
801013c2:	ff 76 10             	pushl  0x10(%esi)
801013c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801013c8:	e8 c3 06 00 00       	call   80101a90 <iunlock>
      end_op();
801013cd:	e8 6e 1b 00 00       	call   80102f40 <end_op>
      if(r < 0)
801013d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013d5:	83 c4 10             	add    $0x10,%esp
801013d8:	85 c0                	test   %eax,%eax
801013da:	74 98                	je     80101374 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801013dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801013df:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801013e4:	89 f8                	mov    %edi,%eax
801013e6:	5b                   	pop    %ebx
801013e7:	5e                   	pop    %esi
801013e8:	5f                   	pop    %edi
801013e9:	5d                   	pop    %ebp
801013ea:	c3                   	ret    
801013eb:	90                   	nop
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801013f0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801013f3:	75 e7                	jne    801013dc <filewrite+0xcc>
}
801013f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f8:	89 f8                	mov    %edi,%eax
801013fa:	5b                   	pop    %ebx
801013fb:	5e                   	pop    %esi
801013fc:	5f                   	pop    %edi
801013fd:	5d                   	pop    %ebp
801013fe:	c3                   	ret    
801013ff:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101400:	8b 46 0c             	mov    0xc(%esi),%eax
80101403:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101406:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101409:	5b                   	pop    %ebx
8010140a:	5e                   	pop    %esi
8010140b:	5f                   	pop    %edi
8010140c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010140d:	e9 0e 23 00 00       	jmp    80103720 <pipewrite>
        panic("short filewrite");
80101412:	83 ec 0c             	sub    $0xc,%esp
80101415:	68 8f 72 10 80       	push   $0x8010728f
8010141a:	e8 71 ef ff ff       	call   80100390 <panic>
  panic("filewrite");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 95 72 10 80       	push   $0x80107295
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	66 90                	xchg   %ax,%ax
8010142e:	66 90                	xchg   %ax,%ax

80101430 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	53                   	push   %ebx
80101436:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101439:	8b 0d 80 0c 11 80    	mov    0x80110c80,%ecx
{
8010143f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101442:	85 c9                	test   %ecx,%ecx
80101444:	0f 84 87 00 00 00    	je     801014d1 <balloc+0xa1>
8010144a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101451:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101454:	83 ec 08             	sub    $0x8,%esp
80101457:	89 f0                	mov    %esi,%eax
80101459:	c1 f8 0c             	sar    $0xc,%eax
8010145c:	03 05 98 0c 11 80    	add    0x80110c98,%eax
80101462:	50                   	push   %eax
80101463:	ff 75 d8             	pushl  -0x28(%ebp)
80101466:	e8 65 ec ff ff       	call   801000d0 <bread>
8010146b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010146e:	a1 80 0c 11 80       	mov    0x80110c80,%eax
80101473:	83 c4 10             	add    $0x10,%esp
80101476:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101479:	31 c0                	xor    %eax,%eax
8010147b:	eb 2f                	jmp    801014ac <balloc+0x7c>
8010147d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101480:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101482:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101485:	bb 01 00 00 00       	mov    $0x1,%ebx
8010148a:	83 e1 07             	and    $0x7,%ecx
8010148d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010148f:	89 c1                	mov    %eax,%ecx
80101491:	c1 f9 03             	sar    $0x3,%ecx
80101494:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101499:	85 df                	test   %ebx,%edi
8010149b:	89 fa                	mov    %edi,%edx
8010149d:	74 41                	je     801014e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010149f:	83 c0 01             	add    $0x1,%eax
801014a2:	83 c6 01             	add    $0x1,%esi
801014a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801014aa:	74 05                	je     801014b1 <balloc+0x81>
801014ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801014af:	77 cf                	ja     80101480 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014b1:	83 ec 0c             	sub    $0xc,%esp
801014b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801014b7:	e8 24 ed ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801014bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801014c3:	83 c4 10             	add    $0x10,%esp
801014c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014c9:	39 05 80 0c 11 80    	cmp    %eax,0x80110c80
801014cf:	77 80                	ja     80101451 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801014d1:	83 ec 0c             	sub    $0xc,%esp
801014d4:	68 9f 72 10 80       	push   $0x8010729f
801014d9:	e8 b2 ee ff ff       	call   80100390 <panic>
801014de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801014e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801014e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801014e6:	09 da                	or     %ebx,%edx
801014e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801014ec:	57                   	push   %edi
801014ed:	e8 ae 1b 00 00       	call   801030a0 <log_write>
        brelse(bp);
801014f2:	89 3c 24             	mov    %edi,(%esp)
801014f5:	e8 e6 ec ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801014fa:	58                   	pop    %eax
801014fb:	5a                   	pop    %edx
801014fc:	56                   	push   %esi
801014fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101500:	e8 cb eb ff ff       	call   801000d0 <bread>
80101505:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101507:	8d 40 5c             	lea    0x5c(%eax),%eax
8010150a:	83 c4 0c             	add    $0xc,%esp
8010150d:	68 00 02 00 00       	push   $0x200
80101512:	6a 00                	push   $0x0
80101514:	50                   	push   %eax
80101515:	e8 66 32 00 00       	call   80104780 <memset>
  log_write(bp);
8010151a:	89 1c 24             	mov    %ebx,(%esp)
8010151d:	e8 7e 1b 00 00       	call   801030a0 <log_write>
  brelse(bp);
80101522:	89 1c 24             	mov    %ebx,(%esp)
80101525:	e8 b6 ec ff ff       	call   801001e0 <brelse>
}
8010152a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152d:	89 f0                	mov    %esi,%eax
8010152f:	5b                   	pop    %ebx
80101530:	5e                   	pop    %esi
80101531:	5f                   	pop    %edi
80101532:	5d                   	pop    %ebp
80101533:	c3                   	ret    
80101534:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010153a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101540 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101548:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010154a:	bb d4 0c 11 80       	mov    $0x80110cd4,%ebx
{
8010154f:	83 ec 28             	sub    $0x28,%esp
80101552:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101555:	68 a0 0c 11 80       	push   $0x80110ca0
8010155a:	e8 11 31 00 00       	call   80104670 <acquire>
8010155f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101562:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101565:	eb 17                	jmp    8010157e <iget+0x3e>
80101567:	89 f6                	mov    %esi,%esi
80101569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101570:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101576:	81 fb f4 28 11 80    	cmp    $0x801128f4,%ebx
8010157c:	73 22                	jae    801015a0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010157e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101581:	85 c9                	test   %ecx,%ecx
80101583:	7e 04                	jle    80101589 <iget+0x49>
80101585:	39 3b                	cmp    %edi,(%ebx)
80101587:	74 4f                	je     801015d8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101589:	85 f6                	test   %esi,%esi
8010158b:	75 e3                	jne    80101570 <iget+0x30>
8010158d:	85 c9                	test   %ecx,%ecx
8010158f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101592:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101598:	81 fb f4 28 11 80    	cmp    $0x801128f4,%ebx
8010159e:	72 de                	jb     8010157e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801015a0:	85 f6                	test   %esi,%esi
801015a2:	74 5b                	je     801015ff <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801015a4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801015a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801015a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801015ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801015b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801015ba:	68 a0 0c 11 80       	push   $0x80110ca0
801015bf:	e8 6c 31 00 00       	call   80104730 <release>

  return ip;
801015c4:	83 c4 10             	add    $0x10,%esp
}
801015c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015ca:	89 f0                	mov    %esi,%eax
801015cc:	5b                   	pop    %ebx
801015cd:	5e                   	pop    %esi
801015ce:	5f                   	pop    %edi
801015cf:	5d                   	pop    %ebp
801015d0:	c3                   	ret    
801015d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801015d8:	39 53 04             	cmp    %edx,0x4(%ebx)
801015db:	75 ac                	jne    80101589 <iget+0x49>
      release(&icache.lock);
801015dd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801015e0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801015e3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801015e5:	68 a0 0c 11 80       	push   $0x80110ca0
      ip->ref++;
801015ea:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801015ed:	e8 3e 31 00 00       	call   80104730 <release>
      return ip;
801015f2:	83 c4 10             	add    $0x10,%esp
}
801015f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015f8:	89 f0                	mov    %esi,%eax
801015fa:	5b                   	pop    %ebx
801015fb:	5e                   	pop    %esi
801015fc:	5f                   	pop    %edi
801015fd:	5d                   	pop    %ebp
801015fe:	c3                   	ret    
    panic("iget: no inodes");
801015ff:	83 ec 0c             	sub    $0xc,%esp
80101602:	68 b5 72 10 80       	push   $0x801072b5
80101607:	e8 84 ed ff ff       	call   80100390 <panic>
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	89 c6                	mov    %eax,%esi
80101618:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010161b:	83 fa 0b             	cmp    $0xb,%edx
8010161e:	77 18                	ja     80101638 <bmap+0x28>
80101620:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101623:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101626:	85 db                	test   %ebx,%ebx
80101628:	74 76                	je     801016a0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010162a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010162d:	89 d8                	mov    %ebx,%eax
8010162f:	5b                   	pop    %ebx
80101630:	5e                   	pop    %esi
80101631:	5f                   	pop    %edi
80101632:	5d                   	pop    %ebp
80101633:	c3                   	ret    
80101634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101638:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010163b:	83 fb 7f             	cmp    $0x7f,%ebx
8010163e:	0f 87 90 00 00 00    	ja     801016d4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101644:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010164a:	8b 00                	mov    (%eax),%eax
8010164c:	85 d2                	test   %edx,%edx
8010164e:	74 70                	je     801016c0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101650:	83 ec 08             	sub    $0x8,%esp
80101653:	52                   	push   %edx
80101654:	50                   	push   %eax
80101655:	e8 76 ea ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010165a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010165e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101661:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101663:	8b 1a                	mov    (%edx),%ebx
80101665:	85 db                	test   %ebx,%ebx
80101667:	75 1d                	jne    80101686 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101669:	8b 06                	mov    (%esi),%eax
8010166b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010166e:	e8 bd fd ff ff       	call   80101430 <balloc>
80101673:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101676:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101679:	89 c3                	mov    %eax,%ebx
8010167b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010167d:	57                   	push   %edi
8010167e:	e8 1d 1a 00 00       	call   801030a0 <log_write>
80101683:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101686:	83 ec 0c             	sub    $0xc,%esp
80101689:	57                   	push   %edi
8010168a:	e8 51 eb ff ff       	call   801001e0 <brelse>
8010168f:	83 c4 10             	add    $0x10,%esp
}
80101692:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101695:	89 d8                	mov    %ebx,%eax
80101697:	5b                   	pop    %ebx
80101698:	5e                   	pop    %esi
80101699:	5f                   	pop    %edi
8010169a:	5d                   	pop    %ebp
8010169b:	c3                   	ret    
8010169c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801016a0:	8b 00                	mov    (%eax),%eax
801016a2:	e8 89 fd ff ff       	call   80101430 <balloc>
801016a7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801016aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801016ad:	89 c3                	mov    %eax,%ebx
}
801016af:	89 d8                	mov    %ebx,%eax
801016b1:	5b                   	pop    %ebx
801016b2:	5e                   	pop    %esi
801016b3:	5f                   	pop    %edi
801016b4:	5d                   	pop    %ebp
801016b5:	c3                   	ret    
801016b6:	8d 76 00             	lea    0x0(%esi),%esi
801016b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801016c0:	e8 6b fd ff ff       	call   80101430 <balloc>
801016c5:	89 c2                	mov    %eax,%edx
801016c7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801016cd:	8b 06                	mov    (%esi),%eax
801016cf:	e9 7c ff ff ff       	jmp    80101650 <bmap+0x40>
  panic("bmap: out of range");
801016d4:	83 ec 0c             	sub    $0xc,%esp
801016d7:	68 c5 72 10 80       	push   $0x801072c5
801016dc:	e8 af ec ff ff       	call   80100390 <panic>
801016e1:	eb 0d                	jmp    801016f0 <readsb>
801016e3:	90                   	nop
801016e4:	90                   	nop
801016e5:	90                   	nop
801016e6:	90                   	nop
801016e7:	90                   	nop
801016e8:	90                   	nop
801016e9:	90                   	nop
801016ea:	90                   	nop
801016eb:	90                   	nop
801016ec:	90                   	nop
801016ed:	90                   	nop
801016ee:	90                   	nop
801016ef:	90                   	nop

801016f0 <readsb>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801016f8:	83 ec 08             	sub    $0x8,%esp
801016fb:	6a 01                	push   $0x1
801016fd:	ff 75 08             	pushl  0x8(%ebp)
80101700:	e8 cb e9 ff ff       	call   801000d0 <bread>
80101705:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101707:	8d 40 5c             	lea    0x5c(%eax),%eax
8010170a:	83 c4 0c             	add    $0xc,%esp
8010170d:	6a 1c                	push   $0x1c
8010170f:	50                   	push   %eax
80101710:	56                   	push   %esi
80101711:	e8 1a 31 00 00       	call   80104830 <memmove>
  brelse(bp);
80101716:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101719:	83 c4 10             	add    $0x10,%esp
}
8010171c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171f:	5b                   	pop    %ebx
80101720:	5e                   	pop    %esi
80101721:	5d                   	pop    %ebp
  brelse(bp);
80101722:	e9 b9 ea ff ff       	jmp    801001e0 <brelse>
80101727:	89 f6                	mov    %esi,%esi
80101729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101730 <bfree>:
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	56                   	push   %esi
80101734:	53                   	push   %ebx
80101735:	89 d3                	mov    %edx,%ebx
80101737:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101739:	83 ec 08             	sub    $0x8,%esp
8010173c:	68 80 0c 11 80       	push   $0x80110c80
80101741:	50                   	push   %eax
80101742:	e8 a9 ff ff ff       	call   801016f0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101747:	58                   	pop    %eax
80101748:	5a                   	pop    %edx
80101749:	89 da                	mov    %ebx,%edx
8010174b:	c1 ea 0c             	shr    $0xc,%edx
8010174e:	03 15 98 0c 11 80    	add    0x80110c98,%edx
80101754:	52                   	push   %edx
80101755:	56                   	push   %esi
80101756:	e8 75 e9 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010175b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010175d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101760:	ba 01 00 00 00       	mov    $0x1,%edx
80101765:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101768:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010176e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101771:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101773:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101778:	85 d1                	test   %edx,%ecx
8010177a:	74 25                	je     801017a1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010177c:	f7 d2                	not    %edx
8010177e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101780:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101783:	21 ca                	and    %ecx,%edx
80101785:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101789:	56                   	push   %esi
8010178a:	e8 11 19 00 00       	call   801030a0 <log_write>
  brelse(bp);
8010178f:	89 34 24             	mov    %esi,(%esp)
80101792:	e8 49 ea ff ff       	call   801001e0 <brelse>
}
80101797:	83 c4 10             	add    $0x10,%esp
8010179a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179d:	5b                   	pop    %ebx
8010179e:	5e                   	pop    %esi
8010179f:	5d                   	pop    %ebp
801017a0:	c3                   	ret    
    panic("freeing free block");
801017a1:	83 ec 0c             	sub    $0xc,%esp
801017a4:	68 d8 72 10 80       	push   $0x801072d8
801017a9:	e8 e2 eb ff ff       	call   80100390 <panic>
801017ae:	66 90                	xchg   %ax,%ax

801017b0 <iinit>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	53                   	push   %ebx
801017b4:	bb e0 0c 11 80       	mov    $0x80110ce0,%ebx
801017b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801017bc:	68 eb 72 10 80       	push   $0x801072eb
801017c1:	68 a0 0c 11 80       	push   $0x80110ca0
801017c6:	e8 65 2d 00 00       	call   80104530 <initlock>
801017cb:	83 c4 10             	add    $0x10,%esp
801017ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801017d0:	83 ec 08             	sub    $0x8,%esp
801017d3:	68 f2 72 10 80       	push   $0x801072f2
801017d8:	53                   	push   %ebx
801017d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801017df:	e8 1c 2c 00 00       	call   80104400 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801017e4:	83 c4 10             	add    $0x10,%esp
801017e7:	81 fb 00 29 11 80    	cmp    $0x80112900,%ebx
801017ed:	75 e1                	jne    801017d0 <iinit+0x20>
  readsb(dev, &sb);
801017ef:	83 ec 08             	sub    $0x8,%esp
801017f2:	68 80 0c 11 80       	push   $0x80110c80
801017f7:	ff 75 08             	pushl  0x8(%ebp)
801017fa:	e8 f1 fe ff ff       	call   801016f0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801017ff:	ff 35 98 0c 11 80    	pushl  0x80110c98
80101805:	ff 35 94 0c 11 80    	pushl  0x80110c94
8010180b:	ff 35 90 0c 11 80    	pushl  0x80110c90
80101811:	ff 35 8c 0c 11 80    	pushl  0x80110c8c
80101817:	ff 35 88 0c 11 80    	pushl  0x80110c88
8010181d:	ff 35 84 0c 11 80    	pushl  0x80110c84
80101823:	ff 35 80 0c 11 80    	pushl  0x80110c80
80101829:	68 58 73 10 80       	push   $0x80107358
8010182e:	e8 2d ee ff ff       	call   80100660 <cprintf>
}
80101833:	83 c4 30             	add    $0x30,%esp
80101836:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101839:	c9                   	leave  
8010183a:	c3                   	ret    
8010183b:	90                   	nop
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101840 <ialloc>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	57                   	push   %edi
80101844:	56                   	push   %esi
80101845:	53                   	push   %ebx
80101846:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101849:	83 3d 88 0c 11 80 01 	cmpl   $0x1,0x80110c88
{
80101850:	8b 45 0c             	mov    0xc(%ebp),%eax
80101853:	8b 75 08             	mov    0x8(%ebp),%esi
80101856:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101859:	0f 86 91 00 00 00    	jbe    801018f0 <ialloc+0xb0>
8010185f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101864:	eb 21                	jmp    80101887 <ialloc+0x47>
80101866:	8d 76 00             	lea    0x0(%esi),%esi
80101869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101870:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101873:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101876:	57                   	push   %edi
80101877:	e8 64 e9 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010187c:	83 c4 10             	add    $0x10,%esp
8010187f:	39 1d 88 0c 11 80    	cmp    %ebx,0x80110c88
80101885:	76 69                	jbe    801018f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101887:	89 d8                	mov    %ebx,%eax
80101889:	83 ec 08             	sub    $0x8,%esp
8010188c:	c1 e8 03             	shr    $0x3,%eax
8010188f:	03 05 94 0c 11 80    	add    0x80110c94,%eax
80101895:	50                   	push   %eax
80101896:	56                   	push   %esi
80101897:	e8 34 e8 ff ff       	call   801000d0 <bread>
8010189c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010189e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801018a0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801018a3:	83 e0 07             	and    $0x7,%eax
801018a6:	c1 e0 06             	shl    $0x6,%eax
801018a9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801018ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801018b1:	75 bd                	jne    80101870 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801018b3:	83 ec 04             	sub    $0x4,%esp
801018b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801018b9:	6a 40                	push   $0x40
801018bb:	6a 00                	push   $0x0
801018bd:	51                   	push   %ecx
801018be:	e8 bd 2e 00 00       	call   80104780 <memset>
      dip->type = type;
801018c3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801018c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801018ca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801018cd:	89 3c 24             	mov    %edi,(%esp)
801018d0:	e8 cb 17 00 00       	call   801030a0 <log_write>
      brelse(bp);
801018d5:	89 3c 24             	mov    %edi,(%esp)
801018d8:	e8 03 e9 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801018dd:	83 c4 10             	add    $0x10,%esp
}
801018e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801018e3:	89 da                	mov    %ebx,%edx
801018e5:	89 f0                	mov    %esi,%eax
}
801018e7:	5b                   	pop    %ebx
801018e8:	5e                   	pop    %esi
801018e9:	5f                   	pop    %edi
801018ea:	5d                   	pop    %ebp
      return iget(dev, inum);
801018eb:	e9 50 fc ff ff       	jmp    80101540 <iget>
  panic("ialloc: no inodes");
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 f8 72 10 80       	push   $0x801072f8
801018f8:	e8 93 ea ff ff       	call   80100390 <panic>
801018fd:	8d 76 00             	lea    0x0(%esi),%esi

80101900 <iupdate>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	56                   	push   %esi
80101904:	53                   	push   %ebx
80101905:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101908:	83 ec 08             	sub    $0x8,%esp
8010190b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010190e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101911:	c1 e8 03             	shr    $0x3,%eax
80101914:	03 05 94 0c 11 80    	add    0x80110c94,%eax
8010191a:	50                   	push   %eax
8010191b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010191e:	e8 ad e7 ff ff       	call   801000d0 <bread>
80101923:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101925:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101928:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010192c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010192f:	83 e0 07             	and    $0x7,%eax
80101932:	c1 e0 06             	shl    $0x6,%eax
80101935:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101939:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010193c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101940:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101943:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101947:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010194b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010194f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101953:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101957:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010195a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010195d:	6a 34                	push   $0x34
8010195f:	53                   	push   %ebx
80101960:	50                   	push   %eax
80101961:	e8 ca 2e 00 00       	call   80104830 <memmove>
  log_write(bp);
80101966:	89 34 24             	mov    %esi,(%esp)
80101969:	e8 32 17 00 00       	call   801030a0 <log_write>
  brelse(bp);
8010196e:	89 75 08             	mov    %esi,0x8(%ebp)
80101971:	83 c4 10             	add    $0x10,%esp
}
80101974:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101977:	5b                   	pop    %ebx
80101978:	5e                   	pop    %esi
80101979:	5d                   	pop    %ebp
  brelse(bp);
8010197a:	e9 61 e8 ff ff       	jmp    801001e0 <brelse>
8010197f:	90                   	nop

80101980 <idup>:
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	53                   	push   %ebx
80101984:	83 ec 10             	sub    $0x10,%esp
80101987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010198a:	68 a0 0c 11 80       	push   $0x80110ca0
8010198f:	e8 dc 2c 00 00       	call   80104670 <acquire>
  ip->ref++;
80101994:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101998:	c7 04 24 a0 0c 11 80 	movl   $0x80110ca0,(%esp)
8010199f:	e8 8c 2d 00 00       	call   80104730 <release>
}
801019a4:	89 d8                	mov    %ebx,%eax
801019a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019a9:	c9                   	leave  
801019aa:	c3                   	ret    
801019ab:	90                   	nop
801019ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019b0 <ilock>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	56                   	push   %esi
801019b4:	53                   	push   %ebx
801019b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801019b8:	85 db                	test   %ebx,%ebx
801019ba:	0f 84 b7 00 00 00    	je     80101a77 <ilock+0xc7>
801019c0:	8b 53 08             	mov    0x8(%ebx),%edx
801019c3:	85 d2                	test   %edx,%edx
801019c5:	0f 8e ac 00 00 00    	jle    80101a77 <ilock+0xc7>
  acquiresleep(&ip->lock);
801019cb:	8d 43 0c             	lea    0xc(%ebx),%eax
801019ce:	83 ec 0c             	sub    $0xc,%esp
801019d1:	50                   	push   %eax
801019d2:	e8 69 2a 00 00       	call   80104440 <acquiresleep>
  if(ip->valid == 0){
801019d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801019da:	83 c4 10             	add    $0x10,%esp
801019dd:	85 c0                	test   %eax,%eax
801019df:	74 0f                	je     801019f0 <ilock+0x40>
}
801019e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019e4:	5b                   	pop    %ebx
801019e5:	5e                   	pop    %esi
801019e6:	5d                   	pop    %ebp
801019e7:	c3                   	ret    
801019e8:	90                   	nop
801019e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019f0:	8b 43 04             	mov    0x4(%ebx),%eax
801019f3:	83 ec 08             	sub    $0x8,%esp
801019f6:	c1 e8 03             	shr    $0x3,%eax
801019f9:	03 05 94 0c 11 80    	add    0x80110c94,%eax
801019ff:	50                   	push   %eax
80101a00:	ff 33                	pushl  (%ebx)
80101a02:	e8 c9 e6 ff ff       	call   801000d0 <bread>
80101a07:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a09:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a0c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a0f:	83 e0 07             	and    $0x7,%eax
80101a12:	c1 e0 06             	shl    $0x6,%eax
80101a15:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101a19:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a1c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101a1f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101a23:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101a27:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101a2b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101a2f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101a33:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101a37:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101a3b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101a3e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a41:	6a 34                	push   $0x34
80101a43:	50                   	push   %eax
80101a44:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101a47:	50                   	push   %eax
80101a48:	e8 e3 2d 00 00       	call   80104830 <memmove>
    brelse(bp);
80101a4d:	89 34 24             	mov    %esi,(%esp)
80101a50:	e8 8b e7 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101a55:	83 c4 10             	add    $0x10,%esp
80101a58:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101a5d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101a64:	0f 85 77 ff ff ff    	jne    801019e1 <ilock+0x31>
      panic("ilock: no type");
80101a6a:	83 ec 0c             	sub    $0xc,%esp
80101a6d:	68 10 73 10 80       	push   $0x80107310
80101a72:	e8 19 e9 ff ff       	call   80100390 <panic>
    panic("ilock");
80101a77:	83 ec 0c             	sub    $0xc,%esp
80101a7a:	68 0a 73 10 80       	push   $0x8010730a
80101a7f:	e8 0c e9 ff ff       	call   80100390 <panic>
80101a84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101a8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101a90 <iunlock>:
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	56                   	push   %esi
80101a94:	53                   	push   %ebx
80101a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a98:	85 db                	test   %ebx,%ebx
80101a9a:	74 28                	je     80101ac4 <iunlock+0x34>
80101a9c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a9f:	83 ec 0c             	sub    $0xc,%esp
80101aa2:	56                   	push   %esi
80101aa3:	e8 38 2a 00 00       	call   801044e0 <holdingsleep>
80101aa8:	83 c4 10             	add    $0x10,%esp
80101aab:	85 c0                	test   %eax,%eax
80101aad:	74 15                	je     80101ac4 <iunlock+0x34>
80101aaf:	8b 43 08             	mov    0x8(%ebx),%eax
80101ab2:	85 c0                	test   %eax,%eax
80101ab4:	7e 0e                	jle    80101ac4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101ab6:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101ab9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101abc:	5b                   	pop    %ebx
80101abd:	5e                   	pop    %esi
80101abe:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101abf:	e9 dc 29 00 00       	jmp    801044a0 <releasesleep>
    panic("iunlock");
80101ac4:	83 ec 0c             	sub    $0xc,%esp
80101ac7:	68 1f 73 10 80       	push   $0x8010731f
80101acc:	e8 bf e8 ff ff       	call   80100390 <panic>
80101ad1:	eb 0d                	jmp    80101ae0 <iput>
80101ad3:	90                   	nop
80101ad4:	90                   	nop
80101ad5:	90                   	nop
80101ad6:	90                   	nop
80101ad7:	90                   	nop
80101ad8:	90                   	nop
80101ad9:	90                   	nop
80101ada:	90                   	nop
80101adb:	90                   	nop
80101adc:	90                   	nop
80101add:	90                   	nop
80101ade:	90                   	nop
80101adf:	90                   	nop

80101ae0 <iput>:
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 28             	sub    $0x28,%esp
80101ae9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101aec:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101aef:	57                   	push   %edi
80101af0:	e8 4b 29 00 00       	call   80104440 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101af5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101af8:	83 c4 10             	add    $0x10,%esp
80101afb:	85 d2                	test   %edx,%edx
80101afd:	74 07                	je     80101b06 <iput+0x26>
80101aff:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101b04:	74 32                	je     80101b38 <iput+0x58>
  releasesleep(&ip->lock);
80101b06:	83 ec 0c             	sub    $0xc,%esp
80101b09:	57                   	push   %edi
80101b0a:	e8 91 29 00 00       	call   801044a0 <releasesleep>
  acquire(&icache.lock);
80101b0f:	c7 04 24 a0 0c 11 80 	movl   $0x80110ca0,(%esp)
80101b16:	e8 55 2b 00 00       	call   80104670 <acquire>
  ip->ref--;
80101b1b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b1f:	83 c4 10             	add    $0x10,%esp
80101b22:	c7 45 08 a0 0c 11 80 	movl   $0x80110ca0,0x8(%ebp)
}
80101b29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b2c:	5b                   	pop    %ebx
80101b2d:	5e                   	pop    %esi
80101b2e:	5f                   	pop    %edi
80101b2f:	5d                   	pop    %ebp
  release(&icache.lock);
80101b30:	e9 fb 2b 00 00       	jmp    80104730 <release>
80101b35:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101b38:	83 ec 0c             	sub    $0xc,%esp
80101b3b:	68 a0 0c 11 80       	push   $0x80110ca0
80101b40:	e8 2b 2b 00 00       	call   80104670 <acquire>
    int r = ip->ref;
80101b45:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101b48:	c7 04 24 a0 0c 11 80 	movl   $0x80110ca0,(%esp)
80101b4f:	e8 dc 2b 00 00       	call   80104730 <release>
    if(r == 1){
80101b54:	83 c4 10             	add    $0x10,%esp
80101b57:	83 fe 01             	cmp    $0x1,%esi
80101b5a:	75 aa                	jne    80101b06 <iput+0x26>
80101b5c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101b62:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101b65:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101b68:	89 cf                	mov    %ecx,%edi
80101b6a:	eb 0b                	jmp    80101b77 <iput+0x97>
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b70:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101b73:	39 fe                	cmp    %edi,%esi
80101b75:	74 19                	je     80101b90 <iput+0xb0>
    if(ip->addrs[i]){
80101b77:	8b 16                	mov    (%esi),%edx
80101b79:	85 d2                	test   %edx,%edx
80101b7b:	74 f3                	je     80101b70 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101b7d:	8b 03                	mov    (%ebx),%eax
80101b7f:	e8 ac fb ff ff       	call   80101730 <bfree>
      ip->addrs[i] = 0;
80101b84:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101b8a:	eb e4                	jmp    80101b70 <iput+0x90>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101b90:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101b96:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b99:	85 c0                	test   %eax,%eax
80101b9b:	75 33                	jne    80101bd0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101b9d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101ba0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101ba7:	53                   	push   %ebx
80101ba8:	e8 53 fd ff ff       	call   80101900 <iupdate>
      ip->type = 0;
80101bad:	31 c0                	xor    %eax,%eax
80101baf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101bb3:	89 1c 24             	mov    %ebx,(%esp)
80101bb6:	e8 45 fd ff ff       	call   80101900 <iupdate>
      ip->valid = 0;
80101bbb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101bc2:	83 c4 10             	add    $0x10,%esp
80101bc5:	e9 3c ff ff ff       	jmp    80101b06 <iput+0x26>
80101bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101bd0:	83 ec 08             	sub    $0x8,%esp
80101bd3:	50                   	push   %eax
80101bd4:	ff 33                	pushl  (%ebx)
80101bd6:	e8 f5 e4 ff ff       	call   801000d0 <bread>
80101bdb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101be1:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101be4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101be7:	8d 70 5c             	lea    0x5c(%eax),%esi
80101bea:	83 c4 10             	add    $0x10,%esp
80101bed:	89 cf                	mov    %ecx,%edi
80101bef:	eb 0e                	jmp    80101bff <iput+0x11f>
80101bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bf8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101bfb:	39 fe                	cmp    %edi,%esi
80101bfd:	74 0f                	je     80101c0e <iput+0x12e>
      if(a[j])
80101bff:	8b 16                	mov    (%esi),%edx
80101c01:	85 d2                	test   %edx,%edx
80101c03:	74 f3                	je     80101bf8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101c05:	8b 03                	mov    (%ebx),%eax
80101c07:	e8 24 fb ff ff       	call   80101730 <bfree>
80101c0c:	eb ea                	jmp    80101bf8 <iput+0x118>
    brelse(bp);
80101c0e:	83 ec 0c             	sub    $0xc,%esp
80101c11:	ff 75 e4             	pushl  -0x1c(%ebp)
80101c14:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c17:	e8 c4 e5 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101c1c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101c22:	8b 03                	mov    (%ebx),%eax
80101c24:	e8 07 fb ff ff       	call   80101730 <bfree>
    ip->addrs[NDIRECT] = 0;
80101c29:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101c30:	00 00 00 
80101c33:	83 c4 10             	add    $0x10,%esp
80101c36:	e9 62 ff ff ff       	jmp    80101b9d <iput+0xbd>
80101c3b:	90                   	nop
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c40 <iunlockput>:
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	53                   	push   %ebx
80101c44:	83 ec 10             	sub    $0x10,%esp
80101c47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101c4a:	53                   	push   %ebx
80101c4b:	e8 40 fe ff ff       	call   80101a90 <iunlock>
  iput(ip);
80101c50:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101c53:	83 c4 10             	add    $0x10,%esp
}
80101c56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c59:	c9                   	leave  
  iput(ip);
80101c5a:	e9 81 fe ff ff       	jmp    80101ae0 <iput>
80101c5f:	90                   	nop

80101c60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	8b 55 08             	mov    0x8(%ebp),%edx
80101c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101c69:	8b 0a                	mov    (%edx),%ecx
80101c6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101c6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101c71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101c74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101c78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101c7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101c7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101c83:	8b 52 58             	mov    0x58(%edx),%edx
80101c86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101c89:	5d                   	pop    %ebp
80101c8a:	c3                   	ret    
80101c8b:	90                   	nop
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	56                   	push   %esi
80101c95:	53                   	push   %ebx
80101c96:	83 ec 1c             	sub    $0x1c,%esp
80101c99:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ca2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ca7:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101caa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cad:	8b 75 10             	mov    0x10(%ebp),%esi
80101cb0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101cb3:	0f 84 a7 00 00 00    	je     80101d60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101cb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cbc:	8b 40 58             	mov    0x58(%eax),%eax
80101cbf:	39 c6                	cmp    %eax,%esi
80101cc1:	0f 87 ba 00 00 00    	ja     80101d81 <readi+0xf1>
80101cc7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101cca:	89 f9                	mov    %edi,%ecx
80101ccc:	01 f1                	add    %esi,%ecx
80101cce:	0f 82 ad 00 00 00    	jb     80101d81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101cd4:	89 c2                	mov    %eax,%edx
80101cd6:	29 f2                	sub    %esi,%edx
80101cd8:	39 c8                	cmp    %ecx,%eax
80101cda:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cdd:	31 ff                	xor    %edi,%edi
80101cdf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101ce1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ce4:	74 6c                	je     80101d52 <readi+0xc2>
80101ce6:	8d 76 00             	lea    0x0(%esi),%esi
80101ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cf0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101cf3:	89 f2                	mov    %esi,%edx
80101cf5:	c1 ea 09             	shr    $0x9,%edx
80101cf8:	89 d8                	mov    %ebx,%eax
80101cfa:	e8 11 f9 ff ff       	call   80101610 <bmap>
80101cff:	83 ec 08             	sub    $0x8,%esp
80101d02:	50                   	push   %eax
80101d03:	ff 33                	pushl  (%ebx)
80101d05:	e8 c6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d0d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d0f:	89 f0                	mov    %esi,%eax
80101d11:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d16:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d1b:	83 c4 0c             	add    $0xc,%esp
80101d1e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101d20:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101d24:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101d27:	29 fb                	sub    %edi,%ebx
80101d29:	39 d9                	cmp    %ebx,%ecx
80101d2b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d2e:	53                   	push   %ebx
80101d2f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d30:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101d32:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d35:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101d37:	e8 f4 2a 00 00       	call   80104830 <memmove>
    brelse(bp);
80101d3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d3f:	89 14 24             	mov    %edx,(%esp)
80101d42:	e8 99 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101d4a:	83 c4 10             	add    $0x10,%esp
80101d4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101d50:	77 9e                	ja     80101cf0 <readi+0x60>
  }
  return n;
80101d52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d58:	5b                   	pop    %ebx
80101d59:	5e                   	pop    %esi
80101d5a:	5f                   	pop    %edi
80101d5b:	5d                   	pop    %ebp
80101d5c:	c3                   	ret    
80101d5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d64:	66 83 f8 09          	cmp    $0x9,%ax
80101d68:	77 17                	ja     80101d81 <readi+0xf1>
80101d6a:	8b 04 c5 20 0c 11 80 	mov    -0x7feef3e0(,%eax,8),%eax
80101d71:	85 c0                	test   %eax,%eax
80101d73:	74 0c                	je     80101d81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101d75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7b:	5b                   	pop    %ebx
80101d7c:	5e                   	pop    %esi
80101d7d:	5f                   	pop    %edi
80101d7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101d7f:	ff e0                	jmp    *%eax
      return -1;
80101d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d86:	eb cd                	jmp    80101d55 <readi+0xc5>
80101d88:	90                   	nop
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	83 ec 1c             	sub    $0x1c,%esp
80101d99:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101da2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101da7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101daa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101dad:	8b 75 10             	mov    0x10(%ebp),%esi
80101db0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101db3:	0f 84 b7 00 00 00    	je     80101e70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101db9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dbc:	39 70 58             	cmp    %esi,0x58(%eax)
80101dbf:	0f 82 eb 00 00 00    	jb     80101eb0 <writei+0x120>
80101dc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101dc8:	31 d2                	xor    %edx,%edx
80101dca:	89 f8                	mov    %edi,%eax
80101dcc:	01 f0                	add    %esi,%eax
80101dce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101dd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101dd6:	0f 87 d4 00 00 00    	ja     80101eb0 <writei+0x120>
80101ddc:	85 d2                	test   %edx,%edx
80101dde:	0f 85 cc 00 00 00    	jne    80101eb0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101de4:	85 ff                	test   %edi,%edi
80101de6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ded:	74 72                	je     80101e61 <writei+0xd1>
80101def:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101df0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101df3:	89 f2                	mov    %esi,%edx
80101df5:	c1 ea 09             	shr    $0x9,%edx
80101df8:	89 f8                	mov    %edi,%eax
80101dfa:	e8 11 f8 ff ff       	call   80101610 <bmap>
80101dff:	83 ec 08             	sub    $0x8,%esp
80101e02:	50                   	push   %eax
80101e03:	ff 37                	pushl  (%edi)
80101e05:	e8 c6 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e0a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101e0d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e10:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101e12:	89 f0                	mov    %esi,%eax
80101e14:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e19:	83 c4 0c             	add    $0xc,%esp
80101e1c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e21:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101e23:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101e27:	39 d9                	cmp    %ebx,%ecx
80101e29:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101e2c:	53                   	push   %ebx
80101e2d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e30:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101e32:	50                   	push   %eax
80101e33:	e8 f8 29 00 00       	call   80104830 <memmove>
    log_write(bp);
80101e38:	89 3c 24             	mov    %edi,(%esp)
80101e3b:	e8 60 12 00 00       	call   801030a0 <log_write>
    brelse(bp);
80101e40:	89 3c 24             	mov    %edi,(%esp)
80101e43:	e8 98 e3 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101e4b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101e4e:	83 c4 10             	add    $0x10,%esp
80101e51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101e57:	77 97                	ja     80101df0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101e59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101e5f:	77 37                	ja     80101e98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101e61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e67:	5b                   	pop    %ebx
80101e68:	5e                   	pop    %esi
80101e69:	5f                   	pop    %edi
80101e6a:	5d                   	pop    %ebp
80101e6b:	c3                   	ret    
80101e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101e70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e74:	66 83 f8 09          	cmp    $0x9,%ax
80101e78:	77 36                	ja     80101eb0 <writei+0x120>
80101e7a:	8b 04 c5 24 0c 11 80 	mov    -0x7feef3dc(,%eax,8),%eax
80101e81:	85 c0                	test   %eax,%eax
80101e83:	74 2b                	je     80101eb0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101e85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e8b:	5b                   	pop    %ebx
80101e8c:	5e                   	pop    %esi
80101e8d:	5f                   	pop    %edi
80101e8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101e8f:	ff e0                	jmp    *%eax
80101e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101e98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101e9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101e9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ea1:	50                   	push   %eax
80101ea2:	e8 59 fa ff ff       	call   80101900 <iupdate>
80101ea7:	83 c4 10             	add    $0x10,%esp
80101eaa:	eb b5                	jmp    80101e61 <writei+0xd1>
80101eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb5:	eb ad                	jmp    80101e64 <writei+0xd4>
80101eb7:	89 f6                	mov    %esi,%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ec0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ec6:	6a 0e                	push   $0xe
80101ec8:	ff 75 0c             	pushl  0xc(%ebp)
80101ecb:	ff 75 08             	pushl  0x8(%ebp)
80101ece:	e8 cd 29 00 00       	call   801048a0 <strncmp>
}
80101ed3:	c9                   	leave  
80101ed4:	c3                   	ret    
80101ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
80101ee3:	57                   	push   %edi
80101ee4:	56                   	push   %esi
80101ee5:	53                   	push   %ebx
80101ee6:	83 ec 1c             	sub    $0x1c,%esp
80101ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101eec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ef1:	0f 85 85 00 00 00    	jne    80101f7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ef7:	8b 53 58             	mov    0x58(%ebx),%edx
80101efa:	31 ff                	xor    %edi,%edi
80101efc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101eff:	85 d2                	test   %edx,%edx
80101f01:	74 3e                	je     80101f41 <dirlookup+0x61>
80101f03:	90                   	nop
80101f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f08:	6a 10                	push   $0x10
80101f0a:	57                   	push   %edi
80101f0b:	56                   	push   %esi
80101f0c:	53                   	push   %ebx
80101f0d:	e8 7e fd ff ff       	call   80101c90 <readi>
80101f12:	83 c4 10             	add    $0x10,%esp
80101f15:	83 f8 10             	cmp    $0x10,%eax
80101f18:	75 55                	jne    80101f6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101f1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f1f:	74 18                	je     80101f39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101f21:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f24:	83 ec 04             	sub    $0x4,%esp
80101f27:	6a 0e                	push   $0xe
80101f29:	50                   	push   %eax
80101f2a:	ff 75 0c             	pushl  0xc(%ebp)
80101f2d:	e8 6e 29 00 00       	call   801048a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101f32:	83 c4 10             	add    $0x10,%esp
80101f35:	85 c0                	test   %eax,%eax
80101f37:	74 17                	je     80101f50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f39:	83 c7 10             	add    $0x10,%edi
80101f3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f3f:	72 c7                	jb     80101f08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101f44:	31 c0                	xor    %eax,%eax
}
80101f46:	5b                   	pop    %ebx
80101f47:	5e                   	pop    %esi
80101f48:	5f                   	pop    %edi
80101f49:	5d                   	pop    %ebp
80101f4a:	c3                   	ret    
80101f4b:	90                   	nop
80101f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101f50:	8b 45 10             	mov    0x10(%ebp),%eax
80101f53:	85 c0                	test   %eax,%eax
80101f55:	74 05                	je     80101f5c <dirlookup+0x7c>
        *poff = off;
80101f57:	8b 45 10             	mov    0x10(%ebp),%eax
80101f5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101f5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101f60:	8b 03                	mov    (%ebx),%eax
80101f62:	e8 d9 f5 ff ff       	call   80101540 <iget>
}
80101f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6a:	5b                   	pop    %ebx
80101f6b:	5e                   	pop    %esi
80101f6c:	5f                   	pop    %edi
80101f6d:	5d                   	pop    %ebp
80101f6e:	c3                   	ret    
      panic("dirlookup read");
80101f6f:	83 ec 0c             	sub    $0xc,%esp
80101f72:	68 39 73 10 80       	push   $0x80107339
80101f77:	e8 14 e4 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101f7c:	83 ec 0c             	sub    $0xc,%esp
80101f7f:	68 27 73 10 80       	push   $0x80107327
80101f84:	e8 07 e4 ff ff       	call   80100390 <panic>
80101f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	57                   	push   %edi
80101f94:	56                   	push   %esi
80101f95:	53                   	push   %ebx
80101f96:	89 cf                	mov    %ecx,%edi
80101f98:	89 c3                	mov    %eax,%ebx
80101f9a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f9d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101fa0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101fa3:	0f 84 67 01 00 00    	je     80102110 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101fa9:	e8 62 1b 00 00       	call   80103b10 <myproc>
  acquire(&icache.lock);
80101fae:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101fb1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101fb4:	68 a0 0c 11 80       	push   $0x80110ca0
80101fb9:	e8 b2 26 00 00       	call   80104670 <acquire>
  ip->ref++;
80101fbe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101fc2:	c7 04 24 a0 0c 11 80 	movl   $0x80110ca0,(%esp)
80101fc9:	e8 62 27 00 00       	call   80104730 <release>
80101fce:	83 c4 10             	add    $0x10,%esp
80101fd1:	eb 08                	jmp    80101fdb <namex+0x4b>
80101fd3:	90                   	nop
80101fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101fd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101fdb:	0f b6 03             	movzbl (%ebx),%eax
80101fde:	3c 2f                	cmp    $0x2f,%al
80101fe0:	74 f6                	je     80101fd8 <namex+0x48>
  if(*path == 0)
80101fe2:	84 c0                	test   %al,%al
80101fe4:	0f 84 ee 00 00 00    	je     801020d8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101fea:	0f b6 03             	movzbl (%ebx),%eax
80101fed:	3c 2f                	cmp    $0x2f,%al
80101fef:	0f 84 b3 00 00 00    	je     801020a8 <namex+0x118>
80101ff5:	84 c0                	test   %al,%al
80101ff7:	89 da                	mov    %ebx,%edx
80101ff9:	75 09                	jne    80102004 <namex+0x74>
80101ffb:	e9 a8 00 00 00       	jmp    801020a8 <namex+0x118>
80102000:	84 c0                	test   %al,%al
80102002:	74 0a                	je     8010200e <namex+0x7e>
    path++;
80102004:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80102007:	0f b6 02             	movzbl (%edx),%eax
8010200a:	3c 2f                	cmp    $0x2f,%al
8010200c:	75 f2                	jne    80102000 <namex+0x70>
8010200e:	89 d1                	mov    %edx,%ecx
80102010:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80102012:	83 f9 0d             	cmp    $0xd,%ecx
80102015:	0f 8e 91 00 00 00    	jle    801020ac <namex+0x11c>
    memmove(name, s, DIRSIZ);
8010201b:	83 ec 04             	sub    $0x4,%esp
8010201e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102021:	6a 0e                	push   $0xe
80102023:	53                   	push   %ebx
80102024:	57                   	push   %edi
80102025:	e8 06 28 00 00       	call   80104830 <memmove>
    path++;
8010202a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
8010202d:	83 c4 10             	add    $0x10,%esp
    path++;
80102030:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80102032:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102035:	75 11                	jne    80102048 <namex+0xb8>
80102037:	89 f6                	mov    %esi,%esi
80102039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80102040:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80102043:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102046:	74 f8                	je     80102040 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102048:	83 ec 0c             	sub    $0xc,%esp
8010204b:	56                   	push   %esi
8010204c:	e8 5f f9 ff ff       	call   801019b0 <ilock>
    if(ip->type != T_DIR){
80102051:	83 c4 10             	add    $0x10,%esp
80102054:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102059:	0f 85 91 00 00 00    	jne    801020f0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010205f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102062:	85 d2                	test   %edx,%edx
80102064:	74 09                	je     8010206f <namex+0xdf>
80102066:	80 3b 00             	cmpb   $0x0,(%ebx)
80102069:	0f 84 b7 00 00 00    	je     80102126 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010206f:	83 ec 04             	sub    $0x4,%esp
80102072:	6a 00                	push   $0x0
80102074:	57                   	push   %edi
80102075:	56                   	push   %esi
80102076:	e8 65 fe ff ff       	call   80101ee0 <dirlookup>
8010207b:	83 c4 10             	add    $0x10,%esp
8010207e:	85 c0                	test   %eax,%eax
80102080:	74 6e                	je     801020f0 <namex+0x160>
  iunlock(ip);
80102082:	83 ec 0c             	sub    $0xc,%esp
80102085:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102088:	56                   	push   %esi
80102089:	e8 02 fa ff ff       	call   80101a90 <iunlock>
  iput(ip);
8010208e:	89 34 24             	mov    %esi,(%esp)
80102091:	e8 4a fa ff ff       	call   80101ae0 <iput>
80102096:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	89 c6                	mov    %eax,%esi
8010209e:	e9 38 ff ff ff       	jmp    80101fdb <namex+0x4b>
801020a3:	90                   	nop
801020a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
801020a8:	89 da                	mov    %ebx,%edx
801020aa:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
801020ac:	83 ec 04             	sub    $0x4,%esp
801020af:	89 55 dc             	mov    %edx,-0x24(%ebp)
801020b2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801020b5:	51                   	push   %ecx
801020b6:	53                   	push   %ebx
801020b7:	57                   	push   %edi
801020b8:	e8 73 27 00 00       	call   80104830 <memmove>
    name[len] = 0;
801020bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801020c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801020c3:	83 c4 10             	add    $0x10,%esp
801020c6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
801020ca:	89 d3                	mov    %edx,%ebx
801020cc:	e9 61 ff ff ff       	jmp    80102032 <namex+0xa2>
801020d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801020d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801020db:	85 c0                	test   %eax,%eax
801020dd:	75 5d                	jne    8010213c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
801020df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e2:	89 f0                	mov    %esi,%eax
801020e4:	5b                   	pop    %ebx
801020e5:	5e                   	pop    %esi
801020e6:	5f                   	pop    %edi
801020e7:	5d                   	pop    %ebp
801020e8:	c3                   	ret    
801020e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801020f0:	83 ec 0c             	sub    $0xc,%esp
801020f3:	56                   	push   %esi
801020f4:	e8 97 f9 ff ff       	call   80101a90 <iunlock>
  iput(ip);
801020f9:	89 34 24             	mov    %esi,(%esp)
      return 0;
801020fc:	31 f6                	xor    %esi,%esi
  iput(ip);
801020fe:	e8 dd f9 ff ff       	call   80101ae0 <iput>
      return 0;
80102103:	83 c4 10             	add    $0x10,%esp
}
80102106:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102109:	89 f0                	mov    %esi,%eax
8010210b:	5b                   	pop    %ebx
8010210c:	5e                   	pop    %esi
8010210d:	5f                   	pop    %edi
8010210e:	5d                   	pop    %ebp
8010210f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102110:	ba 01 00 00 00       	mov    $0x1,%edx
80102115:	b8 01 00 00 00       	mov    $0x1,%eax
8010211a:	e8 21 f4 ff ff       	call   80101540 <iget>
8010211f:	89 c6                	mov    %eax,%esi
80102121:	e9 b5 fe ff ff       	jmp    80101fdb <namex+0x4b>
      iunlock(ip);
80102126:	83 ec 0c             	sub    $0xc,%esp
80102129:	56                   	push   %esi
8010212a:	e8 61 f9 ff ff       	call   80101a90 <iunlock>
      return ip;
8010212f:	83 c4 10             	add    $0x10,%esp
}
80102132:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102135:	89 f0                	mov    %esi,%eax
80102137:	5b                   	pop    %ebx
80102138:	5e                   	pop    %esi
80102139:	5f                   	pop    %edi
8010213a:	5d                   	pop    %ebp
8010213b:	c3                   	ret    
    iput(ip);
8010213c:	83 ec 0c             	sub    $0xc,%esp
8010213f:	56                   	push   %esi
    return 0;
80102140:	31 f6                	xor    %esi,%esi
    iput(ip);
80102142:	e8 99 f9 ff ff       	call   80101ae0 <iput>
    return 0;
80102147:	83 c4 10             	add    $0x10,%esp
8010214a:	eb 93                	jmp    801020df <namex+0x14f>
8010214c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102150 <dirlink>:
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	57                   	push   %edi
80102154:	56                   	push   %esi
80102155:	53                   	push   %ebx
80102156:	83 ec 20             	sub    $0x20,%esp
80102159:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010215c:	6a 00                	push   $0x0
8010215e:	ff 75 0c             	pushl  0xc(%ebp)
80102161:	53                   	push   %ebx
80102162:	e8 79 fd ff ff       	call   80101ee0 <dirlookup>
80102167:	83 c4 10             	add    $0x10,%esp
8010216a:	85 c0                	test   %eax,%eax
8010216c:	75 67                	jne    801021d5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010216e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102171:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102174:	85 ff                	test   %edi,%edi
80102176:	74 29                	je     801021a1 <dirlink+0x51>
80102178:	31 ff                	xor    %edi,%edi
8010217a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010217d:	eb 09                	jmp    80102188 <dirlink+0x38>
8010217f:	90                   	nop
80102180:	83 c7 10             	add    $0x10,%edi
80102183:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102186:	73 19                	jae    801021a1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102188:	6a 10                	push   $0x10
8010218a:	57                   	push   %edi
8010218b:	56                   	push   %esi
8010218c:	53                   	push   %ebx
8010218d:	e8 fe fa ff ff       	call   80101c90 <readi>
80102192:	83 c4 10             	add    $0x10,%esp
80102195:	83 f8 10             	cmp    $0x10,%eax
80102198:	75 4e                	jne    801021e8 <dirlink+0x98>
    if(de.inum == 0)
8010219a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010219f:	75 df                	jne    80102180 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801021a1:	8d 45 da             	lea    -0x26(%ebp),%eax
801021a4:	83 ec 04             	sub    $0x4,%esp
801021a7:	6a 0e                	push   $0xe
801021a9:	ff 75 0c             	pushl  0xc(%ebp)
801021ac:	50                   	push   %eax
801021ad:	e8 4e 27 00 00       	call   80104900 <strncpy>
  de.inum = inum;
801021b2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021b5:	6a 10                	push   $0x10
801021b7:	57                   	push   %edi
801021b8:	56                   	push   %esi
801021b9:	53                   	push   %ebx
  de.inum = inum;
801021ba:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021be:	e8 cd fb ff ff       	call   80101d90 <writei>
801021c3:	83 c4 20             	add    $0x20,%esp
801021c6:	83 f8 10             	cmp    $0x10,%eax
801021c9:	75 2a                	jne    801021f5 <dirlink+0xa5>
  return 0;
801021cb:	31 c0                	xor    %eax,%eax
}
801021cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021d0:	5b                   	pop    %ebx
801021d1:	5e                   	pop    %esi
801021d2:	5f                   	pop    %edi
801021d3:	5d                   	pop    %ebp
801021d4:	c3                   	ret    
    iput(ip);
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	50                   	push   %eax
801021d9:	e8 02 f9 ff ff       	call   80101ae0 <iput>
    return -1;
801021de:	83 c4 10             	add    $0x10,%esp
801021e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021e6:	eb e5                	jmp    801021cd <dirlink+0x7d>
      panic("dirlink read");
801021e8:	83 ec 0c             	sub    $0xc,%esp
801021eb:	68 48 73 10 80       	push   $0x80107348
801021f0:	e8 9b e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
801021f5:	83 ec 0c             	sub    $0xc,%esp
801021f8:	68 3e 79 10 80       	push   $0x8010793e
801021fd:	e8 8e e1 ff ff       	call   80100390 <panic>
80102202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102210 <namei>:

struct inode*
namei(char *path)
{
80102210:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102211:	31 d2                	xor    %edx,%edx
{
80102213:	89 e5                	mov    %esp,%ebp
80102215:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102218:	8b 45 08             	mov    0x8(%ebp),%eax
8010221b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010221e:	e8 6d fd ff ff       	call   80101f90 <namex>
}
80102223:	c9                   	leave  
80102224:	c3                   	ret    
80102225:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102230 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102230:	55                   	push   %ebp
  return namex(path, 1, name);
80102231:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102236:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102238:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010223b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010223e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010223f:	e9 4c fd ff ff       	jmp    80101f90 <namex>
80102244:	66 90                	xchg   %ax,%ax
80102246:	66 90                	xchg   %ax,%ax
80102248:	66 90                	xchg   %ax,%ax
8010224a:	66 90                	xchg   %ax,%ax
8010224c:	66 90                	xchg   %ax,%ax
8010224e:	66 90                	xchg   %ax,%ax

80102250 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102259:	85 c0                	test   %eax,%eax
8010225b:	0f 84 b4 00 00 00    	je     80102315 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102261:	8b 58 08             	mov    0x8(%eax),%ebx
80102264:	89 c6                	mov    %eax,%esi
80102266:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010226c:	0f 87 96 00 00 00    	ja     80102308 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102277:	89 f6                	mov    %esi,%esi
80102279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102280:	89 ca                	mov    %ecx,%edx
80102282:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102283:	83 e0 c0             	and    $0xffffffc0,%eax
80102286:	3c 40                	cmp    $0x40,%al
80102288:	75 f6                	jne    80102280 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010228a:	31 ff                	xor    %edi,%edi
8010228c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102291:	89 f8                	mov    %edi,%eax
80102293:	ee                   	out    %al,(%dx)
80102294:	b8 01 00 00 00       	mov    $0x1,%eax
80102299:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010229e:	ee                   	out    %al,(%dx)
8010229f:	ba f3 01 00 00       	mov    $0x1f3,%edx
801022a4:	89 d8                	mov    %ebx,%eax
801022a6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801022a7:	89 d8                	mov    %ebx,%eax
801022a9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801022ae:	c1 f8 08             	sar    $0x8,%eax
801022b1:	ee                   	out    %al,(%dx)
801022b2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801022b7:	89 f8                	mov    %edi,%eax
801022b9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801022ba:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801022be:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022c3:	c1 e0 04             	shl    $0x4,%eax
801022c6:	83 e0 10             	and    $0x10,%eax
801022c9:	83 c8 e0             	or     $0xffffffe0,%eax
801022cc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801022cd:	f6 06 04             	testb  $0x4,(%esi)
801022d0:	75 16                	jne    801022e8 <idestart+0x98>
801022d2:	b8 20 00 00 00       	mov    $0x20,%eax
801022d7:	89 ca                	mov    %ecx,%edx
801022d9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801022da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022dd:	5b                   	pop    %ebx
801022de:	5e                   	pop    %esi
801022df:	5f                   	pop    %edi
801022e0:	5d                   	pop    %ebp
801022e1:	c3                   	ret    
801022e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022e8:	b8 30 00 00 00       	mov    $0x30,%eax
801022ed:	89 ca                	mov    %ecx,%edx
801022ef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801022f0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801022f5:	83 c6 5c             	add    $0x5c,%esi
801022f8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022fd:	fc                   	cld    
801022fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102300:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102303:	5b                   	pop    %ebx
80102304:	5e                   	pop    %esi
80102305:	5f                   	pop    %edi
80102306:	5d                   	pop    %ebp
80102307:	c3                   	ret    
    panic("incorrect blockno");
80102308:	83 ec 0c             	sub    $0xc,%esp
8010230b:	68 b4 73 10 80       	push   $0x801073b4
80102310:	e8 7b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
80102315:	83 ec 0c             	sub    $0xc,%esp
80102318:	68 ab 73 10 80       	push   $0x801073ab
8010231d:	e8 6e e0 ff ff       	call   80100390 <panic>
80102322:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102330 <ideinit>:
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102336:	68 c6 73 10 80       	push   $0x801073c6
8010233b:	68 c0 a5 10 80       	push   $0x8010a5c0
80102340:	e8 eb 21 00 00       	call   80104530 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102345:	58                   	pop    %eax
80102346:	a1 c0 2f 11 80       	mov    0x80112fc0,%eax
8010234b:	5a                   	pop    %edx
8010234c:	83 e8 01             	sub    $0x1,%eax
8010234f:	50                   	push   %eax
80102350:	6a 0e                	push   $0xe
80102352:	e8 a9 02 00 00       	call   80102600 <ioapicenable>
80102357:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010235a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010235f:	90                   	nop
80102360:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102361:	83 e0 c0             	and    $0xffffffc0,%eax
80102364:	3c 40                	cmp    $0x40,%al
80102366:	75 f8                	jne    80102360 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102368:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010236d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102372:	ee                   	out    %al,(%dx)
80102373:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102378:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010237d:	eb 06                	jmp    80102385 <ideinit+0x55>
8010237f:	90                   	nop
  for(i=0; i<1000; i++){
80102380:	83 e9 01             	sub    $0x1,%ecx
80102383:	74 0f                	je     80102394 <ideinit+0x64>
80102385:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102386:	84 c0                	test   %al,%al
80102388:	74 f6                	je     80102380 <ideinit+0x50>
      havedisk1 = 1;
8010238a:	c7 05 a0 a5 10 80 01 	movl   $0x1,0x8010a5a0
80102391:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102394:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102399:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010239e:	ee                   	out    %al,(%dx)
}
8010239f:	c9                   	leave  
801023a0:	c3                   	ret    
801023a1:	eb 0d                	jmp    801023b0 <ideintr>
801023a3:	90                   	nop
801023a4:	90                   	nop
801023a5:	90                   	nop
801023a6:	90                   	nop
801023a7:	90                   	nop
801023a8:	90                   	nop
801023a9:	90                   	nop
801023aa:	90                   	nop
801023ab:	90                   	nop
801023ac:	90                   	nop
801023ad:	90                   	nop
801023ae:	90                   	nop
801023af:	90                   	nop

801023b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	57                   	push   %edi
801023b4:	56                   	push   %esi
801023b5:	53                   	push   %ebx
801023b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801023b9:	68 c0 a5 10 80       	push   $0x8010a5c0
801023be:	e8 ad 22 00 00       	call   80104670 <acquire>

  if((b = idequeue) == 0){
801023c3:	8b 1d a4 a5 10 80    	mov    0x8010a5a4,%ebx
801023c9:	83 c4 10             	add    $0x10,%esp
801023cc:	85 db                	test   %ebx,%ebx
801023ce:	74 67                	je     80102437 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801023d0:	8b 43 58             	mov    0x58(%ebx),%eax
801023d3:	a3 a4 a5 10 80       	mov    %eax,0x8010a5a4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801023d8:	8b 3b                	mov    (%ebx),%edi
801023da:	f7 c7 04 00 00 00    	test   $0x4,%edi
801023e0:	75 31                	jne    80102413 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023e7:	89 f6                	mov    %esi,%esi
801023e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801023f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023f1:	89 c6                	mov    %eax,%esi
801023f3:	83 e6 c0             	and    $0xffffffc0,%esi
801023f6:	89 f1                	mov    %esi,%ecx
801023f8:	80 f9 40             	cmp    $0x40,%cl
801023fb:	75 f3                	jne    801023f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801023fd:	a8 21                	test   $0x21,%al
801023ff:	75 12                	jne    80102413 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102401:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102404:	b9 80 00 00 00       	mov    $0x80,%ecx
80102409:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010240e:	fc                   	cld    
8010240f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102411:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102413:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102416:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102419:	89 f9                	mov    %edi,%ecx
8010241b:	83 c9 02             	or     $0x2,%ecx
8010241e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102420:	53                   	push   %ebx
80102421:	e8 3a 1e 00 00       	call   80104260 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102426:	a1 a4 a5 10 80       	mov    0x8010a5a4,%eax
8010242b:	83 c4 10             	add    $0x10,%esp
8010242e:	85 c0                	test   %eax,%eax
80102430:	74 05                	je     80102437 <ideintr+0x87>
    idestart(idequeue);
80102432:	e8 19 fe ff ff       	call   80102250 <idestart>
    release(&idelock);
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 c0 a5 10 80       	push   $0x8010a5c0
8010243f:	e8 ec 22 00 00       	call   80104730 <release>

  release(&idelock);
}
80102444:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102447:	5b                   	pop    %ebx
80102448:	5e                   	pop    %esi
80102449:	5f                   	pop    %edi
8010244a:	5d                   	pop    %ebp
8010244b:	c3                   	ret    
8010244c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102450 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	53                   	push   %ebx
80102454:	83 ec 10             	sub    $0x10,%esp
80102457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010245a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010245d:	50                   	push   %eax
8010245e:	e8 7d 20 00 00       	call   801044e0 <holdingsleep>
80102463:	83 c4 10             	add    $0x10,%esp
80102466:	85 c0                	test   %eax,%eax
80102468:	0f 84 c6 00 00 00    	je     80102534 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010246e:	8b 03                	mov    (%ebx),%eax
80102470:	83 e0 06             	and    $0x6,%eax
80102473:	83 f8 02             	cmp    $0x2,%eax
80102476:	0f 84 ab 00 00 00    	je     80102527 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010247c:	8b 53 04             	mov    0x4(%ebx),%edx
8010247f:	85 d2                	test   %edx,%edx
80102481:	74 0d                	je     80102490 <iderw+0x40>
80102483:	a1 a0 a5 10 80       	mov    0x8010a5a0,%eax
80102488:	85 c0                	test   %eax,%eax
8010248a:	0f 84 b1 00 00 00    	je     80102541 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102490:	83 ec 0c             	sub    $0xc,%esp
80102493:	68 c0 a5 10 80       	push   $0x8010a5c0
80102498:	e8 d3 21 00 00       	call   80104670 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010249d:	8b 15 a4 a5 10 80    	mov    0x8010a5a4,%edx
801024a3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801024a6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024ad:	85 d2                	test   %edx,%edx
801024af:	75 09                	jne    801024ba <iderw+0x6a>
801024b1:	eb 6d                	jmp    80102520 <iderw+0xd0>
801024b3:	90                   	nop
801024b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b8:	89 c2                	mov    %eax,%edx
801024ba:	8b 42 58             	mov    0x58(%edx),%eax
801024bd:	85 c0                	test   %eax,%eax
801024bf:	75 f7                	jne    801024b8 <iderw+0x68>
801024c1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801024c4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801024c6:	39 1d a4 a5 10 80    	cmp    %ebx,0x8010a5a4
801024cc:	74 42                	je     80102510 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024ce:	8b 03                	mov    (%ebx),%eax
801024d0:	83 e0 06             	and    $0x6,%eax
801024d3:	83 f8 02             	cmp    $0x2,%eax
801024d6:	74 23                	je     801024fb <iderw+0xab>
801024d8:	90                   	nop
801024d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801024e0:	83 ec 08             	sub    $0x8,%esp
801024e3:	68 c0 a5 10 80       	push   $0x8010a5c0
801024e8:	53                   	push   %ebx
801024e9:	e8 c2 1b 00 00       	call   801040b0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024ee:	8b 03                	mov    (%ebx),%eax
801024f0:	83 c4 10             	add    $0x10,%esp
801024f3:	83 e0 06             	and    $0x6,%eax
801024f6:	83 f8 02             	cmp    $0x2,%eax
801024f9:	75 e5                	jne    801024e0 <iderw+0x90>
  }


  release(&idelock);
801024fb:	c7 45 08 c0 a5 10 80 	movl   $0x8010a5c0,0x8(%ebp)
}
80102502:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102505:	c9                   	leave  
  release(&idelock);
80102506:	e9 25 22 00 00       	jmp    80104730 <release>
8010250b:	90                   	nop
8010250c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102510:	89 d8                	mov    %ebx,%eax
80102512:	e8 39 fd ff ff       	call   80102250 <idestart>
80102517:	eb b5                	jmp    801024ce <iderw+0x7e>
80102519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102520:	ba a4 a5 10 80       	mov    $0x8010a5a4,%edx
80102525:	eb 9d                	jmp    801024c4 <iderw+0x74>
    panic("iderw: nothing to do");
80102527:	83 ec 0c             	sub    $0xc,%esp
8010252a:	68 e0 73 10 80       	push   $0x801073e0
8010252f:	e8 5c de ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102534:	83 ec 0c             	sub    $0xc,%esp
80102537:	68 ca 73 10 80       	push   $0x801073ca
8010253c:	e8 4f de ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102541:	83 ec 0c             	sub    $0xc,%esp
80102544:	68 f5 73 10 80       	push   $0x801073f5
80102549:	e8 42 de ff ff       	call   80100390 <panic>
8010254e:	66 90                	xchg   %ax,%ax

80102550 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102550:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102551:	c7 05 f4 28 11 80 00 	movl   $0xfec00000,0x801128f4
80102558:	00 c0 fe 
{
8010255b:	89 e5                	mov    %esp,%ebp
8010255d:	56                   	push   %esi
8010255e:	53                   	push   %ebx
  ioapic->reg = reg;
8010255f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102566:	00 00 00 
  return ioapic->data;
80102569:	a1 f4 28 11 80       	mov    0x801128f4,%eax
8010256e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102571:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102577:	8b 0d f4 28 11 80    	mov    0x801128f4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010257d:	0f b6 15 20 2a 11 80 	movzbl 0x80112a20,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102584:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102587:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010258a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010258d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102590:	39 c2                	cmp    %eax,%edx
80102592:	74 16                	je     801025aa <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102594:	83 ec 0c             	sub    $0xc,%esp
80102597:	68 14 74 10 80       	push   $0x80107414
8010259c:	e8 bf e0 ff ff       	call   80100660 <cprintf>
801025a1:	8b 0d f4 28 11 80    	mov    0x801128f4,%ecx
801025a7:	83 c4 10             	add    $0x10,%esp
801025aa:	83 c3 21             	add    $0x21,%ebx
{
801025ad:	ba 10 00 00 00       	mov    $0x10,%edx
801025b2:	b8 20 00 00 00       	mov    $0x20,%eax
801025b7:	89 f6                	mov    %esi,%esi
801025b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801025c0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801025c2:	8b 0d f4 28 11 80    	mov    0x801128f4,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801025c8:	89 c6                	mov    %eax,%esi
801025ca:	81 ce 00 00 01 00    	or     $0x10000,%esi
801025d0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801025d3:	89 71 10             	mov    %esi,0x10(%ecx)
801025d6:	8d 72 01             	lea    0x1(%edx),%esi
801025d9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801025dc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801025de:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801025e0:	8b 0d f4 28 11 80    	mov    0x801128f4,%ecx
801025e6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801025ed:	75 d1                	jne    801025c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801025ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025f2:	5b                   	pop    %ebx
801025f3:	5e                   	pop    %esi
801025f4:	5d                   	pop    %ebp
801025f5:	c3                   	ret    
801025f6:	8d 76 00             	lea    0x0(%esi),%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102600 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102600:	55                   	push   %ebp
  ioapic->reg = reg;
80102601:	8b 0d f4 28 11 80    	mov    0x801128f4,%ecx
{
80102607:	89 e5                	mov    %esp,%ebp
80102609:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010260c:	8d 50 20             	lea    0x20(%eax),%edx
8010260f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102613:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102615:	8b 0d f4 28 11 80    	mov    0x801128f4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010261b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010261e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102621:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102624:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102626:	a1 f4 28 11 80       	mov    0x801128f4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010262b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010262e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102631:	5d                   	pop    %ebp
80102632:	c3                   	ret    
80102633:	66 90                	xchg   %ax,%ax
80102635:	66 90                	xchg   %ax,%ax
80102637:	66 90                	xchg   %ax,%ax
80102639:	66 90                	xchg   %ax,%ax
8010263b:	66 90                	xchg   %ax,%ax
8010263d:	66 90                	xchg   %ax,%ax
8010263f:	90                   	nop

80102640 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	53                   	push   %ebx
80102644:	83 ec 04             	sub    $0x4,%esp
80102647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010264a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102650:	75 70                	jne    801026c2 <kfree+0x82>
80102652:	81 fb 68 57 11 80    	cmp    $0x80115768,%ebx
80102658:	72 68                	jb     801026c2 <kfree+0x82>
8010265a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102660:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102665:	77 5b                	ja     801026c2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102667:	83 ec 04             	sub    $0x4,%esp
8010266a:	68 00 10 00 00       	push   $0x1000
8010266f:	6a 01                	push   $0x1
80102671:	53                   	push   %ebx
80102672:	e8 09 21 00 00       	call   80104780 <memset>

  if(kmem.use_lock)
80102677:	8b 15 34 29 11 80    	mov    0x80112934,%edx
8010267d:	83 c4 10             	add    $0x10,%esp
80102680:	85 d2                	test   %edx,%edx
80102682:	75 2c                	jne    801026b0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102684:	a1 38 29 11 80       	mov    0x80112938,%eax
80102689:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010268b:	a1 34 29 11 80       	mov    0x80112934,%eax
  kmem.freelist = r;
80102690:	89 1d 38 29 11 80    	mov    %ebx,0x80112938
  if(kmem.use_lock)
80102696:	85 c0                	test   %eax,%eax
80102698:	75 06                	jne    801026a0 <kfree+0x60>
    release(&kmem.lock);
}
8010269a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010269d:	c9                   	leave  
8010269e:	c3                   	ret    
8010269f:	90                   	nop
    release(&kmem.lock);
801026a0:	c7 45 08 00 29 11 80 	movl   $0x80112900,0x8(%ebp)
}
801026a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026aa:	c9                   	leave  
    release(&kmem.lock);
801026ab:	e9 80 20 00 00       	jmp    80104730 <release>
    acquire(&kmem.lock);
801026b0:	83 ec 0c             	sub    $0xc,%esp
801026b3:	68 00 29 11 80       	push   $0x80112900
801026b8:	e8 b3 1f 00 00       	call   80104670 <acquire>
801026bd:	83 c4 10             	add    $0x10,%esp
801026c0:	eb c2                	jmp    80102684 <kfree+0x44>
    panic("kfree");
801026c2:	83 ec 0c             	sub    $0xc,%esp
801026c5:	68 46 74 10 80       	push   $0x80107446
801026ca:	e8 c1 dc ff ff       	call   80100390 <panic>
801026cf:	90                   	nop

801026d0 <freerange>:
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	56                   	push   %esi
801026d4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026d5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801026db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ed:	39 de                	cmp    %ebx,%esi
801026ef:	72 23                	jb     80102714 <freerange+0x44>
801026f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026fe:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102701:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102707:	50                   	push   %eax
80102708:	e8 33 ff ff ff       	call   80102640 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010270d:	83 c4 10             	add    $0x10,%esp
80102710:	39 f3                	cmp    %esi,%ebx
80102712:	76 e4                	jbe    801026f8 <freerange+0x28>
}
80102714:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102717:	5b                   	pop    %ebx
80102718:	5e                   	pop    %esi
80102719:	5d                   	pop    %ebp
8010271a:	c3                   	ret    
8010271b:	90                   	nop
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102720 <kinit1>:
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	56                   	push   %esi
80102724:	53                   	push   %ebx
80102725:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102728:	83 ec 08             	sub    $0x8,%esp
8010272b:	68 4c 74 10 80       	push   $0x8010744c
80102730:	68 00 29 11 80       	push   $0x80112900
80102735:	e8 f6 1d 00 00       	call   80104530 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010273a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010273d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102740:	c7 05 34 29 11 80 00 	movl   $0x0,0x80112934
80102747:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010274a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102750:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102756:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275c:	39 de                	cmp    %ebx,%esi
8010275e:	72 1c                	jb     8010277c <kinit1+0x5c>
    kfree(p);
80102760:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102766:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102769:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010276f:	50                   	push   %eax
80102770:	e8 cb fe ff ff       	call   80102640 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102775:	83 c4 10             	add    $0x10,%esp
80102778:	39 de                	cmp    %ebx,%esi
8010277a:	73 e4                	jae    80102760 <kinit1+0x40>
}
8010277c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010277f:	5b                   	pop    %ebx
80102780:	5e                   	pop    %esi
80102781:	5d                   	pop    %ebp
80102782:	c3                   	ret    
80102783:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <kinit2>:
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	56                   	push   %esi
80102794:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102795:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102798:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010279b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027ad:	39 de                	cmp    %ebx,%esi
801027af:	72 23                	jb     801027d4 <kinit2+0x44>
801027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027b8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027be:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027c7:	50                   	push   %eax
801027c8:	e8 73 fe ff ff       	call   80102640 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027cd:	83 c4 10             	add    $0x10,%esp
801027d0:	39 de                	cmp    %ebx,%esi
801027d2:	73 e4                	jae    801027b8 <kinit2+0x28>
  kmem.use_lock = 1;
801027d4:	c7 05 34 29 11 80 01 	movl   $0x1,0x80112934
801027db:	00 00 00 
}
801027de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027e1:	5b                   	pop    %ebx
801027e2:	5e                   	pop    %esi
801027e3:	5d                   	pop    %ebp
801027e4:	c3                   	ret    
801027e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027f0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801027f0:	a1 34 29 11 80       	mov    0x80112934,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	75 1f                	jne    80102818 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027f9:	a1 38 29 11 80       	mov    0x80112938,%eax
  if(r)
801027fe:	85 c0                	test   %eax,%eax
80102800:	74 0e                	je     80102810 <kalloc+0x20>
    kmem.freelist = r->next;
80102802:	8b 10                	mov    (%eax),%edx
80102804:	89 15 38 29 11 80    	mov    %edx,0x80112938
8010280a:	c3                   	ret    
8010280b:	90                   	nop
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102810:	f3 c3                	repz ret 
80102812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102818:	55                   	push   %ebp
80102819:	89 e5                	mov    %esp,%ebp
8010281b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010281e:	68 00 29 11 80       	push   $0x80112900
80102823:	e8 48 1e 00 00       	call   80104670 <acquire>
  r = kmem.freelist;
80102828:	a1 38 29 11 80       	mov    0x80112938,%eax
  if(r)
8010282d:	83 c4 10             	add    $0x10,%esp
80102830:	8b 15 34 29 11 80    	mov    0x80112934,%edx
80102836:	85 c0                	test   %eax,%eax
80102838:	74 08                	je     80102842 <kalloc+0x52>
    kmem.freelist = r->next;
8010283a:	8b 08                	mov    (%eax),%ecx
8010283c:	89 0d 38 29 11 80    	mov    %ecx,0x80112938
  if(kmem.use_lock)
80102842:	85 d2                	test   %edx,%edx
80102844:	74 16                	je     8010285c <kalloc+0x6c>
    release(&kmem.lock);
80102846:	83 ec 0c             	sub    $0xc,%esp
80102849:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010284c:	68 00 29 11 80       	push   $0x80112900
80102851:	e8 da 1e 00 00       	call   80104730 <release>
  return (char*)r;
80102856:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102859:	83 c4 10             	add    $0x10,%esp
}
8010285c:	c9                   	leave  
8010285d:	c3                   	ret    
8010285e:	66 90                	xchg   %ax,%ax

80102860 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102860:	ba 64 00 00 00       	mov    $0x64,%edx
80102865:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102866:	a8 01                	test   $0x1,%al
80102868:	0f 84 c2 00 00 00    	je     80102930 <kbdgetc+0xd0>
8010286e:	ba 60 00 00 00       	mov    $0x60,%edx
80102873:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102874:	0f b6 d0             	movzbl %al,%edx
80102877:	8b 0d f4 a5 10 80    	mov    0x8010a5f4,%ecx

  if(data == 0xE0){
8010287d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102883:	0f 84 7f 00 00 00    	je     80102908 <kbdgetc+0xa8>
{
80102889:	55                   	push   %ebp
8010288a:	89 e5                	mov    %esp,%ebp
8010288c:	53                   	push   %ebx
8010288d:	89 cb                	mov    %ecx,%ebx
8010288f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102892:	84 c0                	test   %al,%al
80102894:	78 4a                	js     801028e0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102896:	85 db                	test   %ebx,%ebx
80102898:	74 09                	je     801028a3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010289a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010289d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801028a0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801028a3:	0f b6 82 80 75 10 80 	movzbl -0x7fef8a80(%edx),%eax
801028aa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801028ac:	0f b6 82 80 74 10 80 	movzbl -0x7fef8b80(%edx),%eax
801028b3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801028b5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801028b7:	89 0d f4 a5 10 80    	mov    %ecx,0x8010a5f4
  c = charcode[shift & (CTL | SHIFT)][data];
801028bd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801028c0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801028c3:	8b 04 85 60 74 10 80 	mov    -0x7fef8ba0(,%eax,4),%eax
801028ca:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801028ce:	74 31                	je     80102901 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801028d0:	8d 50 9f             	lea    -0x61(%eax),%edx
801028d3:	83 fa 19             	cmp    $0x19,%edx
801028d6:	77 40                	ja     80102918 <kbdgetc+0xb8>
      c += 'A' - 'a';
801028d8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801028db:	5b                   	pop    %ebx
801028dc:	5d                   	pop    %ebp
801028dd:	c3                   	ret    
801028de:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801028e0:	83 e0 7f             	and    $0x7f,%eax
801028e3:	85 db                	test   %ebx,%ebx
801028e5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801028e8:	0f b6 82 80 75 10 80 	movzbl -0x7fef8a80(%edx),%eax
801028ef:	83 c8 40             	or     $0x40,%eax
801028f2:	0f b6 c0             	movzbl %al,%eax
801028f5:	f7 d0                	not    %eax
801028f7:	21 c1                	and    %eax,%ecx
    return 0;
801028f9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801028fb:	89 0d f4 a5 10 80    	mov    %ecx,0x8010a5f4
}
80102901:	5b                   	pop    %ebx
80102902:	5d                   	pop    %ebp
80102903:	c3                   	ret    
80102904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102908:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010290b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010290d:	89 0d f4 a5 10 80    	mov    %ecx,0x8010a5f4
    return 0;
80102913:	c3                   	ret    
80102914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102918:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010291b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010291e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010291f:	83 f9 1a             	cmp    $0x1a,%ecx
80102922:	0f 42 c2             	cmovb  %edx,%eax
}
80102925:	5d                   	pop    %ebp
80102926:	c3                   	ret    
80102927:	89 f6                	mov    %esi,%esi
80102929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102935:	c3                   	ret    
80102936:	8d 76 00             	lea    0x0(%esi),%esi
80102939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102940 <kbdintr>:

void
kbdintr(void)
{
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
80102943:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102946:	68 60 28 10 80       	push   $0x80102860
8010294b:	e8 b0 e1 ff ff       	call   80100b00 <consoleintr>
}
80102950:	83 c4 10             	add    $0x10,%esp
80102953:	c9                   	leave  
80102954:	c3                   	ret    
80102955:	66 90                	xchg   %ax,%ax
80102957:	66 90                	xchg   %ax,%ax
80102959:	66 90                	xchg   %ax,%ax
8010295b:	66 90                	xchg   %ax,%ax
8010295d:	66 90                	xchg   %ax,%ax
8010295f:	90                   	nop

80102960 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102960:	a1 3c 29 11 80       	mov    0x8011293c,%eax
{
80102965:	55                   	push   %ebp
80102966:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102968:	85 c0                	test   %eax,%eax
8010296a:	0f 84 c8 00 00 00    	je     80102a38 <lapicinit+0xd8>
  lapic[index] = value;
80102970:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102977:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010297a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010297d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102984:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102987:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010298a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102991:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102994:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102997:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010299e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029a1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029ab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029be:	8b 50 30             	mov    0x30(%eax),%edx
801029c1:	c1 ea 10             	shr    $0x10,%edx
801029c4:	80 fa 03             	cmp    $0x3,%dl
801029c7:	77 77                	ja     80102a40 <lapicinit+0xe0>
  lapic[index] = value;
801029c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801029d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ed:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a04:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a07:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a0a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a11:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a14:	8b 50 20             	mov    0x20(%eax),%edx
80102a17:	89 f6                	mov    %esi,%esi
80102a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a20:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a26:	80 e6 10             	and    $0x10,%dh
80102a29:	75 f5                	jne    80102a20 <lapicinit+0xc0>
  lapic[index] = value;
80102a2b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a32:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a35:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a38:	5d                   	pop    %ebp
80102a39:	c3                   	ret    
80102a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102a40:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a47:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4a:	8b 50 20             	mov    0x20(%eax),%edx
80102a4d:	e9 77 ff ff ff       	jmp    801029c9 <lapicinit+0x69>
80102a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a60 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a60:	8b 15 3c 29 11 80    	mov    0x8011293c,%edx
{
80102a66:	55                   	push   %ebp
80102a67:	31 c0                	xor    %eax,%eax
80102a69:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102a6b:	85 d2                	test   %edx,%edx
80102a6d:	74 06                	je     80102a75 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102a6f:	8b 42 20             	mov    0x20(%edx),%eax
80102a72:	c1 e8 18             	shr    $0x18,%eax
}
80102a75:	5d                   	pop    %ebp
80102a76:	c3                   	ret    
80102a77:	89 f6                	mov    %esi,%esi
80102a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a80 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a80:	a1 3c 29 11 80       	mov    0x8011293c,%eax
{
80102a85:	55                   	push   %ebp
80102a86:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102a88:	85 c0                	test   %eax,%eax
80102a8a:	74 0d                	je     80102a99 <lapiceoi+0x19>
  lapic[index] = value;
80102a8c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a93:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a96:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a99:	5d                   	pop    %ebp
80102a9a:	c3                   	ret    
80102a9b:	90                   	nop
80102a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102aa0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
}
80102aa3:	5d                   	pop    %ebp
80102aa4:	c3                   	ret    
80102aa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ab0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ab0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102ab6:	ba 70 00 00 00       	mov    $0x70,%edx
80102abb:	89 e5                	mov    %esp,%ebp
80102abd:	53                   	push   %ebx
80102abe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ac1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ac4:	ee                   	out    %al,(%dx)
80102ac5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aca:	ba 71 00 00 00       	mov    $0x71,%edx
80102acf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ad0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ad2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ad5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102adb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102add:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102ae0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102ae3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ae5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102ae8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102aee:	a1 3c 29 11 80       	mov    0x8011293c,%eax
80102af3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102af9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102afc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b03:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b06:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b09:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b10:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b13:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b16:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b1c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b1f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b25:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b28:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b31:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b37:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b3a:	5b                   	pop    %ebx
80102b3b:	5d                   	pop    %ebp
80102b3c:	c3                   	ret    
80102b3d:	8d 76 00             	lea    0x0(%esi),%esi

80102b40 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b40:	55                   	push   %ebp
80102b41:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b46:	ba 70 00 00 00       	mov    $0x70,%edx
80102b4b:	89 e5                	mov    %esp,%ebp
80102b4d:	57                   	push   %edi
80102b4e:	56                   	push   %esi
80102b4f:	53                   	push   %ebx
80102b50:	83 ec 4c             	sub    $0x4c,%esp
80102b53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b54:	ba 71 00 00 00       	mov    $0x71,%edx
80102b59:	ec                   	in     (%dx),%al
80102b5a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b5d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b62:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b65:	8d 76 00             	lea    0x0(%esi),%esi
80102b68:	31 c0                	xor    %eax,%eax
80102b6a:	89 da                	mov    %ebx,%edx
80102b6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b72:	89 ca                	mov    %ecx,%edx
80102b74:	ec                   	in     (%dx),%al
80102b75:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b78:	89 da                	mov    %ebx,%edx
80102b7a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b80:	89 ca                	mov    %ecx,%edx
80102b82:	ec                   	in     (%dx),%al
80102b83:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b86:	89 da                	mov    %ebx,%edx
80102b88:	b8 04 00 00 00       	mov    $0x4,%eax
80102b8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8e:	89 ca                	mov    %ecx,%edx
80102b90:	ec                   	in     (%dx),%al
80102b91:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b94:	89 da                	mov    %ebx,%edx
80102b96:	b8 07 00 00 00       	mov    $0x7,%eax
80102b9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9c:	89 ca                	mov    %ecx,%edx
80102b9e:	ec                   	in     (%dx),%al
80102b9f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba2:	89 da                	mov    %ebx,%edx
80102ba4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ba9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102baa:	89 ca                	mov    %ecx,%edx
80102bac:	ec                   	in     (%dx),%al
80102bad:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102baf:	89 da                	mov    %ebx,%edx
80102bb1:	b8 09 00 00 00       	mov    $0x9,%eax
80102bb6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb7:	89 ca                	mov    %ecx,%edx
80102bb9:	ec                   	in     (%dx),%al
80102bba:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bbc:	89 da                	mov    %ebx,%edx
80102bbe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bc3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc4:	89 ca                	mov    %ecx,%edx
80102bc6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102bc7:	84 c0                	test   %al,%al
80102bc9:	78 9d                	js     80102b68 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102bcb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102bcf:	89 fa                	mov    %edi,%edx
80102bd1:	0f b6 fa             	movzbl %dl,%edi
80102bd4:	89 f2                	mov    %esi,%edx
80102bd6:	0f b6 f2             	movzbl %dl,%esi
80102bd9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bdc:	89 da                	mov    %ebx,%edx
80102bde:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102be1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102be4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102be8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102beb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102bef:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bf2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102bf6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102bf9:	31 c0                	xor    %eax,%eax
80102bfb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfc:	89 ca                	mov    %ecx,%edx
80102bfe:	ec                   	in     (%dx),%al
80102bff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c02:	89 da                	mov    %ebx,%edx
80102c04:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c07:	b8 02 00 00 00       	mov    $0x2,%eax
80102c0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0d:	89 ca                	mov    %ecx,%edx
80102c0f:	ec                   	in     (%dx),%al
80102c10:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c13:	89 da                	mov    %ebx,%edx
80102c15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c18:	b8 04 00 00 00       	mov    $0x4,%eax
80102c1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1e:	89 ca                	mov    %ecx,%edx
80102c20:	ec                   	in     (%dx),%al
80102c21:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c24:	89 da                	mov    %ebx,%edx
80102c26:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c29:	b8 07 00 00 00       	mov    $0x7,%eax
80102c2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2f:	89 ca                	mov    %ecx,%edx
80102c31:	ec                   	in     (%dx),%al
80102c32:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c35:	89 da                	mov    %ebx,%edx
80102c37:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c3a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c40:	89 ca                	mov    %ecx,%edx
80102c42:	ec                   	in     (%dx),%al
80102c43:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c46:	89 da                	mov    %ebx,%edx
80102c48:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c4b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c50:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c51:	89 ca                	mov    %ecx,%edx
80102c53:	ec                   	in     (%dx),%al
80102c54:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c57:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c5d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c60:	6a 18                	push   $0x18
80102c62:	50                   	push   %eax
80102c63:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c66:	50                   	push   %eax
80102c67:	e8 64 1b 00 00       	call   801047d0 <memcmp>
80102c6c:	83 c4 10             	add    $0x10,%esp
80102c6f:	85 c0                	test   %eax,%eax
80102c71:	0f 85 f1 fe ff ff    	jne    80102b68 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c77:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c7b:	75 78                	jne    80102cf5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c80:	89 c2                	mov    %eax,%edx
80102c82:	83 e0 0f             	and    $0xf,%eax
80102c85:	c1 ea 04             	shr    $0x4,%edx
80102c88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c8e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c91:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c94:	89 c2                	mov    %eax,%edx
80102c96:	83 e0 0f             	and    $0xf,%eax
80102c99:	c1 ea 04             	shr    $0x4,%edx
80102c9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ca2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ca5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ca8:	89 c2                	mov    %eax,%edx
80102caa:	83 e0 0f             	and    $0xf,%eax
80102cad:	c1 ea 04             	shr    $0x4,%edx
80102cb0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cb3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cb6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102cb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cbc:	89 c2                	mov    %eax,%edx
80102cbe:	83 e0 0f             	and    $0xf,%eax
80102cc1:	c1 ea 04             	shr    $0x4,%edx
80102cc4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cc7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102ccd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cd0:	89 c2                	mov    %eax,%edx
80102cd2:	83 e0 0f             	and    $0xf,%eax
80102cd5:	c1 ea 04             	shr    $0x4,%edx
80102cd8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cdb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cde:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ce1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ce4:	89 c2                	mov    %eax,%edx
80102ce6:	83 e0 0f             	and    $0xf,%eax
80102ce9:	c1 ea 04             	shr    $0x4,%edx
80102cec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cf2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102cf5:	8b 75 08             	mov    0x8(%ebp),%esi
80102cf8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cfb:	89 06                	mov    %eax,(%esi)
80102cfd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d00:	89 46 04             	mov    %eax,0x4(%esi)
80102d03:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d06:	89 46 08             	mov    %eax,0x8(%esi)
80102d09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d0c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d12:	89 46 10             	mov    %eax,0x10(%esi)
80102d15:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d18:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d1b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d25:	5b                   	pop    %ebx
80102d26:	5e                   	pop    %esi
80102d27:	5f                   	pop    %edi
80102d28:	5d                   	pop    %ebp
80102d29:	c3                   	ret    
80102d2a:	66 90                	xchg   %ax,%ax
80102d2c:	66 90                	xchg   %ax,%ax
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d30:	8b 0d 88 29 11 80    	mov    0x80112988,%ecx
80102d36:	85 c9                	test   %ecx,%ecx
80102d38:	0f 8e 8a 00 00 00    	jle    80102dc8 <install_trans+0x98>
{
80102d3e:	55                   	push   %ebp
80102d3f:	89 e5                	mov    %esp,%ebp
80102d41:	57                   	push   %edi
80102d42:	56                   	push   %esi
80102d43:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102d44:	31 db                	xor    %ebx,%ebx
{
80102d46:	83 ec 0c             	sub    $0xc,%esp
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d50:	a1 74 29 11 80       	mov    0x80112974,%eax
80102d55:	83 ec 08             	sub    $0x8,%esp
80102d58:	01 d8                	add    %ebx,%eax
80102d5a:	83 c0 01             	add    $0x1,%eax
80102d5d:	50                   	push   %eax
80102d5e:	ff 35 84 29 11 80    	pushl  0x80112984
80102d64:	e8 67 d3 ff ff       	call   801000d0 <bread>
80102d69:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d6b:	58                   	pop    %eax
80102d6c:	5a                   	pop    %edx
80102d6d:	ff 34 9d 8c 29 11 80 	pushl  -0x7feed674(,%ebx,4)
80102d74:	ff 35 84 29 11 80    	pushl  0x80112984
  for (tail = 0; tail < log.lh.n; tail++) {
80102d7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d7d:	e8 4e d3 ff ff       	call   801000d0 <bread>
80102d82:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d84:	8d 47 5c             	lea    0x5c(%edi),%eax
80102d87:	83 c4 0c             	add    $0xc,%esp
80102d8a:	68 00 02 00 00       	push   $0x200
80102d8f:	50                   	push   %eax
80102d90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d93:	50                   	push   %eax
80102d94:	e8 97 1a 00 00       	call   80104830 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d99:	89 34 24             	mov    %esi,(%esp)
80102d9c:	e8 ff d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102da1:	89 3c 24             	mov    %edi,(%esp)
80102da4:	e8 37 d4 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102da9:	89 34 24             	mov    %esi,(%esp)
80102dac:	e8 2f d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102db1:	83 c4 10             	add    $0x10,%esp
80102db4:	39 1d 88 29 11 80    	cmp    %ebx,0x80112988
80102dba:	7f 94                	jg     80102d50 <install_trans+0x20>
  }
}
80102dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dbf:	5b                   	pop    %ebx
80102dc0:	5e                   	pop    %esi
80102dc1:	5f                   	pop    %edi
80102dc2:	5d                   	pop    %ebp
80102dc3:	c3                   	ret    
80102dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dc8:	f3 c3                	repz ret 
80102dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102dd0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	56                   	push   %esi
80102dd4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102dd5:	83 ec 08             	sub    $0x8,%esp
80102dd8:	ff 35 74 29 11 80    	pushl  0x80112974
80102dde:	ff 35 84 29 11 80    	pushl  0x80112984
80102de4:	e8 e7 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102de9:	8b 1d 88 29 11 80    	mov    0x80112988,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102def:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102df2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102df4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102df6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102df9:	7e 16                	jle    80102e11 <write_head+0x41>
80102dfb:	c1 e3 02             	shl    $0x2,%ebx
80102dfe:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102e00:	8b 8a 8c 29 11 80    	mov    -0x7feed674(%edx),%ecx
80102e06:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102e0a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102e0d:	39 da                	cmp    %ebx,%edx
80102e0f:	75 ef                	jne    80102e00 <write_head+0x30>
  }
  bwrite(buf);
80102e11:	83 ec 0c             	sub    $0xc,%esp
80102e14:	56                   	push   %esi
80102e15:	e8 86 d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102e1a:	89 34 24             	mov    %esi,(%esp)
80102e1d:	e8 be d3 ff ff       	call   801001e0 <brelse>
}
80102e22:	83 c4 10             	add    $0x10,%esp
80102e25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e28:	5b                   	pop    %ebx
80102e29:	5e                   	pop    %esi
80102e2a:	5d                   	pop    %ebp
80102e2b:	c3                   	ret    
80102e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e30 <initlog>:
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	53                   	push   %ebx
80102e34:	83 ec 2c             	sub    $0x2c,%esp
80102e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e3a:	68 80 76 10 80       	push   $0x80107680
80102e3f:	68 40 29 11 80       	push   $0x80112940
80102e44:	e8 e7 16 00 00       	call   80104530 <initlock>
  readsb(dev, &sb);
80102e49:	58                   	pop    %eax
80102e4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e4d:	5a                   	pop    %edx
80102e4e:	50                   	push   %eax
80102e4f:	53                   	push   %ebx
80102e50:	e8 9b e8 ff ff       	call   801016f0 <readsb>
  log.size = sb.nlog;
80102e55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e5b:	59                   	pop    %ecx
  log.dev = dev;
80102e5c:	89 1d 84 29 11 80    	mov    %ebx,0x80112984
  log.size = sb.nlog;
80102e62:	89 15 78 29 11 80    	mov    %edx,0x80112978
  log.start = sb.logstart;
80102e68:	a3 74 29 11 80       	mov    %eax,0x80112974
  struct buf *buf = bread(log.dev, log.start);
80102e6d:	5a                   	pop    %edx
80102e6e:	50                   	push   %eax
80102e6f:	53                   	push   %ebx
80102e70:	e8 5b d2 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102e75:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102e78:	83 c4 10             	add    $0x10,%esp
80102e7b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102e7d:	89 1d 88 29 11 80    	mov    %ebx,0x80112988
  for (i = 0; i < log.lh.n; i++) {
80102e83:	7e 1c                	jle    80102ea1 <initlog+0x71>
80102e85:	c1 e3 02             	shl    $0x2,%ebx
80102e88:	31 d2                	xor    %edx,%edx
80102e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102e90:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102e94:	83 c2 04             	add    $0x4,%edx
80102e97:	89 8a 88 29 11 80    	mov    %ecx,-0x7feed678(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102e9d:	39 d3                	cmp    %edx,%ebx
80102e9f:	75 ef                	jne    80102e90 <initlog+0x60>
  brelse(buf);
80102ea1:	83 ec 0c             	sub    $0xc,%esp
80102ea4:	50                   	push   %eax
80102ea5:	e8 36 d3 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102eaa:	e8 81 fe ff ff       	call   80102d30 <install_trans>
  log.lh.n = 0;
80102eaf:	c7 05 88 29 11 80 00 	movl   $0x0,0x80112988
80102eb6:	00 00 00 
  write_head(); // clear the log
80102eb9:	e8 12 ff ff ff       	call   80102dd0 <write_head>
}
80102ebe:	83 c4 10             	add    $0x10,%esp
80102ec1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ec4:	c9                   	leave  
80102ec5:	c3                   	ret    
80102ec6:	8d 76 00             	lea    0x0(%esi),%esi
80102ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ed0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ed6:	68 40 29 11 80       	push   $0x80112940
80102edb:	e8 90 17 00 00       	call   80104670 <acquire>
80102ee0:	83 c4 10             	add    $0x10,%esp
80102ee3:	eb 18                	jmp    80102efd <begin_op+0x2d>
80102ee5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ee8:	83 ec 08             	sub    $0x8,%esp
80102eeb:	68 40 29 11 80       	push   $0x80112940
80102ef0:	68 40 29 11 80       	push   $0x80112940
80102ef5:	e8 b6 11 00 00       	call   801040b0 <sleep>
80102efa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102efd:	a1 80 29 11 80       	mov    0x80112980,%eax
80102f02:	85 c0                	test   %eax,%eax
80102f04:	75 e2                	jne    80102ee8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f06:	a1 7c 29 11 80       	mov    0x8011297c,%eax
80102f0b:	8b 15 88 29 11 80    	mov    0x80112988,%edx
80102f11:	83 c0 01             	add    $0x1,%eax
80102f14:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f17:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f1a:	83 fa 1e             	cmp    $0x1e,%edx
80102f1d:	7f c9                	jg     80102ee8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f1f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f22:	a3 7c 29 11 80       	mov    %eax,0x8011297c
      release(&log.lock);
80102f27:	68 40 29 11 80       	push   $0x80112940
80102f2c:	e8 ff 17 00 00       	call   80104730 <release>
      break;
    }
  }
}
80102f31:	83 c4 10             	add    $0x10,%esp
80102f34:	c9                   	leave  
80102f35:	c3                   	ret    
80102f36:	8d 76 00             	lea    0x0(%esi),%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	57                   	push   %edi
80102f44:	56                   	push   %esi
80102f45:	53                   	push   %ebx
80102f46:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f49:	68 40 29 11 80       	push   $0x80112940
80102f4e:	e8 1d 17 00 00       	call   80104670 <acquire>
  log.outstanding -= 1;
80102f53:	a1 7c 29 11 80       	mov    0x8011297c,%eax
  if(log.committing)
80102f58:	8b 35 80 29 11 80    	mov    0x80112980,%esi
80102f5e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f61:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102f64:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102f66:	89 1d 7c 29 11 80    	mov    %ebx,0x8011297c
  if(log.committing)
80102f6c:	0f 85 1a 01 00 00    	jne    8010308c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102f72:	85 db                	test   %ebx,%ebx
80102f74:	0f 85 ee 00 00 00    	jne    80103068 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f7a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102f7d:	c7 05 80 29 11 80 01 	movl   $0x1,0x80112980
80102f84:	00 00 00 
  release(&log.lock);
80102f87:	68 40 29 11 80       	push   $0x80112940
80102f8c:	e8 9f 17 00 00       	call   80104730 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f91:	8b 0d 88 29 11 80    	mov    0x80112988,%ecx
80102f97:	83 c4 10             	add    $0x10,%esp
80102f9a:	85 c9                	test   %ecx,%ecx
80102f9c:	0f 8e 85 00 00 00    	jle    80103027 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fa2:	a1 74 29 11 80       	mov    0x80112974,%eax
80102fa7:	83 ec 08             	sub    $0x8,%esp
80102faa:	01 d8                	add    %ebx,%eax
80102fac:	83 c0 01             	add    $0x1,%eax
80102faf:	50                   	push   %eax
80102fb0:	ff 35 84 29 11 80    	pushl  0x80112984
80102fb6:	e8 15 d1 ff ff       	call   801000d0 <bread>
80102fbb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fbd:	58                   	pop    %eax
80102fbe:	5a                   	pop    %edx
80102fbf:	ff 34 9d 8c 29 11 80 	pushl  -0x7feed674(,%ebx,4)
80102fc6:	ff 35 84 29 11 80    	pushl  0x80112984
  for (tail = 0; tail < log.lh.n; tail++) {
80102fcc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fcf:	e8 fc d0 ff ff       	call   801000d0 <bread>
80102fd4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102fd6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102fd9:	83 c4 0c             	add    $0xc,%esp
80102fdc:	68 00 02 00 00       	push   $0x200
80102fe1:	50                   	push   %eax
80102fe2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fe5:	50                   	push   %eax
80102fe6:	e8 45 18 00 00       	call   80104830 <memmove>
    bwrite(to);  // write the log
80102feb:	89 34 24             	mov    %esi,(%esp)
80102fee:	e8 ad d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102ff3:	89 3c 24             	mov    %edi,(%esp)
80102ff6:	e8 e5 d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ffb:	89 34 24             	mov    %esi,(%esp)
80102ffe:	e8 dd d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103003:	83 c4 10             	add    $0x10,%esp
80103006:	3b 1d 88 29 11 80    	cmp    0x80112988,%ebx
8010300c:	7c 94                	jl     80102fa2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010300e:	e8 bd fd ff ff       	call   80102dd0 <write_head>
    install_trans(); // Now install writes to home locations
80103013:	e8 18 fd ff ff       	call   80102d30 <install_trans>
    log.lh.n = 0;
80103018:	c7 05 88 29 11 80 00 	movl   $0x0,0x80112988
8010301f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103022:	e8 a9 fd ff ff       	call   80102dd0 <write_head>
    acquire(&log.lock);
80103027:	83 ec 0c             	sub    $0xc,%esp
8010302a:	68 40 29 11 80       	push   $0x80112940
8010302f:	e8 3c 16 00 00       	call   80104670 <acquire>
    wakeup(&log);
80103034:	c7 04 24 40 29 11 80 	movl   $0x80112940,(%esp)
    log.committing = 0;
8010303b:	c7 05 80 29 11 80 00 	movl   $0x0,0x80112980
80103042:	00 00 00 
    wakeup(&log);
80103045:	e8 16 12 00 00       	call   80104260 <wakeup>
    release(&log.lock);
8010304a:	c7 04 24 40 29 11 80 	movl   $0x80112940,(%esp)
80103051:	e8 da 16 00 00       	call   80104730 <release>
80103056:	83 c4 10             	add    $0x10,%esp
}
80103059:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010305c:	5b                   	pop    %ebx
8010305d:	5e                   	pop    %esi
8010305e:	5f                   	pop    %edi
8010305f:	5d                   	pop    %ebp
80103060:	c3                   	ret    
80103061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103068:	83 ec 0c             	sub    $0xc,%esp
8010306b:	68 40 29 11 80       	push   $0x80112940
80103070:	e8 eb 11 00 00       	call   80104260 <wakeup>
  release(&log.lock);
80103075:	c7 04 24 40 29 11 80 	movl   $0x80112940,(%esp)
8010307c:	e8 af 16 00 00       	call   80104730 <release>
80103081:	83 c4 10             	add    $0x10,%esp
}
80103084:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103087:	5b                   	pop    %ebx
80103088:	5e                   	pop    %esi
80103089:	5f                   	pop    %edi
8010308a:	5d                   	pop    %ebp
8010308b:	c3                   	ret    
    panic("log.committing");
8010308c:	83 ec 0c             	sub    $0xc,%esp
8010308f:	68 84 76 10 80       	push   $0x80107684
80103094:	e8 f7 d2 ff ff       	call   80100390 <panic>
80103099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801030a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	53                   	push   %ebx
801030a4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030a7:	8b 15 88 29 11 80    	mov    0x80112988,%edx
{
801030ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030b0:	83 fa 1d             	cmp    $0x1d,%edx
801030b3:	0f 8f 9d 00 00 00    	jg     80103156 <log_write+0xb6>
801030b9:	a1 78 29 11 80       	mov    0x80112978,%eax
801030be:	83 e8 01             	sub    $0x1,%eax
801030c1:	39 c2                	cmp    %eax,%edx
801030c3:	0f 8d 8d 00 00 00    	jge    80103156 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801030c9:	a1 7c 29 11 80       	mov    0x8011297c,%eax
801030ce:	85 c0                	test   %eax,%eax
801030d0:	0f 8e 8d 00 00 00    	jle    80103163 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801030d6:	83 ec 0c             	sub    $0xc,%esp
801030d9:	68 40 29 11 80       	push   $0x80112940
801030de:	e8 8d 15 00 00       	call   80104670 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801030e3:	8b 0d 88 29 11 80    	mov    0x80112988,%ecx
801030e9:	83 c4 10             	add    $0x10,%esp
801030ec:	83 f9 00             	cmp    $0x0,%ecx
801030ef:	7e 57                	jle    80103148 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030f1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
801030f4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030f6:	3b 15 8c 29 11 80    	cmp    0x8011298c,%edx
801030fc:	75 0b                	jne    80103109 <log_write+0x69>
801030fe:	eb 38                	jmp    80103138 <log_write+0x98>
80103100:	39 14 85 8c 29 11 80 	cmp    %edx,-0x7feed674(,%eax,4)
80103107:	74 2f                	je     80103138 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103109:	83 c0 01             	add    $0x1,%eax
8010310c:	39 c1                	cmp    %eax,%ecx
8010310e:	75 f0                	jne    80103100 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103110:	89 14 85 8c 29 11 80 	mov    %edx,-0x7feed674(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103117:	83 c0 01             	add    $0x1,%eax
8010311a:	a3 88 29 11 80       	mov    %eax,0x80112988
  b->flags |= B_DIRTY; // prevent eviction
8010311f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103122:	c7 45 08 40 29 11 80 	movl   $0x80112940,0x8(%ebp)
}
80103129:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010312c:	c9                   	leave  
  release(&log.lock);
8010312d:	e9 fe 15 00 00       	jmp    80104730 <release>
80103132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103138:	89 14 85 8c 29 11 80 	mov    %edx,-0x7feed674(,%eax,4)
8010313f:	eb de                	jmp    8010311f <log_write+0x7f>
80103141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103148:	8b 43 08             	mov    0x8(%ebx),%eax
8010314b:	a3 8c 29 11 80       	mov    %eax,0x8011298c
  if (i == log.lh.n)
80103150:	75 cd                	jne    8010311f <log_write+0x7f>
80103152:	31 c0                	xor    %eax,%eax
80103154:	eb c1                	jmp    80103117 <log_write+0x77>
    panic("too big a transaction");
80103156:	83 ec 0c             	sub    $0xc,%esp
80103159:	68 93 76 10 80       	push   $0x80107693
8010315e:	e8 2d d2 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103163:	83 ec 0c             	sub    $0xc,%esp
80103166:	68 a9 76 10 80       	push   $0x801076a9
8010316b:	e8 20 d2 ff ff       	call   80100390 <panic>

80103170 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	53                   	push   %ebx
80103174:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103177:	e8 74 09 00 00       	call   80103af0 <cpuid>
8010317c:	89 c3                	mov    %eax,%ebx
8010317e:	e8 6d 09 00 00       	call   80103af0 <cpuid>
80103183:	83 ec 04             	sub    $0x4,%esp
80103186:	53                   	push   %ebx
80103187:	50                   	push   %eax
80103188:	68 c4 76 10 80       	push   $0x801076c4
8010318d:	e8 ce d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103192:	e8 69 28 00 00       	call   80105a00 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103197:	e8 d4 08 00 00       	call   80103a70 <mycpu>
8010319c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010319e:	b8 01 00 00 00       	mov    $0x1,%eax
801031a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031aa:	e8 21 0c 00 00       	call   80103dd0 <scheduler>
801031af:	90                   	nop

801031b0 <mpenter>:
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031b6:	e8 35 39 00 00       	call   80106af0 <switchkvm>
  seginit();
801031bb:	e8 a0 38 00 00       	call   80106a60 <seginit>
  lapicinit();
801031c0:	e8 9b f7 ff ff       	call   80102960 <lapicinit>
  mpmain();
801031c5:	e8 a6 ff ff ff       	call   80103170 <mpmain>
801031ca:	66 90                	xchg   %ax,%ax
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <main>:
{
801031d0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801031d4:	83 e4 f0             	and    $0xfffffff0,%esp
801031d7:	ff 71 fc             	pushl  -0x4(%ecx)
801031da:	55                   	push   %ebp
801031db:	89 e5                	mov    %esp,%ebp
801031dd:	53                   	push   %ebx
801031de:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801031df:	83 ec 08             	sub    $0x8,%esp
801031e2:	68 00 00 40 80       	push   $0x80400000
801031e7:	68 68 57 11 80       	push   $0x80115768
801031ec:	e8 2f f5 ff ff       	call   80102720 <kinit1>
  kvmalloc();      // kernel page table
801031f1:	e8 ca 3d 00 00       	call   80106fc0 <kvmalloc>
  mpinit();        // detect other processors
801031f6:	e8 75 01 00 00       	call   80103370 <mpinit>
  lapicinit();     // interrupt controller
801031fb:	e8 60 f7 ff ff       	call   80102960 <lapicinit>
  seginit();       // segment descriptors
80103200:	e8 5b 38 00 00       	call   80106a60 <seginit>
  picinit();       // disable pic
80103205:	e8 46 03 00 00       	call   80103550 <picinit>
  ioapicinit();    // another interrupt controller
8010320a:	e8 41 f3 ff ff       	call   80102550 <ioapicinit>
  consoleinit();   // console hardware
8010320f:	e8 cc da ff ff       	call   80100ce0 <consoleinit>
  uartinit();      // serial port
80103214:	e8 17 2b 00 00       	call   80105d30 <uartinit>
  pinit();         // process table
80103219:	e8 32 08 00 00       	call   80103a50 <pinit>
  tvinit();        // trap vectors
8010321e:	e8 5d 27 00 00       	call   80105980 <tvinit>
  binit();         // buffer cache
80103223:	e8 18 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103228:	e8 53 de ff ff       	call   80101080 <fileinit>
  ideinit();       // disk 
8010322d:	e8 fe f0 ff ff       	call   80102330 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103232:	83 c4 0c             	add    $0xc,%esp
80103235:	68 8a 00 00 00       	push   $0x8a
8010323a:	68 8c a4 10 80       	push   $0x8010a48c
8010323f:	68 00 70 00 80       	push   $0x80007000
80103244:	e8 e7 15 00 00       	call   80104830 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103249:	69 05 c0 2f 11 80 b0 	imul   $0xb0,0x80112fc0,%eax
80103250:	00 00 00 
80103253:	83 c4 10             	add    $0x10,%esp
80103256:	05 40 2a 11 80       	add    $0x80112a40,%eax
8010325b:	3d 40 2a 11 80       	cmp    $0x80112a40,%eax
80103260:	76 71                	jbe    801032d3 <main+0x103>
80103262:	bb 40 2a 11 80       	mov    $0x80112a40,%ebx
80103267:	89 f6                	mov    %esi,%esi
80103269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103270:	e8 fb 07 00 00       	call   80103a70 <mycpu>
80103275:	39 d8                	cmp    %ebx,%eax
80103277:	74 41                	je     801032ba <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103279:	e8 72 f5 ff ff       	call   801027f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010327e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103283:	c7 05 f8 6f 00 80 b0 	movl   $0x801031b0,0x80006ff8
8010328a:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010328d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103294:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103297:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010329c:	0f b6 03             	movzbl (%ebx),%eax
8010329f:	83 ec 08             	sub    $0x8,%esp
801032a2:	68 00 70 00 00       	push   $0x7000
801032a7:	50                   	push   %eax
801032a8:	e8 03 f8 ff ff       	call   80102ab0 <lapicstartap>
801032ad:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032b0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032b6:	85 c0                	test   %eax,%eax
801032b8:	74 f6                	je     801032b0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801032ba:	69 05 c0 2f 11 80 b0 	imul   $0xb0,0x80112fc0,%eax
801032c1:	00 00 00 
801032c4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032ca:	05 40 2a 11 80       	add    $0x80112a40,%eax
801032cf:	39 c3                	cmp    %eax,%ebx
801032d1:	72 9d                	jb     80103270 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801032d3:	83 ec 08             	sub    $0x8,%esp
801032d6:	68 00 00 00 8e       	push   $0x8e000000
801032db:	68 00 00 40 80       	push   $0x80400000
801032e0:	e8 ab f4 ff ff       	call   80102790 <kinit2>
  userinit();      // first user process
801032e5:	e8 56 08 00 00       	call   80103b40 <userinit>
  mpmain();        // finish this processor's setup
801032ea:	e8 81 fe ff ff       	call   80103170 <mpmain>
801032ef:	90                   	nop

801032f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	57                   	push   %edi
801032f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032fb:	53                   	push   %ebx
  e = addr+len;
801032fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103302:	39 de                	cmp    %ebx,%esi
80103304:	72 10                	jb     80103316 <mpsearch1+0x26>
80103306:	eb 50                	jmp    80103358 <mpsearch1+0x68>
80103308:	90                   	nop
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103310:	39 fb                	cmp    %edi,%ebx
80103312:	89 fe                	mov    %edi,%esi
80103314:	76 42                	jbe    80103358 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103316:	83 ec 04             	sub    $0x4,%esp
80103319:	8d 7e 10             	lea    0x10(%esi),%edi
8010331c:	6a 04                	push   $0x4
8010331e:	68 d8 76 10 80       	push   $0x801076d8
80103323:	56                   	push   %esi
80103324:	e8 a7 14 00 00       	call   801047d0 <memcmp>
80103329:	83 c4 10             	add    $0x10,%esp
8010332c:	85 c0                	test   %eax,%eax
8010332e:	75 e0                	jne    80103310 <mpsearch1+0x20>
80103330:	89 f1                	mov    %esi,%ecx
80103332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103338:	0f b6 11             	movzbl (%ecx),%edx
8010333b:	83 c1 01             	add    $0x1,%ecx
8010333e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103340:	39 f9                	cmp    %edi,%ecx
80103342:	75 f4                	jne    80103338 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103344:	84 c0                	test   %al,%al
80103346:	75 c8                	jne    80103310 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103348:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010334b:	89 f0                	mov    %esi,%eax
8010334d:	5b                   	pop    %ebx
8010334e:	5e                   	pop    %esi
8010334f:	5f                   	pop    %edi
80103350:	5d                   	pop    %ebp
80103351:	c3                   	ret    
80103352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103358:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010335b:	31 f6                	xor    %esi,%esi
}
8010335d:	89 f0                	mov    %esi,%eax
8010335f:	5b                   	pop    %ebx
80103360:	5e                   	pop    %esi
80103361:	5f                   	pop    %edi
80103362:	5d                   	pop    %ebp
80103363:	c3                   	ret    
80103364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010336a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103370 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	57                   	push   %edi
80103374:	56                   	push   %esi
80103375:	53                   	push   %ebx
80103376:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103379:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103380:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103387:	c1 e0 08             	shl    $0x8,%eax
8010338a:	09 d0                	or     %edx,%eax
8010338c:	c1 e0 04             	shl    $0x4,%eax
8010338f:	85 c0                	test   %eax,%eax
80103391:	75 1b                	jne    801033ae <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103393:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010339a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033a1:	c1 e0 08             	shl    $0x8,%eax
801033a4:	09 d0                	or     %edx,%eax
801033a6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801033a9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801033ae:	ba 00 04 00 00       	mov    $0x400,%edx
801033b3:	e8 38 ff ff ff       	call   801032f0 <mpsearch1>
801033b8:	85 c0                	test   %eax,%eax
801033ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801033bd:	0f 84 3d 01 00 00    	je     80103500 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033c6:	8b 58 04             	mov    0x4(%eax),%ebx
801033c9:	85 db                	test   %ebx,%ebx
801033cb:	0f 84 4f 01 00 00    	je     80103520 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033d1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801033d7:	83 ec 04             	sub    $0x4,%esp
801033da:	6a 04                	push   $0x4
801033dc:	68 f5 76 10 80       	push   $0x801076f5
801033e1:	56                   	push   %esi
801033e2:	e8 e9 13 00 00       	call   801047d0 <memcmp>
801033e7:	83 c4 10             	add    $0x10,%esp
801033ea:	85 c0                	test   %eax,%eax
801033ec:	0f 85 2e 01 00 00    	jne    80103520 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801033f2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801033f9:	3c 01                	cmp    $0x1,%al
801033fb:	0f 95 c2             	setne  %dl
801033fe:	3c 04                	cmp    $0x4,%al
80103400:	0f 95 c0             	setne  %al
80103403:	20 c2                	and    %al,%dl
80103405:	0f 85 15 01 00 00    	jne    80103520 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010340b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103412:	66 85 ff             	test   %di,%di
80103415:	74 1a                	je     80103431 <mpinit+0xc1>
80103417:	89 f0                	mov    %esi,%eax
80103419:	01 f7                	add    %esi,%edi
  sum = 0;
8010341b:	31 d2                	xor    %edx,%edx
8010341d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103420:	0f b6 08             	movzbl (%eax),%ecx
80103423:	83 c0 01             	add    $0x1,%eax
80103426:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103428:	39 c7                	cmp    %eax,%edi
8010342a:	75 f4                	jne    80103420 <mpinit+0xb0>
8010342c:	84 d2                	test   %dl,%dl
8010342e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103431:	85 f6                	test   %esi,%esi
80103433:	0f 84 e7 00 00 00    	je     80103520 <mpinit+0x1b0>
80103439:	84 d2                	test   %dl,%dl
8010343b:	0f 85 df 00 00 00    	jne    80103520 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103441:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103447:	a3 3c 29 11 80       	mov    %eax,0x8011293c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010344c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103453:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103459:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010345e:	01 d6                	add    %edx,%esi
80103460:	39 c6                	cmp    %eax,%esi
80103462:	76 23                	jbe    80103487 <mpinit+0x117>
    switch(*p){
80103464:	0f b6 10             	movzbl (%eax),%edx
80103467:	80 fa 04             	cmp    $0x4,%dl
8010346a:	0f 87 ca 00 00 00    	ja     8010353a <mpinit+0x1ca>
80103470:	ff 24 95 1c 77 10 80 	jmp    *-0x7fef88e4(,%edx,4)
80103477:	89 f6                	mov    %esi,%esi
80103479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103480:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103483:	39 c6                	cmp    %eax,%esi
80103485:	77 dd                	ja     80103464 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103487:	85 db                	test   %ebx,%ebx
80103489:	0f 84 9e 00 00 00    	je     8010352d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010348f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103492:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103496:	74 15                	je     801034ad <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103498:	b8 70 00 00 00       	mov    $0x70,%eax
8010349d:	ba 22 00 00 00       	mov    $0x22,%edx
801034a2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034a3:	ba 23 00 00 00       	mov    $0x23,%edx
801034a8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801034a9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034ac:	ee                   	out    %al,(%dx)
  }
}
801034ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034b0:	5b                   	pop    %ebx
801034b1:	5e                   	pop    %esi
801034b2:	5f                   	pop    %edi
801034b3:	5d                   	pop    %ebp
801034b4:	c3                   	ret    
801034b5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801034b8:	8b 0d c0 2f 11 80    	mov    0x80112fc0,%ecx
801034be:	83 f9 07             	cmp    $0x7,%ecx
801034c1:	7f 19                	jg     801034dc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034c3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801034c7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801034cd:	83 c1 01             	add    $0x1,%ecx
801034d0:	89 0d c0 2f 11 80    	mov    %ecx,0x80112fc0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034d6:	88 97 40 2a 11 80    	mov    %dl,-0x7feed5c0(%edi)
      p += sizeof(struct mpproc);
801034dc:	83 c0 14             	add    $0x14,%eax
      continue;
801034df:	e9 7c ff ff ff       	jmp    80103460 <mpinit+0xf0>
801034e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801034e8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801034ec:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801034ef:	88 15 20 2a 11 80    	mov    %dl,0x80112a20
      continue;
801034f5:	e9 66 ff ff ff       	jmp    80103460 <mpinit+0xf0>
801034fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103500:	ba 00 00 01 00       	mov    $0x10000,%edx
80103505:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010350a:	e8 e1 fd ff ff       	call   801032f0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010350f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103511:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103514:	0f 85 a9 fe ff ff    	jne    801033c3 <mpinit+0x53>
8010351a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103520:	83 ec 0c             	sub    $0xc,%esp
80103523:	68 dd 76 10 80       	push   $0x801076dd
80103528:	e8 63 ce ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010352d:	83 ec 0c             	sub    $0xc,%esp
80103530:	68 fc 76 10 80       	push   $0x801076fc
80103535:	e8 56 ce ff ff       	call   80100390 <panic>
      ismp = 0;
8010353a:	31 db                	xor    %ebx,%ebx
8010353c:	e9 26 ff ff ff       	jmp    80103467 <mpinit+0xf7>
80103541:	66 90                	xchg   %ax,%ax
80103543:	66 90                	xchg   %ax,%ax
80103545:	66 90                	xchg   %ax,%ax
80103547:	66 90                	xchg   %ax,%ax
80103549:	66 90                	xchg   %ax,%ax
8010354b:	66 90                	xchg   %ax,%ax
8010354d:	66 90                	xchg   %ax,%ax
8010354f:	90                   	nop

80103550 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103550:	55                   	push   %ebp
80103551:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103556:	ba 21 00 00 00       	mov    $0x21,%edx
8010355b:	89 e5                	mov    %esp,%ebp
8010355d:	ee                   	out    %al,(%dx)
8010355e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103563:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103564:	5d                   	pop    %ebp
80103565:	c3                   	ret    
80103566:	66 90                	xchg   %ax,%ax
80103568:	66 90                	xchg   %ax,%ax
8010356a:	66 90                	xchg   %ax,%ax
8010356c:	66 90                	xchg   %ax,%ax
8010356e:	66 90                	xchg   %ax,%ax

80103570 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	57                   	push   %edi
80103574:	56                   	push   %esi
80103575:	53                   	push   %ebx
80103576:	83 ec 0c             	sub    $0xc,%esp
80103579:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010357c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010357f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103585:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010358b:	e8 10 db ff ff       	call   801010a0 <filealloc>
80103590:	85 c0                	test   %eax,%eax
80103592:	89 03                	mov    %eax,(%ebx)
80103594:	74 22                	je     801035b8 <pipealloc+0x48>
80103596:	e8 05 db ff ff       	call   801010a0 <filealloc>
8010359b:	85 c0                	test   %eax,%eax
8010359d:	89 06                	mov    %eax,(%esi)
8010359f:	74 3f                	je     801035e0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035a1:	e8 4a f2 ff ff       	call   801027f0 <kalloc>
801035a6:	85 c0                	test   %eax,%eax
801035a8:	89 c7                	mov    %eax,%edi
801035aa:	75 54                	jne    80103600 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801035ac:	8b 03                	mov    (%ebx),%eax
801035ae:	85 c0                	test   %eax,%eax
801035b0:	75 34                	jne    801035e6 <pipealloc+0x76>
801035b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801035b8:	8b 06                	mov    (%esi),%eax
801035ba:	85 c0                	test   %eax,%eax
801035bc:	74 0c                	je     801035ca <pipealloc+0x5a>
    fileclose(*f1);
801035be:	83 ec 0c             	sub    $0xc,%esp
801035c1:	50                   	push   %eax
801035c2:	e8 99 db ff ff       	call   80101160 <fileclose>
801035c7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801035ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801035cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801035d2:	5b                   	pop    %ebx
801035d3:	5e                   	pop    %esi
801035d4:	5f                   	pop    %edi
801035d5:	5d                   	pop    %ebp
801035d6:	c3                   	ret    
801035d7:	89 f6                	mov    %esi,%esi
801035d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801035e0:	8b 03                	mov    (%ebx),%eax
801035e2:	85 c0                	test   %eax,%eax
801035e4:	74 e4                	je     801035ca <pipealloc+0x5a>
    fileclose(*f0);
801035e6:	83 ec 0c             	sub    $0xc,%esp
801035e9:	50                   	push   %eax
801035ea:	e8 71 db ff ff       	call   80101160 <fileclose>
  if(*f1)
801035ef:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801035f1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801035f4:	85 c0                	test   %eax,%eax
801035f6:	75 c6                	jne    801035be <pipealloc+0x4e>
801035f8:	eb d0                	jmp    801035ca <pipealloc+0x5a>
801035fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103600:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103603:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010360a:	00 00 00 
  p->writeopen = 1;
8010360d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103614:	00 00 00 
  p->nwrite = 0;
80103617:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010361e:	00 00 00 
  p->nread = 0;
80103621:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103628:	00 00 00 
  initlock(&p->lock, "pipe");
8010362b:	68 30 77 10 80       	push   $0x80107730
80103630:	50                   	push   %eax
80103631:	e8 fa 0e 00 00       	call   80104530 <initlock>
  (*f0)->type = FD_PIPE;
80103636:	8b 03                	mov    (%ebx),%eax
  return 0;
80103638:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010363b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103641:	8b 03                	mov    (%ebx),%eax
80103643:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103647:	8b 03                	mov    (%ebx),%eax
80103649:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010364d:	8b 03                	mov    (%ebx),%eax
8010364f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103652:	8b 06                	mov    (%esi),%eax
80103654:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010365a:	8b 06                	mov    (%esi),%eax
8010365c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103660:	8b 06                	mov    (%esi),%eax
80103662:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103666:	8b 06                	mov    (%esi),%eax
80103668:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010366b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010366e:	31 c0                	xor    %eax,%eax
}
80103670:	5b                   	pop    %ebx
80103671:	5e                   	pop    %esi
80103672:	5f                   	pop    %edi
80103673:	5d                   	pop    %ebp
80103674:	c3                   	ret    
80103675:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103680 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	56                   	push   %esi
80103684:	53                   	push   %ebx
80103685:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103688:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010368b:	83 ec 0c             	sub    $0xc,%esp
8010368e:	53                   	push   %ebx
8010368f:	e8 dc 0f 00 00       	call   80104670 <acquire>
  if(writable){
80103694:	83 c4 10             	add    $0x10,%esp
80103697:	85 f6                	test   %esi,%esi
80103699:	74 45                	je     801036e0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010369b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036a1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801036a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036ab:	00 00 00 
    wakeup(&p->nread);
801036ae:	50                   	push   %eax
801036af:	e8 ac 0b 00 00       	call   80104260 <wakeup>
801036b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036bd:	85 d2                	test   %edx,%edx
801036bf:	75 0a                	jne    801036cb <pipeclose+0x4b>
801036c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036c7:	85 c0                	test   %eax,%eax
801036c9:	74 35                	je     80103700 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036d1:	5b                   	pop    %ebx
801036d2:	5e                   	pop    %esi
801036d3:	5d                   	pop    %ebp
    release(&p->lock);
801036d4:	e9 57 10 00 00       	jmp    80104730 <release>
801036d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801036e0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801036e6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801036e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036f0:	00 00 00 
    wakeup(&p->nwrite);
801036f3:	50                   	push   %eax
801036f4:	e8 67 0b 00 00       	call   80104260 <wakeup>
801036f9:	83 c4 10             	add    $0x10,%esp
801036fc:	eb b9                	jmp    801036b7 <pipeclose+0x37>
801036fe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	53                   	push   %ebx
80103704:	e8 27 10 00 00       	call   80104730 <release>
    kfree((char*)p);
80103709:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010370c:	83 c4 10             	add    $0x10,%esp
}
8010370f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103712:	5b                   	pop    %ebx
80103713:	5e                   	pop    %esi
80103714:	5d                   	pop    %ebp
    kfree((char*)p);
80103715:	e9 26 ef ff ff       	jmp    80102640 <kfree>
8010371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103720 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	57                   	push   %edi
80103724:	56                   	push   %esi
80103725:	53                   	push   %ebx
80103726:	83 ec 28             	sub    $0x28,%esp
80103729:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010372c:	53                   	push   %ebx
8010372d:	e8 3e 0f 00 00       	call   80104670 <acquire>
  for(i = 0; i < n; i++){
80103732:	8b 45 10             	mov    0x10(%ebp),%eax
80103735:	83 c4 10             	add    $0x10,%esp
80103738:	85 c0                	test   %eax,%eax
8010373a:	0f 8e c9 00 00 00    	jle    80103809 <pipewrite+0xe9>
80103740:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103743:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103749:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010374f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103752:	03 4d 10             	add    0x10(%ebp),%ecx
80103755:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103758:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010375e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103764:	39 d0                	cmp    %edx,%eax
80103766:	75 71                	jne    801037d9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103768:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010376e:	85 c0                	test   %eax,%eax
80103770:	74 4e                	je     801037c0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103772:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103778:	eb 3a                	jmp    801037b4 <pipewrite+0x94>
8010377a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103780:	83 ec 0c             	sub    $0xc,%esp
80103783:	57                   	push   %edi
80103784:	e8 d7 0a 00 00       	call   80104260 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103789:	5a                   	pop    %edx
8010378a:	59                   	pop    %ecx
8010378b:	53                   	push   %ebx
8010378c:	56                   	push   %esi
8010378d:	e8 1e 09 00 00       	call   801040b0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103792:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103798:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010379e:	83 c4 10             	add    $0x10,%esp
801037a1:	05 00 02 00 00       	add    $0x200,%eax
801037a6:	39 c2                	cmp    %eax,%edx
801037a8:	75 36                	jne    801037e0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801037aa:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037b0:	85 c0                	test   %eax,%eax
801037b2:	74 0c                	je     801037c0 <pipewrite+0xa0>
801037b4:	e8 57 03 00 00       	call   80103b10 <myproc>
801037b9:	8b 40 24             	mov    0x24(%eax),%eax
801037bc:	85 c0                	test   %eax,%eax
801037be:	74 c0                	je     80103780 <pipewrite+0x60>
        release(&p->lock);
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	53                   	push   %ebx
801037c4:	e8 67 0f 00 00       	call   80104730 <release>
        return -1;
801037c9:	83 c4 10             	add    $0x10,%esp
801037cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037d4:	5b                   	pop    %ebx
801037d5:	5e                   	pop    %esi
801037d6:	5f                   	pop    %edi
801037d7:	5d                   	pop    %ebp
801037d8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037d9:	89 c2                	mov    %eax,%edx
801037db:	90                   	nop
801037dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037e0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801037e3:	8d 42 01             	lea    0x1(%edx),%eax
801037e6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037ec:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801037f2:	83 c6 01             	add    $0x1,%esi
801037f5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801037f9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801037fc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037ff:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103803:	0f 85 4f ff ff ff    	jne    80103758 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103809:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010380f:	83 ec 0c             	sub    $0xc,%esp
80103812:	50                   	push   %eax
80103813:	e8 48 0a 00 00       	call   80104260 <wakeup>
  release(&p->lock);
80103818:	89 1c 24             	mov    %ebx,(%esp)
8010381b:	e8 10 0f 00 00       	call   80104730 <release>
  return n;
80103820:	83 c4 10             	add    $0x10,%esp
80103823:	8b 45 10             	mov    0x10(%ebp),%eax
80103826:	eb a9                	jmp    801037d1 <pipewrite+0xb1>
80103828:	90                   	nop
80103829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103830 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	57                   	push   %edi
80103834:	56                   	push   %esi
80103835:	53                   	push   %ebx
80103836:	83 ec 18             	sub    $0x18,%esp
80103839:	8b 75 08             	mov    0x8(%ebp),%esi
8010383c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010383f:	56                   	push   %esi
80103840:	e8 2b 0e 00 00       	call   80104670 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103845:	83 c4 10             	add    $0x10,%esp
80103848:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010384e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103854:	75 6a                	jne    801038c0 <piperead+0x90>
80103856:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010385c:	85 db                	test   %ebx,%ebx
8010385e:	0f 84 c4 00 00 00    	je     80103928 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103864:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010386a:	eb 2d                	jmp    80103899 <piperead+0x69>
8010386c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103870:	83 ec 08             	sub    $0x8,%esp
80103873:	56                   	push   %esi
80103874:	53                   	push   %ebx
80103875:	e8 36 08 00 00       	call   801040b0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010387a:	83 c4 10             	add    $0x10,%esp
8010387d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103883:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103889:	75 35                	jne    801038c0 <piperead+0x90>
8010388b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103891:	85 d2                	test   %edx,%edx
80103893:	0f 84 8f 00 00 00    	je     80103928 <piperead+0xf8>
    if(myproc()->killed){
80103899:	e8 72 02 00 00       	call   80103b10 <myproc>
8010389e:	8b 48 24             	mov    0x24(%eax),%ecx
801038a1:	85 c9                	test   %ecx,%ecx
801038a3:	74 cb                	je     80103870 <piperead+0x40>
      release(&p->lock);
801038a5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038a8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038ad:	56                   	push   %esi
801038ae:	e8 7d 0e 00 00       	call   80104730 <release>
      return -1;
801038b3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038b9:	89 d8                	mov    %ebx,%eax
801038bb:	5b                   	pop    %ebx
801038bc:	5e                   	pop    %esi
801038bd:	5f                   	pop    %edi
801038be:	5d                   	pop    %ebp
801038bf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038c0:	8b 45 10             	mov    0x10(%ebp),%eax
801038c3:	85 c0                	test   %eax,%eax
801038c5:	7e 61                	jle    80103928 <piperead+0xf8>
    if(p->nread == p->nwrite)
801038c7:	31 db                	xor    %ebx,%ebx
801038c9:	eb 13                	jmp    801038de <piperead+0xae>
801038cb:	90                   	nop
801038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038d0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801038d6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801038dc:	74 1f                	je     801038fd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038de:	8d 41 01             	lea    0x1(%ecx),%eax
801038e1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801038e7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801038ed:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801038f2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038f5:	83 c3 01             	add    $0x1,%ebx
801038f8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801038fb:	75 d3                	jne    801038d0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801038fd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103903:	83 ec 0c             	sub    $0xc,%esp
80103906:	50                   	push   %eax
80103907:	e8 54 09 00 00       	call   80104260 <wakeup>
  release(&p->lock);
8010390c:	89 34 24             	mov    %esi,(%esp)
8010390f:	e8 1c 0e 00 00       	call   80104730 <release>
  return i;
80103914:	83 c4 10             	add    $0x10,%esp
}
80103917:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010391a:	89 d8                	mov    %ebx,%eax
8010391c:	5b                   	pop    %ebx
8010391d:	5e                   	pop    %esi
8010391e:	5f                   	pop    %edi
8010391f:	5d                   	pop    %ebp
80103920:	c3                   	ret    
80103921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103928:	31 db                	xor    %ebx,%ebx
8010392a:	eb d1                	jmp    801038fd <piperead+0xcd>
8010392c:	66 90                	xchg   %ax,%ax
8010392e:	66 90                	xchg   %ax,%ax

80103930 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103934:	bb 14 30 11 80       	mov    $0x80113014,%ebx
{
80103939:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010393c:	68 e0 2f 11 80       	push   $0x80112fe0
80103941:	e8 2a 0d 00 00       	call   80104670 <acquire>
80103946:	83 c4 10             	add    $0x10,%esp
80103949:	eb 10                	jmp    8010395b <allocproc+0x2b>
8010394b:	90                   	nop
8010394c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103950:	83 c3 7c             	add    $0x7c,%ebx
80103953:	81 fb 14 4f 11 80    	cmp    $0x80114f14,%ebx
80103959:	73 75                	jae    801039d0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010395b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010395e:	85 c0                	test   %eax,%eax
80103960:	75 ee                	jne    80103950 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103962:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103967:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010396a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103971:	8d 50 01             	lea    0x1(%eax),%edx
80103974:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103977:	68 e0 2f 11 80       	push   $0x80112fe0
  p->pid = nextpid++;
8010397c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103982:	e8 a9 0d 00 00       	call   80104730 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103987:	e8 64 ee ff ff       	call   801027f0 <kalloc>
8010398c:	83 c4 10             	add    $0x10,%esp
8010398f:	85 c0                	test   %eax,%eax
80103991:	89 43 08             	mov    %eax,0x8(%ebx)
80103994:	74 53                	je     801039e9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103996:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010399c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010399f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801039a4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801039a7:	c7 40 14 72 59 10 80 	movl   $0x80105972,0x14(%eax)
  p->context = (struct context*)sp;
801039ae:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039b1:	6a 14                	push   $0x14
801039b3:	6a 00                	push   $0x0
801039b5:	50                   	push   %eax
801039b6:	e8 c5 0d 00 00       	call   80104780 <memset>
  p->context->eip = (uint)forkret;
801039bb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801039be:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801039c1:	c7 40 10 00 3a 10 80 	movl   $0x80103a00,0x10(%eax)
}
801039c8:	89 d8                	mov    %ebx,%eax
801039ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039cd:	c9                   	leave  
801039ce:	c3                   	ret    
801039cf:	90                   	nop
  release(&ptable.lock);
801039d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801039d3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801039d5:	68 e0 2f 11 80       	push   $0x80112fe0
801039da:	e8 51 0d 00 00       	call   80104730 <release>
}
801039df:	89 d8                	mov    %ebx,%eax
  return 0;
801039e1:	83 c4 10             	add    $0x10,%esp
}
801039e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039e7:	c9                   	leave  
801039e8:	c3                   	ret    
    p->state = UNUSED;
801039e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801039f0:	31 db                	xor    %ebx,%ebx
801039f2:	eb d4                	jmp    801039c8 <allocproc+0x98>
801039f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a00 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a06:	68 e0 2f 11 80       	push   $0x80112fe0
80103a0b:	e8 20 0d 00 00       	call   80104730 <release>

  if (first) {
80103a10:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103a15:	83 c4 10             	add    $0x10,%esp
80103a18:	85 c0                	test   %eax,%eax
80103a1a:	75 04                	jne    80103a20 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a1c:	c9                   	leave  
80103a1d:	c3                   	ret    
80103a1e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103a20:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103a23:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103a2a:	00 00 00 
    iinit(ROOTDEV);
80103a2d:	6a 01                	push   $0x1
80103a2f:	e8 7c dd ff ff       	call   801017b0 <iinit>
    initlog(ROOTDEV);
80103a34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a3b:	e8 f0 f3 ff ff       	call   80102e30 <initlog>
80103a40:	83 c4 10             	add    $0x10,%esp
}
80103a43:	c9                   	leave  
80103a44:	c3                   	ret    
80103a45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a50 <pinit>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a56:	68 35 77 10 80       	push   $0x80107735
80103a5b:	68 e0 2f 11 80       	push   $0x80112fe0
80103a60:	e8 cb 0a 00 00       	call   80104530 <initlock>
}
80103a65:	83 c4 10             	add    $0x10,%esp
80103a68:	c9                   	leave  
80103a69:	c3                   	ret    
80103a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a70 <mycpu>:
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	56                   	push   %esi
80103a74:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a75:	9c                   	pushf  
80103a76:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a77:	f6 c4 02             	test   $0x2,%ah
80103a7a:	75 5e                	jne    80103ada <mycpu+0x6a>
  apicid = lapicid();
80103a7c:	e8 df ef ff ff       	call   80102a60 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a81:	8b 35 c0 2f 11 80    	mov    0x80112fc0,%esi
80103a87:	85 f6                	test   %esi,%esi
80103a89:	7e 42                	jle    80103acd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a8b:	0f b6 15 40 2a 11 80 	movzbl 0x80112a40,%edx
80103a92:	39 d0                	cmp    %edx,%eax
80103a94:	74 30                	je     80103ac6 <mycpu+0x56>
80103a96:	b9 f0 2a 11 80       	mov    $0x80112af0,%ecx
  for (i = 0; i < ncpu; ++i) {
80103a9b:	31 d2                	xor    %edx,%edx
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi
80103aa0:	83 c2 01             	add    $0x1,%edx
80103aa3:	39 f2                	cmp    %esi,%edx
80103aa5:	74 26                	je     80103acd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103aa7:	0f b6 19             	movzbl (%ecx),%ebx
80103aaa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103ab0:	39 c3                	cmp    %eax,%ebx
80103ab2:	75 ec                	jne    80103aa0 <mycpu+0x30>
80103ab4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103aba:	05 40 2a 11 80       	add    $0x80112a40,%eax
}
80103abf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ac2:	5b                   	pop    %ebx
80103ac3:	5e                   	pop    %esi
80103ac4:	5d                   	pop    %ebp
80103ac5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103ac6:	b8 40 2a 11 80       	mov    $0x80112a40,%eax
      return &cpus[i];
80103acb:	eb f2                	jmp    80103abf <mycpu+0x4f>
  panic("unknown apicid\n");
80103acd:	83 ec 0c             	sub    $0xc,%esp
80103ad0:	68 3c 77 10 80       	push   $0x8010773c
80103ad5:	e8 b6 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103ada:	83 ec 0c             	sub    $0xc,%esp
80103add:	68 18 78 10 80       	push   $0x80107818
80103ae2:	e8 a9 c8 ff ff       	call   80100390 <panic>
80103ae7:	89 f6                	mov    %esi,%esi
80103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103af0 <cpuid>:
cpuid() {
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103af6:	e8 75 ff ff ff       	call   80103a70 <mycpu>
80103afb:	2d 40 2a 11 80       	sub    $0x80112a40,%eax
}
80103b00:	c9                   	leave  
  return mycpu()-cpus;
80103b01:	c1 f8 04             	sar    $0x4,%eax
80103b04:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b0a:	c3                   	ret    
80103b0b:	90                   	nop
80103b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b10 <myproc>:
myproc(void) {
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	53                   	push   %ebx
80103b14:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b17:	e8 84 0a 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103b1c:	e8 4f ff ff ff       	call   80103a70 <mycpu>
  p = c->proc;
80103b21:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b27:	e8 b4 0a 00 00       	call   801045e0 <popcli>
}
80103b2c:	83 c4 04             	add    $0x4,%esp
80103b2f:	89 d8                	mov    %ebx,%eax
80103b31:	5b                   	pop    %ebx
80103b32:	5d                   	pop    %ebp
80103b33:	c3                   	ret    
80103b34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b40 <userinit>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	53                   	push   %ebx
80103b44:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b47:	e8 e4 fd ff ff       	call   80103930 <allocproc>
80103b4c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b4e:	a3 f8 a5 10 80       	mov    %eax,0x8010a5f8
  if((p->pgdir = setupkvm()) == 0)
80103b53:	e8 e8 33 00 00       	call   80106f40 <setupkvm>
80103b58:	85 c0                	test   %eax,%eax
80103b5a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b5d:	0f 84 bd 00 00 00    	je     80103c20 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b63:	83 ec 04             	sub    $0x4,%esp
80103b66:	68 2c 00 00 00       	push   $0x2c
80103b6b:	68 60 a4 10 80       	push   $0x8010a460
80103b70:	50                   	push   %eax
80103b71:	e8 aa 30 00 00       	call   80106c20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b76:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b79:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b7f:	6a 4c                	push   $0x4c
80103b81:	6a 00                	push   $0x0
80103b83:	ff 73 18             	pushl  0x18(%ebx)
80103b86:	e8 f5 0b 00 00       	call   80104780 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b8b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b8e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b93:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b98:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b9b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b9f:	8b 43 18             	mov    0x18(%ebx),%eax
80103ba2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ba6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ba9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bad:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bb1:	8b 43 18             	mov    0x18(%ebx),%eax
80103bb4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bb8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bbc:	8b 43 18             	mov    0x18(%ebx),%eax
80103bbf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103bc6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103bd0:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bda:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bdd:	6a 10                	push   $0x10
80103bdf:	68 65 77 10 80       	push   $0x80107765
80103be4:	50                   	push   %eax
80103be5:	e8 76 0d 00 00       	call   80104960 <safestrcpy>
  p->cwd = namei("/");
80103bea:	c7 04 24 6e 77 10 80 	movl   $0x8010776e,(%esp)
80103bf1:	e8 1a e6 ff ff       	call   80102210 <namei>
80103bf6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103bf9:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
80103c00:	e8 6b 0a 00 00       	call   80104670 <acquire>
  p->state = RUNNABLE;
80103c05:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c0c:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
80103c13:	e8 18 0b 00 00       	call   80104730 <release>
}
80103c18:	83 c4 10             	add    $0x10,%esp
80103c1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c1e:	c9                   	leave  
80103c1f:	c3                   	ret    
    panic("userinit: out of memory?");
80103c20:	83 ec 0c             	sub    $0xc,%esp
80103c23:	68 4c 77 10 80       	push   $0x8010774c
80103c28:	e8 63 c7 ff ff       	call   80100390 <panic>
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi

80103c30 <growproc>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	56                   	push   %esi
80103c34:	53                   	push   %ebx
80103c35:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c38:	e8 63 09 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103c3d:	e8 2e fe ff ff       	call   80103a70 <mycpu>
  p = c->proc;
80103c42:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c48:	e8 93 09 00 00       	call   801045e0 <popcli>
  if(n > 0){
80103c4d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103c50:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c52:	7f 1c                	jg     80103c70 <growproc+0x40>
  } else if(n < 0){
80103c54:	75 3a                	jne    80103c90 <growproc+0x60>
  switchuvm(curproc);
80103c56:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c59:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c5b:	53                   	push   %ebx
80103c5c:	e8 af 2e 00 00       	call   80106b10 <switchuvm>
  return 0;
80103c61:	83 c4 10             	add    $0x10,%esp
80103c64:	31 c0                	xor    %eax,%eax
}
80103c66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c69:	5b                   	pop    %ebx
80103c6a:	5e                   	pop    %esi
80103c6b:	5d                   	pop    %ebp
80103c6c:	c3                   	ret    
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c70:	83 ec 04             	sub    $0x4,%esp
80103c73:	01 c6                	add    %eax,%esi
80103c75:	56                   	push   %esi
80103c76:	50                   	push   %eax
80103c77:	ff 73 04             	pushl  0x4(%ebx)
80103c7a:	e8 e1 30 00 00       	call   80106d60 <allocuvm>
80103c7f:	83 c4 10             	add    $0x10,%esp
80103c82:	85 c0                	test   %eax,%eax
80103c84:	75 d0                	jne    80103c56 <growproc+0x26>
      return -1;
80103c86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c8b:	eb d9                	jmp    80103c66 <growproc+0x36>
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c90:	83 ec 04             	sub    $0x4,%esp
80103c93:	01 c6                	add    %eax,%esi
80103c95:	56                   	push   %esi
80103c96:	50                   	push   %eax
80103c97:	ff 73 04             	pushl  0x4(%ebx)
80103c9a:	e8 f1 31 00 00       	call   80106e90 <deallocuvm>
80103c9f:	83 c4 10             	add    $0x10,%esp
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	75 b0                	jne    80103c56 <growproc+0x26>
80103ca6:	eb de                	jmp    80103c86 <growproc+0x56>
80103ca8:	90                   	nop
80103ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cb0 <fork>:
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	57                   	push   %edi
80103cb4:	56                   	push   %esi
80103cb5:	53                   	push   %ebx
80103cb6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cb9:	e8 e2 08 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103cbe:	e8 ad fd ff ff       	call   80103a70 <mycpu>
  p = c->proc;
80103cc3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cc9:	e8 12 09 00 00       	call   801045e0 <popcli>
  if((np = allocproc()) == 0){
80103cce:	e8 5d fc ff ff       	call   80103930 <allocproc>
80103cd3:	85 c0                	test   %eax,%eax
80103cd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103cd8:	0f 84 b7 00 00 00    	je     80103d95 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103cde:	83 ec 08             	sub    $0x8,%esp
80103ce1:	ff 33                	pushl  (%ebx)
80103ce3:	ff 73 04             	pushl  0x4(%ebx)
80103ce6:	89 c7                	mov    %eax,%edi
80103ce8:	e8 23 33 00 00       	call   80107010 <copyuvm>
80103ced:	83 c4 10             	add    $0x10,%esp
80103cf0:	85 c0                	test   %eax,%eax
80103cf2:	89 47 04             	mov    %eax,0x4(%edi)
80103cf5:	0f 84 a1 00 00 00    	je     80103d9c <fork+0xec>
  np->sz = curproc->sz;
80103cfb:	8b 03                	mov    (%ebx),%eax
80103cfd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d00:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103d02:	89 59 14             	mov    %ebx,0x14(%ecx)
80103d05:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103d07:	8b 79 18             	mov    0x18(%ecx),%edi
80103d0a:	8b 73 18             	mov    0x18(%ebx),%esi
80103d0d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d14:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d16:	8b 40 18             	mov    0x18(%eax),%eax
80103d19:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d20:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d24:	85 c0                	test   %eax,%eax
80103d26:	74 13                	je     80103d3b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d28:	83 ec 0c             	sub    $0xc,%esp
80103d2b:	50                   	push   %eax
80103d2c:	e8 df d3 ff ff       	call   80101110 <filedup>
80103d31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d34:	83 c4 10             	add    $0x10,%esp
80103d37:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d3b:	83 c6 01             	add    $0x1,%esi
80103d3e:	83 fe 10             	cmp    $0x10,%esi
80103d41:	75 dd                	jne    80103d20 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d43:	83 ec 0c             	sub    $0xc,%esp
80103d46:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d49:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d4c:	e8 2f dc ff ff       	call   80101980 <idup>
80103d51:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d54:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d57:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d5a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d5d:	6a 10                	push   $0x10
80103d5f:	53                   	push   %ebx
80103d60:	50                   	push   %eax
80103d61:	e8 fa 0b 00 00       	call   80104960 <safestrcpy>
  pid = np->pid;
80103d66:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d69:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
80103d70:	e8 fb 08 00 00       	call   80104670 <acquire>
  np->state = RUNNABLE;
80103d75:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d7c:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
80103d83:	e8 a8 09 00 00       	call   80104730 <release>
  return pid;
80103d88:	83 c4 10             	add    $0x10,%esp
}
80103d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d8e:	89 d8                	mov    %ebx,%eax
80103d90:	5b                   	pop    %ebx
80103d91:	5e                   	pop    %esi
80103d92:	5f                   	pop    %edi
80103d93:	5d                   	pop    %ebp
80103d94:	c3                   	ret    
    return -1;
80103d95:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d9a:	eb ef                	jmp    80103d8b <fork+0xdb>
    kfree(np->kstack);
80103d9c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d9f:	83 ec 0c             	sub    $0xc,%esp
80103da2:	ff 73 08             	pushl  0x8(%ebx)
80103da5:	e8 96 e8 ff ff       	call   80102640 <kfree>
    np->kstack = 0;
80103daa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103db1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103db8:	83 c4 10             	add    $0x10,%esp
80103dbb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dc0:	eb c9                	jmp    80103d8b <fork+0xdb>
80103dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dd0 <scheduler>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	57                   	push   %edi
80103dd4:	56                   	push   %esi
80103dd5:	53                   	push   %ebx
80103dd6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103dd9:	e8 92 fc ff ff       	call   80103a70 <mycpu>
80103dde:	8d 78 04             	lea    0x4(%eax),%edi
80103de1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103de3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103dea:	00 00 00 
80103ded:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103df0:	fb                   	sti    
    acquire(&ptable.lock);
80103df1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df4:	bb 14 30 11 80       	mov    $0x80113014,%ebx
    acquire(&ptable.lock);
80103df9:	68 e0 2f 11 80       	push   $0x80112fe0
80103dfe:	e8 6d 08 00 00       	call   80104670 <acquire>
80103e03:	83 c4 10             	add    $0x10,%esp
80103e06:	8d 76 00             	lea    0x0(%esi),%esi
80103e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103e10:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e14:	75 33                	jne    80103e49 <scheduler+0x79>
      switchuvm(p);
80103e16:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e19:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e1f:	53                   	push   %ebx
80103e20:	e8 eb 2c 00 00       	call   80106b10 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e25:	58                   	pop    %eax
80103e26:	5a                   	pop    %edx
80103e27:	ff 73 1c             	pushl  0x1c(%ebx)
80103e2a:	57                   	push   %edi
      p->state = RUNNING;
80103e2b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e32:	e8 84 0b 00 00       	call   801049bb <swtch>
      switchkvm();
80103e37:	e8 b4 2c 00 00       	call   80106af0 <switchkvm>
      c->proc = 0;
80103e3c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e43:	00 00 00 
80103e46:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e49:	83 c3 7c             	add    $0x7c,%ebx
80103e4c:	81 fb 14 4f 11 80    	cmp    $0x80114f14,%ebx
80103e52:	72 bc                	jb     80103e10 <scheduler+0x40>
    release(&ptable.lock);
80103e54:	83 ec 0c             	sub    $0xc,%esp
80103e57:	68 e0 2f 11 80       	push   $0x80112fe0
80103e5c:	e8 cf 08 00 00       	call   80104730 <release>
    sti();
80103e61:	83 c4 10             	add    $0x10,%esp
80103e64:	eb 8a                	jmp    80103df0 <scheduler+0x20>
80103e66:	8d 76 00             	lea    0x0(%esi),%esi
80103e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e70 <sched>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	56                   	push   %esi
80103e74:	53                   	push   %ebx
  pushcli();
80103e75:	e8 26 07 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103e7a:	e8 f1 fb ff ff       	call   80103a70 <mycpu>
  p = c->proc;
80103e7f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e85:	e8 56 07 00 00       	call   801045e0 <popcli>
  if(!holding(&ptable.lock))
80103e8a:	83 ec 0c             	sub    $0xc,%esp
80103e8d:	68 e0 2f 11 80       	push   $0x80112fe0
80103e92:	e8 a9 07 00 00       	call   80104640 <holding>
80103e97:	83 c4 10             	add    $0x10,%esp
80103e9a:	85 c0                	test   %eax,%eax
80103e9c:	74 4f                	je     80103eed <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e9e:	e8 cd fb ff ff       	call   80103a70 <mycpu>
80103ea3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103eaa:	75 68                	jne    80103f14 <sched+0xa4>
  if(p->state == RUNNING)
80103eac:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103eb0:	74 55                	je     80103f07 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103eb2:	9c                   	pushf  
80103eb3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103eb4:	f6 c4 02             	test   $0x2,%ah
80103eb7:	75 41                	jne    80103efa <sched+0x8a>
  intena = mycpu()->intena;
80103eb9:	e8 b2 fb ff ff       	call   80103a70 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103ebe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ec1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ec7:	e8 a4 fb ff ff       	call   80103a70 <mycpu>
80103ecc:	83 ec 08             	sub    $0x8,%esp
80103ecf:	ff 70 04             	pushl  0x4(%eax)
80103ed2:	53                   	push   %ebx
80103ed3:	e8 e3 0a 00 00       	call   801049bb <swtch>
  mycpu()->intena = intena;
80103ed8:	e8 93 fb ff ff       	call   80103a70 <mycpu>
}
80103edd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ee0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ee6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ee9:	5b                   	pop    %ebx
80103eea:	5e                   	pop    %esi
80103eeb:	5d                   	pop    %ebp
80103eec:	c3                   	ret    
    panic("sched ptable.lock");
80103eed:	83 ec 0c             	sub    $0xc,%esp
80103ef0:	68 70 77 10 80       	push   $0x80107770
80103ef5:	e8 96 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 9c 77 10 80       	push   $0x8010779c
80103f02:	e8 89 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f07:	83 ec 0c             	sub    $0xc,%esp
80103f0a:	68 8e 77 10 80       	push   $0x8010778e
80103f0f:	e8 7c c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f14:	83 ec 0c             	sub    $0xc,%esp
80103f17:	68 82 77 10 80       	push   $0x80107782
80103f1c:	e8 6f c4 ff ff       	call   80100390 <panic>
80103f21:	eb 0d                	jmp    80103f30 <exit>
80103f23:	90                   	nop
80103f24:	90                   	nop
80103f25:	90                   	nop
80103f26:	90                   	nop
80103f27:	90                   	nop
80103f28:	90                   	nop
80103f29:	90                   	nop
80103f2a:	90                   	nop
80103f2b:	90                   	nop
80103f2c:	90                   	nop
80103f2d:	90                   	nop
80103f2e:	90                   	nop
80103f2f:	90                   	nop

80103f30 <exit>:
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	57                   	push   %edi
80103f34:	56                   	push   %esi
80103f35:	53                   	push   %ebx
80103f36:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f39:	e8 62 06 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80103f3e:	e8 2d fb ff ff       	call   80103a70 <mycpu>
  p = c->proc;
80103f43:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f49:	e8 92 06 00 00       	call   801045e0 <popcli>
  if(curproc == initproc)
80103f4e:	39 35 f8 a5 10 80    	cmp    %esi,0x8010a5f8
80103f54:	8d 5e 28             	lea    0x28(%esi),%ebx
80103f57:	8d 7e 68             	lea    0x68(%esi),%edi
80103f5a:	0f 84 e7 00 00 00    	je     80104047 <exit+0x117>
    if(curproc->ofile[fd]){
80103f60:	8b 03                	mov    (%ebx),%eax
80103f62:	85 c0                	test   %eax,%eax
80103f64:	74 12                	je     80103f78 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103f66:	83 ec 0c             	sub    $0xc,%esp
80103f69:	50                   	push   %eax
80103f6a:	e8 f1 d1 ff ff       	call   80101160 <fileclose>
      curproc->ofile[fd] = 0;
80103f6f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103f75:	83 c4 10             	add    $0x10,%esp
80103f78:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103f7b:	39 fb                	cmp    %edi,%ebx
80103f7d:	75 e1                	jne    80103f60 <exit+0x30>
  begin_op();
80103f7f:	e8 4c ef ff ff       	call   80102ed0 <begin_op>
  iput(curproc->cwd);
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	ff 76 68             	pushl  0x68(%esi)
80103f8a:	e8 51 db ff ff       	call   80101ae0 <iput>
  end_op();
80103f8f:	e8 ac ef ff ff       	call   80102f40 <end_op>
  curproc->cwd = 0;
80103f94:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103f9b:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
80103fa2:	e8 c9 06 00 00       	call   80104670 <acquire>
  wakeup1(curproc->parent);
80103fa7:	8b 56 14             	mov    0x14(%esi),%edx
80103faa:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fad:	b8 14 30 11 80       	mov    $0x80113014,%eax
80103fb2:	eb 0e                	jmp    80103fc2 <exit+0x92>
80103fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fb8:	83 c0 7c             	add    $0x7c,%eax
80103fbb:	3d 14 4f 11 80       	cmp    $0x80114f14,%eax
80103fc0:	73 1c                	jae    80103fde <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103fc2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fc6:	75 f0                	jne    80103fb8 <exit+0x88>
80103fc8:	3b 50 20             	cmp    0x20(%eax),%edx
80103fcb:	75 eb                	jne    80103fb8 <exit+0x88>
      p->state = RUNNABLE;
80103fcd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fd4:	83 c0 7c             	add    $0x7c,%eax
80103fd7:	3d 14 4f 11 80       	cmp    $0x80114f14,%eax
80103fdc:	72 e4                	jb     80103fc2 <exit+0x92>
      p->parent = initproc;
80103fde:	8b 0d f8 a5 10 80    	mov    0x8010a5f8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fe4:	ba 14 30 11 80       	mov    $0x80113014,%edx
80103fe9:	eb 10                	jmp    80103ffb <exit+0xcb>
80103feb:	90                   	nop
80103fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ff0:	83 c2 7c             	add    $0x7c,%edx
80103ff3:	81 fa 14 4f 11 80    	cmp    $0x80114f14,%edx
80103ff9:	73 33                	jae    8010402e <exit+0xfe>
    if(p->parent == curproc){
80103ffb:	39 72 14             	cmp    %esi,0x14(%edx)
80103ffe:	75 f0                	jne    80103ff0 <exit+0xc0>
      if(p->state == ZOMBIE)
80104000:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104004:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104007:	75 e7                	jne    80103ff0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104009:	b8 14 30 11 80       	mov    $0x80113014,%eax
8010400e:	eb 0a                	jmp    8010401a <exit+0xea>
80104010:	83 c0 7c             	add    $0x7c,%eax
80104013:	3d 14 4f 11 80       	cmp    $0x80114f14,%eax
80104018:	73 d6                	jae    80103ff0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
8010401a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010401e:	75 f0                	jne    80104010 <exit+0xe0>
80104020:	3b 48 20             	cmp    0x20(%eax),%ecx
80104023:	75 eb                	jne    80104010 <exit+0xe0>
      p->state = RUNNABLE;
80104025:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010402c:	eb e2                	jmp    80104010 <exit+0xe0>
  curproc->state = ZOMBIE;
8010402e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104035:	e8 36 fe ff ff       	call   80103e70 <sched>
  panic("zombie exit");
8010403a:	83 ec 0c             	sub    $0xc,%esp
8010403d:	68 bd 77 10 80       	push   $0x801077bd
80104042:	e8 49 c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104047:	83 ec 0c             	sub    $0xc,%esp
8010404a:	68 b0 77 10 80       	push   $0x801077b0
8010404f:	e8 3c c3 ff ff       	call   80100390 <panic>
80104054:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010405a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104060 <yield>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104067:	68 e0 2f 11 80       	push   $0x80112fe0
8010406c:	e8 ff 05 00 00       	call   80104670 <acquire>
  pushcli();
80104071:	e8 2a 05 00 00       	call   801045a0 <pushcli>
  c = mycpu();
80104076:	e8 f5 f9 ff ff       	call   80103a70 <mycpu>
  p = c->proc;
8010407b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104081:	e8 5a 05 00 00       	call   801045e0 <popcli>
  myproc()->state = RUNNABLE;
80104086:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010408d:	e8 de fd ff ff       	call   80103e70 <sched>
  release(&ptable.lock);
80104092:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
80104099:	e8 92 06 00 00       	call   80104730 <release>
}
8010409e:	83 c4 10             	add    $0x10,%esp
801040a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040a4:	c9                   	leave  
801040a5:	c3                   	ret    
801040a6:	8d 76 00             	lea    0x0(%esi),%esi
801040a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040b0 <sleep>:
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	57                   	push   %edi
801040b4:	56                   	push   %esi
801040b5:	53                   	push   %ebx
801040b6:	83 ec 0c             	sub    $0xc,%esp
801040b9:	8b 7d 08             	mov    0x8(%ebp),%edi
801040bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801040bf:	e8 dc 04 00 00       	call   801045a0 <pushcli>
  c = mycpu();
801040c4:	e8 a7 f9 ff ff       	call   80103a70 <mycpu>
  p = c->proc;
801040c9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040cf:	e8 0c 05 00 00       	call   801045e0 <popcli>
  if(p == 0)
801040d4:	85 db                	test   %ebx,%ebx
801040d6:	0f 84 87 00 00 00    	je     80104163 <sleep+0xb3>
  if(lk == 0)
801040dc:	85 f6                	test   %esi,%esi
801040de:	74 76                	je     80104156 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040e0:	81 fe e0 2f 11 80    	cmp    $0x80112fe0,%esi
801040e6:	74 50                	je     80104138 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040e8:	83 ec 0c             	sub    $0xc,%esp
801040eb:	68 e0 2f 11 80       	push   $0x80112fe0
801040f0:	e8 7b 05 00 00       	call   80104670 <acquire>
    release(lk);
801040f5:	89 34 24             	mov    %esi,(%esp)
801040f8:	e8 33 06 00 00       	call   80104730 <release>
  p->chan = chan;
801040fd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104100:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104107:	e8 64 fd ff ff       	call   80103e70 <sched>
  p->chan = 0;
8010410c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104113:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
8010411a:	e8 11 06 00 00       	call   80104730 <release>
    acquire(lk);
8010411f:	89 75 08             	mov    %esi,0x8(%ebp)
80104122:	83 c4 10             	add    $0x10,%esp
}
80104125:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104128:	5b                   	pop    %ebx
80104129:	5e                   	pop    %esi
8010412a:	5f                   	pop    %edi
8010412b:	5d                   	pop    %ebp
    acquire(lk);
8010412c:	e9 3f 05 00 00       	jmp    80104670 <acquire>
80104131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104138:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010413b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104142:	e8 29 fd ff ff       	call   80103e70 <sched>
  p->chan = 0;
80104147:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010414e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104151:	5b                   	pop    %ebx
80104152:	5e                   	pop    %esi
80104153:	5f                   	pop    %edi
80104154:	5d                   	pop    %ebp
80104155:	c3                   	ret    
    panic("sleep without lk");
80104156:	83 ec 0c             	sub    $0xc,%esp
80104159:	68 cf 77 10 80       	push   $0x801077cf
8010415e:	e8 2d c2 ff ff       	call   80100390 <panic>
    panic("sleep");
80104163:	83 ec 0c             	sub    $0xc,%esp
80104166:	68 c9 77 10 80       	push   $0x801077c9
8010416b:	e8 20 c2 ff ff       	call   80100390 <panic>

80104170 <wait>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	56                   	push   %esi
80104174:	53                   	push   %ebx
  pushcli();
80104175:	e8 26 04 00 00       	call   801045a0 <pushcli>
  c = mycpu();
8010417a:	e8 f1 f8 ff ff       	call   80103a70 <mycpu>
  p = c->proc;
8010417f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104185:	e8 56 04 00 00       	call   801045e0 <popcli>
  acquire(&ptable.lock);
8010418a:	83 ec 0c             	sub    $0xc,%esp
8010418d:	68 e0 2f 11 80       	push   $0x80112fe0
80104192:	e8 d9 04 00 00       	call   80104670 <acquire>
80104197:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010419a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010419c:	bb 14 30 11 80       	mov    $0x80113014,%ebx
801041a1:	eb 10                	jmp    801041b3 <wait+0x43>
801041a3:	90                   	nop
801041a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041a8:	83 c3 7c             	add    $0x7c,%ebx
801041ab:	81 fb 14 4f 11 80    	cmp    $0x80114f14,%ebx
801041b1:	73 1b                	jae    801041ce <wait+0x5e>
      if(p->parent != curproc)
801041b3:	39 73 14             	cmp    %esi,0x14(%ebx)
801041b6:	75 f0                	jne    801041a8 <wait+0x38>
      if(p->state == ZOMBIE){
801041b8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801041bc:	74 32                	je     801041f0 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041be:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801041c1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041c6:	81 fb 14 4f 11 80    	cmp    $0x80114f14,%ebx
801041cc:	72 e5                	jb     801041b3 <wait+0x43>
    if(!havekids || curproc->killed){
801041ce:	85 c0                	test   %eax,%eax
801041d0:	74 74                	je     80104246 <wait+0xd6>
801041d2:	8b 46 24             	mov    0x24(%esi),%eax
801041d5:	85 c0                	test   %eax,%eax
801041d7:	75 6d                	jne    80104246 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801041d9:	83 ec 08             	sub    $0x8,%esp
801041dc:	68 e0 2f 11 80       	push   $0x80112fe0
801041e1:	56                   	push   %esi
801041e2:	e8 c9 fe ff ff       	call   801040b0 <sleep>
    havekids = 0;
801041e7:	83 c4 10             	add    $0x10,%esp
801041ea:	eb ae                	jmp    8010419a <wait+0x2a>
801041ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801041f0:	83 ec 0c             	sub    $0xc,%esp
801041f3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801041f6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801041f9:	e8 42 e4 ff ff       	call   80102640 <kfree>
        freevm(p->pgdir);
801041fe:	5a                   	pop    %edx
801041ff:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104202:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104209:	e8 b2 2c 00 00       	call   80106ec0 <freevm>
        release(&ptable.lock);
8010420e:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
        p->pid = 0;
80104215:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010421c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104223:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104227:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010422e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104235:	e8 f6 04 00 00       	call   80104730 <release>
        return pid;
8010423a:	83 c4 10             	add    $0x10,%esp
}
8010423d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104240:	89 f0                	mov    %esi,%eax
80104242:	5b                   	pop    %ebx
80104243:	5e                   	pop    %esi
80104244:	5d                   	pop    %ebp
80104245:	c3                   	ret    
      release(&ptable.lock);
80104246:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104249:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010424e:	68 e0 2f 11 80       	push   $0x80112fe0
80104253:	e8 d8 04 00 00       	call   80104730 <release>
      return -1;
80104258:	83 c4 10             	add    $0x10,%esp
8010425b:	eb e0                	jmp    8010423d <wait+0xcd>
8010425d:	8d 76 00             	lea    0x0(%esi),%esi

80104260 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
80104264:	83 ec 10             	sub    $0x10,%esp
80104267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010426a:	68 e0 2f 11 80       	push   $0x80112fe0
8010426f:	e8 fc 03 00 00       	call   80104670 <acquire>
80104274:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104277:	b8 14 30 11 80       	mov    $0x80113014,%eax
8010427c:	eb 0c                	jmp    8010428a <wakeup+0x2a>
8010427e:	66 90                	xchg   %ax,%ax
80104280:	83 c0 7c             	add    $0x7c,%eax
80104283:	3d 14 4f 11 80       	cmp    $0x80114f14,%eax
80104288:	73 1c                	jae    801042a6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010428a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010428e:	75 f0                	jne    80104280 <wakeup+0x20>
80104290:	3b 58 20             	cmp    0x20(%eax),%ebx
80104293:	75 eb                	jne    80104280 <wakeup+0x20>
      p->state = RUNNABLE;
80104295:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010429c:	83 c0 7c             	add    $0x7c,%eax
8010429f:	3d 14 4f 11 80       	cmp    $0x80114f14,%eax
801042a4:	72 e4                	jb     8010428a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801042a6:	c7 45 08 e0 2f 11 80 	movl   $0x80112fe0,0x8(%ebp)
}
801042ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042b0:	c9                   	leave  
  release(&ptable.lock);
801042b1:	e9 7a 04 00 00       	jmp    80104730 <release>
801042b6:	8d 76 00             	lea    0x0(%esi),%esi
801042b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 10             	sub    $0x10,%esp
801042c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042ca:	68 e0 2f 11 80       	push   $0x80112fe0
801042cf:	e8 9c 03 00 00       	call   80104670 <acquire>
801042d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042d7:	b8 14 30 11 80       	mov    $0x80113014,%eax
801042dc:	eb 0c                	jmp    801042ea <kill+0x2a>
801042de:	66 90                	xchg   %ax,%ax
801042e0:	83 c0 7c             	add    $0x7c,%eax
801042e3:	3d 14 4f 11 80       	cmp    $0x80114f14,%eax
801042e8:	73 36                	jae    80104320 <kill+0x60>
    if(p->pid == pid){
801042ea:	39 58 10             	cmp    %ebx,0x10(%eax)
801042ed:	75 f1                	jne    801042e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042ef:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042f3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042fa:	75 07                	jne    80104303 <kill+0x43>
        p->state = RUNNABLE;
801042fc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104303:	83 ec 0c             	sub    $0xc,%esp
80104306:	68 e0 2f 11 80       	push   $0x80112fe0
8010430b:	e8 20 04 00 00       	call   80104730 <release>
      return 0;
80104310:	83 c4 10             	add    $0x10,%esp
80104313:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104315:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104318:	c9                   	leave  
80104319:	c3                   	ret    
8010431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	68 e0 2f 11 80       	push   $0x80112fe0
80104328:	e8 03 04 00 00       	call   80104730 <release>
  return -1;
8010432d:	83 c4 10             	add    $0x10,%esp
80104330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104338:	c9                   	leave  
80104339:	c3                   	ret    
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	53                   	push   %ebx
80104346:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104349:	bb 14 30 11 80       	mov    $0x80113014,%ebx
{
8010434e:	83 ec 3c             	sub    $0x3c,%esp
80104351:	eb 24                	jmp    80104377 <procdump+0x37>
80104353:	90                   	nop
80104354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104358:	83 ec 0c             	sub    $0xc,%esp
8010435b:	68 57 7b 10 80       	push   $0x80107b57
80104360:	e8 fb c2 ff ff       	call   80100660 <cprintf>
80104365:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104368:	83 c3 7c             	add    $0x7c,%ebx
8010436b:	81 fb 14 4f 11 80    	cmp    $0x80114f14,%ebx
80104371:	0f 83 81 00 00 00    	jae    801043f8 <procdump+0xb8>
    if(p->state == UNUSED)
80104377:	8b 43 0c             	mov    0xc(%ebx),%eax
8010437a:	85 c0                	test   %eax,%eax
8010437c:	74 ea                	je     80104368 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010437e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104381:	ba e0 77 10 80       	mov    $0x801077e0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104386:	77 11                	ja     80104399 <procdump+0x59>
80104388:	8b 14 85 40 78 10 80 	mov    -0x7fef87c0(,%eax,4),%edx
      state = "???";
8010438f:	b8 e0 77 10 80       	mov    $0x801077e0,%eax
80104394:	85 d2                	test   %edx,%edx
80104396:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104399:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010439c:	50                   	push   %eax
8010439d:	52                   	push   %edx
8010439e:	ff 73 10             	pushl  0x10(%ebx)
801043a1:	68 e4 77 10 80       	push   $0x801077e4
801043a6:	e8 b5 c2 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801043ab:	83 c4 10             	add    $0x10,%esp
801043ae:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801043b2:	75 a4                	jne    80104358 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801043b4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043b7:	83 ec 08             	sub    $0x8,%esp
801043ba:	8d 7d c0             	lea    -0x40(%ebp),%edi
801043bd:	50                   	push   %eax
801043be:	8b 43 1c             	mov    0x1c(%ebx),%eax
801043c1:	8b 40 0c             	mov    0xc(%eax),%eax
801043c4:	83 c0 08             	add    $0x8,%eax
801043c7:	50                   	push   %eax
801043c8:	e8 83 01 00 00       	call   80104550 <getcallerpcs>
801043cd:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043d0:	8b 17                	mov    (%edi),%edx
801043d2:	85 d2                	test   %edx,%edx
801043d4:	74 82                	je     80104358 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043d6:	83 ec 08             	sub    $0x8,%esp
801043d9:	83 c7 04             	add    $0x4,%edi
801043dc:	52                   	push   %edx
801043dd:	68 21 72 10 80       	push   $0x80107221
801043e2:	e8 79 c2 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043e7:	83 c4 10             	add    $0x10,%esp
801043ea:	39 fe                	cmp    %edi,%esi
801043ec:	75 e2                	jne    801043d0 <procdump+0x90>
801043ee:	e9 65 ff ff ff       	jmp    80104358 <procdump+0x18>
801043f3:	90                   	nop
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
801043f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043fb:	5b                   	pop    %ebx
801043fc:	5e                   	pop    %esi
801043fd:	5f                   	pop    %edi
801043fe:	5d                   	pop    %ebp
801043ff:	c3                   	ret    

80104400 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 0c             	sub    $0xc,%esp
80104407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010440a:	68 58 78 10 80       	push   $0x80107858
8010440f:	8d 43 04             	lea    0x4(%ebx),%eax
80104412:	50                   	push   %eax
80104413:	e8 18 01 00 00       	call   80104530 <initlock>
  lk->name = name;
80104418:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010441b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104421:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104424:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010442b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010442e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104431:	c9                   	leave  
80104432:	c3                   	ret    
80104433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104440 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104448:	83 ec 0c             	sub    $0xc,%esp
8010444b:	8d 73 04             	lea    0x4(%ebx),%esi
8010444e:	56                   	push   %esi
8010444f:	e8 1c 02 00 00       	call   80104670 <acquire>
  while (lk->locked) {
80104454:	8b 13                	mov    (%ebx),%edx
80104456:	83 c4 10             	add    $0x10,%esp
80104459:	85 d2                	test   %edx,%edx
8010445b:	74 16                	je     80104473 <acquiresleep+0x33>
8010445d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104460:	83 ec 08             	sub    $0x8,%esp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
80104465:	e8 46 fc ff ff       	call   801040b0 <sleep>
  while (lk->locked) {
8010446a:	8b 03                	mov    (%ebx),%eax
8010446c:	83 c4 10             	add    $0x10,%esp
8010446f:	85 c0                	test   %eax,%eax
80104471:	75 ed                	jne    80104460 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104473:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104479:	e8 92 f6 ff ff       	call   80103b10 <myproc>
8010447e:	8b 40 10             	mov    0x10(%eax),%eax
80104481:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104484:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104487:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010448a:	5b                   	pop    %ebx
8010448b:	5e                   	pop    %esi
8010448c:	5d                   	pop    %ebp
  release(&lk->lk);
8010448d:	e9 9e 02 00 00       	jmp    80104730 <release>
80104492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
801044a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044a8:	83 ec 0c             	sub    $0xc,%esp
801044ab:	8d 73 04             	lea    0x4(%ebx),%esi
801044ae:	56                   	push   %esi
801044af:	e8 bc 01 00 00       	call   80104670 <acquire>
  lk->locked = 0;
801044b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044c1:	89 1c 24             	mov    %ebx,(%esp)
801044c4:	e8 97 fd ff ff       	call   80104260 <wakeup>
  release(&lk->lk);
801044c9:	89 75 08             	mov    %esi,0x8(%ebp)
801044cc:	83 c4 10             	add    $0x10,%esp
}
801044cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044d2:	5b                   	pop    %ebx
801044d3:	5e                   	pop    %esi
801044d4:	5d                   	pop    %ebp
  release(&lk->lk);
801044d5:	e9 56 02 00 00       	jmp    80104730 <release>
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	56                   	push   %esi
801044e5:	53                   	push   %ebx
801044e6:	31 ff                	xor    %edi,%edi
801044e8:	83 ec 18             	sub    $0x18,%esp
801044eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044ee:	8d 73 04             	lea    0x4(%ebx),%esi
801044f1:	56                   	push   %esi
801044f2:	e8 79 01 00 00       	call   80104670 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044f7:	8b 03                	mov    (%ebx),%eax
801044f9:	83 c4 10             	add    $0x10,%esp
801044fc:	85 c0                	test   %eax,%eax
801044fe:	74 13                	je     80104513 <holdingsleep+0x33>
80104500:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104503:	e8 08 f6 ff ff       	call   80103b10 <myproc>
80104508:	39 58 10             	cmp    %ebx,0x10(%eax)
8010450b:	0f 94 c0             	sete   %al
8010450e:	0f b6 c0             	movzbl %al,%eax
80104511:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104513:	83 ec 0c             	sub    $0xc,%esp
80104516:	56                   	push   %esi
80104517:	e8 14 02 00 00       	call   80104730 <release>
  return r;
}
8010451c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010451f:	89 f8                	mov    %edi,%eax
80104521:	5b                   	pop    %ebx
80104522:	5e                   	pop    %esi
80104523:	5f                   	pop    %edi
80104524:	5d                   	pop    %ebp
80104525:	c3                   	ret    
80104526:	66 90                	xchg   %ax,%ax
80104528:	66 90                	xchg   %ax,%ax
8010452a:	66 90                	xchg   %ax,%ax
8010452c:	66 90                	xchg   %ax,%ax
8010452e:	66 90                	xchg   %ax,%ax

80104530 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104536:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010453f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104542:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104549:	5d                   	pop    %ebp
8010454a:	c3                   	ret    
8010454b:	90                   	nop
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104550 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104550:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104551:	31 d2                	xor    %edx,%edx
{
80104553:	89 e5                	mov    %esp,%ebp
80104555:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104556:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104559:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010455c:	83 e8 08             	sub    $0x8,%eax
8010455f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104560:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104566:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010456c:	77 1a                	ja     80104588 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010456e:	8b 58 04             	mov    0x4(%eax),%ebx
80104571:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104574:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104577:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104579:	83 fa 0a             	cmp    $0xa,%edx
8010457c:	75 e2                	jne    80104560 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010457e:	5b                   	pop    %ebx
8010457f:	5d                   	pop    %ebp
80104580:	c3                   	ret    
80104581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104588:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010458b:	83 c1 28             	add    $0x28,%ecx
8010458e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104590:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104596:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104599:	39 c1                	cmp    %eax,%ecx
8010459b:	75 f3                	jne    80104590 <getcallerpcs+0x40>
}
8010459d:	5b                   	pop    %ebx
8010459e:	5d                   	pop    %ebp
8010459f:	c3                   	ret    

801045a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 04             	sub    $0x4,%esp
801045a7:	9c                   	pushf  
801045a8:	5b                   	pop    %ebx
  asm volatile("cli");
801045a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801045aa:	e8 c1 f4 ff ff       	call   80103a70 <mycpu>
801045af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045b5:	85 c0                	test   %eax,%eax
801045b7:	75 11                	jne    801045ca <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801045b9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045bf:	e8 ac f4 ff ff       	call   80103a70 <mycpu>
801045c4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801045ca:	e8 a1 f4 ff ff       	call   80103a70 <mycpu>
801045cf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045d6:	83 c4 04             	add    $0x4,%esp
801045d9:	5b                   	pop    %ebx
801045da:	5d                   	pop    %ebp
801045db:	c3                   	ret    
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045e0 <popcli>:

void
popcli(void)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045e6:	9c                   	pushf  
801045e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045e8:	f6 c4 02             	test   $0x2,%ah
801045eb:	75 35                	jne    80104622 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045ed:	e8 7e f4 ff ff       	call   80103a70 <mycpu>
801045f2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045f9:	78 34                	js     8010462f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045fb:	e8 70 f4 ff ff       	call   80103a70 <mycpu>
80104600:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104606:	85 d2                	test   %edx,%edx
80104608:	74 06                	je     80104610 <popcli+0x30>
    sti();
}
8010460a:	c9                   	leave  
8010460b:	c3                   	ret    
8010460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104610:	e8 5b f4 ff ff       	call   80103a70 <mycpu>
80104615:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010461b:	85 c0                	test   %eax,%eax
8010461d:	74 eb                	je     8010460a <popcli+0x2a>
  asm volatile("sti");
8010461f:	fb                   	sti    
}
80104620:	c9                   	leave  
80104621:	c3                   	ret    
    panic("popcli - interruptible");
80104622:	83 ec 0c             	sub    $0xc,%esp
80104625:	68 63 78 10 80       	push   $0x80107863
8010462a:	e8 61 bd ff ff       	call   80100390 <panic>
    panic("popcli");
8010462f:	83 ec 0c             	sub    $0xc,%esp
80104632:	68 7a 78 10 80       	push   $0x8010787a
80104637:	e8 54 bd ff ff       	call   80100390 <panic>
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104640 <holding>:
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 75 08             	mov    0x8(%ebp),%esi
80104648:	31 db                	xor    %ebx,%ebx
  pushcli();
8010464a:	e8 51 ff ff ff       	call   801045a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010464f:	8b 06                	mov    (%esi),%eax
80104651:	85 c0                	test   %eax,%eax
80104653:	74 10                	je     80104665 <holding+0x25>
80104655:	8b 5e 08             	mov    0x8(%esi),%ebx
80104658:	e8 13 f4 ff ff       	call   80103a70 <mycpu>
8010465d:	39 c3                	cmp    %eax,%ebx
8010465f:	0f 94 c3             	sete   %bl
80104662:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104665:	e8 76 ff ff ff       	call   801045e0 <popcli>
}
8010466a:	89 d8                	mov    %ebx,%eax
8010466c:	5b                   	pop    %ebx
8010466d:	5e                   	pop    %esi
8010466e:	5d                   	pop    %ebp
8010466f:	c3                   	ret    

80104670 <acquire>:
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104675:	e8 26 ff ff ff       	call   801045a0 <pushcli>
  if(holding(lk))
8010467a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010467d:	83 ec 0c             	sub    $0xc,%esp
80104680:	53                   	push   %ebx
80104681:	e8 ba ff ff ff       	call   80104640 <holding>
80104686:	83 c4 10             	add    $0x10,%esp
80104689:	85 c0                	test   %eax,%eax
8010468b:	0f 85 83 00 00 00    	jne    80104714 <acquire+0xa4>
80104691:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104693:	ba 01 00 00 00       	mov    $0x1,%edx
80104698:	eb 09                	jmp    801046a3 <acquire+0x33>
8010469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046a3:	89 d0                	mov    %edx,%eax
801046a5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801046a8:	85 c0                	test   %eax,%eax
801046aa:	75 f4                	jne    801046a0 <acquire+0x30>
  __sync_synchronize();
801046ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801046b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046b4:	e8 b7 f3 ff ff       	call   80103a70 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801046b9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801046bc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801046bf:	89 e8                	mov    %ebp,%eax
801046c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046c8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801046ce:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801046d4:	77 1a                	ja     801046f0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801046d6:	8b 48 04             	mov    0x4(%eax),%ecx
801046d9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801046dc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801046df:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046e1:	83 fe 0a             	cmp    $0xa,%esi
801046e4:	75 e2                	jne    801046c8 <acquire+0x58>
}
801046e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046e9:	5b                   	pop    %ebx
801046ea:	5e                   	pop    %esi
801046eb:	5d                   	pop    %ebp
801046ec:	c3                   	ret    
801046ed:	8d 76 00             	lea    0x0(%esi),%esi
801046f0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801046f3:	83 c2 28             	add    $0x28,%edx
801046f6:	8d 76 00             	lea    0x0(%esi),%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104706:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104709:	39 d0                	cmp    %edx,%eax
8010470b:	75 f3                	jne    80104700 <acquire+0x90>
}
8010470d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104710:	5b                   	pop    %ebx
80104711:	5e                   	pop    %esi
80104712:	5d                   	pop    %ebp
80104713:	c3                   	ret    
    panic("acquire");
80104714:	83 ec 0c             	sub    $0xc,%esp
80104717:	68 81 78 10 80       	push   $0x80107881
8010471c:	e8 6f bc ff ff       	call   80100390 <panic>
80104721:	eb 0d                	jmp    80104730 <release>
80104723:	90                   	nop
80104724:	90                   	nop
80104725:	90                   	nop
80104726:	90                   	nop
80104727:	90                   	nop
80104728:	90                   	nop
80104729:	90                   	nop
8010472a:	90                   	nop
8010472b:	90                   	nop
8010472c:	90                   	nop
8010472d:	90                   	nop
8010472e:	90                   	nop
8010472f:	90                   	nop

80104730 <release>:
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 10             	sub    $0x10,%esp
80104737:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010473a:	53                   	push   %ebx
8010473b:	e8 00 ff ff ff       	call   80104640 <holding>
80104740:	83 c4 10             	add    $0x10,%esp
80104743:	85 c0                	test   %eax,%eax
80104745:	74 22                	je     80104769 <release+0x39>
  lk->pcs[0] = 0;
80104747:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010474e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104755:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010475a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104763:	c9                   	leave  
  popcli();
80104764:	e9 77 fe ff ff       	jmp    801045e0 <popcli>
    panic("release");
80104769:	83 ec 0c             	sub    $0xc,%esp
8010476c:	68 89 78 10 80       	push   $0x80107889
80104771:	e8 1a bc ff ff       	call   80100390 <panic>
80104776:	66 90                	xchg   %ax,%ax
80104778:	66 90                	xchg   %ax,%ax
8010477a:	66 90                	xchg   %ax,%ax
8010477c:	66 90                	xchg   %ax,%ax
8010477e:	66 90                	xchg   %ax,%ax

80104780 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	57                   	push   %edi
80104784:	53                   	push   %ebx
80104785:	8b 55 08             	mov    0x8(%ebp),%edx
80104788:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010478b:	f6 c2 03             	test   $0x3,%dl
8010478e:	75 05                	jne    80104795 <memset+0x15>
80104790:	f6 c1 03             	test   $0x3,%cl
80104793:	74 13                	je     801047a8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104795:	89 d7                	mov    %edx,%edi
80104797:	8b 45 0c             	mov    0xc(%ebp),%eax
8010479a:	fc                   	cld    
8010479b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010479d:	5b                   	pop    %ebx
8010479e:	89 d0                	mov    %edx,%eax
801047a0:	5f                   	pop    %edi
801047a1:	5d                   	pop    %ebp
801047a2:	c3                   	ret    
801047a3:	90                   	nop
801047a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801047a8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047ac:	c1 e9 02             	shr    $0x2,%ecx
801047af:	89 f8                	mov    %edi,%eax
801047b1:	89 fb                	mov    %edi,%ebx
801047b3:	c1 e0 18             	shl    $0x18,%eax
801047b6:	c1 e3 10             	shl    $0x10,%ebx
801047b9:	09 d8                	or     %ebx,%eax
801047bb:	09 f8                	or     %edi,%eax
801047bd:	c1 e7 08             	shl    $0x8,%edi
801047c0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047c2:	89 d7                	mov    %edx,%edi
801047c4:	fc                   	cld    
801047c5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801047c7:	5b                   	pop    %ebx
801047c8:	89 d0                	mov    %edx,%eax
801047ca:	5f                   	pop    %edi
801047cb:	5d                   	pop    %ebp
801047cc:	c3                   	ret    
801047cd:	8d 76 00             	lea    0x0(%esi),%esi

801047d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	56                   	push   %esi
801047d5:	53                   	push   %ebx
801047d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801047d9:	8b 75 08             	mov    0x8(%ebp),%esi
801047dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047df:	85 db                	test   %ebx,%ebx
801047e1:	74 29                	je     8010480c <memcmp+0x3c>
    if(*s1 != *s2)
801047e3:	0f b6 16             	movzbl (%esi),%edx
801047e6:	0f b6 0f             	movzbl (%edi),%ecx
801047e9:	38 d1                	cmp    %dl,%cl
801047eb:	75 2b                	jne    80104818 <memcmp+0x48>
801047ed:	b8 01 00 00 00       	mov    $0x1,%eax
801047f2:	eb 14                	jmp    80104808 <memcmp+0x38>
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801047fc:	83 c0 01             	add    $0x1,%eax
801047ff:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104804:	38 ca                	cmp    %cl,%dl
80104806:	75 10                	jne    80104818 <memcmp+0x48>
  while(n-- > 0){
80104808:	39 d8                	cmp    %ebx,%eax
8010480a:	75 ec                	jne    801047f8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010480c:	5b                   	pop    %ebx
  return 0;
8010480d:	31 c0                	xor    %eax,%eax
}
8010480f:	5e                   	pop    %esi
80104810:	5f                   	pop    %edi
80104811:	5d                   	pop    %ebp
80104812:	c3                   	ret    
80104813:	90                   	nop
80104814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104818:	0f b6 c2             	movzbl %dl,%eax
}
8010481b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010481c:	29 c8                	sub    %ecx,%eax
}
8010481e:	5e                   	pop    %esi
8010481f:	5f                   	pop    %edi
80104820:	5d                   	pop    %ebp
80104821:	c3                   	ret    
80104822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
80104835:	8b 45 08             	mov    0x8(%ebp),%eax
80104838:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010483b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010483e:	39 c3                	cmp    %eax,%ebx
80104840:	73 26                	jae    80104868 <memmove+0x38>
80104842:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104845:	39 c8                	cmp    %ecx,%eax
80104847:	73 1f                	jae    80104868 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104849:	85 f6                	test   %esi,%esi
8010484b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010484e:	74 0f                	je     8010485f <memmove+0x2f>
      *--d = *--s;
80104850:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104854:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104857:	83 ea 01             	sub    $0x1,%edx
8010485a:	83 fa ff             	cmp    $0xffffffff,%edx
8010485d:	75 f1                	jne    80104850 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010485f:	5b                   	pop    %ebx
80104860:	5e                   	pop    %esi
80104861:	5d                   	pop    %ebp
80104862:	c3                   	ret    
80104863:	90                   	nop
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104868:	31 d2                	xor    %edx,%edx
8010486a:	85 f6                	test   %esi,%esi
8010486c:	74 f1                	je     8010485f <memmove+0x2f>
8010486e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104870:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104874:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104877:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010487a:	39 d6                	cmp    %edx,%esi
8010487c:	75 f2                	jne    80104870 <memmove+0x40>
}
8010487e:	5b                   	pop    %ebx
8010487f:	5e                   	pop    %esi
80104880:	5d                   	pop    %ebp
80104881:	c3                   	ret    
80104882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104890 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104893:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104894:	eb 9a                	jmp    80104830 <memmove>
80104896:	8d 76 00             	lea    0x0(%esi),%esi
80104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048a0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	57                   	push   %edi
801048a4:	56                   	push   %esi
801048a5:	8b 7d 10             	mov    0x10(%ebp),%edi
801048a8:	53                   	push   %ebx
801048a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801048af:	85 ff                	test   %edi,%edi
801048b1:	74 2f                	je     801048e2 <strncmp+0x42>
801048b3:	0f b6 01             	movzbl (%ecx),%eax
801048b6:	0f b6 1e             	movzbl (%esi),%ebx
801048b9:	84 c0                	test   %al,%al
801048bb:	74 37                	je     801048f4 <strncmp+0x54>
801048bd:	38 c3                	cmp    %al,%bl
801048bf:	75 33                	jne    801048f4 <strncmp+0x54>
801048c1:	01 f7                	add    %esi,%edi
801048c3:	eb 13                	jmp    801048d8 <strncmp+0x38>
801048c5:	8d 76 00             	lea    0x0(%esi),%esi
801048c8:	0f b6 01             	movzbl (%ecx),%eax
801048cb:	84 c0                	test   %al,%al
801048cd:	74 21                	je     801048f0 <strncmp+0x50>
801048cf:	0f b6 1a             	movzbl (%edx),%ebx
801048d2:	89 d6                	mov    %edx,%esi
801048d4:	38 d8                	cmp    %bl,%al
801048d6:	75 1c                	jne    801048f4 <strncmp+0x54>
    n--, p++, q++;
801048d8:	8d 56 01             	lea    0x1(%esi),%edx
801048db:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048de:	39 fa                	cmp    %edi,%edx
801048e0:	75 e6                	jne    801048c8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801048e2:	5b                   	pop    %ebx
    return 0;
801048e3:	31 c0                	xor    %eax,%eax
}
801048e5:	5e                   	pop    %esi
801048e6:	5f                   	pop    %edi
801048e7:	5d                   	pop    %ebp
801048e8:	c3                   	ret    
801048e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048f0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801048f4:	29 d8                	sub    %ebx,%eax
}
801048f6:	5b                   	pop    %ebx
801048f7:	5e                   	pop    %esi
801048f8:	5f                   	pop    %edi
801048f9:	5d                   	pop    %ebp
801048fa:	c3                   	ret    
801048fb:	90                   	nop
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104900 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
80104905:	8b 45 08             	mov    0x8(%ebp),%eax
80104908:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010490b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010490e:	89 c2                	mov    %eax,%edx
80104910:	eb 19                	jmp    8010492b <strncpy+0x2b>
80104912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104918:	83 c3 01             	add    $0x1,%ebx
8010491b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010491f:	83 c2 01             	add    $0x1,%edx
80104922:	84 c9                	test   %cl,%cl
80104924:	88 4a ff             	mov    %cl,-0x1(%edx)
80104927:	74 09                	je     80104932 <strncpy+0x32>
80104929:	89 f1                	mov    %esi,%ecx
8010492b:	85 c9                	test   %ecx,%ecx
8010492d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104930:	7f e6                	jg     80104918 <strncpy+0x18>
    ;
  while(n-- > 0)
80104932:	31 c9                	xor    %ecx,%ecx
80104934:	85 f6                	test   %esi,%esi
80104936:	7e 17                	jle    8010494f <strncpy+0x4f>
80104938:	90                   	nop
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104940:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104944:	89 f3                	mov    %esi,%ebx
80104946:	83 c1 01             	add    $0x1,%ecx
80104949:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010494b:	85 db                	test   %ebx,%ebx
8010494d:	7f f1                	jg     80104940 <strncpy+0x40>
  return os;
}
8010494f:	5b                   	pop    %ebx
80104950:	5e                   	pop    %esi
80104951:	5d                   	pop    %ebp
80104952:	c3                   	ret    
80104953:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104960 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
80104965:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104968:	8b 45 08             	mov    0x8(%ebp),%eax
8010496b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010496e:	85 c9                	test   %ecx,%ecx
80104970:	7e 26                	jle    80104998 <safestrcpy+0x38>
80104972:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104976:	89 c1                	mov    %eax,%ecx
80104978:	eb 17                	jmp    80104991 <safestrcpy+0x31>
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104980:	83 c2 01             	add    $0x1,%edx
80104983:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104987:	83 c1 01             	add    $0x1,%ecx
8010498a:	84 db                	test   %bl,%bl
8010498c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010498f:	74 04                	je     80104995 <safestrcpy+0x35>
80104991:	39 f2                	cmp    %esi,%edx
80104993:	75 eb                	jne    80104980 <safestrcpy+0x20>
    ;
  *s = 0;
80104995:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104998:	5b                   	pop    %ebx
80104999:	5e                   	pop    %esi
8010499a:	5d                   	pop    %ebp
8010499b:	c3                   	ret    
8010499c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049a0 <strlen>:

int
strlen(const char *s)
{
801049a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049a1:	31 c0                	xor    %eax,%eax
{
801049a3:	89 e5                	mov    %esp,%ebp
801049a5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049a8:	80 3a 00             	cmpb   $0x0,(%edx)
801049ab:	74 0c                	je     801049b9 <strlen+0x19>
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
801049b0:	83 c0 01             	add    $0x1,%eax
801049b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049b7:	75 f7                	jne    801049b0 <strlen+0x10>
    ;
  return n;
}
801049b9:	5d                   	pop    %ebp
801049ba:	c3                   	ret    

801049bb <swtch>:
801049bb:	8b 44 24 04          	mov    0x4(%esp),%eax
801049bf:	8b 54 24 08          	mov    0x8(%esp),%edx
801049c3:	55                   	push   %ebp
801049c4:	53                   	push   %ebx
801049c5:	56                   	push   %esi
801049c6:	57                   	push   %edi
801049c7:	89 20                	mov    %esp,(%eax)
801049c9:	89 d4                	mov    %edx,%esp
801049cb:	5f                   	pop    %edi
801049cc:	5e                   	pop    %esi
801049cd:	5b                   	pop    %ebx
801049ce:	5d                   	pop    %ebp
801049cf:	c3                   	ret    

801049d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	53                   	push   %ebx
801049d4:	83 ec 04             	sub    $0x4,%esp
801049d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049da:	e8 31 f1 ff ff       	call   80103b10 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049df:	8b 00                	mov    (%eax),%eax
801049e1:	39 d8                	cmp    %ebx,%eax
801049e3:	76 1b                	jbe    80104a00 <fetchint+0x30>
801049e5:	8d 53 04             	lea    0x4(%ebx),%edx
801049e8:	39 d0                	cmp    %edx,%eax
801049ea:	72 14                	jb     80104a00 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ef:	8b 13                	mov    (%ebx),%edx
801049f1:	89 10                	mov    %edx,(%eax)
  return 0;
801049f3:	31 c0                	xor    %eax,%eax
}
801049f5:	83 c4 04             	add    $0x4,%esp
801049f8:	5b                   	pop    %ebx
801049f9:	5d                   	pop    %ebp
801049fa:	c3                   	ret    
801049fb:	90                   	nop
801049fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a05:	eb ee                	jmp    801049f5 <fetchint+0x25>
80104a07:	89 f6                	mov    %esi,%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	53                   	push   %ebx
80104a14:	83 ec 04             	sub    $0x4,%esp
80104a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a1a:	e8 f1 f0 ff ff       	call   80103b10 <myproc>

  if(addr >= curproc->sz)
80104a1f:	39 18                	cmp    %ebx,(%eax)
80104a21:	76 29                	jbe    80104a4c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104a23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104a26:	89 da                	mov    %ebx,%edx
80104a28:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104a2a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104a2c:	39 c3                	cmp    %eax,%ebx
80104a2e:	73 1c                	jae    80104a4c <fetchstr+0x3c>
    if(*s == 0)
80104a30:	80 3b 00             	cmpb   $0x0,(%ebx)
80104a33:	75 10                	jne    80104a45 <fetchstr+0x35>
80104a35:	eb 39                	jmp    80104a70 <fetchstr+0x60>
80104a37:	89 f6                	mov    %esi,%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104a40:	80 3a 00             	cmpb   $0x0,(%edx)
80104a43:	74 1b                	je     80104a60 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104a45:	83 c2 01             	add    $0x1,%edx
80104a48:	39 d0                	cmp    %edx,%eax
80104a4a:	77 f4                	ja     80104a40 <fetchstr+0x30>
    return -1;
80104a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104a51:	83 c4 04             	add    $0x4,%esp
80104a54:	5b                   	pop    %ebx
80104a55:	5d                   	pop    %ebp
80104a56:	c3                   	ret    
80104a57:	89 f6                	mov    %esi,%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104a60:	83 c4 04             	add    $0x4,%esp
80104a63:	89 d0                	mov    %edx,%eax
80104a65:	29 d8                	sub    %ebx,%eax
80104a67:	5b                   	pop    %ebx
80104a68:	5d                   	pop    %ebp
80104a69:	c3                   	ret    
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104a70:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104a72:	eb dd                	jmp    80104a51 <fetchstr+0x41>
80104a74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a80 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a85:	e8 86 f0 ff ff       	call   80103b10 <myproc>
80104a8a:	8b 40 18             	mov    0x18(%eax),%eax
80104a8d:	8b 55 08             	mov    0x8(%ebp),%edx
80104a90:	8b 40 44             	mov    0x44(%eax),%eax
80104a93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a96:	e8 75 f0 ff ff       	call   80103b10 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a9b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a9d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104aa0:	39 c6                	cmp    %eax,%esi
80104aa2:	73 1c                	jae    80104ac0 <argint+0x40>
80104aa4:	8d 53 08             	lea    0x8(%ebx),%edx
80104aa7:	39 d0                	cmp    %edx,%eax
80104aa9:	72 15                	jb     80104ac0 <argint+0x40>
  *ip = *(int*)(addr);
80104aab:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aae:	8b 53 04             	mov    0x4(%ebx),%edx
80104ab1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ab3:	31 c0                	xor    %eax,%eax
}
80104ab5:	5b                   	pop    %ebx
80104ab6:	5e                   	pop    %esi
80104ab7:	5d                   	pop    %ebp
80104ab8:	c3                   	ret    
80104ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ac5:	eb ee                	jmp    80104ab5 <argint+0x35>
80104ac7:	89 f6                	mov    %esi,%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	83 ec 10             	sub    $0x10,%esp
80104ad8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104adb:	e8 30 f0 ff ff       	call   80103b10 <myproc>
80104ae0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ae2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ae5:	83 ec 08             	sub    $0x8,%esp
80104ae8:	50                   	push   %eax
80104ae9:	ff 75 08             	pushl  0x8(%ebp)
80104aec:	e8 8f ff ff ff       	call   80104a80 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104af1:	83 c4 10             	add    $0x10,%esp
80104af4:	85 c0                	test   %eax,%eax
80104af6:	78 28                	js     80104b20 <argptr+0x50>
80104af8:	85 db                	test   %ebx,%ebx
80104afa:	78 24                	js     80104b20 <argptr+0x50>
80104afc:	8b 16                	mov    (%esi),%edx
80104afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b01:	39 c2                	cmp    %eax,%edx
80104b03:	76 1b                	jbe    80104b20 <argptr+0x50>
80104b05:	01 c3                	add    %eax,%ebx
80104b07:	39 da                	cmp    %ebx,%edx
80104b09:	72 15                	jb     80104b20 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b0e:	89 02                	mov    %eax,(%edx)
  return 0;
80104b10:	31 c0                	xor    %eax,%eax
}
80104b12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b15:	5b                   	pop    %ebx
80104b16:	5e                   	pop    %esi
80104b17:	5d                   	pop    %ebp
80104b18:	c3                   	ret    
80104b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b25:	eb eb                	jmp    80104b12 <argptr+0x42>
80104b27:	89 f6                	mov    %esi,%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104b36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b39:	50                   	push   %eax
80104b3a:	ff 75 08             	pushl  0x8(%ebp)
80104b3d:	e8 3e ff ff ff       	call   80104a80 <argint>
80104b42:	83 c4 10             	add    $0x10,%esp
80104b45:	85 c0                	test   %eax,%eax
80104b47:	78 17                	js     80104b60 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104b49:	83 ec 08             	sub    $0x8,%esp
80104b4c:	ff 75 0c             	pushl  0xc(%ebp)
80104b4f:	ff 75 f4             	pushl  -0xc(%ebp)
80104b52:	e8 b9 fe ff ff       	call   80104a10 <fetchstr>
80104b57:	83 c4 10             	add    $0x10,%esp
}
80104b5a:	c9                   	leave  
80104b5b:	c3                   	ret    
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b65:	c9                   	leave  
80104b66:	c3                   	ret    
80104b67:	89 f6                	mov    %esi,%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b70 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	53                   	push   %ebx
80104b74:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b77:	e8 94 ef ff ff       	call   80103b10 <myproc>
80104b7c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b7e:	8b 40 18             	mov    0x18(%eax),%eax
80104b81:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b84:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b87:	83 fa 14             	cmp    $0x14,%edx
80104b8a:	77 1c                	ja     80104ba8 <syscall+0x38>
80104b8c:	8b 14 85 c0 78 10 80 	mov    -0x7fef8740(,%eax,4),%edx
80104b93:	85 d2                	test   %edx,%edx
80104b95:	74 11                	je     80104ba8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104b97:	ff d2                	call   *%edx
80104b99:	8b 53 18             	mov    0x18(%ebx),%edx
80104b9c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ba2:	c9                   	leave  
80104ba3:	c3                   	ret    
80104ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ba8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ba9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104bac:	50                   	push   %eax
80104bad:	ff 73 10             	pushl  0x10(%ebx)
80104bb0:	68 91 78 10 80       	push   $0x80107891
80104bb5:	e8 a6 ba ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104bba:	8b 43 18             	mov    0x18(%ebx),%eax
80104bbd:	83 c4 10             	add    $0x10,%esp
80104bc0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104bc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bca:	c9                   	leave  
80104bcb:	c3                   	ret    
80104bcc:	66 90                	xchg   %ax,%ax
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
80104bd5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104bd6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104bd9:	83 ec 44             	sub    $0x44,%esp
80104bdc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104bdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104be2:	56                   	push   %esi
80104be3:	50                   	push   %eax
{
80104be4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104be7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104bea:	e8 41 d6 ff ff       	call   80102230 <nameiparent>
80104bef:	83 c4 10             	add    $0x10,%esp
80104bf2:	85 c0                	test   %eax,%eax
80104bf4:	0f 84 46 01 00 00    	je     80104d40 <create+0x170>
    return 0;
  ilock(dp);
80104bfa:	83 ec 0c             	sub    $0xc,%esp
80104bfd:	89 c3                	mov    %eax,%ebx
80104bff:	50                   	push   %eax
80104c00:	e8 ab cd ff ff       	call   801019b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104c05:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104c08:	83 c4 0c             	add    $0xc,%esp
80104c0b:	50                   	push   %eax
80104c0c:	56                   	push   %esi
80104c0d:	53                   	push   %ebx
80104c0e:	e8 cd d2 ff ff       	call   80101ee0 <dirlookup>
80104c13:	83 c4 10             	add    $0x10,%esp
80104c16:	85 c0                	test   %eax,%eax
80104c18:	89 c7                	mov    %eax,%edi
80104c1a:	74 34                	je     80104c50 <create+0x80>
    iunlockput(dp);
80104c1c:	83 ec 0c             	sub    $0xc,%esp
80104c1f:	53                   	push   %ebx
80104c20:	e8 1b d0 ff ff       	call   80101c40 <iunlockput>
    ilock(ip);
80104c25:	89 3c 24             	mov    %edi,(%esp)
80104c28:	e8 83 cd ff ff       	call   801019b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c2d:	83 c4 10             	add    $0x10,%esp
80104c30:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104c35:	0f 85 95 00 00 00    	jne    80104cd0 <create+0x100>
80104c3b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104c40:	0f 85 8a 00 00 00    	jne    80104cd0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c49:	89 f8                	mov    %edi,%eax
80104c4b:	5b                   	pop    %ebx
80104c4c:	5e                   	pop    %esi
80104c4d:	5f                   	pop    %edi
80104c4e:	5d                   	pop    %ebp
80104c4f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104c50:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104c54:	83 ec 08             	sub    $0x8,%esp
80104c57:	50                   	push   %eax
80104c58:	ff 33                	pushl  (%ebx)
80104c5a:	e8 e1 cb ff ff       	call   80101840 <ialloc>
80104c5f:	83 c4 10             	add    $0x10,%esp
80104c62:	85 c0                	test   %eax,%eax
80104c64:	89 c7                	mov    %eax,%edi
80104c66:	0f 84 e8 00 00 00    	je     80104d54 <create+0x184>
  ilock(ip);
80104c6c:	83 ec 0c             	sub    $0xc,%esp
80104c6f:	50                   	push   %eax
80104c70:	e8 3b cd ff ff       	call   801019b0 <ilock>
  ip->major = major;
80104c75:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104c79:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104c7d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104c81:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104c85:	b8 01 00 00 00       	mov    $0x1,%eax
80104c8a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104c8e:	89 3c 24             	mov    %edi,(%esp)
80104c91:	e8 6a cc ff ff       	call   80101900 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c96:	83 c4 10             	add    $0x10,%esp
80104c99:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104c9e:	74 50                	je     80104cf0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ca0:	83 ec 04             	sub    $0x4,%esp
80104ca3:	ff 77 04             	pushl  0x4(%edi)
80104ca6:	56                   	push   %esi
80104ca7:	53                   	push   %ebx
80104ca8:	e8 a3 d4 ff ff       	call   80102150 <dirlink>
80104cad:	83 c4 10             	add    $0x10,%esp
80104cb0:	85 c0                	test   %eax,%eax
80104cb2:	0f 88 8f 00 00 00    	js     80104d47 <create+0x177>
  iunlockput(dp);
80104cb8:	83 ec 0c             	sub    $0xc,%esp
80104cbb:	53                   	push   %ebx
80104cbc:	e8 7f cf ff ff       	call   80101c40 <iunlockput>
  return ip;
80104cc1:	83 c4 10             	add    $0x10,%esp
}
80104cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cc7:	89 f8                	mov    %edi,%eax
80104cc9:	5b                   	pop    %ebx
80104cca:	5e                   	pop    %esi
80104ccb:	5f                   	pop    %edi
80104ccc:	5d                   	pop    %ebp
80104ccd:	c3                   	ret    
80104cce:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104cd0:	83 ec 0c             	sub    $0xc,%esp
80104cd3:	57                   	push   %edi
    return 0;
80104cd4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104cd6:	e8 65 cf ff ff       	call   80101c40 <iunlockput>
    return 0;
80104cdb:	83 c4 10             	add    $0x10,%esp
}
80104cde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ce1:	89 f8                	mov    %edi,%eax
80104ce3:	5b                   	pop    %ebx
80104ce4:	5e                   	pop    %esi
80104ce5:	5f                   	pop    %edi
80104ce6:	5d                   	pop    %ebp
80104ce7:	c3                   	ret    
80104ce8:	90                   	nop
80104ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104cf0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104cf5:	83 ec 0c             	sub    $0xc,%esp
80104cf8:	53                   	push   %ebx
80104cf9:	e8 02 cc ff ff       	call   80101900 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104cfe:	83 c4 0c             	add    $0xc,%esp
80104d01:	ff 77 04             	pushl  0x4(%edi)
80104d04:	68 34 79 10 80       	push   $0x80107934
80104d09:	57                   	push   %edi
80104d0a:	e8 41 d4 ff ff       	call   80102150 <dirlink>
80104d0f:	83 c4 10             	add    $0x10,%esp
80104d12:	85 c0                	test   %eax,%eax
80104d14:	78 1c                	js     80104d32 <create+0x162>
80104d16:	83 ec 04             	sub    $0x4,%esp
80104d19:	ff 73 04             	pushl  0x4(%ebx)
80104d1c:	68 33 79 10 80       	push   $0x80107933
80104d21:	57                   	push   %edi
80104d22:	e8 29 d4 ff ff       	call   80102150 <dirlink>
80104d27:	83 c4 10             	add    $0x10,%esp
80104d2a:	85 c0                	test   %eax,%eax
80104d2c:	0f 89 6e ff ff ff    	jns    80104ca0 <create+0xd0>
      panic("create dots");
80104d32:	83 ec 0c             	sub    $0xc,%esp
80104d35:	68 27 79 10 80       	push   $0x80107927
80104d3a:	e8 51 b6 ff ff       	call   80100390 <panic>
80104d3f:	90                   	nop
    return 0;
80104d40:	31 ff                	xor    %edi,%edi
80104d42:	e9 ff fe ff ff       	jmp    80104c46 <create+0x76>
    panic("create: dirlink");
80104d47:	83 ec 0c             	sub    $0xc,%esp
80104d4a:	68 36 79 10 80       	push   $0x80107936
80104d4f:	e8 3c b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104d54:	83 ec 0c             	sub    $0xc,%esp
80104d57:	68 18 79 10 80       	push   $0x80107918
80104d5c:	e8 2f b6 ff ff       	call   80100390 <panic>
80104d61:	eb 0d                	jmp    80104d70 <argfd.constprop.0>
80104d63:	90                   	nop
80104d64:	90                   	nop
80104d65:	90                   	nop
80104d66:	90                   	nop
80104d67:	90                   	nop
80104d68:	90                   	nop
80104d69:	90                   	nop
80104d6a:	90                   	nop
80104d6b:	90                   	nop
80104d6c:	90                   	nop
80104d6d:	90                   	nop
80104d6e:	90                   	nop
80104d6f:	90                   	nop

80104d70 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
80104d75:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104d77:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d7a:	89 d6                	mov    %edx,%esi
80104d7c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d7f:	50                   	push   %eax
80104d80:	6a 00                	push   $0x0
80104d82:	e8 f9 fc ff ff       	call   80104a80 <argint>
80104d87:	83 c4 10             	add    $0x10,%esp
80104d8a:	85 c0                	test   %eax,%eax
80104d8c:	78 2a                	js     80104db8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d8e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d92:	77 24                	ja     80104db8 <argfd.constprop.0+0x48>
80104d94:	e8 77 ed ff ff       	call   80103b10 <myproc>
80104d99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d9c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104da0:	85 c0                	test   %eax,%eax
80104da2:	74 14                	je     80104db8 <argfd.constprop.0+0x48>
  if(pfd)
80104da4:	85 db                	test   %ebx,%ebx
80104da6:	74 02                	je     80104daa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104da8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104daa:	89 06                	mov    %eax,(%esi)
  return 0;
80104dac:	31 c0                	xor    %eax,%eax
}
80104dae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104db1:	5b                   	pop    %ebx
80104db2:	5e                   	pop    %esi
80104db3:	5d                   	pop    %ebp
80104db4:	c3                   	ret    
80104db5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104db8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dbd:	eb ef                	jmp    80104dae <argfd.constprop.0+0x3e>
80104dbf:	90                   	nop

80104dc0 <sys_dup>:
{
80104dc0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104dc1:	31 c0                	xor    %eax,%eax
{
80104dc3:	89 e5                	mov    %esp,%ebp
80104dc5:	56                   	push   %esi
80104dc6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104dc7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104dca:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104dcd:	e8 9e ff ff ff       	call   80104d70 <argfd.constprop.0>
80104dd2:	85 c0                	test   %eax,%eax
80104dd4:	78 42                	js     80104e18 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104dd6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104dd9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104ddb:	e8 30 ed ff ff       	call   80103b10 <myproc>
80104de0:	eb 0e                	jmp    80104df0 <sys_dup+0x30>
80104de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104de8:	83 c3 01             	add    $0x1,%ebx
80104deb:	83 fb 10             	cmp    $0x10,%ebx
80104dee:	74 28                	je     80104e18 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104df0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104df4:	85 d2                	test   %edx,%edx
80104df6:	75 f0                	jne    80104de8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104df8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104dfc:	83 ec 0c             	sub    $0xc,%esp
80104dff:	ff 75 f4             	pushl  -0xc(%ebp)
80104e02:	e8 09 c3 ff ff       	call   80101110 <filedup>
  return fd;
80104e07:	83 c4 10             	add    $0x10,%esp
}
80104e0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e0d:	89 d8                	mov    %ebx,%eax
80104e0f:	5b                   	pop    %ebx
80104e10:	5e                   	pop    %esi
80104e11:	5d                   	pop    %ebp
80104e12:	c3                   	ret    
80104e13:	90                   	nop
80104e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e18:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e1b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e20:	89 d8                	mov    %ebx,%eax
80104e22:	5b                   	pop    %ebx
80104e23:	5e                   	pop    %esi
80104e24:	5d                   	pop    %ebp
80104e25:	c3                   	ret    
80104e26:	8d 76 00             	lea    0x0(%esi),%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e30 <sys_read>:
{
80104e30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e31:	31 c0                	xor    %eax,%eax
{
80104e33:	89 e5                	mov    %esp,%ebp
80104e35:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e3b:	e8 30 ff ff ff       	call   80104d70 <argfd.constprop.0>
80104e40:	85 c0                	test   %eax,%eax
80104e42:	78 4c                	js     80104e90 <sys_read+0x60>
80104e44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e47:	83 ec 08             	sub    $0x8,%esp
80104e4a:	50                   	push   %eax
80104e4b:	6a 02                	push   $0x2
80104e4d:	e8 2e fc ff ff       	call   80104a80 <argint>
80104e52:	83 c4 10             	add    $0x10,%esp
80104e55:	85 c0                	test   %eax,%eax
80104e57:	78 37                	js     80104e90 <sys_read+0x60>
80104e59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e5c:	83 ec 04             	sub    $0x4,%esp
80104e5f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e62:	50                   	push   %eax
80104e63:	6a 01                	push   $0x1
80104e65:	e8 66 fc ff ff       	call   80104ad0 <argptr>
80104e6a:	83 c4 10             	add    $0x10,%esp
80104e6d:	85 c0                	test   %eax,%eax
80104e6f:	78 1f                	js     80104e90 <sys_read+0x60>
  return fileread(f, p, n);
80104e71:	83 ec 04             	sub    $0x4,%esp
80104e74:	ff 75 f0             	pushl  -0x10(%ebp)
80104e77:	ff 75 f4             	pushl  -0xc(%ebp)
80104e7a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e7d:	e8 fe c3 ff ff       	call   80101280 <fileread>
80104e82:	83 c4 10             	add    $0x10,%esp
}
80104e85:	c9                   	leave  
80104e86:	c3                   	ret    
80104e87:	89 f6                	mov    %esi,%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e95:	c9                   	leave  
80104e96:	c3                   	ret    
80104e97:	89 f6                	mov    %esi,%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <sys_write>:
{
80104ea0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ea1:	31 c0                	xor    %eax,%eax
{
80104ea3:	89 e5                	mov    %esp,%ebp
80104ea5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ea8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104eab:	e8 c0 fe ff ff       	call   80104d70 <argfd.constprop.0>
80104eb0:	85 c0                	test   %eax,%eax
80104eb2:	78 4c                	js     80104f00 <sys_write+0x60>
80104eb4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104eb7:	83 ec 08             	sub    $0x8,%esp
80104eba:	50                   	push   %eax
80104ebb:	6a 02                	push   $0x2
80104ebd:	e8 be fb ff ff       	call   80104a80 <argint>
80104ec2:	83 c4 10             	add    $0x10,%esp
80104ec5:	85 c0                	test   %eax,%eax
80104ec7:	78 37                	js     80104f00 <sys_write+0x60>
80104ec9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ecc:	83 ec 04             	sub    $0x4,%esp
80104ecf:	ff 75 f0             	pushl  -0x10(%ebp)
80104ed2:	50                   	push   %eax
80104ed3:	6a 01                	push   $0x1
80104ed5:	e8 f6 fb ff ff       	call   80104ad0 <argptr>
80104eda:	83 c4 10             	add    $0x10,%esp
80104edd:	85 c0                	test   %eax,%eax
80104edf:	78 1f                	js     80104f00 <sys_write+0x60>
  return filewrite(f, p, n);
80104ee1:	83 ec 04             	sub    $0x4,%esp
80104ee4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ee7:	ff 75 f4             	pushl  -0xc(%ebp)
80104eea:	ff 75 ec             	pushl  -0x14(%ebp)
80104eed:	e8 1e c4 ff ff       	call   80101310 <filewrite>
80104ef2:	83 c4 10             	add    $0x10,%esp
}
80104ef5:	c9                   	leave  
80104ef6:	c3                   	ret    
80104ef7:	89 f6                	mov    %esi,%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f05:	c9                   	leave  
80104f06:	c3                   	ret    
80104f07:	89 f6                	mov    %esi,%esi
80104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f10 <sys_close>:
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104f16:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f19:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f1c:	e8 4f fe ff ff       	call   80104d70 <argfd.constprop.0>
80104f21:	85 c0                	test   %eax,%eax
80104f23:	78 2b                	js     80104f50 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104f25:	e8 e6 eb ff ff       	call   80103b10 <myproc>
80104f2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104f2d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f30:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104f37:	00 
  fileclose(f);
80104f38:	ff 75 f4             	pushl  -0xc(%ebp)
80104f3b:	e8 20 c2 ff ff       	call   80101160 <fileclose>
  return 0;
80104f40:	83 c4 10             	add    $0x10,%esp
80104f43:	31 c0                	xor    %eax,%eax
}
80104f45:	c9                   	leave  
80104f46:	c3                   	ret    
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f55:	c9                   	leave  
80104f56:	c3                   	ret    
80104f57:	89 f6                	mov    %esi,%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <sys_fstat>:
{
80104f60:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f61:	31 c0                	xor    %eax,%eax
{
80104f63:	89 e5                	mov    %esp,%ebp
80104f65:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f68:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f6b:	e8 00 fe ff ff       	call   80104d70 <argfd.constprop.0>
80104f70:	85 c0                	test   %eax,%eax
80104f72:	78 2c                	js     80104fa0 <sys_fstat+0x40>
80104f74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f77:	83 ec 04             	sub    $0x4,%esp
80104f7a:	6a 14                	push   $0x14
80104f7c:	50                   	push   %eax
80104f7d:	6a 01                	push   $0x1
80104f7f:	e8 4c fb ff ff       	call   80104ad0 <argptr>
80104f84:	83 c4 10             	add    $0x10,%esp
80104f87:	85 c0                	test   %eax,%eax
80104f89:	78 15                	js     80104fa0 <sys_fstat+0x40>
  return filestat(f, st);
80104f8b:	83 ec 08             	sub    $0x8,%esp
80104f8e:	ff 75 f4             	pushl  -0xc(%ebp)
80104f91:	ff 75 f0             	pushl  -0x10(%ebp)
80104f94:	e8 97 c2 ff ff       	call   80101230 <filestat>
80104f99:	83 c4 10             	add    $0x10,%esp
}
80104f9c:	c9                   	leave  
80104f9d:	c3                   	ret    
80104f9e:	66 90                	xchg   %ax,%ax
    return -1;
80104fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fa5:	c9                   	leave  
80104fa6:	c3                   	ret    
80104fa7:	89 f6                	mov    %esi,%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fb0 <sys_link>:
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	57                   	push   %edi
80104fb4:	56                   	push   %esi
80104fb5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fb6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104fb9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fbc:	50                   	push   %eax
80104fbd:	6a 00                	push   $0x0
80104fbf:	e8 6c fb ff ff       	call   80104b30 <argstr>
80104fc4:	83 c4 10             	add    $0x10,%esp
80104fc7:	85 c0                	test   %eax,%eax
80104fc9:	0f 88 fb 00 00 00    	js     801050ca <sys_link+0x11a>
80104fcf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104fd2:	83 ec 08             	sub    $0x8,%esp
80104fd5:	50                   	push   %eax
80104fd6:	6a 01                	push   $0x1
80104fd8:	e8 53 fb ff ff       	call   80104b30 <argstr>
80104fdd:	83 c4 10             	add    $0x10,%esp
80104fe0:	85 c0                	test   %eax,%eax
80104fe2:	0f 88 e2 00 00 00    	js     801050ca <sys_link+0x11a>
  begin_op();
80104fe8:	e8 e3 de ff ff       	call   80102ed0 <begin_op>
  if((ip = namei(old)) == 0){
80104fed:	83 ec 0c             	sub    $0xc,%esp
80104ff0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104ff3:	e8 18 d2 ff ff       	call   80102210 <namei>
80104ff8:	83 c4 10             	add    $0x10,%esp
80104ffb:	85 c0                	test   %eax,%eax
80104ffd:	89 c3                	mov    %eax,%ebx
80104fff:	0f 84 ea 00 00 00    	je     801050ef <sys_link+0x13f>
  ilock(ip);
80105005:	83 ec 0c             	sub    $0xc,%esp
80105008:	50                   	push   %eax
80105009:	e8 a2 c9 ff ff       	call   801019b0 <ilock>
  if(ip->type == T_DIR){
8010500e:	83 c4 10             	add    $0x10,%esp
80105011:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105016:	0f 84 bb 00 00 00    	je     801050d7 <sys_link+0x127>
  ip->nlink++;
8010501c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105021:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105024:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105027:	53                   	push   %ebx
80105028:	e8 d3 c8 ff ff       	call   80101900 <iupdate>
  iunlock(ip);
8010502d:	89 1c 24             	mov    %ebx,(%esp)
80105030:	e8 5b ca ff ff       	call   80101a90 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105035:	58                   	pop    %eax
80105036:	5a                   	pop    %edx
80105037:	57                   	push   %edi
80105038:	ff 75 d0             	pushl  -0x30(%ebp)
8010503b:	e8 f0 d1 ff ff       	call   80102230 <nameiparent>
80105040:	83 c4 10             	add    $0x10,%esp
80105043:	85 c0                	test   %eax,%eax
80105045:	89 c6                	mov    %eax,%esi
80105047:	74 5b                	je     801050a4 <sys_link+0xf4>
  ilock(dp);
80105049:	83 ec 0c             	sub    $0xc,%esp
8010504c:	50                   	push   %eax
8010504d:	e8 5e c9 ff ff       	call   801019b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105052:	83 c4 10             	add    $0x10,%esp
80105055:	8b 03                	mov    (%ebx),%eax
80105057:	39 06                	cmp    %eax,(%esi)
80105059:	75 3d                	jne    80105098 <sys_link+0xe8>
8010505b:	83 ec 04             	sub    $0x4,%esp
8010505e:	ff 73 04             	pushl  0x4(%ebx)
80105061:	57                   	push   %edi
80105062:	56                   	push   %esi
80105063:	e8 e8 d0 ff ff       	call   80102150 <dirlink>
80105068:	83 c4 10             	add    $0x10,%esp
8010506b:	85 c0                	test   %eax,%eax
8010506d:	78 29                	js     80105098 <sys_link+0xe8>
  iunlockput(dp);
8010506f:	83 ec 0c             	sub    $0xc,%esp
80105072:	56                   	push   %esi
80105073:	e8 c8 cb ff ff       	call   80101c40 <iunlockput>
  iput(ip);
80105078:	89 1c 24             	mov    %ebx,(%esp)
8010507b:	e8 60 ca ff ff       	call   80101ae0 <iput>
  end_op();
80105080:	e8 bb de ff ff       	call   80102f40 <end_op>
  return 0;
80105085:	83 c4 10             	add    $0x10,%esp
80105088:	31 c0                	xor    %eax,%eax
}
8010508a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010508d:	5b                   	pop    %ebx
8010508e:	5e                   	pop    %esi
8010508f:	5f                   	pop    %edi
80105090:	5d                   	pop    %ebp
80105091:	c3                   	ret    
80105092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105098:	83 ec 0c             	sub    $0xc,%esp
8010509b:	56                   	push   %esi
8010509c:	e8 9f cb ff ff       	call   80101c40 <iunlockput>
    goto bad;
801050a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801050a4:	83 ec 0c             	sub    $0xc,%esp
801050a7:	53                   	push   %ebx
801050a8:	e8 03 c9 ff ff       	call   801019b0 <ilock>
  ip->nlink--;
801050ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050b2:	89 1c 24             	mov    %ebx,(%esp)
801050b5:	e8 46 c8 ff ff       	call   80101900 <iupdate>
  iunlockput(ip);
801050ba:	89 1c 24             	mov    %ebx,(%esp)
801050bd:	e8 7e cb ff ff       	call   80101c40 <iunlockput>
  end_op();
801050c2:	e8 79 de ff ff       	call   80102f40 <end_op>
  return -1;
801050c7:	83 c4 10             	add    $0x10,%esp
}
801050ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801050cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050d2:	5b                   	pop    %ebx
801050d3:	5e                   	pop    %esi
801050d4:	5f                   	pop    %edi
801050d5:	5d                   	pop    %ebp
801050d6:	c3                   	ret    
    iunlockput(ip);
801050d7:	83 ec 0c             	sub    $0xc,%esp
801050da:	53                   	push   %ebx
801050db:	e8 60 cb ff ff       	call   80101c40 <iunlockput>
    end_op();
801050e0:	e8 5b de ff ff       	call   80102f40 <end_op>
    return -1;
801050e5:	83 c4 10             	add    $0x10,%esp
801050e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ed:	eb 9b                	jmp    8010508a <sys_link+0xda>
    end_op();
801050ef:	e8 4c de ff ff       	call   80102f40 <end_op>
    return -1;
801050f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f9:	eb 8f                	jmp    8010508a <sys_link+0xda>
801050fb:	90                   	nop
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105100 <sys_unlink>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	57                   	push   %edi
80105104:	56                   	push   %esi
80105105:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105106:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105109:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010510c:	50                   	push   %eax
8010510d:	6a 00                	push   $0x0
8010510f:	e8 1c fa ff ff       	call   80104b30 <argstr>
80105114:	83 c4 10             	add    $0x10,%esp
80105117:	85 c0                	test   %eax,%eax
80105119:	0f 88 77 01 00 00    	js     80105296 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010511f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105122:	e8 a9 dd ff ff       	call   80102ed0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105127:	83 ec 08             	sub    $0x8,%esp
8010512a:	53                   	push   %ebx
8010512b:	ff 75 c0             	pushl  -0x40(%ebp)
8010512e:	e8 fd d0 ff ff       	call   80102230 <nameiparent>
80105133:	83 c4 10             	add    $0x10,%esp
80105136:	85 c0                	test   %eax,%eax
80105138:	89 c6                	mov    %eax,%esi
8010513a:	0f 84 60 01 00 00    	je     801052a0 <sys_unlink+0x1a0>
  ilock(dp);
80105140:	83 ec 0c             	sub    $0xc,%esp
80105143:	50                   	push   %eax
80105144:	e8 67 c8 ff ff       	call   801019b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105149:	58                   	pop    %eax
8010514a:	5a                   	pop    %edx
8010514b:	68 34 79 10 80       	push   $0x80107934
80105150:	53                   	push   %ebx
80105151:	e8 6a cd ff ff       	call   80101ec0 <namecmp>
80105156:	83 c4 10             	add    $0x10,%esp
80105159:	85 c0                	test   %eax,%eax
8010515b:	0f 84 03 01 00 00    	je     80105264 <sys_unlink+0x164>
80105161:	83 ec 08             	sub    $0x8,%esp
80105164:	68 33 79 10 80       	push   $0x80107933
80105169:	53                   	push   %ebx
8010516a:	e8 51 cd ff ff       	call   80101ec0 <namecmp>
8010516f:	83 c4 10             	add    $0x10,%esp
80105172:	85 c0                	test   %eax,%eax
80105174:	0f 84 ea 00 00 00    	je     80105264 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010517a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010517d:	83 ec 04             	sub    $0x4,%esp
80105180:	50                   	push   %eax
80105181:	53                   	push   %ebx
80105182:	56                   	push   %esi
80105183:	e8 58 cd ff ff       	call   80101ee0 <dirlookup>
80105188:	83 c4 10             	add    $0x10,%esp
8010518b:	85 c0                	test   %eax,%eax
8010518d:	89 c3                	mov    %eax,%ebx
8010518f:	0f 84 cf 00 00 00    	je     80105264 <sys_unlink+0x164>
  ilock(ip);
80105195:	83 ec 0c             	sub    $0xc,%esp
80105198:	50                   	push   %eax
80105199:	e8 12 c8 ff ff       	call   801019b0 <ilock>
  if(ip->nlink < 1)
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801051a6:	0f 8e 10 01 00 00    	jle    801052bc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801051ac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051b1:	74 6d                	je     80105220 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801051b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801051b6:	83 ec 04             	sub    $0x4,%esp
801051b9:	6a 10                	push   $0x10
801051bb:	6a 00                	push   $0x0
801051bd:	50                   	push   %eax
801051be:	e8 bd f5 ff ff       	call   80104780 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051c3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801051c6:	6a 10                	push   $0x10
801051c8:	ff 75 c4             	pushl  -0x3c(%ebp)
801051cb:	50                   	push   %eax
801051cc:	56                   	push   %esi
801051cd:	e8 be cb ff ff       	call   80101d90 <writei>
801051d2:	83 c4 20             	add    $0x20,%esp
801051d5:	83 f8 10             	cmp    $0x10,%eax
801051d8:	0f 85 eb 00 00 00    	jne    801052c9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801051de:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051e3:	0f 84 97 00 00 00    	je     80105280 <sys_unlink+0x180>
  iunlockput(dp);
801051e9:	83 ec 0c             	sub    $0xc,%esp
801051ec:	56                   	push   %esi
801051ed:	e8 4e ca ff ff       	call   80101c40 <iunlockput>
  ip->nlink--;
801051f2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051f7:	89 1c 24             	mov    %ebx,(%esp)
801051fa:	e8 01 c7 ff ff       	call   80101900 <iupdate>
  iunlockput(ip);
801051ff:	89 1c 24             	mov    %ebx,(%esp)
80105202:	e8 39 ca ff ff       	call   80101c40 <iunlockput>
  end_op();
80105207:	e8 34 dd ff ff       	call   80102f40 <end_op>
  return 0;
8010520c:	83 c4 10             	add    $0x10,%esp
8010520f:	31 c0                	xor    %eax,%eax
}
80105211:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105214:	5b                   	pop    %ebx
80105215:	5e                   	pop    %esi
80105216:	5f                   	pop    %edi
80105217:	5d                   	pop    %ebp
80105218:	c3                   	ret    
80105219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105220:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105224:	76 8d                	jbe    801051b3 <sys_unlink+0xb3>
80105226:	bf 20 00 00 00       	mov    $0x20,%edi
8010522b:	eb 0f                	jmp    8010523c <sys_unlink+0x13c>
8010522d:	8d 76 00             	lea    0x0(%esi),%esi
80105230:	83 c7 10             	add    $0x10,%edi
80105233:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105236:	0f 83 77 ff ff ff    	jae    801051b3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010523c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010523f:	6a 10                	push   $0x10
80105241:	57                   	push   %edi
80105242:	50                   	push   %eax
80105243:	53                   	push   %ebx
80105244:	e8 47 ca ff ff       	call   80101c90 <readi>
80105249:	83 c4 10             	add    $0x10,%esp
8010524c:	83 f8 10             	cmp    $0x10,%eax
8010524f:	75 5e                	jne    801052af <sys_unlink+0x1af>
    if(de.inum != 0)
80105251:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105256:	74 d8                	je     80105230 <sys_unlink+0x130>
    iunlockput(ip);
80105258:	83 ec 0c             	sub    $0xc,%esp
8010525b:	53                   	push   %ebx
8010525c:	e8 df c9 ff ff       	call   80101c40 <iunlockput>
    goto bad;
80105261:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105264:	83 ec 0c             	sub    $0xc,%esp
80105267:	56                   	push   %esi
80105268:	e8 d3 c9 ff ff       	call   80101c40 <iunlockput>
  end_op();
8010526d:	e8 ce dc ff ff       	call   80102f40 <end_op>
  return -1;
80105272:	83 c4 10             	add    $0x10,%esp
80105275:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527a:	eb 95                	jmp    80105211 <sys_unlink+0x111>
8010527c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105280:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105285:	83 ec 0c             	sub    $0xc,%esp
80105288:	56                   	push   %esi
80105289:	e8 72 c6 ff ff       	call   80101900 <iupdate>
8010528e:	83 c4 10             	add    $0x10,%esp
80105291:	e9 53 ff ff ff       	jmp    801051e9 <sys_unlink+0xe9>
    return -1;
80105296:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010529b:	e9 71 ff ff ff       	jmp    80105211 <sys_unlink+0x111>
    end_op();
801052a0:	e8 9b dc ff ff       	call   80102f40 <end_op>
    return -1;
801052a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052aa:	e9 62 ff ff ff       	jmp    80105211 <sys_unlink+0x111>
      panic("isdirempty: readi");
801052af:	83 ec 0c             	sub    $0xc,%esp
801052b2:	68 58 79 10 80       	push   $0x80107958
801052b7:	e8 d4 b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801052bc:	83 ec 0c             	sub    $0xc,%esp
801052bf:	68 46 79 10 80       	push   $0x80107946
801052c4:	e8 c7 b0 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801052c9:	83 ec 0c             	sub    $0xc,%esp
801052cc:	68 6a 79 10 80       	push   $0x8010796a
801052d1:	e8 ba b0 ff ff       	call   80100390 <panic>
801052d6:	8d 76 00             	lea    0x0(%esi),%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <sys_open>:

int
sys_open(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	57                   	push   %edi
801052e4:	56                   	push   %esi
801052e5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801052e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052ec:	50                   	push   %eax
801052ed:	6a 00                	push   $0x0
801052ef:	e8 3c f8 ff ff       	call   80104b30 <argstr>
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	85 c0                	test   %eax,%eax
801052f9:	0f 88 1d 01 00 00    	js     8010541c <sys_open+0x13c>
801052ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105302:	83 ec 08             	sub    $0x8,%esp
80105305:	50                   	push   %eax
80105306:	6a 01                	push   $0x1
80105308:	e8 73 f7 ff ff       	call   80104a80 <argint>
8010530d:	83 c4 10             	add    $0x10,%esp
80105310:	85 c0                	test   %eax,%eax
80105312:	0f 88 04 01 00 00    	js     8010541c <sys_open+0x13c>
    return -1;

  begin_op();
80105318:	e8 b3 db ff ff       	call   80102ed0 <begin_op>

  if(omode & O_CREATE){
8010531d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105321:	0f 85 a9 00 00 00    	jne    801053d0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105327:	83 ec 0c             	sub    $0xc,%esp
8010532a:	ff 75 e0             	pushl  -0x20(%ebp)
8010532d:	e8 de ce ff ff       	call   80102210 <namei>
80105332:	83 c4 10             	add    $0x10,%esp
80105335:	85 c0                	test   %eax,%eax
80105337:	89 c6                	mov    %eax,%esi
80105339:	0f 84 b2 00 00 00    	je     801053f1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010533f:	83 ec 0c             	sub    $0xc,%esp
80105342:	50                   	push   %eax
80105343:	e8 68 c6 ff ff       	call   801019b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105348:	83 c4 10             	add    $0x10,%esp
8010534b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105350:	0f 84 aa 00 00 00    	je     80105400 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105356:	e8 45 bd ff ff       	call   801010a0 <filealloc>
8010535b:	85 c0                	test   %eax,%eax
8010535d:	89 c7                	mov    %eax,%edi
8010535f:	0f 84 a6 00 00 00    	je     8010540b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105365:	e8 a6 e7 ff ff       	call   80103b10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010536a:	31 db                	xor    %ebx,%ebx
8010536c:	eb 0e                	jmp    8010537c <sys_open+0x9c>
8010536e:	66 90                	xchg   %ax,%ax
80105370:	83 c3 01             	add    $0x1,%ebx
80105373:	83 fb 10             	cmp    $0x10,%ebx
80105376:	0f 84 ac 00 00 00    	je     80105428 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010537c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105380:	85 d2                	test   %edx,%edx
80105382:	75 ec                	jne    80105370 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105384:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105387:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010538b:	56                   	push   %esi
8010538c:	e8 ff c6 ff ff       	call   80101a90 <iunlock>
  end_op();
80105391:	e8 aa db ff ff       	call   80102f40 <end_op>

  f->type = FD_INODE;
80105396:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010539c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010539f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801053a2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801053a5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801053ac:	89 d0                	mov    %edx,%eax
801053ae:	f7 d0                	not    %eax
801053b0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053b3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801053b6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053b9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801053bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053c0:	89 d8                	mov    %ebx,%eax
801053c2:	5b                   	pop    %ebx
801053c3:	5e                   	pop    %esi
801053c4:	5f                   	pop    %edi
801053c5:	5d                   	pop    %ebp
801053c6:	c3                   	ret    
801053c7:	89 f6                	mov    %esi,%esi
801053c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801053d0:	83 ec 0c             	sub    $0xc,%esp
801053d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053d6:	31 c9                	xor    %ecx,%ecx
801053d8:	6a 00                	push   $0x0
801053da:	ba 02 00 00 00       	mov    $0x2,%edx
801053df:	e8 ec f7 ff ff       	call   80104bd0 <create>
    if(ip == 0){
801053e4:	83 c4 10             	add    $0x10,%esp
801053e7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801053e9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801053eb:	0f 85 65 ff ff ff    	jne    80105356 <sys_open+0x76>
      end_op();
801053f1:	e8 4a db ff ff       	call   80102f40 <end_op>
      return -1;
801053f6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053fb:	eb c0                	jmp    801053bd <sys_open+0xdd>
801053fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105400:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105403:	85 c9                	test   %ecx,%ecx
80105405:	0f 84 4b ff ff ff    	je     80105356 <sys_open+0x76>
    iunlockput(ip);
8010540b:	83 ec 0c             	sub    $0xc,%esp
8010540e:	56                   	push   %esi
8010540f:	e8 2c c8 ff ff       	call   80101c40 <iunlockput>
    end_op();
80105414:	e8 27 db ff ff       	call   80102f40 <end_op>
    return -1;
80105419:	83 c4 10             	add    $0x10,%esp
8010541c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105421:	eb 9a                	jmp    801053bd <sys_open+0xdd>
80105423:	90                   	nop
80105424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105428:	83 ec 0c             	sub    $0xc,%esp
8010542b:	57                   	push   %edi
8010542c:	e8 2f bd ff ff       	call   80101160 <fileclose>
80105431:	83 c4 10             	add    $0x10,%esp
80105434:	eb d5                	jmp    8010540b <sys_open+0x12b>
80105436:	8d 76 00             	lea    0x0(%esi),%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <sys_mkdir>:

int
sys_mkdir(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105446:	e8 85 da ff ff       	call   80102ed0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010544b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544e:	83 ec 08             	sub    $0x8,%esp
80105451:	50                   	push   %eax
80105452:	6a 00                	push   $0x0
80105454:	e8 d7 f6 ff ff       	call   80104b30 <argstr>
80105459:	83 c4 10             	add    $0x10,%esp
8010545c:	85 c0                	test   %eax,%eax
8010545e:	78 30                	js     80105490 <sys_mkdir+0x50>
80105460:	83 ec 0c             	sub    $0xc,%esp
80105463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105466:	31 c9                	xor    %ecx,%ecx
80105468:	6a 00                	push   $0x0
8010546a:	ba 01 00 00 00       	mov    $0x1,%edx
8010546f:	e8 5c f7 ff ff       	call   80104bd0 <create>
80105474:	83 c4 10             	add    $0x10,%esp
80105477:	85 c0                	test   %eax,%eax
80105479:	74 15                	je     80105490 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010547b:	83 ec 0c             	sub    $0xc,%esp
8010547e:	50                   	push   %eax
8010547f:	e8 bc c7 ff ff       	call   80101c40 <iunlockput>
  end_op();
80105484:	e8 b7 da ff ff       	call   80102f40 <end_op>
  return 0;
80105489:	83 c4 10             	add    $0x10,%esp
8010548c:	31 c0                	xor    %eax,%eax
}
8010548e:	c9                   	leave  
8010548f:	c3                   	ret    
    end_op();
80105490:	e8 ab da ff ff       	call   80102f40 <end_op>
    return -1;
80105495:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010549a:	c9                   	leave  
8010549b:	c3                   	ret    
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054a0 <sys_mknod>:

int
sys_mknod(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801054a6:	e8 25 da ff ff       	call   80102ed0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801054ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054ae:	83 ec 08             	sub    $0x8,%esp
801054b1:	50                   	push   %eax
801054b2:	6a 00                	push   $0x0
801054b4:	e8 77 f6 ff ff       	call   80104b30 <argstr>
801054b9:	83 c4 10             	add    $0x10,%esp
801054bc:	85 c0                	test   %eax,%eax
801054be:	78 60                	js     80105520 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801054c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054c3:	83 ec 08             	sub    $0x8,%esp
801054c6:	50                   	push   %eax
801054c7:	6a 01                	push   $0x1
801054c9:	e8 b2 f5 ff ff       	call   80104a80 <argint>
  if((argstr(0, &path)) < 0 ||
801054ce:	83 c4 10             	add    $0x10,%esp
801054d1:	85 c0                	test   %eax,%eax
801054d3:	78 4b                	js     80105520 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801054d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054d8:	83 ec 08             	sub    $0x8,%esp
801054db:	50                   	push   %eax
801054dc:	6a 02                	push   $0x2
801054de:	e8 9d f5 ff ff       	call   80104a80 <argint>
     argint(1, &major) < 0 ||
801054e3:	83 c4 10             	add    $0x10,%esp
801054e6:	85 c0                	test   %eax,%eax
801054e8:	78 36                	js     80105520 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801054ee:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801054f1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801054f5:	ba 03 00 00 00       	mov    $0x3,%edx
801054fa:	50                   	push   %eax
801054fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054fe:	e8 cd f6 ff ff       	call   80104bd0 <create>
80105503:	83 c4 10             	add    $0x10,%esp
80105506:	85 c0                	test   %eax,%eax
80105508:	74 16                	je     80105520 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010550a:	83 ec 0c             	sub    $0xc,%esp
8010550d:	50                   	push   %eax
8010550e:	e8 2d c7 ff ff       	call   80101c40 <iunlockput>
  end_op();
80105513:	e8 28 da ff ff       	call   80102f40 <end_op>
  return 0;
80105518:	83 c4 10             	add    $0x10,%esp
8010551b:	31 c0                	xor    %eax,%eax
}
8010551d:	c9                   	leave  
8010551e:	c3                   	ret    
8010551f:	90                   	nop
    end_op();
80105520:	e8 1b da ff ff       	call   80102f40 <end_op>
    return -1;
80105525:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010552a:	c9                   	leave  
8010552b:	c3                   	ret    
8010552c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105530 <sys_chdir>:

int
sys_chdir(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	56                   	push   %esi
80105534:	53                   	push   %ebx
80105535:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105538:	e8 d3 e5 ff ff       	call   80103b10 <myproc>
8010553d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010553f:	e8 8c d9 ff ff       	call   80102ed0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105544:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105547:	83 ec 08             	sub    $0x8,%esp
8010554a:	50                   	push   %eax
8010554b:	6a 00                	push   $0x0
8010554d:	e8 de f5 ff ff       	call   80104b30 <argstr>
80105552:	83 c4 10             	add    $0x10,%esp
80105555:	85 c0                	test   %eax,%eax
80105557:	78 77                	js     801055d0 <sys_chdir+0xa0>
80105559:	83 ec 0c             	sub    $0xc,%esp
8010555c:	ff 75 f4             	pushl  -0xc(%ebp)
8010555f:	e8 ac cc ff ff       	call   80102210 <namei>
80105564:	83 c4 10             	add    $0x10,%esp
80105567:	85 c0                	test   %eax,%eax
80105569:	89 c3                	mov    %eax,%ebx
8010556b:	74 63                	je     801055d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010556d:	83 ec 0c             	sub    $0xc,%esp
80105570:	50                   	push   %eax
80105571:	e8 3a c4 ff ff       	call   801019b0 <ilock>
  if(ip->type != T_DIR){
80105576:	83 c4 10             	add    $0x10,%esp
80105579:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010557e:	75 30                	jne    801055b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	53                   	push   %ebx
80105584:	e8 07 c5 ff ff       	call   80101a90 <iunlock>
  iput(curproc->cwd);
80105589:	58                   	pop    %eax
8010558a:	ff 76 68             	pushl  0x68(%esi)
8010558d:	e8 4e c5 ff ff       	call   80101ae0 <iput>
  end_op();
80105592:	e8 a9 d9 ff ff       	call   80102f40 <end_op>
  curproc->cwd = ip;
80105597:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010559a:	83 c4 10             	add    $0x10,%esp
8010559d:	31 c0                	xor    %eax,%eax
}
8010559f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055a2:	5b                   	pop    %ebx
801055a3:	5e                   	pop    %esi
801055a4:	5d                   	pop    %ebp
801055a5:	c3                   	ret    
801055a6:	8d 76 00             	lea    0x0(%esi),%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801055b0:	83 ec 0c             	sub    $0xc,%esp
801055b3:	53                   	push   %ebx
801055b4:	e8 87 c6 ff ff       	call   80101c40 <iunlockput>
    end_op();
801055b9:	e8 82 d9 ff ff       	call   80102f40 <end_op>
    return -1;
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055c6:	eb d7                	jmp    8010559f <sys_chdir+0x6f>
801055c8:	90                   	nop
801055c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801055d0:	e8 6b d9 ff ff       	call   80102f40 <end_op>
    return -1;
801055d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055da:	eb c3                	jmp    8010559f <sys_chdir+0x6f>
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055e0 <sys_exec>:

int
sys_exec(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	57                   	push   %edi
801055e4:	56                   	push   %esi
801055e5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055e6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801055ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055f2:	50                   	push   %eax
801055f3:	6a 00                	push   $0x0
801055f5:	e8 36 f5 ff ff       	call   80104b30 <argstr>
801055fa:	83 c4 10             	add    $0x10,%esp
801055fd:	85 c0                	test   %eax,%eax
801055ff:	0f 88 87 00 00 00    	js     8010568c <sys_exec+0xac>
80105605:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010560b:	83 ec 08             	sub    $0x8,%esp
8010560e:	50                   	push   %eax
8010560f:	6a 01                	push   $0x1
80105611:	e8 6a f4 ff ff       	call   80104a80 <argint>
80105616:	83 c4 10             	add    $0x10,%esp
80105619:	85 c0                	test   %eax,%eax
8010561b:	78 6f                	js     8010568c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010561d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105623:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105626:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105628:	68 80 00 00 00       	push   $0x80
8010562d:	6a 00                	push   $0x0
8010562f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105635:	50                   	push   %eax
80105636:	e8 45 f1 ff ff       	call   80104780 <memset>
8010563b:	83 c4 10             	add    $0x10,%esp
8010563e:	eb 2c                	jmp    8010566c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105640:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105646:	85 c0                	test   %eax,%eax
80105648:	74 56                	je     801056a0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010564a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105650:	83 ec 08             	sub    $0x8,%esp
80105653:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105656:	52                   	push   %edx
80105657:	50                   	push   %eax
80105658:	e8 b3 f3 ff ff       	call   80104a10 <fetchstr>
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	85 c0                	test   %eax,%eax
80105662:	78 28                	js     8010568c <sys_exec+0xac>
  for(i=0;; i++){
80105664:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105667:	83 fb 20             	cmp    $0x20,%ebx
8010566a:	74 20                	je     8010568c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010566c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105672:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105679:	83 ec 08             	sub    $0x8,%esp
8010567c:	57                   	push   %edi
8010567d:	01 f0                	add    %esi,%eax
8010567f:	50                   	push   %eax
80105680:	e8 4b f3 ff ff       	call   801049d0 <fetchint>
80105685:	83 c4 10             	add    $0x10,%esp
80105688:	85 c0                	test   %eax,%eax
8010568a:	79 b4                	jns    80105640 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010568c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010568f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105694:	5b                   	pop    %ebx
80105695:	5e                   	pop    %esi
80105696:	5f                   	pop    %edi
80105697:	5d                   	pop    %ebp
80105698:	c3                   	ret    
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801056a0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801056a6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801056a9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801056b0:	00 00 00 00 
  return exec(path, argv);
801056b4:	50                   	push   %eax
801056b5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801056bb:	e8 70 b6 ff ff       	call   80100d30 <exec>
801056c0:	83 c4 10             	add    $0x10,%esp
}
801056c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056c6:	5b                   	pop    %ebx
801056c7:	5e                   	pop    %esi
801056c8:	5f                   	pop    %edi
801056c9:	5d                   	pop    %ebp
801056ca:	c3                   	ret    
801056cb:	90                   	nop
801056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056d0 <sys_pipe>:

int
sys_pipe(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	57                   	push   %edi
801056d4:	56                   	push   %esi
801056d5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056d6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801056d9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056dc:	6a 08                	push   $0x8
801056de:	50                   	push   %eax
801056df:	6a 00                	push   $0x0
801056e1:	e8 ea f3 ff ff       	call   80104ad0 <argptr>
801056e6:	83 c4 10             	add    $0x10,%esp
801056e9:	85 c0                	test   %eax,%eax
801056eb:	0f 88 ae 00 00 00    	js     8010579f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801056f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056f4:	83 ec 08             	sub    $0x8,%esp
801056f7:	50                   	push   %eax
801056f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801056fb:	50                   	push   %eax
801056fc:	e8 6f de ff ff       	call   80103570 <pipealloc>
80105701:	83 c4 10             	add    $0x10,%esp
80105704:	85 c0                	test   %eax,%eax
80105706:	0f 88 93 00 00 00    	js     8010579f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010570c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010570f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105711:	e8 fa e3 ff ff       	call   80103b10 <myproc>
80105716:	eb 10                	jmp    80105728 <sys_pipe+0x58>
80105718:	90                   	nop
80105719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105720:	83 c3 01             	add    $0x1,%ebx
80105723:	83 fb 10             	cmp    $0x10,%ebx
80105726:	74 60                	je     80105788 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105728:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010572c:	85 f6                	test   %esi,%esi
8010572e:	75 f0                	jne    80105720 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105730:	8d 73 08             	lea    0x8(%ebx),%esi
80105733:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105737:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010573a:	e8 d1 e3 ff ff       	call   80103b10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010573f:	31 d2                	xor    %edx,%edx
80105741:	eb 0d                	jmp    80105750 <sys_pipe+0x80>
80105743:	90                   	nop
80105744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105748:	83 c2 01             	add    $0x1,%edx
8010574b:	83 fa 10             	cmp    $0x10,%edx
8010574e:	74 28                	je     80105778 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105750:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105754:	85 c9                	test   %ecx,%ecx
80105756:	75 f0                	jne    80105748 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105758:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010575c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010575f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105761:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105764:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105767:	31 c0                	xor    %eax,%eax
}
80105769:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010576c:	5b                   	pop    %ebx
8010576d:	5e                   	pop    %esi
8010576e:	5f                   	pop    %edi
8010576f:	5d                   	pop    %ebp
80105770:	c3                   	ret    
80105771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105778:	e8 93 e3 ff ff       	call   80103b10 <myproc>
8010577d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105784:	00 
80105785:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105788:	83 ec 0c             	sub    $0xc,%esp
8010578b:	ff 75 e0             	pushl  -0x20(%ebp)
8010578e:	e8 cd b9 ff ff       	call   80101160 <fileclose>
    fileclose(wf);
80105793:	58                   	pop    %eax
80105794:	ff 75 e4             	pushl  -0x1c(%ebp)
80105797:	e8 c4 b9 ff ff       	call   80101160 <fileclose>
    return -1;
8010579c:	83 c4 10             	add    $0x10,%esp
8010579f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a4:	eb c3                	jmp    80105769 <sys_pipe+0x99>
801057a6:	66 90                	xchg   %ax,%ax
801057a8:	66 90                	xchg   %ax,%ax
801057aa:	66 90                	xchg   %ax,%ax
801057ac:	66 90                	xchg   %ax,%ax
801057ae:	66 90                	xchg   %ax,%ax

801057b0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801057b3:	5d                   	pop    %ebp
  return fork();
801057b4:	e9 f7 e4 ff ff       	jmp    80103cb0 <fork>
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_exit>:

int
sys_exit(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801057c6:	e8 65 e7 ff ff       	call   80103f30 <exit>
  return 0;  // not reached
}
801057cb:	31 c0                	xor    %eax,%eax
801057cd:	c9                   	leave  
801057ce:	c3                   	ret    
801057cf:	90                   	nop

801057d0 <sys_wait>:

int
sys_wait(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801057d3:	5d                   	pop    %ebp
  return wait();
801057d4:	e9 97 e9 ff ff       	jmp    80104170 <wait>
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057e0 <sys_kill>:

int
sys_kill(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801057e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057e9:	50                   	push   %eax
801057ea:	6a 00                	push   $0x0
801057ec:	e8 8f f2 ff ff       	call   80104a80 <argint>
801057f1:	83 c4 10             	add    $0x10,%esp
801057f4:	85 c0                	test   %eax,%eax
801057f6:	78 18                	js     80105810 <sys_kill+0x30>
    return -1;
  return kill(pid);
801057f8:	83 ec 0c             	sub    $0xc,%esp
801057fb:	ff 75 f4             	pushl  -0xc(%ebp)
801057fe:	e8 bd ea ff ff       	call   801042c0 <kill>
80105803:	83 c4 10             	add    $0x10,%esp
}
80105806:	c9                   	leave  
80105807:	c3                   	ret    
80105808:	90                   	nop
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105815:	c9                   	leave  
80105816:	c3                   	ret    
80105817:	89 f6                	mov    %esi,%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105820 <sys_getpid>:

int
sys_getpid(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105826:	e8 e5 e2 ff ff       	call   80103b10 <myproc>
8010582b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010582e:	c9                   	leave  
8010582f:	c3                   	ret    

80105830 <sys_sbrk>:

int
sys_sbrk(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105834:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105837:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010583a:	50                   	push   %eax
8010583b:	6a 00                	push   $0x0
8010583d:	e8 3e f2 ff ff       	call   80104a80 <argint>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	85 c0                	test   %eax,%eax
80105847:	78 27                	js     80105870 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105849:	e8 c2 e2 ff ff       	call   80103b10 <myproc>
  if(growproc(n) < 0)
8010584e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105851:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105853:	ff 75 f4             	pushl  -0xc(%ebp)
80105856:	e8 d5 e3 ff ff       	call   80103c30 <growproc>
8010585b:	83 c4 10             	add    $0x10,%esp
8010585e:	85 c0                	test   %eax,%eax
80105860:	78 0e                	js     80105870 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105862:	89 d8                	mov    %ebx,%eax
80105864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105867:	c9                   	leave  
80105868:	c3                   	ret    
80105869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105870:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105875:	eb eb                	jmp    80105862 <sys_sbrk+0x32>
80105877:	89 f6                	mov    %esi,%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105880 <sys_sleep>:

int
sys_sleep(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105884:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105887:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010588a:	50                   	push   %eax
8010588b:	6a 00                	push   $0x0
8010588d:	e8 ee f1 ff ff       	call   80104a80 <argint>
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	85 c0                	test   %eax,%eax
80105897:	0f 88 8a 00 00 00    	js     80105927 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010589d:	83 ec 0c             	sub    $0xc,%esp
801058a0:	68 20 4f 11 80       	push   $0x80114f20
801058a5:	e8 c6 ed ff ff       	call   80104670 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801058aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058ad:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801058b0:	8b 1d 60 57 11 80    	mov    0x80115760,%ebx
  while(ticks - ticks0 < n){
801058b6:	85 d2                	test   %edx,%edx
801058b8:	75 27                	jne    801058e1 <sys_sleep+0x61>
801058ba:	eb 54                	jmp    80105910 <sys_sleep+0x90>
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801058c0:	83 ec 08             	sub    $0x8,%esp
801058c3:	68 20 4f 11 80       	push   $0x80114f20
801058c8:	68 60 57 11 80       	push   $0x80115760
801058cd:	e8 de e7 ff ff       	call   801040b0 <sleep>
  while(ticks - ticks0 < n){
801058d2:	a1 60 57 11 80       	mov    0x80115760,%eax
801058d7:	83 c4 10             	add    $0x10,%esp
801058da:	29 d8                	sub    %ebx,%eax
801058dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801058df:	73 2f                	jae    80105910 <sys_sleep+0x90>
    if(myproc()->killed){
801058e1:	e8 2a e2 ff ff       	call   80103b10 <myproc>
801058e6:	8b 40 24             	mov    0x24(%eax),%eax
801058e9:	85 c0                	test   %eax,%eax
801058eb:	74 d3                	je     801058c0 <sys_sleep+0x40>
      release(&tickslock);
801058ed:	83 ec 0c             	sub    $0xc,%esp
801058f0:	68 20 4f 11 80       	push   $0x80114f20
801058f5:	e8 36 ee ff ff       	call   80104730 <release>
      return -1;
801058fa:	83 c4 10             	add    $0x10,%esp
801058fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105902:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105905:	c9                   	leave  
80105906:	c3                   	ret    
80105907:	89 f6                	mov    %esi,%esi
80105909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	68 20 4f 11 80       	push   $0x80114f20
80105918:	e8 13 ee ff ff       	call   80104730 <release>
  return 0;
8010591d:	83 c4 10             	add    $0x10,%esp
80105920:	31 c0                	xor    %eax,%eax
}
80105922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105925:	c9                   	leave  
80105926:	c3                   	ret    
    return -1;
80105927:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010592c:	eb f4                	jmp    80105922 <sys_sleep+0xa2>
8010592e:	66 90                	xchg   %ax,%ax

80105930 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	53                   	push   %ebx
80105934:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105937:	68 20 4f 11 80       	push   $0x80114f20
8010593c:	e8 2f ed ff ff       	call   80104670 <acquire>
  xticks = ticks;
80105941:	8b 1d 60 57 11 80    	mov    0x80115760,%ebx
  release(&tickslock);
80105947:	c7 04 24 20 4f 11 80 	movl   $0x80114f20,(%esp)
8010594e:	e8 dd ed ff ff       	call   80104730 <release>
  return xticks;
}
80105953:	89 d8                	mov    %ebx,%eax
80105955:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105958:	c9                   	leave  
80105959:	c3                   	ret    

8010595a <alltraps>:
8010595a:	1e                   	push   %ds
8010595b:	06                   	push   %es
8010595c:	0f a0                	push   %fs
8010595e:	0f a8                	push   %gs
80105960:	60                   	pusha  
80105961:	66 b8 10 00          	mov    $0x10,%ax
80105965:	8e d8                	mov    %eax,%ds
80105967:	8e c0                	mov    %eax,%es
80105969:	54                   	push   %esp
8010596a:	e8 c1 00 00 00       	call   80105a30 <trap>
8010596f:	83 c4 04             	add    $0x4,%esp

80105972 <trapret>:
80105972:	61                   	popa   
80105973:	0f a9                	pop    %gs
80105975:	0f a1                	pop    %fs
80105977:	07                   	pop    %es
80105978:	1f                   	pop    %ds
80105979:	83 c4 08             	add    $0x8,%esp
8010597c:	cf                   	iret   
8010597d:	66 90                	xchg   %ax,%ax
8010597f:	90                   	nop

80105980 <tvinit>:
80105980:	55                   	push   %ebp
80105981:	31 c0                	xor    %eax,%eax
80105983:	89 e5                	mov    %esp,%ebp
80105985:	83 ec 08             	sub    $0x8,%esp
80105988:	90                   	nop
80105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105990:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105997:	c7 04 c5 62 4f 11 80 	movl   $0x8e000008,-0x7feeb09e(,%eax,8)
8010599e:	08 00 00 8e 
801059a2:	66 89 14 c5 60 4f 11 	mov    %dx,-0x7feeb0a0(,%eax,8)
801059a9:	80 
801059aa:	c1 ea 10             	shr    $0x10,%edx
801059ad:	66 89 14 c5 66 4f 11 	mov    %dx,-0x7feeb09a(,%eax,8)
801059b4:	80 
801059b5:	83 c0 01             	add    $0x1,%eax
801059b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801059bd:	75 d1                	jne    80105990 <tvinit+0x10>
801059bf:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801059c4:	83 ec 08             	sub    $0x8,%esp
801059c7:	c7 05 62 51 11 80 08 	movl   $0xef000008,0x80115162
801059ce:	00 00 ef 
801059d1:	68 79 79 10 80       	push   $0x80107979
801059d6:	68 20 4f 11 80       	push   $0x80114f20
801059db:	66 a3 60 51 11 80    	mov    %ax,0x80115160
801059e1:	c1 e8 10             	shr    $0x10,%eax
801059e4:	66 a3 66 51 11 80    	mov    %ax,0x80115166
801059ea:	e8 41 eb ff ff       	call   80104530 <initlock>
801059ef:	83 c4 10             	add    $0x10,%esp
801059f2:	c9                   	leave  
801059f3:	c3                   	ret    
801059f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105a00 <idtinit>:
80105a00:	55                   	push   %ebp
80105a01:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105a06:	89 e5                	mov    %esp,%ebp
80105a08:	83 ec 10             	sub    $0x10,%esp
80105a0b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
80105a0f:	b8 60 4f 11 80       	mov    $0x80114f60,%eax
80105a14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80105a18:	c1 e8 10             	shr    $0x10,%eax
80105a1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
80105a1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a22:	0f 01 18             	lidtl  (%eax)
80105a25:	c9                   	leave  
80105a26:	c3                   	ret    
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a30 <trap>:
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	57                   	push   %edi
80105a34:	56                   	push   %esi
80105a35:	53                   	push   %ebx
80105a36:	83 ec 1c             	sub    $0x1c,%esp
80105a39:	8b 7d 08             	mov    0x8(%ebp),%edi
80105a3c:	8b 47 30             	mov    0x30(%edi),%eax
80105a3f:	83 f8 40             	cmp    $0x40,%eax
80105a42:	0f 84 f0 00 00 00    	je     80105b38 <trap+0x108>
80105a48:	83 e8 20             	sub    $0x20,%eax
80105a4b:	83 f8 1f             	cmp    $0x1f,%eax
80105a4e:	77 10                	ja     80105a60 <trap+0x30>
80105a50:	ff 24 85 20 7a 10 80 	jmp    *-0x7fef85e0(,%eax,4)
80105a57:	89 f6                	mov    %esi,%esi
80105a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105a60:	e8 ab e0 ff ff       	call   80103b10 <myproc>
80105a65:	85 c0                	test   %eax,%eax
80105a67:	8b 5f 38             	mov    0x38(%edi),%ebx
80105a6a:	0f 84 14 02 00 00    	je     80105c84 <trap+0x254>
80105a70:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105a74:	0f 84 0a 02 00 00    	je     80105c84 <trap+0x254>
80105a7a:	0f 20 d1             	mov    %cr2,%ecx
80105a7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105a80:	e8 6b e0 ff ff       	call   80103af0 <cpuid>
80105a85:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a88:	8b 47 34             	mov    0x34(%edi),%eax
80105a8b:	8b 77 30             	mov    0x30(%edi),%esi
80105a8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105a91:	e8 7a e0 ff ff       	call   80103b10 <myproc>
80105a96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a99:	e8 72 e0 ff ff       	call   80103b10 <myproc>
80105a9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105aa1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105aa4:	51                   	push   %ecx
80105aa5:	53                   	push   %ebx
80105aa6:	52                   	push   %edx
80105aa7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105aaa:	ff 75 e4             	pushl  -0x1c(%ebp)
80105aad:	56                   	push   %esi
80105aae:	83 c2 6c             	add    $0x6c,%edx
80105ab1:	52                   	push   %edx
80105ab2:	ff 70 10             	pushl  0x10(%eax)
80105ab5:	68 dc 79 10 80       	push   $0x801079dc
80105aba:	e8 a1 ab ff ff       	call   80100660 <cprintf>
80105abf:	83 c4 20             	add    $0x20,%esp
80105ac2:	e8 49 e0 ff ff       	call   80103b10 <myproc>
80105ac7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105ace:	e8 3d e0 ff ff       	call   80103b10 <myproc>
80105ad3:	85 c0                	test   %eax,%eax
80105ad5:	74 1d                	je     80105af4 <trap+0xc4>
80105ad7:	e8 34 e0 ff ff       	call   80103b10 <myproc>
80105adc:	8b 50 24             	mov    0x24(%eax),%edx
80105adf:	85 d2                	test   %edx,%edx
80105ae1:	74 11                	je     80105af4 <trap+0xc4>
80105ae3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ae7:	83 e0 03             	and    $0x3,%eax
80105aea:	66 83 f8 03          	cmp    $0x3,%ax
80105aee:	0f 84 4c 01 00 00    	je     80105c40 <trap+0x210>
80105af4:	e8 17 e0 ff ff       	call   80103b10 <myproc>
80105af9:	85 c0                	test   %eax,%eax
80105afb:	74 0b                	je     80105b08 <trap+0xd8>
80105afd:	e8 0e e0 ff ff       	call   80103b10 <myproc>
80105b02:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b06:	74 68                	je     80105b70 <trap+0x140>
80105b08:	e8 03 e0 ff ff       	call   80103b10 <myproc>
80105b0d:	85 c0                	test   %eax,%eax
80105b0f:	74 19                	je     80105b2a <trap+0xfa>
80105b11:	e8 fa df ff ff       	call   80103b10 <myproc>
80105b16:	8b 40 24             	mov    0x24(%eax),%eax
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	74 0d                	je     80105b2a <trap+0xfa>
80105b1d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105b21:	83 e0 03             	and    $0x3,%eax
80105b24:	66 83 f8 03          	cmp    $0x3,%ax
80105b28:	74 37                	je     80105b61 <trap+0x131>
80105b2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b2d:	5b                   	pop    %ebx
80105b2e:	5e                   	pop    %esi
80105b2f:	5f                   	pop    %edi
80105b30:	5d                   	pop    %ebp
80105b31:	c3                   	ret    
80105b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b38:	e8 d3 df ff ff       	call   80103b10 <myproc>
80105b3d:	8b 58 24             	mov    0x24(%eax),%ebx
80105b40:	85 db                	test   %ebx,%ebx
80105b42:	0f 85 e8 00 00 00    	jne    80105c30 <trap+0x200>
80105b48:	e8 c3 df ff ff       	call   80103b10 <myproc>
80105b4d:	89 78 18             	mov    %edi,0x18(%eax)
80105b50:	e8 1b f0 ff ff       	call   80104b70 <syscall>
80105b55:	e8 b6 df ff ff       	call   80103b10 <myproc>
80105b5a:	8b 48 24             	mov    0x24(%eax),%ecx
80105b5d:	85 c9                	test   %ecx,%ecx
80105b5f:	74 c9                	je     80105b2a <trap+0xfa>
80105b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b64:	5b                   	pop    %ebx
80105b65:	5e                   	pop    %esi
80105b66:	5f                   	pop    %edi
80105b67:	5d                   	pop    %ebp
80105b68:	e9 c3 e3 ff ff       	jmp    80103f30 <exit>
80105b6d:	8d 76 00             	lea    0x0(%esi),%esi
80105b70:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105b74:	75 92                	jne    80105b08 <trap+0xd8>
80105b76:	e8 e5 e4 ff ff       	call   80104060 <yield>
80105b7b:	eb 8b                	jmp    80105b08 <trap+0xd8>
80105b7d:	8d 76 00             	lea    0x0(%esi),%esi
80105b80:	e8 6b df ff ff       	call   80103af0 <cpuid>
80105b85:	85 c0                	test   %eax,%eax
80105b87:	0f 84 c3 00 00 00    	je     80105c50 <trap+0x220>
80105b8d:	e8 ee ce ff ff       	call   80102a80 <lapiceoi>
80105b92:	e8 79 df ff ff       	call   80103b10 <myproc>
80105b97:	85 c0                	test   %eax,%eax
80105b99:	0f 85 38 ff ff ff    	jne    80105ad7 <trap+0xa7>
80105b9f:	e9 50 ff ff ff       	jmp    80105af4 <trap+0xc4>
80105ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ba8:	e8 93 cd ff ff       	call   80102940 <kbdintr>
80105bad:	e8 ce ce ff ff       	call   80102a80 <lapiceoi>
80105bb2:	e8 59 df ff ff       	call   80103b10 <myproc>
80105bb7:	85 c0                	test   %eax,%eax
80105bb9:	0f 85 18 ff ff ff    	jne    80105ad7 <trap+0xa7>
80105bbf:	e9 30 ff ff ff       	jmp    80105af4 <trap+0xc4>
80105bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bc8:	e8 53 02 00 00       	call   80105e20 <uartintr>
80105bcd:	e8 ae ce ff ff       	call   80102a80 <lapiceoi>
80105bd2:	e8 39 df ff ff       	call   80103b10 <myproc>
80105bd7:	85 c0                	test   %eax,%eax
80105bd9:	0f 85 f8 fe ff ff    	jne    80105ad7 <trap+0xa7>
80105bdf:	e9 10 ff ff ff       	jmp    80105af4 <trap+0xc4>
80105be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105be8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105bec:	8b 77 38             	mov    0x38(%edi),%esi
80105bef:	e8 fc de ff ff       	call   80103af0 <cpuid>
80105bf4:	56                   	push   %esi
80105bf5:	53                   	push   %ebx
80105bf6:	50                   	push   %eax
80105bf7:	68 84 79 10 80       	push   $0x80107984
80105bfc:	e8 5f aa ff ff       	call   80100660 <cprintf>
80105c01:	e8 7a ce ff ff       	call   80102a80 <lapiceoi>
80105c06:	83 c4 10             	add    $0x10,%esp
80105c09:	e8 02 df ff ff       	call   80103b10 <myproc>
80105c0e:	85 c0                	test   %eax,%eax
80105c10:	0f 85 c1 fe ff ff    	jne    80105ad7 <trap+0xa7>
80105c16:	e9 d9 fe ff ff       	jmp    80105af4 <trap+0xc4>
80105c1b:	90                   	nop
80105c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c20:	e8 8b c7 ff ff       	call   801023b0 <ideintr>
80105c25:	e9 63 ff ff ff       	jmp    80105b8d <trap+0x15d>
80105c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c30:	e8 fb e2 ff ff       	call   80103f30 <exit>
80105c35:	e9 0e ff ff ff       	jmp    80105b48 <trap+0x118>
80105c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c40:	e8 eb e2 ff ff       	call   80103f30 <exit>
80105c45:	e9 aa fe ff ff       	jmp    80105af4 <trap+0xc4>
80105c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c50:	83 ec 0c             	sub    $0xc,%esp
80105c53:	68 20 4f 11 80       	push   $0x80114f20
80105c58:	e8 13 ea ff ff       	call   80104670 <acquire>
80105c5d:	c7 04 24 60 57 11 80 	movl   $0x80115760,(%esp)
80105c64:	83 05 60 57 11 80 01 	addl   $0x1,0x80115760
80105c6b:	e8 f0 e5 ff ff       	call   80104260 <wakeup>
80105c70:	c7 04 24 20 4f 11 80 	movl   $0x80114f20,(%esp)
80105c77:	e8 b4 ea ff ff       	call   80104730 <release>
80105c7c:	83 c4 10             	add    $0x10,%esp
80105c7f:	e9 09 ff ff ff       	jmp    80105b8d <trap+0x15d>
80105c84:	0f 20 d6             	mov    %cr2,%esi
80105c87:	e8 64 de ff ff       	call   80103af0 <cpuid>
80105c8c:	83 ec 0c             	sub    $0xc,%esp
80105c8f:	56                   	push   %esi
80105c90:	53                   	push   %ebx
80105c91:	50                   	push   %eax
80105c92:	ff 77 30             	pushl  0x30(%edi)
80105c95:	68 a8 79 10 80       	push   $0x801079a8
80105c9a:	e8 c1 a9 ff ff       	call   80100660 <cprintf>
80105c9f:	83 c4 14             	add    $0x14,%esp
80105ca2:	68 7e 79 10 80       	push   $0x8010797e
80105ca7:	e8 e4 a6 ff ff       	call   80100390 <panic>
80105cac:	66 90                	xchg   %ax,%ax
80105cae:	66 90                	xchg   %ax,%ax

80105cb0 <uartgetc>:
80105cb0:	a1 fc a5 10 80       	mov    0x8010a5fc,%eax
80105cb5:	55                   	push   %ebp
80105cb6:	89 e5                	mov    %esp,%ebp
80105cb8:	85 c0                	test   %eax,%eax
80105cba:	74 1c                	je     80105cd8 <uartgetc+0x28>
80105cbc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cc1:	ec                   	in     (%dx),%al
80105cc2:	a8 01                	test   $0x1,%al
80105cc4:	74 12                	je     80105cd8 <uartgetc+0x28>
80105cc6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ccb:	ec                   	in     (%dx),%al
80105ccc:	0f b6 c0             	movzbl %al,%eax
80105ccf:	5d                   	pop    %ebp
80105cd0:	c3                   	ret    
80105cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cdd:	5d                   	pop    %ebp
80105cde:	c3                   	ret    
80105cdf:	90                   	nop

80105ce0 <uartputc.part.0>:
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	57                   	push   %edi
80105ce4:	56                   	push   %esi
80105ce5:	53                   	push   %ebx
80105ce6:	89 c7                	mov    %eax,%edi
80105ce8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ced:	be fd 03 00 00       	mov    $0x3fd,%esi
80105cf2:	83 ec 0c             	sub    $0xc,%esp
80105cf5:	eb 1b                	jmp    80105d12 <uartputc.part.0+0x32>
80105cf7:	89 f6                	mov    %esi,%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105d00:	83 ec 0c             	sub    $0xc,%esp
80105d03:	6a 0a                	push   $0xa
80105d05:	e8 96 cd ff ff       	call   80102aa0 <microdelay>
80105d0a:	83 c4 10             	add    $0x10,%esp
80105d0d:	83 eb 01             	sub    $0x1,%ebx
80105d10:	74 07                	je     80105d19 <uartputc.part.0+0x39>
80105d12:	89 f2                	mov    %esi,%edx
80105d14:	ec                   	in     (%dx),%al
80105d15:	a8 20                	test   $0x20,%al
80105d17:	74 e7                	je     80105d00 <uartputc.part.0+0x20>
80105d19:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d1e:	89 f8                	mov    %edi,%eax
80105d20:	ee                   	out    %al,(%dx)
80105d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d24:	5b                   	pop    %ebx
80105d25:	5e                   	pop    %esi
80105d26:	5f                   	pop    %edi
80105d27:	5d                   	pop    %ebp
80105d28:	c3                   	ret    
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d30 <uartinit>:
80105d30:	55                   	push   %ebp
80105d31:	31 c9                	xor    %ecx,%ecx
80105d33:	89 c8                	mov    %ecx,%eax
80105d35:	89 e5                	mov    %esp,%ebp
80105d37:	57                   	push   %edi
80105d38:	56                   	push   %esi
80105d39:	53                   	push   %ebx
80105d3a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105d3f:	89 da                	mov    %ebx,%edx
80105d41:	83 ec 0c             	sub    $0xc,%esp
80105d44:	ee                   	out    %al,(%dx)
80105d45:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105d4a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d4f:	89 fa                	mov    %edi,%edx
80105d51:	ee                   	out    %al,(%dx)
80105d52:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d57:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d5c:	ee                   	out    %al,(%dx)
80105d5d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105d62:	89 c8                	mov    %ecx,%eax
80105d64:	89 f2                	mov    %esi,%edx
80105d66:	ee                   	out    %al,(%dx)
80105d67:	b8 03 00 00 00       	mov    $0x3,%eax
80105d6c:	89 fa                	mov    %edi,%edx
80105d6e:	ee                   	out    %al,(%dx)
80105d6f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d74:	89 c8                	mov    %ecx,%eax
80105d76:	ee                   	out    %al,(%dx)
80105d77:	b8 01 00 00 00       	mov    $0x1,%eax
80105d7c:	89 f2                	mov    %esi,%edx
80105d7e:	ee                   	out    %al,(%dx)
80105d7f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d84:	ec                   	in     (%dx),%al
80105d85:	3c ff                	cmp    $0xff,%al
80105d87:	74 5a                	je     80105de3 <uartinit+0xb3>
80105d89:	c7 05 fc a5 10 80 01 	movl   $0x1,0x8010a5fc
80105d90:	00 00 00 
80105d93:	89 da                	mov    %ebx,%edx
80105d95:	ec                   	in     (%dx),%al
80105d96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d9b:	ec                   	in     (%dx),%al
80105d9c:	83 ec 08             	sub    $0x8,%esp
80105d9f:	bb a0 7a 10 80       	mov    $0x80107aa0,%ebx
80105da4:	6a 00                	push   $0x0
80105da6:	6a 04                	push   $0x4
80105da8:	e8 53 c8 ff ff       	call   80102600 <ioapicenable>
80105dad:	83 c4 10             	add    $0x10,%esp
80105db0:	b8 78 00 00 00       	mov    $0x78,%eax
80105db5:	eb 13                	jmp    80105dca <uartinit+0x9a>
80105db7:	89 f6                	mov    %esi,%esi
80105db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105dc0:	83 c3 01             	add    $0x1,%ebx
80105dc3:	0f be 03             	movsbl (%ebx),%eax
80105dc6:	84 c0                	test   %al,%al
80105dc8:	74 19                	je     80105de3 <uartinit+0xb3>
80105dca:	8b 15 fc a5 10 80    	mov    0x8010a5fc,%edx
80105dd0:	85 d2                	test   %edx,%edx
80105dd2:	74 ec                	je     80105dc0 <uartinit+0x90>
80105dd4:	83 c3 01             	add    $0x1,%ebx
80105dd7:	e8 04 ff ff ff       	call   80105ce0 <uartputc.part.0>
80105ddc:	0f be 03             	movsbl (%ebx),%eax
80105ddf:	84 c0                	test   %al,%al
80105de1:	75 e7                	jne    80105dca <uartinit+0x9a>
80105de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105de6:	5b                   	pop    %ebx
80105de7:	5e                   	pop    %esi
80105de8:	5f                   	pop    %edi
80105de9:	5d                   	pop    %ebp
80105dea:	c3                   	ret    
80105deb:	90                   	nop
80105dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105df0 <uartputc>:
80105df0:	8b 15 fc a5 10 80    	mov    0x8010a5fc,%edx
80105df6:	55                   	push   %ebp
80105df7:	89 e5                	mov    %esp,%ebp
80105df9:	85 d2                	test   %edx,%edx
80105dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80105dfe:	74 10                	je     80105e10 <uartputc+0x20>
80105e00:	5d                   	pop    %ebp
80105e01:	e9 da fe ff ff       	jmp    80105ce0 <uartputc.part.0>
80105e06:	8d 76 00             	lea    0x0(%esi),%esi
80105e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105e10:	5d                   	pop    %ebp
80105e11:	c3                   	ret    
80105e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e20 <uartintr>:
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	83 ec 14             	sub    $0x14,%esp
80105e26:	68 b0 5c 10 80       	push   $0x80105cb0
80105e2b:	e8 d0 ac ff ff       	call   80100b00 <consoleintr>
80105e30:	83 c4 10             	add    $0x10,%esp
80105e33:	c9                   	leave  
80105e34:	c3                   	ret    

80105e35 <vector0>:
80105e35:	6a 00                	push   $0x0
80105e37:	6a 00                	push   $0x0
80105e39:	e9 1c fb ff ff       	jmp    8010595a <alltraps>

80105e3e <vector1>:
80105e3e:	6a 00                	push   $0x0
80105e40:	6a 01                	push   $0x1
80105e42:	e9 13 fb ff ff       	jmp    8010595a <alltraps>

80105e47 <vector2>:
80105e47:	6a 00                	push   $0x0
80105e49:	6a 02                	push   $0x2
80105e4b:	e9 0a fb ff ff       	jmp    8010595a <alltraps>

80105e50 <vector3>:
80105e50:	6a 00                	push   $0x0
80105e52:	6a 03                	push   $0x3
80105e54:	e9 01 fb ff ff       	jmp    8010595a <alltraps>

80105e59 <vector4>:
80105e59:	6a 00                	push   $0x0
80105e5b:	6a 04                	push   $0x4
80105e5d:	e9 f8 fa ff ff       	jmp    8010595a <alltraps>

80105e62 <vector5>:
80105e62:	6a 00                	push   $0x0
80105e64:	6a 05                	push   $0x5
80105e66:	e9 ef fa ff ff       	jmp    8010595a <alltraps>

80105e6b <vector6>:
80105e6b:	6a 00                	push   $0x0
80105e6d:	6a 06                	push   $0x6
80105e6f:	e9 e6 fa ff ff       	jmp    8010595a <alltraps>

80105e74 <vector7>:
80105e74:	6a 00                	push   $0x0
80105e76:	6a 07                	push   $0x7
80105e78:	e9 dd fa ff ff       	jmp    8010595a <alltraps>

80105e7d <vector8>:
80105e7d:	6a 08                	push   $0x8
80105e7f:	e9 d6 fa ff ff       	jmp    8010595a <alltraps>

80105e84 <vector9>:
80105e84:	6a 00                	push   $0x0
80105e86:	6a 09                	push   $0x9
80105e88:	e9 cd fa ff ff       	jmp    8010595a <alltraps>

80105e8d <vector10>:
80105e8d:	6a 0a                	push   $0xa
80105e8f:	e9 c6 fa ff ff       	jmp    8010595a <alltraps>

80105e94 <vector11>:
80105e94:	6a 0b                	push   $0xb
80105e96:	e9 bf fa ff ff       	jmp    8010595a <alltraps>

80105e9b <vector12>:
80105e9b:	6a 0c                	push   $0xc
80105e9d:	e9 b8 fa ff ff       	jmp    8010595a <alltraps>

80105ea2 <vector13>:
80105ea2:	6a 0d                	push   $0xd
80105ea4:	e9 b1 fa ff ff       	jmp    8010595a <alltraps>

80105ea9 <vector14>:
80105ea9:	6a 0e                	push   $0xe
80105eab:	e9 aa fa ff ff       	jmp    8010595a <alltraps>

80105eb0 <vector15>:
80105eb0:	6a 00                	push   $0x0
80105eb2:	6a 0f                	push   $0xf
80105eb4:	e9 a1 fa ff ff       	jmp    8010595a <alltraps>

80105eb9 <vector16>:
80105eb9:	6a 00                	push   $0x0
80105ebb:	6a 10                	push   $0x10
80105ebd:	e9 98 fa ff ff       	jmp    8010595a <alltraps>

80105ec2 <vector17>:
80105ec2:	6a 11                	push   $0x11
80105ec4:	e9 91 fa ff ff       	jmp    8010595a <alltraps>

80105ec9 <vector18>:
80105ec9:	6a 00                	push   $0x0
80105ecb:	6a 12                	push   $0x12
80105ecd:	e9 88 fa ff ff       	jmp    8010595a <alltraps>

80105ed2 <vector19>:
80105ed2:	6a 00                	push   $0x0
80105ed4:	6a 13                	push   $0x13
80105ed6:	e9 7f fa ff ff       	jmp    8010595a <alltraps>

80105edb <vector20>:
80105edb:	6a 00                	push   $0x0
80105edd:	6a 14                	push   $0x14
80105edf:	e9 76 fa ff ff       	jmp    8010595a <alltraps>

80105ee4 <vector21>:
80105ee4:	6a 00                	push   $0x0
80105ee6:	6a 15                	push   $0x15
80105ee8:	e9 6d fa ff ff       	jmp    8010595a <alltraps>

80105eed <vector22>:
80105eed:	6a 00                	push   $0x0
80105eef:	6a 16                	push   $0x16
80105ef1:	e9 64 fa ff ff       	jmp    8010595a <alltraps>

80105ef6 <vector23>:
80105ef6:	6a 00                	push   $0x0
80105ef8:	6a 17                	push   $0x17
80105efa:	e9 5b fa ff ff       	jmp    8010595a <alltraps>

80105eff <vector24>:
80105eff:	6a 00                	push   $0x0
80105f01:	6a 18                	push   $0x18
80105f03:	e9 52 fa ff ff       	jmp    8010595a <alltraps>

80105f08 <vector25>:
80105f08:	6a 00                	push   $0x0
80105f0a:	6a 19                	push   $0x19
80105f0c:	e9 49 fa ff ff       	jmp    8010595a <alltraps>

80105f11 <vector26>:
80105f11:	6a 00                	push   $0x0
80105f13:	6a 1a                	push   $0x1a
80105f15:	e9 40 fa ff ff       	jmp    8010595a <alltraps>

80105f1a <vector27>:
80105f1a:	6a 00                	push   $0x0
80105f1c:	6a 1b                	push   $0x1b
80105f1e:	e9 37 fa ff ff       	jmp    8010595a <alltraps>

80105f23 <vector28>:
80105f23:	6a 00                	push   $0x0
80105f25:	6a 1c                	push   $0x1c
80105f27:	e9 2e fa ff ff       	jmp    8010595a <alltraps>

80105f2c <vector29>:
80105f2c:	6a 00                	push   $0x0
80105f2e:	6a 1d                	push   $0x1d
80105f30:	e9 25 fa ff ff       	jmp    8010595a <alltraps>

80105f35 <vector30>:
80105f35:	6a 00                	push   $0x0
80105f37:	6a 1e                	push   $0x1e
80105f39:	e9 1c fa ff ff       	jmp    8010595a <alltraps>

80105f3e <vector31>:
80105f3e:	6a 00                	push   $0x0
80105f40:	6a 1f                	push   $0x1f
80105f42:	e9 13 fa ff ff       	jmp    8010595a <alltraps>

80105f47 <vector32>:
80105f47:	6a 00                	push   $0x0
80105f49:	6a 20                	push   $0x20
80105f4b:	e9 0a fa ff ff       	jmp    8010595a <alltraps>

80105f50 <vector33>:
80105f50:	6a 00                	push   $0x0
80105f52:	6a 21                	push   $0x21
80105f54:	e9 01 fa ff ff       	jmp    8010595a <alltraps>

80105f59 <vector34>:
80105f59:	6a 00                	push   $0x0
80105f5b:	6a 22                	push   $0x22
80105f5d:	e9 f8 f9 ff ff       	jmp    8010595a <alltraps>

80105f62 <vector35>:
80105f62:	6a 00                	push   $0x0
80105f64:	6a 23                	push   $0x23
80105f66:	e9 ef f9 ff ff       	jmp    8010595a <alltraps>

80105f6b <vector36>:
80105f6b:	6a 00                	push   $0x0
80105f6d:	6a 24                	push   $0x24
80105f6f:	e9 e6 f9 ff ff       	jmp    8010595a <alltraps>

80105f74 <vector37>:
80105f74:	6a 00                	push   $0x0
80105f76:	6a 25                	push   $0x25
80105f78:	e9 dd f9 ff ff       	jmp    8010595a <alltraps>

80105f7d <vector38>:
80105f7d:	6a 00                	push   $0x0
80105f7f:	6a 26                	push   $0x26
80105f81:	e9 d4 f9 ff ff       	jmp    8010595a <alltraps>

80105f86 <vector39>:
80105f86:	6a 00                	push   $0x0
80105f88:	6a 27                	push   $0x27
80105f8a:	e9 cb f9 ff ff       	jmp    8010595a <alltraps>

80105f8f <vector40>:
80105f8f:	6a 00                	push   $0x0
80105f91:	6a 28                	push   $0x28
80105f93:	e9 c2 f9 ff ff       	jmp    8010595a <alltraps>

80105f98 <vector41>:
80105f98:	6a 00                	push   $0x0
80105f9a:	6a 29                	push   $0x29
80105f9c:	e9 b9 f9 ff ff       	jmp    8010595a <alltraps>

80105fa1 <vector42>:
80105fa1:	6a 00                	push   $0x0
80105fa3:	6a 2a                	push   $0x2a
80105fa5:	e9 b0 f9 ff ff       	jmp    8010595a <alltraps>

80105faa <vector43>:
80105faa:	6a 00                	push   $0x0
80105fac:	6a 2b                	push   $0x2b
80105fae:	e9 a7 f9 ff ff       	jmp    8010595a <alltraps>

80105fb3 <vector44>:
80105fb3:	6a 00                	push   $0x0
80105fb5:	6a 2c                	push   $0x2c
80105fb7:	e9 9e f9 ff ff       	jmp    8010595a <alltraps>

80105fbc <vector45>:
80105fbc:	6a 00                	push   $0x0
80105fbe:	6a 2d                	push   $0x2d
80105fc0:	e9 95 f9 ff ff       	jmp    8010595a <alltraps>

80105fc5 <vector46>:
80105fc5:	6a 00                	push   $0x0
80105fc7:	6a 2e                	push   $0x2e
80105fc9:	e9 8c f9 ff ff       	jmp    8010595a <alltraps>

80105fce <vector47>:
80105fce:	6a 00                	push   $0x0
80105fd0:	6a 2f                	push   $0x2f
80105fd2:	e9 83 f9 ff ff       	jmp    8010595a <alltraps>

80105fd7 <vector48>:
80105fd7:	6a 00                	push   $0x0
80105fd9:	6a 30                	push   $0x30
80105fdb:	e9 7a f9 ff ff       	jmp    8010595a <alltraps>

80105fe0 <vector49>:
80105fe0:	6a 00                	push   $0x0
80105fe2:	6a 31                	push   $0x31
80105fe4:	e9 71 f9 ff ff       	jmp    8010595a <alltraps>

80105fe9 <vector50>:
80105fe9:	6a 00                	push   $0x0
80105feb:	6a 32                	push   $0x32
80105fed:	e9 68 f9 ff ff       	jmp    8010595a <alltraps>

80105ff2 <vector51>:
80105ff2:	6a 00                	push   $0x0
80105ff4:	6a 33                	push   $0x33
80105ff6:	e9 5f f9 ff ff       	jmp    8010595a <alltraps>

80105ffb <vector52>:
80105ffb:	6a 00                	push   $0x0
80105ffd:	6a 34                	push   $0x34
80105fff:	e9 56 f9 ff ff       	jmp    8010595a <alltraps>

80106004 <vector53>:
80106004:	6a 00                	push   $0x0
80106006:	6a 35                	push   $0x35
80106008:	e9 4d f9 ff ff       	jmp    8010595a <alltraps>

8010600d <vector54>:
8010600d:	6a 00                	push   $0x0
8010600f:	6a 36                	push   $0x36
80106011:	e9 44 f9 ff ff       	jmp    8010595a <alltraps>

80106016 <vector55>:
80106016:	6a 00                	push   $0x0
80106018:	6a 37                	push   $0x37
8010601a:	e9 3b f9 ff ff       	jmp    8010595a <alltraps>

8010601f <vector56>:
8010601f:	6a 00                	push   $0x0
80106021:	6a 38                	push   $0x38
80106023:	e9 32 f9 ff ff       	jmp    8010595a <alltraps>

80106028 <vector57>:
80106028:	6a 00                	push   $0x0
8010602a:	6a 39                	push   $0x39
8010602c:	e9 29 f9 ff ff       	jmp    8010595a <alltraps>

80106031 <vector58>:
80106031:	6a 00                	push   $0x0
80106033:	6a 3a                	push   $0x3a
80106035:	e9 20 f9 ff ff       	jmp    8010595a <alltraps>

8010603a <vector59>:
8010603a:	6a 00                	push   $0x0
8010603c:	6a 3b                	push   $0x3b
8010603e:	e9 17 f9 ff ff       	jmp    8010595a <alltraps>

80106043 <vector60>:
80106043:	6a 00                	push   $0x0
80106045:	6a 3c                	push   $0x3c
80106047:	e9 0e f9 ff ff       	jmp    8010595a <alltraps>

8010604c <vector61>:
8010604c:	6a 00                	push   $0x0
8010604e:	6a 3d                	push   $0x3d
80106050:	e9 05 f9 ff ff       	jmp    8010595a <alltraps>

80106055 <vector62>:
80106055:	6a 00                	push   $0x0
80106057:	6a 3e                	push   $0x3e
80106059:	e9 fc f8 ff ff       	jmp    8010595a <alltraps>

8010605e <vector63>:
8010605e:	6a 00                	push   $0x0
80106060:	6a 3f                	push   $0x3f
80106062:	e9 f3 f8 ff ff       	jmp    8010595a <alltraps>

80106067 <vector64>:
80106067:	6a 00                	push   $0x0
80106069:	6a 40                	push   $0x40
8010606b:	e9 ea f8 ff ff       	jmp    8010595a <alltraps>

80106070 <vector65>:
80106070:	6a 00                	push   $0x0
80106072:	6a 41                	push   $0x41
80106074:	e9 e1 f8 ff ff       	jmp    8010595a <alltraps>

80106079 <vector66>:
80106079:	6a 00                	push   $0x0
8010607b:	6a 42                	push   $0x42
8010607d:	e9 d8 f8 ff ff       	jmp    8010595a <alltraps>

80106082 <vector67>:
80106082:	6a 00                	push   $0x0
80106084:	6a 43                	push   $0x43
80106086:	e9 cf f8 ff ff       	jmp    8010595a <alltraps>

8010608b <vector68>:
8010608b:	6a 00                	push   $0x0
8010608d:	6a 44                	push   $0x44
8010608f:	e9 c6 f8 ff ff       	jmp    8010595a <alltraps>

80106094 <vector69>:
80106094:	6a 00                	push   $0x0
80106096:	6a 45                	push   $0x45
80106098:	e9 bd f8 ff ff       	jmp    8010595a <alltraps>

8010609d <vector70>:
8010609d:	6a 00                	push   $0x0
8010609f:	6a 46                	push   $0x46
801060a1:	e9 b4 f8 ff ff       	jmp    8010595a <alltraps>

801060a6 <vector71>:
801060a6:	6a 00                	push   $0x0
801060a8:	6a 47                	push   $0x47
801060aa:	e9 ab f8 ff ff       	jmp    8010595a <alltraps>

801060af <vector72>:
801060af:	6a 00                	push   $0x0
801060b1:	6a 48                	push   $0x48
801060b3:	e9 a2 f8 ff ff       	jmp    8010595a <alltraps>

801060b8 <vector73>:
801060b8:	6a 00                	push   $0x0
801060ba:	6a 49                	push   $0x49
801060bc:	e9 99 f8 ff ff       	jmp    8010595a <alltraps>

801060c1 <vector74>:
801060c1:	6a 00                	push   $0x0
801060c3:	6a 4a                	push   $0x4a
801060c5:	e9 90 f8 ff ff       	jmp    8010595a <alltraps>

801060ca <vector75>:
801060ca:	6a 00                	push   $0x0
801060cc:	6a 4b                	push   $0x4b
801060ce:	e9 87 f8 ff ff       	jmp    8010595a <alltraps>

801060d3 <vector76>:
801060d3:	6a 00                	push   $0x0
801060d5:	6a 4c                	push   $0x4c
801060d7:	e9 7e f8 ff ff       	jmp    8010595a <alltraps>

801060dc <vector77>:
801060dc:	6a 00                	push   $0x0
801060de:	6a 4d                	push   $0x4d
801060e0:	e9 75 f8 ff ff       	jmp    8010595a <alltraps>

801060e5 <vector78>:
801060e5:	6a 00                	push   $0x0
801060e7:	6a 4e                	push   $0x4e
801060e9:	e9 6c f8 ff ff       	jmp    8010595a <alltraps>

801060ee <vector79>:
801060ee:	6a 00                	push   $0x0
801060f0:	6a 4f                	push   $0x4f
801060f2:	e9 63 f8 ff ff       	jmp    8010595a <alltraps>

801060f7 <vector80>:
801060f7:	6a 00                	push   $0x0
801060f9:	6a 50                	push   $0x50
801060fb:	e9 5a f8 ff ff       	jmp    8010595a <alltraps>

80106100 <vector81>:
80106100:	6a 00                	push   $0x0
80106102:	6a 51                	push   $0x51
80106104:	e9 51 f8 ff ff       	jmp    8010595a <alltraps>

80106109 <vector82>:
80106109:	6a 00                	push   $0x0
8010610b:	6a 52                	push   $0x52
8010610d:	e9 48 f8 ff ff       	jmp    8010595a <alltraps>

80106112 <vector83>:
80106112:	6a 00                	push   $0x0
80106114:	6a 53                	push   $0x53
80106116:	e9 3f f8 ff ff       	jmp    8010595a <alltraps>

8010611b <vector84>:
8010611b:	6a 00                	push   $0x0
8010611d:	6a 54                	push   $0x54
8010611f:	e9 36 f8 ff ff       	jmp    8010595a <alltraps>

80106124 <vector85>:
80106124:	6a 00                	push   $0x0
80106126:	6a 55                	push   $0x55
80106128:	e9 2d f8 ff ff       	jmp    8010595a <alltraps>

8010612d <vector86>:
8010612d:	6a 00                	push   $0x0
8010612f:	6a 56                	push   $0x56
80106131:	e9 24 f8 ff ff       	jmp    8010595a <alltraps>

80106136 <vector87>:
80106136:	6a 00                	push   $0x0
80106138:	6a 57                	push   $0x57
8010613a:	e9 1b f8 ff ff       	jmp    8010595a <alltraps>

8010613f <vector88>:
8010613f:	6a 00                	push   $0x0
80106141:	6a 58                	push   $0x58
80106143:	e9 12 f8 ff ff       	jmp    8010595a <alltraps>

80106148 <vector89>:
80106148:	6a 00                	push   $0x0
8010614a:	6a 59                	push   $0x59
8010614c:	e9 09 f8 ff ff       	jmp    8010595a <alltraps>

80106151 <vector90>:
80106151:	6a 00                	push   $0x0
80106153:	6a 5a                	push   $0x5a
80106155:	e9 00 f8 ff ff       	jmp    8010595a <alltraps>

8010615a <vector91>:
8010615a:	6a 00                	push   $0x0
8010615c:	6a 5b                	push   $0x5b
8010615e:	e9 f7 f7 ff ff       	jmp    8010595a <alltraps>

80106163 <vector92>:
80106163:	6a 00                	push   $0x0
80106165:	6a 5c                	push   $0x5c
80106167:	e9 ee f7 ff ff       	jmp    8010595a <alltraps>

8010616c <vector93>:
8010616c:	6a 00                	push   $0x0
8010616e:	6a 5d                	push   $0x5d
80106170:	e9 e5 f7 ff ff       	jmp    8010595a <alltraps>

80106175 <vector94>:
80106175:	6a 00                	push   $0x0
80106177:	6a 5e                	push   $0x5e
80106179:	e9 dc f7 ff ff       	jmp    8010595a <alltraps>

8010617e <vector95>:
8010617e:	6a 00                	push   $0x0
80106180:	6a 5f                	push   $0x5f
80106182:	e9 d3 f7 ff ff       	jmp    8010595a <alltraps>

80106187 <vector96>:
80106187:	6a 00                	push   $0x0
80106189:	6a 60                	push   $0x60
8010618b:	e9 ca f7 ff ff       	jmp    8010595a <alltraps>

80106190 <vector97>:
80106190:	6a 00                	push   $0x0
80106192:	6a 61                	push   $0x61
80106194:	e9 c1 f7 ff ff       	jmp    8010595a <alltraps>

80106199 <vector98>:
80106199:	6a 00                	push   $0x0
8010619b:	6a 62                	push   $0x62
8010619d:	e9 b8 f7 ff ff       	jmp    8010595a <alltraps>

801061a2 <vector99>:
801061a2:	6a 00                	push   $0x0
801061a4:	6a 63                	push   $0x63
801061a6:	e9 af f7 ff ff       	jmp    8010595a <alltraps>

801061ab <vector100>:
801061ab:	6a 00                	push   $0x0
801061ad:	6a 64                	push   $0x64
801061af:	e9 a6 f7 ff ff       	jmp    8010595a <alltraps>

801061b4 <vector101>:
801061b4:	6a 00                	push   $0x0
801061b6:	6a 65                	push   $0x65
801061b8:	e9 9d f7 ff ff       	jmp    8010595a <alltraps>

801061bd <vector102>:
801061bd:	6a 00                	push   $0x0
801061bf:	6a 66                	push   $0x66
801061c1:	e9 94 f7 ff ff       	jmp    8010595a <alltraps>

801061c6 <vector103>:
801061c6:	6a 00                	push   $0x0
801061c8:	6a 67                	push   $0x67
801061ca:	e9 8b f7 ff ff       	jmp    8010595a <alltraps>

801061cf <vector104>:
801061cf:	6a 00                	push   $0x0
801061d1:	6a 68                	push   $0x68
801061d3:	e9 82 f7 ff ff       	jmp    8010595a <alltraps>

801061d8 <vector105>:
801061d8:	6a 00                	push   $0x0
801061da:	6a 69                	push   $0x69
801061dc:	e9 79 f7 ff ff       	jmp    8010595a <alltraps>

801061e1 <vector106>:
801061e1:	6a 00                	push   $0x0
801061e3:	6a 6a                	push   $0x6a
801061e5:	e9 70 f7 ff ff       	jmp    8010595a <alltraps>

801061ea <vector107>:
801061ea:	6a 00                	push   $0x0
801061ec:	6a 6b                	push   $0x6b
801061ee:	e9 67 f7 ff ff       	jmp    8010595a <alltraps>

801061f3 <vector108>:
801061f3:	6a 00                	push   $0x0
801061f5:	6a 6c                	push   $0x6c
801061f7:	e9 5e f7 ff ff       	jmp    8010595a <alltraps>

801061fc <vector109>:
801061fc:	6a 00                	push   $0x0
801061fe:	6a 6d                	push   $0x6d
80106200:	e9 55 f7 ff ff       	jmp    8010595a <alltraps>

80106205 <vector110>:
80106205:	6a 00                	push   $0x0
80106207:	6a 6e                	push   $0x6e
80106209:	e9 4c f7 ff ff       	jmp    8010595a <alltraps>

8010620e <vector111>:
8010620e:	6a 00                	push   $0x0
80106210:	6a 6f                	push   $0x6f
80106212:	e9 43 f7 ff ff       	jmp    8010595a <alltraps>

80106217 <vector112>:
80106217:	6a 00                	push   $0x0
80106219:	6a 70                	push   $0x70
8010621b:	e9 3a f7 ff ff       	jmp    8010595a <alltraps>

80106220 <vector113>:
80106220:	6a 00                	push   $0x0
80106222:	6a 71                	push   $0x71
80106224:	e9 31 f7 ff ff       	jmp    8010595a <alltraps>

80106229 <vector114>:
80106229:	6a 00                	push   $0x0
8010622b:	6a 72                	push   $0x72
8010622d:	e9 28 f7 ff ff       	jmp    8010595a <alltraps>

80106232 <vector115>:
80106232:	6a 00                	push   $0x0
80106234:	6a 73                	push   $0x73
80106236:	e9 1f f7 ff ff       	jmp    8010595a <alltraps>

8010623b <vector116>:
8010623b:	6a 00                	push   $0x0
8010623d:	6a 74                	push   $0x74
8010623f:	e9 16 f7 ff ff       	jmp    8010595a <alltraps>

80106244 <vector117>:
80106244:	6a 00                	push   $0x0
80106246:	6a 75                	push   $0x75
80106248:	e9 0d f7 ff ff       	jmp    8010595a <alltraps>

8010624d <vector118>:
8010624d:	6a 00                	push   $0x0
8010624f:	6a 76                	push   $0x76
80106251:	e9 04 f7 ff ff       	jmp    8010595a <alltraps>

80106256 <vector119>:
80106256:	6a 00                	push   $0x0
80106258:	6a 77                	push   $0x77
8010625a:	e9 fb f6 ff ff       	jmp    8010595a <alltraps>

8010625f <vector120>:
8010625f:	6a 00                	push   $0x0
80106261:	6a 78                	push   $0x78
80106263:	e9 f2 f6 ff ff       	jmp    8010595a <alltraps>

80106268 <vector121>:
80106268:	6a 00                	push   $0x0
8010626a:	6a 79                	push   $0x79
8010626c:	e9 e9 f6 ff ff       	jmp    8010595a <alltraps>

80106271 <vector122>:
80106271:	6a 00                	push   $0x0
80106273:	6a 7a                	push   $0x7a
80106275:	e9 e0 f6 ff ff       	jmp    8010595a <alltraps>

8010627a <vector123>:
8010627a:	6a 00                	push   $0x0
8010627c:	6a 7b                	push   $0x7b
8010627e:	e9 d7 f6 ff ff       	jmp    8010595a <alltraps>

80106283 <vector124>:
80106283:	6a 00                	push   $0x0
80106285:	6a 7c                	push   $0x7c
80106287:	e9 ce f6 ff ff       	jmp    8010595a <alltraps>

8010628c <vector125>:
8010628c:	6a 00                	push   $0x0
8010628e:	6a 7d                	push   $0x7d
80106290:	e9 c5 f6 ff ff       	jmp    8010595a <alltraps>

80106295 <vector126>:
80106295:	6a 00                	push   $0x0
80106297:	6a 7e                	push   $0x7e
80106299:	e9 bc f6 ff ff       	jmp    8010595a <alltraps>

8010629e <vector127>:
8010629e:	6a 00                	push   $0x0
801062a0:	6a 7f                	push   $0x7f
801062a2:	e9 b3 f6 ff ff       	jmp    8010595a <alltraps>

801062a7 <vector128>:
801062a7:	6a 00                	push   $0x0
801062a9:	68 80 00 00 00       	push   $0x80
801062ae:	e9 a7 f6 ff ff       	jmp    8010595a <alltraps>

801062b3 <vector129>:
801062b3:	6a 00                	push   $0x0
801062b5:	68 81 00 00 00       	push   $0x81
801062ba:	e9 9b f6 ff ff       	jmp    8010595a <alltraps>

801062bf <vector130>:
801062bf:	6a 00                	push   $0x0
801062c1:	68 82 00 00 00       	push   $0x82
801062c6:	e9 8f f6 ff ff       	jmp    8010595a <alltraps>

801062cb <vector131>:
801062cb:	6a 00                	push   $0x0
801062cd:	68 83 00 00 00       	push   $0x83
801062d2:	e9 83 f6 ff ff       	jmp    8010595a <alltraps>

801062d7 <vector132>:
801062d7:	6a 00                	push   $0x0
801062d9:	68 84 00 00 00       	push   $0x84
801062de:	e9 77 f6 ff ff       	jmp    8010595a <alltraps>

801062e3 <vector133>:
801062e3:	6a 00                	push   $0x0
801062e5:	68 85 00 00 00       	push   $0x85
801062ea:	e9 6b f6 ff ff       	jmp    8010595a <alltraps>

801062ef <vector134>:
801062ef:	6a 00                	push   $0x0
801062f1:	68 86 00 00 00       	push   $0x86
801062f6:	e9 5f f6 ff ff       	jmp    8010595a <alltraps>

801062fb <vector135>:
801062fb:	6a 00                	push   $0x0
801062fd:	68 87 00 00 00       	push   $0x87
80106302:	e9 53 f6 ff ff       	jmp    8010595a <alltraps>

80106307 <vector136>:
80106307:	6a 00                	push   $0x0
80106309:	68 88 00 00 00       	push   $0x88
8010630e:	e9 47 f6 ff ff       	jmp    8010595a <alltraps>

80106313 <vector137>:
80106313:	6a 00                	push   $0x0
80106315:	68 89 00 00 00       	push   $0x89
8010631a:	e9 3b f6 ff ff       	jmp    8010595a <alltraps>

8010631f <vector138>:
8010631f:	6a 00                	push   $0x0
80106321:	68 8a 00 00 00       	push   $0x8a
80106326:	e9 2f f6 ff ff       	jmp    8010595a <alltraps>

8010632b <vector139>:
8010632b:	6a 00                	push   $0x0
8010632d:	68 8b 00 00 00       	push   $0x8b
80106332:	e9 23 f6 ff ff       	jmp    8010595a <alltraps>

80106337 <vector140>:
80106337:	6a 00                	push   $0x0
80106339:	68 8c 00 00 00       	push   $0x8c
8010633e:	e9 17 f6 ff ff       	jmp    8010595a <alltraps>

80106343 <vector141>:
80106343:	6a 00                	push   $0x0
80106345:	68 8d 00 00 00       	push   $0x8d
8010634a:	e9 0b f6 ff ff       	jmp    8010595a <alltraps>

8010634f <vector142>:
8010634f:	6a 00                	push   $0x0
80106351:	68 8e 00 00 00       	push   $0x8e
80106356:	e9 ff f5 ff ff       	jmp    8010595a <alltraps>

8010635b <vector143>:
8010635b:	6a 00                	push   $0x0
8010635d:	68 8f 00 00 00       	push   $0x8f
80106362:	e9 f3 f5 ff ff       	jmp    8010595a <alltraps>

80106367 <vector144>:
80106367:	6a 00                	push   $0x0
80106369:	68 90 00 00 00       	push   $0x90
8010636e:	e9 e7 f5 ff ff       	jmp    8010595a <alltraps>

80106373 <vector145>:
80106373:	6a 00                	push   $0x0
80106375:	68 91 00 00 00       	push   $0x91
8010637a:	e9 db f5 ff ff       	jmp    8010595a <alltraps>

8010637f <vector146>:
8010637f:	6a 00                	push   $0x0
80106381:	68 92 00 00 00       	push   $0x92
80106386:	e9 cf f5 ff ff       	jmp    8010595a <alltraps>

8010638b <vector147>:
8010638b:	6a 00                	push   $0x0
8010638d:	68 93 00 00 00       	push   $0x93
80106392:	e9 c3 f5 ff ff       	jmp    8010595a <alltraps>

80106397 <vector148>:
80106397:	6a 00                	push   $0x0
80106399:	68 94 00 00 00       	push   $0x94
8010639e:	e9 b7 f5 ff ff       	jmp    8010595a <alltraps>

801063a3 <vector149>:
801063a3:	6a 00                	push   $0x0
801063a5:	68 95 00 00 00       	push   $0x95
801063aa:	e9 ab f5 ff ff       	jmp    8010595a <alltraps>

801063af <vector150>:
801063af:	6a 00                	push   $0x0
801063b1:	68 96 00 00 00       	push   $0x96
801063b6:	e9 9f f5 ff ff       	jmp    8010595a <alltraps>

801063bb <vector151>:
801063bb:	6a 00                	push   $0x0
801063bd:	68 97 00 00 00       	push   $0x97
801063c2:	e9 93 f5 ff ff       	jmp    8010595a <alltraps>

801063c7 <vector152>:
801063c7:	6a 00                	push   $0x0
801063c9:	68 98 00 00 00       	push   $0x98
801063ce:	e9 87 f5 ff ff       	jmp    8010595a <alltraps>

801063d3 <vector153>:
801063d3:	6a 00                	push   $0x0
801063d5:	68 99 00 00 00       	push   $0x99
801063da:	e9 7b f5 ff ff       	jmp    8010595a <alltraps>

801063df <vector154>:
801063df:	6a 00                	push   $0x0
801063e1:	68 9a 00 00 00       	push   $0x9a
801063e6:	e9 6f f5 ff ff       	jmp    8010595a <alltraps>

801063eb <vector155>:
801063eb:	6a 00                	push   $0x0
801063ed:	68 9b 00 00 00       	push   $0x9b
801063f2:	e9 63 f5 ff ff       	jmp    8010595a <alltraps>

801063f7 <vector156>:
801063f7:	6a 00                	push   $0x0
801063f9:	68 9c 00 00 00       	push   $0x9c
801063fe:	e9 57 f5 ff ff       	jmp    8010595a <alltraps>

80106403 <vector157>:
80106403:	6a 00                	push   $0x0
80106405:	68 9d 00 00 00       	push   $0x9d
8010640a:	e9 4b f5 ff ff       	jmp    8010595a <alltraps>

8010640f <vector158>:
8010640f:	6a 00                	push   $0x0
80106411:	68 9e 00 00 00       	push   $0x9e
80106416:	e9 3f f5 ff ff       	jmp    8010595a <alltraps>

8010641b <vector159>:
8010641b:	6a 00                	push   $0x0
8010641d:	68 9f 00 00 00       	push   $0x9f
80106422:	e9 33 f5 ff ff       	jmp    8010595a <alltraps>

80106427 <vector160>:
80106427:	6a 00                	push   $0x0
80106429:	68 a0 00 00 00       	push   $0xa0
8010642e:	e9 27 f5 ff ff       	jmp    8010595a <alltraps>

80106433 <vector161>:
80106433:	6a 00                	push   $0x0
80106435:	68 a1 00 00 00       	push   $0xa1
8010643a:	e9 1b f5 ff ff       	jmp    8010595a <alltraps>

8010643f <vector162>:
8010643f:	6a 00                	push   $0x0
80106441:	68 a2 00 00 00       	push   $0xa2
80106446:	e9 0f f5 ff ff       	jmp    8010595a <alltraps>

8010644b <vector163>:
8010644b:	6a 00                	push   $0x0
8010644d:	68 a3 00 00 00       	push   $0xa3
80106452:	e9 03 f5 ff ff       	jmp    8010595a <alltraps>

80106457 <vector164>:
80106457:	6a 00                	push   $0x0
80106459:	68 a4 00 00 00       	push   $0xa4
8010645e:	e9 f7 f4 ff ff       	jmp    8010595a <alltraps>

80106463 <vector165>:
80106463:	6a 00                	push   $0x0
80106465:	68 a5 00 00 00       	push   $0xa5
8010646a:	e9 eb f4 ff ff       	jmp    8010595a <alltraps>

8010646f <vector166>:
8010646f:	6a 00                	push   $0x0
80106471:	68 a6 00 00 00       	push   $0xa6
80106476:	e9 df f4 ff ff       	jmp    8010595a <alltraps>

8010647b <vector167>:
8010647b:	6a 00                	push   $0x0
8010647d:	68 a7 00 00 00       	push   $0xa7
80106482:	e9 d3 f4 ff ff       	jmp    8010595a <alltraps>

80106487 <vector168>:
80106487:	6a 00                	push   $0x0
80106489:	68 a8 00 00 00       	push   $0xa8
8010648e:	e9 c7 f4 ff ff       	jmp    8010595a <alltraps>

80106493 <vector169>:
80106493:	6a 00                	push   $0x0
80106495:	68 a9 00 00 00       	push   $0xa9
8010649a:	e9 bb f4 ff ff       	jmp    8010595a <alltraps>

8010649f <vector170>:
8010649f:	6a 00                	push   $0x0
801064a1:	68 aa 00 00 00       	push   $0xaa
801064a6:	e9 af f4 ff ff       	jmp    8010595a <alltraps>

801064ab <vector171>:
801064ab:	6a 00                	push   $0x0
801064ad:	68 ab 00 00 00       	push   $0xab
801064b2:	e9 a3 f4 ff ff       	jmp    8010595a <alltraps>

801064b7 <vector172>:
801064b7:	6a 00                	push   $0x0
801064b9:	68 ac 00 00 00       	push   $0xac
801064be:	e9 97 f4 ff ff       	jmp    8010595a <alltraps>

801064c3 <vector173>:
801064c3:	6a 00                	push   $0x0
801064c5:	68 ad 00 00 00       	push   $0xad
801064ca:	e9 8b f4 ff ff       	jmp    8010595a <alltraps>

801064cf <vector174>:
801064cf:	6a 00                	push   $0x0
801064d1:	68 ae 00 00 00       	push   $0xae
801064d6:	e9 7f f4 ff ff       	jmp    8010595a <alltraps>

801064db <vector175>:
801064db:	6a 00                	push   $0x0
801064dd:	68 af 00 00 00       	push   $0xaf
801064e2:	e9 73 f4 ff ff       	jmp    8010595a <alltraps>

801064e7 <vector176>:
801064e7:	6a 00                	push   $0x0
801064e9:	68 b0 00 00 00       	push   $0xb0
801064ee:	e9 67 f4 ff ff       	jmp    8010595a <alltraps>

801064f3 <vector177>:
801064f3:	6a 00                	push   $0x0
801064f5:	68 b1 00 00 00       	push   $0xb1
801064fa:	e9 5b f4 ff ff       	jmp    8010595a <alltraps>

801064ff <vector178>:
801064ff:	6a 00                	push   $0x0
80106501:	68 b2 00 00 00       	push   $0xb2
80106506:	e9 4f f4 ff ff       	jmp    8010595a <alltraps>

8010650b <vector179>:
8010650b:	6a 00                	push   $0x0
8010650d:	68 b3 00 00 00       	push   $0xb3
80106512:	e9 43 f4 ff ff       	jmp    8010595a <alltraps>

80106517 <vector180>:
80106517:	6a 00                	push   $0x0
80106519:	68 b4 00 00 00       	push   $0xb4
8010651e:	e9 37 f4 ff ff       	jmp    8010595a <alltraps>

80106523 <vector181>:
80106523:	6a 00                	push   $0x0
80106525:	68 b5 00 00 00       	push   $0xb5
8010652a:	e9 2b f4 ff ff       	jmp    8010595a <alltraps>

8010652f <vector182>:
8010652f:	6a 00                	push   $0x0
80106531:	68 b6 00 00 00       	push   $0xb6
80106536:	e9 1f f4 ff ff       	jmp    8010595a <alltraps>

8010653b <vector183>:
8010653b:	6a 00                	push   $0x0
8010653d:	68 b7 00 00 00       	push   $0xb7
80106542:	e9 13 f4 ff ff       	jmp    8010595a <alltraps>

80106547 <vector184>:
80106547:	6a 00                	push   $0x0
80106549:	68 b8 00 00 00       	push   $0xb8
8010654e:	e9 07 f4 ff ff       	jmp    8010595a <alltraps>

80106553 <vector185>:
80106553:	6a 00                	push   $0x0
80106555:	68 b9 00 00 00       	push   $0xb9
8010655a:	e9 fb f3 ff ff       	jmp    8010595a <alltraps>

8010655f <vector186>:
8010655f:	6a 00                	push   $0x0
80106561:	68 ba 00 00 00       	push   $0xba
80106566:	e9 ef f3 ff ff       	jmp    8010595a <alltraps>

8010656b <vector187>:
8010656b:	6a 00                	push   $0x0
8010656d:	68 bb 00 00 00       	push   $0xbb
80106572:	e9 e3 f3 ff ff       	jmp    8010595a <alltraps>

80106577 <vector188>:
80106577:	6a 00                	push   $0x0
80106579:	68 bc 00 00 00       	push   $0xbc
8010657e:	e9 d7 f3 ff ff       	jmp    8010595a <alltraps>

80106583 <vector189>:
80106583:	6a 00                	push   $0x0
80106585:	68 bd 00 00 00       	push   $0xbd
8010658a:	e9 cb f3 ff ff       	jmp    8010595a <alltraps>

8010658f <vector190>:
8010658f:	6a 00                	push   $0x0
80106591:	68 be 00 00 00       	push   $0xbe
80106596:	e9 bf f3 ff ff       	jmp    8010595a <alltraps>

8010659b <vector191>:
8010659b:	6a 00                	push   $0x0
8010659d:	68 bf 00 00 00       	push   $0xbf
801065a2:	e9 b3 f3 ff ff       	jmp    8010595a <alltraps>

801065a7 <vector192>:
801065a7:	6a 00                	push   $0x0
801065a9:	68 c0 00 00 00       	push   $0xc0
801065ae:	e9 a7 f3 ff ff       	jmp    8010595a <alltraps>

801065b3 <vector193>:
801065b3:	6a 00                	push   $0x0
801065b5:	68 c1 00 00 00       	push   $0xc1
801065ba:	e9 9b f3 ff ff       	jmp    8010595a <alltraps>

801065bf <vector194>:
801065bf:	6a 00                	push   $0x0
801065c1:	68 c2 00 00 00       	push   $0xc2
801065c6:	e9 8f f3 ff ff       	jmp    8010595a <alltraps>

801065cb <vector195>:
801065cb:	6a 00                	push   $0x0
801065cd:	68 c3 00 00 00       	push   $0xc3
801065d2:	e9 83 f3 ff ff       	jmp    8010595a <alltraps>

801065d7 <vector196>:
801065d7:	6a 00                	push   $0x0
801065d9:	68 c4 00 00 00       	push   $0xc4
801065de:	e9 77 f3 ff ff       	jmp    8010595a <alltraps>

801065e3 <vector197>:
801065e3:	6a 00                	push   $0x0
801065e5:	68 c5 00 00 00       	push   $0xc5
801065ea:	e9 6b f3 ff ff       	jmp    8010595a <alltraps>

801065ef <vector198>:
801065ef:	6a 00                	push   $0x0
801065f1:	68 c6 00 00 00       	push   $0xc6
801065f6:	e9 5f f3 ff ff       	jmp    8010595a <alltraps>

801065fb <vector199>:
801065fb:	6a 00                	push   $0x0
801065fd:	68 c7 00 00 00       	push   $0xc7
80106602:	e9 53 f3 ff ff       	jmp    8010595a <alltraps>

80106607 <vector200>:
80106607:	6a 00                	push   $0x0
80106609:	68 c8 00 00 00       	push   $0xc8
8010660e:	e9 47 f3 ff ff       	jmp    8010595a <alltraps>

80106613 <vector201>:
80106613:	6a 00                	push   $0x0
80106615:	68 c9 00 00 00       	push   $0xc9
8010661a:	e9 3b f3 ff ff       	jmp    8010595a <alltraps>

8010661f <vector202>:
8010661f:	6a 00                	push   $0x0
80106621:	68 ca 00 00 00       	push   $0xca
80106626:	e9 2f f3 ff ff       	jmp    8010595a <alltraps>

8010662b <vector203>:
8010662b:	6a 00                	push   $0x0
8010662d:	68 cb 00 00 00       	push   $0xcb
80106632:	e9 23 f3 ff ff       	jmp    8010595a <alltraps>

80106637 <vector204>:
80106637:	6a 00                	push   $0x0
80106639:	68 cc 00 00 00       	push   $0xcc
8010663e:	e9 17 f3 ff ff       	jmp    8010595a <alltraps>

80106643 <vector205>:
80106643:	6a 00                	push   $0x0
80106645:	68 cd 00 00 00       	push   $0xcd
8010664a:	e9 0b f3 ff ff       	jmp    8010595a <alltraps>

8010664f <vector206>:
8010664f:	6a 00                	push   $0x0
80106651:	68 ce 00 00 00       	push   $0xce
80106656:	e9 ff f2 ff ff       	jmp    8010595a <alltraps>

8010665b <vector207>:
8010665b:	6a 00                	push   $0x0
8010665d:	68 cf 00 00 00       	push   $0xcf
80106662:	e9 f3 f2 ff ff       	jmp    8010595a <alltraps>

80106667 <vector208>:
80106667:	6a 00                	push   $0x0
80106669:	68 d0 00 00 00       	push   $0xd0
8010666e:	e9 e7 f2 ff ff       	jmp    8010595a <alltraps>

80106673 <vector209>:
80106673:	6a 00                	push   $0x0
80106675:	68 d1 00 00 00       	push   $0xd1
8010667a:	e9 db f2 ff ff       	jmp    8010595a <alltraps>

8010667f <vector210>:
8010667f:	6a 00                	push   $0x0
80106681:	68 d2 00 00 00       	push   $0xd2
80106686:	e9 cf f2 ff ff       	jmp    8010595a <alltraps>

8010668b <vector211>:
8010668b:	6a 00                	push   $0x0
8010668d:	68 d3 00 00 00       	push   $0xd3
80106692:	e9 c3 f2 ff ff       	jmp    8010595a <alltraps>

80106697 <vector212>:
80106697:	6a 00                	push   $0x0
80106699:	68 d4 00 00 00       	push   $0xd4
8010669e:	e9 b7 f2 ff ff       	jmp    8010595a <alltraps>

801066a3 <vector213>:
801066a3:	6a 00                	push   $0x0
801066a5:	68 d5 00 00 00       	push   $0xd5
801066aa:	e9 ab f2 ff ff       	jmp    8010595a <alltraps>

801066af <vector214>:
801066af:	6a 00                	push   $0x0
801066b1:	68 d6 00 00 00       	push   $0xd6
801066b6:	e9 9f f2 ff ff       	jmp    8010595a <alltraps>

801066bb <vector215>:
801066bb:	6a 00                	push   $0x0
801066bd:	68 d7 00 00 00       	push   $0xd7
801066c2:	e9 93 f2 ff ff       	jmp    8010595a <alltraps>

801066c7 <vector216>:
801066c7:	6a 00                	push   $0x0
801066c9:	68 d8 00 00 00       	push   $0xd8
801066ce:	e9 87 f2 ff ff       	jmp    8010595a <alltraps>

801066d3 <vector217>:
801066d3:	6a 00                	push   $0x0
801066d5:	68 d9 00 00 00       	push   $0xd9
801066da:	e9 7b f2 ff ff       	jmp    8010595a <alltraps>

801066df <vector218>:
801066df:	6a 00                	push   $0x0
801066e1:	68 da 00 00 00       	push   $0xda
801066e6:	e9 6f f2 ff ff       	jmp    8010595a <alltraps>

801066eb <vector219>:
801066eb:	6a 00                	push   $0x0
801066ed:	68 db 00 00 00       	push   $0xdb
801066f2:	e9 63 f2 ff ff       	jmp    8010595a <alltraps>

801066f7 <vector220>:
801066f7:	6a 00                	push   $0x0
801066f9:	68 dc 00 00 00       	push   $0xdc
801066fe:	e9 57 f2 ff ff       	jmp    8010595a <alltraps>

80106703 <vector221>:
80106703:	6a 00                	push   $0x0
80106705:	68 dd 00 00 00       	push   $0xdd
8010670a:	e9 4b f2 ff ff       	jmp    8010595a <alltraps>

8010670f <vector222>:
8010670f:	6a 00                	push   $0x0
80106711:	68 de 00 00 00       	push   $0xde
80106716:	e9 3f f2 ff ff       	jmp    8010595a <alltraps>

8010671b <vector223>:
8010671b:	6a 00                	push   $0x0
8010671d:	68 df 00 00 00       	push   $0xdf
80106722:	e9 33 f2 ff ff       	jmp    8010595a <alltraps>

80106727 <vector224>:
80106727:	6a 00                	push   $0x0
80106729:	68 e0 00 00 00       	push   $0xe0
8010672e:	e9 27 f2 ff ff       	jmp    8010595a <alltraps>

80106733 <vector225>:
80106733:	6a 00                	push   $0x0
80106735:	68 e1 00 00 00       	push   $0xe1
8010673a:	e9 1b f2 ff ff       	jmp    8010595a <alltraps>

8010673f <vector226>:
8010673f:	6a 00                	push   $0x0
80106741:	68 e2 00 00 00       	push   $0xe2
80106746:	e9 0f f2 ff ff       	jmp    8010595a <alltraps>

8010674b <vector227>:
8010674b:	6a 00                	push   $0x0
8010674d:	68 e3 00 00 00       	push   $0xe3
80106752:	e9 03 f2 ff ff       	jmp    8010595a <alltraps>

80106757 <vector228>:
80106757:	6a 00                	push   $0x0
80106759:	68 e4 00 00 00       	push   $0xe4
8010675e:	e9 f7 f1 ff ff       	jmp    8010595a <alltraps>

80106763 <vector229>:
80106763:	6a 00                	push   $0x0
80106765:	68 e5 00 00 00       	push   $0xe5
8010676a:	e9 eb f1 ff ff       	jmp    8010595a <alltraps>

8010676f <vector230>:
8010676f:	6a 00                	push   $0x0
80106771:	68 e6 00 00 00       	push   $0xe6
80106776:	e9 df f1 ff ff       	jmp    8010595a <alltraps>

8010677b <vector231>:
8010677b:	6a 00                	push   $0x0
8010677d:	68 e7 00 00 00       	push   $0xe7
80106782:	e9 d3 f1 ff ff       	jmp    8010595a <alltraps>

80106787 <vector232>:
80106787:	6a 00                	push   $0x0
80106789:	68 e8 00 00 00       	push   $0xe8
8010678e:	e9 c7 f1 ff ff       	jmp    8010595a <alltraps>

80106793 <vector233>:
80106793:	6a 00                	push   $0x0
80106795:	68 e9 00 00 00       	push   $0xe9
8010679a:	e9 bb f1 ff ff       	jmp    8010595a <alltraps>

8010679f <vector234>:
8010679f:	6a 00                	push   $0x0
801067a1:	68 ea 00 00 00       	push   $0xea
801067a6:	e9 af f1 ff ff       	jmp    8010595a <alltraps>

801067ab <vector235>:
801067ab:	6a 00                	push   $0x0
801067ad:	68 eb 00 00 00       	push   $0xeb
801067b2:	e9 a3 f1 ff ff       	jmp    8010595a <alltraps>

801067b7 <vector236>:
801067b7:	6a 00                	push   $0x0
801067b9:	68 ec 00 00 00       	push   $0xec
801067be:	e9 97 f1 ff ff       	jmp    8010595a <alltraps>

801067c3 <vector237>:
801067c3:	6a 00                	push   $0x0
801067c5:	68 ed 00 00 00       	push   $0xed
801067ca:	e9 8b f1 ff ff       	jmp    8010595a <alltraps>

801067cf <vector238>:
801067cf:	6a 00                	push   $0x0
801067d1:	68 ee 00 00 00       	push   $0xee
801067d6:	e9 7f f1 ff ff       	jmp    8010595a <alltraps>

801067db <vector239>:
801067db:	6a 00                	push   $0x0
801067dd:	68 ef 00 00 00       	push   $0xef
801067e2:	e9 73 f1 ff ff       	jmp    8010595a <alltraps>

801067e7 <vector240>:
801067e7:	6a 00                	push   $0x0
801067e9:	68 f0 00 00 00       	push   $0xf0
801067ee:	e9 67 f1 ff ff       	jmp    8010595a <alltraps>

801067f3 <vector241>:
801067f3:	6a 00                	push   $0x0
801067f5:	68 f1 00 00 00       	push   $0xf1
801067fa:	e9 5b f1 ff ff       	jmp    8010595a <alltraps>

801067ff <vector242>:
801067ff:	6a 00                	push   $0x0
80106801:	68 f2 00 00 00       	push   $0xf2
80106806:	e9 4f f1 ff ff       	jmp    8010595a <alltraps>

8010680b <vector243>:
8010680b:	6a 00                	push   $0x0
8010680d:	68 f3 00 00 00       	push   $0xf3
80106812:	e9 43 f1 ff ff       	jmp    8010595a <alltraps>

80106817 <vector244>:
80106817:	6a 00                	push   $0x0
80106819:	68 f4 00 00 00       	push   $0xf4
8010681e:	e9 37 f1 ff ff       	jmp    8010595a <alltraps>

80106823 <vector245>:
80106823:	6a 00                	push   $0x0
80106825:	68 f5 00 00 00       	push   $0xf5
8010682a:	e9 2b f1 ff ff       	jmp    8010595a <alltraps>

8010682f <vector246>:
8010682f:	6a 00                	push   $0x0
80106831:	68 f6 00 00 00       	push   $0xf6
80106836:	e9 1f f1 ff ff       	jmp    8010595a <alltraps>

8010683b <vector247>:
8010683b:	6a 00                	push   $0x0
8010683d:	68 f7 00 00 00       	push   $0xf7
80106842:	e9 13 f1 ff ff       	jmp    8010595a <alltraps>

80106847 <vector248>:
80106847:	6a 00                	push   $0x0
80106849:	68 f8 00 00 00       	push   $0xf8
8010684e:	e9 07 f1 ff ff       	jmp    8010595a <alltraps>

80106853 <vector249>:
80106853:	6a 00                	push   $0x0
80106855:	68 f9 00 00 00       	push   $0xf9
8010685a:	e9 fb f0 ff ff       	jmp    8010595a <alltraps>

8010685f <vector250>:
8010685f:	6a 00                	push   $0x0
80106861:	68 fa 00 00 00       	push   $0xfa
80106866:	e9 ef f0 ff ff       	jmp    8010595a <alltraps>

8010686b <vector251>:
8010686b:	6a 00                	push   $0x0
8010686d:	68 fb 00 00 00       	push   $0xfb
80106872:	e9 e3 f0 ff ff       	jmp    8010595a <alltraps>

80106877 <vector252>:
80106877:	6a 00                	push   $0x0
80106879:	68 fc 00 00 00       	push   $0xfc
8010687e:	e9 d7 f0 ff ff       	jmp    8010595a <alltraps>

80106883 <vector253>:
80106883:	6a 00                	push   $0x0
80106885:	68 fd 00 00 00       	push   $0xfd
8010688a:	e9 cb f0 ff ff       	jmp    8010595a <alltraps>

8010688f <vector254>:
8010688f:	6a 00                	push   $0x0
80106891:	68 fe 00 00 00       	push   $0xfe
80106896:	e9 bf f0 ff ff       	jmp    8010595a <alltraps>

8010689b <vector255>:
8010689b:	6a 00                	push   $0x0
8010689d:	68 ff 00 00 00       	push   $0xff
801068a2:	e9 b3 f0 ff ff       	jmp    8010595a <alltraps>
801068a7:	66 90                	xchg   %ax,%ax
801068a9:	66 90                	xchg   %ax,%ax
801068ab:	66 90                	xchg   %ax,%ax
801068ad:	66 90                	xchg   %ax,%ax
801068af:	90                   	nop

801068b0 <walkpgdir>:
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	57                   	push   %edi
801068b4:	56                   	push   %esi
801068b5:	53                   	push   %ebx
801068b6:	89 d3                	mov    %edx,%ebx
801068b8:	89 d7                	mov    %edx,%edi
801068ba:	c1 eb 16             	shr    $0x16,%ebx
801068bd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
801068c0:	83 ec 0c             	sub    $0xc,%esp
801068c3:	8b 06                	mov    (%esi),%eax
801068c5:	a8 01                	test   $0x1,%al
801068c7:	74 27                	je     801068f0 <walkpgdir+0x40>
801068c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068ce:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801068d4:	c1 ef 0a             	shr    $0xa,%edi
801068d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068da:	89 fa                	mov    %edi,%edx
801068dc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801068e2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
801068e5:	5b                   	pop    %ebx
801068e6:	5e                   	pop    %esi
801068e7:	5f                   	pop    %edi
801068e8:	5d                   	pop    %ebp
801068e9:	c3                   	ret    
801068ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801068f0:	85 c9                	test   %ecx,%ecx
801068f2:	74 2c                	je     80106920 <walkpgdir+0x70>
801068f4:	e8 f7 be ff ff       	call   801027f0 <kalloc>
801068f9:	85 c0                	test   %eax,%eax
801068fb:	89 c3                	mov    %eax,%ebx
801068fd:	74 21                	je     80106920 <walkpgdir+0x70>
801068ff:	83 ec 04             	sub    $0x4,%esp
80106902:	68 00 10 00 00       	push   $0x1000
80106907:	6a 00                	push   $0x0
80106909:	50                   	push   %eax
8010690a:	e8 71 de ff ff       	call   80104780 <memset>
8010690f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106915:	83 c4 10             	add    $0x10,%esp
80106918:	83 c8 07             	or     $0x7,%eax
8010691b:	89 06                	mov    %eax,(%esi)
8010691d:	eb b5                	jmp    801068d4 <walkpgdir+0x24>
8010691f:	90                   	nop
80106920:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106923:	31 c0                	xor    %eax,%eax
80106925:	5b                   	pop    %ebx
80106926:	5e                   	pop    %esi
80106927:	5f                   	pop    %edi
80106928:	5d                   	pop    %ebp
80106929:	c3                   	ret    
8010692a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106930 <mappages>:
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	57                   	push   %edi
80106934:	56                   	push   %esi
80106935:	53                   	push   %ebx
80106936:	89 d3                	mov    %edx,%ebx
80106938:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010693e:	83 ec 1c             	sub    $0x1c,%esp
80106941:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106944:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106948:	8b 7d 08             	mov    0x8(%ebp),%edi
8010694b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106950:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106953:	8b 45 0c             	mov    0xc(%ebp),%eax
80106956:	29 df                	sub    %ebx,%edi
80106958:	83 c8 01             	or     $0x1,%eax
8010695b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010695e:	eb 15                	jmp    80106975 <mappages+0x45>
80106960:	f6 00 01             	testb  $0x1,(%eax)
80106963:	75 45                	jne    801069aa <mappages+0x7a>
80106965:	0b 75 dc             	or     -0x24(%ebp),%esi
80106968:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
8010696b:	89 30                	mov    %esi,(%eax)
8010696d:	74 31                	je     801069a0 <mappages+0x70>
8010696f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106975:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106978:	b9 01 00 00 00       	mov    $0x1,%ecx
8010697d:	89 da                	mov    %ebx,%edx
8010697f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106982:	e8 29 ff ff ff       	call   801068b0 <walkpgdir>
80106987:	85 c0                	test   %eax,%eax
80106989:	75 d5                	jne    80106960 <mappages+0x30>
8010698b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010698e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106993:	5b                   	pop    %ebx
80106994:	5e                   	pop    %esi
80106995:	5f                   	pop    %edi
80106996:	5d                   	pop    %ebp
80106997:	c3                   	ret    
80106998:	90                   	nop
80106999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069a3:	31 c0                	xor    %eax,%eax
801069a5:	5b                   	pop    %ebx
801069a6:	5e                   	pop    %esi
801069a7:	5f                   	pop    %edi
801069a8:	5d                   	pop    %ebp
801069a9:	c3                   	ret    
801069aa:	83 ec 0c             	sub    $0xc,%esp
801069ad:	68 a8 7a 10 80       	push   $0x80107aa8
801069b2:	e8 d9 99 ff ff       	call   80100390 <panic>
801069b7:	89 f6                	mov    %esi,%esi
801069b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069c0 <deallocuvm.part.0>:
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	53                   	push   %ebx
801069c6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801069cc:	89 c7                	mov    %eax,%edi
801069ce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801069d4:	83 ec 1c             	sub    $0x1c,%esp
801069d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801069da:	39 d3                	cmp    %edx,%ebx
801069dc:	73 66                	jae    80106a44 <deallocuvm.part.0+0x84>
801069de:	89 d6                	mov    %edx,%esi
801069e0:	eb 3d                	jmp    80106a1f <deallocuvm.part.0+0x5f>
801069e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069e8:	8b 10                	mov    (%eax),%edx
801069ea:	f6 c2 01             	test   $0x1,%dl
801069ed:	74 26                	je     80106a15 <deallocuvm.part.0+0x55>
801069ef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801069f5:	74 58                	je     80106a4f <deallocuvm.part.0+0x8f>
801069f7:	83 ec 0c             	sub    $0xc,%esp
801069fa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106a00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a03:	52                   	push   %edx
80106a04:	e8 37 bc ff ff       	call   80102640 <kfree>
80106a09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a0c:	83 c4 10             	add    $0x10,%esp
80106a0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106a15:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a1b:	39 f3                	cmp    %esi,%ebx
80106a1d:	73 25                	jae    80106a44 <deallocuvm.part.0+0x84>
80106a1f:	31 c9                	xor    %ecx,%ecx
80106a21:	89 da                	mov    %ebx,%edx
80106a23:	89 f8                	mov    %edi,%eax
80106a25:	e8 86 fe ff ff       	call   801068b0 <walkpgdir>
80106a2a:	85 c0                	test   %eax,%eax
80106a2c:	75 ba                	jne    801069e8 <deallocuvm.part.0+0x28>
80106a2e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106a34:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
80106a3a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a40:	39 f3                	cmp    %esi,%ebx
80106a42:	72 db                	jb     80106a1f <deallocuvm.part.0+0x5f>
80106a44:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a4a:	5b                   	pop    %ebx
80106a4b:	5e                   	pop    %esi
80106a4c:	5f                   	pop    %edi
80106a4d:	5d                   	pop    %ebp
80106a4e:	c3                   	ret    
80106a4f:	83 ec 0c             	sub    $0xc,%esp
80106a52:	68 46 74 10 80       	push   $0x80107446
80106a57:	e8 34 99 ff ff       	call   80100390 <panic>
80106a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a60 <seginit>:
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	83 ec 18             	sub    $0x18,%esp
80106a66:	e8 85 d0 ff ff       	call   80103af0 <cpuid>
80106a6b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106a71:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106a76:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106a7a:	c7 80 b8 2a 11 80 ff 	movl   $0xffff,-0x7feed548(%eax)
80106a81:	ff 00 00 
80106a84:	c7 80 bc 2a 11 80 00 	movl   $0xcf9a00,-0x7feed544(%eax)
80106a8b:	9a cf 00 
80106a8e:	c7 80 c0 2a 11 80 ff 	movl   $0xffff,-0x7feed540(%eax)
80106a95:	ff 00 00 
80106a98:	c7 80 c4 2a 11 80 00 	movl   $0xcf9200,-0x7feed53c(%eax)
80106a9f:	92 cf 00 
80106aa2:	c7 80 c8 2a 11 80 ff 	movl   $0xffff,-0x7feed538(%eax)
80106aa9:	ff 00 00 
80106aac:	c7 80 cc 2a 11 80 00 	movl   $0xcffa00,-0x7feed534(%eax)
80106ab3:	fa cf 00 
80106ab6:	c7 80 d0 2a 11 80 ff 	movl   $0xffff,-0x7feed530(%eax)
80106abd:	ff 00 00 
80106ac0:	c7 80 d4 2a 11 80 00 	movl   $0xcff200,-0x7feed52c(%eax)
80106ac7:	f2 cf 00 
80106aca:	05 b0 2a 11 80       	add    $0x80112ab0,%eax
80106acf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80106ad3:	c1 e8 10             	shr    $0x10,%eax
80106ad6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80106ada:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106add:	0f 01 10             	lgdtl  (%eax)
80106ae0:	c9                   	leave  
80106ae1:	c3                   	ret    
80106ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106af0 <switchkvm>:
80106af0:	a1 64 57 11 80       	mov    0x80115764,%eax
80106af5:	55                   	push   %ebp
80106af6:	89 e5                	mov    %esp,%ebp
80106af8:	05 00 00 00 80       	add    $0x80000000,%eax
80106afd:	0f 22 d8             	mov    %eax,%cr3
80106b00:	5d                   	pop    %ebp
80106b01:	c3                   	ret    
80106b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b10 <switchuvm>:
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	57                   	push   %edi
80106b14:	56                   	push   %esi
80106b15:	53                   	push   %ebx
80106b16:	83 ec 1c             	sub    $0x1c,%esp
80106b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106b1c:	85 db                	test   %ebx,%ebx
80106b1e:	0f 84 cb 00 00 00    	je     80106bef <switchuvm+0xdf>
80106b24:	8b 43 08             	mov    0x8(%ebx),%eax
80106b27:	85 c0                	test   %eax,%eax
80106b29:	0f 84 da 00 00 00    	je     80106c09 <switchuvm+0xf9>
80106b2f:	8b 43 04             	mov    0x4(%ebx),%eax
80106b32:	85 c0                	test   %eax,%eax
80106b34:	0f 84 c2 00 00 00    	je     80106bfc <switchuvm+0xec>
80106b3a:	e8 61 da ff ff       	call   801045a0 <pushcli>
80106b3f:	e8 2c cf ff ff       	call   80103a70 <mycpu>
80106b44:	89 c6                	mov    %eax,%esi
80106b46:	e8 25 cf ff ff       	call   80103a70 <mycpu>
80106b4b:	89 c7                	mov    %eax,%edi
80106b4d:	e8 1e cf ff ff       	call   80103a70 <mycpu>
80106b52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b55:	83 c7 08             	add    $0x8,%edi
80106b58:	e8 13 cf ff ff       	call   80103a70 <mycpu>
80106b5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b60:	83 c0 08             	add    $0x8,%eax
80106b63:	ba 67 00 00 00       	mov    $0x67,%edx
80106b68:	c1 e8 18             	shr    $0x18,%eax
80106b6b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106b72:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106b79:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
80106b7f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80106b84:	83 c1 08             	add    $0x8,%ecx
80106b87:	c1 e9 10             	shr    $0x10,%ecx
80106b8a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106b90:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b95:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
80106b9c:	be 10 00 00 00       	mov    $0x10,%esi
80106ba1:	e8 ca ce ff ff       	call   80103a70 <mycpu>
80106ba6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
80106bad:	e8 be ce ff ff       	call   80103a70 <mycpu>
80106bb2:	66 89 70 10          	mov    %si,0x10(%eax)
80106bb6:	8b 73 08             	mov    0x8(%ebx),%esi
80106bb9:	e8 b2 ce ff ff       	call   80103a70 <mycpu>
80106bbe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106bc4:	89 70 0c             	mov    %esi,0xc(%eax)
80106bc7:	e8 a4 ce ff ff       	call   80103a70 <mycpu>
80106bcc:	66 89 78 6e          	mov    %di,0x6e(%eax)
80106bd0:	b8 28 00 00 00       	mov    $0x28,%eax
80106bd5:	0f 00 d8             	ltr    %ax
80106bd8:	8b 43 04             	mov    0x4(%ebx),%eax
80106bdb:	05 00 00 00 80       	add    $0x80000000,%eax
80106be0:	0f 22 d8             	mov    %eax,%cr3
80106be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106be6:	5b                   	pop    %ebx
80106be7:	5e                   	pop    %esi
80106be8:	5f                   	pop    %edi
80106be9:	5d                   	pop    %ebp
80106bea:	e9 f1 d9 ff ff       	jmp    801045e0 <popcli>
80106bef:	83 ec 0c             	sub    $0xc,%esp
80106bf2:	68 ae 7a 10 80       	push   $0x80107aae
80106bf7:	e8 94 97 ff ff       	call   80100390 <panic>
80106bfc:	83 ec 0c             	sub    $0xc,%esp
80106bff:	68 d9 7a 10 80       	push   $0x80107ad9
80106c04:	e8 87 97 ff ff       	call   80100390 <panic>
80106c09:	83 ec 0c             	sub    $0xc,%esp
80106c0c:	68 c4 7a 10 80       	push   $0x80107ac4
80106c11:	e8 7a 97 ff ff       	call   80100390 <panic>
80106c16:	8d 76 00             	lea    0x0(%esi),%esi
80106c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c20 <inituvm>:
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
80106c26:	83 ec 1c             	sub    $0x1c,%esp
80106c29:	8b 75 10             	mov    0x10(%ebp),%esi
80106c2c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106c32:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c3b:	77 49                	ja     80106c86 <inituvm+0x66>
80106c3d:	e8 ae bb ff ff       	call   801027f0 <kalloc>
80106c42:	83 ec 04             	sub    $0x4,%esp
80106c45:	89 c3                	mov    %eax,%ebx
80106c47:	68 00 10 00 00       	push   $0x1000
80106c4c:	6a 00                	push   $0x0
80106c4e:	50                   	push   %eax
80106c4f:	e8 2c db ff ff       	call   80104780 <memset>
80106c54:	58                   	pop    %eax
80106c55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c5b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c60:	5a                   	pop    %edx
80106c61:	6a 06                	push   $0x6
80106c63:	50                   	push   %eax
80106c64:	31 d2                	xor    %edx,%edx
80106c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c69:	e8 c2 fc ff ff       	call   80106930 <mappages>
80106c6e:	89 75 10             	mov    %esi,0x10(%ebp)
80106c71:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106c74:	83 c4 10             	add    $0x10,%esp
80106c77:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c7d:	5b                   	pop    %ebx
80106c7e:	5e                   	pop    %esi
80106c7f:	5f                   	pop    %edi
80106c80:	5d                   	pop    %ebp
80106c81:	e9 aa db ff ff       	jmp    80104830 <memmove>
80106c86:	83 ec 0c             	sub    $0xc,%esp
80106c89:	68 ed 7a 10 80       	push   $0x80107aed
80106c8e:	e8 fd 96 ff ff       	call   80100390 <panic>
80106c93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ca0 <loaduvm>:
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
80106ca6:	83 ec 0c             	sub    $0xc,%esp
80106ca9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106cb0:	0f 85 91 00 00 00    	jne    80106d47 <loaduvm+0xa7>
80106cb6:	8b 75 18             	mov    0x18(%ebp),%esi
80106cb9:	31 db                	xor    %ebx,%ebx
80106cbb:	85 f6                	test   %esi,%esi
80106cbd:	75 1a                	jne    80106cd9 <loaduvm+0x39>
80106cbf:	eb 6f                	jmp    80106d30 <loaduvm+0x90>
80106cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cc8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106cd4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106cd7:	76 57                	jbe    80106d30 <loaduvm+0x90>
80106cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cdc:	8b 45 08             	mov    0x8(%ebp),%eax
80106cdf:	31 c9                	xor    %ecx,%ecx
80106ce1:	01 da                	add    %ebx,%edx
80106ce3:	e8 c8 fb ff ff       	call   801068b0 <walkpgdir>
80106ce8:	85 c0                	test   %eax,%eax
80106cea:	74 4e                	je     80106d3a <loaduvm+0x9a>
80106cec:	8b 00                	mov    (%eax),%eax
80106cee:	8b 4d 14             	mov    0x14(%ebp),%ecx
80106cf1:	bf 00 10 00 00       	mov    $0x1000,%edi
80106cf6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cfb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d01:	0f 46 fe             	cmovbe %esi,%edi
80106d04:	01 d9                	add    %ebx,%ecx
80106d06:	05 00 00 00 80       	add    $0x80000000,%eax
80106d0b:	57                   	push   %edi
80106d0c:	51                   	push   %ecx
80106d0d:	50                   	push   %eax
80106d0e:	ff 75 10             	pushl  0x10(%ebp)
80106d11:	e8 7a af ff ff       	call   80101c90 <readi>
80106d16:	83 c4 10             	add    $0x10,%esp
80106d19:	39 f8                	cmp    %edi,%eax
80106d1b:	74 ab                	je     80106cc8 <loaduvm+0x28>
80106d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d25:	5b                   	pop    %ebx
80106d26:	5e                   	pop    %esi
80106d27:	5f                   	pop    %edi
80106d28:	5d                   	pop    %ebp
80106d29:	c3                   	ret    
80106d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d33:	31 c0                	xor    %eax,%eax
80106d35:	5b                   	pop    %ebx
80106d36:	5e                   	pop    %esi
80106d37:	5f                   	pop    %edi
80106d38:	5d                   	pop    %ebp
80106d39:	c3                   	ret    
80106d3a:	83 ec 0c             	sub    $0xc,%esp
80106d3d:	68 07 7b 10 80       	push   $0x80107b07
80106d42:	e8 49 96 ff ff       	call   80100390 <panic>
80106d47:	83 ec 0c             	sub    $0xc,%esp
80106d4a:	68 a8 7b 10 80       	push   $0x80107ba8
80106d4f:	e8 3c 96 ff ff       	call   80100390 <panic>
80106d54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d60 <allocuvm>:
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
80106d66:	83 ec 1c             	sub    $0x1c,%esp
80106d69:	8b 7d 10             	mov    0x10(%ebp),%edi
80106d6c:	85 ff                	test   %edi,%edi
80106d6e:	0f 88 8e 00 00 00    	js     80106e02 <allocuvm+0xa2>
80106d74:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d77:	0f 82 93 00 00 00    	jb     80106e10 <allocuvm+0xb0>
80106d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d80:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d86:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106d8c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106d8f:	0f 86 7e 00 00 00    	jbe    80106e13 <allocuvm+0xb3>
80106d95:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106d98:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d9b:	eb 42                	jmp    80106ddf <allocuvm+0x7f>
80106d9d:	8d 76 00             	lea    0x0(%esi),%esi
80106da0:	83 ec 04             	sub    $0x4,%esp
80106da3:	68 00 10 00 00       	push   $0x1000
80106da8:	6a 00                	push   $0x0
80106daa:	50                   	push   %eax
80106dab:	e8 d0 d9 ff ff       	call   80104780 <memset>
80106db0:	58                   	pop    %eax
80106db1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106db7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106dbc:	5a                   	pop    %edx
80106dbd:	6a 06                	push   $0x6
80106dbf:	50                   	push   %eax
80106dc0:	89 da                	mov    %ebx,%edx
80106dc2:	89 f8                	mov    %edi,%eax
80106dc4:	e8 67 fb ff ff       	call   80106930 <mappages>
80106dc9:	83 c4 10             	add    $0x10,%esp
80106dcc:	85 c0                	test   %eax,%eax
80106dce:	78 50                	js     80106e20 <allocuvm+0xc0>
80106dd0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dd6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106dd9:	0f 86 81 00 00 00    	jbe    80106e60 <allocuvm+0x100>
80106ddf:	e8 0c ba ff ff       	call   801027f0 <kalloc>
80106de4:	85 c0                	test   %eax,%eax
80106de6:	89 c6                	mov    %eax,%esi
80106de8:	75 b6                	jne    80106da0 <allocuvm+0x40>
80106dea:	83 ec 0c             	sub    $0xc,%esp
80106ded:	68 25 7b 10 80       	push   $0x80107b25
80106df2:	e8 69 98 ff ff       	call   80100660 <cprintf>
80106df7:	83 c4 10             	add    $0x10,%esp
80106dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dfd:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e00:	77 6e                	ja     80106e70 <allocuvm+0x110>
80106e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e05:	31 ff                	xor    %edi,%edi
80106e07:	89 f8                	mov    %edi,%eax
80106e09:	5b                   	pop    %ebx
80106e0a:	5e                   	pop    %esi
80106e0b:	5f                   	pop    %edi
80106e0c:	5d                   	pop    %ebp
80106e0d:	c3                   	ret    
80106e0e:	66 90                	xchg   %ax,%ax
80106e10:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106e13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e16:	89 f8                	mov    %edi,%eax
80106e18:	5b                   	pop    %ebx
80106e19:	5e                   	pop    %esi
80106e1a:	5f                   	pop    %edi
80106e1b:	5d                   	pop    %ebp
80106e1c:	c3                   	ret    
80106e1d:	8d 76 00             	lea    0x0(%esi),%esi
80106e20:	83 ec 0c             	sub    $0xc,%esp
80106e23:	68 3d 7b 10 80       	push   $0x80107b3d
80106e28:	e8 33 98 ff ff       	call   80100660 <cprintf>
80106e2d:	83 c4 10             	add    $0x10,%esp
80106e30:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e33:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e36:	76 0d                	jbe    80106e45 <allocuvm+0xe5>
80106e38:	89 c1                	mov    %eax,%ecx
80106e3a:	8b 55 10             	mov    0x10(%ebp),%edx
80106e3d:	8b 45 08             	mov    0x8(%ebp),%eax
80106e40:	e8 7b fb ff ff       	call   801069c0 <deallocuvm.part.0>
80106e45:	83 ec 0c             	sub    $0xc,%esp
80106e48:	31 ff                	xor    %edi,%edi
80106e4a:	56                   	push   %esi
80106e4b:	e8 f0 b7 ff ff       	call   80102640 <kfree>
80106e50:	83 c4 10             	add    $0x10,%esp
80106e53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e56:	89 f8                	mov    %edi,%eax
80106e58:	5b                   	pop    %ebx
80106e59:	5e                   	pop    %esi
80106e5a:	5f                   	pop    %edi
80106e5b:	5d                   	pop    %ebp
80106e5c:	c3                   	ret    
80106e5d:	8d 76 00             	lea    0x0(%esi),%esi
80106e60:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e66:	5b                   	pop    %ebx
80106e67:	89 f8                	mov    %edi,%eax
80106e69:	5e                   	pop    %esi
80106e6a:	5f                   	pop    %edi
80106e6b:	5d                   	pop    %ebp
80106e6c:	c3                   	ret    
80106e6d:	8d 76 00             	lea    0x0(%esi),%esi
80106e70:	89 c1                	mov    %eax,%ecx
80106e72:	8b 55 10             	mov    0x10(%ebp),%edx
80106e75:	8b 45 08             	mov    0x8(%ebp),%eax
80106e78:	31 ff                	xor    %edi,%edi
80106e7a:	e8 41 fb ff ff       	call   801069c0 <deallocuvm.part.0>
80106e7f:	eb 92                	jmp    80106e13 <allocuvm+0xb3>
80106e81:	eb 0d                	jmp    80106e90 <deallocuvm>
80106e83:	90                   	nop
80106e84:	90                   	nop
80106e85:	90                   	nop
80106e86:	90                   	nop
80106e87:	90                   	nop
80106e88:	90                   	nop
80106e89:	90                   	nop
80106e8a:	90                   	nop
80106e8b:	90                   	nop
80106e8c:	90                   	nop
80106e8d:	90                   	nop
80106e8e:	90                   	nop
80106e8f:	90                   	nop

80106e90 <deallocuvm>:
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e96:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e99:	8b 45 08             	mov    0x8(%ebp),%eax
80106e9c:	39 d1                	cmp    %edx,%ecx
80106e9e:	73 10                	jae    80106eb0 <deallocuvm+0x20>
80106ea0:	5d                   	pop    %ebp
80106ea1:	e9 1a fb ff ff       	jmp    801069c0 <deallocuvm.part.0>
80106ea6:	8d 76 00             	lea    0x0(%esi),%esi
80106ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106eb0:	89 d0                	mov    %edx,%eax
80106eb2:	5d                   	pop    %ebp
80106eb3:	c3                   	ret    
80106eb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106eba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ec0 <freevm>:
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 0c             	sub    $0xc,%esp
80106ec9:	8b 75 08             	mov    0x8(%ebp),%esi
80106ecc:	85 f6                	test   %esi,%esi
80106ece:	74 59                	je     80106f29 <freevm+0x69>
80106ed0:	31 c9                	xor    %ecx,%ecx
80106ed2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ed7:	89 f0                	mov    %esi,%eax
80106ed9:	e8 e2 fa ff ff       	call   801069c0 <deallocuvm.part.0>
80106ede:	89 f3                	mov    %esi,%ebx
80106ee0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ee6:	eb 0f                	jmp    80106ef7 <freevm+0x37>
80106ee8:	90                   	nop
80106ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ef0:	83 c3 04             	add    $0x4,%ebx
80106ef3:	39 fb                	cmp    %edi,%ebx
80106ef5:	74 23                	je     80106f1a <freevm+0x5a>
80106ef7:	8b 03                	mov    (%ebx),%eax
80106ef9:	a8 01                	test   $0x1,%al
80106efb:	74 f3                	je     80106ef0 <freevm+0x30>
80106efd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f02:	83 ec 0c             	sub    $0xc,%esp
80106f05:	83 c3 04             	add    $0x4,%ebx
80106f08:	05 00 00 00 80       	add    $0x80000000,%eax
80106f0d:	50                   	push   %eax
80106f0e:	e8 2d b7 ff ff       	call   80102640 <kfree>
80106f13:	83 c4 10             	add    $0x10,%esp
80106f16:	39 fb                	cmp    %edi,%ebx
80106f18:	75 dd                	jne    80106ef7 <freevm+0x37>
80106f1a:	89 75 08             	mov    %esi,0x8(%ebp)
80106f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f20:	5b                   	pop    %ebx
80106f21:	5e                   	pop    %esi
80106f22:	5f                   	pop    %edi
80106f23:	5d                   	pop    %ebp
80106f24:	e9 17 b7 ff ff       	jmp    80102640 <kfree>
80106f29:	83 ec 0c             	sub    $0xc,%esp
80106f2c:	68 59 7b 10 80       	push   $0x80107b59
80106f31:	e8 5a 94 ff ff       	call   80100390 <panic>
80106f36:	8d 76 00             	lea    0x0(%esi),%esi
80106f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f40 <setupkvm>:
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	56                   	push   %esi
80106f44:	53                   	push   %ebx
80106f45:	e8 a6 b8 ff ff       	call   801027f0 <kalloc>
80106f4a:	85 c0                	test   %eax,%eax
80106f4c:	89 c6                	mov    %eax,%esi
80106f4e:	74 42                	je     80106f92 <setupkvm+0x52>
80106f50:	83 ec 04             	sub    $0x4,%esp
80106f53:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106f58:	68 00 10 00 00       	push   $0x1000
80106f5d:	6a 00                	push   $0x0
80106f5f:	50                   	push   %eax
80106f60:	e8 1b d8 ff ff       	call   80104780 <memset>
80106f65:	83 c4 10             	add    $0x10,%esp
80106f68:	8b 43 04             	mov    0x4(%ebx),%eax
80106f6b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f6e:	83 ec 08             	sub    $0x8,%esp
80106f71:	8b 13                	mov    (%ebx),%edx
80106f73:	ff 73 0c             	pushl  0xc(%ebx)
80106f76:	50                   	push   %eax
80106f77:	29 c1                	sub    %eax,%ecx
80106f79:	89 f0                	mov    %esi,%eax
80106f7b:	e8 b0 f9 ff ff       	call   80106930 <mappages>
80106f80:	83 c4 10             	add    $0x10,%esp
80106f83:	85 c0                	test   %eax,%eax
80106f85:	78 19                	js     80106fa0 <setupkvm+0x60>
80106f87:	83 c3 10             	add    $0x10,%ebx
80106f8a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f90:	75 d6                	jne    80106f68 <setupkvm+0x28>
80106f92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f95:	89 f0                	mov    %esi,%eax
80106f97:	5b                   	pop    %ebx
80106f98:	5e                   	pop    %esi
80106f99:	5d                   	pop    %ebp
80106f9a:	c3                   	ret    
80106f9b:	90                   	nop
80106f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fa0:	83 ec 0c             	sub    $0xc,%esp
80106fa3:	56                   	push   %esi
80106fa4:	31 f6                	xor    %esi,%esi
80106fa6:	e8 15 ff ff ff       	call   80106ec0 <freevm>
80106fab:	83 c4 10             	add    $0x10,%esp
80106fae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fb1:	89 f0                	mov    %esi,%eax
80106fb3:	5b                   	pop    %ebx
80106fb4:	5e                   	pop    %esi
80106fb5:	5d                   	pop    %ebp
80106fb6:	c3                   	ret    
80106fb7:	89 f6                	mov    %esi,%esi
80106fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fc0 <kvmalloc>:
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	83 ec 08             	sub    $0x8,%esp
80106fc6:	e8 75 ff ff ff       	call   80106f40 <setupkvm>
80106fcb:	a3 64 57 11 80       	mov    %eax,0x80115764
80106fd0:	05 00 00 00 80       	add    $0x80000000,%eax
80106fd5:	0f 22 d8             	mov    %eax,%cr3
80106fd8:	c9                   	leave  
80106fd9:	c3                   	ret    
80106fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fe0 <clearpteu>:
80106fe0:	55                   	push   %ebp
80106fe1:	31 c9                	xor    %ecx,%ecx
80106fe3:	89 e5                	mov    %esp,%ebp
80106fe5:	83 ec 08             	sub    $0x8,%esp
80106fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106feb:	8b 45 08             	mov    0x8(%ebp),%eax
80106fee:	e8 bd f8 ff ff       	call   801068b0 <walkpgdir>
80106ff3:	85 c0                	test   %eax,%eax
80106ff5:	74 05                	je     80106ffc <clearpteu+0x1c>
80106ff7:	83 20 fb             	andl   $0xfffffffb,(%eax)
80106ffa:	c9                   	leave  
80106ffb:	c3                   	ret    
80106ffc:	83 ec 0c             	sub    $0xc,%esp
80106fff:	68 6a 7b 10 80       	push   $0x80107b6a
80107004:	e8 87 93 ff ff       	call   80100390 <panic>
80107009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107010 <copyuvm>:
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 1c             	sub    $0x1c,%esp
80107019:	e8 22 ff ff ff       	call   80106f40 <setupkvm>
8010701e:	85 c0                	test   %eax,%eax
80107020:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107023:	0f 84 9f 00 00 00    	je     801070c8 <copyuvm+0xb8>
80107029:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010702c:	85 c9                	test   %ecx,%ecx
8010702e:	0f 84 94 00 00 00    	je     801070c8 <copyuvm+0xb8>
80107034:	31 ff                	xor    %edi,%edi
80107036:	eb 4a                	jmp    80107082 <copyuvm+0x72>
80107038:	90                   	nop
80107039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107040:	83 ec 04             	sub    $0x4,%esp
80107043:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107049:	68 00 10 00 00       	push   $0x1000
8010704e:	53                   	push   %ebx
8010704f:	50                   	push   %eax
80107050:	e8 db d7 ff ff       	call   80104830 <memmove>
80107055:	58                   	pop    %eax
80107056:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010705c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107061:	5a                   	pop    %edx
80107062:	ff 75 e4             	pushl  -0x1c(%ebp)
80107065:	50                   	push   %eax
80107066:	89 fa                	mov    %edi,%edx
80107068:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010706b:	e8 c0 f8 ff ff       	call   80106930 <mappages>
80107070:	83 c4 10             	add    $0x10,%esp
80107073:	85 c0                	test   %eax,%eax
80107075:	78 61                	js     801070d8 <copyuvm+0xc8>
80107077:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010707d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107080:	76 46                	jbe    801070c8 <copyuvm+0xb8>
80107082:	8b 45 08             	mov    0x8(%ebp),%eax
80107085:	31 c9                	xor    %ecx,%ecx
80107087:	89 fa                	mov    %edi,%edx
80107089:	e8 22 f8 ff ff       	call   801068b0 <walkpgdir>
8010708e:	85 c0                	test   %eax,%eax
80107090:	74 61                	je     801070f3 <copyuvm+0xe3>
80107092:	8b 00                	mov    (%eax),%eax
80107094:	a8 01                	test   $0x1,%al
80107096:	74 4e                	je     801070e6 <copyuvm+0xd6>
80107098:	89 c3                	mov    %eax,%ebx
8010709a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010709f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801070a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070a8:	e8 43 b7 ff ff       	call   801027f0 <kalloc>
801070ad:	85 c0                	test   %eax,%eax
801070af:	89 c6                	mov    %eax,%esi
801070b1:	75 8d                	jne    80107040 <copyuvm+0x30>
801070b3:	83 ec 0c             	sub    $0xc,%esp
801070b6:	ff 75 e0             	pushl  -0x20(%ebp)
801070b9:	e8 02 fe ff ff       	call   80106ec0 <freevm>
801070be:	83 c4 10             	add    $0x10,%esp
801070c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801070c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ce:	5b                   	pop    %ebx
801070cf:	5e                   	pop    %esi
801070d0:	5f                   	pop    %edi
801070d1:	5d                   	pop    %ebp
801070d2:	c3                   	ret    
801070d3:	90                   	nop
801070d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070d8:	83 ec 0c             	sub    $0xc,%esp
801070db:	56                   	push   %esi
801070dc:	e8 5f b5 ff ff       	call   80102640 <kfree>
801070e1:	83 c4 10             	add    $0x10,%esp
801070e4:	eb cd                	jmp    801070b3 <copyuvm+0xa3>
801070e6:	83 ec 0c             	sub    $0xc,%esp
801070e9:	68 8e 7b 10 80       	push   $0x80107b8e
801070ee:	e8 9d 92 ff ff       	call   80100390 <panic>
801070f3:	83 ec 0c             	sub    $0xc,%esp
801070f6:	68 74 7b 10 80       	push   $0x80107b74
801070fb:	e8 90 92 ff ff       	call   80100390 <panic>

80107100 <uva2ka>:
80107100:	55                   	push   %ebp
80107101:	31 c9                	xor    %ecx,%ecx
80107103:	89 e5                	mov    %esp,%ebp
80107105:	83 ec 08             	sub    $0x8,%esp
80107108:	8b 55 0c             	mov    0xc(%ebp),%edx
8010710b:	8b 45 08             	mov    0x8(%ebp),%eax
8010710e:	e8 9d f7 ff ff       	call   801068b0 <walkpgdir>
80107113:	8b 00                	mov    (%eax),%eax
80107115:	c9                   	leave  
80107116:	89 c2                	mov    %eax,%edx
80107118:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010711d:	83 e2 05             	and    $0x5,%edx
80107120:	05 00 00 00 80       	add    $0x80000000,%eax
80107125:	83 fa 05             	cmp    $0x5,%edx
80107128:	ba 00 00 00 00       	mov    $0x0,%edx
8010712d:	0f 45 c2             	cmovne %edx,%eax
80107130:	c3                   	ret    
80107131:	eb 0d                	jmp    80107140 <copyout>
80107133:	90                   	nop
80107134:	90                   	nop
80107135:	90                   	nop
80107136:	90                   	nop
80107137:	90                   	nop
80107138:	90                   	nop
80107139:	90                   	nop
8010713a:	90                   	nop
8010713b:	90                   	nop
8010713c:	90                   	nop
8010713d:	90                   	nop
8010713e:	90                   	nop
8010713f:	90                   	nop

80107140 <copyout>:
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 1c             	sub    $0x1c,%esp
80107149:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010714c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010714f:	8b 7d 10             	mov    0x10(%ebp),%edi
80107152:	85 db                	test   %ebx,%ebx
80107154:	75 40                	jne    80107196 <copyout+0x56>
80107156:	eb 70                	jmp    801071c8 <copyout+0x88>
80107158:	90                   	nop
80107159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107160:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107163:	89 f1                	mov    %esi,%ecx
80107165:	29 d1                	sub    %edx,%ecx
80107167:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010716d:	39 d9                	cmp    %ebx,%ecx
8010716f:	0f 47 cb             	cmova  %ebx,%ecx
80107172:	29 f2                	sub    %esi,%edx
80107174:	83 ec 04             	sub    $0x4,%esp
80107177:	01 d0                	add    %edx,%eax
80107179:	51                   	push   %ecx
8010717a:	57                   	push   %edi
8010717b:	50                   	push   %eax
8010717c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010717f:	e8 ac d6 ff ff       	call   80104830 <memmove>
80107184:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107187:	83 c4 10             	add    $0x10,%esp
8010718a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
80107190:	01 cf                	add    %ecx,%edi
80107192:	29 cb                	sub    %ecx,%ebx
80107194:	74 32                	je     801071c8 <copyout+0x88>
80107196:	89 d6                	mov    %edx,%esi
80107198:	83 ec 08             	sub    $0x8,%esp
8010719b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010719e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801071a4:	56                   	push   %esi
801071a5:	ff 75 08             	pushl  0x8(%ebp)
801071a8:	e8 53 ff ff ff       	call   80107100 <uva2ka>
801071ad:	83 c4 10             	add    $0x10,%esp
801071b0:	85 c0                	test   %eax,%eax
801071b2:	75 ac                	jne    80107160 <copyout+0x20>
801071b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071bc:	5b                   	pop    %ebx
801071bd:	5e                   	pop    %esi
801071be:	5f                   	pop    %edi
801071bf:	5d                   	pop    %ebp
801071c0:	c3                   	ret    
801071c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071cb:	31 c0                	xor    %eax,%eax
801071cd:	5b                   	pop    %ebx
801071ce:	5e                   	pop    %esi
801071cf:	5f                   	pop    %edi
801071d0:	5d                   	pop    %ebp
801071d1:	c3                   	ret    
