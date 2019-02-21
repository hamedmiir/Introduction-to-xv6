
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
8010002d:	b8 10 32 10 80       	mov    $0x80103210,%eax
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
8010004c:	68 20 72 10 80       	push   $0x80107220
80100051:	68 00 b6 10 80       	push   $0x8010b600
80100056:	e8 15 45 00 00       	call   80104570 <initlock>
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
80100092:	68 27 72 10 80       	push   $0x80107227
80100097:	50                   	push   %eax
80100098:	e8 a3 43 00 00       	call   80104440 <initsleeplock>
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
801000e4:	e8 c7 45 00 00       	call   801046b0 <acquire>
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
80100162:	e8 09 46 00 00       	call   80104770 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 43 00 00       	call   80104480 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 0d 23 00 00       	call   80102490 <iderw>
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
80100193:	68 2e 72 10 80       	push   $0x8010722e
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
801001ae:	e8 6d 43 00 00       	call   80104520 <holdingsleep>
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
801001c4:	e9 c7 22 00 00       	jmp    80102490 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 72 10 80       	push   $0x8010723f
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
801001ef:	e8 2c 43 00 00       	call   80104520 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 42 00 00       	call   801044e0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010020b:	e8 a0 44 00 00       	call   801046b0 <acquire>
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
8010025c:	e9 0f 45 00 00       	jmp    80104770 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 72 10 80       	push   $0x80107246
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
80100280:	e8 4b 18 00 00       	call   80101ad0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
8010028c:	e8 1f 44 00 00       	call   801046b0 <acquire>
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
801002c5:	e8 26 3e 00 00       	call   801040f0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 ff 10 80    	mov    0x8010ffe0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 ff 10 80    	cmp    0x8010ffe4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 70 38 00 00       	call   80103b50 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 60 a5 10 80       	push   $0x8010a560
801002ef:	e8 7c 44 00 00       	call   80104770 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 f4 16 00 00       	call   801019f0 <ilock>
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
8010034d:	e8 1e 44 00 00       	call   80104770 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 96 16 00 00       	call   801019f0 <ilock>
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
801003a9:	e8 f2 26 00 00       	call   80102aa0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 72 10 80       	push   $0x8010724d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 97 7b 10 80 	movl   $0x80107b97,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 b3 41 00 00       	call   80104590 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 72 10 80       	push   $0x80107261
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
8010043a:	e8 f1 59 00 00       	call   80105e30 <uartputc>
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
801004ec:	e8 3f 59 00 00       	call   80105e30 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 33 59 00 00       	call   80105e30 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 27 59 00 00       	call   80105e30 <uartputc>
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
80100524:	e8 47 43 00 00       	call   80104870 <memmove>
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
80100541:	e8 7a 42 00 00       	call   801047c0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 72 10 80       	push   $0x80107265
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
801005b1:	0f b6 92 90 72 10 80 	movzbl -0x7fef8d70(%edx),%edx
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
8010060f:	e8 bc 14 00 00       	call   80101ad0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
8010061b:	e8 90 40 00 00       	call   801046b0 <acquire>
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
80100647:	e8 24 41 00 00       	call   80104770 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 9b 13 00 00       	call   801019f0 <ilock>

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
8010071f:	e8 4c 40 00 00       	call   80104770 <release>
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
801007d0:	ba 78 72 10 80       	mov    $0x80107278,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 60 a5 10 80       	push   $0x8010a560
801007f0:	e8 bb 3e 00 00       	call   801046b0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 72 10 80       	push   $0x8010727f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <InsertNewCmd>:
{
80100810:	55                   	push   %ebp
    int i = input.w , temp_cur = history.mem_count % 5;
80100811:	ba 67 66 66 66       	mov    $0x66666667,%edx
{
80100816:	89 e5                	mov    %esp,%ebp
80100818:	56                   	push   %esi
80100819:	53                   	push   %ebx
8010081a:	81 ec 84 02 00 00    	sub    $0x284,%esp
    int i = input.w , temp_cur = history.mem_count % 5;
80100820:	8b 0d 34 a5 10 80    	mov    0x8010a534,%ecx
80100826:	8b 1d e4 ff 10 80    	mov    0x8010ffe4,%ebx
    memset(temp[temp_cur] ,'\0' ,INPUT_BUF * sizeof(char));
8010082c:	68 80 00 00 00       	push   $0x80
80100831:	6a 00                	push   $0x0
    int i = input.w , temp_cur = history.mem_count % 5;
80100833:	89 c8                	mov    %ecx,%eax
80100835:	f7 ea                	imul   %edx
80100837:	89 c8                	mov    %ecx,%eax
80100839:	c1 f8 1f             	sar    $0x1f,%eax
8010083c:	d1 fa                	sar    %edx
8010083e:	29 c2                	sub    %eax,%edx
80100840:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100843:	29 c1                	sub    %eax,%ecx
    memset(temp[temp_cur] ,'\0' ,INPUT_BUF * sizeof(char));
80100845:	c1 e1 07             	shl    $0x7,%ecx
80100848:	8d b4 0d 78 fd ff ff 	lea    -0x288(%ebp,%ecx,1),%esi
8010084f:	56                   	push   %esi
80100850:	e8 6b 3f 00 00       	call   801047c0 <memset>
    while( i != (input.e - 1)){
80100855:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
8010085a:	83 c4 10             	add    $0x10,%esp
8010085d:	8d 48 ff             	lea    -0x1(%eax),%ecx
    int j = 0;
80100860:	31 c0                	xor    %eax,%eax
    while( i != (input.e - 1)){
80100862:	39 cb                	cmp    %ecx,%ebx
80100864:	74 2d                	je     80100893 <InsertNewCmd+0x83>
80100866:	8d 76 00             	lea    0x0(%esi),%esi
80100869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                  temp[temp_cur][j] = input.buf[i];
80100870:	0f b6 93 60 ff 10 80 	movzbl -0x7fef00a0(%ebx),%edx
                  i = (i + 1) % INPUT_BUF;
80100877:	83 c3 01             	add    $0x1,%ebx
                  temp[temp_cur][j] = input.buf[i];
8010087a:	88 14 06             	mov    %dl,(%esi,%eax,1)
                  i = (i + 1) % INPUT_BUF;
8010087d:	89 da                	mov    %ebx,%edx
                  j++;
8010087f:	83 c0 01             	add    $0x1,%eax
                  i = (i + 1) % INPUT_BUF;
80100882:	c1 fa 1f             	sar    $0x1f,%edx
80100885:	c1 ea 19             	shr    $0x19,%edx
80100888:	01 d3                	add    %edx,%ebx
8010088a:	83 e3 7f             	and    $0x7f,%ebx
8010088d:	29 d3                	sub    %edx,%ebx
    while( i != (input.e - 1)){
8010088f:	39 cb                	cmp    %ecx,%ebx
80100891:	75 dd                	jne    80100870 <InsertNewCmd+0x60>
80100893:	ba 20 a5 10 80       	mov    $0x8010a520,%edx
      history.PervCmd[i] = history.PervCmd[i-1];
80100898:	8b 4a 0c             	mov    0xc(%edx),%ecx
8010089b:	83 ea 04             	sub    $0x4,%edx
8010089e:	89 4a 14             	mov    %ecx,0x14(%edx)
      history.size[i] = history.size[i-1];
801008a1:	8b 4a 2c             	mov    0x2c(%edx),%ecx
801008a4:	89 4a 30             	mov    %ecx,0x30(%edx)
    for(int i = 4 ; i > 0 ; i--){
801008a7:	81 fa 10 a5 10 80    	cmp    $0x8010a510,%edx
801008ad:	75 e9                	jne    80100898 <InsertNewCmd+0x88>
    history.PervCmd[0] = temp[temp_cur];
801008af:	89 35 20 a5 10 80    	mov    %esi,0x8010a520
    history.size[0] = j;
801008b5:	a3 3c a5 10 80       	mov    %eax,0x8010a53c
}
801008ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801008bd:	5b                   	pop    %ebx
801008be:	5e                   	pop    %esi
801008bf:	5d                   	pop    %ebp
801008c0:	c3                   	ret    
801008c1:	eb 0d                	jmp    801008d0 <killLine>
801008c3:	90                   	nop
801008c4:	90                   	nop
801008c5:	90                   	nop
801008c6:	90                   	nop
801008c7:	90                   	nop
801008c8:	90                   	nop
801008c9:	90                   	nop
801008ca:	90                   	nop
801008cb:	90                   	nop
801008cc:	90                   	nop
801008cd:	90                   	nop
801008ce:	90                   	nop
801008cf:	90                   	nop

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
  for(int i = 0; i < history.size[history.cursor] ; i++)
80100940:	a1 38 a5 10 80       	mov    0x8010a538,%eax
80100945:	8b 0c 85 3c a5 10 80 	mov    -0x7fef5ac4(,%eax,4),%ecx
8010094c:	85 c9                	test   %ecx,%ecx
8010094e:	7e 40                	jle    80100990 <fillBuf+0x50>
{
80100950:	55                   	push   %ebp
80100951:	8b 15 e8 ff 10 80    	mov    0x8010ffe8,%edx
80100957:	89 e5                	mov    %esp,%ebp
80100959:	53                   	push   %ebx
        input.buf[input.e++] = history.PervCmd[history.cursor][i];
8010095a:	8b 1c 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%ebx
80100961:	8d 42 01             	lea    0x1(%edx),%eax
80100964:	29 d3                	sub    %edx,%ebx
80100966:	01 c1                	add    %eax,%ecx
80100968:	90                   	nop
80100969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100970:	a3 e8 ff 10 80       	mov    %eax,0x8010ffe8
80100975:	0f b6 54 03 ff       	movzbl -0x1(%ebx,%eax,1),%edx
8010097a:	83 c0 01             	add    $0x1,%eax
8010097d:	88 90 5e ff 10 80    	mov    %dl,-0x7fef00a2(%eax)
  for(int i = 0; i < history.size[history.cursor] ; i++)
80100983:	39 c8                	cmp    %ecx,%eax
80100985:	75 e9                	jne    80100970 <fillBuf+0x30>
}
80100987:	5b                   	pop    %ebx
80100988:	5d                   	pop    %ebp
80100989:	c3                   	ret    
8010098a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100990:	f3 c3                	repz ret 
80100992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <IncCursor>:
  history.cursor = (history.cursor + 1) % 5;
801009a0:	a1 38 a5 10 80       	mov    0x8010a538,%eax
801009a5:	ba 67 66 66 66       	mov    $0x66666667,%edx
{
801009aa:	55                   	push   %ebp
801009ab:	89 e5                	mov    %esp,%ebp
  history.cursor = (history.cursor + 1) % 5;
801009ad:	8d 48 01             	lea    0x1(%eax),%ecx
801009b0:	89 c8                	mov    %ecx,%eax
801009b2:	f7 ea                	imul   %edx
801009b4:	89 c8                	mov    %ecx,%eax
801009b6:	c1 f8 1f             	sar    $0x1f,%eax
801009b9:	d1 fa                	sar    %edx
801009bb:	29 c2                	sub    %eax,%edx
801009bd:	8d 04 92             	lea    (%edx,%edx,4),%eax
801009c0:	29 c1                	sub    %eax,%ecx
      if ( history.cursor == history.mem_count) 
801009c2:	3b 0d 34 a5 10 80    	cmp    0x8010a534,%ecx
  history.cursor = (history.cursor + 1) % 5;
801009c8:	89 0d 38 a5 10 80    	mov    %ecx,0x8010a538
      if ( history.cursor == history.mem_count) 
801009ce:	74 08                	je     801009d8 <IncCursor+0x38>
}
801009d0:	5d                   	pop    %ebp
801009d1:	c3                   	ret    
801009d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009d8:	89 ca                	mov    %ecx,%edx
        history.cursor = history.mem_count - 1;
801009da:	83 ea 01             	sub    $0x1,%edx
801009dd:	89 15 38 a5 10 80    	mov    %edx,0x8010a538
}
801009e3:	5d                   	pop    %ebp
801009e4:	c3                   	ret    
801009e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009f0 <DecCursor>:
  history.cursor = history.cursor - 1;
801009f0:	a1 38 a5 10 80       	mov    0x8010a538,%eax
{
801009f5:	55                   	push   %ebp
  history.cursor = history.cursor - 1;
801009f6:	ba 04 00 00 00       	mov    $0x4,%edx
{
801009fb:	89 e5                	mov    %esp,%ebp
  history.cursor = history.cursor - 1;
801009fd:	83 e8 01             	sub    $0x1,%eax
80100a00:	0f 48 c2             	cmovs  %edx,%eax
80100a03:	a3 38 a5 10 80       	mov    %eax,0x8010a538
}
80100a08:	5d                   	pop    %ebp
80100a09:	c3                   	ret    
80100a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100a10 <printInput>:
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	53                   	push   %ebx
80100a14:	83 ec 04             	sub    $0x4,%esp
  int i = input.w;
80100a17:	8b 1d e4 ff 10 80    	mov    0x8010ffe4,%ebx
      while( i != input.e){ 
80100a1d:	3b 1d e8 ff 10 80    	cmp    0x8010ffe8,%ebx
80100a23:	74 29                	je     80100a4e <printInput+0x3e>
80100a25:	8d 76 00             	lea    0x0(%esi),%esi
        consputc(input.buf[i]);
80100a28:	0f be 83 60 ff 10 80 	movsbl -0x7fef00a0(%ebx),%eax
        i = (i + 1) % INPUT_BUF;
80100a2f:	83 c3 01             	add    $0x1,%ebx
        consputc(input.buf[i]);
80100a32:	e8 d9 f9 ff ff       	call   80100410 <consputc>
        i = (i + 1) % INPUT_BUF;
80100a37:	89 d8                	mov    %ebx,%eax
80100a39:	c1 f8 1f             	sar    $0x1f,%eax
80100a3c:	c1 e8 19             	shr    $0x19,%eax
80100a3f:	01 c3                	add    %eax,%ebx
80100a41:	83 e3 7f             	and    $0x7f,%ebx
80100a44:	29 c3                	sub    %eax,%ebx
      while( i != input.e){ 
80100a46:	39 1d e8 ff 10 80    	cmp    %ebx,0x8010ffe8
80100a4c:	75 da                	jne    80100a28 <printInput+0x18>
}
80100a4e:	83 c4 04             	add    $0x4,%esp
80100a51:	5b                   	pop    %ebx
80100a52:	5d                   	pop    %ebp
80100a53:	c3                   	ret    
80100a54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100a60 <consoleintr>:
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	57                   	push   %edi
80100a64:	56                   	push   %esi
80100a65:	53                   	push   %ebx
  int c, doprocdump = 0;
80100a66:	31 f6                	xor    %esi,%esi
{
80100a68:	83 ec 28             	sub    $0x28,%esp
80100a6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
80100a6e:	68 60 a5 10 80       	push   $0x8010a560
80100a73:	e8 38 3c 00 00       	call   801046b0 <acquire>
  while((c = getc()) >= 0){
80100a78:	83 c4 10             	add    $0x10,%esp
80100a7b:	90                   	nop
80100a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a80:	ff d3                	call   *%ebx
80100a82:	85 c0                	test   %eax,%eax
80100a84:	89 c7                	mov    %eax,%edi
80100a86:	0f 88 c4 00 00 00    	js     80100b50 <consoleintr+0xf0>
    switch(c){
80100a8c:	83 ff 15             	cmp    $0x15,%edi
80100a8f:	0f 84 fb 00 00 00    	je     80100b90 <consoleintr+0x130>
80100a95:	0f 8e d5 00 00 00    	jle    80100b70 <consoleintr+0x110>
80100a9b:	81 ff e2 00 00 00    	cmp    $0xe2,%edi
80100aa1:	0f 84 99 01 00 00    	je     80100c40 <consoleintr+0x1e0>
80100aa7:	81 ff e3 00 00 00    	cmp    $0xe3,%edi
80100aad:	0f 84 1d 01 00 00    	je     80100bd0 <consoleintr+0x170>
80100ab3:	83 ff 7f             	cmp    $0x7f,%edi
80100ab6:	0f 84 e4 00 00 00    	je     80100ba0 <consoleintr+0x140>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100abc:	85 ff                	test   %edi,%edi
80100abe:	74 c0                	je     80100a80 <consoleintr+0x20>
80100ac0:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100ac5:	89 c2                	mov    %eax,%edx
80100ac7:	2b 15 e0 ff 10 80    	sub    0x8010ffe0,%edx
80100acd:	83 fa 7f             	cmp    $0x7f,%edx
80100ad0:	77 ae                	ja     80100a80 <consoleintr+0x20>
80100ad2:	8d 50 01             	lea    0x1(%eax),%edx
80100ad5:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100ad8:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100adb:	89 15 e8 ff 10 80    	mov    %edx,0x8010ffe8
        c = (c == '\r') ? '\n' : c;
80100ae1:	0f 84 01 02 00 00    	je     80100ce8 <consoleintr+0x288>
        input.buf[input.e++ % INPUT_BUF] = c;
80100ae7:	89 f9                	mov    %edi,%ecx
80100ae9:	88 88 60 ff 10 80    	mov    %cl,-0x7fef00a0(%eax)
        consputc(c);
80100aef:	89 f8                	mov    %edi,%eax
80100af1:	e8 1a f9 ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100af6:	83 ff 0a             	cmp    $0xa,%edi
80100af9:	74 19                	je     80100b14 <consoleintr+0xb4>
80100afb:	83 ff 04             	cmp    $0x4,%edi
80100afe:	74 14                	je     80100b14 <consoleintr+0xb4>
80100b00:	a1 e0 ff 10 80       	mov    0x8010ffe0,%eax
80100b05:	83 e8 80             	sub    $0xffffff80,%eax
80100b08:	39 05 e8 ff 10 80    	cmp    %eax,0x8010ffe8
80100b0e:	0f 85 6c ff ff ff    	jne    80100a80 <consoleintr+0x20>
          InsertNewCmd();
80100b14:	e8 f7 fc ff ff       	call   80100810 <InsertNewCmd>
          wakeup(&input.r);
80100b19:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100b1c:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
          history.mem_count++;
80100b21:	83 05 34 a5 10 80 01 	addl   $0x1,0x8010a534
          wakeup(&input.r);
80100b28:	68 e0 ff 10 80       	push   $0x8010ffe0
          input.w = input.e;
80100b2d:	a3 e4 ff 10 80       	mov    %eax,0x8010ffe4
          wakeup(&input.r);
80100b32:	e8 69 37 00 00       	call   801042a0 <wakeup>
80100b37:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100b3a:	ff d3                	call   *%ebx
80100b3c:	85 c0                	test   %eax,%eax
80100b3e:	89 c7                	mov    %eax,%edi
80100b40:	0f 89 46 ff ff ff    	jns    80100a8c <consoleintr+0x2c>
80100b46:	8d 76 00             	lea    0x0(%esi),%esi
80100b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&cons.lock);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	68 60 a5 10 80       	push   $0x8010a560
80100b58:	e8 13 3c 00 00       	call   80104770 <release>
  if(doprocdump) {
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	85 f6                	test   %esi,%esi
80100b62:	0f 85 70 01 00 00    	jne    80100cd8 <consoleintr+0x278>
}
80100b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b6b:	5b                   	pop    %ebx
80100b6c:	5e                   	pop    %esi
80100b6d:	5f                   	pop    %edi
80100b6e:	5d                   	pop    %ebp
80100b6f:	c3                   	ret    
    switch(c){
80100b70:	83 ff 08             	cmp    $0x8,%edi
80100b73:	74 2b                	je     80100ba0 <consoleintr+0x140>
80100b75:	83 ff 10             	cmp    $0x10,%edi
80100b78:	0f 85 3e ff ff ff    	jne    80100abc <consoleintr+0x5c>
      doprocdump = 1;
80100b7e:	be 01 00 00 00       	mov    $0x1,%esi
80100b83:	e9 f8 fe ff ff       	jmp    80100a80 <consoleintr+0x20>
80100b88:	90                   	nop
80100b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      killLine();
80100b90:	e8 3b fd ff ff       	call   801008d0 <killLine>
      break;
80100b95:	e9 e6 fe ff ff       	jmp    80100a80 <consoleintr+0x20>
80100b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
80100ba0:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100ba5:	3b 05 e4 ff 10 80    	cmp    0x8010ffe4,%eax
80100bab:	0f 84 cf fe ff ff    	je     80100a80 <consoleintr+0x20>
        input.e--;
80100bb1:	83 e8 01             	sub    $0x1,%eax
80100bb4:	a3 e8 ff 10 80       	mov    %eax,0x8010ffe8
        consputc(BACKSPACE);
80100bb9:	b8 00 01 00 00       	mov    $0x100,%eax
80100bbe:	e8 4d f8 ff ff       	call   80100410 <consputc>
80100bc3:	e9 b8 fe ff ff       	jmp    80100a80 <consoleintr+0x20>
80100bc8:	90                   	nop
80100bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if ( history.mem_count == 0) 
80100bd0:	a1 34 a5 10 80       	mov    0x8010a534,%eax
80100bd5:	85 c0                	test   %eax,%eax
80100bd7:	0f 84 a3 fe ff ff    	je     80100a80 <consoleintr+0x20>
      killLine();
80100bdd:	e8 ee fc ff ff       	call   801008d0 <killLine>
  if (history.cursor < 0)
80100be2:	a1 38 a5 10 80       	mov    0x8010a538,%eax
80100be7:	83 e8 01             	sub    $0x1,%eax
80100bea:	0f 88 10 01 00 00    	js     80100d00 <consoleintr+0x2a0>
  history.cursor = history.cursor - 1;
80100bf0:	a3 38 a5 10 80       	mov    %eax,0x8010a538
  for(int i = 0; i < history.size[history.cursor] ; i++)
80100bf5:	8b 0c 85 3c a5 10 80 	mov    -0x7fef5ac4(,%eax,4),%ecx
80100bfc:	85 c9                	test   %ecx,%ecx
80100bfe:	7e 2f                	jle    80100c2f <consoleintr+0x1cf>
80100c00:	8b 15 e8 ff 10 80    	mov    0x8010ffe8,%edx
        input.buf[input.e++] = history.PervCmd[history.cursor][i];
80100c06:	8b 3c 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edi
80100c0d:	8d 42 01             	lea    0x1(%edx),%eax
80100c10:	29 d7                	sub    %edx,%edi
80100c12:	01 c1                	add    %eax,%ecx
80100c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c18:	a3 e8 ff 10 80       	mov    %eax,0x8010ffe8
80100c1d:	0f b6 54 07 ff       	movzbl -0x1(%edi,%eax,1),%edx
80100c22:	83 c0 01             	add    $0x1,%eax
80100c25:	88 90 5e ff 10 80    	mov    %dl,-0x7fef00a2(%eax)
  for(int i = 0; i < history.size[history.cursor] ; i++)
80100c2b:	39 c1                	cmp    %eax,%ecx
80100c2d:	75 e9                	jne    80100c18 <consoleintr+0x1b8>
      printInput();
80100c2f:	e8 dc fd ff ff       	call   80100a10 <printInput>
      break;
80100c34:	e9 47 fe ff ff       	jmp    80100a80 <consoleintr+0x20>
80100c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if ( history.mem_count == 0) 
80100c40:	8b 15 34 a5 10 80    	mov    0x8010a534,%edx
80100c46:	85 d2                	test   %edx,%edx
80100c48:	0f 84 32 fe ff ff    	je     80100a80 <consoleintr+0x20>
      killLine();
80100c4e:	e8 7d fc ff ff       	call   801008d0 <killLine>
  for(int i = 0; i < history.size[history.cursor] ; i++)
80100c53:	8b 3d 38 a5 10 80    	mov    0x8010a538,%edi
80100c59:	8b 14 bd 3c a5 10 80 	mov    -0x7fef5ac4(,%edi,4),%edx
80100c60:	85 d2                	test   %edx,%edx
80100c62:	7e 36                	jle    80100c9a <consoleintr+0x23a>
80100c64:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
        input.buf[input.e++] = history.PervCmd[history.cursor][i];
80100c69:	8b 0c bd 20 a5 10 80 	mov    -0x7fef5ae0(,%edi,4),%ecx
80100c70:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100c73:	01 c2                	add    %eax,%edx
80100c75:	29 c1                	sub    %eax,%ecx
80100c77:	89 f6                	mov    %esi,%esi
80100c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80100c80:	83 c0 01             	add    $0x1,%eax
80100c83:	a3 e8 ff 10 80       	mov    %eax,0x8010ffe8
80100c88:	0f b6 5c 01 ff       	movzbl -0x1(%ecx,%eax,1),%ebx
  for(int i = 0; i < history.size[history.cursor] ; i++)
80100c8d:	39 c2                	cmp    %eax,%edx
        input.buf[input.e++] = history.PervCmd[history.cursor][i];
80100c8f:	88 98 5f ff 10 80    	mov    %bl,-0x7fef00a1(%eax)
  for(int i = 0; i < history.size[history.cursor] ; i++)
80100c95:	75 e9                	jne    80100c80 <consoleintr+0x220>
80100c97:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  history.cursor = (history.cursor + 1) % 5;
80100c9a:	83 c7 01             	add    $0x1,%edi
80100c9d:	b8 67 66 66 66       	mov    $0x66666667,%eax
80100ca2:	f7 ef                	imul   %edi
80100ca4:	89 f8                	mov    %edi,%eax
80100ca6:	c1 f8 1f             	sar    $0x1f,%eax
80100ca9:	d1 fa                	sar    %edx
80100cab:	29 c2                	sub    %eax,%edx
80100cad:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100cb0:	89 fa                	mov    %edi,%edx
80100cb2:	29 c2                	sub    %eax,%edx
      if ( history.cursor == history.mem_count) 
80100cb4:	3b 15 34 a5 10 80    	cmp    0x8010a534,%edx
  history.cursor = (history.cursor + 1) % 5;
80100cba:	89 15 38 a5 10 80    	mov    %edx,0x8010a538
      if ( history.cursor == history.mem_count) 
80100cc0:	0f 85 69 ff ff ff    	jne    80100c2f <consoleintr+0x1cf>
        history.cursor = history.mem_count - 1;
80100cc6:	83 ea 01             	sub    $0x1,%edx
80100cc9:	89 15 38 a5 10 80    	mov    %edx,0x8010a538
80100ccf:	e9 5b ff ff ff       	jmp    80100c2f <consoleintr+0x1cf>
80100cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80100cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100cdb:	5b                   	pop    %ebx
80100cdc:	5e                   	pop    %esi
80100cdd:	5f                   	pop    %edi
80100cde:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100cdf:	e9 9c 36 00 00       	jmp    80104380 <procdump>
80100ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100ce8:	c6 80 60 ff 10 80 0a 	movb   $0xa,-0x7fef00a0(%eax)
        consputc(c);
80100cef:	b8 0a 00 00 00       	mov    $0xa,%eax
80100cf4:	e8 17 f7 ff ff       	call   80100410 <consputc>
80100cf9:	e9 16 fe ff ff       	jmp    80100b14 <consoleintr+0xb4>
80100cfe:	66 90                	xchg   %ax,%ax
    history.cursor = 4;
80100d00:	c7 05 38 a5 10 80 04 	movl   $0x4,0x8010a538
80100d07:	00 00 00 
80100d0a:	b8 04 00 00 00       	mov    $0x4,%eax
80100d0f:	e9 e1 fe ff ff       	jmp    80100bf5 <consoleintr+0x195>
80100d14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100d20 <consoleinit>:

void
consoleinit(void)
{
80100d20:	55                   	push   %ebp
80100d21:	89 e5                	mov    %esp,%ebp
80100d23:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100d26:	68 88 72 10 80       	push   $0x80107288
80100d2b:	68 60 a5 10 80       	push   $0x8010a560
80100d30:	e8 3b 38 00 00       	call   80104570 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100d35:	58                   	pop    %eax
80100d36:	5a                   	pop    %edx
80100d37:	6a 00                	push   $0x0
80100d39:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100d3b:	c7 05 ac 09 11 80 00 	movl   $0x80100600,0x801109ac
80100d42:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100d45:	c7 05 a8 09 11 80 70 	movl   $0x80100270,0x801109a8
80100d4c:	02 10 80 
  cons.locking = 1;
80100d4f:	c7 05 94 a5 10 80 01 	movl   $0x1,0x8010a594
80100d56:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100d59:	e8 e2 18 00 00       	call   80102640 <ioapicenable>
}
80100d5e:	83 c4 10             	add    $0x10,%esp
80100d61:	c9                   	leave  
80100d62:	c3                   	ret    
80100d63:	66 90                	xchg   %ax,%ax
80100d65:	66 90                	xchg   %ax,%ax
80100d67:	66 90                	xchg   %ax,%ax
80100d69:	66 90                	xchg   %ax,%ax
80100d6b:	66 90                	xchg   %ax,%ax
80100d6d:	66 90                	xchg   %ax,%ax
80100d6f:	90                   	nop

80100d70 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	57                   	push   %edi
80100d74:	56                   	push   %esi
80100d75:	53                   	push   %ebx
80100d76:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100d7c:	e8 cf 2d 00 00       	call   80103b50 <myproc>
80100d81:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100d87:	e8 84 21 00 00       	call   80102f10 <begin_op>

  if((ip = namei(path)) == 0){
80100d8c:	83 ec 0c             	sub    $0xc,%esp
80100d8f:	ff 75 08             	pushl  0x8(%ebp)
80100d92:	e8 b9 14 00 00       	call   80102250 <namei>
80100d97:	83 c4 10             	add    $0x10,%esp
80100d9a:	85 c0                	test   %eax,%eax
80100d9c:	0f 84 91 01 00 00    	je     80100f33 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100da2:	83 ec 0c             	sub    $0xc,%esp
80100da5:	89 c3                	mov    %eax,%ebx
80100da7:	50                   	push   %eax
80100da8:	e8 43 0c 00 00       	call   801019f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100dad:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100db3:	6a 34                	push   $0x34
80100db5:	6a 00                	push   $0x0
80100db7:	50                   	push   %eax
80100db8:	53                   	push   %ebx
80100db9:	e8 12 0f 00 00       	call   80101cd0 <readi>
80100dbe:	83 c4 20             	add    $0x20,%esp
80100dc1:	83 f8 34             	cmp    $0x34,%eax
80100dc4:	74 22                	je     80100de8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100dc6:	83 ec 0c             	sub    $0xc,%esp
80100dc9:	53                   	push   %ebx
80100dca:	e8 b1 0e 00 00       	call   80101c80 <iunlockput>
    end_op();
80100dcf:	e8 ac 21 00 00       	call   80102f80 <end_op>
80100dd4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100dd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ddf:	5b                   	pop    %ebx
80100de0:	5e                   	pop    %esi
80100de1:	5f                   	pop    %edi
80100de2:	5d                   	pop    %ebp
80100de3:	c3                   	ret    
80100de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100de8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100def:	45 4c 46 
80100df2:	75 d2                	jne    80100dc6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100df4:	e8 87 61 00 00       	call   80106f80 <setupkvm>
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100e01:	74 c3                	je     80100dc6 <exec+0x56>
  sz = 0;
80100e03:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e05:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100e0c:	00 
80100e0d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100e13:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100e19:	0f 84 8c 02 00 00    	je     801010ab <exec+0x33b>
80100e1f:	31 f6                	xor    %esi,%esi
80100e21:	eb 7f                	jmp    80100ea2 <exec+0x132>
80100e23:	90                   	nop
80100e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100e28:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100e2f:	75 63                	jne    80100e94 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100e31:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100e37:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100e3d:	0f 82 86 00 00 00    	jb     80100ec9 <exec+0x159>
80100e43:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100e49:	72 7e                	jb     80100ec9 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100e4b:	83 ec 04             	sub    $0x4,%esp
80100e4e:	50                   	push   %eax
80100e4f:	57                   	push   %edi
80100e50:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100e56:	e8 45 5f 00 00       	call   80106da0 <allocuvm>
80100e5b:	83 c4 10             	add    $0x10,%esp
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	89 c7                	mov    %eax,%edi
80100e62:	74 65                	je     80100ec9 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100e64:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100e6a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100e6f:	75 58                	jne    80100ec9 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100e71:	83 ec 0c             	sub    $0xc,%esp
80100e74:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100e7a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100e80:	53                   	push   %ebx
80100e81:	50                   	push   %eax
80100e82:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100e88:	e8 53 5e 00 00       	call   80106ce0 <loaduvm>
80100e8d:	83 c4 20             	add    $0x20,%esp
80100e90:	85 c0                	test   %eax,%eax
80100e92:	78 35                	js     80100ec9 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e94:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100e9b:	83 c6 01             	add    $0x1,%esi
80100e9e:	39 f0                	cmp    %esi,%eax
80100ea0:	7e 3d                	jle    80100edf <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ea2:	89 f0                	mov    %esi,%eax
80100ea4:	6a 20                	push   $0x20
80100ea6:	c1 e0 05             	shl    $0x5,%eax
80100ea9:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100eaf:	50                   	push   %eax
80100eb0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100eb6:	50                   	push   %eax
80100eb7:	53                   	push   %ebx
80100eb8:	e8 13 0e 00 00       	call   80101cd0 <readi>
80100ebd:	83 c4 10             	add    $0x10,%esp
80100ec0:	83 f8 20             	cmp    $0x20,%eax
80100ec3:	0f 84 5f ff ff ff    	je     80100e28 <exec+0xb8>
    freevm(pgdir);
80100ec9:	83 ec 0c             	sub    $0xc,%esp
80100ecc:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ed2:	e8 29 60 00 00       	call   80106f00 <freevm>
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	e9 e7 fe ff ff       	jmp    80100dc6 <exec+0x56>
80100edf:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100ee5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100eeb:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100ef1:	83 ec 0c             	sub    $0xc,%esp
80100ef4:	53                   	push   %ebx
80100ef5:	e8 86 0d 00 00       	call   80101c80 <iunlockput>
  end_op();
80100efa:	e8 81 20 00 00       	call   80102f80 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100eff:	83 c4 0c             	add    $0xc,%esp
80100f02:	56                   	push   %esi
80100f03:	57                   	push   %edi
80100f04:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100f0a:	e8 91 5e 00 00       	call   80106da0 <allocuvm>
80100f0f:	83 c4 10             	add    $0x10,%esp
80100f12:	85 c0                	test   %eax,%eax
80100f14:	89 c6                	mov    %eax,%esi
80100f16:	75 3a                	jne    80100f52 <exec+0x1e2>
    freevm(pgdir);
80100f18:	83 ec 0c             	sub    $0xc,%esp
80100f1b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100f21:	e8 da 5f 00 00       	call   80106f00 <freevm>
80100f26:	83 c4 10             	add    $0x10,%esp
  return -1;
80100f29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f2e:	e9 a9 fe ff ff       	jmp    80100ddc <exec+0x6c>
    end_op();
80100f33:	e8 48 20 00 00       	call   80102f80 <end_op>
    cprintf("exec: fail\n");
80100f38:	83 ec 0c             	sub    $0xc,%esp
80100f3b:	68 a1 72 10 80       	push   $0x801072a1
80100f40:	e8 1b f7 ff ff       	call   80100660 <cprintf>
    return -1;
80100f45:	83 c4 10             	add    $0x10,%esp
80100f48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f4d:	e9 8a fe ff ff       	jmp    80100ddc <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f52:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100f58:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100f5b:	31 ff                	xor    %edi,%edi
80100f5d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f5f:	50                   	push   %eax
80100f60:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100f66:	e8 b5 60 00 00       	call   80107020 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f6e:	83 c4 10             	add    $0x10,%esp
80100f71:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100f77:	8b 00                	mov    (%eax),%eax
80100f79:	85 c0                	test   %eax,%eax
80100f7b:	74 70                	je     80100fed <exec+0x27d>
80100f7d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100f83:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100f89:	eb 0a                	jmp    80100f95 <exec+0x225>
80100f8b:	90                   	nop
80100f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100f90:	83 ff 20             	cmp    $0x20,%edi
80100f93:	74 83                	je     80100f18 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f95:	83 ec 0c             	sub    $0xc,%esp
80100f98:	50                   	push   %eax
80100f99:	e8 42 3a 00 00       	call   801049e0 <strlen>
80100f9e:	f7 d0                	not    %eax
80100fa0:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fa5:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fa6:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fa9:	ff 34 b8             	pushl  (%eax,%edi,4)
80100fac:	e8 2f 3a 00 00       	call   801049e0 <strlen>
80100fb1:	83 c0 01             	add    $0x1,%eax
80100fb4:	50                   	push   %eax
80100fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fb8:	ff 34 b8             	pushl  (%eax,%edi,4)
80100fbb:	53                   	push   %ebx
80100fbc:	56                   	push   %esi
80100fbd:	e8 be 61 00 00       	call   80107180 <copyout>
80100fc2:	83 c4 20             	add    $0x20,%esp
80100fc5:	85 c0                	test   %eax,%eax
80100fc7:	0f 88 4b ff ff ff    	js     80100f18 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100fd0:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100fd7:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100fda:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100fe0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100fe3:	85 c0                	test   %eax,%eax
80100fe5:	75 a9                	jne    80100f90 <exec+0x220>
80100fe7:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100fed:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100ff4:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100ff6:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100ffd:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80101001:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80101008:	ff ff ff 
  ustack[1] = argc;
8010100b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101011:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80101013:	83 c0 0c             	add    $0xc,%eax
80101016:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101018:	50                   	push   %eax
80101019:	52                   	push   %edx
8010101a:	53                   	push   %ebx
8010101b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101021:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101027:	e8 54 61 00 00       	call   80107180 <copyout>
8010102c:	83 c4 10             	add    $0x10,%esp
8010102f:	85 c0                	test   %eax,%eax
80101031:	0f 88 e1 fe ff ff    	js     80100f18 <exec+0x1a8>
  for(last=s=path; *s; s++)
80101037:	8b 45 08             	mov    0x8(%ebp),%eax
8010103a:	0f b6 00             	movzbl (%eax),%eax
8010103d:	84 c0                	test   %al,%al
8010103f:	74 17                	je     80101058 <exec+0x2e8>
80101041:	8b 55 08             	mov    0x8(%ebp),%edx
80101044:	89 d1                	mov    %edx,%ecx
80101046:	83 c1 01             	add    $0x1,%ecx
80101049:	3c 2f                	cmp    $0x2f,%al
8010104b:	0f b6 01             	movzbl (%ecx),%eax
8010104e:	0f 44 d1             	cmove  %ecx,%edx
80101051:	84 c0                	test   %al,%al
80101053:	75 f1                	jne    80101046 <exec+0x2d6>
80101055:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101058:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
8010105e:	50                   	push   %eax
8010105f:	6a 10                	push   $0x10
80101061:	ff 75 08             	pushl  0x8(%ebp)
80101064:	89 f8                	mov    %edi,%eax
80101066:	83 c0 6c             	add    $0x6c,%eax
80101069:	50                   	push   %eax
8010106a:	e8 31 39 00 00       	call   801049a0 <safestrcpy>
  curproc->pgdir = pgdir;
8010106f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80101075:	89 f9                	mov    %edi,%ecx
80101077:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
8010107a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
8010107d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
8010107f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80101082:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80101088:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
8010108b:	8b 41 18             	mov    0x18(%ecx),%eax
8010108e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80101091:	89 0c 24             	mov    %ecx,(%esp)
80101094:	e8 b7 5a 00 00       	call   80106b50 <switchuvm>
  freevm(oldpgdir);
80101099:	89 3c 24             	mov    %edi,(%esp)
8010109c:	e8 5f 5e 00 00       	call   80106f00 <freevm>
  return 0;
801010a1:	83 c4 10             	add    $0x10,%esp
801010a4:	31 c0                	xor    %eax,%eax
801010a6:	e9 31 fd ff ff       	jmp    80100ddc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010ab:	be 00 20 00 00       	mov    $0x2000,%esi
801010b0:	e9 3c fe ff ff       	jmp    80100ef1 <exec+0x181>
801010b5:	66 90                	xchg   %ax,%ax
801010b7:	66 90                	xchg   %ax,%ax
801010b9:	66 90                	xchg   %ax,%ax
801010bb:	66 90                	xchg   %ax,%ax
801010bd:	66 90                	xchg   %ax,%ax
801010bf:	90                   	nop

801010c0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801010c6:	68 ad 72 10 80       	push   $0x801072ad
801010cb:	68 00 00 11 80       	push   $0x80110000
801010d0:	e8 9b 34 00 00       	call   80104570 <initlock>
}
801010d5:	83 c4 10             	add    $0x10,%esp
801010d8:	c9                   	leave  
801010d9:	c3                   	ret    
801010da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010e0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010e4:	bb 34 00 11 80       	mov    $0x80110034,%ebx
{
801010e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801010ec:	68 00 00 11 80       	push   $0x80110000
801010f1:	e8 ba 35 00 00       	call   801046b0 <acquire>
801010f6:	83 c4 10             	add    $0x10,%esp
801010f9:	eb 10                	jmp    8010110b <filealloc+0x2b>
801010fb:	90                   	nop
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101100:	83 c3 18             	add    $0x18,%ebx
80101103:	81 fb 94 09 11 80    	cmp    $0x80110994,%ebx
80101109:	73 25                	jae    80101130 <filealloc+0x50>
    if(f->ref == 0){
8010110b:	8b 43 04             	mov    0x4(%ebx),%eax
8010110e:	85 c0                	test   %eax,%eax
80101110:	75 ee                	jne    80101100 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101112:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101115:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010111c:	68 00 00 11 80       	push   $0x80110000
80101121:	e8 4a 36 00 00       	call   80104770 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101126:	89 d8                	mov    %ebx,%eax
      return f;
80101128:	83 c4 10             	add    $0x10,%esp
}
8010112b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010112e:	c9                   	leave  
8010112f:	c3                   	ret    
  release(&ftable.lock);
80101130:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101133:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101135:	68 00 00 11 80       	push   $0x80110000
8010113a:	e8 31 36 00 00       	call   80104770 <release>
}
8010113f:	89 d8                	mov    %ebx,%eax
  return 0;
80101141:	83 c4 10             	add    $0x10,%esp
}
80101144:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101147:	c9                   	leave  
80101148:	c3                   	ret    
80101149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101150 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	53                   	push   %ebx
80101154:	83 ec 10             	sub    $0x10,%esp
80101157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010115a:	68 00 00 11 80       	push   $0x80110000
8010115f:	e8 4c 35 00 00       	call   801046b0 <acquire>
  if(f->ref < 1)
80101164:	8b 43 04             	mov    0x4(%ebx),%eax
80101167:	83 c4 10             	add    $0x10,%esp
8010116a:	85 c0                	test   %eax,%eax
8010116c:	7e 1a                	jle    80101188 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010116e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101171:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101174:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101177:	68 00 00 11 80       	push   $0x80110000
8010117c:	e8 ef 35 00 00       	call   80104770 <release>
  return f;
}
80101181:	89 d8                	mov    %ebx,%eax
80101183:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101186:	c9                   	leave  
80101187:	c3                   	ret    
    panic("filedup");
80101188:	83 ec 0c             	sub    $0xc,%esp
8010118b:	68 b4 72 10 80       	push   $0x801072b4
80101190:	e8 fb f1 ff ff       	call   80100390 <panic>
80101195:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801011a0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	57                   	push   %edi
801011a4:	56                   	push   %esi
801011a5:	53                   	push   %ebx
801011a6:	83 ec 28             	sub    $0x28,%esp
801011a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801011ac:	68 00 00 11 80       	push   $0x80110000
801011b1:	e8 fa 34 00 00       	call   801046b0 <acquire>
  if(f->ref < 1)
801011b6:	8b 43 04             	mov    0x4(%ebx),%eax
801011b9:	83 c4 10             	add    $0x10,%esp
801011bc:	85 c0                	test   %eax,%eax
801011be:	0f 8e 9b 00 00 00    	jle    8010125f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
801011c4:	83 e8 01             	sub    $0x1,%eax
801011c7:	85 c0                	test   %eax,%eax
801011c9:	89 43 04             	mov    %eax,0x4(%ebx)
801011cc:	74 1a                	je     801011e8 <fileclose+0x48>
    release(&ftable.lock);
801011ce:	c7 45 08 00 00 11 80 	movl   $0x80110000,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801011d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011d8:	5b                   	pop    %ebx
801011d9:	5e                   	pop    %esi
801011da:	5f                   	pop    %edi
801011db:	5d                   	pop    %ebp
    release(&ftable.lock);
801011dc:	e9 8f 35 00 00       	jmp    80104770 <release>
801011e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
801011e8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
801011ec:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
801011ee:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801011f1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
801011f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801011fa:	88 45 e7             	mov    %al,-0x19(%ebp)
801011fd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101200:	68 00 00 11 80       	push   $0x80110000
  ff = *f;
80101205:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101208:	e8 63 35 00 00       	call   80104770 <release>
  if(ff.type == FD_PIPE)
8010120d:	83 c4 10             	add    $0x10,%esp
80101210:	83 ff 01             	cmp    $0x1,%edi
80101213:	74 13                	je     80101228 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80101215:	83 ff 02             	cmp    $0x2,%edi
80101218:	74 26                	je     80101240 <fileclose+0xa0>
}
8010121a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010121d:	5b                   	pop    %ebx
8010121e:	5e                   	pop    %esi
8010121f:	5f                   	pop    %edi
80101220:	5d                   	pop    %ebp
80101221:	c3                   	ret    
80101222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101228:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010122c:	83 ec 08             	sub    $0x8,%esp
8010122f:	53                   	push   %ebx
80101230:	56                   	push   %esi
80101231:	e8 8a 24 00 00       	call   801036c0 <pipeclose>
80101236:	83 c4 10             	add    $0x10,%esp
80101239:	eb df                	jmp    8010121a <fileclose+0x7a>
8010123b:	90                   	nop
8010123c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101240:	e8 cb 1c 00 00       	call   80102f10 <begin_op>
    iput(ff.ip);
80101245:	83 ec 0c             	sub    $0xc,%esp
80101248:	ff 75 e0             	pushl  -0x20(%ebp)
8010124b:	e8 d0 08 00 00       	call   80101b20 <iput>
    end_op();
80101250:	83 c4 10             	add    $0x10,%esp
}
80101253:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101256:	5b                   	pop    %ebx
80101257:	5e                   	pop    %esi
80101258:	5f                   	pop    %edi
80101259:	5d                   	pop    %ebp
    end_op();
8010125a:	e9 21 1d 00 00       	jmp    80102f80 <end_op>
    panic("fileclose");
8010125f:	83 ec 0c             	sub    $0xc,%esp
80101262:	68 bc 72 10 80       	push   $0x801072bc
80101267:	e8 24 f1 ff ff       	call   80100390 <panic>
8010126c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101270 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101270:	55                   	push   %ebp
80101271:	89 e5                	mov    %esp,%ebp
80101273:	53                   	push   %ebx
80101274:	83 ec 04             	sub    $0x4,%esp
80101277:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010127a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010127d:	75 31                	jne    801012b0 <filestat+0x40>
    ilock(f->ip);
8010127f:	83 ec 0c             	sub    $0xc,%esp
80101282:	ff 73 10             	pushl  0x10(%ebx)
80101285:	e8 66 07 00 00       	call   801019f0 <ilock>
    stati(f->ip, st);
8010128a:	58                   	pop    %eax
8010128b:	5a                   	pop    %edx
8010128c:	ff 75 0c             	pushl  0xc(%ebp)
8010128f:	ff 73 10             	pushl  0x10(%ebx)
80101292:	e8 09 0a 00 00       	call   80101ca0 <stati>
    iunlock(f->ip);
80101297:	59                   	pop    %ecx
80101298:	ff 73 10             	pushl  0x10(%ebx)
8010129b:	e8 30 08 00 00       	call   80101ad0 <iunlock>
    return 0;
801012a0:	83 c4 10             	add    $0x10,%esp
801012a3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
801012a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012a8:	c9                   	leave  
801012a9:	c3                   	ret    
801012aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
801012b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012b5:	eb ee                	jmp    801012a5 <filestat+0x35>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012c0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	83 ec 0c             	sub    $0xc,%esp
801012c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801012cc:	8b 75 0c             	mov    0xc(%ebp),%esi
801012cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801012d2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801012d6:	74 60                	je     80101338 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801012d8:	8b 03                	mov    (%ebx),%eax
801012da:	83 f8 01             	cmp    $0x1,%eax
801012dd:	74 41                	je     80101320 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801012df:	83 f8 02             	cmp    $0x2,%eax
801012e2:	75 5b                	jne    8010133f <fileread+0x7f>
    ilock(f->ip);
801012e4:	83 ec 0c             	sub    $0xc,%esp
801012e7:	ff 73 10             	pushl  0x10(%ebx)
801012ea:	e8 01 07 00 00       	call   801019f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801012ef:	57                   	push   %edi
801012f0:	ff 73 14             	pushl  0x14(%ebx)
801012f3:	56                   	push   %esi
801012f4:	ff 73 10             	pushl  0x10(%ebx)
801012f7:	e8 d4 09 00 00       	call   80101cd0 <readi>
801012fc:	83 c4 20             	add    $0x20,%esp
801012ff:	85 c0                	test   %eax,%eax
80101301:	89 c6                	mov    %eax,%esi
80101303:	7e 03                	jle    80101308 <fileread+0x48>
      f->off += r;
80101305:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101308:	83 ec 0c             	sub    $0xc,%esp
8010130b:	ff 73 10             	pushl  0x10(%ebx)
8010130e:	e8 bd 07 00 00       	call   80101ad0 <iunlock>
    return r;
80101313:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101316:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101319:	89 f0                	mov    %esi,%eax
8010131b:	5b                   	pop    %ebx
8010131c:	5e                   	pop    %esi
8010131d:	5f                   	pop    %edi
8010131e:	5d                   	pop    %ebp
8010131f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101320:	8b 43 0c             	mov    0xc(%ebx),%eax
80101323:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101326:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101329:	5b                   	pop    %ebx
8010132a:	5e                   	pop    %esi
8010132b:	5f                   	pop    %edi
8010132c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010132d:	e9 3e 25 00 00       	jmp    80103870 <piperead>
80101332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101338:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010133d:	eb d7                	jmp    80101316 <fileread+0x56>
  panic("fileread");
8010133f:	83 ec 0c             	sub    $0xc,%esp
80101342:	68 c6 72 10 80       	push   $0x801072c6
80101347:	e8 44 f0 ff ff       	call   80100390 <panic>
8010134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101350 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	83 ec 1c             	sub    $0x1c,%esp
80101359:	8b 75 08             	mov    0x8(%ebp),%esi
8010135c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010135f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101363:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101366:	8b 45 10             	mov    0x10(%ebp),%eax
80101369:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010136c:	0f 84 aa 00 00 00    	je     8010141c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101372:	8b 06                	mov    (%esi),%eax
80101374:	83 f8 01             	cmp    $0x1,%eax
80101377:	0f 84 c3 00 00 00    	je     80101440 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010137d:	83 f8 02             	cmp    $0x2,%eax
80101380:	0f 85 d9 00 00 00    	jne    8010145f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101389:	31 ff                	xor    %edi,%edi
    while(i < n){
8010138b:	85 c0                	test   %eax,%eax
8010138d:	7f 34                	jg     801013c3 <filewrite+0x73>
8010138f:	e9 9c 00 00 00       	jmp    80101430 <filewrite+0xe0>
80101394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101398:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010139b:	83 ec 0c             	sub    $0xc,%esp
8010139e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801013a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801013a4:	e8 27 07 00 00       	call   80101ad0 <iunlock>
      end_op();
801013a9:	e8 d2 1b 00 00       	call   80102f80 <end_op>
801013ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013b1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801013b4:	39 c3                	cmp    %eax,%ebx
801013b6:	0f 85 96 00 00 00    	jne    80101452 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801013bc:	01 df                	add    %ebx,%edi
    while(i < n){
801013be:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801013c1:	7e 6d                	jle    80101430 <filewrite+0xe0>
      int n1 = n - i;
801013c3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801013c6:	b8 00 06 00 00       	mov    $0x600,%eax
801013cb:	29 fb                	sub    %edi,%ebx
801013cd:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801013d3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801013d6:	e8 35 1b 00 00       	call   80102f10 <begin_op>
      ilock(f->ip);
801013db:	83 ec 0c             	sub    $0xc,%esp
801013de:	ff 76 10             	pushl  0x10(%esi)
801013e1:	e8 0a 06 00 00       	call   801019f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801013e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801013e9:	53                   	push   %ebx
801013ea:	ff 76 14             	pushl  0x14(%esi)
801013ed:	01 f8                	add    %edi,%eax
801013ef:	50                   	push   %eax
801013f0:	ff 76 10             	pushl  0x10(%esi)
801013f3:	e8 d8 09 00 00       	call   80101dd0 <writei>
801013f8:	83 c4 20             	add    $0x20,%esp
801013fb:	85 c0                	test   %eax,%eax
801013fd:	7f 99                	jg     80101398 <filewrite+0x48>
      iunlock(f->ip);
801013ff:	83 ec 0c             	sub    $0xc,%esp
80101402:	ff 76 10             	pushl  0x10(%esi)
80101405:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101408:	e8 c3 06 00 00       	call   80101ad0 <iunlock>
      end_op();
8010140d:	e8 6e 1b 00 00       	call   80102f80 <end_op>
      if(r < 0)
80101412:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101415:	83 c4 10             	add    $0x10,%esp
80101418:	85 c0                	test   %eax,%eax
8010141a:	74 98                	je     801013b4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010141c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010141f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101424:	89 f8                	mov    %edi,%eax
80101426:	5b                   	pop    %ebx
80101427:	5e                   	pop    %esi
80101428:	5f                   	pop    %edi
80101429:	5d                   	pop    %ebp
8010142a:	c3                   	ret    
8010142b:	90                   	nop
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101430:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101433:	75 e7                	jne    8010141c <filewrite+0xcc>
}
80101435:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101438:	89 f8                	mov    %edi,%eax
8010143a:	5b                   	pop    %ebx
8010143b:	5e                   	pop    %esi
8010143c:	5f                   	pop    %edi
8010143d:	5d                   	pop    %ebp
8010143e:	c3                   	ret    
8010143f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101440:	8b 46 0c             	mov    0xc(%esi),%eax
80101443:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101446:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101449:	5b                   	pop    %ebx
8010144a:	5e                   	pop    %esi
8010144b:	5f                   	pop    %edi
8010144c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010144d:	e9 0e 23 00 00       	jmp    80103760 <pipewrite>
        panic("short filewrite");
80101452:	83 ec 0c             	sub    $0xc,%esp
80101455:	68 cf 72 10 80       	push   $0x801072cf
8010145a:	e8 31 ef ff ff       	call   80100390 <panic>
  panic("filewrite");
8010145f:	83 ec 0c             	sub    $0xc,%esp
80101462:	68 d5 72 10 80       	push   $0x801072d5
80101467:	e8 24 ef ff ff       	call   80100390 <panic>
8010146c:	66 90                	xchg   %ax,%ax
8010146e:	66 90                	xchg   %ax,%ax

80101470 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	53                   	push   %ebx
80101476:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101479:	8b 0d 00 0a 11 80    	mov    0x80110a00,%ecx
{
8010147f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101482:	85 c9                	test   %ecx,%ecx
80101484:	0f 84 87 00 00 00    	je     80101511 <balloc+0xa1>
8010148a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101491:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101494:	83 ec 08             	sub    $0x8,%esp
80101497:	89 f0                	mov    %esi,%eax
80101499:	c1 f8 0c             	sar    $0xc,%eax
8010149c:	03 05 18 0a 11 80    	add    0x80110a18,%eax
801014a2:	50                   	push   %eax
801014a3:	ff 75 d8             	pushl  -0x28(%ebp)
801014a6:	e8 25 ec ff ff       	call   801000d0 <bread>
801014ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014ae:	a1 00 0a 11 80       	mov    0x80110a00,%eax
801014b3:	83 c4 10             	add    $0x10,%esp
801014b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801014b9:	31 c0                	xor    %eax,%eax
801014bb:	eb 2f                	jmp    801014ec <balloc+0x7c>
801014bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801014c0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801014c5:	bb 01 00 00 00       	mov    $0x1,%ebx
801014ca:	83 e1 07             	and    $0x7,%ecx
801014cd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014cf:	89 c1                	mov    %eax,%ecx
801014d1:	c1 f9 03             	sar    $0x3,%ecx
801014d4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801014d9:	85 df                	test   %ebx,%edi
801014db:	89 fa                	mov    %edi,%edx
801014dd:	74 41                	je     80101520 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014df:	83 c0 01             	add    $0x1,%eax
801014e2:	83 c6 01             	add    $0x1,%esi
801014e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801014ea:	74 05                	je     801014f1 <balloc+0x81>
801014ec:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801014ef:	77 cf                	ja     801014c0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014f1:	83 ec 0c             	sub    $0xc,%esp
801014f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801014f7:	e8 e4 ec ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801014fc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101503:	83 c4 10             	add    $0x10,%esp
80101506:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101509:	39 05 00 0a 11 80    	cmp    %eax,0x80110a00
8010150f:	77 80                	ja     80101491 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101511:	83 ec 0c             	sub    $0xc,%esp
80101514:	68 df 72 10 80       	push   $0x801072df
80101519:	e8 72 ee ff ff       	call   80100390 <panic>
8010151e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101520:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101523:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101526:	09 da                	or     %ebx,%edx
80101528:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010152c:	57                   	push   %edi
8010152d:	e8 ae 1b 00 00       	call   801030e0 <log_write>
        brelse(bp);
80101532:	89 3c 24             	mov    %edi,(%esp)
80101535:	e8 a6 ec ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010153a:	58                   	pop    %eax
8010153b:	5a                   	pop    %edx
8010153c:	56                   	push   %esi
8010153d:	ff 75 d8             	pushl  -0x28(%ebp)
80101540:	e8 8b eb ff ff       	call   801000d0 <bread>
80101545:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101547:	8d 40 5c             	lea    0x5c(%eax),%eax
8010154a:	83 c4 0c             	add    $0xc,%esp
8010154d:	68 00 02 00 00       	push   $0x200
80101552:	6a 00                	push   $0x0
80101554:	50                   	push   %eax
80101555:	e8 66 32 00 00       	call   801047c0 <memset>
  log_write(bp);
8010155a:	89 1c 24             	mov    %ebx,(%esp)
8010155d:	e8 7e 1b 00 00       	call   801030e0 <log_write>
  brelse(bp);
80101562:	89 1c 24             	mov    %ebx,(%esp)
80101565:	e8 76 ec ff ff       	call   801001e0 <brelse>
}
8010156a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010156d:	89 f0                	mov    %esi,%eax
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5f                   	pop    %edi
80101572:	5d                   	pop    %ebp
80101573:	c3                   	ret    
80101574:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010157a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101580 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	57                   	push   %edi
80101584:	56                   	push   %esi
80101585:	53                   	push   %ebx
80101586:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101588:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010158a:	bb 54 0a 11 80       	mov    $0x80110a54,%ebx
{
8010158f:	83 ec 28             	sub    $0x28,%esp
80101592:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101595:	68 20 0a 11 80       	push   $0x80110a20
8010159a:	e8 11 31 00 00       	call   801046b0 <acquire>
8010159f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801015a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015a5:	eb 17                	jmp    801015be <iget+0x3e>
801015a7:	89 f6                	mov    %esi,%esi
801015a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801015b0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015b6:	81 fb 74 26 11 80    	cmp    $0x80112674,%ebx
801015bc:	73 22                	jae    801015e0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801015be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801015c1:	85 c9                	test   %ecx,%ecx
801015c3:	7e 04                	jle    801015c9 <iget+0x49>
801015c5:	39 3b                	cmp    %edi,(%ebx)
801015c7:	74 4f                	je     80101618 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801015c9:	85 f6                	test   %esi,%esi
801015cb:	75 e3                	jne    801015b0 <iget+0x30>
801015cd:	85 c9                	test   %ecx,%ecx
801015cf:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801015d2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015d8:	81 fb 74 26 11 80    	cmp    $0x80112674,%ebx
801015de:	72 de                	jb     801015be <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801015e0:	85 f6                	test   %esi,%esi
801015e2:	74 5b                	je     8010163f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801015e4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801015e7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801015e9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801015ec:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801015f3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801015fa:	68 20 0a 11 80       	push   $0x80110a20
801015ff:	e8 6c 31 00 00       	call   80104770 <release>

  return ip;
80101604:	83 c4 10             	add    $0x10,%esp
}
80101607:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010160a:	89 f0                	mov    %esi,%eax
8010160c:	5b                   	pop    %ebx
8010160d:	5e                   	pop    %esi
8010160e:	5f                   	pop    %edi
8010160f:	5d                   	pop    %ebp
80101610:	c3                   	ret    
80101611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101618:	39 53 04             	cmp    %edx,0x4(%ebx)
8010161b:	75 ac                	jne    801015c9 <iget+0x49>
      release(&icache.lock);
8010161d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101620:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101623:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101625:	68 20 0a 11 80       	push   $0x80110a20
      ip->ref++;
8010162a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010162d:	e8 3e 31 00 00       	call   80104770 <release>
      return ip;
80101632:	83 c4 10             	add    $0x10,%esp
}
80101635:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101638:	89 f0                	mov    %esi,%eax
8010163a:	5b                   	pop    %ebx
8010163b:	5e                   	pop    %esi
8010163c:	5f                   	pop    %edi
8010163d:	5d                   	pop    %ebp
8010163e:	c3                   	ret    
    panic("iget: no inodes");
8010163f:	83 ec 0c             	sub    $0xc,%esp
80101642:	68 f5 72 10 80       	push   $0x801072f5
80101647:	e8 44 ed ff ff       	call   80100390 <panic>
8010164c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101650 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	57                   	push   %edi
80101654:	56                   	push   %esi
80101655:	53                   	push   %ebx
80101656:	89 c6                	mov    %eax,%esi
80101658:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010165b:	83 fa 0b             	cmp    $0xb,%edx
8010165e:	77 18                	ja     80101678 <bmap+0x28>
80101660:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101663:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101666:	85 db                	test   %ebx,%ebx
80101668:	74 76                	je     801016e0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010166a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010166d:	89 d8                	mov    %ebx,%eax
8010166f:	5b                   	pop    %ebx
80101670:	5e                   	pop    %esi
80101671:	5f                   	pop    %edi
80101672:	5d                   	pop    %ebp
80101673:	c3                   	ret    
80101674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101678:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010167b:	83 fb 7f             	cmp    $0x7f,%ebx
8010167e:	0f 87 90 00 00 00    	ja     80101714 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101684:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010168a:	8b 00                	mov    (%eax),%eax
8010168c:	85 d2                	test   %edx,%edx
8010168e:	74 70                	je     80101700 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101690:	83 ec 08             	sub    $0x8,%esp
80101693:	52                   	push   %edx
80101694:	50                   	push   %eax
80101695:	e8 36 ea ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010169a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010169e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801016a1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801016a3:	8b 1a                	mov    (%edx),%ebx
801016a5:	85 db                	test   %ebx,%ebx
801016a7:	75 1d                	jne    801016c6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801016a9:	8b 06                	mov    (%esi),%eax
801016ab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801016ae:	e8 bd fd ff ff       	call   80101470 <balloc>
801016b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801016b6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801016b9:	89 c3                	mov    %eax,%ebx
801016bb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801016bd:	57                   	push   %edi
801016be:	e8 1d 1a 00 00       	call   801030e0 <log_write>
801016c3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801016c6:	83 ec 0c             	sub    $0xc,%esp
801016c9:	57                   	push   %edi
801016ca:	e8 11 eb ff ff       	call   801001e0 <brelse>
801016cf:	83 c4 10             	add    $0x10,%esp
}
801016d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016d5:	89 d8                	mov    %ebx,%eax
801016d7:	5b                   	pop    %ebx
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
801016db:	c3                   	ret    
801016dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801016e0:	8b 00                	mov    (%eax),%eax
801016e2:	e8 89 fd ff ff       	call   80101470 <balloc>
801016e7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801016ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801016ed:	89 c3                	mov    %eax,%ebx
}
801016ef:	89 d8                	mov    %ebx,%eax
801016f1:	5b                   	pop    %ebx
801016f2:	5e                   	pop    %esi
801016f3:	5f                   	pop    %edi
801016f4:	5d                   	pop    %ebp
801016f5:	c3                   	ret    
801016f6:	8d 76 00             	lea    0x0(%esi),%esi
801016f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101700:	e8 6b fd ff ff       	call   80101470 <balloc>
80101705:	89 c2                	mov    %eax,%edx
80101707:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010170d:	8b 06                	mov    (%esi),%eax
8010170f:	e9 7c ff ff ff       	jmp    80101690 <bmap+0x40>
  panic("bmap: out of range");
80101714:	83 ec 0c             	sub    $0xc,%esp
80101717:	68 05 73 10 80       	push   $0x80107305
8010171c:	e8 6f ec ff ff       	call   80100390 <panic>
80101721:	eb 0d                	jmp    80101730 <readsb>
80101723:	90                   	nop
80101724:	90                   	nop
80101725:	90                   	nop
80101726:	90                   	nop
80101727:	90                   	nop
80101728:	90                   	nop
80101729:	90                   	nop
8010172a:	90                   	nop
8010172b:	90                   	nop
8010172c:	90                   	nop
8010172d:	90                   	nop
8010172e:	90                   	nop
8010172f:	90                   	nop

80101730 <readsb>:
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	56                   	push   %esi
80101734:	53                   	push   %ebx
80101735:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101738:	83 ec 08             	sub    $0x8,%esp
8010173b:	6a 01                	push   $0x1
8010173d:	ff 75 08             	pushl  0x8(%ebp)
80101740:	e8 8b e9 ff ff       	call   801000d0 <bread>
80101745:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101747:	8d 40 5c             	lea    0x5c(%eax),%eax
8010174a:	83 c4 0c             	add    $0xc,%esp
8010174d:	6a 1c                	push   $0x1c
8010174f:	50                   	push   %eax
80101750:	56                   	push   %esi
80101751:	e8 1a 31 00 00       	call   80104870 <memmove>
  brelse(bp);
80101756:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101759:	83 c4 10             	add    $0x10,%esp
}
8010175c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010175f:	5b                   	pop    %ebx
80101760:	5e                   	pop    %esi
80101761:	5d                   	pop    %ebp
  brelse(bp);
80101762:	e9 79 ea ff ff       	jmp    801001e0 <brelse>
80101767:	89 f6                	mov    %esi,%esi
80101769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101770 <bfree>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	89 d3                	mov    %edx,%ebx
80101777:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101779:	83 ec 08             	sub    $0x8,%esp
8010177c:	68 00 0a 11 80       	push   $0x80110a00
80101781:	50                   	push   %eax
80101782:	e8 a9 ff ff ff       	call   80101730 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101787:	58                   	pop    %eax
80101788:	5a                   	pop    %edx
80101789:	89 da                	mov    %ebx,%edx
8010178b:	c1 ea 0c             	shr    $0xc,%edx
8010178e:	03 15 18 0a 11 80    	add    0x80110a18,%edx
80101794:	52                   	push   %edx
80101795:	56                   	push   %esi
80101796:	e8 35 e9 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010179b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010179d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801017a0:	ba 01 00 00 00       	mov    $0x1,%edx
801017a5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801017a8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801017ae:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801017b1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801017b3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801017b8:	85 d1                	test   %edx,%ecx
801017ba:	74 25                	je     801017e1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801017bc:	f7 d2                	not    %edx
801017be:	89 c6                	mov    %eax,%esi
  log_write(bp);
801017c0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801017c3:	21 ca                	and    %ecx,%edx
801017c5:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801017c9:	56                   	push   %esi
801017ca:	e8 11 19 00 00       	call   801030e0 <log_write>
  brelse(bp);
801017cf:	89 34 24             	mov    %esi,(%esp)
801017d2:	e8 09 ea ff ff       	call   801001e0 <brelse>
}
801017d7:	83 c4 10             	add    $0x10,%esp
801017da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017dd:	5b                   	pop    %ebx
801017de:	5e                   	pop    %esi
801017df:	5d                   	pop    %ebp
801017e0:	c3                   	ret    
    panic("freeing free block");
801017e1:	83 ec 0c             	sub    $0xc,%esp
801017e4:	68 18 73 10 80       	push   $0x80107318
801017e9:	e8 a2 eb ff ff       	call   80100390 <panic>
801017ee:	66 90                	xchg   %ax,%ax

801017f0 <iinit>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	53                   	push   %ebx
801017f4:	bb 60 0a 11 80       	mov    $0x80110a60,%ebx
801017f9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801017fc:	68 2b 73 10 80       	push   $0x8010732b
80101801:	68 20 0a 11 80       	push   $0x80110a20
80101806:	e8 65 2d 00 00       	call   80104570 <initlock>
8010180b:	83 c4 10             	add    $0x10,%esp
8010180e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101810:	83 ec 08             	sub    $0x8,%esp
80101813:	68 32 73 10 80       	push   $0x80107332
80101818:	53                   	push   %ebx
80101819:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010181f:	e8 1c 2c 00 00       	call   80104440 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	81 fb 80 26 11 80    	cmp    $0x80112680,%ebx
8010182d:	75 e1                	jne    80101810 <iinit+0x20>
  readsb(dev, &sb);
8010182f:	83 ec 08             	sub    $0x8,%esp
80101832:	68 00 0a 11 80       	push   $0x80110a00
80101837:	ff 75 08             	pushl  0x8(%ebp)
8010183a:	e8 f1 fe ff ff       	call   80101730 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010183f:	ff 35 18 0a 11 80    	pushl  0x80110a18
80101845:	ff 35 14 0a 11 80    	pushl  0x80110a14
8010184b:	ff 35 10 0a 11 80    	pushl  0x80110a10
80101851:	ff 35 0c 0a 11 80    	pushl  0x80110a0c
80101857:	ff 35 08 0a 11 80    	pushl  0x80110a08
8010185d:	ff 35 04 0a 11 80    	pushl  0x80110a04
80101863:	ff 35 00 0a 11 80    	pushl  0x80110a00
80101869:	68 98 73 10 80       	push   $0x80107398
8010186e:	e8 ed ed ff ff       	call   80100660 <cprintf>
}
80101873:	83 c4 30             	add    $0x30,%esp
80101876:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101879:	c9                   	leave  
8010187a:	c3                   	ret    
8010187b:	90                   	nop
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101880 <ialloc>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	57                   	push   %edi
80101884:	56                   	push   %esi
80101885:	53                   	push   %ebx
80101886:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101889:	83 3d 08 0a 11 80 01 	cmpl   $0x1,0x80110a08
{
80101890:	8b 45 0c             	mov    0xc(%ebp),%eax
80101893:	8b 75 08             	mov    0x8(%ebp),%esi
80101896:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101899:	0f 86 91 00 00 00    	jbe    80101930 <ialloc+0xb0>
8010189f:	bb 01 00 00 00       	mov    $0x1,%ebx
801018a4:	eb 21                	jmp    801018c7 <ialloc+0x47>
801018a6:	8d 76 00             	lea    0x0(%esi),%esi
801018a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801018b0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801018b3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801018b6:	57                   	push   %edi
801018b7:	e8 24 e9 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801018bc:	83 c4 10             	add    $0x10,%esp
801018bf:	39 1d 08 0a 11 80    	cmp    %ebx,0x80110a08
801018c5:	76 69                	jbe    80101930 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801018c7:	89 d8                	mov    %ebx,%eax
801018c9:	83 ec 08             	sub    $0x8,%esp
801018cc:	c1 e8 03             	shr    $0x3,%eax
801018cf:	03 05 14 0a 11 80    	add    0x80110a14,%eax
801018d5:	50                   	push   %eax
801018d6:	56                   	push   %esi
801018d7:	e8 f4 e7 ff ff       	call   801000d0 <bread>
801018dc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801018de:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801018e0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801018e3:	83 e0 07             	and    $0x7,%eax
801018e6:	c1 e0 06             	shl    $0x6,%eax
801018e9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801018ed:	66 83 39 00          	cmpw   $0x0,(%ecx)
801018f1:	75 bd                	jne    801018b0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801018f3:	83 ec 04             	sub    $0x4,%esp
801018f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801018f9:	6a 40                	push   $0x40
801018fb:	6a 00                	push   $0x0
801018fd:	51                   	push   %ecx
801018fe:	e8 bd 2e 00 00       	call   801047c0 <memset>
      dip->type = type;
80101903:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101907:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010190a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010190d:	89 3c 24             	mov    %edi,(%esp)
80101910:	e8 cb 17 00 00       	call   801030e0 <log_write>
      brelse(bp);
80101915:	89 3c 24             	mov    %edi,(%esp)
80101918:	e8 c3 e8 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010191d:	83 c4 10             	add    $0x10,%esp
}
80101920:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101923:	89 da                	mov    %ebx,%edx
80101925:	89 f0                	mov    %esi,%eax
}
80101927:	5b                   	pop    %ebx
80101928:	5e                   	pop    %esi
80101929:	5f                   	pop    %edi
8010192a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010192b:	e9 50 fc ff ff       	jmp    80101580 <iget>
  panic("ialloc: no inodes");
80101930:	83 ec 0c             	sub    $0xc,%esp
80101933:	68 38 73 10 80       	push   $0x80107338
80101938:	e8 53 ea ff ff       	call   80100390 <panic>
8010193d:	8d 76 00             	lea    0x0(%esi),%esi

80101940 <iupdate>:
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	56                   	push   %esi
80101944:	53                   	push   %ebx
80101945:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101948:	83 ec 08             	sub    $0x8,%esp
8010194b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010194e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101951:	c1 e8 03             	shr    $0x3,%eax
80101954:	03 05 14 0a 11 80    	add    0x80110a14,%eax
8010195a:	50                   	push   %eax
8010195b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010195e:	e8 6d e7 ff ff       	call   801000d0 <bread>
80101963:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101965:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101968:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010196c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010196f:	83 e0 07             	and    $0x7,%eax
80101972:	c1 e0 06             	shl    $0x6,%eax
80101975:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101979:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010197c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101980:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101983:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101987:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010198b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010198f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101993:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101997:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010199a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010199d:	6a 34                	push   $0x34
8010199f:	53                   	push   %ebx
801019a0:	50                   	push   %eax
801019a1:	e8 ca 2e 00 00       	call   80104870 <memmove>
  log_write(bp);
801019a6:	89 34 24             	mov    %esi,(%esp)
801019a9:	e8 32 17 00 00       	call   801030e0 <log_write>
  brelse(bp);
801019ae:	89 75 08             	mov    %esi,0x8(%ebp)
801019b1:	83 c4 10             	add    $0x10,%esp
}
801019b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019b7:	5b                   	pop    %ebx
801019b8:	5e                   	pop    %esi
801019b9:	5d                   	pop    %ebp
  brelse(bp);
801019ba:	e9 21 e8 ff ff       	jmp    801001e0 <brelse>
801019bf:	90                   	nop

801019c0 <idup>:
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	53                   	push   %ebx
801019c4:	83 ec 10             	sub    $0x10,%esp
801019c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801019ca:	68 20 0a 11 80       	push   $0x80110a20
801019cf:	e8 dc 2c 00 00       	call   801046b0 <acquire>
  ip->ref++;
801019d4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019d8:	c7 04 24 20 0a 11 80 	movl   $0x80110a20,(%esp)
801019df:	e8 8c 2d 00 00       	call   80104770 <release>
}
801019e4:	89 d8                	mov    %ebx,%eax
801019e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019e9:	c9                   	leave  
801019ea:	c3                   	ret    
801019eb:	90                   	nop
801019ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019f0 <ilock>:
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	56                   	push   %esi
801019f4:	53                   	push   %ebx
801019f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801019f8:	85 db                	test   %ebx,%ebx
801019fa:	0f 84 b7 00 00 00    	je     80101ab7 <ilock+0xc7>
80101a00:	8b 53 08             	mov    0x8(%ebx),%edx
80101a03:	85 d2                	test   %edx,%edx
80101a05:	0f 8e ac 00 00 00    	jle    80101ab7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101a0b:	8d 43 0c             	lea    0xc(%ebx),%eax
80101a0e:	83 ec 0c             	sub    $0xc,%esp
80101a11:	50                   	push   %eax
80101a12:	e8 69 2a 00 00       	call   80104480 <acquiresleep>
  if(ip->valid == 0){
80101a17:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	85 c0                	test   %eax,%eax
80101a1f:	74 0f                	je     80101a30 <ilock+0x40>
}
80101a21:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a24:	5b                   	pop    %ebx
80101a25:	5e                   	pop    %esi
80101a26:	5d                   	pop    %ebp
80101a27:	c3                   	ret    
80101a28:	90                   	nop
80101a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a30:	8b 43 04             	mov    0x4(%ebx),%eax
80101a33:	83 ec 08             	sub    $0x8,%esp
80101a36:	c1 e8 03             	shr    $0x3,%eax
80101a39:	03 05 14 0a 11 80    	add    0x80110a14,%eax
80101a3f:	50                   	push   %eax
80101a40:	ff 33                	pushl  (%ebx)
80101a42:	e8 89 e6 ff ff       	call   801000d0 <bread>
80101a47:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a49:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a4c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a4f:	83 e0 07             	and    $0x7,%eax
80101a52:	c1 e0 06             	shl    $0x6,%eax
80101a55:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101a59:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a5c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101a5f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101a63:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101a67:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101a6b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101a6f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101a73:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101a77:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101a7b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101a7e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a81:	6a 34                	push   $0x34
80101a83:	50                   	push   %eax
80101a84:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101a87:	50                   	push   %eax
80101a88:	e8 e3 2d 00 00       	call   80104870 <memmove>
    brelse(bp);
80101a8d:	89 34 24             	mov    %esi,(%esp)
80101a90:	e8 4b e7 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101a95:	83 c4 10             	add    $0x10,%esp
80101a98:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101a9d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101aa4:	0f 85 77 ff ff ff    	jne    80101a21 <ilock+0x31>
      panic("ilock: no type");
80101aaa:	83 ec 0c             	sub    $0xc,%esp
80101aad:	68 50 73 10 80       	push   $0x80107350
80101ab2:	e8 d9 e8 ff ff       	call   80100390 <panic>
    panic("ilock");
80101ab7:	83 ec 0c             	sub    $0xc,%esp
80101aba:	68 4a 73 10 80       	push   $0x8010734a
80101abf:	e8 cc e8 ff ff       	call   80100390 <panic>
80101ac4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101aca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101ad0 <iunlock>:
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	56                   	push   %esi
80101ad4:	53                   	push   %ebx
80101ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ad8:	85 db                	test   %ebx,%ebx
80101ada:	74 28                	je     80101b04 <iunlock+0x34>
80101adc:	8d 73 0c             	lea    0xc(%ebx),%esi
80101adf:	83 ec 0c             	sub    $0xc,%esp
80101ae2:	56                   	push   %esi
80101ae3:	e8 38 2a 00 00       	call   80104520 <holdingsleep>
80101ae8:	83 c4 10             	add    $0x10,%esp
80101aeb:	85 c0                	test   %eax,%eax
80101aed:	74 15                	je     80101b04 <iunlock+0x34>
80101aef:	8b 43 08             	mov    0x8(%ebx),%eax
80101af2:	85 c0                	test   %eax,%eax
80101af4:	7e 0e                	jle    80101b04 <iunlock+0x34>
  releasesleep(&ip->lock);
80101af6:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101af9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101afc:	5b                   	pop    %ebx
80101afd:	5e                   	pop    %esi
80101afe:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101aff:	e9 dc 29 00 00       	jmp    801044e0 <releasesleep>
    panic("iunlock");
80101b04:	83 ec 0c             	sub    $0xc,%esp
80101b07:	68 5f 73 10 80       	push   $0x8010735f
80101b0c:	e8 7f e8 ff ff       	call   80100390 <panic>
80101b11:	eb 0d                	jmp    80101b20 <iput>
80101b13:	90                   	nop
80101b14:	90                   	nop
80101b15:	90                   	nop
80101b16:	90                   	nop
80101b17:	90                   	nop
80101b18:	90                   	nop
80101b19:	90                   	nop
80101b1a:	90                   	nop
80101b1b:	90                   	nop
80101b1c:	90                   	nop
80101b1d:	90                   	nop
80101b1e:	90                   	nop
80101b1f:	90                   	nop

80101b20 <iput>:
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	57                   	push   %edi
80101b24:	56                   	push   %esi
80101b25:	53                   	push   %ebx
80101b26:	83 ec 28             	sub    $0x28,%esp
80101b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101b2c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101b2f:	57                   	push   %edi
80101b30:	e8 4b 29 00 00       	call   80104480 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101b35:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101b38:	83 c4 10             	add    $0x10,%esp
80101b3b:	85 d2                	test   %edx,%edx
80101b3d:	74 07                	je     80101b46 <iput+0x26>
80101b3f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101b44:	74 32                	je     80101b78 <iput+0x58>
  releasesleep(&ip->lock);
80101b46:	83 ec 0c             	sub    $0xc,%esp
80101b49:	57                   	push   %edi
80101b4a:	e8 91 29 00 00       	call   801044e0 <releasesleep>
  acquire(&icache.lock);
80101b4f:	c7 04 24 20 0a 11 80 	movl   $0x80110a20,(%esp)
80101b56:	e8 55 2b 00 00       	call   801046b0 <acquire>
  ip->ref--;
80101b5b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b5f:	83 c4 10             	add    $0x10,%esp
80101b62:	c7 45 08 20 0a 11 80 	movl   $0x80110a20,0x8(%ebp)
}
80101b69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6c:	5b                   	pop    %ebx
80101b6d:	5e                   	pop    %esi
80101b6e:	5f                   	pop    %edi
80101b6f:	5d                   	pop    %ebp
  release(&icache.lock);
80101b70:	e9 fb 2b 00 00       	jmp    80104770 <release>
80101b75:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101b78:	83 ec 0c             	sub    $0xc,%esp
80101b7b:	68 20 0a 11 80       	push   $0x80110a20
80101b80:	e8 2b 2b 00 00       	call   801046b0 <acquire>
    int r = ip->ref;
80101b85:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101b88:	c7 04 24 20 0a 11 80 	movl   $0x80110a20,(%esp)
80101b8f:	e8 dc 2b 00 00       	call   80104770 <release>
    if(r == 1){
80101b94:	83 c4 10             	add    $0x10,%esp
80101b97:	83 fe 01             	cmp    $0x1,%esi
80101b9a:	75 aa                	jne    80101b46 <iput+0x26>
80101b9c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101ba2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ba5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101ba8:	89 cf                	mov    %ecx,%edi
80101baa:	eb 0b                	jmp    80101bb7 <iput+0x97>
80101bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101bb3:	39 fe                	cmp    %edi,%esi
80101bb5:	74 19                	je     80101bd0 <iput+0xb0>
    if(ip->addrs[i]){
80101bb7:	8b 16                	mov    (%esi),%edx
80101bb9:	85 d2                	test   %edx,%edx
80101bbb:	74 f3                	je     80101bb0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101bbd:	8b 03                	mov    (%ebx),%eax
80101bbf:	e8 ac fb ff ff       	call   80101770 <bfree>
      ip->addrs[i] = 0;
80101bc4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101bca:	eb e4                	jmp    80101bb0 <iput+0x90>
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101bd0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101bd6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101bd9:	85 c0                	test   %eax,%eax
80101bdb:	75 33                	jne    80101c10 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101bdd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101be0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101be7:	53                   	push   %ebx
80101be8:	e8 53 fd ff ff       	call   80101940 <iupdate>
      ip->type = 0;
80101bed:	31 c0                	xor    %eax,%eax
80101bef:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101bf3:	89 1c 24             	mov    %ebx,(%esp)
80101bf6:	e8 45 fd ff ff       	call   80101940 <iupdate>
      ip->valid = 0;
80101bfb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	e9 3c ff ff ff       	jmp    80101b46 <iput+0x26>
80101c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c10:	83 ec 08             	sub    $0x8,%esp
80101c13:	50                   	push   %eax
80101c14:	ff 33                	pushl  (%ebx)
80101c16:	e8 b5 e4 ff ff       	call   801000d0 <bread>
80101c1b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101c21:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101c27:	8d 70 5c             	lea    0x5c(%eax),%esi
80101c2a:	83 c4 10             	add    $0x10,%esp
80101c2d:	89 cf                	mov    %ecx,%edi
80101c2f:	eb 0e                	jmp    80101c3f <iput+0x11f>
80101c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c38:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101c3b:	39 fe                	cmp    %edi,%esi
80101c3d:	74 0f                	je     80101c4e <iput+0x12e>
      if(a[j])
80101c3f:	8b 16                	mov    (%esi),%edx
80101c41:	85 d2                	test   %edx,%edx
80101c43:	74 f3                	je     80101c38 <iput+0x118>
        bfree(ip->dev, a[j]);
80101c45:	8b 03                	mov    (%ebx),%eax
80101c47:	e8 24 fb ff ff       	call   80101770 <bfree>
80101c4c:	eb ea                	jmp    80101c38 <iput+0x118>
    brelse(bp);
80101c4e:	83 ec 0c             	sub    $0xc,%esp
80101c51:	ff 75 e4             	pushl  -0x1c(%ebp)
80101c54:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c57:	e8 84 e5 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101c5c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101c62:	8b 03                	mov    (%ebx),%eax
80101c64:	e8 07 fb ff ff       	call   80101770 <bfree>
    ip->addrs[NDIRECT] = 0;
80101c69:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101c70:	00 00 00 
80101c73:	83 c4 10             	add    $0x10,%esp
80101c76:	e9 62 ff ff ff       	jmp    80101bdd <iput+0xbd>
80101c7b:	90                   	nop
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c80 <iunlockput>:
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	53                   	push   %ebx
80101c84:	83 ec 10             	sub    $0x10,%esp
80101c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101c8a:	53                   	push   %ebx
80101c8b:	e8 40 fe ff ff       	call   80101ad0 <iunlock>
  iput(ip);
80101c90:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101c93:	83 c4 10             	add    $0x10,%esp
}
80101c96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c99:	c9                   	leave  
  iput(ip);
80101c9a:	e9 81 fe ff ff       	jmp    80101b20 <iput>
80101c9f:	90                   	nop

80101ca0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ca9:	8b 0a                	mov    (%edx),%ecx
80101cab:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101cae:	8b 4a 04             	mov    0x4(%edx),%ecx
80101cb1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101cb4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101cb8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101cbb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101cbf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101cc3:	8b 52 58             	mov    0x58(%edx),%edx
80101cc6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101cc9:	5d                   	pop    %ebp
80101cca:	c3                   	ret    
80101ccb:	90                   	nop
80101ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cd0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	57                   	push   %edi
80101cd4:	56                   	push   %esi
80101cd5:	53                   	push   %ebx
80101cd6:	83 ec 1c             	sub    $0x1c,%esp
80101cd9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101cdf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ce2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ce7:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101cea:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ced:	8b 75 10             	mov    0x10(%ebp),%esi
80101cf0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101cf3:	0f 84 a7 00 00 00    	je     80101da0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101cf9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cfc:	8b 40 58             	mov    0x58(%eax),%eax
80101cff:	39 c6                	cmp    %eax,%esi
80101d01:	0f 87 ba 00 00 00    	ja     80101dc1 <readi+0xf1>
80101d07:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d0a:	89 f9                	mov    %edi,%ecx
80101d0c:	01 f1                	add    %esi,%ecx
80101d0e:	0f 82 ad 00 00 00    	jb     80101dc1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d14:	89 c2                	mov    %eax,%edx
80101d16:	29 f2                	sub    %esi,%edx
80101d18:	39 c8                	cmp    %ecx,%eax
80101d1a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d1d:	31 ff                	xor    %edi,%edi
80101d1f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101d21:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d24:	74 6c                	je     80101d92 <readi+0xc2>
80101d26:	8d 76 00             	lea    0x0(%esi),%esi
80101d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d30:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101d33:	89 f2                	mov    %esi,%edx
80101d35:	c1 ea 09             	shr    $0x9,%edx
80101d38:	89 d8                	mov    %ebx,%eax
80101d3a:	e8 11 f9 ff ff       	call   80101650 <bmap>
80101d3f:	83 ec 08             	sub    $0x8,%esp
80101d42:	50                   	push   %eax
80101d43:	ff 33                	pushl  (%ebx)
80101d45:	e8 86 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d4a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d4d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d4f:	89 f0                	mov    %esi,%eax
80101d51:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d56:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d5b:	83 c4 0c             	add    $0xc,%esp
80101d5e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101d60:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101d64:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101d67:	29 fb                	sub    %edi,%ebx
80101d69:	39 d9                	cmp    %ebx,%ecx
80101d6b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d6e:	53                   	push   %ebx
80101d6f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d70:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101d72:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d75:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101d77:	e8 f4 2a 00 00       	call   80104870 <memmove>
    brelse(bp);
80101d7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d7f:	89 14 24             	mov    %edx,(%esp)
80101d82:	e8 59 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d87:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101d8a:	83 c4 10             	add    $0x10,%esp
80101d8d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101d90:	77 9e                	ja     80101d30 <readi+0x60>
  }
  return n;
80101d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101d95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d98:	5b                   	pop    %ebx
80101d99:	5e                   	pop    %esi
80101d9a:	5f                   	pop    %edi
80101d9b:	5d                   	pop    %ebp
80101d9c:	c3                   	ret    
80101d9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101da0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101da4:	66 83 f8 09          	cmp    $0x9,%ax
80101da8:	77 17                	ja     80101dc1 <readi+0xf1>
80101daa:	8b 04 c5 a0 09 11 80 	mov    -0x7feef660(,%eax,8),%eax
80101db1:	85 c0                	test   %eax,%eax
80101db3:	74 0c                	je     80101dc1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101db5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dbb:	5b                   	pop    %ebx
80101dbc:	5e                   	pop    %esi
80101dbd:	5f                   	pop    %edi
80101dbe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101dbf:	ff e0                	jmp    *%eax
      return -1;
80101dc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dc6:	eb cd                	jmp    80101d95 <readi+0xc5>
80101dc8:	90                   	nop
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101dd0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	57                   	push   %edi
80101dd4:	56                   	push   %esi
80101dd5:	53                   	push   %ebx
80101dd6:	83 ec 1c             	sub    $0x1c,%esp
80101dd9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ddc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101ddf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101de2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101de7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101dea:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ded:	8b 75 10             	mov    0x10(%ebp),%esi
80101df0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101df3:	0f 84 b7 00 00 00    	je     80101eb0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101df9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dfc:	39 70 58             	cmp    %esi,0x58(%eax)
80101dff:	0f 82 eb 00 00 00    	jb     80101ef0 <writei+0x120>
80101e05:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e08:	31 d2                	xor    %edx,%edx
80101e0a:	89 f8                	mov    %edi,%eax
80101e0c:	01 f0                	add    %esi,%eax
80101e0e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101e11:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101e16:	0f 87 d4 00 00 00    	ja     80101ef0 <writei+0x120>
80101e1c:	85 d2                	test   %edx,%edx
80101e1e:	0f 85 cc 00 00 00    	jne    80101ef0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e24:	85 ff                	test   %edi,%edi
80101e26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101e2d:	74 72                	je     80101ea1 <writei+0xd1>
80101e2f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e30:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101e33:	89 f2                	mov    %esi,%edx
80101e35:	c1 ea 09             	shr    $0x9,%edx
80101e38:	89 f8                	mov    %edi,%eax
80101e3a:	e8 11 f8 ff ff       	call   80101650 <bmap>
80101e3f:	83 ec 08             	sub    $0x8,%esp
80101e42:	50                   	push   %eax
80101e43:	ff 37                	pushl  (%edi)
80101e45:	e8 86 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e4a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101e4d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e50:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101e52:	89 f0                	mov    %esi,%eax
80101e54:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e59:	83 c4 0c             	add    $0xc,%esp
80101e5c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e61:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101e63:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101e67:	39 d9                	cmp    %ebx,%ecx
80101e69:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101e6c:	53                   	push   %ebx
80101e6d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e70:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101e72:	50                   	push   %eax
80101e73:	e8 f8 29 00 00       	call   80104870 <memmove>
    log_write(bp);
80101e78:	89 3c 24             	mov    %edi,(%esp)
80101e7b:	e8 60 12 00 00       	call   801030e0 <log_write>
    brelse(bp);
80101e80:	89 3c 24             	mov    %edi,(%esp)
80101e83:	e8 58 e3 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e88:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101e8b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101e8e:	83 c4 10             	add    $0x10,%esp
80101e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e94:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101e97:	77 97                	ja     80101e30 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101e99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e9c:	3b 70 58             	cmp    0x58(%eax),%esi
80101e9f:	77 37                	ja     80101ed8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ea1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea7:	5b                   	pop    %ebx
80101ea8:	5e                   	pop    %esi
80101ea9:	5f                   	pop    %edi
80101eaa:	5d                   	pop    %ebp
80101eab:	c3                   	ret    
80101eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101eb0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101eb4:	66 83 f8 09          	cmp    $0x9,%ax
80101eb8:	77 36                	ja     80101ef0 <writei+0x120>
80101eba:	8b 04 c5 a4 09 11 80 	mov    -0x7feef65c(,%eax,8),%eax
80101ec1:	85 c0                	test   %eax,%eax
80101ec3:	74 2b                	je     80101ef0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101ec5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ecb:	5b                   	pop    %ebx
80101ecc:	5e                   	pop    %esi
80101ecd:	5f                   	pop    %edi
80101ece:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101ecf:	ff e0                	jmp    *%eax
80101ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ed8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101edb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101ede:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ee1:	50                   	push   %eax
80101ee2:	e8 59 fa ff ff       	call   80101940 <iupdate>
80101ee7:	83 c4 10             	add    $0x10,%esp
80101eea:	eb b5                	jmp    80101ea1 <writei+0xd1>
80101eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef5:	eb ad                	jmp    80101ea4 <writei+0xd4>
80101ef7:	89 f6                	mov    %esi,%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101f06:	6a 0e                	push   $0xe
80101f08:	ff 75 0c             	pushl  0xc(%ebp)
80101f0b:	ff 75 08             	pushl  0x8(%ebp)
80101f0e:	e8 cd 29 00 00       	call   801048e0 <strncmp>
}
80101f13:	c9                   	leave  
80101f14:	c3                   	ret    
80101f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 1c             	sub    $0x1c,%esp
80101f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101f2c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101f31:	0f 85 85 00 00 00    	jne    80101fbc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101f37:	8b 53 58             	mov    0x58(%ebx),%edx
80101f3a:	31 ff                	xor    %edi,%edi
80101f3c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f3f:	85 d2                	test   %edx,%edx
80101f41:	74 3e                	je     80101f81 <dirlookup+0x61>
80101f43:	90                   	nop
80101f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f48:	6a 10                	push   $0x10
80101f4a:	57                   	push   %edi
80101f4b:	56                   	push   %esi
80101f4c:	53                   	push   %ebx
80101f4d:	e8 7e fd ff ff       	call   80101cd0 <readi>
80101f52:	83 c4 10             	add    $0x10,%esp
80101f55:	83 f8 10             	cmp    $0x10,%eax
80101f58:	75 55                	jne    80101faf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101f5a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f5f:	74 18                	je     80101f79 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101f61:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f64:	83 ec 04             	sub    $0x4,%esp
80101f67:	6a 0e                	push   $0xe
80101f69:	50                   	push   %eax
80101f6a:	ff 75 0c             	pushl  0xc(%ebp)
80101f6d:	e8 6e 29 00 00       	call   801048e0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 17                	je     80101f90 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f79:	83 c7 10             	add    $0x10,%edi
80101f7c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f7f:	72 c7                	jb     80101f48 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101f84:	31 c0                	xor    %eax,%eax
}
80101f86:	5b                   	pop    %ebx
80101f87:	5e                   	pop    %esi
80101f88:	5f                   	pop    %edi
80101f89:	5d                   	pop    %ebp
80101f8a:	c3                   	ret    
80101f8b:	90                   	nop
80101f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101f90:	8b 45 10             	mov    0x10(%ebp),%eax
80101f93:	85 c0                	test   %eax,%eax
80101f95:	74 05                	je     80101f9c <dirlookup+0x7c>
        *poff = off;
80101f97:	8b 45 10             	mov    0x10(%ebp),%eax
80101f9a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101f9c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101fa0:	8b 03                	mov    (%ebx),%eax
80101fa2:	e8 d9 f5 ff ff       	call   80101580 <iget>
}
80101fa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101faa:	5b                   	pop    %ebx
80101fab:	5e                   	pop    %esi
80101fac:	5f                   	pop    %edi
80101fad:	5d                   	pop    %ebp
80101fae:	c3                   	ret    
      panic("dirlookup read");
80101faf:	83 ec 0c             	sub    $0xc,%esp
80101fb2:	68 79 73 10 80       	push   $0x80107379
80101fb7:	e8 d4 e3 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101fbc:	83 ec 0c             	sub    $0xc,%esp
80101fbf:	68 67 73 10 80       	push   $0x80107367
80101fc4:	e8 c7 e3 ff ff       	call   80100390 <panic>
80101fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fd0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	57                   	push   %edi
80101fd4:	56                   	push   %esi
80101fd5:	53                   	push   %ebx
80101fd6:	89 cf                	mov    %ecx,%edi
80101fd8:	89 c3                	mov    %eax,%ebx
80101fda:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101fdd:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101fe0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101fe3:	0f 84 67 01 00 00    	je     80102150 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101fe9:	e8 62 1b 00 00       	call   80103b50 <myproc>
  acquire(&icache.lock);
80101fee:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ff1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ff4:	68 20 0a 11 80       	push   $0x80110a20
80101ff9:	e8 b2 26 00 00       	call   801046b0 <acquire>
  ip->ref++;
80101ffe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102002:	c7 04 24 20 0a 11 80 	movl   $0x80110a20,(%esp)
80102009:	e8 62 27 00 00       	call   80104770 <release>
8010200e:	83 c4 10             	add    $0x10,%esp
80102011:	eb 08                	jmp    8010201b <namex+0x4b>
80102013:	90                   	nop
80102014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102018:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010201b:	0f b6 03             	movzbl (%ebx),%eax
8010201e:	3c 2f                	cmp    $0x2f,%al
80102020:	74 f6                	je     80102018 <namex+0x48>
  if(*path == 0)
80102022:	84 c0                	test   %al,%al
80102024:	0f 84 ee 00 00 00    	je     80102118 <namex+0x148>
  while(*path != '/' && *path != 0)
8010202a:	0f b6 03             	movzbl (%ebx),%eax
8010202d:	3c 2f                	cmp    $0x2f,%al
8010202f:	0f 84 b3 00 00 00    	je     801020e8 <namex+0x118>
80102035:	84 c0                	test   %al,%al
80102037:	89 da                	mov    %ebx,%edx
80102039:	75 09                	jne    80102044 <namex+0x74>
8010203b:	e9 a8 00 00 00       	jmp    801020e8 <namex+0x118>
80102040:	84 c0                	test   %al,%al
80102042:	74 0a                	je     8010204e <namex+0x7e>
    path++;
80102044:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80102047:	0f b6 02             	movzbl (%edx),%eax
8010204a:	3c 2f                	cmp    $0x2f,%al
8010204c:	75 f2                	jne    80102040 <namex+0x70>
8010204e:	89 d1                	mov    %edx,%ecx
80102050:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80102052:	83 f9 0d             	cmp    $0xd,%ecx
80102055:	0f 8e 91 00 00 00    	jle    801020ec <namex+0x11c>
    memmove(name, s, DIRSIZ);
8010205b:	83 ec 04             	sub    $0x4,%esp
8010205e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102061:	6a 0e                	push   $0xe
80102063:	53                   	push   %ebx
80102064:	57                   	push   %edi
80102065:	e8 06 28 00 00       	call   80104870 <memmove>
    path++;
8010206a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
8010206d:	83 c4 10             	add    $0x10,%esp
    path++;
80102070:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80102072:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102075:	75 11                	jne    80102088 <namex+0xb8>
80102077:	89 f6                	mov    %esi,%esi
80102079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80102080:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80102083:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102086:	74 f8                	je     80102080 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	56                   	push   %esi
8010208c:	e8 5f f9 ff ff       	call   801019f0 <ilock>
    if(ip->type != T_DIR){
80102091:	83 c4 10             	add    $0x10,%esp
80102094:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102099:	0f 85 91 00 00 00    	jne    80102130 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010209f:	8b 55 e0             	mov    -0x20(%ebp),%edx
801020a2:	85 d2                	test   %edx,%edx
801020a4:	74 09                	je     801020af <namex+0xdf>
801020a6:	80 3b 00             	cmpb   $0x0,(%ebx)
801020a9:	0f 84 b7 00 00 00    	je     80102166 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801020af:	83 ec 04             	sub    $0x4,%esp
801020b2:	6a 00                	push   $0x0
801020b4:	57                   	push   %edi
801020b5:	56                   	push   %esi
801020b6:	e8 65 fe ff ff       	call   80101f20 <dirlookup>
801020bb:	83 c4 10             	add    $0x10,%esp
801020be:	85 c0                	test   %eax,%eax
801020c0:	74 6e                	je     80102130 <namex+0x160>
  iunlock(ip);
801020c2:	83 ec 0c             	sub    $0xc,%esp
801020c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801020c8:	56                   	push   %esi
801020c9:	e8 02 fa ff ff       	call   80101ad0 <iunlock>
  iput(ip);
801020ce:	89 34 24             	mov    %esi,(%esp)
801020d1:	e8 4a fa ff ff       	call   80101b20 <iput>
801020d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801020d9:	83 c4 10             	add    $0x10,%esp
801020dc:	89 c6                	mov    %eax,%esi
801020de:	e9 38 ff ff ff       	jmp    8010201b <namex+0x4b>
801020e3:	90                   	nop
801020e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
801020e8:	89 da                	mov    %ebx,%edx
801020ea:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
801020ec:	83 ec 04             	sub    $0x4,%esp
801020ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
801020f2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801020f5:	51                   	push   %ecx
801020f6:	53                   	push   %ebx
801020f7:	57                   	push   %edi
801020f8:	e8 73 27 00 00       	call   80104870 <memmove>
    name[len] = 0;
801020fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102100:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102103:	83 c4 10             	add    $0x10,%esp
80102106:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010210a:	89 d3                	mov    %edx,%ebx
8010210c:	e9 61 ff ff ff       	jmp    80102072 <namex+0xa2>
80102111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102118:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010211b:	85 c0                	test   %eax,%eax
8010211d:	75 5d                	jne    8010217c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
8010211f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102122:	89 f0                	mov    %esi,%eax
80102124:	5b                   	pop    %ebx
80102125:	5e                   	pop    %esi
80102126:	5f                   	pop    %edi
80102127:	5d                   	pop    %ebp
80102128:	c3                   	ret    
80102129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102130:	83 ec 0c             	sub    $0xc,%esp
80102133:	56                   	push   %esi
80102134:	e8 97 f9 ff ff       	call   80101ad0 <iunlock>
  iput(ip);
80102139:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010213c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010213e:	e8 dd f9 ff ff       	call   80101b20 <iput>
      return 0;
80102143:	83 c4 10             	add    $0x10,%esp
}
80102146:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102149:	89 f0                	mov    %esi,%eax
8010214b:	5b                   	pop    %ebx
8010214c:	5e                   	pop    %esi
8010214d:	5f                   	pop    %edi
8010214e:	5d                   	pop    %ebp
8010214f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102150:	ba 01 00 00 00       	mov    $0x1,%edx
80102155:	b8 01 00 00 00       	mov    $0x1,%eax
8010215a:	e8 21 f4 ff ff       	call   80101580 <iget>
8010215f:	89 c6                	mov    %eax,%esi
80102161:	e9 b5 fe ff ff       	jmp    8010201b <namex+0x4b>
      iunlock(ip);
80102166:	83 ec 0c             	sub    $0xc,%esp
80102169:	56                   	push   %esi
8010216a:	e8 61 f9 ff ff       	call   80101ad0 <iunlock>
      return ip;
8010216f:	83 c4 10             	add    $0x10,%esp
}
80102172:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102175:	89 f0                	mov    %esi,%eax
80102177:	5b                   	pop    %ebx
80102178:	5e                   	pop    %esi
80102179:	5f                   	pop    %edi
8010217a:	5d                   	pop    %ebp
8010217b:	c3                   	ret    
    iput(ip);
8010217c:	83 ec 0c             	sub    $0xc,%esp
8010217f:	56                   	push   %esi
    return 0;
80102180:	31 f6                	xor    %esi,%esi
    iput(ip);
80102182:	e8 99 f9 ff ff       	call   80101b20 <iput>
    return 0;
80102187:	83 c4 10             	add    $0x10,%esp
8010218a:	eb 93                	jmp    8010211f <namex+0x14f>
8010218c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102190 <dirlink>:
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	57                   	push   %edi
80102194:	56                   	push   %esi
80102195:	53                   	push   %ebx
80102196:	83 ec 20             	sub    $0x20,%esp
80102199:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010219c:	6a 00                	push   $0x0
8010219e:	ff 75 0c             	pushl  0xc(%ebp)
801021a1:	53                   	push   %ebx
801021a2:	e8 79 fd ff ff       	call   80101f20 <dirlookup>
801021a7:	83 c4 10             	add    $0x10,%esp
801021aa:	85 c0                	test   %eax,%eax
801021ac:	75 67                	jne    80102215 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021ae:	8b 7b 58             	mov    0x58(%ebx),%edi
801021b1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021b4:	85 ff                	test   %edi,%edi
801021b6:	74 29                	je     801021e1 <dirlink+0x51>
801021b8:	31 ff                	xor    %edi,%edi
801021ba:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021bd:	eb 09                	jmp    801021c8 <dirlink+0x38>
801021bf:	90                   	nop
801021c0:	83 c7 10             	add    $0x10,%edi
801021c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801021c6:	73 19                	jae    801021e1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021c8:	6a 10                	push   $0x10
801021ca:	57                   	push   %edi
801021cb:	56                   	push   %esi
801021cc:	53                   	push   %ebx
801021cd:	e8 fe fa ff ff       	call   80101cd0 <readi>
801021d2:	83 c4 10             	add    $0x10,%esp
801021d5:	83 f8 10             	cmp    $0x10,%eax
801021d8:	75 4e                	jne    80102228 <dirlink+0x98>
    if(de.inum == 0)
801021da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801021df:	75 df                	jne    801021c0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801021e1:	8d 45 da             	lea    -0x26(%ebp),%eax
801021e4:	83 ec 04             	sub    $0x4,%esp
801021e7:	6a 0e                	push   $0xe
801021e9:	ff 75 0c             	pushl  0xc(%ebp)
801021ec:	50                   	push   %eax
801021ed:	e8 4e 27 00 00       	call   80104940 <strncpy>
  de.inum = inum;
801021f2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f5:	6a 10                	push   $0x10
801021f7:	57                   	push   %edi
801021f8:	56                   	push   %esi
801021f9:	53                   	push   %ebx
  de.inum = inum;
801021fa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021fe:	e8 cd fb ff ff       	call   80101dd0 <writei>
80102203:	83 c4 20             	add    $0x20,%esp
80102206:	83 f8 10             	cmp    $0x10,%eax
80102209:	75 2a                	jne    80102235 <dirlink+0xa5>
  return 0;
8010220b:	31 c0                	xor    %eax,%eax
}
8010220d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102210:	5b                   	pop    %ebx
80102211:	5e                   	pop    %esi
80102212:	5f                   	pop    %edi
80102213:	5d                   	pop    %ebp
80102214:	c3                   	ret    
    iput(ip);
80102215:	83 ec 0c             	sub    $0xc,%esp
80102218:	50                   	push   %eax
80102219:	e8 02 f9 ff ff       	call   80101b20 <iput>
    return -1;
8010221e:	83 c4 10             	add    $0x10,%esp
80102221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102226:	eb e5                	jmp    8010220d <dirlink+0x7d>
      panic("dirlink read");
80102228:	83 ec 0c             	sub    $0xc,%esp
8010222b:	68 88 73 10 80       	push   $0x80107388
80102230:	e8 5b e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102235:	83 ec 0c             	sub    $0xc,%esp
80102238:	68 7e 79 10 80       	push   $0x8010797e
8010223d:	e8 4e e1 ff ff       	call   80100390 <panic>
80102242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102250 <namei>:

struct inode*
namei(char *path)
{
80102250:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102251:	31 d2                	xor    %edx,%edx
{
80102253:	89 e5                	mov    %esp,%ebp
80102255:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102258:	8b 45 08             	mov    0x8(%ebp),%eax
8010225b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010225e:	e8 6d fd ff ff       	call   80101fd0 <namex>
}
80102263:	c9                   	leave  
80102264:	c3                   	ret    
80102265:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102270 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102270:	55                   	push   %ebp
  return namex(path, 1, name);
80102271:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102276:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010227b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010227e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010227f:	e9 4c fd ff ff       	jmp    80101fd0 <namex>
80102284:	66 90                	xchg   %ax,%ax
80102286:	66 90                	xchg   %ax,%ax
80102288:	66 90                	xchg   %ax,%ax
8010228a:	66 90                	xchg   %ax,%ax
8010228c:	66 90                	xchg   %ax,%ax
8010228e:	66 90                	xchg   %ax,%ax

80102290 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	57                   	push   %edi
80102294:	56                   	push   %esi
80102295:	53                   	push   %ebx
80102296:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102299:	85 c0                	test   %eax,%eax
8010229b:	0f 84 b4 00 00 00    	je     80102355 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022a1:	8b 58 08             	mov    0x8(%eax),%ebx
801022a4:	89 c6                	mov    %eax,%esi
801022a6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801022ac:	0f 87 96 00 00 00    	ja     80102348 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801022b7:	89 f6                	mov    %esi,%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801022c0:	89 ca                	mov    %ecx,%edx
801022c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022c3:	83 e0 c0             	and    $0xffffffc0,%eax
801022c6:	3c 40                	cmp    $0x40,%al
801022c8:	75 f6                	jne    801022c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022ca:	31 ff                	xor    %edi,%edi
801022cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801022d1:	89 f8                	mov    %edi,%eax
801022d3:	ee                   	out    %al,(%dx)
801022d4:	b8 01 00 00 00       	mov    $0x1,%eax
801022d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801022de:	ee                   	out    %al,(%dx)
801022df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801022e4:	89 d8                	mov    %ebx,%eax
801022e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801022e7:	89 d8                	mov    %ebx,%eax
801022e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801022ee:	c1 f8 08             	sar    $0x8,%eax
801022f1:	ee                   	out    %al,(%dx)
801022f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801022f7:	89 f8                	mov    %edi,%eax
801022f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801022fa:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801022fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102303:	c1 e0 04             	shl    $0x4,%eax
80102306:	83 e0 10             	and    $0x10,%eax
80102309:	83 c8 e0             	or     $0xffffffe0,%eax
8010230c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010230d:	f6 06 04             	testb  $0x4,(%esi)
80102310:	75 16                	jne    80102328 <idestart+0x98>
80102312:	b8 20 00 00 00       	mov    $0x20,%eax
80102317:	89 ca                	mov    %ecx,%edx
80102319:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010231a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010231d:	5b                   	pop    %ebx
8010231e:	5e                   	pop    %esi
8010231f:	5f                   	pop    %edi
80102320:	5d                   	pop    %ebp
80102321:	c3                   	ret    
80102322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102328:	b8 30 00 00 00       	mov    $0x30,%eax
8010232d:	89 ca                	mov    %ecx,%edx
8010232f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102330:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102335:	83 c6 5c             	add    $0x5c,%esi
80102338:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010233d:	fc                   	cld    
8010233e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102340:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102343:	5b                   	pop    %ebx
80102344:	5e                   	pop    %esi
80102345:	5f                   	pop    %edi
80102346:	5d                   	pop    %ebp
80102347:	c3                   	ret    
    panic("incorrect blockno");
80102348:	83 ec 0c             	sub    $0xc,%esp
8010234b:	68 f4 73 10 80       	push   $0x801073f4
80102350:	e8 3b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
80102355:	83 ec 0c             	sub    $0xc,%esp
80102358:	68 eb 73 10 80       	push   $0x801073eb
8010235d:	e8 2e e0 ff ff       	call   80100390 <panic>
80102362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102370 <ideinit>:
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102376:	68 06 74 10 80       	push   $0x80107406
8010237b:	68 c0 a5 10 80       	push   $0x8010a5c0
80102380:	e8 eb 21 00 00       	call   80104570 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102385:	58                   	pop    %eax
80102386:	a1 40 2d 11 80       	mov    0x80112d40,%eax
8010238b:	5a                   	pop    %edx
8010238c:	83 e8 01             	sub    $0x1,%eax
8010238f:	50                   	push   %eax
80102390:	6a 0e                	push   $0xe
80102392:	e8 a9 02 00 00       	call   80102640 <ioapicenable>
80102397:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010239a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010239f:	90                   	nop
801023a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023a1:	83 e0 c0             	and    $0xffffffc0,%eax
801023a4:	3c 40                	cmp    $0x40,%al
801023a6:	75 f8                	jne    801023a0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023a8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023ad:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023b2:	ee                   	out    %al,(%dx)
801023b3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023bd:	eb 06                	jmp    801023c5 <ideinit+0x55>
801023bf:	90                   	nop
  for(i=0; i<1000; i++){
801023c0:	83 e9 01             	sub    $0x1,%ecx
801023c3:	74 0f                	je     801023d4 <ideinit+0x64>
801023c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023c6:	84 c0                	test   %al,%al
801023c8:	74 f6                	je     801023c0 <ideinit+0x50>
      havedisk1 = 1;
801023ca:	c7 05 a0 a5 10 80 01 	movl   $0x1,0x8010a5a0
801023d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801023d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023de:	ee                   	out    %al,(%dx)
}
801023df:	c9                   	leave  
801023e0:	c3                   	ret    
801023e1:	eb 0d                	jmp    801023f0 <ideintr>
801023e3:	90                   	nop
801023e4:	90                   	nop
801023e5:	90                   	nop
801023e6:	90                   	nop
801023e7:	90                   	nop
801023e8:	90                   	nop
801023e9:	90                   	nop
801023ea:	90                   	nop
801023eb:	90                   	nop
801023ec:	90                   	nop
801023ed:	90                   	nop
801023ee:	90                   	nop
801023ef:	90                   	nop

801023f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	57                   	push   %edi
801023f4:	56                   	push   %esi
801023f5:	53                   	push   %ebx
801023f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801023f9:	68 c0 a5 10 80       	push   $0x8010a5c0
801023fe:	e8 ad 22 00 00       	call   801046b0 <acquire>

  if((b = idequeue) == 0){
80102403:	8b 1d a4 a5 10 80    	mov    0x8010a5a4,%ebx
80102409:	83 c4 10             	add    $0x10,%esp
8010240c:	85 db                	test   %ebx,%ebx
8010240e:	74 67                	je     80102477 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102410:	8b 43 58             	mov    0x58(%ebx),%eax
80102413:	a3 a4 a5 10 80       	mov    %eax,0x8010a5a4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102418:	8b 3b                	mov    (%ebx),%edi
8010241a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102420:	75 31                	jne    80102453 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102422:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102427:	89 f6                	mov    %esi,%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102430:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102431:	89 c6                	mov    %eax,%esi
80102433:	83 e6 c0             	and    $0xffffffc0,%esi
80102436:	89 f1                	mov    %esi,%ecx
80102438:	80 f9 40             	cmp    $0x40,%cl
8010243b:	75 f3                	jne    80102430 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010243d:	a8 21                	test   $0x21,%al
8010243f:	75 12                	jne    80102453 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102441:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102444:	b9 80 00 00 00       	mov    $0x80,%ecx
80102449:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010244e:	fc                   	cld    
8010244f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102451:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102453:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102456:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102459:	89 f9                	mov    %edi,%ecx
8010245b:	83 c9 02             	or     $0x2,%ecx
8010245e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102460:	53                   	push   %ebx
80102461:	e8 3a 1e 00 00       	call   801042a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102466:	a1 a4 a5 10 80       	mov    0x8010a5a4,%eax
8010246b:	83 c4 10             	add    $0x10,%esp
8010246e:	85 c0                	test   %eax,%eax
80102470:	74 05                	je     80102477 <ideintr+0x87>
    idestart(idequeue);
80102472:	e8 19 fe ff ff       	call   80102290 <idestart>
    release(&idelock);
80102477:	83 ec 0c             	sub    $0xc,%esp
8010247a:	68 c0 a5 10 80       	push   $0x8010a5c0
8010247f:	e8 ec 22 00 00       	call   80104770 <release>

  release(&idelock);
}
80102484:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102487:	5b                   	pop    %ebx
80102488:	5e                   	pop    %esi
80102489:	5f                   	pop    %edi
8010248a:	5d                   	pop    %ebp
8010248b:	c3                   	ret    
8010248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102490 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 10             	sub    $0x10,%esp
80102497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010249a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010249d:	50                   	push   %eax
8010249e:	e8 7d 20 00 00       	call   80104520 <holdingsleep>
801024a3:	83 c4 10             	add    $0x10,%esp
801024a6:	85 c0                	test   %eax,%eax
801024a8:	0f 84 c6 00 00 00    	je     80102574 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024ae:	8b 03                	mov    (%ebx),%eax
801024b0:	83 e0 06             	and    $0x6,%eax
801024b3:	83 f8 02             	cmp    $0x2,%eax
801024b6:	0f 84 ab 00 00 00    	je     80102567 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024bc:	8b 53 04             	mov    0x4(%ebx),%edx
801024bf:	85 d2                	test   %edx,%edx
801024c1:	74 0d                	je     801024d0 <iderw+0x40>
801024c3:	a1 a0 a5 10 80       	mov    0x8010a5a0,%eax
801024c8:	85 c0                	test   %eax,%eax
801024ca:	0f 84 b1 00 00 00    	je     80102581 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	68 c0 a5 10 80       	push   $0x8010a5c0
801024d8:	e8 d3 21 00 00       	call   801046b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024dd:	8b 15 a4 a5 10 80    	mov    0x8010a5a4,%edx
801024e3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801024e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024ed:	85 d2                	test   %edx,%edx
801024ef:	75 09                	jne    801024fa <iderw+0x6a>
801024f1:	eb 6d                	jmp    80102560 <iderw+0xd0>
801024f3:	90                   	nop
801024f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f8:	89 c2                	mov    %eax,%edx
801024fa:	8b 42 58             	mov    0x58(%edx),%eax
801024fd:	85 c0                	test   %eax,%eax
801024ff:	75 f7                	jne    801024f8 <iderw+0x68>
80102501:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102504:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102506:	39 1d a4 a5 10 80    	cmp    %ebx,0x8010a5a4
8010250c:	74 42                	je     80102550 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010250e:	8b 03                	mov    (%ebx),%eax
80102510:	83 e0 06             	and    $0x6,%eax
80102513:	83 f8 02             	cmp    $0x2,%eax
80102516:	74 23                	je     8010253b <iderw+0xab>
80102518:	90                   	nop
80102519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102520:	83 ec 08             	sub    $0x8,%esp
80102523:	68 c0 a5 10 80       	push   $0x8010a5c0
80102528:	53                   	push   %ebx
80102529:	e8 c2 1b 00 00       	call   801040f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010252e:	8b 03                	mov    (%ebx),%eax
80102530:	83 c4 10             	add    $0x10,%esp
80102533:	83 e0 06             	and    $0x6,%eax
80102536:	83 f8 02             	cmp    $0x2,%eax
80102539:	75 e5                	jne    80102520 <iderw+0x90>
  }


  release(&idelock);
8010253b:	c7 45 08 c0 a5 10 80 	movl   $0x8010a5c0,0x8(%ebp)
}
80102542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102545:	c9                   	leave  
  release(&idelock);
80102546:	e9 25 22 00 00       	jmp    80104770 <release>
8010254b:	90                   	nop
8010254c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102550:	89 d8                	mov    %ebx,%eax
80102552:	e8 39 fd ff ff       	call   80102290 <idestart>
80102557:	eb b5                	jmp    8010250e <iderw+0x7e>
80102559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102560:	ba a4 a5 10 80       	mov    $0x8010a5a4,%edx
80102565:	eb 9d                	jmp    80102504 <iderw+0x74>
    panic("iderw: nothing to do");
80102567:	83 ec 0c             	sub    $0xc,%esp
8010256a:	68 20 74 10 80       	push   $0x80107420
8010256f:	e8 1c de ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102574:	83 ec 0c             	sub    $0xc,%esp
80102577:	68 0a 74 10 80       	push   $0x8010740a
8010257c:	e8 0f de ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102581:	83 ec 0c             	sub    $0xc,%esp
80102584:	68 35 74 10 80       	push   $0x80107435
80102589:	e8 02 de ff ff       	call   80100390 <panic>
8010258e:	66 90                	xchg   %ax,%ax

80102590 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102590:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102591:	c7 05 74 26 11 80 00 	movl   $0xfec00000,0x80112674
80102598:	00 c0 fe 
{
8010259b:	89 e5                	mov    %esp,%ebp
8010259d:	56                   	push   %esi
8010259e:	53                   	push   %ebx
  ioapic->reg = reg;
8010259f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025a6:	00 00 00 
  return ioapic->data;
801025a9:	a1 74 26 11 80       	mov    0x80112674,%eax
801025ae:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801025b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801025b7:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025bd:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025c4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801025c7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025ca:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801025cd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801025d0:	39 c2                	cmp    %eax,%edx
801025d2:	74 16                	je     801025ea <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025d4:	83 ec 0c             	sub    $0xc,%esp
801025d7:	68 54 74 10 80       	push   $0x80107454
801025dc:	e8 7f e0 ff ff       	call   80100660 <cprintf>
801025e1:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
801025e7:	83 c4 10             	add    $0x10,%esp
801025ea:	83 c3 21             	add    $0x21,%ebx
{
801025ed:	ba 10 00 00 00       	mov    $0x10,%edx
801025f2:	b8 20 00 00 00       	mov    $0x20,%eax
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102600:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102602:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102608:	89 c6                	mov    %eax,%esi
8010260a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102610:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102613:	89 71 10             	mov    %esi,0x10(%ecx)
80102616:	8d 72 01             	lea    0x1(%edx),%esi
80102619:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010261c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010261e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102620:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
80102626:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010262d:	75 d1                	jne    80102600 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010262f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102632:	5b                   	pop    %ebx
80102633:	5e                   	pop    %esi
80102634:	5d                   	pop    %ebp
80102635:	c3                   	ret    
80102636:	8d 76 00             	lea    0x0(%esi),%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102640 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102640:	55                   	push   %ebp
  ioapic->reg = reg;
80102641:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
{
80102647:	89 e5                	mov    %esp,%ebp
80102649:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010264c:	8d 50 20             	lea    0x20(%eax),%edx
8010264f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102653:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102655:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010265b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010265e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102661:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102664:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102666:	a1 74 26 11 80       	mov    0x80112674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010266b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010266e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	66 90                	xchg   %ax,%ax
80102675:	66 90                	xchg   %ax,%ax
80102677:	66 90                	xchg   %ax,%ax
80102679:	66 90                	xchg   %ax,%ax
8010267b:	66 90                	xchg   %ax,%ax
8010267d:	66 90                	xchg   %ax,%ax
8010267f:	90                   	nop

80102680 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	53                   	push   %ebx
80102684:	83 ec 04             	sub    $0x4,%esp
80102687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010268a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102690:	75 70                	jne    80102702 <kfree+0x82>
80102692:	81 fb e8 54 11 80    	cmp    $0x801154e8,%ebx
80102698:	72 68                	jb     80102702 <kfree+0x82>
8010269a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026a0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026a5:	77 5b                	ja     80102702 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026a7:	83 ec 04             	sub    $0x4,%esp
801026aa:	68 00 10 00 00       	push   $0x1000
801026af:	6a 01                	push   $0x1
801026b1:	53                   	push   %ebx
801026b2:	e8 09 21 00 00       	call   801047c0 <memset>

  if(kmem.use_lock)
801026b7:	8b 15 b4 26 11 80    	mov    0x801126b4,%edx
801026bd:	83 c4 10             	add    $0x10,%esp
801026c0:	85 d2                	test   %edx,%edx
801026c2:	75 2c                	jne    801026f0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026c4:	a1 b8 26 11 80       	mov    0x801126b8,%eax
801026c9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026cb:	a1 b4 26 11 80       	mov    0x801126b4,%eax
  kmem.freelist = r;
801026d0:	89 1d b8 26 11 80    	mov    %ebx,0x801126b8
  if(kmem.use_lock)
801026d6:	85 c0                	test   %eax,%eax
801026d8:	75 06                	jne    801026e0 <kfree+0x60>
    release(&kmem.lock);
}
801026da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026dd:	c9                   	leave  
801026de:	c3                   	ret    
801026df:	90                   	nop
    release(&kmem.lock);
801026e0:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
801026e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026ea:	c9                   	leave  
    release(&kmem.lock);
801026eb:	e9 80 20 00 00       	jmp    80104770 <release>
    acquire(&kmem.lock);
801026f0:	83 ec 0c             	sub    $0xc,%esp
801026f3:	68 80 26 11 80       	push   $0x80112680
801026f8:	e8 b3 1f 00 00       	call   801046b0 <acquire>
801026fd:	83 c4 10             	add    $0x10,%esp
80102700:	eb c2                	jmp    801026c4 <kfree+0x44>
    panic("kfree");
80102702:	83 ec 0c             	sub    $0xc,%esp
80102705:	68 86 74 10 80       	push   $0x80107486
8010270a:	e8 81 dc ff ff       	call   80100390 <panic>
8010270f:	90                   	nop

80102710 <freerange>:
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	56                   	push   %esi
80102714:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102715:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102718:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010271b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102721:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102727:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010272d:	39 de                	cmp    %ebx,%esi
8010272f:	72 23                	jb     80102754 <freerange+0x44>
80102731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102738:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010273e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102741:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102747:	50                   	push   %eax
80102748:	e8 33 ff ff ff       	call   80102680 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010274d:	83 c4 10             	add    $0x10,%esp
80102750:	39 f3                	cmp    %esi,%ebx
80102752:	76 e4                	jbe    80102738 <freerange+0x28>
}
80102754:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102757:	5b                   	pop    %ebx
80102758:	5e                   	pop    %esi
80102759:	5d                   	pop    %ebp
8010275a:	c3                   	ret    
8010275b:	90                   	nop
8010275c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102760 <kinit1>:
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	56                   	push   %esi
80102764:	53                   	push   %ebx
80102765:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102768:	83 ec 08             	sub    $0x8,%esp
8010276b:	68 8c 74 10 80       	push   $0x8010748c
80102770:	68 80 26 11 80       	push   $0x80112680
80102775:	e8 f6 1d 00 00       	call   80104570 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010277a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010277d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102780:	c7 05 b4 26 11 80 00 	movl   $0x0,0x801126b4
80102787:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010278a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102790:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102796:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010279c:	39 de                	cmp    %ebx,%esi
8010279e:	72 1c                	jb     801027bc <kinit1+0x5c>
    kfree(p);
801027a0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027a6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027af:	50                   	push   %eax
801027b0:	e8 cb fe ff ff       	call   80102680 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027b5:	83 c4 10             	add    $0x10,%esp
801027b8:	39 de                	cmp    %ebx,%esi
801027ba:	73 e4                	jae    801027a0 <kinit1+0x40>
}
801027bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027bf:	5b                   	pop    %ebx
801027c0:	5e                   	pop    %esi
801027c1:	5d                   	pop    %ebp
801027c2:	c3                   	ret    
801027c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <kinit2>:
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	56                   	push   %esi
801027d4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801027d5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801027d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801027db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027ed:	39 de                	cmp    %ebx,%esi
801027ef:	72 23                	jb     80102814 <kinit2+0x44>
801027f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027fe:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102801:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102807:	50                   	push   %eax
80102808:	e8 73 fe ff ff       	call   80102680 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010280d:	83 c4 10             	add    $0x10,%esp
80102810:	39 de                	cmp    %ebx,%esi
80102812:	73 e4                	jae    801027f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102814:	c7 05 b4 26 11 80 01 	movl   $0x1,0x801126b4
8010281b:	00 00 00 
}
8010281e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102821:	5b                   	pop    %ebx
80102822:	5e                   	pop    %esi
80102823:	5d                   	pop    %ebp
80102824:	c3                   	ret    
80102825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102830 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102830:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102835:	85 c0                	test   %eax,%eax
80102837:	75 1f                	jne    80102858 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102839:	a1 b8 26 11 80       	mov    0x801126b8,%eax
  if(r)
8010283e:	85 c0                	test   %eax,%eax
80102840:	74 0e                	je     80102850 <kalloc+0x20>
    kmem.freelist = r->next;
80102842:	8b 10                	mov    (%eax),%edx
80102844:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
8010284a:	c3                   	ret    
8010284b:	90                   	nop
8010284c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102850:	f3 c3                	repz ret 
80102852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102858:	55                   	push   %ebp
80102859:	89 e5                	mov    %esp,%ebp
8010285b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010285e:	68 80 26 11 80       	push   $0x80112680
80102863:	e8 48 1e 00 00       	call   801046b0 <acquire>
  r = kmem.freelist;
80102868:	a1 b8 26 11 80       	mov    0x801126b8,%eax
  if(r)
8010286d:	83 c4 10             	add    $0x10,%esp
80102870:	8b 15 b4 26 11 80    	mov    0x801126b4,%edx
80102876:	85 c0                	test   %eax,%eax
80102878:	74 08                	je     80102882 <kalloc+0x52>
    kmem.freelist = r->next;
8010287a:	8b 08                	mov    (%eax),%ecx
8010287c:	89 0d b8 26 11 80    	mov    %ecx,0x801126b8
  if(kmem.use_lock)
80102882:	85 d2                	test   %edx,%edx
80102884:	74 16                	je     8010289c <kalloc+0x6c>
    release(&kmem.lock);
80102886:	83 ec 0c             	sub    $0xc,%esp
80102889:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010288c:	68 80 26 11 80       	push   $0x80112680
80102891:	e8 da 1e 00 00       	call   80104770 <release>
  return (char*)r;
80102896:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102899:	83 c4 10             	add    $0x10,%esp
}
8010289c:	c9                   	leave  
8010289d:	c3                   	ret    
8010289e:	66 90                	xchg   %ax,%ax

801028a0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a0:	ba 64 00 00 00       	mov    $0x64,%edx
801028a5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028a6:	a8 01                	test   $0x1,%al
801028a8:	0f 84 c2 00 00 00    	je     80102970 <kbdgetc+0xd0>
801028ae:	ba 60 00 00 00       	mov    $0x60,%edx
801028b3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801028b4:	0f b6 d0             	movzbl %al,%edx
801028b7:	8b 0d f4 a5 10 80    	mov    0x8010a5f4,%ecx

  if(data == 0xE0){
801028bd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801028c3:	0f 84 7f 00 00 00    	je     80102948 <kbdgetc+0xa8>
{
801028c9:	55                   	push   %ebp
801028ca:	89 e5                	mov    %esp,%ebp
801028cc:	53                   	push   %ebx
801028cd:	89 cb                	mov    %ecx,%ebx
801028cf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028d2:	84 c0                	test   %al,%al
801028d4:	78 4a                	js     80102920 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028d6:	85 db                	test   %ebx,%ebx
801028d8:	74 09                	je     801028e3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028da:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028dd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801028e0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801028e3:	0f b6 82 c0 75 10 80 	movzbl -0x7fef8a40(%edx),%eax
801028ea:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801028ec:	0f b6 82 c0 74 10 80 	movzbl -0x7fef8b40(%edx),%eax
801028f3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801028f5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801028f7:	89 0d f4 a5 10 80    	mov    %ecx,0x8010a5f4
  c = charcode[shift & (CTL | SHIFT)][data];
801028fd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102900:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102903:	8b 04 85 a0 74 10 80 	mov    -0x7fef8b60(,%eax,4),%eax
8010290a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010290e:	74 31                	je     80102941 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102910:	8d 50 9f             	lea    -0x61(%eax),%edx
80102913:	83 fa 19             	cmp    $0x19,%edx
80102916:	77 40                	ja     80102958 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102918:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010291b:	5b                   	pop    %ebx
8010291c:	5d                   	pop    %ebp
8010291d:	c3                   	ret    
8010291e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102920:	83 e0 7f             	and    $0x7f,%eax
80102923:	85 db                	test   %ebx,%ebx
80102925:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102928:	0f b6 82 c0 75 10 80 	movzbl -0x7fef8a40(%edx),%eax
8010292f:	83 c8 40             	or     $0x40,%eax
80102932:	0f b6 c0             	movzbl %al,%eax
80102935:	f7 d0                	not    %eax
80102937:	21 c1                	and    %eax,%ecx
    return 0;
80102939:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010293b:	89 0d f4 a5 10 80    	mov    %ecx,0x8010a5f4
}
80102941:	5b                   	pop    %ebx
80102942:	5d                   	pop    %ebp
80102943:	c3                   	ret    
80102944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102948:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010294b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010294d:	89 0d f4 a5 10 80    	mov    %ecx,0x8010a5f4
    return 0;
80102953:	c3                   	ret    
80102954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102958:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010295b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010295e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010295f:	83 f9 1a             	cmp    $0x1a,%ecx
80102962:	0f 42 c2             	cmovb  %edx,%eax
}
80102965:	5d                   	pop    %ebp
80102966:	c3                   	ret    
80102967:	89 f6                	mov    %esi,%esi
80102969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102975:	c3                   	ret    
80102976:	8d 76 00             	lea    0x0(%esi),%esi
80102979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102980 <kbdintr>:

void
kbdintr(void)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102986:	68 a0 28 10 80       	push   $0x801028a0
8010298b:	e8 d0 e0 ff ff       	call   80100a60 <consoleintr>
}
80102990:	83 c4 10             	add    $0x10,%esp
80102993:	c9                   	leave  
80102994:	c3                   	ret    
80102995:	66 90                	xchg   %ax,%ax
80102997:	66 90                	xchg   %ax,%ax
80102999:	66 90                	xchg   %ax,%ax
8010299b:	66 90                	xchg   %ax,%ax
8010299d:	66 90                	xchg   %ax,%ax
8010299f:	90                   	nop

801029a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029a0:	a1 bc 26 11 80       	mov    0x801126bc,%eax
{
801029a5:	55                   	push   %ebp
801029a6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029a8:	85 c0                	test   %eax,%eax
801029aa:	0f 84 c8 00 00 00    	je     80102a78 <lapicinit+0xd8>
  lapic[index] = value;
801029b0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029b7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029bd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ca:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029d1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029de:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029eb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029fe:	8b 50 30             	mov    0x30(%eax),%edx
80102a01:	c1 ea 10             	shr    $0x10,%edx
80102a04:	80 fa 03             	cmp    $0x3,%dl
80102a07:	77 77                	ja     80102a80 <lapicinit+0xe0>
  lapic[index] = value;
80102a09:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a10:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a13:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a16:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a1d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a20:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a23:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a2a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a30:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a37:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a3d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a47:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a4a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a51:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a54:	8b 50 20             	mov    0x20(%eax),%edx
80102a57:	89 f6                	mov    %esi,%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a60:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a66:	80 e6 10             	and    $0x10,%dh
80102a69:	75 f5                	jne    80102a60 <lapicinit+0xc0>
  lapic[index] = value;
80102a6b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a72:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a75:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a78:	5d                   	pop    %ebp
80102a79:	c3                   	ret    
80102a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102a80:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a87:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8a:	8b 50 20             	mov    0x20(%eax),%edx
80102a8d:	e9 77 ff ff ff       	jmp    80102a09 <lapicinit+0x69>
80102a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102aa0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102aa0:	8b 15 bc 26 11 80    	mov    0x801126bc,%edx
{
80102aa6:	55                   	push   %ebp
80102aa7:	31 c0                	xor    %eax,%eax
80102aa9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102aab:	85 d2                	test   %edx,%edx
80102aad:	74 06                	je     80102ab5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102aaf:	8b 42 20             	mov    0x20(%edx),%eax
80102ab2:	c1 e8 18             	shr    $0x18,%eax
}
80102ab5:	5d                   	pop    %ebp
80102ab6:	c3                   	ret    
80102ab7:	89 f6                	mov    %esi,%esi
80102ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ac0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ac0:	a1 bc 26 11 80       	mov    0x801126bc,%eax
{
80102ac5:	55                   	push   %ebp
80102ac6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ac8:	85 c0                	test   %eax,%eax
80102aca:	74 0d                	je     80102ad9 <lapiceoi+0x19>
  lapic[index] = value;
80102acc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ad3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102ad9:	5d                   	pop    %ebp
80102ada:	c3                   	ret    
80102adb:	90                   	nop
80102adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ae0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
}
80102ae3:	5d                   	pop    %ebp
80102ae4:	c3                   	ret    
80102ae5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102af0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102af0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102af6:	ba 70 00 00 00       	mov    $0x70,%edx
80102afb:	89 e5                	mov    %esp,%ebp
80102afd:	53                   	push   %ebx
80102afe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b04:	ee                   	out    %al,(%dx)
80102b05:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b0a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b0f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b10:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b12:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b15:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b1b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b1d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102b20:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102b23:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b25:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b28:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b2e:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b33:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b39:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b3c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b43:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b46:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b49:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b50:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b53:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b56:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b5c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b5f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b65:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b68:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b71:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b77:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b7a:	5b                   	pop    %ebx
80102b7b:	5d                   	pop    %ebp
80102b7c:	c3                   	ret    
80102b7d:	8d 76 00             	lea    0x0(%esi),%esi

80102b80 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b80:	55                   	push   %ebp
80102b81:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b86:	ba 70 00 00 00       	mov    $0x70,%edx
80102b8b:	89 e5                	mov    %esp,%ebp
80102b8d:	57                   	push   %edi
80102b8e:	56                   	push   %esi
80102b8f:	53                   	push   %ebx
80102b90:	83 ec 4c             	sub    $0x4c,%esp
80102b93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b94:	ba 71 00 00 00       	mov    $0x71,%edx
80102b99:	ec                   	in     (%dx),%al
80102b9a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b9d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ba2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ba5:	8d 76 00             	lea    0x0(%esi),%esi
80102ba8:	31 c0                	xor    %eax,%eax
80102baa:	89 da                	mov    %ebx,%edx
80102bac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bad:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bb2:	89 ca                	mov    %ecx,%edx
80102bb4:	ec                   	in     (%dx),%al
80102bb5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb8:	89 da                	mov    %ebx,%edx
80102bba:	b8 02 00 00 00       	mov    $0x2,%eax
80102bbf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc0:	89 ca                	mov    %ecx,%edx
80102bc2:	ec                   	in     (%dx),%al
80102bc3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc6:	89 da                	mov    %ebx,%edx
80102bc8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bcd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bce:	89 ca                	mov    %ecx,%edx
80102bd0:	ec                   	in     (%dx),%al
80102bd1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd4:	89 da                	mov    %ebx,%edx
80102bd6:	b8 07 00 00 00       	mov    $0x7,%eax
80102bdb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdc:	89 ca                	mov    %ecx,%edx
80102bde:	ec                   	in     (%dx),%al
80102bdf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be2:	89 da                	mov    %ebx,%edx
80102be4:	b8 08 00 00 00       	mov    $0x8,%eax
80102be9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bea:	89 ca                	mov    %ecx,%edx
80102bec:	ec                   	in     (%dx),%al
80102bed:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bef:	89 da                	mov    %ebx,%edx
80102bf1:	b8 09 00 00 00       	mov    $0x9,%eax
80102bf6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf7:	89 ca                	mov    %ecx,%edx
80102bf9:	ec                   	in     (%dx),%al
80102bfa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bfc:	89 da                	mov    %ebx,%edx
80102bfe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c04:	89 ca                	mov    %ecx,%edx
80102c06:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c07:	84 c0                	test   %al,%al
80102c09:	78 9d                	js     80102ba8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c0b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c0f:	89 fa                	mov    %edi,%edx
80102c11:	0f b6 fa             	movzbl %dl,%edi
80102c14:	89 f2                	mov    %esi,%edx
80102c16:	0f b6 f2             	movzbl %dl,%esi
80102c19:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c1c:	89 da                	mov    %ebx,%edx
80102c1e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c21:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c24:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c28:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c2b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c2f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c32:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c36:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c39:	31 c0                	xor    %eax,%eax
80102c3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3c:	89 ca                	mov    %ecx,%edx
80102c3e:	ec                   	in     (%dx),%al
80102c3f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c42:	89 da                	mov    %ebx,%edx
80102c44:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c47:	b8 02 00 00 00       	mov    $0x2,%eax
80102c4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4d:	89 ca                	mov    %ecx,%edx
80102c4f:	ec                   	in     (%dx),%al
80102c50:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c53:	89 da                	mov    %ebx,%edx
80102c55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c58:	b8 04 00 00 00       	mov    $0x4,%eax
80102c5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5e:	89 ca                	mov    %ecx,%edx
80102c60:	ec                   	in     (%dx),%al
80102c61:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c64:	89 da                	mov    %ebx,%edx
80102c66:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c69:	b8 07 00 00 00       	mov    $0x7,%eax
80102c6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6f:	89 ca                	mov    %ecx,%edx
80102c71:	ec                   	in     (%dx),%al
80102c72:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c75:	89 da                	mov    %ebx,%edx
80102c77:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c7a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c80:	89 ca                	mov    %ecx,%edx
80102c82:	ec                   	in     (%dx),%al
80102c83:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c86:	89 da                	mov    %ebx,%edx
80102c88:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c8b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c90:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c91:	89 ca                	mov    %ecx,%edx
80102c93:	ec                   	in     (%dx),%al
80102c94:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c97:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c9d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ca0:	6a 18                	push   $0x18
80102ca2:	50                   	push   %eax
80102ca3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ca6:	50                   	push   %eax
80102ca7:	e8 64 1b 00 00       	call   80104810 <memcmp>
80102cac:	83 c4 10             	add    $0x10,%esp
80102caf:	85 c0                	test   %eax,%eax
80102cb1:	0f 85 f1 fe ff ff    	jne    80102ba8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102cb7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102cbb:	75 78                	jne    80102d35 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cbd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cc0:	89 c2                	mov    %eax,%edx
80102cc2:	83 e0 0f             	and    $0xf,%eax
80102cc5:	c1 ea 04             	shr    $0x4,%edx
80102cc8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ccb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cce:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cd1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cd4:	89 c2                	mov    %eax,%edx
80102cd6:	83 e0 0f             	and    $0xf,%eax
80102cd9:	c1 ea 04             	shr    $0x4,%edx
80102cdc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cdf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ce2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ce5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ce8:	89 c2                	mov    %eax,%edx
80102cea:	83 e0 0f             	and    $0xf,%eax
80102ced:	c1 ea 04             	shr    $0x4,%edx
80102cf0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cf3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cf6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102cf9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cfc:	89 c2                	mov    %eax,%edx
80102cfe:	83 e0 0f             	and    $0xf,%eax
80102d01:	c1 ea 04             	shr    $0x4,%edx
80102d04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d0a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d0d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d10:	89 c2                	mov    %eax,%edx
80102d12:	83 e0 0f             	and    $0xf,%eax
80102d15:	c1 ea 04             	shr    $0x4,%edx
80102d18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d1e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d21:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d24:	89 c2                	mov    %eax,%edx
80102d26:	83 e0 0f             	and    $0xf,%eax
80102d29:	c1 ea 04             	shr    $0x4,%edx
80102d2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d32:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d35:	8b 75 08             	mov    0x8(%ebp),%esi
80102d38:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d3b:	89 06                	mov    %eax,(%esi)
80102d3d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d40:	89 46 04             	mov    %eax,0x4(%esi)
80102d43:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d46:	89 46 08             	mov    %eax,0x8(%esi)
80102d49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d4c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d52:	89 46 10             	mov    %eax,0x10(%esi)
80102d55:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d58:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d5b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d65:	5b                   	pop    %ebx
80102d66:	5e                   	pop    %esi
80102d67:	5f                   	pop    %edi
80102d68:	5d                   	pop    %ebp
80102d69:	c3                   	ret    
80102d6a:	66 90                	xchg   %ax,%ax
80102d6c:	66 90                	xchg   %ax,%ax
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d70:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102d76:	85 c9                	test   %ecx,%ecx
80102d78:	0f 8e 8a 00 00 00    	jle    80102e08 <install_trans+0x98>
{
80102d7e:	55                   	push   %ebp
80102d7f:	89 e5                	mov    %esp,%ebp
80102d81:	57                   	push   %edi
80102d82:	56                   	push   %esi
80102d83:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102d84:	31 db                	xor    %ebx,%ebx
{
80102d86:	83 ec 0c             	sub    $0xc,%esp
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d90:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80102d95:	83 ec 08             	sub    $0x8,%esp
80102d98:	01 d8                	add    %ebx,%eax
80102d9a:	83 c0 01             	add    $0x1,%eax
80102d9d:	50                   	push   %eax
80102d9e:	ff 35 04 27 11 80    	pushl  0x80112704
80102da4:	e8 27 d3 ff ff       	call   801000d0 <bread>
80102da9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dab:	58                   	pop    %eax
80102dac:	5a                   	pop    %edx
80102dad:	ff 34 9d 0c 27 11 80 	pushl  -0x7feed8f4(,%ebx,4)
80102db4:	ff 35 04 27 11 80    	pushl  0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
80102dba:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dbd:	e8 0e d3 ff ff       	call   801000d0 <bread>
80102dc2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dc4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102dc7:	83 c4 0c             	add    $0xc,%esp
80102dca:	68 00 02 00 00       	push   $0x200
80102dcf:	50                   	push   %eax
80102dd0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dd3:	50                   	push   %eax
80102dd4:	e8 97 1a 00 00       	call   80104870 <memmove>
    bwrite(dbuf);  // write dst to disk
80102dd9:	89 34 24             	mov    %esi,(%esp)
80102ddc:	e8 bf d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102de1:	89 3c 24             	mov    %edi,(%esp)
80102de4:	e8 f7 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102de9:	89 34 24             	mov    %esi,(%esp)
80102dec:	e8 ef d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102df1:	83 c4 10             	add    $0x10,%esp
80102df4:	39 1d 08 27 11 80    	cmp    %ebx,0x80112708
80102dfa:	7f 94                	jg     80102d90 <install_trans+0x20>
  }
}
80102dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dff:	5b                   	pop    %ebx
80102e00:	5e                   	pop    %esi
80102e01:	5f                   	pop    %edi
80102e02:	5d                   	pop    %ebp
80102e03:	c3                   	ret    
80102e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e08:	f3 c3                	repz ret 
80102e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	56                   	push   %esi
80102e14:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102e15:	83 ec 08             	sub    $0x8,%esp
80102e18:	ff 35 f4 26 11 80    	pushl  0x801126f4
80102e1e:	ff 35 04 27 11 80    	pushl  0x80112704
80102e24:	e8 a7 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e29:	8b 1d 08 27 11 80    	mov    0x80112708,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102e2f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e32:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102e34:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102e36:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e39:	7e 16                	jle    80102e51 <write_head+0x41>
80102e3b:	c1 e3 02             	shl    $0x2,%ebx
80102e3e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102e40:	8b 8a 0c 27 11 80    	mov    -0x7feed8f4(%edx),%ecx
80102e46:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102e4a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102e4d:	39 da                	cmp    %ebx,%edx
80102e4f:	75 ef                	jne    80102e40 <write_head+0x30>
  }
  bwrite(buf);
80102e51:	83 ec 0c             	sub    $0xc,%esp
80102e54:	56                   	push   %esi
80102e55:	e8 46 d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102e5a:	89 34 24             	mov    %esi,(%esp)
80102e5d:	e8 7e d3 ff ff       	call   801001e0 <brelse>
}
80102e62:	83 c4 10             	add    $0x10,%esp
80102e65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e68:	5b                   	pop    %ebx
80102e69:	5e                   	pop    %esi
80102e6a:	5d                   	pop    %ebp
80102e6b:	c3                   	ret    
80102e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e70 <initlog>:
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 2c             	sub    $0x2c,%esp
80102e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e7a:	68 c0 76 10 80       	push   $0x801076c0
80102e7f:	68 c0 26 11 80       	push   $0x801126c0
80102e84:	e8 e7 16 00 00       	call   80104570 <initlock>
  readsb(dev, &sb);
80102e89:	58                   	pop    %eax
80102e8a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e8d:	5a                   	pop    %edx
80102e8e:	50                   	push   %eax
80102e8f:	53                   	push   %ebx
80102e90:	e8 9b e8 ff ff       	call   80101730 <readsb>
  log.size = sb.nlog;
80102e95:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e9b:	59                   	pop    %ecx
  log.dev = dev;
80102e9c:	89 1d 04 27 11 80    	mov    %ebx,0x80112704
  log.size = sb.nlog;
80102ea2:	89 15 f8 26 11 80    	mov    %edx,0x801126f8
  log.start = sb.logstart;
80102ea8:	a3 f4 26 11 80       	mov    %eax,0x801126f4
  struct buf *buf = bread(log.dev, log.start);
80102ead:	5a                   	pop    %edx
80102eae:	50                   	push   %eax
80102eaf:	53                   	push   %ebx
80102eb0:	e8 1b d2 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102eb5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102eb8:	83 c4 10             	add    $0x10,%esp
80102ebb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102ebd:	89 1d 08 27 11 80    	mov    %ebx,0x80112708
  for (i = 0; i < log.lh.n; i++) {
80102ec3:	7e 1c                	jle    80102ee1 <initlog+0x71>
80102ec5:	c1 e3 02             	shl    $0x2,%ebx
80102ec8:	31 d2                	xor    %edx,%edx
80102eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102ed0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ed4:	83 c2 04             	add    $0x4,%edx
80102ed7:	89 8a 08 27 11 80    	mov    %ecx,-0x7feed8f8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102edd:	39 d3                	cmp    %edx,%ebx
80102edf:	75 ef                	jne    80102ed0 <initlog+0x60>
  brelse(buf);
80102ee1:	83 ec 0c             	sub    $0xc,%esp
80102ee4:	50                   	push   %eax
80102ee5:	e8 f6 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102eea:	e8 81 fe ff ff       	call   80102d70 <install_trans>
  log.lh.n = 0;
80102eef:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
80102ef6:	00 00 00 
  write_head(); // clear the log
80102ef9:	e8 12 ff ff ff       	call   80102e10 <write_head>
}
80102efe:	83 c4 10             	add    $0x10,%esp
80102f01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f04:	c9                   	leave  
80102f05:	c3                   	ret    
80102f06:	8d 76 00             	lea    0x0(%esi),%esi
80102f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f16:	68 c0 26 11 80       	push   $0x801126c0
80102f1b:	e8 90 17 00 00       	call   801046b0 <acquire>
80102f20:	83 c4 10             	add    $0x10,%esp
80102f23:	eb 18                	jmp    80102f3d <begin_op+0x2d>
80102f25:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f28:	83 ec 08             	sub    $0x8,%esp
80102f2b:	68 c0 26 11 80       	push   $0x801126c0
80102f30:	68 c0 26 11 80       	push   $0x801126c0
80102f35:	e8 b6 11 00 00       	call   801040f0 <sleep>
80102f3a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f3d:	a1 00 27 11 80       	mov    0x80112700,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	75 e2                	jne    80102f28 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f46:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80102f4b:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80102f51:	83 c0 01             	add    $0x1,%eax
80102f54:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f57:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f5a:	83 fa 1e             	cmp    $0x1e,%edx
80102f5d:	7f c9                	jg     80102f28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f5f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f62:	a3 fc 26 11 80       	mov    %eax,0x801126fc
      release(&log.lock);
80102f67:	68 c0 26 11 80       	push   $0x801126c0
80102f6c:	e8 ff 17 00 00       	call   80104770 <release>
      break;
    }
  }
}
80102f71:	83 c4 10             	add    $0x10,%esp
80102f74:	c9                   	leave  
80102f75:	c3                   	ret    
80102f76:	8d 76 00             	lea    0x0(%esi),%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	57                   	push   %edi
80102f84:	56                   	push   %esi
80102f85:	53                   	push   %ebx
80102f86:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f89:	68 c0 26 11 80       	push   $0x801126c0
80102f8e:	e8 1d 17 00 00       	call   801046b0 <acquire>
  log.outstanding -= 1;
80102f93:	a1 fc 26 11 80       	mov    0x801126fc,%eax
  if(log.committing)
80102f98:	8b 35 00 27 11 80    	mov    0x80112700,%esi
80102f9e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fa1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102fa4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102fa6:	89 1d fc 26 11 80    	mov    %ebx,0x801126fc
  if(log.committing)
80102fac:	0f 85 1a 01 00 00    	jne    801030cc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102fb2:	85 db                	test   %ebx,%ebx
80102fb4:	0f 85 ee 00 00 00    	jne    801030a8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fba:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102fbd:	c7 05 00 27 11 80 01 	movl   $0x1,0x80112700
80102fc4:	00 00 00 
  release(&log.lock);
80102fc7:	68 c0 26 11 80       	push   $0x801126c0
80102fcc:	e8 9f 17 00 00       	call   80104770 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fd1:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102fd7:	83 c4 10             	add    $0x10,%esp
80102fda:	85 c9                	test   %ecx,%ecx
80102fdc:	0f 8e 85 00 00 00    	jle    80103067 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fe2:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80102fe7:	83 ec 08             	sub    $0x8,%esp
80102fea:	01 d8                	add    %ebx,%eax
80102fec:	83 c0 01             	add    $0x1,%eax
80102fef:	50                   	push   %eax
80102ff0:	ff 35 04 27 11 80    	pushl  0x80112704
80102ff6:	e8 d5 d0 ff ff       	call   801000d0 <bread>
80102ffb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ffd:	58                   	pop    %eax
80102ffe:	5a                   	pop    %edx
80102fff:	ff 34 9d 0c 27 11 80 	pushl  -0x7feed8f4(,%ebx,4)
80103006:	ff 35 04 27 11 80    	pushl  0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
8010300c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010300f:	e8 bc d0 ff ff       	call   801000d0 <bread>
80103014:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103016:	8d 40 5c             	lea    0x5c(%eax),%eax
80103019:	83 c4 0c             	add    $0xc,%esp
8010301c:	68 00 02 00 00       	push   $0x200
80103021:	50                   	push   %eax
80103022:	8d 46 5c             	lea    0x5c(%esi),%eax
80103025:	50                   	push   %eax
80103026:	e8 45 18 00 00       	call   80104870 <memmove>
    bwrite(to);  // write the log
8010302b:	89 34 24             	mov    %esi,(%esp)
8010302e:	e8 6d d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103033:	89 3c 24             	mov    %edi,(%esp)
80103036:	e8 a5 d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010303b:	89 34 24             	mov    %esi,(%esp)
8010303e:	e8 9d d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103043:	83 c4 10             	add    $0x10,%esp
80103046:	3b 1d 08 27 11 80    	cmp    0x80112708,%ebx
8010304c:	7c 94                	jl     80102fe2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010304e:	e8 bd fd ff ff       	call   80102e10 <write_head>
    install_trans(); // Now install writes to home locations
80103053:	e8 18 fd ff ff       	call   80102d70 <install_trans>
    log.lh.n = 0;
80103058:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
8010305f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103062:	e8 a9 fd ff ff       	call   80102e10 <write_head>
    acquire(&log.lock);
80103067:	83 ec 0c             	sub    $0xc,%esp
8010306a:	68 c0 26 11 80       	push   $0x801126c0
8010306f:	e8 3c 16 00 00       	call   801046b0 <acquire>
    wakeup(&log);
80103074:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
    log.committing = 0;
8010307b:	c7 05 00 27 11 80 00 	movl   $0x0,0x80112700
80103082:	00 00 00 
    wakeup(&log);
80103085:	e8 16 12 00 00       	call   801042a0 <wakeup>
    release(&log.lock);
8010308a:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80103091:	e8 da 16 00 00       	call   80104770 <release>
80103096:	83 c4 10             	add    $0x10,%esp
}
80103099:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309c:	5b                   	pop    %ebx
8010309d:	5e                   	pop    %esi
8010309e:	5f                   	pop    %edi
8010309f:	5d                   	pop    %ebp
801030a0:	c3                   	ret    
801030a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801030a8:	83 ec 0c             	sub    $0xc,%esp
801030ab:	68 c0 26 11 80       	push   $0x801126c0
801030b0:	e8 eb 11 00 00       	call   801042a0 <wakeup>
  release(&log.lock);
801030b5:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
801030bc:	e8 af 16 00 00       	call   80104770 <release>
801030c1:	83 c4 10             	add    $0x10,%esp
}
801030c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030c7:	5b                   	pop    %ebx
801030c8:	5e                   	pop    %esi
801030c9:	5f                   	pop    %edi
801030ca:	5d                   	pop    %ebp
801030cb:	c3                   	ret    
    panic("log.committing");
801030cc:	83 ec 0c             	sub    $0xc,%esp
801030cf:	68 c4 76 10 80       	push   $0x801076c4
801030d4:	e8 b7 d2 ff ff       	call   80100390 <panic>
801030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801030e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	53                   	push   %ebx
801030e4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030e7:	8b 15 08 27 11 80    	mov    0x80112708,%edx
{
801030ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030f0:	83 fa 1d             	cmp    $0x1d,%edx
801030f3:	0f 8f 9d 00 00 00    	jg     80103196 <log_write+0xb6>
801030f9:	a1 f8 26 11 80       	mov    0x801126f8,%eax
801030fe:	83 e8 01             	sub    $0x1,%eax
80103101:	39 c2                	cmp    %eax,%edx
80103103:	0f 8d 8d 00 00 00    	jge    80103196 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103109:	a1 fc 26 11 80       	mov    0x801126fc,%eax
8010310e:	85 c0                	test   %eax,%eax
80103110:	0f 8e 8d 00 00 00    	jle    801031a3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103116:	83 ec 0c             	sub    $0xc,%esp
80103119:	68 c0 26 11 80       	push   $0x801126c0
8010311e:	e8 8d 15 00 00       	call   801046b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103123:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80103129:	83 c4 10             	add    $0x10,%esp
8010312c:	83 f9 00             	cmp    $0x0,%ecx
8010312f:	7e 57                	jle    80103188 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103131:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103134:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103136:	3b 15 0c 27 11 80    	cmp    0x8011270c,%edx
8010313c:	75 0b                	jne    80103149 <log_write+0x69>
8010313e:	eb 38                	jmp    80103178 <log_write+0x98>
80103140:	39 14 85 0c 27 11 80 	cmp    %edx,-0x7feed8f4(,%eax,4)
80103147:	74 2f                	je     80103178 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103149:	83 c0 01             	add    $0x1,%eax
8010314c:	39 c1                	cmp    %eax,%ecx
8010314e:	75 f0                	jne    80103140 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103150:	89 14 85 0c 27 11 80 	mov    %edx,-0x7feed8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103157:	83 c0 01             	add    $0x1,%eax
8010315a:	a3 08 27 11 80       	mov    %eax,0x80112708
  b->flags |= B_DIRTY; // prevent eviction
8010315f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103162:	c7 45 08 c0 26 11 80 	movl   $0x801126c0,0x8(%ebp)
}
80103169:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010316c:	c9                   	leave  
  release(&log.lock);
8010316d:	e9 fe 15 00 00       	jmp    80104770 <release>
80103172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103178:	89 14 85 0c 27 11 80 	mov    %edx,-0x7feed8f4(,%eax,4)
8010317f:	eb de                	jmp    8010315f <log_write+0x7f>
80103181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103188:	8b 43 08             	mov    0x8(%ebx),%eax
8010318b:	a3 0c 27 11 80       	mov    %eax,0x8011270c
  if (i == log.lh.n)
80103190:	75 cd                	jne    8010315f <log_write+0x7f>
80103192:	31 c0                	xor    %eax,%eax
80103194:	eb c1                	jmp    80103157 <log_write+0x77>
    panic("too big a transaction");
80103196:	83 ec 0c             	sub    $0xc,%esp
80103199:	68 d3 76 10 80       	push   $0x801076d3
8010319e:	e8 ed d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801031a3:	83 ec 0c             	sub    $0xc,%esp
801031a6:	68 e9 76 10 80       	push   $0x801076e9
801031ab:	e8 e0 d1 ff ff       	call   80100390 <panic>

801031b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	53                   	push   %ebx
801031b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031b7:	e8 74 09 00 00       	call   80103b30 <cpuid>
801031bc:	89 c3                	mov    %eax,%ebx
801031be:	e8 6d 09 00 00       	call   80103b30 <cpuid>
801031c3:	83 ec 04             	sub    $0x4,%esp
801031c6:	53                   	push   %ebx
801031c7:	50                   	push   %eax
801031c8:	68 04 77 10 80       	push   $0x80107704
801031cd:	e8 8e d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801031d2:	e8 69 28 00 00       	call   80105a40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031d7:	e8 d4 08 00 00       	call   80103ab0 <mycpu>
801031dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031de:	b8 01 00 00 00       	mov    $0x1,%eax
801031e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031ea:	e8 21 0c 00 00       	call   80103e10 <scheduler>
801031ef:	90                   	nop

801031f0 <mpenter>:
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031f6:	e8 35 39 00 00       	call   80106b30 <switchkvm>
  seginit();
801031fb:	e8 a0 38 00 00       	call   80106aa0 <seginit>
  lapicinit();
80103200:	e8 9b f7 ff ff       	call   801029a0 <lapicinit>
  mpmain();
80103205:	e8 a6 ff ff ff       	call   801031b0 <mpmain>
8010320a:	66 90                	xchg   %ax,%ax
8010320c:	66 90                	xchg   %ax,%ax
8010320e:	66 90                	xchg   %ax,%ax

80103210 <main>:
{
80103210:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103214:	83 e4 f0             	and    $0xfffffff0,%esp
80103217:	ff 71 fc             	pushl  -0x4(%ecx)
8010321a:	55                   	push   %ebp
8010321b:	89 e5                	mov    %esp,%ebp
8010321d:	53                   	push   %ebx
8010321e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010321f:	83 ec 08             	sub    $0x8,%esp
80103222:	68 00 00 40 80       	push   $0x80400000
80103227:	68 e8 54 11 80       	push   $0x801154e8
8010322c:	e8 2f f5 ff ff       	call   80102760 <kinit1>
  kvmalloc();      // kernel page table
80103231:	e8 ca 3d 00 00       	call   80107000 <kvmalloc>
  mpinit();        // detect other processors
80103236:	e8 75 01 00 00       	call   801033b0 <mpinit>
  lapicinit();     // interrupt controller
8010323b:	e8 60 f7 ff ff       	call   801029a0 <lapicinit>
  seginit();       // segment descriptors
80103240:	e8 5b 38 00 00       	call   80106aa0 <seginit>
  picinit();       // disable pic
80103245:	e8 46 03 00 00       	call   80103590 <picinit>
  ioapicinit();    // another interrupt controller
8010324a:	e8 41 f3 ff ff       	call   80102590 <ioapicinit>
  consoleinit();   // console hardware
8010324f:	e8 cc da ff ff       	call   80100d20 <consoleinit>
  uartinit();      // serial port
80103254:	e8 17 2b 00 00       	call   80105d70 <uartinit>
  pinit();         // process table
80103259:	e8 32 08 00 00       	call   80103a90 <pinit>
  tvinit();        // trap vectors
8010325e:	e8 5d 27 00 00       	call   801059c0 <tvinit>
  binit();         // buffer cache
80103263:	e8 d8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103268:	e8 53 de ff ff       	call   801010c0 <fileinit>
  ideinit();       // disk 
8010326d:	e8 fe f0 ff ff       	call   80102370 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103272:	83 c4 0c             	add    $0xc,%esp
80103275:	68 8a 00 00 00       	push   $0x8a
8010327a:	68 8c a4 10 80       	push   $0x8010a48c
8010327f:	68 00 70 00 80       	push   $0x80007000
80103284:	e8 e7 15 00 00       	call   80104870 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103289:	69 05 40 2d 11 80 b0 	imul   $0xb0,0x80112d40,%eax
80103290:	00 00 00 
80103293:	83 c4 10             	add    $0x10,%esp
80103296:	05 c0 27 11 80       	add    $0x801127c0,%eax
8010329b:	3d c0 27 11 80       	cmp    $0x801127c0,%eax
801032a0:	76 71                	jbe    80103313 <main+0x103>
801032a2:	bb c0 27 11 80       	mov    $0x801127c0,%ebx
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801032b0:	e8 fb 07 00 00       	call   80103ab0 <mycpu>
801032b5:	39 d8                	cmp    %ebx,%eax
801032b7:	74 41                	je     801032fa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032b9:	e8 72 f5 ff ff       	call   80102830 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801032be:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801032c3:	c7 05 f8 6f 00 80 f0 	movl   $0x801031f0,0x80006ff8
801032ca:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032cd:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801032d4:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801032d7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801032dc:	0f b6 03             	movzbl (%ebx),%eax
801032df:	83 ec 08             	sub    $0x8,%esp
801032e2:	68 00 70 00 00       	push   $0x7000
801032e7:	50                   	push   %eax
801032e8:	e8 03 f8 ff ff       	call   80102af0 <lapicstartap>
801032ed:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032f6:	85 c0                	test   %eax,%eax
801032f8:	74 f6                	je     801032f0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801032fa:	69 05 40 2d 11 80 b0 	imul   $0xb0,0x80112d40,%eax
80103301:	00 00 00 
80103304:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010330a:	05 c0 27 11 80       	add    $0x801127c0,%eax
8010330f:	39 c3                	cmp    %eax,%ebx
80103311:	72 9d                	jb     801032b0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103313:	83 ec 08             	sub    $0x8,%esp
80103316:	68 00 00 00 8e       	push   $0x8e000000
8010331b:	68 00 00 40 80       	push   $0x80400000
80103320:	e8 ab f4 ff ff       	call   801027d0 <kinit2>
  userinit();      // first user process
80103325:	e8 56 08 00 00       	call   80103b80 <userinit>
  mpmain();        // finish this processor's setup
8010332a:	e8 81 fe ff ff       	call   801031b0 <mpmain>
8010332f:	90                   	nop

80103330 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	57                   	push   %edi
80103334:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103335:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010333b:	53                   	push   %ebx
  e = addr+len;
8010333c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010333f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103342:	39 de                	cmp    %ebx,%esi
80103344:	72 10                	jb     80103356 <mpsearch1+0x26>
80103346:	eb 50                	jmp    80103398 <mpsearch1+0x68>
80103348:	90                   	nop
80103349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103350:	39 fb                	cmp    %edi,%ebx
80103352:	89 fe                	mov    %edi,%esi
80103354:	76 42                	jbe    80103398 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103356:	83 ec 04             	sub    $0x4,%esp
80103359:	8d 7e 10             	lea    0x10(%esi),%edi
8010335c:	6a 04                	push   $0x4
8010335e:	68 18 77 10 80       	push   $0x80107718
80103363:	56                   	push   %esi
80103364:	e8 a7 14 00 00       	call   80104810 <memcmp>
80103369:	83 c4 10             	add    $0x10,%esp
8010336c:	85 c0                	test   %eax,%eax
8010336e:	75 e0                	jne    80103350 <mpsearch1+0x20>
80103370:	89 f1                	mov    %esi,%ecx
80103372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103378:	0f b6 11             	movzbl (%ecx),%edx
8010337b:	83 c1 01             	add    $0x1,%ecx
8010337e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103380:	39 f9                	cmp    %edi,%ecx
80103382:	75 f4                	jne    80103378 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103384:	84 c0                	test   %al,%al
80103386:	75 c8                	jne    80103350 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103388:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010338b:	89 f0                	mov    %esi,%eax
8010338d:	5b                   	pop    %ebx
8010338e:	5e                   	pop    %esi
8010338f:	5f                   	pop    %edi
80103390:	5d                   	pop    %ebp
80103391:	c3                   	ret    
80103392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103398:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010339b:	31 f6                	xor    %esi,%esi
}
8010339d:	89 f0                	mov    %esi,%eax
8010339f:	5b                   	pop    %ebx
801033a0:	5e                   	pop    %esi
801033a1:	5f                   	pop    %edi
801033a2:	5d                   	pop    %ebp
801033a3:	c3                   	ret    
801033a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801033b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	57                   	push   %edi
801033b4:	56                   	push   %esi
801033b5:	53                   	push   %ebx
801033b6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033c7:	c1 e0 08             	shl    $0x8,%eax
801033ca:	09 d0                	or     %edx,%eax
801033cc:	c1 e0 04             	shl    $0x4,%eax
801033cf:	85 c0                	test   %eax,%eax
801033d1:	75 1b                	jne    801033ee <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801033d3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033da:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033e1:	c1 e0 08             	shl    $0x8,%eax
801033e4:	09 d0                	or     %edx,%eax
801033e6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801033e9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801033ee:	ba 00 04 00 00       	mov    $0x400,%edx
801033f3:	e8 38 ff ff ff       	call   80103330 <mpsearch1>
801033f8:	85 c0                	test   %eax,%eax
801033fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801033fd:	0f 84 3d 01 00 00    	je     80103540 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103406:	8b 58 04             	mov    0x4(%eax),%ebx
80103409:	85 db                	test   %ebx,%ebx
8010340b:	0f 84 4f 01 00 00    	je     80103560 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103411:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103417:	83 ec 04             	sub    $0x4,%esp
8010341a:	6a 04                	push   $0x4
8010341c:	68 35 77 10 80       	push   $0x80107735
80103421:	56                   	push   %esi
80103422:	e8 e9 13 00 00       	call   80104810 <memcmp>
80103427:	83 c4 10             	add    $0x10,%esp
8010342a:	85 c0                	test   %eax,%eax
8010342c:	0f 85 2e 01 00 00    	jne    80103560 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103432:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103439:	3c 01                	cmp    $0x1,%al
8010343b:	0f 95 c2             	setne  %dl
8010343e:	3c 04                	cmp    $0x4,%al
80103440:	0f 95 c0             	setne  %al
80103443:	20 c2                	and    %al,%dl
80103445:	0f 85 15 01 00 00    	jne    80103560 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010344b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103452:	66 85 ff             	test   %di,%di
80103455:	74 1a                	je     80103471 <mpinit+0xc1>
80103457:	89 f0                	mov    %esi,%eax
80103459:	01 f7                	add    %esi,%edi
  sum = 0;
8010345b:	31 d2                	xor    %edx,%edx
8010345d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103460:	0f b6 08             	movzbl (%eax),%ecx
80103463:	83 c0 01             	add    $0x1,%eax
80103466:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103468:	39 c7                	cmp    %eax,%edi
8010346a:	75 f4                	jne    80103460 <mpinit+0xb0>
8010346c:	84 d2                	test   %dl,%dl
8010346e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103471:	85 f6                	test   %esi,%esi
80103473:	0f 84 e7 00 00 00    	je     80103560 <mpinit+0x1b0>
80103479:	84 d2                	test   %dl,%dl
8010347b:	0f 85 df 00 00 00    	jne    80103560 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103481:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103487:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010348c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103493:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103499:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010349e:	01 d6                	add    %edx,%esi
801034a0:	39 c6                	cmp    %eax,%esi
801034a2:	76 23                	jbe    801034c7 <mpinit+0x117>
    switch(*p){
801034a4:	0f b6 10             	movzbl (%eax),%edx
801034a7:	80 fa 04             	cmp    $0x4,%dl
801034aa:	0f 87 ca 00 00 00    	ja     8010357a <mpinit+0x1ca>
801034b0:	ff 24 95 5c 77 10 80 	jmp    *-0x7fef88a4(,%edx,4)
801034b7:	89 f6                	mov    %esi,%esi
801034b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034c0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034c3:	39 c6                	cmp    %eax,%esi
801034c5:	77 dd                	ja     801034a4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034c7:	85 db                	test   %ebx,%ebx
801034c9:	0f 84 9e 00 00 00    	je     8010356d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034d2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801034d6:	74 15                	je     801034ed <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034d8:	b8 70 00 00 00       	mov    $0x70,%eax
801034dd:	ba 22 00 00 00       	mov    $0x22,%edx
801034e2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034e3:	ba 23 00 00 00       	mov    $0x23,%edx
801034e8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801034e9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034ec:	ee                   	out    %al,(%dx)
  }
}
801034ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034f0:	5b                   	pop    %ebx
801034f1:	5e                   	pop    %esi
801034f2:	5f                   	pop    %edi
801034f3:	5d                   	pop    %ebp
801034f4:	c3                   	ret    
801034f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801034f8:	8b 0d 40 2d 11 80    	mov    0x80112d40,%ecx
801034fe:	83 f9 07             	cmp    $0x7,%ecx
80103501:	7f 19                	jg     8010351c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103503:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103507:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010350d:	83 c1 01             	add    $0x1,%ecx
80103510:	89 0d 40 2d 11 80    	mov    %ecx,0x80112d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103516:	88 97 c0 27 11 80    	mov    %dl,-0x7feed840(%edi)
      p += sizeof(struct mpproc);
8010351c:	83 c0 14             	add    $0x14,%eax
      continue;
8010351f:	e9 7c ff ff ff       	jmp    801034a0 <mpinit+0xf0>
80103524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103528:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010352c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010352f:	88 15 a0 27 11 80    	mov    %dl,0x801127a0
      continue;
80103535:	e9 66 ff ff ff       	jmp    801034a0 <mpinit+0xf0>
8010353a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103540:	ba 00 00 01 00       	mov    $0x10000,%edx
80103545:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010354a:	e8 e1 fd ff ff       	call   80103330 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010354f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103551:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103554:	0f 85 a9 fe ff ff    	jne    80103403 <mpinit+0x53>
8010355a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	68 1d 77 10 80       	push   $0x8010771d
80103568:	e8 23 ce ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010356d:	83 ec 0c             	sub    $0xc,%esp
80103570:	68 3c 77 10 80       	push   $0x8010773c
80103575:	e8 16 ce ff ff       	call   80100390 <panic>
      ismp = 0;
8010357a:	31 db                	xor    %ebx,%ebx
8010357c:	e9 26 ff ff ff       	jmp    801034a7 <mpinit+0xf7>
80103581:	66 90                	xchg   %ax,%ax
80103583:	66 90                	xchg   %ax,%ax
80103585:	66 90                	xchg   %ax,%ax
80103587:	66 90                	xchg   %ax,%ax
80103589:	66 90                	xchg   %ax,%ax
8010358b:	66 90                	xchg   %ax,%ax
8010358d:	66 90                	xchg   %ax,%ax
8010358f:	90                   	nop

80103590 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103590:	55                   	push   %ebp
80103591:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103596:	ba 21 00 00 00       	mov    $0x21,%edx
8010359b:	89 e5                	mov    %esp,%ebp
8010359d:	ee                   	out    %al,(%dx)
8010359e:	ba a1 00 00 00       	mov    $0xa1,%edx
801035a3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035a4:	5d                   	pop    %ebp
801035a5:	c3                   	ret    
801035a6:	66 90                	xchg   %ax,%ax
801035a8:	66 90                	xchg   %ax,%ax
801035aa:	66 90                	xchg   %ax,%ax
801035ac:	66 90                	xchg   %ax,%ax
801035ae:	66 90                	xchg   %ax,%ax

801035b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	57                   	push   %edi
801035b4:	56                   	push   %esi
801035b5:	53                   	push   %ebx
801035b6:	83 ec 0c             	sub    $0xc,%esp
801035b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035bf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801035c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035cb:	e8 10 db ff ff       	call   801010e0 <filealloc>
801035d0:	85 c0                	test   %eax,%eax
801035d2:	89 03                	mov    %eax,(%ebx)
801035d4:	74 22                	je     801035f8 <pipealloc+0x48>
801035d6:	e8 05 db ff ff       	call   801010e0 <filealloc>
801035db:	85 c0                	test   %eax,%eax
801035dd:	89 06                	mov    %eax,(%esi)
801035df:	74 3f                	je     80103620 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035e1:	e8 4a f2 ff ff       	call   80102830 <kalloc>
801035e6:	85 c0                	test   %eax,%eax
801035e8:	89 c7                	mov    %eax,%edi
801035ea:	75 54                	jne    80103640 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801035ec:	8b 03                	mov    (%ebx),%eax
801035ee:	85 c0                	test   %eax,%eax
801035f0:	75 34                	jne    80103626 <pipealloc+0x76>
801035f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801035f8:	8b 06                	mov    (%esi),%eax
801035fa:	85 c0                	test   %eax,%eax
801035fc:	74 0c                	je     8010360a <pipealloc+0x5a>
    fileclose(*f1);
801035fe:	83 ec 0c             	sub    $0xc,%esp
80103601:	50                   	push   %eax
80103602:	e8 99 db ff ff       	call   801011a0 <fileclose>
80103607:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010360a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010360d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103612:	5b                   	pop    %ebx
80103613:	5e                   	pop    %esi
80103614:	5f                   	pop    %edi
80103615:	5d                   	pop    %ebp
80103616:	c3                   	ret    
80103617:	89 f6                	mov    %esi,%esi
80103619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103620:	8b 03                	mov    (%ebx),%eax
80103622:	85 c0                	test   %eax,%eax
80103624:	74 e4                	je     8010360a <pipealloc+0x5a>
    fileclose(*f0);
80103626:	83 ec 0c             	sub    $0xc,%esp
80103629:	50                   	push   %eax
8010362a:	e8 71 db ff ff       	call   801011a0 <fileclose>
  if(*f1)
8010362f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103631:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103634:	85 c0                	test   %eax,%eax
80103636:	75 c6                	jne    801035fe <pipealloc+0x4e>
80103638:	eb d0                	jmp    8010360a <pipealloc+0x5a>
8010363a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103640:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103643:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010364a:	00 00 00 
  p->writeopen = 1;
8010364d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103654:	00 00 00 
  p->nwrite = 0;
80103657:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010365e:	00 00 00 
  p->nread = 0;
80103661:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103668:	00 00 00 
  initlock(&p->lock, "pipe");
8010366b:	68 70 77 10 80       	push   $0x80107770
80103670:	50                   	push   %eax
80103671:	e8 fa 0e 00 00       	call   80104570 <initlock>
  (*f0)->type = FD_PIPE;
80103676:	8b 03                	mov    (%ebx),%eax
  return 0;
80103678:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010367b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103681:	8b 03                	mov    (%ebx),%eax
80103683:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103687:	8b 03                	mov    (%ebx),%eax
80103689:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010368d:	8b 03                	mov    (%ebx),%eax
8010368f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103692:	8b 06                	mov    (%esi),%eax
80103694:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010369a:	8b 06                	mov    (%esi),%eax
8010369c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036a0:	8b 06                	mov    (%esi),%eax
801036a2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036a6:	8b 06                	mov    (%esi),%eax
801036a8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801036ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036ae:	31 c0                	xor    %eax,%eax
}
801036b0:	5b                   	pop    %ebx
801036b1:	5e                   	pop    %esi
801036b2:	5f                   	pop    %edi
801036b3:	5d                   	pop    %ebp
801036b4:	c3                   	ret    
801036b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036c0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	56                   	push   %esi
801036c4:	53                   	push   %ebx
801036c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036cb:	83 ec 0c             	sub    $0xc,%esp
801036ce:	53                   	push   %ebx
801036cf:	e8 dc 0f 00 00       	call   801046b0 <acquire>
  if(writable){
801036d4:	83 c4 10             	add    $0x10,%esp
801036d7:	85 f6                	test   %esi,%esi
801036d9:	74 45                	je     80103720 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801036db:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036e1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801036e4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036eb:	00 00 00 
    wakeup(&p->nread);
801036ee:	50                   	push   %eax
801036ef:	e8 ac 0b 00 00       	call   801042a0 <wakeup>
801036f4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036f7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036fd:	85 d2                	test   %edx,%edx
801036ff:	75 0a                	jne    8010370b <pipeclose+0x4b>
80103701:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103707:	85 c0                	test   %eax,%eax
80103709:	74 35                	je     80103740 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010370b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010370e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103711:	5b                   	pop    %ebx
80103712:	5e                   	pop    %esi
80103713:	5d                   	pop    %ebp
    release(&p->lock);
80103714:	e9 57 10 00 00       	jmp    80104770 <release>
80103719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103720:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103726:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103729:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103730:	00 00 00 
    wakeup(&p->nwrite);
80103733:	50                   	push   %eax
80103734:	e8 67 0b 00 00       	call   801042a0 <wakeup>
80103739:	83 c4 10             	add    $0x10,%esp
8010373c:	eb b9                	jmp    801036f7 <pipeclose+0x37>
8010373e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	53                   	push   %ebx
80103744:	e8 27 10 00 00       	call   80104770 <release>
    kfree((char*)p);
80103749:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010374c:	83 c4 10             	add    $0x10,%esp
}
8010374f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103752:	5b                   	pop    %ebx
80103753:	5e                   	pop    %esi
80103754:	5d                   	pop    %ebp
    kfree((char*)p);
80103755:	e9 26 ef ff ff       	jmp    80102680 <kfree>
8010375a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103760 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	57                   	push   %edi
80103764:	56                   	push   %esi
80103765:	53                   	push   %ebx
80103766:	83 ec 28             	sub    $0x28,%esp
80103769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010376c:	53                   	push   %ebx
8010376d:	e8 3e 0f 00 00       	call   801046b0 <acquire>
  for(i = 0; i < n; i++){
80103772:	8b 45 10             	mov    0x10(%ebp),%eax
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	85 c0                	test   %eax,%eax
8010377a:	0f 8e c9 00 00 00    	jle    80103849 <pipewrite+0xe9>
80103780:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103783:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103789:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010378f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103792:	03 4d 10             	add    0x10(%ebp),%ecx
80103795:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103798:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010379e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801037a4:	39 d0                	cmp    %edx,%eax
801037a6:	75 71                	jne    80103819 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801037a8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037ae:	85 c0                	test   %eax,%eax
801037b0:	74 4e                	je     80103800 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037b2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801037b8:	eb 3a                	jmp    801037f4 <pipewrite+0x94>
801037ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	57                   	push   %edi
801037c4:	e8 d7 0a 00 00       	call   801042a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037c9:	5a                   	pop    %edx
801037ca:	59                   	pop    %ecx
801037cb:	53                   	push   %ebx
801037cc:	56                   	push   %esi
801037cd:	e8 1e 09 00 00       	call   801040f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037d2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037d8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037de:	83 c4 10             	add    $0x10,%esp
801037e1:	05 00 02 00 00       	add    $0x200,%eax
801037e6:	39 c2                	cmp    %eax,%edx
801037e8:	75 36                	jne    80103820 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801037ea:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037f0:	85 c0                	test   %eax,%eax
801037f2:	74 0c                	je     80103800 <pipewrite+0xa0>
801037f4:	e8 57 03 00 00       	call   80103b50 <myproc>
801037f9:	8b 40 24             	mov    0x24(%eax),%eax
801037fc:	85 c0                	test   %eax,%eax
801037fe:	74 c0                	je     801037c0 <pipewrite+0x60>
        release(&p->lock);
80103800:	83 ec 0c             	sub    $0xc,%esp
80103803:	53                   	push   %ebx
80103804:	e8 67 0f 00 00       	call   80104770 <release>
        return -1;
80103809:	83 c4 10             	add    $0x10,%esp
8010380c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103811:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103814:	5b                   	pop    %ebx
80103815:	5e                   	pop    %esi
80103816:	5f                   	pop    %edi
80103817:	5d                   	pop    %ebp
80103818:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103819:	89 c2                	mov    %eax,%edx
8010381b:	90                   	nop
8010381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103820:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103823:	8d 42 01             	lea    0x1(%edx),%eax
80103826:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010382c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103832:	83 c6 01             	add    $0x1,%esi
80103835:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103839:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010383c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010383f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103843:	0f 85 4f ff ff ff    	jne    80103798 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103849:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010384f:	83 ec 0c             	sub    $0xc,%esp
80103852:	50                   	push   %eax
80103853:	e8 48 0a 00 00       	call   801042a0 <wakeup>
  release(&p->lock);
80103858:	89 1c 24             	mov    %ebx,(%esp)
8010385b:	e8 10 0f 00 00       	call   80104770 <release>
  return n;
80103860:	83 c4 10             	add    $0x10,%esp
80103863:	8b 45 10             	mov    0x10(%ebp),%eax
80103866:	eb a9                	jmp    80103811 <pipewrite+0xb1>
80103868:	90                   	nop
80103869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103870 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	57                   	push   %edi
80103874:	56                   	push   %esi
80103875:	53                   	push   %ebx
80103876:	83 ec 18             	sub    $0x18,%esp
80103879:	8b 75 08             	mov    0x8(%ebp),%esi
8010387c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010387f:	56                   	push   %esi
80103880:	e8 2b 0e 00 00       	call   801046b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103885:	83 c4 10             	add    $0x10,%esp
80103888:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010388e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103894:	75 6a                	jne    80103900 <piperead+0x90>
80103896:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010389c:	85 db                	test   %ebx,%ebx
8010389e:	0f 84 c4 00 00 00    	je     80103968 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038a4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038aa:	eb 2d                	jmp    801038d9 <piperead+0x69>
801038ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038b0:	83 ec 08             	sub    $0x8,%esp
801038b3:	56                   	push   %esi
801038b4:	53                   	push   %ebx
801038b5:	e8 36 08 00 00       	call   801040f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038ba:	83 c4 10             	add    $0x10,%esp
801038bd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801038c3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801038c9:	75 35                	jne    80103900 <piperead+0x90>
801038cb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801038d1:	85 d2                	test   %edx,%edx
801038d3:	0f 84 8f 00 00 00    	je     80103968 <piperead+0xf8>
    if(myproc()->killed){
801038d9:	e8 72 02 00 00       	call   80103b50 <myproc>
801038de:	8b 48 24             	mov    0x24(%eax),%ecx
801038e1:	85 c9                	test   %ecx,%ecx
801038e3:	74 cb                	je     801038b0 <piperead+0x40>
      release(&p->lock);
801038e5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038e8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038ed:	56                   	push   %esi
801038ee:	e8 7d 0e 00 00       	call   80104770 <release>
      return -1;
801038f3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038f9:	89 d8                	mov    %ebx,%eax
801038fb:	5b                   	pop    %ebx
801038fc:	5e                   	pop    %esi
801038fd:	5f                   	pop    %edi
801038fe:	5d                   	pop    %ebp
801038ff:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103900:	8b 45 10             	mov    0x10(%ebp),%eax
80103903:	85 c0                	test   %eax,%eax
80103905:	7e 61                	jle    80103968 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103907:	31 db                	xor    %ebx,%ebx
80103909:	eb 13                	jmp    8010391e <piperead+0xae>
8010390b:	90                   	nop
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103910:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103916:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010391c:	74 1f                	je     8010393d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010391e:	8d 41 01             	lea    0x1(%ecx),%eax
80103921:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103927:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010392d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103932:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103935:	83 c3 01             	add    $0x1,%ebx
80103938:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010393b:	75 d3                	jne    80103910 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010393d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103943:	83 ec 0c             	sub    $0xc,%esp
80103946:	50                   	push   %eax
80103947:	e8 54 09 00 00       	call   801042a0 <wakeup>
  release(&p->lock);
8010394c:	89 34 24             	mov    %esi,(%esp)
8010394f:	e8 1c 0e 00 00       	call   80104770 <release>
  return i;
80103954:	83 c4 10             	add    $0x10,%esp
}
80103957:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010395a:	89 d8                	mov    %ebx,%eax
8010395c:	5b                   	pop    %ebx
8010395d:	5e                   	pop    %esi
8010395e:	5f                   	pop    %edi
8010395f:	5d                   	pop    %ebp
80103960:	c3                   	ret    
80103961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103968:	31 db                	xor    %ebx,%ebx
8010396a:	eb d1                	jmp    8010393d <piperead+0xcd>
8010396c:	66 90                	xchg   %ax,%ax
8010396e:	66 90                	xchg   %ax,%ax

80103970 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103974:	bb 94 2d 11 80       	mov    $0x80112d94,%ebx
{
80103979:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010397c:	68 60 2d 11 80       	push   $0x80112d60
80103981:	e8 2a 0d 00 00       	call   801046b0 <acquire>
80103986:	83 c4 10             	add    $0x10,%esp
80103989:	eb 10                	jmp    8010399b <allocproc+0x2b>
8010398b:	90                   	nop
8010398c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103990:	83 c3 7c             	add    $0x7c,%ebx
80103993:	81 fb 94 4c 11 80    	cmp    $0x80114c94,%ebx
80103999:	73 75                	jae    80103a10 <allocproc+0xa0>
    if(p->state == UNUSED)
8010399b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010399e:	85 c0                	test   %eax,%eax
801039a0:	75 ee                	jne    80103990 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039a2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801039a7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039aa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801039b1:	8d 50 01             	lea    0x1(%eax),%edx
801039b4:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801039b7:	68 60 2d 11 80       	push   $0x80112d60
  p->pid = nextpid++;
801039bc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801039c2:	e8 a9 0d 00 00       	call   80104770 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039c7:	e8 64 ee ff ff       	call   80102830 <kalloc>
801039cc:	83 c4 10             	add    $0x10,%esp
801039cf:	85 c0                	test   %eax,%eax
801039d1:	89 43 08             	mov    %eax,0x8(%ebx)
801039d4:	74 53                	je     80103a29 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039d6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039dc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039df:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801039e4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801039e7:	c7 40 14 b2 59 10 80 	movl   $0x801059b2,0x14(%eax)
  p->context = (struct context*)sp;
801039ee:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039f1:	6a 14                	push   $0x14
801039f3:	6a 00                	push   $0x0
801039f5:	50                   	push   %eax
801039f6:	e8 c5 0d 00 00       	call   801047c0 <memset>
  p->context->eip = (uint)forkret;
801039fb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801039fe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a01:	c7 40 10 40 3a 10 80 	movl   $0x80103a40,0x10(%eax)
}
80103a08:	89 d8                	mov    %ebx,%eax
80103a0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a0d:	c9                   	leave  
80103a0e:	c3                   	ret    
80103a0f:	90                   	nop
  release(&ptable.lock);
80103a10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a13:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a15:	68 60 2d 11 80       	push   $0x80112d60
80103a1a:	e8 51 0d 00 00       	call   80104770 <release>
}
80103a1f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a21:	83 c4 10             	add    $0x10,%esp
}
80103a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a27:	c9                   	leave  
80103a28:	c3                   	ret    
    p->state = UNUSED;
80103a29:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a30:	31 db                	xor    %ebx,%ebx
80103a32:	eb d4                	jmp    80103a08 <allocproc+0x98>
80103a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a46:	68 60 2d 11 80       	push   $0x80112d60
80103a4b:	e8 20 0d 00 00       	call   80104770 <release>

  if (first) {
80103a50:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103a55:	83 c4 10             	add    $0x10,%esp
80103a58:	85 c0                	test   %eax,%eax
80103a5a:	75 04                	jne    80103a60 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a5c:	c9                   	leave  
80103a5d:	c3                   	ret    
80103a5e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103a60:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103a63:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103a6a:	00 00 00 
    iinit(ROOTDEV);
80103a6d:	6a 01                	push   $0x1
80103a6f:	e8 7c dd ff ff       	call   801017f0 <iinit>
    initlog(ROOTDEV);
80103a74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a7b:	e8 f0 f3 ff ff       	call   80102e70 <initlog>
80103a80:	83 c4 10             	add    $0x10,%esp
}
80103a83:	c9                   	leave  
80103a84:	c3                   	ret    
80103a85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a90 <pinit>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a96:	68 75 77 10 80       	push   $0x80107775
80103a9b:	68 60 2d 11 80       	push   $0x80112d60
80103aa0:	e8 cb 0a 00 00       	call   80104570 <initlock>
}
80103aa5:	83 c4 10             	add    $0x10,%esp
80103aa8:	c9                   	leave  
80103aa9:	c3                   	ret    
80103aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ab0 <mycpu>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ab5:	9c                   	pushf  
80103ab6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ab7:	f6 c4 02             	test   $0x2,%ah
80103aba:	75 5e                	jne    80103b1a <mycpu+0x6a>
  apicid = lapicid();
80103abc:	e8 df ef ff ff       	call   80102aa0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ac1:	8b 35 40 2d 11 80    	mov    0x80112d40,%esi
80103ac7:	85 f6                	test   %esi,%esi
80103ac9:	7e 42                	jle    80103b0d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103acb:	0f b6 15 c0 27 11 80 	movzbl 0x801127c0,%edx
80103ad2:	39 d0                	cmp    %edx,%eax
80103ad4:	74 30                	je     80103b06 <mycpu+0x56>
80103ad6:	b9 70 28 11 80       	mov    $0x80112870,%ecx
  for (i = 0; i < ncpu; ++i) {
80103adb:	31 d2                	xor    %edx,%edx
80103add:	8d 76 00             	lea    0x0(%esi),%esi
80103ae0:	83 c2 01             	add    $0x1,%edx
80103ae3:	39 f2                	cmp    %esi,%edx
80103ae5:	74 26                	je     80103b0d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103ae7:	0f b6 19             	movzbl (%ecx),%ebx
80103aea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103af0:	39 c3                	cmp    %eax,%ebx
80103af2:	75 ec                	jne    80103ae0 <mycpu+0x30>
80103af4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103afa:	05 c0 27 11 80       	add    $0x801127c0,%eax
}
80103aff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b02:	5b                   	pop    %ebx
80103b03:	5e                   	pop    %esi
80103b04:	5d                   	pop    %ebp
80103b05:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103b06:	b8 c0 27 11 80       	mov    $0x801127c0,%eax
      return &cpus[i];
80103b0b:	eb f2                	jmp    80103aff <mycpu+0x4f>
  panic("unknown apicid\n");
80103b0d:	83 ec 0c             	sub    $0xc,%esp
80103b10:	68 7c 77 10 80       	push   $0x8010777c
80103b15:	e8 76 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b1a:	83 ec 0c             	sub    $0xc,%esp
80103b1d:	68 58 78 10 80       	push   $0x80107858
80103b22:	e8 69 c8 ff ff       	call   80100390 <panic>
80103b27:	89 f6                	mov    %esi,%esi
80103b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b30 <cpuid>:
cpuid() {
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b36:	e8 75 ff ff ff       	call   80103ab0 <mycpu>
80103b3b:	2d c0 27 11 80       	sub    $0x801127c0,%eax
}
80103b40:	c9                   	leave  
  return mycpu()-cpus;
80103b41:	c1 f8 04             	sar    $0x4,%eax
80103b44:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b4a:	c3                   	ret    
80103b4b:	90                   	nop
80103b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b50 <myproc>:
myproc(void) {
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
80103b54:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b57:	e8 84 0a 00 00       	call   801045e0 <pushcli>
  c = mycpu();
80103b5c:	e8 4f ff ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103b61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b67:	e8 b4 0a 00 00       	call   80104620 <popcli>
}
80103b6c:	83 c4 04             	add    $0x4,%esp
80103b6f:	89 d8                	mov    %ebx,%eax
80103b71:	5b                   	pop    %ebx
80103b72:	5d                   	pop    %ebp
80103b73:	c3                   	ret    
80103b74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b80 <userinit>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	53                   	push   %ebx
80103b84:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b87:	e8 e4 fd ff ff       	call   80103970 <allocproc>
80103b8c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b8e:	a3 f8 a5 10 80       	mov    %eax,0x8010a5f8
  if((p->pgdir = setupkvm()) == 0)
80103b93:	e8 e8 33 00 00       	call   80106f80 <setupkvm>
80103b98:	85 c0                	test   %eax,%eax
80103b9a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b9d:	0f 84 bd 00 00 00    	je     80103c60 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ba3:	83 ec 04             	sub    $0x4,%esp
80103ba6:	68 2c 00 00 00       	push   $0x2c
80103bab:	68 60 a4 10 80       	push   $0x8010a460
80103bb0:	50                   	push   %eax
80103bb1:	e8 aa 30 00 00       	call   80106c60 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bb6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bb9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bbf:	6a 4c                	push   $0x4c
80103bc1:	6a 00                	push   $0x0
80103bc3:	ff 73 18             	pushl  0x18(%ebx)
80103bc6:	e8 f5 0b 00 00       	call   801047c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bcb:	8b 43 18             	mov    0x18(%ebx),%eax
80103bce:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bd3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bd8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bdb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bdf:	8b 43 18             	mov    0x18(%ebx),%eax
80103be2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103be6:	8b 43 18             	mov    0x18(%ebx),%eax
80103be9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bf1:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bf8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bfc:	8b 43 18             	mov    0x18(%ebx),%eax
80103bff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c06:	8b 43 18             	mov    0x18(%ebx),%eax
80103c09:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c10:	8b 43 18             	mov    0x18(%ebx),%eax
80103c13:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c1a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c1d:	6a 10                	push   $0x10
80103c1f:	68 a5 77 10 80       	push   $0x801077a5
80103c24:	50                   	push   %eax
80103c25:	e8 76 0d 00 00       	call   801049a0 <safestrcpy>
  p->cwd = namei("/");
80103c2a:	c7 04 24 ae 77 10 80 	movl   $0x801077ae,(%esp)
80103c31:	e8 1a e6 ff ff       	call   80102250 <namei>
80103c36:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c39:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103c40:	e8 6b 0a 00 00       	call   801046b0 <acquire>
  p->state = RUNNABLE;
80103c45:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c4c:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103c53:	e8 18 0b 00 00       	call   80104770 <release>
}
80103c58:	83 c4 10             	add    $0x10,%esp
80103c5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c5e:	c9                   	leave  
80103c5f:	c3                   	ret    
    panic("userinit: out of memory?");
80103c60:	83 ec 0c             	sub    $0xc,%esp
80103c63:	68 8c 77 10 80       	push   $0x8010778c
80103c68:	e8 23 c7 ff ff       	call   80100390 <panic>
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi

80103c70 <growproc>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	56                   	push   %esi
80103c74:	53                   	push   %ebx
80103c75:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c78:	e8 63 09 00 00       	call   801045e0 <pushcli>
  c = mycpu();
80103c7d:	e8 2e fe ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103c82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c88:	e8 93 09 00 00       	call   80104620 <popcli>
  if(n > 0){
80103c8d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103c90:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c92:	7f 1c                	jg     80103cb0 <growproc+0x40>
  } else if(n < 0){
80103c94:	75 3a                	jne    80103cd0 <growproc+0x60>
  switchuvm(curproc);
80103c96:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c99:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c9b:	53                   	push   %ebx
80103c9c:	e8 af 2e 00 00       	call   80106b50 <switchuvm>
  return 0;
80103ca1:	83 c4 10             	add    $0x10,%esp
80103ca4:	31 c0                	xor    %eax,%eax
}
80103ca6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ca9:	5b                   	pop    %ebx
80103caa:	5e                   	pop    %esi
80103cab:	5d                   	pop    %ebp
80103cac:	c3                   	ret    
80103cad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cb0:	83 ec 04             	sub    $0x4,%esp
80103cb3:	01 c6                	add    %eax,%esi
80103cb5:	56                   	push   %esi
80103cb6:	50                   	push   %eax
80103cb7:	ff 73 04             	pushl  0x4(%ebx)
80103cba:	e8 e1 30 00 00       	call   80106da0 <allocuvm>
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	85 c0                	test   %eax,%eax
80103cc4:	75 d0                	jne    80103c96 <growproc+0x26>
      return -1;
80103cc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ccb:	eb d9                	jmp    80103ca6 <growproc+0x36>
80103ccd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cd0:	83 ec 04             	sub    $0x4,%esp
80103cd3:	01 c6                	add    %eax,%esi
80103cd5:	56                   	push   %esi
80103cd6:	50                   	push   %eax
80103cd7:	ff 73 04             	pushl  0x4(%ebx)
80103cda:	e8 f1 31 00 00       	call   80106ed0 <deallocuvm>
80103cdf:	83 c4 10             	add    $0x10,%esp
80103ce2:	85 c0                	test   %eax,%eax
80103ce4:	75 b0                	jne    80103c96 <growproc+0x26>
80103ce6:	eb de                	jmp    80103cc6 <growproc+0x56>
80103ce8:	90                   	nop
80103ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cf0 <fork>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	57                   	push   %edi
80103cf4:	56                   	push   %esi
80103cf5:	53                   	push   %ebx
80103cf6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cf9:	e8 e2 08 00 00       	call   801045e0 <pushcli>
  c = mycpu();
80103cfe:	e8 ad fd ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103d03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d09:	e8 12 09 00 00       	call   80104620 <popcli>
  if((np = allocproc()) == 0){
80103d0e:	e8 5d fc ff ff       	call   80103970 <allocproc>
80103d13:	85 c0                	test   %eax,%eax
80103d15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d18:	0f 84 b7 00 00 00    	je     80103dd5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d1e:	83 ec 08             	sub    $0x8,%esp
80103d21:	ff 33                	pushl  (%ebx)
80103d23:	ff 73 04             	pushl  0x4(%ebx)
80103d26:	89 c7                	mov    %eax,%edi
80103d28:	e8 23 33 00 00       	call   80107050 <copyuvm>
80103d2d:	83 c4 10             	add    $0x10,%esp
80103d30:	85 c0                	test   %eax,%eax
80103d32:	89 47 04             	mov    %eax,0x4(%edi)
80103d35:	0f 84 a1 00 00 00    	je     80103ddc <fork+0xec>
  np->sz = curproc->sz;
80103d3b:	8b 03                	mov    (%ebx),%eax
80103d3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d40:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103d42:	89 59 14             	mov    %ebx,0x14(%ecx)
80103d45:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103d47:	8b 79 18             	mov    0x18(%ecx),%edi
80103d4a:	8b 73 18             	mov    0x18(%ebx),%esi
80103d4d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d54:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d56:	8b 40 18             	mov    0x18(%eax),%eax
80103d59:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d64:	85 c0                	test   %eax,%eax
80103d66:	74 13                	je     80103d7b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d68:	83 ec 0c             	sub    $0xc,%esp
80103d6b:	50                   	push   %eax
80103d6c:	e8 df d3 ff ff       	call   80101150 <filedup>
80103d71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d74:	83 c4 10             	add    $0x10,%esp
80103d77:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d7b:	83 c6 01             	add    $0x1,%esi
80103d7e:	83 fe 10             	cmp    $0x10,%esi
80103d81:	75 dd                	jne    80103d60 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d83:	83 ec 0c             	sub    $0xc,%esp
80103d86:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d89:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d8c:	e8 2f dc ff ff       	call   801019c0 <idup>
80103d91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d94:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d97:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d9a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d9d:	6a 10                	push   $0x10
80103d9f:	53                   	push   %ebx
80103da0:	50                   	push   %eax
80103da1:	e8 fa 0b 00 00       	call   801049a0 <safestrcpy>
  pid = np->pid;
80103da6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103da9:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103db0:	e8 fb 08 00 00       	call   801046b0 <acquire>
  np->state = RUNNABLE;
80103db5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103dbc:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103dc3:	e8 a8 09 00 00       	call   80104770 <release>
  return pid;
80103dc8:	83 c4 10             	add    $0x10,%esp
}
80103dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dce:	89 d8                	mov    %ebx,%eax
80103dd0:	5b                   	pop    %ebx
80103dd1:	5e                   	pop    %esi
80103dd2:	5f                   	pop    %edi
80103dd3:	5d                   	pop    %ebp
80103dd4:	c3                   	ret    
    return -1;
80103dd5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dda:	eb ef                	jmp    80103dcb <fork+0xdb>
    kfree(np->kstack);
80103ddc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ddf:	83 ec 0c             	sub    $0xc,%esp
80103de2:	ff 73 08             	pushl  0x8(%ebx)
80103de5:	e8 96 e8 ff ff       	call   80102680 <kfree>
    np->kstack = 0;
80103dea:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103df1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103df8:	83 c4 10             	add    $0x10,%esp
80103dfb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e00:	eb c9                	jmp    80103dcb <fork+0xdb>
80103e02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e10 <scheduler>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	57                   	push   %edi
80103e14:	56                   	push   %esi
80103e15:	53                   	push   %ebx
80103e16:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e19:	e8 92 fc ff ff       	call   80103ab0 <mycpu>
80103e1e:	8d 78 04             	lea    0x4(%eax),%edi
80103e21:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e23:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e2a:	00 00 00 
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e30:	fb                   	sti    
    acquire(&ptable.lock);
80103e31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e34:	bb 94 2d 11 80       	mov    $0x80112d94,%ebx
    acquire(&ptable.lock);
80103e39:	68 60 2d 11 80       	push   $0x80112d60
80103e3e:	e8 6d 08 00 00       	call   801046b0 <acquire>
80103e43:	83 c4 10             	add    $0x10,%esp
80103e46:	8d 76 00             	lea    0x0(%esi),%esi
80103e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103e50:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e54:	75 33                	jne    80103e89 <scheduler+0x79>
      switchuvm(p);
80103e56:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e59:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e5f:	53                   	push   %ebx
80103e60:	e8 eb 2c 00 00       	call   80106b50 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e65:	58                   	pop    %eax
80103e66:	5a                   	pop    %edx
80103e67:	ff 73 1c             	pushl  0x1c(%ebx)
80103e6a:	57                   	push   %edi
      p->state = RUNNING;
80103e6b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e72:	e8 84 0b 00 00       	call   801049fb <swtch>
      switchkvm();
80103e77:	e8 b4 2c 00 00       	call   80106b30 <switchkvm>
      c->proc = 0;
80103e7c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e83:	00 00 00 
80103e86:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e89:	83 c3 7c             	add    $0x7c,%ebx
80103e8c:	81 fb 94 4c 11 80    	cmp    $0x80114c94,%ebx
80103e92:	72 bc                	jb     80103e50 <scheduler+0x40>
    release(&ptable.lock);
80103e94:	83 ec 0c             	sub    $0xc,%esp
80103e97:	68 60 2d 11 80       	push   $0x80112d60
80103e9c:	e8 cf 08 00 00       	call   80104770 <release>
    sti();
80103ea1:	83 c4 10             	add    $0x10,%esp
80103ea4:	eb 8a                	jmp    80103e30 <scheduler+0x20>
80103ea6:	8d 76 00             	lea    0x0(%esi),%esi
80103ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103eb0 <sched>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
  pushcli();
80103eb5:	e8 26 07 00 00       	call   801045e0 <pushcli>
  c = mycpu();
80103eba:	e8 f1 fb ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103ebf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ec5:	e8 56 07 00 00       	call   80104620 <popcli>
  if(!holding(&ptable.lock))
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 60 2d 11 80       	push   $0x80112d60
80103ed2:	e8 a9 07 00 00       	call   80104680 <holding>
80103ed7:	83 c4 10             	add    $0x10,%esp
80103eda:	85 c0                	test   %eax,%eax
80103edc:	74 4f                	je     80103f2d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103ede:	e8 cd fb ff ff       	call   80103ab0 <mycpu>
80103ee3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103eea:	75 68                	jne    80103f54 <sched+0xa4>
  if(p->state == RUNNING)
80103eec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ef0:	74 55                	je     80103f47 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ef2:	9c                   	pushf  
80103ef3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ef4:	f6 c4 02             	test   $0x2,%ah
80103ef7:	75 41                	jne    80103f3a <sched+0x8a>
  intena = mycpu()->intena;
80103ef9:	e8 b2 fb ff ff       	call   80103ab0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103efe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f07:	e8 a4 fb ff ff       	call   80103ab0 <mycpu>
80103f0c:	83 ec 08             	sub    $0x8,%esp
80103f0f:	ff 70 04             	pushl  0x4(%eax)
80103f12:	53                   	push   %ebx
80103f13:	e8 e3 0a 00 00       	call   801049fb <swtch>
  mycpu()->intena = intena;
80103f18:	e8 93 fb ff ff       	call   80103ab0 <mycpu>
}
80103f1d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f29:	5b                   	pop    %ebx
80103f2a:	5e                   	pop    %esi
80103f2b:	5d                   	pop    %ebp
80103f2c:	c3                   	ret    
    panic("sched ptable.lock");
80103f2d:	83 ec 0c             	sub    $0xc,%esp
80103f30:	68 b0 77 10 80       	push   $0x801077b0
80103f35:	e8 56 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	68 dc 77 10 80       	push   $0x801077dc
80103f42:	e8 49 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f47:	83 ec 0c             	sub    $0xc,%esp
80103f4a:	68 ce 77 10 80       	push   $0x801077ce
80103f4f:	e8 3c c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f54:	83 ec 0c             	sub    $0xc,%esp
80103f57:	68 c2 77 10 80       	push   $0x801077c2
80103f5c:	e8 2f c4 ff ff       	call   80100390 <panic>
80103f61:	eb 0d                	jmp    80103f70 <exit>
80103f63:	90                   	nop
80103f64:	90                   	nop
80103f65:	90                   	nop
80103f66:	90                   	nop
80103f67:	90                   	nop
80103f68:	90                   	nop
80103f69:	90                   	nop
80103f6a:	90                   	nop
80103f6b:	90                   	nop
80103f6c:	90                   	nop
80103f6d:	90                   	nop
80103f6e:	90                   	nop
80103f6f:	90                   	nop

80103f70 <exit>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	57                   	push   %edi
80103f74:	56                   	push   %esi
80103f75:	53                   	push   %ebx
80103f76:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f79:	e8 62 06 00 00       	call   801045e0 <pushcli>
  c = mycpu();
80103f7e:	e8 2d fb ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103f83:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f89:	e8 92 06 00 00       	call   80104620 <popcli>
  if(curproc == initproc)
80103f8e:	39 35 f8 a5 10 80    	cmp    %esi,0x8010a5f8
80103f94:	8d 5e 28             	lea    0x28(%esi),%ebx
80103f97:	8d 7e 68             	lea    0x68(%esi),%edi
80103f9a:	0f 84 e7 00 00 00    	je     80104087 <exit+0x117>
    if(curproc->ofile[fd]){
80103fa0:	8b 03                	mov    (%ebx),%eax
80103fa2:	85 c0                	test   %eax,%eax
80103fa4:	74 12                	je     80103fb8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103fa6:	83 ec 0c             	sub    $0xc,%esp
80103fa9:	50                   	push   %eax
80103faa:	e8 f1 d1 ff ff       	call   801011a0 <fileclose>
      curproc->ofile[fd] = 0;
80103faf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103fb5:	83 c4 10             	add    $0x10,%esp
80103fb8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103fbb:	39 fb                	cmp    %edi,%ebx
80103fbd:	75 e1                	jne    80103fa0 <exit+0x30>
  begin_op();
80103fbf:	e8 4c ef ff ff       	call   80102f10 <begin_op>
  iput(curproc->cwd);
80103fc4:	83 ec 0c             	sub    $0xc,%esp
80103fc7:	ff 76 68             	pushl  0x68(%esi)
80103fca:	e8 51 db ff ff       	call   80101b20 <iput>
  end_op();
80103fcf:	e8 ac ef ff ff       	call   80102f80 <end_op>
  curproc->cwd = 0;
80103fd4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103fdb:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
80103fe2:	e8 c9 06 00 00       	call   801046b0 <acquire>
  wakeup1(curproc->parent);
80103fe7:	8b 56 14             	mov    0x14(%esi),%edx
80103fea:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fed:	b8 94 2d 11 80       	mov    $0x80112d94,%eax
80103ff2:	eb 0e                	jmp    80104002 <exit+0x92>
80103ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ff8:	83 c0 7c             	add    $0x7c,%eax
80103ffb:	3d 94 4c 11 80       	cmp    $0x80114c94,%eax
80104000:	73 1c                	jae    8010401e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80104002:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104006:	75 f0                	jne    80103ff8 <exit+0x88>
80104008:	3b 50 20             	cmp    0x20(%eax),%edx
8010400b:	75 eb                	jne    80103ff8 <exit+0x88>
      p->state = RUNNABLE;
8010400d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104014:	83 c0 7c             	add    $0x7c,%eax
80104017:	3d 94 4c 11 80       	cmp    $0x80114c94,%eax
8010401c:	72 e4                	jb     80104002 <exit+0x92>
      p->parent = initproc;
8010401e:	8b 0d f8 a5 10 80    	mov    0x8010a5f8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104024:	ba 94 2d 11 80       	mov    $0x80112d94,%edx
80104029:	eb 10                	jmp    8010403b <exit+0xcb>
8010402b:	90                   	nop
8010402c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104030:	83 c2 7c             	add    $0x7c,%edx
80104033:	81 fa 94 4c 11 80    	cmp    $0x80114c94,%edx
80104039:	73 33                	jae    8010406e <exit+0xfe>
    if(p->parent == curproc){
8010403b:	39 72 14             	cmp    %esi,0x14(%edx)
8010403e:	75 f0                	jne    80104030 <exit+0xc0>
      if(p->state == ZOMBIE)
80104040:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104044:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104047:	75 e7                	jne    80104030 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104049:	b8 94 2d 11 80       	mov    $0x80112d94,%eax
8010404e:	eb 0a                	jmp    8010405a <exit+0xea>
80104050:	83 c0 7c             	add    $0x7c,%eax
80104053:	3d 94 4c 11 80       	cmp    $0x80114c94,%eax
80104058:	73 d6                	jae    80104030 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
8010405a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010405e:	75 f0                	jne    80104050 <exit+0xe0>
80104060:	3b 48 20             	cmp    0x20(%eax),%ecx
80104063:	75 eb                	jne    80104050 <exit+0xe0>
      p->state = RUNNABLE;
80104065:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010406c:	eb e2                	jmp    80104050 <exit+0xe0>
  curproc->state = ZOMBIE;
8010406e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104075:	e8 36 fe ff ff       	call   80103eb0 <sched>
  panic("zombie exit");
8010407a:	83 ec 0c             	sub    $0xc,%esp
8010407d:	68 fd 77 10 80       	push   $0x801077fd
80104082:	e8 09 c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104087:	83 ec 0c             	sub    $0xc,%esp
8010408a:	68 f0 77 10 80       	push   $0x801077f0
8010408f:	e8 fc c2 ff ff       	call   80100390 <panic>
80104094:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010409a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801040a0 <yield>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040a7:	68 60 2d 11 80       	push   $0x80112d60
801040ac:	e8 ff 05 00 00       	call   801046b0 <acquire>
  pushcli();
801040b1:	e8 2a 05 00 00       	call   801045e0 <pushcli>
  c = mycpu();
801040b6:	e8 f5 f9 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
801040bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040c1:	e8 5a 05 00 00       	call   80104620 <popcli>
  myproc()->state = RUNNABLE;
801040c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040cd:	e8 de fd ff ff       	call   80103eb0 <sched>
  release(&ptable.lock);
801040d2:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
801040d9:	e8 92 06 00 00       	call   80104770 <release>
}
801040de:	83 c4 10             	add    $0x10,%esp
801040e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040e4:	c9                   	leave  
801040e5:	c3                   	ret    
801040e6:	8d 76 00             	lea    0x0(%esi),%esi
801040e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040f0 <sleep>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	57                   	push   %edi
801040f4:	56                   	push   %esi
801040f5:	53                   	push   %ebx
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801040fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801040ff:	e8 dc 04 00 00       	call   801045e0 <pushcli>
  c = mycpu();
80104104:	e8 a7 f9 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104109:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010410f:	e8 0c 05 00 00       	call   80104620 <popcli>
  if(p == 0)
80104114:	85 db                	test   %ebx,%ebx
80104116:	0f 84 87 00 00 00    	je     801041a3 <sleep+0xb3>
  if(lk == 0)
8010411c:	85 f6                	test   %esi,%esi
8010411e:	74 76                	je     80104196 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104120:	81 fe 60 2d 11 80    	cmp    $0x80112d60,%esi
80104126:	74 50                	je     80104178 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104128:	83 ec 0c             	sub    $0xc,%esp
8010412b:	68 60 2d 11 80       	push   $0x80112d60
80104130:	e8 7b 05 00 00       	call   801046b0 <acquire>
    release(lk);
80104135:	89 34 24             	mov    %esi,(%esp)
80104138:	e8 33 06 00 00       	call   80104770 <release>
  p->chan = chan;
8010413d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104140:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104147:	e8 64 fd ff ff       	call   80103eb0 <sched>
  p->chan = 0;
8010414c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104153:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
8010415a:	e8 11 06 00 00       	call   80104770 <release>
    acquire(lk);
8010415f:	89 75 08             	mov    %esi,0x8(%ebp)
80104162:	83 c4 10             	add    $0x10,%esp
}
80104165:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104168:	5b                   	pop    %ebx
80104169:	5e                   	pop    %esi
8010416a:	5f                   	pop    %edi
8010416b:	5d                   	pop    %ebp
    acquire(lk);
8010416c:	e9 3f 05 00 00       	jmp    801046b0 <acquire>
80104171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104178:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010417b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104182:	e8 29 fd ff ff       	call   80103eb0 <sched>
  p->chan = 0;
80104187:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010418e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104191:	5b                   	pop    %ebx
80104192:	5e                   	pop    %esi
80104193:	5f                   	pop    %edi
80104194:	5d                   	pop    %ebp
80104195:	c3                   	ret    
    panic("sleep without lk");
80104196:	83 ec 0c             	sub    $0xc,%esp
80104199:	68 0f 78 10 80       	push   $0x8010780f
8010419e:	e8 ed c1 ff ff       	call   80100390 <panic>
    panic("sleep");
801041a3:	83 ec 0c             	sub    $0xc,%esp
801041a6:	68 09 78 10 80       	push   $0x80107809
801041ab:	e8 e0 c1 ff ff       	call   80100390 <panic>

801041b0 <wait>:
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
  pushcli();
801041b5:	e8 26 04 00 00       	call   801045e0 <pushcli>
  c = mycpu();
801041ba:	e8 f1 f8 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
801041bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041c5:	e8 56 04 00 00       	call   80104620 <popcli>
  acquire(&ptable.lock);
801041ca:	83 ec 0c             	sub    $0xc,%esp
801041cd:	68 60 2d 11 80       	push   $0x80112d60
801041d2:	e8 d9 04 00 00       	call   801046b0 <acquire>
801041d7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801041da:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041dc:	bb 94 2d 11 80       	mov    $0x80112d94,%ebx
801041e1:	eb 10                	jmp    801041f3 <wait+0x43>
801041e3:	90                   	nop
801041e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041e8:	83 c3 7c             	add    $0x7c,%ebx
801041eb:	81 fb 94 4c 11 80    	cmp    $0x80114c94,%ebx
801041f1:	73 1b                	jae    8010420e <wait+0x5e>
      if(p->parent != curproc)
801041f3:	39 73 14             	cmp    %esi,0x14(%ebx)
801041f6:	75 f0                	jne    801041e8 <wait+0x38>
      if(p->state == ZOMBIE){
801041f8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801041fc:	74 32                	je     80104230 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041fe:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104201:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104206:	81 fb 94 4c 11 80    	cmp    $0x80114c94,%ebx
8010420c:	72 e5                	jb     801041f3 <wait+0x43>
    if(!havekids || curproc->killed){
8010420e:	85 c0                	test   %eax,%eax
80104210:	74 74                	je     80104286 <wait+0xd6>
80104212:	8b 46 24             	mov    0x24(%esi),%eax
80104215:	85 c0                	test   %eax,%eax
80104217:	75 6d                	jne    80104286 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104219:	83 ec 08             	sub    $0x8,%esp
8010421c:	68 60 2d 11 80       	push   $0x80112d60
80104221:	56                   	push   %esi
80104222:	e8 c9 fe ff ff       	call   801040f0 <sleep>
    havekids = 0;
80104227:	83 c4 10             	add    $0x10,%esp
8010422a:	eb ae                	jmp    801041da <wait+0x2a>
8010422c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104230:	83 ec 0c             	sub    $0xc,%esp
80104233:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104236:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104239:	e8 42 e4 ff ff       	call   80102680 <kfree>
        freevm(p->pgdir);
8010423e:	5a                   	pop    %edx
8010423f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104242:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104249:	e8 b2 2c 00 00       	call   80106f00 <freevm>
        release(&ptable.lock);
8010424e:	c7 04 24 60 2d 11 80 	movl   $0x80112d60,(%esp)
        p->pid = 0;
80104255:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010425c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104263:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104267:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010426e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104275:	e8 f6 04 00 00       	call   80104770 <release>
        return pid;
8010427a:	83 c4 10             	add    $0x10,%esp
}
8010427d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104280:	89 f0                	mov    %esi,%eax
80104282:	5b                   	pop    %ebx
80104283:	5e                   	pop    %esi
80104284:	5d                   	pop    %ebp
80104285:	c3                   	ret    
      release(&ptable.lock);
80104286:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104289:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010428e:	68 60 2d 11 80       	push   $0x80112d60
80104293:	e8 d8 04 00 00       	call   80104770 <release>
      return -1;
80104298:	83 c4 10             	add    $0x10,%esp
8010429b:	eb e0                	jmp    8010427d <wait+0xcd>
8010429d:	8d 76 00             	lea    0x0(%esi),%esi

801042a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 10             	sub    $0x10,%esp
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042aa:	68 60 2d 11 80       	push   $0x80112d60
801042af:	e8 fc 03 00 00       	call   801046b0 <acquire>
801042b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042b7:	b8 94 2d 11 80       	mov    $0x80112d94,%eax
801042bc:	eb 0c                	jmp    801042ca <wakeup+0x2a>
801042be:	66 90                	xchg   %ax,%ax
801042c0:	83 c0 7c             	add    $0x7c,%eax
801042c3:	3d 94 4c 11 80       	cmp    $0x80114c94,%eax
801042c8:	73 1c                	jae    801042e6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801042ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042ce:	75 f0                	jne    801042c0 <wakeup+0x20>
801042d0:	3b 58 20             	cmp    0x20(%eax),%ebx
801042d3:	75 eb                	jne    801042c0 <wakeup+0x20>
      p->state = RUNNABLE;
801042d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042dc:	83 c0 7c             	add    $0x7c,%eax
801042df:	3d 94 4c 11 80       	cmp    $0x80114c94,%eax
801042e4:	72 e4                	jb     801042ca <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801042e6:	c7 45 08 60 2d 11 80 	movl   $0x80112d60,0x8(%ebp)
}
801042ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f0:	c9                   	leave  
  release(&ptable.lock);
801042f1:	e9 7a 04 00 00       	jmp    80104770 <release>
801042f6:	8d 76 00             	lea    0x0(%esi),%esi
801042f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104300 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 10             	sub    $0x10,%esp
80104307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010430a:	68 60 2d 11 80       	push   $0x80112d60
8010430f:	e8 9c 03 00 00       	call   801046b0 <acquire>
80104314:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104317:	b8 94 2d 11 80       	mov    $0x80112d94,%eax
8010431c:	eb 0c                	jmp    8010432a <kill+0x2a>
8010431e:	66 90                	xchg   %ax,%ax
80104320:	83 c0 7c             	add    $0x7c,%eax
80104323:	3d 94 4c 11 80       	cmp    $0x80114c94,%eax
80104328:	73 36                	jae    80104360 <kill+0x60>
    if(p->pid == pid){
8010432a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010432d:	75 f1                	jne    80104320 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010432f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104333:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010433a:	75 07                	jne    80104343 <kill+0x43>
        p->state = RUNNABLE;
8010433c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104343:	83 ec 0c             	sub    $0xc,%esp
80104346:	68 60 2d 11 80       	push   $0x80112d60
8010434b:	e8 20 04 00 00       	call   80104770 <release>
      return 0;
80104350:	83 c4 10             	add    $0x10,%esp
80104353:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104355:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104358:	c9                   	leave  
80104359:	c3                   	ret    
8010435a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104360:	83 ec 0c             	sub    $0xc,%esp
80104363:	68 60 2d 11 80       	push   $0x80112d60
80104368:	e8 03 04 00 00       	call   80104770 <release>
  return -1;
8010436d:	83 c4 10             	add    $0x10,%esp
80104370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104378:	c9                   	leave  
80104379:	c3                   	ret    
8010437a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104380 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	57                   	push   %edi
80104384:	56                   	push   %esi
80104385:	53                   	push   %ebx
80104386:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104389:	bb 94 2d 11 80       	mov    $0x80112d94,%ebx
{
8010438e:	83 ec 3c             	sub    $0x3c,%esp
80104391:	eb 24                	jmp    801043b7 <procdump+0x37>
80104393:	90                   	nop
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104398:	83 ec 0c             	sub    $0xc,%esp
8010439b:	68 97 7b 10 80       	push   $0x80107b97
801043a0:	e8 bb c2 ff ff       	call   80100660 <cprintf>
801043a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a8:	83 c3 7c             	add    $0x7c,%ebx
801043ab:	81 fb 94 4c 11 80    	cmp    $0x80114c94,%ebx
801043b1:	0f 83 81 00 00 00    	jae    80104438 <procdump+0xb8>
    if(p->state == UNUSED)
801043b7:	8b 43 0c             	mov    0xc(%ebx),%eax
801043ba:	85 c0                	test   %eax,%eax
801043bc:	74 ea                	je     801043a8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043be:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801043c1:	ba 20 78 10 80       	mov    $0x80107820,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043c6:	77 11                	ja     801043d9 <procdump+0x59>
801043c8:	8b 14 85 80 78 10 80 	mov    -0x7fef8780(,%eax,4),%edx
      state = "???";
801043cf:	b8 20 78 10 80       	mov    $0x80107820,%eax
801043d4:	85 d2                	test   %edx,%edx
801043d6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801043d9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801043dc:	50                   	push   %eax
801043dd:	52                   	push   %edx
801043de:	ff 73 10             	pushl  0x10(%ebx)
801043e1:	68 24 78 10 80       	push   $0x80107824
801043e6:	e8 75 c2 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801043eb:	83 c4 10             	add    $0x10,%esp
801043ee:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801043f2:	75 a4                	jne    80104398 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801043f4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043f7:	83 ec 08             	sub    $0x8,%esp
801043fa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801043fd:	50                   	push   %eax
801043fe:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104401:	8b 40 0c             	mov    0xc(%eax),%eax
80104404:	83 c0 08             	add    $0x8,%eax
80104407:	50                   	push   %eax
80104408:	e8 83 01 00 00       	call   80104590 <getcallerpcs>
8010440d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104410:	8b 17                	mov    (%edi),%edx
80104412:	85 d2                	test   %edx,%edx
80104414:	74 82                	je     80104398 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104416:	83 ec 08             	sub    $0x8,%esp
80104419:	83 c7 04             	add    $0x4,%edi
8010441c:	52                   	push   %edx
8010441d:	68 61 72 10 80       	push   $0x80107261
80104422:	e8 39 c2 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104427:	83 c4 10             	add    $0x10,%esp
8010442a:	39 fe                	cmp    %edi,%esi
8010442c:	75 e2                	jne    80104410 <procdump+0x90>
8010442e:	e9 65 ff ff ff       	jmp    80104398 <procdump+0x18>
80104433:	90                   	nop
80104434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104438:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010443b:	5b                   	pop    %ebx
8010443c:	5e                   	pop    %esi
8010443d:	5f                   	pop    %edi
8010443e:	5d                   	pop    %ebp
8010443f:	c3                   	ret    

80104440 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	53                   	push   %ebx
80104444:	83 ec 0c             	sub    $0xc,%esp
80104447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010444a:	68 98 78 10 80       	push   $0x80107898
8010444f:	8d 43 04             	lea    0x4(%ebx),%eax
80104452:	50                   	push   %eax
80104453:	e8 18 01 00 00       	call   80104570 <initlock>
  lk->name = name;
80104458:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010445b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104461:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104464:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010446b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010446e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104471:	c9                   	leave  
80104472:	c3                   	ret    
80104473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104480 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
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
8010448f:	e8 1c 02 00 00       	call   801046b0 <acquire>
  while (lk->locked) {
80104494:	8b 13                	mov    (%ebx),%edx
80104496:	83 c4 10             	add    $0x10,%esp
80104499:	85 d2                	test   %edx,%edx
8010449b:	74 16                	je     801044b3 <acquiresleep+0x33>
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801044a0:	83 ec 08             	sub    $0x8,%esp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
801044a5:	e8 46 fc ff ff       	call   801040f0 <sleep>
  while (lk->locked) {
801044aa:	8b 03                	mov    (%ebx),%eax
801044ac:	83 c4 10             	add    $0x10,%esp
801044af:	85 c0                	test   %eax,%eax
801044b1:	75 ed                	jne    801044a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801044b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801044b9:	e8 92 f6 ff ff       	call   80103b50 <myproc>
801044be:	8b 40 10             	mov    0x10(%eax),%eax
801044c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801044c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044ca:	5b                   	pop    %ebx
801044cb:	5e                   	pop    %esi
801044cc:	5d                   	pop    %ebp
  release(&lk->lk);
801044cd:	e9 9e 02 00 00       	jmp    80104770 <release>
801044d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	56                   	push   %esi
801044e4:	53                   	push   %ebx
801044e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044e8:	83 ec 0c             	sub    $0xc,%esp
801044eb:	8d 73 04             	lea    0x4(%ebx),%esi
801044ee:	56                   	push   %esi
801044ef:	e8 bc 01 00 00       	call   801046b0 <acquire>
  lk->locked = 0;
801044f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104501:	89 1c 24             	mov    %ebx,(%esp)
80104504:	e8 97 fd ff ff       	call   801042a0 <wakeup>
  release(&lk->lk);
80104509:	89 75 08             	mov    %esi,0x8(%ebp)
8010450c:	83 c4 10             	add    $0x10,%esp
}
8010450f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104512:	5b                   	pop    %ebx
80104513:	5e                   	pop    %esi
80104514:	5d                   	pop    %ebp
  release(&lk->lk);
80104515:	e9 56 02 00 00       	jmp    80104770 <release>
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104520 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	56                   	push   %esi
80104525:	53                   	push   %ebx
80104526:	31 ff                	xor    %edi,%edi
80104528:	83 ec 18             	sub    $0x18,%esp
8010452b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010452e:	8d 73 04             	lea    0x4(%ebx),%esi
80104531:	56                   	push   %esi
80104532:	e8 79 01 00 00       	call   801046b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104537:	8b 03                	mov    (%ebx),%eax
80104539:	83 c4 10             	add    $0x10,%esp
8010453c:	85 c0                	test   %eax,%eax
8010453e:	74 13                	je     80104553 <holdingsleep+0x33>
80104540:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104543:	e8 08 f6 ff ff       	call   80103b50 <myproc>
80104548:	39 58 10             	cmp    %ebx,0x10(%eax)
8010454b:	0f 94 c0             	sete   %al
8010454e:	0f b6 c0             	movzbl %al,%eax
80104551:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104553:	83 ec 0c             	sub    $0xc,%esp
80104556:	56                   	push   %esi
80104557:	e8 14 02 00 00       	call   80104770 <release>
  return r;
}
8010455c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010455f:	89 f8                	mov    %edi,%eax
80104561:	5b                   	pop    %ebx
80104562:	5e                   	pop    %esi
80104563:	5f                   	pop    %edi
80104564:	5d                   	pop    %ebp
80104565:	c3                   	ret    
80104566:	66 90                	xchg   %ax,%ax
80104568:	66 90                	xchg   %ax,%ax
8010456a:	66 90                	xchg   %ax,%ax
8010456c:	66 90                	xchg   %ax,%ax
8010456e:	66 90                	xchg   %ax,%ax

80104570 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104576:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010457f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104582:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104589:	5d                   	pop    %ebp
8010458a:	c3                   	ret    
8010458b:	90                   	nop
8010458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104590 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104590:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104591:	31 d2                	xor    %edx,%edx
{
80104593:	89 e5                	mov    %esp,%ebp
80104595:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104596:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104599:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010459c:	83 e8 08             	sub    $0x8,%eax
8010459f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045a0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045ac:	77 1a                	ja     801045c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045ae:	8b 58 04             	mov    0x4(%eax),%ebx
801045b1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801045b4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801045b7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801045b9:	83 fa 0a             	cmp    $0xa,%edx
801045bc:	75 e2                	jne    801045a0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801045be:	5b                   	pop    %ebx
801045bf:	5d                   	pop    %ebp
801045c0:	c3                   	ret    
801045c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045c8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801045cb:	83 c1 28             	add    $0x28,%ecx
801045ce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801045d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801045d6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801045d9:	39 c1                	cmp    %eax,%ecx
801045db:	75 f3                	jne    801045d0 <getcallerpcs+0x40>
}
801045dd:	5b                   	pop    %ebx
801045de:	5d                   	pop    %ebp
801045df:	c3                   	ret    

801045e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	53                   	push   %ebx
801045e4:	83 ec 04             	sub    $0x4,%esp
801045e7:	9c                   	pushf  
801045e8:	5b                   	pop    %ebx
  asm volatile("cli");
801045e9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801045ea:	e8 c1 f4 ff ff       	call   80103ab0 <mycpu>
801045ef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045f5:	85 c0                	test   %eax,%eax
801045f7:	75 11                	jne    8010460a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801045f9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045ff:	e8 ac f4 ff ff       	call   80103ab0 <mycpu>
80104604:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010460a:	e8 a1 f4 ff ff       	call   80103ab0 <mycpu>
8010460f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104616:	83 c4 04             	add    $0x4,%esp
80104619:	5b                   	pop    %ebx
8010461a:	5d                   	pop    %ebp
8010461b:	c3                   	ret    
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104620 <popcli>:

void
popcli(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104626:	9c                   	pushf  
80104627:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104628:	f6 c4 02             	test   $0x2,%ah
8010462b:	75 35                	jne    80104662 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010462d:	e8 7e f4 ff ff       	call   80103ab0 <mycpu>
80104632:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104639:	78 34                	js     8010466f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010463b:	e8 70 f4 ff ff       	call   80103ab0 <mycpu>
80104640:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104646:	85 d2                	test   %edx,%edx
80104648:	74 06                	je     80104650 <popcli+0x30>
    sti();
}
8010464a:	c9                   	leave  
8010464b:	c3                   	ret    
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104650:	e8 5b f4 ff ff       	call   80103ab0 <mycpu>
80104655:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010465b:	85 c0                	test   %eax,%eax
8010465d:	74 eb                	je     8010464a <popcli+0x2a>
  asm volatile("sti");
8010465f:	fb                   	sti    
}
80104660:	c9                   	leave  
80104661:	c3                   	ret    
    panic("popcli - interruptible");
80104662:	83 ec 0c             	sub    $0xc,%esp
80104665:	68 a3 78 10 80       	push   $0x801078a3
8010466a:	e8 21 bd ff ff       	call   80100390 <panic>
    panic("popcli");
8010466f:	83 ec 0c             	sub    $0xc,%esp
80104672:	68 ba 78 10 80       	push   $0x801078ba
80104677:	e8 14 bd ff ff       	call   80100390 <panic>
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104680 <holding>:
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 75 08             	mov    0x8(%ebp),%esi
80104688:	31 db                	xor    %ebx,%ebx
  pushcli();
8010468a:	e8 51 ff ff ff       	call   801045e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010468f:	8b 06                	mov    (%esi),%eax
80104691:	85 c0                	test   %eax,%eax
80104693:	74 10                	je     801046a5 <holding+0x25>
80104695:	8b 5e 08             	mov    0x8(%esi),%ebx
80104698:	e8 13 f4 ff ff       	call   80103ab0 <mycpu>
8010469d:	39 c3                	cmp    %eax,%ebx
8010469f:	0f 94 c3             	sete   %bl
801046a2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801046a5:	e8 76 ff ff ff       	call   80104620 <popcli>
}
801046aa:	89 d8                	mov    %ebx,%eax
801046ac:	5b                   	pop    %ebx
801046ad:	5e                   	pop    %esi
801046ae:	5d                   	pop    %ebp
801046af:	c3                   	ret    

801046b0 <acquire>:
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
801046b4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801046b5:	e8 26 ff ff ff       	call   801045e0 <pushcli>
  if(holding(lk))
801046ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046bd:	83 ec 0c             	sub    $0xc,%esp
801046c0:	53                   	push   %ebx
801046c1:	e8 ba ff ff ff       	call   80104680 <holding>
801046c6:	83 c4 10             	add    $0x10,%esp
801046c9:	85 c0                	test   %eax,%eax
801046cb:	0f 85 83 00 00 00    	jne    80104754 <acquire+0xa4>
801046d1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801046d3:	ba 01 00 00 00       	mov    $0x1,%edx
801046d8:	eb 09                	jmp    801046e3 <acquire+0x33>
801046da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046e3:	89 d0                	mov    %edx,%eax
801046e5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801046e8:	85 c0                	test   %eax,%eax
801046ea:	75 f4                	jne    801046e0 <acquire+0x30>
  __sync_synchronize();
801046ec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801046f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046f4:	e8 b7 f3 ff ff       	call   80103ab0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801046f9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801046fc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801046ff:	89 e8                	mov    %ebp,%eax
80104701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104708:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010470e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104714:	77 1a                	ja     80104730 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104716:	8b 48 04             	mov    0x4(%eax),%ecx
80104719:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010471c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010471f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104721:	83 fe 0a             	cmp    $0xa,%esi
80104724:	75 e2                	jne    80104708 <acquire+0x58>
}
80104726:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104729:	5b                   	pop    %ebx
8010472a:	5e                   	pop    %esi
8010472b:	5d                   	pop    %ebp
8010472c:	c3                   	ret    
8010472d:	8d 76 00             	lea    0x0(%esi),%esi
80104730:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104733:	83 c2 28             	add    $0x28,%edx
80104736:	8d 76 00             	lea    0x0(%esi),%esi
80104739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104740:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104746:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104749:	39 d0                	cmp    %edx,%eax
8010474b:	75 f3                	jne    80104740 <acquire+0x90>
}
8010474d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104750:	5b                   	pop    %ebx
80104751:	5e                   	pop    %esi
80104752:	5d                   	pop    %ebp
80104753:	c3                   	ret    
    panic("acquire");
80104754:	83 ec 0c             	sub    $0xc,%esp
80104757:	68 c1 78 10 80       	push   $0x801078c1
8010475c:	e8 2f bc ff ff       	call   80100390 <panic>
80104761:	eb 0d                	jmp    80104770 <release>
80104763:	90                   	nop
80104764:	90                   	nop
80104765:	90                   	nop
80104766:	90                   	nop
80104767:	90                   	nop
80104768:	90                   	nop
80104769:	90                   	nop
8010476a:	90                   	nop
8010476b:	90                   	nop
8010476c:	90                   	nop
8010476d:	90                   	nop
8010476e:	90                   	nop
8010476f:	90                   	nop

80104770 <release>:
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	53                   	push   %ebx
80104774:	83 ec 10             	sub    $0x10,%esp
80104777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010477a:	53                   	push   %ebx
8010477b:	e8 00 ff ff ff       	call   80104680 <holding>
80104780:	83 c4 10             	add    $0x10,%esp
80104783:	85 c0                	test   %eax,%eax
80104785:	74 22                	je     801047a9 <release+0x39>
  lk->pcs[0] = 0;
80104787:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010478e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104795:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010479a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047a3:	c9                   	leave  
  popcli();
801047a4:	e9 77 fe ff ff       	jmp    80104620 <popcli>
    panic("release");
801047a9:	83 ec 0c             	sub    $0xc,%esp
801047ac:	68 c9 78 10 80       	push   $0x801078c9
801047b1:	e8 da bb ff ff       	call   80100390 <panic>
801047b6:	66 90                	xchg   %ax,%ax
801047b8:	66 90                	xchg   %ax,%ax
801047ba:	66 90                	xchg   %ax,%ax
801047bc:	66 90                	xchg   %ax,%ax
801047be:	66 90                	xchg   %ax,%ax

801047c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	57                   	push   %edi
801047c4:	53                   	push   %ebx
801047c5:	8b 55 08             	mov    0x8(%ebp),%edx
801047c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801047cb:	f6 c2 03             	test   $0x3,%dl
801047ce:	75 05                	jne    801047d5 <memset+0x15>
801047d0:	f6 c1 03             	test   $0x3,%cl
801047d3:	74 13                	je     801047e8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801047d5:	89 d7                	mov    %edx,%edi
801047d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801047da:	fc                   	cld    
801047db:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801047dd:	5b                   	pop    %ebx
801047de:	89 d0                	mov    %edx,%eax
801047e0:	5f                   	pop    %edi
801047e1:	5d                   	pop    %ebp
801047e2:	c3                   	ret    
801047e3:	90                   	nop
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801047e8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047ec:	c1 e9 02             	shr    $0x2,%ecx
801047ef:	89 f8                	mov    %edi,%eax
801047f1:	89 fb                	mov    %edi,%ebx
801047f3:	c1 e0 18             	shl    $0x18,%eax
801047f6:	c1 e3 10             	shl    $0x10,%ebx
801047f9:	09 d8                	or     %ebx,%eax
801047fb:	09 f8                	or     %edi,%eax
801047fd:	c1 e7 08             	shl    $0x8,%edi
80104800:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104802:	89 d7                	mov    %edx,%edi
80104804:	fc                   	cld    
80104805:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104807:	5b                   	pop    %ebx
80104808:	89 d0                	mov    %edx,%eax
8010480a:	5f                   	pop    %edi
8010480b:	5d                   	pop    %ebp
8010480c:	c3                   	ret    
8010480d:	8d 76 00             	lea    0x0(%esi),%esi

80104810 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	57                   	push   %edi
80104814:	56                   	push   %esi
80104815:	53                   	push   %ebx
80104816:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104819:	8b 75 08             	mov    0x8(%ebp),%esi
8010481c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010481f:	85 db                	test   %ebx,%ebx
80104821:	74 29                	je     8010484c <memcmp+0x3c>
    if(*s1 != *s2)
80104823:	0f b6 16             	movzbl (%esi),%edx
80104826:	0f b6 0f             	movzbl (%edi),%ecx
80104829:	38 d1                	cmp    %dl,%cl
8010482b:	75 2b                	jne    80104858 <memcmp+0x48>
8010482d:	b8 01 00 00 00       	mov    $0x1,%eax
80104832:	eb 14                	jmp    80104848 <memcmp+0x38>
80104834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104838:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010483c:	83 c0 01             	add    $0x1,%eax
8010483f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104844:	38 ca                	cmp    %cl,%dl
80104846:	75 10                	jne    80104858 <memcmp+0x48>
  while(n-- > 0){
80104848:	39 d8                	cmp    %ebx,%eax
8010484a:	75 ec                	jne    80104838 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010484c:	5b                   	pop    %ebx
  return 0;
8010484d:	31 c0                	xor    %eax,%eax
}
8010484f:	5e                   	pop    %esi
80104850:	5f                   	pop    %edi
80104851:	5d                   	pop    %ebp
80104852:	c3                   	ret    
80104853:	90                   	nop
80104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104858:	0f b6 c2             	movzbl %dl,%eax
}
8010485b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010485c:	29 c8                	sub    %ecx,%eax
}
8010485e:	5e                   	pop    %esi
8010485f:	5f                   	pop    %edi
80104860:	5d                   	pop    %ebp
80104861:	c3                   	ret    
80104862:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
80104875:	8b 45 08             	mov    0x8(%ebp),%eax
80104878:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010487b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010487e:	39 c3                	cmp    %eax,%ebx
80104880:	73 26                	jae    801048a8 <memmove+0x38>
80104882:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104885:	39 c8                	cmp    %ecx,%eax
80104887:	73 1f                	jae    801048a8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104889:	85 f6                	test   %esi,%esi
8010488b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010488e:	74 0f                	je     8010489f <memmove+0x2f>
      *--d = *--s;
80104890:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104894:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104897:	83 ea 01             	sub    $0x1,%edx
8010489a:	83 fa ff             	cmp    $0xffffffff,%edx
8010489d:	75 f1                	jne    80104890 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010489f:	5b                   	pop    %ebx
801048a0:	5e                   	pop    %esi
801048a1:	5d                   	pop    %ebp
801048a2:	c3                   	ret    
801048a3:	90                   	nop
801048a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801048a8:	31 d2                	xor    %edx,%edx
801048aa:	85 f6                	test   %esi,%esi
801048ac:	74 f1                	je     8010489f <memmove+0x2f>
801048ae:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801048b0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801048b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801048b7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801048ba:	39 d6                	cmp    %edx,%esi
801048bc:	75 f2                	jne    801048b0 <memmove+0x40>
}
801048be:	5b                   	pop    %ebx
801048bf:	5e                   	pop    %esi
801048c0:	5d                   	pop    %ebp
801048c1:	c3                   	ret    
801048c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801048d3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801048d4:	eb 9a                	jmp    80104870 <memmove>
801048d6:	8d 76 00             	lea    0x0(%esi),%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048e0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	56                   	push   %esi
801048e5:	8b 7d 10             	mov    0x10(%ebp),%edi
801048e8:	53                   	push   %ebx
801048e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801048ef:	85 ff                	test   %edi,%edi
801048f1:	74 2f                	je     80104922 <strncmp+0x42>
801048f3:	0f b6 01             	movzbl (%ecx),%eax
801048f6:	0f b6 1e             	movzbl (%esi),%ebx
801048f9:	84 c0                	test   %al,%al
801048fb:	74 37                	je     80104934 <strncmp+0x54>
801048fd:	38 c3                	cmp    %al,%bl
801048ff:	75 33                	jne    80104934 <strncmp+0x54>
80104901:	01 f7                	add    %esi,%edi
80104903:	eb 13                	jmp    80104918 <strncmp+0x38>
80104905:	8d 76 00             	lea    0x0(%esi),%esi
80104908:	0f b6 01             	movzbl (%ecx),%eax
8010490b:	84 c0                	test   %al,%al
8010490d:	74 21                	je     80104930 <strncmp+0x50>
8010490f:	0f b6 1a             	movzbl (%edx),%ebx
80104912:	89 d6                	mov    %edx,%esi
80104914:	38 d8                	cmp    %bl,%al
80104916:	75 1c                	jne    80104934 <strncmp+0x54>
    n--, p++, q++;
80104918:	8d 56 01             	lea    0x1(%esi),%edx
8010491b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010491e:	39 fa                	cmp    %edi,%edx
80104920:	75 e6                	jne    80104908 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104922:	5b                   	pop    %ebx
    return 0;
80104923:	31 c0                	xor    %eax,%eax
}
80104925:	5e                   	pop    %esi
80104926:	5f                   	pop    %edi
80104927:	5d                   	pop    %ebp
80104928:	c3                   	ret    
80104929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104930:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104934:	29 d8                	sub    %ebx,%eax
}
80104936:	5b                   	pop    %ebx
80104937:	5e                   	pop    %esi
80104938:	5f                   	pop    %edi
80104939:	5d                   	pop    %ebp
8010493a:	c3                   	ret    
8010493b:	90                   	nop
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104940 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	8b 45 08             	mov    0x8(%ebp),%eax
80104948:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010494b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010494e:	89 c2                	mov    %eax,%edx
80104950:	eb 19                	jmp    8010496b <strncpy+0x2b>
80104952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104958:	83 c3 01             	add    $0x1,%ebx
8010495b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010495f:	83 c2 01             	add    $0x1,%edx
80104962:	84 c9                	test   %cl,%cl
80104964:	88 4a ff             	mov    %cl,-0x1(%edx)
80104967:	74 09                	je     80104972 <strncpy+0x32>
80104969:	89 f1                	mov    %esi,%ecx
8010496b:	85 c9                	test   %ecx,%ecx
8010496d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104970:	7f e6                	jg     80104958 <strncpy+0x18>
    ;
  while(n-- > 0)
80104972:	31 c9                	xor    %ecx,%ecx
80104974:	85 f6                	test   %esi,%esi
80104976:	7e 17                	jle    8010498f <strncpy+0x4f>
80104978:	90                   	nop
80104979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104980:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104984:	89 f3                	mov    %esi,%ebx
80104986:	83 c1 01             	add    $0x1,%ecx
80104989:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010498b:	85 db                	test   %ebx,%ebx
8010498d:	7f f1                	jg     80104980 <strncpy+0x40>
  return os;
}
8010498f:	5b                   	pop    %ebx
80104990:	5e                   	pop    %esi
80104991:	5d                   	pop    %ebp
80104992:	c3                   	ret    
80104993:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
801049a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049a8:	8b 45 08             	mov    0x8(%ebp),%eax
801049ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801049ae:	85 c9                	test   %ecx,%ecx
801049b0:	7e 26                	jle    801049d8 <safestrcpy+0x38>
801049b2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801049b6:	89 c1                	mov    %eax,%ecx
801049b8:	eb 17                	jmp    801049d1 <safestrcpy+0x31>
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801049c0:	83 c2 01             	add    $0x1,%edx
801049c3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801049c7:	83 c1 01             	add    $0x1,%ecx
801049ca:	84 db                	test   %bl,%bl
801049cc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801049cf:	74 04                	je     801049d5 <safestrcpy+0x35>
801049d1:	39 f2                	cmp    %esi,%edx
801049d3:	75 eb                	jne    801049c0 <safestrcpy+0x20>
    ;
  *s = 0;
801049d5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801049d8:	5b                   	pop    %ebx
801049d9:	5e                   	pop    %esi
801049da:	5d                   	pop    %ebp
801049db:	c3                   	ret    
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049e0 <strlen>:

int
strlen(const char *s)
{
801049e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049e1:	31 c0                	xor    %eax,%eax
{
801049e3:	89 e5                	mov    %esp,%ebp
801049e5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049e8:	80 3a 00             	cmpb   $0x0,(%edx)
801049eb:	74 0c                	je     801049f9 <strlen+0x19>
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
801049f0:	83 c0 01             	add    $0x1,%eax
801049f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049f7:	75 f7                	jne    801049f0 <strlen+0x10>
    ;
  return n;
}
801049f9:	5d                   	pop    %ebp
801049fa:	c3                   	ret    

801049fb <swtch>:
801049fb:	8b 44 24 04          	mov    0x4(%esp),%eax
801049ff:	8b 54 24 08          	mov    0x8(%esp),%edx
80104a03:	55                   	push   %ebp
80104a04:	53                   	push   %ebx
80104a05:	56                   	push   %esi
80104a06:	57                   	push   %edi
80104a07:	89 20                	mov    %esp,(%eax)
80104a09:	89 d4                	mov    %edx,%esp
80104a0b:	5f                   	pop    %edi
80104a0c:	5e                   	pop    %esi
80104a0d:	5b                   	pop    %ebx
80104a0e:	5d                   	pop    %ebp
80104a0f:	c3                   	ret    

80104a10 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	53                   	push   %ebx
80104a14:	83 ec 04             	sub    $0x4,%esp
80104a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a1a:	e8 31 f1 ff ff       	call   80103b50 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a1f:	8b 00                	mov    (%eax),%eax
80104a21:	39 d8                	cmp    %ebx,%eax
80104a23:	76 1b                	jbe    80104a40 <fetchint+0x30>
80104a25:	8d 53 04             	lea    0x4(%ebx),%edx
80104a28:	39 d0                	cmp    %edx,%eax
80104a2a:	72 14                	jb     80104a40 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a2f:	8b 13                	mov    (%ebx),%edx
80104a31:	89 10                	mov    %edx,(%eax)
  return 0;
80104a33:	31 c0                	xor    %eax,%eax
}
80104a35:	83 c4 04             	add    $0x4,%esp
80104a38:	5b                   	pop    %ebx
80104a39:	5d                   	pop    %ebp
80104a3a:	c3                   	ret    
80104a3b:	90                   	nop
80104a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a45:	eb ee                	jmp    80104a35 <fetchint+0x25>
80104a47:	89 f6                	mov    %esi,%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a50 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	53                   	push   %ebx
80104a54:	83 ec 04             	sub    $0x4,%esp
80104a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a5a:	e8 f1 f0 ff ff       	call   80103b50 <myproc>

  if(addr >= curproc->sz)
80104a5f:	39 18                	cmp    %ebx,(%eax)
80104a61:	76 29                	jbe    80104a8c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104a63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104a66:	89 da                	mov    %ebx,%edx
80104a68:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104a6a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104a6c:	39 c3                	cmp    %eax,%ebx
80104a6e:	73 1c                	jae    80104a8c <fetchstr+0x3c>
    if(*s == 0)
80104a70:	80 3b 00             	cmpb   $0x0,(%ebx)
80104a73:	75 10                	jne    80104a85 <fetchstr+0x35>
80104a75:	eb 39                	jmp    80104ab0 <fetchstr+0x60>
80104a77:	89 f6                	mov    %esi,%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104a80:	80 3a 00             	cmpb   $0x0,(%edx)
80104a83:	74 1b                	je     80104aa0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104a85:	83 c2 01             	add    $0x1,%edx
80104a88:	39 d0                	cmp    %edx,%eax
80104a8a:	77 f4                	ja     80104a80 <fetchstr+0x30>
    return -1;
80104a8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104a91:	83 c4 04             	add    $0x4,%esp
80104a94:	5b                   	pop    %ebx
80104a95:	5d                   	pop    %ebp
80104a96:	c3                   	ret    
80104a97:	89 f6                	mov    %esi,%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104aa0:	83 c4 04             	add    $0x4,%esp
80104aa3:	89 d0                	mov    %edx,%eax
80104aa5:	29 d8                	sub    %ebx,%eax
80104aa7:	5b                   	pop    %ebx
80104aa8:	5d                   	pop    %ebp
80104aa9:	c3                   	ret    
80104aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104ab0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104ab2:	eb dd                	jmp    80104a91 <fetchstr+0x41>
80104ab4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ac0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ac5:	e8 86 f0 ff ff       	call   80103b50 <myproc>
80104aca:	8b 40 18             	mov    0x18(%eax),%eax
80104acd:	8b 55 08             	mov    0x8(%ebp),%edx
80104ad0:	8b 40 44             	mov    0x44(%eax),%eax
80104ad3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ad6:	e8 75 f0 ff ff       	call   80103b50 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104adb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104add:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ae0:	39 c6                	cmp    %eax,%esi
80104ae2:	73 1c                	jae    80104b00 <argint+0x40>
80104ae4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ae7:	39 d0                	cmp    %edx,%eax
80104ae9:	72 15                	jb     80104b00 <argint+0x40>
  *ip = *(int*)(addr);
80104aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aee:	8b 53 04             	mov    0x4(%ebx),%edx
80104af1:	89 10                	mov    %edx,(%eax)
  return 0;
80104af3:	31 c0                	xor    %eax,%eax
}
80104af5:	5b                   	pop    %ebx
80104af6:	5e                   	pop    %esi
80104af7:	5d                   	pop    %ebp
80104af8:	c3                   	ret    
80104af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b05:	eb ee                	jmp    80104af5 <argint+0x35>
80104b07:	89 f6                	mov    %esi,%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b10 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
80104b15:	83 ec 10             	sub    $0x10,%esp
80104b18:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104b1b:	e8 30 f0 ff ff       	call   80103b50 <myproc>
80104b20:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104b22:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b25:	83 ec 08             	sub    $0x8,%esp
80104b28:	50                   	push   %eax
80104b29:	ff 75 08             	pushl  0x8(%ebp)
80104b2c:	e8 8f ff ff ff       	call   80104ac0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b31:	83 c4 10             	add    $0x10,%esp
80104b34:	85 c0                	test   %eax,%eax
80104b36:	78 28                	js     80104b60 <argptr+0x50>
80104b38:	85 db                	test   %ebx,%ebx
80104b3a:	78 24                	js     80104b60 <argptr+0x50>
80104b3c:	8b 16                	mov    (%esi),%edx
80104b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b41:	39 c2                	cmp    %eax,%edx
80104b43:	76 1b                	jbe    80104b60 <argptr+0x50>
80104b45:	01 c3                	add    %eax,%ebx
80104b47:	39 da                	cmp    %ebx,%edx
80104b49:	72 15                	jb     80104b60 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b4e:	89 02                	mov    %eax,(%edx)
  return 0;
80104b50:	31 c0                	xor    %eax,%eax
}
80104b52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b55:	5b                   	pop    %ebx
80104b56:	5e                   	pop    %esi
80104b57:	5d                   	pop    %ebp
80104b58:	c3                   	ret    
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b65:	eb eb                	jmp    80104b52 <argptr+0x42>
80104b67:	89 f6                	mov    %esi,%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b70 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104b76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b79:	50                   	push   %eax
80104b7a:	ff 75 08             	pushl  0x8(%ebp)
80104b7d:	e8 3e ff ff ff       	call   80104ac0 <argint>
80104b82:	83 c4 10             	add    $0x10,%esp
80104b85:	85 c0                	test   %eax,%eax
80104b87:	78 17                	js     80104ba0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104b89:	83 ec 08             	sub    $0x8,%esp
80104b8c:	ff 75 0c             	pushl  0xc(%ebp)
80104b8f:	ff 75 f4             	pushl  -0xc(%ebp)
80104b92:	e8 b9 fe ff ff       	call   80104a50 <fetchstr>
80104b97:	83 c4 10             	add    $0x10,%esp
}
80104b9a:	c9                   	leave  
80104b9b:	c3                   	ret    
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ba5:	c9                   	leave  
80104ba6:	c3                   	ret    
80104ba7:	89 f6                	mov    %esi,%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bb0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104bb7:	e8 94 ef ff ff       	call   80103b50 <myproc>
80104bbc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104bbe:	8b 40 18             	mov    0x18(%eax),%eax
80104bc1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104bc4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104bc7:	83 fa 14             	cmp    $0x14,%edx
80104bca:	77 1c                	ja     80104be8 <syscall+0x38>
80104bcc:	8b 14 85 00 79 10 80 	mov    -0x7fef8700(,%eax,4),%edx
80104bd3:	85 d2                	test   %edx,%edx
80104bd5:	74 11                	je     80104be8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104bd7:	ff d2                	call   *%edx
80104bd9:	8b 53 18             	mov    0x18(%ebx),%edx
80104bdc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104bdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104be2:	c9                   	leave  
80104be3:	c3                   	ret    
80104be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104be8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104be9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104bec:	50                   	push   %eax
80104bed:	ff 73 10             	pushl  0x10(%ebx)
80104bf0:	68 d1 78 10 80       	push   $0x801078d1
80104bf5:	e8 66 ba ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104bfa:	8b 43 18             	mov    0x18(%ebx),%eax
80104bfd:	83 c4 10             	add    $0x10,%esp
80104c00:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c0a:	c9                   	leave  
80104c0b:	c3                   	ret    
80104c0c:	66 90                	xchg   %ax,%ax
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	57                   	push   %edi
80104c14:	56                   	push   %esi
80104c15:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c16:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104c19:	83 ec 44             	sub    $0x44,%esp
80104c1c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104c1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104c22:	56                   	push   %esi
80104c23:	50                   	push   %eax
{
80104c24:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104c27:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c2a:	e8 41 d6 ff ff       	call   80102270 <nameiparent>
80104c2f:	83 c4 10             	add    $0x10,%esp
80104c32:	85 c0                	test   %eax,%eax
80104c34:	0f 84 46 01 00 00    	je     80104d80 <create+0x170>
    return 0;
  ilock(dp);
80104c3a:	83 ec 0c             	sub    $0xc,%esp
80104c3d:	89 c3                	mov    %eax,%ebx
80104c3f:	50                   	push   %eax
80104c40:	e8 ab cd ff ff       	call   801019f0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104c45:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104c48:	83 c4 0c             	add    $0xc,%esp
80104c4b:	50                   	push   %eax
80104c4c:	56                   	push   %esi
80104c4d:	53                   	push   %ebx
80104c4e:	e8 cd d2 ff ff       	call   80101f20 <dirlookup>
80104c53:	83 c4 10             	add    $0x10,%esp
80104c56:	85 c0                	test   %eax,%eax
80104c58:	89 c7                	mov    %eax,%edi
80104c5a:	74 34                	je     80104c90 <create+0x80>
    iunlockput(dp);
80104c5c:	83 ec 0c             	sub    $0xc,%esp
80104c5f:	53                   	push   %ebx
80104c60:	e8 1b d0 ff ff       	call   80101c80 <iunlockput>
    ilock(ip);
80104c65:	89 3c 24             	mov    %edi,(%esp)
80104c68:	e8 83 cd ff ff       	call   801019f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c6d:	83 c4 10             	add    $0x10,%esp
80104c70:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104c75:	0f 85 95 00 00 00    	jne    80104d10 <create+0x100>
80104c7b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104c80:	0f 85 8a 00 00 00    	jne    80104d10 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c89:	89 f8                	mov    %edi,%eax
80104c8b:	5b                   	pop    %ebx
80104c8c:	5e                   	pop    %esi
80104c8d:	5f                   	pop    %edi
80104c8e:	5d                   	pop    %ebp
80104c8f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104c90:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104c94:	83 ec 08             	sub    $0x8,%esp
80104c97:	50                   	push   %eax
80104c98:	ff 33                	pushl  (%ebx)
80104c9a:	e8 e1 cb ff ff       	call   80101880 <ialloc>
80104c9f:	83 c4 10             	add    $0x10,%esp
80104ca2:	85 c0                	test   %eax,%eax
80104ca4:	89 c7                	mov    %eax,%edi
80104ca6:	0f 84 e8 00 00 00    	je     80104d94 <create+0x184>
  ilock(ip);
80104cac:	83 ec 0c             	sub    $0xc,%esp
80104caf:	50                   	push   %eax
80104cb0:	e8 3b cd ff ff       	call   801019f0 <ilock>
  ip->major = major;
80104cb5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104cb9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104cbd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104cc1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104cc5:	b8 01 00 00 00       	mov    $0x1,%eax
80104cca:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104cce:	89 3c 24             	mov    %edi,(%esp)
80104cd1:	e8 6a cc ff ff       	call   80101940 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104cd6:	83 c4 10             	add    $0x10,%esp
80104cd9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104cde:	74 50                	je     80104d30 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ce0:	83 ec 04             	sub    $0x4,%esp
80104ce3:	ff 77 04             	pushl  0x4(%edi)
80104ce6:	56                   	push   %esi
80104ce7:	53                   	push   %ebx
80104ce8:	e8 a3 d4 ff ff       	call   80102190 <dirlink>
80104ced:	83 c4 10             	add    $0x10,%esp
80104cf0:	85 c0                	test   %eax,%eax
80104cf2:	0f 88 8f 00 00 00    	js     80104d87 <create+0x177>
  iunlockput(dp);
80104cf8:	83 ec 0c             	sub    $0xc,%esp
80104cfb:	53                   	push   %ebx
80104cfc:	e8 7f cf ff ff       	call   80101c80 <iunlockput>
  return ip;
80104d01:	83 c4 10             	add    $0x10,%esp
}
80104d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d07:	89 f8                	mov    %edi,%eax
80104d09:	5b                   	pop    %ebx
80104d0a:	5e                   	pop    %esi
80104d0b:	5f                   	pop    %edi
80104d0c:	5d                   	pop    %ebp
80104d0d:	c3                   	ret    
80104d0e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104d10:	83 ec 0c             	sub    $0xc,%esp
80104d13:	57                   	push   %edi
    return 0;
80104d14:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104d16:	e8 65 cf ff ff       	call   80101c80 <iunlockput>
    return 0;
80104d1b:	83 c4 10             	add    $0x10,%esp
}
80104d1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d21:	89 f8                	mov    %edi,%eax
80104d23:	5b                   	pop    %ebx
80104d24:	5e                   	pop    %esi
80104d25:	5f                   	pop    %edi
80104d26:	5d                   	pop    %ebp
80104d27:	c3                   	ret    
80104d28:	90                   	nop
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104d30:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d35:	83 ec 0c             	sub    $0xc,%esp
80104d38:	53                   	push   %ebx
80104d39:	e8 02 cc ff ff       	call   80101940 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d3e:	83 c4 0c             	add    $0xc,%esp
80104d41:	ff 77 04             	pushl  0x4(%edi)
80104d44:	68 74 79 10 80       	push   $0x80107974
80104d49:	57                   	push   %edi
80104d4a:	e8 41 d4 ff ff       	call   80102190 <dirlink>
80104d4f:	83 c4 10             	add    $0x10,%esp
80104d52:	85 c0                	test   %eax,%eax
80104d54:	78 1c                	js     80104d72 <create+0x162>
80104d56:	83 ec 04             	sub    $0x4,%esp
80104d59:	ff 73 04             	pushl  0x4(%ebx)
80104d5c:	68 73 79 10 80       	push   $0x80107973
80104d61:	57                   	push   %edi
80104d62:	e8 29 d4 ff ff       	call   80102190 <dirlink>
80104d67:	83 c4 10             	add    $0x10,%esp
80104d6a:	85 c0                	test   %eax,%eax
80104d6c:	0f 89 6e ff ff ff    	jns    80104ce0 <create+0xd0>
      panic("create dots");
80104d72:	83 ec 0c             	sub    $0xc,%esp
80104d75:	68 67 79 10 80       	push   $0x80107967
80104d7a:	e8 11 b6 ff ff       	call   80100390 <panic>
80104d7f:	90                   	nop
    return 0;
80104d80:	31 ff                	xor    %edi,%edi
80104d82:	e9 ff fe ff ff       	jmp    80104c86 <create+0x76>
    panic("create: dirlink");
80104d87:	83 ec 0c             	sub    $0xc,%esp
80104d8a:	68 76 79 10 80       	push   $0x80107976
80104d8f:	e8 fc b5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104d94:	83 ec 0c             	sub    $0xc,%esp
80104d97:	68 58 79 10 80       	push   $0x80107958
80104d9c:	e8 ef b5 ff ff       	call   80100390 <panic>
80104da1:	eb 0d                	jmp    80104db0 <argfd.constprop.0>
80104da3:	90                   	nop
80104da4:	90                   	nop
80104da5:	90                   	nop
80104da6:	90                   	nop
80104da7:	90                   	nop
80104da8:	90                   	nop
80104da9:	90                   	nop
80104daa:	90                   	nop
80104dab:	90                   	nop
80104dac:	90                   	nop
80104dad:	90                   	nop
80104dae:	90                   	nop
80104daf:	90                   	nop

80104db0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
80104db5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104db7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104dba:	89 d6                	mov    %edx,%esi
80104dbc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104dbf:	50                   	push   %eax
80104dc0:	6a 00                	push   $0x0
80104dc2:	e8 f9 fc ff ff       	call   80104ac0 <argint>
80104dc7:	83 c4 10             	add    $0x10,%esp
80104dca:	85 c0                	test   %eax,%eax
80104dcc:	78 2a                	js     80104df8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dce:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dd2:	77 24                	ja     80104df8 <argfd.constprop.0+0x48>
80104dd4:	e8 77 ed ff ff       	call   80103b50 <myproc>
80104dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ddc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104de0:	85 c0                	test   %eax,%eax
80104de2:	74 14                	je     80104df8 <argfd.constprop.0+0x48>
  if(pfd)
80104de4:	85 db                	test   %ebx,%ebx
80104de6:	74 02                	je     80104dea <argfd.constprop.0+0x3a>
    *pfd = fd;
80104de8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104dea:	89 06                	mov    %eax,(%esi)
  return 0;
80104dec:	31 c0                	xor    %eax,%eax
}
80104dee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104df1:	5b                   	pop    %ebx
80104df2:	5e                   	pop    %esi
80104df3:	5d                   	pop    %ebp
80104df4:	c3                   	ret    
80104df5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dfd:	eb ef                	jmp    80104dee <argfd.constprop.0+0x3e>
80104dff:	90                   	nop

80104e00 <sys_dup>:
{
80104e00:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104e01:	31 c0                	xor    %eax,%eax
{
80104e03:	89 e5                	mov    %esp,%ebp
80104e05:	56                   	push   %esi
80104e06:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104e07:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104e0a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104e0d:	e8 9e ff ff ff       	call   80104db0 <argfd.constprop.0>
80104e12:	85 c0                	test   %eax,%eax
80104e14:	78 42                	js     80104e58 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104e16:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104e19:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104e1b:	e8 30 ed ff ff       	call   80103b50 <myproc>
80104e20:	eb 0e                	jmp    80104e30 <sys_dup+0x30>
80104e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104e28:	83 c3 01             	add    $0x1,%ebx
80104e2b:	83 fb 10             	cmp    $0x10,%ebx
80104e2e:	74 28                	je     80104e58 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104e30:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e34:	85 d2                	test   %edx,%edx
80104e36:	75 f0                	jne    80104e28 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104e38:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e3c:	83 ec 0c             	sub    $0xc,%esp
80104e3f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e42:	e8 09 c3 ff ff       	call   80101150 <filedup>
  return fd;
80104e47:	83 c4 10             	add    $0x10,%esp
}
80104e4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e4d:	89 d8                	mov    %ebx,%eax
80104e4f:	5b                   	pop    %ebx
80104e50:	5e                   	pop    %esi
80104e51:	5d                   	pop    %ebp
80104e52:	c3                   	ret    
80104e53:	90                   	nop
80104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e58:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e5b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e60:	89 d8                	mov    %ebx,%eax
80104e62:	5b                   	pop    %ebx
80104e63:	5e                   	pop    %esi
80104e64:	5d                   	pop    %ebp
80104e65:	c3                   	ret    
80104e66:	8d 76 00             	lea    0x0(%esi),%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e70 <sys_read>:
{
80104e70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e71:	31 c0                	xor    %eax,%eax
{
80104e73:	89 e5                	mov    %esp,%ebp
80104e75:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e78:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e7b:	e8 30 ff ff ff       	call   80104db0 <argfd.constprop.0>
80104e80:	85 c0                	test   %eax,%eax
80104e82:	78 4c                	js     80104ed0 <sys_read+0x60>
80104e84:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e87:	83 ec 08             	sub    $0x8,%esp
80104e8a:	50                   	push   %eax
80104e8b:	6a 02                	push   $0x2
80104e8d:	e8 2e fc ff ff       	call   80104ac0 <argint>
80104e92:	83 c4 10             	add    $0x10,%esp
80104e95:	85 c0                	test   %eax,%eax
80104e97:	78 37                	js     80104ed0 <sys_read+0x60>
80104e99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e9c:	83 ec 04             	sub    $0x4,%esp
80104e9f:	ff 75 f0             	pushl  -0x10(%ebp)
80104ea2:	50                   	push   %eax
80104ea3:	6a 01                	push   $0x1
80104ea5:	e8 66 fc ff ff       	call   80104b10 <argptr>
80104eaa:	83 c4 10             	add    $0x10,%esp
80104ead:	85 c0                	test   %eax,%eax
80104eaf:	78 1f                	js     80104ed0 <sys_read+0x60>
  return fileread(f, p, n);
80104eb1:	83 ec 04             	sub    $0x4,%esp
80104eb4:	ff 75 f0             	pushl  -0x10(%ebp)
80104eb7:	ff 75 f4             	pushl  -0xc(%ebp)
80104eba:	ff 75 ec             	pushl  -0x14(%ebp)
80104ebd:	e8 fe c3 ff ff       	call   801012c0 <fileread>
80104ec2:	83 c4 10             	add    $0x10,%esp
}
80104ec5:	c9                   	leave  
80104ec6:	c3                   	ret    
80104ec7:	89 f6                	mov    %esi,%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ed5:	c9                   	leave  
80104ed6:	c3                   	ret    
80104ed7:	89 f6                	mov    %esi,%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <sys_write>:
{
80104ee0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ee1:	31 c0                	xor    %eax,%eax
{
80104ee3:	89 e5                	mov    %esp,%ebp
80104ee5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ee8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104eeb:	e8 c0 fe ff ff       	call   80104db0 <argfd.constprop.0>
80104ef0:	85 c0                	test   %eax,%eax
80104ef2:	78 4c                	js     80104f40 <sys_write+0x60>
80104ef4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ef7:	83 ec 08             	sub    $0x8,%esp
80104efa:	50                   	push   %eax
80104efb:	6a 02                	push   $0x2
80104efd:	e8 be fb ff ff       	call   80104ac0 <argint>
80104f02:	83 c4 10             	add    $0x10,%esp
80104f05:	85 c0                	test   %eax,%eax
80104f07:	78 37                	js     80104f40 <sys_write+0x60>
80104f09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f0c:	83 ec 04             	sub    $0x4,%esp
80104f0f:	ff 75 f0             	pushl  -0x10(%ebp)
80104f12:	50                   	push   %eax
80104f13:	6a 01                	push   $0x1
80104f15:	e8 f6 fb ff ff       	call   80104b10 <argptr>
80104f1a:	83 c4 10             	add    $0x10,%esp
80104f1d:	85 c0                	test   %eax,%eax
80104f1f:	78 1f                	js     80104f40 <sys_write+0x60>
  return filewrite(f, p, n);
80104f21:	83 ec 04             	sub    $0x4,%esp
80104f24:	ff 75 f0             	pushl  -0x10(%ebp)
80104f27:	ff 75 f4             	pushl  -0xc(%ebp)
80104f2a:	ff 75 ec             	pushl  -0x14(%ebp)
80104f2d:	e8 1e c4 ff ff       	call   80101350 <filewrite>
80104f32:	83 c4 10             	add    $0x10,%esp
}
80104f35:	c9                   	leave  
80104f36:	c3                   	ret    
80104f37:	89 f6                	mov    %esi,%esi
80104f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f45:	c9                   	leave  
80104f46:	c3                   	ret    
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <sys_close>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104f56:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f5c:	e8 4f fe ff ff       	call   80104db0 <argfd.constprop.0>
80104f61:	85 c0                	test   %eax,%eax
80104f63:	78 2b                	js     80104f90 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104f65:	e8 e6 eb ff ff       	call   80103b50 <myproc>
80104f6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104f6d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f70:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104f77:	00 
  fileclose(f);
80104f78:	ff 75 f4             	pushl  -0xc(%ebp)
80104f7b:	e8 20 c2 ff ff       	call   801011a0 <fileclose>
  return 0;
80104f80:	83 c4 10             	add    $0x10,%esp
80104f83:	31 c0                	xor    %eax,%eax
}
80104f85:	c9                   	leave  
80104f86:	c3                   	ret    
80104f87:	89 f6                	mov    %esi,%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f95:	c9                   	leave  
80104f96:	c3                   	ret    
80104f97:	89 f6                	mov    %esi,%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fa0 <sys_fstat>:
{
80104fa0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104fa1:	31 c0                	xor    %eax,%eax
{
80104fa3:	89 e5                	mov    %esp,%ebp
80104fa5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104fa8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104fab:	e8 00 fe ff ff       	call   80104db0 <argfd.constprop.0>
80104fb0:	85 c0                	test   %eax,%eax
80104fb2:	78 2c                	js     80104fe0 <sys_fstat+0x40>
80104fb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fb7:	83 ec 04             	sub    $0x4,%esp
80104fba:	6a 14                	push   $0x14
80104fbc:	50                   	push   %eax
80104fbd:	6a 01                	push   $0x1
80104fbf:	e8 4c fb ff ff       	call   80104b10 <argptr>
80104fc4:	83 c4 10             	add    $0x10,%esp
80104fc7:	85 c0                	test   %eax,%eax
80104fc9:	78 15                	js     80104fe0 <sys_fstat+0x40>
  return filestat(f, st);
80104fcb:	83 ec 08             	sub    $0x8,%esp
80104fce:	ff 75 f4             	pushl  -0xc(%ebp)
80104fd1:	ff 75 f0             	pushl  -0x10(%ebp)
80104fd4:	e8 97 c2 ff ff       	call   80101270 <filestat>
80104fd9:	83 c4 10             	add    $0x10,%esp
}
80104fdc:	c9                   	leave  
80104fdd:	c3                   	ret    
80104fde:	66 90                	xchg   %ax,%ax
    return -1;
80104fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fe5:	c9                   	leave  
80104fe6:	c3                   	ret    
80104fe7:	89 f6                	mov    %esi,%esi
80104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ff0 <sys_link>:
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	57                   	push   %edi
80104ff4:	56                   	push   %esi
80104ff5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ff6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104ff9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ffc:	50                   	push   %eax
80104ffd:	6a 00                	push   $0x0
80104fff:	e8 6c fb ff ff       	call   80104b70 <argstr>
80105004:	83 c4 10             	add    $0x10,%esp
80105007:	85 c0                	test   %eax,%eax
80105009:	0f 88 fb 00 00 00    	js     8010510a <sys_link+0x11a>
8010500f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105012:	83 ec 08             	sub    $0x8,%esp
80105015:	50                   	push   %eax
80105016:	6a 01                	push   $0x1
80105018:	e8 53 fb ff ff       	call   80104b70 <argstr>
8010501d:	83 c4 10             	add    $0x10,%esp
80105020:	85 c0                	test   %eax,%eax
80105022:	0f 88 e2 00 00 00    	js     8010510a <sys_link+0x11a>
  begin_op();
80105028:	e8 e3 de ff ff       	call   80102f10 <begin_op>
  if((ip = namei(old)) == 0){
8010502d:	83 ec 0c             	sub    $0xc,%esp
80105030:	ff 75 d4             	pushl  -0x2c(%ebp)
80105033:	e8 18 d2 ff ff       	call   80102250 <namei>
80105038:	83 c4 10             	add    $0x10,%esp
8010503b:	85 c0                	test   %eax,%eax
8010503d:	89 c3                	mov    %eax,%ebx
8010503f:	0f 84 ea 00 00 00    	je     8010512f <sys_link+0x13f>
  ilock(ip);
80105045:	83 ec 0c             	sub    $0xc,%esp
80105048:	50                   	push   %eax
80105049:	e8 a2 c9 ff ff       	call   801019f0 <ilock>
  if(ip->type == T_DIR){
8010504e:	83 c4 10             	add    $0x10,%esp
80105051:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105056:	0f 84 bb 00 00 00    	je     80105117 <sys_link+0x127>
  ip->nlink++;
8010505c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105061:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105064:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105067:	53                   	push   %ebx
80105068:	e8 d3 c8 ff ff       	call   80101940 <iupdate>
  iunlock(ip);
8010506d:	89 1c 24             	mov    %ebx,(%esp)
80105070:	e8 5b ca ff ff       	call   80101ad0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105075:	58                   	pop    %eax
80105076:	5a                   	pop    %edx
80105077:	57                   	push   %edi
80105078:	ff 75 d0             	pushl  -0x30(%ebp)
8010507b:	e8 f0 d1 ff ff       	call   80102270 <nameiparent>
80105080:	83 c4 10             	add    $0x10,%esp
80105083:	85 c0                	test   %eax,%eax
80105085:	89 c6                	mov    %eax,%esi
80105087:	74 5b                	je     801050e4 <sys_link+0xf4>
  ilock(dp);
80105089:	83 ec 0c             	sub    $0xc,%esp
8010508c:	50                   	push   %eax
8010508d:	e8 5e c9 ff ff       	call   801019f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105092:	83 c4 10             	add    $0x10,%esp
80105095:	8b 03                	mov    (%ebx),%eax
80105097:	39 06                	cmp    %eax,(%esi)
80105099:	75 3d                	jne    801050d8 <sys_link+0xe8>
8010509b:	83 ec 04             	sub    $0x4,%esp
8010509e:	ff 73 04             	pushl  0x4(%ebx)
801050a1:	57                   	push   %edi
801050a2:	56                   	push   %esi
801050a3:	e8 e8 d0 ff ff       	call   80102190 <dirlink>
801050a8:	83 c4 10             	add    $0x10,%esp
801050ab:	85 c0                	test   %eax,%eax
801050ad:	78 29                	js     801050d8 <sys_link+0xe8>
  iunlockput(dp);
801050af:	83 ec 0c             	sub    $0xc,%esp
801050b2:	56                   	push   %esi
801050b3:	e8 c8 cb ff ff       	call   80101c80 <iunlockput>
  iput(ip);
801050b8:	89 1c 24             	mov    %ebx,(%esp)
801050bb:	e8 60 ca ff ff       	call   80101b20 <iput>
  end_op();
801050c0:	e8 bb de ff ff       	call   80102f80 <end_op>
  return 0;
801050c5:	83 c4 10             	add    $0x10,%esp
801050c8:	31 c0                	xor    %eax,%eax
}
801050ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050cd:	5b                   	pop    %ebx
801050ce:	5e                   	pop    %esi
801050cf:	5f                   	pop    %edi
801050d0:	5d                   	pop    %ebp
801050d1:	c3                   	ret    
801050d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801050d8:	83 ec 0c             	sub    $0xc,%esp
801050db:	56                   	push   %esi
801050dc:	e8 9f cb ff ff       	call   80101c80 <iunlockput>
    goto bad;
801050e1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801050e4:	83 ec 0c             	sub    $0xc,%esp
801050e7:	53                   	push   %ebx
801050e8:	e8 03 c9 ff ff       	call   801019f0 <ilock>
  ip->nlink--;
801050ed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050f2:	89 1c 24             	mov    %ebx,(%esp)
801050f5:	e8 46 c8 ff ff       	call   80101940 <iupdate>
  iunlockput(ip);
801050fa:	89 1c 24             	mov    %ebx,(%esp)
801050fd:	e8 7e cb ff ff       	call   80101c80 <iunlockput>
  end_op();
80105102:	e8 79 de ff ff       	call   80102f80 <end_op>
  return -1;
80105107:	83 c4 10             	add    $0x10,%esp
}
8010510a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010510d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105112:	5b                   	pop    %ebx
80105113:	5e                   	pop    %esi
80105114:	5f                   	pop    %edi
80105115:	5d                   	pop    %ebp
80105116:	c3                   	ret    
    iunlockput(ip);
80105117:	83 ec 0c             	sub    $0xc,%esp
8010511a:	53                   	push   %ebx
8010511b:	e8 60 cb ff ff       	call   80101c80 <iunlockput>
    end_op();
80105120:	e8 5b de ff ff       	call   80102f80 <end_op>
    return -1;
80105125:	83 c4 10             	add    $0x10,%esp
80105128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010512d:	eb 9b                	jmp    801050ca <sys_link+0xda>
    end_op();
8010512f:	e8 4c de ff ff       	call   80102f80 <end_op>
    return -1;
80105134:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105139:	eb 8f                	jmp    801050ca <sys_link+0xda>
8010513b:	90                   	nop
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105140 <sys_unlink>:
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	57                   	push   %edi
80105144:	56                   	push   %esi
80105145:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105146:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105149:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010514c:	50                   	push   %eax
8010514d:	6a 00                	push   $0x0
8010514f:	e8 1c fa ff ff       	call   80104b70 <argstr>
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	85 c0                	test   %eax,%eax
80105159:	0f 88 77 01 00 00    	js     801052d6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010515f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105162:	e8 a9 dd ff ff       	call   80102f10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105167:	83 ec 08             	sub    $0x8,%esp
8010516a:	53                   	push   %ebx
8010516b:	ff 75 c0             	pushl  -0x40(%ebp)
8010516e:	e8 fd d0 ff ff       	call   80102270 <nameiparent>
80105173:	83 c4 10             	add    $0x10,%esp
80105176:	85 c0                	test   %eax,%eax
80105178:	89 c6                	mov    %eax,%esi
8010517a:	0f 84 60 01 00 00    	je     801052e0 <sys_unlink+0x1a0>
  ilock(dp);
80105180:	83 ec 0c             	sub    $0xc,%esp
80105183:	50                   	push   %eax
80105184:	e8 67 c8 ff ff       	call   801019f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105189:	58                   	pop    %eax
8010518a:	5a                   	pop    %edx
8010518b:	68 74 79 10 80       	push   $0x80107974
80105190:	53                   	push   %ebx
80105191:	e8 6a cd ff ff       	call   80101f00 <namecmp>
80105196:	83 c4 10             	add    $0x10,%esp
80105199:	85 c0                	test   %eax,%eax
8010519b:	0f 84 03 01 00 00    	je     801052a4 <sys_unlink+0x164>
801051a1:	83 ec 08             	sub    $0x8,%esp
801051a4:	68 73 79 10 80       	push   $0x80107973
801051a9:	53                   	push   %ebx
801051aa:	e8 51 cd ff ff       	call   80101f00 <namecmp>
801051af:	83 c4 10             	add    $0x10,%esp
801051b2:	85 c0                	test   %eax,%eax
801051b4:	0f 84 ea 00 00 00    	je     801052a4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801051ba:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801051bd:	83 ec 04             	sub    $0x4,%esp
801051c0:	50                   	push   %eax
801051c1:	53                   	push   %ebx
801051c2:	56                   	push   %esi
801051c3:	e8 58 cd ff ff       	call   80101f20 <dirlookup>
801051c8:	83 c4 10             	add    $0x10,%esp
801051cb:	85 c0                	test   %eax,%eax
801051cd:	89 c3                	mov    %eax,%ebx
801051cf:	0f 84 cf 00 00 00    	je     801052a4 <sys_unlink+0x164>
  ilock(ip);
801051d5:	83 ec 0c             	sub    $0xc,%esp
801051d8:	50                   	push   %eax
801051d9:	e8 12 c8 ff ff       	call   801019f0 <ilock>
  if(ip->nlink < 1)
801051de:	83 c4 10             	add    $0x10,%esp
801051e1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801051e6:	0f 8e 10 01 00 00    	jle    801052fc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801051ec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051f1:	74 6d                	je     80105260 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801051f3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801051f6:	83 ec 04             	sub    $0x4,%esp
801051f9:	6a 10                	push   $0x10
801051fb:	6a 00                	push   $0x0
801051fd:	50                   	push   %eax
801051fe:	e8 bd f5 ff ff       	call   801047c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105203:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105206:	6a 10                	push   $0x10
80105208:	ff 75 c4             	pushl  -0x3c(%ebp)
8010520b:	50                   	push   %eax
8010520c:	56                   	push   %esi
8010520d:	e8 be cb ff ff       	call   80101dd0 <writei>
80105212:	83 c4 20             	add    $0x20,%esp
80105215:	83 f8 10             	cmp    $0x10,%eax
80105218:	0f 85 eb 00 00 00    	jne    80105309 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010521e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105223:	0f 84 97 00 00 00    	je     801052c0 <sys_unlink+0x180>
  iunlockput(dp);
80105229:	83 ec 0c             	sub    $0xc,%esp
8010522c:	56                   	push   %esi
8010522d:	e8 4e ca ff ff       	call   80101c80 <iunlockput>
  ip->nlink--;
80105232:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105237:	89 1c 24             	mov    %ebx,(%esp)
8010523a:	e8 01 c7 ff ff       	call   80101940 <iupdate>
  iunlockput(ip);
8010523f:	89 1c 24             	mov    %ebx,(%esp)
80105242:	e8 39 ca ff ff       	call   80101c80 <iunlockput>
  end_op();
80105247:	e8 34 dd ff ff       	call   80102f80 <end_op>
  return 0;
8010524c:	83 c4 10             	add    $0x10,%esp
8010524f:	31 c0                	xor    %eax,%eax
}
80105251:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105254:	5b                   	pop    %ebx
80105255:	5e                   	pop    %esi
80105256:	5f                   	pop    %edi
80105257:	5d                   	pop    %ebp
80105258:	c3                   	ret    
80105259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105260:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105264:	76 8d                	jbe    801051f3 <sys_unlink+0xb3>
80105266:	bf 20 00 00 00       	mov    $0x20,%edi
8010526b:	eb 0f                	jmp    8010527c <sys_unlink+0x13c>
8010526d:	8d 76 00             	lea    0x0(%esi),%esi
80105270:	83 c7 10             	add    $0x10,%edi
80105273:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105276:	0f 83 77 ff ff ff    	jae    801051f3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010527c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010527f:	6a 10                	push   $0x10
80105281:	57                   	push   %edi
80105282:	50                   	push   %eax
80105283:	53                   	push   %ebx
80105284:	e8 47 ca ff ff       	call   80101cd0 <readi>
80105289:	83 c4 10             	add    $0x10,%esp
8010528c:	83 f8 10             	cmp    $0x10,%eax
8010528f:	75 5e                	jne    801052ef <sys_unlink+0x1af>
    if(de.inum != 0)
80105291:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105296:	74 d8                	je     80105270 <sys_unlink+0x130>
    iunlockput(ip);
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	53                   	push   %ebx
8010529c:	e8 df c9 ff ff       	call   80101c80 <iunlockput>
    goto bad;
801052a1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801052a4:	83 ec 0c             	sub    $0xc,%esp
801052a7:	56                   	push   %esi
801052a8:	e8 d3 c9 ff ff       	call   80101c80 <iunlockput>
  end_op();
801052ad:	e8 ce dc ff ff       	call   80102f80 <end_op>
  return -1;
801052b2:	83 c4 10             	add    $0x10,%esp
801052b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ba:	eb 95                	jmp    80105251 <sys_unlink+0x111>
801052bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801052c0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801052c5:	83 ec 0c             	sub    $0xc,%esp
801052c8:	56                   	push   %esi
801052c9:	e8 72 c6 ff ff       	call   80101940 <iupdate>
801052ce:	83 c4 10             	add    $0x10,%esp
801052d1:	e9 53 ff ff ff       	jmp    80105229 <sys_unlink+0xe9>
    return -1;
801052d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052db:	e9 71 ff ff ff       	jmp    80105251 <sys_unlink+0x111>
    end_op();
801052e0:	e8 9b dc ff ff       	call   80102f80 <end_op>
    return -1;
801052e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ea:	e9 62 ff ff ff       	jmp    80105251 <sys_unlink+0x111>
      panic("isdirempty: readi");
801052ef:	83 ec 0c             	sub    $0xc,%esp
801052f2:	68 98 79 10 80       	push   $0x80107998
801052f7:	e8 94 b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801052fc:	83 ec 0c             	sub    $0xc,%esp
801052ff:	68 86 79 10 80       	push   $0x80107986
80105304:	e8 87 b0 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105309:	83 ec 0c             	sub    $0xc,%esp
8010530c:	68 aa 79 10 80       	push   $0x801079aa
80105311:	e8 7a b0 ff ff       	call   80100390 <panic>
80105316:	8d 76 00             	lea    0x0(%esi),%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105320 <sys_open>:

int
sys_open(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	57                   	push   %edi
80105324:	56                   	push   %esi
80105325:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105326:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105329:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010532c:	50                   	push   %eax
8010532d:	6a 00                	push   $0x0
8010532f:	e8 3c f8 ff ff       	call   80104b70 <argstr>
80105334:	83 c4 10             	add    $0x10,%esp
80105337:	85 c0                	test   %eax,%eax
80105339:	0f 88 1d 01 00 00    	js     8010545c <sys_open+0x13c>
8010533f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105342:	83 ec 08             	sub    $0x8,%esp
80105345:	50                   	push   %eax
80105346:	6a 01                	push   $0x1
80105348:	e8 73 f7 ff ff       	call   80104ac0 <argint>
8010534d:	83 c4 10             	add    $0x10,%esp
80105350:	85 c0                	test   %eax,%eax
80105352:	0f 88 04 01 00 00    	js     8010545c <sys_open+0x13c>
    return -1;

  begin_op();
80105358:	e8 b3 db ff ff       	call   80102f10 <begin_op>

  if(omode & O_CREATE){
8010535d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105361:	0f 85 a9 00 00 00    	jne    80105410 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105367:	83 ec 0c             	sub    $0xc,%esp
8010536a:	ff 75 e0             	pushl  -0x20(%ebp)
8010536d:	e8 de ce ff ff       	call   80102250 <namei>
80105372:	83 c4 10             	add    $0x10,%esp
80105375:	85 c0                	test   %eax,%eax
80105377:	89 c6                	mov    %eax,%esi
80105379:	0f 84 b2 00 00 00    	je     80105431 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010537f:	83 ec 0c             	sub    $0xc,%esp
80105382:	50                   	push   %eax
80105383:	e8 68 c6 ff ff       	call   801019f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105388:	83 c4 10             	add    $0x10,%esp
8010538b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105390:	0f 84 aa 00 00 00    	je     80105440 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105396:	e8 45 bd ff ff       	call   801010e0 <filealloc>
8010539b:	85 c0                	test   %eax,%eax
8010539d:	89 c7                	mov    %eax,%edi
8010539f:	0f 84 a6 00 00 00    	je     8010544b <sys_open+0x12b>
  struct proc *curproc = myproc();
801053a5:	e8 a6 e7 ff ff       	call   80103b50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053aa:	31 db                	xor    %ebx,%ebx
801053ac:	eb 0e                	jmp    801053bc <sys_open+0x9c>
801053ae:	66 90                	xchg   %ax,%ax
801053b0:	83 c3 01             	add    $0x1,%ebx
801053b3:	83 fb 10             	cmp    $0x10,%ebx
801053b6:	0f 84 ac 00 00 00    	je     80105468 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801053bc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053c0:	85 d2                	test   %edx,%edx
801053c2:	75 ec                	jne    801053b0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801053c4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801053c7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801053cb:	56                   	push   %esi
801053cc:	e8 ff c6 ff ff       	call   80101ad0 <iunlock>
  end_op();
801053d1:	e8 aa db ff ff       	call   80102f80 <end_op>

  f->type = FD_INODE;
801053d6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801053dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053df:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801053e2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801053e5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801053ec:	89 d0                	mov    %edx,%eax
801053ee:	f7 d0                	not    %eax
801053f0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053f3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801053f6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053f9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801053fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105400:	89 d8                	mov    %ebx,%eax
80105402:	5b                   	pop    %ebx
80105403:	5e                   	pop    %esi
80105404:	5f                   	pop    %edi
80105405:	5d                   	pop    %ebp
80105406:	c3                   	ret    
80105407:	89 f6                	mov    %esi,%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105410:	83 ec 0c             	sub    $0xc,%esp
80105413:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105416:	31 c9                	xor    %ecx,%ecx
80105418:	6a 00                	push   $0x0
8010541a:	ba 02 00 00 00       	mov    $0x2,%edx
8010541f:	e8 ec f7 ff ff       	call   80104c10 <create>
    if(ip == 0){
80105424:	83 c4 10             	add    $0x10,%esp
80105427:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105429:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010542b:	0f 85 65 ff ff ff    	jne    80105396 <sys_open+0x76>
      end_op();
80105431:	e8 4a db ff ff       	call   80102f80 <end_op>
      return -1;
80105436:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010543b:	eb c0                	jmp    801053fd <sys_open+0xdd>
8010543d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105440:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105443:	85 c9                	test   %ecx,%ecx
80105445:	0f 84 4b ff ff ff    	je     80105396 <sys_open+0x76>
    iunlockput(ip);
8010544b:	83 ec 0c             	sub    $0xc,%esp
8010544e:	56                   	push   %esi
8010544f:	e8 2c c8 ff ff       	call   80101c80 <iunlockput>
    end_op();
80105454:	e8 27 db ff ff       	call   80102f80 <end_op>
    return -1;
80105459:	83 c4 10             	add    $0x10,%esp
8010545c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105461:	eb 9a                	jmp    801053fd <sys_open+0xdd>
80105463:	90                   	nop
80105464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105468:	83 ec 0c             	sub    $0xc,%esp
8010546b:	57                   	push   %edi
8010546c:	e8 2f bd ff ff       	call   801011a0 <fileclose>
80105471:	83 c4 10             	add    $0x10,%esp
80105474:	eb d5                	jmp    8010544b <sys_open+0x12b>
80105476:	8d 76 00             	lea    0x0(%esi),%esi
80105479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105480 <sys_mkdir>:

int
sys_mkdir(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105486:	e8 85 da ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010548b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010548e:	83 ec 08             	sub    $0x8,%esp
80105491:	50                   	push   %eax
80105492:	6a 00                	push   $0x0
80105494:	e8 d7 f6 ff ff       	call   80104b70 <argstr>
80105499:	83 c4 10             	add    $0x10,%esp
8010549c:	85 c0                	test   %eax,%eax
8010549e:	78 30                	js     801054d0 <sys_mkdir+0x50>
801054a0:	83 ec 0c             	sub    $0xc,%esp
801054a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a6:	31 c9                	xor    %ecx,%ecx
801054a8:	6a 00                	push   $0x0
801054aa:	ba 01 00 00 00       	mov    $0x1,%edx
801054af:	e8 5c f7 ff ff       	call   80104c10 <create>
801054b4:	83 c4 10             	add    $0x10,%esp
801054b7:	85 c0                	test   %eax,%eax
801054b9:	74 15                	je     801054d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054bb:	83 ec 0c             	sub    $0xc,%esp
801054be:	50                   	push   %eax
801054bf:	e8 bc c7 ff ff       	call   80101c80 <iunlockput>
  end_op();
801054c4:	e8 b7 da ff ff       	call   80102f80 <end_op>
  return 0;
801054c9:	83 c4 10             	add    $0x10,%esp
801054cc:	31 c0                	xor    %eax,%eax
}
801054ce:	c9                   	leave  
801054cf:	c3                   	ret    
    end_op();
801054d0:	e8 ab da ff ff       	call   80102f80 <end_op>
    return -1;
801054d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054da:	c9                   	leave  
801054db:	c3                   	ret    
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054e0 <sys_mknod>:

int
sys_mknod(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801054e6:	e8 25 da ff ff       	call   80102f10 <begin_op>
  if((argstr(0, &path)) < 0 ||
801054eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054ee:	83 ec 08             	sub    $0x8,%esp
801054f1:	50                   	push   %eax
801054f2:	6a 00                	push   $0x0
801054f4:	e8 77 f6 ff ff       	call   80104b70 <argstr>
801054f9:	83 c4 10             	add    $0x10,%esp
801054fc:	85 c0                	test   %eax,%eax
801054fe:	78 60                	js     80105560 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105500:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105503:	83 ec 08             	sub    $0x8,%esp
80105506:	50                   	push   %eax
80105507:	6a 01                	push   $0x1
80105509:	e8 b2 f5 ff ff       	call   80104ac0 <argint>
  if((argstr(0, &path)) < 0 ||
8010550e:	83 c4 10             	add    $0x10,%esp
80105511:	85 c0                	test   %eax,%eax
80105513:	78 4b                	js     80105560 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105515:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105518:	83 ec 08             	sub    $0x8,%esp
8010551b:	50                   	push   %eax
8010551c:	6a 02                	push   $0x2
8010551e:	e8 9d f5 ff ff       	call   80104ac0 <argint>
     argint(1, &major) < 0 ||
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	78 36                	js     80105560 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010552a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010552e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105531:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105535:	ba 03 00 00 00       	mov    $0x3,%edx
8010553a:	50                   	push   %eax
8010553b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010553e:	e8 cd f6 ff ff       	call   80104c10 <create>
80105543:	83 c4 10             	add    $0x10,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	74 16                	je     80105560 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010554a:	83 ec 0c             	sub    $0xc,%esp
8010554d:	50                   	push   %eax
8010554e:	e8 2d c7 ff ff       	call   80101c80 <iunlockput>
  end_op();
80105553:	e8 28 da ff ff       	call   80102f80 <end_op>
  return 0;
80105558:	83 c4 10             	add    $0x10,%esp
8010555b:	31 c0                	xor    %eax,%eax
}
8010555d:	c9                   	leave  
8010555e:	c3                   	ret    
8010555f:	90                   	nop
    end_op();
80105560:	e8 1b da ff ff       	call   80102f80 <end_op>
    return -1;
80105565:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010556a:	c9                   	leave  
8010556b:	c3                   	ret    
8010556c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105570 <sys_chdir>:

int
sys_chdir(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	56                   	push   %esi
80105574:	53                   	push   %ebx
80105575:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105578:	e8 d3 e5 ff ff       	call   80103b50 <myproc>
8010557d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010557f:	e8 8c d9 ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105584:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105587:	83 ec 08             	sub    $0x8,%esp
8010558a:	50                   	push   %eax
8010558b:	6a 00                	push   $0x0
8010558d:	e8 de f5 ff ff       	call   80104b70 <argstr>
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	85 c0                	test   %eax,%eax
80105597:	78 77                	js     80105610 <sys_chdir+0xa0>
80105599:	83 ec 0c             	sub    $0xc,%esp
8010559c:	ff 75 f4             	pushl  -0xc(%ebp)
8010559f:	e8 ac cc ff ff       	call   80102250 <namei>
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	85 c0                	test   %eax,%eax
801055a9:	89 c3                	mov    %eax,%ebx
801055ab:	74 63                	je     80105610 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801055ad:	83 ec 0c             	sub    $0xc,%esp
801055b0:	50                   	push   %eax
801055b1:	e8 3a c4 ff ff       	call   801019f0 <ilock>
  if(ip->type != T_DIR){
801055b6:	83 c4 10             	add    $0x10,%esp
801055b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055be:	75 30                	jne    801055f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055c0:	83 ec 0c             	sub    $0xc,%esp
801055c3:	53                   	push   %ebx
801055c4:	e8 07 c5 ff ff       	call   80101ad0 <iunlock>
  iput(curproc->cwd);
801055c9:	58                   	pop    %eax
801055ca:	ff 76 68             	pushl  0x68(%esi)
801055cd:	e8 4e c5 ff ff       	call   80101b20 <iput>
  end_op();
801055d2:	e8 a9 d9 ff ff       	call   80102f80 <end_op>
  curproc->cwd = ip;
801055d7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801055da:	83 c4 10             	add    $0x10,%esp
801055dd:	31 c0                	xor    %eax,%eax
}
801055df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055e2:	5b                   	pop    %ebx
801055e3:	5e                   	pop    %esi
801055e4:	5d                   	pop    %ebp
801055e5:	c3                   	ret    
801055e6:	8d 76 00             	lea    0x0(%esi),%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801055f0:	83 ec 0c             	sub    $0xc,%esp
801055f3:	53                   	push   %ebx
801055f4:	e8 87 c6 ff ff       	call   80101c80 <iunlockput>
    end_op();
801055f9:	e8 82 d9 ff ff       	call   80102f80 <end_op>
    return -1;
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105606:	eb d7                	jmp    801055df <sys_chdir+0x6f>
80105608:	90                   	nop
80105609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105610:	e8 6b d9 ff ff       	call   80102f80 <end_op>
    return -1;
80105615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010561a:	eb c3                	jmp    801055df <sys_chdir+0x6f>
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105620 <sys_exec>:

int
sys_exec(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	57                   	push   %edi
80105624:	56                   	push   %esi
80105625:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105626:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010562c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105632:	50                   	push   %eax
80105633:	6a 00                	push   $0x0
80105635:	e8 36 f5 ff ff       	call   80104b70 <argstr>
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	85 c0                	test   %eax,%eax
8010563f:	0f 88 87 00 00 00    	js     801056cc <sys_exec+0xac>
80105645:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010564b:	83 ec 08             	sub    $0x8,%esp
8010564e:	50                   	push   %eax
8010564f:	6a 01                	push   $0x1
80105651:	e8 6a f4 ff ff       	call   80104ac0 <argint>
80105656:	83 c4 10             	add    $0x10,%esp
80105659:	85 c0                	test   %eax,%eax
8010565b:	78 6f                	js     801056cc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010565d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105663:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105666:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105668:	68 80 00 00 00       	push   $0x80
8010566d:	6a 00                	push   $0x0
8010566f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105675:	50                   	push   %eax
80105676:	e8 45 f1 ff ff       	call   801047c0 <memset>
8010567b:	83 c4 10             	add    $0x10,%esp
8010567e:	eb 2c                	jmp    801056ac <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105680:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105686:	85 c0                	test   %eax,%eax
80105688:	74 56                	je     801056e0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010568a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105690:	83 ec 08             	sub    $0x8,%esp
80105693:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105696:	52                   	push   %edx
80105697:	50                   	push   %eax
80105698:	e8 b3 f3 ff ff       	call   80104a50 <fetchstr>
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	85 c0                	test   %eax,%eax
801056a2:	78 28                	js     801056cc <sys_exec+0xac>
  for(i=0;; i++){
801056a4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801056a7:	83 fb 20             	cmp    $0x20,%ebx
801056aa:	74 20                	je     801056cc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801056ac:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801056b2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801056b9:	83 ec 08             	sub    $0x8,%esp
801056bc:	57                   	push   %edi
801056bd:	01 f0                	add    %esi,%eax
801056bf:	50                   	push   %eax
801056c0:	e8 4b f3 ff ff       	call   80104a10 <fetchint>
801056c5:	83 c4 10             	add    $0x10,%esp
801056c8:	85 c0                	test   %eax,%eax
801056ca:	79 b4                	jns    80105680 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801056cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801056cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056d4:	5b                   	pop    %ebx
801056d5:	5e                   	pop    %esi
801056d6:	5f                   	pop    %edi
801056d7:	5d                   	pop    %ebp
801056d8:	c3                   	ret    
801056d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801056e0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801056e6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801056e9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801056f0:	00 00 00 00 
  return exec(path, argv);
801056f4:	50                   	push   %eax
801056f5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801056fb:	e8 70 b6 ff ff       	call   80100d70 <exec>
80105700:	83 c4 10             	add    $0x10,%esp
}
80105703:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105706:	5b                   	pop    %ebx
80105707:	5e                   	pop    %esi
80105708:	5f                   	pop    %edi
80105709:	5d                   	pop    %ebp
8010570a:	c3                   	ret    
8010570b:	90                   	nop
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_pipe>:

int
sys_pipe(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	57                   	push   %edi
80105714:	56                   	push   %esi
80105715:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105716:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105719:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010571c:	6a 08                	push   $0x8
8010571e:	50                   	push   %eax
8010571f:	6a 00                	push   $0x0
80105721:	e8 ea f3 ff ff       	call   80104b10 <argptr>
80105726:	83 c4 10             	add    $0x10,%esp
80105729:	85 c0                	test   %eax,%eax
8010572b:	0f 88 ae 00 00 00    	js     801057df <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105731:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105734:	83 ec 08             	sub    $0x8,%esp
80105737:	50                   	push   %eax
80105738:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010573b:	50                   	push   %eax
8010573c:	e8 6f de ff ff       	call   801035b0 <pipealloc>
80105741:	83 c4 10             	add    $0x10,%esp
80105744:	85 c0                	test   %eax,%eax
80105746:	0f 88 93 00 00 00    	js     801057df <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010574c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010574f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105751:	e8 fa e3 ff ff       	call   80103b50 <myproc>
80105756:	eb 10                	jmp    80105768 <sys_pipe+0x58>
80105758:	90                   	nop
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105760:	83 c3 01             	add    $0x1,%ebx
80105763:	83 fb 10             	cmp    $0x10,%ebx
80105766:	74 60                	je     801057c8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105768:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010576c:	85 f6                	test   %esi,%esi
8010576e:	75 f0                	jne    80105760 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105770:	8d 73 08             	lea    0x8(%ebx),%esi
80105773:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105777:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010577a:	e8 d1 e3 ff ff       	call   80103b50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010577f:	31 d2                	xor    %edx,%edx
80105781:	eb 0d                	jmp    80105790 <sys_pipe+0x80>
80105783:	90                   	nop
80105784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105788:	83 c2 01             	add    $0x1,%edx
8010578b:	83 fa 10             	cmp    $0x10,%edx
8010578e:	74 28                	je     801057b8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105790:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105794:	85 c9                	test   %ecx,%ecx
80105796:	75 f0                	jne    80105788 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105798:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010579c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010579f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801057a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057a4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801057a7:	31 c0                	xor    %eax,%eax
}
801057a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057ac:	5b                   	pop    %ebx
801057ad:	5e                   	pop    %esi
801057ae:	5f                   	pop    %edi
801057af:	5d                   	pop    %ebp
801057b0:	c3                   	ret    
801057b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801057b8:	e8 93 e3 ff ff       	call   80103b50 <myproc>
801057bd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801057c4:	00 
801057c5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801057c8:	83 ec 0c             	sub    $0xc,%esp
801057cb:	ff 75 e0             	pushl  -0x20(%ebp)
801057ce:	e8 cd b9 ff ff       	call   801011a0 <fileclose>
    fileclose(wf);
801057d3:	58                   	pop    %eax
801057d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801057d7:	e8 c4 b9 ff ff       	call   801011a0 <fileclose>
    return -1;
801057dc:	83 c4 10             	add    $0x10,%esp
801057df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e4:	eb c3                	jmp    801057a9 <sys_pipe+0x99>
801057e6:	66 90                	xchg   %ax,%ax
801057e8:	66 90                	xchg   %ax,%ax
801057ea:	66 90                	xchg   %ax,%ax
801057ec:	66 90                	xchg   %ax,%ax
801057ee:	66 90                	xchg   %ax,%ax

801057f0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801057f3:	5d                   	pop    %ebp
  return fork();
801057f4:	e9 f7 e4 ff ff       	jmp    80103cf0 <fork>
801057f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105800 <sys_exit>:

int
sys_exit(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	83 ec 08             	sub    $0x8,%esp
  exit();
80105806:	e8 65 e7 ff ff       	call   80103f70 <exit>
  return 0;  // not reached
}
8010580b:	31 c0                	xor    %eax,%eax
8010580d:	c9                   	leave  
8010580e:	c3                   	ret    
8010580f:	90                   	nop

80105810 <sys_wait>:

int
sys_wait(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105813:	5d                   	pop    %ebp
  return wait();
80105814:	e9 97 e9 ff ff       	jmp    801041b0 <wait>
80105819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105820 <sys_kill>:

int
sys_kill(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105826:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105829:	50                   	push   %eax
8010582a:	6a 00                	push   $0x0
8010582c:	e8 8f f2 ff ff       	call   80104ac0 <argint>
80105831:	83 c4 10             	add    $0x10,%esp
80105834:	85 c0                	test   %eax,%eax
80105836:	78 18                	js     80105850 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105838:	83 ec 0c             	sub    $0xc,%esp
8010583b:	ff 75 f4             	pushl  -0xc(%ebp)
8010583e:	e8 bd ea ff ff       	call   80104300 <kill>
80105843:	83 c4 10             	add    $0x10,%esp
}
80105846:	c9                   	leave  
80105847:	c3                   	ret    
80105848:	90                   	nop
80105849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105855:	c9                   	leave  
80105856:	c3                   	ret    
80105857:	89 f6                	mov    %esi,%esi
80105859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105860 <sys_getpid>:

int
sys_getpid(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105866:	e8 e5 e2 ff ff       	call   80103b50 <myproc>
8010586b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010586e:	c9                   	leave  
8010586f:	c3                   	ret    

80105870 <sys_sbrk>:

int
sys_sbrk(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105874:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105877:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010587a:	50                   	push   %eax
8010587b:	6a 00                	push   $0x0
8010587d:	e8 3e f2 ff ff       	call   80104ac0 <argint>
80105882:	83 c4 10             	add    $0x10,%esp
80105885:	85 c0                	test   %eax,%eax
80105887:	78 27                	js     801058b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105889:	e8 c2 e2 ff ff       	call   80103b50 <myproc>
  if(growproc(n) < 0)
8010588e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105891:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105893:	ff 75 f4             	pushl  -0xc(%ebp)
80105896:	e8 d5 e3 ff ff       	call   80103c70 <growproc>
8010589b:	83 c4 10             	add    $0x10,%esp
8010589e:	85 c0                	test   %eax,%eax
801058a0:	78 0e                	js     801058b0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801058a2:	89 d8                	mov    %ebx,%eax
801058a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058a7:	c9                   	leave  
801058a8:	c3                   	ret    
801058a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058b5:	eb eb                	jmp    801058a2 <sys_sbrk+0x32>
801058b7:	89 f6                	mov    %esi,%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058c0 <sys_sleep>:

int
sys_sleep(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801058c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058ca:	50                   	push   %eax
801058cb:	6a 00                	push   $0x0
801058cd:	e8 ee f1 ff ff       	call   80104ac0 <argint>
801058d2:	83 c4 10             	add    $0x10,%esp
801058d5:	85 c0                	test   %eax,%eax
801058d7:	0f 88 8a 00 00 00    	js     80105967 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801058dd:	83 ec 0c             	sub    $0xc,%esp
801058e0:	68 a0 4c 11 80       	push   $0x80114ca0
801058e5:	e8 c6 ed ff ff       	call   801046b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801058ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058ed:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801058f0:	8b 1d e0 54 11 80    	mov    0x801154e0,%ebx
  while(ticks - ticks0 < n){
801058f6:	85 d2                	test   %edx,%edx
801058f8:	75 27                	jne    80105921 <sys_sleep+0x61>
801058fa:	eb 54                	jmp    80105950 <sys_sleep+0x90>
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105900:	83 ec 08             	sub    $0x8,%esp
80105903:	68 a0 4c 11 80       	push   $0x80114ca0
80105908:	68 e0 54 11 80       	push   $0x801154e0
8010590d:	e8 de e7 ff ff       	call   801040f0 <sleep>
  while(ticks - ticks0 < n){
80105912:	a1 e0 54 11 80       	mov    0x801154e0,%eax
80105917:	83 c4 10             	add    $0x10,%esp
8010591a:	29 d8                	sub    %ebx,%eax
8010591c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010591f:	73 2f                	jae    80105950 <sys_sleep+0x90>
    if(myproc()->killed){
80105921:	e8 2a e2 ff ff       	call   80103b50 <myproc>
80105926:	8b 40 24             	mov    0x24(%eax),%eax
80105929:	85 c0                	test   %eax,%eax
8010592b:	74 d3                	je     80105900 <sys_sleep+0x40>
      release(&tickslock);
8010592d:	83 ec 0c             	sub    $0xc,%esp
80105930:	68 a0 4c 11 80       	push   $0x80114ca0
80105935:	e8 36 ee ff ff       	call   80104770 <release>
      return -1;
8010593a:	83 c4 10             	add    $0x10,%esp
8010593d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105942:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105945:	c9                   	leave  
80105946:	c3                   	ret    
80105947:	89 f6                	mov    %esi,%esi
80105949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105950:	83 ec 0c             	sub    $0xc,%esp
80105953:	68 a0 4c 11 80       	push   $0x80114ca0
80105958:	e8 13 ee ff ff       	call   80104770 <release>
  return 0;
8010595d:	83 c4 10             	add    $0x10,%esp
80105960:	31 c0                	xor    %eax,%eax
}
80105962:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105965:	c9                   	leave  
80105966:	c3                   	ret    
    return -1;
80105967:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596c:	eb f4                	jmp    80105962 <sys_sleep+0xa2>
8010596e:	66 90                	xchg   %ax,%ax

80105970 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	53                   	push   %ebx
80105974:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105977:	68 a0 4c 11 80       	push   $0x80114ca0
8010597c:	e8 2f ed ff ff       	call   801046b0 <acquire>
  xticks = ticks;
80105981:	8b 1d e0 54 11 80    	mov    0x801154e0,%ebx
  release(&tickslock);
80105987:	c7 04 24 a0 4c 11 80 	movl   $0x80114ca0,(%esp)
8010598e:	e8 dd ed ff ff       	call   80104770 <release>
  return xticks;
}
80105993:	89 d8                	mov    %ebx,%eax
80105995:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105998:	c9                   	leave  
80105999:	c3                   	ret    

8010599a <alltraps>:
8010599a:	1e                   	push   %ds
8010599b:	06                   	push   %es
8010599c:	0f a0                	push   %fs
8010599e:	0f a8                	push   %gs
801059a0:	60                   	pusha  
801059a1:	66 b8 10 00          	mov    $0x10,%ax
801059a5:	8e d8                	mov    %eax,%ds
801059a7:	8e c0                	mov    %eax,%es
801059a9:	54                   	push   %esp
801059aa:	e8 c1 00 00 00       	call   80105a70 <trap>
801059af:	83 c4 04             	add    $0x4,%esp

801059b2 <trapret>:
801059b2:	61                   	popa   
801059b3:	0f a9                	pop    %gs
801059b5:	0f a1                	pop    %fs
801059b7:	07                   	pop    %es
801059b8:	1f                   	pop    %ds
801059b9:	83 c4 08             	add    $0x8,%esp
801059bc:	cf                   	iret   
801059bd:	66 90                	xchg   %ax,%ax
801059bf:	90                   	nop

801059c0 <tvinit>:
801059c0:	55                   	push   %ebp
801059c1:	31 c0                	xor    %eax,%eax
801059c3:	89 e5                	mov    %esp,%ebp
801059c5:	83 ec 08             	sub    $0x8,%esp
801059c8:	90                   	nop
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059d0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801059d7:	c7 04 c5 e2 4c 11 80 	movl   $0x8e000008,-0x7feeb31e(,%eax,8)
801059de:	08 00 00 8e 
801059e2:	66 89 14 c5 e0 4c 11 	mov    %dx,-0x7feeb320(,%eax,8)
801059e9:	80 
801059ea:	c1 ea 10             	shr    $0x10,%edx
801059ed:	66 89 14 c5 e6 4c 11 	mov    %dx,-0x7feeb31a(,%eax,8)
801059f4:	80 
801059f5:	83 c0 01             	add    $0x1,%eax
801059f8:	3d 00 01 00 00       	cmp    $0x100,%eax
801059fd:	75 d1                	jne    801059d0 <tvinit+0x10>
801059ff:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105a04:	83 ec 08             	sub    $0x8,%esp
80105a07:	c7 05 e2 4e 11 80 08 	movl   $0xef000008,0x80114ee2
80105a0e:	00 00 ef 
80105a11:	68 b9 79 10 80       	push   $0x801079b9
80105a16:	68 a0 4c 11 80       	push   $0x80114ca0
80105a1b:	66 a3 e0 4e 11 80    	mov    %ax,0x80114ee0
80105a21:	c1 e8 10             	shr    $0x10,%eax
80105a24:	66 a3 e6 4e 11 80    	mov    %ax,0x80114ee6
80105a2a:	e8 41 eb ff ff       	call   80104570 <initlock>
80105a2f:	83 c4 10             	add    $0x10,%esp
80105a32:	c9                   	leave  
80105a33:	c3                   	ret    
80105a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105a40 <idtinit>:
80105a40:	55                   	push   %ebp
80105a41:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105a46:	89 e5                	mov    %esp,%ebp
80105a48:	83 ec 10             	sub    $0x10,%esp
80105a4b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
80105a4f:	b8 e0 4c 11 80       	mov    $0x80114ce0,%eax
80105a54:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80105a58:	c1 e8 10             	shr    $0x10,%eax
80105a5b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
80105a5f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a62:	0f 01 18             	lidtl  (%eax)
80105a65:	c9                   	leave  
80105a66:	c3                   	ret    
80105a67:	89 f6                	mov    %esi,%esi
80105a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a70 <trap>:
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	57                   	push   %edi
80105a74:	56                   	push   %esi
80105a75:	53                   	push   %ebx
80105a76:	83 ec 1c             	sub    $0x1c,%esp
80105a79:	8b 7d 08             	mov    0x8(%ebp),%edi
80105a7c:	8b 47 30             	mov    0x30(%edi),%eax
80105a7f:	83 f8 40             	cmp    $0x40,%eax
80105a82:	0f 84 f0 00 00 00    	je     80105b78 <trap+0x108>
80105a88:	83 e8 20             	sub    $0x20,%eax
80105a8b:	83 f8 1f             	cmp    $0x1f,%eax
80105a8e:	77 10                	ja     80105aa0 <trap+0x30>
80105a90:	ff 24 85 60 7a 10 80 	jmp    *-0x7fef85a0(,%eax,4)
80105a97:	89 f6                	mov    %esi,%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105aa0:	e8 ab e0 ff ff       	call   80103b50 <myproc>
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105aaa:	0f 84 14 02 00 00    	je     80105cc4 <trap+0x254>
80105ab0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105ab4:	0f 84 0a 02 00 00    	je     80105cc4 <trap+0x254>
80105aba:	0f 20 d1             	mov    %cr2,%ecx
80105abd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105ac0:	e8 6b e0 ff ff       	call   80103b30 <cpuid>
80105ac5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ac8:	8b 47 34             	mov    0x34(%edi),%eax
80105acb:	8b 77 30             	mov    0x30(%edi),%esi
80105ace:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105ad1:	e8 7a e0 ff ff       	call   80103b50 <myproc>
80105ad6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ad9:	e8 72 e0 ff ff       	call   80103b50 <myproc>
80105ade:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ae1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ae4:	51                   	push   %ecx
80105ae5:	53                   	push   %ebx
80105ae6:	52                   	push   %edx
80105ae7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105aea:	ff 75 e4             	pushl  -0x1c(%ebp)
80105aed:	56                   	push   %esi
80105aee:	83 c2 6c             	add    $0x6c,%edx
80105af1:	52                   	push   %edx
80105af2:	ff 70 10             	pushl  0x10(%eax)
80105af5:	68 1c 7a 10 80       	push   $0x80107a1c
80105afa:	e8 61 ab ff ff       	call   80100660 <cprintf>
80105aff:	83 c4 20             	add    $0x20,%esp
80105b02:	e8 49 e0 ff ff       	call   80103b50 <myproc>
80105b07:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105b0e:	e8 3d e0 ff ff       	call   80103b50 <myproc>
80105b13:	85 c0                	test   %eax,%eax
80105b15:	74 1d                	je     80105b34 <trap+0xc4>
80105b17:	e8 34 e0 ff ff       	call   80103b50 <myproc>
80105b1c:	8b 50 24             	mov    0x24(%eax),%edx
80105b1f:	85 d2                	test   %edx,%edx
80105b21:	74 11                	je     80105b34 <trap+0xc4>
80105b23:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105b27:	83 e0 03             	and    $0x3,%eax
80105b2a:	66 83 f8 03          	cmp    $0x3,%ax
80105b2e:	0f 84 4c 01 00 00    	je     80105c80 <trap+0x210>
80105b34:	e8 17 e0 ff ff       	call   80103b50 <myproc>
80105b39:	85 c0                	test   %eax,%eax
80105b3b:	74 0b                	je     80105b48 <trap+0xd8>
80105b3d:	e8 0e e0 ff ff       	call   80103b50 <myproc>
80105b42:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b46:	74 68                	je     80105bb0 <trap+0x140>
80105b48:	e8 03 e0 ff ff       	call   80103b50 <myproc>
80105b4d:	85 c0                	test   %eax,%eax
80105b4f:	74 19                	je     80105b6a <trap+0xfa>
80105b51:	e8 fa df ff ff       	call   80103b50 <myproc>
80105b56:	8b 40 24             	mov    0x24(%eax),%eax
80105b59:	85 c0                	test   %eax,%eax
80105b5b:	74 0d                	je     80105b6a <trap+0xfa>
80105b5d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105b61:	83 e0 03             	and    $0x3,%eax
80105b64:	66 83 f8 03          	cmp    $0x3,%ax
80105b68:	74 37                	je     80105ba1 <trap+0x131>
80105b6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b6d:	5b                   	pop    %ebx
80105b6e:	5e                   	pop    %esi
80105b6f:	5f                   	pop    %edi
80105b70:	5d                   	pop    %ebp
80105b71:	c3                   	ret    
80105b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b78:	e8 d3 df ff ff       	call   80103b50 <myproc>
80105b7d:	8b 58 24             	mov    0x24(%eax),%ebx
80105b80:	85 db                	test   %ebx,%ebx
80105b82:	0f 85 e8 00 00 00    	jne    80105c70 <trap+0x200>
80105b88:	e8 c3 df ff ff       	call   80103b50 <myproc>
80105b8d:	89 78 18             	mov    %edi,0x18(%eax)
80105b90:	e8 1b f0 ff ff       	call   80104bb0 <syscall>
80105b95:	e8 b6 df ff ff       	call   80103b50 <myproc>
80105b9a:	8b 48 24             	mov    0x24(%eax),%ecx
80105b9d:	85 c9                	test   %ecx,%ecx
80105b9f:	74 c9                	je     80105b6a <trap+0xfa>
80105ba1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba4:	5b                   	pop    %ebx
80105ba5:	5e                   	pop    %esi
80105ba6:	5f                   	pop    %edi
80105ba7:	5d                   	pop    %ebp
80105ba8:	e9 c3 e3 ff ff       	jmp    80103f70 <exit>
80105bad:	8d 76 00             	lea    0x0(%esi),%esi
80105bb0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105bb4:	75 92                	jne    80105b48 <trap+0xd8>
80105bb6:	e8 e5 e4 ff ff       	call   801040a0 <yield>
80105bbb:	eb 8b                	jmp    80105b48 <trap+0xd8>
80105bbd:	8d 76 00             	lea    0x0(%esi),%esi
80105bc0:	e8 6b df ff ff       	call   80103b30 <cpuid>
80105bc5:	85 c0                	test   %eax,%eax
80105bc7:	0f 84 c3 00 00 00    	je     80105c90 <trap+0x220>
80105bcd:	e8 ee ce ff ff       	call   80102ac0 <lapiceoi>
80105bd2:	e8 79 df ff ff       	call   80103b50 <myproc>
80105bd7:	85 c0                	test   %eax,%eax
80105bd9:	0f 85 38 ff ff ff    	jne    80105b17 <trap+0xa7>
80105bdf:	e9 50 ff ff ff       	jmp    80105b34 <trap+0xc4>
80105be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105be8:	e8 93 cd ff ff       	call   80102980 <kbdintr>
80105bed:	e8 ce ce ff ff       	call   80102ac0 <lapiceoi>
80105bf2:	e8 59 df ff ff       	call   80103b50 <myproc>
80105bf7:	85 c0                	test   %eax,%eax
80105bf9:	0f 85 18 ff ff ff    	jne    80105b17 <trap+0xa7>
80105bff:	e9 30 ff ff ff       	jmp    80105b34 <trap+0xc4>
80105c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c08:	e8 53 02 00 00       	call   80105e60 <uartintr>
80105c0d:	e8 ae ce ff ff       	call   80102ac0 <lapiceoi>
80105c12:	e8 39 df ff ff       	call   80103b50 <myproc>
80105c17:	85 c0                	test   %eax,%eax
80105c19:	0f 85 f8 fe ff ff    	jne    80105b17 <trap+0xa7>
80105c1f:	e9 10 ff ff ff       	jmp    80105b34 <trap+0xc4>
80105c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c28:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105c2c:	8b 77 38             	mov    0x38(%edi),%esi
80105c2f:	e8 fc de ff ff       	call   80103b30 <cpuid>
80105c34:	56                   	push   %esi
80105c35:	53                   	push   %ebx
80105c36:	50                   	push   %eax
80105c37:	68 c4 79 10 80       	push   $0x801079c4
80105c3c:	e8 1f aa ff ff       	call   80100660 <cprintf>
80105c41:	e8 7a ce ff ff       	call   80102ac0 <lapiceoi>
80105c46:	83 c4 10             	add    $0x10,%esp
80105c49:	e8 02 df ff ff       	call   80103b50 <myproc>
80105c4e:	85 c0                	test   %eax,%eax
80105c50:	0f 85 c1 fe ff ff    	jne    80105b17 <trap+0xa7>
80105c56:	e9 d9 fe ff ff       	jmp    80105b34 <trap+0xc4>
80105c5b:	90                   	nop
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c60:	e8 8b c7 ff ff       	call   801023f0 <ideintr>
80105c65:	e9 63 ff ff ff       	jmp    80105bcd <trap+0x15d>
80105c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c70:	e8 fb e2 ff ff       	call   80103f70 <exit>
80105c75:	e9 0e ff ff ff       	jmp    80105b88 <trap+0x118>
80105c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c80:	e8 eb e2 ff ff       	call   80103f70 <exit>
80105c85:	e9 aa fe ff ff       	jmp    80105b34 <trap+0xc4>
80105c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c90:	83 ec 0c             	sub    $0xc,%esp
80105c93:	68 a0 4c 11 80       	push   $0x80114ca0
80105c98:	e8 13 ea ff ff       	call   801046b0 <acquire>
80105c9d:	c7 04 24 e0 54 11 80 	movl   $0x801154e0,(%esp)
80105ca4:	83 05 e0 54 11 80 01 	addl   $0x1,0x801154e0
80105cab:	e8 f0 e5 ff ff       	call   801042a0 <wakeup>
80105cb0:	c7 04 24 a0 4c 11 80 	movl   $0x80114ca0,(%esp)
80105cb7:	e8 b4 ea ff ff       	call   80104770 <release>
80105cbc:	83 c4 10             	add    $0x10,%esp
80105cbf:	e9 09 ff ff ff       	jmp    80105bcd <trap+0x15d>
80105cc4:	0f 20 d6             	mov    %cr2,%esi
80105cc7:	e8 64 de ff ff       	call   80103b30 <cpuid>
80105ccc:	83 ec 0c             	sub    $0xc,%esp
80105ccf:	56                   	push   %esi
80105cd0:	53                   	push   %ebx
80105cd1:	50                   	push   %eax
80105cd2:	ff 77 30             	pushl  0x30(%edi)
80105cd5:	68 e8 79 10 80       	push   $0x801079e8
80105cda:	e8 81 a9 ff ff       	call   80100660 <cprintf>
80105cdf:	83 c4 14             	add    $0x14,%esp
80105ce2:	68 be 79 10 80       	push   $0x801079be
80105ce7:	e8 a4 a6 ff ff       	call   80100390 <panic>
80105cec:	66 90                	xchg   %ax,%ax
80105cee:	66 90                	xchg   %ax,%ax

80105cf0 <uartgetc>:
80105cf0:	a1 fc a5 10 80       	mov    0x8010a5fc,%eax
80105cf5:	55                   	push   %ebp
80105cf6:	89 e5                	mov    %esp,%ebp
80105cf8:	85 c0                	test   %eax,%eax
80105cfa:	74 1c                	je     80105d18 <uartgetc+0x28>
80105cfc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d01:	ec                   	in     (%dx),%al
80105d02:	a8 01                	test   $0x1,%al
80105d04:	74 12                	je     80105d18 <uartgetc+0x28>
80105d06:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d0b:	ec                   	in     (%dx),%al
80105d0c:	0f b6 c0             	movzbl %al,%eax
80105d0f:	5d                   	pop    %ebp
80105d10:	c3                   	ret    
80105d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d1d:	5d                   	pop    %ebp
80105d1e:	c3                   	ret    
80105d1f:	90                   	nop

80105d20 <uartputc.part.0>:
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	57                   	push   %edi
80105d24:	56                   	push   %esi
80105d25:	53                   	push   %ebx
80105d26:	89 c7                	mov    %eax,%edi
80105d28:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d2d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105d32:	83 ec 0c             	sub    $0xc,%esp
80105d35:	eb 1b                	jmp    80105d52 <uartputc.part.0+0x32>
80105d37:	89 f6                	mov    %esi,%esi
80105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105d40:	83 ec 0c             	sub    $0xc,%esp
80105d43:	6a 0a                	push   $0xa
80105d45:	e8 96 cd ff ff       	call   80102ae0 <microdelay>
80105d4a:	83 c4 10             	add    $0x10,%esp
80105d4d:	83 eb 01             	sub    $0x1,%ebx
80105d50:	74 07                	je     80105d59 <uartputc.part.0+0x39>
80105d52:	89 f2                	mov    %esi,%edx
80105d54:	ec                   	in     (%dx),%al
80105d55:	a8 20                	test   $0x20,%al
80105d57:	74 e7                	je     80105d40 <uartputc.part.0+0x20>
80105d59:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d5e:	89 f8                	mov    %edi,%eax
80105d60:	ee                   	out    %al,(%dx)
80105d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d64:	5b                   	pop    %ebx
80105d65:	5e                   	pop    %esi
80105d66:	5f                   	pop    %edi
80105d67:	5d                   	pop    %ebp
80105d68:	c3                   	ret    
80105d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d70 <uartinit>:
80105d70:	55                   	push   %ebp
80105d71:	31 c9                	xor    %ecx,%ecx
80105d73:	89 c8                	mov    %ecx,%eax
80105d75:	89 e5                	mov    %esp,%ebp
80105d77:	57                   	push   %edi
80105d78:	56                   	push   %esi
80105d79:	53                   	push   %ebx
80105d7a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105d7f:	89 da                	mov    %ebx,%edx
80105d81:	83 ec 0c             	sub    $0xc,%esp
80105d84:	ee                   	out    %al,(%dx)
80105d85:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105d8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d8f:	89 fa                	mov    %edi,%edx
80105d91:	ee                   	out    %al,(%dx)
80105d92:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d9c:	ee                   	out    %al,(%dx)
80105d9d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105da2:	89 c8                	mov    %ecx,%eax
80105da4:	89 f2                	mov    %esi,%edx
80105da6:	ee                   	out    %al,(%dx)
80105da7:	b8 03 00 00 00       	mov    $0x3,%eax
80105dac:	89 fa                	mov    %edi,%edx
80105dae:	ee                   	out    %al,(%dx)
80105daf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105db4:	89 c8                	mov    %ecx,%eax
80105db6:	ee                   	out    %al,(%dx)
80105db7:	b8 01 00 00 00       	mov    $0x1,%eax
80105dbc:	89 f2                	mov    %esi,%edx
80105dbe:	ee                   	out    %al,(%dx)
80105dbf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105dc4:	ec                   	in     (%dx),%al
80105dc5:	3c ff                	cmp    $0xff,%al
80105dc7:	74 5a                	je     80105e23 <uartinit+0xb3>
80105dc9:	c7 05 fc a5 10 80 01 	movl   $0x1,0x8010a5fc
80105dd0:	00 00 00 
80105dd3:	89 da                	mov    %ebx,%edx
80105dd5:	ec                   	in     (%dx),%al
80105dd6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ddb:	ec                   	in     (%dx),%al
80105ddc:	83 ec 08             	sub    $0x8,%esp
80105ddf:	bb e0 7a 10 80       	mov    $0x80107ae0,%ebx
80105de4:	6a 00                	push   $0x0
80105de6:	6a 04                	push   $0x4
80105de8:	e8 53 c8 ff ff       	call   80102640 <ioapicenable>
80105ded:	83 c4 10             	add    $0x10,%esp
80105df0:	b8 78 00 00 00       	mov    $0x78,%eax
80105df5:	eb 13                	jmp    80105e0a <uartinit+0x9a>
80105df7:	89 f6                	mov    %esi,%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105e00:	83 c3 01             	add    $0x1,%ebx
80105e03:	0f be 03             	movsbl (%ebx),%eax
80105e06:	84 c0                	test   %al,%al
80105e08:	74 19                	je     80105e23 <uartinit+0xb3>
80105e0a:	8b 15 fc a5 10 80    	mov    0x8010a5fc,%edx
80105e10:	85 d2                	test   %edx,%edx
80105e12:	74 ec                	je     80105e00 <uartinit+0x90>
80105e14:	83 c3 01             	add    $0x1,%ebx
80105e17:	e8 04 ff ff ff       	call   80105d20 <uartputc.part.0>
80105e1c:	0f be 03             	movsbl (%ebx),%eax
80105e1f:	84 c0                	test   %al,%al
80105e21:	75 e7                	jne    80105e0a <uartinit+0x9a>
80105e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e26:	5b                   	pop    %ebx
80105e27:	5e                   	pop    %esi
80105e28:	5f                   	pop    %edi
80105e29:	5d                   	pop    %ebp
80105e2a:	c3                   	ret    
80105e2b:	90                   	nop
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e30 <uartputc>:
80105e30:	8b 15 fc a5 10 80    	mov    0x8010a5fc,%edx
80105e36:	55                   	push   %ebp
80105e37:	89 e5                	mov    %esp,%ebp
80105e39:	85 d2                	test   %edx,%edx
80105e3b:	8b 45 08             	mov    0x8(%ebp),%eax
80105e3e:	74 10                	je     80105e50 <uartputc+0x20>
80105e40:	5d                   	pop    %ebp
80105e41:	e9 da fe ff ff       	jmp    80105d20 <uartputc.part.0>
80105e46:	8d 76 00             	lea    0x0(%esi),%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105e50:	5d                   	pop    %ebp
80105e51:	c3                   	ret    
80105e52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e60 <uartintr>:
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	83 ec 14             	sub    $0x14,%esp
80105e66:	68 f0 5c 10 80       	push   $0x80105cf0
80105e6b:	e8 f0 ab ff ff       	call   80100a60 <consoleintr>
80105e70:	83 c4 10             	add    $0x10,%esp
80105e73:	c9                   	leave  
80105e74:	c3                   	ret    

80105e75 <vector0>:
80105e75:	6a 00                	push   $0x0
80105e77:	6a 00                	push   $0x0
80105e79:	e9 1c fb ff ff       	jmp    8010599a <alltraps>

80105e7e <vector1>:
80105e7e:	6a 00                	push   $0x0
80105e80:	6a 01                	push   $0x1
80105e82:	e9 13 fb ff ff       	jmp    8010599a <alltraps>

80105e87 <vector2>:
80105e87:	6a 00                	push   $0x0
80105e89:	6a 02                	push   $0x2
80105e8b:	e9 0a fb ff ff       	jmp    8010599a <alltraps>

80105e90 <vector3>:
80105e90:	6a 00                	push   $0x0
80105e92:	6a 03                	push   $0x3
80105e94:	e9 01 fb ff ff       	jmp    8010599a <alltraps>

80105e99 <vector4>:
80105e99:	6a 00                	push   $0x0
80105e9b:	6a 04                	push   $0x4
80105e9d:	e9 f8 fa ff ff       	jmp    8010599a <alltraps>

80105ea2 <vector5>:
80105ea2:	6a 00                	push   $0x0
80105ea4:	6a 05                	push   $0x5
80105ea6:	e9 ef fa ff ff       	jmp    8010599a <alltraps>

80105eab <vector6>:
80105eab:	6a 00                	push   $0x0
80105ead:	6a 06                	push   $0x6
80105eaf:	e9 e6 fa ff ff       	jmp    8010599a <alltraps>

80105eb4 <vector7>:
80105eb4:	6a 00                	push   $0x0
80105eb6:	6a 07                	push   $0x7
80105eb8:	e9 dd fa ff ff       	jmp    8010599a <alltraps>

80105ebd <vector8>:
80105ebd:	6a 08                	push   $0x8
80105ebf:	e9 d6 fa ff ff       	jmp    8010599a <alltraps>

80105ec4 <vector9>:
80105ec4:	6a 00                	push   $0x0
80105ec6:	6a 09                	push   $0x9
80105ec8:	e9 cd fa ff ff       	jmp    8010599a <alltraps>

80105ecd <vector10>:
80105ecd:	6a 0a                	push   $0xa
80105ecf:	e9 c6 fa ff ff       	jmp    8010599a <alltraps>

80105ed4 <vector11>:
80105ed4:	6a 0b                	push   $0xb
80105ed6:	e9 bf fa ff ff       	jmp    8010599a <alltraps>

80105edb <vector12>:
80105edb:	6a 0c                	push   $0xc
80105edd:	e9 b8 fa ff ff       	jmp    8010599a <alltraps>

80105ee2 <vector13>:
80105ee2:	6a 0d                	push   $0xd
80105ee4:	e9 b1 fa ff ff       	jmp    8010599a <alltraps>

80105ee9 <vector14>:
80105ee9:	6a 0e                	push   $0xe
80105eeb:	e9 aa fa ff ff       	jmp    8010599a <alltraps>

80105ef0 <vector15>:
80105ef0:	6a 00                	push   $0x0
80105ef2:	6a 0f                	push   $0xf
80105ef4:	e9 a1 fa ff ff       	jmp    8010599a <alltraps>

80105ef9 <vector16>:
80105ef9:	6a 00                	push   $0x0
80105efb:	6a 10                	push   $0x10
80105efd:	e9 98 fa ff ff       	jmp    8010599a <alltraps>

80105f02 <vector17>:
80105f02:	6a 11                	push   $0x11
80105f04:	e9 91 fa ff ff       	jmp    8010599a <alltraps>

80105f09 <vector18>:
80105f09:	6a 00                	push   $0x0
80105f0b:	6a 12                	push   $0x12
80105f0d:	e9 88 fa ff ff       	jmp    8010599a <alltraps>

80105f12 <vector19>:
80105f12:	6a 00                	push   $0x0
80105f14:	6a 13                	push   $0x13
80105f16:	e9 7f fa ff ff       	jmp    8010599a <alltraps>

80105f1b <vector20>:
80105f1b:	6a 00                	push   $0x0
80105f1d:	6a 14                	push   $0x14
80105f1f:	e9 76 fa ff ff       	jmp    8010599a <alltraps>

80105f24 <vector21>:
80105f24:	6a 00                	push   $0x0
80105f26:	6a 15                	push   $0x15
80105f28:	e9 6d fa ff ff       	jmp    8010599a <alltraps>

80105f2d <vector22>:
80105f2d:	6a 00                	push   $0x0
80105f2f:	6a 16                	push   $0x16
80105f31:	e9 64 fa ff ff       	jmp    8010599a <alltraps>

80105f36 <vector23>:
80105f36:	6a 00                	push   $0x0
80105f38:	6a 17                	push   $0x17
80105f3a:	e9 5b fa ff ff       	jmp    8010599a <alltraps>

80105f3f <vector24>:
80105f3f:	6a 00                	push   $0x0
80105f41:	6a 18                	push   $0x18
80105f43:	e9 52 fa ff ff       	jmp    8010599a <alltraps>

80105f48 <vector25>:
80105f48:	6a 00                	push   $0x0
80105f4a:	6a 19                	push   $0x19
80105f4c:	e9 49 fa ff ff       	jmp    8010599a <alltraps>

80105f51 <vector26>:
80105f51:	6a 00                	push   $0x0
80105f53:	6a 1a                	push   $0x1a
80105f55:	e9 40 fa ff ff       	jmp    8010599a <alltraps>

80105f5a <vector27>:
80105f5a:	6a 00                	push   $0x0
80105f5c:	6a 1b                	push   $0x1b
80105f5e:	e9 37 fa ff ff       	jmp    8010599a <alltraps>

80105f63 <vector28>:
80105f63:	6a 00                	push   $0x0
80105f65:	6a 1c                	push   $0x1c
80105f67:	e9 2e fa ff ff       	jmp    8010599a <alltraps>

80105f6c <vector29>:
80105f6c:	6a 00                	push   $0x0
80105f6e:	6a 1d                	push   $0x1d
80105f70:	e9 25 fa ff ff       	jmp    8010599a <alltraps>

80105f75 <vector30>:
80105f75:	6a 00                	push   $0x0
80105f77:	6a 1e                	push   $0x1e
80105f79:	e9 1c fa ff ff       	jmp    8010599a <alltraps>

80105f7e <vector31>:
80105f7e:	6a 00                	push   $0x0
80105f80:	6a 1f                	push   $0x1f
80105f82:	e9 13 fa ff ff       	jmp    8010599a <alltraps>

80105f87 <vector32>:
80105f87:	6a 00                	push   $0x0
80105f89:	6a 20                	push   $0x20
80105f8b:	e9 0a fa ff ff       	jmp    8010599a <alltraps>

80105f90 <vector33>:
80105f90:	6a 00                	push   $0x0
80105f92:	6a 21                	push   $0x21
80105f94:	e9 01 fa ff ff       	jmp    8010599a <alltraps>

80105f99 <vector34>:
80105f99:	6a 00                	push   $0x0
80105f9b:	6a 22                	push   $0x22
80105f9d:	e9 f8 f9 ff ff       	jmp    8010599a <alltraps>

80105fa2 <vector35>:
80105fa2:	6a 00                	push   $0x0
80105fa4:	6a 23                	push   $0x23
80105fa6:	e9 ef f9 ff ff       	jmp    8010599a <alltraps>

80105fab <vector36>:
80105fab:	6a 00                	push   $0x0
80105fad:	6a 24                	push   $0x24
80105faf:	e9 e6 f9 ff ff       	jmp    8010599a <alltraps>

80105fb4 <vector37>:
80105fb4:	6a 00                	push   $0x0
80105fb6:	6a 25                	push   $0x25
80105fb8:	e9 dd f9 ff ff       	jmp    8010599a <alltraps>

80105fbd <vector38>:
80105fbd:	6a 00                	push   $0x0
80105fbf:	6a 26                	push   $0x26
80105fc1:	e9 d4 f9 ff ff       	jmp    8010599a <alltraps>

80105fc6 <vector39>:
80105fc6:	6a 00                	push   $0x0
80105fc8:	6a 27                	push   $0x27
80105fca:	e9 cb f9 ff ff       	jmp    8010599a <alltraps>

80105fcf <vector40>:
80105fcf:	6a 00                	push   $0x0
80105fd1:	6a 28                	push   $0x28
80105fd3:	e9 c2 f9 ff ff       	jmp    8010599a <alltraps>

80105fd8 <vector41>:
80105fd8:	6a 00                	push   $0x0
80105fda:	6a 29                	push   $0x29
80105fdc:	e9 b9 f9 ff ff       	jmp    8010599a <alltraps>

80105fe1 <vector42>:
80105fe1:	6a 00                	push   $0x0
80105fe3:	6a 2a                	push   $0x2a
80105fe5:	e9 b0 f9 ff ff       	jmp    8010599a <alltraps>

80105fea <vector43>:
80105fea:	6a 00                	push   $0x0
80105fec:	6a 2b                	push   $0x2b
80105fee:	e9 a7 f9 ff ff       	jmp    8010599a <alltraps>

80105ff3 <vector44>:
80105ff3:	6a 00                	push   $0x0
80105ff5:	6a 2c                	push   $0x2c
80105ff7:	e9 9e f9 ff ff       	jmp    8010599a <alltraps>

80105ffc <vector45>:
80105ffc:	6a 00                	push   $0x0
80105ffe:	6a 2d                	push   $0x2d
80106000:	e9 95 f9 ff ff       	jmp    8010599a <alltraps>

80106005 <vector46>:
80106005:	6a 00                	push   $0x0
80106007:	6a 2e                	push   $0x2e
80106009:	e9 8c f9 ff ff       	jmp    8010599a <alltraps>

8010600e <vector47>:
8010600e:	6a 00                	push   $0x0
80106010:	6a 2f                	push   $0x2f
80106012:	e9 83 f9 ff ff       	jmp    8010599a <alltraps>

80106017 <vector48>:
80106017:	6a 00                	push   $0x0
80106019:	6a 30                	push   $0x30
8010601b:	e9 7a f9 ff ff       	jmp    8010599a <alltraps>

80106020 <vector49>:
80106020:	6a 00                	push   $0x0
80106022:	6a 31                	push   $0x31
80106024:	e9 71 f9 ff ff       	jmp    8010599a <alltraps>

80106029 <vector50>:
80106029:	6a 00                	push   $0x0
8010602b:	6a 32                	push   $0x32
8010602d:	e9 68 f9 ff ff       	jmp    8010599a <alltraps>

80106032 <vector51>:
80106032:	6a 00                	push   $0x0
80106034:	6a 33                	push   $0x33
80106036:	e9 5f f9 ff ff       	jmp    8010599a <alltraps>

8010603b <vector52>:
8010603b:	6a 00                	push   $0x0
8010603d:	6a 34                	push   $0x34
8010603f:	e9 56 f9 ff ff       	jmp    8010599a <alltraps>

80106044 <vector53>:
80106044:	6a 00                	push   $0x0
80106046:	6a 35                	push   $0x35
80106048:	e9 4d f9 ff ff       	jmp    8010599a <alltraps>

8010604d <vector54>:
8010604d:	6a 00                	push   $0x0
8010604f:	6a 36                	push   $0x36
80106051:	e9 44 f9 ff ff       	jmp    8010599a <alltraps>

80106056 <vector55>:
80106056:	6a 00                	push   $0x0
80106058:	6a 37                	push   $0x37
8010605a:	e9 3b f9 ff ff       	jmp    8010599a <alltraps>

8010605f <vector56>:
8010605f:	6a 00                	push   $0x0
80106061:	6a 38                	push   $0x38
80106063:	e9 32 f9 ff ff       	jmp    8010599a <alltraps>

80106068 <vector57>:
80106068:	6a 00                	push   $0x0
8010606a:	6a 39                	push   $0x39
8010606c:	e9 29 f9 ff ff       	jmp    8010599a <alltraps>

80106071 <vector58>:
80106071:	6a 00                	push   $0x0
80106073:	6a 3a                	push   $0x3a
80106075:	e9 20 f9 ff ff       	jmp    8010599a <alltraps>

8010607a <vector59>:
8010607a:	6a 00                	push   $0x0
8010607c:	6a 3b                	push   $0x3b
8010607e:	e9 17 f9 ff ff       	jmp    8010599a <alltraps>

80106083 <vector60>:
80106083:	6a 00                	push   $0x0
80106085:	6a 3c                	push   $0x3c
80106087:	e9 0e f9 ff ff       	jmp    8010599a <alltraps>

8010608c <vector61>:
8010608c:	6a 00                	push   $0x0
8010608e:	6a 3d                	push   $0x3d
80106090:	e9 05 f9 ff ff       	jmp    8010599a <alltraps>

80106095 <vector62>:
80106095:	6a 00                	push   $0x0
80106097:	6a 3e                	push   $0x3e
80106099:	e9 fc f8 ff ff       	jmp    8010599a <alltraps>

8010609e <vector63>:
8010609e:	6a 00                	push   $0x0
801060a0:	6a 3f                	push   $0x3f
801060a2:	e9 f3 f8 ff ff       	jmp    8010599a <alltraps>

801060a7 <vector64>:
801060a7:	6a 00                	push   $0x0
801060a9:	6a 40                	push   $0x40
801060ab:	e9 ea f8 ff ff       	jmp    8010599a <alltraps>

801060b0 <vector65>:
801060b0:	6a 00                	push   $0x0
801060b2:	6a 41                	push   $0x41
801060b4:	e9 e1 f8 ff ff       	jmp    8010599a <alltraps>

801060b9 <vector66>:
801060b9:	6a 00                	push   $0x0
801060bb:	6a 42                	push   $0x42
801060bd:	e9 d8 f8 ff ff       	jmp    8010599a <alltraps>

801060c2 <vector67>:
801060c2:	6a 00                	push   $0x0
801060c4:	6a 43                	push   $0x43
801060c6:	e9 cf f8 ff ff       	jmp    8010599a <alltraps>

801060cb <vector68>:
801060cb:	6a 00                	push   $0x0
801060cd:	6a 44                	push   $0x44
801060cf:	e9 c6 f8 ff ff       	jmp    8010599a <alltraps>

801060d4 <vector69>:
801060d4:	6a 00                	push   $0x0
801060d6:	6a 45                	push   $0x45
801060d8:	e9 bd f8 ff ff       	jmp    8010599a <alltraps>

801060dd <vector70>:
801060dd:	6a 00                	push   $0x0
801060df:	6a 46                	push   $0x46
801060e1:	e9 b4 f8 ff ff       	jmp    8010599a <alltraps>

801060e6 <vector71>:
801060e6:	6a 00                	push   $0x0
801060e8:	6a 47                	push   $0x47
801060ea:	e9 ab f8 ff ff       	jmp    8010599a <alltraps>

801060ef <vector72>:
801060ef:	6a 00                	push   $0x0
801060f1:	6a 48                	push   $0x48
801060f3:	e9 a2 f8 ff ff       	jmp    8010599a <alltraps>

801060f8 <vector73>:
801060f8:	6a 00                	push   $0x0
801060fa:	6a 49                	push   $0x49
801060fc:	e9 99 f8 ff ff       	jmp    8010599a <alltraps>

80106101 <vector74>:
80106101:	6a 00                	push   $0x0
80106103:	6a 4a                	push   $0x4a
80106105:	e9 90 f8 ff ff       	jmp    8010599a <alltraps>

8010610a <vector75>:
8010610a:	6a 00                	push   $0x0
8010610c:	6a 4b                	push   $0x4b
8010610e:	e9 87 f8 ff ff       	jmp    8010599a <alltraps>

80106113 <vector76>:
80106113:	6a 00                	push   $0x0
80106115:	6a 4c                	push   $0x4c
80106117:	e9 7e f8 ff ff       	jmp    8010599a <alltraps>

8010611c <vector77>:
8010611c:	6a 00                	push   $0x0
8010611e:	6a 4d                	push   $0x4d
80106120:	e9 75 f8 ff ff       	jmp    8010599a <alltraps>

80106125 <vector78>:
80106125:	6a 00                	push   $0x0
80106127:	6a 4e                	push   $0x4e
80106129:	e9 6c f8 ff ff       	jmp    8010599a <alltraps>

8010612e <vector79>:
8010612e:	6a 00                	push   $0x0
80106130:	6a 4f                	push   $0x4f
80106132:	e9 63 f8 ff ff       	jmp    8010599a <alltraps>

80106137 <vector80>:
80106137:	6a 00                	push   $0x0
80106139:	6a 50                	push   $0x50
8010613b:	e9 5a f8 ff ff       	jmp    8010599a <alltraps>

80106140 <vector81>:
80106140:	6a 00                	push   $0x0
80106142:	6a 51                	push   $0x51
80106144:	e9 51 f8 ff ff       	jmp    8010599a <alltraps>

80106149 <vector82>:
80106149:	6a 00                	push   $0x0
8010614b:	6a 52                	push   $0x52
8010614d:	e9 48 f8 ff ff       	jmp    8010599a <alltraps>

80106152 <vector83>:
80106152:	6a 00                	push   $0x0
80106154:	6a 53                	push   $0x53
80106156:	e9 3f f8 ff ff       	jmp    8010599a <alltraps>

8010615b <vector84>:
8010615b:	6a 00                	push   $0x0
8010615d:	6a 54                	push   $0x54
8010615f:	e9 36 f8 ff ff       	jmp    8010599a <alltraps>

80106164 <vector85>:
80106164:	6a 00                	push   $0x0
80106166:	6a 55                	push   $0x55
80106168:	e9 2d f8 ff ff       	jmp    8010599a <alltraps>

8010616d <vector86>:
8010616d:	6a 00                	push   $0x0
8010616f:	6a 56                	push   $0x56
80106171:	e9 24 f8 ff ff       	jmp    8010599a <alltraps>

80106176 <vector87>:
80106176:	6a 00                	push   $0x0
80106178:	6a 57                	push   $0x57
8010617a:	e9 1b f8 ff ff       	jmp    8010599a <alltraps>

8010617f <vector88>:
8010617f:	6a 00                	push   $0x0
80106181:	6a 58                	push   $0x58
80106183:	e9 12 f8 ff ff       	jmp    8010599a <alltraps>

80106188 <vector89>:
80106188:	6a 00                	push   $0x0
8010618a:	6a 59                	push   $0x59
8010618c:	e9 09 f8 ff ff       	jmp    8010599a <alltraps>

80106191 <vector90>:
80106191:	6a 00                	push   $0x0
80106193:	6a 5a                	push   $0x5a
80106195:	e9 00 f8 ff ff       	jmp    8010599a <alltraps>

8010619a <vector91>:
8010619a:	6a 00                	push   $0x0
8010619c:	6a 5b                	push   $0x5b
8010619e:	e9 f7 f7 ff ff       	jmp    8010599a <alltraps>

801061a3 <vector92>:
801061a3:	6a 00                	push   $0x0
801061a5:	6a 5c                	push   $0x5c
801061a7:	e9 ee f7 ff ff       	jmp    8010599a <alltraps>

801061ac <vector93>:
801061ac:	6a 00                	push   $0x0
801061ae:	6a 5d                	push   $0x5d
801061b0:	e9 e5 f7 ff ff       	jmp    8010599a <alltraps>

801061b5 <vector94>:
801061b5:	6a 00                	push   $0x0
801061b7:	6a 5e                	push   $0x5e
801061b9:	e9 dc f7 ff ff       	jmp    8010599a <alltraps>

801061be <vector95>:
801061be:	6a 00                	push   $0x0
801061c0:	6a 5f                	push   $0x5f
801061c2:	e9 d3 f7 ff ff       	jmp    8010599a <alltraps>

801061c7 <vector96>:
801061c7:	6a 00                	push   $0x0
801061c9:	6a 60                	push   $0x60
801061cb:	e9 ca f7 ff ff       	jmp    8010599a <alltraps>

801061d0 <vector97>:
801061d0:	6a 00                	push   $0x0
801061d2:	6a 61                	push   $0x61
801061d4:	e9 c1 f7 ff ff       	jmp    8010599a <alltraps>

801061d9 <vector98>:
801061d9:	6a 00                	push   $0x0
801061db:	6a 62                	push   $0x62
801061dd:	e9 b8 f7 ff ff       	jmp    8010599a <alltraps>

801061e2 <vector99>:
801061e2:	6a 00                	push   $0x0
801061e4:	6a 63                	push   $0x63
801061e6:	e9 af f7 ff ff       	jmp    8010599a <alltraps>

801061eb <vector100>:
801061eb:	6a 00                	push   $0x0
801061ed:	6a 64                	push   $0x64
801061ef:	e9 a6 f7 ff ff       	jmp    8010599a <alltraps>

801061f4 <vector101>:
801061f4:	6a 00                	push   $0x0
801061f6:	6a 65                	push   $0x65
801061f8:	e9 9d f7 ff ff       	jmp    8010599a <alltraps>

801061fd <vector102>:
801061fd:	6a 00                	push   $0x0
801061ff:	6a 66                	push   $0x66
80106201:	e9 94 f7 ff ff       	jmp    8010599a <alltraps>

80106206 <vector103>:
80106206:	6a 00                	push   $0x0
80106208:	6a 67                	push   $0x67
8010620a:	e9 8b f7 ff ff       	jmp    8010599a <alltraps>

8010620f <vector104>:
8010620f:	6a 00                	push   $0x0
80106211:	6a 68                	push   $0x68
80106213:	e9 82 f7 ff ff       	jmp    8010599a <alltraps>

80106218 <vector105>:
80106218:	6a 00                	push   $0x0
8010621a:	6a 69                	push   $0x69
8010621c:	e9 79 f7 ff ff       	jmp    8010599a <alltraps>

80106221 <vector106>:
80106221:	6a 00                	push   $0x0
80106223:	6a 6a                	push   $0x6a
80106225:	e9 70 f7 ff ff       	jmp    8010599a <alltraps>

8010622a <vector107>:
8010622a:	6a 00                	push   $0x0
8010622c:	6a 6b                	push   $0x6b
8010622e:	e9 67 f7 ff ff       	jmp    8010599a <alltraps>

80106233 <vector108>:
80106233:	6a 00                	push   $0x0
80106235:	6a 6c                	push   $0x6c
80106237:	e9 5e f7 ff ff       	jmp    8010599a <alltraps>

8010623c <vector109>:
8010623c:	6a 00                	push   $0x0
8010623e:	6a 6d                	push   $0x6d
80106240:	e9 55 f7 ff ff       	jmp    8010599a <alltraps>

80106245 <vector110>:
80106245:	6a 00                	push   $0x0
80106247:	6a 6e                	push   $0x6e
80106249:	e9 4c f7 ff ff       	jmp    8010599a <alltraps>

8010624e <vector111>:
8010624e:	6a 00                	push   $0x0
80106250:	6a 6f                	push   $0x6f
80106252:	e9 43 f7 ff ff       	jmp    8010599a <alltraps>

80106257 <vector112>:
80106257:	6a 00                	push   $0x0
80106259:	6a 70                	push   $0x70
8010625b:	e9 3a f7 ff ff       	jmp    8010599a <alltraps>

80106260 <vector113>:
80106260:	6a 00                	push   $0x0
80106262:	6a 71                	push   $0x71
80106264:	e9 31 f7 ff ff       	jmp    8010599a <alltraps>

80106269 <vector114>:
80106269:	6a 00                	push   $0x0
8010626b:	6a 72                	push   $0x72
8010626d:	e9 28 f7 ff ff       	jmp    8010599a <alltraps>

80106272 <vector115>:
80106272:	6a 00                	push   $0x0
80106274:	6a 73                	push   $0x73
80106276:	e9 1f f7 ff ff       	jmp    8010599a <alltraps>

8010627b <vector116>:
8010627b:	6a 00                	push   $0x0
8010627d:	6a 74                	push   $0x74
8010627f:	e9 16 f7 ff ff       	jmp    8010599a <alltraps>

80106284 <vector117>:
80106284:	6a 00                	push   $0x0
80106286:	6a 75                	push   $0x75
80106288:	e9 0d f7 ff ff       	jmp    8010599a <alltraps>

8010628d <vector118>:
8010628d:	6a 00                	push   $0x0
8010628f:	6a 76                	push   $0x76
80106291:	e9 04 f7 ff ff       	jmp    8010599a <alltraps>

80106296 <vector119>:
80106296:	6a 00                	push   $0x0
80106298:	6a 77                	push   $0x77
8010629a:	e9 fb f6 ff ff       	jmp    8010599a <alltraps>

8010629f <vector120>:
8010629f:	6a 00                	push   $0x0
801062a1:	6a 78                	push   $0x78
801062a3:	e9 f2 f6 ff ff       	jmp    8010599a <alltraps>

801062a8 <vector121>:
801062a8:	6a 00                	push   $0x0
801062aa:	6a 79                	push   $0x79
801062ac:	e9 e9 f6 ff ff       	jmp    8010599a <alltraps>

801062b1 <vector122>:
801062b1:	6a 00                	push   $0x0
801062b3:	6a 7a                	push   $0x7a
801062b5:	e9 e0 f6 ff ff       	jmp    8010599a <alltraps>

801062ba <vector123>:
801062ba:	6a 00                	push   $0x0
801062bc:	6a 7b                	push   $0x7b
801062be:	e9 d7 f6 ff ff       	jmp    8010599a <alltraps>

801062c3 <vector124>:
801062c3:	6a 00                	push   $0x0
801062c5:	6a 7c                	push   $0x7c
801062c7:	e9 ce f6 ff ff       	jmp    8010599a <alltraps>

801062cc <vector125>:
801062cc:	6a 00                	push   $0x0
801062ce:	6a 7d                	push   $0x7d
801062d0:	e9 c5 f6 ff ff       	jmp    8010599a <alltraps>

801062d5 <vector126>:
801062d5:	6a 00                	push   $0x0
801062d7:	6a 7e                	push   $0x7e
801062d9:	e9 bc f6 ff ff       	jmp    8010599a <alltraps>

801062de <vector127>:
801062de:	6a 00                	push   $0x0
801062e0:	6a 7f                	push   $0x7f
801062e2:	e9 b3 f6 ff ff       	jmp    8010599a <alltraps>

801062e7 <vector128>:
801062e7:	6a 00                	push   $0x0
801062e9:	68 80 00 00 00       	push   $0x80
801062ee:	e9 a7 f6 ff ff       	jmp    8010599a <alltraps>

801062f3 <vector129>:
801062f3:	6a 00                	push   $0x0
801062f5:	68 81 00 00 00       	push   $0x81
801062fa:	e9 9b f6 ff ff       	jmp    8010599a <alltraps>

801062ff <vector130>:
801062ff:	6a 00                	push   $0x0
80106301:	68 82 00 00 00       	push   $0x82
80106306:	e9 8f f6 ff ff       	jmp    8010599a <alltraps>

8010630b <vector131>:
8010630b:	6a 00                	push   $0x0
8010630d:	68 83 00 00 00       	push   $0x83
80106312:	e9 83 f6 ff ff       	jmp    8010599a <alltraps>

80106317 <vector132>:
80106317:	6a 00                	push   $0x0
80106319:	68 84 00 00 00       	push   $0x84
8010631e:	e9 77 f6 ff ff       	jmp    8010599a <alltraps>

80106323 <vector133>:
80106323:	6a 00                	push   $0x0
80106325:	68 85 00 00 00       	push   $0x85
8010632a:	e9 6b f6 ff ff       	jmp    8010599a <alltraps>

8010632f <vector134>:
8010632f:	6a 00                	push   $0x0
80106331:	68 86 00 00 00       	push   $0x86
80106336:	e9 5f f6 ff ff       	jmp    8010599a <alltraps>

8010633b <vector135>:
8010633b:	6a 00                	push   $0x0
8010633d:	68 87 00 00 00       	push   $0x87
80106342:	e9 53 f6 ff ff       	jmp    8010599a <alltraps>

80106347 <vector136>:
80106347:	6a 00                	push   $0x0
80106349:	68 88 00 00 00       	push   $0x88
8010634e:	e9 47 f6 ff ff       	jmp    8010599a <alltraps>

80106353 <vector137>:
80106353:	6a 00                	push   $0x0
80106355:	68 89 00 00 00       	push   $0x89
8010635a:	e9 3b f6 ff ff       	jmp    8010599a <alltraps>

8010635f <vector138>:
8010635f:	6a 00                	push   $0x0
80106361:	68 8a 00 00 00       	push   $0x8a
80106366:	e9 2f f6 ff ff       	jmp    8010599a <alltraps>

8010636b <vector139>:
8010636b:	6a 00                	push   $0x0
8010636d:	68 8b 00 00 00       	push   $0x8b
80106372:	e9 23 f6 ff ff       	jmp    8010599a <alltraps>

80106377 <vector140>:
80106377:	6a 00                	push   $0x0
80106379:	68 8c 00 00 00       	push   $0x8c
8010637e:	e9 17 f6 ff ff       	jmp    8010599a <alltraps>

80106383 <vector141>:
80106383:	6a 00                	push   $0x0
80106385:	68 8d 00 00 00       	push   $0x8d
8010638a:	e9 0b f6 ff ff       	jmp    8010599a <alltraps>

8010638f <vector142>:
8010638f:	6a 00                	push   $0x0
80106391:	68 8e 00 00 00       	push   $0x8e
80106396:	e9 ff f5 ff ff       	jmp    8010599a <alltraps>

8010639b <vector143>:
8010639b:	6a 00                	push   $0x0
8010639d:	68 8f 00 00 00       	push   $0x8f
801063a2:	e9 f3 f5 ff ff       	jmp    8010599a <alltraps>

801063a7 <vector144>:
801063a7:	6a 00                	push   $0x0
801063a9:	68 90 00 00 00       	push   $0x90
801063ae:	e9 e7 f5 ff ff       	jmp    8010599a <alltraps>

801063b3 <vector145>:
801063b3:	6a 00                	push   $0x0
801063b5:	68 91 00 00 00       	push   $0x91
801063ba:	e9 db f5 ff ff       	jmp    8010599a <alltraps>

801063bf <vector146>:
801063bf:	6a 00                	push   $0x0
801063c1:	68 92 00 00 00       	push   $0x92
801063c6:	e9 cf f5 ff ff       	jmp    8010599a <alltraps>

801063cb <vector147>:
801063cb:	6a 00                	push   $0x0
801063cd:	68 93 00 00 00       	push   $0x93
801063d2:	e9 c3 f5 ff ff       	jmp    8010599a <alltraps>

801063d7 <vector148>:
801063d7:	6a 00                	push   $0x0
801063d9:	68 94 00 00 00       	push   $0x94
801063de:	e9 b7 f5 ff ff       	jmp    8010599a <alltraps>

801063e3 <vector149>:
801063e3:	6a 00                	push   $0x0
801063e5:	68 95 00 00 00       	push   $0x95
801063ea:	e9 ab f5 ff ff       	jmp    8010599a <alltraps>

801063ef <vector150>:
801063ef:	6a 00                	push   $0x0
801063f1:	68 96 00 00 00       	push   $0x96
801063f6:	e9 9f f5 ff ff       	jmp    8010599a <alltraps>

801063fb <vector151>:
801063fb:	6a 00                	push   $0x0
801063fd:	68 97 00 00 00       	push   $0x97
80106402:	e9 93 f5 ff ff       	jmp    8010599a <alltraps>

80106407 <vector152>:
80106407:	6a 00                	push   $0x0
80106409:	68 98 00 00 00       	push   $0x98
8010640e:	e9 87 f5 ff ff       	jmp    8010599a <alltraps>

80106413 <vector153>:
80106413:	6a 00                	push   $0x0
80106415:	68 99 00 00 00       	push   $0x99
8010641a:	e9 7b f5 ff ff       	jmp    8010599a <alltraps>

8010641f <vector154>:
8010641f:	6a 00                	push   $0x0
80106421:	68 9a 00 00 00       	push   $0x9a
80106426:	e9 6f f5 ff ff       	jmp    8010599a <alltraps>

8010642b <vector155>:
8010642b:	6a 00                	push   $0x0
8010642d:	68 9b 00 00 00       	push   $0x9b
80106432:	e9 63 f5 ff ff       	jmp    8010599a <alltraps>

80106437 <vector156>:
80106437:	6a 00                	push   $0x0
80106439:	68 9c 00 00 00       	push   $0x9c
8010643e:	e9 57 f5 ff ff       	jmp    8010599a <alltraps>

80106443 <vector157>:
80106443:	6a 00                	push   $0x0
80106445:	68 9d 00 00 00       	push   $0x9d
8010644a:	e9 4b f5 ff ff       	jmp    8010599a <alltraps>

8010644f <vector158>:
8010644f:	6a 00                	push   $0x0
80106451:	68 9e 00 00 00       	push   $0x9e
80106456:	e9 3f f5 ff ff       	jmp    8010599a <alltraps>

8010645b <vector159>:
8010645b:	6a 00                	push   $0x0
8010645d:	68 9f 00 00 00       	push   $0x9f
80106462:	e9 33 f5 ff ff       	jmp    8010599a <alltraps>

80106467 <vector160>:
80106467:	6a 00                	push   $0x0
80106469:	68 a0 00 00 00       	push   $0xa0
8010646e:	e9 27 f5 ff ff       	jmp    8010599a <alltraps>

80106473 <vector161>:
80106473:	6a 00                	push   $0x0
80106475:	68 a1 00 00 00       	push   $0xa1
8010647a:	e9 1b f5 ff ff       	jmp    8010599a <alltraps>

8010647f <vector162>:
8010647f:	6a 00                	push   $0x0
80106481:	68 a2 00 00 00       	push   $0xa2
80106486:	e9 0f f5 ff ff       	jmp    8010599a <alltraps>

8010648b <vector163>:
8010648b:	6a 00                	push   $0x0
8010648d:	68 a3 00 00 00       	push   $0xa3
80106492:	e9 03 f5 ff ff       	jmp    8010599a <alltraps>

80106497 <vector164>:
80106497:	6a 00                	push   $0x0
80106499:	68 a4 00 00 00       	push   $0xa4
8010649e:	e9 f7 f4 ff ff       	jmp    8010599a <alltraps>

801064a3 <vector165>:
801064a3:	6a 00                	push   $0x0
801064a5:	68 a5 00 00 00       	push   $0xa5
801064aa:	e9 eb f4 ff ff       	jmp    8010599a <alltraps>

801064af <vector166>:
801064af:	6a 00                	push   $0x0
801064b1:	68 a6 00 00 00       	push   $0xa6
801064b6:	e9 df f4 ff ff       	jmp    8010599a <alltraps>

801064bb <vector167>:
801064bb:	6a 00                	push   $0x0
801064bd:	68 a7 00 00 00       	push   $0xa7
801064c2:	e9 d3 f4 ff ff       	jmp    8010599a <alltraps>

801064c7 <vector168>:
801064c7:	6a 00                	push   $0x0
801064c9:	68 a8 00 00 00       	push   $0xa8
801064ce:	e9 c7 f4 ff ff       	jmp    8010599a <alltraps>

801064d3 <vector169>:
801064d3:	6a 00                	push   $0x0
801064d5:	68 a9 00 00 00       	push   $0xa9
801064da:	e9 bb f4 ff ff       	jmp    8010599a <alltraps>

801064df <vector170>:
801064df:	6a 00                	push   $0x0
801064e1:	68 aa 00 00 00       	push   $0xaa
801064e6:	e9 af f4 ff ff       	jmp    8010599a <alltraps>

801064eb <vector171>:
801064eb:	6a 00                	push   $0x0
801064ed:	68 ab 00 00 00       	push   $0xab
801064f2:	e9 a3 f4 ff ff       	jmp    8010599a <alltraps>

801064f7 <vector172>:
801064f7:	6a 00                	push   $0x0
801064f9:	68 ac 00 00 00       	push   $0xac
801064fe:	e9 97 f4 ff ff       	jmp    8010599a <alltraps>

80106503 <vector173>:
80106503:	6a 00                	push   $0x0
80106505:	68 ad 00 00 00       	push   $0xad
8010650a:	e9 8b f4 ff ff       	jmp    8010599a <alltraps>

8010650f <vector174>:
8010650f:	6a 00                	push   $0x0
80106511:	68 ae 00 00 00       	push   $0xae
80106516:	e9 7f f4 ff ff       	jmp    8010599a <alltraps>

8010651b <vector175>:
8010651b:	6a 00                	push   $0x0
8010651d:	68 af 00 00 00       	push   $0xaf
80106522:	e9 73 f4 ff ff       	jmp    8010599a <alltraps>

80106527 <vector176>:
80106527:	6a 00                	push   $0x0
80106529:	68 b0 00 00 00       	push   $0xb0
8010652e:	e9 67 f4 ff ff       	jmp    8010599a <alltraps>

80106533 <vector177>:
80106533:	6a 00                	push   $0x0
80106535:	68 b1 00 00 00       	push   $0xb1
8010653a:	e9 5b f4 ff ff       	jmp    8010599a <alltraps>

8010653f <vector178>:
8010653f:	6a 00                	push   $0x0
80106541:	68 b2 00 00 00       	push   $0xb2
80106546:	e9 4f f4 ff ff       	jmp    8010599a <alltraps>

8010654b <vector179>:
8010654b:	6a 00                	push   $0x0
8010654d:	68 b3 00 00 00       	push   $0xb3
80106552:	e9 43 f4 ff ff       	jmp    8010599a <alltraps>

80106557 <vector180>:
80106557:	6a 00                	push   $0x0
80106559:	68 b4 00 00 00       	push   $0xb4
8010655e:	e9 37 f4 ff ff       	jmp    8010599a <alltraps>

80106563 <vector181>:
80106563:	6a 00                	push   $0x0
80106565:	68 b5 00 00 00       	push   $0xb5
8010656a:	e9 2b f4 ff ff       	jmp    8010599a <alltraps>

8010656f <vector182>:
8010656f:	6a 00                	push   $0x0
80106571:	68 b6 00 00 00       	push   $0xb6
80106576:	e9 1f f4 ff ff       	jmp    8010599a <alltraps>

8010657b <vector183>:
8010657b:	6a 00                	push   $0x0
8010657d:	68 b7 00 00 00       	push   $0xb7
80106582:	e9 13 f4 ff ff       	jmp    8010599a <alltraps>

80106587 <vector184>:
80106587:	6a 00                	push   $0x0
80106589:	68 b8 00 00 00       	push   $0xb8
8010658e:	e9 07 f4 ff ff       	jmp    8010599a <alltraps>

80106593 <vector185>:
80106593:	6a 00                	push   $0x0
80106595:	68 b9 00 00 00       	push   $0xb9
8010659a:	e9 fb f3 ff ff       	jmp    8010599a <alltraps>

8010659f <vector186>:
8010659f:	6a 00                	push   $0x0
801065a1:	68 ba 00 00 00       	push   $0xba
801065a6:	e9 ef f3 ff ff       	jmp    8010599a <alltraps>

801065ab <vector187>:
801065ab:	6a 00                	push   $0x0
801065ad:	68 bb 00 00 00       	push   $0xbb
801065b2:	e9 e3 f3 ff ff       	jmp    8010599a <alltraps>

801065b7 <vector188>:
801065b7:	6a 00                	push   $0x0
801065b9:	68 bc 00 00 00       	push   $0xbc
801065be:	e9 d7 f3 ff ff       	jmp    8010599a <alltraps>

801065c3 <vector189>:
801065c3:	6a 00                	push   $0x0
801065c5:	68 bd 00 00 00       	push   $0xbd
801065ca:	e9 cb f3 ff ff       	jmp    8010599a <alltraps>

801065cf <vector190>:
801065cf:	6a 00                	push   $0x0
801065d1:	68 be 00 00 00       	push   $0xbe
801065d6:	e9 bf f3 ff ff       	jmp    8010599a <alltraps>

801065db <vector191>:
801065db:	6a 00                	push   $0x0
801065dd:	68 bf 00 00 00       	push   $0xbf
801065e2:	e9 b3 f3 ff ff       	jmp    8010599a <alltraps>

801065e7 <vector192>:
801065e7:	6a 00                	push   $0x0
801065e9:	68 c0 00 00 00       	push   $0xc0
801065ee:	e9 a7 f3 ff ff       	jmp    8010599a <alltraps>

801065f3 <vector193>:
801065f3:	6a 00                	push   $0x0
801065f5:	68 c1 00 00 00       	push   $0xc1
801065fa:	e9 9b f3 ff ff       	jmp    8010599a <alltraps>

801065ff <vector194>:
801065ff:	6a 00                	push   $0x0
80106601:	68 c2 00 00 00       	push   $0xc2
80106606:	e9 8f f3 ff ff       	jmp    8010599a <alltraps>

8010660b <vector195>:
8010660b:	6a 00                	push   $0x0
8010660d:	68 c3 00 00 00       	push   $0xc3
80106612:	e9 83 f3 ff ff       	jmp    8010599a <alltraps>

80106617 <vector196>:
80106617:	6a 00                	push   $0x0
80106619:	68 c4 00 00 00       	push   $0xc4
8010661e:	e9 77 f3 ff ff       	jmp    8010599a <alltraps>

80106623 <vector197>:
80106623:	6a 00                	push   $0x0
80106625:	68 c5 00 00 00       	push   $0xc5
8010662a:	e9 6b f3 ff ff       	jmp    8010599a <alltraps>

8010662f <vector198>:
8010662f:	6a 00                	push   $0x0
80106631:	68 c6 00 00 00       	push   $0xc6
80106636:	e9 5f f3 ff ff       	jmp    8010599a <alltraps>

8010663b <vector199>:
8010663b:	6a 00                	push   $0x0
8010663d:	68 c7 00 00 00       	push   $0xc7
80106642:	e9 53 f3 ff ff       	jmp    8010599a <alltraps>

80106647 <vector200>:
80106647:	6a 00                	push   $0x0
80106649:	68 c8 00 00 00       	push   $0xc8
8010664e:	e9 47 f3 ff ff       	jmp    8010599a <alltraps>

80106653 <vector201>:
80106653:	6a 00                	push   $0x0
80106655:	68 c9 00 00 00       	push   $0xc9
8010665a:	e9 3b f3 ff ff       	jmp    8010599a <alltraps>

8010665f <vector202>:
8010665f:	6a 00                	push   $0x0
80106661:	68 ca 00 00 00       	push   $0xca
80106666:	e9 2f f3 ff ff       	jmp    8010599a <alltraps>

8010666b <vector203>:
8010666b:	6a 00                	push   $0x0
8010666d:	68 cb 00 00 00       	push   $0xcb
80106672:	e9 23 f3 ff ff       	jmp    8010599a <alltraps>

80106677 <vector204>:
80106677:	6a 00                	push   $0x0
80106679:	68 cc 00 00 00       	push   $0xcc
8010667e:	e9 17 f3 ff ff       	jmp    8010599a <alltraps>

80106683 <vector205>:
80106683:	6a 00                	push   $0x0
80106685:	68 cd 00 00 00       	push   $0xcd
8010668a:	e9 0b f3 ff ff       	jmp    8010599a <alltraps>

8010668f <vector206>:
8010668f:	6a 00                	push   $0x0
80106691:	68 ce 00 00 00       	push   $0xce
80106696:	e9 ff f2 ff ff       	jmp    8010599a <alltraps>

8010669b <vector207>:
8010669b:	6a 00                	push   $0x0
8010669d:	68 cf 00 00 00       	push   $0xcf
801066a2:	e9 f3 f2 ff ff       	jmp    8010599a <alltraps>

801066a7 <vector208>:
801066a7:	6a 00                	push   $0x0
801066a9:	68 d0 00 00 00       	push   $0xd0
801066ae:	e9 e7 f2 ff ff       	jmp    8010599a <alltraps>

801066b3 <vector209>:
801066b3:	6a 00                	push   $0x0
801066b5:	68 d1 00 00 00       	push   $0xd1
801066ba:	e9 db f2 ff ff       	jmp    8010599a <alltraps>

801066bf <vector210>:
801066bf:	6a 00                	push   $0x0
801066c1:	68 d2 00 00 00       	push   $0xd2
801066c6:	e9 cf f2 ff ff       	jmp    8010599a <alltraps>

801066cb <vector211>:
801066cb:	6a 00                	push   $0x0
801066cd:	68 d3 00 00 00       	push   $0xd3
801066d2:	e9 c3 f2 ff ff       	jmp    8010599a <alltraps>

801066d7 <vector212>:
801066d7:	6a 00                	push   $0x0
801066d9:	68 d4 00 00 00       	push   $0xd4
801066de:	e9 b7 f2 ff ff       	jmp    8010599a <alltraps>

801066e3 <vector213>:
801066e3:	6a 00                	push   $0x0
801066e5:	68 d5 00 00 00       	push   $0xd5
801066ea:	e9 ab f2 ff ff       	jmp    8010599a <alltraps>

801066ef <vector214>:
801066ef:	6a 00                	push   $0x0
801066f1:	68 d6 00 00 00       	push   $0xd6
801066f6:	e9 9f f2 ff ff       	jmp    8010599a <alltraps>

801066fb <vector215>:
801066fb:	6a 00                	push   $0x0
801066fd:	68 d7 00 00 00       	push   $0xd7
80106702:	e9 93 f2 ff ff       	jmp    8010599a <alltraps>

80106707 <vector216>:
80106707:	6a 00                	push   $0x0
80106709:	68 d8 00 00 00       	push   $0xd8
8010670e:	e9 87 f2 ff ff       	jmp    8010599a <alltraps>

80106713 <vector217>:
80106713:	6a 00                	push   $0x0
80106715:	68 d9 00 00 00       	push   $0xd9
8010671a:	e9 7b f2 ff ff       	jmp    8010599a <alltraps>

8010671f <vector218>:
8010671f:	6a 00                	push   $0x0
80106721:	68 da 00 00 00       	push   $0xda
80106726:	e9 6f f2 ff ff       	jmp    8010599a <alltraps>

8010672b <vector219>:
8010672b:	6a 00                	push   $0x0
8010672d:	68 db 00 00 00       	push   $0xdb
80106732:	e9 63 f2 ff ff       	jmp    8010599a <alltraps>

80106737 <vector220>:
80106737:	6a 00                	push   $0x0
80106739:	68 dc 00 00 00       	push   $0xdc
8010673e:	e9 57 f2 ff ff       	jmp    8010599a <alltraps>

80106743 <vector221>:
80106743:	6a 00                	push   $0x0
80106745:	68 dd 00 00 00       	push   $0xdd
8010674a:	e9 4b f2 ff ff       	jmp    8010599a <alltraps>

8010674f <vector222>:
8010674f:	6a 00                	push   $0x0
80106751:	68 de 00 00 00       	push   $0xde
80106756:	e9 3f f2 ff ff       	jmp    8010599a <alltraps>

8010675b <vector223>:
8010675b:	6a 00                	push   $0x0
8010675d:	68 df 00 00 00       	push   $0xdf
80106762:	e9 33 f2 ff ff       	jmp    8010599a <alltraps>

80106767 <vector224>:
80106767:	6a 00                	push   $0x0
80106769:	68 e0 00 00 00       	push   $0xe0
8010676e:	e9 27 f2 ff ff       	jmp    8010599a <alltraps>

80106773 <vector225>:
80106773:	6a 00                	push   $0x0
80106775:	68 e1 00 00 00       	push   $0xe1
8010677a:	e9 1b f2 ff ff       	jmp    8010599a <alltraps>

8010677f <vector226>:
8010677f:	6a 00                	push   $0x0
80106781:	68 e2 00 00 00       	push   $0xe2
80106786:	e9 0f f2 ff ff       	jmp    8010599a <alltraps>

8010678b <vector227>:
8010678b:	6a 00                	push   $0x0
8010678d:	68 e3 00 00 00       	push   $0xe3
80106792:	e9 03 f2 ff ff       	jmp    8010599a <alltraps>

80106797 <vector228>:
80106797:	6a 00                	push   $0x0
80106799:	68 e4 00 00 00       	push   $0xe4
8010679e:	e9 f7 f1 ff ff       	jmp    8010599a <alltraps>

801067a3 <vector229>:
801067a3:	6a 00                	push   $0x0
801067a5:	68 e5 00 00 00       	push   $0xe5
801067aa:	e9 eb f1 ff ff       	jmp    8010599a <alltraps>

801067af <vector230>:
801067af:	6a 00                	push   $0x0
801067b1:	68 e6 00 00 00       	push   $0xe6
801067b6:	e9 df f1 ff ff       	jmp    8010599a <alltraps>

801067bb <vector231>:
801067bb:	6a 00                	push   $0x0
801067bd:	68 e7 00 00 00       	push   $0xe7
801067c2:	e9 d3 f1 ff ff       	jmp    8010599a <alltraps>

801067c7 <vector232>:
801067c7:	6a 00                	push   $0x0
801067c9:	68 e8 00 00 00       	push   $0xe8
801067ce:	e9 c7 f1 ff ff       	jmp    8010599a <alltraps>

801067d3 <vector233>:
801067d3:	6a 00                	push   $0x0
801067d5:	68 e9 00 00 00       	push   $0xe9
801067da:	e9 bb f1 ff ff       	jmp    8010599a <alltraps>

801067df <vector234>:
801067df:	6a 00                	push   $0x0
801067e1:	68 ea 00 00 00       	push   $0xea
801067e6:	e9 af f1 ff ff       	jmp    8010599a <alltraps>

801067eb <vector235>:
801067eb:	6a 00                	push   $0x0
801067ed:	68 eb 00 00 00       	push   $0xeb
801067f2:	e9 a3 f1 ff ff       	jmp    8010599a <alltraps>

801067f7 <vector236>:
801067f7:	6a 00                	push   $0x0
801067f9:	68 ec 00 00 00       	push   $0xec
801067fe:	e9 97 f1 ff ff       	jmp    8010599a <alltraps>

80106803 <vector237>:
80106803:	6a 00                	push   $0x0
80106805:	68 ed 00 00 00       	push   $0xed
8010680a:	e9 8b f1 ff ff       	jmp    8010599a <alltraps>

8010680f <vector238>:
8010680f:	6a 00                	push   $0x0
80106811:	68 ee 00 00 00       	push   $0xee
80106816:	e9 7f f1 ff ff       	jmp    8010599a <alltraps>

8010681b <vector239>:
8010681b:	6a 00                	push   $0x0
8010681d:	68 ef 00 00 00       	push   $0xef
80106822:	e9 73 f1 ff ff       	jmp    8010599a <alltraps>

80106827 <vector240>:
80106827:	6a 00                	push   $0x0
80106829:	68 f0 00 00 00       	push   $0xf0
8010682e:	e9 67 f1 ff ff       	jmp    8010599a <alltraps>

80106833 <vector241>:
80106833:	6a 00                	push   $0x0
80106835:	68 f1 00 00 00       	push   $0xf1
8010683a:	e9 5b f1 ff ff       	jmp    8010599a <alltraps>

8010683f <vector242>:
8010683f:	6a 00                	push   $0x0
80106841:	68 f2 00 00 00       	push   $0xf2
80106846:	e9 4f f1 ff ff       	jmp    8010599a <alltraps>

8010684b <vector243>:
8010684b:	6a 00                	push   $0x0
8010684d:	68 f3 00 00 00       	push   $0xf3
80106852:	e9 43 f1 ff ff       	jmp    8010599a <alltraps>

80106857 <vector244>:
80106857:	6a 00                	push   $0x0
80106859:	68 f4 00 00 00       	push   $0xf4
8010685e:	e9 37 f1 ff ff       	jmp    8010599a <alltraps>

80106863 <vector245>:
80106863:	6a 00                	push   $0x0
80106865:	68 f5 00 00 00       	push   $0xf5
8010686a:	e9 2b f1 ff ff       	jmp    8010599a <alltraps>

8010686f <vector246>:
8010686f:	6a 00                	push   $0x0
80106871:	68 f6 00 00 00       	push   $0xf6
80106876:	e9 1f f1 ff ff       	jmp    8010599a <alltraps>

8010687b <vector247>:
8010687b:	6a 00                	push   $0x0
8010687d:	68 f7 00 00 00       	push   $0xf7
80106882:	e9 13 f1 ff ff       	jmp    8010599a <alltraps>

80106887 <vector248>:
80106887:	6a 00                	push   $0x0
80106889:	68 f8 00 00 00       	push   $0xf8
8010688e:	e9 07 f1 ff ff       	jmp    8010599a <alltraps>

80106893 <vector249>:
80106893:	6a 00                	push   $0x0
80106895:	68 f9 00 00 00       	push   $0xf9
8010689a:	e9 fb f0 ff ff       	jmp    8010599a <alltraps>

8010689f <vector250>:
8010689f:	6a 00                	push   $0x0
801068a1:	68 fa 00 00 00       	push   $0xfa
801068a6:	e9 ef f0 ff ff       	jmp    8010599a <alltraps>

801068ab <vector251>:
801068ab:	6a 00                	push   $0x0
801068ad:	68 fb 00 00 00       	push   $0xfb
801068b2:	e9 e3 f0 ff ff       	jmp    8010599a <alltraps>

801068b7 <vector252>:
801068b7:	6a 00                	push   $0x0
801068b9:	68 fc 00 00 00       	push   $0xfc
801068be:	e9 d7 f0 ff ff       	jmp    8010599a <alltraps>

801068c3 <vector253>:
801068c3:	6a 00                	push   $0x0
801068c5:	68 fd 00 00 00       	push   $0xfd
801068ca:	e9 cb f0 ff ff       	jmp    8010599a <alltraps>

801068cf <vector254>:
801068cf:	6a 00                	push   $0x0
801068d1:	68 fe 00 00 00       	push   $0xfe
801068d6:	e9 bf f0 ff ff       	jmp    8010599a <alltraps>

801068db <vector255>:
801068db:	6a 00                	push   $0x0
801068dd:	68 ff 00 00 00       	push   $0xff
801068e2:	e9 b3 f0 ff ff       	jmp    8010599a <alltraps>
801068e7:	66 90                	xchg   %ax,%ax
801068e9:	66 90                	xchg   %ax,%ax
801068eb:	66 90                	xchg   %ax,%ax
801068ed:	66 90                	xchg   %ax,%ax
801068ef:	90                   	nop

801068f0 <walkpgdir>:
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	57                   	push   %edi
801068f4:	56                   	push   %esi
801068f5:	53                   	push   %ebx
801068f6:	89 d3                	mov    %edx,%ebx
801068f8:	89 d7                	mov    %edx,%edi
801068fa:	c1 eb 16             	shr    $0x16,%ebx
801068fd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
80106900:	83 ec 0c             	sub    $0xc,%esp
80106903:	8b 06                	mov    (%esi),%eax
80106905:	a8 01                	test   $0x1,%al
80106907:	74 27                	je     80106930 <walkpgdir+0x40>
80106909:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010690e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80106914:	c1 ef 0a             	shr    $0xa,%edi
80106917:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010691a:	89 fa                	mov    %edi,%edx
8010691c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106922:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80106925:	5b                   	pop    %ebx
80106926:	5e                   	pop    %esi
80106927:	5f                   	pop    %edi
80106928:	5d                   	pop    %ebp
80106929:	c3                   	ret    
8010692a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106930:	85 c9                	test   %ecx,%ecx
80106932:	74 2c                	je     80106960 <walkpgdir+0x70>
80106934:	e8 f7 be ff ff       	call   80102830 <kalloc>
80106939:	85 c0                	test   %eax,%eax
8010693b:	89 c3                	mov    %eax,%ebx
8010693d:	74 21                	je     80106960 <walkpgdir+0x70>
8010693f:	83 ec 04             	sub    $0x4,%esp
80106942:	68 00 10 00 00       	push   $0x1000
80106947:	6a 00                	push   $0x0
80106949:	50                   	push   %eax
8010694a:	e8 71 de ff ff       	call   801047c0 <memset>
8010694f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106955:	83 c4 10             	add    $0x10,%esp
80106958:	83 c8 07             	or     $0x7,%eax
8010695b:	89 06                	mov    %eax,(%esi)
8010695d:	eb b5                	jmp    80106914 <walkpgdir+0x24>
8010695f:	90                   	nop
80106960:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106963:	31 c0                	xor    %eax,%eax
80106965:	5b                   	pop    %ebx
80106966:	5e                   	pop    %esi
80106967:	5f                   	pop    %edi
80106968:	5d                   	pop    %ebp
80106969:	c3                   	ret    
8010696a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106970 <mappages>:
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	57                   	push   %edi
80106974:	56                   	push   %esi
80106975:	53                   	push   %ebx
80106976:	89 d3                	mov    %edx,%ebx
80106978:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010697e:	83 ec 1c             	sub    $0x1c,%esp
80106981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106984:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106988:	8b 7d 08             	mov    0x8(%ebp),%edi
8010698b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106990:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106993:	8b 45 0c             	mov    0xc(%ebp),%eax
80106996:	29 df                	sub    %ebx,%edi
80106998:	83 c8 01             	or     $0x1,%eax
8010699b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010699e:	eb 15                	jmp    801069b5 <mappages+0x45>
801069a0:	f6 00 01             	testb  $0x1,(%eax)
801069a3:	75 45                	jne    801069ea <mappages+0x7a>
801069a5:	0b 75 dc             	or     -0x24(%ebp),%esi
801069a8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
801069ab:	89 30                	mov    %esi,(%eax)
801069ad:	74 31                	je     801069e0 <mappages+0x70>
801069af:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069b8:	b9 01 00 00 00       	mov    $0x1,%ecx
801069bd:	89 da                	mov    %ebx,%edx
801069bf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801069c2:	e8 29 ff ff ff       	call   801068f0 <walkpgdir>
801069c7:	85 c0                	test   %eax,%eax
801069c9:	75 d5                	jne    801069a0 <mappages+0x30>
801069cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069d3:	5b                   	pop    %ebx
801069d4:	5e                   	pop    %esi
801069d5:	5f                   	pop    %edi
801069d6:	5d                   	pop    %ebp
801069d7:	c3                   	ret    
801069d8:	90                   	nop
801069d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069e3:	31 c0                	xor    %eax,%eax
801069e5:	5b                   	pop    %ebx
801069e6:	5e                   	pop    %esi
801069e7:	5f                   	pop    %edi
801069e8:	5d                   	pop    %ebp
801069e9:	c3                   	ret    
801069ea:	83 ec 0c             	sub    $0xc,%esp
801069ed:	68 e8 7a 10 80       	push   $0x80107ae8
801069f2:	e8 99 99 ff ff       	call   80100390 <panic>
801069f7:	89 f6                	mov    %esi,%esi
801069f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a00 <deallocuvm.part.0>:
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	57                   	push   %edi
80106a04:	56                   	push   %esi
80106a05:	53                   	push   %ebx
80106a06:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106a0c:	89 c7                	mov    %eax,%edi
80106a0e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106a14:	83 ec 1c             	sub    $0x1c,%esp
80106a17:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106a1a:	39 d3                	cmp    %edx,%ebx
80106a1c:	73 66                	jae    80106a84 <deallocuvm.part.0+0x84>
80106a1e:	89 d6                	mov    %edx,%esi
80106a20:	eb 3d                	jmp    80106a5f <deallocuvm.part.0+0x5f>
80106a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a28:	8b 10                	mov    (%eax),%edx
80106a2a:	f6 c2 01             	test   $0x1,%dl
80106a2d:	74 26                	je     80106a55 <deallocuvm.part.0+0x55>
80106a2f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a35:	74 58                	je     80106a8f <deallocuvm.part.0+0x8f>
80106a37:	83 ec 0c             	sub    $0xc,%esp
80106a3a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a43:	52                   	push   %edx
80106a44:	e8 37 bc ff ff       	call   80102680 <kfree>
80106a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a4c:	83 c4 10             	add    $0x10,%esp
80106a4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106a55:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a5b:	39 f3                	cmp    %esi,%ebx
80106a5d:	73 25                	jae    80106a84 <deallocuvm.part.0+0x84>
80106a5f:	31 c9                	xor    %ecx,%ecx
80106a61:	89 da                	mov    %ebx,%edx
80106a63:	89 f8                	mov    %edi,%eax
80106a65:	e8 86 fe ff ff       	call   801068f0 <walkpgdir>
80106a6a:	85 c0                	test   %eax,%eax
80106a6c:	75 ba                	jne    80106a28 <deallocuvm.part.0+0x28>
80106a6e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106a74:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
80106a7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a80:	39 f3                	cmp    %esi,%ebx
80106a82:	72 db                	jb     80106a5f <deallocuvm.part.0+0x5f>
80106a84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a8a:	5b                   	pop    %ebx
80106a8b:	5e                   	pop    %esi
80106a8c:	5f                   	pop    %edi
80106a8d:	5d                   	pop    %ebp
80106a8e:	c3                   	ret    
80106a8f:	83 ec 0c             	sub    $0xc,%esp
80106a92:	68 86 74 10 80       	push   $0x80107486
80106a97:	e8 f4 98 ff ff       	call   80100390 <panic>
80106a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106aa0 <seginit>:
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	83 ec 18             	sub    $0x18,%esp
80106aa6:	e8 85 d0 ff ff       	call   80103b30 <cpuid>
80106aab:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ab1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ab6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106aba:	c7 80 38 28 11 80 ff 	movl   $0xffff,-0x7feed7c8(%eax)
80106ac1:	ff 00 00 
80106ac4:	c7 80 3c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7c4(%eax)
80106acb:	9a cf 00 
80106ace:	c7 80 40 28 11 80 ff 	movl   $0xffff,-0x7feed7c0(%eax)
80106ad5:	ff 00 00 
80106ad8:	c7 80 44 28 11 80 00 	movl   $0xcf9200,-0x7feed7bc(%eax)
80106adf:	92 cf 00 
80106ae2:	c7 80 48 28 11 80 ff 	movl   $0xffff,-0x7feed7b8(%eax)
80106ae9:	ff 00 00 
80106aec:	c7 80 4c 28 11 80 00 	movl   $0xcffa00,-0x7feed7b4(%eax)
80106af3:	fa cf 00 
80106af6:	c7 80 50 28 11 80 ff 	movl   $0xffff,-0x7feed7b0(%eax)
80106afd:	ff 00 00 
80106b00:	c7 80 54 28 11 80 00 	movl   $0xcff200,-0x7feed7ac(%eax)
80106b07:	f2 cf 00 
80106b0a:	05 30 28 11 80       	add    $0x80112830,%eax
80106b0f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80106b13:	c1 e8 10             	shr    $0x10,%eax
80106b16:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80106b1a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106b1d:	0f 01 10             	lgdtl  (%eax)
80106b20:	c9                   	leave  
80106b21:	c3                   	ret    
80106b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b30 <switchkvm>:
80106b30:	a1 e4 54 11 80       	mov    0x801154e4,%eax
80106b35:	55                   	push   %ebp
80106b36:	89 e5                	mov    %esp,%ebp
80106b38:	05 00 00 00 80       	add    $0x80000000,%eax
80106b3d:	0f 22 d8             	mov    %eax,%cr3
80106b40:	5d                   	pop    %ebp
80106b41:	c3                   	ret    
80106b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b50 <switchuvm>:
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
80106b56:	83 ec 1c             	sub    $0x1c,%esp
80106b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106b5c:	85 db                	test   %ebx,%ebx
80106b5e:	0f 84 cb 00 00 00    	je     80106c2f <switchuvm+0xdf>
80106b64:	8b 43 08             	mov    0x8(%ebx),%eax
80106b67:	85 c0                	test   %eax,%eax
80106b69:	0f 84 da 00 00 00    	je     80106c49 <switchuvm+0xf9>
80106b6f:	8b 43 04             	mov    0x4(%ebx),%eax
80106b72:	85 c0                	test   %eax,%eax
80106b74:	0f 84 c2 00 00 00    	je     80106c3c <switchuvm+0xec>
80106b7a:	e8 61 da ff ff       	call   801045e0 <pushcli>
80106b7f:	e8 2c cf ff ff       	call   80103ab0 <mycpu>
80106b84:	89 c6                	mov    %eax,%esi
80106b86:	e8 25 cf ff ff       	call   80103ab0 <mycpu>
80106b8b:	89 c7                	mov    %eax,%edi
80106b8d:	e8 1e cf ff ff       	call   80103ab0 <mycpu>
80106b92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b95:	83 c7 08             	add    $0x8,%edi
80106b98:	e8 13 cf ff ff       	call   80103ab0 <mycpu>
80106b9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ba0:	83 c0 08             	add    $0x8,%eax
80106ba3:	ba 67 00 00 00       	mov    $0x67,%edx
80106ba8:	c1 e8 18             	shr    $0x18,%eax
80106bab:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106bb2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106bb9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
80106bbf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80106bc4:	83 c1 08             	add    $0x8,%ecx
80106bc7:	c1 e9 10             	shr    $0x10,%ecx
80106bca:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106bd0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106bd5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
80106bdc:	be 10 00 00 00       	mov    $0x10,%esi
80106be1:	e8 ca ce ff ff       	call   80103ab0 <mycpu>
80106be6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
80106bed:	e8 be ce ff ff       	call   80103ab0 <mycpu>
80106bf2:	66 89 70 10          	mov    %si,0x10(%eax)
80106bf6:	8b 73 08             	mov    0x8(%ebx),%esi
80106bf9:	e8 b2 ce ff ff       	call   80103ab0 <mycpu>
80106bfe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106c04:	89 70 0c             	mov    %esi,0xc(%eax)
80106c07:	e8 a4 ce ff ff       	call   80103ab0 <mycpu>
80106c0c:	66 89 78 6e          	mov    %di,0x6e(%eax)
80106c10:	b8 28 00 00 00       	mov    $0x28,%eax
80106c15:	0f 00 d8             	ltr    %ax
80106c18:	8b 43 04             	mov    0x4(%ebx),%eax
80106c1b:	05 00 00 00 80       	add    $0x80000000,%eax
80106c20:	0f 22 d8             	mov    %eax,%cr3
80106c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c26:	5b                   	pop    %ebx
80106c27:	5e                   	pop    %esi
80106c28:	5f                   	pop    %edi
80106c29:	5d                   	pop    %ebp
80106c2a:	e9 f1 d9 ff ff       	jmp    80104620 <popcli>
80106c2f:	83 ec 0c             	sub    $0xc,%esp
80106c32:	68 ee 7a 10 80       	push   $0x80107aee
80106c37:	e8 54 97 ff ff       	call   80100390 <panic>
80106c3c:	83 ec 0c             	sub    $0xc,%esp
80106c3f:	68 19 7b 10 80       	push   $0x80107b19
80106c44:	e8 47 97 ff ff       	call   80100390 <panic>
80106c49:	83 ec 0c             	sub    $0xc,%esp
80106c4c:	68 04 7b 10 80       	push   $0x80107b04
80106c51:	e8 3a 97 ff ff       	call   80100390 <panic>
80106c56:	8d 76 00             	lea    0x0(%esi),%esi
80106c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c60 <inituvm>:
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	57                   	push   %edi
80106c64:	56                   	push   %esi
80106c65:	53                   	push   %ebx
80106c66:	83 ec 1c             	sub    $0x1c,%esp
80106c69:	8b 75 10             	mov    0x10(%ebp),%esi
80106c6c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c6f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106c72:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c7b:	77 49                	ja     80106cc6 <inituvm+0x66>
80106c7d:	e8 ae bb ff ff       	call   80102830 <kalloc>
80106c82:	83 ec 04             	sub    $0x4,%esp
80106c85:	89 c3                	mov    %eax,%ebx
80106c87:	68 00 10 00 00       	push   $0x1000
80106c8c:	6a 00                	push   $0x0
80106c8e:	50                   	push   %eax
80106c8f:	e8 2c db ff ff       	call   801047c0 <memset>
80106c94:	58                   	pop    %eax
80106c95:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c9b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ca0:	5a                   	pop    %edx
80106ca1:	6a 06                	push   $0x6
80106ca3:	50                   	push   %eax
80106ca4:	31 d2                	xor    %edx,%edx
80106ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ca9:	e8 c2 fc ff ff       	call   80106970 <mappages>
80106cae:	89 75 10             	mov    %esi,0x10(%ebp)
80106cb1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106cb4:	83 c4 10             	add    $0x10,%esp
80106cb7:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106cba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cbd:	5b                   	pop    %ebx
80106cbe:	5e                   	pop    %esi
80106cbf:	5f                   	pop    %edi
80106cc0:	5d                   	pop    %ebp
80106cc1:	e9 aa db ff ff       	jmp    80104870 <memmove>
80106cc6:	83 ec 0c             	sub    $0xc,%esp
80106cc9:	68 2d 7b 10 80       	push   $0x80107b2d
80106cce:	e8 bd 96 ff ff       	call   80100390 <panic>
80106cd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ce0 <loaduvm>:
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	57                   	push   %edi
80106ce4:	56                   	push   %esi
80106ce5:	53                   	push   %ebx
80106ce6:	83 ec 0c             	sub    $0xc,%esp
80106ce9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106cf0:	0f 85 91 00 00 00    	jne    80106d87 <loaduvm+0xa7>
80106cf6:	8b 75 18             	mov    0x18(%ebp),%esi
80106cf9:	31 db                	xor    %ebx,%ebx
80106cfb:	85 f6                	test   %esi,%esi
80106cfd:	75 1a                	jne    80106d19 <loaduvm+0x39>
80106cff:	eb 6f                	jmp    80106d70 <loaduvm+0x90>
80106d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d08:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d0e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106d14:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106d17:	76 57                	jbe    80106d70 <loaduvm+0x90>
80106d19:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d1f:	31 c9                	xor    %ecx,%ecx
80106d21:	01 da                	add    %ebx,%edx
80106d23:	e8 c8 fb ff ff       	call   801068f0 <walkpgdir>
80106d28:	85 c0                	test   %eax,%eax
80106d2a:	74 4e                	je     80106d7a <loaduvm+0x9a>
80106d2c:	8b 00                	mov    (%eax),%eax
80106d2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
80106d31:	bf 00 10 00 00       	mov    $0x1000,%edi
80106d36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d3b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d41:	0f 46 fe             	cmovbe %esi,%edi
80106d44:	01 d9                	add    %ebx,%ecx
80106d46:	05 00 00 00 80       	add    $0x80000000,%eax
80106d4b:	57                   	push   %edi
80106d4c:	51                   	push   %ecx
80106d4d:	50                   	push   %eax
80106d4e:	ff 75 10             	pushl  0x10(%ebp)
80106d51:	e8 7a af ff ff       	call   80101cd0 <readi>
80106d56:	83 c4 10             	add    $0x10,%esp
80106d59:	39 f8                	cmp    %edi,%eax
80106d5b:	74 ab                	je     80106d08 <loaduvm+0x28>
80106d5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d65:	5b                   	pop    %ebx
80106d66:	5e                   	pop    %esi
80106d67:	5f                   	pop    %edi
80106d68:	5d                   	pop    %ebp
80106d69:	c3                   	ret    
80106d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d73:	31 c0                	xor    %eax,%eax
80106d75:	5b                   	pop    %ebx
80106d76:	5e                   	pop    %esi
80106d77:	5f                   	pop    %edi
80106d78:	5d                   	pop    %ebp
80106d79:	c3                   	ret    
80106d7a:	83 ec 0c             	sub    $0xc,%esp
80106d7d:	68 47 7b 10 80       	push   $0x80107b47
80106d82:	e8 09 96 ff ff       	call   80100390 <panic>
80106d87:	83 ec 0c             	sub    $0xc,%esp
80106d8a:	68 e8 7b 10 80       	push   $0x80107be8
80106d8f:	e8 fc 95 ff ff       	call   80100390 <panic>
80106d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106da0 <allocuvm>:
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	53                   	push   %ebx
80106da6:	83 ec 1c             	sub    $0x1c,%esp
80106da9:	8b 7d 10             	mov    0x10(%ebp),%edi
80106dac:	85 ff                	test   %edi,%edi
80106dae:	0f 88 8e 00 00 00    	js     80106e42 <allocuvm+0xa2>
80106db4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106db7:	0f 82 93 00 00 00    	jb     80106e50 <allocuvm+0xb0>
80106dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dc0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106dc6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106dcc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106dcf:	0f 86 7e 00 00 00    	jbe    80106e53 <allocuvm+0xb3>
80106dd5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106dd8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106ddb:	eb 42                	jmp    80106e1f <allocuvm+0x7f>
80106ddd:	8d 76 00             	lea    0x0(%esi),%esi
80106de0:	83 ec 04             	sub    $0x4,%esp
80106de3:	68 00 10 00 00       	push   $0x1000
80106de8:	6a 00                	push   $0x0
80106dea:	50                   	push   %eax
80106deb:	e8 d0 d9 ff ff       	call   801047c0 <memset>
80106df0:	58                   	pop    %eax
80106df1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106df7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106dfc:	5a                   	pop    %edx
80106dfd:	6a 06                	push   $0x6
80106dff:	50                   	push   %eax
80106e00:	89 da                	mov    %ebx,%edx
80106e02:	89 f8                	mov    %edi,%eax
80106e04:	e8 67 fb ff ff       	call   80106970 <mappages>
80106e09:	83 c4 10             	add    $0x10,%esp
80106e0c:	85 c0                	test   %eax,%eax
80106e0e:	78 50                	js     80106e60 <allocuvm+0xc0>
80106e10:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e16:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106e19:	0f 86 81 00 00 00    	jbe    80106ea0 <allocuvm+0x100>
80106e1f:	e8 0c ba ff ff       	call   80102830 <kalloc>
80106e24:	85 c0                	test   %eax,%eax
80106e26:	89 c6                	mov    %eax,%esi
80106e28:	75 b6                	jne    80106de0 <allocuvm+0x40>
80106e2a:	83 ec 0c             	sub    $0xc,%esp
80106e2d:	68 65 7b 10 80       	push   $0x80107b65
80106e32:	e8 29 98 ff ff       	call   80100660 <cprintf>
80106e37:	83 c4 10             	add    $0x10,%esp
80106e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e3d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e40:	77 6e                	ja     80106eb0 <allocuvm+0x110>
80106e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e45:	31 ff                	xor    %edi,%edi
80106e47:	89 f8                	mov    %edi,%eax
80106e49:	5b                   	pop    %ebx
80106e4a:	5e                   	pop    %esi
80106e4b:	5f                   	pop    %edi
80106e4c:	5d                   	pop    %ebp
80106e4d:	c3                   	ret    
80106e4e:	66 90                	xchg   %ax,%ax
80106e50:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106e53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e56:	89 f8                	mov    %edi,%eax
80106e58:	5b                   	pop    %ebx
80106e59:	5e                   	pop    %esi
80106e5a:	5f                   	pop    %edi
80106e5b:	5d                   	pop    %ebp
80106e5c:	c3                   	ret    
80106e5d:	8d 76 00             	lea    0x0(%esi),%esi
80106e60:	83 ec 0c             	sub    $0xc,%esp
80106e63:	68 7d 7b 10 80       	push   $0x80107b7d
80106e68:	e8 f3 97 ff ff       	call   80100660 <cprintf>
80106e6d:	83 c4 10             	add    $0x10,%esp
80106e70:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e73:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e76:	76 0d                	jbe    80106e85 <allocuvm+0xe5>
80106e78:	89 c1                	mov    %eax,%ecx
80106e7a:	8b 55 10             	mov    0x10(%ebp),%edx
80106e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80106e80:	e8 7b fb ff ff       	call   80106a00 <deallocuvm.part.0>
80106e85:	83 ec 0c             	sub    $0xc,%esp
80106e88:	31 ff                	xor    %edi,%edi
80106e8a:	56                   	push   %esi
80106e8b:	e8 f0 b7 ff ff       	call   80102680 <kfree>
80106e90:	83 c4 10             	add    $0x10,%esp
80106e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e96:	89 f8                	mov    %edi,%eax
80106e98:	5b                   	pop    %ebx
80106e99:	5e                   	pop    %esi
80106e9a:	5f                   	pop    %edi
80106e9b:	5d                   	pop    %ebp
80106e9c:	c3                   	ret    
80106e9d:	8d 76 00             	lea    0x0(%esi),%esi
80106ea0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ea6:	5b                   	pop    %ebx
80106ea7:	89 f8                	mov    %edi,%eax
80106ea9:	5e                   	pop    %esi
80106eaa:	5f                   	pop    %edi
80106eab:	5d                   	pop    %ebp
80106eac:	c3                   	ret    
80106ead:	8d 76 00             	lea    0x0(%esi),%esi
80106eb0:	89 c1                	mov    %eax,%ecx
80106eb2:	8b 55 10             	mov    0x10(%ebp),%edx
80106eb5:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb8:	31 ff                	xor    %edi,%edi
80106eba:	e8 41 fb ff ff       	call   80106a00 <deallocuvm.part.0>
80106ebf:	eb 92                	jmp    80106e53 <allocuvm+0xb3>
80106ec1:	eb 0d                	jmp    80106ed0 <deallocuvm>
80106ec3:	90                   	nop
80106ec4:	90                   	nop
80106ec5:	90                   	nop
80106ec6:	90                   	nop
80106ec7:	90                   	nop
80106ec8:	90                   	nop
80106ec9:	90                   	nop
80106eca:	90                   	nop
80106ecb:	90                   	nop
80106ecc:	90                   	nop
80106ecd:	90                   	nop
80106ece:	90                   	nop
80106ecf:	90                   	nop

80106ed0 <deallocuvm>:
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ed6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80106edc:	39 d1                	cmp    %edx,%ecx
80106ede:	73 10                	jae    80106ef0 <deallocuvm+0x20>
80106ee0:	5d                   	pop    %ebp
80106ee1:	e9 1a fb ff ff       	jmp    80106a00 <deallocuvm.part.0>
80106ee6:	8d 76 00             	lea    0x0(%esi),%esi
80106ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106ef0:	89 d0                	mov    %edx,%eax
80106ef2:	5d                   	pop    %ebp
80106ef3:	c3                   	ret    
80106ef4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106efa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f00 <freevm>:
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 0c             	sub    $0xc,%esp
80106f09:	8b 75 08             	mov    0x8(%ebp),%esi
80106f0c:	85 f6                	test   %esi,%esi
80106f0e:	74 59                	je     80106f69 <freevm+0x69>
80106f10:	31 c9                	xor    %ecx,%ecx
80106f12:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f17:	89 f0                	mov    %esi,%eax
80106f19:	e8 e2 fa ff ff       	call   80106a00 <deallocuvm.part.0>
80106f1e:	89 f3                	mov    %esi,%ebx
80106f20:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106f26:	eb 0f                	jmp    80106f37 <freevm+0x37>
80106f28:	90                   	nop
80106f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f30:	83 c3 04             	add    $0x4,%ebx
80106f33:	39 fb                	cmp    %edi,%ebx
80106f35:	74 23                	je     80106f5a <freevm+0x5a>
80106f37:	8b 03                	mov    (%ebx),%eax
80106f39:	a8 01                	test   $0x1,%al
80106f3b:	74 f3                	je     80106f30 <freevm+0x30>
80106f3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f42:	83 ec 0c             	sub    $0xc,%esp
80106f45:	83 c3 04             	add    $0x4,%ebx
80106f48:	05 00 00 00 80       	add    $0x80000000,%eax
80106f4d:	50                   	push   %eax
80106f4e:	e8 2d b7 ff ff       	call   80102680 <kfree>
80106f53:	83 c4 10             	add    $0x10,%esp
80106f56:	39 fb                	cmp    %edi,%ebx
80106f58:	75 dd                	jne    80106f37 <freevm+0x37>
80106f5a:	89 75 08             	mov    %esi,0x8(%ebp)
80106f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f60:	5b                   	pop    %ebx
80106f61:	5e                   	pop    %esi
80106f62:	5f                   	pop    %edi
80106f63:	5d                   	pop    %ebp
80106f64:	e9 17 b7 ff ff       	jmp    80102680 <kfree>
80106f69:	83 ec 0c             	sub    $0xc,%esp
80106f6c:	68 99 7b 10 80       	push   $0x80107b99
80106f71:	e8 1a 94 ff ff       	call   80100390 <panic>
80106f76:	8d 76 00             	lea    0x0(%esi),%esi
80106f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f80 <setupkvm>:
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	56                   	push   %esi
80106f84:	53                   	push   %ebx
80106f85:	e8 a6 b8 ff ff       	call   80102830 <kalloc>
80106f8a:	85 c0                	test   %eax,%eax
80106f8c:	89 c6                	mov    %eax,%esi
80106f8e:	74 42                	je     80106fd2 <setupkvm+0x52>
80106f90:	83 ec 04             	sub    $0x4,%esp
80106f93:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106f98:	68 00 10 00 00       	push   $0x1000
80106f9d:	6a 00                	push   $0x0
80106f9f:	50                   	push   %eax
80106fa0:	e8 1b d8 ff ff       	call   801047c0 <memset>
80106fa5:	83 c4 10             	add    $0x10,%esp
80106fa8:	8b 43 04             	mov    0x4(%ebx),%eax
80106fab:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106fae:	83 ec 08             	sub    $0x8,%esp
80106fb1:	8b 13                	mov    (%ebx),%edx
80106fb3:	ff 73 0c             	pushl  0xc(%ebx)
80106fb6:	50                   	push   %eax
80106fb7:	29 c1                	sub    %eax,%ecx
80106fb9:	89 f0                	mov    %esi,%eax
80106fbb:	e8 b0 f9 ff ff       	call   80106970 <mappages>
80106fc0:	83 c4 10             	add    $0x10,%esp
80106fc3:	85 c0                	test   %eax,%eax
80106fc5:	78 19                	js     80106fe0 <setupkvm+0x60>
80106fc7:	83 c3 10             	add    $0x10,%ebx
80106fca:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106fd0:	75 d6                	jne    80106fa8 <setupkvm+0x28>
80106fd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fd5:	89 f0                	mov    %esi,%eax
80106fd7:	5b                   	pop    %ebx
80106fd8:	5e                   	pop    %esi
80106fd9:	5d                   	pop    %ebp
80106fda:	c3                   	ret    
80106fdb:	90                   	nop
80106fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fe0:	83 ec 0c             	sub    $0xc,%esp
80106fe3:	56                   	push   %esi
80106fe4:	31 f6                	xor    %esi,%esi
80106fe6:	e8 15 ff ff ff       	call   80106f00 <freevm>
80106feb:	83 c4 10             	add    $0x10,%esp
80106fee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ff1:	89 f0                	mov    %esi,%eax
80106ff3:	5b                   	pop    %ebx
80106ff4:	5e                   	pop    %esi
80106ff5:	5d                   	pop    %ebp
80106ff6:	c3                   	ret    
80106ff7:	89 f6                	mov    %esi,%esi
80106ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107000 <kvmalloc>:
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	83 ec 08             	sub    $0x8,%esp
80107006:	e8 75 ff ff ff       	call   80106f80 <setupkvm>
8010700b:	a3 e4 54 11 80       	mov    %eax,0x801154e4
80107010:	05 00 00 00 80       	add    $0x80000000,%eax
80107015:	0f 22 d8             	mov    %eax,%cr3
80107018:	c9                   	leave  
80107019:	c3                   	ret    
8010701a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107020 <clearpteu>:
80107020:	55                   	push   %ebp
80107021:	31 c9                	xor    %ecx,%ecx
80107023:	89 e5                	mov    %esp,%ebp
80107025:	83 ec 08             	sub    $0x8,%esp
80107028:	8b 55 0c             	mov    0xc(%ebp),%edx
8010702b:	8b 45 08             	mov    0x8(%ebp),%eax
8010702e:	e8 bd f8 ff ff       	call   801068f0 <walkpgdir>
80107033:	85 c0                	test   %eax,%eax
80107035:	74 05                	je     8010703c <clearpteu+0x1c>
80107037:	83 20 fb             	andl   $0xfffffffb,(%eax)
8010703a:	c9                   	leave  
8010703b:	c3                   	ret    
8010703c:	83 ec 0c             	sub    $0xc,%esp
8010703f:	68 aa 7b 10 80       	push   $0x80107baa
80107044:	e8 47 93 ff ff       	call   80100390 <panic>
80107049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107050 <copyuvm>:
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	57                   	push   %edi
80107054:	56                   	push   %esi
80107055:	53                   	push   %ebx
80107056:	83 ec 1c             	sub    $0x1c,%esp
80107059:	e8 22 ff ff ff       	call   80106f80 <setupkvm>
8010705e:	85 c0                	test   %eax,%eax
80107060:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107063:	0f 84 9f 00 00 00    	je     80107108 <copyuvm+0xb8>
80107069:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010706c:	85 c9                	test   %ecx,%ecx
8010706e:	0f 84 94 00 00 00    	je     80107108 <copyuvm+0xb8>
80107074:	31 ff                	xor    %edi,%edi
80107076:	eb 4a                	jmp    801070c2 <copyuvm+0x72>
80107078:	90                   	nop
80107079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107080:	83 ec 04             	sub    $0x4,%esp
80107083:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107089:	68 00 10 00 00       	push   $0x1000
8010708e:	53                   	push   %ebx
8010708f:	50                   	push   %eax
80107090:	e8 db d7 ff ff       	call   80104870 <memmove>
80107095:	58                   	pop    %eax
80107096:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010709c:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070a1:	5a                   	pop    %edx
801070a2:	ff 75 e4             	pushl  -0x1c(%ebp)
801070a5:	50                   	push   %eax
801070a6:	89 fa                	mov    %edi,%edx
801070a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070ab:	e8 c0 f8 ff ff       	call   80106970 <mappages>
801070b0:	83 c4 10             	add    $0x10,%esp
801070b3:	85 c0                	test   %eax,%eax
801070b5:	78 61                	js     80107118 <copyuvm+0xc8>
801070b7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801070bd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801070c0:	76 46                	jbe    80107108 <copyuvm+0xb8>
801070c2:	8b 45 08             	mov    0x8(%ebp),%eax
801070c5:	31 c9                	xor    %ecx,%ecx
801070c7:	89 fa                	mov    %edi,%edx
801070c9:	e8 22 f8 ff ff       	call   801068f0 <walkpgdir>
801070ce:	85 c0                	test   %eax,%eax
801070d0:	74 61                	je     80107133 <copyuvm+0xe3>
801070d2:	8b 00                	mov    (%eax),%eax
801070d4:	a8 01                	test   $0x1,%al
801070d6:	74 4e                	je     80107126 <copyuvm+0xd6>
801070d8:	89 c3                	mov    %eax,%ebx
801070da:	25 ff 0f 00 00       	and    $0xfff,%eax
801070df:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801070e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070e8:	e8 43 b7 ff ff       	call   80102830 <kalloc>
801070ed:	85 c0                	test   %eax,%eax
801070ef:	89 c6                	mov    %eax,%esi
801070f1:	75 8d                	jne    80107080 <copyuvm+0x30>
801070f3:	83 ec 0c             	sub    $0xc,%esp
801070f6:	ff 75 e0             	pushl  -0x20(%ebp)
801070f9:	e8 02 fe ff ff       	call   80106f00 <freevm>
801070fe:	83 c4 10             	add    $0x10,%esp
80107101:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107108:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010710b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010710e:	5b                   	pop    %ebx
8010710f:	5e                   	pop    %esi
80107110:	5f                   	pop    %edi
80107111:	5d                   	pop    %ebp
80107112:	c3                   	ret    
80107113:	90                   	nop
80107114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107118:	83 ec 0c             	sub    $0xc,%esp
8010711b:	56                   	push   %esi
8010711c:	e8 5f b5 ff ff       	call   80102680 <kfree>
80107121:	83 c4 10             	add    $0x10,%esp
80107124:	eb cd                	jmp    801070f3 <copyuvm+0xa3>
80107126:	83 ec 0c             	sub    $0xc,%esp
80107129:	68 ce 7b 10 80       	push   $0x80107bce
8010712e:	e8 5d 92 ff ff       	call   80100390 <panic>
80107133:	83 ec 0c             	sub    $0xc,%esp
80107136:	68 b4 7b 10 80       	push   $0x80107bb4
8010713b:	e8 50 92 ff ff       	call   80100390 <panic>

80107140 <uva2ka>:
80107140:	55                   	push   %ebp
80107141:	31 c9                	xor    %ecx,%ecx
80107143:	89 e5                	mov    %esp,%ebp
80107145:	83 ec 08             	sub    $0x8,%esp
80107148:	8b 55 0c             	mov    0xc(%ebp),%edx
8010714b:	8b 45 08             	mov    0x8(%ebp),%eax
8010714e:	e8 9d f7 ff ff       	call   801068f0 <walkpgdir>
80107153:	8b 00                	mov    (%eax),%eax
80107155:	c9                   	leave  
80107156:	89 c2                	mov    %eax,%edx
80107158:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010715d:	83 e2 05             	and    $0x5,%edx
80107160:	05 00 00 00 80       	add    $0x80000000,%eax
80107165:	83 fa 05             	cmp    $0x5,%edx
80107168:	ba 00 00 00 00       	mov    $0x0,%edx
8010716d:	0f 45 c2             	cmovne %edx,%eax
80107170:	c3                   	ret    
80107171:	eb 0d                	jmp    80107180 <copyout>
80107173:	90                   	nop
80107174:	90                   	nop
80107175:	90                   	nop
80107176:	90                   	nop
80107177:	90                   	nop
80107178:	90                   	nop
80107179:	90                   	nop
8010717a:	90                   	nop
8010717b:	90                   	nop
8010717c:	90                   	nop
8010717d:	90                   	nop
8010717e:	90                   	nop
8010717f:	90                   	nop

80107180 <copyout>:
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
80107186:	83 ec 1c             	sub    $0x1c,%esp
80107189:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010718c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010718f:	8b 7d 10             	mov    0x10(%ebp),%edi
80107192:	85 db                	test   %ebx,%ebx
80107194:	75 40                	jne    801071d6 <copyout+0x56>
80107196:	eb 70                	jmp    80107208 <copyout+0x88>
80107198:	90                   	nop
80107199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801071a3:	89 f1                	mov    %esi,%ecx
801071a5:	29 d1                	sub    %edx,%ecx
801071a7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801071ad:	39 d9                	cmp    %ebx,%ecx
801071af:	0f 47 cb             	cmova  %ebx,%ecx
801071b2:	29 f2                	sub    %esi,%edx
801071b4:	83 ec 04             	sub    $0x4,%esp
801071b7:	01 d0                	add    %edx,%eax
801071b9:	51                   	push   %ecx
801071ba:	57                   	push   %edi
801071bb:	50                   	push   %eax
801071bc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801071bf:	e8 ac d6 ff ff       	call   80104870 <memmove>
801071c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071c7:	83 c4 10             	add    $0x10,%esp
801071ca:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
801071d0:	01 cf                	add    %ecx,%edi
801071d2:	29 cb                	sub    %ecx,%ebx
801071d4:	74 32                	je     80107208 <copyout+0x88>
801071d6:	89 d6                	mov    %edx,%esi
801071d8:	83 ec 08             	sub    $0x8,%esp
801071db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801071de:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801071e4:	56                   	push   %esi
801071e5:	ff 75 08             	pushl  0x8(%ebp)
801071e8:	e8 53 ff ff ff       	call   80107140 <uva2ka>
801071ed:	83 c4 10             	add    $0x10,%esp
801071f0:	85 c0                	test   %eax,%eax
801071f2:	75 ac                	jne    801071a0 <copyout+0x20>
801071f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071fc:	5b                   	pop    %ebx
801071fd:	5e                   	pop    %esi
801071fe:	5f                   	pop    %edi
801071ff:	5d                   	pop    %ebp
80107200:	c3                   	ret    
80107201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010720b:	31 c0                	xor    %eax,%eax
8010720d:	5b                   	pop    %ebx
8010720e:	5e                   	pop    %esi
8010720f:	5f                   	pop    %edi
80107210:	5d                   	pop    %ebp
80107211:	c3                   	ret    
