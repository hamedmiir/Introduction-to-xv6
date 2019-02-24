
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
8010002d:	b8 b0 31 10 80       	mov    $0x801031b0,%eax
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
8010004c:	68 c0 71 10 80       	push   $0x801071c0
80100051:	68 00 b6 10 80       	push   $0x8010b600
80100056:	e8 b5 44 00 00       	call   80104510 <initlock>
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
80100092:	68 c7 71 10 80       	push   $0x801071c7
80100097:	50                   	push   %eax
80100098:	e8 43 43 00 00       	call   801043e0 <initsleeplock>
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
801000e4:	e8 67 45 00 00       	call   80104650 <acquire>
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
80100162:	e8 a9 45 00 00       	call   80104710 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 42 00 00       	call   80104420 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ad 22 00 00       	call   80102430 <iderw>
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
80100193:	68 ce 71 10 80       	push   $0x801071ce
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
801001ae:	e8 0d 43 00 00       	call   801044c0 <holdingsleep>
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
801001c4:	e9 67 22 00 00       	jmp    80102430 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 71 10 80       	push   $0x801071df
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
801001ef:	e8 cc 42 00 00       	call   801044c0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 42 00 00       	call   80104480 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010020b:	e8 40 44 00 00       	call   80104650 <acquire>
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
8010025c:	e9 af 44 00 00       	jmp    80104710 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 71 10 80       	push   $0x801071e6
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
80100280:	e8 eb 17 00 00       	call   80101a70 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
8010028c:	e8 bf 43 00 00       	call   80104650 <acquire>
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
801002c5:	e8 c6 3d 00 00       	call   80104090 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 ff 10 80    	mov    0x8010ffe0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 ff 10 80    	cmp    0x8010ffe4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 10 38 00 00       	call   80103af0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 60 a5 10 80       	push   $0x8010a560
801002ef:	e8 1c 44 00 00       	call   80104710 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 16 00 00       	call   80101990 <ilock>
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
8010034d:	e8 be 43 00 00       	call   80104710 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 16 00 00       	call   80101990 <ilock>
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
801003a9:	e8 92 26 00 00       	call   80102a40 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 71 10 80       	push   $0x801071ed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 37 7b 10 80 	movl   $0x80107b37,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 53 41 00 00       	call   80104530 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 72 10 80       	push   $0x80107201
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
8010043a:	e8 91 59 00 00       	call   80105dd0 <uartputc>
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
801004ec:	e8 df 58 00 00       	call   80105dd0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 d3 58 00 00       	call   80105dd0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 c7 58 00 00       	call   80105dd0 <uartputc>
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
80100524:	e8 e7 42 00 00       	call   80104810 <memmove>
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
80100541:	e8 1a 42 00 00       	call   80104760 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 72 10 80       	push   $0x80107205
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
801005b1:	0f b6 92 30 72 10 80 	movzbl -0x7fef8dd0(%edx),%edx
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
8010060f:	e8 5c 14 00 00       	call   80101a70 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
8010061b:	e8 30 40 00 00       	call   80104650 <acquire>
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
80100647:	e8 c4 40 00 00       	call   80104710 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 13 00 00       	call   80101990 <ilock>

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
8010071f:	e8 ec 3f 00 00       	call   80104710 <release>
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
801007d0:	ba 18 72 10 80       	mov    $0x80107218,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 60 a5 10 80       	push   $0x8010a560
801007f0:	e8 5b 3e 00 00       	call   80104650 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 72 10 80       	push   $0x8010721f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <InsertNewCmd>:
{
80100810:	55                   	push   %ebp
    int i = input.w % INPUT_BUF , temp_cur = history.cmd_count % 5;
80100811:	ba 67 66 66 66       	mov    $0x66666667,%edx
{
80100816:	89 e5                	mov    %esp,%ebp
80100818:	57                   	push   %edi
80100819:	56                   	push   %esi
8010081a:	53                   	push   %ebx
8010081b:	83 ec 10             	sub    $0x10,%esp
    int i = input.w % INPUT_BUF , temp_cur = history.cmd_count % 5;
8010081e:	8b 3d 34 a5 10 80    	mov    0x8010a534,%edi
80100824:	8b 1d e4 ff 10 80    	mov    0x8010ffe4,%ebx
    memset(temp_buf[temp_cur] ,'\0' ,INPUT_BUF * sizeof(char));
8010082a:	68 80 00 00 00       	push   $0x80
8010082f:	6a 00                	push   $0x0
    int i = input.w % INPUT_BUF , temp_cur = history.cmd_count % 5;
80100831:	89 f8                	mov    %edi,%eax
80100833:	83 e3 7f             	and    $0x7f,%ebx
80100836:	f7 ea                	imul   %edx
80100838:	89 f8                	mov    %edi,%eax
8010083a:	c1 f8 1f             	sar    $0x1f,%eax
8010083d:	d1 fa                	sar    %edx
8010083f:	29 c2                	sub    %eax,%edx
80100841:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100844:	29 c7                	sub    %eax,%edi
80100846:	c1 e7 07             	shl    $0x7,%edi
    memset(temp_buf[temp_cur] ,'\0' ,INPUT_BUF * sizeof(char));
80100849:	8d b7 00 00 11 80    	lea    -0x7fef0000(%edi),%esi
8010084f:	56                   	push   %esi
80100850:	e8 0b 3f 00 00       	call   80104760 <memset>
    while( i != ((input.e - 1)%INPUT_BUF)){
80100855:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
8010085a:	83 c4 10             	add    $0x10,%esp
    int j = 0;
8010085d:	31 d2                	xor    %edx,%edx
    while( i != ((input.e - 1)%INPUT_BUF)){
8010085f:	83 e8 01             	sub    $0x1,%eax
80100862:	83 e0 7f             	and    $0x7f,%eax
80100865:	39 d8                	cmp    %ebx,%eax
80100867:	74 22                	je     8010088b <InsertNewCmd+0x7b>
80100869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                  temp_buf[temp_cur][j] = input.buf[i];
80100870:	0f b6 8b 60 ff 10 80 	movzbl -0x7fef00a0(%ebx),%ecx
                  i = (i + 1) % INPUT_BUF;
80100877:	83 c3 01             	add    $0x1,%ebx
8010087a:	83 e3 7f             	and    $0x7f,%ebx
                  temp_buf[temp_cur][j] = input.buf[i];
8010087d:	88 8c 17 00 00 11 80 	mov    %cl,-0x7fef0000(%edi,%edx,1)
                  j++;
80100884:	83 c2 01             	add    $0x1,%edx
    while( i != ((input.e - 1)%INPUT_BUF)){
80100887:	39 c3                	cmp    %eax,%ebx
80100889:	75 e5                	jne    80100870 <InsertNewCmd+0x60>
8010088b:	b8 20 a5 10 80       	mov    $0x8010a520,%eax
      history.PervCmd[i] = history.PervCmd[i-1];
80100890:	8b 48 0c             	mov    0xc(%eax),%ecx
80100893:	83 e8 04             	sub    $0x4,%eax
80100896:	89 48 14             	mov    %ecx,0x14(%eax)
      history.size[i] = history.size[i-1];
80100899:	8b 48 2c             	mov    0x2c(%eax),%ecx
8010089c:	89 48 30             	mov    %ecx,0x30(%eax)
    for(int i = 4 ; i > 0 ; i--){
8010089f:	3d 10 a5 10 80       	cmp    $0x8010a510,%eax
801008a4:	75 ea                	jne    80100890 <InsertNewCmd+0x80>
    history.PervCmd[0] = temp_buf[temp_cur];
801008a6:	89 35 20 a5 10 80    	mov    %esi,0x8010a520
    history.size[0] = j;
801008ac:	89 15 3c a5 10 80    	mov    %edx,0x8010a53c
}
801008b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008b5:	5b                   	pop    %ebx
801008b6:	5e                   	pop    %esi
801008b7:	5f                   	pop    %edi
801008b8:	5d                   	pop    %ebp
801008b9:	c3                   	ret    
801008ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801008c0 <killLine>:
  while(input.e != input.w &&
801008c0:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
801008c5:	3b 05 e4 ff 10 80    	cmp    0x8010ffe4,%eax
801008cb:	74 53                	je     80100920 <killLine+0x60>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008cd:	83 e8 01             	sub    $0x1,%eax
801008d0:	89 c2                	mov    %eax,%edx
801008d2:	83 e2 7f             	and    $0x7f,%edx
  while(input.e != input.w &&
801008d5:	80 ba 60 ff 10 80 0a 	cmpb   $0xa,-0x7fef00a0(%edx)
801008dc:	74 42                	je     80100920 <killLine+0x60>
{
801008de:	55                   	push   %ebp
801008df:	89 e5                	mov    %esp,%ebp
801008e1:	83 ec 08             	sub    $0x8,%esp
801008e4:	eb 1b                	jmp    80100901 <killLine+0x41>
801008e6:	8d 76 00             	lea    0x0(%esi),%esi
801008e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f0:	83 e8 01             	sub    $0x1,%eax
801008f3:	89 c2                	mov    %eax,%edx
801008f5:	83 e2 7f             	and    $0x7f,%edx
  while(input.e != input.w &&
801008f8:	80 ba 60 ff 10 80 0a 	cmpb   $0xa,-0x7fef00a0(%edx)
801008ff:	74 1c                	je     8010091d <killLine+0x5d>
        input.e--;
80100901:	a3 e8 ff 10 80       	mov    %eax,0x8010ffe8
        consputc(BACKSPACE);
80100906:	b8 00 01 00 00       	mov    $0x100,%eax
8010090b:	e8 00 fb ff ff       	call   80100410 <consputc>
  while(input.e != input.w &&
80100910:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100915:	3b 05 e4 ff 10 80    	cmp    0x8010ffe4,%eax
8010091b:	75 d3                	jne    801008f0 <killLine+0x30>
}
8010091d:	c9                   	leave  
8010091e:	c3                   	ret    
8010091f:	90                   	nop
80100920:	f3 c3                	repz ret 
80100922:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100930 <fillBuf>:
{
80100930:	55                   	push   %ebp
80100931:	89 e5                	mov    %esp,%ebp
80100933:	56                   	push   %esi
80100934:	53                   	push   %ebx
  killLine();
80100935:	e8 86 ff ff ff       	call   801008c0 <killLine>
  for(int i = 0; i < history.size[history.cursor] ; i++)
8010093a:	a1 38 a5 10 80       	mov    0x8010a538,%eax
8010093f:	8b 1c 85 3c a5 10 80 	mov    -0x7fef5ac4(,%eax,4),%ebx
80100946:	85 db                	test   %ebx,%ebx
80100948:	7e 32                	jle    8010097c <fillBuf+0x4c>
    input.buf[input.e++ % INPUT_BUF] = history.PervCmd[history.cursor][i];
8010094a:	8b 34 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%esi
80100951:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100956:	01 c3                	add    %eax,%ebx
80100958:	29 c6                	sub    %eax,%esi
8010095a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100960:	8d 50 01             	lea    0x1(%eax),%edx
80100963:	89 15 e8 ff 10 80    	mov    %edx,0x8010ffe8
80100969:	0f b6 0c 30          	movzbl (%eax,%esi,1),%ecx
8010096d:	83 e0 7f             	and    $0x7f,%eax
  for(int i = 0; i < history.size[history.cursor] ; i++)
80100970:	39 da                	cmp    %ebx,%edx
    input.buf[input.e++ % INPUT_BUF] = history.PervCmd[history.cursor][i];
80100972:	88 88 60 ff 10 80    	mov    %cl,-0x7fef00a0(%eax)
80100978:	89 d0                	mov    %edx,%eax
  for(int i = 0; i < history.size[history.cursor] ; i++)
8010097a:	75 e4                	jne    80100960 <fillBuf+0x30>
}
8010097c:	5b                   	pop    %ebx
8010097d:	5e                   	pop    %esi
8010097e:	5d                   	pop    %ebp
8010097f:	c3                   	ret    

80100980 <IncCursor>:
  if (history.cursor == 4)
80100980:	8b 0d 38 a5 10 80    	mov    0x8010a538,%ecx
{
80100986:	55                   	push   %ebp
80100987:	89 e5                	mov    %esp,%ebp
  if (history.cursor == 4)
80100989:	83 f9 04             	cmp    $0x4,%ecx
8010098c:	74 2a                	je     801009b8 <IncCursor+0x38>
  history.cursor = (history.cursor + 1) % 5;
8010098e:	83 c1 01             	add    $0x1,%ecx
80100991:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100996:	89 c8                	mov    %ecx,%eax
80100998:	f7 ea                	imul   %edx
8010099a:	89 c8                	mov    %ecx,%eax
8010099c:	c1 f8 1f             	sar    $0x1f,%eax
8010099f:	d1 fa                	sar    %edx
801009a1:	29 c2                	sub    %eax,%edx
801009a3:	8d 04 92             	lea    (%edx,%edx,4),%eax
801009a6:	29 c1                	sub    %eax,%ecx
      if ( history.cursor == history.cmd_count) 
801009a8:	3b 0d 34 a5 10 80    	cmp    0x8010a534,%ecx
  history.cursor = (history.cursor + 1) % 5;
801009ae:	89 ca                	mov    %ecx,%edx
801009b0:	89 0d 38 a5 10 80    	mov    %ecx,0x8010a538
      if ( history.cursor == history.cmd_count) 
801009b6:	74 08                	je     801009c0 <IncCursor+0x40>
}
801009b8:	5d                   	pop    %ebp
801009b9:	c3                   	ret    
801009ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        history.cursor = history.cmd_count - 1;
801009c0:	83 ea 01             	sub    $0x1,%edx
801009c3:	89 15 38 a5 10 80    	mov    %edx,0x8010a538
}
801009c9:	5d                   	pop    %ebp
801009ca:	c3                   	ret    
801009cb:	90                   	nop
801009cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009d0 <DecCursor>:
  if ( history.cursor < 0)
801009d0:	a1 38 a5 10 80       	mov    0x8010a538,%eax
{
801009d5:	55                   	push   %ebp
801009d6:	89 e5                	mov    %esp,%ebp
  if ( history.cursor < 0)
801009d8:	85 c0                	test   %eax,%eax
801009da:	78 08                	js     801009e4 <DecCursor+0x14>
  history.cursor = history.cursor - 1;
801009dc:	83 e8 01             	sub    $0x1,%eax
801009df:	a3 38 a5 10 80       	mov    %eax,0x8010a538
}
801009e4:	5d                   	pop    %ebp
801009e5:	c3                   	ret    
801009e6:	8d 76 00             	lea    0x0(%esi),%esi
801009e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009f0 <printInput>:
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	53                   	push   %ebx
801009f4:	83 ec 04             	sub    $0x4,%esp
  int i = input.w % INPUT_BUF;
801009f7:	8b 1d e4 ff 10 80    	mov    0x8010ffe4,%ebx
801009fd:	eb 10                	jmp    80100a0f <printInput+0x1f>
801009ff:	90                   	nop
    consputc(input.buf[i]);
80100a00:	0f be 83 60 ff 10 80 	movsbl -0x7fef00a0(%ebx),%eax
    i = (i + 1) % INPUT_BUF;
80100a07:	83 c3 01             	add    $0x1,%ebx
    consputc(input.buf[i]);
80100a0a:	e8 01 fa ff ff       	call   80100410 <consputc>
  while( i != (input.e % INPUT_BUF)){ 
80100a0f:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
  int i = input.w % INPUT_BUF;
80100a14:	83 e3 7f             	and    $0x7f,%ebx
  while( i != (input.e % INPUT_BUF)){ 
80100a17:	83 e0 7f             	and    $0x7f,%eax
80100a1a:	39 d8                	cmp    %ebx,%eax
80100a1c:	75 e2                	jne    80100a00 <printInput+0x10>
}
80100a1e:	83 c4 04             	add    $0x4,%esp
80100a21:	5b                   	pop    %ebx
80100a22:	5d                   	pop    %ebp
80100a23:	c3                   	ret    
80100a24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100a30 <KeyDownPressed.part.0>:
if (history.cursor == -1){
80100a30:	a1 38 a5 10 80       	mov    0x8010a538,%eax
80100a35:	83 f8 ff             	cmp    $0xffffffff,%eax
80100a38:	74 1e                	je     80100a58 <KeyDownPressed.part.0+0x28>
KeyDownPressed()
80100a3a:	55                   	push   %ebp
80100a3b:	89 e5                	mov    %esp,%ebp
80100a3d:	83 ec 08             	sub    $0x8,%esp
  if ( history.cursor < 0)
80100a40:	85 c0                	test   %eax,%eax
80100a42:	78 08                	js     80100a4c <KeyDownPressed.part.0+0x1c>
  history.cursor = history.cursor - 1;
80100a44:	83 e8 01             	sub    $0x1,%eax
80100a47:	a3 38 a5 10 80       	mov    %eax,0x8010a538
  fillBuf();
80100a4c:	e8 df fe ff ff       	call   80100930 <fillBuf>
}
80100a51:	c9                   	leave  
  printInput();
80100a52:	eb 9c                	jmp    801009f0 <printInput>
80100a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  killLine();
80100a58:	e9 63 fe ff ff       	jmp    801008c0 <killLine>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi

80100a60 <KeyUpPressed>:
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	53                   	push   %ebx
80100a64:	83 ec 04             	sub    $0x4,%esp
  if ( history.cmd_count == 0) 
80100a67:	8b 1d 34 a5 10 80    	mov    0x8010a534,%ebx
80100a6d:	85 db                	test   %ebx,%ebx
80100a6f:	74 47                	je     80100ab8 <KeyUpPressed+0x58>
  if (history.cursor == 4)
80100a71:	8b 0d 38 a5 10 80    	mov    0x8010a538,%ecx
80100a77:	83 f9 04             	cmp    $0x4,%ecx
80100a7a:	74 2a                	je     80100aa6 <KeyUpPressed+0x46>
  history.cursor = (history.cursor + 1) % 5;
80100a7c:	83 c1 01             	add    $0x1,%ecx
80100a7f:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100a84:	89 c8                	mov    %ecx,%eax
80100a86:	f7 ea                	imul   %edx
80100a88:	89 c8                	mov    %ecx,%eax
80100a8a:	c1 f8 1f             	sar    $0x1f,%eax
80100a8d:	d1 fa                	sar    %edx
80100a8f:	29 c2                	sub    %eax,%edx
80100a91:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100a94:	29 c1                	sub    %eax,%ecx
80100a96:	8d 43 ff             	lea    -0x1(%ebx),%eax
80100a99:	89 ca                	mov    %ecx,%edx
80100a9b:	39 cb                	cmp    %ecx,%ebx
80100a9d:	0f 44 d0             	cmove  %eax,%edx
80100aa0:	89 15 38 a5 10 80    	mov    %edx,0x8010a538
  fillBuf();
80100aa6:	e8 85 fe ff ff       	call   80100930 <fillBuf>
}
80100aab:	83 c4 04             	add    $0x4,%esp
80100aae:	5b                   	pop    %ebx
80100aaf:	5d                   	pop    %ebp
  printInput();
80100ab0:	e9 3b ff ff ff       	jmp    801009f0 <printInput>
80100ab5:	8d 76 00             	lea    0x0(%esi),%esi
}
80100ab8:	83 c4 04             	add    $0x4,%esp
80100abb:	5b                   	pop    %ebx
80100abc:	5d                   	pop    %ebp
80100abd:	c3                   	ret    
80100abe:	66 90                	xchg   %ax,%ax

80100ac0 <KeyDownPressed>:
  if ( history.cmd_count == 0) 
80100ac0:	a1 34 a5 10 80       	mov    0x8010a534,%eax
{
80100ac5:	55                   	push   %ebp
80100ac6:	89 e5                	mov    %esp,%ebp
  if ( history.cmd_count == 0) 
80100ac8:	85 c0                	test   %eax,%eax
80100aca:	74 0c                	je     80100ad8 <KeyDownPressed+0x18>
}
80100acc:	5d                   	pop    %ebp
80100acd:	e9 5e ff ff ff       	jmp    80100a30 <KeyDownPressed.part.0>
80100ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ad8:	5d                   	pop    %ebp
80100ad9:	c3                   	ret    
80100ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ae0 <consoleintr>:
{
80100ae0:	55                   	push   %ebp
80100ae1:	89 e5                	mov    %esp,%ebp
80100ae3:	57                   	push   %edi
80100ae4:	56                   	push   %esi
80100ae5:	53                   	push   %ebx
  int c, doprocdump = 0;
80100ae6:	31 ff                	xor    %edi,%edi
{
80100ae8:	83 ec 18             	sub    $0x18,%esp
80100aeb:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
80100aee:	68 60 a5 10 80       	push   $0x8010a560
80100af3:	e8 58 3b 00 00       	call   80104650 <acquire>
  while((c = getc()) >= 0){
80100af8:	83 c4 10             	add    $0x10,%esp
80100afb:	90                   	nop
80100afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b00:	ff d6                	call   *%esi
80100b02:	85 c0                	test   %eax,%eax
80100b04:	89 c3                	mov    %eax,%ebx
80100b06:	0f 88 b4 00 00 00    	js     80100bc0 <consoleintr+0xe0>
    switch(c){
80100b0c:	83 fb 15             	cmp    $0x15,%ebx
80100b0f:	0f 84 cb 00 00 00    	je     80100be0 <consoleintr+0x100>
80100b15:	0f 8e 85 00 00 00    	jle    80100ba0 <consoleintr+0xc0>
80100b1b:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
80100b21:	0f 84 19 01 00 00    	je     80100c40 <consoleintr+0x160>
80100b27:	81 fb e3 00 00 00    	cmp    $0xe3,%ebx
80100b2d:	0f 84 ed 00 00 00    	je     80100c20 <consoleintr+0x140>
80100b33:	83 fb 7f             	cmp    $0x7f,%ebx
80100b36:	0f 84 b4 00 00 00    	je     80100bf0 <consoleintr+0x110>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100b3c:	85 db                	test   %ebx,%ebx
80100b3e:	74 c0                	je     80100b00 <consoleintr+0x20>
80100b40:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100b45:	89 c2                	mov    %eax,%edx
80100b47:	2b 15 e0 ff 10 80    	sub    0x8010ffe0,%edx
80100b4d:	83 fa 7f             	cmp    $0x7f,%edx
80100b50:	77 ae                	ja     80100b00 <consoleintr+0x20>
80100b52:	8d 50 01             	lea    0x1(%eax),%edx
80100b55:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100b58:	83 fb 0d             	cmp    $0xd,%ebx
        input.buf[input.e++ % INPUT_BUF] = c;
80100b5b:	89 15 e8 ff 10 80    	mov    %edx,0x8010ffe8
        c = (c == '\r') ? '\n' : c;
80100b61:	0f 84 f9 00 00 00    	je     80100c60 <consoleintr+0x180>
        input.buf[input.e++ % INPUT_BUF] = c;
80100b67:	88 98 60 ff 10 80    	mov    %bl,-0x7fef00a0(%eax)
        consputc(c);
80100b6d:	89 d8                	mov    %ebx,%eax
80100b6f:	e8 9c f8 ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100b74:	83 fb 0a             	cmp    $0xa,%ebx
80100b77:	0f 84 f4 00 00 00    	je     80100c71 <consoleintr+0x191>
80100b7d:	83 fb 04             	cmp    $0x4,%ebx
80100b80:	0f 84 eb 00 00 00    	je     80100c71 <consoleintr+0x191>
80100b86:	a1 e0 ff 10 80       	mov    0x8010ffe0,%eax
80100b8b:	83 e8 80             	sub    $0xffffff80,%eax
80100b8e:	39 05 e8 ff 10 80    	cmp    %eax,0x8010ffe8
80100b94:	0f 85 66 ff ff ff    	jne    80100b00 <consoleintr+0x20>
80100b9a:	e9 d7 00 00 00       	jmp    80100c76 <consoleintr+0x196>
80100b9f:	90                   	nop
    switch(c){
80100ba0:	83 fb 08             	cmp    $0x8,%ebx
80100ba3:	74 4b                	je     80100bf0 <consoleintr+0x110>
80100ba5:	83 fb 10             	cmp    $0x10,%ebx
80100ba8:	75 92                	jne    80100b3c <consoleintr+0x5c>
  while((c = getc()) >= 0){
80100baa:	ff d6                	call   *%esi
80100bac:	85 c0                	test   %eax,%eax
      doprocdump = 1;
80100bae:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
80100bb3:	89 c3                	mov    %eax,%ebx
80100bb5:	0f 89 51 ff ff ff    	jns    80100b0c <consoleintr+0x2c>
80100bbb:	90                   	nop
80100bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100bc0:	83 ec 0c             	sub    $0xc,%esp
80100bc3:	68 60 a5 10 80       	push   $0x8010a560
80100bc8:	e8 43 3b 00 00       	call   80104710 <release>
  if(doprocdump) {
80100bcd:	83 c4 10             	add    $0x10,%esp
80100bd0:	85 ff                	test   %edi,%edi
80100bd2:	75 7c                	jne    80100c50 <consoleintr+0x170>
}
80100bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100bd7:	5b                   	pop    %ebx
80100bd8:	5e                   	pop    %esi
80100bd9:	5f                   	pop    %edi
80100bda:	5d                   	pop    %ebp
80100bdb:	c3                   	ret    
80100bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      killLine();
80100be0:	e8 db fc ff ff       	call   801008c0 <killLine>
      break;
80100be5:	e9 16 ff ff ff       	jmp    80100b00 <consoleintr+0x20>
80100bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
80100bf0:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100bf5:	3b 05 e4 ff 10 80    	cmp    0x8010ffe4,%eax
80100bfb:	0f 84 ff fe ff ff    	je     80100b00 <consoleintr+0x20>
        input.e--;
80100c01:	83 e8 01             	sub    $0x1,%eax
80100c04:	a3 e8 ff 10 80       	mov    %eax,0x8010ffe8
        consputc(BACKSPACE);
80100c09:	b8 00 01 00 00       	mov    $0x100,%eax
80100c0e:	e8 fd f7 ff ff       	call   80100410 <consputc>
80100c13:	e9 e8 fe ff ff       	jmp    80100b00 <consoleintr+0x20>
80100c18:	90                   	nop
80100c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if ( history.cmd_count == 0) 
80100c20:	a1 34 a5 10 80       	mov    0x8010a534,%eax
80100c25:	85 c0                	test   %eax,%eax
80100c27:	0f 84 d3 fe ff ff    	je     80100b00 <consoleintr+0x20>
80100c2d:	e8 fe fd ff ff       	call   80100a30 <KeyDownPressed.part.0>
80100c32:	e9 c9 fe ff ff       	jmp    80100b00 <consoleintr+0x20>
80100c37:	89 f6                	mov    %esi,%esi
80100c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      KeyUpPressed();
80100c40:	e8 1b fe ff ff       	call   80100a60 <KeyUpPressed>
      break;
80100c45:	e9 b6 fe ff ff       	jmp    80100b00 <consoleintr+0x20>
80100c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c53:	5b                   	pop    %ebx
80100c54:	5e                   	pop    %esi
80100c55:	5f                   	pop    %edi
80100c56:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100c57:	e9 c4 36 00 00       	jmp    80104320 <procdump>
80100c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100c60:	c6 80 60 ff 10 80 0a 	movb   $0xa,-0x7fef00a0(%eax)
        consputc(c);
80100c67:	b8 0a 00 00 00       	mov    $0xa,%eax
80100c6c:	e8 9f f7 ff ff       	call   80100410 <consputc>
80100c71:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
          if ( (input.e - input.w) != 1) {
80100c76:	89 c2                	mov    %eax,%edx
80100c78:	2b 15 e4 ff 10 80    	sub    0x8010ffe4,%edx
80100c7e:	83 fa 01             	cmp    $0x1,%edx
80100c81:	74 1b                	je     80100c9e <consoleintr+0x1be>
            InsertNewCmd();
80100c83:	e8 88 fb ff ff       	call   80100810 <InsertNewCmd>
            history.cmd_count++;
80100c88:	83 05 34 a5 10 80 01 	addl   $0x1,0x8010a534
80100c8f:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
            history.cursor = -1;
80100c94:	c7 05 38 a5 10 80 ff 	movl   $0xffffffff,0x8010a538
80100c9b:	ff ff ff 
          wakeup(&input.r);
80100c9e:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100ca1:	a3 e4 ff 10 80       	mov    %eax,0x8010ffe4
          wakeup(&input.r);
80100ca6:	68 e0 ff 10 80       	push   $0x8010ffe0
80100cab:	e8 90 35 00 00       	call   80104240 <wakeup>
80100cb0:	83 c4 10             	add    $0x10,%esp
80100cb3:	e9 48 fe ff ff       	jmp    80100b00 <consoleintr+0x20>
80100cb8:	90                   	nop
80100cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100cc0 <consoleinit>:

void
consoleinit(void)
{
80100cc0:	55                   	push   %ebp
80100cc1:	89 e5                	mov    %esp,%ebp
80100cc3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100cc6:	68 28 72 10 80       	push   $0x80107228
80100ccb:	68 60 a5 10 80       	push   $0x8010a560
80100cd0:	e8 3b 38 00 00       	call   80104510 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100cd5:	58                   	pop    %eax
80100cd6:	5a                   	pop    %edx
80100cd7:	6a 00                	push   $0x0
80100cd9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100cdb:	c7 05 2c 0c 11 80 00 	movl   $0x80100600,0x80110c2c
80100ce2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100ce5:	c7 05 28 0c 11 80 70 	movl   $0x80100270,0x80110c28
80100cec:	02 10 80 
  cons.locking = 1;
80100cef:	c7 05 94 a5 10 80 01 	movl   $0x1,0x8010a594
80100cf6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100cf9:	e8 e2 18 00 00       	call   801025e0 <ioapicenable>
}
80100cfe:	83 c4 10             	add    $0x10,%esp
80100d01:	c9                   	leave  
80100d02:	c3                   	ret    
80100d03:	66 90                	xchg   %ax,%ax
80100d05:	66 90                	xchg   %ax,%ax
80100d07:	66 90                	xchg   %ax,%ax
80100d09:	66 90                	xchg   %ax,%ax
80100d0b:	66 90                	xchg   %ax,%ax
80100d0d:	66 90                	xchg   %ax,%ax
80100d0f:	90                   	nop

80100d10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100d10:	55                   	push   %ebp
80100d11:	89 e5                	mov    %esp,%ebp
80100d13:	57                   	push   %edi
80100d14:	56                   	push   %esi
80100d15:	53                   	push   %ebx
80100d16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100d1c:	e8 cf 2d 00 00       	call   80103af0 <myproc>
80100d21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100d27:	e8 84 21 00 00       	call   80102eb0 <begin_op>

  if((ip = namei(path)) == 0){
80100d2c:	83 ec 0c             	sub    $0xc,%esp
80100d2f:	ff 75 08             	pushl  0x8(%ebp)
80100d32:	e8 b9 14 00 00       	call   801021f0 <namei>
80100d37:	83 c4 10             	add    $0x10,%esp
80100d3a:	85 c0                	test   %eax,%eax
80100d3c:	0f 84 91 01 00 00    	je     80100ed3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100d42:	83 ec 0c             	sub    $0xc,%esp
80100d45:	89 c3                	mov    %eax,%ebx
80100d47:	50                   	push   %eax
80100d48:	e8 43 0c 00 00       	call   80101990 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100d4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100d53:	6a 34                	push   $0x34
80100d55:	6a 00                	push   $0x0
80100d57:	50                   	push   %eax
80100d58:	53                   	push   %ebx
80100d59:	e8 12 0f 00 00       	call   80101c70 <readi>
80100d5e:	83 c4 20             	add    $0x20,%esp
80100d61:	83 f8 34             	cmp    $0x34,%eax
80100d64:	74 22                	je     80100d88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100d66:	83 ec 0c             	sub    $0xc,%esp
80100d69:	53                   	push   %ebx
80100d6a:	e8 b1 0e 00 00       	call   80101c20 <iunlockput>
    end_op();
80100d6f:	e8 ac 21 00 00       	call   80102f20 <end_op>
80100d74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100d77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d7f:	5b                   	pop    %ebx
80100d80:	5e                   	pop    %esi
80100d81:	5f                   	pop    %edi
80100d82:	5d                   	pop    %ebp
80100d83:	c3                   	ret    
80100d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100d88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100d8f:	45 4c 46 
80100d92:	75 d2                	jne    80100d66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100d94:	e8 87 61 00 00       	call   80106f20 <setupkvm>
80100d99:	85 c0                	test   %eax,%eax
80100d9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100da1:	74 c3                	je     80100d66 <exec+0x56>
  sz = 0;
80100da3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100da5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100dac:	00 
80100dad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100db3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100db9:	0f 84 8c 02 00 00    	je     8010104b <exec+0x33b>
80100dbf:	31 f6                	xor    %esi,%esi
80100dc1:	eb 7f                	jmp    80100e42 <exec+0x132>
80100dc3:	90                   	nop
80100dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100dc8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100dcf:	75 63                	jne    80100e34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100dd1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100dd7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ddd:	0f 82 86 00 00 00    	jb     80100e69 <exec+0x159>
80100de3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100de9:	72 7e                	jb     80100e69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100deb:	83 ec 04             	sub    $0x4,%esp
80100dee:	50                   	push   %eax
80100def:	57                   	push   %edi
80100df0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100df6:	e8 45 5f 00 00       	call   80106d40 <allocuvm>
80100dfb:	83 c4 10             	add    $0x10,%esp
80100dfe:	85 c0                	test   %eax,%eax
80100e00:	89 c7                	mov    %eax,%edi
80100e02:	74 65                	je     80100e69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100e04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100e0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100e0f:	75 58                	jne    80100e69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100e11:	83 ec 0c             	sub    $0xc,%esp
80100e14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100e1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100e20:	53                   	push   %ebx
80100e21:	50                   	push   %eax
80100e22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100e28:	e8 53 5e 00 00       	call   80106c80 <loaduvm>
80100e2d:	83 c4 20             	add    $0x20,%esp
80100e30:	85 c0                	test   %eax,%eax
80100e32:	78 35                	js     80100e69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100e3b:	83 c6 01             	add    $0x1,%esi
80100e3e:	39 f0                	cmp    %esi,%eax
80100e40:	7e 3d                	jle    80100e7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100e42:	89 f0                	mov    %esi,%eax
80100e44:	6a 20                	push   $0x20
80100e46:	c1 e0 05             	shl    $0x5,%eax
80100e49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100e4f:	50                   	push   %eax
80100e50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100e56:	50                   	push   %eax
80100e57:	53                   	push   %ebx
80100e58:	e8 13 0e 00 00       	call   80101c70 <readi>
80100e5d:	83 c4 10             	add    $0x10,%esp
80100e60:	83 f8 20             	cmp    $0x20,%eax
80100e63:	0f 84 5f ff ff ff    	je     80100dc8 <exec+0xb8>
    freevm(pgdir);
80100e69:	83 ec 0c             	sub    $0xc,%esp
80100e6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100e72:	e8 29 60 00 00       	call   80106ea0 <freevm>
80100e77:	83 c4 10             	add    $0x10,%esp
80100e7a:	e9 e7 fe ff ff       	jmp    80100d66 <exec+0x56>
80100e7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100e85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100e8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100e91:	83 ec 0c             	sub    $0xc,%esp
80100e94:	53                   	push   %ebx
80100e95:	e8 86 0d 00 00       	call   80101c20 <iunlockput>
  end_op();
80100e9a:	e8 81 20 00 00       	call   80102f20 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e9f:	83 c4 0c             	add    $0xc,%esp
80100ea2:	56                   	push   %esi
80100ea3:	57                   	push   %edi
80100ea4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100eaa:	e8 91 5e 00 00       	call   80106d40 <allocuvm>
80100eaf:	83 c4 10             	add    $0x10,%esp
80100eb2:	85 c0                	test   %eax,%eax
80100eb4:	89 c6                	mov    %eax,%esi
80100eb6:	75 3a                	jne    80100ef2 <exec+0x1e2>
    freevm(pgdir);
80100eb8:	83 ec 0c             	sub    $0xc,%esp
80100ebb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ec1:	e8 da 5f 00 00       	call   80106ea0 <freevm>
80100ec6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ec9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ece:	e9 a9 fe ff ff       	jmp    80100d7c <exec+0x6c>
    end_op();
80100ed3:	e8 48 20 00 00       	call   80102f20 <end_op>
    cprintf("exec: fail\n");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 41 72 10 80       	push   $0x80107241
80100ee0:	e8 7b f7 ff ff       	call   80100660 <cprintf>
    return -1;
80100ee5:	83 c4 10             	add    $0x10,%esp
80100ee8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100eed:	e9 8a fe ff ff       	jmp    80100d7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ef2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100ef8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100efb:	31 ff                	xor    %edi,%edi
80100efd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100eff:	50                   	push   %eax
80100f00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100f06:	e8 b5 60 00 00       	call   80106fc0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0e:	83 c4 10             	add    $0x10,%esp
80100f11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100f17:	8b 00                	mov    (%eax),%eax
80100f19:	85 c0                	test   %eax,%eax
80100f1b:	74 70                	je     80100f8d <exec+0x27d>
80100f1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100f23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100f29:	eb 0a                	jmp    80100f35 <exec+0x225>
80100f2b:	90                   	nop
80100f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100f30:	83 ff 20             	cmp    $0x20,%edi
80100f33:	74 83                	je     80100eb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f35:	83 ec 0c             	sub    $0xc,%esp
80100f38:	50                   	push   %eax
80100f39:	e8 42 3a 00 00       	call   80104980 <strlen>
80100f3e:	f7 d0                	not    %eax
80100f40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100f4c:	e8 2f 3a 00 00       	call   80104980 <strlen>
80100f51:	83 c0 01             	add    $0x1,%eax
80100f54:	50                   	push   %eax
80100f55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100f5b:	53                   	push   %ebx
80100f5c:	56                   	push   %esi
80100f5d:	e8 be 61 00 00       	call   80107120 <copyout>
80100f62:	83 c4 20             	add    $0x20,%esp
80100f65:	85 c0                	test   %eax,%eax
80100f67:	0f 88 4b ff ff ff    	js     80100eb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100f70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100f77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100f7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100f80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100f83:	85 c0                	test   %eax,%eax
80100f85:	75 a9                	jne    80100f30 <exec+0x220>
80100f87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100f94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100f96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100f9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100fa1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100fa8:	ff ff ff 
  ustack[1] = argc;
80100fab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100fb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100fb3:	83 c0 0c             	add    $0xc,%eax
80100fb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100fb8:	50                   	push   %eax
80100fb9:	52                   	push   %edx
80100fba:	53                   	push   %ebx
80100fbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100fc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100fc7:	e8 54 61 00 00       	call   80107120 <copyout>
80100fcc:	83 c4 10             	add    $0x10,%esp
80100fcf:	85 c0                	test   %eax,%eax
80100fd1:	0f 88 e1 fe ff ff    	js     80100eb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100fd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100fda:	0f b6 00             	movzbl (%eax),%eax
80100fdd:	84 c0                	test   %al,%al
80100fdf:	74 17                	je     80100ff8 <exec+0x2e8>
80100fe1:	8b 55 08             	mov    0x8(%ebp),%edx
80100fe4:	89 d1                	mov    %edx,%ecx
80100fe6:	83 c1 01             	add    $0x1,%ecx
80100fe9:	3c 2f                	cmp    $0x2f,%al
80100feb:	0f b6 01             	movzbl (%ecx),%eax
80100fee:	0f 44 d1             	cmove  %ecx,%edx
80100ff1:	84 c0                	test   %al,%al
80100ff3:	75 f1                	jne    80100fe6 <exec+0x2d6>
80100ff5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ff8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100ffe:	50                   	push   %eax
80100fff:	6a 10                	push   $0x10
80101001:	ff 75 08             	pushl  0x8(%ebp)
80101004:	89 f8                	mov    %edi,%eax
80101006:	83 c0 6c             	add    $0x6c,%eax
80101009:	50                   	push   %eax
8010100a:	e8 31 39 00 00       	call   80104940 <safestrcpy>
  curproc->pgdir = pgdir;
8010100f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80101015:	89 f9                	mov    %edi,%ecx
80101017:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
8010101a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
8010101d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
8010101f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80101022:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80101028:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
8010102b:	8b 41 18             	mov    0x18(%ecx),%eax
8010102e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 b7 5a 00 00       	call   80106af0 <switchuvm>
  freevm(oldpgdir);
80101039:	89 3c 24             	mov    %edi,(%esp)
8010103c:	e8 5f 5e 00 00       	call   80106ea0 <freevm>
  return 0;
80101041:	83 c4 10             	add    $0x10,%esp
80101044:	31 c0                	xor    %eax,%eax
80101046:	e9 31 fd ff ff       	jmp    80100d7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010104b:	be 00 20 00 00       	mov    $0x2000,%esi
80101050:	e9 3c fe ff ff       	jmp    80100e91 <exec+0x181>
80101055:	66 90                	xchg   %ax,%ax
80101057:	66 90                	xchg   %ax,%ax
80101059:	66 90                	xchg   %ax,%ax
8010105b:	66 90                	xchg   %ax,%ax
8010105d:	66 90                	xchg   %ax,%ax
8010105f:	90                   	nop

80101060 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101066:	68 4d 72 10 80       	push   $0x8010724d
8010106b:	68 80 02 11 80       	push   $0x80110280
80101070:	e8 9b 34 00 00       	call   80104510 <initlock>
}
80101075:	83 c4 10             	add    $0x10,%esp
80101078:	c9                   	leave  
80101079:	c3                   	ret    
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101080 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101084:	bb b4 02 11 80       	mov    $0x801102b4,%ebx
{
80101089:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010108c:	68 80 02 11 80       	push   $0x80110280
80101091:	e8 ba 35 00 00       	call   80104650 <acquire>
80101096:	83 c4 10             	add    $0x10,%esp
80101099:	eb 10                	jmp    801010ab <filealloc+0x2b>
8010109b:	90                   	nop
8010109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010a0:	83 c3 18             	add    $0x18,%ebx
801010a3:	81 fb 14 0c 11 80    	cmp    $0x80110c14,%ebx
801010a9:	73 25                	jae    801010d0 <filealloc+0x50>
    if(f->ref == 0){
801010ab:	8b 43 04             	mov    0x4(%ebx),%eax
801010ae:	85 c0                	test   %eax,%eax
801010b0:	75 ee                	jne    801010a0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801010b2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801010b5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801010bc:	68 80 02 11 80       	push   $0x80110280
801010c1:	e8 4a 36 00 00       	call   80104710 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801010c6:	89 d8                	mov    %ebx,%eax
      return f;
801010c8:	83 c4 10             	add    $0x10,%esp
}
801010cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010ce:	c9                   	leave  
801010cf:	c3                   	ret    
  release(&ftable.lock);
801010d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801010d3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801010d5:	68 80 02 11 80       	push   $0x80110280
801010da:	e8 31 36 00 00       	call   80104710 <release>
}
801010df:	89 d8                	mov    %ebx,%eax
  return 0;
801010e1:	83 c4 10             	add    $0x10,%esp
}
801010e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010e7:	c9                   	leave  
801010e8:	c3                   	ret    
801010e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801010f0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	53                   	push   %ebx
801010f4:	83 ec 10             	sub    $0x10,%esp
801010f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801010fa:	68 80 02 11 80       	push   $0x80110280
801010ff:	e8 4c 35 00 00       	call   80104650 <acquire>
  if(f->ref < 1)
80101104:	8b 43 04             	mov    0x4(%ebx),%eax
80101107:	83 c4 10             	add    $0x10,%esp
8010110a:	85 c0                	test   %eax,%eax
8010110c:	7e 1a                	jle    80101128 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010110e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101111:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101114:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101117:	68 80 02 11 80       	push   $0x80110280
8010111c:	e8 ef 35 00 00       	call   80104710 <release>
  return f;
}
80101121:	89 d8                	mov    %ebx,%eax
80101123:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101126:	c9                   	leave  
80101127:	c3                   	ret    
    panic("filedup");
80101128:	83 ec 0c             	sub    $0xc,%esp
8010112b:	68 54 72 10 80       	push   $0x80107254
80101130:	e8 5b f2 ff ff       	call   80100390 <panic>
80101135:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101140 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 28             	sub    $0x28,%esp
80101149:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010114c:	68 80 02 11 80       	push   $0x80110280
80101151:	e8 fa 34 00 00       	call   80104650 <acquire>
  if(f->ref < 1)
80101156:	8b 43 04             	mov    0x4(%ebx),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	0f 8e 9b 00 00 00    	jle    801011ff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101164:	83 e8 01             	sub    $0x1,%eax
80101167:	85 c0                	test   %eax,%eax
80101169:	89 43 04             	mov    %eax,0x4(%ebx)
8010116c:	74 1a                	je     80101188 <fileclose+0x48>
    release(&ftable.lock);
8010116e:	c7 45 08 80 02 11 80 	movl   $0x80110280,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101175:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101178:	5b                   	pop    %ebx
80101179:	5e                   	pop    %esi
8010117a:	5f                   	pop    %edi
8010117b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010117c:	e9 8f 35 00 00       	jmp    80104710 <release>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80101188:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010118c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
8010118e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101191:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80101194:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010119a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010119d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801011a0:	68 80 02 11 80       	push   $0x80110280
  ff = *f;
801011a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801011a8:	e8 63 35 00 00       	call   80104710 <release>
  if(ff.type == FD_PIPE)
801011ad:	83 c4 10             	add    $0x10,%esp
801011b0:	83 ff 01             	cmp    $0x1,%edi
801011b3:	74 13                	je     801011c8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
801011b5:	83 ff 02             	cmp    $0x2,%edi
801011b8:	74 26                	je     801011e0 <fileclose+0xa0>
}
801011ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011bd:	5b                   	pop    %ebx
801011be:	5e                   	pop    %esi
801011bf:	5f                   	pop    %edi
801011c0:	5d                   	pop    %ebp
801011c1:	c3                   	ret    
801011c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
801011c8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801011cc:	83 ec 08             	sub    $0x8,%esp
801011cf:	53                   	push   %ebx
801011d0:	56                   	push   %esi
801011d1:	e8 8a 24 00 00       	call   80103660 <pipeclose>
801011d6:	83 c4 10             	add    $0x10,%esp
801011d9:	eb df                	jmp    801011ba <fileclose+0x7a>
801011db:	90                   	nop
801011dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
801011e0:	e8 cb 1c 00 00       	call   80102eb0 <begin_op>
    iput(ff.ip);
801011e5:	83 ec 0c             	sub    $0xc,%esp
801011e8:	ff 75 e0             	pushl  -0x20(%ebp)
801011eb:	e8 d0 08 00 00       	call   80101ac0 <iput>
    end_op();
801011f0:	83 c4 10             	add    $0x10,%esp
}
801011f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f6:	5b                   	pop    %ebx
801011f7:	5e                   	pop    %esi
801011f8:	5f                   	pop    %edi
801011f9:	5d                   	pop    %ebp
    end_op();
801011fa:	e9 21 1d 00 00       	jmp    80102f20 <end_op>
    panic("fileclose");
801011ff:	83 ec 0c             	sub    $0xc,%esp
80101202:	68 5c 72 10 80       	push   $0x8010725c
80101207:	e8 84 f1 ff ff       	call   80100390 <panic>
8010120c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101210 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	53                   	push   %ebx
80101214:	83 ec 04             	sub    $0x4,%esp
80101217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010121a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010121d:	75 31                	jne    80101250 <filestat+0x40>
    ilock(f->ip);
8010121f:	83 ec 0c             	sub    $0xc,%esp
80101222:	ff 73 10             	pushl  0x10(%ebx)
80101225:	e8 66 07 00 00       	call   80101990 <ilock>
    stati(f->ip, st);
8010122a:	58                   	pop    %eax
8010122b:	5a                   	pop    %edx
8010122c:	ff 75 0c             	pushl  0xc(%ebp)
8010122f:	ff 73 10             	pushl  0x10(%ebx)
80101232:	e8 09 0a 00 00       	call   80101c40 <stati>
    iunlock(f->ip);
80101237:	59                   	pop    %ecx
80101238:	ff 73 10             	pushl  0x10(%ebx)
8010123b:	e8 30 08 00 00       	call   80101a70 <iunlock>
    return 0;
80101240:	83 c4 10             	add    $0x10,%esp
80101243:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101248:	c9                   	leave  
80101249:	c3                   	ret    
8010124a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101255:	eb ee                	jmp    80101245 <filestat+0x35>
80101257:	89 f6                	mov    %esi,%esi
80101259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101260 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	56                   	push   %esi
80101265:	53                   	push   %ebx
80101266:	83 ec 0c             	sub    $0xc,%esp
80101269:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010126c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010126f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101272:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101276:	74 60                	je     801012d8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101278:	8b 03                	mov    (%ebx),%eax
8010127a:	83 f8 01             	cmp    $0x1,%eax
8010127d:	74 41                	je     801012c0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010127f:	83 f8 02             	cmp    $0x2,%eax
80101282:	75 5b                	jne    801012df <fileread+0x7f>
    ilock(f->ip);
80101284:	83 ec 0c             	sub    $0xc,%esp
80101287:	ff 73 10             	pushl  0x10(%ebx)
8010128a:	e8 01 07 00 00       	call   80101990 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010128f:	57                   	push   %edi
80101290:	ff 73 14             	pushl  0x14(%ebx)
80101293:	56                   	push   %esi
80101294:	ff 73 10             	pushl  0x10(%ebx)
80101297:	e8 d4 09 00 00       	call   80101c70 <readi>
8010129c:	83 c4 20             	add    $0x20,%esp
8010129f:	85 c0                	test   %eax,%eax
801012a1:	89 c6                	mov    %eax,%esi
801012a3:	7e 03                	jle    801012a8 <fileread+0x48>
      f->off += r;
801012a5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801012a8:	83 ec 0c             	sub    $0xc,%esp
801012ab:	ff 73 10             	pushl  0x10(%ebx)
801012ae:	e8 bd 07 00 00       	call   80101a70 <iunlock>
    return r;
801012b3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801012b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012b9:	89 f0                	mov    %esi,%eax
801012bb:	5b                   	pop    %ebx
801012bc:	5e                   	pop    %esi
801012bd:	5f                   	pop    %edi
801012be:	5d                   	pop    %ebp
801012bf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801012c0:	8b 43 0c             	mov    0xc(%ebx),%eax
801012c3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012c9:	5b                   	pop    %ebx
801012ca:	5e                   	pop    %esi
801012cb:	5f                   	pop    %edi
801012cc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801012cd:	e9 3e 25 00 00       	jmp    80103810 <piperead>
801012d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801012d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801012dd:	eb d7                	jmp    801012b6 <fileread+0x56>
  panic("fileread");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 66 72 10 80       	push   $0x80107266
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	83 ec 1c             	sub    $0x1c,%esp
801012f9:	8b 75 08             	mov    0x8(%ebp),%esi
801012fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801012ff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101303:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101306:	8b 45 10             	mov    0x10(%ebp),%eax
80101309:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010130c:	0f 84 aa 00 00 00    	je     801013bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101312:	8b 06                	mov    (%esi),%eax
80101314:	83 f8 01             	cmp    $0x1,%eax
80101317:	0f 84 c3 00 00 00    	je     801013e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010131d:	83 f8 02             	cmp    $0x2,%eax
80101320:	0f 85 d9 00 00 00    	jne    801013ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101326:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101329:	31 ff                	xor    %edi,%edi
    while(i < n){
8010132b:	85 c0                	test   %eax,%eax
8010132d:	7f 34                	jg     80101363 <filewrite+0x73>
8010132f:	e9 9c 00 00 00       	jmp    801013d0 <filewrite+0xe0>
80101334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101338:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010133b:	83 ec 0c             	sub    $0xc,%esp
8010133e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101341:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101344:	e8 27 07 00 00       	call   80101a70 <iunlock>
      end_op();
80101349:	e8 d2 1b 00 00       	call   80102f20 <end_op>
8010134e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101351:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101354:	39 c3                	cmp    %eax,%ebx
80101356:	0f 85 96 00 00 00    	jne    801013f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010135c:	01 df                	add    %ebx,%edi
    while(i < n){
8010135e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101361:	7e 6d                	jle    801013d0 <filewrite+0xe0>
      int n1 = n - i;
80101363:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101366:	b8 00 06 00 00       	mov    $0x600,%eax
8010136b:	29 fb                	sub    %edi,%ebx
8010136d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101373:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101376:	e8 35 1b 00 00       	call   80102eb0 <begin_op>
      ilock(f->ip);
8010137b:	83 ec 0c             	sub    $0xc,%esp
8010137e:	ff 76 10             	pushl  0x10(%esi)
80101381:	e8 0a 06 00 00       	call   80101990 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101386:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101389:	53                   	push   %ebx
8010138a:	ff 76 14             	pushl  0x14(%esi)
8010138d:	01 f8                	add    %edi,%eax
8010138f:	50                   	push   %eax
80101390:	ff 76 10             	pushl  0x10(%esi)
80101393:	e8 d8 09 00 00       	call   80101d70 <writei>
80101398:	83 c4 20             	add    $0x20,%esp
8010139b:	85 c0                	test   %eax,%eax
8010139d:	7f 99                	jg     80101338 <filewrite+0x48>
      iunlock(f->ip);
8010139f:	83 ec 0c             	sub    $0xc,%esp
801013a2:	ff 76 10             	pushl  0x10(%esi)
801013a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801013a8:	e8 c3 06 00 00       	call   80101a70 <iunlock>
      end_op();
801013ad:	e8 6e 1b 00 00       	call   80102f20 <end_op>
      if(r < 0)
801013b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013b5:	83 c4 10             	add    $0x10,%esp
801013b8:	85 c0                	test   %eax,%eax
801013ba:	74 98                	je     80101354 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801013bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801013bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801013c4:	89 f8                	mov    %edi,%eax
801013c6:	5b                   	pop    %ebx
801013c7:	5e                   	pop    %esi
801013c8:	5f                   	pop    %edi
801013c9:	5d                   	pop    %ebp
801013ca:	c3                   	ret    
801013cb:	90                   	nop
801013cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801013d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801013d3:	75 e7                	jne    801013bc <filewrite+0xcc>
}
801013d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d8:	89 f8                	mov    %edi,%eax
801013da:	5b                   	pop    %ebx
801013db:	5e                   	pop    %esi
801013dc:	5f                   	pop    %edi
801013dd:	5d                   	pop    %ebp
801013de:	c3                   	ret    
801013df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801013e0:	8b 46 0c             	mov    0xc(%esi),%eax
801013e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801013e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e9:	5b                   	pop    %ebx
801013ea:	5e                   	pop    %esi
801013eb:	5f                   	pop    %edi
801013ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801013ed:	e9 0e 23 00 00       	jmp    80103700 <pipewrite>
        panic("short filewrite");
801013f2:	83 ec 0c             	sub    $0xc,%esp
801013f5:	68 6f 72 10 80       	push   $0x8010726f
801013fa:	e8 91 ef ff ff       	call   80100390 <panic>
  panic("filewrite");
801013ff:	83 ec 0c             	sub    $0xc,%esp
80101402:	68 75 72 10 80       	push   $0x80107275
80101407:	e8 84 ef ff ff       	call   80100390 <panic>
8010140c:	66 90                	xchg   %ax,%ax
8010140e:	66 90                	xchg   %ax,%ax

80101410 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	57                   	push   %edi
80101414:	56                   	push   %esi
80101415:	53                   	push   %ebx
80101416:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101419:	8b 0d 80 0c 11 80    	mov    0x80110c80,%ecx
{
8010141f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101422:	85 c9                	test   %ecx,%ecx
80101424:	0f 84 87 00 00 00    	je     801014b1 <balloc+0xa1>
8010142a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101431:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101434:	83 ec 08             	sub    $0x8,%esp
80101437:	89 f0                	mov    %esi,%eax
80101439:	c1 f8 0c             	sar    $0xc,%eax
8010143c:	03 05 98 0c 11 80    	add    0x80110c98,%eax
80101442:	50                   	push   %eax
80101443:	ff 75 d8             	pushl  -0x28(%ebp)
80101446:	e8 85 ec ff ff       	call   801000d0 <bread>
8010144b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010144e:	a1 80 0c 11 80       	mov    0x80110c80,%eax
80101453:	83 c4 10             	add    $0x10,%esp
80101456:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101459:	31 c0                	xor    %eax,%eax
8010145b:	eb 2f                	jmp    8010148c <balloc+0x7c>
8010145d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101460:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101462:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101465:	bb 01 00 00 00       	mov    $0x1,%ebx
8010146a:	83 e1 07             	and    $0x7,%ecx
8010146d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010146f:	89 c1                	mov    %eax,%ecx
80101471:	c1 f9 03             	sar    $0x3,%ecx
80101474:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101479:	85 df                	test   %ebx,%edi
8010147b:	89 fa                	mov    %edi,%edx
8010147d:	74 41                	je     801014c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010147f:	83 c0 01             	add    $0x1,%eax
80101482:	83 c6 01             	add    $0x1,%esi
80101485:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010148a:	74 05                	je     80101491 <balloc+0x81>
8010148c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010148f:	77 cf                	ja     80101460 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101491:	83 ec 0c             	sub    $0xc,%esp
80101494:	ff 75 e4             	pushl  -0x1c(%ebp)
80101497:	e8 44 ed ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010149c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801014a3:	83 c4 10             	add    $0x10,%esp
801014a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014a9:	39 05 80 0c 11 80    	cmp    %eax,0x80110c80
801014af:	77 80                	ja     80101431 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801014b1:	83 ec 0c             	sub    $0xc,%esp
801014b4:	68 7f 72 10 80       	push   $0x8010727f
801014b9:	e8 d2 ee ff ff       	call   80100390 <panic>
801014be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801014c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801014c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801014c6:	09 da                	or     %ebx,%edx
801014c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801014cc:	57                   	push   %edi
801014cd:	e8 ae 1b 00 00       	call   80103080 <log_write>
        brelse(bp);
801014d2:	89 3c 24             	mov    %edi,(%esp)
801014d5:	e8 06 ed ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801014da:	58                   	pop    %eax
801014db:	5a                   	pop    %edx
801014dc:	56                   	push   %esi
801014dd:	ff 75 d8             	pushl  -0x28(%ebp)
801014e0:	e8 eb eb ff ff       	call   801000d0 <bread>
801014e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801014e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801014ea:	83 c4 0c             	add    $0xc,%esp
801014ed:	68 00 02 00 00       	push   $0x200
801014f2:	6a 00                	push   $0x0
801014f4:	50                   	push   %eax
801014f5:	e8 66 32 00 00       	call   80104760 <memset>
  log_write(bp);
801014fa:	89 1c 24             	mov    %ebx,(%esp)
801014fd:	e8 7e 1b 00 00       	call   80103080 <log_write>
  brelse(bp);
80101502:	89 1c 24             	mov    %ebx,(%esp)
80101505:	e8 d6 ec ff ff       	call   801001e0 <brelse>
}
8010150a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150d:	89 f0                	mov    %esi,%eax
8010150f:	5b                   	pop    %ebx
80101510:	5e                   	pop    %esi
80101511:	5f                   	pop    %edi
80101512:	5d                   	pop    %ebp
80101513:	c3                   	ret    
80101514:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010151a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101520 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101528:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010152a:	bb d4 0c 11 80       	mov    $0x80110cd4,%ebx
{
8010152f:	83 ec 28             	sub    $0x28,%esp
80101532:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101535:	68 a0 0c 11 80       	push   $0x80110ca0
8010153a:	e8 11 31 00 00       	call   80104650 <acquire>
8010153f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101542:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101545:	eb 17                	jmp    8010155e <iget+0x3e>
80101547:	89 f6                	mov    %esi,%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101550:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101556:	81 fb f4 28 11 80    	cmp    $0x801128f4,%ebx
8010155c:	73 22                	jae    80101580 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010155e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101561:	85 c9                	test   %ecx,%ecx
80101563:	7e 04                	jle    80101569 <iget+0x49>
80101565:	39 3b                	cmp    %edi,(%ebx)
80101567:	74 4f                	je     801015b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101569:	85 f6                	test   %esi,%esi
8010156b:	75 e3                	jne    80101550 <iget+0x30>
8010156d:	85 c9                	test   %ecx,%ecx
8010156f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101572:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101578:	81 fb f4 28 11 80    	cmp    $0x801128f4,%ebx
8010157e:	72 de                	jb     8010155e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101580:	85 f6                	test   %esi,%esi
80101582:	74 5b                	je     801015df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101584:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101587:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101589:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010158c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101593:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010159a:	68 a0 0c 11 80       	push   $0x80110ca0
8010159f:	e8 6c 31 00 00       	call   80104710 <release>

  return ip;
801015a4:	83 c4 10             	add    $0x10,%esp
}
801015a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015aa:	89 f0                	mov    %esi,%eax
801015ac:	5b                   	pop    %ebx
801015ad:	5e                   	pop    %esi
801015ae:	5f                   	pop    %edi
801015af:	5d                   	pop    %ebp
801015b0:	c3                   	ret    
801015b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801015b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801015bb:	75 ac                	jne    80101569 <iget+0x49>
      release(&icache.lock);
801015bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801015c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801015c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801015c5:	68 a0 0c 11 80       	push   $0x80110ca0
      ip->ref++;
801015ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801015cd:	e8 3e 31 00 00       	call   80104710 <release>
      return ip;
801015d2:	83 c4 10             	add    $0x10,%esp
}
801015d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015d8:	89 f0                	mov    %esi,%eax
801015da:	5b                   	pop    %ebx
801015db:	5e                   	pop    %esi
801015dc:	5f                   	pop    %edi
801015dd:	5d                   	pop    %ebp
801015de:	c3                   	ret    
    panic("iget: no inodes");
801015df:	83 ec 0c             	sub    $0xc,%esp
801015e2:	68 95 72 10 80       	push   $0x80107295
801015e7:	e8 a4 ed ff ff       	call   80100390 <panic>
801015ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	57                   	push   %edi
801015f4:	56                   	push   %esi
801015f5:	53                   	push   %ebx
801015f6:	89 c6                	mov    %eax,%esi
801015f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801015fb:	83 fa 0b             	cmp    $0xb,%edx
801015fe:	77 18                	ja     80101618 <bmap+0x28>
80101600:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101603:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101606:	85 db                	test   %ebx,%ebx
80101608:	74 76                	je     80101680 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010160a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010160d:	89 d8                	mov    %ebx,%eax
8010160f:	5b                   	pop    %ebx
80101610:	5e                   	pop    %esi
80101611:	5f                   	pop    %edi
80101612:	5d                   	pop    %ebp
80101613:	c3                   	ret    
80101614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101618:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010161b:	83 fb 7f             	cmp    $0x7f,%ebx
8010161e:	0f 87 90 00 00 00    	ja     801016b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101624:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010162a:	8b 00                	mov    (%eax),%eax
8010162c:	85 d2                	test   %edx,%edx
8010162e:	74 70                	je     801016a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101630:	83 ec 08             	sub    $0x8,%esp
80101633:	52                   	push   %edx
80101634:	50                   	push   %eax
80101635:	e8 96 ea ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010163a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010163e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101641:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101643:	8b 1a                	mov    (%edx),%ebx
80101645:	85 db                	test   %ebx,%ebx
80101647:	75 1d                	jne    80101666 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101649:	8b 06                	mov    (%esi),%eax
8010164b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010164e:	e8 bd fd ff ff       	call   80101410 <balloc>
80101653:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101656:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101659:	89 c3                	mov    %eax,%ebx
8010165b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010165d:	57                   	push   %edi
8010165e:	e8 1d 1a 00 00       	call   80103080 <log_write>
80101663:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101666:	83 ec 0c             	sub    $0xc,%esp
80101669:	57                   	push   %edi
8010166a:	e8 71 eb ff ff       	call   801001e0 <brelse>
8010166f:	83 c4 10             	add    $0x10,%esp
}
80101672:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101675:	89 d8                	mov    %ebx,%eax
80101677:	5b                   	pop    %ebx
80101678:	5e                   	pop    %esi
80101679:	5f                   	pop    %edi
8010167a:	5d                   	pop    %ebp
8010167b:	c3                   	ret    
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101680:	8b 00                	mov    (%eax),%eax
80101682:	e8 89 fd ff ff       	call   80101410 <balloc>
80101687:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010168a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010168d:	89 c3                	mov    %eax,%ebx
}
8010168f:	89 d8                	mov    %ebx,%eax
80101691:	5b                   	pop    %ebx
80101692:	5e                   	pop    %esi
80101693:	5f                   	pop    %edi
80101694:	5d                   	pop    %ebp
80101695:	c3                   	ret    
80101696:	8d 76 00             	lea    0x0(%esi),%esi
80101699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801016a0:	e8 6b fd ff ff       	call   80101410 <balloc>
801016a5:	89 c2                	mov    %eax,%edx
801016a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801016ad:	8b 06                	mov    (%esi),%eax
801016af:	e9 7c ff ff ff       	jmp    80101630 <bmap+0x40>
  panic("bmap: out of range");
801016b4:	83 ec 0c             	sub    $0xc,%esp
801016b7:	68 a5 72 10 80       	push   $0x801072a5
801016bc:	e8 cf ec ff ff       	call   80100390 <panic>
801016c1:	eb 0d                	jmp    801016d0 <readsb>
801016c3:	90                   	nop
801016c4:	90                   	nop
801016c5:	90                   	nop
801016c6:	90                   	nop
801016c7:	90                   	nop
801016c8:	90                   	nop
801016c9:	90                   	nop
801016ca:	90                   	nop
801016cb:	90                   	nop
801016cc:	90                   	nop
801016cd:	90                   	nop
801016ce:	90                   	nop
801016cf:	90                   	nop

801016d0 <readsb>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801016d8:	83 ec 08             	sub    $0x8,%esp
801016db:	6a 01                	push   $0x1
801016dd:	ff 75 08             	pushl  0x8(%ebp)
801016e0:	e8 eb e9 ff ff       	call   801000d0 <bread>
801016e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801016ea:	83 c4 0c             	add    $0xc,%esp
801016ed:	6a 1c                	push   $0x1c
801016ef:	50                   	push   %eax
801016f0:	56                   	push   %esi
801016f1:	e8 1a 31 00 00       	call   80104810 <memmove>
  brelse(bp);
801016f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801016f9:	83 c4 10             	add    $0x10,%esp
}
801016fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016ff:	5b                   	pop    %ebx
80101700:	5e                   	pop    %esi
80101701:	5d                   	pop    %ebp
  brelse(bp);
80101702:	e9 d9 ea ff ff       	jmp    801001e0 <brelse>
80101707:	89 f6                	mov    %esi,%esi
80101709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101710 <bfree>:
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	56                   	push   %esi
80101714:	53                   	push   %ebx
80101715:	89 d3                	mov    %edx,%ebx
80101717:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101719:	83 ec 08             	sub    $0x8,%esp
8010171c:	68 80 0c 11 80       	push   $0x80110c80
80101721:	50                   	push   %eax
80101722:	e8 a9 ff ff ff       	call   801016d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101727:	58                   	pop    %eax
80101728:	5a                   	pop    %edx
80101729:	89 da                	mov    %ebx,%edx
8010172b:	c1 ea 0c             	shr    $0xc,%edx
8010172e:	03 15 98 0c 11 80    	add    0x80110c98,%edx
80101734:	52                   	push   %edx
80101735:	56                   	push   %esi
80101736:	e8 95 e9 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010173b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010173d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101740:	ba 01 00 00 00       	mov    $0x1,%edx
80101745:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101748:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010174e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101751:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101753:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101758:	85 d1                	test   %edx,%ecx
8010175a:	74 25                	je     80101781 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010175c:	f7 d2                	not    %edx
8010175e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101760:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101763:	21 ca                	and    %ecx,%edx
80101765:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101769:	56                   	push   %esi
8010176a:	e8 11 19 00 00       	call   80103080 <log_write>
  brelse(bp);
8010176f:	89 34 24             	mov    %esi,(%esp)
80101772:	e8 69 ea ff ff       	call   801001e0 <brelse>
}
80101777:	83 c4 10             	add    $0x10,%esp
8010177a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010177d:	5b                   	pop    %ebx
8010177e:	5e                   	pop    %esi
8010177f:	5d                   	pop    %ebp
80101780:	c3                   	ret    
    panic("freeing free block");
80101781:	83 ec 0c             	sub    $0xc,%esp
80101784:	68 b8 72 10 80       	push   $0x801072b8
80101789:	e8 02 ec ff ff       	call   80100390 <panic>
8010178e:	66 90                	xchg   %ax,%ax

80101790 <iinit>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	53                   	push   %ebx
80101794:	bb e0 0c 11 80       	mov    $0x80110ce0,%ebx
80101799:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010179c:	68 cb 72 10 80       	push   $0x801072cb
801017a1:	68 a0 0c 11 80       	push   $0x80110ca0
801017a6:	e8 65 2d 00 00       	call   80104510 <initlock>
801017ab:	83 c4 10             	add    $0x10,%esp
801017ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801017b0:	83 ec 08             	sub    $0x8,%esp
801017b3:	68 d2 72 10 80       	push   $0x801072d2
801017b8:	53                   	push   %ebx
801017b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801017bf:	e8 1c 2c 00 00       	call   801043e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801017c4:	83 c4 10             	add    $0x10,%esp
801017c7:	81 fb 00 29 11 80    	cmp    $0x80112900,%ebx
801017cd:	75 e1                	jne    801017b0 <iinit+0x20>
  readsb(dev, &sb);
801017cf:	83 ec 08             	sub    $0x8,%esp
801017d2:	68 80 0c 11 80       	push   $0x80110c80
801017d7:	ff 75 08             	pushl  0x8(%ebp)
801017da:	e8 f1 fe ff ff       	call   801016d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801017df:	ff 35 98 0c 11 80    	pushl  0x80110c98
801017e5:	ff 35 94 0c 11 80    	pushl  0x80110c94
801017eb:	ff 35 90 0c 11 80    	pushl  0x80110c90
801017f1:	ff 35 8c 0c 11 80    	pushl  0x80110c8c
801017f7:	ff 35 88 0c 11 80    	pushl  0x80110c88
801017fd:	ff 35 84 0c 11 80    	pushl  0x80110c84
80101803:	ff 35 80 0c 11 80    	pushl  0x80110c80
80101809:	68 38 73 10 80       	push   $0x80107338
8010180e:	e8 4d ee ff ff       	call   80100660 <cprintf>
}
80101813:	83 c4 30             	add    $0x30,%esp
80101816:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101819:	c9                   	leave  
8010181a:	c3                   	ret    
8010181b:	90                   	nop
8010181c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101820 <ialloc>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	57                   	push   %edi
80101824:	56                   	push   %esi
80101825:	53                   	push   %ebx
80101826:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101829:	83 3d 88 0c 11 80 01 	cmpl   $0x1,0x80110c88
{
80101830:	8b 45 0c             	mov    0xc(%ebp),%eax
80101833:	8b 75 08             	mov    0x8(%ebp),%esi
80101836:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101839:	0f 86 91 00 00 00    	jbe    801018d0 <ialloc+0xb0>
8010183f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101844:	eb 21                	jmp    80101867 <ialloc+0x47>
80101846:	8d 76 00             	lea    0x0(%esi),%esi
80101849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101850:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101853:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101856:	57                   	push   %edi
80101857:	e8 84 e9 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	39 1d 88 0c 11 80    	cmp    %ebx,0x80110c88
80101865:	76 69                	jbe    801018d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101867:	89 d8                	mov    %ebx,%eax
80101869:	83 ec 08             	sub    $0x8,%esp
8010186c:	c1 e8 03             	shr    $0x3,%eax
8010186f:	03 05 94 0c 11 80    	add    0x80110c94,%eax
80101875:	50                   	push   %eax
80101876:	56                   	push   %esi
80101877:	e8 54 e8 ff ff       	call   801000d0 <bread>
8010187c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010187e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101880:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101883:	83 e0 07             	and    $0x7,%eax
80101886:	c1 e0 06             	shl    $0x6,%eax
80101889:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010188d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101891:	75 bd                	jne    80101850 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101893:	83 ec 04             	sub    $0x4,%esp
80101896:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101899:	6a 40                	push   $0x40
8010189b:	6a 00                	push   $0x0
8010189d:	51                   	push   %ecx
8010189e:	e8 bd 2e 00 00       	call   80104760 <memset>
      dip->type = type;
801018a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801018a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801018aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801018ad:	89 3c 24             	mov    %edi,(%esp)
801018b0:	e8 cb 17 00 00       	call   80103080 <log_write>
      brelse(bp);
801018b5:	89 3c 24             	mov    %edi,(%esp)
801018b8:	e8 23 e9 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801018bd:	83 c4 10             	add    $0x10,%esp
}
801018c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801018c3:	89 da                	mov    %ebx,%edx
801018c5:	89 f0                	mov    %esi,%eax
}
801018c7:	5b                   	pop    %ebx
801018c8:	5e                   	pop    %esi
801018c9:	5f                   	pop    %edi
801018ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801018cb:	e9 50 fc ff ff       	jmp    80101520 <iget>
  panic("ialloc: no inodes");
801018d0:	83 ec 0c             	sub    $0xc,%esp
801018d3:	68 d8 72 10 80       	push   $0x801072d8
801018d8:	e8 b3 ea ff ff       	call   80100390 <panic>
801018dd:	8d 76 00             	lea    0x0(%esi),%esi

801018e0 <iupdate>:
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	56                   	push   %esi
801018e4:	53                   	push   %ebx
801018e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018e8:	83 ec 08             	sub    $0x8,%esp
801018eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018f1:	c1 e8 03             	shr    $0x3,%eax
801018f4:	03 05 94 0c 11 80    	add    0x80110c94,%eax
801018fa:	50                   	push   %eax
801018fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801018fe:	e8 cd e7 ff ff       	call   801000d0 <bread>
80101903:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101905:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101908:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010190c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010190f:	83 e0 07             	and    $0x7,%eax
80101912:	c1 e0 06             	shl    $0x6,%eax
80101915:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101919:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010191c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101920:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101923:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101927:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010192b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010192f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101933:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101937:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010193a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010193d:	6a 34                	push   $0x34
8010193f:	53                   	push   %ebx
80101940:	50                   	push   %eax
80101941:	e8 ca 2e 00 00       	call   80104810 <memmove>
  log_write(bp);
80101946:	89 34 24             	mov    %esi,(%esp)
80101949:	e8 32 17 00 00       	call   80103080 <log_write>
  brelse(bp);
8010194e:	89 75 08             	mov    %esi,0x8(%ebp)
80101951:	83 c4 10             	add    $0x10,%esp
}
80101954:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101957:	5b                   	pop    %ebx
80101958:	5e                   	pop    %esi
80101959:	5d                   	pop    %ebp
  brelse(bp);
8010195a:	e9 81 e8 ff ff       	jmp    801001e0 <brelse>
8010195f:	90                   	nop

80101960 <idup>:
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	53                   	push   %ebx
80101964:	83 ec 10             	sub    $0x10,%esp
80101967:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010196a:	68 a0 0c 11 80       	push   $0x80110ca0
8010196f:	e8 dc 2c 00 00       	call   80104650 <acquire>
  ip->ref++;
80101974:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101978:	c7 04 24 a0 0c 11 80 	movl   $0x80110ca0,(%esp)
8010197f:	e8 8c 2d 00 00       	call   80104710 <release>
}
80101984:	89 d8                	mov    %ebx,%eax
80101986:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101989:	c9                   	leave  
8010198a:	c3                   	ret    
8010198b:	90                   	nop
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <ilock>:
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	56                   	push   %esi
80101994:	53                   	push   %ebx
80101995:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101998:	85 db                	test   %ebx,%ebx
8010199a:	0f 84 b7 00 00 00    	je     80101a57 <ilock+0xc7>
801019a0:	8b 53 08             	mov    0x8(%ebx),%edx
801019a3:	85 d2                	test   %edx,%edx
801019a5:	0f 8e ac 00 00 00    	jle    80101a57 <ilock+0xc7>
  acquiresleep(&ip->lock);
801019ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801019ae:	83 ec 0c             	sub    $0xc,%esp
801019b1:	50                   	push   %eax
801019b2:	e8 69 2a 00 00       	call   80104420 <acquiresleep>
  if(ip->valid == 0){
801019b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801019ba:	83 c4 10             	add    $0x10,%esp
801019bd:	85 c0                	test   %eax,%eax
801019bf:	74 0f                	je     801019d0 <ilock+0x40>
}
801019c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019c4:	5b                   	pop    %ebx
801019c5:	5e                   	pop    %esi
801019c6:	5d                   	pop    %ebp
801019c7:	c3                   	ret    
801019c8:	90                   	nop
801019c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019d0:	8b 43 04             	mov    0x4(%ebx),%eax
801019d3:	83 ec 08             	sub    $0x8,%esp
801019d6:	c1 e8 03             	shr    $0x3,%eax
801019d9:	03 05 94 0c 11 80    	add    0x80110c94,%eax
801019df:	50                   	push   %eax
801019e0:	ff 33                	pushl  (%ebx)
801019e2:	e8 e9 e6 ff ff       	call   801000d0 <bread>
801019e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019ef:	83 e0 07             	and    $0x7,%eax
801019f2:	c1 e0 06             	shl    $0x6,%eax
801019f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801019f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801019ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101a03:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101a07:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101a0b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101a0f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101a13:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101a17:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101a1b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101a1e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a21:	6a 34                	push   $0x34
80101a23:	50                   	push   %eax
80101a24:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101a27:	50                   	push   %eax
80101a28:	e8 e3 2d 00 00       	call   80104810 <memmove>
    brelse(bp);
80101a2d:	89 34 24             	mov    %esi,(%esp)
80101a30:	e8 ab e7 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101a35:	83 c4 10             	add    $0x10,%esp
80101a38:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101a3d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101a44:	0f 85 77 ff ff ff    	jne    801019c1 <ilock+0x31>
      panic("ilock: no type");
80101a4a:	83 ec 0c             	sub    $0xc,%esp
80101a4d:	68 f0 72 10 80       	push   $0x801072f0
80101a52:	e8 39 e9 ff ff       	call   80100390 <panic>
    panic("ilock");
80101a57:	83 ec 0c             	sub    $0xc,%esp
80101a5a:	68 ea 72 10 80       	push   $0x801072ea
80101a5f:	e8 2c e9 ff ff       	call   80100390 <panic>
80101a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101a70 <iunlock>:
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	56                   	push   %esi
80101a74:	53                   	push   %ebx
80101a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a78:	85 db                	test   %ebx,%ebx
80101a7a:	74 28                	je     80101aa4 <iunlock+0x34>
80101a7c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a7f:	83 ec 0c             	sub    $0xc,%esp
80101a82:	56                   	push   %esi
80101a83:	e8 38 2a 00 00       	call   801044c0 <holdingsleep>
80101a88:	83 c4 10             	add    $0x10,%esp
80101a8b:	85 c0                	test   %eax,%eax
80101a8d:	74 15                	je     80101aa4 <iunlock+0x34>
80101a8f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a92:	85 c0                	test   %eax,%eax
80101a94:	7e 0e                	jle    80101aa4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101a96:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101a99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a9c:	5b                   	pop    %ebx
80101a9d:	5e                   	pop    %esi
80101a9e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101a9f:	e9 dc 29 00 00       	jmp    80104480 <releasesleep>
    panic("iunlock");
80101aa4:	83 ec 0c             	sub    $0xc,%esp
80101aa7:	68 ff 72 10 80       	push   $0x801072ff
80101aac:	e8 df e8 ff ff       	call   80100390 <panic>
80101ab1:	eb 0d                	jmp    80101ac0 <iput>
80101ab3:	90                   	nop
80101ab4:	90                   	nop
80101ab5:	90                   	nop
80101ab6:	90                   	nop
80101ab7:	90                   	nop
80101ab8:	90                   	nop
80101ab9:	90                   	nop
80101aba:	90                   	nop
80101abb:	90                   	nop
80101abc:	90                   	nop
80101abd:	90                   	nop
80101abe:	90                   	nop
80101abf:	90                   	nop

80101ac0 <iput>:
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	57                   	push   %edi
80101ac4:	56                   	push   %esi
80101ac5:	53                   	push   %ebx
80101ac6:	83 ec 28             	sub    $0x28,%esp
80101ac9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101acc:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101acf:	57                   	push   %edi
80101ad0:	e8 4b 29 00 00       	call   80104420 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101ad5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101ad8:	83 c4 10             	add    $0x10,%esp
80101adb:	85 d2                	test   %edx,%edx
80101add:	74 07                	je     80101ae6 <iput+0x26>
80101adf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101ae4:	74 32                	je     80101b18 <iput+0x58>
  releasesleep(&ip->lock);
80101ae6:	83 ec 0c             	sub    $0xc,%esp
80101ae9:	57                   	push   %edi
80101aea:	e8 91 29 00 00       	call   80104480 <releasesleep>
  acquire(&icache.lock);
80101aef:	c7 04 24 a0 0c 11 80 	movl   $0x80110ca0,(%esp)
80101af6:	e8 55 2b 00 00       	call   80104650 <acquire>
  ip->ref--;
80101afb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101aff:	83 c4 10             	add    $0x10,%esp
80101b02:	c7 45 08 a0 0c 11 80 	movl   $0x80110ca0,0x8(%ebp)
}
80101b09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b0c:	5b                   	pop    %ebx
80101b0d:	5e                   	pop    %esi
80101b0e:	5f                   	pop    %edi
80101b0f:	5d                   	pop    %ebp
  release(&icache.lock);
80101b10:	e9 fb 2b 00 00       	jmp    80104710 <release>
80101b15:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101b18:	83 ec 0c             	sub    $0xc,%esp
80101b1b:	68 a0 0c 11 80       	push   $0x80110ca0
80101b20:	e8 2b 2b 00 00       	call   80104650 <acquire>
    int r = ip->ref;
80101b25:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101b28:	c7 04 24 a0 0c 11 80 	movl   $0x80110ca0,(%esp)
80101b2f:	e8 dc 2b 00 00       	call   80104710 <release>
    if(r == 1){
80101b34:	83 c4 10             	add    $0x10,%esp
80101b37:	83 fe 01             	cmp    $0x1,%esi
80101b3a:	75 aa                	jne    80101ae6 <iput+0x26>
80101b3c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101b42:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101b45:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101b48:	89 cf                	mov    %ecx,%edi
80101b4a:	eb 0b                	jmp    80101b57 <iput+0x97>
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b50:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101b53:	39 fe                	cmp    %edi,%esi
80101b55:	74 19                	je     80101b70 <iput+0xb0>
    if(ip->addrs[i]){
80101b57:	8b 16                	mov    (%esi),%edx
80101b59:	85 d2                	test   %edx,%edx
80101b5b:	74 f3                	je     80101b50 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101b5d:	8b 03                	mov    (%ebx),%eax
80101b5f:	e8 ac fb ff ff       	call   80101710 <bfree>
      ip->addrs[i] = 0;
80101b64:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101b6a:	eb e4                	jmp    80101b50 <iput+0x90>
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101b70:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101b76:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b79:	85 c0                	test   %eax,%eax
80101b7b:	75 33                	jne    80101bb0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101b7d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101b80:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101b87:	53                   	push   %ebx
80101b88:	e8 53 fd ff ff       	call   801018e0 <iupdate>
      ip->type = 0;
80101b8d:	31 c0                	xor    %eax,%eax
80101b8f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101b93:	89 1c 24             	mov    %ebx,(%esp)
80101b96:	e8 45 fd ff ff       	call   801018e0 <iupdate>
      ip->valid = 0;
80101b9b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101ba2:	83 c4 10             	add    $0x10,%esp
80101ba5:	e9 3c ff ff ff       	jmp    80101ae6 <iput+0x26>
80101baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101bb0:	83 ec 08             	sub    $0x8,%esp
80101bb3:	50                   	push   %eax
80101bb4:	ff 33                	pushl  (%ebx)
80101bb6:	e8 15 e5 ff ff       	call   801000d0 <bread>
80101bbb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101bc1:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101bc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101bc7:	8d 70 5c             	lea    0x5c(%eax),%esi
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	89 cf                	mov    %ecx,%edi
80101bcf:	eb 0e                	jmp    80101bdf <iput+0x11f>
80101bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bd8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101bdb:	39 fe                	cmp    %edi,%esi
80101bdd:	74 0f                	je     80101bee <iput+0x12e>
      if(a[j])
80101bdf:	8b 16                	mov    (%esi),%edx
80101be1:	85 d2                	test   %edx,%edx
80101be3:	74 f3                	je     80101bd8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101be5:	8b 03                	mov    (%ebx),%eax
80101be7:	e8 24 fb ff ff       	call   80101710 <bfree>
80101bec:	eb ea                	jmp    80101bd8 <iput+0x118>
    brelse(bp);
80101bee:	83 ec 0c             	sub    $0xc,%esp
80101bf1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101bf4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bf7:	e8 e4 e5 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101bfc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101c02:	8b 03                	mov    (%ebx),%eax
80101c04:	e8 07 fb ff ff       	call   80101710 <bfree>
    ip->addrs[NDIRECT] = 0;
80101c09:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101c10:	00 00 00 
80101c13:	83 c4 10             	add    $0x10,%esp
80101c16:	e9 62 ff ff ff       	jmp    80101b7d <iput+0xbd>
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c20 <iunlockput>:
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	53                   	push   %ebx
80101c24:	83 ec 10             	sub    $0x10,%esp
80101c27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101c2a:	53                   	push   %ebx
80101c2b:	e8 40 fe ff ff       	call   80101a70 <iunlock>
  iput(ip);
80101c30:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101c33:	83 c4 10             	add    $0x10,%esp
}
80101c36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c39:	c9                   	leave  
  iput(ip);
80101c3a:	e9 81 fe ff ff       	jmp    80101ac0 <iput>
80101c3f:	90                   	nop

80101c40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	8b 55 08             	mov    0x8(%ebp),%edx
80101c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101c49:	8b 0a                	mov    (%edx),%ecx
80101c4b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101c4e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101c51:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101c54:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101c58:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101c5b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101c5f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101c63:	8b 52 58             	mov    0x58(%edx),%edx
80101c66:	89 50 10             	mov    %edx,0x10(%eax)
}
80101c69:	5d                   	pop    %ebp
80101c6a:	c3                   	ret    
80101c6b:	90                   	nop
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	83 ec 1c             	sub    $0x1c,%esp
80101c79:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c87:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c90:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101c93:	0f 84 a7 00 00 00    	je     80101d40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c9c:	8b 40 58             	mov    0x58(%eax),%eax
80101c9f:	39 c6                	cmp    %eax,%esi
80101ca1:	0f 87 ba 00 00 00    	ja     80101d61 <readi+0xf1>
80101ca7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101caa:	89 f9                	mov    %edi,%ecx
80101cac:	01 f1                	add    %esi,%ecx
80101cae:	0f 82 ad 00 00 00    	jb     80101d61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101cb4:	89 c2                	mov    %eax,%edx
80101cb6:	29 f2                	sub    %esi,%edx
80101cb8:	39 c8                	cmp    %ecx,%eax
80101cba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cbd:	31 ff                	xor    %edi,%edi
80101cbf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101cc1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cc4:	74 6c                	je     80101d32 <readi+0xc2>
80101cc6:	8d 76 00             	lea    0x0(%esi),%esi
80101cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cd0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101cd3:	89 f2                	mov    %esi,%edx
80101cd5:	c1 ea 09             	shr    $0x9,%edx
80101cd8:	89 d8                	mov    %ebx,%eax
80101cda:	e8 11 f9 ff ff       	call   801015f0 <bmap>
80101cdf:	83 ec 08             	sub    $0x8,%esp
80101ce2:	50                   	push   %eax
80101ce3:	ff 33                	pushl  (%ebx)
80101ce5:	e8 e6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ced:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101cef:	89 f0                	mov    %esi,%eax
80101cf1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cf6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cfb:	83 c4 0c             	add    $0xc,%esp
80101cfe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101d00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101d04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101d07:	29 fb                	sub    %edi,%ebx
80101d09:	39 d9                	cmp    %ebx,%ecx
80101d0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d0e:	53                   	push   %ebx
80101d0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101d12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101d17:	e8 f4 2a 00 00       	call   80104810 <memmove>
    brelse(bp);
80101d1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d1f:	89 14 24             	mov    %edx,(%esp)
80101d22:	e8 b9 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101d2a:	83 c4 10             	add    $0x10,%esp
80101d2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101d30:	77 9e                	ja     80101cd0 <readi+0x60>
  }
  return n;
80101d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101d35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d38:	5b                   	pop    %ebx
80101d39:	5e                   	pop    %esi
80101d3a:	5f                   	pop    %edi
80101d3b:	5d                   	pop    %ebp
80101d3c:	c3                   	ret    
80101d3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d44:	66 83 f8 09          	cmp    $0x9,%ax
80101d48:	77 17                	ja     80101d61 <readi+0xf1>
80101d4a:	8b 04 c5 20 0c 11 80 	mov    -0x7feef3e0(,%eax,8),%eax
80101d51:	85 c0                	test   %eax,%eax
80101d53:	74 0c                	je     80101d61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101d55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d5b:	5b                   	pop    %ebx
80101d5c:	5e                   	pop    %esi
80101d5d:	5f                   	pop    %edi
80101d5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101d5f:	ff e0                	jmp    *%eax
      return -1;
80101d61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d66:	eb cd                	jmp    80101d35 <readi+0xc5>
80101d68:	90                   	nop
80101d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	83 ec 1c             	sub    $0x1c,%esp
80101d79:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101d8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101d90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101d93:	0f 84 b7 00 00 00    	je     80101e50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101d99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101d9f:	0f 82 eb 00 00 00    	jb     80101e90 <writei+0x120>
80101da5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101da8:	31 d2                	xor    %edx,%edx
80101daa:	89 f8                	mov    %edi,%eax
80101dac:	01 f0                	add    %esi,%eax
80101dae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101db1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101db6:	0f 87 d4 00 00 00    	ja     80101e90 <writei+0x120>
80101dbc:	85 d2                	test   %edx,%edx
80101dbe:	0f 85 cc 00 00 00    	jne    80101e90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101dc4:	85 ff                	test   %edi,%edi
80101dc6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101dcd:	74 72                	je     80101e41 <writei+0xd1>
80101dcf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101dd0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101dd3:	89 f2                	mov    %esi,%edx
80101dd5:	c1 ea 09             	shr    $0x9,%edx
80101dd8:	89 f8                	mov    %edi,%eax
80101dda:	e8 11 f8 ff ff       	call   801015f0 <bmap>
80101ddf:	83 ec 08             	sub    $0x8,%esp
80101de2:	50                   	push   %eax
80101de3:	ff 37                	pushl  (%edi)
80101de5:	e8 e6 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101dea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ded:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101df0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101df2:	89 f0                	mov    %esi,%eax
80101df4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101df9:	83 c4 0c             	add    $0xc,%esp
80101dfc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101e03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101e07:	39 d9                	cmp    %ebx,%ecx
80101e09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101e0c:	53                   	push   %ebx
80101e0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101e12:	50                   	push   %eax
80101e13:	e8 f8 29 00 00       	call   80104810 <memmove>
    log_write(bp);
80101e18:	89 3c 24             	mov    %edi,(%esp)
80101e1b:	e8 60 12 00 00       	call   80103080 <log_write>
    brelse(bp);
80101e20:	89 3c 24             	mov    %edi,(%esp)
80101e23:	e8 b8 e3 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101e2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101e2e:	83 c4 10             	add    $0x10,%esp
80101e31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101e37:	77 97                	ja     80101dd0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101e39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101e3f:	77 37                	ja     80101e78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e47:	5b                   	pop    %ebx
80101e48:	5e                   	pop    %esi
80101e49:	5f                   	pop    %edi
80101e4a:	5d                   	pop    %ebp
80101e4b:	c3                   	ret    
80101e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101e50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e54:	66 83 f8 09          	cmp    $0x9,%ax
80101e58:	77 36                	ja     80101e90 <writei+0x120>
80101e5a:	8b 04 c5 24 0c 11 80 	mov    -0x7feef3dc(,%eax,8),%eax
80101e61:	85 c0                	test   %eax,%eax
80101e63:	74 2b                	je     80101e90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101e65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e6b:	5b                   	pop    %ebx
80101e6c:	5e                   	pop    %esi
80101e6d:	5f                   	pop    %edi
80101e6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101e6f:	ff e0                	jmp    *%eax
80101e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101e78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101e7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101e7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101e81:	50                   	push   %eax
80101e82:	e8 59 fa ff ff       	call   801018e0 <iupdate>
80101e87:	83 c4 10             	add    $0x10,%esp
80101e8a:	eb b5                	jmp    80101e41 <writei+0xd1>
80101e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e95:	eb ad                	jmp    80101e44 <writei+0xd4>
80101e97:	89 f6                	mov    %esi,%esi
80101e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ea0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ea6:	6a 0e                	push   $0xe
80101ea8:	ff 75 0c             	pushl  0xc(%ebp)
80101eab:	ff 75 08             	pushl  0x8(%ebp)
80101eae:	e8 cd 29 00 00       	call   80104880 <strncmp>
}
80101eb3:	c9                   	leave  
80101eb4:	c3                   	ret    
80101eb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ec0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	57                   	push   %edi
80101ec4:	56                   	push   %esi
80101ec5:	53                   	push   %ebx
80101ec6:	83 ec 1c             	sub    $0x1c,%esp
80101ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101ecc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ed1:	0f 85 85 00 00 00    	jne    80101f5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ed7:	8b 53 58             	mov    0x58(%ebx),%edx
80101eda:	31 ff                	xor    %edi,%edi
80101edc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101edf:	85 d2                	test   %edx,%edx
80101ee1:	74 3e                	je     80101f21 <dirlookup+0x61>
80101ee3:	90                   	nop
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ee8:	6a 10                	push   $0x10
80101eea:	57                   	push   %edi
80101eeb:	56                   	push   %esi
80101eec:	53                   	push   %ebx
80101eed:	e8 7e fd ff ff       	call   80101c70 <readi>
80101ef2:	83 c4 10             	add    $0x10,%esp
80101ef5:	83 f8 10             	cmp    $0x10,%eax
80101ef8:	75 55                	jne    80101f4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101efa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eff:	74 18                	je     80101f19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101f01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f04:	83 ec 04             	sub    $0x4,%esp
80101f07:	6a 0e                	push   $0xe
80101f09:	50                   	push   %eax
80101f0a:	ff 75 0c             	pushl  0xc(%ebp)
80101f0d:	e8 6e 29 00 00       	call   80104880 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101f12:	83 c4 10             	add    $0x10,%esp
80101f15:	85 c0                	test   %eax,%eax
80101f17:	74 17                	je     80101f30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f19:	83 c7 10             	add    $0x10,%edi
80101f1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f1f:	72 c7                	jb     80101ee8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101f24:	31 c0                	xor    %eax,%eax
}
80101f26:	5b                   	pop    %ebx
80101f27:	5e                   	pop    %esi
80101f28:	5f                   	pop    %edi
80101f29:	5d                   	pop    %ebp
80101f2a:	c3                   	ret    
80101f2b:	90                   	nop
80101f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101f30:	8b 45 10             	mov    0x10(%ebp),%eax
80101f33:	85 c0                	test   %eax,%eax
80101f35:	74 05                	je     80101f3c <dirlookup+0x7c>
        *poff = off;
80101f37:	8b 45 10             	mov    0x10(%ebp),%eax
80101f3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101f3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101f40:	8b 03                	mov    (%ebx),%eax
80101f42:	e8 d9 f5 ff ff       	call   80101520 <iget>
}
80101f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4a:	5b                   	pop    %ebx
80101f4b:	5e                   	pop    %esi
80101f4c:	5f                   	pop    %edi
80101f4d:	5d                   	pop    %ebp
80101f4e:	c3                   	ret    
      panic("dirlookup read");
80101f4f:	83 ec 0c             	sub    $0xc,%esp
80101f52:	68 19 73 10 80       	push   $0x80107319
80101f57:	e8 34 e4 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101f5c:	83 ec 0c             	sub    $0xc,%esp
80101f5f:	68 07 73 10 80       	push   $0x80107307
80101f64:	e8 27 e4 ff ff       	call   80100390 <panic>
80101f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f70:	55                   	push   %ebp
80101f71:	89 e5                	mov    %esp,%ebp
80101f73:	57                   	push   %edi
80101f74:	56                   	push   %esi
80101f75:	53                   	push   %ebx
80101f76:	89 cf                	mov    %ecx,%edi
80101f78:	89 c3                	mov    %eax,%ebx
80101f7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101f83:	0f 84 67 01 00 00    	je     801020f0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101f89:	e8 62 1b 00 00       	call   80103af0 <myproc>
  acquire(&icache.lock);
80101f8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f94:	68 a0 0c 11 80       	push   $0x80110ca0
80101f99:	e8 b2 26 00 00       	call   80104650 <acquire>
  ip->ref++;
80101f9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101fa2:	c7 04 24 a0 0c 11 80 	movl   $0x80110ca0,(%esp)
80101fa9:	e8 62 27 00 00       	call   80104710 <release>
80101fae:	83 c4 10             	add    $0x10,%esp
80101fb1:	eb 08                	jmp    80101fbb <namex+0x4b>
80101fb3:	90                   	nop
80101fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101fb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101fbb:	0f b6 03             	movzbl (%ebx),%eax
80101fbe:	3c 2f                	cmp    $0x2f,%al
80101fc0:	74 f6                	je     80101fb8 <namex+0x48>
  if(*path == 0)
80101fc2:	84 c0                	test   %al,%al
80101fc4:	0f 84 ee 00 00 00    	je     801020b8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101fca:	0f b6 03             	movzbl (%ebx),%eax
80101fcd:	3c 2f                	cmp    $0x2f,%al
80101fcf:	0f 84 b3 00 00 00    	je     80102088 <namex+0x118>
80101fd5:	84 c0                	test   %al,%al
80101fd7:	89 da                	mov    %ebx,%edx
80101fd9:	75 09                	jne    80101fe4 <namex+0x74>
80101fdb:	e9 a8 00 00 00       	jmp    80102088 <namex+0x118>
80101fe0:	84 c0                	test   %al,%al
80101fe2:	74 0a                	je     80101fee <namex+0x7e>
    path++;
80101fe4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101fe7:	0f b6 02             	movzbl (%edx),%eax
80101fea:	3c 2f                	cmp    $0x2f,%al
80101fec:	75 f2                	jne    80101fe0 <namex+0x70>
80101fee:	89 d1                	mov    %edx,%ecx
80101ff0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ff2:	83 f9 0d             	cmp    $0xd,%ecx
80101ff5:	0f 8e 91 00 00 00    	jle    8010208c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ffb:	83 ec 04             	sub    $0x4,%esp
80101ffe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102001:	6a 0e                	push   $0xe
80102003:	53                   	push   %ebx
80102004:	57                   	push   %edi
80102005:	e8 06 28 00 00       	call   80104810 <memmove>
    path++;
8010200a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
8010200d:	83 c4 10             	add    $0x10,%esp
    path++;
80102010:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80102012:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102015:	75 11                	jne    80102028 <namex+0xb8>
80102017:	89 f6                	mov    %esi,%esi
80102019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80102020:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80102023:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102026:	74 f8                	je     80102020 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102028:	83 ec 0c             	sub    $0xc,%esp
8010202b:	56                   	push   %esi
8010202c:	e8 5f f9 ff ff       	call   80101990 <ilock>
    if(ip->type != T_DIR){
80102031:	83 c4 10             	add    $0x10,%esp
80102034:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102039:	0f 85 91 00 00 00    	jne    801020d0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010203f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102042:	85 d2                	test   %edx,%edx
80102044:	74 09                	je     8010204f <namex+0xdf>
80102046:	80 3b 00             	cmpb   $0x0,(%ebx)
80102049:	0f 84 b7 00 00 00    	je     80102106 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010204f:	83 ec 04             	sub    $0x4,%esp
80102052:	6a 00                	push   $0x0
80102054:	57                   	push   %edi
80102055:	56                   	push   %esi
80102056:	e8 65 fe ff ff       	call   80101ec0 <dirlookup>
8010205b:	83 c4 10             	add    $0x10,%esp
8010205e:	85 c0                	test   %eax,%eax
80102060:	74 6e                	je     801020d0 <namex+0x160>
  iunlock(ip);
80102062:	83 ec 0c             	sub    $0xc,%esp
80102065:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102068:	56                   	push   %esi
80102069:	e8 02 fa ff ff       	call   80101a70 <iunlock>
  iput(ip);
8010206e:	89 34 24             	mov    %esi,(%esp)
80102071:	e8 4a fa ff ff       	call   80101ac0 <iput>
80102076:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102079:	83 c4 10             	add    $0x10,%esp
8010207c:	89 c6                	mov    %eax,%esi
8010207e:	e9 38 ff ff ff       	jmp    80101fbb <namex+0x4b>
80102083:	90                   	nop
80102084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80102088:	89 da                	mov    %ebx,%edx
8010208a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
8010208c:	83 ec 04             	sub    $0x4,%esp
8010208f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102092:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102095:	51                   	push   %ecx
80102096:	53                   	push   %ebx
80102097:	57                   	push   %edi
80102098:	e8 73 27 00 00       	call   80104810 <memmove>
    name[len] = 0;
8010209d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801020a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801020a3:	83 c4 10             	add    $0x10,%esp
801020a6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
801020aa:	89 d3                	mov    %edx,%ebx
801020ac:	e9 61 ff ff ff       	jmp    80102012 <namex+0xa2>
801020b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801020b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801020bb:	85 c0                	test   %eax,%eax
801020bd:	75 5d                	jne    8010211c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
801020bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c2:	89 f0                	mov    %esi,%eax
801020c4:	5b                   	pop    %ebx
801020c5:	5e                   	pop    %esi
801020c6:	5f                   	pop    %edi
801020c7:	5d                   	pop    %ebp
801020c8:	c3                   	ret    
801020c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801020d0:	83 ec 0c             	sub    $0xc,%esp
801020d3:	56                   	push   %esi
801020d4:	e8 97 f9 ff ff       	call   80101a70 <iunlock>
  iput(ip);
801020d9:	89 34 24             	mov    %esi,(%esp)
      return 0;
801020dc:	31 f6                	xor    %esi,%esi
  iput(ip);
801020de:	e8 dd f9 ff ff       	call   80101ac0 <iput>
      return 0;
801020e3:	83 c4 10             	add    $0x10,%esp
}
801020e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e9:	89 f0                	mov    %esi,%eax
801020eb:	5b                   	pop    %ebx
801020ec:	5e                   	pop    %esi
801020ed:	5f                   	pop    %edi
801020ee:	5d                   	pop    %ebp
801020ef:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
801020f0:	ba 01 00 00 00       	mov    $0x1,%edx
801020f5:	b8 01 00 00 00       	mov    $0x1,%eax
801020fa:	e8 21 f4 ff ff       	call   80101520 <iget>
801020ff:	89 c6                	mov    %eax,%esi
80102101:	e9 b5 fe ff ff       	jmp    80101fbb <namex+0x4b>
      iunlock(ip);
80102106:	83 ec 0c             	sub    $0xc,%esp
80102109:	56                   	push   %esi
8010210a:	e8 61 f9 ff ff       	call   80101a70 <iunlock>
      return ip;
8010210f:	83 c4 10             	add    $0x10,%esp
}
80102112:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102115:	89 f0                	mov    %esi,%eax
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
    iput(ip);
8010211c:	83 ec 0c             	sub    $0xc,%esp
8010211f:	56                   	push   %esi
    return 0;
80102120:	31 f6                	xor    %esi,%esi
    iput(ip);
80102122:	e8 99 f9 ff ff       	call   80101ac0 <iput>
    return 0;
80102127:	83 c4 10             	add    $0x10,%esp
8010212a:	eb 93                	jmp    801020bf <namex+0x14f>
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102130 <dirlink>:
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	57                   	push   %edi
80102134:	56                   	push   %esi
80102135:	53                   	push   %ebx
80102136:	83 ec 20             	sub    $0x20,%esp
80102139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010213c:	6a 00                	push   $0x0
8010213e:	ff 75 0c             	pushl  0xc(%ebp)
80102141:	53                   	push   %ebx
80102142:	e8 79 fd ff ff       	call   80101ec0 <dirlookup>
80102147:	83 c4 10             	add    $0x10,%esp
8010214a:	85 c0                	test   %eax,%eax
8010214c:	75 67                	jne    801021b5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010214e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102151:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102154:	85 ff                	test   %edi,%edi
80102156:	74 29                	je     80102181 <dirlink+0x51>
80102158:	31 ff                	xor    %edi,%edi
8010215a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010215d:	eb 09                	jmp    80102168 <dirlink+0x38>
8010215f:	90                   	nop
80102160:	83 c7 10             	add    $0x10,%edi
80102163:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102166:	73 19                	jae    80102181 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102168:	6a 10                	push   $0x10
8010216a:	57                   	push   %edi
8010216b:	56                   	push   %esi
8010216c:	53                   	push   %ebx
8010216d:	e8 fe fa ff ff       	call   80101c70 <readi>
80102172:	83 c4 10             	add    $0x10,%esp
80102175:	83 f8 10             	cmp    $0x10,%eax
80102178:	75 4e                	jne    801021c8 <dirlink+0x98>
    if(de.inum == 0)
8010217a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010217f:	75 df                	jne    80102160 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102181:	8d 45 da             	lea    -0x26(%ebp),%eax
80102184:	83 ec 04             	sub    $0x4,%esp
80102187:	6a 0e                	push   $0xe
80102189:	ff 75 0c             	pushl  0xc(%ebp)
8010218c:	50                   	push   %eax
8010218d:	e8 4e 27 00 00       	call   801048e0 <strncpy>
  de.inum = inum;
80102192:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102195:	6a 10                	push   $0x10
80102197:	57                   	push   %edi
80102198:	56                   	push   %esi
80102199:	53                   	push   %ebx
  de.inum = inum;
8010219a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010219e:	e8 cd fb ff ff       	call   80101d70 <writei>
801021a3:	83 c4 20             	add    $0x20,%esp
801021a6:	83 f8 10             	cmp    $0x10,%eax
801021a9:	75 2a                	jne    801021d5 <dirlink+0xa5>
  return 0;
801021ab:	31 c0                	xor    %eax,%eax
}
801021ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b0:	5b                   	pop    %ebx
801021b1:	5e                   	pop    %esi
801021b2:	5f                   	pop    %edi
801021b3:	5d                   	pop    %ebp
801021b4:	c3                   	ret    
    iput(ip);
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	50                   	push   %eax
801021b9:	e8 02 f9 ff ff       	call   80101ac0 <iput>
    return -1;
801021be:	83 c4 10             	add    $0x10,%esp
801021c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021c6:	eb e5                	jmp    801021ad <dirlink+0x7d>
      panic("dirlink read");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 28 73 10 80       	push   $0x80107328
801021d0:	e8 bb e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 1e 79 10 80       	push   $0x8010791e
801021dd:	e8 ae e1 ff ff       	call   80100390 <panic>
801021e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021f0 <namei>:

struct inode*
namei(char *path)
{
801021f0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021f1:	31 d2                	xor    %edx,%edx
{
801021f3:	89 e5                	mov    %esp,%ebp
801021f5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021f8:	8b 45 08             	mov    0x8(%ebp),%eax
801021fb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021fe:	e8 6d fd ff ff       	call   80101f70 <namex>
}
80102203:	c9                   	leave  
80102204:	c3                   	ret    
80102205:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102210 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102210:	55                   	push   %ebp
  return namex(path, 1, name);
80102211:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102216:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102218:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010221b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010221e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010221f:	e9 4c fd ff ff       	jmp    80101f70 <namex>
80102224:	66 90                	xchg   %ax,%ax
80102226:	66 90                	xchg   %ax,%ax
80102228:	66 90                	xchg   %ax,%ax
8010222a:	66 90                	xchg   %ax,%ax
8010222c:	66 90                	xchg   %ax,%ax
8010222e:	66 90                	xchg   %ax,%ax

80102230 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	57                   	push   %edi
80102234:	56                   	push   %esi
80102235:	53                   	push   %ebx
80102236:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102239:	85 c0                	test   %eax,%eax
8010223b:	0f 84 b4 00 00 00    	je     801022f5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102241:	8b 58 08             	mov    0x8(%eax),%ebx
80102244:	89 c6                	mov    %eax,%esi
80102246:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010224c:	0f 87 96 00 00 00    	ja     801022e8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102252:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102257:	89 f6                	mov    %esi,%esi
80102259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102260:	89 ca                	mov    %ecx,%edx
80102262:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102263:	83 e0 c0             	and    $0xffffffc0,%eax
80102266:	3c 40                	cmp    $0x40,%al
80102268:	75 f6                	jne    80102260 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010226a:	31 ff                	xor    %edi,%edi
8010226c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102271:	89 f8                	mov    %edi,%eax
80102273:	ee                   	out    %al,(%dx)
80102274:	b8 01 00 00 00       	mov    $0x1,%eax
80102279:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010227e:	ee                   	out    %al,(%dx)
8010227f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102284:	89 d8                	mov    %ebx,%eax
80102286:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102287:	89 d8                	mov    %ebx,%eax
80102289:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010228e:	c1 f8 08             	sar    $0x8,%eax
80102291:	ee                   	out    %al,(%dx)
80102292:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102297:	89 f8                	mov    %edi,%eax
80102299:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010229a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010229e:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022a3:	c1 e0 04             	shl    $0x4,%eax
801022a6:	83 e0 10             	and    $0x10,%eax
801022a9:	83 c8 e0             	or     $0xffffffe0,%eax
801022ac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801022ad:	f6 06 04             	testb  $0x4,(%esi)
801022b0:	75 16                	jne    801022c8 <idestart+0x98>
801022b2:	b8 20 00 00 00       	mov    $0x20,%eax
801022b7:	89 ca                	mov    %ecx,%edx
801022b9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801022ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022bd:	5b                   	pop    %ebx
801022be:	5e                   	pop    %esi
801022bf:	5f                   	pop    %edi
801022c0:	5d                   	pop    %ebp
801022c1:	c3                   	ret    
801022c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022c8:	b8 30 00 00 00       	mov    $0x30,%eax
801022cd:	89 ca                	mov    %ecx,%edx
801022cf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801022d0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801022d5:	83 c6 5c             	add    $0x5c,%esi
801022d8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022dd:	fc                   	cld    
801022de:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801022e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e3:	5b                   	pop    %ebx
801022e4:	5e                   	pop    %esi
801022e5:	5f                   	pop    %edi
801022e6:	5d                   	pop    %ebp
801022e7:	c3                   	ret    
    panic("incorrect blockno");
801022e8:	83 ec 0c             	sub    $0xc,%esp
801022eb:	68 94 73 10 80       	push   $0x80107394
801022f0:	e8 9b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
801022f5:	83 ec 0c             	sub    $0xc,%esp
801022f8:	68 8b 73 10 80       	push   $0x8010738b
801022fd:	e8 8e e0 ff ff       	call   80100390 <panic>
80102302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102310 <ideinit>:
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102316:	68 a6 73 10 80       	push   $0x801073a6
8010231b:	68 c0 a5 10 80       	push   $0x8010a5c0
80102320:	e8 eb 21 00 00       	call   80104510 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102325:	58                   	pop    %eax
80102326:	a1 c0 2f 11 80       	mov    0x80112fc0,%eax
8010232b:	5a                   	pop    %edx
8010232c:	83 e8 01             	sub    $0x1,%eax
8010232f:	50                   	push   %eax
80102330:	6a 0e                	push   $0xe
80102332:	e8 a9 02 00 00       	call   801025e0 <ioapicenable>
80102337:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010233a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010233f:	90                   	nop
80102340:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102341:	83 e0 c0             	and    $0xffffffc0,%eax
80102344:	3c 40                	cmp    $0x40,%al
80102346:	75 f8                	jne    80102340 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102348:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010234d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102352:	ee                   	out    %al,(%dx)
80102353:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102358:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010235d:	eb 06                	jmp    80102365 <ideinit+0x55>
8010235f:	90                   	nop
  for(i=0; i<1000; i++){
80102360:	83 e9 01             	sub    $0x1,%ecx
80102363:	74 0f                	je     80102374 <ideinit+0x64>
80102365:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102366:	84 c0                	test   %al,%al
80102368:	74 f6                	je     80102360 <ideinit+0x50>
      havedisk1 = 1;
8010236a:	c7 05 a0 a5 10 80 01 	movl   $0x1,0x8010a5a0
80102371:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102374:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102379:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010237e:	ee                   	out    %al,(%dx)
}
8010237f:	c9                   	leave  
80102380:	c3                   	ret    
80102381:	eb 0d                	jmp    80102390 <ideintr>
80102383:	90                   	nop
80102384:	90                   	nop
80102385:	90                   	nop
80102386:	90                   	nop
80102387:	90                   	nop
80102388:	90                   	nop
80102389:	90                   	nop
8010238a:	90                   	nop
8010238b:	90                   	nop
8010238c:	90                   	nop
8010238d:	90                   	nop
8010238e:	90                   	nop
8010238f:	90                   	nop

80102390 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	57                   	push   %edi
80102394:	56                   	push   %esi
80102395:	53                   	push   %ebx
80102396:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102399:	68 c0 a5 10 80       	push   $0x8010a5c0
8010239e:	e8 ad 22 00 00       	call   80104650 <acquire>

  if((b = idequeue) == 0){
801023a3:	8b 1d a4 a5 10 80    	mov    0x8010a5a4,%ebx
801023a9:	83 c4 10             	add    $0x10,%esp
801023ac:	85 db                	test   %ebx,%ebx
801023ae:	74 67                	je     80102417 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801023b0:	8b 43 58             	mov    0x58(%ebx),%eax
801023b3:	a3 a4 a5 10 80       	mov    %eax,0x8010a5a4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801023b8:	8b 3b                	mov    (%ebx),%edi
801023ba:	f7 c7 04 00 00 00    	test   $0x4,%edi
801023c0:	75 31                	jne    801023f3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023c7:	89 f6                	mov    %esi,%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801023d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023d1:	89 c6                	mov    %eax,%esi
801023d3:	83 e6 c0             	and    $0xffffffc0,%esi
801023d6:	89 f1                	mov    %esi,%ecx
801023d8:	80 f9 40             	cmp    $0x40,%cl
801023db:	75 f3                	jne    801023d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801023dd:	a8 21                	test   $0x21,%al
801023df:	75 12                	jne    801023f3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801023e1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801023e4:	b9 80 00 00 00       	mov    $0x80,%ecx
801023e9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023ee:	fc                   	cld    
801023ef:	f3 6d                	rep insl (%dx),%es:(%edi)
801023f1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801023f3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801023f6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801023f9:	89 f9                	mov    %edi,%ecx
801023fb:	83 c9 02             	or     $0x2,%ecx
801023fe:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102400:	53                   	push   %ebx
80102401:	e8 3a 1e 00 00       	call   80104240 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102406:	a1 a4 a5 10 80       	mov    0x8010a5a4,%eax
8010240b:	83 c4 10             	add    $0x10,%esp
8010240e:	85 c0                	test   %eax,%eax
80102410:	74 05                	je     80102417 <ideintr+0x87>
    idestart(idequeue);
80102412:	e8 19 fe ff ff       	call   80102230 <idestart>
    release(&idelock);
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 c0 a5 10 80       	push   $0x8010a5c0
8010241f:	e8 ec 22 00 00       	call   80104710 <release>

  release(&idelock);
}
80102424:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102427:	5b                   	pop    %ebx
80102428:	5e                   	pop    %esi
80102429:	5f                   	pop    %edi
8010242a:	5d                   	pop    %ebp
8010242b:	c3                   	ret    
8010242c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102430 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	53                   	push   %ebx
80102434:	83 ec 10             	sub    $0x10,%esp
80102437:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010243a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010243d:	50                   	push   %eax
8010243e:	e8 7d 20 00 00       	call   801044c0 <holdingsleep>
80102443:	83 c4 10             	add    $0x10,%esp
80102446:	85 c0                	test   %eax,%eax
80102448:	0f 84 c6 00 00 00    	je     80102514 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010244e:	8b 03                	mov    (%ebx),%eax
80102450:	83 e0 06             	and    $0x6,%eax
80102453:	83 f8 02             	cmp    $0x2,%eax
80102456:	0f 84 ab 00 00 00    	je     80102507 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010245c:	8b 53 04             	mov    0x4(%ebx),%edx
8010245f:	85 d2                	test   %edx,%edx
80102461:	74 0d                	je     80102470 <iderw+0x40>
80102463:	a1 a0 a5 10 80       	mov    0x8010a5a0,%eax
80102468:	85 c0                	test   %eax,%eax
8010246a:	0f 84 b1 00 00 00    	je     80102521 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102470:	83 ec 0c             	sub    $0xc,%esp
80102473:	68 c0 a5 10 80       	push   $0x8010a5c0
80102478:	e8 d3 21 00 00       	call   80104650 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010247d:	8b 15 a4 a5 10 80    	mov    0x8010a5a4,%edx
80102483:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102486:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010248d:	85 d2                	test   %edx,%edx
8010248f:	75 09                	jne    8010249a <iderw+0x6a>
80102491:	eb 6d                	jmp    80102500 <iderw+0xd0>
80102493:	90                   	nop
80102494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102498:	89 c2                	mov    %eax,%edx
8010249a:	8b 42 58             	mov    0x58(%edx),%eax
8010249d:	85 c0                	test   %eax,%eax
8010249f:	75 f7                	jne    80102498 <iderw+0x68>
801024a1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801024a4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801024a6:	39 1d a4 a5 10 80    	cmp    %ebx,0x8010a5a4
801024ac:	74 42                	je     801024f0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024ae:	8b 03                	mov    (%ebx),%eax
801024b0:	83 e0 06             	and    $0x6,%eax
801024b3:	83 f8 02             	cmp    $0x2,%eax
801024b6:	74 23                	je     801024db <iderw+0xab>
801024b8:	90                   	nop
801024b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801024c0:	83 ec 08             	sub    $0x8,%esp
801024c3:	68 c0 a5 10 80       	push   $0x8010a5c0
801024c8:	53                   	push   %ebx
801024c9:	e8 c2 1b 00 00       	call   80104090 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024ce:	8b 03                	mov    (%ebx),%eax
801024d0:	83 c4 10             	add    $0x10,%esp
801024d3:	83 e0 06             	and    $0x6,%eax
801024d6:	83 f8 02             	cmp    $0x2,%eax
801024d9:	75 e5                	jne    801024c0 <iderw+0x90>
  }


  release(&idelock);
801024db:	c7 45 08 c0 a5 10 80 	movl   $0x8010a5c0,0x8(%ebp)
}
801024e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024e5:	c9                   	leave  
  release(&idelock);
801024e6:	e9 25 22 00 00       	jmp    80104710 <release>
801024eb:	90                   	nop
801024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801024f0:	89 d8                	mov    %ebx,%eax
801024f2:	e8 39 fd ff ff       	call   80102230 <idestart>
801024f7:	eb b5                	jmp    801024ae <iderw+0x7e>
801024f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102500:	ba a4 a5 10 80       	mov    $0x8010a5a4,%edx
80102505:	eb 9d                	jmp    801024a4 <iderw+0x74>
    panic("iderw: nothing to do");
80102507:	83 ec 0c             	sub    $0xc,%esp
8010250a:	68 c0 73 10 80       	push   $0x801073c0
8010250f:	e8 7c de ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102514:	83 ec 0c             	sub    $0xc,%esp
80102517:	68 aa 73 10 80       	push   $0x801073aa
8010251c:	e8 6f de ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102521:	83 ec 0c             	sub    $0xc,%esp
80102524:	68 d5 73 10 80       	push   $0x801073d5
80102529:	e8 62 de ff ff       	call   80100390 <panic>
8010252e:	66 90                	xchg   %ax,%ax

80102530 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102530:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102531:	c7 05 f4 28 11 80 00 	movl   $0xfec00000,0x801128f4
80102538:	00 c0 fe 
{
8010253b:	89 e5                	mov    %esp,%ebp
8010253d:	56                   	push   %esi
8010253e:	53                   	push   %ebx
  ioapic->reg = reg;
8010253f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102546:	00 00 00 
  return ioapic->data;
80102549:	a1 f4 28 11 80       	mov    0x801128f4,%eax
8010254e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102551:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102557:	8b 0d f4 28 11 80    	mov    0x801128f4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010255d:	0f b6 15 20 2a 11 80 	movzbl 0x80112a20,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102564:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102567:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010256a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010256d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102570:	39 c2                	cmp    %eax,%edx
80102572:	74 16                	je     8010258a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102574:	83 ec 0c             	sub    $0xc,%esp
80102577:	68 f4 73 10 80       	push   $0x801073f4
8010257c:	e8 df e0 ff ff       	call   80100660 <cprintf>
80102581:	8b 0d f4 28 11 80    	mov    0x801128f4,%ecx
80102587:	83 c4 10             	add    $0x10,%esp
8010258a:	83 c3 21             	add    $0x21,%ebx
{
8010258d:	ba 10 00 00 00       	mov    $0x10,%edx
80102592:	b8 20 00 00 00       	mov    $0x20,%eax
80102597:	89 f6                	mov    %esi,%esi
80102599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801025a0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801025a2:	8b 0d f4 28 11 80    	mov    0x801128f4,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801025a8:	89 c6                	mov    %eax,%esi
801025aa:	81 ce 00 00 01 00    	or     $0x10000,%esi
801025b0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801025b3:	89 71 10             	mov    %esi,0x10(%ecx)
801025b6:	8d 72 01             	lea    0x1(%edx),%esi
801025b9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801025bc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801025be:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801025c0:	8b 0d f4 28 11 80    	mov    0x801128f4,%ecx
801025c6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801025cd:	75 d1                	jne    801025a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801025cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d2:	5b                   	pop    %ebx
801025d3:	5e                   	pop    %esi
801025d4:	5d                   	pop    %ebp
801025d5:	c3                   	ret    
801025d6:	8d 76 00             	lea    0x0(%esi),%esi
801025d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801025e0:	55                   	push   %ebp
  ioapic->reg = reg;
801025e1:	8b 0d f4 28 11 80    	mov    0x801128f4,%ecx
{
801025e7:	89 e5                	mov    %esp,%ebp
801025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801025ec:	8d 50 20             	lea    0x20(%eax),%edx
801025ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801025f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025f5:	8b 0d f4 28 11 80    	mov    0x801128f4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801025fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102601:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102604:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102606:	a1 f4 28 11 80       	mov    0x801128f4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010260b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010260e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102611:	5d                   	pop    %ebp
80102612:	c3                   	ret    
80102613:	66 90                	xchg   %ax,%ax
80102615:	66 90                	xchg   %ax,%ax
80102617:	66 90                	xchg   %ax,%ax
80102619:	66 90                	xchg   %ax,%ax
8010261b:	66 90                	xchg   %ax,%ax
8010261d:	66 90                	xchg   %ax,%ax
8010261f:	90                   	nop

80102620 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	53                   	push   %ebx
80102624:	83 ec 04             	sub    $0x4,%esp
80102627:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010262a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102630:	75 70                	jne    801026a2 <kfree+0x82>
80102632:	81 fb 68 57 11 80    	cmp    $0x80115768,%ebx
80102638:	72 68                	jb     801026a2 <kfree+0x82>
8010263a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102640:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102645:	77 5b                	ja     801026a2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102647:	83 ec 04             	sub    $0x4,%esp
8010264a:	68 00 10 00 00       	push   $0x1000
8010264f:	6a 01                	push   $0x1
80102651:	53                   	push   %ebx
80102652:	e8 09 21 00 00       	call   80104760 <memset>

  if(kmem.use_lock)
80102657:	8b 15 34 29 11 80    	mov    0x80112934,%edx
8010265d:	83 c4 10             	add    $0x10,%esp
80102660:	85 d2                	test   %edx,%edx
80102662:	75 2c                	jne    80102690 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102664:	a1 38 29 11 80       	mov    0x80112938,%eax
80102669:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010266b:	a1 34 29 11 80       	mov    0x80112934,%eax
  kmem.freelist = r;
80102670:	89 1d 38 29 11 80    	mov    %ebx,0x80112938
  if(kmem.use_lock)
80102676:	85 c0                	test   %eax,%eax
80102678:	75 06                	jne    80102680 <kfree+0x60>
    release(&kmem.lock);
}
8010267a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010267d:	c9                   	leave  
8010267e:	c3                   	ret    
8010267f:	90                   	nop
    release(&kmem.lock);
80102680:	c7 45 08 00 29 11 80 	movl   $0x80112900,0x8(%ebp)
}
80102687:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010268a:	c9                   	leave  
    release(&kmem.lock);
8010268b:	e9 80 20 00 00       	jmp    80104710 <release>
    acquire(&kmem.lock);
80102690:	83 ec 0c             	sub    $0xc,%esp
80102693:	68 00 29 11 80       	push   $0x80112900
80102698:	e8 b3 1f 00 00       	call   80104650 <acquire>
8010269d:	83 c4 10             	add    $0x10,%esp
801026a0:	eb c2                	jmp    80102664 <kfree+0x44>
    panic("kfree");
801026a2:	83 ec 0c             	sub    $0xc,%esp
801026a5:	68 26 74 10 80       	push   $0x80107426
801026aa:	e8 e1 dc ff ff       	call   80100390 <panic>
801026af:	90                   	nop

801026b0 <freerange>:
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	56                   	push   %esi
801026b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801026bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026cd:	39 de                	cmp    %ebx,%esi
801026cf:	72 23                	jb     801026f4 <freerange+0x44>
801026d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026de:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026e7:	50                   	push   %eax
801026e8:	e8 33 ff ff ff       	call   80102620 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	39 f3                	cmp    %esi,%ebx
801026f2:	76 e4                	jbe    801026d8 <freerange+0x28>
}
801026f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026f7:	5b                   	pop    %ebx
801026f8:	5e                   	pop    %esi
801026f9:	5d                   	pop    %ebp
801026fa:	c3                   	ret    
801026fb:	90                   	nop
801026fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102700 <kinit1>:
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	56                   	push   %esi
80102704:	53                   	push   %ebx
80102705:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102708:	83 ec 08             	sub    $0x8,%esp
8010270b:	68 2c 74 10 80       	push   $0x8010742c
80102710:	68 00 29 11 80       	push   $0x80112900
80102715:	e8 f6 1d 00 00       	call   80104510 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010271a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010271d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102720:	c7 05 34 29 11 80 00 	movl   $0x0,0x80112934
80102727:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010272a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102730:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102736:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010273c:	39 de                	cmp    %ebx,%esi
8010273e:	72 1c                	jb     8010275c <kinit1+0x5c>
    kfree(p);
80102740:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102746:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102749:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010274f:	50                   	push   %eax
80102750:	e8 cb fe ff ff       	call   80102620 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102755:	83 c4 10             	add    $0x10,%esp
80102758:	39 de                	cmp    %ebx,%esi
8010275a:	73 e4                	jae    80102740 <kinit1+0x40>
}
8010275c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010275f:	5b                   	pop    %ebx
80102760:	5e                   	pop    %esi
80102761:	5d                   	pop    %ebp
80102762:	c3                   	ret    
80102763:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <kinit2>:
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	56                   	push   %esi
80102774:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102775:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102778:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010277b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102781:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102787:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010278d:	39 de                	cmp    %ebx,%esi
8010278f:	72 23                	jb     801027b4 <kinit2+0x44>
80102791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102798:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010279e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027a7:	50                   	push   %eax
801027a8:	e8 73 fe ff ff       	call   80102620 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027ad:	83 c4 10             	add    $0x10,%esp
801027b0:	39 de                	cmp    %ebx,%esi
801027b2:	73 e4                	jae    80102798 <kinit2+0x28>
  kmem.use_lock = 1;
801027b4:	c7 05 34 29 11 80 01 	movl   $0x1,0x80112934
801027bb:	00 00 00 
}
801027be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027c1:	5b                   	pop    %ebx
801027c2:	5e                   	pop    %esi
801027c3:	5d                   	pop    %ebp
801027c4:	c3                   	ret    
801027c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801027d0:	a1 34 29 11 80       	mov    0x80112934,%eax
801027d5:	85 c0                	test   %eax,%eax
801027d7:	75 1f                	jne    801027f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027d9:	a1 38 29 11 80       	mov    0x80112938,%eax
  if(r)
801027de:	85 c0                	test   %eax,%eax
801027e0:	74 0e                	je     801027f0 <kalloc+0x20>
    kmem.freelist = r->next;
801027e2:	8b 10                	mov    (%eax),%edx
801027e4:	89 15 38 29 11 80    	mov    %edx,0x80112938
801027ea:	c3                   	ret    
801027eb:	90                   	nop
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801027f0:	f3 c3                	repz ret 
801027f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801027f8:	55                   	push   %ebp
801027f9:	89 e5                	mov    %esp,%ebp
801027fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027fe:	68 00 29 11 80       	push   $0x80112900
80102803:	e8 48 1e 00 00       	call   80104650 <acquire>
  r = kmem.freelist;
80102808:	a1 38 29 11 80       	mov    0x80112938,%eax
  if(r)
8010280d:	83 c4 10             	add    $0x10,%esp
80102810:	8b 15 34 29 11 80    	mov    0x80112934,%edx
80102816:	85 c0                	test   %eax,%eax
80102818:	74 08                	je     80102822 <kalloc+0x52>
    kmem.freelist = r->next;
8010281a:	8b 08                	mov    (%eax),%ecx
8010281c:	89 0d 38 29 11 80    	mov    %ecx,0x80112938
  if(kmem.use_lock)
80102822:	85 d2                	test   %edx,%edx
80102824:	74 16                	je     8010283c <kalloc+0x6c>
    release(&kmem.lock);
80102826:	83 ec 0c             	sub    $0xc,%esp
80102829:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010282c:	68 00 29 11 80       	push   $0x80112900
80102831:	e8 da 1e 00 00       	call   80104710 <release>
  return (char*)r;
80102836:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102839:	83 c4 10             	add    $0x10,%esp
}
8010283c:	c9                   	leave  
8010283d:	c3                   	ret    
8010283e:	66 90                	xchg   %ax,%ax

80102840 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102840:	ba 64 00 00 00       	mov    $0x64,%edx
80102845:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102846:	a8 01                	test   $0x1,%al
80102848:	0f 84 c2 00 00 00    	je     80102910 <kbdgetc+0xd0>
8010284e:	ba 60 00 00 00       	mov    $0x60,%edx
80102853:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102854:	0f b6 d0             	movzbl %al,%edx
80102857:	8b 0d f4 a5 10 80    	mov    0x8010a5f4,%ecx

  if(data == 0xE0){
8010285d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102863:	0f 84 7f 00 00 00    	je     801028e8 <kbdgetc+0xa8>
{
80102869:	55                   	push   %ebp
8010286a:	89 e5                	mov    %esp,%ebp
8010286c:	53                   	push   %ebx
8010286d:	89 cb                	mov    %ecx,%ebx
8010286f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102872:	84 c0                	test   %al,%al
80102874:	78 4a                	js     801028c0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102876:	85 db                	test   %ebx,%ebx
80102878:	74 09                	je     80102883 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010287a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010287d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102880:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102883:	0f b6 82 60 75 10 80 	movzbl -0x7fef8aa0(%edx),%eax
8010288a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010288c:	0f b6 82 60 74 10 80 	movzbl -0x7fef8ba0(%edx),%eax
80102893:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102895:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102897:	89 0d f4 a5 10 80    	mov    %ecx,0x8010a5f4
  c = charcode[shift & (CTL | SHIFT)][data];
8010289d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801028a0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801028a3:	8b 04 85 40 74 10 80 	mov    -0x7fef8bc0(,%eax,4),%eax
801028aa:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801028ae:	74 31                	je     801028e1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801028b0:	8d 50 9f             	lea    -0x61(%eax),%edx
801028b3:	83 fa 19             	cmp    $0x19,%edx
801028b6:	77 40                	ja     801028f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801028b8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801028bb:	5b                   	pop    %ebx
801028bc:	5d                   	pop    %ebp
801028bd:	c3                   	ret    
801028be:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801028c0:	83 e0 7f             	and    $0x7f,%eax
801028c3:	85 db                	test   %ebx,%ebx
801028c5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801028c8:	0f b6 82 60 75 10 80 	movzbl -0x7fef8aa0(%edx),%eax
801028cf:	83 c8 40             	or     $0x40,%eax
801028d2:	0f b6 c0             	movzbl %al,%eax
801028d5:	f7 d0                	not    %eax
801028d7:	21 c1                	and    %eax,%ecx
    return 0;
801028d9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801028db:	89 0d f4 a5 10 80    	mov    %ecx,0x8010a5f4
}
801028e1:	5b                   	pop    %ebx
801028e2:	5d                   	pop    %ebp
801028e3:	c3                   	ret    
801028e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801028e8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801028eb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801028ed:	89 0d f4 a5 10 80    	mov    %ecx,0x8010a5f4
    return 0;
801028f3:	c3                   	ret    
801028f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801028f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801028fb:	8d 50 20             	lea    0x20(%eax),%edx
}
801028fe:	5b                   	pop    %ebx
      c += 'a' - 'A';
801028ff:	83 f9 1a             	cmp    $0x1a,%ecx
80102902:	0f 42 c2             	cmovb  %edx,%eax
}
80102905:	5d                   	pop    %ebp
80102906:	c3                   	ret    
80102907:	89 f6                	mov    %esi,%esi
80102909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102915:	c3                   	ret    
80102916:	8d 76 00             	lea    0x0(%esi),%esi
80102919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102920 <kbdintr>:

void
kbdintr(void)
{
80102920:	55                   	push   %ebp
80102921:	89 e5                	mov    %esp,%ebp
80102923:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102926:	68 40 28 10 80       	push   $0x80102840
8010292b:	e8 b0 e1 ff ff       	call   80100ae0 <consoleintr>
}
80102930:	83 c4 10             	add    $0x10,%esp
80102933:	c9                   	leave  
80102934:	c3                   	ret    
80102935:	66 90                	xchg   %ax,%ax
80102937:	66 90                	xchg   %ax,%ax
80102939:	66 90                	xchg   %ax,%ax
8010293b:	66 90                	xchg   %ax,%ax
8010293d:	66 90                	xchg   %ax,%ax
8010293f:	90                   	nop

80102940 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102940:	a1 3c 29 11 80       	mov    0x8011293c,%eax
{
80102945:	55                   	push   %ebp
80102946:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102948:	85 c0                	test   %eax,%eax
8010294a:	0f 84 c8 00 00 00    	je     80102a18 <lapicinit+0xd8>
  lapic[index] = value;
80102950:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102957:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010295d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102964:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010296a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102971:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102974:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102977:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010297e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102981:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102984:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010298b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010298e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102991:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102998:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010299b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010299e:	8b 50 30             	mov    0x30(%eax),%edx
801029a1:	c1 ea 10             	shr    $0x10,%edx
801029a4:	80 fa 03             	cmp    $0x3,%dl
801029a7:	77 77                	ja     80102a20 <lapicinit+0xe0>
  lapic[index] = value;
801029a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801029b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029f1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029f4:	8b 50 20             	mov    0x20(%eax),%edx
801029f7:	89 f6                	mov    %esi,%esi
801029f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a00:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a06:	80 e6 10             	and    $0x10,%dh
80102a09:	75 f5                	jne    80102a00 <lapicinit+0xc0>
  lapic[index] = value;
80102a0b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a12:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a15:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a18:	5d                   	pop    %ebp
80102a19:	c3                   	ret    
80102a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102a20:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a27:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2a:	8b 50 20             	mov    0x20(%eax),%edx
80102a2d:	e9 77 ff ff ff       	jmp    801029a9 <lapicinit+0x69>
80102a32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a40 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a40:	8b 15 3c 29 11 80    	mov    0x8011293c,%edx
{
80102a46:	55                   	push   %ebp
80102a47:	31 c0                	xor    %eax,%eax
80102a49:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102a4b:	85 d2                	test   %edx,%edx
80102a4d:	74 06                	je     80102a55 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102a4f:	8b 42 20             	mov    0x20(%edx),%eax
80102a52:	c1 e8 18             	shr    $0x18,%eax
}
80102a55:	5d                   	pop    %ebp
80102a56:	c3                   	ret    
80102a57:	89 f6                	mov    %esi,%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a60 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a60:	a1 3c 29 11 80       	mov    0x8011293c,%eax
{
80102a65:	55                   	push   %ebp
80102a66:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102a68:	85 c0                	test   %eax,%eax
80102a6a:	74 0d                	je     80102a79 <lapiceoi+0x19>
  lapic[index] = value;
80102a6c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a73:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a76:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a79:	5d                   	pop    %ebp
80102a7a:	c3                   	ret    
80102a7b:	90                   	nop
80102a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a80 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
}
80102a83:	5d                   	pop    %ebp
80102a84:	c3                   	ret    
80102a85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a90 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a90:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a91:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a96:	ba 70 00 00 00       	mov    $0x70,%edx
80102a9b:	89 e5                	mov    %esp,%ebp
80102a9d:	53                   	push   %ebx
80102a9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102aa1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102aa4:	ee                   	out    %al,(%dx)
80102aa5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aaa:	ba 71 00 00 00       	mov    $0x71,%edx
80102aaf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ab0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ab2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ab5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102abb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102abd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102ac0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102ac3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ac5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102ac8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102ace:	a1 3c 29 11 80       	mov    0x8011293c,%eax
80102ad3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ad9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102adc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ae3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ae9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102af0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102af6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102afc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b05:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b08:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b11:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b17:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b1a:	5b                   	pop    %ebx
80102b1b:	5d                   	pop    %ebp
80102b1c:	c3                   	ret    
80102b1d:	8d 76 00             	lea    0x0(%esi),%esi

80102b20 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b20:	55                   	push   %ebp
80102b21:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b26:	ba 70 00 00 00       	mov    $0x70,%edx
80102b2b:	89 e5                	mov    %esp,%ebp
80102b2d:	57                   	push   %edi
80102b2e:	56                   	push   %esi
80102b2f:	53                   	push   %ebx
80102b30:	83 ec 4c             	sub    $0x4c,%esp
80102b33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b34:	ba 71 00 00 00       	mov    $0x71,%edx
80102b39:	ec                   	in     (%dx),%al
80102b3a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b3d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b42:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b45:	8d 76 00             	lea    0x0(%esi),%esi
80102b48:	31 c0                	xor    %eax,%eax
80102b4a:	89 da                	mov    %ebx,%edx
80102b4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b52:	89 ca                	mov    %ecx,%edx
80102b54:	ec                   	in     (%dx),%al
80102b55:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b58:	89 da                	mov    %ebx,%edx
80102b5a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b60:	89 ca                	mov    %ecx,%edx
80102b62:	ec                   	in     (%dx),%al
80102b63:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b66:	89 da                	mov    %ebx,%edx
80102b68:	b8 04 00 00 00       	mov    $0x4,%eax
80102b6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6e:	89 ca                	mov    %ecx,%edx
80102b70:	ec                   	in     (%dx),%al
80102b71:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b74:	89 da                	mov    %ebx,%edx
80102b76:	b8 07 00 00 00       	mov    $0x7,%eax
80102b7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7c:	89 ca                	mov    %ecx,%edx
80102b7e:	ec                   	in     (%dx),%al
80102b7f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b82:	89 da                	mov    %ebx,%edx
80102b84:	b8 08 00 00 00       	mov    $0x8,%eax
80102b89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8a:	89 ca                	mov    %ecx,%edx
80102b8c:	ec                   	in     (%dx),%al
80102b8d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b8f:	89 da                	mov    %ebx,%edx
80102b91:	b8 09 00 00 00       	mov    $0x9,%eax
80102b96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b97:	89 ca                	mov    %ecx,%edx
80102b99:	ec                   	in     (%dx),%al
80102b9a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b9c:	89 da                	mov    %ebx,%edx
80102b9e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ba3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba4:	89 ca                	mov    %ecx,%edx
80102ba6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ba7:	84 c0                	test   %al,%al
80102ba9:	78 9d                	js     80102b48 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102bab:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102baf:	89 fa                	mov    %edi,%edx
80102bb1:	0f b6 fa             	movzbl %dl,%edi
80102bb4:	89 f2                	mov    %esi,%edx
80102bb6:	0f b6 f2             	movzbl %dl,%esi
80102bb9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bbc:	89 da                	mov    %ebx,%edx
80102bbe:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102bc1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102bc4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102bc8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102bcb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102bcf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bd2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102bd6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102bd9:	31 c0                	xor    %eax,%eax
80102bdb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdc:	89 ca                	mov    %ecx,%edx
80102bde:	ec                   	in     (%dx),%al
80102bdf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be2:	89 da                	mov    %ebx,%edx
80102be4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102be7:	b8 02 00 00 00       	mov    $0x2,%eax
80102bec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bed:	89 ca                	mov    %ecx,%edx
80102bef:	ec                   	in     (%dx),%al
80102bf0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf3:	89 da                	mov    %ebx,%edx
80102bf5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102bf8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfe:	89 ca                	mov    %ecx,%edx
80102c00:	ec                   	in     (%dx),%al
80102c01:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c04:	89 da                	mov    %ebx,%edx
80102c06:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c09:	b8 07 00 00 00       	mov    $0x7,%eax
80102c0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0f:	89 ca                	mov    %ecx,%edx
80102c11:	ec                   	in     (%dx),%al
80102c12:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c15:	89 da                	mov    %ebx,%edx
80102c17:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c1a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c20:	89 ca                	mov    %ecx,%edx
80102c22:	ec                   	in     (%dx),%al
80102c23:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c26:	89 da                	mov    %ebx,%edx
80102c28:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c2b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c30:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c31:	89 ca                	mov    %ecx,%edx
80102c33:	ec                   	in     (%dx),%al
80102c34:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c37:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c3d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c40:	6a 18                	push   $0x18
80102c42:	50                   	push   %eax
80102c43:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c46:	50                   	push   %eax
80102c47:	e8 64 1b 00 00       	call   801047b0 <memcmp>
80102c4c:	83 c4 10             	add    $0x10,%esp
80102c4f:	85 c0                	test   %eax,%eax
80102c51:	0f 85 f1 fe ff ff    	jne    80102b48 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c57:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c5b:	75 78                	jne    80102cd5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c60:	89 c2                	mov    %eax,%edx
80102c62:	83 e0 0f             	and    $0xf,%eax
80102c65:	c1 ea 04             	shr    $0x4,%edx
80102c68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c71:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c74:	89 c2                	mov    %eax,%edx
80102c76:	83 e0 0f             	and    $0xf,%eax
80102c79:	c1 ea 04             	shr    $0x4,%edx
80102c7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c82:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c85:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c88:	89 c2                	mov    %eax,%edx
80102c8a:	83 e0 0f             	and    $0xf,%eax
80102c8d:	c1 ea 04             	shr    $0x4,%edx
80102c90:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c93:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c96:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c9c:	89 c2                	mov    %eax,%edx
80102c9e:	83 e0 0f             	and    $0xf,%eax
80102ca1:	c1 ea 04             	shr    $0x4,%edx
80102ca4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ca7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102caa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102cad:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cb0:	89 c2                	mov    %eax,%edx
80102cb2:	83 e0 0f             	and    $0xf,%eax
80102cb5:	c1 ea 04             	shr    $0x4,%edx
80102cb8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cbb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cbe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102cc1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cc4:	89 c2                	mov    %eax,%edx
80102cc6:	83 e0 0f             	and    $0xf,%eax
80102cc9:	c1 ea 04             	shr    $0x4,%edx
80102ccc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ccf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cd2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102cd5:	8b 75 08             	mov    0x8(%ebp),%esi
80102cd8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cdb:	89 06                	mov    %eax,(%esi)
80102cdd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ce0:	89 46 04             	mov    %eax,0x4(%esi)
80102ce3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ce6:	89 46 08             	mov    %eax,0x8(%esi)
80102ce9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cec:	89 46 0c             	mov    %eax,0xc(%esi)
80102cef:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cf2:	89 46 10             	mov    %eax,0x10(%esi)
80102cf5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cf8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102cfb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d05:	5b                   	pop    %ebx
80102d06:	5e                   	pop    %esi
80102d07:	5f                   	pop    %edi
80102d08:	5d                   	pop    %ebp
80102d09:	c3                   	ret    
80102d0a:	66 90                	xchg   %ax,%ax
80102d0c:	66 90                	xchg   %ax,%ax
80102d0e:	66 90                	xchg   %ax,%ax

80102d10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d10:	8b 0d 88 29 11 80    	mov    0x80112988,%ecx
80102d16:	85 c9                	test   %ecx,%ecx
80102d18:	0f 8e 8a 00 00 00    	jle    80102da8 <install_trans+0x98>
{
80102d1e:	55                   	push   %ebp
80102d1f:	89 e5                	mov    %esp,%ebp
80102d21:	57                   	push   %edi
80102d22:	56                   	push   %esi
80102d23:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102d24:	31 db                	xor    %ebx,%ebx
{
80102d26:	83 ec 0c             	sub    $0xc,%esp
80102d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d30:	a1 74 29 11 80       	mov    0x80112974,%eax
80102d35:	83 ec 08             	sub    $0x8,%esp
80102d38:	01 d8                	add    %ebx,%eax
80102d3a:	83 c0 01             	add    $0x1,%eax
80102d3d:	50                   	push   %eax
80102d3e:	ff 35 84 29 11 80    	pushl  0x80112984
80102d44:	e8 87 d3 ff ff       	call   801000d0 <bread>
80102d49:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d4b:	58                   	pop    %eax
80102d4c:	5a                   	pop    %edx
80102d4d:	ff 34 9d 8c 29 11 80 	pushl  -0x7feed674(,%ebx,4)
80102d54:	ff 35 84 29 11 80    	pushl  0x80112984
  for (tail = 0; tail < log.lh.n; tail++) {
80102d5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d5d:	e8 6e d3 ff ff       	call   801000d0 <bread>
80102d62:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d64:	8d 47 5c             	lea    0x5c(%edi),%eax
80102d67:	83 c4 0c             	add    $0xc,%esp
80102d6a:	68 00 02 00 00       	push   $0x200
80102d6f:	50                   	push   %eax
80102d70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d73:	50                   	push   %eax
80102d74:	e8 97 1a 00 00       	call   80104810 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d79:	89 34 24             	mov    %esi,(%esp)
80102d7c:	e8 1f d4 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102d81:	89 3c 24             	mov    %edi,(%esp)
80102d84:	e8 57 d4 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102d89:	89 34 24             	mov    %esi,(%esp)
80102d8c:	e8 4f d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d91:	83 c4 10             	add    $0x10,%esp
80102d94:	39 1d 88 29 11 80    	cmp    %ebx,0x80112988
80102d9a:	7f 94                	jg     80102d30 <install_trans+0x20>
  }
}
80102d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d9f:	5b                   	pop    %ebx
80102da0:	5e                   	pop    %esi
80102da1:	5f                   	pop    %edi
80102da2:	5d                   	pop    %ebp
80102da3:	c3                   	ret    
80102da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102da8:	f3 c3                	repz ret 
80102daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102db0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	56                   	push   %esi
80102db4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102db5:	83 ec 08             	sub    $0x8,%esp
80102db8:	ff 35 74 29 11 80    	pushl  0x80112974
80102dbe:	ff 35 84 29 11 80    	pushl  0x80112984
80102dc4:	e8 07 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102dc9:	8b 1d 88 29 11 80    	mov    0x80112988,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102dcf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102dd2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102dd4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102dd6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	7e 16                	jle    80102df1 <write_head+0x41>
80102ddb:	c1 e3 02             	shl    $0x2,%ebx
80102dde:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102de0:	8b 8a 8c 29 11 80    	mov    -0x7feed674(%edx),%ecx
80102de6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102dea:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102ded:	39 da                	cmp    %ebx,%edx
80102def:	75 ef                	jne    80102de0 <write_head+0x30>
  }
  bwrite(buf);
80102df1:	83 ec 0c             	sub    $0xc,%esp
80102df4:	56                   	push   %esi
80102df5:	e8 a6 d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102dfa:	89 34 24             	mov    %esi,(%esp)
80102dfd:	e8 de d3 ff ff       	call   801001e0 <brelse>
}
80102e02:	83 c4 10             	add    $0x10,%esp
80102e05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e08:	5b                   	pop    %ebx
80102e09:	5e                   	pop    %esi
80102e0a:	5d                   	pop    %ebp
80102e0b:	c3                   	ret    
80102e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e10 <initlog>:
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	53                   	push   %ebx
80102e14:	83 ec 2c             	sub    $0x2c,%esp
80102e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e1a:	68 60 76 10 80       	push   $0x80107660
80102e1f:	68 40 29 11 80       	push   $0x80112940
80102e24:	e8 e7 16 00 00       	call   80104510 <initlock>
  readsb(dev, &sb);
80102e29:	58                   	pop    %eax
80102e2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e2d:	5a                   	pop    %edx
80102e2e:	50                   	push   %eax
80102e2f:	53                   	push   %ebx
80102e30:	e8 9b e8 ff ff       	call   801016d0 <readsb>
  log.size = sb.nlog;
80102e35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e3b:	59                   	pop    %ecx
  log.dev = dev;
80102e3c:	89 1d 84 29 11 80    	mov    %ebx,0x80112984
  log.size = sb.nlog;
80102e42:	89 15 78 29 11 80    	mov    %edx,0x80112978
  log.start = sb.logstart;
80102e48:	a3 74 29 11 80       	mov    %eax,0x80112974
  struct buf *buf = bread(log.dev, log.start);
80102e4d:	5a                   	pop    %edx
80102e4e:	50                   	push   %eax
80102e4f:	53                   	push   %ebx
80102e50:	e8 7b d2 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102e55:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102e58:	83 c4 10             	add    $0x10,%esp
80102e5b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102e5d:	89 1d 88 29 11 80    	mov    %ebx,0x80112988
  for (i = 0; i < log.lh.n; i++) {
80102e63:	7e 1c                	jle    80102e81 <initlog+0x71>
80102e65:	c1 e3 02             	shl    $0x2,%ebx
80102e68:	31 d2                	xor    %edx,%edx
80102e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102e70:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102e74:	83 c2 04             	add    $0x4,%edx
80102e77:	89 8a 88 29 11 80    	mov    %ecx,-0x7feed678(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102e7d:	39 d3                	cmp    %edx,%ebx
80102e7f:	75 ef                	jne    80102e70 <initlog+0x60>
  brelse(buf);
80102e81:	83 ec 0c             	sub    $0xc,%esp
80102e84:	50                   	push   %eax
80102e85:	e8 56 d3 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e8a:	e8 81 fe ff ff       	call   80102d10 <install_trans>
  log.lh.n = 0;
80102e8f:	c7 05 88 29 11 80 00 	movl   $0x0,0x80112988
80102e96:	00 00 00 
  write_head(); // clear the log
80102e99:	e8 12 ff ff ff       	call   80102db0 <write_head>
}
80102e9e:	83 c4 10             	add    $0x10,%esp
80102ea1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ea4:	c9                   	leave  
80102ea5:	c3                   	ret    
80102ea6:	8d 76 00             	lea    0x0(%esi),%esi
80102ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102eb0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102eb6:	68 40 29 11 80       	push   $0x80112940
80102ebb:	e8 90 17 00 00       	call   80104650 <acquire>
80102ec0:	83 c4 10             	add    $0x10,%esp
80102ec3:	eb 18                	jmp    80102edd <begin_op+0x2d>
80102ec5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ec8:	83 ec 08             	sub    $0x8,%esp
80102ecb:	68 40 29 11 80       	push   $0x80112940
80102ed0:	68 40 29 11 80       	push   $0x80112940
80102ed5:	e8 b6 11 00 00       	call   80104090 <sleep>
80102eda:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102edd:	a1 80 29 11 80       	mov    0x80112980,%eax
80102ee2:	85 c0                	test   %eax,%eax
80102ee4:	75 e2                	jne    80102ec8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ee6:	a1 7c 29 11 80       	mov    0x8011297c,%eax
80102eeb:	8b 15 88 29 11 80    	mov    0x80112988,%edx
80102ef1:	83 c0 01             	add    $0x1,%eax
80102ef4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ef7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102efa:	83 fa 1e             	cmp    $0x1e,%edx
80102efd:	7f c9                	jg     80102ec8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102eff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f02:	a3 7c 29 11 80       	mov    %eax,0x8011297c
      release(&log.lock);
80102f07:	68 40 29 11 80       	push   $0x80112940
80102f0c:	e8 ff 17 00 00       	call   80104710 <release>
      break;
    }
  }
}
80102f11:	83 c4 10             	add    $0x10,%esp
80102f14:	c9                   	leave  
80102f15:	c3                   	ret    
80102f16:	8d 76 00             	lea    0x0(%esi),%esi
80102f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	57                   	push   %edi
80102f24:	56                   	push   %esi
80102f25:	53                   	push   %ebx
80102f26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f29:	68 40 29 11 80       	push   $0x80112940
80102f2e:	e8 1d 17 00 00       	call   80104650 <acquire>
  log.outstanding -= 1;
80102f33:	a1 7c 29 11 80       	mov    0x8011297c,%eax
  if(log.committing)
80102f38:	8b 35 80 29 11 80    	mov    0x80112980,%esi
80102f3e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f41:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102f44:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102f46:	89 1d 7c 29 11 80    	mov    %ebx,0x8011297c
  if(log.committing)
80102f4c:	0f 85 1a 01 00 00    	jne    8010306c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102f52:	85 db                	test   %ebx,%ebx
80102f54:	0f 85 ee 00 00 00    	jne    80103048 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f5a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102f5d:	c7 05 80 29 11 80 01 	movl   $0x1,0x80112980
80102f64:	00 00 00 
  release(&log.lock);
80102f67:	68 40 29 11 80       	push   $0x80112940
80102f6c:	e8 9f 17 00 00       	call   80104710 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f71:	8b 0d 88 29 11 80    	mov    0x80112988,%ecx
80102f77:	83 c4 10             	add    $0x10,%esp
80102f7a:	85 c9                	test   %ecx,%ecx
80102f7c:	0f 8e 85 00 00 00    	jle    80103007 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f82:	a1 74 29 11 80       	mov    0x80112974,%eax
80102f87:	83 ec 08             	sub    $0x8,%esp
80102f8a:	01 d8                	add    %ebx,%eax
80102f8c:	83 c0 01             	add    $0x1,%eax
80102f8f:	50                   	push   %eax
80102f90:	ff 35 84 29 11 80    	pushl  0x80112984
80102f96:	e8 35 d1 ff ff       	call   801000d0 <bread>
80102f9b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f9d:	58                   	pop    %eax
80102f9e:	5a                   	pop    %edx
80102f9f:	ff 34 9d 8c 29 11 80 	pushl  -0x7feed674(,%ebx,4)
80102fa6:	ff 35 84 29 11 80    	pushl  0x80112984
  for (tail = 0; tail < log.lh.n; tail++) {
80102fac:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102faf:	e8 1c d1 ff ff       	call   801000d0 <bread>
80102fb4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102fb6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102fb9:	83 c4 0c             	add    $0xc,%esp
80102fbc:	68 00 02 00 00       	push   $0x200
80102fc1:	50                   	push   %eax
80102fc2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fc5:	50                   	push   %eax
80102fc6:	e8 45 18 00 00       	call   80104810 <memmove>
    bwrite(to);  // write the log
80102fcb:	89 34 24             	mov    %esi,(%esp)
80102fce:	e8 cd d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102fd3:	89 3c 24             	mov    %edi,(%esp)
80102fd6:	e8 05 d2 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102fdb:	89 34 24             	mov    %esi,(%esp)
80102fde:	e8 fd d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fe3:	83 c4 10             	add    $0x10,%esp
80102fe6:	3b 1d 88 29 11 80    	cmp    0x80112988,%ebx
80102fec:	7c 94                	jl     80102f82 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fee:	e8 bd fd ff ff       	call   80102db0 <write_head>
    install_trans(); // Now install writes to home locations
80102ff3:	e8 18 fd ff ff       	call   80102d10 <install_trans>
    log.lh.n = 0;
80102ff8:	c7 05 88 29 11 80 00 	movl   $0x0,0x80112988
80102fff:	00 00 00 
    write_head();    // Erase the transaction from the log
80103002:	e8 a9 fd ff ff       	call   80102db0 <write_head>
    acquire(&log.lock);
80103007:	83 ec 0c             	sub    $0xc,%esp
8010300a:	68 40 29 11 80       	push   $0x80112940
8010300f:	e8 3c 16 00 00       	call   80104650 <acquire>
    wakeup(&log);
80103014:	c7 04 24 40 29 11 80 	movl   $0x80112940,(%esp)
    log.committing = 0;
8010301b:	c7 05 80 29 11 80 00 	movl   $0x0,0x80112980
80103022:	00 00 00 
    wakeup(&log);
80103025:	e8 16 12 00 00       	call   80104240 <wakeup>
    release(&log.lock);
8010302a:	c7 04 24 40 29 11 80 	movl   $0x80112940,(%esp)
80103031:	e8 da 16 00 00       	call   80104710 <release>
80103036:	83 c4 10             	add    $0x10,%esp
}
80103039:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010303c:	5b                   	pop    %ebx
8010303d:	5e                   	pop    %esi
8010303e:	5f                   	pop    %edi
8010303f:	5d                   	pop    %ebp
80103040:	c3                   	ret    
80103041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103048:	83 ec 0c             	sub    $0xc,%esp
8010304b:	68 40 29 11 80       	push   $0x80112940
80103050:	e8 eb 11 00 00       	call   80104240 <wakeup>
  release(&log.lock);
80103055:	c7 04 24 40 29 11 80 	movl   $0x80112940,(%esp)
8010305c:	e8 af 16 00 00       	call   80104710 <release>
80103061:	83 c4 10             	add    $0x10,%esp
}
80103064:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103067:	5b                   	pop    %ebx
80103068:	5e                   	pop    %esi
80103069:	5f                   	pop    %edi
8010306a:	5d                   	pop    %ebp
8010306b:	c3                   	ret    
    panic("log.committing");
8010306c:	83 ec 0c             	sub    $0xc,%esp
8010306f:	68 64 76 10 80       	push   $0x80107664
80103074:	e8 17 d3 ff ff       	call   80100390 <panic>
80103079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103080 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	53                   	push   %ebx
80103084:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103087:	8b 15 88 29 11 80    	mov    0x80112988,%edx
{
8010308d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103090:	83 fa 1d             	cmp    $0x1d,%edx
80103093:	0f 8f 9d 00 00 00    	jg     80103136 <log_write+0xb6>
80103099:	a1 78 29 11 80       	mov    0x80112978,%eax
8010309e:	83 e8 01             	sub    $0x1,%eax
801030a1:	39 c2                	cmp    %eax,%edx
801030a3:	0f 8d 8d 00 00 00    	jge    80103136 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801030a9:	a1 7c 29 11 80       	mov    0x8011297c,%eax
801030ae:	85 c0                	test   %eax,%eax
801030b0:	0f 8e 8d 00 00 00    	jle    80103143 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801030b6:	83 ec 0c             	sub    $0xc,%esp
801030b9:	68 40 29 11 80       	push   $0x80112940
801030be:	e8 8d 15 00 00       	call   80104650 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801030c3:	8b 0d 88 29 11 80    	mov    0x80112988,%ecx
801030c9:	83 c4 10             	add    $0x10,%esp
801030cc:	83 f9 00             	cmp    $0x0,%ecx
801030cf:	7e 57                	jle    80103128 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030d1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
801030d4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030d6:	3b 15 8c 29 11 80    	cmp    0x8011298c,%edx
801030dc:	75 0b                	jne    801030e9 <log_write+0x69>
801030de:	eb 38                	jmp    80103118 <log_write+0x98>
801030e0:	39 14 85 8c 29 11 80 	cmp    %edx,-0x7feed674(,%eax,4)
801030e7:	74 2f                	je     80103118 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801030e9:	83 c0 01             	add    $0x1,%eax
801030ec:	39 c1                	cmp    %eax,%ecx
801030ee:	75 f0                	jne    801030e0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801030f0:	89 14 85 8c 29 11 80 	mov    %edx,-0x7feed674(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801030f7:	83 c0 01             	add    $0x1,%eax
801030fa:	a3 88 29 11 80       	mov    %eax,0x80112988
  b->flags |= B_DIRTY; // prevent eviction
801030ff:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103102:	c7 45 08 40 29 11 80 	movl   $0x80112940,0x8(%ebp)
}
80103109:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010310c:	c9                   	leave  
  release(&log.lock);
8010310d:	e9 fe 15 00 00       	jmp    80104710 <release>
80103112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103118:	89 14 85 8c 29 11 80 	mov    %edx,-0x7feed674(,%eax,4)
8010311f:	eb de                	jmp    801030ff <log_write+0x7f>
80103121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103128:	8b 43 08             	mov    0x8(%ebx),%eax
8010312b:	a3 8c 29 11 80       	mov    %eax,0x8011298c
  if (i == log.lh.n)
80103130:	75 cd                	jne    801030ff <log_write+0x7f>
80103132:	31 c0                	xor    %eax,%eax
80103134:	eb c1                	jmp    801030f7 <log_write+0x77>
    panic("too big a transaction");
80103136:	83 ec 0c             	sub    $0xc,%esp
80103139:	68 73 76 10 80       	push   $0x80107673
8010313e:	e8 4d d2 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103143:	83 ec 0c             	sub    $0xc,%esp
80103146:	68 89 76 10 80       	push   $0x80107689
8010314b:	e8 40 d2 ff ff       	call   80100390 <panic>

80103150 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	53                   	push   %ebx
80103154:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103157:	e8 74 09 00 00       	call   80103ad0 <cpuid>
8010315c:	89 c3                	mov    %eax,%ebx
8010315e:	e8 6d 09 00 00       	call   80103ad0 <cpuid>
80103163:	83 ec 04             	sub    $0x4,%esp
80103166:	53                   	push   %ebx
80103167:	50                   	push   %eax
80103168:	68 a4 76 10 80       	push   $0x801076a4
8010316d:	e8 ee d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103172:	e8 69 28 00 00       	call   801059e0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103177:	e8 d4 08 00 00       	call   80103a50 <mycpu>
8010317c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010317e:	b8 01 00 00 00       	mov    $0x1,%eax
80103183:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010318a:	e8 21 0c 00 00       	call   80103db0 <scheduler>
8010318f:	90                   	nop

80103190 <mpenter>:
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103196:	e8 35 39 00 00       	call   80106ad0 <switchkvm>
  seginit();
8010319b:	e8 a0 38 00 00       	call   80106a40 <seginit>
  lapicinit();
801031a0:	e8 9b f7 ff ff       	call   80102940 <lapicinit>
  mpmain();
801031a5:	e8 a6 ff ff ff       	call   80103150 <mpmain>
801031aa:	66 90                	xchg   %ax,%ax
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <main>:
{
801031b0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801031b4:	83 e4 f0             	and    $0xfffffff0,%esp
801031b7:	ff 71 fc             	pushl  -0x4(%ecx)
801031ba:	55                   	push   %ebp
801031bb:	89 e5                	mov    %esp,%ebp
801031bd:	53                   	push   %ebx
801031be:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801031bf:	83 ec 08             	sub    $0x8,%esp
801031c2:	68 00 00 40 80       	push   $0x80400000
801031c7:	68 68 57 11 80       	push   $0x80115768
801031cc:	e8 2f f5 ff ff       	call   80102700 <kinit1>
  kvmalloc();      // kernel page table
801031d1:	e8 ca 3d 00 00       	call   80106fa0 <kvmalloc>
  mpinit();        // detect other processors
801031d6:	e8 75 01 00 00       	call   80103350 <mpinit>
  lapicinit();     // interrupt controller
801031db:	e8 60 f7 ff ff       	call   80102940 <lapicinit>
  seginit();       // segment descriptors
801031e0:	e8 5b 38 00 00       	call   80106a40 <seginit>
  picinit();       // disable pic
801031e5:	e8 46 03 00 00       	call   80103530 <picinit>
  ioapicinit();    // another interrupt controller
801031ea:	e8 41 f3 ff ff       	call   80102530 <ioapicinit>
  consoleinit();   // console hardware
801031ef:	e8 cc da ff ff       	call   80100cc0 <consoleinit>
  uartinit();      // serial port
801031f4:	e8 17 2b 00 00       	call   80105d10 <uartinit>
  pinit();         // process table
801031f9:	e8 32 08 00 00       	call   80103a30 <pinit>
  tvinit();        // trap vectors
801031fe:	e8 5d 27 00 00       	call   80105960 <tvinit>
  binit();         // buffer cache
80103203:	e8 38 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103208:	e8 53 de ff ff       	call   80101060 <fileinit>
  ideinit();       // disk 
8010320d:	e8 fe f0 ff ff       	call   80102310 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103212:	83 c4 0c             	add    $0xc,%esp
80103215:	68 8a 00 00 00       	push   $0x8a
8010321a:	68 8c a4 10 80       	push   $0x8010a48c
8010321f:	68 00 70 00 80       	push   $0x80007000
80103224:	e8 e7 15 00 00       	call   80104810 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103229:	69 05 c0 2f 11 80 b0 	imul   $0xb0,0x80112fc0,%eax
80103230:	00 00 00 
80103233:	83 c4 10             	add    $0x10,%esp
80103236:	05 40 2a 11 80       	add    $0x80112a40,%eax
8010323b:	3d 40 2a 11 80       	cmp    $0x80112a40,%eax
80103240:	76 71                	jbe    801032b3 <main+0x103>
80103242:	bb 40 2a 11 80       	mov    $0x80112a40,%ebx
80103247:	89 f6                	mov    %esi,%esi
80103249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103250:	e8 fb 07 00 00       	call   80103a50 <mycpu>
80103255:	39 d8                	cmp    %ebx,%eax
80103257:	74 41                	je     8010329a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103259:	e8 72 f5 ff ff       	call   801027d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010325e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103263:	c7 05 f8 6f 00 80 90 	movl   $0x80103190,0x80006ff8
8010326a:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010326d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103274:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103277:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010327c:	0f b6 03             	movzbl (%ebx),%eax
8010327f:	83 ec 08             	sub    $0x8,%esp
80103282:	68 00 70 00 00       	push   $0x7000
80103287:	50                   	push   %eax
80103288:	e8 03 f8 ff ff       	call   80102a90 <lapicstartap>
8010328d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103290:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103296:	85 c0                	test   %eax,%eax
80103298:	74 f6                	je     80103290 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010329a:	69 05 c0 2f 11 80 b0 	imul   $0xb0,0x80112fc0,%eax
801032a1:	00 00 00 
801032a4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032aa:	05 40 2a 11 80       	add    $0x80112a40,%eax
801032af:	39 c3                	cmp    %eax,%ebx
801032b1:	72 9d                	jb     80103250 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801032b3:	83 ec 08             	sub    $0x8,%esp
801032b6:	68 00 00 00 8e       	push   $0x8e000000
801032bb:	68 00 00 40 80       	push   $0x80400000
801032c0:	e8 ab f4 ff ff       	call   80102770 <kinit2>
  userinit();      // first user process
801032c5:	e8 56 08 00 00       	call   80103b20 <userinit>
  mpmain();        // finish this processor's setup
801032ca:	e8 81 fe ff ff       	call   80103150 <mpmain>
801032cf:	90                   	nop

801032d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	57                   	push   %edi
801032d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032db:	53                   	push   %ebx
  e = addr+len;
801032dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801032e2:	39 de                	cmp    %ebx,%esi
801032e4:	72 10                	jb     801032f6 <mpsearch1+0x26>
801032e6:	eb 50                	jmp    80103338 <mpsearch1+0x68>
801032e8:	90                   	nop
801032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032f0:	39 fb                	cmp    %edi,%ebx
801032f2:	89 fe                	mov    %edi,%esi
801032f4:	76 42                	jbe    80103338 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032f6:	83 ec 04             	sub    $0x4,%esp
801032f9:	8d 7e 10             	lea    0x10(%esi),%edi
801032fc:	6a 04                	push   $0x4
801032fe:	68 b8 76 10 80       	push   $0x801076b8
80103303:	56                   	push   %esi
80103304:	e8 a7 14 00 00       	call   801047b0 <memcmp>
80103309:	83 c4 10             	add    $0x10,%esp
8010330c:	85 c0                	test   %eax,%eax
8010330e:	75 e0                	jne    801032f0 <mpsearch1+0x20>
80103310:	89 f1                	mov    %esi,%ecx
80103312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103318:	0f b6 11             	movzbl (%ecx),%edx
8010331b:	83 c1 01             	add    $0x1,%ecx
8010331e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103320:	39 f9                	cmp    %edi,%ecx
80103322:	75 f4                	jne    80103318 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103324:	84 c0                	test   %al,%al
80103326:	75 c8                	jne    801032f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103328:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010332b:	89 f0                	mov    %esi,%eax
8010332d:	5b                   	pop    %ebx
8010332e:	5e                   	pop    %esi
8010332f:	5f                   	pop    %edi
80103330:	5d                   	pop    %ebp
80103331:	c3                   	ret    
80103332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103338:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010333b:	31 f6                	xor    %esi,%esi
}
8010333d:	89 f0                	mov    %esi,%eax
8010333f:	5b                   	pop    %ebx
80103340:	5e                   	pop    %esi
80103341:	5f                   	pop    %edi
80103342:	5d                   	pop    %ebp
80103343:	c3                   	ret    
80103344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010334a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103350 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	57                   	push   %edi
80103354:	56                   	push   %esi
80103355:	53                   	push   %ebx
80103356:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103359:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103360:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103367:	c1 e0 08             	shl    $0x8,%eax
8010336a:	09 d0                	or     %edx,%eax
8010336c:	c1 e0 04             	shl    $0x4,%eax
8010336f:	85 c0                	test   %eax,%eax
80103371:	75 1b                	jne    8010338e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103373:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010337a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103381:	c1 e0 08             	shl    $0x8,%eax
80103384:	09 d0                	or     %edx,%eax
80103386:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103389:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010338e:	ba 00 04 00 00       	mov    $0x400,%edx
80103393:	e8 38 ff ff ff       	call   801032d0 <mpsearch1>
80103398:	85 c0                	test   %eax,%eax
8010339a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010339d:	0f 84 3d 01 00 00    	je     801034e0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033a6:	8b 58 04             	mov    0x4(%eax),%ebx
801033a9:	85 db                	test   %ebx,%ebx
801033ab:	0f 84 4f 01 00 00    	je     80103500 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033b1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801033b7:	83 ec 04             	sub    $0x4,%esp
801033ba:	6a 04                	push   $0x4
801033bc:	68 d5 76 10 80       	push   $0x801076d5
801033c1:	56                   	push   %esi
801033c2:	e8 e9 13 00 00       	call   801047b0 <memcmp>
801033c7:	83 c4 10             	add    $0x10,%esp
801033ca:	85 c0                	test   %eax,%eax
801033cc:	0f 85 2e 01 00 00    	jne    80103500 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801033d2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801033d9:	3c 01                	cmp    $0x1,%al
801033db:	0f 95 c2             	setne  %dl
801033de:	3c 04                	cmp    $0x4,%al
801033e0:	0f 95 c0             	setne  %al
801033e3:	20 c2                	and    %al,%dl
801033e5:	0f 85 15 01 00 00    	jne    80103500 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801033eb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801033f2:	66 85 ff             	test   %di,%di
801033f5:	74 1a                	je     80103411 <mpinit+0xc1>
801033f7:	89 f0                	mov    %esi,%eax
801033f9:	01 f7                	add    %esi,%edi
  sum = 0;
801033fb:	31 d2                	xor    %edx,%edx
801033fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103400:	0f b6 08             	movzbl (%eax),%ecx
80103403:	83 c0 01             	add    $0x1,%eax
80103406:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103408:	39 c7                	cmp    %eax,%edi
8010340a:	75 f4                	jne    80103400 <mpinit+0xb0>
8010340c:	84 d2                	test   %dl,%dl
8010340e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103411:	85 f6                	test   %esi,%esi
80103413:	0f 84 e7 00 00 00    	je     80103500 <mpinit+0x1b0>
80103419:	84 d2                	test   %dl,%dl
8010341b:	0f 85 df 00 00 00    	jne    80103500 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103421:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103427:	a3 3c 29 11 80       	mov    %eax,0x8011293c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010342c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103433:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103439:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010343e:	01 d6                	add    %edx,%esi
80103440:	39 c6                	cmp    %eax,%esi
80103442:	76 23                	jbe    80103467 <mpinit+0x117>
    switch(*p){
80103444:	0f b6 10             	movzbl (%eax),%edx
80103447:	80 fa 04             	cmp    $0x4,%dl
8010344a:	0f 87 ca 00 00 00    	ja     8010351a <mpinit+0x1ca>
80103450:	ff 24 95 fc 76 10 80 	jmp    *-0x7fef8904(,%edx,4)
80103457:	89 f6                	mov    %esi,%esi
80103459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103460:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103463:	39 c6                	cmp    %eax,%esi
80103465:	77 dd                	ja     80103444 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103467:	85 db                	test   %ebx,%ebx
80103469:	0f 84 9e 00 00 00    	je     8010350d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010346f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103472:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103476:	74 15                	je     8010348d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103478:	b8 70 00 00 00       	mov    $0x70,%eax
8010347d:	ba 22 00 00 00       	mov    $0x22,%edx
80103482:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103483:	ba 23 00 00 00       	mov    $0x23,%edx
80103488:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103489:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010348c:	ee                   	out    %al,(%dx)
  }
}
8010348d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103490:	5b                   	pop    %ebx
80103491:	5e                   	pop    %esi
80103492:	5f                   	pop    %edi
80103493:	5d                   	pop    %ebp
80103494:	c3                   	ret    
80103495:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103498:	8b 0d c0 2f 11 80    	mov    0x80112fc0,%ecx
8010349e:	83 f9 07             	cmp    $0x7,%ecx
801034a1:	7f 19                	jg     801034bc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034a3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801034a7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801034ad:	83 c1 01             	add    $0x1,%ecx
801034b0:	89 0d c0 2f 11 80    	mov    %ecx,0x80112fc0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034b6:	88 97 40 2a 11 80    	mov    %dl,-0x7feed5c0(%edi)
      p += sizeof(struct mpproc);
801034bc:	83 c0 14             	add    $0x14,%eax
      continue;
801034bf:	e9 7c ff ff ff       	jmp    80103440 <mpinit+0xf0>
801034c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801034c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801034cc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801034cf:	88 15 20 2a 11 80    	mov    %dl,0x80112a20
      continue;
801034d5:	e9 66 ff ff ff       	jmp    80103440 <mpinit+0xf0>
801034da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801034e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801034e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801034ea:	e8 e1 fd ff ff       	call   801032d0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034ef:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801034f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034f4:	0f 85 a9 fe ff ff    	jne    801033a3 <mpinit+0x53>
801034fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103500:	83 ec 0c             	sub    $0xc,%esp
80103503:	68 bd 76 10 80       	push   $0x801076bd
80103508:	e8 83 ce ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010350d:	83 ec 0c             	sub    $0xc,%esp
80103510:	68 dc 76 10 80       	push   $0x801076dc
80103515:	e8 76 ce ff ff       	call   80100390 <panic>
      ismp = 0;
8010351a:	31 db                	xor    %ebx,%ebx
8010351c:	e9 26 ff ff ff       	jmp    80103447 <mpinit+0xf7>
80103521:	66 90                	xchg   %ax,%ax
80103523:	66 90                	xchg   %ax,%ax
80103525:	66 90                	xchg   %ax,%ax
80103527:	66 90                	xchg   %ax,%ax
80103529:	66 90                	xchg   %ax,%ax
8010352b:	66 90                	xchg   %ax,%ax
8010352d:	66 90                	xchg   %ax,%ax
8010352f:	90                   	nop

80103530 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103530:	55                   	push   %ebp
80103531:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103536:	ba 21 00 00 00       	mov    $0x21,%edx
8010353b:	89 e5                	mov    %esp,%ebp
8010353d:	ee                   	out    %al,(%dx)
8010353e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103543:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103544:	5d                   	pop    %ebp
80103545:	c3                   	ret    
80103546:	66 90                	xchg   %ax,%ax
80103548:	66 90                	xchg   %ax,%ax
8010354a:	66 90                	xchg   %ax,%ax
8010354c:	66 90                	xchg   %ax,%ax
8010354e:	66 90                	xchg   %ax,%ax

80103550 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	57                   	push   %edi
80103554:	56                   	push   %esi
80103555:	53                   	push   %ebx
80103556:	83 ec 0c             	sub    $0xc,%esp
80103559:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010355c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010355f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103565:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010356b:	e8 10 db ff ff       	call   80101080 <filealloc>
80103570:	85 c0                	test   %eax,%eax
80103572:	89 03                	mov    %eax,(%ebx)
80103574:	74 22                	je     80103598 <pipealloc+0x48>
80103576:	e8 05 db ff ff       	call   80101080 <filealloc>
8010357b:	85 c0                	test   %eax,%eax
8010357d:	89 06                	mov    %eax,(%esi)
8010357f:	74 3f                	je     801035c0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103581:	e8 4a f2 ff ff       	call   801027d0 <kalloc>
80103586:	85 c0                	test   %eax,%eax
80103588:	89 c7                	mov    %eax,%edi
8010358a:	75 54                	jne    801035e0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010358c:	8b 03                	mov    (%ebx),%eax
8010358e:	85 c0                	test   %eax,%eax
80103590:	75 34                	jne    801035c6 <pipealloc+0x76>
80103592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103598:	8b 06                	mov    (%esi),%eax
8010359a:	85 c0                	test   %eax,%eax
8010359c:	74 0c                	je     801035aa <pipealloc+0x5a>
    fileclose(*f1);
8010359e:	83 ec 0c             	sub    $0xc,%esp
801035a1:	50                   	push   %eax
801035a2:	e8 99 db ff ff       	call   80101140 <fileclose>
801035a7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801035aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801035ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801035b2:	5b                   	pop    %ebx
801035b3:	5e                   	pop    %esi
801035b4:	5f                   	pop    %edi
801035b5:	5d                   	pop    %ebp
801035b6:	c3                   	ret    
801035b7:	89 f6                	mov    %esi,%esi
801035b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801035c0:	8b 03                	mov    (%ebx),%eax
801035c2:	85 c0                	test   %eax,%eax
801035c4:	74 e4                	je     801035aa <pipealloc+0x5a>
    fileclose(*f0);
801035c6:	83 ec 0c             	sub    $0xc,%esp
801035c9:	50                   	push   %eax
801035ca:	e8 71 db ff ff       	call   80101140 <fileclose>
  if(*f1)
801035cf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801035d1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801035d4:	85 c0                	test   %eax,%eax
801035d6:	75 c6                	jne    8010359e <pipealloc+0x4e>
801035d8:	eb d0                	jmp    801035aa <pipealloc+0x5a>
801035da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801035e0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801035e3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035ea:	00 00 00 
  p->writeopen = 1;
801035ed:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035f4:	00 00 00 
  p->nwrite = 0;
801035f7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035fe:	00 00 00 
  p->nread = 0;
80103601:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103608:	00 00 00 
  initlock(&p->lock, "pipe");
8010360b:	68 10 77 10 80       	push   $0x80107710
80103610:	50                   	push   %eax
80103611:	e8 fa 0e 00 00       	call   80104510 <initlock>
  (*f0)->type = FD_PIPE;
80103616:	8b 03                	mov    (%ebx),%eax
  return 0;
80103618:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010361b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103621:	8b 03                	mov    (%ebx),%eax
80103623:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103627:	8b 03                	mov    (%ebx),%eax
80103629:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010362d:	8b 03                	mov    (%ebx),%eax
8010362f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103632:	8b 06                	mov    (%esi),%eax
80103634:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010363a:	8b 06                	mov    (%esi),%eax
8010363c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103640:	8b 06                	mov    (%esi),%eax
80103642:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103646:	8b 06                	mov    (%esi),%eax
80103648:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010364b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010364e:	31 c0                	xor    %eax,%eax
}
80103650:	5b                   	pop    %ebx
80103651:	5e                   	pop    %esi
80103652:	5f                   	pop    %edi
80103653:	5d                   	pop    %ebp
80103654:	c3                   	ret    
80103655:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103660 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	56                   	push   %esi
80103664:	53                   	push   %ebx
80103665:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103668:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010366b:	83 ec 0c             	sub    $0xc,%esp
8010366e:	53                   	push   %ebx
8010366f:	e8 dc 0f 00 00       	call   80104650 <acquire>
  if(writable){
80103674:	83 c4 10             	add    $0x10,%esp
80103677:	85 f6                	test   %esi,%esi
80103679:	74 45                	je     801036c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010367b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103681:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103684:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010368b:	00 00 00 
    wakeup(&p->nread);
8010368e:	50                   	push   %eax
8010368f:	e8 ac 0b 00 00       	call   80104240 <wakeup>
80103694:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103697:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010369d:	85 d2                	test   %edx,%edx
8010369f:	75 0a                	jne    801036ab <pipeclose+0x4b>
801036a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036a7:	85 c0                	test   %eax,%eax
801036a9:	74 35                	je     801036e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036b1:	5b                   	pop    %ebx
801036b2:	5e                   	pop    %esi
801036b3:	5d                   	pop    %ebp
    release(&p->lock);
801036b4:	e9 57 10 00 00       	jmp    80104710 <release>
801036b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801036c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801036c6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801036c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036d0:	00 00 00 
    wakeup(&p->nwrite);
801036d3:	50                   	push   %eax
801036d4:	e8 67 0b 00 00       	call   80104240 <wakeup>
801036d9:	83 c4 10             	add    $0x10,%esp
801036dc:	eb b9                	jmp    80103697 <pipeclose+0x37>
801036de:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801036e0:	83 ec 0c             	sub    $0xc,%esp
801036e3:	53                   	push   %ebx
801036e4:	e8 27 10 00 00       	call   80104710 <release>
    kfree((char*)p);
801036e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036ec:	83 c4 10             	add    $0x10,%esp
}
801036ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036f2:	5b                   	pop    %ebx
801036f3:	5e                   	pop    %esi
801036f4:	5d                   	pop    %ebp
    kfree((char*)p);
801036f5:	e9 26 ef ff ff       	jmp    80102620 <kfree>
801036fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103700 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	57                   	push   %edi
80103704:	56                   	push   %esi
80103705:	53                   	push   %ebx
80103706:	83 ec 28             	sub    $0x28,%esp
80103709:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010370c:	53                   	push   %ebx
8010370d:	e8 3e 0f 00 00       	call   80104650 <acquire>
  for(i = 0; i < n; i++){
80103712:	8b 45 10             	mov    0x10(%ebp),%eax
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	85 c0                	test   %eax,%eax
8010371a:	0f 8e c9 00 00 00    	jle    801037e9 <pipewrite+0xe9>
80103720:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103723:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103729:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010372f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103732:	03 4d 10             	add    0x10(%ebp),%ecx
80103735:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103738:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010373e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103744:	39 d0                	cmp    %edx,%eax
80103746:	75 71                	jne    801037b9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103748:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010374e:	85 c0                	test   %eax,%eax
80103750:	74 4e                	je     801037a0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103752:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103758:	eb 3a                	jmp    80103794 <pipewrite+0x94>
8010375a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	57                   	push   %edi
80103764:	e8 d7 0a 00 00       	call   80104240 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103769:	5a                   	pop    %edx
8010376a:	59                   	pop    %ecx
8010376b:	53                   	push   %ebx
8010376c:	56                   	push   %esi
8010376d:	e8 1e 09 00 00       	call   80104090 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103772:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103778:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010377e:	83 c4 10             	add    $0x10,%esp
80103781:	05 00 02 00 00       	add    $0x200,%eax
80103786:	39 c2                	cmp    %eax,%edx
80103788:	75 36                	jne    801037c0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010378a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103790:	85 c0                	test   %eax,%eax
80103792:	74 0c                	je     801037a0 <pipewrite+0xa0>
80103794:	e8 57 03 00 00       	call   80103af0 <myproc>
80103799:	8b 40 24             	mov    0x24(%eax),%eax
8010379c:	85 c0                	test   %eax,%eax
8010379e:	74 c0                	je     80103760 <pipewrite+0x60>
        release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
801037a3:	53                   	push   %ebx
801037a4:	e8 67 0f 00 00       	call   80104710 <release>
        return -1;
801037a9:	83 c4 10             	add    $0x10,%esp
801037ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b4:	5b                   	pop    %ebx
801037b5:	5e                   	pop    %esi
801037b6:	5f                   	pop    %edi
801037b7:	5d                   	pop    %ebp
801037b8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037b9:	89 c2                	mov    %eax,%edx
801037bb:	90                   	nop
801037bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037c0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801037c3:	8d 42 01             	lea    0x1(%edx),%eax
801037c6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037cc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801037d2:	83 c6 01             	add    $0x1,%esi
801037d5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801037d9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801037dc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037df:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037e3:	0f 85 4f ff ff ff    	jne    80103738 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037e9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037ef:	83 ec 0c             	sub    $0xc,%esp
801037f2:	50                   	push   %eax
801037f3:	e8 48 0a 00 00       	call   80104240 <wakeup>
  release(&p->lock);
801037f8:	89 1c 24             	mov    %ebx,(%esp)
801037fb:	e8 10 0f 00 00       	call   80104710 <release>
  return n;
80103800:	83 c4 10             	add    $0x10,%esp
80103803:	8b 45 10             	mov    0x10(%ebp),%eax
80103806:	eb a9                	jmp    801037b1 <pipewrite+0xb1>
80103808:	90                   	nop
80103809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103810 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	57                   	push   %edi
80103814:	56                   	push   %esi
80103815:	53                   	push   %ebx
80103816:	83 ec 18             	sub    $0x18,%esp
80103819:	8b 75 08             	mov    0x8(%ebp),%esi
8010381c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010381f:	56                   	push   %esi
80103820:	e8 2b 0e 00 00       	call   80104650 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103825:	83 c4 10             	add    $0x10,%esp
80103828:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010382e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103834:	75 6a                	jne    801038a0 <piperead+0x90>
80103836:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010383c:	85 db                	test   %ebx,%ebx
8010383e:	0f 84 c4 00 00 00    	je     80103908 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103844:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010384a:	eb 2d                	jmp    80103879 <piperead+0x69>
8010384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103850:	83 ec 08             	sub    $0x8,%esp
80103853:	56                   	push   %esi
80103854:	53                   	push   %ebx
80103855:	e8 36 08 00 00       	call   80104090 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010385a:	83 c4 10             	add    $0x10,%esp
8010385d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103863:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103869:	75 35                	jne    801038a0 <piperead+0x90>
8010386b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103871:	85 d2                	test   %edx,%edx
80103873:	0f 84 8f 00 00 00    	je     80103908 <piperead+0xf8>
    if(myproc()->killed){
80103879:	e8 72 02 00 00       	call   80103af0 <myproc>
8010387e:	8b 48 24             	mov    0x24(%eax),%ecx
80103881:	85 c9                	test   %ecx,%ecx
80103883:	74 cb                	je     80103850 <piperead+0x40>
      release(&p->lock);
80103885:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103888:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010388d:	56                   	push   %esi
8010388e:	e8 7d 0e 00 00       	call   80104710 <release>
      return -1;
80103893:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103896:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103899:	89 d8                	mov    %ebx,%eax
8010389b:	5b                   	pop    %ebx
8010389c:	5e                   	pop    %esi
8010389d:	5f                   	pop    %edi
8010389e:	5d                   	pop    %ebp
8010389f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038a0:	8b 45 10             	mov    0x10(%ebp),%eax
801038a3:	85 c0                	test   %eax,%eax
801038a5:	7e 61                	jle    80103908 <piperead+0xf8>
    if(p->nread == p->nwrite)
801038a7:	31 db                	xor    %ebx,%ebx
801038a9:	eb 13                	jmp    801038be <piperead+0xae>
801038ab:	90                   	nop
801038ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038b0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801038b6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801038bc:	74 1f                	je     801038dd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038be:	8d 41 01             	lea    0x1(%ecx),%eax
801038c1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801038c7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801038cd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801038d2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038d5:	83 c3 01             	add    $0x1,%ebx
801038d8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801038db:	75 d3                	jne    801038b0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801038dd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801038e3:	83 ec 0c             	sub    $0xc,%esp
801038e6:	50                   	push   %eax
801038e7:	e8 54 09 00 00       	call   80104240 <wakeup>
  release(&p->lock);
801038ec:	89 34 24             	mov    %esi,(%esp)
801038ef:	e8 1c 0e 00 00       	call   80104710 <release>
  return i;
801038f4:	83 c4 10             	add    $0x10,%esp
}
801038f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038fa:	89 d8                	mov    %ebx,%eax
801038fc:	5b                   	pop    %ebx
801038fd:	5e                   	pop    %esi
801038fe:	5f                   	pop    %edi
801038ff:	5d                   	pop    %ebp
80103900:	c3                   	ret    
80103901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103908:	31 db                	xor    %ebx,%ebx
8010390a:	eb d1                	jmp    801038dd <piperead+0xcd>
8010390c:	66 90                	xchg   %ax,%ax
8010390e:	66 90                	xchg   %ax,%ax

80103910 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103914:	bb 14 30 11 80       	mov    $0x80113014,%ebx
{
80103919:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010391c:	68 e0 2f 11 80       	push   $0x80112fe0
80103921:	e8 2a 0d 00 00       	call   80104650 <acquire>
80103926:	83 c4 10             	add    $0x10,%esp
80103929:	eb 10                	jmp    8010393b <allocproc+0x2b>
8010392b:	90                   	nop
8010392c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103930:	83 c3 7c             	add    $0x7c,%ebx
80103933:	81 fb 14 4f 11 80    	cmp    $0x80114f14,%ebx
80103939:	73 75                	jae    801039b0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010393b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010393e:	85 c0                	test   %eax,%eax
80103940:	75 ee                	jne    80103930 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103942:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103947:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010394a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103951:	8d 50 01             	lea    0x1(%eax),%edx
80103954:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103957:	68 e0 2f 11 80       	push   $0x80112fe0
  p->pid = nextpid++;
8010395c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103962:	e8 a9 0d 00 00       	call   80104710 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103967:	e8 64 ee ff ff       	call   801027d0 <kalloc>
8010396c:	83 c4 10             	add    $0x10,%esp
8010396f:	85 c0                	test   %eax,%eax
80103971:	89 43 08             	mov    %eax,0x8(%ebx)
80103974:	74 53                	je     801039c9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103976:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010397c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010397f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103984:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103987:	c7 40 14 52 59 10 80 	movl   $0x80105952,0x14(%eax)
  p->context = (struct context*)sp;
8010398e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103991:	6a 14                	push   $0x14
80103993:	6a 00                	push   $0x0
80103995:	50                   	push   %eax
80103996:	e8 c5 0d 00 00       	call   80104760 <memset>
  p->context->eip = (uint)forkret;
8010399b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010399e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801039a1:	c7 40 10 e0 39 10 80 	movl   $0x801039e0,0x10(%eax)
}
801039a8:	89 d8                	mov    %ebx,%eax
801039aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039ad:	c9                   	leave  
801039ae:	c3                   	ret    
801039af:	90                   	nop
  release(&ptable.lock);
801039b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801039b3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801039b5:	68 e0 2f 11 80       	push   $0x80112fe0
801039ba:	e8 51 0d 00 00       	call   80104710 <release>
}
801039bf:	89 d8                	mov    %ebx,%eax
  return 0;
801039c1:	83 c4 10             	add    $0x10,%esp
}
801039c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039c7:	c9                   	leave  
801039c8:	c3                   	ret    
    p->state = UNUSED;
801039c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801039d0:	31 db                	xor    %ebx,%ebx
801039d2:	eb d4                	jmp    801039a8 <allocproc+0x98>
801039d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039e6:	68 e0 2f 11 80       	push   $0x80112fe0
801039eb:	e8 20 0d 00 00       	call   80104710 <release>

  if (first) {
801039f0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801039f5:	83 c4 10             	add    $0x10,%esp
801039f8:	85 c0                	test   %eax,%eax
801039fa:	75 04                	jne    80103a00 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039fc:	c9                   	leave  
801039fd:	c3                   	ret    
801039fe:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103a00:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103a03:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103a0a:	00 00 00 
    iinit(ROOTDEV);
80103a0d:	6a 01                	push   $0x1
80103a0f:	e8 7c dd ff ff       	call   80101790 <iinit>
    initlog(ROOTDEV);
80103a14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a1b:	e8 f0 f3 ff ff       	call   80102e10 <initlog>
80103a20:	83 c4 10             	add    $0x10,%esp
}
80103a23:	c9                   	leave  
80103a24:	c3                   	ret    
80103a25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a30 <pinit>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a36:	68 15 77 10 80       	push   $0x80107715
80103a3b:	68 e0 2f 11 80       	push   $0x80112fe0
80103a40:	e8 cb 0a 00 00       	call   80104510 <initlock>
}
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	c9                   	leave  
80103a49:	c3                   	ret    
80103a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a50 <mycpu>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	56                   	push   %esi
80103a54:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a55:	9c                   	pushf  
80103a56:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a57:	f6 c4 02             	test   $0x2,%ah
80103a5a:	75 5e                	jne    80103aba <mycpu+0x6a>
  apicid = lapicid();
80103a5c:	e8 df ef ff ff       	call   80102a40 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a61:	8b 35 c0 2f 11 80    	mov    0x80112fc0,%esi
80103a67:	85 f6                	test   %esi,%esi
80103a69:	7e 42                	jle    80103aad <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a6b:	0f b6 15 40 2a 11 80 	movzbl 0x80112a40,%edx
80103a72:	39 d0                	cmp    %edx,%eax
80103a74:	74 30                	je     80103aa6 <mycpu+0x56>
80103a76:	b9 f0 2a 11 80       	mov    $0x80112af0,%ecx
  for (i = 0; i < ncpu; ++i) {
80103a7b:	31 d2                	xor    %edx,%edx
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi
80103a80:	83 c2 01             	add    $0x1,%edx
80103a83:	39 f2                	cmp    %esi,%edx
80103a85:	74 26                	je     80103aad <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103a87:	0f b6 19             	movzbl (%ecx),%ebx
80103a8a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103a90:	39 c3                	cmp    %eax,%ebx
80103a92:	75 ec                	jne    80103a80 <mycpu+0x30>
80103a94:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103a9a:	05 40 2a 11 80       	add    $0x80112a40,%eax
}
80103a9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aa2:	5b                   	pop    %ebx
80103aa3:	5e                   	pop    %esi
80103aa4:	5d                   	pop    %ebp
80103aa5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103aa6:	b8 40 2a 11 80       	mov    $0x80112a40,%eax
      return &cpus[i];
80103aab:	eb f2                	jmp    80103a9f <mycpu+0x4f>
  panic("unknown apicid\n");
80103aad:	83 ec 0c             	sub    $0xc,%esp
80103ab0:	68 1c 77 10 80       	push   $0x8010771c
80103ab5:	e8 d6 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103aba:	83 ec 0c             	sub    $0xc,%esp
80103abd:	68 f8 77 10 80       	push   $0x801077f8
80103ac2:	e8 c9 c8 ff ff       	call   80100390 <panic>
80103ac7:	89 f6                	mov    %esi,%esi
80103ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ad0 <cpuid>:
cpuid() {
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ad6:	e8 75 ff ff ff       	call   80103a50 <mycpu>
80103adb:	2d 40 2a 11 80       	sub    $0x80112a40,%eax
}
80103ae0:	c9                   	leave  
  return mycpu()-cpus;
80103ae1:	c1 f8 04             	sar    $0x4,%eax
80103ae4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103aea:	c3                   	ret    
80103aeb:	90                   	nop
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103af0 <myproc>:
myproc(void) {
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	53                   	push   %ebx
80103af4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103af7:	e8 84 0a 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103afc:	e8 4f ff ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103b01:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b07:	e8 b4 0a 00 00       	call   801045c0 <popcli>
}
80103b0c:	83 c4 04             	add    $0x4,%esp
80103b0f:	89 d8                	mov    %ebx,%eax
80103b11:	5b                   	pop    %ebx
80103b12:	5d                   	pop    %ebp
80103b13:	c3                   	ret    
80103b14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b20 <userinit>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	53                   	push   %ebx
80103b24:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b27:	e8 e4 fd ff ff       	call   80103910 <allocproc>
80103b2c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b2e:	a3 f8 a5 10 80       	mov    %eax,0x8010a5f8
  if((p->pgdir = setupkvm()) == 0)
80103b33:	e8 e8 33 00 00       	call   80106f20 <setupkvm>
80103b38:	85 c0                	test   %eax,%eax
80103b3a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b3d:	0f 84 bd 00 00 00    	je     80103c00 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b43:	83 ec 04             	sub    $0x4,%esp
80103b46:	68 2c 00 00 00       	push   $0x2c
80103b4b:	68 60 a4 10 80       	push   $0x8010a460
80103b50:	50                   	push   %eax
80103b51:	e8 aa 30 00 00       	call   80106c00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b56:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b59:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b5f:	6a 4c                	push   $0x4c
80103b61:	6a 00                	push   $0x0
80103b63:	ff 73 18             	pushl  0x18(%ebx)
80103b66:	e8 f5 0b 00 00       	call   80104760 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b6b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b6e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b73:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b78:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b7b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b7f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b82:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b86:	8b 43 18             	mov    0x18(%ebx),%eax
80103b89:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b8d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b91:	8b 43 18             	mov    0x18(%ebx),%eax
80103b94:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b98:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b9c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b9f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ba6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ba9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103bb0:	8b 43 18             	mov    0x18(%ebx),%eax
80103bb3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bba:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bbd:	6a 10                	push   $0x10
80103bbf:	68 45 77 10 80       	push   $0x80107745
80103bc4:	50                   	push   %eax
80103bc5:	e8 76 0d 00 00       	call   80104940 <safestrcpy>
  p->cwd = namei("/");
80103bca:	c7 04 24 4e 77 10 80 	movl   $0x8010774e,(%esp)
80103bd1:	e8 1a e6 ff ff       	call   801021f0 <namei>
80103bd6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103bd9:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
80103be0:	e8 6b 0a 00 00       	call   80104650 <acquire>
  p->state = RUNNABLE;
80103be5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bec:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
80103bf3:	e8 18 0b 00 00       	call   80104710 <release>
}
80103bf8:	83 c4 10             	add    $0x10,%esp
80103bfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bfe:	c9                   	leave  
80103bff:	c3                   	ret    
    panic("userinit: out of memory?");
80103c00:	83 ec 0c             	sub    $0xc,%esp
80103c03:	68 2c 77 10 80       	push   $0x8010772c
80103c08:	e8 83 c7 ff ff       	call   80100390 <panic>
80103c0d:	8d 76 00             	lea    0x0(%esi),%esi

80103c10 <growproc>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	56                   	push   %esi
80103c14:	53                   	push   %ebx
80103c15:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c18:	e8 63 09 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103c1d:	e8 2e fe ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103c22:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c28:	e8 93 09 00 00       	call   801045c0 <popcli>
  if(n > 0){
80103c2d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103c30:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c32:	7f 1c                	jg     80103c50 <growproc+0x40>
  } else if(n < 0){
80103c34:	75 3a                	jne    80103c70 <growproc+0x60>
  switchuvm(curproc);
80103c36:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c39:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c3b:	53                   	push   %ebx
80103c3c:	e8 af 2e 00 00       	call   80106af0 <switchuvm>
  return 0;
80103c41:	83 c4 10             	add    $0x10,%esp
80103c44:	31 c0                	xor    %eax,%eax
}
80103c46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c49:	5b                   	pop    %ebx
80103c4a:	5e                   	pop    %esi
80103c4b:	5d                   	pop    %ebp
80103c4c:	c3                   	ret    
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c50:	83 ec 04             	sub    $0x4,%esp
80103c53:	01 c6                	add    %eax,%esi
80103c55:	56                   	push   %esi
80103c56:	50                   	push   %eax
80103c57:	ff 73 04             	pushl  0x4(%ebx)
80103c5a:	e8 e1 30 00 00       	call   80106d40 <allocuvm>
80103c5f:	83 c4 10             	add    $0x10,%esp
80103c62:	85 c0                	test   %eax,%eax
80103c64:	75 d0                	jne    80103c36 <growproc+0x26>
      return -1;
80103c66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c6b:	eb d9                	jmp    80103c46 <growproc+0x36>
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c70:	83 ec 04             	sub    $0x4,%esp
80103c73:	01 c6                	add    %eax,%esi
80103c75:	56                   	push   %esi
80103c76:	50                   	push   %eax
80103c77:	ff 73 04             	pushl  0x4(%ebx)
80103c7a:	e8 f1 31 00 00       	call   80106e70 <deallocuvm>
80103c7f:	83 c4 10             	add    $0x10,%esp
80103c82:	85 c0                	test   %eax,%eax
80103c84:	75 b0                	jne    80103c36 <growproc+0x26>
80103c86:	eb de                	jmp    80103c66 <growproc+0x56>
80103c88:	90                   	nop
80103c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c90 <fork>:
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	57                   	push   %edi
80103c94:	56                   	push   %esi
80103c95:	53                   	push   %ebx
80103c96:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c99:	e8 e2 08 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103c9e:	e8 ad fd ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103ca3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ca9:	e8 12 09 00 00       	call   801045c0 <popcli>
  if((np = allocproc()) == 0){
80103cae:	e8 5d fc ff ff       	call   80103910 <allocproc>
80103cb3:	85 c0                	test   %eax,%eax
80103cb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103cb8:	0f 84 b7 00 00 00    	je     80103d75 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103cbe:	83 ec 08             	sub    $0x8,%esp
80103cc1:	ff 33                	pushl  (%ebx)
80103cc3:	ff 73 04             	pushl  0x4(%ebx)
80103cc6:	89 c7                	mov    %eax,%edi
80103cc8:	e8 23 33 00 00       	call   80106ff0 <copyuvm>
80103ccd:	83 c4 10             	add    $0x10,%esp
80103cd0:	85 c0                	test   %eax,%eax
80103cd2:	89 47 04             	mov    %eax,0x4(%edi)
80103cd5:	0f 84 a1 00 00 00    	je     80103d7c <fork+0xec>
  np->sz = curproc->sz;
80103cdb:	8b 03                	mov    (%ebx),%eax
80103cdd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ce0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103ce2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103ce5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103ce7:	8b 79 18             	mov    0x18(%ecx),%edi
80103cea:	8b 73 18             	mov    0x18(%ebx),%esi
80103ced:	b9 13 00 00 00       	mov    $0x13,%ecx
80103cf2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103cf4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cf6:	8b 40 18             	mov    0x18(%eax),%eax
80103cf9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d00:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d04:	85 c0                	test   %eax,%eax
80103d06:	74 13                	je     80103d1b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d08:	83 ec 0c             	sub    $0xc,%esp
80103d0b:	50                   	push   %eax
80103d0c:	e8 df d3 ff ff       	call   801010f0 <filedup>
80103d11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d14:	83 c4 10             	add    $0x10,%esp
80103d17:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d1b:	83 c6 01             	add    $0x1,%esi
80103d1e:	83 fe 10             	cmp    $0x10,%esi
80103d21:	75 dd                	jne    80103d00 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d23:	83 ec 0c             	sub    $0xc,%esp
80103d26:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d29:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d2c:	e8 2f dc ff ff       	call   80101960 <idup>
80103d31:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d34:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d37:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d3a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d3d:	6a 10                	push   $0x10
80103d3f:	53                   	push   %ebx
80103d40:	50                   	push   %eax
80103d41:	e8 fa 0b 00 00       	call   80104940 <safestrcpy>
  pid = np->pid;
80103d46:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d49:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
80103d50:	e8 fb 08 00 00       	call   80104650 <acquire>
  np->state = RUNNABLE;
80103d55:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d5c:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
80103d63:	e8 a8 09 00 00       	call   80104710 <release>
  return pid;
80103d68:	83 c4 10             	add    $0x10,%esp
}
80103d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d6e:	89 d8                	mov    %ebx,%eax
80103d70:	5b                   	pop    %ebx
80103d71:	5e                   	pop    %esi
80103d72:	5f                   	pop    %edi
80103d73:	5d                   	pop    %ebp
80103d74:	c3                   	ret    
    return -1;
80103d75:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d7a:	eb ef                	jmp    80103d6b <fork+0xdb>
    kfree(np->kstack);
80103d7c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d7f:	83 ec 0c             	sub    $0xc,%esp
80103d82:	ff 73 08             	pushl  0x8(%ebx)
80103d85:	e8 96 e8 ff ff       	call   80102620 <kfree>
    np->kstack = 0;
80103d8a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103d91:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d98:	83 c4 10             	add    $0x10,%esp
80103d9b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103da0:	eb c9                	jmp    80103d6b <fork+0xdb>
80103da2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103db0 <scheduler>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	57                   	push   %edi
80103db4:	56                   	push   %esi
80103db5:	53                   	push   %ebx
80103db6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103db9:	e8 92 fc ff ff       	call   80103a50 <mycpu>
80103dbe:	8d 78 04             	lea    0x4(%eax),%edi
80103dc1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103dc3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103dca:	00 00 00 
80103dcd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103dd0:	fb                   	sti    
    acquire(&ptable.lock);
80103dd1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dd4:	bb 14 30 11 80       	mov    $0x80113014,%ebx
    acquire(&ptable.lock);
80103dd9:	68 e0 2f 11 80       	push   $0x80112fe0
80103dde:	e8 6d 08 00 00       	call   80104650 <acquire>
80103de3:	83 c4 10             	add    $0x10,%esp
80103de6:	8d 76 00             	lea    0x0(%esi),%esi
80103de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103df0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103df4:	75 33                	jne    80103e29 <scheduler+0x79>
      switchuvm(p);
80103df6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103df9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103dff:	53                   	push   %ebx
80103e00:	e8 eb 2c 00 00       	call   80106af0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e05:	58                   	pop    %eax
80103e06:	5a                   	pop    %edx
80103e07:	ff 73 1c             	pushl  0x1c(%ebx)
80103e0a:	57                   	push   %edi
      p->state = RUNNING;
80103e0b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e12:	e8 84 0b 00 00       	call   8010499b <swtch>
      switchkvm();
80103e17:	e8 b4 2c 00 00       	call   80106ad0 <switchkvm>
      c->proc = 0;
80103e1c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e23:	00 00 00 
80103e26:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e29:	83 c3 7c             	add    $0x7c,%ebx
80103e2c:	81 fb 14 4f 11 80    	cmp    $0x80114f14,%ebx
80103e32:	72 bc                	jb     80103df0 <scheduler+0x40>
    release(&ptable.lock);
80103e34:	83 ec 0c             	sub    $0xc,%esp
80103e37:	68 e0 2f 11 80       	push   $0x80112fe0
80103e3c:	e8 cf 08 00 00       	call   80104710 <release>
    sti();
80103e41:	83 c4 10             	add    $0x10,%esp
80103e44:	eb 8a                	jmp    80103dd0 <scheduler+0x20>
80103e46:	8d 76 00             	lea    0x0(%esi),%esi
80103e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e50 <sched>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	56                   	push   %esi
80103e54:	53                   	push   %ebx
  pushcli();
80103e55:	e8 26 07 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103e5a:	e8 f1 fb ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103e5f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e65:	e8 56 07 00 00       	call   801045c0 <popcli>
  if(!holding(&ptable.lock))
80103e6a:	83 ec 0c             	sub    $0xc,%esp
80103e6d:	68 e0 2f 11 80       	push   $0x80112fe0
80103e72:	e8 a9 07 00 00       	call   80104620 <holding>
80103e77:	83 c4 10             	add    $0x10,%esp
80103e7a:	85 c0                	test   %eax,%eax
80103e7c:	74 4f                	je     80103ecd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e7e:	e8 cd fb ff ff       	call   80103a50 <mycpu>
80103e83:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e8a:	75 68                	jne    80103ef4 <sched+0xa4>
  if(p->state == RUNNING)
80103e8c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e90:	74 55                	je     80103ee7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e92:	9c                   	pushf  
80103e93:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e94:	f6 c4 02             	test   $0x2,%ah
80103e97:	75 41                	jne    80103eda <sched+0x8a>
  intena = mycpu()->intena;
80103e99:	e8 b2 fb ff ff       	call   80103a50 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e9e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ea1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ea7:	e8 a4 fb ff ff       	call   80103a50 <mycpu>
80103eac:	83 ec 08             	sub    $0x8,%esp
80103eaf:	ff 70 04             	pushl  0x4(%eax)
80103eb2:	53                   	push   %ebx
80103eb3:	e8 e3 0a 00 00       	call   8010499b <swtch>
  mycpu()->intena = intena;
80103eb8:	e8 93 fb ff ff       	call   80103a50 <mycpu>
}
80103ebd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ec0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ec6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ec9:	5b                   	pop    %ebx
80103eca:	5e                   	pop    %esi
80103ecb:	5d                   	pop    %ebp
80103ecc:	c3                   	ret    
    panic("sched ptable.lock");
80103ecd:	83 ec 0c             	sub    $0xc,%esp
80103ed0:	68 50 77 10 80       	push   $0x80107750
80103ed5:	e8 b6 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 7c 77 10 80       	push   $0x8010777c
80103ee2:	e8 a9 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103ee7:	83 ec 0c             	sub    $0xc,%esp
80103eea:	68 6e 77 10 80       	push   $0x8010776e
80103eef:	e8 9c c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103ef4:	83 ec 0c             	sub    $0xc,%esp
80103ef7:	68 62 77 10 80       	push   $0x80107762
80103efc:	e8 8f c4 ff ff       	call   80100390 <panic>
80103f01:	eb 0d                	jmp    80103f10 <exit>
80103f03:	90                   	nop
80103f04:	90                   	nop
80103f05:	90                   	nop
80103f06:	90                   	nop
80103f07:	90                   	nop
80103f08:	90                   	nop
80103f09:	90                   	nop
80103f0a:	90                   	nop
80103f0b:	90                   	nop
80103f0c:	90                   	nop
80103f0d:	90                   	nop
80103f0e:	90                   	nop
80103f0f:	90                   	nop

80103f10 <exit>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	57                   	push   %edi
80103f14:	56                   	push   %esi
80103f15:	53                   	push   %ebx
80103f16:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f19:	e8 62 06 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103f1e:	e8 2d fb ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103f23:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f29:	e8 92 06 00 00       	call   801045c0 <popcli>
  if(curproc == initproc)
80103f2e:	39 35 f8 a5 10 80    	cmp    %esi,0x8010a5f8
80103f34:	8d 5e 28             	lea    0x28(%esi),%ebx
80103f37:	8d 7e 68             	lea    0x68(%esi),%edi
80103f3a:	0f 84 e7 00 00 00    	je     80104027 <exit+0x117>
    if(curproc->ofile[fd]){
80103f40:	8b 03                	mov    (%ebx),%eax
80103f42:	85 c0                	test   %eax,%eax
80103f44:	74 12                	je     80103f58 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103f46:	83 ec 0c             	sub    $0xc,%esp
80103f49:	50                   	push   %eax
80103f4a:	e8 f1 d1 ff ff       	call   80101140 <fileclose>
      curproc->ofile[fd] = 0;
80103f4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103f55:	83 c4 10             	add    $0x10,%esp
80103f58:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103f5b:	39 fb                	cmp    %edi,%ebx
80103f5d:	75 e1                	jne    80103f40 <exit+0x30>
  begin_op();
80103f5f:	e8 4c ef ff ff       	call   80102eb0 <begin_op>
  iput(curproc->cwd);
80103f64:	83 ec 0c             	sub    $0xc,%esp
80103f67:	ff 76 68             	pushl  0x68(%esi)
80103f6a:	e8 51 db ff ff       	call   80101ac0 <iput>
  end_op();
80103f6f:	e8 ac ef ff ff       	call   80102f20 <end_op>
  curproc->cwd = 0;
80103f74:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103f7b:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
80103f82:	e8 c9 06 00 00       	call   80104650 <acquire>
  wakeup1(curproc->parent);
80103f87:	8b 56 14             	mov    0x14(%esi),%edx
80103f8a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f8d:	b8 14 30 11 80       	mov    $0x80113014,%eax
80103f92:	eb 0e                	jmp    80103fa2 <exit+0x92>
80103f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f98:	83 c0 7c             	add    $0x7c,%eax
80103f9b:	3d 14 4f 11 80       	cmp    $0x80114f14,%eax
80103fa0:	73 1c                	jae    80103fbe <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103fa2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fa6:	75 f0                	jne    80103f98 <exit+0x88>
80103fa8:	3b 50 20             	cmp    0x20(%eax),%edx
80103fab:	75 eb                	jne    80103f98 <exit+0x88>
      p->state = RUNNABLE;
80103fad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb4:	83 c0 7c             	add    $0x7c,%eax
80103fb7:	3d 14 4f 11 80       	cmp    $0x80114f14,%eax
80103fbc:	72 e4                	jb     80103fa2 <exit+0x92>
      p->parent = initproc;
80103fbe:	8b 0d f8 a5 10 80    	mov    0x8010a5f8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fc4:	ba 14 30 11 80       	mov    $0x80113014,%edx
80103fc9:	eb 10                	jmp    80103fdb <exit+0xcb>
80103fcb:	90                   	nop
80103fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fd0:	83 c2 7c             	add    $0x7c,%edx
80103fd3:	81 fa 14 4f 11 80    	cmp    $0x80114f14,%edx
80103fd9:	73 33                	jae    8010400e <exit+0xfe>
    if(p->parent == curproc){
80103fdb:	39 72 14             	cmp    %esi,0x14(%edx)
80103fde:	75 f0                	jne    80103fd0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103fe0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103fe4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103fe7:	75 e7                	jne    80103fd0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fe9:	b8 14 30 11 80       	mov    $0x80113014,%eax
80103fee:	eb 0a                	jmp    80103ffa <exit+0xea>
80103ff0:	83 c0 7c             	add    $0x7c,%eax
80103ff3:	3d 14 4f 11 80       	cmp    $0x80114f14,%eax
80103ff8:	73 d6                	jae    80103fd0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103ffa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ffe:	75 f0                	jne    80103ff0 <exit+0xe0>
80104000:	3b 48 20             	cmp    0x20(%eax),%ecx
80104003:	75 eb                	jne    80103ff0 <exit+0xe0>
      p->state = RUNNABLE;
80104005:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010400c:	eb e2                	jmp    80103ff0 <exit+0xe0>
  curproc->state = ZOMBIE;
8010400e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104015:	e8 36 fe ff ff       	call   80103e50 <sched>
  panic("zombie exit");
8010401a:	83 ec 0c             	sub    $0xc,%esp
8010401d:	68 9d 77 10 80       	push   $0x8010779d
80104022:	e8 69 c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104027:	83 ec 0c             	sub    $0xc,%esp
8010402a:	68 90 77 10 80       	push   $0x80107790
8010402f:	e8 5c c3 ff ff       	call   80100390 <panic>
80104034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010403a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104040 <yield>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104047:	68 e0 2f 11 80       	push   $0x80112fe0
8010404c:	e8 ff 05 00 00       	call   80104650 <acquire>
  pushcli();
80104051:	e8 2a 05 00 00       	call   80104580 <pushcli>
  c = mycpu();
80104056:	e8 f5 f9 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
8010405b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104061:	e8 5a 05 00 00       	call   801045c0 <popcli>
  myproc()->state = RUNNABLE;
80104066:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010406d:	e8 de fd ff ff       	call   80103e50 <sched>
  release(&ptable.lock);
80104072:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
80104079:	e8 92 06 00 00       	call   80104710 <release>
}
8010407e:	83 c4 10             	add    $0x10,%esp
80104081:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104084:	c9                   	leave  
80104085:	c3                   	ret    
80104086:	8d 76 00             	lea    0x0(%esi),%esi
80104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104090 <sleep>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	83 ec 0c             	sub    $0xc,%esp
80104099:	8b 7d 08             	mov    0x8(%ebp),%edi
8010409c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010409f:	e8 dc 04 00 00       	call   80104580 <pushcli>
  c = mycpu();
801040a4:	e8 a7 f9 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
801040a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040af:	e8 0c 05 00 00       	call   801045c0 <popcli>
  if(p == 0)
801040b4:	85 db                	test   %ebx,%ebx
801040b6:	0f 84 87 00 00 00    	je     80104143 <sleep+0xb3>
  if(lk == 0)
801040bc:	85 f6                	test   %esi,%esi
801040be:	74 76                	je     80104136 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040c0:	81 fe e0 2f 11 80    	cmp    $0x80112fe0,%esi
801040c6:	74 50                	je     80104118 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	68 e0 2f 11 80       	push   $0x80112fe0
801040d0:	e8 7b 05 00 00       	call   80104650 <acquire>
    release(lk);
801040d5:	89 34 24             	mov    %esi,(%esp)
801040d8:	e8 33 06 00 00       	call   80104710 <release>
  p->chan = chan;
801040dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040e7:	e8 64 fd ff ff       	call   80103e50 <sched>
  p->chan = 0;
801040ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040f3:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
801040fa:	e8 11 06 00 00       	call   80104710 <release>
    acquire(lk);
801040ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104102:	83 c4 10             	add    $0x10,%esp
}
80104105:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104108:	5b                   	pop    %ebx
80104109:	5e                   	pop    %esi
8010410a:	5f                   	pop    %edi
8010410b:	5d                   	pop    %ebp
    acquire(lk);
8010410c:	e9 3f 05 00 00       	jmp    80104650 <acquire>
80104111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104118:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010411b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104122:	e8 29 fd ff ff       	call   80103e50 <sched>
  p->chan = 0;
80104127:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010412e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104131:	5b                   	pop    %ebx
80104132:	5e                   	pop    %esi
80104133:	5f                   	pop    %edi
80104134:	5d                   	pop    %ebp
80104135:	c3                   	ret    
    panic("sleep without lk");
80104136:	83 ec 0c             	sub    $0xc,%esp
80104139:	68 af 77 10 80       	push   $0x801077af
8010413e:	e8 4d c2 ff ff       	call   80100390 <panic>
    panic("sleep");
80104143:	83 ec 0c             	sub    $0xc,%esp
80104146:	68 a9 77 10 80       	push   $0x801077a9
8010414b:	e8 40 c2 ff ff       	call   80100390 <panic>

80104150 <wait>:
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	56                   	push   %esi
80104154:	53                   	push   %ebx
  pushcli();
80104155:	e8 26 04 00 00       	call   80104580 <pushcli>
  c = mycpu();
8010415a:	e8 f1 f8 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
8010415f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104165:	e8 56 04 00 00       	call   801045c0 <popcli>
  acquire(&ptable.lock);
8010416a:	83 ec 0c             	sub    $0xc,%esp
8010416d:	68 e0 2f 11 80       	push   $0x80112fe0
80104172:	e8 d9 04 00 00       	call   80104650 <acquire>
80104177:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010417a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010417c:	bb 14 30 11 80       	mov    $0x80113014,%ebx
80104181:	eb 10                	jmp    80104193 <wait+0x43>
80104183:	90                   	nop
80104184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104188:	83 c3 7c             	add    $0x7c,%ebx
8010418b:	81 fb 14 4f 11 80    	cmp    $0x80114f14,%ebx
80104191:	73 1b                	jae    801041ae <wait+0x5e>
      if(p->parent != curproc)
80104193:	39 73 14             	cmp    %esi,0x14(%ebx)
80104196:	75 f0                	jne    80104188 <wait+0x38>
      if(p->state == ZOMBIE){
80104198:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010419c:	74 32                	je     801041d0 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010419e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801041a1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a6:	81 fb 14 4f 11 80    	cmp    $0x80114f14,%ebx
801041ac:	72 e5                	jb     80104193 <wait+0x43>
    if(!havekids || curproc->killed){
801041ae:	85 c0                	test   %eax,%eax
801041b0:	74 74                	je     80104226 <wait+0xd6>
801041b2:	8b 46 24             	mov    0x24(%esi),%eax
801041b5:	85 c0                	test   %eax,%eax
801041b7:	75 6d                	jne    80104226 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801041b9:	83 ec 08             	sub    $0x8,%esp
801041bc:	68 e0 2f 11 80       	push   $0x80112fe0
801041c1:	56                   	push   %esi
801041c2:	e8 c9 fe ff ff       	call   80104090 <sleep>
    havekids = 0;
801041c7:	83 c4 10             	add    $0x10,%esp
801041ca:	eb ae                	jmp    8010417a <wait+0x2a>
801041cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801041d0:	83 ec 0c             	sub    $0xc,%esp
801041d3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801041d6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801041d9:	e8 42 e4 ff ff       	call   80102620 <kfree>
        freevm(p->pgdir);
801041de:	5a                   	pop    %edx
801041df:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801041e2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801041e9:	e8 b2 2c 00 00       	call   80106ea0 <freevm>
        release(&ptable.lock);
801041ee:	c7 04 24 e0 2f 11 80 	movl   $0x80112fe0,(%esp)
        p->pid = 0;
801041f5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041fc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104203:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104207:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010420e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104215:	e8 f6 04 00 00       	call   80104710 <release>
        return pid;
8010421a:	83 c4 10             	add    $0x10,%esp
}
8010421d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104220:	89 f0                	mov    %esi,%eax
80104222:	5b                   	pop    %ebx
80104223:	5e                   	pop    %esi
80104224:	5d                   	pop    %ebp
80104225:	c3                   	ret    
      release(&ptable.lock);
80104226:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104229:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010422e:	68 e0 2f 11 80       	push   $0x80112fe0
80104233:	e8 d8 04 00 00       	call   80104710 <release>
      return -1;
80104238:	83 c4 10             	add    $0x10,%esp
8010423b:	eb e0                	jmp    8010421d <wait+0xcd>
8010423d:	8d 76 00             	lea    0x0(%esi),%esi

80104240 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 10             	sub    $0x10,%esp
80104247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010424a:	68 e0 2f 11 80       	push   $0x80112fe0
8010424f:	e8 fc 03 00 00       	call   80104650 <acquire>
80104254:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104257:	b8 14 30 11 80       	mov    $0x80113014,%eax
8010425c:	eb 0c                	jmp    8010426a <wakeup+0x2a>
8010425e:	66 90                	xchg   %ax,%ax
80104260:	83 c0 7c             	add    $0x7c,%eax
80104263:	3d 14 4f 11 80       	cmp    $0x80114f14,%eax
80104268:	73 1c                	jae    80104286 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010426a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010426e:	75 f0                	jne    80104260 <wakeup+0x20>
80104270:	3b 58 20             	cmp    0x20(%eax),%ebx
80104273:	75 eb                	jne    80104260 <wakeup+0x20>
      p->state = RUNNABLE;
80104275:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010427c:	83 c0 7c             	add    $0x7c,%eax
8010427f:	3d 14 4f 11 80       	cmp    $0x80114f14,%eax
80104284:	72 e4                	jb     8010426a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104286:	c7 45 08 e0 2f 11 80 	movl   $0x80112fe0,0x8(%ebp)
}
8010428d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104290:	c9                   	leave  
  release(&ptable.lock);
80104291:	e9 7a 04 00 00       	jmp    80104710 <release>
80104296:	8d 76 00             	lea    0x0(%esi),%esi
80104299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 10             	sub    $0x10,%esp
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042aa:	68 e0 2f 11 80       	push   $0x80112fe0
801042af:	e8 9c 03 00 00       	call   80104650 <acquire>
801042b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b7:	b8 14 30 11 80       	mov    $0x80113014,%eax
801042bc:	eb 0c                	jmp    801042ca <kill+0x2a>
801042be:	66 90                	xchg   %ax,%ax
801042c0:	83 c0 7c             	add    $0x7c,%eax
801042c3:	3d 14 4f 11 80       	cmp    $0x80114f14,%eax
801042c8:	73 36                	jae    80104300 <kill+0x60>
    if(p->pid == pid){
801042ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801042cd:	75 f1                	jne    801042c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042cf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042da:	75 07                	jne    801042e3 <kill+0x43>
        p->state = RUNNABLE;
801042dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042e3:	83 ec 0c             	sub    $0xc,%esp
801042e6:	68 e0 2f 11 80       	push   $0x80112fe0
801042eb:	e8 20 04 00 00       	call   80104710 <release>
      return 0;
801042f0:	83 c4 10             	add    $0x10,%esp
801042f3:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801042f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f8:	c9                   	leave  
801042f9:	c3                   	ret    
801042fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	68 e0 2f 11 80       	push   $0x80112fe0
80104308:	e8 03 04 00 00       	call   80104710 <release>
  return -1;
8010430d:	83 c4 10             	add    $0x10,%esp
80104310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104315:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104318:	c9                   	leave  
80104319:	c3                   	ret    
8010431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104320 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	57                   	push   %edi
80104324:	56                   	push   %esi
80104325:	53                   	push   %ebx
80104326:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104329:	bb 14 30 11 80       	mov    $0x80113014,%ebx
{
8010432e:	83 ec 3c             	sub    $0x3c,%esp
80104331:	eb 24                	jmp    80104357 <procdump+0x37>
80104333:	90                   	nop
80104334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	68 37 7b 10 80       	push   $0x80107b37
80104340:	e8 1b c3 ff ff       	call   80100660 <cprintf>
80104345:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104348:	83 c3 7c             	add    $0x7c,%ebx
8010434b:	81 fb 14 4f 11 80    	cmp    $0x80114f14,%ebx
80104351:	0f 83 81 00 00 00    	jae    801043d8 <procdump+0xb8>
    if(p->state == UNUSED)
80104357:	8b 43 0c             	mov    0xc(%ebx),%eax
8010435a:	85 c0                	test   %eax,%eax
8010435c:	74 ea                	je     80104348 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010435e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104361:	ba c0 77 10 80       	mov    $0x801077c0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104366:	77 11                	ja     80104379 <procdump+0x59>
80104368:	8b 14 85 20 78 10 80 	mov    -0x7fef87e0(,%eax,4),%edx
      state = "???";
8010436f:	b8 c0 77 10 80       	mov    $0x801077c0,%eax
80104374:	85 d2                	test   %edx,%edx
80104376:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104379:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010437c:	50                   	push   %eax
8010437d:	52                   	push   %edx
8010437e:	ff 73 10             	pushl  0x10(%ebx)
80104381:	68 c4 77 10 80       	push   $0x801077c4
80104386:	e8 d5 c2 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010438b:	83 c4 10             	add    $0x10,%esp
8010438e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104392:	75 a4                	jne    80104338 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104394:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104397:	83 ec 08             	sub    $0x8,%esp
8010439a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010439d:	50                   	push   %eax
8010439e:	8b 43 1c             	mov    0x1c(%ebx),%eax
801043a1:	8b 40 0c             	mov    0xc(%eax),%eax
801043a4:	83 c0 08             	add    $0x8,%eax
801043a7:	50                   	push   %eax
801043a8:	e8 83 01 00 00       	call   80104530 <getcallerpcs>
801043ad:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043b0:	8b 17                	mov    (%edi),%edx
801043b2:	85 d2                	test   %edx,%edx
801043b4:	74 82                	je     80104338 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043b6:	83 ec 08             	sub    $0x8,%esp
801043b9:	83 c7 04             	add    $0x4,%edi
801043bc:	52                   	push   %edx
801043bd:	68 01 72 10 80       	push   $0x80107201
801043c2:	e8 99 c2 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043c7:	83 c4 10             	add    $0x10,%esp
801043ca:	39 fe                	cmp    %edi,%esi
801043cc:	75 e2                	jne    801043b0 <procdump+0x90>
801043ce:	e9 65 ff ff ff       	jmp    80104338 <procdump+0x18>
801043d3:	90                   	nop
801043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
801043d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043db:	5b                   	pop    %ebx
801043dc:	5e                   	pop    %esi
801043dd:	5f                   	pop    %edi
801043de:	5d                   	pop    %ebp
801043df:	c3                   	ret    

801043e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	83 ec 0c             	sub    $0xc,%esp
801043e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043ea:	68 38 78 10 80       	push   $0x80107838
801043ef:	8d 43 04             	lea    0x4(%ebx),%eax
801043f2:	50                   	push   %eax
801043f3:	e8 18 01 00 00       	call   80104510 <initlock>
  lk->name = name;
801043f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104401:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104404:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010440b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010440e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104411:	c9                   	leave  
80104412:	c3                   	ret    
80104413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104420 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	56                   	push   %esi
80104424:	53                   	push   %ebx
80104425:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104428:	83 ec 0c             	sub    $0xc,%esp
8010442b:	8d 73 04             	lea    0x4(%ebx),%esi
8010442e:	56                   	push   %esi
8010442f:	e8 1c 02 00 00       	call   80104650 <acquire>
  while (lk->locked) {
80104434:	8b 13                	mov    (%ebx),%edx
80104436:	83 c4 10             	add    $0x10,%esp
80104439:	85 d2                	test   %edx,%edx
8010443b:	74 16                	je     80104453 <acquiresleep+0x33>
8010443d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104440:	83 ec 08             	sub    $0x8,%esp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	e8 46 fc ff ff       	call   80104090 <sleep>
  while (lk->locked) {
8010444a:	8b 03                	mov    (%ebx),%eax
8010444c:	83 c4 10             	add    $0x10,%esp
8010444f:	85 c0                	test   %eax,%eax
80104451:	75 ed                	jne    80104440 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104453:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104459:	e8 92 f6 ff ff       	call   80103af0 <myproc>
8010445e:	8b 40 10             	mov    0x10(%eax),%eax
80104461:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104464:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104467:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010446a:	5b                   	pop    %ebx
8010446b:	5e                   	pop    %esi
8010446c:	5d                   	pop    %ebp
  release(&lk->lk);
8010446d:	e9 9e 02 00 00       	jmp    80104710 <release>
80104472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104480 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
80104485:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104488:	83 ec 0c             	sub    $0xc,%esp
8010448b:	8d 73 04             	lea    0x4(%ebx),%esi
8010448e:	56                   	push   %esi
8010448f:	e8 bc 01 00 00       	call   80104650 <acquire>
  lk->locked = 0;
80104494:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010449a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044a1:	89 1c 24             	mov    %ebx,(%esp)
801044a4:	e8 97 fd ff ff       	call   80104240 <wakeup>
  release(&lk->lk);
801044a9:	89 75 08             	mov    %esi,0x8(%ebp)
801044ac:	83 c4 10             	add    $0x10,%esp
}
801044af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044b2:	5b                   	pop    %ebx
801044b3:	5e                   	pop    %esi
801044b4:	5d                   	pop    %ebp
  release(&lk->lk);
801044b5:	e9 56 02 00 00       	jmp    80104710 <release>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	57                   	push   %edi
801044c4:	56                   	push   %esi
801044c5:	53                   	push   %ebx
801044c6:	31 ff                	xor    %edi,%edi
801044c8:	83 ec 18             	sub    $0x18,%esp
801044cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044ce:	8d 73 04             	lea    0x4(%ebx),%esi
801044d1:	56                   	push   %esi
801044d2:	e8 79 01 00 00       	call   80104650 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044d7:	8b 03                	mov    (%ebx),%eax
801044d9:	83 c4 10             	add    $0x10,%esp
801044dc:	85 c0                	test   %eax,%eax
801044de:	74 13                	je     801044f3 <holdingsleep+0x33>
801044e0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801044e3:	e8 08 f6 ff ff       	call   80103af0 <myproc>
801044e8:	39 58 10             	cmp    %ebx,0x10(%eax)
801044eb:	0f 94 c0             	sete   %al
801044ee:	0f b6 c0             	movzbl %al,%eax
801044f1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801044f3:	83 ec 0c             	sub    $0xc,%esp
801044f6:	56                   	push   %esi
801044f7:	e8 14 02 00 00       	call   80104710 <release>
  return r;
}
801044fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044ff:	89 f8                	mov    %edi,%eax
80104501:	5b                   	pop    %ebx
80104502:	5e                   	pop    %esi
80104503:	5f                   	pop    %edi
80104504:	5d                   	pop    %ebp
80104505:	c3                   	ret    
80104506:	66 90                	xchg   %ax,%ax
80104508:	66 90                	xchg   %ax,%ax
8010450a:	66 90                	xchg   %ax,%ax
8010450c:	66 90                	xchg   %ax,%ax
8010450e:	66 90                	xchg   %ax,%ax

80104510 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104516:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010451f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104522:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104529:	5d                   	pop    %ebp
8010452a:	c3                   	ret    
8010452b:	90                   	nop
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104530 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104530:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104531:	31 d2                	xor    %edx,%edx
{
80104533:	89 e5                	mov    %esp,%ebp
80104535:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104536:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104539:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010453c:	83 e8 08             	sub    $0x8,%eax
8010453f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104540:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104546:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010454c:	77 1a                	ja     80104568 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010454e:	8b 58 04             	mov    0x4(%eax),%ebx
80104551:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104554:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104557:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104559:	83 fa 0a             	cmp    $0xa,%edx
8010455c:	75 e2                	jne    80104540 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010455e:	5b                   	pop    %ebx
8010455f:	5d                   	pop    %ebp
80104560:	c3                   	ret    
80104561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104568:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010456b:	83 c1 28             	add    $0x28,%ecx
8010456e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104576:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104579:	39 c1                	cmp    %eax,%ecx
8010457b:	75 f3                	jne    80104570 <getcallerpcs+0x40>
}
8010457d:	5b                   	pop    %ebx
8010457e:	5d                   	pop    %ebp
8010457f:	c3                   	ret    

80104580 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 04             	sub    $0x4,%esp
80104587:	9c                   	pushf  
80104588:	5b                   	pop    %ebx
  asm volatile("cli");
80104589:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010458a:	e8 c1 f4 ff ff       	call   80103a50 <mycpu>
8010458f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104595:	85 c0                	test   %eax,%eax
80104597:	75 11                	jne    801045aa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104599:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010459f:	e8 ac f4 ff ff       	call   80103a50 <mycpu>
801045a4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801045aa:	e8 a1 f4 ff ff       	call   80103a50 <mycpu>
801045af:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045b6:	83 c4 04             	add    $0x4,%esp
801045b9:	5b                   	pop    %ebx
801045ba:	5d                   	pop    %ebp
801045bb:	c3                   	ret    
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045c0 <popcli>:

void
popcli(void)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045c6:	9c                   	pushf  
801045c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045c8:	f6 c4 02             	test   $0x2,%ah
801045cb:	75 35                	jne    80104602 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045cd:	e8 7e f4 ff ff       	call   80103a50 <mycpu>
801045d2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045d9:	78 34                	js     8010460f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045db:	e8 70 f4 ff ff       	call   80103a50 <mycpu>
801045e0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045e6:	85 d2                	test   %edx,%edx
801045e8:	74 06                	je     801045f0 <popcli+0x30>
    sti();
}
801045ea:	c9                   	leave  
801045eb:	c3                   	ret    
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045f0:	e8 5b f4 ff ff       	call   80103a50 <mycpu>
801045f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801045fb:	85 c0                	test   %eax,%eax
801045fd:	74 eb                	je     801045ea <popcli+0x2a>
  asm volatile("sti");
801045ff:	fb                   	sti    
}
80104600:	c9                   	leave  
80104601:	c3                   	ret    
    panic("popcli - interruptible");
80104602:	83 ec 0c             	sub    $0xc,%esp
80104605:	68 43 78 10 80       	push   $0x80107843
8010460a:	e8 81 bd ff ff       	call   80100390 <panic>
    panic("popcli");
8010460f:	83 ec 0c             	sub    $0xc,%esp
80104612:	68 5a 78 10 80       	push   $0x8010785a
80104617:	e8 74 bd ff ff       	call   80100390 <panic>
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104620 <holding>:
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	8b 75 08             	mov    0x8(%ebp),%esi
80104628:	31 db                	xor    %ebx,%ebx
  pushcli();
8010462a:	e8 51 ff ff ff       	call   80104580 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010462f:	8b 06                	mov    (%esi),%eax
80104631:	85 c0                	test   %eax,%eax
80104633:	74 10                	je     80104645 <holding+0x25>
80104635:	8b 5e 08             	mov    0x8(%esi),%ebx
80104638:	e8 13 f4 ff ff       	call   80103a50 <mycpu>
8010463d:	39 c3                	cmp    %eax,%ebx
8010463f:	0f 94 c3             	sete   %bl
80104642:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104645:	e8 76 ff ff ff       	call   801045c0 <popcli>
}
8010464a:	89 d8                	mov    %ebx,%eax
8010464c:	5b                   	pop    %ebx
8010464d:	5e                   	pop    %esi
8010464e:	5d                   	pop    %ebp
8010464f:	c3                   	ret    

80104650 <acquire>:
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104655:	e8 26 ff ff ff       	call   80104580 <pushcli>
  if(holding(lk))
8010465a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010465d:	83 ec 0c             	sub    $0xc,%esp
80104660:	53                   	push   %ebx
80104661:	e8 ba ff ff ff       	call   80104620 <holding>
80104666:	83 c4 10             	add    $0x10,%esp
80104669:	85 c0                	test   %eax,%eax
8010466b:	0f 85 83 00 00 00    	jne    801046f4 <acquire+0xa4>
80104671:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104673:	ba 01 00 00 00       	mov    $0x1,%edx
80104678:	eb 09                	jmp    80104683 <acquire+0x33>
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104680:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104683:	89 d0                	mov    %edx,%eax
80104685:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104688:	85 c0                	test   %eax,%eax
8010468a:	75 f4                	jne    80104680 <acquire+0x30>
  __sync_synchronize();
8010468c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104691:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104694:	e8 b7 f3 ff ff       	call   80103a50 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104699:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010469c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010469f:	89 e8                	mov    %ebp,%eax
801046a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046a8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801046ae:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801046b4:	77 1a                	ja     801046d0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801046b6:	8b 48 04             	mov    0x4(%eax),%ecx
801046b9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801046bc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801046bf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046c1:	83 fe 0a             	cmp    $0xa,%esi
801046c4:	75 e2                	jne    801046a8 <acquire+0x58>
}
801046c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c9:	5b                   	pop    %ebx
801046ca:	5e                   	pop    %esi
801046cb:	5d                   	pop    %ebp
801046cc:	c3                   	ret    
801046cd:	8d 76 00             	lea    0x0(%esi),%esi
801046d0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801046d3:	83 c2 28             	add    $0x28,%edx
801046d6:	8d 76 00             	lea    0x0(%esi),%esi
801046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801046e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801046e6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801046e9:	39 d0                	cmp    %edx,%eax
801046eb:	75 f3                	jne    801046e0 <acquire+0x90>
}
801046ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046f0:	5b                   	pop    %ebx
801046f1:	5e                   	pop    %esi
801046f2:	5d                   	pop    %ebp
801046f3:	c3                   	ret    
    panic("acquire");
801046f4:	83 ec 0c             	sub    $0xc,%esp
801046f7:	68 61 78 10 80       	push   $0x80107861
801046fc:	e8 8f bc ff ff       	call   80100390 <panic>
80104701:	eb 0d                	jmp    80104710 <release>
80104703:	90                   	nop
80104704:	90                   	nop
80104705:	90                   	nop
80104706:	90                   	nop
80104707:	90                   	nop
80104708:	90                   	nop
80104709:	90                   	nop
8010470a:	90                   	nop
8010470b:	90                   	nop
8010470c:	90                   	nop
8010470d:	90                   	nop
8010470e:	90                   	nop
8010470f:	90                   	nop

80104710 <release>:
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 10             	sub    $0x10,%esp
80104717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010471a:	53                   	push   %ebx
8010471b:	e8 00 ff ff ff       	call   80104620 <holding>
80104720:	83 c4 10             	add    $0x10,%esp
80104723:	85 c0                	test   %eax,%eax
80104725:	74 22                	je     80104749 <release+0x39>
  lk->pcs[0] = 0;
80104727:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010472e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104735:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010473a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104740:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104743:	c9                   	leave  
  popcli();
80104744:	e9 77 fe ff ff       	jmp    801045c0 <popcli>
    panic("release");
80104749:	83 ec 0c             	sub    $0xc,%esp
8010474c:	68 69 78 10 80       	push   $0x80107869
80104751:	e8 3a bc ff ff       	call   80100390 <panic>
80104756:	66 90                	xchg   %ax,%ax
80104758:	66 90                	xchg   %ax,%ax
8010475a:	66 90                	xchg   %ax,%ax
8010475c:	66 90                	xchg   %ax,%ax
8010475e:	66 90                	xchg   %ax,%ax

80104760 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	57                   	push   %edi
80104764:	53                   	push   %ebx
80104765:	8b 55 08             	mov    0x8(%ebp),%edx
80104768:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010476b:	f6 c2 03             	test   $0x3,%dl
8010476e:	75 05                	jne    80104775 <memset+0x15>
80104770:	f6 c1 03             	test   $0x3,%cl
80104773:	74 13                	je     80104788 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104775:	89 d7                	mov    %edx,%edi
80104777:	8b 45 0c             	mov    0xc(%ebp),%eax
8010477a:	fc                   	cld    
8010477b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010477d:	5b                   	pop    %ebx
8010477e:	89 d0                	mov    %edx,%eax
80104780:	5f                   	pop    %edi
80104781:	5d                   	pop    %ebp
80104782:	c3                   	ret    
80104783:	90                   	nop
80104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104788:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010478c:	c1 e9 02             	shr    $0x2,%ecx
8010478f:	89 f8                	mov    %edi,%eax
80104791:	89 fb                	mov    %edi,%ebx
80104793:	c1 e0 18             	shl    $0x18,%eax
80104796:	c1 e3 10             	shl    $0x10,%ebx
80104799:	09 d8                	or     %ebx,%eax
8010479b:	09 f8                	or     %edi,%eax
8010479d:	c1 e7 08             	shl    $0x8,%edi
801047a0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047a2:	89 d7                	mov    %edx,%edi
801047a4:	fc                   	cld    
801047a5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801047a7:	5b                   	pop    %ebx
801047a8:	89 d0                	mov    %edx,%eax
801047aa:	5f                   	pop    %edi
801047ab:	5d                   	pop    %ebp
801047ac:	c3                   	ret    
801047ad:	8d 76 00             	lea    0x0(%esi),%esi

801047b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	57                   	push   %edi
801047b4:	56                   	push   %esi
801047b5:	53                   	push   %ebx
801047b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801047b9:	8b 75 08             	mov    0x8(%ebp),%esi
801047bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047bf:	85 db                	test   %ebx,%ebx
801047c1:	74 29                	je     801047ec <memcmp+0x3c>
    if(*s1 != *s2)
801047c3:	0f b6 16             	movzbl (%esi),%edx
801047c6:	0f b6 0f             	movzbl (%edi),%ecx
801047c9:	38 d1                	cmp    %dl,%cl
801047cb:	75 2b                	jne    801047f8 <memcmp+0x48>
801047cd:	b8 01 00 00 00       	mov    $0x1,%eax
801047d2:	eb 14                	jmp    801047e8 <memcmp+0x38>
801047d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047d8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801047dc:	83 c0 01             	add    $0x1,%eax
801047df:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801047e4:	38 ca                	cmp    %cl,%dl
801047e6:	75 10                	jne    801047f8 <memcmp+0x48>
  while(n-- > 0){
801047e8:	39 d8                	cmp    %ebx,%eax
801047ea:	75 ec                	jne    801047d8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801047ec:	5b                   	pop    %ebx
  return 0;
801047ed:	31 c0                	xor    %eax,%eax
}
801047ef:	5e                   	pop    %esi
801047f0:	5f                   	pop    %edi
801047f1:	5d                   	pop    %ebp
801047f2:	c3                   	ret    
801047f3:	90                   	nop
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801047f8:	0f b6 c2             	movzbl %dl,%eax
}
801047fb:	5b                   	pop    %ebx
      return *s1 - *s2;
801047fc:	29 c8                	sub    %ecx,%eax
}
801047fe:	5e                   	pop    %esi
801047ff:	5f                   	pop    %edi
80104800:	5d                   	pop    %ebp
80104801:	c3                   	ret    
80104802:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104810 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
80104815:	8b 45 08             	mov    0x8(%ebp),%eax
80104818:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010481b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010481e:	39 c3                	cmp    %eax,%ebx
80104820:	73 26                	jae    80104848 <memmove+0x38>
80104822:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104825:	39 c8                	cmp    %ecx,%eax
80104827:	73 1f                	jae    80104848 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104829:	85 f6                	test   %esi,%esi
8010482b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010482e:	74 0f                	je     8010483f <memmove+0x2f>
      *--d = *--s;
80104830:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104834:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104837:	83 ea 01             	sub    $0x1,%edx
8010483a:	83 fa ff             	cmp    $0xffffffff,%edx
8010483d:	75 f1                	jne    80104830 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010483f:	5b                   	pop    %ebx
80104840:	5e                   	pop    %esi
80104841:	5d                   	pop    %ebp
80104842:	c3                   	ret    
80104843:	90                   	nop
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104848:	31 d2                	xor    %edx,%edx
8010484a:	85 f6                	test   %esi,%esi
8010484c:	74 f1                	je     8010483f <memmove+0x2f>
8010484e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104850:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104854:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104857:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010485a:	39 d6                	cmp    %edx,%esi
8010485c:	75 f2                	jne    80104850 <memmove+0x40>
}
8010485e:	5b                   	pop    %ebx
8010485f:	5e                   	pop    %esi
80104860:	5d                   	pop    %ebp
80104861:	c3                   	ret    
80104862:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104873:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104874:	eb 9a                	jmp    80104810 <memmove>
80104876:	8d 76 00             	lea    0x0(%esi),%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104880 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	57                   	push   %edi
80104884:	56                   	push   %esi
80104885:	8b 7d 10             	mov    0x10(%ebp),%edi
80104888:	53                   	push   %ebx
80104889:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010488c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010488f:	85 ff                	test   %edi,%edi
80104891:	74 2f                	je     801048c2 <strncmp+0x42>
80104893:	0f b6 01             	movzbl (%ecx),%eax
80104896:	0f b6 1e             	movzbl (%esi),%ebx
80104899:	84 c0                	test   %al,%al
8010489b:	74 37                	je     801048d4 <strncmp+0x54>
8010489d:	38 c3                	cmp    %al,%bl
8010489f:	75 33                	jne    801048d4 <strncmp+0x54>
801048a1:	01 f7                	add    %esi,%edi
801048a3:	eb 13                	jmp    801048b8 <strncmp+0x38>
801048a5:	8d 76 00             	lea    0x0(%esi),%esi
801048a8:	0f b6 01             	movzbl (%ecx),%eax
801048ab:	84 c0                	test   %al,%al
801048ad:	74 21                	je     801048d0 <strncmp+0x50>
801048af:	0f b6 1a             	movzbl (%edx),%ebx
801048b2:	89 d6                	mov    %edx,%esi
801048b4:	38 d8                	cmp    %bl,%al
801048b6:	75 1c                	jne    801048d4 <strncmp+0x54>
    n--, p++, q++;
801048b8:	8d 56 01             	lea    0x1(%esi),%edx
801048bb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048be:	39 fa                	cmp    %edi,%edx
801048c0:	75 e6                	jne    801048a8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801048c2:	5b                   	pop    %ebx
    return 0;
801048c3:	31 c0                	xor    %eax,%eax
}
801048c5:	5e                   	pop    %esi
801048c6:	5f                   	pop    %edi
801048c7:	5d                   	pop    %ebp
801048c8:	c3                   	ret    
801048c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048d0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801048d4:	29 d8                	sub    %ebx,%eax
}
801048d6:	5b                   	pop    %ebx
801048d7:	5e                   	pop    %esi
801048d8:	5f                   	pop    %edi
801048d9:	5d                   	pop    %ebp
801048da:	c3                   	ret    
801048db:	90                   	nop
801048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048e0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	8b 45 08             	mov    0x8(%ebp),%eax
801048e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801048eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801048ee:	89 c2                	mov    %eax,%edx
801048f0:	eb 19                	jmp    8010490b <strncpy+0x2b>
801048f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048f8:	83 c3 01             	add    $0x1,%ebx
801048fb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801048ff:	83 c2 01             	add    $0x1,%edx
80104902:	84 c9                	test   %cl,%cl
80104904:	88 4a ff             	mov    %cl,-0x1(%edx)
80104907:	74 09                	je     80104912 <strncpy+0x32>
80104909:	89 f1                	mov    %esi,%ecx
8010490b:	85 c9                	test   %ecx,%ecx
8010490d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104910:	7f e6                	jg     801048f8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104912:	31 c9                	xor    %ecx,%ecx
80104914:	85 f6                	test   %esi,%esi
80104916:	7e 17                	jle    8010492f <strncpy+0x4f>
80104918:	90                   	nop
80104919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104920:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104924:	89 f3                	mov    %esi,%ebx
80104926:	83 c1 01             	add    $0x1,%ecx
80104929:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010492b:	85 db                	test   %ebx,%ebx
8010492d:	7f f1                	jg     80104920 <strncpy+0x40>
  return os;
}
8010492f:	5b                   	pop    %ebx
80104930:	5e                   	pop    %esi
80104931:	5d                   	pop    %ebp
80104932:	c3                   	ret    
80104933:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104940 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104948:	8b 45 08             	mov    0x8(%ebp),%eax
8010494b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010494e:	85 c9                	test   %ecx,%ecx
80104950:	7e 26                	jle    80104978 <safestrcpy+0x38>
80104952:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104956:	89 c1                	mov    %eax,%ecx
80104958:	eb 17                	jmp    80104971 <safestrcpy+0x31>
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104960:	83 c2 01             	add    $0x1,%edx
80104963:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104967:	83 c1 01             	add    $0x1,%ecx
8010496a:	84 db                	test   %bl,%bl
8010496c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010496f:	74 04                	je     80104975 <safestrcpy+0x35>
80104971:	39 f2                	cmp    %esi,%edx
80104973:	75 eb                	jne    80104960 <safestrcpy+0x20>
    ;
  *s = 0;
80104975:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104978:	5b                   	pop    %ebx
80104979:	5e                   	pop    %esi
8010497a:	5d                   	pop    %ebp
8010497b:	c3                   	ret    
8010497c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104980 <strlen>:

int
strlen(const char *s)
{
80104980:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104981:	31 c0                	xor    %eax,%eax
{
80104983:	89 e5                	mov    %esp,%ebp
80104985:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104988:	80 3a 00             	cmpb   $0x0,(%edx)
8010498b:	74 0c                	je     80104999 <strlen+0x19>
8010498d:	8d 76 00             	lea    0x0(%esi),%esi
80104990:	83 c0 01             	add    $0x1,%eax
80104993:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104997:	75 f7                	jne    80104990 <strlen+0x10>
    ;
  return n;
}
80104999:	5d                   	pop    %ebp
8010499a:	c3                   	ret    

8010499b <swtch>:
8010499b:	8b 44 24 04          	mov    0x4(%esp),%eax
8010499f:	8b 54 24 08          	mov    0x8(%esp),%edx
801049a3:	55                   	push   %ebp
801049a4:	53                   	push   %ebx
801049a5:	56                   	push   %esi
801049a6:	57                   	push   %edi
801049a7:	89 20                	mov    %esp,(%eax)
801049a9:	89 d4                	mov    %edx,%esp
801049ab:	5f                   	pop    %edi
801049ac:	5e                   	pop    %esi
801049ad:	5b                   	pop    %ebx
801049ae:	5d                   	pop    %ebp
801049af:	c3                   	ret    

801049b0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	53                   	push   %ebx
801049b4:	83 ec 04             	sub    $0x4,%esp
801049b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049ba:	e8 31 f1 ff ff       	call   80103af0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049bf:	8b 00                	mov    (%eax),%eax
801049c1:	39 d8                	cmp    %ebx,%eax
801049c3:	76 1b                	jbe    801049e0 <fetchint+0x30>
801049c5:	8d 53 04             	lea    0x4(%ebx),%edx
801049c8:	39 d0                	cmp    %edx,%eax
801049ca:	72 14                	jb     801049e0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049cf:	8b 13                	mov    (%ebx),%edx
801049d1:	89 10                	mov    %edx,(%eax)
  return 0;
801049d3:	31 c0                	xor    %eax,%eax
}
801049d5:	83 c4 04             	add    $0x4,%esp
801049d8:	5b                   	pop    %ebx
801049d9:	5d                   	pop    %ebp
801049da:	c3                   	ret    
801049db:	90                   	nop
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049e5:	eb ee                	jmp    801049d5 <fetchint+0x25>
801049e7:	89 f6                	mov    %esi,%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	53                   	push   %ebx
801049f4:	83 ec 04             	sub    $0x4,%esp
801049f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801049fa:	e8 f1 f0 ff ff       	call   80103af0 <myproc>

  if(addr >= curproc->sz)
801049ff:	39 18                	cmp    %ebx,(%eax)
80104a01:	76 29                	jbe    80104a2c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104a03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104a06:	89 da                	mov    %ebx,%edx
80104a08:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104a0a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104a0c:	39 c3                	cmp    %eax,%ebx
80104a0e:	73 1c                	jae    80104a2c <fetchstr+0x3c>
    if(*s == 0)
80104a10:	80 3b 00             	cmpb   $0x0,(%ebx)
80104a13:	75 10                	jne    80104a25 <fetchstr+0x35>
80104a15:	eb 39                	jmp    80104a50 <fetchstr+0x60>
80104a17:	89 f6                	mov    %esi,%esi
80104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104a20:	80 3a 00             	cmpb   $0x0,(%edx)
80104a23:	74 1b                	je     80104a40 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104a25:	83 c2 01             	add    $0x1,%edx
80104a28:	39 d0                	cmp    %edx,%eax
80104a2a:	77 f4                	ja     80104a20 <fetchstr+0x30>
    return -1;
80104a2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104a31:	83 c4 04             	add    $0x4,%esp
80104a34:	5b                   	pop    %ebx
80104a35:	5d                   	pop    %ebp
80104a36:	c3                   	ret    
80104a37:	89 f6                	mov    %esi,%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104a40:	83 c4 04             	add    $0x4,%esp
80104a43:	89 d0                	mov    %edx,%eax
80104a45:	29 d8                	sub    %ebx,%eax
80104a47:	5b                   	pop    %ebx
80104a48:	5d                   	pop    %ebp
80104a49:	c3                   	ret    
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104a50:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104a52:	eb dd                	jmp    80104a31 <fetchstr+0x41>
80104a54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a60 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a65:	e8 86 f0 ff ff       	call   80103af0 <myproc>
80104a6a:	8b 40 18             	mov    0x18(%eax),%eax
80104a6d:	8b 55 08             	mov    0x8(%ebp),%edx
80104a70:	8b 40 44             	mov    0x44(%eax),%eax
80104a73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a76:	e8 75 f0 ff ff       	call   80103af0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a7b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a7d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a80:	39 c6                	cmp    %eax,%esi
80104a82:	73 1c                	jae    80104aa0 <argint+0x40>
80104a84:	8d 53 08             	lea    0x8(%ebx),%edx
80104a87:	39 d0                	cmp    %edx,%eax
80104a89:	72 15                	jb     80104aa0 <argint+0x40>
  *ip = *(int*)(addr);
80104a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a8e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a91:	89 10                	mov    %edx,(%eax)
  return 0;
80104a93:	31 c0                	xor    %eax,%eax
}
80104a95:	5b                   	pop    %ebx
80104a96:	5e                   	pop    %esi
80104a97:	5d                   	pop    %ebp
80104a98:	c3                   	ret    
80104a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104aa5:	eb ee                	jmp    80104a95 <argint+0x35>
80104aa7:	89 f6                	mov    %esi,%esi
80104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ab0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	56                   	push   %esi
80104ab4:	53                   	push   %ebx
80104ab5:	83 ec 10             	sub    $0x10,%esp
80104ab8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104abb:	e8 30 f0 ff ff       	call   80103af0 <myproc>
80104ac0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ac2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ac5:	83 ec 08             	sub    $0x8,%esp
80104ac8:	50                   	push   %eax
80104ac9:	ff 75 08             	pushl  0x8(%ebp)
80104acc:	e8 8f ff ff ff       	call   80104a60 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ad1:	83 c4 10             	add    $0x10,%esp
80104ad4:	85 c0                	test   %eax,%eax
80104ad6:	78 28                	js     80104b00 <argptr+0x50>
80104ad8:	85 db                	test   %ebx,%ebx
80104ada:	78 24                	js     80104b00 <argptr+0x50>
80104adc:	8b 16                	mov    (%esi),%edx
80104ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae1:	39 c2                	cmp    %eax,%edx
80104ae3:	76 1b                	jbe    80104b00 <argptr+0x50>
80104ae5:	01 c3                	add    %eax,%ebx
80104ae7:	39 da                	cmp    %ebx,%edx
80104ae9:	72 15                	jb     80104b00 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104aee:	89 02                	mov    %eax,(%edx)
  return 0;
80104af0:	31 c0                	xor    %eax,%eax
}
80104af2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104af5:	5b                   	pop    %ebx
80104af6:	5e                   	pop    %esi
80104af7:	5d                   	pop    %ebp
80104af8:	c3                   	ret    
80104af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b05:	eb eb                	jmp    80104af2 <argptr+0x42>
80104b07:	89 f6                	mov    %esi,%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104b16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b19:	50                   	push   %eax
80104b1a:	ff 75 08             	pushl  0x8(%ebp)
80104b1d:	e8 3e ff ff ff       	call   80104a60 <argint>
80104b22:	83 c4 10             	add    $0x10,%esp
80104b25:	85 c0                	test   %eax,%eax
80104b27:	78 17                	js     80104b40 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104b29:	83 ec 08             	sub    $0x8,%esp
80104b2c:	ff 75 0c             	pushl  0xc(%ebp)
80104b2f:	ff 75 f4             	pushl  -0xc(%ebp)
80104b32:	e8 b9 fe ff ff       	call   801049f0 <fetchstr>
80104b37:	83 c4 10             	add    $0x10,%esp
}
80104b3a:	c9                   	leave  
80104b3b:	c3                   	ret    
80104b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b45:	c9                   	leave  
80104b46:	c3                   	ret    
80104b47:	89 f6                	mov    %esi,%esi
80104b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b50 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	53                   	push   %ebx
80104b54:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b57:	e8 94 ef ff ff       	call   80103af0 <myproc>
80104b5c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b5e:	8b 40 18             	mov    0x18(%eax),%eax
80104b61:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b64:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b67:	83 fa 14             	cmp    $0x14,%edx
80104b6a:	77 1c                	ja     80104b88 <syscall+0x38>
80104b6c:	8b 14 85 a0 78 10 80 	mov    -0x7fef8760(,%eax,4),%edx
80104b73:	85 d2                	test   %edx,%edx
80104b75:	74 11                	je     80104b88 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104b77:	ff d2                	call   *%edx
80104b79:	8b 53 18             	mov    0x18(%ebx),%edx
80104b7c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b82:	c9                   	leave  
80104b83:	c3                   	ret    
80104b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b88:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b89:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b8c:	50                   	push   %eax
80104b8d:	ff 73 10             	pushl  0x10(%ebx)
80104b90:	68 71 78 10 80       	push   $0x80107871
80104b95:	e8 c6 ba ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104b9a:	8b 43 18             	mov    0x18(%ebx),%eax
80104b9d:	83 c4 10             	add    $0x10,%esp
80104ba0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104ba7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104baa:	c9                   	leave  
80104bab:	c3                   	ret    
80104bac:	66 90                	xchg   %ax,%ax
80104bae:	66 90                	xchg   %ax,%ax

80104bb0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	57                   	push   %edi
80104bb4:	56                   	push   %esi
80104bb5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104bb6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104bb9:	83 ec 44             	sub    $0x44,%esp
80104bbc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104bbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104bc2:	56                   	push   %esi
80104bc3:	50                   	push   %eax
{
80104bc4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104bc7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104bca:	e8 41 d6 ff ff       	call   80102210 <nameiparent>
80104bcf:	83 c4 10             	add    $0x10,%esp
80104bd2:	85 c0                	test   %eax,%eax
80104bd4:	0f 84 46 01 00 00    	je     80104d20 <create+0x170>
    return 0;
  ilock(dp);
80104bda:	83 ec 0c             	sub    $0xc,%esp
80104bdd:	89 c3                	mov    %eax,%ebx
80104bdf:	50                   	push   %eax
80104be0:	e8 ab cd ff ff       	call   80101990 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104be5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104be8:	83 c4 0c             	add    $0xc,%esp
80104beb:	50                   	push   %eax
80104bec:	56                   	push   %esi
80104bed:	53                   	push   %ebx
80104bee:	e8 cd d2 ff ff       	call   80101ec0 <dirlookup>
80104bf3:	83 c4 10             	add    $0x10,%esp
80104bf6:	85 c0                	test   %eax,%eax
80104bf8:	89 c7                	mov    %eax,%edi
80104bfa:	74 34                	je     80104c30 <create+0x80>
    iunlockput(dp);
80104bfc:	83 ec 0c             	sub    $0xc,%esp
80104bff:	53                   	push   %ebx
80104c00:	e8 1b d0 ff ff       	call   80101c20 <iunlockput>
    ilock(ip);
80104c05:	89 3c 24             	mov    %edi,(%esp)
80104c08:	e8 83 cd ff ff       	call   80101990 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c0d:	83 c4 10             	add    $0x10,%esp
80104c10:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104c15:	0f 85 95 00 00 00    	jne    80104cb0 <create+0x100>
80104c1b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104c20:	0f 85 8a 00 00 00    	jne    80104cb0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c29:	89 f8                	mov    %edi,%eax
80104c2b:	5b                   	pop    %ebx
80104c2c:	5e                   	pop    %esi
80104c2d:	5f                   	pop    %edi
80104c2e:	5d                   	pop    %ebp
80104c2f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104c30:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104c34:	83 ec 08             	sub    $0x8,%esp
80104c37:	50                   	push   %eax
80104c38:	ff 33                	pushl  (%ebx)
80104c3a:	e8 e1 cb ff ff       	call   80101820 <ialloc>
80104c3f:	83 c4 10             	add    $0x10,%esp
80104c42:	85 c0                	test   %eax,%eax
80104c44:	89 c7                	mov    %eax,%edi
80104c46:	0f 84 e8 00 00 00    	je     80104d34 <create+0x184>
  ilock(ip);
80104c4c:	83 ec 0c             	sub    $0xc,%esp
80104c4f:	50                   	push   %eax
80104c50:	e8 3b cd ff ff       	call   80101990 <ilock>
  ip->major = major;
80104c55:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104c59:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104c5d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104c61:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104c65:	b8 01 00 00 00       	mov    $0x1,%eax
80104c6a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104c6e:	89 3c 24             	mov    %edi,(%esp)
80104c71:	e8 6a cc ff ff       	call   801018e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c76:	83 c4 10             	add    $0x10,%esp
80104c79:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104c7e:	74 50                	je     80104cd0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c80:	83 ec 04             	sub    $0x4,%esp
80104c83:	ff 77 04             	pushl  0x4(%edi)
80104c86:	56                   	push   %esi
80104c87:	53                   	push   %ebx
80104c88:	e8 a3 d4 ff ff       	call   80102130 <dirlink>
80104c8d:	83 c4 10             	add    $0x10,%esp
80104c90:	85 c0                	test   %eax,%eax
80104c92:	0f 88 8f 00 00 00    	js     80104d27 <create+0x177>
  iunlockput(dp);
80104c98:	83 ec 0c             	sub    $0xc,%esp
80104c9b:	53                   	push   %ebx
80104c9c:	e8 7f cf ff ff       	call   80101c20 <iunlockput>
  return ip;
80104ca1:	83 c4 10             	add    $0x10,%esp
}
80104ca4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ca7:	89 f8                	mov    %edi,%eax
80104ca9:	5b                   	pop    %ebx
80104caa:	5e                   	pop    %esi
80104cab:	5f                   	pop    %edi
80104cac:	5d                   	pop    %ebp
80104cad:	c3                   	ret    
80104cae:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104cb0:	83 ec 0c             	sub    $0xc,%esp
80104cb3:	57                   	push   %edi
    return 0;
80104cb4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104cb6:	e8 65 cf ff ff       	call   80101c20 <iunlockput>
    return 0;
80104cbb:	83 c4 10             	add    $0x10,%esp
}
80104cbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cc1:	89 f8                	mov    %edi,%eax
80104cc3:	5b                   	pop    %ebx
80104cc4:	5e                   	pop    %esi
80104cc5:	5f                   	pop    %edi
80104cc6:	5d                   	pop    %ebp
80104cc7:	c3                   	ret    
80104cc8:	90                   	nop
80104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104cd0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104cd5:	83 ec 0c             	sub    $0xc,%esp
80104cd8:	53                   	push   %ebx
80104cd9:	e8 02 cc ff ff       	call   801018e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104cde:	83 c4 0c             	add    $0xc,%esp
80104ce1:	ff 77 04             	pushl  0x4(%edi)
80104ce4:	68 14 79 10 80       	push   $0x80107914
80104ce9:	57                   	push   %edi
80104cea:	e8 41 d4 ff ff       	call   80102130 <dirlink>
80104cef:	83 c4 10             	add    $0x10,%esp
80104cf2:	85 c0                	test   %eax,%eax
80104cf4:	78 1c                	js     80104d12 <create+0x162>
80104cf6:	83 ec 04             	sub    $0x4,%esp
80104cf9:	ff 73 04             	pushl  0x4(%ebx)
80104cfc:	68 13 79 10 80       	push   $0x80107913
80104d01:	57                   	push   %edi
80104d02:	e8 29 d4 ff ff       	call   80102130 <dirlink>
80104d07:	83 c4 10             	add    $0x10,%esp
80104d0a:	85 c0                	test   %eax,%eax
80104d0c:	0f 89 6e ff ff ff    	jns    80104c80 <create+0xd0>
      panic("create dots");
80104d12:	83 ec 0c             	sub    $0xc,%esp
80104d15:	68 07 79 10 80       	push   $0x80107907
80104d1a:	e8 71 b6 ff ff       	call   80100390 <panic>
80104d1f:	90                   	nop
    return 0;
80104d20:	31 ff                	xor    %edi,%edi
80104d22:	e9 ff fe ff ff       	jmp    80104c26 <create+0x76>
    panic("create: dirlink");
80104d27:	83 ec 0c             	sub    $0xc,%esp
80104d2a:	68 16 79 10 80       	push   $0x80107916
80104d2f:	e8 5c b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104d34:	83 ec 0c             	sub    $0xc,%esp
80104d37:	68 f8 78 10 80       	push   $0x801078f8
80104d3c:	e8 4f b6 ff ff       	call   80100390 <panic>
80104d41:	eb 0d                	jmp    80104d50 <argfd.constprop.0>
80104d43:	90                   	nop
80104d44:	90                   	nop
80104d45:	90                   	nop
80104d46:	90                   	nop
80104d47:	90                   	nop
80104d48:	90                   	nop
80104d49:	90                   	nop
80104d4a:	90                   	nop
80104d4b:	90                   	nop
80104d4c:	90                   	nop
80104d4d:	90                   	nop
80104d4e:	90                   	nop
80104d4f:	90                   	nop

80104d50 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
80104d55:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104d57:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d5a:	89 d6                	mov    %edx,%esi
80104d5c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d5f:	50                   	push   %eax
80104d60:	6a 00                	push   $0x0
80104d62:	e8 f9 fc ff ff       	call   80104a60 <argint>
80104d67:	83 c4 10             	add    $0x10,%esp
80104d6a:	85 c0                	test   %eax,%eax
80104d6c:	78 2a                	js     80104d98 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d6e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d72:	77 24                	ja     80104d98 <argfd.constprop.0+0x48>
80104d74:	e8 77 ed ff ff       	call   80103af0 <myproc>
80104d79:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d7c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104d80:	85 c0                	test   %eax,%eax
80104d82:	74 14                	je     80104d98 <argfd.constprop.0+0x48>
  if(pfd)
80104d84:	85 db                	test   %ebx,%ebx
80104d86:	74 02                	je     80104d8a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104d88:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104d8a:	89 06                	mov    %eax,(%esi)
  return 0;
80104d8c:	31 c0                	xor    %eax,%eax
}
80104d8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d91:	5b                   	pop    %ebx
80104d92:	5e                   	pop    %esi
80104d93:	5d                   	pop    %ebp
80104d94:	c3                   	ret    
80104d95:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d9d:	eb ef                	jmp    80104d8e <argfd.constprop.0+0x3e>
80104d9f:	90                   	nop

80104da0 <sys_dup>:
{
80104da0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104da1:	31 c0                	xor    %eax,%eax
{
80104da3:	89 e5                	mov    %esp,%ebp
80104da5:	56                   	push   %esi
80104da6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104da7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104daa:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104dad:	e8 9e ff ff ff       	call   80104d50 <argfd.constprop.0>
80104db2:	85 c0                	test   %eax,%eax
80104db4:	78 42                	js     80104df8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104db6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104db9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104dbb:	e8 30 ed ff ff       	call   80103af0 <myproc>
80104dc0:	eb 0e                	jmp    80104dd0 <sys_dup+0x30>
80104dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104dc8:	83 c3 01             	add    $0x1,%ebx
80104dcb:	83 fb 10             	cmp    $0x10,%ebx
80104dce:	74 28                	je     80104df8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104dd0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104dd4:	85 d2                	test   %edx,%edx
80104dd6:	75 f0                	jne    80104dc8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104dd8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ddc:	83 ec 0c             	sub    $0xc,%esp
80104ddf:	ff 75 f4             	pushl  -0xc(%ebp)
80104de2:	e8 09 c3 ff ff       	call   801010f0 <filedup>
  return fd;
80104de7:	83 c4 10             	add    $0x10,%esp
}
80104dea:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ded:	89 d8                	mov    %ebx,%eax
80104def:	5b                   	pop    %ebx
80104df0:	5e                   	pop    %esi
80104df1:	5d                   	pop    %ebp
80104df2:	c3                   	ret    
80104df3:	90                   	nop
80104df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104df8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104dfb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e00:	89 d8                	mov    %ebx,%eax
80104e02:	5b                   	pop    %ebx
80104e03:	5e                   	pop    %esi
80104e04:	5d                   	pop    %ebp
80104e05:	c3                   	ret    
80104e06:	8d 76 00             	lea    0x0(%esi),%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <sys_read>:
{
80104e10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e11:	31 c0                	xor    %eax,%eax
{
80104e13:	89 e5                	mov    %esp,%ebp
80104e15:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e1b:	e8 30 ff ff ff       	call   80104d50 <argfd.constprop.0>
80104e20:	85 c0                	test   %eax,%eax
80104e22:	78 4c                	js     80104e70 <sys_read+0x60>
80104e24:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e27:	83 ec 08             	sub    $0x8,%esp
80104e2a:	50                   	push   %eax
80104e2b:	6a 02                	push   $0x2
80104e2d:	e8 2e fc ff ff       	call   80104a60 <argint>
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	85 c0                	test   %eax,%eax
80104e37:	78 37                	js     80104e70 <sys_read+0x60>
80104e39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e3c:	83 ec 04             	sub    $0x4,%esp
80104e3f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e42:	50                   	push   %eax
80104e43:	6a 01                	push   $0x1
80104e45:	e8 66 fc ff ff       	call   80104ab0 <argptr>
80104e4a:	83 c4 10             	add    $0x10,%esp
80104e4d:	85 c0                	test   %eax,%eax
80104e4f:	78 1f                	js     80104e70 <sys_read+0x60>
  return fileread(f, p, n);
80104e51:	83 ec 04             	sub    $0x4,%esp
80104e54:	ff 75 f0             	pushl  -0x10(%ebp)
80104e57:	ff 75 f4             	pushl  -0xc(%ebp)
80104e5a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e5d:	e8 fe c3 ff ff       	call   80101260 <fileread>
80104e62:	83 c4 10             	add    $0x10,%esp
}
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e75:	c9                   	leave  
80104e76:	c3                   	ret    
80104e77:	89 f6                	mov    %esi,%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e80 <sys_write>:
{
80104e80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e81:	31 c0                	xor    %eax,%eax
{
80104e83:	89 e5                	mov    %esp,%ebp
80104e85:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e88:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e8b:	e8 c0 fe ff ff       	call   80104d50 <argfd.constprop.0>
80104e90:	85 c0                	test   %eax,%eax
80104e92:	78 4c                	js     80104ee0 <sys_write+0x60>
80104e94:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e97:	83 ec 08             	sub    $0x8,%esp
80104e9a:	50                   	push   %eax
80104e9b:	6a 02                	push   $0x2
80104e9d:	e8 be fb ff ff       	call   80104a60 <argint>
80104ea2:	83 c4 10             	add    $0x10,%esp
80104ea5:	85 c0                	test   %eax,%eax
80104ea7:	78 37                	js     80104ee0 <sys_write+0x60>
80104ea9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eac:	83 ec 04             	sub    $0x4,%esp
80104eaf:	ff 75 f0             	pushl  -0x10(%ebp)
80104eb2:	50                   	push   %eax
80104eb3:	6a 01                	push   $0x1
80104eb5:	e8 f6 fb ff ff       	call   80104ab0 <argptr>
80104eba:	83 c4 10             	add    $0x10,%esp
80104ebd:	85 c0                	test   %eax,%eax
80104ebf:	78 1f                	js     80104ee0 <sys_write+0x60>
  return filewrite(f, p, n);
80104ec1:	83 ec 04             	sub    $0x4,%esp
80104ec4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ec7:	ff 75 f4             	pushl  -0xc(%ebp)
80104eca:	ff 75 ec             	pushl  -0x14(%ebp)
80104ecd:	e8 1e c4 ff ff       	call   801012f0 <filewrite>
80104ed2:	83 c4 10             	add    $0x10,%esp
}
80104ed5:	c9                   	leave  
80104ed6:	c3                   	ret    
80104ed7:	89 f6                	mov    %esi,%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ee5:	c9                   	leave  
80104ee6:	c3                   	ret    
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ef0 <sys_close>:
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104ef6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ef9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104efc:	e8 4f fe ff ff       	call   80104d50 <argfd.constprop.0>
80104f01:	85 c0                	test   %eax,%eax
80104f03:	78 2b                	js     80104f30 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104f05:	e8 e6 eb ff ff       	call   80103af0 <myproc>
80104f0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104f0d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f10:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104f17:	00 
  fileclose(f);
80104f18:	ff 75 f4             	pushl  -0xc(%ebp)
80104f1b:	e8 20 c2 ff ff       	call   80101140 <fileclose>
  return 0;
80104f20:	83 c4 10             	add    $0x10,%esp
80104f23:	31 c0                	xor    %eax,%eax
}
80104f25:	c9                   	leave  
80104f26:	c3                   	ret    
80104f27:	89 f6                	mov    %esi,%esi
80104f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f35:	c9                   	leave  
80104f36:	c3                   	ret    
80104f37:	89 f6                	mov    %esi,%esi
80104f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f40 <sys_fstat>:
{
80104f40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f41:	31 c0                	xor    %eax,%eax
{
80104f43:	89 e5                	mov    %esp,%ebp
80104f45:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f48:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f4b:	e8 00 fe ff ff       	call   80104d50 <argfd.constprop.0>
80104f50:	85 c0                	test   %eax,%eax
80104f52:	78 2c                	js     80104f80 <sys_fstat+0x40>
80104f54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f57:	83 ec 04             	sub    $0x4,%esp
80104f5a:	6a 14                	push   $0x14
80104f5c:	50                   	push   %eax
80104f5d:	6a 01                	push   $0x1
80104f5f:	e8 4c fb ff ff       	call   80104ab0 <argptr>
80104f64:	83 c4 10             	add    $0x10,%esp
80104f67:	85 c0                	test   %eax,%eax
80104f69:	78 15                	js     80104f80 <sys_fstat+0x40>
  return filestat(f, st);
80104f6b:	83 ec 08             	sub    $0x8,%esp
80104f6e:	ff 75 f4             	pushl  -0xc(%ebp)
80104f71:	ff 75 f0             	pushl  -0x10(%ebp)
80104f74:	e8 97 c2 ff ff       	call   80101210 <filestat>
80104f79:	83 c4 10             	add    $0x10,%esp
}
80104f7c:	c9                   	leave  
80104f7d:	c3                   	ret    
80104f7e:	66 90                	xchg   %ax,%ax
    return -1;
80104f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f85:	c9                   	leave  
80104f86:	c3                   	ret    
80104f87:	89 f6                	mov    %esi,%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f90 <sys_link>:
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	57                   	push   %edi
80104f94:	56                   	push   %esi
80104f95:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f96:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f99:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f9c:	50                   	push   %eax
80104f9d:	6a 00                	push   $0x0
80104f9f:	e8 6c fb ff ff       	call   80104b10 <argstr>
80104fa4:	83 c4 10             	add    $0x10,%esp
80104fa7:	85 c0                	test   %eax,%eax
80104fa9:	0f 88 fb 00 00 00    	js     801050aa <sys_link+0x11a>
80104faf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104fb2:	83 ec 08             	sub    $0x8,%esp
80104fb5:	50                   	push   %eax
80104fb6:	6a 01                	push   $0x1
80104fb8:	e8 53 fb ff ff       	call   80104b10 <argstr>
80104fbd:	83 c4 10             	add    $0x10,%esp
80104fc0:	85 c0                	test   %eax,%eax
80104fc2:	0f 88 e2 00 00 00    	js     801050aa <sys_link+0x11a>
  begin_op();
80104fc8:	e8 e3 de ff ff       	call   80102eb0 <begin_op>
  if((ip = namei(old)) == 0){
80104fcd:	83 ec 0c             	sub    $0xc,%esp
80104fd0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104fd3:	e8 18 d2 ff ff       	call   801021f0 <namei>
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	85 c0                	test   %eax,%eax
80104fdd:	89 c3                	mov    %eax,%ebx
80104fdf:	0f 84 ea 00 00 00    	je     801050cf <sys_link+0x13f>
  ilock(ip);
80104fe5:	83 ec 0c             	sub    $0xc,%esp
80104fe8:	50                   	push   %eax
80104fe9:	e8 a2 c9 ff ff       	call   80101990 <ilock>
  if(ip->type == T_DIR){
80104fee:	83 c4 10             	add    $0x10,%esp
80104ff1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ff6:	0f 84 bb 00 00 00    	je     801050b7 <sys_link+0x127>
  ip->nlink++;
80104ffc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105001:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105004:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105007:	53                   	push   %ebx
80105008:	e8 d3 c8 ff ff       	call   801018e0 <iupdate>
  iunlock(ip);
8010500d:	89 1c 24             	mov    %ebx,(%esp)
80105010:	e8 5b ca ff ff       	call   80101a70 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105015:	58                   	pop    %eax
80105016:	5a                   	pop    %edx
80105017:	57                   	push   %edi
80105018:	ff 75 d0             	pushl  -0x30(%ebp)
8010501b:	e8 f0 d1 ff ff       	call   80102210 <nameiparent>
80105020:	83 c4 10             	add    $0x10,%esp
80105023:	85 c0                	test   %eax,%eax
80105025:	89 c6                	mov    %eax,%esi
80105027:	74 5b                	je     80105084 <sys_link+0xf4>
  ilock(dp);
80105029:	83 ec 0c             	sub    $0xc,%esp
8010502c:	50                   	push   %eax
8010502d:	e8 5e c9 ff ff       	call   80101990 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105032:	83 c4 10             	add    $0x10,%esp
80105035:	8b 03                	mov    (%ebx),%eax
80105037:	39 06                	cmp    %eax,(%esi)
80105039:	75 3d                	jne    80105078 <sys_link+0xe8>
8010503b:	83 ec 04             	sub    $0x4,%esp
8010503e:	ff 73 04             	pushl  0x4(%ebx)
80105041:	57                   	push   %edi
80105042:	56                   	push   %esi
80105043:	e8 e8 d0 ff ff       	call   80102130 <dirlink>
80105048:	83 c4 10             	add    $0x10,%esp
8010504b:	85 c0                	test   %eax,%eax
8010504d:	78 29                	js     80105078 <sys_link+0xe8>
  iunlockput(dp);
8010504f:	83 ec 0c             	sub    $0xc,%esp
80105052:	56                   	push   %esi
80105053:	e8 c8 cb ff ff       	call   80101c20 <iunlockput>
  iput(ip);
80105058:	89 1c 24             	mov    %ebx,(%esp)
8010505b:	e8 60 ca ff ff       	call   80101ac0 <iput>
  end_op();
80105060:	e8 bb de ff ff       	call   80102f20 <end_op>
  return 0;
80105065:	83 c4 10             	add    $0x10,%esp
80105068:	31 c0                	xor    %eax,%eax
}
8010506a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010506d:	5b                   	pop    %ebx
8010506e:	5e                   	pop    %esi
8010506f:	5f                   	pop    %edi
80105070:	5d                   	pop    %ebp
80105071:	c3                   	ret    
80105072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105078:	83 ec 0c             	sub    $0xc,%esp
8010507b:	56                   	push   %esi
8010507c:	e8 9f cb ff ff       	call   80101c20 <iunlockput>
    goto bad;
80105081:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	53                   	push   %ebx
80105088:	e8 03 c9 ff ff       	call   80101990 <ilock>
  ip->nlink--;
8010508d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105092:	89 1c 24             	mov    %ebx,(%esp)
80105095:	e8 46 c8 ff ff       	call   801018e0 <iupdate>
  iunlockput(ip);
8010509a:	89 1c 24             	mov    %ebx,(%esp)
8010509d:	e8 7e cb ff ff       	call   80101c20 <iunlockput>
  end_op();
801050a2:	e8 79 de ff ff       	call   80102f20 <end_op>
  return -1;
801050a7:	83 c4 10             	add    $0x10,%esp
}
801050aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801050ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050b2:	5b                   	pop    %ebx
801050b3:	5e                   	pop    %esi
801050b4:	5f                   	pop    %edi
801050b5:	5d                   	pop    %ebp
801050b6:	c3                   	ret    
    iunlockput(ip);
801050b7:	83 ec 0c             	sub    $0xc,%esp
801050ba:	53                   	push   %ebx
801050bb:	e8 60 cb ff ff       	call   80101c20 <iunlockput>
    end_op();
801050c0:	e8 5b de ff ff       	call   80102f20 <end_op>
    return -1;
801050c5:	83 c4 10             	add    $0x10,%esp
801050c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050cd:	eb 9b                	jmp    8010506a <sys_link+0xda>
    end_op();
801050cf:	e8 4c de ff ff       	call   80102f20 <end_op>
    return -1;
801050d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d9:	eb 8f                	jmp    8010506a <sys_link+0xda>
801050db:	90                   	nop
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050e0 <sys_unlink>:
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	57                   	push   %edi
801050e4:	56                   	push   %esi
801050e5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801050e6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801050e9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801050ec:	50                   	push   %eax
801050ed:	6a 00                	push   $0x0
801050ef:	e8 1c fa ff ff       	call   80104b10 <argstr>
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	85 c0                	test   %eax,%eax
801050f9:	0f 88 77 01 00 00    	js     80105276 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801050ff:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105102:	e8 a9 dd ff ff       	call   80102eb0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105107:	83 ec 08             	sub    $0x8,%esp
8010510a:	53                   	push   %ebx
8010510b:	ff 75 c0             	pushl  -0x40(%ebp)
8010510e:	e8 fd d0 ff ff       	call   80102210 <nameiparent>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	89 c6                	mov    %eax,%esi
8010511a:	0f 84 60 01 00 00    	je     80105280 <sys_unlink+0x1a0>
  ilock(dp);
80105120:	83 ec 0c             	sub    $0xc,%esp
80105123:	50                   	push   %eax
80105124:	e8 67 c8 ff ff       	call   80101990 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105129:	58                   	pop    %eax
8010512a:	5a                   	pop    %edx
8010512b:	68 14 79 10 80       	push   $0x80107914
80105130:	53                   	push   %ebx
80105131:	e8 6a cd ff ff       	call   80101ea0 <namecmp>
80105136:	83 c4 10             	add    $0x10,%esp
80105139:	85 c0                	test   %eax,%eax
8010513b:	0f 84 03 01 00 00    	je     80105244 <sys_unlink+0x164>
80105141:	83 ec 08             	sub    $0x8,%esp
80105144:	68 13 79 10 80       	push   $0x80107913
80105149:	53                   	push   %ebx
8010514a:	e8 51 cd ff ff       	call   80101ea0 <namecmp>
8010514f:	83 c4 10             	add    $0x10,%esp
80105152:	85 c0                	test   %eax,%eax
80105154:	0f 84 ea 00 00 00    	je     80105244 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010515a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010515d:	83 ec 04             	sub    $0x4,%esp
80105160:	50                   	push   %eax
80105161:	53                   	push   %ebx
80105162:	56                   	push   %esi
80105163:	e8 58 cd ff ff       	call   80101ec0 <dirlookup>
80105168:	83 c4 10             	add    $0x10,%esp
8010516b:	85 c0                	test   %eax,%eax
8010516d:	89 c3                	mov    %eax,%ebx
8010516f:	0f 84 cf 00 00 00    	je     80105244 <sys_unlink+0x164>
  ilock(ip);
80105175:	83 ec 0c             	sub    $0xc,%esp
80105178:	50                   	push   %eax
80105179:	e8 12 c8 ff ff       	call   80101990 <ilock>
  if(ip->nlink < 1)
8010517e:	83 c4 10             	add    $0x10,%esp
80105181:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105186:	0f 8e 10 01 00 00    	jle    8010529c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010518c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105191:	74 6d                	je     80105200 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105193:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105196:	83 ec 04             	sub    $0x4,%esp
80105199:	6a 10                	push   $0x10
8010519b:	6a 00                	push   $0x0
8010519d:	50                   	push   %eax
8010519e:	e8 bd f5 ff ff       	call   80104760 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051a3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801051a6:	6a 10                	push   $0x10
801051a8:	ff 75 c4             	pushl  -0x3c(%ebp)
801051ab:	50                   	push   %eax
801051ac:	56                   	push   %esi
801051ad:	e8 be cb ff ff       	call   80101d70 <writei>
801051b2:	83 c4 20             	add    $0x20,%esp
801051b5:	83 f8 10             	cmp    $0x10,%eax
801051b8:	0f 85 eb 00 00 00    	jne    801052a9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801051be:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051c3:	0f 84 97 00 00 00    	je     80105260 <sys_unlink+0x180>
  iunlockput(dp);
801051c9:	83 ec 0c             	sub    $0xc,%esp
801051cc:	56                   	push   %esi
801051cd:	e8 4e ca ff ff       	call   80101c20 <iunlockput>
  ip->nlink--;
801051d2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051d7:	89 1c 24             	mov    %ebx,(%esp)
801051da:	e8 01 c7 ff ff       	call   801018e0 <iupdate>
  iunlockput(ip);
801051df:	89 1c 24             	mov    %ebx,(%esp)
801051e2:	e8 39 ca ff ff       	call   80101c20 <iunlockput>
  end_op();
801051e7:	e8 34 dd ff ff       	call   80102f20 <end_op>
  return 0;
801051ec:	83 c4 10             	add    $0x10,%esp
801051ef:	31 c0                	xor    %eax,%eax
}
801051f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051f4:	5b                   	pop    %ebx
801051f5:	5e                   	pop    %esi
801051f6:	5f                   	pop    %edi
801051f7:	5d                   	pop    %ebp
801051f8:	c3                   	ret    
801051f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105200:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105204:	76 8d                	jbe    80105193 <sys_unlink+0xb3>
80105206:	bf 20 00 00 00       	mov    $0x20,%edi
8010520b:	eb 0f                	jmp    8010521c <sys_unlink+0x13c>
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
80105210:	83 c7 10             	add    $0x10,%edi
80105213:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105216:	0f 83 77 ff ff ff    	jae    80105193 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010521c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010521f:	6a 10                	push   $0x10
80105221:	57                   	push   %edi
80105222:	50                   	push   %eax
80105223:	53                   	push   %ebx
80105224:	e8 47 ca ff ff       	call   80101c70 <readi>
80105229:	83 c4 10             	add    $0x10,%esp
8010522c:	83 f8 10             	cmp    $0x10,%eax
8010522f:	75 5e                	jne    8010528f <sys_unlink+0x1af>
    if(de.inum != 0)
80105231:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105236:	74 d8                	je     80105210 <sys_unlink+0x130>
    iunlockput(ip);
80105238:	83 ec 0c             	sub    $0xc,%esp
8010523b:	53                   	push   %ebx
8010523c:	e8 df c9 ff ff       	call   80101c20 <iunlockput>
    goto bad;
80105241:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105244:	83 ec 0c             	sub    $0xc,%esp
80105247:	56                   	push   %esi
80105248:	e8 d3 c9 ff ff       	call   80101c20 <iunlockput>
  end_op();
8010524d:	e8 ce dc ff ff       	call   80102f20 <end_op>
  return -1;
80105252:	83 c4 10             	add    $0x10,%esp
80105255:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525a:	eb 95                	jmp    801051f1 <sys_unlink+0x111>
8010525c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105260:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105265:	83 ec 0c             	sub    $0xc,%esp
80105268:	56                   	push   %esi
80105269:	e8 72 c6 ff ff       	call   801018e0 <iupdate>
8010526e:	83 c4 10             	add    $0x10,%esp
80105271:	e9 53 ff ff ff       	jmp    801051c9 <sys_unlink+0xe9>
    return -1;
80105276:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527b:	e9 71 ff ff ff       	jmp    801051f1 <sys_unlink+0x111>
    end_op();
80105280:	e8 9b dc ff ff       	call   80102f20 <end_op>
    return -1;
80105285:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528a:	e9 62 ff ff ff       	jmp    801051f1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010528f:	83 ec 0c             	sub    $0xc,%esp
80105292:	68 38 79 10 80       	push   $0x80107938
80105297:	e8 f4 b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010529c:	83 ec 0c             	sub    $0xc,%esp
8010529f:	68 26 79 10 80       	push   $0x80107926
801052a4:	e8 e7 b0 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	68 4a 79 10 80       	push   $0x8010794a
801052b1:	e8 da b0 ff ff       	call   80100390 <panic>
801052b6:	8d 76 00             	lea    0x0(%esi),%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <sys_open>:

int
sys_open(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
801052c5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801052c9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052cc:	50                   	push   %eax
801052cd:	6a 00                	push   $0x0
801052cf:	e8 3c f8 ff ff       	call   80104b10 <argstr>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	0f 88 1d 01 00 00    	js     801053fc <sys_open+0x13c>
801052df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052e2:	83 ec 08             	sub    $0x8,%esp
801052e5:	50                   	push   %eax
801052e6:	6a 01                	push   $0x1
801052e8:	e8 73 f7 ff ff       	call   80104a60 <argint>
801052ed:	83 c4 10             	add    $0x10,%esp
801052f0:	85 c0                	test   %eax,%eax
801052f2:	0f 88 04 01 00 00    	js     801053fc <sys_open+0x13c>
    return -1;

  begin_op();
801052f8:	e8 b3 db ff ff       	call   80102eb0 <begin_op>

  if(omode & O_CREATE){
801052fd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105301:	0f 85 a9 00 00 00    	jne    801053b0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105307:	83 ec 0c             	sub    $0xc,%esp
8010530a:	ff 75 e0             	pushl  -0x20(%ebp)
8010530d:	e8 de ce ff ff       	call   801021f0 <namei>
80105312:	83 c4 10             	add    $0x10,%esp
80105315:	85 c0                	test   %eax,%eax
80105317:	89 c6                	mov    %eax,%esi
80105319:	0f 84 b2 00 00 00    	je     801053d1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010531f:	83 ec 0c             	sub    $0xc,%esp
80105322:	50                   	push   %eax
80105323:	e8 68 c6 ff ff       	call   80101990 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105328:	83 c4 10             	add    $0x10,%esp
8010532b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105330:	0f 84 aa 00 00 00    	je     801053e0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105336:	e8 45 bd ff ff       	call   80101080 <filealloc>
8010533b:	85 c0                	test   %eax,%eax
8010533d:	89 c7                	mov    %eax,%edi
8010533f:	0f 84 a6 00 00 00    	je     801053eb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105345:	e8 a6 e7 ff ff       	call   80103af0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010534a:	31 db                	xor    %ebx,%ebx
8010534c:	eb 0e                	jmp    8010535c <sys_open+0x9c>
8010534e:	66 90                	xchg   %ax,%ax
80105350:	83 c3 01             	add    $0x1,%ebx
80105353:	83 fb 10             	cmp    $0x10,%ebx
80105356:	0f 84 ac 00 00 00    	je     80105408 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010535c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105360:	85 d2                	test   %edx,%edx
80105362:	75 ec                	jne    80105350 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105364:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105367:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010536b:	56                   	push   %esi
8010536c:	e8 ff c6 ff ff       	call   80101a70 <iunlock>
  end_op();
80105371:	e8 aa db ff ff       	call   80102f20 <end_op>

  f->type = FD_INODE;
80105376:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010537c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010537f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105382:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105385:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010538c:	89 d0                	mov    %edx,%eax
8010538e:	f7 d0                	not    %eax
80105390:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105393:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105396:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105399:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010539d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053a0:	89 d8                	mov    %ebx,%eax
801053a2:	5b                   	pop    %ebx
801053a3:	5e                   	pop    %esi
801053a4:	5f                   	pop    %edi
801053a5:	5d                   	pop    %ebp
801053a6:	c3                   	ret    
801053a7:	89 f6                	mov    %esi,%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053b6:	31 c9                	xor    %ecx,%ecx
801053b8:	6a 00                	push   $0x0
801053ba:	ba 02 00 00 00       	mov    $0x2,%edx
801053bf:	e8 ec f7 ff ff       	call   80104bb0 <create>
    if(ip == 0){
801053c4:	83 c4 10             	add    $0x10,%esp
801053c7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801053c9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801053cb:	0f 85 65 ff ff ff    	jne    80105336 <sys_open+0x76>
      end_op();
801053d1:	e8 4a db ff ff       	call   80102f20 <end_op>
      return -1;
801053d6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053db:	eb c0                	jmp    8010539d <sys_open+0xdd>
801053dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801053e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801053e3:	85 c9                	test   %ecx,%ecx
801053e5:	0f 84 4b ff ff ff    	je     80105336 <sys_open+0x76>
    iunlockput(ip);
801053eb:	83 ec 0c             	sub    $0xc,%esp
801053ee:	56                   	push   %esi
801053ef:	e8 2c c8 ff ff       	call   80101c20 <iunlockput>
    end_op();
801053f4:	e8 27 db ff ff       	call   80102f20 <end_op>
    return -1;
801053f9:	83 c4 10             	add    $0x10,%esp
801053fc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105401:	eb 9a                	jmp    8010539d <sys_open+0xdd>
80105403:	90                   	nop
80105404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105408:	83 ec 0c             	sub    $0xc,%esp
8010540b:	57                   	push   %edi
8010540c:	e8 2f bd ff ff       	call   80101140 <fileclose>
80105411:	83 c4 10             	add    $0x10,%esp
80105414:	eb d5                	jmp    801053eb <sys_open+0x12b>
80105416:	8d 76 00             	lea    0x0(%esi),%esi
80105419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105420 <sys_mkdir>:

int
sys_mkdir(void)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105426:	e8 85 da ff ff       	call   80102eb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010542b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010542e:	83 ec 08             	sub    $0x8,%esp
80105431:	50                   	push   %eax
80105432:	6a 00                	push   $0x0
80105434:	e8 d7 f6 ff ff       	call   80104b10 <argstr>
80105439:	83 c4 10             	add    $0x10,%esp
8010543c:	85 c0                	test   %eax,%eax
8010543e:	78 30                	js     80105470 <sys_mkdir+0x50>
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105446:	31 c9                	xor    %ecx,%ecx
80105448:	6a 00                	push   $0x0
8010544a:	ba 01 00 00 00       	mov    $0x1,%edx
8010544f:	e8 5c f7 ff ff       	call   80104bb0 <create>
80105454:	83 c4 10             	add    $0x10,%esp
80105457:	85 c0                	test   %eax,%eax
80105459:	74 15                	je     80105470 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010545b:	83 ec 0c             	sub    $0xc,%esp
8010545e:	50                   	push   %eax
8010545f:	e8 bc c7 ff ff       	call   80101c20 <iunlockput>
  end_op();
80105464:	e8 b7 da ff ff       	call   80102f20 <end_op>
  return 0;
80105469:	83 c4 10             	add    $0x10,%esp
8010546c:	31 c0                	xor    %eax,%eax
}
8010546e:	c9                   	leave  
8010546f:	c3                   	ret    
    end_op();
80105470:	e8 ab da ff ff       	call   80102f20 <end_op>
    return -1;
80105475:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010547a:	c9                   	leave  
8010547b:	c3                   	ret    
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105480 <sys_mknod>:

int
sys_mknod(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105486:	e8 25 da ff ff       	call   80102eb0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010548b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010548e:	83 ec 08             	sub    $0x8,%esp
80105491:	50                   	push   %eax
80105492:	6a 00                	push   $0x0
80105494:	e8 77 f6 ff ff       	call   80104b10 <argstr>
80105499:	83 c4 10             	add    $0x10,%esp
8010549c:	85 c0                	test   %eax,%eax
8010549e:	78 60                	js     80105500 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801054a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054a3:	83 ec 08             	sub    $0x8,%esp
801054a6:	50                   	push   %eax
801054a7:	6a 01                	push   $0x1
801054a9:	e8 b2 f5 ff ff       	call   80104a60 <argint>
  if((argstr(0, &path)) < 0 ||
801054ae:	83 c4 10             	add    $0x10,%esp
801054b1:	85 c0                	test   %eax,%eax
801054b3:	78 4b                	js     80105500 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801054b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054b8:	83 ec 08             	sub    $0x8,%esp
801054bb:	50                   	push   %eax
801054bc:	6a 02                	push   $0x2
801054be:	e8 9d f5 ff ff       	call   80104a60 <argint>
     argint(1, &major) < 0 ||
801054c3:	83 c4 10             	add    $0x10,%esp
801054c6:	85 c0                	test   %eax,%eax
801054c8:	78 36                	js     80105500 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801054ce:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801054d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801054d5:	ba 03 00 00 00       	mov    $0x3,%edx
801054da:	50                   	push   %eax
801054db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054de:	e8 cd f6 ff ff       	call   80104bb0 <create>
801054e3:	83 c4 10             	add    $0x10,%esp
801054e6:	85 c0                	test   %eax,%eax
801054e8:	74 16                	je     80105500 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054ea:	83 ec 0c             	sub    $0xc,%esp
801054ed:	50                   	push   %eax
801054ee:	e8 2d c7 ff ff       	call   80101c20 <iunlockput>
  end_op();
801054f3:	e8 28 da ff ff       	call   80102f20 <end_op>
  return 0;
801054f8:	83 c4 10             	add    $0x10,%esp
801054fb:	31 c0                	xor    %eax,%eax
}
801054fd:	c9                   	leave  
801054fe:	c3                   	ret    
801054ff:	90                   	nop
    end_op();
80105500:	e8 1b da ff ff       	call   80102f20 <end_op>
    return -1;
80105505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010550a:	c9                   	leave  
8010550b:	c3                   	ret    
8010550c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105510 <sys_chdir>:

int
sys_chdir(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	56                   	push   %esi
80105514:	53                   	push   %ebx
80105515:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105518:	e8 d3 e5 ff ff       	call   80103af0 <myproc>
8010551d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010551f:	e8 8c d9 ff ff       	call   80102eb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105524:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105527:	83 ec 08             	sub    $0x8,%esp
8010552a:	50                   	push   %eax
8010552b:	6a 00                	push   $0x0
8010552d:	e8 de f5 ff ff       	call   80104b10 <argstr>
80105532:	83 c4 10             	add    $0x10,%esp
80105535:	85 c0                	test   %eax,%eax
80105537:	78 77                	js     801055b0 <sys_chdir+0xa0>
80105539:	83 ec 0c             	sub    $0xc,%esp
8010553c:	ff 75 f4             	pushl  -0xc(%ebp)
8010553f:	e8 ac cc ff ff       	call   801021f0 <namei>
80105544:	83 c4 10             	add    $0x10,%esp
80105547:	85 c0                	test   %eax,%eax
80105549:	89 c3                	mov    %eax,%ebx
8010554b:	74 63                	je     801055b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010554d:	83 ec 0c             	sub    $0xc,%esp
80105550:	50                   	push   %eax
80105551:	e8 3a c4 ff ff       	call   80101990 <ilock>
  if(ip->type != T_DIR){
80105556:	83 c4 10             	add    $0x10,%esp
80105559:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010555e:	75 30                	jne    80105590 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105560:	83 ec 0c             	sub    $0xc,%esp
80105563:	53                   	push   %ebx
80105564:	e8 07 c5 ff ff       	call   80101a70 <iunlock>
  iput(curproc->cwd);
80105569:	58                   	pop    %eax
8010556a:	ff 76 68             	pushl  0x68(%esi)
8010556d:	e8 4e c5 ff ff       	call   80101ac0 <iput>
  end_op();
80105572:	e8 a9 d9 ff ff       	call   80102f20 <end_op>
  curproc->cwd = ip;
80105577:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010557a:	83 c4 10             	add    $0x10,%esp
8010557d:	31 c0                	xor    %eax,%eax
}
8010557f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105582:	5b                   	pop    %ebx
80105583:	5e                   	pop    %esi
80105584:	5d                   	pop    %ebp
80105585:	c3                   	ret    
80105586:	8d 76 00             	lea    0x0(%esi),%esi
80105589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105590:	83 ec 0c             	sub    $0xc,%esp
80105593:	53                   	push   %ebx
80105594:	e8 87 c6 ff ff       	call   80101c20 <iunlockput>
    end_op();
80105599:	e8 82 d9 ff ff       	call   80102f20 <end_op>
    return -1;
8010559e:	83 c4 10             	add    $0x10,%esp
801055a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055a6:	eb d7                	jmp    8010557f <sys_chdir+0x6f>
801055a8:	90                   	nop
801055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801055b0:	e8 6b d9 ff ff       	call   80102f20 <end_op>
    return -1;
801055b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ba:	eb c3                	jmp    8010557f <sys_chdir+0x6f>
801055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055c0 <sys_exec>:

int
sys_exec(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	57                   	push   %edi
801055c4:	56                   	push   %esi
801055c5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055c6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801055cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055d2:	50                   	push   %eax
801055d3:	6a 00                	push   $0x0
801055d5:	e8 36 f5 ff ff       	call   80104b10 <argstr>
801055da:	83 c4 10             	add    $0x10,%esp
801055dd:	85 c0                	test   %eax,%eax
801055df:	0f 88 87 00 00 00    	js     8010566c <sys_exec+0xac>
801055e5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801055eb:	83 ec 08             	sub    $0x8,%esp
801055ee:	50                   	push   %eax
801055ef:	6a 01                	push   $0x1
801055f1:	e8 6a f4 ff ff       	call   80104a60 <argint>
801055f6:	83 c4 10             	add    $0x10,%esp
801055f9:	85 c0                	test   %eax,%eax
801055fb:	78 6f                	js     8010566c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801055fd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105603:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105606:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105608:	68 80 00 00 00       	push   $0x80
8010560d:	6a 00                	push   $0x0
8010560f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105615:	50                   	push   %eax
80105616:	e8 45 f1 ff ff       	call   80104760 <memset>
8010561b:	83 c4 10             	add    $0x10,%esp
8010561e:	eb 2c                	jmp    8010564c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105620:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105626:	85 c0                	test   %eax,%eax
80105628:	74 56                	je     80105680 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010562a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105630:	83 ec 08             	sub    $0x8,%esp
80105633:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105636:	52                   	push   %edx
80105637:	50                   	push   %eax
80105638:	e8 b3 f3 ff ff       	call   801049f0 <fetchstr>
8010563d:	83 c4 10             	add    $0x10,%esp
80105640:	85 c0                	test   %eax,%eax
80105642:	78 28                	js     8010566c <sys_exec+0xac>
  for(i=0;; i++){
80105644:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105647:	83 fb 20             	cmp    $0x20,%ebx
8010564a:	74 20                	je     8010566c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010564c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105652:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105659:	83 ec 08             	sub    $0x8,%esp
8010565c:	57                   	push   %edi
8010565d:	01 f0                	add    %esi,%eax
8010565f:	50                   	push   %eax
80105660:	e8 4b f3 ff ff       	call   801049b0 <fetchint>
80105665:	83 c4 10             	add    $0x10,%esp
80105668:	85 c0                	test   %eax,%eax
8010566a:	79 b4                	jns    80105620 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010566c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010566f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105674:	5b                   	pop    %ebx
80105675:	5e                   	pop    %esi
80105676:	5f                   	pop    %edi
80105677:	5d                   	pop    %ebp
80105678:	c3                   	ret    
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105680:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105686:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105689:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105690:	00 00 00 00 
  return exec(path, argv);
80105694:	50                   	push   %eax
80105695:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010569b:	e8 70 b6 ff ff       	call   80100d10 <exec>
801056a0:	83 c4 10             	add    $0x10,%esp
}
801056a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056a6:	5b                   	pop    %ebx
801056a7:	5e                   	pop    %esi
801056a8:	5f                   	pop    %edi
801056a9:	5d                   	pop    %ebp
801056aa:	c3                   	ret    
801056ab:	90                   	nop
801056ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056b0 <sys_pipe>:

int
sys_pipe(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
801056b5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056b6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801056b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056bc:	6a 08                	push   $0x8
801056be:	50                   	push   %eax
801056bf:	6a 00                	push   $0x0
801056c1:	e8 ea f3 ff ff       	call   80104ab0 <argptr>
801056c6:	83 c4 10             	add    $0x10,%esp
801056c9:	85 c0                	test   %eax,%eax
801056cb:	0f 88 ae 00 00 00    	js     8010577f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801056d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056d4:	83 ec 08             	sub    $0x8,%esp
801056d7:	50                   	push   %eax
801056d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801056db:	50                   	push   %eax
801056dc:	e8 6f de ff ff       	call   80103550 <pipealloc>
801056e1:	83 c4 10             	add    $0x10,%esp
801056e4:	85 c0                	test   %eax,%eax
801056e6:	0f 88 93 00 00 00    	js     8010577f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801056ef:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801056f1:	e8 fa e3 ff ff       	call   80103af0 <myproc>
801056f6:	eb 10                	jmp    80105708 <sys_pipe+0x58>
801056f8:	90                   	nop
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105700:	83 c3 01             	add    $0x1,%ebx
80105703:	83 fb 10             	cmp    $0x10,%ebx
80105706:	74 60                	je     80105768 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105708:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010570c:	85 f6                	test   %esi,%esi
8010570e:	75 f0                	jne    80105700 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105710:	8d 73 08             	lea    0x8(%ebx),%esi
80105713:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105717:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010571a:	e8 d1 e3 ff ff       	call   80103af0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010571f:	31 d2                	xor    %edx,%edx
80105721:	eb 0d                	jmp    80105730 <sys_pipe+0x80>
80105723:	90                   	nop
80105724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105728:	83 c2 01             	add    $0x1,%edx
8010572b:	83 fa 10             	cmp    $0x10,%edx
8010572e:	74 28                	je     80105758 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105730:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105734:	85 c9                	test   %ecx,%ecx
80105736:	75 f0                	jne    80105728 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105738:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010573c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010573f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105741:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105744:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105747:	31 c0                	xor    %eax,%eax
}
80105749:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010574c:	5b                   	pop    %ebx
8010574d:	5e                   	pop    %esi
8010574e:	5f                   	pop    %edi
8010574f:	5d                   	pop    %ebp
80105750:	c3                   	ret    
80105751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105758:	e8 93 e3 ff ff       	call   80103af0 <myproc>
8010575d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105764:	00 
80105765:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105768:	83 ec 0c             	sub    $0xc,%esp
8010576b:	ff 75 e0             	pushl  -0x20(%ebp)
8010576e:	e8 cd b9 ff ff       	call   80101140 <fileclose>
    fileclose(wf);
80105773:	58                   	pop    %eax
80105774:	ff 75 e4             	pushl  -0x1c(%ebp)
80105777:	e8 c4 b9 ff ff       	call   80101140 <fileclose>
    return -1;
8010577c:	83 c4 10             	add    $0x10,%esp
8010577f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105784:	eb c3                	jmp    80105749 <sys_pipe+0x99>
80105786:	66 90                	xchg   %ax,%ax
80105788:	66 90                	xchg   %ax,%ax
8010578a:	66 90                	xchg   %ax,%ax
8010578c:	66 90                	xchg   %ax,%ax
8010578e:	66 90                	xchg   %ax,%ax

80105790 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105793:	5d                   	pop    %ebp
  return fork();
80105794:	e9 f7 e4 ff ff       	jmp    80103c90 <fork>
80105799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057a0 <sys_exit>:

int
sys_exit(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801057a6:	e8 65 e7 ff ff       	call   80103f10 <exit>
  return 0;  // not reached
}
801057ab:	31 c0                	xor    %eax,%eax
801057ad:	c9                   	leave  
801057ae:	c3                   	ret    
801057af:	90                   	nop

801057b0 <sys_wait>:

int
sys_wait(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801057b3:	5d                   	pop    %ebp
  return wait();
801057b4:	e9 97 e9 ff ff       	jmp    80104150 <wait>
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_kill>:

int
sys_kill(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801057c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057c9:	50                   	push   %eax
801057ca:	6a 00                	push   $0x0
801057cc:	e8 8f f2 ff ff       	call   80104a60 <argint>
801057d1:	83 c4 10             	add    $0x10,%esp
801057d4:	85 c0                	test   %eax,%eax
801057d6:	78 18                	js     801057f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801057d8:	83 ec 0c             	sub    $0xc,%esp
801057db:	ff 75 f4             	pushl  -0xc(%ebp)
801057de:	e8 bd ea ff ff       	call   801042a0 <kill>
801057e3:	83 c4 10             	add    $0x10,%esp
}
801057e6:	c9                   	leave  
801057e7:	c3                   	ret    
801057e8:	90                   	nop
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057f5:	c9                   	leave  
801057f6:	c3                   	ret    
801057f7:	89 f6                	mov    %esi,%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105800 <sys_getpid>:

int
sys_getpid(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105806:	e8 e5 e2 ff ff       	call   80103af0 <myproc>
8010580b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010580e:	c9                   	leave  
8010580f:	c3                   	ret    

80105810 <sys_sbrk>:

int
sys_sbrk(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105814:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105817:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010581a:	50                   	push   %eax
8010581b:	6a 00                	push   $0x0
8010581d:	e8 3e f2 ff ff       	call   80104a60 <argint>
80105822:	83 c4 10             	add    $0x10,%esp
80105825:	85 c0                	test   %eax,%eax
80105827:	78 27                	js     80105850 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105829:	e8 c2 e2 ff ff       	call   80103af0 <myproc>
  if(growproc(n) < 0)
8010582e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105831:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105833:	ff 75 f4             	pushl  -0xc(%ebp)
80105836:	e8 d5 e3 ff ff       	call   80103c10 <growproc>
8010583b:	83 c4 10             	add    $0x10,%esp
8010583e:	85 c0                	test   %eax,%eax
80105840:	78 0e                	js     80105850 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105842:	89 d8                	mov    %ebx,%eax
80105844:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105847:	c9                   	leave  
80105848:	c3                   	ret    
80105849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105850:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105855:	eb eb                	jmp    80105842 <sys_sbrk+0x32>
80105857:	89 f6                	mov    %esi,%esi
80105859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105860 <sys_sleep>:

int
sys_sleep(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105864:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105867:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010586a:	50                   	push   %eax
8010586b:	6a 00                	push   $0x0
8010586d:	e8 ee f1 ff ff       	call   80104a60 <argint>
80105872:	83 c4 10             	add    $0x10,%esp
80105875:	85 c0                	test   %eax,%eax
80105877:	0f 88 8a 00 00 00    	js     80105907 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010587d:	83 ec 0c             	sub    $0xc,%esp
80105880:	68 20 4f 11 80       	push   $0x80114f20
80105885:	e8 c6 ed ff ff       	call   80104650 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010588a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010588d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105890:	8b 1d 60 57 11 80    	mov    0x80115760,%ebx
  while(ticks - ticks0 < n){
80105896:	85 d2                	test   %edx,%edx
80105898:	75 27                	jne    801058c1 <sys_sleep+0x61>
8010589a:	eb 54                	jmp    801058f0 <sys_sleep+0x90>
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801058a0:	83 ec 08             	sub    $0x8,%esp
801058a3:	68 20 4f 11 80       	push   $0x80114f20
801058a8:	68 60 57 11 80       	push   $0x80115760
801058ad:	e8 de e7 ff ff       	call   80104090 <sleep>
  while(ticks - ticks0 < n){
801058b2:	a1 60 57 11 80       	mov    0x80115760,%eax
801058b7:	83 c4 10             	add    $0x10,%esp
801058ba:	29 d8                	sub    %ebx,%eax
801058bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801058bf:	73 2f                	jae    801058f0 <sys_sleep+0x90>
    if(myproc()->killed){
801058c1:	e8 2a e2 ff ff       	call   80103af0 <myproc>
801058c6:	8b 40 24             	mov    0x24(%eax),%eax
801058c9:	85 c0                	test   %eax,%eax
801058cb:	74 d3                	je     801058a0 <sys_sleep+0x40>
      release(&tickslock);
801058cd:	83 ec 0c             	sub    $0xc,%esp
801058d0:	68 20 4f 11 80       	push   $0x80114f20
801058d5:	e8 36 ee ff ff       	call   80104710 <release>
      return -1;
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801058e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058e5:	c9                   	leave  
801058e6:	c3                   	ret    
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801058f0:	83 ec 0c             	sub    $0xc,%esp
801058f3:	68 20 4f 11 80       	push   $0x80114f20
801058f8:	e8 13 ee ff ff       	call   80104710 <release>
  return 0;
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	31 c0                	xor    %eax,%eax
}
80105902:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105905:	c9                   	leave  
80105906:	c3                   	ret    
    return -1;
80105907:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010590c:	eb f4                	jmp    80105902 <sys_sleep+0xa2>
8010590e:	66 90                	xchg   %ax,%ax

80105910 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	53                   	push   %ebx
80105914:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105917:	68 20 4f 11 80       	push   $0x80114f20
8010591c:	e8 2f ed ff ff       	call   80104650 <acquire>
  xticks = ticks;
80105921:	8b 1d 60 57 11 80    	mov    0x80115760,%ebx
  release(&tickslock);
80105927:	c7 04 24 20 4f 11 80 	movl   $0x80114f20,(%esp)
8010592e:	e8 dd ed ff ff       	call   80104710 <release>
  return xticks;
}
80105933:	89 d8                	mov    %ebx,%eax
80105935:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105938:	c9                   	leave  
80105939:	c3                   	ret    

8010593a <alltraps>:
8010593a:	1e                   	push   %ds
8010593b:	06                   	push   %es
8010593c:	0f a0                	push   %fs
8010593e:	0f a8                	push   %gs
80105940:	60                   	pusha  
80105941:	66 b8 10 00          	mov    $0x10,%ax
80105945:	8e d8                	mov    %eax,%ds
80105947:	8e c0                	mov    %eax,%es
80105949:	54                   	push   %esp
8010594a:	e8 c1 00 00 00       	call   80105a10 <trap>
8010594f:	83 c4 04             	add    $0x4,%esp

80105952 <trapret>:
80105952:	61                   	popa   
80105953:	0f a9                	pop    %gs
80105955:	0f a1                	pop    %fs
80105957:	07                   	pop    %es
80105958:	1f                   	pop    %ds
80105959:	83 c4 08             	add    $0x8,%esp
8010595c:	cf                   	iret   
8010595d:	66 90                	xchg   %ax,%ax
8010595f:	90                   	nop

80105960 <tvinit>:
80105960:	55                   	push   %ebp
80105961:	31 c0                	xor    %eax,%eax
80105963:	89 e5                	mov    %esp,%ebp
80105965:	83 ec 08             	sub    $0x8,%esp
80105968:	90                   	nop
80105969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105970:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105977:	c7 04 c5 62 4f 11 80 	movl   $0x8e000008,-0x7feeb09e(,%eax,8)
8010597e:	08 00 00 8e 
80105982:	66 89 14 c5 60 4f 11 	mov    %dx,-0x7feeb0a0(,%eax,8)
80105989:	80 
8010598a:	c1 ea 10             	shr    $0x10,%edx
8010598d:	66 89 14 c5 66 4f 11 	mov    %dx,-0x7feeb09a(,%eax,8)
80105994:	80 
80105995:	83 c0 01             	add    $0x1,%eax
80105998:	3d 00 01 00 00       	cmp    $0x100,%eax
8010599d:	75 d1                	jne    80105970 <tvinit+0x10>
8010599f:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801059a4:	83 ec 08             	sub    $0x8,%esp
801059a7:	c7 05 62 51 11 80 08 	movl   $0xef000008,0x80115162
801059ae:	00 00 ef 
801059b1:	68 59 79 10 80       	push   $0x80107959
801059b6:	68 20 4f 11 80       	push   $0x80114f20
801059bb:	66 a3 60 51 11 80    	mov    %ax,0x80115160
801059c1:	c1 e8 10             	shr    $0x10,%eax
801059c4:	66 a3 66 51 11 80    	mov    %ax,0x80115166
801059ca:	e8 41 eb ff ff       	call   80104510 <initlock>
801059cf:	83 c4 10             	add    $0x10,%esp
801059d2:	c9                   	leave  
801059d3:	c3                   	ret    
801059d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801059e0 <idtinit>:
801059e0:	55                   	push   %ebp
801059e1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801059e6:	89 e5                	mov    %esp,%ebp
801059e8:	83 ec 10             	sub    $0x10,%esp
801059eb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
801059ef:	b8 60 4f 11 80       	mov    $0x80114f60,%eax
801059f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801059f8:	c1 e8 10             	shr    $0x10,%eax
801059fb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
801059ff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a02:	0f 01 18             	lidtl  (%eax)
80105a05:	c9                   	leave  
80105a06:	c3                   	ret    
80105a07:	89 f6                	mov    %esi,%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a10 <trap>:
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	57                   	push   %edi
80105a14:	56                   	push   %esi
80105a15:	53                   	push   %ebx
80105a16:	83 ec 1c             	sub    $0x1c,%esp
80105a19:	8b 7d 08             	mov    0x8(%ebp),%edi
80105a1c:	8b 47 30             	mov    0x30(%edi),%eax
80105a1f:	83 f8 40             	cmp    $0x40,%eax
80105a22:	0f 84 f0 00 00 00    	je     80105b18 <trap+0x108>
80105a28:	83 e8 20             	sub    $0x20,%eax
80105a2b:	83 f8 1f             	cmp    $0x1f,%eax
80105a2e:	77 10                	ja     80105a40 <trap+0x30>
80105a30:	ff 24 85 00 7a 10 80 	jmp    *-0x7fef8600(,%eax,4)
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105a40:	e8 ab e0 ff ff       	call   80103af0 <myproc>
80105a45:	85 c0                	test   %eax,%eax
80105a47:	8b 5f 38             	mov    0x38(%edi),%ebx
80105a4a:	0f 84 14 02 00 00    	je     80105c64 <trap+0x254>
80105a50:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105a54:	0f 84 0a 02 00 00    	je     80105c64 <trap+0x254>
80105a5a:	0f 20 d1             	mov    %cr2,%ecx
80105a5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105a60:	e8 6b e0 ff ff       	call   80103ad0 <cpuid>
80105a65:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a68:	8b 47 34             	mov    0x34(%edi),%eax
80105a6b:	8b 77 30             	mov    0x30(%edi),%esi
80105a6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105a71:	e8 7a e0 ff ff       	call   80103af0 <myproc>
80105a76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a79:	e8 72 e0 ff ff       	call   80103af0 <myproc>
80105a7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a81:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a84:	51                   	push   %ecx
80105a85:	53                   	push   %ebx
80105a86:	52                   	push   %edx
80105a87:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105a8a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a8d:	56                   	push   %esi
80105a8e:	83 c2 6c             	add    $0x6c,%edx
80105a91:	52                   	push   %edx
80105a92:	ff 70 10             	pushl  0x10(%eax)
80105a95:	68 bc 79 10 80       	push   $0x801079bc
80105a9a:	e8 c1 ab ff ff       	call   80100660 <cprintf>
80105a9f:	83 c4 20             	add    $0x20,%esp
80105aa2:	e8 49 e0 ff ff       	call   80103af0 <myproc>
80105aa7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105aae:	e8 3d e0 ff ff       	call   80103af0 <myproc>
80105ab3:	85 c0                	test   %eax,%eax
80105ab5:	74 1d                	je     80105ad4 <trap+0xc4>
80105ab7:	e8 34 e0 ff ff       	call   80103af0 <myproc>
80105abc:	8b 50 24             	mov    0x24(%eax),%edx
80105abf:	85 d2                	test   %edx,%edx
80105ac1:	74 11                	je     80105ad4 <trap+0xc4>
80105ac3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ac7:	83 e0 03             	and    $0x3,%eax
80105aca:	66 83 f8 03          	cmp    $0x3,%ax
80105ace:	0f 84 4c 01 00 00    	je     80105c20 <trap+0x210>
80105ad4:	e8 17 e0 ff ff       	call   80103af0 <myproc>
80105ad9:	85 c0                	test   %eax,%eax
80105adb:	74 0b                	je     80105ae8 <trap+0xd8>
80105add:	e8 0e e0 ff ff       	call   80103af0 <myproc>
80105ae2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ae6:	74 68                	je     80105b50 <trap+0x140>
80105ae8:	e8 03 e0 ff ff       	call   80103af0 <myproc>
80105aed:	85 c0                	test   %eax,%eax
80105aef:	74 19                	je     80105b0a <trap+0xfa>
80105af1:	e8 fa df ff ff       	call   80103af0 <myproc>
80105af6:	8b 40 24             	mov    0x24(%eax),%eax
80105af9:	85 c0                	test   %eax,%eax
80105afb:	74 0d                	je     80105b0a <trap+0xfa>
80105afd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105b01:	83 e0 03             	and    $0x3,%eax
80105b04:	66 83 f8 03          	cmp    $0x3,%ax
80105b08:	74 37                	je     80105b41 <trap+0x131>
80105b0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b0d:	5b                   	pop    %ebx
80105b0e:	5e                   	pop    %esi
80105b0f:	5f                   	pop    %edi
80105b10:	5d                   	pop    %ebp
80105b11:	c3                   	ret    
80105b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b18:	e8 d3 df ff ff       	call   80103af0 <myproc>
80105b1d:	8b 58 24             	mov    0x24(%eax),%ebx
80105b20:	85 db                	test   %ebx,%ebx
80105b22:	0f 85 e8 00 00 00    	jne    80105c10 <trap+0x200>
80105b28:	e8 c3 df ff ff       	call   80103af0 <myproc>
80105b2d:	89 78 18             	mov    %edi,0x18(%eax)
80105b30:	e8 1b f0 ff ff       	call   80104b50 <syscall>
80105b35:	e8 b6 df ff ff       	call   80103af0 <myproc>
80105b3a:	8b 48 24             	mov    0x24(%eax),%ecx
80105b3d:	85 c9                	test   %ecx,%ecx
80105b3f:	74 c9                	je     80105b0a <trap+0xfa>
80105b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b44:	5b                   	pop    %ebx
80105b45:	5e                   	pop    %esi
80105b46:	5f                   	pop    %edi
80105b47:	5d                   	pop    %ebp
80105b48:	e9 c3 e3 ff ff       	jmp    80103f10 <exit>
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi
80105b50:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105b54:	75 92                	jne    80105ae8 <trap+0xd8>
80105b56:	e8 e5 e4 ff ff       	call   80104040 <yield>
80105b5b:	eb 8b                	jmp    80105ae8 <trap+0xd8>
80105b5d:	8d 76 00             	lea    0x0(%esi),%esi
80105b60:	e8 6b df ff ff       	call   80103ad0 <cpuid>
80105b65:	85 c0                	test   %eax,%eax
80105b67:	0f 84 c3 00 00 00    	je     80105c30 <trap+0x220>
80105b6d:	e8 ee ce ff ff       	call   80102a60 <lapiceoi>
80105b72:	e8 79 df ff ff       	call   80103af0 <myproc>
80105b77:	85 c0                	test   %eax,%eax
80105b79:	0f 85 38 ff ff ff    	jne    80105ab7 <trap+0xa7>
80105b7f:	e9 50 ff ff ff       	jmp    80105ad4 <trap+0xc4>
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b88:	e8 93 cd ff ff       	call   80102920 <kbdintr>
80105b8d:	e8 ce ce ff ff       	call   80102a60 <lapiceoi>
80105b92:	e8 59 df ff ff       	call   80103af0 <myproc>
80105b97:	85 c0                	test   %eax,%eax
80105b99:	0f 85 18 ff ff ff    	jne    80105ab7 <trap+0xa7>
80105b9f:	e9 30 ff ff ff       	jmp    80105ad4 <trap+0xc4>
80105ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ba8:	e8 53 02 00 00       	call   80105e00 <uartintr>
80105bad:	e8 ae ce ff ff       	call   80102a60 <lapiceoi>
80105bb2:	e8 39 df ff ff       	call   80103af0 <myproc>
80105bb7:	85 c0                	test   %eax,%eax
80105bb9:	0f 85 f8 fe ff ff    	jne    80105ab7 <trap+0xa7>
80105bbf:	e9 10 ff ff ff       	jmp    80105ad4 <trap+0xc4>
80105bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bc8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105bcc:	8b 77 38             	mov    0x38(%edi),%esi
80105bcf:	e8 fc de ff ff       	call   80103ad0 <cpuid>
80105bd4:	56                   	push   %esi
80105bd5:	53                   	push   %ebx
80105bd6:	50                   	push   %eax
80105bd7:	68 64 79 10 80       	push   $0x80107964
80105bdc:	e8 7f aa ff ff       	call   80100660 <cprintf>
80105be1:	e8 7a ce ff ff       	call   80102a60 <lapiceoi>
80105be6:	83 c4 10             	add    $0x10,%esp
80105be9:	e8 02 df ff ff       	call   80103af0 <myproc>
80105bee:	85 c0                	test   %eax,%eax
80105bf0:	0f 85 c1 fe ff ff    	jne    80105ab7 <trap+0xa7>
80105bf6:	e9 d9 fe ff ff       	jmp    80105ad4 <trap+0xc4>
80105bfb:	90                   	nop
80105bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c00:	e8 8b c7 ff ff       	call   80102390 <ideintr>
80105c05:	e9 63 ff ff ff       	jmp    80105b6d <trap+0x15d>
80105c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c10:	e8 fb e2 ff ff       	call   80103f10 <exit>
80105c15:	e9 0e ff ff ff       	jmp    80105b28 <trap+0x118>
80105c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c20:	e8 eb e2 ff ff       	call   80103f10 <exit>
80105c25:	e9 aa fe ff ff       	jmp    80105ad4 <trap+0xc4>
80105c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c30:	83 ec 0c             	sub    $0xc,%esp
80105c33:	68 20 4f 11 80       	push   $0x80114f20
80105c38:	e8 13 ea ff ff       	call   80104650 <acquire>
80105c3d:	c7 04 24 60 57 11 80 	movl   $0x80115760,(%esp)
80105c44:	83 05 60 57 11 80 01 	addl   $0x1,0x80115760
80105c4b:	e8 f0 e5 ff ff       	call   80104240 <wakeup>
80105c50:	c7 04 24 20 4f 11 80 	movl   $0x80114f20,(%esp)
80105c57:	e8 b4 ea ff ff       	call   80104710 <release>
80105c5c:	83 c4 10             	add    $0x10,%esp
80105c5f:	e9 09 ff ff ff       	jmp    80105b6d <trap+0x15d>
80105c64:	0f 20 d6             	mov    %cr2,%esi
80105c67:	e8 64 de ff ff       	call   80103ad0 <cpuid>
80105c6c:	83 ec 0c             	sub    $0xc,%esp
80105c6f:	56                   	push   %esi
80105c70:	53                   	push   %ebx
80105c71:	50                   	push   %eax
80105c72:	ff 77 30             	pushl  0x30(%edi)
80105c75:	68 88 79 10 80       	push   $0x80107988
80105c7a:	e8 e1 a9 ff ff       	call   80100660 <cprintf>
80105c7f:	83 c4 14             	add    $0x14,%esp
80105c82:	68 5e 79 10 80       	push   $0x8010795e
80105c87:	e8 04 a7 ff ff       	call   80100390 <panic>
80105c8c:	66 90                	xchg   %ax,%ax
80105c8e:	66 90                	xchg   %ax,%ax

80105c90 <uartgetc>:
80105c90:	a1 fc a5 10 80       	mov    0x8010a5fc,%eax
80105c95:	55                   	push   %ebp
80105c96:	89 e5                	mov    %esp,%ebp
80105c98:	85 c0                	test   %eax,%eax
80105c9a:	74 1c                	je     80105cb8 <uartgetc+0x28>
80105c9c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ca1:	ec                   	in     (%dx),%al
80105ca2:	a8 01                	test   $0x1,%al
80105ca4:	74 12                	je     80105cb8 <uartgetc+0x28>
80105ca6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cab:	ec                   	in     (%dx),%al
80105cac:	0f b6 c0             	movzbl %al,%eax
80105caf:	5d                   	pop    %ebp
80105cb0:	c3                   	ret    
80105cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cbd:	5d                   	pop    %ebp
80105cbe:	c3                   	ret    
80105cbf:	90                   	nop

80105cc0 <uartputc.part.0>:
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	57                   	push   %edi
80105cc4:	56                   	push   %esi
80105cc5:	53                   	push   %ebx
80105cc6:	89 c7                	mov    %eax,%edi
80105cc8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ccd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105cd2:	83 ec 0c             	sub    $0xc,%esp
80105cd5:	eb 1b                	jmp    80105cf2 <uartputc.part.0+0x32>
80105cd7:	89 f6                	mov    %esi,%esi
80105cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	6a 0a                	push   $0xa
80105ce5:	e8 96 cd ff ff       	call   80102a80 <microdelay>
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	83 eb 01             	sub    $0x1,%ebx
80105cf0:	74 07                	je     80105cf9 <uartputc.part.0+0x39>
80105cf2:	89 f2                	mov    %esi,%edx
80105cf4:	ec                   	in     (%dx),%al
80105cf5:	a8 20                	test   $0x20,%al
80105cf7:	74 e7                	je     80105ce0 <uartputc.part.0+0x20>
80105cf9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cfe:	89 f8                	mov    %edi,%eax
80105d00:	ee                   	out    %al,(%dx)
80105d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d04:	5b                   	pop    %ebx
80105d05:	5e                   	pop    %esi
80105d06:	5f                   	pop    %edi
80105d07:	5d                   	pop    %ebp
80105d08:	c3                   	ret    
80105d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d10 <uartinit>:
80105d10:	55                   	push   %ebp
80105d11:	31 c9                	xor    %ecx,%ecx
80105d13:	89 c8                	mov    %ecx,%eax
80105d15:	89 e5                	mov    %esp,%ebp
80105d17:	57                   	push   %edi
80105d18:	56                   	push   %esi
80105d19:	53                   	push   %ebx
80105d1a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105d1f:	89 da                	mov    %ebx,%edx
80105d21:	83 ec 0c             	sub    $0xc,%esp
80105d24:	ee                   	out    %al,(%dx)
80105d25:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105d2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d2f:	89 fa                	mov    %edi,%edx
80105d31:	ee                   	out    %al,(%dx)
80105d32:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d37:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d3c:	ee                   	out    %al,(%dx)
80105d3d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105d42:	89 c8                	mov    %ecx,%eax
80105d44:	89 f2                	mov    %esi,%edx
80105d46:	ee                   	out    %al,(%dx)
80105d47:	b8 03 00 00 00       	mov    $0x3,%eax
80105d4c:	89 fa                	mov    %edi,%edx
80105d4e:	ee                   	out    %al,(%dx)
80105d4f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d54:	89 c8                	mov    %ecx,%eax
80105d56:	ee                   	out    %al,(%dx)
80105d57:	b8 01 00 00 00       	mov    $0x1,%eax
80105d5c:	89 f2                	mov    %esi,%edx
80105d5e:	ee                   	out    %al,(%dx)
80105d5f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d64:	ec                   	in     (%dx),%al
80105d65:	3c ff                	cmp    $0xff,%al
80105d67:	74 5a                	je     80105dc3 <uartinit+0xb3>
80105d69:	c7 05 fc a5 10 80 01 	movl   $0x1,0x8010a5fc
80105d70:	00 00 00 
80105d73:	89 da                	mov    %ebx,%edx
80105d75:	ec                   	in     (%dx),%al
80105d76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d7b:	ec                   	in     (%dx),%al
80105d7c:	83 ec 08             	sub    $0x8,%esp
80105d7f:	bb 80 7a 10 80       	mov    $0x80107a80,%ebx
80105d84:	6a 00                	push   $0x0
80105d86:	6a 04                	push   $0x4
80105d88:	e8 53 c8 ff ff       	call   801025e0 <ioapicenable>
80105d8d:	83 c4 10             	add    $0x10,%esp
80105d90:	b8 78 00 00 00       	mov    $0x78,%eax
80105d95:	eb 13                	jmp    80105daa <uartinit+0x9a>
80105d97:	89 f6                	mov    %esi,%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105da0:	83 c3 01             	add    $0x1,%ebx
80105da3:	0f be 03             	movsbl (%ebx),%eax
80105da6:	84 c0                	test   %al,%al
80105da8:	74 19                	je     80105dc3 <uartinit+0xb3>
80105daa:	8b 15 fc a5 10 80    	mov    0x8010a5fc,%edx
80105db0:	85 d2                	test   %edx,%edx
80105db2:	74 ec                	je     80105da0 <uartinit+0x90>
80105db4:	83 c3 01             	add    $0x1,%ebx
80105db7:	e8 04 ff ff ff       	call   80105cc0 <uartputc.part.0>
80105dbc:	0f be 03             	movsbl (%ebx),%eax
80105dbf:	84 c0                	test   %al,%al
80105dc1:	75 e7                	jne    80105daa <uartinit+0x9a>
80105dc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dc6:	5b                   	pop    %ebx
80105dc7:	5e                   	pop    %esi
80105dc8:	5f                   	pop    %edi
80105dc9:	5d                   	pop    %ebp
80105dca:	c3                   	ret    
80105dcb:	90                   	nop
80105dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105dd0 <uartputc>:
80105dd0:	8b 15 fc a5 10 80    	mov    0x8010a5fc,%edx
80105dd6:	55                   	push   %ebp
80105dd7:	89 e5                	mov    %esp,%ebp
80105dd9:	85 d2                	test   %edx,%edx
80105ddb:	8b 45 08             	mov    0x8(%ebp),%eax
80105dde:	74 10                	je     80105df0 <uartputc+0x20>
80105de0:	5d                   	pop    %ebp
80105de1:	e9 da fe ff ff       	jmp    80105cc0 <uartputc.part.0>
80105de6:	8d 76 00             	lea    0x0(%esi),%esi
80105de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105df0:	5d                   	pop    %ebp
80105df1:	c3                   	ret    
80105df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e00 <uartintr>:
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	83 ec 14             	sub    $0x14,%esp
80105e06:	68 90 5c 10 80       	push   $0x80105c90
80105e0b:	e8 d0 ac ff ff       	call   80100ae0 <consoleintr>
80105e10:	83 c4 10             	add    $0x10,%esp
80105e13:	c9                   	leave  
80105e14:	c3                   	ret    

80105e15 <vector0>:
80105e15:	6a 00                	push   $0x0
80105e17:	6a 00                	push   $0x0
80105e19:	e9 1c fb ff ff       	jmp    8010593a <alltraps>

80105e1e <vector1>:
80105e1e:	6a 00                	push   $0x0
80105e20:	6a 01                	push   $0x1
80105e22:	e9 13 fb ff ff       	jmp    8010593a <alltraps>

80105e27 <vector2>:
80105e27:	6a 00                	push   $0x0
80105e29:	6a 02                	push   $0x2
80105e2b:	e9 0a fb ff ff       	jmp    8010593a <alltraps>

80105e30 <vector3>:
80105e30:	6a 00                	push   $0x0
80105e32:	6a 03                	push   $0x3
80105e34:	e9 01 fb ff ff       	jmp    8010593a <alltraps>

80105e39 <vector4>:
80105e39:	6a 00                	push   $0x0
80105e3b:	6a 04                	push   $0x4
80105e3d:	e9 f8 fa ff ff       	jmp    8010593a <alltraps>

80105e42 <vector5>:
80105e42:	6a 00                	push   $0x0
80105e44:	6a 05                	push   $0x5
80105e46:	e9 ef fa ff ff       	jmp    8010593a <alltraps>

80105e4b <vector6>:
80105e4b:	6a 00                	push   $0x0
80105e4d:	6a 06                	push   $0x6
80105e4f:	e9 e6 fa ff ff       	jmp    8010593a <alltraps>

80105e54 <vector7>:
80105e54:	6a 00                	push   $0x0
80105e56:	6a 07                	push   $0x7
80105e58:	e9 dd fa ff ff       	jmp    8010593a <alltraps>

80105e5d <vector8>:
80105e5d:	6a 08                	push   $0x8
80105e5f:	e9 d6 fa ff ff       	jmp    8010593a <alltraps>

80105e64 <vector9>:
80105e64:	6a 00                	push   $0x0
80105e66:	6a 09                	push   $0x9
80105e68:	e9 cd fa ff ff       	jmp    8010593a <alltraps>

80105e6d <vector10>:
80105e6d:	6a 0a                	push   $0xa
80105e6f:	e9 c6 fa ff ff       	jmp    8010593a <alltraps>

80105e74 <vector11>:
80105e74:	6a 0b                	push   $0xb
80105e76:	e9 bf fa ff ff       	jmp    8010593a <alltraps>

80105e7b <vector12>:
80105e7b:	6a 0c                	push   $0xc
80105e7d:	e9 b8 fa ff ff       	jmp    8010593a <alltraps>

80105e82 <vector13>:
80105e82:	6a 0d                	push   $0xd
80105e84:	e9 b1 fa ff ff       	jmp    8010593a <alltraps>

80105e89 <vector14>:
80105e89:	6a 0e                	push   $0xe
80105e8b:	e9 aa fa ff ff       	jmp    8010593a <alltraps>

80105e90 <vector15>:
80105e90:	6a 00                	push   $0x0
80105e92:	6a 0f                	push   $0xf
80105e94:	e9 a1 fa ff ff       	jmp    8010593a <alltraps>

80105e99 <vector16>:
80105e99:	6a 00                	push   $0x0
80105e9b:	6a 10                	push   $0x10
80105e9d:	e9 98 fa ff ff       	jmp    8010593a <alltraps>

80105ea2 <vector17>:
80105ea2:	6a 11                	push   $0x11
80105ea4:	e9 91 fa ff ff       	jmp    8010593a <alltraps>

80105ea9 <vector18>:
80105ea9:	6a 00                	push   $0x0
80105eab:	6a 12                	push   $0x12
80105ead:	e9 88 fa ff ff       	jmp    8010593a <alltraps>

80105eb2 <vector19>:
80105eb2:	6a 00                	push   $0x0
80105eb4:	6a 13                	push   $0x13
80105eb6:	e9 7f fa ff ff       	jmp    8010593a <alltraps>

80105ebb <vector20>:
80105ebb:	6a 00                	push   $0x0
80105ebd:	6a 14                	push   $0x14
80105ebf:	e9 76 fa ff ff       	jmp    8010593a <alltraps>

80105ec4 <vector21>:
80105ec4:	6a 00                	push   $0x0
80105ec6:	6a 15                	push   $0x15
80105ec8:	e9 6d fa ff ff       	jmp    8010593a <alltraps>

80105ecd <vector22>:
80105ecd:	6a 00                	push   $0x0
80105ecf:	6a 16                	push   $0x16
80105ed1:	e9 64 fa ff ff       	jmp    8010593a <alltraps>

80105ed6 <vector23>:
80105ed6:	6a 00                	push   $0x0
80105ed8:	6a 17                	push   $0x17
80105eda:	e9 5b fa ff ff       	jmp    8010593a <alltraps>

80105edf <vector24>:
80105edf:	6a 00                	push   $0x0
80105ee1:	6a 18                	push   $0x18
80105ee3:	e9 52 fa ff ff       	jmp    8010593a <alltraps>

80105ee8 <vector25>:
80105ee8:	6a 00                	push   $0x0
80105eea:	6a 19                	push   $0x19
80105eec:	e9 49 fa ff ff       	jmp    8010593a <alltraps>

80105ef1 <vector26>:
80105ef1:	6a 00                	push   $0x0
80105ef3:	6a 1a                	push   $0x1a
80105ef5:	e9 40 fa ff ff       	jmp    8010593a <alltraps>

80105efa <vector27>:
80105efa:	6a 00                	push   $0x0
80105efc:	6a 1b                	push   $0x1b
80105efe:	e9 37 fa ff ff       	jmp    8010593a <alltraps>

80105f03 <vector28>:
80105f03:	6a 00                	push   $0x0
80105f05:	6a 1c                	push   $0x1c
80105f07:	e9 2e fa ff ff       	jmp    8010593a <alltraps>

80105f0c <vector29>:
80105f0c:	6a 00                	push   $0x0
80105f0e:	6a 1d                	push   $0x1d
80105f10:	e9 25 fa ff ff       	jmp    8010593a <alltraps>

80105f15 <vector30>:
80105f15:	6a 00                	push   $0x0
80105f17:	6a 1e                	push   $0x1e
80105f19:	e9 1c fa ff ff       	jmp    8010593a <alltraps>

80105f1e <vector31>:
80105f1e:	6a 00                	push   $0x0
80105f20:	6a 1f                	push   $0x1f
80105f22:	e9 13 fa ff ff       	jmp    8010593a <alltraps>

80105f27 <vector32>:
80105f27:	6a 00                	push   $0x0
80105f29:	6a 20                	push   $0x20
80105f2b:	e9 0a fa ff ff       	jmp    8010593a <alltraps>

80105f30 <vector33>:
80105f30:	6a 00                	push   $0x0
80105f32:	6a 21                	push   $0x21
80105f34:	e9 01 fa ff ff       	jmp    8010593a <alltraps>

80105f39 <vector34>:
80105f39:	6a 00                	push   $0x0
80105f3b:	6a 22                	push   $0x22
80105f3d:	e9 f8 f9 ff ff       	jmp    8010593a <alltraps>

80105f42 <vector35>:
80105f42:	6a 00                	push   $0x0
80105f44:	6a 23                	push   $0x23
80105f46:	e9 ef f9 ff ff       	jmp    8010593a <alltraps>

80105f4b <vector36>:
80105f4b:	6a 00                	push   $0x0
80105f4d:	6a 24                	push   $0x24
80105f4f:	e9 e6 f9 ff ff       	jmp    8010593a <alltraps>

80105f54 <vector37>:
80105f54:	6a 00                	push   $0x0
80105f56:	6a 25                	push   $0x25
80105f58:	e9 dd f9 ff ff       	jmp    8010593a <alltraps>

80105f5d <vector38>:
80105f5d:	6a 00                	push   $0x0
80105f5f:	6a 26                	push   $0x26
80105f61:	e9 d4 f9 ff ff       	jmp    8010593a <alltraps>

80105f66 <vector39>:
80105f66:	6a 00                	push   $0x0
80105f68:	6a 27                	push   $0x27
80105f6a:	e9 cb f9 ff ff       	jmp    8010593a <alltraps>

80105f6f <vector40>:
80105f6f:	6a 00                	push   $0x0
80105f71:	6a 28                	push   $0x28
80105f73:	e9 c2 f9 ff ff       	jmp    8010593a <alltraps>

80105f78 <vector41>:
80105f78:	6a 00                	push   $0x0
80105f7a:	6a 29                	push   $0x29
80105f7c:	e9 b9 f9 ff ff       	jmp    8010593a <alltraps>

80105f81 <vector42>:
80105f81:	6a 00                	push   $0x0
80105f83:	6a 2a                	push   $0x2a
80105f85:	e9 b0 f9 ff ff       	jmp    8010593a <alltraps>

80105f8a <vector43>:
80105f8a:	6a 00                	push   $0x0
80105f8c:	6a 2b                	push   $0x2b
80105f8e:	e9 a7 f9 ff ff       	jmp    8010593a <alltraps>

80105f93 <vector44>:
80105f93:	6a 00                	push   $0x0
80105f95:	6a 2c                	push   $0x2c
80105f97:	e9 9e f9 ff ff       	jmp    8010593a <alltraps>

80105f9c <vector45>:
80105f9c:	6a 00                	push   $0x0
80105f9e:	6a 2d                	push   $0x2d
80105fa0:	e9 95 f9 ff ff       	jmp    8010593a <alltraps>

80105fa5 <vector46>:
80105fa5:	6a 00                	push   $0x0
80105fa7:	6a 2e                	push   $0x2e
80105fa9:	e9 8c f9 ff ff       	jmp    8010593a <alltraps>

80105fae <vector47>:
80105fae:	6a 00                	push   $0x0
80105fb0:	6a 2f                	push   $0x2f
80105fb2:	e9 83 f9 ff ff       	jmp    8010593a <alltraps>

80105fb7 <vector48>:
80105fb7:	6a 00                	push   $0x0
80105fb9:	6a 30                	push   $0x30
80105fbb:	e9 7a f9 ff ff       	jmp    8010593a <alltraps>

80105fc0 <vector49>:
80105fc0:	6a 00                	push   $0x0
80105fc2:	6a 31                	push   $0x31
80105fc4:	e9 71 f9 ff ff       	jmp    8010593a <alltraps>

80105fc9 <vector50>:
80105fc9:	6a 00                	push   $0x0
80105fcb:	6a 32                	push   $0x32
80105fcd:	e9 68 f9 ff ff       	jmp    8010593a <alltraps>

80105fd2 <vector51>:
80105fd2:	6a 00                	push   $0x0
80105fd4:	6a 33                	push   $0x33
80105fd6:	e9 5f f9 ff ff       	jmp    8010593a <alltraps>

80105fdb <vector52>:
80105fdb:	6a 00                	push   $0x0
80105fdd:	6a 34                	push   $0x34
80105fdf:	e9 56 f9 ff ff       	jmp    8010593a <alltraps>

80105fe4 <vector53>:
80105fe4:	6a 00                	push   $0x0
80105fe6:	6a 35                	push   $0x35
80105fe8:	e9 4d f9 ff ff       	jmp    8010593a <alltraps>

80105fed <vector54>:
80105fed:	6a 00                	push   $0x0
80105fef:	6a 36                	push   $0x36
80105ff1:	e9 44 f9 ff ff       	jmp    8010593a <alltraps>

80105ff6 <vector55>:
80105ff6:	6a 00                	push   $0x0
80105ff8:	6a 37                	push   $0x37
80105ffa:	e9 3b f9 ff ff       	jmp    8010593a <alltraps>

80105fff <vector56>:
80105fff:	6a 00                	push   $0x0
80106001:	6a 38                	push   $0x38
80106003:	e9 32 f9 ff ff       	jmp    8010593a <alltraps>

80106008 <vector57>:
80106008:	6a 00                	push   $0x0
8010600a:	6a 39                	push   $0x39
8010600c:	e9 29 f9 ff ff       	jmp    8010593a <alltraps>

80106011 <vector58>:
80106011:	6a 00                	push   $0x0
80106013:	6a 3a                	push   $0x3a
80106015:	e9 20 f9 ff ff       	jmp    8010593a <alltraps>

8010601a <vector59>:
8010601a:	6a 00                	push   $0x0
8010601c:	6a 3b                	push   $0x3b
8010601e:	e9 17 f9 ff ff       	jmp    8010593a <alltraps>

80106023 <vector60>:
80106023:	6a 00                	push   $0x0
80106025:	6a 3c                	push   $0x3c
80106027:	e9 0e f9 ff ff       	jmp    8010593a <alltraps>

8010602c <vector61>:
8010602c:	6a 00                	push   $0x0
8010602e:	6a 3d                	push   $0x3d
80106030:	e9 05 f9 ff ff       	jmp    8010593a <alltraps>

80106035 <vector62>:
80106035:	6a 00                	push   $0x0
80106037:	6a 3e                	push   $0x3e
80106039:	e9 fc f8 ff ff       	jmp    8010593a <alltraps>

8010603e <vector63>:
8010603e:	6a 00                	push   $0x0
80106040:	6a 3f                	push   $0x3f
80106042:	e9 f3 f8 ff ff       	jmp    8010593a <alltraps>

80106047 <vector64>:
80106047:	6a 00                	push   $0x0
80106049:	6a 40                	push   $0x40
8010604b:	e9 ea f8 ff ff       	jmp    8010593a <alltraps>

80106050 <vector65>:
80106050:	6a 00                	push   $0x0
80106052:	6a 41                	push   $0x41
80106054:	e9 e1 f8 ff ff       	jmp    8010593a <alltraps>

80106059 <vector66>:
80106059:	6a 00                	push   $0x0
8010605b:	6a 42                	push   $0x42
8010605d:	e9 d8 f8 ff ff       	jmp    8010593a <alltraps>

80106062 <vector67>:
80106062:	6a 00                	push   $0x0
80106064:	6a 43                	push   $0x43
80106066:	e9 cf f8 ff ff       	jmp    8010593a <alltraps>

8010606b <vector68>:
8010606b:	6a 00                	push   $0x0
8010606d:	6a 44                	push   $0x44
8010606f:	e9 c6 f8 ff ff       	jmp    8010593a <alltraps>

80106074 <vector69>:
80106074:	6a 00                	push   $0x0
80106076:	6a 45                	push   $0x45
80106078:	e9 bd f8 ff ff       	jmp    8010593a <alltraps>

8010607d <vector70>:
8010607d:	6a 00                	push   $0x0
8010607f:	6a 46                	push   $0x46
80106081:	e9 b4 f8 ff ff       	jmp    8010593a <alltraps>

80106086 <vector71>:
80106086:	6a 00                	push   $0x0
80106088:	6a 47                	push   $0x47
8010608a:	e9 ab f8 ff ff       	jmp    8010593a <alltraps>

8010608f <vector72>:
8010608f:	6a 00                	push   $0x0
80106091:	6a 48                	push   $0x48
80106093:	e9 a2 f8 ff ff       	jmp    8010593a <alltraps>

80106098 <vector73>:
80106098:	6a 00                	push   $0x0
8010609a:	6a 49                	push   $0x49
8010609c:	e9 99 f8 ff ff       	jmp    8010593a <alltraps>

801060a1 <vector74>:
801060a1:	6a 00                	push   $0x0
801060a3:	6a 4a                	push   $0x4a
801060a5:	e9 90 f8 ff ff       	jmp    8010593a <alltraps>

801060aa <vector75>:
801060aa:	6a 00                	push   $0x0
801060ac:	6a 4b                	push   $0x4b
801060ae:	e9 87 f8 ff ff       	jmp    8010593a <alltraps>

801060b3 <vector76>:
801060b3:	6a 00                	push   $0x0
801060b5:	6a 4c                	push   $0x4c
801060b7:	e9 7e f8 ff ff       	jmp    8010593a <alltraps>

801060bc <vector77>:
801060bc:	6a 00                	push   $0x0
801060be:	6a 4d                	push   $0x4d
801060c0:	e9 75 f8 ff ff       	jmp    8010593a <alltraps>

801060c5 <vector78>:
801060c5:	6a 00                	push   $0x0
801060c7:	6a 4e                	push   $0x4e
801060c9:	e9 6c f8 ff ff       	jmp    8010593a <alltraps>

801060ce <vector79>:
801060ce:	6a 00                	push   $0x0
801060d0:	6a 4f                	push   $0x4f
801060d2:	e9 63 f8 ff ff       	jmp    8010593a <alltraps>

801060d7 <vector80>:
801060d7:	6a 00                	push   $0x0
801060d9:	6a 50                	push   $0x50
801060db:	e9 5a f8 ff ff       	jmp    8010593a <alltraps>

801060e0 <vector81>:
801060e0:	6a 00                	push   $0x0
801060e2:	6a 51                	push   $0x51
801060e4:	e9 51 f8 ff ff       	jmp    8010593a <alltraps>

801060e9 <vector82>:
801060e9:	6a 00                	push   $0x0
801060eb:	6a 52                	push   $0x52
801060ed:	e9 48 f8 ff ff       	jmp    8010593a <alltraps>

801060f2 <vector83>:
801060f2:	6a 00                	push   $0x0
801060f4:	6a 53                	push   $0x53
801060f6:	e9 3f f8 ff ff       	jmp    8010593a <alltraps>

801060fb <vector84>:
801060fb:	6a 00                	push   $0x0
801060fd:	6a 54                	push   $0x54
801060ff:	e9 36 f8 ff ff       	jmp    8010593a <alltraps>

80106104 <vector85>:
80106104:	6a 00                	push   $0x0
80106106:	6a 55                	push   $0x55
80106108:	e9 2d f8 ff ff       	jmp    8010593a <alltraps>

8010610d <vector86>:
8010610d:	6a 00                	push   $0x0
8010610f:	6a 56                	push   $0x56
80106111:	e9 24 f8 ff ff       	jmp    8010593a <alltraps>

80106116 <vector87>:
80106116:	6a 00                	push   $0x0
80106118:	6a 57                	push   $0x57
8010611a:	e9 1b f8 ff ff       	jmp    8010593a <alltraps>

8010611f <vector88>:
8010611f:	6a 00                	push   $0x0
80106121:	6a 58                	push   $0x58
80106123:	e9 12 f8 ff ff       	jmp    8010593a <alltraps>

80106128 <vector89>:
80106128:	6a 00                	push   $0x0
8010612a:	6a 59                	push   $0x59
8010612c:	e9 09 f8 ff ff       	jmp    8010593a <alltraps>

80106131 <vector90>:
80106131:	6a 00                	push   $0x0
80106133:	6a 5a                	push   $0x5a
80106135:	e9 00 f8 ff ff       	jmp    8010593a <alltraps>

8010613a <vector91>:
8010613a:	6a 00                	push   $0x0
8010613c:	6a 5b                	push   $0x5b
8010613e:	e9 f7 f7 ff ff       	jmp    8010593a <alltraps>

80106143 <vector92>:
80106143:	6a 00                	push   $0x0
80106145:	6a 5c                	push   $0x5c
80106147:	e9 ee f7 ff ff       	jmp    8010593a <alltraps>

8010614c <vector93>:
8010614c:	6a 00                	push   $0x0
8010614e:	6a 5d                	push   $0x5d
80106150:	e9 e5 f7 ff ff       	jmp    8010593a <alltraps>

80106155 <vector94>:
80106155:	6a 00                	push   $0x0
80106157:	6a 5e                	push   $0x5e
80106159:	e9 dc f7 ff ff       	jmp    8010593a <alltraps>

8010615e <vector95>:
8010615e:	6a 00                	push   $0x0
80106160:	6a 5f                	push   $0x5f
80106162:	e9 d3 f7 ff ff       	jmp    8010593a <alltraps>

80106167 <vector96>:
80106167:	6a 00                	push   $0x0
80106169:	6a 60                	push   $0x60
8010616b:	e9 ca f7 ff ff       	jmp    8010593a <alltraps>

80106170 <vector97>:
80106170:	6a 00                	push   $0x0
80106172:	6a 61                	push   $0x61
80106174:	e9 c1 f7 ff ff       	jmp    8010593a <alltraps>

80106179 <vector98>:
80106179:	6a 00                	push   $0x0
8010617b:	6a 62                	push   $0x62
8010617d:	e9 b8 f7 ff ff       	jmp    8010593a <alltraps>

80106182 <vector99>:
80106182:	6a 00                	push   $0x0
80106184:	6a 63                	push   $0x63
80106186:	e9 af f7 ff ff       	jmp    8010593a <alltraps>

8010618b <vector100>:
8010618b:	6a 00                	push   $0x0
8010618d:	6a 64                	push   $0x64
8010618f:	e9 a6 f7 ff ff       	jmp    8010593a <alltraps>

80106194 <vector101>:
80106194:	6a 00                	push   $0x0
80106196:	6a 65                	push   $0x65
80106198:	e9 9d f7 ff ff       	jmp    8010593a <alltraps>

8010619d <vector102>:
8010619d:	6a 00                	push   $0x0
8010619f:	6a 66                	push   $0x66
801061a1:	e9 94 f7 ff ff       	jmp    8010593a <alltraps>

801061a6 <vector103>:
801061a6:	6a 00                	push   $0x0
801061a8:	6a 67                	push   $0x67
801061aa:	e9 8b f7 ff ff       	jmp    8010593a <alltraps>

801061af <vector104>:
801061af:	6a 00                	push   $0x0
801061b1:	6a 68                	push   $0x68
801061b3:	e9 82 f7 ff ff       	jmp    8010593a <alltraps>

801061b8 <vector105>:
801061b8:	6a 00                	push   $0x0
801061ba:	6a 69                	push   $0x69
801061bc:	e9 79 f7 ff ff       	jmp    8010593a <alltraps>

801061c1 <vector106>:
801061c1:	6a 00                	push   $0x0
801061c3:	6a 6a                	push   $0x6a
801061c5:	e9 70 f7 ff ff       	jmp    8010593a <alltraps>

801061ca <vector107>:
801061ca:	6a 00                	push   $0x0
801061cc:	6a 6b                	push   $0x6b
801061ce:	e9 67 f7 ff ff       	jmp    8010593a <alltraps>

801061d3 <vector108>:
801061d3:	6a 00                	push   $0x0
801061d5:	6a 6c                	push   $0x6c
801061d7:	e9 5e f7 ff ff       	jmp    8010593a <alltraps>

801061dc <vector109>:
801061dc:	6a 00                	push   $0x0
801061de:	6a 6d                	push   $0x6d
801061e0:	e9 55 f7 ff ff       	jmp    8010593a <alltraps>

801061e5 <vector110>:
801061e5:	6a 00                	push   $0x0
801061e7:	6a 6e                	push   $0x6e
801061e9:	e9 4c f7 ff ff       	jmp    8010593a <alltraps>

801061ee <vector111>:
801061ee:	6a 00                	push   $0x0
801061f0:	6a 6f                	push   $0x6f
801061f2:	e9 43 f7 ff ff       	jmp    8010593a <alltraps>

801061f7 <vector112>:
801061f7:	6a 00                	push   $0x0
801061f9:	6a 70                	push   $0x70
801061fb:	e9 3a f7 ff ff       	jmp    8010593a <alltraps>

80106200 <vector113>:
80106200:	6a 00                	push   $0x0
80106202:	6a 71                	push   $0x71
80106204:	e9 31 f7 ff ff       	jmp    8010593a <alltraps>

80106209 <vector114>:
80106209:	6a 00                	push   $0x0
8010620b:	6a 72                	push   $0x72
8010620d:	e9 28 f7 ff ff       	jmp    8010593a <alltraps>

80106212 <vector115>:
80106212:	6a 00                	push   $0x0
80106214:	6a 73                	push   $0x73
80106216:	e9 1f f7 ff ff       	jmp    8010593a <alltraps>

8010621b <vector116>:
8010621b:	6a 00                	push   $0x0
8010621d:	6a 74                	push   $0x74
8010621f:	e9 16 f7 ff ff       	jmp    8010593a <alltraps>

80106224 <vector117>:
80106224:	6a 00                	push   $0x0
80106226:	6a 75                	push   $0x75
80106228:	e9 0d f7 ff ff       	jmp    8010593a <alltraps>

8010622d <vector118>:
8010622d:	6a 00                	push   $0x0
8010622f:	6a 76                	push   $0x76
80106231:	e9 04 f7 ff ff       	jmp    8010593a <alltraps>

80106236 <vector119>:
80106236:	6a 00                	push   $0x0
80106238:	6a 77                	push   $0x77
8010623a:	e9 fb f6 ff ff       	jmp    8010593a <alltraps>

8010623f <vector120>:
8010623f:	6a 00                	push   $0x0
80106241:	6a 78                	push   $0x78
80106243:	e9 f2 f6 ff ff       	jmp    8010593a <alltraps>

80106248 <vector121>:
80106248:	6a 00                	push   $0x0
8010624a:	6a 79                	push   $0x79
8010624c:	e9 e9 f6 ff ff       	jmp    8010593a <alltraps>

80106251 <vector122>:
80106251:	6a 00                	push   $0x0
80106253:	6a 7a                	push   $0x7a
80106255:	e9 e0 f6 ff ff       	jmp    8010593a <alltraps>

8010625a <vector123>:
8010625a:	6a 00                	push   $0x0
8010625c:	6a 7b                	push   $0x7b
8010625e:	e9 d7 f6 ff ff       	jmp    8010593a <alltraps>

80106263 <vector124>:
80106263:	6a 00                	push   $0x0
80106265:	6a 7c                	push   $0x7c
80106267:	e9 ce f6 ff ff       	jmp    8010593a <alltraps>

8010626c <vector125>:
8010626c:	6a 00                	push   $0x0
8010626e:	6a 7d                	push   $0x7d
80106270:	e9 c5 f6 ff ff       	jmp    8010593a <alltraps>

80106275 <vector126>:
80106275:	6a 00                	push   $0x0
80106277:	6a 7e                	push   $0x7e
80106279:	e9 bc f6 ff ff       	jmp    8010593a <alltraps>

8010627e <vector127>:
8010627e:	6a 00                	push   $0x0
80106280:	6a 7f                	push   $0x7f
80106282:	e9 b3 f6 ff ff       	jmp    8010593a <alltraps>

80106287 <vector128>:
80106287:	6a 00                	push   $0x0
80106289:	68 80 00 00 00       	push   $0x80
8010628e:	e9 a7 f6 ff ff       	jmp    8010593a <alltraps>

80106293 <vector129>:
80106293:	6a 00                	push   $0x0
80106295:	68 81 00 00 00       	push   $0x81
8010629a:	e9 9b f6 ff ff       	jmp    8010593a <alltraps>

8010629f <vector130>:
8010629f:	6a 00                	push   $0x0
801062a1:	68 82 00 00 00       	push   $0x82
801062a6:	e9 8f f6 ff ff       	jmp    8010593a <alltraps>

801062ab <vector131>:
801062ab:	6a 00                	push   $0x0
801062ad:	68 83 00 00 00       	push   $0x83
801062b2:	e9 83 f6 ff ff       	jmp    8010593a <alltraps>

801062b7 <vector132>:
801062b7:	6a 00                	push   $0x0
801062b9:	68 84 00 00 00       	push   $0x84
801062be:	e9 77 f6 ff ff       	jmp    8010593a <alltraps>

801062c3 <vector133>:
801062c3:	6a 00                	push   $0x0
801062c5:	68 85 00 00 00       	push   $0x85
801062ca:	e9 6b f6 ff ff       	jmp    8010593a <alltraps>

801062cf <vector134>:
801062cf:	6a 00                	push   $0x0
801062d1:	68 86 00 00 00       	push   $0x86
801062d6:	e9 5f f6 ff ff       	jmp    8010593a <alltraps>

801062db <vector135>:
801062db:	6a 00                	push   $0x0
801062dd:	68 87 00 00 00       	push   $0x87
801062e2:	e9 53 f6 ff ff       	jmp    8010593a <alltraps>

801062e7 <vector136>:
801062e7:	6a 00                	push   $0x0
801062e9:	68 88 00 00 00       	push   $0x88
801062ee:	e9 47 f6 ff ff       	jmp    8010593a <alltraps>

801062f3 <vector137>:
801062f3:	6a 00                	push   $0x0
801062f5:	68 89 00 00 00       	push   $0x89
801062fa:	e9 3b f6 ff ff       	jmp    8010593a <alltraps>

801062ff <vector138>:
801062ff:	6a 00                	push   $0x0
80106301:	68 8a 00 00 00       	push   $0x8a
80106306:	e9 2f f6 ff ff       	jmp    8010593a <alltraps>

8010630b <vector139>:
8010630b:	6a 00                	push   $0x0
8010630d:	68 8b 00 00 00       	push   $0x8b
80106312:	e9 23 f6 ff ff       	jmp    8010593a <alltraps>

80106317 <vector140>:
80106317:	6a 00                	push   $0x0
80106319:	68 8c 00 00 00       	push   $0x8c
8010631e:	e9 17 f6 ff ff       	jmp    8010593a <alltraps>

80106323 <vector141>:
80106323:	6a 00                	push   $0x0
80106325:	68 8d 00 00 00       	push   $0x8d
8010632a:	e9 0b f6 ff ff       	jmp    8010593a <alltraps>

8010632f <vector142>:
8010632f:	6a 00                	push   $0x0
80106331:	68 8e 00 00 00       	push   $0x8e
80106336:	e9 ff f5 ff ff       	jmp    8010593a <alltraps>

8010633b <vector143>:
8010633b:	6a 00                	push   $0x0
8010633d:	68 8f 00 00 00       	push   $0x8f
80106342:	e9 f3 f5 ff ff       	jmp    8010593a <alltraps>

80106347 <vector144>:
80106347:	6a 00                	push   $0x0
80106349:	68 90 00 00 00       	push   $0x90
8010634e:	e9 e7 f5 ff ff       	jmp    8010593a <alltraps>

80106353 <vector145>:
80106353:	6a 00                	push   $0x0
80106355:	68 91 00 00 00       	push   $0x91
8010635a:	e9 db f5 ff ff       	jmp    8010593a <alltraps>

8010635f <vector146>:
8010635f:	6a 00                	push   $0x0
80106361:	68 92 00 00 00       	push   $0x92
80106366:	e9 cf f5 ff ff       	jmp    8010593a <alltraps>

8010636b <vector147>:
8010636b:	6a 00                	push   $0x0
8010636d:	68 93 00 00 00       	push   $0x93
80106372:	e9 c3 f5 ff ff       	jmp    8010593a <alltraps>

80106377 <vector148>:
80106377:	6a 00                	push   $0x0
80106379:	68 94 00 00 00       	push   $0x94
8010637e:	e9 b7 f5 ff ff       	jmp    8010593a <alltraps>

80106383 <vector149>:
80106383:	6a 00                	push   $0x0
80106385:	68 95 00 00 00       	push   $0x95
8010638a:	e9 ab f5 ff ff       	jmp    8010593a <alltraps>

8010638f <vector150>:
8010638f:	6a 00                	push   $0x0
80106391:	68 96 00 00 00       	push   $0x96
80106396:	e9 9f f5 ff ff       	jmp    8010593a <alltraps>

8010639b <vector151>:
8010639b:	6a 00                	push   $0x0
8010639d:	68 97 00 00 00       	push   $0x97
801063a2:	e9 93 f5 ff ff       	jmp    8010593a <alltraps>

801063a7 <vector152>:
801063a7:	6a 00                	push   $0x0
801063a9:	68 98 00 00 00       	push   $0x98
801063ae:	e9 87 f5 ff ff       	jmp    8010593a <alltraps>

801063b3 <vector153>:
801063b3:	6a 00                	push   $0x0
801063b5:	68 99 00 00 00       	push   $0x99
801063ba:	e9 7b f5 ff ff       	jmp    8010593a <alltraps>

801063bf <vector154>:
801063bf:	6a 00                	push   $0x0
801063c1:	68 9a 00 00 00       	push   $0x9a
801063c6:	e9 6f f5 ff ff       	jmp    8010593a <alltraps>

801063cb <vector155>:
801063cb:	6a 00                	push   $0x0
801063cd:	68 9b 00 00 00       	push   $0x9b
801063d2:	e9 63 f5 ff ff       	jmp    8010593a <alltraps>

801063d7 <vector156>:
801063d7:	6a 00                	push   $0x0
801063d9:	68 9c 00 00 00       	push   $0x9c
801063de:	e9 57 f5 ff ff       	jmp    8010593a <alltraps>

801063e3 <vector157>:
801063e3:	6a 00                	push   $0x0
801063e5:	68 9d 00 00 00       	push   $0x9d
801063ea:	e9 4b f5 ff ff       	jmp    8010593a <alltraps>

801063ef <vector158>:
801063ef:	6a 00                	push   $0x0
801063f1:	68 9e 00 00 00       	push   $0x9e
801063f6:	e9 3f f5 ff ff       	jmp    8010593a <alltraps>

801063fb <vector159>:
801063fb:	6a 00                	push   $0x0
801063fd:	68 9f 00 00 00       	push   $0x9f
80106402:	e9 33 f5 ff ff       	jmp    8010593a <alltraps>

80106407 <vector160>:
80106407:	6a 00                	push   $0x0
80106409:	68 a0 00 00 00       	push   $0xa0
8010640e:	e9 27 f5 ff ff       	jmp    8010593a <alltraps>

80106413 <vector161>:
80106413:	6a 00                	push   $0x0
80106415:	68 a1 00 00 00       	push   $0xa1
8010641a:	e9 1b f5 ff ff       	jmp    8010593a <alltraps>

8010641f <vector162>:
8010641f:	6a 00                	push   $0x0
80106421:	68 a2 00 00 00       	push   $0xa2
80106426:	e9 0f f5 ff ff       	jmp    8010593a <alltraps>

8010642b <vector163>:
8010642b:	6a 00                	push   $0x0
8010642d:	68 a3 00 00 00       	push   $0xa3
80106432:	e9 03 f5 ff ff       	jmp    8010593a <alltraps>

80106437 <vector164>:
80106437:	6a 00                	push   $0x0
80106439:	68 a4 00 00 00       	push   $0xa4
8010643e:	e9 f7 f4 ff ff       	jmp    8010593a <alltraps>

80106443 <vector165>:
80106443:	6a 00                	push   $0x0
80106445:	68 a5 00 00 00       	push   $0xa5
8010644a:	e9 eb f4 ff ff       	jmp    8010593a <alltraps>

8010644f <vector166>:
8010644f:	6a 00                	push   $0x0
80106451:	68 a6 00 00 00       	push   $0xa6
80106456:	e9 df f4 ff ff       	jmp    8010593a <alltraps>

8010645b <vector167>:
8010645b:	6a 00                	push   $0x0
8010645d:	68 a7 00 00 00       	push   $0xa7
80106462:	e9 d3 f4 ff ff       	jmp    8010593a <alltraps>

80106467 <vector168>:
80106467:	6a 00                	push   $0x0
80106469:	68 a8 00 00 00       	push   $0xa8
8010646e:	e9 c7 f4 ff ff       	jmp    8010593a <alltraps>

80106473 <vector169>:
80106473:	6a 00                	push   $0x0
80106475:	68 a9 00 00 00       	push   $0xa9
8010647a:	e9 bb f4 ff ff       	jmp    8010593a <alltraps>

8010647f <vector170>:
8010647f:	6a 00                	push   $0x0
80106481:	68 aa 00 00 00       	push   $0xaa
80106486:	e9 af f4 ff ff       	jmp    8010593a <alltraps>

8010648b <vector171>:
8010648b:	6a 00                	push   $0x0
8010648d:	68 ab 00 00 00       	push   $0xab
80106492:	e9 a3 f4 ff ff       	jmp    8010593a <alltraps>

80106497 <vector172>:
80106497:	6a 00                	push   $0x0
80106499:	68 ac 00 00 00       	push   $0xac
8010649e:	e9 97 f4 ff ff       	jmp    8010593a <alltraps>

801064a3 <vector173>:
801064a3:	6a 00                	push   $0x0
801064a5:	68 ad 00 00 00       	push   $0xad
801064aa:	e9 8b f4 ff ff       	jmp    8010593a <alltraps>

801064af <vector174>:
801064af:	6a 00                	push   $0x0
801064b1:	68 ae 00 00 00       	push   $0xae
801064b6:	e9 7f f4 ff ff       	jmp    8010593a <alltraps>

801064bb <vector175>:
801064bb:	6a 00                	push   $0x0
801064bd:	68 af 00 00 00       	push   $0xaf
801064c2:	e9 73 f4 ff ff       	jmp    8010593a <alltraps>

801064c7 <vector176>:
801064c7:	6a 00                	push   $0x0
801064c9:	68 b0 00 00 00       	push   $0xb0
801064ce:	e9 67 f4 ff ff       	jmp    8010593a <alltraps>

801064d3 <vector177>:
801064d3:	6a 00                	push   $0x0
801064d5:	68 b1 00 00 00       	push   $0xb1
801064da:	e9 5b f4 ff ff       	jmp    8010593a <alltraps>

801064df <vector178>:
801064df:	6a 00                	push   $0x0
801064e1:	68 b2 00 00 00       	push   $0xb2
801064e6:	e9 4f f4 ff ff       	jmp    8010593a <alltraps>

801064eb <vector179>:
801064eb:	6a 00                	push   $0x0
801064ed:	68 b3 00 00 00       	push   $0xb3
801064f2:	e9 43 f4 ff ff       	jmp    8010593a <alltraps>

801064f7 <vector180>:
801064f7:	6a 00                	push   $0x0
801064f9:	68 b4 00 00 00       	push   $0xb4
801064fe:	e9 37 f4 ff ff       	jmp    8010593a <alltraps>

80106503 <vector181>:
80106503:	6a 00                	push   $0x0
80106505:	68 b5 00 00 00       	push   $0xb5
8010650a:	e9 2b f4 ff ff       	jmp    8010593a <alltraps>

8010650f <vector182>:
8010650f:	6a 00                	push   $0x0
80106511:	68 b6 00 00 00       	push   $0xb6
80106516:	e9 1f f4 ff ff       	jmp    8010593a <alltraps>

8010651b <vector183>:
8010651b:	6a 00                	push   $0x0
8010651d:	68 b7 00 00 00       	push   $0xb7
80106522:	e9 13 f4 ff ff       	jmp    8010593a <alltraps>

80106527 <vector184>:
80106527:	6a 00                	push   $0x0
80106529:	68 b8 00 00 00       	push   $0xb8
8010652e:	e9 07 f4 ff ff       	jmp    8010593a <alltraps>

80106533 <vector185>:
80106533:	6a 00                	push   $0x0
80106535:	68 b9 00 00 00       	push   $0xb9
8010653a:	e9 fb f3 ff ff       	jmp    8010593a <alltraps>

8010653f <vector186>:
8010653f:	6a 00                	push   $0x0
80106541:	68 ba 00 00 00       	push   $0xba
80106546:	e9 ef f3 ff ff       	jmp    8010593a <alltraps>

8010654b <vector187>:
8010654b:	6a 00                	push   $0x0
8010654d:	68 bb 00 00 00       	push   $0xbb
80106552:	e9 e3 f3 ff ff       	jmp    8010593a <alltraps>

80106557 <vector188>:
80106557:	6a 00                	push   $0x0
80106559:	68 bc 00 00 00       	push   $0xbc
8010655e:	e9 d7 f3 ff ff       	jmp    8010593a <alltraps>

80106563 <vector189>:
80106563:	6a 00                	push   $0x0
80106565:	68 bd 00 00 00       	push   $0xbd
8010656a:	e9 cb f3 ff ff       	jmp    8010593a <alltraps>

8010656f <vector190>:
8010656f:	6a 00                	push   $0x0
80106571:	68 be 00 00 00       	push   $0xbe
80106576:	e9 bf f3 ff ff       	jmp    8010593a <alltraps>

8010657b <vector191>:
8010657b:	6a 00                	push   $0x0
8010657d:	68 bf 00 00 00       	push   $0xbf
80106582:	e9 b3 f3 ff ff       	jmp    8010593a <alltraps>

80106587 <vector192>:
80106587:	6a 00                	push   $0x0
80106589:	68 c0 00 00 00       	push   $0xc0
8010658e:	e9 a7 f3 ff ff       	jmp    8010593a <alltraps>

80106593 <vector193>:
80106593:	6a 00                	push   $0x0
80106595:	68 c1 00 00 00       	push   $0xc1
8010659a:	e9 9b f3 ff ff       	jmp    8010593a <alltraps>

8010659f <vector194>:
8010659f:	6a 00                	push   $0x0
801065a1:	68 c2 00 00 00       	push   $0xc2
801065a6:	e9 8f f3 ff ff       	jmp    8010593a <alltraps>

801065ab <vector195>:
801065ab:	6a 00                	push   $0x0
801065ad:	68 c3 00 00 00       	push   $0xc3
801065b2:	e9 83 f3 ff ff       	jmp    8010593a <alltraps>

801065b7 <vector196>:
801065b7:	6a 00                	push   $0x0
801065b9:	68 c4 00 00 00       	push   $0xc4
801065be:	e9 77 f3 ff ff       	jmp    8010593a <alltraps>

801065c3 <vector197>:
801065c3:	6a 00                	push   $0x0
801065c5:	68 c5 00 00 00       	push   $0xc5
801065ca:	e9 6b f3 ff ff       	jmp    8010593a <alltraps>

801065cf <vector198>:
801065cf:	6a 00                	push   $0x0
801065d1:	68 c6 00 00 00       	push   $0xc6
801065d6:	e9 5f f3 ff ff       	jmp    8010593a <alltraps>

801065db <vector199>:
801065db:	6a 00                	push   $0x0
801065dd:	68 c7 00 00 00       	push   $0xc7
801065e2:	e9 53 f3 ff ff       	jmp    8010593a <alltraps>

801065e7 <vector200>:
801065e7:	6a 00                	push   $0x0
801065e9:	68 c8 00 00 00       	push   $0xc8
801065ee:	e9 47 f3 ff ff       	jmp    8010593a <alltraps>

801065f3 <vector201>:
801065f3:	6a 00                	push   $0x0
801065f5:	68 c9 00 00 00       	push   $0xc9
801065fa:	e9 3b f3 ff ff       	jmp    8010593a <alltraps>

801065ff <vector202>:
801065ff:	6a 00                	push   $0x0
80106601:	68 ca 00 00 00       	push   $0xca
80106606:	e9 2f f3 ff ff       	jmp    8010593a <alltraps>

8010660b <vector203>:
8010660b:	6a 00                	push   $0x0
8010660d:	68 cb 00 00 00       	push   $0xcb
80106612:	e9 23 f3 ff ff       	jmp    8010593a <alltraps>

80106617 <vector204>:
80106617:	6a 00                	push   $0x0
80106619:	68 cc 00 00 00       	push   $0xcc
8010661e:	e9 17 f3 ff ff       	jmp    8010593a <alltraps>

80106623 <vector205>:
80106623:	6a 00                	push   $0x0
80106625:	68 cd 00 00 00       	push   $0xcd
8010662a:	e9 0b f3 ff ff       	jmp    8010593a <alltraps>

8010662f <vector206>:
8010662f:	6a 00                	push   $0x0
80106631:	68 ce 00 00 00       	push   $0xce
80106636:	e9 ff f2 ff ff       	jmp    8010593a <alltraps>

8010663b <vector207>:
8010663b:	6a 00                	push   $0x0
8010663d:	68 cf 00 00 00       	push   $0xcf
80106642:	e9 f3 f2 ff ff       	jmp    8010593a <alltraps>

80106647 <vector208>:
80106647:	6a 00                	push   $0x0
80106649:	68 d0 00 00 00       	push   $0xd0
8010664e:	e9 e7 f2 ff ff       	jmp    8010593a <alltraps>

80106653 <vector209>:
80106653:	6a 00                	push   $0x0
80106655:	68 d1 00 00 00       	push   $0xd1
8010665a:	e9 db f2 ff ff       	jmp    8010593a <alltraps>

8010665f <vector210>:
8010665f:	6a 00                	push   $0x0
80106661:	68 d2 00 00 00       	push   $0xd2
80106666:	e9 cf f2 ff ff       	jmp    8010593a <alltraps>

8010666b <vector211>:
8010666b:	6a 00                	push   $0x0
8010666d:	68 d3 00 00 00       	push   $0xd3
80106672:	e9 c3 f2 ff ff       	jmp    8010593a <alltraps>

80106677 <vector212>:
80106677:	6a 00                	push   $0x0
80106679:	68 d4 00 00 00       	push   $0xd4
8010667e:	e9 b7 f2 ff ff       	jmp    8010593a <alltraps>

80106683 <vector213>:
80106683:	6a 00                	push   $0x0
80106685:	68 d5 00 00 00       	push   $0xd5
8010668a:	e9 ab f2 ff ff       	jmp    8010593a <alltraps>

8010668f <vector214>:
8010668f:	6a 00                	push   $0x0
80106691:	68 d6 00 00 00       	push   $0xd6
80106696:	e9 9f f2 ff ff       	jmp    8010593a <alltraps>

8010669b <vector215>:
8010669b:	6a 00                	push   $0x0
8010669d:	68 d7 00 00 00       	push   $0xd7
801066a2:	e9 93 f2 ff ff       	jmp    8010593a <alltraps>

801066a7 <vector216>:
801066a7:	6a 00                	push   $0x0
801066a9:	68 d8 00 00 00       	push   $0xd8
801066ae:	e9 87 f2 ff ff       	jmp    8010593a <alltraps>

801066b3 <vector217>:
801066b3:	6a 00                	push   $0x0
801066b5:	68 d9 00 00 00       	push   $0xd9
801066ba:	e9 7b f2 ff ff       	jmp    8010593a <alltraps>

801066bf <vector218>:
801066bf:	6a 00                	push   $0x0
801066c1:	68 da 00 00 00       	push   $0xda
801066c6:	e9 6f f2 ff ff       	jmp    8010593a <alltraps>

801066cb <vector219>:
801066cb:	6a 00                	push   $0x0
801066cd:	68 db 00 00 00       	push   $0xdb
801066d2:	e9 63 f2 ff ff       	jmp    8010593a <alltraps>

801066d7 <vector220>:
801066d7:	6a 00                	push   $0x0
801066d9:	68 dc 00 00 00       	push   $0xdc
801066de:	e9 57 f2 ff ff       	jmp    8010593a <alltraps>

801066e3 <vector221>:
801066e3:	6a 00                	push   $0x0
801066e5:	68 dd 00 00 00       	push   $0xdd
801066ea:	e9 4b f2 ff ff       	jmp    8010593a <alltraps>

801066ef <vector222>:
801066ef:	6a 00                	push   $0x0
801066f1:	68 de 00 00 00       	push   $0xde
801066f6:	e9 3f f2 ff ff       	jmp    8010593a <alltraps>

801066fb <vector223>:
801066fb:	6a 00                	push   $0x0
801066fd:	68 df 00 00 00       	push   $0xdf
80106702:	e9 33 f2 ff ff       	jmp    8010593a <alltraps>

80106707 <vector224>:
80106707:	6a 00                	push   $0x0
80106709:	68 e0 00 00 00       	push   $0xe0
8010670e:	e9 27 f2 ff ff       	jmp    8010593a <alltraps>

80106713 <vector225>:
80106713:	6a 00                	push   $0x0
80106715:	68 e1 00 00 00       	push   $0xe1
8010671a:	e9 1b f2 ff ff       	jmp    8010593a <alltraps>

8010671f <vector226>:
8010671f:	6a 00                	push   $0x0
80106721:	68 e2 00 00 00       	push   $0xe2
80106726:	e9 0f f2 ff ff       	jmp    8010593a <alltraps>

8010672b <vector227>:
8010672b:	6a 00                	push   $0x0
8010672d:	68 e3 00 00 00       	push   $0xe3
80106732:	e9 03 f2 ff ff       	jmp    8010593a <alltraps>

80106737 <vector228>:
80106737:	6a 00                	push   $0x0
80106739:	68 e4 00 00 00       	push   $0xe4
8010673e:	e9 f7 f1 ff ff       	jmp    8010593a <alltraps>

80106743 <vector229>:
80106743:	6a 00                	push   $0x0
80106745:	68 e5 00 00 00       	push   $0xe5
8010674a:	e9 eb f1 ff ff       	jmp    8010593a <alltraps>

8010674f <vector230>:
8010674f:	6a 00                	push   $0x0
80106751:	68 e6 00 00 00       	push   $0xe6
80106756:	e9 df f1 ff ff       	jmp    8010593a <alltraps>

8010675b <vector231>:
8010675b:	6a 00                	push   $0x0
8010675d:	68 e7 00 00 00       	push   $0xe7
80106762:	e9 d3 f1 ff ff       	jmp    8010593a <alltraps>

80106767 <vector232>:
80106767:	6a 00                	push   $0x0
80106769:	68 e8 00 00 00       	push   $0xe8
8010676e:	e9 c7 f1 ff ff       	jmp    8010593a <alltraps>

80106773 <vector233>:
80106773:	6a 00                	push   $0x0
80106775:	68 e9 00 00 00       	push   $0xe9
8010677a:	e9 bb f1 ff ff       	jmp    8010593a <alltraps>

8010677f <vector234>:
8010677f:	6a 00                	push   $0x0
80106781:	68 ea 00 00 00       	push   $0xea
80106786:	e9 af f1 ff ff       	jmp    8010593a <alltraps>

8010678b <vector235>:
8010678b:	6a 00                	push   $0x0
8010678d:	68 eb 00 00 00       	push   $0xeb
80106792:	e9 a3 f1 ff ff       	jmp    8010593a <alltraps>

80106797 <vector236>:
80106797:	6a 00                	push   $0x0
80106799:	68 ec 00 00 00       	push   $0xec
8010679e:	e9 97 f1 ff ff       	jmp    8010593a <alltraps>

801067a3 <vector237>:
801067a3:	6a 00                	push   $0x0
801067a5:	68 ed 00 00 00       	push   $0xed
801067aa:	e9 8b f1 ff ff       	jmp    8010593a <alltraps>

801067af <vector238>:
801067af:	6a 00                	push   $0x0
801067b1:	68 ee 00 00 00       	push   $0xee
801067b6:	e9 7f f1 ff ff       	jmp    8010593a <alltraps>

801067bb <vector239>:
801067bb:	6a 00                	push   $0x0
801067bd:	68 ef 00 00 00       	push   $0xef
801067c2:	e9 73 f1 ff ff       	jmp    8010593a <alltraps>

801067c7 <vector240>:
801067c7:	6a 00                	push   $0x0
801067c9:	68 f0 00 00 00       	push   $0xf0
801067ce:	e9 67 f1 ff ff       	jmp    8010593a <alltraps>

801067d3 <vector241>:
801067d3:	6a 00                	push   $0x0
801067d5:	68 f1 00 00 00       	push   $0xf1
801067da:	e9 5b f1 ff ff       	jmp    8010593a <alltraps>

801067df <vector242>:
801067df:	6a 00                	push   $0x0
801067e1:	68 f2 00 00 00       	push   $0xf2
801067e6:	e9 4f f1 ff ff       	jmp    8010593a <alltraps>

801067eb <vector243>:
801067eb:	6a 00                	push   $0x0
801067ed:	68 f3 00 00 00       	push   $0xf3
801067f2:	e9 43 f1 ff ff       	jmp    8010593a <alltraps>

801067f7 <vector244>:
801067f7:	6a 00                	push   $0x0
801067f9:	68 f4 00 00 00       	push   $0xf4
801067fe:	e9 37 f1 ff ff       	jmp    8010593a <alltraps>

80106803 <vector245>:
80106803:	6a 00                	push   $0x0
80106805:	68 f5 00 00 00       	push   $0xf5
8010680a:	e9 2b f1 ff ff       	jmp    8010593a <alltraps>

8010680f <vector246>:
8010680f:	6a 00                	push   $0x0
80106811:	68 f6 00 00 00       	push   $0xf6
80106816:	e9 1f f1 ff ff       	jmp    8010593a <alltraps>

8010681b <vector247>:
8010681b:	6a 00                	push   $0x0
8010681d:	68 f7 00 00 00       	push   $0xf7
80106822:	e9 13 f1 ff ff       	jmp    8010593a <alltraps>

80106827 <vector248>:
80106827:	6a 00                	push   $0x0
80106829:	68 f8 00 00 00       	push   $0xf8
8010682e:	e9 07 f1 ff ff       	jmp    8010593a <alltraps>

80106833 <vector249>:
80106833:	6a 00                	push   $0x0
80106835:	68 f9 00 00 00       	push   $0xf9
8010683a:	e9 fb f0 ff ff       	jmp    8010593a <alltraps>

8010683f <vector250>:
8010683f:	6a 00                	push   $0x0
80106841:	68 fa 00 00 00       	push   $0xfa
80106846:	e9 ef f0 ff ff       	jmp    8010593a <alltraps>

8010684b <vector251>:
8010684b:	6a 00                	push   $0x0
8010684d:	68 fb 00 00 00       	push   $0xfb
80106852:	e9 e3 f0 ff ff       	jmp    8010593a <alltraps>

80106857 <vector252>:
80106857:	6a 00                	push   $0x0
80106859:	68 fc 00 00 00       	push   $0xfc
8010685e:	e9 d7 f0 ff ff       	jmp    8010593a <alltraps>

80106863 <vector253>:
80106863:	6a 00                	push   $0x0
80106865:	68 fd 00 00 00       	push   $0xfd
8010686a:	e9 cb f0 ff ff       	jmp    8010593a <alltraps>

8010686f <vector254>:
8010686f:	6a 00                	push   $0x0
80106871:	68 fe 00 00 00       	push   $0xfe
80106876:	e9 bf f0 ff ff       	jmp    8010593a <alltraps>

8010687b <vector255>:
8010687b:	6a 00                	push   $0x0
8010687d:	68 ff 00 00 00       	push   $0xff
80106882:	e9 b3 f0 ff ff       	jmp    8010593a <alltraps>
80106887:	66 90                	xchg   %ax,%ax
80106889:	66 90                	xchg   %ax,%ax
8010688b:	66 90                	xchg   %ax,%ax
8010688d:	66 90                	xchg   %ax,%ax
8010688f:	90                   	nop

80106890 <walkpgdir>:
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	57                   	push   %edi
80106894:	56                   	push   %esi
80106895:	53                   	push   %ebx
80106896:	89 d3                	mov    %edx,%ebx
80106898:	89 d7                	mov    %edx,%edi
8010689a:	c1 eb 16             	shr    $0x16,%ebx
8010689d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
801068a0:	83 ec 0c             	sub    $0xc,%esp
801068a3:	8b 06                	mov    (%esi),%eax
801068a5:	a8 01                	test   $0x1,%al
801068a7:	74 27                	je     801068d0 <walkpgdir+0x40>
801068a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068ae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801068b4:	c1 ef 0a             	shr    $0xa,%edi
801068b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068ba:	89 fa                	mov    %edi,%edx
801068bc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801068c2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
801068c5:	5b                   	pop    %ebx
801068c6:	5e                   	pop    %esi
801068c7:	5f                   	pop    %edi
801068c8:	5d                   	pop    %ebp
801068c9:	c3                   	ret    
801068ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801068d0:	85 c9                	test   %ecx,%ecx
801068d2:	74 2c                	je     80106900 <walkpgdir+0x70>
801068d4:	e8 f7 be ff ff       	call   801027d0 <kalloc>
801068d9:	85 c0                	test   %eax,%eax
801068db:	89 c3                	mov    %eax,%ebx
801068dd:	74 21                	je     80106900 <walkpgdir+0x70>
801068df:	83 ec 04             	sub    $0x4,%esp
801068e2:	68 00 10 00 00       	push   $0x1000
801068e7:	6a 00                	push   $0x0
801068e9:	50                   	push   %eax
801068ea:	e8 71 de ff ff       	call   80104760 <memset>
801068ef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801068f5:	83 c4 10             	add    $0x10,%esp
801068f8:	83 c8 07             	or     $0x7,%eax
801068fb:	89 06                	mov    %eax,(%esi)
801068fd:	eb b5                	jmp    801068b4 <walkpgdir+0x24>
801068ff:	90                   	nop
80106900:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106903:	31 c0                	xor    %eax,%eax
80106905:	5b                   	pop    %ebx
80106906:	5e                   	pop    %esi
80106907:	5f                   	pop    %edi
80106908:	5d                   	pop    %ebp
80106909:	c3                   	ret    
8010690a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106910 <mappages>:
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
80106916:	89 d3                	mov    %edx,%ebx
80106918:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010691e:	83 ec 1c             	sub    $0x1c,%esp
80106921:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106924:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106928:	8b 7d 08             	mov    0x8(%ebp),%edi
8010692b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106930:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106933:	8b 45 0c             	mov    0xc(%ebp),%eax
80106936:	29 df                	sub    %ebx,%edi
80106938:	83 c8 01             	or     $0x1,%eax
8010693b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010693e:	eb 15                	jmp    80106955 <mappages+0x45>
80106940:	f6 00 01             	testb  $0x1,(%eax)
80106943:	75 45                	jne    8010698a <mappages+0x7a>
80106945:	0b 75 dc             	or     -0x24(%ebp),%esi
80106948:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
8010694b:	89 30                	mov    %esi,(%eax)
8010694d:	74 31                	je     80106980 <mappages+0x70>
8010694f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106955:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106958:	b9 01 00 00 00       	mov    $0x1,%ecx
8010695d:	89 da                	mov    %ebx,%edx
8010695f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106962:	e8 29 ff ff ff       	call   80106890 <walkpgdir>
80106967:	85 c0                	test   %eax,%eax
80106969:	75 d5                	jne    80106940 <mappages+0x30>
8010696b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010696e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106973:	5b                   	pop    %ebx
80106974:	5e                   	pop    %esi
80106975:	5f                   	pop    %edi
80106976:	5d                   	pop    %ebp
80106977:	c3                   	ret    
80106978:	90                   	nop
80106979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106980:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106983:	31 c0                	xor    %eax,%eax
80106985:	5b                   	pop    %ebx
80106986:	5e                   	pop    %esi
80106987:	5f                   	pop    %edi
80106988:	5d                   	pop    %ebp
80106989:	c3                   	ret    
8010698a:	83 ec 0c             	sub    $0xc,%esp
8010698d:	68 88 7a 10 80       	push   $0x80107a88
80106992:	e8 f9 99 ff ff       	call   80100390 <panic>
80106997:	89 f6                	mov    %esi,%esi
80106999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069a0 <deallocuvm.part.0>:
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	57                   	push   %edi
801069a4:	56                   	push   %esi
801069a5:	53                   	push   %ebx
801069a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801069ac:	89 c7                	mov    %eax,%edi
801069ae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801069b4:	83 ec 1c             	sub    $0x1c,%esp
801069b7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801069ba:	39 d3                	cmp    %edx,%ebx
801069bc:	73 66                	jae    80106a24 <deallocuvm.part.0+0x84>
801069be:	89 d6                	mov    %edx,%esi
801069c0:	eb 3d                	jmp    801069ff <deallocuvm.part.0+0x5f>
801069c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069c8:	8b 10                	mov    (%eax),%edx
801069ca:	f6 c2 01             	test   $0x1,%dl
801069cd:	74 26                	je     801069f5 <deallocuvm.part.0+0x55>
801069cf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801069d5:	74 58                	je     80106a2f <deallocuvm.part.0+0x8f>
801069d7:	83 ec 0c             	sub    $0xc,%esp
801069da:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801069e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069e3:	52                   	push   %edx
801069e4:	e8 37 bc ff ff       	call   80102620 <kfree>
801069e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069ec:	83 c4 10             	add    $0x10,%esp
801069ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801069f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069fb:	39 f3                	cmp    %esi,%ebx
801069fd:	73 25                	jae    80106a24 <deallocuvm.part.0+0x84>
801069ff:	31 c9                	xor    %ecx,%ecx
80106a01:	89 da                	mov    %ebx,%edx
80106a03:	89 f8                	mov    %edi,%eax
80106a05:	e8 86 fe ff ff       	call   80106890 <walkpgdir>
80106a0a:	85 c0                	test   %eax,%eax
80106a0c:	75 ba                	jne    801069c8 <deallocuvm.part.0+0x28>
80106a0e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106a14:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
80106a1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a20:	39 f3                	cmp    %esi,%ebx
80106a22:	72 db                	jb     801069ff <deallocuvm.part.0+0x5f>
80106a24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a2a:	5b                   	pop    %ebx
80106a2b:	5e                   	pop    %esi
80106a2c:	5f                   	pop    %edi
80106a2d:	5d                   	pop    %ebp
80106a2e:	c3                   	ret    
80106a2f:	83 ec 0c             	sub    $0xc,%esp
80106a32:	68 26 74 10 80       	push   $0x80107426
80106a37:	e8 54 99 ff ff       	call   80100390 <panic>
80106a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a40 <seginit>:
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	83 ec 18             	sub    $0x18,%esp
80106a46:	e8 85 d0 ff ff       	call   80103ad0 <cpuid>
80106a4b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106a51:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106a56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106a5a:	c7 80 b8 2a 11 80 ff 	movl   $0xffff,-0x7feed548(%eax)
80106a61:	ff 00 00 
80106a64:	c7 80 bc 2a 11 80 00 	movl   $0xcf9a00,-0x7feed544(%eax)
80106a6b:	9a cf 00 
80106a6e:	c7 80 c0 2a 11 80 ff 	movl   $0xffff,-0x7feed540(%eax)
80106a75:	ff 00 00 
80106a78:	c7 80 c4 2a 11 80 00 	movl   $0xcf9200,-0x7feed53c(%eax)
80106a7f:	92 cf 00 
80106a82:	c7 80 c8 2a 11 80 ff 	movl   $0xffff,-0x7feed538(%eax)
80106a89:	ff 00 00 
80106a8c:	c7 80 cc 2a 11 80 00 	movl   $0xcffa00,-0x7feed534(%eax)
80106a93:	fa cf 00 
80106a96:	c7 80 d0 2a 11 80 ff 	movl   $0xffff,-0x7feed530(%eax)
80106a9d:	ff 00 00 
80106aa0:	c7 80 d4 2a 11 80 00 	movl   $0xcff200,-0x7feed52c(%eax)
80106aa7:	f2 cf 00 
80106aaa:	05 b0 2a 11 80       	add    $0x80112ab0,%eax
80106aaf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80106ab3:	c1 e8 10             	shr    $0x10,%eax
80106ab6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80106aba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106abd:	0f 01 10             	lgdtl  (%eax)
80106ac0:	c9                   	leave  
80106ac1:	c3                   	ret    
80106ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ad0 <switchkvm>:
80106ad0:	a1 64 57 11 80       	mov    0x80115764,%eax
80106ad5:	55                   	push   %ebp
80106ad6:	89 e5                	mov    %esp,%ebp
80106ad8:	05 00 00 00 80       	add    $0x80000000,%eax
80106add:	0f 22 d8             	mov    %eax,%cr3
80106ae0:	5d                   	pop    %ebp
80106ae1:	c3                   	ret    
80106ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106af0 <switchuvm>:
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
80106af6:	83 ec 1c             	sub    $0x1c,%esp
80106af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106afc:	85 db                	test   %ebx,%ebx
80106afe:	0f 84 cb 00 00 00    	je     80106bcf <switchuvm+0xdf>
80106b04:	8b 43 08             	mov    0x8(%ebx),%eax
80106b07:	85 c0                	test   %eax,%eax
80106b09:	0f 84 da 00 00 00    	je     80106be9 <switchuvm+0xf9>
80106b0f:	8b 43 04             	mov    0x4(%ebx),%eax
80106b12:	85 c0                	test   %eax,%eax
80106b14:	0f 84 c2 00 00 00    	je     80106bdc <switchuvm+0xec>
80106b1a:	e8 61 da ff ff       	call   80104580 <pushcli>
80106b1f:	e8 2c cf ff ff       	call   80103a50 <mycpu>
80106b24:	89 c6                	mov    %eax,%esi
80106b26:	e8 25 cf ff ff       	call   80103a50 <mycpu>
80106b2b:	89 c7                	mov    %eax,%edi
80106b2d:	e8 1e cf ff ff       	call   80103a50 <mycpu>
80106b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b35:	83 c7 08             	add    $0x8,%edi
80106b38:	e8 13 cf ff ff       	call   80103a50 <mycpu>
80106b3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b40:	83 c0 08             	add    $0x8,%eax
80106b43:	ba 67 00 00 00       	mov    $0x67,%edx
80106b48:	c1 e8 18             	shr    $0x18,%eax
80106b4b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106b52:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106b59:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
80106b5f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80106b64:	83 c1 08             	add    $0x8,%ecx
80106b67:	c1 e9 10             	shr    $0x10,%ecx
80106b6a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106b70:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b75:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
80106b7c:	be 10 00 00 00       	mov    $0x10,%esi
80106b81:	e8 ca ce ff ff       	call   80103a50 <mycpu>
80106b86:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
80106b8d:	e8 be ce ff ff       	call   80103a50 <mycpu>
80106b92:	66 89 70 10          	mov    %si,0x10(%eax)
80106b96:	8b 73 08             	mov    0x8(%ebx),%esi
80106b99:	e8 b2 ce ff ff       	call   80103a50 <mycpu>
80106b9e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ba4:	89 70 0c             	mov    %esi,0xc(%eax)
80106ba7:	e8 a4 ce ff ff       	call   80103a50 <mycpu>
80106bac:	66 89 78 6e          	mov    %di,0x6e(%eax)
80106bb0:	b8 28 00 00 00       	mov    $0x28,%eax
80106bb5:	0f 00 d8             	ltr    %ax
80106bb8:	8b 43 04             	mov    0x4(%ebx),%eax
80106bbb:	05 00 00 00 80       	add    $0x80000000,%eax
80106bc0:	0f 22 d8             	mov    %eax,%cr3
80106bc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bc6:	5b                   	pop    %ebx
80106bc7:	5e                   	pop    %esi
80106bc8:	5f                   	pop    %edi
80106bc9:	5d                   	pop    %ebp
80106bca:	e9 f1 d9 ff ff       	jmp    801045c0 <popcli>
80106bcf:	83 ec 0c             	sub    $0xc,%esp
80106bd2:	68 8e 7a 10 80       	push   $0x80107a8e
80106bd7:	e8 b4 97 ff ff       	call   80100390 <panic>
80106bdc:	83 ec 0c             	sub    $0xc,%esp
80106bdf:	68 b9 7a 10 80       	push   $0x80107ab9
80106be4:	e8 a7 97 ff ff       	call   80100390 <panic>
80106be9:	83 ec 0c             	sub    $0xc,%esp
80106bec:	68 a4 7a 10 80       	push   $0x80107aa4
80106bf1:	e8 9a 97 ff ff       	call   80100390 <panic>
80106bf6:	8d 76 00             	lea    0x0(%esi),%esi
80106bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c00 <inituvm>:
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
80106c06:	83 ec 1c             	sub    $0x1c,%esp
80106c09:	8b 75 10             	mov    0x10(%ebp),%esi
80106c0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c0f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106c12:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c1b:	77 49                	ja     80106c66 <inituvm+0x66>
80106c1d:	e8 ae bb ff ff       	call   801027d0 <kalloc>
80106c22:	83 ec 04             	sub    $0x4,%esp
80106c25:	89 c3                	mov    %eax,%ebx
80106c27:	68 00 10 00 00       	push   $0x1000
80106c2c:	6a 00                	push   $0x0
80106c2e:	50                   	push   %eax
80106c2f:	e8 2c db ff ff       	call   80104760 <memset>
80106c34:	58                   	pop    %eax
80106c35:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c3b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c40:	5a                   	pop    %edx
80106c41:	6a 06                	push   $0x6
80106c43:	50                   	push   %eax
80106c44:	31 d2                	xor    %edx,%edx
80106c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c49:	e8 c2 fc ff ff       	call   80106910 <mappages>
80106c4e:	89 75 10             	mov    %esi,0x10(%ebp)
80106c51:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106c54:	83 c4 10             	add    $0x10,%esp
80106c57:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c5d:	5b                   	pop    %ebx
80106c5e:	5e                   	pop    %esi
80106c5f:	5f                   	pop    %edi
80106c60:	5d                   	pop    %ebp
80106c61:	e9 aa db ff ff       	jmp    80104810 <memmove>
80106c66:	83 ec 0c             	sub    $0xc,%esp
80106c69:	68 cd 7a 10 80       	push   $0x80107acd
80106c6e:	e8 1d 97 ff ff       	call   80100390 <panic>
80106c73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c80 <loaduvm>:
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 0c             	sub    $0xc,%esp
80106c89:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106c90:	0f 85 91 00 00 00    	jne    80106d27 <loaduvm+0xa7>
80106c96:	8b 75 18             	mov    0x18(%ebp),%esi
80106c99:	31 db                	xor    %ebx,%ebx
80106c9b:	85 f6                	test   %esi,%esi
80106c9d:	75 1a                	jne    80106cb9 <loaduvm+0x39>
80106c9f:	eb 6f                	jmp    80106d10 <loaduvm+0x90>
80106ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ca8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106cb4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106cb7:	76 57                	jbe    80106d10 <loaduvm+0x90>
80106cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cbc:	8b 45 08             	mov    0x8(%ebp),%eax
80106cbf:	31 c9                	xor    %ecx,%ecx
80106cc1:	01 da                	add    %ebx,%edx
80106cc3:	e8 c8 fb ff ff       	call   80106890 <walkpgdir>
80106cc8:	85 c0                	test   %eax,%eax
80106cca:	74 4e                	je     80106d1a <loaduvm+0x9a>
80106ccc:	8b 00                	mov    (%eax),%eax
80106cce:	8b 4d 14             	mov    0x14(%ebp),%ecx
80106cd1:	bf 00 10 00 00       	mov    $0x1000,%edi
80106cd6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cdb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ce1:	0f 46 fe             	cmovbe %esi,%edi
80106ce4:	01 d9                	add    %ebx,%ecx
80106ce6:	05 00 00 00 80       	add    $0x80000000,%eax
80106ceb:	57                   	push   %edi
80106cec:	51                   	push   %ecx
80106ced:	50                   	push   %eax
80106cee:	ff 75 10             	pushl  0x10(%ebp)
80106cf1:	e8 7a af ff ff       	call   80101c70 <readi>
80106cf6:	83 c4 10             	add    $0x10,%esp
80106cf9:	39 f8                	cmp    %edi,%eax
80106cfb:	74 ab                	je     80106ca8 <loaduvm+0x28>
80106cfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d05:	5b                   	pop    %ebx
80106d06:	5e                   	pop    %esi
80106d07:	5f                   	pop    %edi
80106d08:	5d                   	pop    %ebp
80106d09:	c3                   	ret    
80106d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d13:	31 c0                	xor    %eax,%eax
80106d15:	5b                   	pop    %ebx
80106d16:	5e                   	pop    %esi
80106d17:	5f                   	pop    %edi
80106d18:	5d                   	pop    %ebp
80106d19:	c3                   	ret    
80106d1a:	83 ec 0c             	sub    $0xc,%esp
80106d1d:	68 e7 7a 10 80       	push   $0x80107ae7
80106d22:	e8 69 96 ff ff       	call   80100390 <panic>
80106d27:	83 ec 0c             	sub    $0xc,%esp
80106d2a:	68 88 7b 10 80       	push   $0x80107b88
80106d2f:	e8 5c 96 ff ff       	call   80100390 <panic>
80106d34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d40 <allocuvm>:
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
80106d46:	83 ec 1c             	sub    $0x1c,%esp
80106d49:	8b 7d 10             	mov    0x10(%ebp),%edi
80106d4c:	85 ff                	test   %edi,%edi
80106d4e:	0f 88 8e 00 00 00    	js     80106de2 <allocuvm+0xa2>
80106d54:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d57:	0f 82 93 00 00 00    	jb     80106df0 <allocuvm+0xb0>
80106d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d60:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d66:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106d6c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106d6f:	0f 86 7e 00 00 00    	jbe    80106df3 <allocuvm+0xb3>
80106d75:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106d78:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d7b:	eb 42                	jmp    80106dbf <allocuvm+0x7f>
80106d7d:	8d 76 00             	lea    0x0(%esi),%esi
80106d80:	83 ec 04             	sub    $0x4,%esp
80106d83:	68 00 10 00 00       	push   $0x1000
80106d88:	6a 00                	push   $0x0
80106d8a:	50                   	push   %eax
80106d8b:	e8 d0 d9 ff ff       	call   80104760 <memset>
80106d90:	58                   	pop    %eax
80106d91:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d97:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d9c:	5a                   	pop    %edx
80106d9d:	6a 06                	push   $0x6
80106d9f:	50                   	push   %eax
80106da0:	89 da                	mov    %ebx,%edx
80106da2:	89 f8                	mov    %edi,%eax
80106da4:	e8 67 fb ff ff       	call   80106910 <mappages>
80106da9:	83 c4 10             	add    $0x10,%esp
80106dac:	85 c0                	test   %eax,%eax
80106dae:	78 50                	js     80106e00 <allocuvm+0xc0>
80106db0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106db6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106db9:	0f 86 81 00 00 00    	jbe    80106e40 <allocuvm+0x100>
80106dbf:	e8 0c ba ff ff       	call   801027d0 <kalloc>
80106dc4:	85 c0                	test   %eax,%eax
80106dc6:	89 c6                	mov    %eax,%esi
80106dc8:	75 b6                	jne    80106d80 <allocuvm+0x40>
80106dca:	83 ec 0c             	sub    $0xc,%esp
80106dcd:	68 05 7b 10 80       	push   $0x80107b05
80106dd2:	e8 89 98 ff ff       	call   80100660 <cprintf>
80106dd7:	83 c4 10             	add    $0x10,%esp
80106dda:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ddd:	39 45 10             	cmp    %eax,0x10(%ebp)
80106de0:	77 6e                	ja     80106e50 <allocuvm+0x110>
80106de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de5:	31 ff                	xor    %edi,%edi
80106de7:	89 f8                	mov    %edi,%eax
80106de9:	5b                   	pop    %ebx
80106dea:	5e                   	pop    %esi
80106deb:	5f                   	pop    %edi
80106dec:	5d                   	pop    %ebp
80106ded:	c3                   	ret    
80106dee:	66 90                	xchg   %ax,%ax
80106df0:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106df6:	89 f8                	mov    %edi,%eax
80106df8:	5b                   	pop    %ebx
80106df9:	5e                   	pop    %esi
80106dfa:	5f                   	pop    %edi
80106dfb:	5d                   	pop    %ebp
80106dfc:	c3                   	ret    
80106dfd:	8d 76 00             	lea    0x0(%esi),%esi
80106e00:	83 ec 0c             	sub    $0xc,%esp
80106e03:	68 1d 7b 10 80       	push   $0x80107b1d
80106e08:	e8 53 98 ff ff       	call   80100660 <cprintf>
80106e0d:	83 c4 10             	add    $0x10,%esp
80106e10:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e13:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e16:	76 0d                	jbe    80106e25 <allocuvm+0xe5>
80106e18:	89 c1                	mov    %eax,%ecx
80106e1a:	8b 55 10             	mov    0x10(%ebp),%edx
80106e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80106e20:	e8 7b fb ff ff       	call   801069a0 <deallocuvm.part.0>
80106e25:	83 ec 0c             	sub    $0xc,%esp
80106e28:	31 ff                	xor    %edi,%edi
80106e2a:	56                   	push   %esi
80106e2b:	e8 f0 b7 ff ff       	call   80102620 <kfree>
80106e30:	83 c4 10             	add    $0x10,%esp
80106e33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e36:	89 f8                	mov    %edi,%eax
80106e38:	5b                   	pop    %ebx
80106e39:	5e                   	pop    %esi
80106e3a:	5f                   	pop    %edi
80106e3b:	5d                   	pop    %ebp
80106e3c:	c3                   	ret    
80106e3d:	8d 76 00             	lea    0x0(%esi),%esi
80106e40:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106e43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e46:	5b                   	pop    %ebx
80106e47:	89 f8                	mov    %edi,%eax
80106e49:	5e                   	pop    %esi
80106e4a:	5f                   	pop    %edi
80106e4b:	5d                   	pop    %ebp
80106e4c:	c3                   	ret    
80106e4d:	8d 76 00             	lea    0x0(%esi),%esi
80106e50:	89 c1                	mov    %eax,%ecx
80106e52:	8b 55 10             	mov    0x10(%ebp),%edx
80106e55:	8b 45 08             	mov    0x8(%ebp),%eax
80106e58:	31 ff                	xor    %edi,%edi
80106e5a:	e8 41 fb ff ff       	call   801069a0 <deallocuvm.part.0>
80106e5f:	eb 92                	jmp    80106df3 <allocuvm+0xb3>
80106e61:	eb 0d                	jmp    80106e70 <deallocuvm>
80106e63:	90                   	nop
80106e64:	90                   	nop
80106e65:	90                   	nop
80106e66:	90                   	nop
80106e67:	90                   	nop
80106e68:	90                   	nop
80106e69:	90                   	nop
80106e6a:	90                   	nop
80106e6b:	90                   	nop
80106e6c:	90                   	nop
80106e6d:	90                   	nop
80106e6e:	90                   	nop
80106e6f:	90                   	nop

80106e70 <deallocuvm>:
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e76:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e79:	8b 45 08             	mov    0x8(%ebp),%eax
80106e7c:	39 d1                	cmp    %edx,%ecx
80106e7e:	73 10                	jae    80106e90 <deallocuvm+0x20>
80106e80:	5d                   	pop    %ebp
80106e81:	e9 1a fb ff ff       	jmp    801069a0 <deallocuvm.part.0>
80106e86:	8d 76 00             	lea    0x0(%esi),%esi
80106e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106e90:	89 d0                	mov    %edx,%eax
80106e92:	5d                   	pop    %ebp
80106e93:	c3                   	ret    
80106e94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ea0 <freevm>:
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	83 ec 0c             	sub    $0xc,%esp
80106ea9:	8b 75 08             	mov    0x8(%ebp),%esi
80106eac:	85 f6                	test   %esi,%esi
80106eae:	74 59                	je     80106f09 <freevm+0x69>
80106eb0:	31 c9                	xor    %ecx,%ecx
80106eb2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106eb7:	89 f0                	mov    %esi,%eax
80106eb9:	e8 e2 fa ff ff       	call   801069a0 <deallocuvm.part.0>
80106ebe:	89 f3                	mov    %esi,%ebx
80106ec0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ec6:	eb 0f                	jmp    80106ed7 <freevm+0x37>
80106ec8:	90                   	nop
80106ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ed0:	83 c3 04             	add    $0x4,%ebx
80106ed3:	39 fb                	cmp    %edi,%ebx
80106ed5:	74 23                	je     80106efa <freevm+0x5a>
80106ed7:	8b 03                	mov    (%ebx),%eax
80106ed9:	a8 01                	test   $0x1,%al
80106edb:	74 f3                	je     80106ed0 <freevm+0x30>
80106edd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ee2:	83 ec 0c             	sub    $0xc,%esp
80106ee5:	83 c3 04             	add    $0x4,%ebx
80106ee8:	05 00 00 00 80       	add    $0x80000000,%eax
80106eed:	50                   	push   %eax
80106eee:	e8 2d b7 ff ff       	call   80102620 <kfree>
80106ef3:	83 c4 10             	add    $0x10,%esp
80106ef6:	39 fb                	cmp    %edi,%ebx
80106ef8:	75 dd                	jne    80106ed7 <freevm+0x37>
80106efa:	89 75 08             	mov    %esi,0x8(%ebp)
80106efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f00:	5b                   	pop    %ebx
80106f01:	5e                   	pop    %esi
80106f02:	5f                   	pop    %edi
80106f03:	5d                   	pop    %ebp
80106f04:	e9 17 b7 ff ff       	jmp    80102620 <kfree>
80106f09:	83 ec 0c             	sub    $0xc,%esp
80106f0c:	68 39 7b 10 80       	push   $0x80107b39
80106f11:	e8 7a 94 ff ff       	call   80100390 <panic>
80106f16:	8d 76 00             	lea    0x0(%esi),%esi
80106f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f20 <setupkvm>:
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	56                   	push   %esi
80106f24:	53                   	push   %ebx
80106f25:	e8 a6 b8 ff ff       	call   801027d0 <kalloc>
80106f2a:	85 c0                	test   %eax,%eax
80106f2c:	89 c6                	mov    %eax,%esi
80106f2e:	74 42                	je     80106f72 <setupkvm+0x52>
80106f30:	83 ec 04             	sub    $0x4,%esp
80106f33:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106f38:	68 00 10 00 00       	push   $0x1000
80106f3d:	6a 00                	push   $0x0
80106f3f:	50                   	push   %eax
80106f40:	e8 1b d8 ff ff       	call   80104760 <memset>
80106f45:	83 c4 10             	add    $0x10,%esp
80106f48:	8b 43 04             	mov    0x4(%ebx),%eax
80106f4b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f4e:	83 ec 08             	sub    $0x8,%esp
80106f51:	8b 13                	mov    (%ebx),%edx
80106f53:	ff 73 0c             	pushl  0xc(%ebx)
80106f56:	50                   	push   %eax
80106f57:	29 c1                	sub    %eax,%ecx
80106f59:	89 f0                	mov    %esi,%eax
80106f5b:	e8 b0 f9 ff ff       	call   80106910 <mappages>
80106f60:	83 c4 10             	add    $0x10,%esp
80106f63:	85 c0                	test   %eax,%eax
80106f65:	78 19                	js     80106f80 <setupkvm+0x60>
80106f67:	83 c3 10             	add    $0x10,%ebx
80106f6a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f70:	75 d6                	jne    80106f48 <setupkvm+0x28>
80106f72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f75:	89 f0                	mov    %esi,%eax
80106f77:	5b                   	pop    %ebx
80106f78:	5e                   	pop    %esi
80106f79:	5d                   	pop    %ebp
80106f7a:	c3                   	ret    
80106f7b:	90                   	nop
80106f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f80:	83 ec 0c             	sub    $0xc,%esp
80106f83:	56                   	push   %esi
80106f84:	31 f6                	xor    %esi,%esi
80106f86:	e8 15 ff ff ff       	call   80106ea0 <freevm>
80106f8b:	83 c4 10             	add    $0x10,%esp
80106f8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f91:	89 f0                	mov    %esi,%eax
80106f93:	5b                   	pop    %ebx
80106f94:	5e                   	pop    %esi
80106f95:	5d                   	pop    %ebp
80106f96:	c3                   	ret    
80106f97:	89 f6                	mov    %esi,%esi
80106f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fa0 <kvmalloc>:
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	83 ec 08             	sub    $0x8,%esp
80106fa6:	e8 75 ff ff ff       	call   80106f20 <setupkvm>
80106fab:	a3 64 57 11 80       	mov    %eax,0x80115764
80106fb0:	05 00 00 00 80       	add    $0x80000000,%eax
80106fb5:	0f 22 d8             	mov    %eax,%cr3
80106fb8:	c9                   	leave  
80106fb9:	c3                   	ret    
80106fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fc0 <clearpteu>:
80106fc0:	55                   	push   %ebp
80106fc1:	31 c9                	xor    %ecx,%ecx
80106fc3:	89 e5                	mov    %esp,%ebp
80106fc5:	83 ec 08             	sub    $0x8,%esp
80106fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80106fce:	e8 bd f8 ff ff       	call   80106890 <walkpgdir>
80106fd3:	85 c0                	test   %eax,%eax
80106fd5:	74 05                	je     80106fdc <clearpteu+0x1c>
80106fd7:	83 20 fb             	andl   $0xfffffffb,(%eax)
80106fda:	c9                   	leave  
80106fdb:	c3                   	ret    
80106fdc:	83 ec 0c             	sub    $0xc,%esp
80106fdf:	68 4a 7b 10 80       	push   $0x80107b4a
80106fe4:	e8 a7 93 ff ff       	call   80100390 <panic>
80106fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <copyuvm>:
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 1c             	sub    $0x1c,%esp
80106ff9:	e8 22 ff ff ff       	call   80106f20 <setupkvm>
80106ffe:	85 c0                	test   %eax,%eax
80107000:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107003:	0f 84 9f 00 00 00    	je     801070a8 <copyuvm+0xb8>
80107009:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010700c:	85 c9                	test   %ecx,%ecx
8010700e:	0f 84 94 00 00 00    	je     801070a8 <copyuvm+0xb8>
80107014:	31 ff                	xor    %edi,%edi
80107016:	eb 4a                	jmp    80107062 <copyuvm+0x72>
80107018:	90                   	nop
80107019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107020:	83 ec 04             	sub    $0x4,%esp
80107023:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107029:	68 00 10 00 00       	push   $0x1000
8010702e:	53                   	push   %ebx
8010702f:	50                   	push   %eax
80107030:	e8 db d7 ff ff       	call   80104810 <memmove>
80107035:	58                   	pop    %eax
80107036:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010703c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107041:	5a                   	pop    %edx
80107042:	ff 75 e4             	pushl  -0x1c(%ebp)
80107045:	50                   	push   %eax
80107046:	89 fa                	mov    %edi,%edx
80107048:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010704b:	e8 c0 f8 ff ff       	call   80106910 <mappages>
80107050:	83 c4 10             	add    $0x10,%esp
80107053:	85 c0                	test   %eax,%eax
80107055:	78 61                	js     801070b8 <copyuvm+0xc8>
80107057:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010705d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107060:	76 46                	jbe    801070a8 <copyuvm+0xb8>
80107062:	8b 45 08             	mov    0x8(%ebp),%eax
80107065:	31 c9                	xor    %ecx,%ecx
80107067:	89 fa                	mov    %edi,%edx
80107069:	e8 22 f8 ff ff       	call   80106890 <walkpgdir>
8010706e:	85 c0                	test   %eax,%eax
80107070:	74 61                	je     801070d3 <copyuvm+0xe3>
80107072:	8b 00                	mov    (%eax),%eax
80107074:	a8 01                	test   $0x1,%al
80107076:	74 4e                	je     801070c6 <copyuvm+0xd6>
80107078:	89 c3                	mov    %eax,%ebx
8010707a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010707f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107085:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107088:	e8 43 b7 ff ff       	call   801027d0 <kalloc>
8010708d:	85 c0                	test   %eax,%eax
8010708f:	89 c6                	mov    %eax,%esi
80107091:	75 8d                	jne    80107020 <copyuvm+0x30>
80107093:	83 ec 0c             	sub    $0xc,%esp
80107096:	ff 75 e0             	pushl  -0x20(%ebp)
80107099:	e8 02 fe ff ff       	call   80106ea0 <freevm>
8010709e:	83 c4 10             	add    $0x10,%esp
801070a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801070a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ae:	5b                   	pop    %ebx
801070af:	5e                   	pop    %esi
801070b0:	5f                   	pop    %edi
801070b1:	5d                   	pop    %ebp
801070b2:	c3                   	ret    
801070b3:	90                   	nop
801070b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070b8:	83 ec 0c             	sub    $0xc,%esp
801070bb:	56                   	push   %esi
801070bc:	e8 5f b5 ff ff       	call   80102620 <kfree>
801070c1:	83 c4 10             	add    $0x10,%esp
801070c4:	eb cd                	jmp    80107093 <copyuvm+0xa3>
801070c6:	83 ec 0c             	sub    $0xc,%esp
801070c9:	68 6e 7b 10 80       	push   $0x80107b6e
801070ce:	e8 bd 92 ff ff       	call   80100390 <panic>
801070d3:	83 ec 0c             	sub    $0xc,%esp
801070d6:	68 54 7b 10 80       	push   $0x80107b54
801070db:	e8 b0 92 ff ff       	call   80100390 <panic>

801070e0 <uva2ka>:
801070e0:	55                   	push   %ebp
801070e1:	31 c9                	xor    %ecx,%ecx
801070e3:	89 e5                	mov    %esp,%ebp
801070e5:	83 ec 08             	sub    $0x8,%esp
801070e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801070eb:	8b 45 08             	mov    0x8(%ebp),%eax
801070ee:	e8 9d f7 ff ff       	call   80106890 <walkpgdir>
801070f3:	8b 00                	mov    (%eax),%eax
801070f5:	c9                   	leave  
801070f6:	89 c2                	mov    %eax,%edx
801070f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070fd:	83 e2 05             	and    $0x5,%edx
80107100:	05 00 00 00 80       	add    $0x80000000,%eax
80107105:	83 fa 05             	cmp    $0x5,%edx
80107108:	ba 00 00 00 00       	mov    $0x0,%edx
8010710d:	0f 45 c2             	cmovne %edx,%eax
80107110:	c3                   	ret    
80107111:	eb 0d                	jmp    80107120 <copyout>
80107113:	90                   	nop
80107114:	90                   	nop
80107115:	90                   	nop
80107116:	90                   	nop
80107117:	90                   	nop
80107118:	90                   	nop
80107119:	90                   	nop
8010711a:	90                   	nop
8010711b:	90                   	nop
8010711c:	90                   	nop
8010711d:	90                   	nop
8010711e:	90                   	nop
8010711f:	90                   	nop

80107120 <copyout>:
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 1c             	sub    $0x1c,%esp
80107129:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010712c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010712f:	8b 7d 10             	mov    0x10(%ebp),%edi
80107132:	85 db                	test   %ebx,%ebx
80107134:	75 40                	jne    80107176 <copyout+0x56>
80107136:	eb 70                	jmp    801071a8 <copyout+0x88>
80107138:	90                   	nop
80107139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107140:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107143:	89 f1                	mov    %esi,%ecx
80107145:	29 d1                	sub    %edx,%ecx
80107147:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010714d:	39 d9                	cmp    %ebx,%ecx
8010714f:	0f 47 cb             	cmova  %ebx,%ecx
80107152:	29 f2                	sub    %esi,%edx
80107154:	83 ec 04             	sub    $0x4,%esp
80107157:	01 d0                	add    %edx,%eax
80107159:	51                   	push   %ecx
8010715a:	57                   	push   %edi
8010715b:	50                   	push   %eax
8010715c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010715f:	e8 ac d6 ff ff       	call   80104810 <memmove>
80107164:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107167:	83 c4 10             	add    $0x10,%esp
8010716a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
80107170:	01 cf                	add    %ecx,%edi
80107172:	29 cb                	sub    %ecx,%ebx
80107174:	74 32                	je     801071a8 <copyout+0x88>
80107176:	89 d6                	mov    %edx,%esi
80107178:	83 ec 08             	sub    $0x8,%esp
8010717b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010717e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107184:	56                   	push   %esi
80107185:	ff 75 08             	pushl  0x8(%ebp)
80107188:	e8 53 ff ff ff       	call   801070e0 <uva2ka>
8010718d:	83 c4 10             	add    $0x10,%esp
80107190:	85 c0                	test   %eax,%eax
80107192:	75 ac                	jne    80107140 <copyout+0x20>
80107194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010719c:	5b                   	pop    %ebx
8010719d:	5e                   	pop    %esi
8010719e:	5f                   	pop    %edi
8010719f:	5d                   	pop    %ebp
801071a0:	c3                   	ret    
801071a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ab:	31 c0                	xor    %eax,%eax
801071ad:	5b                   	pop    %ebx
801071ae:	5e                   	pop    %esi
801071af:	5f                   	pop    %edi
801071b0:	5d                   	pop    %ebp
801071b1:	c3                   	ret    
