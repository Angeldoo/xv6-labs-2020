
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	83010113          	addi	sp,sp,-2000 # 80009830 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	fe660613          	addi	a2,a2,-26 # 80009030 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	c6478793          	addi	a5,a5,-924 # 80005cc0 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd77ff>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	e6678793          	addi	a5,a5,-410 # 80000f0c <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000cc:	10479073          	csrw	sie,a5
  timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000dc:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000de:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e0:	30200073          	mret
}
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	addi	sp,sp,16
    800000ea:	8082                	ret

00000000800000ec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000ec:	715d                	addi	sp,sp,-80
    800000ee:	e486                	sd	ra,72(sp)
    800000f0:	e0a2                	sd	s0,64(sp)
    800000f2:	fc26                	sd	s1,56(sp)
    800000f4:	f84a                	sd	s2,48(sp)
    800000f6:	f44e                	sd	s3,40(sp)
    800000f8:	f052                	sd	s4,32(sp)
    800000fa:	ec56                	sd	s5,24(sp)
    800000fc:	0880                	addi	s0,sp,80
    800000fe:	8a2a                	mv	s4,a0
    80000100:	84ae                	mv	s1,a1
    80000102:	89b2                	mv	s3,a2
  int i;

  acquire(&cons.lock);
    80000104:	00011517          	auipc	a0,0x11
    80000108:	72c50513          	addi	a0,a0,1836 # 80011830 <cons>
    8000010c:	00001097          	auipc	ra,0x1
    80000110:	b56080e7          	jalr	-1194(ra) # 80000c62 <acquire>
  for(i = 0; i < n; i++){
    80000114:	05305b63          	blez	s3,8000016a <consolewrite+0x7e>
    80000118:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011a:	5afd                	li	s5,-1
    8000011c:	4685                	li	a3,1
    8000011e:	8626                	mv	a2,s1
    80000120:	85d2                	mv	a1,s4
    80000122:	fbf40513          	addi	a0,s0,-65
    80000126:	00002097          	auipc	ra,0x2
    8000012a:	3d8080e7          	jalr	984(ra) # 800024fe <either_copyin>
    8000012e:	01550c63          	beq	a0,s5,80000146 <consolewrite+0x5a>
      break;
    uartputc(c);
    80000132:	fbf44503          	lbu	a0,-65(s0)
    80000136:	00000097          	auipc	ra,0x0
    8000013a:	7fa080e7          	jalr	2042(ra) # 80000930 <uartputc>
  for(i = 0; i < n; i++){
    8000013e:	2905                	addiw	s2,s2,1
    80000140:	0485                	addi	s1,s1,1
    80000142:	fd299de3          	bne	s3,s2,8000011c <consolewrite+0x30>
  }
  release(&cons.lock);
    80000146:	00011517          	auipc	a0,0x11
    8000014a:	6ea50513          	addi	a0,a0,1770 # 80011830 <cons>
    8000014e:	00001097          	auipc	ra,0x1
    80000152:	bc8080e7          	jalr	-1080(ra) # 80000d16 <release>

  return i;
}
    80000156:	854a                	mv	a0,s2
    80000158:	60a6                	ld	ra,72(sp)
    8000015a:	6406                	ld	s0,64(sp)
    8000015c:	74e2                	ld	s1,56(sp)
    8000015e:	7942                	ld	s2,48(sp)
    80000160:	79a2                	ld	s3,40(sp)
    80000162:	7a02                	ld	s4,32(sp)
    80000164:	6ae2                	ld	s5,24(sp)
    80000166:	6161                	addi	sp,sp,80
    80000168:	8082                	ret
  for(i = 0; i < n; i++){
    8000016a:	4901                	li	s2,0
    8000016c:	bfe9                	j	80000146 <consolewrite+0x5a>

000000008000016e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	7159                	addi	sp,sp,-112
    80000170:	f486                	sd	ra,104(sp)
    80000172:	f0a2                	sd	s0,96(sp)
    80000174:	eca6                	sd	s1,88(sp)
    80000176:	e8ca                	sd	s2,80(sp)
    80000178:	e4ce                	sd	s3,72(sp)
    8000017a:	e0d2                	sd	s4,64(sp)
    8000017c:	fc56                	sd	s5,56(sp)
    8000017e:	f85a                	sd	s6,48(sp)
    80000180:	f45e                	sd	s7,40(sp)
    80000182:	f062                	sd	s8,32(sp)
    80000184:	ec66                	sd	s9,24(sp)
    80000186:	e86a                	sd	s10,16(sp)
    80000188:	1880                	addi	s0,sp,112
    8000018a:	8aaa                	mv	s5,a0
    8000018c:	8a2e                	mv	s4,a1
    8000018e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000190:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000194:	00011517          	auipc	a0,0x11
    80000198:	69c50513          	addi	a0,a0,1692 # 80011830 <cons>
    8000019c:	00001097          	auipc	ra,0x1
    800001a0:	ac6080e7          	jalr	-1338(ra) # 80000c62 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001a4:	00011497          	auipc	s1,0x11
    800001a8:	68c48493          	addi	s1,s1,1676 # 80011830 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001ac:	00011917          	auipc	s2,0x11
    800001b0:	71c90913          	addi	s2,s2,1820 # 800118c8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001b4:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001b6:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001b8:	4ca9                	li	s9,10
  while(n > 0){
    800001ba:	07305863          	blez	s3,8000022a <consoleread+0xbc>
    while(cons.r == cons.w){
    800001be:	0984a783          	lw	a5,152(s1)
    800001c2:	09c4a703          	lw	a4,156(s1)
    800001c6:	02f71463          	bne	a4,a5,800001ee <consoleread+0x80>
      if(myproc()->killed){
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	864080e7          	jalr	-1948(ra) # 80001a2e <myproc>
    800001d2:	591c                	lw	a5,48(a0)
    800001d4:	e7b5                	bnez	a5,80000240 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001d6:	85a6                	mv	a1,s1
    800001d8:	854a                	mv	a0,s2
    800001da:	00002097          	auipc	ra,0x2
    800001de:	074080e7          	jalr	116(ra) # 8000224e <sleep>
    while(cons.r == cons.w){
    800001e2:	0984a783          	lw	a5,152(s1)
    800001e6:	09c4a703          	lw	a4,156(s1)
    800001ea:	fef700e3          	beq	a4,a5,800001ca <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001ee:	0017871b          	addiw	a4,a5,1
    800001f2:	08e4ac23          	sw	a4,152(s1)
    800001f6:	07f7f713          	andi	a4,a5,127
    800001fa:	9726                	add	a4,a4,s1
    800001fc:	01874703          	lbu	a4,24(a4)
    80000200:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000204:	077d0563          	beq	s10,s7,8000026e <consoleread+0x100>
    cbuf = c;
    80000208:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000020c:	4685                	li	a3,1
    8000020e:	f9f40613          	addi	a2,s0,-97
    80000212:	85d2                	mv	a1,s4
    80000214:	8556                	mv	a0,s5
    80000216:	00002097          	auipc	ra,0x2
    8000021a:	292080e7          	jalr	658(ra) # 800024a8 <either_copyout>
    8000021e:	01850663          	beq	a0,s8,8000022a <consoleread+0xbc>
    dst++;
    80000222:	0a05                	addi	s4,s4,1
    --n;
    80000224:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000226:	f99d1ae3          	bne	s10,s9,800001ba <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000022a:	00011517          	auipc	a0,0x11
    8000022e:	60650513          	addi	a0,a0,1542 # 80011830 <cons>
    80000232:	00001097          	auipc	ra,0x1
    80000236:	ae4080e7          	jalr	-1308(ra) # 80000d16 <release>

  return target - n;
    8000023a:	413b053b          	subw	a0,s6,s3
    8000023e:	a811                	j	80000252 <consoleread+0xe4>
        release(&cons.lock);
    80000240:	00011517          	auipc	a0,0x11
    80000244:	5f050513          	addi	a0,a0,1520 # 80011830 <cons>
    80000248:	00001097          	auipc	ra,0x1
    8000024c:	ace080e7          	jalr	-1330(ra) # 80000d16 <release>
        return -1;
    80000250:	557d                	li	a0,-1
}
    80000252:	70a6                	ld	ra,104(sp)
    80000254:	7406                	ld	s0,96(sp)
    80000256:	64e6                	ld	s1,88(sp)
    80000258:	6946                	ld	s2,80(sp)
    8000025a:	69a6                	ld	s3,72(sp)
    8000025c:	6a06                	ld	s4,64(sp)
    8000025e:	7ae2                	ld	s5,56(sp)
    80000260:	7b42                	ld	s6,48(sp)
    80000262:	7ba2                	ld	s7,40(sp)
    80000264:	7c02                	ld	s8,32(sp)
    80000266:	6ce2                	ld	s9,24(sp)
    80000268:	6d42                	ld	s10,16(sp)
    8000026a:	6165                	addi	sp,sp,112
    8000026c:	8082                	ret
      if(n < target){
    8000026e:	0009871b          	sext.w	a4,s3
    80000272:	fb677ce3          	bgeu	a4,s6,8000022a <consoleread+0xbc>
        cons.r--;
    80000276:	00011717          	auipc	a4,0x11
    8000027a:	64f72923          	sw	a5,1618(a4) # 800118c8 <cons+0x98>
    8000027e:	b775                	j	8000022a <consoleread+0xbc>

0000000080000280 <consputc>:
{
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e406                	sd	ra,8(sp)
    80000284:	e022                	sd	s0,0(sp)
    80000286:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000288:	10000793          	li	a5,256
    8000028c:	00f50a63          	beq	a0,a5,800002a0 <consputc+0x20>
    uartputc_sync(c);
    80000290:	00000097          	auipc	ra,0x0
    80000294:	5c2080e7          	jalr	1474(ra) # 80000852 <uartputc_sync>
}
    80000298:	60a2                	ld	ra,8(sp)
    8000029a:	6402                	ld	s0,0(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002a0:	4521                	li	a0,8
    800002a2:	00000097          	auipc	ra,0x0
    800002a6:	5b0080e7          	jalr	1456(ra) # 80000852 <uartputc_sync>
    800002aa:	02000513          	li	a0,32
    800002ae:	00000097          	auipc	ra,0x0
    800002b2:	5a4080e7          	jalr	1444(ra) # 80000852 <uartputc_sync>
    800002b6:	4521                	li	a0,8
    800002b8:	00000097          	auipc	ra,0x0
    800002bc:	59a080e7          	jalr	1434(ra) # 80000852 <uartputc_sync>
    800002c0:	bfe1                	j	80000298 <consputc+0x18>

00000000800002c2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c2:	1101                	addi	sp,sp,-32
    800002c4:	ec06                	sd	ra,24(sp)
    800002c6:	e822                	sd	s0,16(sp)
    800002c8:	e426                	sd	s1,8(sp)
    800002ca:	e04a                	sd	s2,0(sp)
    800002cc:	1000                	addi	s0,sp,32
    800002ce:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d0:	00011517          	auipc	a0,0x11
    800002d4:	56050513          	addi	a0,a0,1376 # 80011830 <cons>
    800002d8:	00001097          	auipc	ra,0x1
    800002dc:	98a080e7          	jalr	-1654(ra) # 80000c62 <acquire>

  switch(c){
    800002e0:	47d5                	li	a5,21
    800002e2:	0af48663          	beq	s1,a5,8000038e <consoleintr+0xcc>
    800002e6:	0297ca63          	blt	a5,s1,8000031a <consoleintr+0x58>
    800002ea:	47a1                	li	a5,8
    800002ec:	0ef48763          	beq	s1,a5,800003da <consoleintr+0x118>
    800002f0:	47c1                	li	a5,16
    800002f2:	10f49a63          	bne	s1,a5,80000406 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f6:	00002097          	auipc	ra,0x2
    800002fa:	25e080e7          	jalr	606(ra) # 80002554 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fe:	00011517          	auipc	a0,0x11
    80000302:	53250513          	addi	a0,a0,1330 # 80011830 <cons>
    80000306:	00001097          	auipc	ra,0x1
    8000030a:	a10080e7          	jalr	-1520(ra) # 80000d16 <release>
}
    8000030e:	60e2                	ld	ra,24(sp)
    80000310:	6442                	ld	s0,16(sp)
    80000312:	64a2                	ld	s1,8(sp)
    80000314:	6902                	ld	s2,0(sp)
    80000316:	6105                	addi	sp,sp,32
    80000318:	8082                	ret
  switch(c){
    8000031a:	07f00793          	li	a5,127
    8000031e:	0af48e63          	beq	s1,a5,800003da <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000322:	00011717          	auipc	a4,0x11
    80000326:	50e70713          	addi	a4,a4,1294 # 80011830 <cons>
    8000032a:	0a072783          	lw	a5,160(a4)
    8000032e:	09872703          	lw	a4,152(a4)
    80000332:	9f99                	subw	a5,a5,a4
    80000334:	07f00713          	li	a4,127
    80000338:	fcf763e3          	bltu	a4,a5,800002fe <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000033c:	47b5                	li	a5,13
    8000033e:	0cf48763          	beq	s1,a5,8000040c <consoleintr+0x14a>
      consputc(c);
    80000342:	8526                	mv	a0,s1
    80000344:	00000097          	auipc	ra,0x0
    80000348:	f3c080e7          	jalr	-196(ra) # 80000280 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000034c:	00011797          	auipc	a5,0x11
    80000350:	4e478793          	addi	a5,a5,1252 # 80011830 <cons>
    80000354:	0a07a703          	lw	a4,160(a5)
    80000358:	0017069b          	addiw	a3,a4,1
    8000035c:	0006861b          	sext.w	a2,a3
    80000360:	0ad7a023          	sw	a3,160(a5)
    80000364:	07f77713          	andi	a4,a4,127
    80000368:	97ba                	add	a5,a5,a4
    8000036a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000036e:	47a9                	li	a5,10
    80000370:	0cf48563          	beq	s1,a5,8000043a <consoleintr+0x178>
    80000374:	4791                	li	a5,4
    80000376:	0cf48263          	beq	s1,a5,8000043a <consoleintr+0x178>
    8000037a:	00011797          	auipc	a5,0x11
    8000037e:	54e7a783          	lw	a5,1358(a5) # 800118c8 <cons+0x98>
    80000382:	0807879b          	addiw	a5,a5,128
    80000386:	f6f61ce3          	bne	a2,a5,800002fe <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000038a:	863e                	mv	a2,a5
    8000038c:	a07d                	j	8000043a <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038e:	00011717          	auipc	a4,0x11
    80000392:	4a270713          	addi	a4,a4,1186 # 80011830 <cons>
    80000396:	0a072783          	lw	a5,160(a4)
    8000039a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    8000039e:	00011497          	auipc	s1,0x11
    800003a2:	49248493          	addi	s1,s1,1170 # 80011830 <cons>
    while(cons.e != cons.w &&
    800003a6:	4929                	li	s2,10
    800003a8:	f4f70be3          	beq	a4,a5,800002fe <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003ac:	37fd                	addiw	a5,a5,-1
    800003ae:	07f7f713          	andi	a4,a5,127
    800003b2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b4:	01874703          	lbu	a4,24(a4)
    800003b8:	f52703e3          	beq	a4,s2,800002fe <consoleintr+0x3c>
      cons.e--;
    800003bc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003c0:	10000513          	li	a0,256
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	ebc080e7          	jalr	-324(ra) # 80000280 <consputc>
    while(cons.e != cons.w &&
    800003cc:	0a04a783          	lw	a5,160(s1)
    800003d0:	09c4a703          	lw	a4,156(s1)
    800003d4:	fcf71ce3          	bne	a4,a5,800003ac <consoleintr+0xea>
    800003d8:	b71d                	j	800002fe <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003da:	00011717          	auipc	a4,0x11
    800003de:	45670713          	addi	a4,a4,1110 # 80011830 <cons>
    800003e2:	0a072783          	lw	a5,160(a4)
    800003e6:	09c72703          	lw	a4,156(a4)
    800003ea:	f0f70ae3          	beq	a4,a5,800002fe <consoleintr+0x3c>
      cons.e--;
    800003ee:	37fd                	addiw	a5,a5,-1
    800003f0:	00011717          	auipc	a4,0x11
    800003f4:	4ef72023          	sw	a5,1248(a4) # 800118d0 <cons+0xa0>
      consputc(BACKSPACE);
    800003f8:	10000513          	li	a0,256
    800003fc:	00000097          	auipc	ra,0x0
    80000400:	e84080e7          	jalr	-380(ra) # 80000280 <consputc>
    80000404:	bded                	j	800002fe <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000406:	ee048ce3          	beqz	s1,800002fe <consoleintr+0x3c>
    8000040a:	bf21                	j	80000322 <consoleintr+0x60>
      consputc(c);
    8000040c:	4529                	li	a0,10
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	e72080e7          	jalr	-398(ra) # 80000280 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000416:	00011797          	auipc	a5,0x11
    8000041a:	41a78793          	addi	a5,a5,1050 # 80011830 <cons>
    8000041e:	0a07a703          	lw	a4,160(a5)
    80000422:	0017069b          	addiw	a3,a4,1
    80000426:	0006861b          	sext.w	a2,a3
    8000042a:	0ad7a023          	sw	a3,160(a5)
    8000042e:	07f77713          	andi	a4,a4,127
    80000432:	97ba                	add	a5,a5,a4
    80000434:	4729                	li	a4,10
    80000436:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000043a:	00011797          	auipc	a5,0x11
    8000043e:	48c7a923          	sw	a2,1170(a5) # 800118cc <cons+0x9c>
        wakeup(&cons.r);
    80000442:	00011517          	auipc	a0,0x11
    80000446:	48650513          	addi	a0,a0,1158 # 800118c8 <cons+0x98>
    8000044a:	00002097          	auipc	ra,0x2
    8000044e:	f84080e7          	jalr	-124(ra) # 800023ce <wakeup>
    80000452:	b575                	j	800002fe <consoleintr+0x3c>

0000000080000454 <consoleinit>:

void
consoleinit(void)
{
    80000454:	1141                	addi	sp,sp,-16
    80000456:	e406                	sd	ra,8(sp)
    80000458:	e022                	sd	s0,0(sp)
    8000045a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000045c:	00008597          	auipc	a1,0x8
    80000460:	bb458593          	addi	a1,a1,-1100 # 80008010 <etext+0x10>
    80000464:	00011517          	auipc	a0,0x11
    80000468:	3cc50513          	addi	a0,a0,972 # 80011830 <cons>
    8000046c:	00000097          	auipc	ra,0x0
    80000470:	766080e7          	jalr	1894(ra) # 80000bd2 <initlock>

  uartinit();
    80000474:	00000097          	auipc	ra,0x0
    80000478:	38e080e7          	jalr	910(ra) # 80000802 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000047c:	00022797          	auipc	a5,0x22
    80000480:	d3478793          	addi	a5,a5,-716 # 800221b0 <devsw>
    80000484:	00000717          	auipc	a4,0x0
    80000488:	cea70713          	addi	a4,a4,-790 # 8000016e <consoleread>
    8000048c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048e:	00000717          	auipc	a4,0x0
    80000492:	c5e70713          	addi	a4,a4,-930 # 800000ec <consolewrite>
    80000496:	ef98                	sd	a4,24(a5)
}
    80000498:	60a2                	ld	ra,8(sp)
    8000049a:	6402                	ld	s0,0(sp)
    8000049c:	0141                	addi	sp,sp,16
    8000049e:	8082                	ret

00000000800004a0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004a0:	7179                	addi	sp,sp,-48
    800004a2:	f406                	sd	ra,40(sp)
    800004a4:	f022                	sd	s0,32(sp)
    800004a6:	ec26                	sd	s1,24(sp)
    800004a8:	e84a                	sd	s2,16(sp)
    800004aa:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004ac:	c219                	beqz	a2,800004b2 <printint+0x12>
    800004ae:	08054663          	bltz	a0,8000053a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004b2:	2501                	sext.w	a0,a0
    800004b4:	4881                	li	a7,0
    800004b6:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004ba:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004bc:	2581                	sext.w	a1,a1
    800004be:	00008617          	auipc	a2,0x8
    800004c2:	b8a60613          	addi	a2,a2,-1142 # 80008048 <digits>
    800004c6:	883a                	mv	a6,a4
    800004c8:	2705                	addiw	a4,a4,1
    800004ca:	02b577bb          	remuw	a5,a0,a1
    800004ce:	1782                	slli	a5,a5,0x20
    800004d0:	9381                	srli	a5,a5,0x20
    800004d2:	97b2                	add	a5,a5,a2
    800004d4:	0007c783          	lbu	a5,0(a5)
    800004d8:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004dc:	0005079b          	sext.w	a5,a0
    800004e0:	02b5553b          	divuw	a0,a0,a1
    800004e4:	0685                	addi	a3,a3,1
    800004e6:	feb7f0e3          	bgeu	a5,a1,800004c6 <printint+0x26>

  if(sign)
    800004ea:	00088b63          	beqz	a7,80000500 <printint+0x60>
    buf[i++] = '-';
    800004ee:	fe040793          	addi	a5,s0,-32
    800004f2:	973e                	add	a4,a4,a5
    800004f4:	02d00793          	li	a5,45
    800004f8:	fef70823          	sb	a5,-16(a4)
    800004fc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000500:	02e05763          	blez	a4,8000052e <printint+0x8e>
    80000504:	fd040793          	addi	a5,s0,-48
    80000508:	00e784b3          	add	s1,a5,a4
    8000050c:	fff78913          	addi	s2,a5,-1
    80000510:	993a                	add	s2,s2,a4
    80000512:	377d                	addiw	a4,a4,-1
    80000514:	1702                	slli	a4,a4,0x20
    80000516:	9301                	srli	a4,a4,0x20
    80000518:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000051c:	fff4c503          	lbu	a0,-1(s1)
    80000520:	00000097          	auipc	ra,0x0
    80000524:	d60080e7          	jalr	-672(ra) # 80000280 <consputc>
  while(--i >= 0)
    80000528:	14fd                	addi	s1,s1,-1
    8000052a:	ff2499e3          	bne	s1,s2,8000051c <printint+0x7c>
}
    8000052e:	70a2                	ld	ra,40(sp)
    80000530:	7402                	ld	s0,32(sp)
    80000532:	64e2                	ld	s1,24(sp)
    80000534:	6942                	ld	s2,16(sp)
    80000536:	6145                	addi	sp,sp,48
    80000538:	8082                	ret
    x = -xx;
    8000053a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053e:	4885                	li	a7,1
    x = -xx;
    80000540:	bf9d                	j	800004b6 <printint+0x16>

0000000080000542 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000542:	1101                	addi	sp,sp,-32
    80000544:	ec06                	sd	ra,24(sp)
    80000546:	e822                	sd	s0,16(sp)
    80000548:	e426                	sd	s1,8(sp)
    8000054a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000054c:	00011497          	auipc	s1,0x11
    80000550:	38c48493          	addi	s1,s1,908 # 800118d8 <pr>
    80000554:	00008597          	auipc	a1,0x8
    80000558:	ac458593          	addi	a1,a1,-1340 # 80008018 <etext+0x18>
    8000055c:	8526                	mv	a0,s1
    8000055e:	00000097          	auipc	ra,0x0
    80000562:	674080e7          	jalr	1652(ra) # 80000bd2 <initlock>
  pr.locking = 1;
    80000566:	4785                	li	a5,1
    80000568:	cc9c                	sw	a5,24(s1)
}
    8000056a:	60e2                	ld	ra,24(sp)
    8000056c:	6442                	ld	s0,16(sp)
    8000056e:	64a2                	ld	s1,8(sp)
    80000570:	6105                	addi	sp,sp,32
    80000572:	8082                	ret

0000000080000574 <backtrace>:

// print the return address - lab4-2
void backtrace() {
    80000574:	7179                	addi	sp,sp,-48
    80000576:	f406                	sd	ra,40(sp)
    80000578:	f022                	sd	s0,32(sp)
    8000057a:	ec26                	sd	s1,24(sp)
    8000057c:	e84a                	sd	s2,16(sp)
    8000057e:	e44e                	sd	s3,8(sp)
    80000580:	e052                	sd	s4,0(sp)
    80000582:	1800                	addi	s0,sp,48
typedef uint64 *pagetable_t; // 512 PTEs

// read the current frame pointer from s0 register - lab4-2
static inline uint64 r_fp() {
    uint64 x;
    asm volatile("mv %0, s0" : "=r" (x) );
    80000584:	84a2                	mv	s1,s0
    uint64 fp = r_fp();
    uint64 top = PGROUNDUP(fp);
    80000586:	6905                	lui	s2,0x1
    80000588:	197d                	addi	s2,s2,-1
    8000058a:	9926                	add	s2,s2,s1
    8000058c:	79fd                	lui	s3,0xfffff
    8000058e:	01397933          	and	s2,s2,s3
    uint64 bottom = PGROUNDDOWN(fp);
    80000592:	0134f9b3          	and	s3,s1,s3
    for (; fp >= bottom && fp < top; fp = *((uint64 *) (fp - 16))) {
    80000596:	0334e563          	bltu	s1,s3,800005c0 <backtrace+0x4c>
    8000059a:	0324f363          	bgeu	s1,s2,800005c0 <backtrace+0x4c>
        printf("%p\n", *((uint64 *) (fp - 8)));
    8000059e:	00008a17          	auipc	s4,0x8
    800005a2:	a82a0a13          	addi	s4,s4,-1406 # 80008020 <etext+0x20>
    800005a6:	ff84b583          	ld	a1,-8(s1)
    800005aa:	8552                	mv	a0,s4
    800005ac:	00000097          	auipc	ra,0x0
    800005b0:	076080e7          	jalr	118(ra) # 80000622 <printf>
    for (; fp >= bottom && fp < top; fp = *((uint64 *) (fp - 16))) {
    800005b4:	ff04b483          	ld	s1,-16(s1)
    800005b8:	0134e463          	bltu	s1,s3,800005c0 <backtrace+0x4c>
    800005bc:	ff24e5e3          	bltu	s1,s2,800005a6 <backtrace+0x32>
    }
    800005c0:	70a2                	ld	ra,40(sp)
    800005c2:	7402                	ld	s0,32(sp)
    800005c4:	64e2                	ld	s1,24(sp)
    800005c6:	6942                	ld	s2,16(sp)
    800005c8:	69a2                	ld	s3,8(sp)
    800005ca:	6a02                	ld	s4,0(sp)
    800005cc:	6145                	addi	sp,sp,48
    800005ce:	8082                	ret

00000000800005d0 <panic>:
{
    800005d0:	1101                	addi	sp,sp,-32
    800005d2:	ec06                	sd	ra,24(sp)
    800005d4:	e822                	sd	s0,16(sp)
    800005d6:	e426                	sd	s1,8(sp)
    800005d8:	1000                	addi	s0,sp,32
    800005da:	84aa                	mv	s1,a0
  pr.locking = 0;
    800005dc:	00011797          	auipc	a5,0x11
    800005e0:	3007aa23          	sw	zero,788(a5) # 800118f0 <pr+0x18>
  printf("panic: ");
    800005e4:	00008517          	auipc	a0,0x8
    800005e8:	a4450513          	addi	a0,a0,-1468 # 80008028 <etext+0x28>
    800005ec:	00000097          	auipc	ra,0x0
    800005f0:	036080e7          	jalr	54(ra) # 80000622 <printf>
  printf(s);
    800005f4:	8526                	mv	a0,s1
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	02c080e7          	jalr	44(ra) # 80000622 <printf>
  printf("\n");
    800005fe:	00008517          	auipc	a0,0x8
    80000602:	ad250513          	addi	a0,a0,-1326 # 800080d0 <digits+0x88>
    80000606:	00000097          	auipc	ra,0x0
    8000060a:	01c080e7          	jalr	28(ra) # 80000622 <printf>
  backtrace();  // lab4-2
    8000060e:	00000097          	auipc	ra,0x0
    80000612:	f66080e7          	jalr	-154(ra) # 80000574 <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80000616:	4785                	li	a5,1
    80000618:	00009717          	auipc	a4,0x9
    8000061c:	9ef72423          	sw	a5,-1560(a4) # 80009000 <panicked>
  for(;;)
    80000620:	a001                	j	80000620 <panic+0x50>

0000000080000622 <printf>:
{
    80000622:	7131                	addi	sp,sp,-192
    80000624:	fc86                	sd	ra,120(sp)
    80000626:	f8a2                	sd	s0,112(sp)
    80000628:	f4a6                	sd	s1,104(sp)
    8000062a:	f0ca                	sd	s2,96(sp)
    8000062c:	ecce                	sd	s3,88(sp)
    8000062e:	e8d2                	sd	s4,80(sp)
    80000630:	e4d6                	sd	s5,72(sp)
    80000632:	e0da                	sd	s6,64(sp)
    80000634:	fc5e                	sd	s7,56(sp)
    80000636:	f862                	sd	s8,48(sp)
    80000638:	f466                	sd	s9,40(sp)
    8000063a:	f06a                	sd	s10,32(sp)
    8000063c:	ec6e                	sd	s11,24(sp)
    8000063e:	0100                	addi	s0,sp,128
    80000640:	8a2a                	mv	s4,a0
    80000642:	e40c                	sd	a1,8(s0)
    80000644:	e810                	sd	a2,16(s0)
    80000646:	ec14                	sd	a3,24(s0)
    80000648:	f018                	sd	a4,32(s0)
    8000064a:	f41c                	sd	a5,40(s0)
    8000064c:	03043823          	sd	a6,48(s0)
    80000650:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80000654:	00011d97          	auipc	s11,0x11
    80000658:	29cdad83          	lw	s11,668(s11) # 800118f0 <pr+0x18>
  if(locking)
    8000065c:	020d9b63          	bnez	s11,80000692 <printf+0x70>
  if (fmt == 0)
    80000660:	040a0263          	beqz	s4,800006a4 <printf+0x82>
  va_start(ap, fmt);
    80000664:	00840793          	addi	a5,s0,8
    80000668:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000066c:	000a4503          	lbu	a0,0(s4)
    80000670:	14050f63          	beqz	a0,800007ce <printf+0x1ac>
    80000674:	4981                	li	s3,0
    if(c != '%'){
    80000676:	02500a93          	li	s5,37
    switch(c){
    8000067a:	07000b93          	li	s7,112
  consputc('x');
    8000067e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000680:	00008b17          	auipc	s6,0x8
    80000684:	9c8b0b13          	addi	s6,s6,-1592 # 80008048 <digits>
    switch(c){
    80000688:	07300c93          	li	s9,115
    8000068c:	06400c13          	li	s8,100
    80000690:	a82d                	j	800006ca <printf+0xa8>
    acquire(&pr.lock);
    80000692:	00011517          	auipc	a0,0x11
    80000696:	24650513          	addi	a0,a0,582 # 800118d8 <pr>
    8000069a:	00000097          	auipc	ra,0x0
    8000069e:	5c8080e7          	jalr	1480(ra) # 80000c62 <acquire>
    800006a2:	bf7d                	j	80000660 <printf+0x3e>
    panic("null fmt");
    800006a4:	00008517          	auipc	a0,0x8
    800006a8:	99450513          	addi	a0,a0,-1644 # 80008038 <etext+0x38>
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	f24080e7          	jalr	-220(ra) # 800005d0 <panic>
      consputc(c);
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	bcc080e7          	jalr	-1076(ra) # 80000280 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800006bc:	2985                	addiw	s3,s3,1
    800006be:	013a07b3          	add	a5,s4,s3
    800006c2:	0007c503          	lbu	a0,0(a5)
    800006c6:	10050463          	beqz	a0,800007ce <printf+0x1ac>
    if(c != '%'){
    800006ca:	ff5515e3          	bne	a0,s5,800006b4 <printf+0x92>
    c = fmt[++i] & 0xff;
    800006ce:	2985                	addiw	s3,s3,1
    800006d0:	013a07b3          	add	a5,s4,s3
    800006d4:	0007c783          	lbu	a5,0(a5)
    800006d8:	0007849b          	sext.w	s1,a5
    if(c == 0)
    800006dc:	cbed                	beqz	a5,800007ce <printf+0x1ac>
    switch(c){
    800006de:	05778a63          	beq	a5,s7,80000732 <printf+0x110>
    800006e2:	02fbf663          	bgeu	s7,a5,8000070e <printf+0xec>
    800006e6:	09978863          	beq	a5,s9,80000776 <printf+0x154>
    800006ea:	07800713          	li	a4,120
    800006ee:	0ce79563          	bne	a5,a4,800007b8 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    800006f2:	f8843783          	ld	a5,-120(s0)
    800006f6:	00878713          	addi	a4,a5,8
    800006fa:	f8e43423          	sd	a4,-120(s0)
    800006fe:	4605                	li	a2,1
    80000700:	85ea                	mv	a1,s10
    80000702:	4388                	lw	a0,0(a5)
    80000704:	00000097          	auipc	ra,0x0
    80000708:	d9c080e7          	jalr	-612(ra) # 800004a0 <printint>
      break;
    8000070c:	bf45                	j	800006bc <printf+0x9a>
    switch(c){
    8000070e:	09578f63          	beq	a5,s5,800007ac <printf+0x18a>
    80000712:	0b879363          	bne	a5,s8,800007b8 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000716:	f8843783          	ld	a5,-120(s0)
    8000071a:	00878713          	addi	a4,a5,8
    8000071e:	f8e43423          	sd	a4,-120(s0)
    80000722:	4605                	li	a2,1
    80000724:	45a9                	li	a1,10
    80000726:	4388                	lw	a0,0(a5)
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	d78080e7          	jalr	-648(ra) # 800004a0 <printint>
      break;
    80000730:	b771                	j	800006bc <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000732:	f8843783          	ld	a5,-120(s0)
    80000736:	00878713          	addi	a4,a5,8
    8000073a:	f8e43423          	sd	a4,-120(s0)
    8000073e:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80000742:	03000513          	li	a0,48
    80000746:	00000097          	auipc	ra,0x0
    8000074a:	b3a080e7          	jalr	-1222(ra) # 80000280 <consputc>
  consputc('x');
    8000074e:	07800513          	li	a0,120
    80000752:	00000097          	auipc	ra,0x0
    80000756:	b2e080e7          	jalr	-1234(ra) # 80000280 <consputc>
    8000075a:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000075c:	03c95793          	srli	a5,s2,0x3c
    80000760:	97da                	add	a5,a5,s6
    80000762:	0007c503          	lbu	a0,0(a5)
    80000766:	00000097          	auipc	ra,0x0
    8000076a:	b1a080e7          	jalr	-1254(ra) # 80000280 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000076e:	0912                	slli	s2,s2,0x4
    80000770:	34fd                	addiw	s1,s1,-1
    80000772:	f4ed                	bnez	s1,8000075c <printf+0x13a>
    80000774:	b7a1                	j	800006bc <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80000776:	f8843783          	ld	a5,-120(s0)
    8000077a:	00878713          	addi	a4,a5,8
    8000077e:	f8e43423          	sd	a4,-120(s0)
    80000782:	6384                	ld	s1,0(a5)
    80000784:	cc89                	beqz	s1,8000079e <printf+0x17c>
      for(; *s; s++)
    80000786:	0004c503          	lbu	a0,0(s1)
    8000078a:	d90d                	beqz	a0,800006bc <printf+0x9a>
        consputc(*s);
    8000078c:	00000097          	auipc	ra,0x0
    80000790:	af4080e7          	jalr	-1292(ra) # 80000280 <consputc>
      for(; *s; s++)
    80000794:	0485                	addi	s1,s1,1
    80000796:	0004c503          	lbu	a0,0(s1)
    8000079a:	f96d                	bnez	a0,8000078c <printf+0x16a>
    8000079c:	b705                	j	800006bc <printf+0x9a>
        s = "(null)";
    8000079e:	00008497          	auipc	s1,0x8
    800007a2:	89248493          	addi	s1,s1,-1902 # 80008030 <etext+0x30>
      for(; *s; s++)
    800007a6:	02800513          	li	a0,40
    800007aa:	b7cd                	j	8000078c <printf+0x16a>
      consputc('%');
    800007ac:	8556                	mv	a0,s5
    800007ae:	00000097          	auipc	ra,0x0
    800007b2:	ad2080e7          	jalr	-1326(ra) # 80000280 <consputc>
      break;
    800007b6:	b719                	j	800006bc <printf+0x9a>
      consputc('%');
    800007b8:	8556                	mv	a0,s5
    800007ba:	00000097          	auipc	ra,0x0
    800007be:	ac6080e7          	jalr	-1338(ra) # 80000280 <consputc>
      consputc(c);
    800007c2:	8526                	mv	a0,s1
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	abc080e7          	jalr	-1348(ra) # 80000280 <consputc>
      break;
    800007cc:	bdc5                	j	800006bc <printf+0x9a>
  if(locking)
    800007ce:	020d9163          	bnez	s11,800007f0 <printf+0x1ce>
}
    800007d2:	70e6                	ld	ra,120(sp)
    800007d4:	7446                	ld	s0,112(sp)
    800007d6:	74a6                	ld	s1,104(sp)
    800007d8:	7906                	ld	s2,96(sp)
    800007da:	69e6                	ld	s3,88(sp)
    800007dc:	6a46                	ld	s4,80(sp)
    800007de:	6aa6                	ld	s5,72(sp)
    800007e0:	6b06                	ld	s6,64(sp)
    800007e2:	7be2                	ld	s7,56(sp)
    800007e4:	7c42                	ld	s8,48(sp)
    800007e6:	7ca2                	ld	s9,40(sp)
    800007e8:	7d02                	ld	s10,32(sp)
    800007ea:	6de2                	ld	s11,24(sp)
    800007ec:	6129                	addi	sp,sp,192
    800007ee:	8082                	ret
    release(&pr.lock);
    800007f0:	00011517          	auipc	a0,0x11
    800007f4:	0e850513          	addi	a0,a0,232 # 800118d8 <pr>
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	51e080e7          	jalr	1310(ra) # 80000d16 <release>
}
    80000800:	bfc9                	j	800007d2 <printf+0x1b0>

0000000080000802 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000802:	1141                	addi	sp,sp,-16
    80000804:	e406                	sd	ra,8(sp)
    80000806:	e022                	sd	s0,0(sp)
    80000808:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000080a:	100007b7          	lui	a5,0x10000
    8000080e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000812:	f8000713          	li	a4,-128
    80000816:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000081a:	470d                	li	a4,3
    8000081c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000820:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000824:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000828:	469d                	li	a3,7
    8000082a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000082e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000832:	00008597          	auipc	a1,0x8
    80000836:	82e58593          	addi	a1,a1,-2002 # 80008060 <digits+0x18>
    8000083a:	00011517          	auipc	a0,0x11
    8000083e:	0be50513          	addi	a0,a0,190 # 800118f8 <uart_tx_lock>
    80000842:	00000097          	auipc	ra,0x0
    80000846:	390080e7          	jalr	912(ra) # 80000bd2 <initlock>
}
    8000084a:	60a2                	ld	ra,8(sp)
    8000084c:	6402                	ld	s0,0(sp)
    8000084e:	0141                	addi	sp,sp,16
    80000850:	8082                	ret

0000000080000852 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000852:	1101                	addi	sp,sp,-32
    80000854:	ec06                	sd	ra,24(sp)
    80000856:	e822                	sd	s0,16(sp)
    80000858:	e426                	sd	s1,8(sp)
    8000085a:	1000                	addi	s0,sp,32
    8000085c:	84aa                	mv	s1,a0
  push_off();
    8000085e:	00000097          	auipc	ra,0x0
    80000862:	3b8080e7          	jalr	952(ra) # 80000c16 <push_off>

  if(panicked){
    80000866:	00008797          	auipc	a5,0x8
    8000086a:	79a7a783          	lw	a5,1946(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000086e:	10000737          	lui	a4,0x10000
  if(panicked){
    80000872:	c391                	beqz	a5,80000876 <uartputc_sync+0x24>
    for(;;)
    80000874:	a001                	j	80000874 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000876:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000087a:	0207f793          	andi	a5,a5,32
    8000087e:	dfe5                	beqz	a5,80000876 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000880:	0ff4f513          	andi	a0,s1,255
    80000884:	100007b7          	lui	a5,0x10000
    80000888:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088c:	00000097          	auipc	ra,0x0
    80000890:	42a080e7          	jalr	1066(ra) # 80000cb6 <pop_off>
}
    80000894:	60e2                	ld	ra,24(sp)
    80000896:	6442                	ld	s0,16(sp)
    80000898:	64a2                	ld	s1,8(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret

000000008000089e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000089e:	00008797          	auipc	a5,0x8
    800008a2:	7667a783          	lw	a5,1894(a5) # 80009004 <uart_tx_r>
    800008a6:	00008717          	auipc	a4,0x8
    800008aa:	76272703          	lw	a4,1890(a4) # 80009008 <uart_tx_w>
    800008ae:	08f70063          	beq	a4,a5,8000092e <uartstart+0x90>
{
    800008b2:	7139                	addi	sp,sp,-64
    800008b4:	fc06                	sd	ra,56(sp)
    800008b6:	f822                	sd	s0,48(sp)
    800008b8:	f426                	sd	s1,40(sp)
    800008ba:	f04a                	sd	s2,32(sp)
    800008bc:	ec4e                	sd	s3,24(sp)
    800008be:	e852                	sd	s4,16(sp)
    800008c0:	e456                	sd	s5,8(sp)
    800008c2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r];
    800008c8:	00011a97          	auipc	s5,0x11
    800008cc:	030a8a93          	addi	s5,s5,48 # 800118f8 <uart_tx_lock>
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    800008d0:	00008497          	auipc	s1,0x8
    800008d4:	73448493          	addi	s1,s1,1844 # 80009004 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800008d8:	00008a17          	auipc	s4,0x8
    800008dc:	730a0a13          	addi	s4,s4,1840 # 80009008 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008e0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800008e4:	02077713          	andi	a4,a4,32
    800008e8:	cb15                	beqz	a4,8000091c <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r];
    800008ea:	00fa8733          	add	a4,s5,a5
    800008ee:	01874983          	lbu	s3,24(a4)
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    800008f2:	2785                	addiw	a5,a5,1
    800008f4:	41f7d71b          	sraiw	a4,a5,0x1f
    800008f8:	01b7571b          	srliw	a4,a4,0x1b
    800008fc:	9fb9                	addw	a5,a5,a4
    800008fe:	8bfd                	andi	a5,a5,31
    80000900:	9f99                	subw	a5,a5,a4
    80000902:	c09c                	sw	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000904:	8526                	mv	a0,s1
    80000906:	00002097          	auipc	ra,0x2
    8000090a:	ac8080e7          	jalr	-1336(ra) # 800023ce <wakeup>
    
    WriteReg(THR, c);
    8000090e:	01390023          	sb	s3,0(s2)
    if(uart_tx_w == uart_tx_r){
    80000912:	409c                	lw	a5,0(s1)
    80000914:	000a2703          	lw	a4,0(s4)
    80000918:	fcf714e3          	bne	a4,a5,800008e0 <uartstart+0x42>
  }
}
    8000091c:	70e2                	ld	ra,56(sp)
    8000091e:	7442                	ld	s0,48(sp)
    80000920:	74a2                	ld	s1,40(sp)
    80000922:	7902                	ld	s2,32(sp)
    80000924:	69e2                	ld	s3,24(sp)
    80000926:	6a42                	ld	s4,16(sp)
    80000928:	6aa2                	ld	s5,8(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret
    8000092e:	8082                	ret

0000000080000930 <uartputc>:
{
    80000930:	7179                	addi	sp,sp,-48
    80000932:	f406                	sd	ra,40(sp)
    80000934:	f022                	sd	s0,32(sp)
    80000936:	ec26                	sd	s1,24(sp)
    80000938:	e84a                	sd	s2,16(sp)
    8000093a:	e44e                	sd	s3,8(sp)
    8000093c:	e052                	sd	s4,0(sp)
    8000093e:	1800                	addi	s0,sp,48
    80000940:	84aa                	mv	s1,a0
  acquire(&uart_tx_lock);
    80000942:	00011517          	auipc	a0,0x11
    80000946:	fb650513          	addi	a0,a0,-74 # 800118f8 <uart_tx_lock>
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	318080e7          	jalr	792(ra) # 80000c62 <acquire>
  if(panicked){
    80000952:	00008797          	auipc	a5,0x8
    80000956:	6ae7a783          	lw	a5,1710(a5) # 80009000 <panicked>
    8000095a:	c391                	beqz	a5,8000095e <uartputc+0x2e>
    for(;;)
    8000095c:	a001                	j	8000095c <uartputc+0x2c>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    8000095e:	00008697          	auipc	a3,0x8
    80000962:	6aa6a683          	lw	a3,1706(a3) # 80009008 <uart_tx_w>
    80000966:	0016879b          	addiw	a5,a3,1
    8000096a:	41f7d71b          	sraiw	a4,a5,0x1f
    8000096e:	01b7571b          	srliw	a4,a4,0x1b
    80000972:	9fb9                	addw	a5,a5,a4
    80000974:	8bfd                	andi	a5,a5,31
    80000976:	9f99                	subw	a5,a5,a4
    80000978:	00008717          	auipc	a4,0x8
    8000097c:	68c72703          	lw	a4,1676(a4) # 80009004 <uart_tx_r>
    80000980:	04f71363          	bne	a4,a5,800009c6 <uartputc+0x96>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000984:	00011a17          	auipc	s4,0x11
    80000988:	f74a0a13          	addi	s4,s4,-140 # 800118f8 <uart_tx_lock>
    8000098c:	00008917          	auipc	s2,0x8
    80000990:	67890913          	addi	s2,s2,1656 # 80009004 <uart_tx_r>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000994:	00008997          	auipc	s3,0x8
    80000998:	67498993          	addi	s3,s3,1652 # 80009008 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000099c:	85d2                	mv	a1,s4
    8000099e:	854a                	mv	a0,s2
    800009a0:	00002097          	auipc	ra,0x2
    800009a4:	8ae080e7          	jalr	-1874(ra) # 8000224e <sleep>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    800009a8:	0009a683          	lw	a3,0(s3)
    800009ac:	0016879b          	addiw	a5,a3,1
    800009b0:	41f7d71b          	sraiw	a4,a5,0x1f
    800009b4:	01b7571b          	srliw	a4,a4,0x1b
    800009b8:	9fb9                	addw	a5,a5,a4
    800009ba:	8bfd                	andi	a5,a5,31
    800009bc:	9f99                	subw	a5,a5,a4
    800009be:	00092703          	lw	a4,0(s2)
    800009c2:	fcf70de3          	beq	a4,a5,8000099c <uartputc+0x6c>
      uart_tx_buf[uart_tx_w] = c;
    800009c6:	00011917          	auipc	s2,0x11
    800009ca:	f3290913          	addi	s2,s2,-206 # 800118f8 <uart_tx_lock>
    800009ce:	96ca                	add	a3,a3,s2
    800009d0:	00968c23          	sb	s1,24(a3)
      uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    800009d4:	00008717          	auipc	a4,0x8
    800009d8:	62f72a23          	sw	a5,1588(a4) # 80009008 <uart_tx_w>
      uartstart();
    800009dc:	00000097          	auipc	ra,0x0
    800009e0:	ec2080e7          	jalr	-318(ra) # 8000089e <uartstart>
      release(&uart_tx_lock);
    800009e4:	854a                	mv	a0,s2
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	330080e7          	jalr	816(ra) # 80000d16 <release>
}
    800009ee:	70a2                	ld	ra,40(sp)
    800009f0:	7402                	ld	s0,32(sp)
    800009f2:	64e2                	ld	s1,24(sp)
    800009f4:	6942                	ld	s2,16(sp)
    800009f6:	69a2                	ld	s3,8(sp)
    800009f8:	6a02                	ld	s4,0(sp)
    800009fa:	6145                	addi	sp,sp,48
    800009fc:	8082                	ret

00000000800009fe <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009fe:	1141                	addi	sp,sp,-16
    80000a00:	e422                	sd	s0,8(sp)
    80000a02:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000a04:	100007b7          	lui	a5,0x10000
    80000a08:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a0c:	8b85                	andi	a5,a5,1
    80000a0e:	cb91                	beqz	a5,80000a22 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000a10:	100007b7          	lui	a5,0x10000
    80000a14:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000a18:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80000a1c:	6422                	ld	s0,8(sp)
    80000a1e:	0141                	addi	sp,sp,16
    80000a20:	8082                	ret
    return -1;
    80000a22:	557d                	li	a0,-1
    80000a24:	bfe5                	j	80000a1c <uartgetc+0x1e>

0000000080000a26 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000a26:	1101                	addi	sp,sp,-32
    80000a28:	ec06                	sd	ra,24(sp)
    80000a2a:	e822                	sd	s0,16(sp)
    80000a2c:	e426                	sd	s1,8(sp)
    80000a2e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a30:	54fd                	li	s1,-1
    80000a32:	a029                	j	80000a3c <uartintr+0x16>
      break;
    consoleintr(c);
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	88e080e7          	jalr	-1906(ra) # 800002c2 <consoleintr>
    int c = uartgetc();
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	fc2080e7          	jalr	-62(ra) # 800009fe <uartgetc>
    if(c == -1)
    80000a44:	fe9518e3          	bne	a0,s1,80000a34 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a48:	00011497          	auipc	s1,0x11
    80000a4c:	eb048493          	addi	s1,s1,-336 # 800118f8 <uart_tx_lock>
    80000a50:	8526                	mv	a0,s1
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	210080e7          	jalr	528(ra) # 80000c62 <acquire>
  uartstart();
    80000a5a:	00000097          	auipc	ra,0x0
    80000a5e:	e44080e7          	jalr	-444(ra) # 8000089e <uartstart>
  release(&uart_tx_lock);
    80000a62:	8526                	mv	a0,s1
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	2b2080e7          	jalr	690(ra) # 80000d16 <release>
}
    80000a6c:	60e2                	ld	ra,24(sp)
    80000a6e:	6442                	ld	s0,16(sp)
    80000a70:	64a2                	ld	s1,8(sp)
    80000a72:	6105                	addi	sp,sp,32
    80000a74:	8082                	ret

0000000080000a76 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a76:	1101                	addi	sp,sp,-32
    80000a78:	ec06                	sd	ra,24(sp)
    80000a7a:	e822                	sd	s0,16(sp)
    80000a7c:	e426                	sd	s1,8(sp)
    80000a7e:	e04a                	sd	s2,0(sp)
    80000a80:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a82:	03451793          	slli	a5,a0,0x34
    80000a86:	ebb9                	bnez	a5,80000adc <kfree+0x66>
    80000a88:	84aa                	mv	s1,a0
    80000a8a:	00026797          	auipc	a5,0x26
    80000a8e:	57678793          	addi	a5,a5,1398 # 80027000 <end>
    80000a92:	04f56563          	bltu	a0,a5,80000adc <kfree+0x66>
    80000a96:	47c5                	li	a5,17
    80000a98:	07ee                	slli	a5,a5,0x1b
    80000a9a:	04f57163          	bgeu	a0,a5,80000adc <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a9e:	6605                	lui	a2,0x1
    80000aa0:	4585                	li	a1,1
    80000aa2:	00000097          	auipc	ra,0x0
    80000aa6:	2bc080e7          	jalr	700(ra) # 80000d5e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000aaa:	00011917          	auipc	s2,0x11
    80000aae:	e8690913          	addi	s2,s2,-378 # 80011930 <kmem>
    80000ab2:	854a                	mv	a0,s2
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	1ae080e7          	jalr	430(ra) # 80000c62 <acquire>
  r->next = kmem.freelist;
    80000abc:	01893783          	ld	a5,24(s2)
    80000ac0:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000ac2:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000ac6:	854a                	mv	a0,s2
    80000ac8:	00000097          	auipc	ra,0x0
    80000acc:	24e080e7          	jalr	590(ra) # 80000d16 <release>
}
    80000ad0:	60e2                	ld	ra,24(sp)
    80000ad2:	6442                	ld	s0,16(sp)
    80000ad4:	64a2                	ld	s1,8(sp)
    80000ad6:	6902                	ld	s2,0(sp)
    80000ad8:	6105                	addi	sp,sp,32
    80000ada:	8082                	ret
    panic("kfree");
    80000adc:	00007517          	auipc	a0,0x7
    80000ae0:	58c50513          	addi	a0,a0,1420 # 80008068 <digits+0x20>
    80000ae4:	00000097          	auipc	ra,0x0
    80000ae8:	aec080e7          	jalr	-1300(ra) # 800005d0 <panic>

0000000080000aec <freerange>:
{
    80000aec:	7179                	addi	sp,sp,-48
    80000aee:	f406                	sd	ra,40(sp)
    80000af0:	f022                	sd	s0,32(sp)
    80000af2:	ec26                	sd	s1,24(sp)
    80000af4:	e84a                	sd	s2,16(sp)
    80000af6:	e44e                	sd	s3,8(sp)
    80000af8:	e052                	sd	s4,0(sp)
    80000afa:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000afc:	6785                	lui	a5,0x1
    80000afe:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000b02:	94aa                	add	s1,s1,a0
    80000b04:	757d                	lui	a0,0xfffff
    80000b06:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b08:	94be                	add	s1,s1,a5
    80000b0a:	0095ee63          	bltu	a1,s1,80000b26 <freerange+0x3a>
    80000b0e:	892e                	mv	s2,a1
    kfree(p);
    80000b10:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b12:	6985                	lui	s3,0x1
    kfree(p);
    80000b14:	01448533          	add	a0,s1,s4
    80000b18:	00000097          	auipc	ra,0x0
    80000b1c:	f5e080e7          	jalr	-162(ra) # 80000a76 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b20:	94ce                	add	s1,s1,s3
    80000b22:	fe9979e3          	bgeu	s2,s1,80000b14 <freerange+0x28>
}
    80000b26:	70a2                	ld	ra,40(sp)
    80000b28:	7402                	ld	s0,32(sp)
    80000b2a:	64e2                	ld	s1,24(sp)
    80000b2c:	6942                	ld	s2,16(sp)
    80000b2e:	69a2                	ld	s3,8(sp)
    80000b30:	6a02                	ld	s4,0(sp)
    80000b32:	6145                	addi	sp,sp,48
    80000b34:	8082                	ret

0000000080000b36 <kinit>:
{
    80000b36:	1141                	addi	sp,sp,-16
    80000b38:	e406                	sd	ra,8(sp)
    80000b3a:	e022                	sd	s0,0(sp)
    80000b3c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b3e:	00007597          	auipc	a1,0x7
    80000b42:	53258593          	addi	a1,a1,1330 # 80008070 <digits+0x28>
    80000b46:	00011517          	auipc	a0,0x11
    80000b4a:	dea50513          	addi	a0,a0,-534 # 80011930 <kmem>
    80000b4e:	00000097          	auipc	ra,0x0
    80000b52:	084080e7          	jalr	132(ra) # 80000bd2 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b56:	45c5                	li	a1,17
    80000b58:	05ee                	slli	a1,a1,0x1b
    80000b5a:	00026517          	auipc	a0,0x26
    80000b5e:	4a650513          	addi	a0,a0,1190 # 80027000 <end>
    80000b62:	00000097          	auipc	ra,0x0
    80000b66:	f8a080e7          	jalr	-118(ra) # 80000aec <freerange>
}
    80000b6a:	60a2                	ld	ra,8(sp)
    80000b6c:	6402                	ld	s0,0(sp)
    80000b6e:	0141                	addi	sp,sp,16
    80000b70:	8082                	ret

0000000080000b72 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b72:	1101                	addi	sp,sp,-32
    80000b74:	ec06                	sd	ra,24(sp)
    80000b76:	e822                	sd	s0,16(sp)
    80000b78:	e426                	sd	s1,8(sp)
    80000b7a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b7c:	00011497          	auipc	s1,0x11
    80000b80:	db448493          	addi	s1,s1,-588 # 80011930 <kmem>
    80000b84:	8526                	mv	a0,s1
    80000b86:	00000097          	auipc	ra,0x0
    80000b8a:	0dc080e7          	jalr	220(ra) # 80000c62 <acquire>
  r = kmem.freelist;
    80000b8e:	6c84                	ld	s1,24(s1)
  if(r)
    80000b90:	c885                	beqz	s1,80000bc0 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b92:	609c                	ld	a5,0(s1)
    80000b94:	00011517          	auipc	a0,0x11
    80000b98:	d9c50513          	addi	a0,a0,-612 # 80011930 <kmem>
    80000b9c:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b9e:	00000097          	auipc	ra,0x0
    80000ba2:	178080e7          	jalr	376(ra) # 80000d16 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000ba6:	6605                	lui	a2,0x1
    80000ba8:	4595                	li	a1,5
    80000baa:	8526                	mv	a0,s1
    80000bac:	00000097          	auipc	ra,0x0
    80000bb0:	1b2080e7          	jalr	434(ra) # 80000d5e <memset>
  return (void*)r;
}
    80000bb4:	8526                	mv	a0,s1
    80000bb6:	60e2                	ld	ra,24(sp)
    80000bb8:	6442                	ld	s0,16(sp)
    80000bba:	64a2                	ld	s1,8(sp)
    80000bbc:	6105                	addi	sp,sp,32
    80000bbe:	8082                	ret
  release(&kmem.lock);
    80000bc0:	00011517          	auipc	a0,0x11
    80000bc4:	d7050513          	addi	a0,a0,-656 # 80011930 <kmem>
    80000bc8:	00000097          	auipc	ra,0x0
    80000bcc:	14e080e7          	jalr	334(ra) # 80000d16 <release>
  if(r)
    80000bd0:	b7d5                	j	80000bb4 <kalloc+0x42>

0000000080000bd2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000bd2:	1141                	addi	sp,sp,-16
    80000bd4:	e422                	sd	s0,8(sp)
    80000bd6:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bd8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bda:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bde:	00053823          	sd	zero,16(a0)
}
    80000be2:	6422                	ld	s0,8(sp)
    80000be4:	0141                	addi	sp,sp,16
    80000be6:	8082                	ret

0000000080000be8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000be8:	411c                	lw	a5,0(a0)
    80000bea:	e399                	bnez	a5,80000bf0 <holding+0x8>
    80000bec:	4501                	li	a0,0
  return r;
}
    80000bee:	8082                	ret
{
    80000bf0:	1101                	addi	sp,sp,-32
    80000bf2:	ec06                	sd	ra,24(sp)
    80000bf4:	e822                	sd	s0,16(sp)
    80000bf6:	e426                	sd	s1,8(sp)
    80000bf8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bfa:	6904                	ld	s1,16(a0)
    80000bfc:	00001097          	auipc	ra,0x1
    80000c00:	e16080e7          	jalr	-490(ra) # 80001a12 <mycpu>
    80000c04:	40a48533          	sub	a0,s1,a0
    80000c08:	00153513          	seqz	a0,a0
}
    80000c0c:	60e2                	ld	ra,24(sp)
    80000c0e:	6442                	ld	s0,16(sp)
    80000c10:	64a2                	ld	s1,8(sp)
    80000c12:	6105                	addi	sp,sp,32
    80000c14:	8082                	ret

0000000080000c16 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c16:	1101                	addi	sp,sp,-32
    80000c18:	ec06                	sd	ra,24(sp)
    80000c1a:	e822                	sd	s0,16(sp)
    80000c1c:	e426                	sd	s1,8(sp)
    80000c1e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c20:	100024f3          	csrr	s1,sstatus
    80000c24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c28:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c2a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c2e:	00001097          	auipc	ra,0x1
    80000c32:	de4080e7          	jalr	-540(ra) # 80001a12 <mycpu>
    80000c36:	5d3c                	lw	a5,120(a0)
    80000c38:	cf89                	beqz	a5,80000c52 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c3a:	00001097          	auipc	ra,0x1
    80000c3e:	dd8080e7          	jalr	-552(ra) # 80001a12 <mycpu>
    80000c42:	5d3c                	lw	a5,120(a0)
    80000c44:	2785                	addiw	a5,a5,1
    80000c46:	dd3c                	sw	a5,120(a0)
}
    80000c48:	60e2                	ld	ra,24(sp)
    80000c4a:	6442                	ld	s0,16(sp)
    80000c4c:	64a2                	ld	s1,8(sp)
    80000c4e:	6105                	addi	sp,sp,32
    80000c50:	8082                	ret
    mycpu()->intena = old;
    80000c52:	00001097          	auipc	ra,0x1
    80000c56:	dc0080e7          	jalr	-576(ra) # 80001a12 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c5a:	8085                	srli	s1,s1,0x1
    80000c5c:	8885                	andi	s1,s1,1
    80000c5e:	dd64                	sw	s1,124(a0)
    80000c60:	bfe9                	j	80000c3a <push_off+0x24>

0000000080000c62 <acquire>:
{
    80000c62:	1101                	addi	sp,sp,-32
    80000c64:	ec06                	sd	ra,24(sp)
    80000c66:	e822                	sd	s0,16(sp)
    80000c68:	e426                	sd	s1,8(sp)
    80000c6a:	1000                	addi	s0,sp,32
    80000c6c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c6e:	00000097          	auipc	ra,0x0
    80000c72:	fa8080e7          	jalr	-88(ra) # 80000c16 <push_off>
  if(holding(lk))
    80000c76:	8526                	mv	a0,s1
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	f70080e7          	jalr	-144(ra) # 80000be8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c80:	4705                	li	a4,1
  if(holding(lk))
    80000c82:	e115                	bnez	a0,80000ca6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c84:	87ba                	mv	a5,a4
    80000c86:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c8a:	2781                	sext.w	a5,a5
    80000c8c:	ffe5                	bnez	a5,80000c84 <acquire+0x22>
  __sync_synchronize();
    80000c8e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c92:	00001097          	auipc	ra,0x1
    80000c96:	d80080e7          	jalr	-640(ra) # 80001a12 <mycpu>
    80000c9a:	e888                	sd	a0,16(s1)
}
    80000c9c:	60e2                	ld	ra,24(sp)
    80000c9e:	6442                	ld	s0,16(sp)
    80000ca0:	64a2                	ld	s1,8(sp)
    80000ca2:	6105                	addi	sp,sp,32
    80000ca4:	8082                	ret
    panic("acquire");
    80000ca6:	00007517          	auipc	a0,0x7
    80000caa:	3d250513          	addi	a0,a0,978 # 80008078 <digits+0x30>
    80000cae:	00000097          	auipc	ra,0x0
    80000cb2:	922080e7          	jalr	-1758(ra) # 800005d0 <panic>

0000000080000cb6 <pop_off>:

void
pop_off(void)
{
    80000cb6:	1141                	addi	sp,sp,-16
    80000cb8:	e406                	sd	ra,8(sp)
    80000cba:	e022                	sd	s0,0(sp)
    80000cbc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000cbe:	00001097          	auipc	ra,0x1
    80000cc2:	d54080e7          	jalr	-684(ra) # 80001a12 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cc6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000cca:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000ccc:	e78d                	bnez	a5,80000cf6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000cce:	5d3c                	lw	a5,120(a0)
    80000cd0:	02f05b63          	blez	a5,80000d06 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000cd4:	37fd                	addiw	a5,a5,-1
    80000cd6:	0007871b          	sext.w	a4,a5
    80000cda:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cdc:	eb09                	bnez	a4,80000cee <pop_off+0x38>
    80000cde:	5d7c                	lw	a5,124(a0)
    80000ce0:	c799                	beqz	a5,80000cee <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ce2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000ce6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cea:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cee:	60a2                	ld	ra,8(sp)
    80000cf0:	6402                	ld	s0,0(sp)
    80000cf2:	0141                	addi	sp,sp,16
    80000cf4:	8082                	ret
    panic("pop_off - interruptible");
    80000cf6:	00007517          	auipc	a0,0x7
    80000cfa:	38a50513          	addi	a0,a0,906 # 80008080 <digits+0x38>
    80000cfe:	00000097          	auipc	ra,0x0
    80000d02:	8d2080e7          	jalr	-1838(ra) # 800005d0 <panic>
    panic("pop_off");
    80000d06:	00007517          	auipc	a0,0x7
    80000d0a:	39250513          	addi	a0,a0,914 # 80008098 <digits+0x50>
    80000d0e:	00000097          	auipc	ra,0x0
    80000d12:	8c2080e7          	jalr	-1854(ra) # 800005d0 <panic>

0000000080000d16 <release>:
{
    80000d16:	1101                	addi	sp,sp,-32
    80000d18:	ec06                	sd	ra,24(sp)
    80000d1a:	e822                	sd	s0,16(sp)
    80000d1c:	e426                	sd	s1,8(sp)
    80000d1e:	1000                	addi	s0,sp,32
    80000d20:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000d22:	00000097          	auipc	ra,0x0
    80000d26:	ec6080e7          	jalr	-314(ra) # 80000be8 <holding>
    80000d2a:	c115                	beqz	a0,80000d4e <release+0x38>
  lk->cpu = 0;
    80000d2c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d30:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000d34:	0f50000f          	fence	iorw,ow
    80000d38:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000d3c:	00000097          	auipc	ra,0x0
    80000d40:	f7a080e7          	jalr	-134(ra) # 80000cb6 <pop_off>
}
    80000d44:	60e2                	ld	ra,24(sp)
    80000d46:	6442                	ld	s0,16(sp)
    80000d48:	64a2                	ld	s1,8(sp)
    80000d4a:	6105                	addi	sp,sp,32
    80000d4c:	8082                	ret
    panic("release");
    80000d4e:	00007517          	auipc	a0,0x7
    80000d52:	35250513          	addi	a0,a0,850 # 800080a0 <digits+0x58>
    80000d56:	00000097          	auipc	ra,0x0
    80000d5a:	87a080e7          	jalr	-1926(ra) # 800005d0 <panic>

0000000080000d5e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d5e:	1141                	addi	sp,sp,-16
    80000d60:	e422                	sd	s0,8(sp)
    80000d62:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d64:	ca19                	beqz	a2,80000d7a <memset+0x1c>
    80000d66:	87aa                	mv	a5,a0
    80000d68:	1602                	slli	a2,a2,0x20
    80000d6a:	9201                	srli	a2,a2,0x20
    80000d6c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d70:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d74:	0785                	addi	a5,a5,1
    80000d76:	fee79de3          	bne	a5,a4,80000d70 <memset+0x12>
  }
  return dst;
}
    80000d7a:	6422                	ld	s0,8(sp)
    80000d7c:	0141                	addi	sp,sp,16
    80000d7e:	8082                	ret

0000000080000d80 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d80:	1141                	addi	sp,sp,-16
    80000d82:	e422                	sd	s0,8(sp)
    80000d84:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d86:	ca05                	beqz	a2,80000db6 <memcmp+0x36>
    80000d88:	fff6069b          	addiw	a3,a2,-1
    80000d8c:	1682                	slli	a3,a3,0x20
    80000d8e:	9281                	srli	a3,a3,0x20
    80000d90:	0685                	addi	a3,a3,1
    80000d92:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d94:	00054783          	lbu	a5,0(a0)
    80000d98:	0005c703          	lbu	a4,0(a1)
    80000d9c:	00e79863          	bne	a5,a4,80000dac <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000da0:	0505                	addi	a0,a0,1
    80000da2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000da4:	fed518e3          	bne	a0,a3,80000d94 <memcmp+0x14>
  }

  return 0;
    80000da8:	4501                	li	a0,0
    80000daa:	a019                	j	80000db0 <memcmp+0x30>
      return *s1 - *s2;
    80000dac:	40e7853b          	subw	a0,a5,a4
}
    80000db0:	6422                	ld	s0,8(sp)
    80000db2:	0141                	addi	sp,sp,16
    80000db4:	8082                	ret
  return 0;
    80000db6:	4501                	li	a0,0
    80000db8:	bfe5                	j	80000db0 <memcmp+0x30>

0000000080000dba <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000dba:	1141                	addi	sp,sp,-16
    80000dbc:	e422                	sd	s0,8(sp)
    80000dbe:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000dc0:	02a5e563          	bltu	a1,a0,80000dea <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000dc4:	fff6069b          	addiw	a3,a2,-1
    80000dc8:	ce11                	beqz	a2,80000de4 <memmove+0x2a>
    80000dca:	1682                	slli	a3,a3,0x20
    80000dcc:	9281                	srli	a3,a3,0x20
    80000dce:	0685                	addi	a3,a3,1
    80000dd0:	96ae                	add	a3,a3,a1
    80000dd2:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000dd4:	0585                	addi	a1,a1,1
    80000dd6:	0785                	addi	a5,a5,1
    80000dd8:	fff5c703          	lbu	a4,-1(a1)
    80000ddc:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000de0:	fed59ae3          	bne	a1,a3,80000dd4 <memmove+0x1a>

  return dst;
}
    80000de4:	6422                	ld	s0,8(sp)
    80000de6:	0141                	addi	sp,sp,16
    80000de8:	8082                	ret
  if(s < d && s + n > d){
    80000dea:	02061713          	slli	a4,a2,0x20
    80000dee:	9301                	srli	a4,a4,0x20
    80000df0:	00e587b3          	add	a5,a1,a4
    80000df4:	fcf578e3          	bgeu	a0,a5,80000dc4 <memmove+0xa>
    d += n;
    80000df8:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000dfa:	fff6069b          	addiw	a3,a2,-1
    80000dfe:	d27d                	beqz	a2,80000de4 <memmove+0x2a>
    80000e00:	02069613          	slli	a2,a3,0x20
    80000e04:	9201                	srli	a2,a2,0x20
    80000e06:	fff64613          	not	a2,a2
    80000e0a:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000e0c:	17fd                	addi	a5,a5,-1
    80000e0e:	177d                	addi	a4,a4,-1
    80000e10:	0007c683          	lbu	a3,0(a5)
    80000e14:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000e18:	fef61ae3          	bne	a2,a5,80000e0c <memmove+0x52>
    80000e1c:	b7e1                	j	80000de4 <memmove+0x2a>

0000000080000e1e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e1e:	1141                	addi	sp,sp,-16
    80000e20:	e406                	sd	ra,8(sp)
    80000e22:	e022                	sd	s0,0(sp)
    80000e24:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e26:	00000097          	auipc	ra,0x0
    80000e2a:	f94080e7          	jalr	-108(ra) # 80000dba <memmove>
}
    80000e2e:	60a2                	ld	ra,8(sp)
    80000e30:	6402                	ld	s0,0(sp)
    80000e32:	0141                	addi	sp,sp,16
    80000e34:	8082                	ret

0000000080000e36 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e36:	1141                	addi	sp,sp,-16
    80000e38:	e422                	sd	s0,8(sp)
    80000e3a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e3c:	ce11                	beqz	a2,80000e58 <strncmp+0x22>
    80000e3e:	00054783          	lbu	a5,0(a0)
    80000e42:	cf89                	beqz	a5,80000e5c <strncmp+0x26>
    80000e44:	0005c703          	lbu	a4,0(a1)
    80000e48:	00f71a63          	bne	a4,a5,80000e5c <strncmp+0x26>
    n--, p++, q++;
    80000e4c:	367d                	addiw	a2,a2,-1
    80000e4e:	0505                	addi	a0,a0,1
    80000e50:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e52:	f675                	bnez	a2,80000e3e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e54:	4501                	li	a0,0
    80000e56:	a809                	j	80000e68 <strncmp+0x32>
    80000e58:	4501                	li	a0,0
    80000e5a:	a039                	j	80000e68 <strncmp+0x32>
  if(n == 0)
    80000e5c:	ca09                	beqz	a2,80000e6e <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e5e:	00054503          	lbu	a0,0(a0)
    80000e62:	0005c783          	lbu	a5,0(a1)
    80000e66:	9d1d                	subw	a0,a0,a5
}
    80000e68:	6422                	ld	s0,8(sp)
    80000e6a:	0141                	addi	sp,sp,16
    80000e6c:	8082                	ret
    return 0;
    80000e6e:	4501                	li	a0,0
    80000e70:	bfe5                	j	80000e68 <strncmp+0x32>

0000000080000e72 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e72:	1141                	addi	sp,sp,-16
    80000e74:	e422                	sd	s0,8(sp)
    80000e76:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e78:	872a                	mv	a4,a0
    80000e7a:	8832                	mv	a6,a2
    80000e7c:	367d                	addiw	a2,a2,-1
    80000e7e:	01005963          	blez	a6,80000e90 <strncpy+0x1e>
    80000e82:	0705                	addi	a4,a4,1
    80000e84:	0005c783          	lbu	a5,0(a1)
    80000e88:	fef70fa3          	sb	a5,-1(a4)
    80000e8c:	0585                	addi	a1,a1,1
    80000e8e:	f7f5                	bnez	a5,80000e7a <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e90:	86ba                	mv	a3,a4
    80000e92:	00c05c63          	blez	a2,80000eaa <strncpy+0x38>
    *s++ = 0;
    80000e96:	0685                	addi	a3,a3,1
    80000e98:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e9c:	fff6c793          	not	a5,a3
    80000ea0:	9fb9                	addw	a5,a5,a4
    80000ea2:	010787bb          	addw	a5,a5,a6
    80000ea6:	fef048e3          	bgtz	a5,80000e96 <strncpy+0x24>
  return os;
}
    80000eaa:	6422                	ld	s0,8(sp)
    80000eac:	0141                	addi	sp,sp,16
    80000eae:	8082                	ret

0000000080000eb0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000eb0:	1141                	addi	sp,sp,-16
    80000eb2:	e422                	sd	s0,8(sp)
    80000eb4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000eb6:	02c05363          	blez	a2,80000edc <safestrcpy+0x2c>
    80000eba:	fff6069b          	addiw	a3,a2,-1
    80000ebe:	1682                	slli	a3,a3,0x20
    80000ec0:	9281                	srli	a3,a3,0x20
    80000ec2:	96ae                	add	a3,a3,a1
    80000ec4:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000ec6:	00d58963          	beq	a1,a3,80000ed8 <safestrcpy+0x28>
    80000eca:	0585                	addi	a1,a1,1
    80000ecc:	0785                	addi	a5,a5,1
    80000ece:	fff5c703          	lbu	a4,-1(a1)
    80000ed2:	fee78fa3          	sb	a4,-1(a5)
    80000ed6:	fb65                	bnez	a4,80000ec6 <safestrcpy+0x16>
    ;
  *s = 0;
    80000ed8:	00078023          	sb	zero,0(a5)
  return os;
}
    80000edc:	6422                	ld	s0,8(sp)
    80000ede:	0141                	addi	sp,sp,16
    80000ee0:	8082                	ret

0000000080000ee2 <strlen>:

int
strlen(const char *s)
{
    80000ee2:	1141                	addi	sp,sp,-16
    80000ee4:	e422                	sd	s0,8(sp)
    80000ee6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000ee8:	00054783          	lbu	a5,0(a0)
    80000eec:	cf91                	beqz	a5,80000f08 <strlen+0x26>
    80000eee:	0505                	addi	a0,a0,1
    80000ef0:	87aa                	mv	a5,a0
    80000ef2:	4685                	li	a3,1
    80000ef4:	9e89                	subw	a3,a3,a0
    80000ef6:	00f6853b          	addw	a0,a3,a5
    80000efa:	0785                	addi	a5,a5,1
    80000efc:	fff7c703          	lbu	a4,-1(a5)
    80000f00:	fb7d                	bnez	a4,80000ef6 <strlen+0x14>
    ;
  return n;
}
    80000f02:	6422                	ld	s0,8(sp)
    80000f04:	0141                	addi	sp,sp,16
    80000f06:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f08:	4501                	li	a0,0
    80000f0a:	bfe5                	j	80000f02 <strlen+0x20>

0000000080000f0c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f0c:	1141                	addi	sp,sp,-16
    80000f0e:	e406                	sd	ra,8(sp)
    80000f10:	e022                	sd	s0,0(sp)
    80000f12:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f14:	00001097          	auipc	ra,0x1
    80000f18:	aee080e7          	jalr	-1298(ra) # 80001a02 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f1c:	00008717          	auipc	a4,0x8
    80000f20:	0f070713          	addi	a4,a4,240 # 8000900c <started>
  if(cpuid() == 0){
    80000f24:	c139                	beqz	a0,80000f6a <main+0x5e>
    while(started == 0)
    80000f26:	431c                	lw	a5,0(a4)
    80000f28:	2781                	sext.w	a5,a5
    80000f2a:	dff5                	beqz	a5,80000f26 <main+0x1a>
      ;
    __sync_synchronize();
    80000f2c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f30:	00001097          	auipc	ra,0x1
    80000f34:	ad2080e7          	jalr	-1326(ra) # 80001a02 <cpuid>
    80000f38:	85aa                	mv	a1,a0
    80000f3a:	00007517          	auipc	a0,0x7
    80000f3e:	18650513          	addi	a0,a0,390 # 800080c0 <digits+0x78>
    80000f42:	fffff097          	auipc	ra,0xfffff
    80000f46:	6e0080e7          	jalr	1760(ra) # 80000622 <printf>
    kvminithart();    // turn on paging
    80000f4a:	00000097          	auipc	ra,0x0
    80000f4e:	0d8080e7          	jalr	216(ra) # 80001022 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f52:	00001097          	auipc	ra,0x1
    80000f56:	742080e7          	jalr	1858(ra) # 80002694 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f5a:	00005097          	auipc	ra,0x5
    80000f5e:	da6080e7          	jalr	-602(ra) # 80005d00 <plicinithart>
  }

  scheduler();        
    80000f62:	00001097          	auipc	ra,0x1
    80000f66:	010080e7          	jalr	16(ra) # 80001f72 <scheduler>
    consoleinit();
    80000f6a:	fffff097          	auipc	ra,0xfffff
    80000f6e:	4ea080e7          	jalr	1258(ra) # 80000454 <consoleinit>
    printfinit();
    80000f72:	fffff097          	auipc	ra,0xfffff
    80000f76:	5d0080e7          	jalr	1488(ra) # 80000542 <printfinit>
    printf("\n");
    80000f7a:	00007517          	auipc	a0,0x7
    80000f7e:	15650513          	addi	a0,a0,342 # 800080d0 <digits+0x88>
    80000f82:	fffff097          	auipc	ra,0xfffff
    80000f86:	6a0080e7          	jalr	1696(ra) # 80000622 <printf>
    printf("xv6 kernel is booting\n");
    80000f8a:	00007517          	auipc	a0,0x7
    80000f8e:	11e50513          	addi	a0,a0,286 # 800080a8 <digits+0x60>
    80000f92:	fffff097          	auipc	ra,0xfffff
    80000f96:	690080e7          	jalr	1680(ra) # 80000622 <printf>
    printf("\n");
    80000f9a:	00007517          	auipc	a0,0x7
    80000f9e:	13650513          	addi	a0,a0,310 # 800080d0 <digits+0x88>
    80000fa2:	fffff097          	auipc	ra,0xfffff
    80000fa6:	680080e7          	jalr	1664(ra) # 80000622 <printf>
    kinit();         // physical page allocator
    80000faa:	00000097          	auipc	ra,0x0
    80000fae:	b8c080e7          	jalr	-1140(ra) # 80000b36 <kinit>
    kvminit();       // create kernel page table
    80000fb2:	00000097          	auipc	ra,0x0
    80000fb6:	2a0080e7          	jalr	672(ra) # 80001252 <kvminit>
    kvminithart();   // turn on paging
    80000fba:	00000097          	auipc	ra,0x0
    80000fbe:	068080e7          	jalr	104(ra) # 80001022 <kvminithart>
    procinit();      // process table
    80000fc2:	00001097          	auipc	ra,0x1
    80000fc6:	970080e7          	jalr	-1680(ra) # 80001932 <procinit>
    trapinit();      // trap vectors
    80000fca:	00001097          	auipc	ra,0x1
    80000fce:	6a2080e7          	jalr	1698(ra) # 8000266c <trapinit>
    trapinithart();  // install kernel trap vector
    80000fd2:	00001097          	auipc	ra,0x1
    80000fd6:	6c2080e7          	jalr	1730(ra) # 80002694 <trapinithart>
    plicinit();      // set up interrupt controller
    80000fda:	00005097          	auipc	ra,0x5
    80000fde:	d10080e7          	jalr	-752(ra) # 80005cea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fe2:	00005097          	auipc	ra,0x5
    80000fe6:	d1e080e7          	jalr	-738(ra) # 80005d00 <plicinithart>
    binit();         // buffer cache
    80000fea:	00002097          	auipc	ra,0x2
    80000fee:	ec6080e7          	jalr	-314(ra) # 80002eb0 <binit>
    iinit();         // inode cache
    80000ff2:	00002097          	auipc	ra,0x2
    80000ff6:	556080e7          	jalr	1366(ra) # 80003548 <iinit>
    fileinit();      // file table
    80000ffa:	00003097          	auipc	ra,0x3
    80000ffe:	4f0080e7          	jalr	1264(ra) # 800044ea <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001002:	00005097          	auipc	ra,0x5
    80001006:	e06080e7          	jalr	-506(ra) # 80005e08 <virtio_disk_init>
    userinit();      // first user process
    8000100a:	00001097          	auipc	ra,0x1
    8000100e:	cfe080e7          	jalr	-770(ra) # 80001d08 <userinit>
    __sync_synchronize();
    80001012:	0ff0000f          	fence
    started = 1;
    80001016:	4785                	li	a5,1
    80001018:	00008717          	auipc	a4,0x8
    8000101c:	fef72a23          	sw	a5,-12(a4) # 8000900c <started>
    80001020:	b789                	j	80000f62 <main+0x56>

0000000080001022 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001022:	1141                	addi	sp,sp,-16
    80001024:	e422                	sd	s0,8(sp)
    80001026:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80001028:	00008797          	auipc	a5,0x8
    8000102c:	fe87b783          	ld	a5,-24(a5) # 80009010 <kernel_pagetable>
    80001030:	83b1                	srli	a5,a5,0xc
    80001032:	577d                	li	a4,-1
    80001034:	177e                	slli	a4,a4,0x3f
    80001036:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001038:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000103c:	12000073          	sfence.vma
  sfence_vma();
}
    80001040:	6422                	ld	s0,8(sp)
    80001042:	0141                	addi	sp,sp,16
    80001044:	8082                	ret

0000000080001046 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001046:	7139                	addi	sp,sp,-64
    80001048:	fc06                	sd	ra,56(sp)
    8000104a:	f822                	sd	s0,48(sp)
    8000104c:	f426                	sd	s1,40(sp)
    8000104e:	f04a                	sd	s2,32(sp)
    80001050:	ec4e                	sd	s3,24(sp)
    80001052:	e852                	sd	s4,16(sp)
    80001054:	e456                	sd	s5,8(sp)
    80001056:	e05a                	sd	s6,0(sp)
    80001058:	0080                	addi	s0,sp,64
    8000105a:	84aa                	mv	s1,a0
    8000105c:	89ae                	mv	s3,a1
    8000105e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001060:	57fd                	li	a5,-1
    80001062:	83e9                	srli	a5,a5,0x1a
    80001064:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001066:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001068:	04b7f263          	bgeu	a5,a1,800010ac <walk+0x66>
    panic("walk");
    8000106c:	00007517          	auipc	a0,0x7
    80001070:	06c50513          	addi	a0,a0,108 # 800080d8 <digits+0x90>
    80001074:	fffff097          	auipc	ra,0xfffff
    80001078:	55c080e7          	jalr	1372(ra) # 800005d0 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000107c:	060a8663          	beqz	s5,800010e8 <walk+0xa2>
    80001080:	00000097          	auipc	ra,0x0
    80001084:	af2080e7          	jalr	-1294(ra) # 80000b72 <kalloc>
    80001088:	84aa                	mv	s1,a0
    8000108a:	c529                	beqz	a0,800010d4 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000108c:	6605                	lui	a2,0x1
    8000108e:	4581                	li	a1,0
    80001090:	00000097          	auipc	ra,0x0
    80001094:	cce080e7          	jalr	-818(ra) # 80000d5e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001098:	00c4d793          	srli	a5,s1,0xc
    8000109c:	07aa                	slli	a5,a5,0xa
    8000109e:	0017e793          	ori	a5,a5,1
    800010a2:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800010a6:	3a5d                	addiw	s4,s4,-9
    800010a8:	036a0063          	beq	s4,s6,800010c8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800010ac:	0149d933          	srl	s2,s3,s4
    800010b0:	1ff97913          	andi	s2,s2,511
    800010b4:	090e                	slli	s2,s2,0x3
    800010b6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800010b8:	00093483          	ld	s1,0(s2)
    800010bc:	0014f793          	andi	a5,s1,1
    800010c0:	dfd5                	beqz	a5,8000107c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010c2:	80a9                	srli	s1,s1,0xa
    800010c4:	04b2                	slli	s1,s1,0xc
    800010c6:	b7c5                	j	800010a6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800010c8:	00c9d513          	srli	a0,s3,0xc
    800010cc:	1ff57513          	andi	a0,a0,511
    800010d0:	050e                	slli	a0,a0,0x3
    800010d2:	9526                	add	a0,a0,s1
}
    800010d4:	70e2                	ld	ra,56(sp)
    800010d6:	7442                	ld	s0,48(sp)
    800010d8:	74a2                	ld	s1,40(sp)
    800010da:	7902                	ld	s2,32(sp)
    800010dc:	69e2                	ld	s3,24(sp)
    800010de:	6a42                	ld	s4,16(sp)
    800010e0:	6aa2                	ld	s5,8(sp)
    800010e2:	6b02                	ld	s6,0(sp)
    800010e4:	6121                	addi	sp,sp,64
    800010e6:	8082                	ret
        return 0;
    800010e8:	4501                	li	a0,0
    800010ea:	b7ed                	j	800010d4 <walk+0x8e>

00000000800010ec <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010ec:	57fd                	li	a5,-1
    800010ee:	83e9                	srli	a5,a5,0x1a
    800010f0:	00b7f463          	bgeu	a5,a1,800010f8 <walkaddr+0xc>
    return 0;
    800010f4:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010f6:	8082                	ret
{
    800010f8:	1141                	addi	sp,sp,-16
    800010fa:	e406                	sd	ra,8(sp)
    800010fc:	e022                	sd	s0,0(sp)
    800010fe:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001100:	4601                	li	a2,0
    80001102:	00000097          	auipc	ra,0x0
    80001106:	f44080e7          	jalr	-188(ra) # 80001046 <walk>
  if(pte == 0)
    8000110a:	c105                	beqz	a0,8000112a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000110c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000110e:	0117f693          	andi	a3,a5,17
    80001112:	4745                	li	a4,17
    return 0;
    80001114:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001116:	00e68663          	beq	a3,a4,80001122 <walkaddr+0x36>
}
    8000111a:	60a2                	ld	ra,8(sp)
    8000111c:	6402                	ld	s0,0(sp)
    8000111e:	0141                	addi	sp,sp,16
    80001120:	8082                	ret
  pa = PTE2PA(*pte);
    80001122:	00a7d513          	srli	a0,a5,0xa
    80001126:	0532                	slli	a0,a0,0xc
  return pa;
    80001128:	bfcd                	j	8000111a <walkaddr+0x2e>
    return 0;
    8000112a:	4501                	li	a0,0
    8000112c:	b7fd                	j	8000111a <walkaddr+0x2e>

000000008000112e <kvmpa>:
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64
kvmpa(uint64 va)
{
    8000112e:	1101                	addi	sp,sp,-32
    80001130:	ec06                	sd	ra,24(sp)
    80001132:	e822                	sd	s0,16(sp)
    80001134:	e426                	sd	s1,8(sp)
    80001136:	1000                	addi	s0,sp,32
    80001138:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    8000113a:	1552                	slli	a0,a0,0x34
    8000113c:	03455493          	srli	s1,a0,0x34
  pte_t *pte;
  uint64 pa;
  
  pte = walk(kernel_pagetable, va, 0);
    80001140:	4601                	li	a2,0
    80001142:	00008517          	auipc	a0,0x8
    80001146:	ece53503          	ld	a0,-306(a0) # 80009010 <kernel_pagetable>
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	efc080e7          	jalr	-260(ra) # 80001046 <walk>
  if(pte == 0)
    80001152:	cd09                	beqz	a0,8000116c <kvmpa+0x3e>
    panic("kvmpa");
  if((*pte & PTE_V) == 0)
    80001154:	6108                	ld	a0,0(a0)
    80001156:	00157793          	andi	a5,a0,1
    8000115a:	c38d                	beqz	a5,8000117c <kvmpa+0x4e>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    8000115c:	8129                	srli	a0,a0,0xa
    8000115e:	0532                	slli	a0,a0,0xc
  return pa+off;
}
    80001160:	9526                	add	a0,a0,s1
    80001162:	60e2                	ld	ra,24(sp)
    80001164:	6442                	ld	s0,16(sp)
    80001166:	64a2                	ld	s1,8(sp)
    80001168:	6105                	addi	sp,sp,32
    8000116a:	8082                	ret
    panic("kvmpa");
    8000116c:	00007517          	auipc	a0,0x7
    80001170:	f7450513          	addi	a0,a0,-140 # 800080e0 <digits+0x98>
    80001174:	fffff097          	auipc	ra,0xfffff
    80001178:	45c080e7          	jalr	1116(ra) # 800005d0 <panic>
    panic("kvmpa");
    8000117c:	00007517          	auipc	a0,0x7
    80001180:	f6450513          	addi	a0,a0,-156 # 800080e0 <digits+0x98>
    80001184:	fffff097          	auipc	ra,0xfffff
    80001188:	44c080e7          	jalr	1100(ra) # 800005d0 <panic>

000000008000118c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000118c:	715d                	addi	sp,sp,-80
    8000118e:	e486                	sd	ra,72(sp)
    80001190:	e0a2                	sd	s0,64(sp)
    80001192:	fc26                	sd	s1,56(sp)
    80001194:	f84a                	sd	s2,48(sp)
    80001196:	f44e                	sd	s3,40(sp)
    80001198:	f052                	sd	s4,32(sp)
    8000119a:	ec56                	sd	s5,24(sp)
    8000119c:	e85a                	sd	s6,16(sp)
    8000119e:	e45e                	sd	s7,8(sp)
    800011a0:	0880                	addi	s0,sp,80
    800011a2:	8aaa                	mv	s5,a0
    800011a4:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800011a6:	777d                	lui	a4,0xfffff
    800011a8:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800011ac:	167d                	addi	a2,a2,-1
    800011ae:	00b609b3          	add	s3,a2,a1
    800011b2:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800011b6:	893e                	mv	s2,a5
    800011b8:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800011bc:	6b85                	lui	s7,0x1
    800011be:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800011c2:	4605                	li	a2,1
    800011c4:	85ca                	mv	a1,s2
    800011c6:	8556                	mv	a0,s5
    800011c8:	00000097          	auipc	ra,0x0
    800011cc:	e7e080e7          	jalr	-386(ra) # 80001046 <walk>
    800011d0:	c51d                	beqz	a0,800011fe <mappages+0x72>
    if(*pte & PTE_V)
    800011d2:	611c                	ld	a5,0(a0)
    800011d4:	8b85                	andi	a5,a5,1
    800011d6:	ef81                	bnez	a5,800011ee <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800011d8:	80b1                	srli	s1,s1,0xc
    800011da:	04aa                	slli	s1,s1,0xa
    800011dc:	0164e4b3          	or	s1,s1,s6
    800011e0:	0014e493          	ori	s1,s1,1
    800011e4:	e104                	sd	s1,0(a0)
    if(a == last)
    800011e6:	03390863          	beq	s2,s3,80001216 <mappages+0x8a>
    a += PGSIZE;
    800011ea:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800011ec:	bfc9                	j	800011be <mappages+0x32>
      panic("remap");
    800011ee:	00007517          	auipc	a0,0x7
    800011f2:	efa50513          	addi	a0,a0,-262 # 800080e8 <digits+0xa0>
    800011f6:	fffff097          	auipc	ra,0xfffff
    800011fa:	3da080e7          	jalr	986(ra) # 800005d0 <panic>
      return -1;
    800011fe:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001200:	60a6                	ld	ra,72(sp)
    80001202:	6406                	ld	s0,64(sp)
    80001204:	74e2                	ld	s1,56(sp)
    80001206:	7942                	ld	s2,48(sp)
    80001208:	79a2                	ld	s3,40(sp)
    8000120a:	7a02                	ld	s4,32(sp)
    8000120c:	6ae2                	ld	s5,24(sp)
    8000120e:	6b42                	ld	s6,16(sp)
    80001210:	6ba2                	ld	s7,8(sp)
    80001212:	6161                	addi	sp,sp,80
    80001214:	8082                	ret
  return 0;
    80001216:	4501                	li	a0,0
    80001218:	b7e5                	j	80001200 <mappages+0x74>

000000008000121a <kvmmap>:
{
    8000121a:	1141                	addi	sp,sp,-16
    8000121c:	e406                	sd	ra,8(sp)
    8000121e:	e022                	sd	s0,0(sp)
    80001220:	0800                	addi	s0,sp,16
    80001222:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    80001224:	86ae                	mv	a3,a1
    80001226:	85aa                	mv	a1,a0
    80001228:	00008517          	auipc	a0,0x8
    8000122c:	de853503          	ld	a0,-536(a0) # 80009010 <kernel_pagetable>
    80001230:	00000097          	auipc	ra,0x0
    80001234:	f5c080e7          	jalr	-164(ra) # 8000118c <mappages>
    80001238:	e509                	bnez	a0,80001242 <kvmmap+0x28>
}
    8000123a:	60a2                	ld	ra,8(sp)
    8000123c:	6402                	ld	s0,0(sp)
    8000123e:	0141                	addi	sp,sp,16
    80001240:	8082                	ret
    panic("kvmmap");
    80001242:	00007517          	auipc	a0,0x7
    80001246:	eae50513          	addi	a0,a0,-338 # 800080f0 <digits+0xa8>
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	386080e7          	jalr	902(ra) # 800005d0 <panic>

0000000080001252 <kvminit>:
{
    80001252:	1101                	addi	sp,sp,-32
    80001254:	ec06                	sd	ra,24(sp)
    80001256:	e822                	sd	s0,16(sp)
    80001258:	e426                	sd	s1,8(sp)
    8000125a:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    8000125c:	00000097          	auipc	ra,0x0
    80001260:	916080e7          	jalr	-1770(ra) # 80000b72 <kalloc>
    80001264:	00008797          	auipc	a5,0x8
    80001268:	daa7b623          	sd	a0,-596(a5) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    8000126c:	6605                	lui	a2,0x1
    8000126e:	4581                	li	a1,0
    80001270:	00000097          	auipc	ra,0x0
    80001274:	aee080e7          	jalr	-1298(ra) # 80000d5e <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001278:	4699                	li	a3,6
    8000127a:	6605                	lui	a2,0x1
    8000127c:	100005b7          	lui	a1,0x10000
    80001280:	10000537          	lui	a0,0x10000
    80001284:	00000097          	auipc	ra,0x0
    80001288:	f96080e7          	jalr	-106(ra) # 8000121a <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000128c:	4699                	li	a3,6
    8000128e:	6605                	lui	a2,0x1
    80001290:	100015b7          	lui	a1,0x10001
    80001294:	10001537          	lui	a0,0x10001
    80001298:	00000097          	auipc	ra,0x0
    8000129c:	f82080e7          	jalr	-126(ra) # 8000121a <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    800012a0:	4699                	li	a3,6
    800012a2:	6641                	lui	a2,0x10
    800012a4:	020005b7          	lui	a1,0x2000
    800012a8:	02000537          	lui	a0,0x2000
    800012ac:	00000097          	auipc	ra,0x0
    800012b0:	f6e080e7          	jalr	-146(ra) # 8000121a <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800012b4:	4699                	li	a3,6
    800012b6:	00400637          	lui	a2,0x400
    800012ba:	0c0005b7          	lui	a1,0xc000
    800012be:	0c000537          	lui	a0,0xc000
    800012c2:	00000097          	auipc	ra,0x0
    800012c6:	f58080e7          	jalr	-168(ra) # 8000121a <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800012ca:	00007497          	auipc	s1,0x7
    800012ce:	d3648493          	addi	s1,s1,-714 # 80008000 <etext>
    800012d2:	46a9                	li	a3,10
    800012d4:	80007617          	auipc	a2,0x80007
    800012d8:	d2c60613          	addi	a2,a2,-724 # 8000 <_entry-0x7fff8000>
    800012dc:	4585                	li	a1,1
    800012de:	05fe                	slli	a1,a1,0x1f
    800012e0:	852e                	mv	a0,a1
    800012e2:	00000097          	auipc	ra,0x0
    800012e6:	f38080e7          	jalr	-200(ra) # 8000121a <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800012ea:	4699                	li	a3,6
    800012ec:	4645                	li	a2,17
    800012ee:	066e                	slli	a2,a2,0x1b
    800012f0:	8e05                	sub	a2,a2,s1
    800012f2:	85a6                	mv	a1,s1
    800012f4:	8526                	mv	a0,s1
    800012f6:	00000097          	auipc	ra,0x0
    800012fa:	f24080e7          	jalr	-220(ra) # 8000121a <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800012fe:	46a9                	li	a3,10
    80001300:	6605                	lui	a2,0x1
    80001302:	00006597          	auipc	a1,0x6
    80001306:	cfe58593          	addi	a1,a1,-770 # 80007000 <_trampoline>
    8000130a:	04000537          	lui	a0,0x4000
    8000130e:	157d                	addi	a0,a0,-1
    80001310:	0532                	slli	a0,a0,0xc
    80001312:	00000097          	auipc	ra,0x0
    80001316:	f08080e7          	jalr	-248(ra) # 8000121a <kvmmap>
}
    8000131a:	60e2                	ld	ra,24(sp)
    8000131c:	6442                	ld	s0,16(sp)
    8000131e:	64a2                	ld	s1,8(sp)
    80001320:	6105                	addi	sp,sp,32
    80001322:	8082                	ret

0000000080001324 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001324:	715d                	addi	sp,sp,-80
    80001326:	e486                	sd	ra,72(sp)
    80001328:	e0a2                	sd	s0,64(sp)
    8000132a:	fc26                	sd	s1,56(sp)
    8000132c:	f84a                	sd	s2,48(sp)
    8000132e:	f44e                	sd	s3,40(sp)
    80001330:	f052                	sd	s4,32(sp)
    80001332:	ec56                	sd	s5,24(sp)
    80001334:	e85a                	sd	s6,16(sp)
    80001336:	e45e                	sd	s7,8(sp)
    80001338:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000133a:	03459793          	slli	a5,a1,0x34
    8000133e:	e795                	bnez	a5,8000136a <uvmunmap+0x46>
    80001340:	8a2a                	mv	s4,a0
    80001342:	892e                	mv	s2,a1
    80001344:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001346:	0632                	slli	a2,a2,0xc
    80001348:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000134c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000134e:	6b05                	lui	s6,0x1
    80001350:	0735e263          	bltu	a1,s3,800013b4 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001354:	60a6                	ld	ra,72(sp)
    80001356:	6406                	ld	s0,64(sp)
    80001358:	74e2                	ld	s1,56(sp)
    8000135a:	7942                	ld	s2,48(sp)
    8000135c:	79a2                	ld	s3,40(sp)
    8000135e:	7a02                	ld	s4,32(sp)
    80001360:	6ae2                	ld	s5,24(sp)
    80001362:	6b42                	ld	s6,16(sp)
    80001364:	6ba2                	ld	s7,8(sp)
    80001366:	6161                	addi	sp,sp,80
    80001368:	8082                	ret
    panic("uvmunmap: not aligned");
    8000136a:	00007517          	auipc	a0,0x7
    8000136e:	d8e50513          	addi	a0,a0,-626 # 800080f8 <digits+0xb0>
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	25e080e7          	jalr	606(ra) # 800005d0 <panic>
      panic("uvmunmap: walk");
    8000137a:	00007517          	auipc	a0,0x7
    8000137e:	d9650513          	addi	a0,a0,-618 # 80008110 <digits+0xc8>
    80001382:	fffff097          	auipc	ra,0xfffff
    80001386:	24e080e7          	jalr	590(ra) # 800005d0 <panic>
      panic("uvmunmap: not mapped");
    8000138a:	00007517          	auipc	a0,0x7
    8000138e:	d9650513          	addi	a0,a0,-618 # 80008120 <digits+0xd8>
    80001392:	fffff097          	auipc	ra,0xfffff
    80001396:	23e080e7          	jalr	574(ra) # 800005d0 <panic>
      panic("uvmunmap: not a leaf");
    8000139a:	00007517          	auipc	a0,0x7
    8000139e:	d9e50513          	addi	a0,a0,-610 # 80008138 <digits+0xf0>
    800013a2:	fffff097          	auipc	ra,0xfffff
    800013a6:	22e080e7          	jalr	558(ra) # 800005d0 <panic>
    *pte = 0;
    800013aa:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013ae:	995a                	add	s2,s2,s6
    800013b0:	fb3972e3          	bgeu	s2,s3,80001354 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800013b4:	4601                	li	a2,0
    800013b6:	85ca                	mv	a1,s2
    800013b8:	8552                	mv	a0,s4
    800013ba:	00000097          	auipc	ra,0x0
    800013be:	c8c080e7          	jalr	-884(ra) # 80001046 <walk>
    800013c2:	84aa                	mv	s1,a0
    800013c4:	d95d                	beqz	a0,8000137a <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800013c6:	6108                	ld	a0,0(a0)
    800013c8:	00157793          	andi	a5,a0,1
    800013cc:	dfdd                	beqz	a5,8000138a <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800013ce:	3ff57793          	andi	a5,a0,1023
    800013d2:	fd7784e3          	beq	a5,s7,8000139a <uvmunmap+0x76>
    if(do_free){
    800013d6:	fc0a8ae3          	beqz	s5,800013aa <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800013da:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800013dc:	0532                	slli	a0,a0,0xc
    800013de:	fffff097          	auipc	ra,0xfffff
    800013e2:	698080e7          	jalr	1688(ra) # 80000a76 <kfree>
    800013e6:	b7d1                	j	800013aa <uvmunmap+0x86>

00000000800013e8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013e8:	1101                	addi	sp,sp,-32
    800013ea:	ec06                	sd	ra,24(sp)
    800013ec:	e822                	sd	s0,16(sp)
    800013ee:	e426                	sd	s1,8(sp)
    800013f0:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013f2:	fffff097          	auipc	ra,0xfffff
    800013f6:	780080e7          	jalr	1920(ra) # 80000b72 <kalloc>
    800013fa:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013fc:	c519                	beqz	a0,8000140a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013fe:	6605                	lui	a2,0x1
    80001400:	4581                	li	a1,0
    80001402:	00000097          	auipc	ra,0x0
    80001406:	95c080e7          	jalr	-1700(ra) # 80000d5e <memset>
  return pagetable;
}
    8000140a:	8526                	mv	a0,s1
    8000140c:	60e2                	ld	ra,24(sp)
    8000140e:	6442                	ld	s0,16(sp)
    80001410:	64a2                	ld	s1,8(sp)
    80001412:	6105                	addi	sp,sp,32
    80001414:	8082                	ret

0000000080001416 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001416:	7179                	addi	sp,sp,-48
    80001418:	f406                	sd	ra,40(sp)
    8000141a:	f022                	sd	s0,32(sp)
    8000141c:	ec26                	sd	s1,24(sp)
    8000141e:	e84a                	sd	s2,16(sp)
    80001420:	e44e                	sd	s3,8(sp)
    80001422:	e052                	sd	s4,0(sp)
    80001424:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001426:	6785                	lui	a5,0x1
    80001428:	04f67863          	bgeu	a2,a5,80001478 <uvminit+0x62>
    8000142c:	8a2a                	mv	s4,a0
    8000142e:	89ae                	mv	s3,a1
    80001430:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001432:	fffff097          	auipc	ra,0xfffff
    80001436:	740080e7          	jalr	1856(ra) # 80000b72 <kalloc>
    8000143a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000143c:	6605                	lui	a2,0x1
    8000143e:	4581                	li	a1,0
    80001440:	00000097          	auipc	ra,0x0
    80001444:	91e080e7          	jalr	-1762(ra) # 80000d5e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001448:	4779                	li	a4,30
    8000144a:	86ca                	mv	a3,s2
    8000144c:	6605                	lui	a2,0x1
    8000144e:	4581                	li	a1,0
    80001450:	8552                	mv	a0,s4
    80001452:	00000097          	auipc	ra,0x0
    80001456:	d3a080e7          	jalr	-710(ra) # 8000118c <mappages>
  memmove(mem, src, sz);
    8000145a:	8626                	mv	a2,s1
    8000145c:	85ce                	mv	a1,s3
    8000145e:	854a                	mv	a0,s2
    80001460:	00000097          	auipc	ra,0x0
    80001464:	95a080e7          	jalr	-1702(ra) # 80000dba <memmove>
}
    80001468:	70a2                	ld	ra,40(sp)
    8000146a:	7402                	ld	s0,32(sp)
    8000146c:	64e2                	ld	s1,24(sp)
    8000146e:	6942                	ld	s2,16(sp)
    80001470:	69a2                	ld	s3,8(sp)
    80001472:	6a02                	ld	s4,0(sp)
    80001474:	6145                	addi	sp,sp,48
    80001476:	8082                	ret
    panic("inituvm: more than a page");
    80001478:	00007517          	auipc	a0,0x7
    8000147c:	cd850513          	addi	a0,a0,-808 # 80008150 <digits+0x108>
    80001480:	fffff097          	auipc	ra,0xfffff
    80001484:	150080e7          	jalr	336(ra) # 800005d0 <panic>

0000000080001488 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001488:	1101                	addi	sp,sp,-32
    8000148a:	ec06                	sd	ra,24(sp)
    8000148c:	e822                	sd	s0,16(sp)
    8000148e:	e426                	sd	s1,8(sp)
    80001490:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001492:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001494:	00b67d63          	bgeu	a2,a1,800014ae <uvmdealloc+0x26>
    80001498:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000149a:	6785                	lui	a5,0x1
    8000149c:	17fd                	addi	a5,a5,-1
    8000149e:	00f60733          	add	a4,a2,a5
    800014a2:	767d                	lui	a2,0xfffff
    800014a4:	8f71                	and	a4,a4,a2
    800014a6:	97ae                	add	a5,a5,a1
    800014a8:	8ff1                	and	a5,a5,a2
    800014aa:	00f76863          	bltu	a4,a5,800014ba <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800014ae:	8526                	mv	a0,s1
    800014b0:	60e2                	ld	ra,24(sp)
    800014b2:	6442                	ld	s0,16(sp)
    800014b4:	64a2                	ld	s1,8(sp)
    800014b6:	6105                	addi	sp,sp,32
    800014b8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800014ba:	8f99                	sub	a5,a5,a4
    800014bc:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014be:	4685                	li	a3,1
    800014c0:	0007861b          	sext.w	a2,a5
    800014c4:	85ba                	mv	a1,a4
    800014c6:	00000097          	auipc	ra,0x0
    800014ca:	e5e080e7          	jalr	-418(ra) # 80001324 <uvmunmap>
    800014ce:	b7c5                	j	800014ae <uvmdealloc+0x26>

00000000800014d0 <uvmalloc>:
  if(newsz < oldsz)
    800014d0:	0ab66163          	bltu	a2,a1,80001572 <uvmalloc+0xa2>
{
    800014d4:	7139                	addi	sp,sp,-64
    800014d6:	fc06                	sd	ra,56(sp)
    800014d8:	f822                	sd	s0,48(sp)
    800014da:	f426                	sd	s1,40(sp)
    800014dc:	f04a                	sd	s2,32(sp)
    800014de:	ec4e                	sd	s3,24(sp)
    800014e0:	e852                	sd	s4,16(sp)
    800014e2:	e456                	sd	s5,8(sp)
    800014e4:	0080                	addi	s0,sp,64
    800014e6:	8aaa                	mv	s5,a0
    800014e8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800014ea:	6985                	lui	s3,0x1
    800014ec:	19fd                	addi	s3,s3,-1
    800014ee:	95ce                	add	a1,a1,s3
    800014f0:	79fd                	lui	s3,0xfffff
    800014f2:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014f6:	08c9f063          	bgeu	s3,a2,80001576 <uvmalloc+0xa6>
    800014fa:	894e                	mv	s2,s3
    mem = kalloc();
    800014fc:	fffff097          	auipc	ra,0xfffff
    80001500:	676080e7          	jalr	1654(ra) # 80000b72 <kalloc>
    80001504:	84aa                	mv	s1,a0
    if(mem == 0){
    80001506:	c51d                	beqz	a0,80001534 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001508:	6605                	lui	a2,0x1
    8000150a:	4581                	li	a1,0
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	852080e7          	jalr	-1966(ra) # 80000d5e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001514:	4779                	li	a4,30
    80001516:	86a6                	mv	a3,s1
    80001518:	6605                	lui	a2,0x1
    8000151a:	85ca                	mv	a1,s2
    8000151c:	8556                	mv	a0,s5
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	c6e080e7          	jalr	-914(ra) # 8000118c <mappages>
    80001526:	e905                	bnez	a0,80001556 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001528:	6785                	lui	a5,0x1
    8000152a:	993e                	add	s2,s2,a5
    8000152c:	fd4968e3          	bltu	s2,s4,800014fc <uvmalloc+0x2c>
  return newsz;
    80001530:	8552                	mv	a0,s4
    80001532:	a809                	j	80001544 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001534:	864e                	mv	a2,s3
    80001536:	85ca                	mv	a1,s2
    80001538:	8556                	mv	a0,s5
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	f4e080e7          	jalr	-178(ra) # 80001488 <uvmdealloc>
      return 0;
    80001542:	4501                	li	a0,0
}
    80001544:	70e2                	ld	ra,56(sp)
    80001546:	7442                	ld	s0,48(sp)
    80001548:	74a2                	ld	s1,40(sp)
    8000154a:	7902                	ld	s2,32(sp)
    8000154c:	69e2                	ld	s3,24(sp)
    8000154e:	6a42                	ld	s4,16(sp)
    80001550:	6aa2                	ld	s5,8(sp)
    80001552:	6121                	addi	sp,sp,64
    80001554:	8082                	ret
      kfree(mem);
    80001556:	8526                	mv	a0,s1
    80001558:	fffff097          	auipc	ra,0xfffff
    8000155c:	51e080e7          	jalr	1310(ra) # 80000a76 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001560:	864e                	mv	a2,s3
    80001562:	85ca                	mv	a1,s2
    80001564:	8556                	mv	a0,s5
    80001566:	00000097          	auipc	ra,0x0
    8000156a:	f22080e7          	jalr	-222(ra) # 80001488 <uvmdealloc>
      return 0;
    8000156e:	4501                	li	a0,0
    80001570:	bfd1                	j	80001544 <uvmalloc+0x74>
    return oldsz;
    80001572:	852e                	mv	a0,a1
}
    80001574:	8082                	ret
  return newsz;
    80001576:	8532                	mv	a0,a2
    80001578:	b7f1                	j	80001544 <uvmalloc+0x74>

000000008000157a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000157a:	7179                	addi	sp,sp,-48
    8000157c:	f406                	sd	ra,40(sp)
    8000157e:	f022                	sd	s0,32(sp)
    80001580:	ec26                	sd	s1,24(sp)
    80001582:	e84a                	sd	s2,16(sp)
    80001584:	e44e                	sd	s3,8(sp)
    80001586:	e052                	sd	s4,0(sp)
    80001588:	1800                	addi	s0,sp,48
    8000158a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000158c:	84aa                	mv	s1,a0
    8000158e:	6905                	lui	s2,0x1
    80001590:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001592:	4985                	li	s3,1
    80001594:	a821                	j	800015ac <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001596:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80001598:	0532                	slli	a0,a0,0xc
    8000159a:	00000097          	auipc	ra,0x0
    8000159e:	fe0080e7          	jalr	-32(ra) # 8000157a <freewalk>
      pagetable[i] = 0;
    800015a2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800015a6:	04a1                	addi	s1,s1,8
    800015a8:	03248163          	beq	s1,s2,800015ca <freewalk+0x50>
    pte_t pte = pagetable[i];
    800015ac:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015ae:	00f57793          	andi	a5,a0,15
    800015b2:	ff3782e3          	beq	a5,s3,80001596 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800015b6:	8905                	andi	a0,a0,1
    800015b8:	d57d                	beqz	a0,800015a6 <freewalk+0x2c>
      panic("freewalk: leaf");
    800015ba:	00007517          	auipc	a0,0x7
    800015be:	bb650513          	addi	a0,a0,-1098 # 80008170 <digits+0x128>
    800015c2:	fffff097          	auipc	ra,0xfffff
    800015c6:	00e080e7          	jalr	14(ra) # 800005d0 <panic>
    }
  }
  kfree((void*)pagetable);
    800015ca:	8552                	mv	a0,s4
    800015cc:	fffff097          	auipc	ra,0xfffff
    800015d0:	4aa080e7          	jalr	1194(ra) # 80000a76 <kfree>
}
    800015d4:	70a2                	ld	ra,40(sp)
    800015d6:	7402                	ld	s0,32(sp)
    800015d8:	64e2                	ld	s1,24(sp)
    800015da:	6942                	ld	s2,16(sp)
    800015dc:	69a2                	ld	s3,8(sp)
    800015de:	6a02                	ld	s4,0(sp)
    800015e0:	6145                	addi	sp,sp,48
    800015e2:	8082                	ret

00000000800015e4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015e4:	1101                	addi	sp,sp,-32
    800015e6:	ec06                	sd	ra,24(sp)
    800015e8:	e822                	sd	s0,16(sp)
    800015ea:	e426                	sd	s1,8(sp)
    800015ec:	1000                	addi	s0,sp,32
    800015ee:	84aa                	mv	s1,a0
  if(sz > 0)
    800015f0:	e999                	bnez	a1,80001606 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015f2:	8526                	mv	a0,s1
    800015f4:	00000097          	auipc	ra,0x0
    800015f8:	f86080e7          	jalr	-122(ra) # 8000157a <freewalk>
}
    800015fc:	60e2                	ld	ra,24(sp)
    800015fe:	6442                	ld	s0,16(sp)
    80001600:	64a2                	ld	s1,8(sp)
    80001602:	6105                	addi	sp,sp,32
    80001604:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001606:	6605                	lui	a2,0x1
    80001608:	167d                	addi	a2,a2,-1
    8000160a:	962e                	add	a2,a2,a1
    8000160c:	4685                	li	a3,1
    8000160e:	8231                	srli	a2,a2,0xc
    80001610:	4581                	li	a1,0
    80001612:	00000097          	auipc	ra,0x0
    80001616:	d12080e7          	jalr	-750(ra) # 80001324 <uvmunmap>
    8000161a:	bfe1                	j	800015f2 <uvmfree+0xe>

000000008000161c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000161c:	c679                	beqz	a2,800016ea <uvmcopy+0xce>
{
    8000161e:	715d                	addi	sp,sp,-80
    80001620:	e486                	sd	ra,72(sp)
    80001622:	e0a2                	sd	s0,64(sp)
    80001624:	fc26                	sd	s1,56(sp)
    80001626:	f84a                	sd	s2,48(sp)
    80001628:	f44e                	sd	s3,40(sp)
    8000162a:	f052                	sd	s4,32(sp)
    8000162c:	ec56                	sd	s5,24(sp)
    8000162e:	e85a                	sd	s6,16(sp)
    80001630:	e45e                	sd	s7,8(sp)
    80001632:	0880                	addi	s0,sp,80
    80001634:	8b2a                	mv	s6,a0
    80001636:	8aae                	mv	s5,a1
    80001638:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000163a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000163c:	4601                	li	a2,0
    8000163e:	85ce                	mv	a1,s3
    80001640:	855a                	mv	a0,s6
    80001642:	00000097          	auipc	ra,0x0
    80001646:	a04080e7          	jalr	-1532(ra) # 80001046 <walk>
    8000164a:	c531                	beqz	a0,80001696 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000164c:	6118                	ld	a4,0(a0)
    8000164e:	00177793          	andi	a5,a4,1
    80001652:	cbb1                	beqz	a5,800016a6 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001654:	00a75593          	srli	a1,a4,0xa
    80001658:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000165c:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	512080e7          	jalr	1298(ra) # 80000b72 <kalloc>
    80001668:	892a                	mv	s2,a0
    8000166a:	c939                	beqz	a0,800016c0 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000166c:	6605                	lui	a2,0x1
    8000166e:	85de                	mv	a1,s7
    80001670:	fffff097          	auipc	ra,0xfffff
    80001674:	74a080e7          	jalr	1866(ra) # 80000dba <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001678:	8726                	mv	a4,s1
    8000167a:	86ca                	mv	a3,s2
    8000167c:	6605                	lui	a2,0x1
    8000167e:	85ce                	mv	a1,s3
    80001680:	8556                	mv	a0,s5
    80001682:	00000097          	auipc	ra,0x0
    80001686:	b0a080e7          	jalr	-1270(ra) # 8000118c <mappages>
    8000168a:	e515                	bnez	a0,800016b6 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    8000168c:	6785                	lui	a5,0x1
    8000168e:	99be                	add	s3,s3,a5
    80001690:	fb49e6e3          	bltu	s3,s4,8000163c <uvmcopy+0x20>
    80001694:	a081                	j	800016d4 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001696:	00007517          	auipc	a0,0x7
    8000169a:	aea50513          	addi	a0,a0,-1302 # 80008180 <digits+0x138>
    8000169e:	fffff097          	auipc	ra,0xfffff
    800016a2:	f32080e7          	jalr	-206(ra) # 800005d0 <panic>
      panic("uvmcopy: page not present");
    800016a6:	00007517          	auipc	a0,0x7
    800016aa:	afa50513          	addi	a0,a0,-1286 # 800081a0 <digits+0x158>
    800016ae:	fffff097          	auipc	ra,0xfffff
    800016b2:	f22080e7          	jalr	-222(ra) # 800005d0 <panic>
      kfree(mem);
    800016b6:	854a                	mv	a0,s2
    800016b8:	fffff097          	auipc	ra,0xfffff
    800016bc:	3be080e7          	jalr	958(ra) # 80000a76 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016c0:	4685                	li	a3,1
    800016c2:	00c9d613          	srli	a2,s3,0xc
    800016c6:	4581                	li	a1,0
    800016c8:	8556                	mv	a0,s5
    800016ca:	00000097          	auipc	ra,0x0
    800016ce:	c5a080e7          	jalr	-934(ra) # 80001324 <uvmunmap>
  return -1;
    800016d2:	557d                	li	a0,-1
}
    800016d4:	60a6                	ld	ra,72(sp)
    800016d6:	6406                	ld	s0,64(sp)
    800016d8:	74e2                	ld	s1,56(sp)
    800016da:	7942                	ld	s2,48(sp)
    800016dc:	79a2                	ld	s3,40(sp)
    800016de:	7a02                	ld	s4,32(sp)
    800016e0:	6ae2                	ld	s5,24(sp)
    800016e2:	6b42                	ld	s6,16(sp)
    800016e4:	6ba2                	ld	s7,8(sp)
    800016e6:	6161                	addi	sp,sp,80
    800016e8:	8082                	ret
  return 0;
    800016ea:	4501                	li	a0,0
}
    800016ec:	8082                	ret

00000000800016ee <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016ee:	1141                	addi	sp,sp,-16
    800016f0:	e406                	sd	ra,8(sp)
    800016f2:	e022                	sd	s0,0(sp)
    800016f4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016f6:	4601                	li	a2,0
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	94e080e7          	jalr	-1714(ra) # 80001046 <walk>
  if(pte == 0)
    80001700:	c901                	beqz	a0,80001710 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001702:	611c                	ld	a5,0(a0)
    80001704:	9bbd                	andi	a5,a5,-17
    80001706:	e11c                	sd	a5,0(a0)
}
    80001708:	60a2                	ld	ra,8(sp)
    8000170a:	6402                	ld	s0,0(sp)
    8000170c:	0141                	addi	sp,sp,16
    8000170e:	8082                	ret
    panic("uvmclear");
    80001710:	00007517          	auipc	a0,0x7
    80001714:	ab050513          	addi	a0,a0,-1360 # 800081c0 <digits+0x178>
    80001718:	fffff097          	auipc	ra,0xfffff
    8000171c:	eb8080e7          	jalr	-328(ra) # 800005d0 <panic>

0000000080001720 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001720:	c6bd                	beqz	a3,8000178e <copyout+0x6e>
{
    80001722:	715d                	addi	sp,sp,-80
    80001724:	e486                	sd	ra,72(sp)
    80001726:	e0a2                	sd	s0,64(sp)
    80001728:	fc26                	sd	s1,56(sp)
    8000172a:	f84a                	sd	s2,48(sp)
    8000172c:	f44e                	sd	s3,40(sp)
    8000172e:	f052                	sd	s4,32(sp)
    80001730:	ec56                	sd	s5,24(sp)
    80001732:	e85a                	sd	s6,16(sp)
    80001734:	e45e                	sd	s7,8(sp)
    80001736:	e062                	sd	s8,0(sp)
    80001738:	0880                	addi	s0,sp,80
    8000173a:	8b2a                	mv	s6,a0
    8000173c:	8c2e                	mv	s8,a1
    8000173e:	8a32                	mv	s4,a2
    80001740:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001742:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001744:	6a85                	lui	s5,0x1
    80001746:	a015                	j	8000176a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001748:	9562                	add	a0,a0,s8
    8000174a:	0004861b          	sext.w	a2,s1
    8000174e:	85d2                	mv	a1,s4
    80001750:	41250533          	sub	a0,a0,s2
    80001754:	fffff097          	auipc	ra,0xfffff
    80001758:	666080e7          	jalr	1638(ra) # 80000dba <memmove>

    len -= n;
    8000175c:	409989b3          	sub	s3,s3,s1
    src += n;
    80001760:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001762:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001766:	02098263          	beqz	s3,8000178a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000176a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000176e:	85ca                	mv	a1,s2
    80001770:	855a                	mv	a0,s6
    80001772:	00000097          	auipc	ra,0x0
    80001776:	97a080e7          	jalr	-1670(ra) # 800010ec <walkaddr>
    if(pa0 == 0)
    8000177a:	cd01                	beqz	a0,80001792 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000177c:	418904b3          	sub	s1,s2,s8
    80001780:	94d6                	add	s1,s1,s5
    if(n > len)
    80001782:	fc99f3e3          	bgeu	s3,s1,80001748 <copyout+0x28>
    80001786:	84ce                	mv	s1,s3
    80001788:	b7c1                	j	80001748 <copyout+0x28>
  }
  return 0;
    8000178a:	4501                	li	a0,0
    8000178c:	a021                	j	80001794 <copyout+0x74>
    8000178e:	4501                	li	a0,0
}
    80001790:	8082                	ret
      return -1;
    80001792:	557d                	li	a0,-1
}
    80001794:	60a6                	ld	ra,72(sp)
    80001796:	6406                	ld	s0,64(sp)
    80001798:	74e2                	ld	s1,56(sp)
    8000179a:	7942                	ld	s2,48(sp)
    8000179c:	79a2                	ld	s3,40(sp)
    8000179e:	7a02                	ld	s4,32(sp)
    800017a0:	6ae2                	ld	s5,24(sp)
    800017a2:	6b42                	ld	s6,16(sp)
    800017a4:	6ba2                	ld	s7,8(sp)
    800017a6:	6c02                	ld	s8,0(sp)
    800017a8:	6161                	addi	sp,sp,80
    800017aa:	8082                	ret

00000000800017ac <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800017ac:	caa5                	beqz	a3,8000181c <copyin+0x70>
{
    800017ae:	715d                	addi	sp,sp,-80
    800017b0:	e486                	sd	ra,72(sp)
    800017b2:	e0a2                	sd	s0,64(sp)
    800017b4:	fc26                	sd	s1,56(sp)
    800017b6:	f84a                	sd	s2,48(sp)
    800017b8:	f44e                	sd	s3,40(sp)
    800017ba:	f052                	sd	s4,32(sp)
    800017bc:	ec56                	sd	s5,24(sp)
    800017be:	e85a                	sd	s6,16(sp)
    800017c0:	e45e                	sd	s7,8(sp)
    800017c2:	e062                	sd	s8,0(sp)
    800017c4:	0880                	addi	s0,sp,80
    800017c6:	8b2a                	mv	s6,a0
    800017c8:	8a2e                	mv	s4,a1
    800017ca:	8c32                	mv	s8,a2
    800017cc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017ce:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017d0:	6a85                	lui	s5,0x1
    800017d2:	a01d                	j	800017f8 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017d4:	018505b3          	add	a1,a0,s8
    800017d8:	0004861b          	sext.w	a2,s1
    800017dc:	412585b3          	sub	a1,a1,s2
    800017e0:	8552                	mv	a0,s4
    800017e2:	fffff097          	auipc	ra,0xfffff
    800017e6:	5d8080e7          	jalr	1496(ra) # 80000dba <memmove>

    len -= n;
    800017ea:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017ee:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017f0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017f4:	02098263          	beqz	s3,80001818 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017f8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017fc:	85ca                	mv	a1,s2
    800017fe:	855a                	mv	a0,s6
    80001800:	00000097          	auipc	ra,0x0
    80001804:	8ec080e7          	jalr	-1812(ra) # 800010ec <walkaddr>
    if(pa0 == 0)
    80001808:	cd01                	beqz	a0,80001820 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000180a:	418904b3          	sub	s1,s2,s8
    8000180e:	94d6                	add	s1,s1,s5
    if(n > len)
    80001810:	fc99f2e3          	bgeu	s3,s1,800017d4 <copyin+0x28>
    80001814:	84ce                	mv	s1,s3
    80001816:	bf7d                	j	800017d4 <copyin+0x28>
  }
  return 0;
    80001818:	4501                	li	a0,0
    8000181a:	a021                	j	80001822 <copyin+0x76>
    8000181c:	4501                	li	a0,0
}
    8000181e:	8082                	ret
      return -1;
    80001820:	557d                	li	a0,-1
}
    80001822:	60a6                	ld	ra,72(sp)
    80001824:	6406                	ld	s0,64(sp)
    80001826:	74e2                	ld	s1,56(sp)
    80001828:	7942                	ld	s2,48(sp)
    8000182a:	79a2                	ld	s3,40(sp)
    8000182c:	7a02                	ld	s4,32(sp)
    8000182e:	6ae2                	ld	s5,24(sp)
    80001830:	6b42                	ld	s6,16(sp)
    80001832:	6ba2                	ld	s7,8(sp)
    80001834:	6c02                	ld	s8,0(sp)
    80001836:	6161                	addi	sp,sp,80
    80001838:	8082                	ret

000000008000183a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000183a:	c6c5                	beqz	a3,800018e2 <copyinstr+0xa8>
{
    8000183c:	715d                	addi	sp,sp,-80
    8000183e:	e486                	sd	ra,72(sp)
    80001840:	e0a2                	sd	s0,64(sp)
    80001842:	fc26                	sd	s1,56(sp)
    80001844:	f84a                	sd	s2,48(sp)
    80001846:	f44e                	sd	s3,40(sp)
    80001848:	f052                	sd	s4,32(sp)
    8000184a:	ec56                	sd	s5,24(sp)
    8000184c:	e85a                	sd	s6,16(sp)
    8000184e:	e45e                	sd	s7,8(sp)
    80001850:	0880                	addi	s0,sp,80
    80001852:	8a2a                	mv	s4,a0
    80001854:	8b2e                	mv	s6,a1
    80001856:	8bb2                	mv	s7,a2
    80001858:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000185a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000185c:	6985                	lui	s3,0x1
    8000185e:	a035                	j	8000188a <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001860:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001864:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001866:	0017b793          	seqz	a5,a5
    8000186a:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000186e:	60a6                	ld	ra,72(sp)
    80001870:	6406                	ld	s0,64(sp)
    80001872:	74e2                	ld	s1,56(sp)
    80001874:	7942                	ld	s2,48(sp)
    80001876:	79a2                	ld	s3,40(sp)
    80001878:	7a02                	ld	s4,32(sp)
    8000187a:	6ae2                	ld	s5,24(sp)
    8000187c:	6b42                	ld	s6,16(sp)
    8000187e:	6ba2                	ld	s7,8(sp)
    80001880:	6161                	addi	sp,sp,80
    80001882:	8082                	ret
    srcva = va0 + PGSIZE;
    80001884:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001888:	c8a9                	beqz	s1,800018da <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    8000188a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000188e:	85ca                	mv	a1,s2
    80001890:	8552                	mv	a0,s4
    80001892:	00000097          	auipc	ra,0x0
    80001896:	85a080e7          	jalr	-1958(ra) # 800010ec <walkaddr>
    if(pa0 == 0)
    8000189a:	c131                	beqz	a0,800018de <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    8000189c:	41790833          	sub	a6,s2,s7
    800018a0:	984e                	add	a6,a6,s3
    if(n > max)
    800018a2:	0104f363          	bgeu	s1,a6,800018a8 <copyinstr+0x6e>
    800018a6:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800018a8:	955e                	add	a0,a0,s7
    800018aa:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800018ae:	fc080be3          	beqz	a6,80001884 <copyinstr+0x4a>
    800018b2:	985a                	add	a6,a6,s6
    800018b4:	87da                	mv	a5,s6
      if(*p == '\0'){
    800018b6:	41650633          	sub	a2,a0,s6
    800018ba:	14fd                	addi	s1,s1,-1
    800018bc:	9b26                	add	s6,s6,s1
    800018be:	00f60733          	add	a4,a2,a5
    800018c2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8000>
    800018c6:	df49                	beqz	a4,80001860 <copyinstr+0x26>
        *dst = *p;
    800018c8:	00e78023          	sb	a4,0(a5)
      --max;
    800018cc:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800018d0:	0785                	addi	a5,a5,1
    while(n > 0){
    800018d2:	ff0796e3          	bne	a5,a6,800018be <copyinstr+0x84>
      dst++;
    800018d6:	8b42                	mv	s6,a6
    800018d8:	b775                	j	80001884 <copyinstr+0x4a>
    800018da:	4781                	li	a5,0
    800018dc:	b769                	j	80001866 <copyinstr+0x2c>
      return -1;
    800018de:	557d                	li	a0,-1
    800018e0:	b779                	j	8000186e <copyinstr+0x34>
  int got_null = 0;
    800018e2:	4781                	li	a5,0
  if(got_null){
    800018e4:	0017b793          	seqz	a5,a5
    800018e8:	40f00533          	neg	a0,a5
}
    800018ec:	8082                	ret

00000000800018ee <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    800018ee:	1101                	addi	sp,sp,-32
    800018f0:	ec06                	sd	ra,24(sp)
    800018f2:	e822                	sd	s0,16(sp)
    800018f4:	e426                	sd	s1,8(sp)
    800018f6:	1000                	addi	s0,sp,32
    800018f8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800018fa:	fffff097          	auipc	ra,0xfffff
    800018fe:	2ee080e7          	jalr	750(ra) # 80000be8 <holding>
    80001902:	c909                	beqz	a0,80001914 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001904:	749c                	ld	a5,40(s1)
    80001906:	00978f63          	beq	a5,s1,80001924 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    8000190a:	60e2                	ld	ra,24(sp)
    8000190c:	6442                	ld	s0,16(sp)
    8000190e:	64a2                	ld	s1,8(sp)
    80001910:	6105                	addi	sp,sp,32
    80001912:	8082                	ret
    panic("wakeup1");
    80001914:	00007517          	auipc	a0,0x7
    80001918:	8bc50513          	addi	a0,a0,-1860 # 800081d0 <digits+0x188>
    8000191c:	fffff097          	auipc	ra,0xfffff
    80001920:	cb4080e7          	jalr	-844(ra) # 800005d0 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001924:	4c98                	lw	a4,24(s1)
    80001926:	4785                	li	a5,1
    80001928:	fef711e3          	bne	a4,a5,8000190a <wakeup1+0x1c>
    p->state = RUNNABLE;
    8000192c:	4789                	li	a5,2
    8000192e:	cc9c                	sw	a5,24(s1)
}
    80001930:	bfe9                	j	8000190a <wakeup1+0x1c>

0000000080001932 <procinit>:
{
    80001932:	715d                	addi	sp,sp,-80
    80001934:	e486                	sd	ra,72(sp)
    80001936:	e0a2                	sd	s0,64(sp)
    80001938:	fc26                	sd	s1,56(sp)
    8000193a:	f84a                	sd	s2,48(sp)
    8000193c:	f44e                	sd	s3,40(sp)
    8000193e:	f052                	sd	s4,32(sp)
    80001940:	ec56                	sd	s5,24(sp)
    80001942:	e85a                	sd	s6,16(sp)
    80001944:	e45e                	sd	s7,8(sp)
    80001946:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001948:	00007597          	auipc	a1,0x7
    8000194c:	89058593          	addi	a1,a1,-1904 # 800081d8 <digits+0x190>
    80001950:	00010517          	auipc	a0,0x10
    80001954:	00050513          	mv	a0,a0
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	27a080e7          	jalr	634(ra) # 80000bd2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001960:	00010917          	auipc	s2,0x10
    80001964:	40890913          	addi	s2,s2,1032 # 80011d68 <proc>
      initlock(&p->lock, "proc");
    80001968:	00007b97          	auipc	s7,0x7
    8000196c:	878b8b93          	addi	s7,s7,-1928 # 800081e0 <digits+0x198>
      uint64 va = KSTACK((int) (p - proc));
    80001970:	8b4a                	mv	s6,s2
    80001972:	00006a97          	auipc	s5,0x6
    80001976:	68ea8a93          	addi	s5,s5,1678 # 80008000 <etext>
    8000197a:	040009b7          	lui	s3,0x4000
    8000197e:	19fd                	addi	s3,s3,-1
    80001980:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001982:	00016a17          	auipc	s4,0x16
    80001986:	5e6a0a13          	addi	s4,s4,1510 # 80017f68 <tickslock>
      initlock(&p->lock, "proc");
    8000198a:	85de                	mv	a1,s7
    8000198c:	854a                	mv	a0,s2
    8000198e:	fffff097          	auipc	ra,0xfffff
    80001992:	244080e7          	jalr	580(ra) # 80000bd2 <initlock>
      char *pa = kalloc();
    80001996:	fffff097          	auipc	ra,0xfffff
    8000199a:	1dc080e7          	jalr	476(ra) # 80000b72 <kalloc>
    8000199e:	85aa                	mv	a1,a0
      if(pa == 0)
    800019a0:	c929                	beqz	a0,800019f2 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    800019a2:	416904b3          	sub	s1,s2,s6
    800019a6:	848d                	srai	s1,s1,0x3
    800019a8:	000ab783          	ld	a5,0(s5)
    800019ac:	02f484b3          	mul	s1,s1,a5
    800019b0:	2485                	addiw	s1,s1,1
    800019b2:	00d4949b          	slliw	s1,s1,0xd
    800019b6:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019ba:	4699                	li	a3,6
    800019bc:	6605                	lui	a2,0x1
    800019be:	8526                	mv	a0,s1
    800019c0:	00000097          	auipc	ra,0x0
    800019c4:	85a080e7          	jalr	-1958(ra) # 8000121a <kvmmap>
      p->kstack = va;
    800019c8:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800019cc:	18890913          	addi	s2,s2,392
    800019d0:	fb491de3          	bne	s2,s4,8000198a <procinit+0x58>
  kvminithart();
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	64e080e7          	jalr	1614(ra) # 80001022 <kvminithart>
}
    800019dc:	60a6                	ld	ra,72(sp)
    800019de:	6406                	ld	s0,64(sp)
    800019e0:	74e2                	ld	s1,56(sp)
    800019e2:	7942                	ld	s2,48(sp)
    800019e4:	79a2                	ld	s3,40(sp)
    800019e6:	7a02                	ld	s4,32(sp)
    800019e8:	6ae2                	ld	s5,24(sp)
    800019ea:	6b42                	ld	s6,16(sp)
    800019ec:	6ba2                	ld	s7,8(sp)
    800019ee:	6161                	addi	sp,sp,80
    800019f0:	8082                	ret
        panic("kalloc");
    800019f2:	00006517          	auipc	a0,0x6
    800019f6:	7f650513          	addi	a0,a0,2038 # 800081e8 <digits+0x1a0>
    800019fa:	fffff097          	auipc	ra,0xfffff
    800019fe:	bd6080e7          	jalr	-1066(ra) # 800005d0 <panic>

0000000080001a02 <cpuid>:
{
    80001a02:	1141                	addi	sp,sp,-16
    80001a04:	e422                	sd	s0,8(sp)
    80001a06:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a08:	8512                	mv	a0,tp
}
    80001a0a:	2501                	sext.w	a0,a0
    80001a0c:	6422                	ld	s0,8(sp)
    80001a0e:	0141                	addi	sp,sp,16
    80001a10:	8082                	ret

0000000080001a12 <mycpu>:
mycpu(void) {
    80001a12:	1141                	addi	sp,sp,-16
    80001a14:	e422                	sd	s0,8(sp)
    80001a16:	0800                	addi	s0,sp,16
    80001a18:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001a1a:	2781                	sext.w	a5,a5
    80001a1c:	079e                	slli	a5,a5,0x7
}
    80001a1e:	00010517          	auipc	a0,0x10
    80001a22:	f4a50513          	addi	a0,a0,-182 # 80011968 <cpus>
    80001a26:	953e                	add	a0,a0,a5
    80001a28:	6422                	ld	s0,8(sp)
    80001a2a:	0141                	addi	sp,sp,16
    80001a2c:	8082                	ret

0000000080001a2e <myproc>:
myproc(void) {
    80001a2e:	1101                	addi	sp,sp,-32
    80001a30:	ec06                	sd	ra,24(sp)
    80001a32:	e822                	sd	s0,16(sp)
    80001a34:	e426                	sd	s1,8(sp)
    80001a36:	1000                	addi	s0,sp,32
  push_off();
    80001a38:	fffff097          	auipc	ra,0xfffff
    80001a3c:	1de080e7          	jalr	478(ra) # 80000c16 <push_off>
    80001a40:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001a42:	2781                	sext.w	a5,a5
    80001a44:	079e                	slli	a5,a5,0x7
    80001a46:	00010717          	auipc	a4,0x10
    80001a4a:	f0a70713          	addi	a4,a4,-246 # 80011950 <pid_lock>
    80001a4e:	97ba                	add	a5,a5,a4
    80001a50:	6f84                	ld	s1,24(a5)
  pop_off();
    80001a52:	fffff097          	auipc	ra,0xfffff
    80001a56:	264080e7          	jalr	612(ra) # 80000cb6 <pop_off>
}
    80001a5a:	8526                	mv	a0,s1
    80001a5c:	60e2                	ld	ra,24(sp)
    80001a5e:	6442                	ld	s0,16(sp)
    80001a60:	64a2                	ld	s1,8(sp)
    80001a62:	6105                	addi	sp,sp,32
    80001a64:	8082                	ret

0000000080001a66 <forkret>:
{
    80001a66:	1141                	addi	sp,sp,-16
    80001a68:	e406                	sd	ra,8(sp)
    80001a6a:	e022                	sd	s0,0(sp)
    80001a6c:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001a6e:	00000097          	auipc	ra,0x0
    80001a72:	fc0080e7          	jalr	-64(ra) # 80001a2e <myproc>
    80001a76:	fffff097          	auipc	ra,0xfffff
    80001a7a:	2a0080e7          	jalr	672(ra) # 80000d16 <release>
  if (first) {
    80001a7e:	00007797          	auipc	a5,0x7
    80001a82:	db27a783          	lw	a5,-590(a5) # 80008830 <first.1>
    80001a86:	eb89                	bnez	a5,80001a98 <forkret+0x32>
  usertrapret();
    80001a88:	00001097          	auipc	ra,0x1
    80001a8c:	c24080e7          	jalr	-988(ra) # 800026ac <usertrapret>
}
    80001a90:	60a2                	ld	ra,8(sp)
    80001a92:	6402                	ld	s0,0(sp)
    80001a94:	0141                	addi	sp,sp,16
    80001a96:	8082                	ret
    first = 0;
    80001a98:	00007797          	auipc	a5,0x7
    80001a9c:	d807ac23          	sw	zero,-616(a5) # 80008830 <first.1>
    fsinit(ROOTDEV);
    80001aa0:	4505                	li	a0,1
    80001aa2:	00002097          	auipc	ra,0x2
    80001aa6:	a26080e7          	jalr	-1498(ra) # 800034c8 <fsinit>
    80001aaa:	bff9                	j	80001a88 <forkret+0x22>

0000000080001aac <allocpid>:
allocpid() {
    80001aac:	1101                	addi	sp,sp,-32
    80001aae:	ec06                	sd	ra,24(sp)
    80001ab0:	e822                	sd	s0,16(sp)
    80001ab2:	e426                	sd	s1,8(sp)
    80001ab4:	e04a                	sd	s2,0(sp)
    80001ab6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001ab8:	00010917          	auipc	s2,0x10
    80001abc:	e9890913          	addi	s2,s2,-360 # 80011950 <pid_lock>
    80001ac0:	854a                	mv	a0,s2
    80001ac2:	fffff097          	auipc	ra,0xfffff
    80001ac6:	1a0080e7          	jalr	416(ra) # 80000c62 <acquire>
  pid = nextpid;
    80001aca:	00007797          	auipc	a5,0x7
    80001ace:	d6a78793          	addi	a5,a5,-662 # 80008834 <nextpid>
    80001ad2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001ad4:	0014871b          	addiw	a4,s1,1
    80001ad8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001ada:	854a                	mv	a0,s2
    80001adc:	fffff097          	auipc	ra,0xfffff
    80001ae0:	23a080e7          	jalr	570(ra) # 80000d16 <release>
}
    80001ae4:	8526                	mv	a0,s1
    80001ae6:	60e2                	ld	ra,24(sp)
    80001ae8:	6442                	ld	s0,16(sp)
    80001aea:	64a2                	ld	s1,8(sp)
    80001aec:	6902                	ld	s2,0(sp)
    80001aee:	6105                	addi	sp,sp,32
    80001af0:	8082                	ret

0000000080001af2 <proc_pagetable>:
{
    80001af2:	1101                	addi	sp,sp,-32
    80001af4:	ec06                	sd	ra,24(sp)
    80001af6:	e822                	sd	s0,16(sp)
    80001af8:	e426                	sd	s1,8(sp)
    80001afa:	e04a                	sd	s2,0(sp)
    80001afc:	1000                	addi	s0,sp,32
    80001afe:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b00:	00000097          	auipc	ra,0x0
    80001b04:	8e8080e7          	jalr	-1816(ra) # 800013e8 <uvmcreate>
    80001b08:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b0a:	c121                	beqz	a0,80001b4a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b0c:	4729                	li	a4,10
    80001b0e:	00005697          	auipc	a3,0x5
    80001b12:	4f268693          	addi	a3,a3,1266 # 80007000 <_trampoline>
    80001b16:	6605                	lui	a2,0x1
    80001b18:	040005b7          	lui	a1,0x4000
    80001b1c:	15fd                	addi	a1,a1,-1
    80001b1e:	05b2                	slli	a1,a1,0xc
    80001b20:	fffff097          	auipc	ra,0xfffff
    80001b24:	66c080e7          	jalr	1644(ra) # 8000118c <mappages>
    80001b28:	02054863          	bltz	a0,80001b58 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b2c:	4719                	li	a4,6
    80001b2e:	05893683          	ld	a3,88(s2)
    80001b32:	6605                	lui	a2,0x1
    80001b34:	020005b7          	lui	a1,0x2000
    80001b38:	15fd                	addi	a1,a1,-1
    80001b3a:	05b6                	slli	a1,a1,0xd
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	fffff097          	auipc	ra,0xfffff
    80001b42:	64e080e7          	jalr	1614(ra) # 8000118c <mappages>
    80001b46:	02054163          	bltz	a0,80001b68 <proc_pagetable+0x76>
}
    80001b4a:	8526                	mv	a0,s1
    80001b4c:	60e2                	ld	ra,24(sp)
    80001b4e:	6442                	ld	s0,16(sp)
    80001b50:	64a2                	ld	s1,8(sp)
    80001b52:	6902                	ld	s2,0(sp)
    80001b54:	6105                	addi	sp,sp,32
    80001b56:	8082                	ret
    uvmfree(pagetable, 0);
    80001b58:	4581                	li	a1,0
    80001b5a:	8526                	mv	a0,s1
    80001b5c:	00000097          	auipc	ra,0x0
    80001b60:	a88080e7          	jalr	-1400(ra) # 800015e4 <uvmfree>
    return 0;
    80001b64:	4481                	li	s1,0
    80001b66:	b7d5                	j	80001b4a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b68:	4681                	li	a3,0
    80001b6a:	4605                	li	a2,1
    80001b6c:	040005b7          	lui	a1,0x4000
    80001b70:	15fd                	addi	a1,a1,-1
    80001b72:	05b2                	slli	a1,a1,0xc
    80001b74:	8526                	mv	a0,s1
    80001b76:	fffff097          	auipc	ra,0xfffff
    80001b7a:	7ae080e7          	jalr	1966(ra) # 80001324 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b7e:	4581                	li	a1,0
    80001b80:	8526                	mv	a0,s1
    80001b82:	00000097          	auipc	ra,0x0
    80001b86:	a62080e7          	jalr	-1438(ra) # 800015e4 <uvmfree>
    return 0;
    80001b8a:	4481                	li	s1,0
    80001b8c:	bf7d                	j	80001b4a <proc_pagetable+0x58>

0000000080001b8e <proc_freepagetable>:
{
    80001b8e:	1101                	addi	sp,sp,-32
    80001b90:	ec06                	sd	ra,24(sp)
    80001b92:	e822                	sd	s0,16(sp)
    80001b94:	e426                	sd	s1,8(sp)
    80001b96:	e04a                	sd	s2,0(sp)
    80001b98:	1000                	addi	s0,sp,32
    80001b9a:	84aa                	mv	s1,a0
    80001b9c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b9e:	4681                	li	a3,0
    80001ba0:	4605                	li	a2,1
    80001ba2:	040005b7          	lui	a1,0x4000
    80001ba6:	15fd                	addi	a1,a1,-1
    80001ba8:	05b2                	slli	a1,a1,0xc
    80001baa:	fffff097          	auipc	ra,0xfffff
    80001bae:	77a080e7          	jalr	1914(ra) # 80001324 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001bb2:	4681                	li	a3,0
    80001bb4:	4605                	li	a2,1
    80001bb6:	020005b7          	lui	a1,0x2000
    80001bba:	15fd                	addi	a1,a1,-1
    80001bbc:	05b6                	slli	a1,a1,0xd
    80001bbe:	8526                	mv	a0,s1
    80001bc0:	fffff097          	auipc	ra,0xfffff
    80001bc4:	764080e7          	jalr	1892(ra) # 80001324 <uvmunmap>
  uvmfree(pagetable, sz);
    80001bc8:	85ca                	mv	a1,s2
    80001bca:	8526                	mv	a0,s1
    80001bcc:	00000097          	auipc	ra,0x0
    80001bd0:	a18080e7          	jalr	-1512(ra) # 800015e4 <uvmfree>
}
    80001bd4:	60e2                	ld	ra,24(sp)
    80001bd6:	6442                	ld	s0,16(sp)
    80001bd8:	64a2                	ld	s1,8(sp)
    80001bda:	6902                	ld	s2,0(sp)
    80001bdc:	6105                	addi	sp,sp,32
    80001bde:	8082                	ret

0000000080001be0 <freeproc>:
{
    80001be0:	1101                	addi	sp,sp,-32
    80001be2:	ec06                	sd	ra,24(sp)
    80001be4:	e822                	sd	s0,16(sp)
    80001be6:	e426                	sd	s1,8(sp)
    80001be8:	1000                	addi	s0,sp,32
    80001bea:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001bec:	6d28                	ld	a0,88(a0)
    80001bee:	c509                	beqz	a0,80001bf8 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001bf0:	fffff097          	auipc	ra,0xfffff
    80001bf4:	e86080e7          	jalr	-378(ra) # 80000a76 <kfree>
  p->trapframe = 0;
    80001bf8:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001bfc:	68a8                	ld	a0,80(s1)
    80001bfe:	c511                	beqz	a0,80001c0a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001c00:	64ac                	ld	a1,72(s1)
    80001c02:	00000097          	auipc	ra,0x0
    80001c06:	f8c080e7          	jalr	-116(ra) # 80001b8e <proc_freepagetable>
  p->pagetable = 0;
    80001c0a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001c0e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c12:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001c16:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001c1a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c1e:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001c22:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001c26:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001c2a:	0004ac23          	sw	zero,24(s1)
}
    80001c2e:	60e2                	ld	ra,24(sp)
    80001c30:	6442                	ld	s0,16(sp)
    80001c32:	64a2                	ld	s1,8(sp)
    80001c34:	6105                	addi	sp,sp,32
    80001c36:	8082                	ret

0000000080001c38 <allocproc>:
{
    80001c38:	1101                	addi	sp,sp,-32
    80001c3a:	ec06                	sd	ra,24(sp)
    80001c3c:	e822                	sd	s0,16(sp)
    80001c3e:	e426                	sd	s1,8(sp)
    80001c40:	e04a                	sd	s2,0(sp)
    80001c42:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c44:	00010497          	auipc	s1,0x10
    80001c48:	12448493          	addi	s1,s1,292 # 80011d68 <proc>
    80001c4c:	00016917          	auipc	s2,0x16
    80001c50:	31c90913          	addi	s2,s2,796 # 80017f68 <tickslock>
    acquire(&p->lock);
    80001c54:	8526                	mv	a0,s1
    80001c56:	fffff097          	auipc	ra,0xfffff
    80001c5a:	00c080e7          	jalr	12(ra) # 80000c62 <acquire>
    if(p->state == UNUSED) {
    80001c5e:	4c9c                	lw	a5,24(s1)
    80001c60:	cf81                	beqz	a5,80001c78 <allocproc+0x40>
      release(&p->lock);
    80001c62:	8526                	mv	a0,s1
    80001c64:	fffff097          	auipc	ra,0xfffff
    80001c68:	0b2080e7          	jalr	178(ra) # 80000d16 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c6c:	18848493          	addi	s1,s1,392
    80001c70:	ff2492e3          	bne	s1,s2,80001c54 <allocproc+0x1c>
  return 0;
    80001c74:	4481                	li	s1,0
    80001c76:	a8b9                	j	80001cd4 <allocproc+0x9c>
  p->pid = allocpid();
    80001c78:	00000097          	auipc	ra,0x0
    80001c7c:	e34080e7          	jalr	-460(ra) # 80001aac <allocpid>
    80001c80:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c82:	fffff097          	auipc	ra,0xfffff
    80001c86:	ef0080e7          	jalr	-272(ra) # 80000b72 <kalloc>
    80001c8a:	892a                	mv	s2,a0
    80001c8c:	eca8                	sd	a0,88(s1)
    80001c8e:	c931                	beqz	a0,80001ce2 <allocproc+0xaa>
  p->pagetable = proc_pagetable(p);
    80001c90:	8526                	mv	a0,s1
    80001c92:	00000097          	auipc	ra,0x0
    80001c96:	e60080e7          	jalr	-416(ra) # 80001af2 <proc_pagetable>
    80001c9a:	892a                	mv	s2,a0
    80001c9c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c9e:	c929                	beqz	a0,80001cf0 <allocproc+0xb8>
  memset(&p->context, 0, sizeof(p->context));
    80001ca0:	07000613          	li	a2,112
    80001ca4:	4581                	li	a1,0
    80001ca6:	06048513          	addi	a0,s1,96
    80001caa:	fffff097          	auipc	ra,0xfffff
    80001cae:	0b4080e7          	jalr	180(ra) # 80000d5e <memset>
  p->context.ra = (uint64)forkret;
    80001cb2:	00000797          	auipc	a5,0x0
    80001cb6:	db478793          	addi	a5,a5,-588 # 80001a66 <forkret>
    80001cba:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001cbc:	60bc                	ld	a5,64(s1)
    80001cbe:	6705                	lui	a4,0x1
    80001cc0:	97ba                	add	a5,a5,a4
    80001cc2:	f4bc                	sd	a5,104(s1)
  p->interval = 0;      // lab4-3
    80001cc4:	1604a423          	sw	zero,360(s1)
  p->handler = 0;       // lab4-3
    80001cc8:	1604b823          	sd	zero,368(s1)
  p->passedticks = 0;   // lab4-3
    80001ccc:	1604ac23          	sw	zero,376(s1)
  p->trapframecopy = 0; // lab4-3
    80001cd0:	1804b023          	sd	zero,384(s1)
}
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	60e2                	ld	ra,24(sp)
    80001cd8:	6442                	ld	s0,16(sp)
    80001cda:	64a2                	ld	s1,8(sp)
    80001cdc:	6902                	ld	s2,0(sp)
    80001cde:	6105                	addi	sp,sp,32
    80001ce0:	8082                	ret
    release(&p->lock);
    80001ce2:	8526                	mv	a0,s1
    80001ce4:	fffff097          	auipc	ra,0xfffff
    80001ce8:	032080e7          	jalr	50(ra) # 80000d16 <release>
    return 0;
    80001cec:	84ca                	mv	s1,s2
    80001cee:	b7dd                	j	80001cd4 <allocproc+0x9c>
    freeproc(p);
    80001cf0:	8526                	mv	a0,s1
    80001cf2:	00000097          	auipc	ra,0x0
    80001cf6:	eee080e7          	jalr	-274(ra) # 80001be0 <freeproc>
    release(&p->lock);
    80001cfa:	8526                	mv	a0,s1
    80001cfc:	fffff097          	auipc	ra,0xfffff
    80001d00:	01a080e7          	jalr	26(ra) # 80000d16 <release>
    return 0;
    80001d04:	84ca                	mv	s1,s2
    80001d06:	b7f9                	j	80001cd4 <allocproc+0x9c>

0000000080001d08 <userinit>:
{
    80001d08:	1101                	addi	sp,sp,-32
    80001d0a:	ec06                	sd	ra,24(sp)
    80001d0c:	e822                	sd	s0,16(sp)
    80001d0e:	e426                	sd	s1,8(sp)
    80001d10:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d12:	00000097          	auipc	ra,0x0
    80001d16:	f26080e7          	jalr	-218(ra) # 80001c38 <allocproc>
    80001d1a:	84aa                	mv	s1,a0
  initproc = p;
    80001d1c:	00007797          	auipc	a5,0x7
    80001d20:	2ea7be23          	sd	a0,764(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001d24:	03400613          	li	a2,52
    80001d28:	00007597          	auipc	a1,0x7
    80001d2c:	b1858593          	addi	a1,a1,-1256 # 80008840 <initcode>
    80001d30:	6928                	ld	a0,80(a0)
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	6e4080e7          	jalr	1764(ra) # 80001416 <uvminit>
  p->sz = PGSIZE;
    80001d3a:	6785                	lui	a5,0x1
    80001d3c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d3e:	6cb8                	ld	a4,88(s1)
    80001d40:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d44:	6cb8                	ld	a4,88(s1)
    80001d46:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d48:	4641                	li	a2,16
    80001d4a:	00006597          	auipc	a1,0x6
    80001d4e:	4a658593          	addi	a1,a1,1190 # 800081f0 <digits+0x1a8>
    80001d52:	15848513          	addi	a0,s1,344
    80001d56:	fffff097          	auipc	ra,0xfffff
    80001d5a:	15a080e7          	jalr	346(ra) # 80000eb0 <safestrcpy>
  p->cwd = namei("/");
    80001d5e:	00006517          	auipc	a0,0x6
    80001d62:	4a250513          	addi	a0,a0,1186 # 80008200 <digits+0x1b8>
    80001d66:	00002097          	auipc	ra,0x2
    80001d6a:	18a080e7          	jalr	394(ra) # 80003ef0 <namei>
    80001d6e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d72:	4789                	li	a5,2
    80001d74:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d76:	8526                	mv	a0,s1
    80001d78:	fffff097          	auipc	ra,0xfffff
    80001d7c:	f9e080e7          	jalr	-98(ra) # 80000d16 <release>
}
    80001d80:	60e2                	ld	ra,24(sp)
    80001d82:	6442                	ld	s0,16(sp)
    80001d84:	64a2                	ld	s1,8(sp)
    80001d86:	6105                	addi	sp,sp,32
    80001d88:	8082                	ret

0000000080001d8a <growproc>:
{
    80001d8a:	1101                	addi	sp,sp,-32
    80001d8c:	ec06                	sd	ra,24(sp)
    80001d8e:	e822                	sd	s0,16(sp)
    80001d90:	e426                	sd	s1,8(sp)
    80001d92:	e04a                	sd	s2,0(sp)
    80001d94:	1000                	addi	s0,sp,32
    80001d96:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	c96080e7          	jalr	-874(ra) # 80001a2e <myproc>
    80001da0:	892a                	mv	s2,a0
  sz = p->sz;
    80001da2:	652c                	ld	a1,72(a0)
    80001da4:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001da8:	00904f63          	bgtz	s1,80001dc6 <growproc+0x3c>
  } else if(n < 0){
    80001dac:	0204cc63          	bltz	s1,80001de4 <growproc+0x5a>
  p->sz = sz;
    80001db0:	1602                	slli	a2,a2,0x20
    80001db2:	9201                	srli	a2,a2,0x20
    80001db4:	04c93423          	sd	a2,72(s2)
  return 0;
    80001db8:	4501                	li	a0,0
}
    80001dba:	60e2                	ld	ra,24(sp)
    80001dbc:	6442                	ld	s0,16(sp)
    80001dbe:	64a2                	ld	s1,8(sp)
    80001dc0:	6902                	ld	s2,0(sp)
    80001dc2:	6105                	addi	sp,sp,32
    80001dc4:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001dc6:	9e25                	addw	a2,a2,s1
    80001dc8:	1602                	slli	a2,a2,0x20
    80001dca:	9201                	srli	a2,a2,0x20
    80001dcc:	1582                	slli	a1,a1,0x20
    80001dce:	9181                	srli	a1,a1,0x20
    80001dd0:	6928                	ld	a0,80(a0)
    80001dd2:	fffff097          	auipc	ra,0xfffff
    80001dd6:	6fe080e7          	jalr	1790(ra) # 800014d0 <uvmalloc>
    80001dda:	0005061b          	sext.w	a2,a0
    80001dde:	fa69                	bnez	a2,80001db0 <growproc+0x26>
      return -1;
    80001de0:	557d                	li	a0,-1
    80001de2:	bfe1                	j	80001dba <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001de4:	9e25                	addw	a2,a2,s1
    80001de6:	1602                	slli	a2,a2,0x20
    80001de8:	9201                	srli	a2,a2,0x20
    80001dea:	1582                	slli	a1,a1,0x20
    80001dec:	9181                	srli	a1,a1,0x20
    80001dee:	6928                	ld	a0,80(a0)
    80001df0:	fffff097          	auipc	ra,0xfffff
    80001df4:	698080e7          	jalr	1688(ra) # 80001488 <uvmdealloc>
    80001df8:	0005061b          	sext.w	a2,a0
    80001dfc:	bf55                	j	80001db0 <growproc+0x26>

0000000080001dfe <fork>:
{
    80001dfe:	7139                	addi	sp,sp,-64
    80001e00:	fc06                	sd	ra,56(sp)
    80001e02:	f822                	sd	s0,48(sp)
    80001e04:	f426                	sd	s1,40(sp)
    80001e06:	f04a                	sd	s2,32(sp)
    80001e08:	ec4e                	sd	s3,24(sp)
    80001e0a:	e852                	sd	s4,16(sp)
    80001e0c:	e456                	sd	s5,8(sp)
    80001e0e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001e10:	00000097          	auipc	ra,0x0
    80001e14:	c1e080e7          	jalr	-994(ra) # 80001a2e <myproc>
    80001e18:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001e1a:	00000097          	auipc	ra,0x0
    80001e1e:	e1e080e7          	jalr	-482(ra) # 80001c38 <allocproc>
    80001e22:	c17d                	beqz	a0,80001f08 <fork+0x10a>
    80001e24:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e26:	048ab603          	ld	a2,72(s5)
    80001e2a:	692c                	ld	a1,80(a0)
    80001e2c:	050ab503          	ld	a0,80(s5)
    80001e30:	fffff097          	auipc	ra,0xfffff
    80001e34:	7ec080e7          	jalr	2028(ra) # 8000161c <uvmcopy>
    80001e38:	04054a63          	bltz	a0,80001e8c <fork+0x8e>
  np->sz = p->sz;
    80001e3c:	048ab783          	ld	a5,72(s5)
    80001e40:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80001e44:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80001e48:	058ab683          	ld	a3,88(s5)
    80001e4c:	87b6                	mv	a5,a3
    80001e4e:	058a3703          	ld	a4,88(s4)
    80001e52:	12068693          	addi	a3,a3,288
    80001e56:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e5a:	6788                	ld	a0,8(a5)
    80001e5c:	6b8c                	ld	a1,16(a5)
    80001e5e:	6f90                	ld	a2,24(a5)
    80001e60:	01073023          	sd	a6,0(a4)
    80001e64:	e708                	sd	a0,8(a4)
    80001e66:	eb0c                	sd	a1,16(a4)
    80001e68:	ef10                	sd	a2,24(a4)
    80001e6a:	02078793          	addi	a5,a5,32
    80001e6e:	02070713          	addi	a4,a4,32
    80001e72:	fed792e3          	bne	a5,a3,80001e56 <fork+0x58>
  np->trapframe->a0 = 0;
    80001e76:	058a3783          	ld	a5,88(s4)
    80001e7a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e7e:	0d0a8493          	addi	s1,s5,208
    80001e82:	0d0a0913          	addi	s2,s4,208
    80001e86:	150a8993          	addi	s3,s5,336
    80001e8a:	a00d                	j	80001eac <fork+0xae>
    freeproc(np);
    80001e8c:	8552                	mv	a0,s4
    80001e8e:	00000097          	auipc	ra,0x0
    80001e92:	d52080e7          	jalr	-686(ra) # 80001be0 <freeproc>
    release(&np->lock);
    80001e96:	8552                	mv	a0,s4
    80001e98:	fffff097          	auipc	ra,0xfffff
    80001e9c:	e7e080e7          	jalr	-386(ra) # 80000d16 <release>
    return -1;
    80001ea0:	54fd                	li	s1,-1
    80001ea2:	a889                	j	80001ef4 <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    80001ea4:	04a1                	addi	s1,s1,8
    80001ea6:	0921                	addi	s2,s2,8
    80001ea8:	01348b63          	beq	s1,s3,80001ebe <fork+0xc0>
    if(p->ofile[i])
    80001eac:	6088                	ld	a0,0(s1)
    80001eae:	d97d                	beqz	a0,80001ea4 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001eb0:	00002097          	auipc	ra,0x2
    80001eb4:	6cc080e7          	jalr	1740(ra) # 8000457c <filedup>
    80001eb8:	00a93023          	sd	a0,0(s2)
    80001ebc:	b7e5                	j	80001ea4 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001ebe:	150ab503          	ld	a0,336(s5)
    80001ec2:	00002097          	auipc	ra,0x2
    80001ec6:	840080e7          	jalr	-1984(ra) # 80003702 <idup>
    80001eca:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ece:	4641                	li	a2,16
    80001ed0:	158a8593          	addi	a1,s5,344
    80001ed4:	158a0513          	addi	a0,s4,344
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	fd8080e7          	jalr	-40(ra) # 80000eb0 <safestrcpy>
  pid = np->pid;
    80001ee0:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    80001ee4:	4789                	li	a5,2
    80001ee6:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001eea:	8552                	mv	a0,s4
    80001eec:	fffff097          	auipc	ra,0xfffff
    80001ef0:	e2a080e7          	jalr	-470(ra) # 80000d16 <release>
}
    80001ef4:	8526                	mv	a0,s1
    80001ef6:	70e2                	ld	ra,56(sp)
    80001ef8:	7442                	ld	s0,48(sp)
    80001efa:	74a2                	ld	s1,40(sp)
    80001efc:	7902                	ld	s2,32(sp)
    80001efe:	69e2                	ld	s3,24(sp)
    80001f00:	6a42                	ld	s4,16(sp)
    80001f02:	6aa2                	ld	s5,8(sp)
    80001f04:	6121                	addi	sp,sp,64
    80001f06:	8082                	ret
    return -1;
    80001f08:	54fd                	li	s1,-1
    80001f0a:	b7ed                	j	80001ef4 <fork+0xf6>

0000000080001f0c <reparent>:
{
    80001f0c:	7179                	addi	sp,sp,-48
    80001f0e:	f406                	sd	ra,40(sp)
    80001f10:	f022                	sd	s0,32(sp)
    80001f12:	ec26                	sd	s1,24(sp)
    80001f14:	e84a                	sd	s2,16(sp)
    80001f16:	e44e                	sd	s3,8(sp)
    80001f18:	e052                	sd	s4,0(sp)
    80001f1a:	1800                	addi	s0,sp,48
    80001f1c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f1e:	00010497          	auipc	s1,0x10
    80001f22:	e4a48493          	addi	s1,s1,-438 # 80011d68 <proc>
      pp->parent = initproc;
    80001f26:	00007a17          	auipc	s4,0x7
    80001f2a:	0f2a0a13          	addi	s4,s4,242 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f2e:	00016997          	auipc	s3,0x16
    80001f32:	03a98993          	addi	s3,s3,58 # 80017f68 <tickslock>
    80001f36:	a029                	j	80001f40 <reparent+0x34>
    80001f38:	18848493          	addi	s1,s1,392
    80001f3c:	03348363          	beq	s1,s3,80001f62 <reparent+0x56>
    if(pp->parent == p){
    80001f40:	709c                	ld	a5,32(s1)
    80001f42:	ff279be3          	bne	a5,s2,80001f38 <reparent+0x2c>
      acquire(&pp->lock);
    80001f46:	8526                	mv	a0,s1
    80001f48:	fffff097          	auipc	ra,0xfffff
    80001f4c:	d1a080e7          	jalr	-742(ra) # 80000c62 <acquire>
      pp->parent = initproc;
    80001f50:	000a3783          	ld	a5,0(s4)
    80001f54:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001f56:	8526                	mv	a0,s1
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	dbe080e7          	jalr	-578(ra) # 80000d16 <release>
    80001f60:	bfe1                	j	80001f38 <reparent+0x2c>
}
    80001f62:	70a2                	ld	ra,40(sp)
    80001f64:	7402                	ld	s0,32(sp)
    80001f66:	64e2                	ld	s1,24(sp)
    80001f68:	6942                	ld	s2,16(sp)
    80001f6a:	69a2                	ld	s3,8(sp)
    80001f6c:	6a02                	ld	s4,0(sp)
    80001f6e:	6145                	addi	sp,sp,48
    80001f70:	8082                	ret

0000000080001f72 <scheduler>:
{
    80001f72:	715d                	addi	sp,sp,-80
    80001f74:	e486                	sd	ra,72(sp)
    80001f76:	e0a2                	sd	s0,64(sp)
    80001f78:	fc26                	sd	s1,56(sp)
    80001f7a:	f84a                	sd	s2,48(sp)
    80001f7c:	f44e                	sd	s3,40(sp)
    80001f7e:	f052                	sd	s4,32(sp)
    80001f80:	ec56                	sd	s5,24(sp)
    80001f82:	e85a                	sd	s6,16(sp)
    80001f84:	e45e                	sd	s7,8(sp)
    80001f86:	e062                	sd	s8,0(sp)
    80001f88:	0880                	addi	s0,sp,80
    80001f8a:	8792                	mv	a5,tp
  int id = r_tp();
    80001f8c:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f8e:	00779b13          	slli	s6,a5,0x7
    80001f92:	00010717          	auipc	a4,0x10
    80001f96:	9be70713          	addi	a4,a4,-1602 # 80011950 <pid_lock>
    80001f9a:	975a                	add	a4,a4,s6
    80001f9c:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001fa0:	00010717          	auipc	a4,0x10
    80001fa4:	9d070713          	addi	a4,a4,-1584 # 80011970 <cpus+0x8>
    80001fa8:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001faa:	4c0d                	li	s8,3
        c->proc = p;
    80001fac:	079e                	slli	a5,a5,0x7
    80001fae:	00010a17          	auipc	s4,0x10
    80001fb2:	9a2a0a13          	addi	s4,s4,-1630 # 80011950 <pid_lock>
    80001fb6:	9a3e                	add	s4,s4,a5
        found = 1;
    80001fb8:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fba:	00016997          	auipc	s3,0x16
    80001fbe:	fae98993          	addi	s3,s3,-82 # 80017f68 <tickslock>
    80001fc2:	a899                	j	80002018 <scheduler+0xa6>
      release(&p->lock);
    80001fc4:	8526                	mv	a0,s1
    80001fc6:	fffff097          	auipc	ra,0xfffff
    80001fca:	d50080e7          	jalr	-688(ra) # 80000d16 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fce:	18848493          	addi	s1,s1,392
    80001fd2:	03348963          	beq	s1,s3,80002004 <scheduler+0x92>
      acquire(&p->lock);
    80001fd6:	8526                	mv	a0,s1
    80001fd8:	fffff097          	auipc	ra,0xfffff
    80001fdc:	c8a080e7          	jalr	-886(ra) # 80000c62 <acquire>
      if(p->state == RUNNABLE) {
    80001fe0:	4c9c                	lw	a5,24(s1)
    80001fe2:	ff2791e3          	bne	a5,s2,80001fc4 <scheduler+0x52>
        p->state = RUNNING;
    80001fe6:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001fea:	009a3c23          	sd	s1,24(s4)
        swtch(&c->context, &p->context);
    80001fee:	06048593          	addi	a1,s1,96
    80001ff2:	855a                	mv	a0,s6
    80001ff4:	00000097          	auipc	ra,0x0
    80001ff8:	60e080e7          	jalr	1550(ra) # 80002602 <swtch>
        c->proc = 0;
    80001ffc:	000a3c23          	sd	zero,24(s4)
        found = 1;
    80002000:	8ade                	mv	s5,s7
    80002002:	b7c9                	j	80001fc4 <scheduler+0x52>
    if(found == 0) {
    80002004:	000a9a63          	bnez	s5,80002018 <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002008:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000200c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002010:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002014:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002018:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000201c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002020:	10079073          	csrw	sstatus,a5
    int found = 0;
    80002024:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80002026:	00010497          	auipc	s1,0x10
    8000202a:	d4248493          	addi	s1,s1,-702 # 80011d68 <proc>
      if(p->state == RUNNABLE) {
    8000202e:	4909                	li	s2,2
    80002030:	b75d                	j	80001fd6 <scheduler+0x64>

0000000080002032 <sched>:
{
    80002032:	7179                	addi	sp,sp,-48
    80002034:	f406                	sd	ra,40(sp)
    80002036:	f022                	sd	s0,32(sp)
    80002038:	ec26                	sd	s1,24(sp)
    8000203a:	e84a                	sd	s2,16(sp)
    8000203c:	e44e                	sd	s3,8(sp)
    8000203e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002040:	00000097          	auipc	ra,0x0
    80002044:	9ee080e7          	jalr	-1554(ra) # 80001a2e <myproc>
    80002048:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000204a:	fffff097          	auipc	ra,0xfffff
    8000204e:	b9e080e7          	jalr	-1122(ra) # 80000be8 <holding>
    80002052:	c93d                	beqz	a0,800020c8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002054:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002056:	2781                	sext.w	a5,a5
    80002058:	079e                	slli	a5,a5,0x7
    8000205a:	00010717          	auipc	a4,0x10
    8000205e:	8f670713          	addi	a4,a4,-1802 # 80011950 <pid_lock>
    80002062:	97ba                	add	a5,a5,a4
    80002064:	0907a703          	lw	a4,144(a5)
    80002068:	4785                	li	a5,1
    8000206a:	06f71763          	bne	a4,a5,800020d8 <sched+0xa6>
  if(p->state == RUNNING)
    8000206e:	4c98                	lw	a4,24(s1)
    80002070:	478d                	li	a5,3
    80002072:	06f70b63          	beq	a4,a5,800020e8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002076:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000207a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000207c:	efb5                	bnez	a5,800020f8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000207e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002080:	00010917          	auipc	s2,0x10
    80002084:	8d090913          	addi	s2,s2,-1840 # 80011950 <pid_lock>
    80002088:	2781                	sext.w	a5,a5
    8000208a:	079e                	slli	a5,a5,0x7
    8000208c:	97ca                	add	a5,a5,s2
    8000208e:	0947a983          	lw	s3,148(a5)
    80002092:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002094:	2781                	sext.w	a5,a5
    80002096:	079e                	slli	a5,a5,0x7
    80002098:	00010597          	auipc	a1,0x10
    8000209c:	8d858593          	addi	a1,a1,-1832 # 80011970 <cpus+0x8>
    800020a0:	95be                	add	a1,a1,a5
    800020a2:	06048513          	addi	a0,s1,96
    800020a6:	00000097          	auipc	ra,0x0
    800020aa:	55c080e7          	jalr	1372(ra) # 80002602 <swtch>
    800020ae:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800020b0:	2781                	sext.w	a5,a5
    800020b2:	079e                	slli	a5,a5,0x7
    800020b4:	97ca                	add	a5,a5,s2
    800020b6:	0937aa23          	sw	s3,148(a5)
}
    800020ba:	70a2                	ld	ra,40(sp)
    800020bc:	7402                	ld	s0,32(sp)
    800020be:	64e2                	ld	s1,24(sp)
    800020c0:	6942                	ld	s2,16(sp)
    800020c2:	69a2                	ld	s3,8(sp)
    800020c4:	6145                	addi	sp,sp,48
    800020c6:	8082                	ret
    panic("sched p->lock");
    800020c8:	00006517          	auipc	a0,0x6
    800020cc:	14050513          	addi	a0,a0,320 # 80008208 <digits+0x1c0>
    800020d0:	ffffe097          	auipc	ra,0xffffe
    800020d4:	500080e7          	jalr	1280(ra) # 800005d0 <panic>
    panic("sched locks");
    800020d8:	00006517          	auipc	a0,0x6
    800020dc:	14050513          	addi	a0,a0,320 # 80008218 <digits+0x1d0>
    800020e0:	ffffe097          	auipc	ra,0xffffe
    800020e4:	4f0080e7          	jalr	1264(ra) # 800005d0 <panic>
    panic("sched running");
    800020e8:	00006517          	auipc	a0,0x6
    800020ec:	14050513          	addi	a0,a0,320 # 80008228 <digits+0x1e0>
    800020f0:	ffffe097          	auipc	ra,0xffffe
    800020f4:	4e0080e7          	jalr	1248(ra) # 800005d0 <panic>
    panic("sched interruptible");
    800020f8:	00006517          	auipc	a0,0x6
    800020fc:	14050513          	addi	a0,a0,320 # 80008238 <digits+0x1f0>
    80002100:	ffffe097          	auipc	ra,0xffffe
    80002104:	4d0080e7          	jalr	1232(ra) # 800005d0 <panic>

0000000080002108 <exit>:
{
    80002108:	7179                	addi	sp,sp,-48
    8000210a:	f406                	sd	ra,40(sp)
    8000210c:	f022                	sd	s0,32(sp)
    8000210e:	ec26                	sd	s1,24(sp)
    80002110:	e84a                	sd	s2,16(sp)
    80002112:	e44e                	sd	s3,8(sp)
    80002114:	e052                	sd	s4,0(sp)
    80002116:	1800                	addi	s0,sp,48
    80002118:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000211a:	00000097          	auipc	ra,0x0
    8000211e:	914080e7          	jalr	-1772(ra) # 80001a2e <myproc>
    80002122:	89aa                	mv	s3,a0
  if(p == initproc)
    80002124:	00007797          	auipc	a5,0x7
    80002128:	ef47b783          	ld	a5,-268(a5) # 80009018 <initproc>
    8000212c:	0d050493          	addi	s1,a0,208
    80002130:	15050913          	addi	s2,a0,336
    80002134:	02a79363          	bne	a5,a0,8000215a <exit+0x52>
    panic("init exiting");
    80002138:	00006517          	auipc	a0,0x6
    8000213c:	11850513          	addi	a0,a0,280 # 80008250 <digits+0x208>
    80002140:	ffffe097          	auipc	ra,0xffffe
    80002144:	490080e7          	jalr	1168(ra) # 800005d0 <panic>
      fileclose(f);
    80002148:	00002097          	auipc	ra,0x2
    8000214c:	486080e7          	jalr	1158(ra) # 800045ce <fileclose>
      p->ofile[fd] = 0;
    80002150:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002154:	04a1                	addi	s1,s1,8
    80002156:	01248563          	beq	s1,s2,80002160 <exit+0x58>
    if(p->ofile[fd]){
    8000215a:	6088                	ld	a0,0(s1)
    8000215c:	f575                	bnez	a0,80002148 <exit+0x40>
    8000215e:	bfdd                	j	80002154 <exit+0x4c>
  begin_op();
    80002160:	00002097          	auipc	ra,0x2
    80002164:	f9c080e7          	jalr	-100(ra) # 800040fc <begin_op>
  iput(p->cwd);
    80002168:	1509b503          	ld	a0,336(s3)
    8000216c:	00001097          	auipc	ra,0x1
    80002170:	78e080e7          	jalr	1934(ra) # 800038fa <iput>
  end_op();
    80002174:	00002097          	auipc	ra,0x2
    80002178:	008080e7          	jalr	8(ra) # 8000417c <end_op>
  p->cwd = 0;
    8000217c:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    80002180:	00007497          	auipc	s1,0x7
    80002184:	e9848493          	addi	s1,s1,-360 # 80009018 <initproc>
    80002188:	6088                	ld	a0,0(s1)
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	ad8080e7          	jalr	-1320(ra) # 80000c62 <acquire>
  wakeup1(initproc);
    80002192:	6088                	ld	a0,0(s1)
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	75a080e7          	jalr	1882(ra) # 800018ee <wakeup1>
  release(&initproc->lock);
    8000219c:	6088                	ld	a0,0(s1)
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	b78080e7          	jalr	-1160(ra) # 80000d16 <release>
  acquire(&p->lock);
    800021a6:	854e                	mv	a0,s3
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	aba080e7          	jalr	-1350(ra) # 80000c62 <acquire>
  struct proc *original_parent = p->parent;
    800021b0:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800021b4:	854e                	mv	a0,s3
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	b60080e7          	jalr	-1184(ra) # 80000d16 <release>
  acquire(&original_parent->lock);
    800021be:	8526                	mv	a0,s1
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	aa2080e7          	jalr	-1374(ra) # 80000c62 <acquire>
  acquire(&p->lock);
    800021c8:	854e                	mv	a0,s3
    800021ca:	fffff097          	auipc	ra,0xfffff
    800021ce:	a98080e7          	jalr	-1384(ra) # 80000c62 <acquire>
  reparent(p);
    800021d2:	854e                	mv	a0,s3
    800021d4:	00000097          	auipc	ra,0x0
    800021d8:	d38080e7          	jalr	-712(ra) # 80001f0c <reparent>
  wakeup1(original_parent);
    800021dc:	8526                	mv	a0,s1
    800021de:	fffff097          	auipc	ra,0xfffff
    800021e2:	710080e7          	jalr	1808(ra) # 800018ee <wakeup1>
  p->xstate = status;
    800021e6:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800021ea:	4791                	li	a5,4
    800021ec:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    800021f0:	8526                	mv	a0,s1
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	b24080e7          	jalr	-1244(ra) # 80000d16 <release>
  sched();
    800021fa:	00000097          	auipc	ra,0x0
    800021fe:	e38080e7          	jalr	-456(ra) # 80002032 <sched>
  panic("zombie exit");
    80002202:	00006517          	auipc	a0,0x6
    80002206:	05e50513          	addi	a0,a0,94 # 80008260 <digits+0x218>
    8000220a:	ffffe097          	auipc	ra,0xffffe
    8000220e:	3c6080e7          	jalr	966(ra) # 800005d0 <panic>

0000000080002212 <yield>:
{
    80002212:	1101                	addi	sp,sp,-32
    80002214:	ec06                	sd	ra,24(sp)
    80002216:	e822                	sd	s0,16(sp)
    80002218:	e426                	sd	s1,8(sp)
    8000221a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000221c:	00000097          	auipc	ra,0x0
    80002220:	812080e7          	jalr	-2030(ra) # 80001a2e <myproc>
    80002224:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002226:	fffff097          	auipc	ra,0xfffff
    8000222a:	a3c080e7          	jalr	-1476(ra) # 80000c62 <acquire>
  p->state = RUNNABLE;
    8000222e:	4789                	li	a5,2
    80002230:	cc9c                	sw	a5,24(s1)
  sched();
    80002232:	00000097          	auipc	ra,0x0
    80002236:	e00080e7          	jalr	-512(ra) # 80002032 <sched>
  release(&p->lock);
    8000223a:	8526                	mv	a0,s1
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	ada080e7          	jalr	-1318(ra) # 80000d16 <release>
}
    80002244:	60e2                	ld	ra,24(sp)
    80002246:	6442                	ld	s0,16(sp)
    80002248:	64a2                	ld	s1,8(sp)
    8000224a:	6105                	addi	sp,sp,32
    8000224c:	8082                	ret

000000008000224e <sleep>:
{
    8000224e:	7179                	addi	sp,sp,-48
    80002250:	f406                	sd	ra,40(sp)
    80002252:	f022                	sd	s0,32(sp)
    80002254:	ec26                	sd	s1,24(sp)
    80002256:	e84a                	sd	s2,16(sp)
    80002258:	e44e                	sd	s3,8(sp)
    8000225a:	1800                	addi	s0,sp,48
    8000225c:	89aa                	mv	s3,a0
    8000225e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	7ce080e7          	jalr	1998(ra) # 80001a2e <myproc>
    80002268:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    8000226a:	05250663          	beq	a0,s2,800022b6 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	9f4080e7          	jalr	-1548(ra) # 80000c62 <acquire>
    release(lk);
    80002276:	854a                	mv	a0,s2
    80002278:	fffff097          	auipc	ra,0xfffff
    8000227c:	a9e080e7          	jalr	-1378(ra) # 80000d16 <release>
  p->chan = chan;
    80002280:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80002284:	4785                	li	a5,1
    80002286:	cc9c                	sw	a5,24(s1)
  sched();
    80002288:	00000097          	auipc	ra,0x0
    8000228c:	daa080e7          	jalr	-598(ra) # 80002032 <sched>
  p->chan = 0;
    80002290:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002294:	8526                	mv	a0,s1
    80002296:	fffff097          	auipc	ra,0xfffff
    8000229a:	a80080e7          	jalr	-1408(ra) # 80000d16 <release>
    acquire(lk);
    8000229e:	854a                	mv	a0,s2
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	9c2080e7          	jalr	-1598(ra) # 80000c62 <acquire>
}
    800022a8:	70a2                	ld	ra,40(sp)
    800022aa:	7402                	ld	s0,32(sp)
    800022ac:	64e2                	ld	s1,24(sp)
    800022ae:	6942                	ld	s2,16(sp)
    800022b0:	69a2                	ld	s3,8(sp)
    800022b2:	6145                	addi	sp,sp,48
    800022b4:	8082                	ret
  p->chan = chan;
    800022b6:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800022ba:	4785                	li	a5,1
    800022bc:	cd1c                	sw	a5,24(a0)
  sched();
    800022be:	00000097          	auipc	ra,0x0
    800022c2:	d74080e7          	jalr	-652(ra) # 80002032 <sched>
  p->chan = 0;
    800022c6:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800022ca:	bff9                	j	800022a8 <sleep+0x5a>

00000000800022cc <wait>:
{
    800022cc:	715d                	addi	sp,sp,-80
    800022ce:	e486                	sd	ra,72(sp)
    800022d0:	e0a2                	sd	s0,64(sp)
    800022d2:	fc26                	sd	s1,56(sp)
    800022d4:	f84a                	sd	s2,48(sp)
    800022d6:	f44e                	sd	s3,40(sp)
    800022d8:	f052                	sd	s4,32(sp)
    800022da:	ec56                	sd	s5,24(sp)
    800022dc:	e85a                	sd	s6,16(sp)
    800022de:	e45e                	sd	s7,8(sp)
    800022e0:	0880                	addi	s0,sp,80
    800022e2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	74a080e7          	jalr	1866(ra) # 80001a2e <myproc>
    800022ec:	892a                	mv	s2,a0
  acquire(&p->lock);
    800022ee:	fffff097          	auipc	ra,0xfffff
    800022f2:	974080e7          	jalr	-1676(ra) # 80000c62 <acquire>
    havekids = 0;
    800022f6:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800022f8:	4a11                	li	s4,4
        havekids = 1;
    800022fa:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800022fc:	00016997          	auipc	s3,0x16
    80002300:	c6c98993          	addi	s3,s3,-916 # 80017f68 <tickslock>
    havekids = 0;
    80002304:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002306:	00010497          	auipc	s1,0x10
    8000230a:	a6248493          	addi	s1,s1,-1438 # 80011d68 <proc>
    8000230e:	a08d                	j	80002370 <wait+0xa4>
          pid = np->pid;
    80002310:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002314:	000b0e63          	beqz	s6,80002330 <wait+0x64>
    80002318:	4691                	li	a3,4
    8000231a:	03448613          	addi	a2,s1,52
    8000231e:	85da                	mv	a1,s6
    80002320:	05093503          	ld	a0,80(s2)
    80002324:	fffff097          	auipc	ra,0xfffff
    80002328:	3fc080e7          	jalr	1020(ra) # 80001720 <copyout>
    8000232c:	02054263          	bltz	a0,80002350 <wait+0x84>
          freeproc(np);
    80002330:	8526                	mv	a0,s1
    80002332:	00000097          	auipc	ra,0x0
    80002336:	8ae080e7          	jalr	-1874(ra) # 80001be0 <freeproc>
          release(&np->lock);
    8000233a:	8526                	mv	a0,s1
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	9da080e7          	jalr	-1574(ra) # 80000d16 <release>
          release(&p->lock);
    80002344:	854a                	mv	a0,s2
    80002346:	fffff097          	auipc	ra,0xfffff
    8000234a:	9d0080e7          	jalr	-1584(ra) # 80000d16 <release>
          return pid;
    8000234e:	a8a9                	j	800023a8 <wait+0xdc>
            release(&np->lock);
    80002350:	8526                	mv	a0,s1
    80002352:	fffff097          	auipc	ra,0xfffff
    80002356:	9c4080e7          	jalr	-1596(ra) # 80000d16 <release>
            release(&p->lock);
    8000235a:	854a                	mv	a0,s2
    8000235c:	fffff097          	auipc	ra,0xfffff
    80002360:	9ba080e7          	jalr	-1606(ra) # 80000d16 <release>
            return -1;
    80002364:	59fd                	li	s3,-1
    80002366:	a089                	j	800023a8 <wait+0xdc>
    for(np = proc; np < &proc[NPROC]; np++){
    80002368:	18848493          	addi	s1,s1,392
    8000236c:	03348463          	beq	s1,s3,80002394 <wait+0xc8>
      if(np->parent == p){
    80002370:	709c                	ld	a5,32(s1)
    80002372:	ff279be3          	bne	a5,s2,80002368 <wait+0x9c>
        acquire(&np->lock);
    80002376:	8526                	mv	a0,s1
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	8ea080e7          	jalr	-1814(ra) # 80000c62 <acquire>
        if(np->state == ZOMBIE){
    80002380:	4c9c                	lw	a5,24(s1)
    80002382:	f94787e3          	beq	a5,s4,80002310 <wait+0x44>
        release(&np->lock);
    80002386:	8526                	mv	a0,s1
    80002388:	fffff097          	auipc	ra,0xfffff
    8000238c:	98e080e7          	jalr	-1650(ra) # 80000d16 <release>
        havekids = 1;
    80002390:	8756                	mv	a4,s5
    80002392:	bfd9                	j	80002368 <wait+0x9c>
    if(!havekids || p->killed){
    80002394:	c701                	beqz	a4,8000239c <wait+0xd0>
    80002396:	03092783          	lw	a5,48(s2)
    8000239a:	c39d                	beqz	a5,800023c0 <wait+0xf4>
      release(&p->lock);
    8000239c:	854a                	mv	a0,s2
    8000239e:	fffff097          	auipc	ra,0xfffff
    800023a2:	978080e7          	jalr	-1672(ra) # 80000d16 <release>
      return -1;
    800023a6:	59fd                	li	s3,-1
}
    800023a8:	854e                	mv	a0,s3
    800023aa:	60a6                	ld	ra,72(sp)
    800023ac:	6406                	ld	s0,64(sp)
    800023ae:	74e2                	ld	s1,56(sp)
    800023b0:	7942                	ld	s2,48(sp)
    800023b2:	79a2                	ld	s3,40(sp)
    800023b4:	7a02                	ld	s4,32(sp)
    800023b6:	6ae2                	ld	s5,24(sp)
    800023b8:	6b42                	ld	s6,16(sp)
    800023ba:	6ba2                	ld	s7,8(sp)
    800023bc:	6161                	addi	sp,sp,80
    800023be:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    800023c0:	85ca                	mv	a1,s2
    800023c2:	854a                	mv	a0,s2
    800023c4:	00000097          	auipc	ra,0x0
    800023c8:	e8a080e7          	jalr	-374(ra) # 8000224e <sleep>
    havekids = 0;
    800023cc:	bf25                	j	80002304 <wait+0x38>

00000000800023ce <wakeup>:
{
    800023ce:	7139                	addi	sp,sp,-64
    800023d0:	fc06                	sd	ra,56(sp)
    800023d2:	f822                	sd	s0,48(sp)
    800023d4:	f426                	sd	s1,40(sp)
    800023d6:	f04a                	sd	s2,32(sp)
    800023d8:	ec4e                	sd	s3,24(sp)
    800023da:	e852                	sd	s4,16(sp)
    800023dc:	e456                	sd	s5,8(sp)
    800023de:	0080                	addi	s0,sp,64
    800023e0:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800023e2:	00010497          	auipc	s1,0x10
    800023e6:	98648493          	addi	s1,s1,-1658 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    800023ea:	4985                	li	s3,1
      p->state = RUNNABLE;
    800023ec:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    800023ee:	00016917          	auipc	s2,0x16
    800023f2:	b7a90913          	addi	s2,s2,-1158 # 80017f68 <tickslock>
    800023f6:	a811                	j	8000240a <wakeup+0x3c>
    release(&p->lock);
    800023f8:	8526                	mv	a0,s1
    800023fa:	fffff097          	auipc	ra,0xfffff
    800023fe:	91c080e7          	jalr	-1764(ra) # 80000d16 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002402:	18848493          	addi	s1,s1,392
    80002406:	03248063          	beq	s1,s2,80002426 <wakeup+0x58>
    acquire(&p->lock);
    8000240a:	8526                	mv	a0,s1
    8000240c:	fffff097          	auipc	ra,0xfffff
    80002410:	856080e7          	jalr	-1962(ra) # 80000c62 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002414:	4c9c                	lw	a5,24(s1)
    80002416:	ff3791e3          	bne	a5,s3,800023f8 <wakeup+0x2a>
    8000241a:	749c                	ld	a5,40(s1)
    8000241c:	fd479ee3          	bne	a5,s4,800023f8 <wakeup+0x2a>
      p->state = RUNNABLE;
    80002420:	0154ac23          	sw	s5,24(s1)
    80002424:	bfd1                	j	800023f8 <wakeup+0x2a>
}
    80002426:	70e2                	ld	ra,56(sp)
    80002428:	7442                	ld	s0,48(sp)
    8000242a:	74a2                	ld	s1,40(sp)
    8000242c:	7902                	ld	s2,32(sp)
    8000242e:	69e2                	ld	s3,24(sp)
    80002430:	6a42                	ld	s4,16(sp)
    80002432:	6aa2                	ld	s5,8(sp)
    80002434:	6121                	addi	sp,sp,64
    80002436:	8082                	ret

0000000080002438 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002438:	7179                	addi	sp,sp,-48
    8000243a:	f406                	sd	ra,40(sp)
    8000243c:	f022                	sd	s0,32(sp)
    8000243e:	ec26                	sd	s1,24(sp)
    80002440:	e84a                	sd	s2,16(sp)
    80002442:	e44e                	sd	s3,8(sp)
    80002444:	1800                	addi	s0,sp,48
    80002446:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002448:	00010497          	auipc	s1,0x10
    8000244c:	92048493          	addi	s1,s1,-1760 # 80011d68 <proc>
    80002450:	00016997          	auipc	s3,0x16
    80002454:	b1898993          	addi	s3,s3,-1256 # 80017f68 <tickslock>
    acquire(&p->lock);
    80002458:	8526                	mv	a0,s1
    8000245a:	fffff097          	auipc	ra,0xfffff
    8000245e:	808080e7          	jalr	-2040(ra) # 80000c62 <acquire>
    if(p->pid == pid){
    80002462:	5c9c                	lw	a5,56(s1)
    80002464:	01278d63          	beq	a5,s2,8000247e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002468:	8526                	mv	a0,s1
    8000246a:	fffff097          	auipc	ra,0xfffff
    8000246e:	8ac080e7          	jalr	-1876(ra) # 80000d16 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002472:	18848493          	addi	s1,s1,392
    80002476:	ff3491e3          	bne	s1,s3,80002458 <kill+0x20>
  }
  return -1;
    8000247a:	557d                	li	a0,-1
    8000247c:	a821                	j	80002494 <kill+0x5c>
      p->killed = 1;
    8000247e:	4785                	li	a5,1
    80002480:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002482:	4c98                	lw	a4,24(s1)
    80002484:	00f70f63          	beq	a4,a5,800024a2 <kill+0x6a>
      release(&p->lock);
    80002488:	8526                	mv	a0,s1
    8000248a:	fffff097          	auipc	ra,0xfffff
    8000248e:	88c080e7          	jalr	-1908(ra) # 80000d16 <release>
      return 0;
    80002492:	4501                	li	a0,0
}
    80002494:	70a2                	ld	ra,40(sp)
    80002496:	7402                	ld	s0,32(sp)
    80002498:	64e2                	ld	s1,24(sp)
    8000249a:	6942                	ld	s2,16(sp)
    8000249c:	69a2                	ld	s3,8(sp)
    8000249e:	6145                	addi	sp,sp,48
    800024a0:	8082                	ret
        p->state = RUNNABLE;
    800024a2:	4789                	li	a5,2
    800024a4:	cc9c                	sw	a5,24(s1)
    800024a6:	b7cd                	j	80002488 <kill+0x50>

00000000800024a8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024a8:	7179                	addi	sp,sp,-48
    800024aa:	f406                	sd	ra,40(sp)
    800024ac:	f022                	sd	s0,32(sp)
    800024ae:	ec26                	sd	s1,24(sp)
    800024b0:	e84a                	sd	s2,16(sp)
    800024b2:	e44e                	sd	s3,8(sp)
    800024b4:	e052                	sd	s4,0(sp)
    800024b6:	1800                	addi	s0,sp,48
    800024b8:	84aa                	mv	s1,a0
    800024ba:	892e                	mv	s2,a1
    800024bc:	89b2                	mv	s3,a2
    800024be:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024c0:	fffff097          	auipc	ra,0xfffff
    800024c4:	56e080e7          	jalr	1390(ra) # 80001a2e <myproc>
  if(user_dst){
    800024c8:	c08d                	beqz	s1,800024ea <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024ca:	86d2                	mv	a3,s4
    800024cc:	864e                	mv	a2,s3
    800024ce:	85ca                	mv	a1,s2
    800024d0:	6928                	ld	a0,80(a0)
    800024d2:	fffff097          	auipc	ra,0xfffff
    800024d6:	24e080e7          	jalr	590(ra) # 80001720 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024da:	70a2                	ld	ra,40(sp)
    800024dc:	7402                	ld	s0,32(sp)
    800024de:	64e2                	ld	s1,24(sp)
    800024e0:	6942                	ld	s2,16(sp)
    800024e2:	69a2                	ld	s3,8(sp)
    800024e4:	6a02                	ld	s4,0(sp)
    800024e6:	6145                	addi	sp,sp,48
    800024e8:	8082                	ret
    memmove((char *)dst, src, len);
    800024ea:	000a061b          	sext.w	a2,s4
    800024ee:	85ce                	mv	a1,s3
    800024f0:	854a                	mv	a0,s2
    800024f2:	fffff097          	auipc	ra,0xfffff
    800024f6:	8c8080e7          	jalr	-1848(ra) # 80000dba <memmove>
    return 0;
    800024fa:	8526                	mv	a0,s1
    800024fc:	bff9                	j	800024da <either_copyout+0x32>

00000000800024fe <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024fe:	7179                	addi	sp,sp,-48
    80002500:	f406                	sd	ra,40(sp)
    80002502:	f022                	sd	s0,32(sp)
    80002504:	ec26                	sd	s1,24(sp)
    80002506:	e84a                	sd	s2,16(sp)
    80002508:	e44e                	sd	s3,8(sp)
    8000250a:	e052                	sd	s4,0(sp)
    8000250c:	1800                	addi	s0,sp,48
    8000250e:	892a                	mv	s2,a0
    80002510:	84ae                	mv	s1,a1
    80002512:	89b2                	mv	s3,a2
    80002514:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002516:	fffff097          	auipc	ra,0xfffff
    8000251a:	518080e7          	jalr	1304(ra) # 80001a2e <myproc>
  if(user_src){
    8000251e:	c08d                	beqz	s1,80002540 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002520:	86d2                	mv	a3,s4
    80002522:	864e                	mv	a2,s3
    80002524:	85ca                	mv	a1,s2
    80002526:	6928                	ld	a0,80(a0)
    80002528:	fffff097          	auipc	ra,0xfffff
    8000252c:	284080e7          	jalr	644(ra) # 800017ac <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002530:	70a2                	ld	ra,40(sp)
    80002532:	7402                	ld	s0,32(sp)
    80002534:	64e2                	ld	s1,24(sp)
    80002536:	6942                	ld	s2,16(sp)
    80002538:	69a2                	ld	s3,8(sp)
    8000253a:	6a02                	ld	s4,0(sp)
    8000253c:	6145                	addi	sp,sp,48
    8000253e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002540:	000a061b          	sext.w	a2,s4
    80002544:	85ce                	mv	a1,s3
    80002546:	854a                	mv	a0,s2
    80002548:	fffff097          	auipc	ra,0xfffff
    8000254c:	872080e7          	jalr	-1934(ra) # 80000dba <memmove>
    return 0;
    80002550:	8526                	mv	a0,s1
    80002552:	bff9                	j	80002530 <either_copyin+0x32>

0000000080002554 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002554:	715d                	addi	sp,sp,-80
    80002556:	e486                	sd	ra,72(sp)
    80002558:	e0a2                	sd	s0,64(sp)
    8000255a:	fc26                	sd	s1,56(sp)
    8000255c:	f84a                	sd	s2,48(sp)
    8000255e:	f44e                	sd	s3,40(sp)
    80002560:	f052                	sd	s4,32(sp)
    80002562:	ec56                	sd	s5,24(sp)
    80002564:	e85a                	sd	s6,16(sp)
    80002566:	e45e                	sd	s7,8(sp)
    80002568:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000256a:	00006517          	auipc	a0,0x6
    8000256e:	b6650513          	addi	a0,a0,-1178 # 800080d0 <digits+0x88>
    80002572:	ffffe097          	auipc	ra,0xffffe
    80002576:	0b0080e7          	jalr	176(ra) # 80000622 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000257a:	00010497          	auipc	s1,0x10
    8000257e:	94648493          	addi	s1,s1,-1722 # 80011ec0 <proc+0x158>
    80002582:	00016917          	auipc	s2,0x16
    80002586:	b3e90913          	addi	s2,s2,-1218 # 800180c0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000258a:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000258c:	00006997          	auipc	s3,0x6
    80002590:	ce498993          	addi	s3,s3,-796 # 80008270 <digits+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80002594:	00006a97          	auipc	s5,0x6
    80002598:	ce4a8a93          	addi	s5,s5,-796 # 80008278 <digits+0x230>
    printf("\n");
    8000259c:	00006a17          	auipc	s4,0x6
    800025a0:	b34a0a13          	addi	s4,s4,-1228 # 800080d0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025a4:	00006b97          	auipc	s7,0x6
    800025a8:	d0cb8b93          	addi	s7,s7,-756 # 800082b0 <states.0>
    800025ac:	a00d                	j	800025ce <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800025ae:	ee06a583          	lw	a1,-288(a3)
    800025b2:	8556                	mv	a0,s5
    800025b4:	ffffe097          	auipc	ra,0xffffe
    800025b8:	06e080e7          	jalr	110(ra) # 80000622 <printf>
    printf("\n");
    800025bc:	8552                	mv	a0,s4
    800025be:	ffffe097          	auipc	ra,0xffffe
    800025c2:	064080e7          	jalr	100(ra) # 80000622 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025c6:	18848493          	addi	s1,s1,392
    800025ca:	03248163          	beq	s1,s2,800025ec <procdump+0x98>
    if(p->state == UNUSED)
    800025ce:	86a6                	mv	a3,s1
    800025d0:	ec04a783          	lw	a5,-320(s1)
    800025d4:	dbed                	beqz	a5,800025c6 <procdump+0x72>
      state = "???";
    800025d6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025d8:	fcfb6be3          	bltu	s6,a5,800025ae <procdump+0x5a>
    800025dc:	1782                	slli	a5,a5,0x20
    800025de:	9381                	srli	a5,a5,0x20
    800025e0:	078e                	slli	a5,a5,0x3
    800025e2:	97de                	add	a5,a5,s7
    800025e4:	6390                	ld	a2,0(a5)
    800025e6:	f661                	bnez	a2,800025ae <procdump+0x5a>
      state = "???";
    800025e8:	864e                	mv	a2,s3
    800025ea:	b7d1                	j	800025ae <procdump+0x5a>
  }
    800025ec:	60a6                	ld	ra,72(sp)
    800025ee:	6406                	ld	s0,64(sp)
    800025f0:	74e2                	ld	s1,56(sp)
    800025f2:	7942                	ld	s2,48(sp)
    800025f4:	79a2                	ld	s3,40(sp)
    800025f6:	7a02                	ld	s4,32(sp)
    800025f8:	6ae2                	ld	s5,24(sp)
    800025fa:	6b42                	ld	s6,16(sp)
    800025fc:	6ba2                	ld	s7,8(sp)
    800025fe:	6161                	addi	sp,sp,80
    80002600:	8082                	ret

0000000080002602 <swtch>:
    80002602:	00153023          	sd	ra,0(a0)
    80002606:	00253423          	sd	sp,8(a0)
    8000260a:	e900                	sd	s0,16(a0)
    8000260c:	ed04                	sd	s1,24(a0)
    8000260e:	03253023          	sd	s2,32(a0)
    80002612:	03353423          	sd	s3,40(a0)
    80002616:	03453823          	sd	s4,48(a0)
    8000261a:	03553c23          	sd	s5,56(a0)
    8000261e:	05653023          	sd	s6,64(a0)
    80002622:	05753423          	sd	s7,72(a0)
    80002626:	05853823          	sd	s8,80(a0)
    8000262a:	05953c23          	sd	s9,88(a0)
    8000262e:	07a53023          	sd	s10,96(a0)
    80002632:	07b53423          	sd	s11,104(a0)
    80002636:	0005b083          	ld	ra,0(a1)
    8000263a:	0085b103          	ld	sp,8(a1)
    8000263e:	6980                	ld	s0,16(a1)
    80002640:	6d84                	ld	s1,24(a1)
    80002642:	0205b903          	ld	s2,32(a1)
    80002646:	0285b983          	ld	s3,40(a1)
    8000264a:	0305ba03          	ld	s4,48(a1)
    8000264e:	0385ba83          	ld	s5,56(a1)
    80002652:	0405bb03          	ld	s6,64(a1)
    80002656:	0485bb83          	ld	s7,72(a1)
    8000265a:	0505bc03          	ld	s8,80(a1)
    8000265e:	0585bc83          	ld	s9,88(a1)
    80002662:	0605bd03          	ld	s10,96(a1)
    80002666:	0685bd83          	ld	s11,104(a1)
    8000266a:	8082                	ret

000000008000266c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000266c:	1141                	addi	sp,sp,-16
    8000266e:	e406                	sd	ra,8(sp)
    80002670:	e022                	sd	s0,0(sp)
    80002672:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002674:	00006597          	auipc	a1,0x6
    80002678:	c6458593          	addi	a1,a1,-924 # 800082d8 <states.0+0x28>
    8000267c:	00016517          	auipc	a0,0x16
    80002680:	8ec50513          	addi	a0,a0,-1812 # 80017f68 <tickslock>
    80002684:	ffffe097          	auipc	ra,0xffffe
    80002688:	54e080e7          	jalr	1358(ra) # 80000bd2 <initlock>
}
    8000268c:	60a2                	ld	ra,8(sp)
    8000268e:	6402                	ld	s0,0(sp)
    80002690:	0141                	addi	sp,sp,16
    80002692:	8082                	ret

0000000080002694 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002694:	1141                	addi	sp,sp,-16
    80002696:	e422                	sd	s0,8(sp)
    80002698:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000269a:	00003797          	auipc	a5,0x3
    8000269e:	59678793          	addi	a5,a5,1430 # 80005c30 <kernelvec>
    800026a2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800026a6:	6422                	ld	s0,8(sp)
    800026a8:	0141                	addi	sp,sp,16
    800026aa:	8082                	ret

00000000800026ac <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800026ac:	1141                	addi	sp,sp,-16
    800026ae:	e406                	sd	ra,8(sp)
    800026b0:	e022                	sd	s0,0(sp)
    800026b2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800026b4:	fffff097          	auipc	ra,0xfffff
    800026b8:	37a080e7          	jalr	890(ra) # 80001a2e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026bc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800026c0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026c2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800026c6:	00005617          	auipc	a2,0x5
    800026ca:	93a60613          	addi	a2,a2,-1734 # 80007000 <_trampoline>
    800026ce:	00005697          	auipc	a3,0x5
    800026d2:	93268693          	addi	a3,a3,-1742 # 80007000 <_trampoline>
    800026d6:	8e91                	sub	a3,a3,a2
    800026d8:	040007b7          	lui	a5,0x4000
    800026dc:	17fd                	addi	a5,a5,-1
    800026de:	07b2                	slli	a5,a5,0xc
    800026e0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026e2:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800026e6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800026e8:	180026f3          	csrr	a3,satp
    800026ec:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800026ee:	6d38                	ld	a4,88(a0)
    800026f0:	6134                	ld	a3,64(a0)
    800026f2:	6585                	lui	a1,0x1
    800026f4:	96ae                	add	a3,a3,a1
    800026f6:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800026f8:	6d38                	ld	a4,88(a0)
    800026fa:	00000697          	auipc	a3,0x0
    800026fe:	13868693          	addi	a3,a3,312 # 80002832 <usertrap>
    80002702:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002704:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002706:	8692                	mv	a3,tp
    80002708:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000270a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000270e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002712:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002716:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000271a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000271c:	6f18                	ld	a4,24(a4)
    8000271e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002722:	692c                	ld	a1,80(a0)
    80002724:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002726:	00005717          	auipc	a4,0x5
    8000272a:	96a70713          	addi	a4,a4,-1686 # 80007090 <userret>
    8000272e:	8f11                	sub	a4,a4,a2
    80002730:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002732:	577d                	li	a4,-1
    80002734:	177e                	slli	a4,a4,0x3f
    80002736:	8dd9                	or	a1,a1,a4
    80002738:	02000537          	lui	a0,0x2000
    8000273c:	157d                	addi	a0,a0,-1
    8000273e:	0536                	slli	a0,a0,0xd
    80002740:	9782                	jalr	a5
}
    80002742:	60a2                	ld	ra,8(sp)
    80002744:	6402                	ld	s0,0(sp)
    80002746:	0141                	addi	sp,sp,16
    80002748:	8082                	ret

000000008000274a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000274a:	1101                	addi	sp,sp,-32
    8000274c:	ec06                	sd	ra,24(sp)
    8000274e:	e822                	sd	s0,16(sp)
    80002750:	e426                	sd	s1,8(sp)
    80002752:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002754:	00016497          	auipc	s1,0x16
    80002758:	81448493          	addi	s1,s1,-2028 # 80017f68 <tickslock>
    8000275c:	8526                	mv	a0,s1
    8000275e:	ffffe097          	auipc	ra,0xffffe
    80002762:	504080e7          	jalr	1284(ra) # 80000c62 <acquire>
  ticks++;
    80002766:	00007517          	auipc	a0,0x7
    8000276a:	8ba50513          	addi	a0,a0,-1862 # 80009020 <ticks>
    8000276e:	411c                	lw	a5,0(a0)
    80002770:	2785                	addiw	a5,a5,1
    80002772:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002774:	00000097          	auipc	ra,0x0
    80002778:	c5a080e7          	jalr	-934(ra) # 800023ce <wakeup>
  release(&tickslock);
    8000277c:	8526                	mv	a0,s1
    8000277e:	ffffe097          	auipc	ra,0xffffe
    80002782:	598080e7          	jalr	1432(ra) # 80000d16 <release>
}
    80002786:	60e2                	ld	ra,24(sp)
    80002788:	6442                	ld	s0,16(sp)
    8000278a:	64a2                	ld	s1,8(sp)
    8000278c:	6105                	addi	sp,sp,32
    8000278e:	8082                	ret

0000000080002790 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002790:	1101                	addi	sp,sp,-32
    80002792:	ec06                	sd	ra,24(sp)
    80002794:	e822                	sd	s0,16(sp)
    80002796:	e426                	sd	s1,8(sp)
    80002798:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000279a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000279e:	00074d63          	bltz	a4,800027b8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800027a2:	57fd                	li	a5,-1
    800027a4:	17fe                	slli	a5,a5,0x3f
    800027a6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800027a8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800027aa:	06f70363          	beq	a4,a5,80002810 <devintr+0x80>
  }
}
    800027ae:	60e2                	ld	ra,24(sp)
    800027b0:	6442                	ld	s0,16(sp)
    800027b2:	64a2                	ld	s1,8(sp)
    800027b4:	6105                	addi	sp,sp,32
    800027b6:	8082                	ret
     (scause & 0xff) == 9){
    800027b8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    800027bc:	46a5                	li	a3,9
    800027be:	fed792e3          	bne	a5,a3,800027a2 <devintr+0x12>
    int irq = plic_claim();
    800027c2:	00003097          	auipc	ra,0x3
    800027c6:	576080e7          	jalr	1398(ra) # 80005d38 <plic_claim>
    800027ca:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800027cc:	47a9                	li	a5,10
    800027ce:	02f50763          	beq	a0,a5,800027fc <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    800027d2:	4785                	li	a5,1
    800027d4:	02f50963          	beq	a0,a5,80002806 <devintr+0x76>
    return 1;
    800027d8:	4505                	li	a0,1
    } else if(irq){
    800027da:	d8f1                	beqz	s1,800027ae <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    800027dc:	85a6                	mv	a1,s1
    800027de:	00006517          	auipc	a0,0x6
    800027e2:	b0250513          	addi	a0,a0,-1278 # 800082e0 <states.0+0x30>
    800027e6:	ffffe097          	auipc	ra,0xffffe
    800027ea:	e3c080e7          	jalr	-452(ra) # 80000622 <printf>
      plic_complete(irq);
    800027ee:	8526                	mv	a0,s1
    800027f0:	00003097          	auipc	ra,0x3
    800027f4:	56c080e7          	jalr	1388(ra) # 80005d5c <plic_complete>
    return 1;
    800027f8:	4505                	li	a0,1
    800027fa:	bf55                	j	800027ae <devintr+0x1e>
      uartintr();
    800027fc:	ffffe097          	auipc	ra,0xffffe
    80002800:	22a080e7          	jalr	554(ra) # 80000a26 <uartintr>
    80002804:	b7ed                	j	800027ee <devintr+0x5e>
      virtio_disk_intr();
    80002806:	00004097          	auipc	ra,0x4
    8000280a:	9d0080e7          	jalr	-1584(ra) # 800061d6 <virtio_disk_intr>
    8000280e:	b7c5                	j	800027ee <devintr+0x5e>
    if(cpuid() == 0){
    80002810:	fffff097          	auipc	ra,0xfffff
    80002814:	1f2080e7          	jalr	498(ra) # 80001a02 <cpuid>
    80002818:	c901                	beqz	a0,80002828 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000281a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000281e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002820:	14479073          	csrw	sip,a5
    return 2;
    80002824:	4509                	li	a0,2
    80002826:	b761                	j	800027ae <devintr+0x1e>
      clockintr();
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	f22080e7          	jalr	-222(ra) # 8000274a <clockintr>
    80002830:	b7ed                	j	8000281a <devintr+0x8a>

0000000080002832 <usertrap>:
{
    80002832:	1101                	addi	sp,sp,-32
    80002834:	ec06                	sd	ra,24(sp)
    80002836:	e822                	sd	s0,16(sp)
    80002838:	e426                	sd	s1,8(sp)
    8000283a:	e04a                	sd	s2,0(sp)
    8000283c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000283e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002842:	1007f793          	andi	a5,a5,256
    80002846:	e3ad                	bnez	a5,800028a8 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002848:	00003797          	auipc	a5,0x3
    8000284c:	3e878793          	addi	a5,a5,1000 # 80005c30 <kernelvec>
    80002850:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002854:	fffff097          	auipc	ra,0xfffff
    80002858:	1da080e7          	jalr	474(ra) # 80001a2e <myproc>
    8000285c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000285e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002860:	14102773          	csrr	a4,sepc
    80002864:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002866:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000286a:	47a1                	li	a5,8
    8000286c:	04f71c63          	bne	a4,a5,800028c4 <usertrap+0x92>
    if(p->killed)
    80002870:	591c                	lw	a5,48(a0)
    80002872:	e3b9                	bnez	a5,800028b8 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002874:	6cb8                	ld	a4,88(s1)
    80002876:	6f1c                	ld	a5,24(a4)
    80002878:	0791                	addi	a5,a5,4
    8000287a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000287c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002880:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002884:	10079073          	csrw	sstatus,a5
    syscall();
    80002888:	00000097          	auipc	ra,0x0
    8000288c:	306080e7          	jalr	774(ra) # 80002b8e <syscall>
  if(p->killed)
    80002890:	589c                	lw	a5,48(s1)
    80002892:	e7c5                	bnez	a5,8000293a <usertrap+0x108>
  usertrapret();
    80002894:	00000097          	auipc	ra,0x0
    80002898:	e18080e7          	jalr	-488(ra) # 800026ac <usertrapret>
}
    8000289c:	60e2                	ld	ra,24(sp)
    8000289e:	6442                	ld	s0,16(sp)
    800028a0:	64a2                	ld	s1,8(sp)
    800028a2:	6902                	ld	s2,0(sp)
    800028a4:	6105                	addi	sp,sp,32
    800028a6:	8082                	ret
    panic("usertrap: not from user mode");
    800028a8:	00006517          	auipc	a0,0x6
    800028ac:	a5850513          	addi	a0,a0,-1448 # 80008300 <states.0+0x50>
    800028b0:	ffffe097          	auipc	ra,0xffffe
    800028b4:	d20080e7          	jalr	-736(ra) # 800005d0 <panic>
      exit(-1);
    800028b8:	557d                	li	a0,-1
    800028ba:	00000097          	auipc	ra,0x0
    800028be:	84e080e7          	jalr	-1970(ra) # 80002108 <exit>
    800028c2:	bf4d                	j	80002874 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    800028c4:	00000097          	auipc	ra,0x0
    800028c8:	ecc080e7          	jalr	-308(ra) # 80002790 <devintr>
    800028cc:	892a                	mv	s2,a0
    800028ce:	c501                	beqz	a0,800028d6 <usertrap+0xa4>
  if(p->killed)
    800028d0:	589c                	lw	a5,48(s1)
    800028d2:	c3a1                	beqz	a5,80002912 <usertrap+0xe0>
    800028d4:	a815                	j	80002908 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028d6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800028da:	5c90                	lw	a2,56(s1)
    800028dc:	00006517          	auipc	a0,0x6
    800028e0:	a4450513          	addi	a0,a0,-1468 # 80008320 <states.0+0x70>
    800028e4:	ffffe097          	auipc	ra,0xffffe
    800028e8:	d3e080e7          	jalr	-706(ra) # 80000622 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028ec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800028f0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800028f4:	00006517          	auipc	a0,0x6
    800028f8:	a5c50513          	addi	a0,a0,-1444 # 80008350 <states.0+0xa0>
    800028fc:	ffffe097          	auipc	ra,0xffffe
    80002900:	d26080e7          	jalr	-730(ra) # 80000622 <printf>
    p->killed = 1;
    80002904:	4785                	li	a5,1
    80002906:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002908:	557d                	li	a0,-1
    8000290a:	fffff097          	auipc	ra,0xfffff
    8000290e:	7fe080e7          	jalr	2046(ra) # 80002108 <exit>
  if(which_dev == 2){   // timer interrupt
    80002912:	4789                	li	a5,2
    80002914:	f8f910e3          	bne	s2,a5,80002894 <usertrap+0x62>
    if(p->interval != 0 && ++p->passedticks == p->interval)
    80002918:	1684a783          	lw	a5,360(s1)
    8000291c:	cb91                	beqz	a5,80002930 <usertrap+0xfe>
    8000291e:	1784a703          	lw	a4,376(s1)
    80002922:	2705                	addiw	a4,a4,1
    80002924:	0007069b          	sext.w	a3,a4
    80002928:	16e4ac23          	sw	a4,376(s1)
    8000292c:	00d78963          	beq	a5,a3,8000293e <usertrap+0x10c>
    yield();
    80002930:	00000097          	auipc	ra,0x0
    80002934:	8e2080e7          	jalr	-1822(ra) # 80002212 <yield>
    80002938:	bfb1                	j	80002894 <usertrap+0x62>
  int which_dev = 0;
    8000293a:	4901                	li	s2,0
    8000293c:	b7f1                	j	80002908 <usertrap+0xd6>
      p->trapframecopy = p->trapframe + 512;
    8000293e:	6cbc                	ld	a5,88(s1)
      p->trapframecopy=p->trapframe;
    80002940:	18f4b023          	sd	a5,384(s1)
      p->trapframe->epc = p->handler;   
    80002944:	1704b703          	ld	a4,368(s1)
    80002948:	ef98                	sd	a4,24(a5)
    8000294a:	b7dd                	j	80002930 <usertrap+0xfe>

000000008000294c <kerneltrap>:
{
    8000294c:	7179                	addi	sp,sp,-48
    8000294e:	f406                	sd	ra,40(sp)
    80002950:	f022                	sd	s0,32(sp)
    80002952:	ec26                	sd	s1,24(sp)
    80002954:	e84a                	sd	s2,16(sp)
    80002956:	e44e                	sd	s3,8(sp)
    80002958:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000295a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000295e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002962:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002966:	1004f793          	andi	a5,s1,256
    8000296a:	cb85                	beqz	a5,8000299a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000296c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002970:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002972:	ef85                	bnez	a5,800029aa <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002974:	00000097          	auipc	ra,0x0
    80002978:	e1c080e7          	jalr	-484(ra) # 80002790 <devintr>
    8000297c:	cd1d                	beqz	a0,800029ba <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000297e:	4789                	li	a5,2
    80002980:	06f50a63          	beq	a0,a5,800029f4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002984:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002988:	10049073          	csrw	sstatus,s1
}
    8000298c:	70a2                	ld	ra,40(sp)
    8000298e:	7402                	ld	s0,32(sp)
    80002990:	64e2                	ld	s1,24(sp)
    80002992:	6942                	ld	s2,16(sp)
    80002994:	69a2                	ld	s3,8(sp)
    80002996:	6145                	addi	sp,sp,48
    80002998:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000299a:	00006517          	auipc	a0,0x6
    8000299e:	9d650513          	addi	a0,a0,-1578 # 80008370 <states.0+0xc0>
    800029a2:	ffffe097          	auipc	ra,0xffffe
    800029a6:	c2e080e7          	jalr	-978(ra) # 800005d0 <panic>
    panic("kerneltrap: interrupts enabled");
    800029aa:	00006517          	auipc	a0,0x6
    800029ae:	9ee50513          	addi	a0,a0,-1554 # 80008398 <states.0+0xe8>
    800029b2:	ffffe097          	auipc	ra,0xffffe
    800029b6:	c1e080e7          	jalr	-994(ra) # 800005d0 <panic>
    printf("scause %p\n", scause);
    800029ba:	85ce                	mv	a1,s3
    800029bc:	00006517          	auipc	a0,0x6
    800029c0:	9fc50513          	addi	a0,a0,-1540 # 800083b8 <states.0+0x108>
    800029c4:	ffffe097          	auipc	ra,0xffffe
    800029c8:	c5e080e7          	jalr	-930(ra) # 80000622 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029cc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029d0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800029d4:	00006517          	auipc	a0,0x6
    800029d8:	9f450513          	addi	a0,a0,-1548 # 800083c8 <states.0+0x118>
    800029dc:	ffffe097          	auipc	ra,0xffffe
    800029e0:	c46080e7          	jalr	-954(ra) # 80000622 <printf>
    panic("kerneltrap");
    800029e4:	00006517          	auipc	a0,0x6
    800029e8:	9fc50513          	addi	a0,a0,-1540 # 800083e0 <states.0+0x130>
    800029ec:	ffffe097          	auipc	ra,0xffffe
    800029f0:	be4080e7          	jalr	-1052(ra) # 800005d0 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800029f4:	fffff097          	auipc	ra,0xfffff
    800029f8:	03a080e7          	jalr	58(ra) # 80001a2e <myproc>
    800029fc:	d541                	beqz	a0,80002984 <kerneltrap+0x38>
    800029fe:	fffff097          	auipc	ra,0xfffff
    80002a02:	030080e7          	jalr	48(ra) # 80001a2e <myproc>
    80002a06:	4d18                	lw	a4,24(a0)
    80002a08:	478d                	li	a5,3
    80002a0a:	f6f71de3          	bne	a4,a5,80002984 <kerneltrap+0x38>
    yield();
    80002a0e:	00000097          	auipc	ra,0x0
    80002a12:	804080e7          	jalr	-2044(ra) # 80002212 <yield>
    80002a16:	b7bd                	j	80002984 <kerneltrap+0x38>

0000000080002a18 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a18:	1101                	addi	sp,sp,-32
    80002a1a:	ec06                	sd	ra,24(sp)
    80002a1c:	e822                	sd	s0,16(sp)
    80002a1e:	e426                	sd	s1,8(sp)
    80002a20:	1000                	addi	s0,sp,32
    80002a22:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a24:	fffff097          	auipc	ra,0xfffff
    80002a28:	00a080e7          	jalr	10(ra) # 80001a2e <myproc>
  switch (n) {
    80002a2c:	4795                	li	a5,5
    80002a2e:	0497e163          	bltu	a5,s1,80002a70 <argraw+0x58>
    80002a32:	048a                	slli	s1,s1,0x2
    80002a34:	00006717          	auipc	a4,0x6
    80002a38:	9e470713          	addi	a4,a4,-1564 # 80008418 <states.0+0x168>
    80002a3c:	94ba                	add	s1,s1,a4
    80002a3e:	409c                	lw	a5,0(s1)
    80002a40:	97ba                	add	a5,a5,a4
    80002a42:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002a44:	6d3c                	ld	a5,88(a0)
    80002a46:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002a48:	60e2                	ld	ra,24(sp)
    80002a4a:	6442                	ld	s0,16(sp)
    80002a4c:	64a2                	ld	s1,8(sp)
    80002a4e:	6105                	addi	sp,sp,32
    80002a50:	8082                	ret
    return p->trapframe->a1;
    80002a52:	6d3c                	ld	a5,88(a0)
    80002a54:	7fa8                	ld	a0,120(a5)
    80002a56:	bfcd                	j	80002a48 <argraw+0x30>
    return p->trapframe->a2;
    80002a58:	6d3c                	ld	a5,88(a0)
    80002a5a:	63c8                	ld	a0,128(a5)
    80002a5c:	b7f5                	j	80002a48 <argraw+0x30>
    return p->trapframe->a3;
    80002a5e:	6d3c                	ld	a5,88(a0)
    80002a60:	67c8                	ld	a0,136(a5)
    80002a62:	b7dd                	j	80002a48 <argraw+0x30>
    return p->trapframe->a4;
    80002a64:	6d3c                	ld	a5,88(a0)
    80002a66:	6bc8                	ld	a0,144(a5)
    80002a68:	b7c5                	j	80002a48 <argraw+0x30>
    return p->trapframe->a5;
    80002a6a:	6d3c                	ld	a5,88(a0)
    80002a6c:	6fc8                	ld	a0,152(a5)
    80002a6e:	bfe9                	j	80002a48 <argraw+0x30>
  panic("argraw");
    80002a70:	00006517          	auipc	a0,0x6
    80002a74:	98050513          	addi	a0,a0,-1664 # 800083f0 <states.0+0x140>
    80002a78:	ffffe097          	auipc	ra,0xffffe
    80002a7c:	b58080e7          	jalr	-1192(ra) # 800005d0 <panic>

0000000080002a80 <fetchaddr>:
{
    80002a80:	1101                	addi	sp,sp,-32
    80002a82:	ec06                	sd	ra,24(sp)
    80002a84:	e822                	sd	s0,16(sp)
    80002a86:	e426                	sd	s1,8(sp)
    80002a88:	e04a                	sd	s2,0(sp)
    80002a8a:	1000                	addi	s0,sp,32
    80002a8c:	84aa                	mv	s1,a0
    80002a8e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002a90:	fffff097          	auipc	ra,0xfffff
    80002a94:	f9e080e7          	jalr	-98(ra) # 80001a2e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002a98:	653c                	ld	a5,72(a0)
    80002a9a:	02f4f863          	bgeu	s1,a5,80002aca <fetchaddr+0x4a>
    80002a9e:	00848713          	addi	a4,s1,8
    80002aa2:	02e7e663          	bltu	a5,a4,80002ace <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002aa6:	46a1                	li	a3,8
    80002aa8:	8626                	mv	a2,s1
    80002aaa:	85ca                	mv	a1,s2
    80002aac:	6928                	ld	a0,80(a0)
    80002aae:	fffff097          	auipc	ra,0xfffff
    80002ab2:	cfe080e7          	jalr	-770(ra) # 800017ac <copyin>
    80002ab6:	00a03533          	snez	a0,a0
    80002aba:	40a00533          	neg	a0,a0
}
    80002abe:	60e2                	ld	ra,24(sp)
    80002ac0:	6442                	ld	s0,16(sp)
    80002ac2:	64a2                	ld	s1,8(sp)
    80002ac4:	6902                	ld	s2,0(sp)
    80002ac6:	6105                	addi	sp,sp,32
    80002ac8:	8082                	ret
    return -1;
    80002aca:	557d                	li	a0,-1
    80002acc:	bfcd                	j	80002abe <fetchaddr+0x3e>
    80002ace:	557d                	li	a0,-1
    80002ad0:	b7fd                	j	80002abe <fetchaddr+0x3e>

0000000080002ad2 <fetchstr>:
{
    80002ad2:	7179                	addi	sp,sp,-48
    80002ad4:	f406                	sd	ra,40(sp)
    80002ad6:	f022                	sd	s0,32(sp)
    80002ad8:	ec26                	sd	s1,24(sp)
    80002ada:	e84a                	sd	s2,16(sp)
    80002adc:	e44e                	sd	s3,8(sp)
    80002ade:	1800                	addi	s0,sp,48
    80002ae0:	892a                	mv	s2,a0
    80002ae2:	84ae                	mv	s1,a1
    80002ae4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002ae6:	fffff097          	auipc	ra,0xfffff
    80002aea:	f48080e7          	jalr	-184(ra) # 80001a2e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002aee:	86ce                	mv	a3,s3
    80002af0:	864a                	mv	a2,s2
    80002af2:	85a6                	mv	a1,s1
    80002af4:	6928                	ld	a0,80(a0)
    80002af6:	fffff097          	auipc	ra,0xfffff
    80002afa:	d44080e7          	jalr	-700(ra) # 8000183a <copyinstr>
  if(err < 0)
    80002afe:	00054763          	bltz	a0,80002b0c <fetchstr+0x3a>
  return strlen(buf);
    80002b02:	8526                	mv	a0,s1
    80002b04:	ffffe097          	auipc	ra,0xffffe
    80002b08:	3de080e7          	jalr	990(ra) # 80000ee2 <strlen>
}
    80002b0c:	70a2                	ld	ra,40(sp)
    80002b0e:	7402                	ld	s0,32(sp)
    80002b10:	64e2                	ld	s1,24(sp)
    80002b12:	6942                	ld	s2,16(sp)
    80002b14:	69a2                	ld	s3,8(sp)
    80002b16:	6145                	addi	sp,sp,48
    80002b18:	8082                	ret

0000000080002b1a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002b1a:	1101                	addi	sp,sp,-32
    80002b1c:	ec06                	sd	ra,24(sp)
    80002b1e:	e822                	sd	s0,16(sp)
    80002b20:	e426                	sd	s1,8(sp)
    80002b22:	1000                	addi	s0,sp,32
    80002b24:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b26:	00000097          	auipc	ra,0x0
    80002b2a:	ef2080e7          	jalr	-270(ra) # 80002a18 <argraw>
    80002b2e:	c088                	sw	a0,0(s1)
  return 0;
}
    80002b30:	4501                	li	a0,0
    80002b32:	60e2                	ld	ra,24(sp)
    80002b34:	6442                	ld	s0,16(sp)
    80002b36:	64a2                	ld	s1,8(sp)
    80002b38:	6105                	addi	sp,sp,32
    80002b3a:	8082                	ret

0000000080002b3c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002b3c:	1101                	addi	sp,sp,-32
    80002b3e:	ec06                	sd	ra,24(sp)
    80002b40:	e822                	sd	s0,16(sp)
    80002b42:	e426                	sd	s1,8(sp)
    80002b44:	1000                	addi	s0,sp,32
    80002b46:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b48:	00000097          	auipc	ra,0x0
    80002b4c:	ed0080e7          	jalr	-304(ra) # 80002a18 <argraw>
    80002b50:	e088                	sd	a0,0(s1)
  return 0;
}
    80002b52:	4501                	li	a0,0
    80002b54:	60e2                	ld	ra,24(sp)
    80002b56:	6442                	ld	s0,16(sp)
    80002b58:	64a2                	ld	s1,8(sp)
    80002b5a:	6105                	addi	sp,sp,32
    80002b5c:	8082                	ret

0000000080002b5e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b5e:	1101                	addi	sp,sp,-32
    80002b60:	ec06                	sd	ra,24(sp)
    80002b62:	e822                	sd	s0,16(sp)
    80002b64:	e426                	sd	s1,8(sp)
    80002b66:	e04a                	sd	s2,0(sp)
    80002b68:	1000                	addi	s0,sp,32
    80002b6a:	84ae                	mv	s1,a1
    80002b6c:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002b6e:	00000097          	auipc	ra,0x0
    80002b72:	eaa080e7          	jalr	-342(ra) # 80002a18 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002b76:	864a                	mv	a2,s2
    80002b78:	85a6                	mv	a1,s1
    80002b7a:	00000097          	auipc	ra,0x0
    80002b7e:	f58080e7          	jalr	-168(ra) # 80002ad2 <fetchstr>
}
    80002b82:	60e2                	ld	ra,24(sp)
    80002b84:	6442                	ld	s0,16(sp)
    80002b86:	64a2                	ld	s1,8(sp)
    80002b88:	6902                	ld	s2,0(sp)
    80002b8a:	6105                	addi	sp,sp,32
    80002b8c:	8082                	ret

0000000080002b8e <syscall>:
[SYS_sigreturn] sys_sigreturn,  // lab4-3
};

void
syscall(void)
{
    80002b8e:	1101                	addi	sp,sp,-32
    80002b90:	ec06                	sd	ra,24(sp)
    80002b92:	e822                	sd	s0,16(sp)
    80002b94:	e426                	sd	s1,8(sp)
    80002b96:	e04a                	sd	s2,0(sp)
    80002b98:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b9a:	fffff097          	auipc	ra,0xfffff
    80002b9e:	e94080e7          	jalr	-364(ra) # 80001a2e <myproc>
    80002ba2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002ba4:	05853903          	ld	s2,88(a0)
    80002ba8:	0a893783          	ld	a5,168(s2)
    80002bac:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002bb0:	37fd                	addiw	a5,a5,-1
    80002bb2:	4759                	li	a4,22
    80002bb4:	00f76f63          	bltu	a4,a5,80002bd2 <syscall+0x44>
    80002bb8:	00369713          	slli	a4,a3,0x3
    80002bbc:	00006797          	auipc	a5,0x6
    80002bc0:	87478793          	addi	a5,a5,-1932 # 80008430 <syscalls>
    80002bc4:	97ba                	add	a5,a5,a4
    80002bc6:	639c                	ld	a5,0(a5)
    80002bc8:	c789                	beqz	a5,80002bd2 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002bca:	9782                	jalr	a5
    80002bcc:	06a93823          	sd	a0,112(s2)
    80002bd0:	a839                	j	80002bee <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002bd2:	15848613          	addi	a2,s1,344
    80002bd6:	5c8c                	lw	a1,56(s1)
    80002bd8:	00006517          	auipc	a0,0x6
    80002bdc:	82050513          	addi	a0,a0,-2016 # 800083f8 <states.0+0x148>
    80002be0:	ffffe097          	auipc	ra,0xffffe
    80002be4:	a42080e7          	jalr	-1470(ra) # 80000622 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002be8:	6cbc                	ld	a5,88(s1)
    80002bea:	577d                	li	a4,-1
    80002bec:	fbb8                	sd	a4,112(a5)
  }
    80002bee:	60e2                	ld	ra,24(sp)
    80002bf0:	6442                	ld	s0,16(sp)
    80002bf2:	64a2                	ld	s1,8(sp)
    80002bf4:	6902                	ld	s2,0(sp)
    80002bf6:	6105                	addi	sp,sp,32
    80002bf8:	8082                	ret

0000000080002bfa <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002bfa:	1101                	addi	sp,sp,-32
    80002bfc:	ec06                	sd	ra,24(sp)
    80002bfe:	e822                	sd	s0,16(sp)
    80002c00:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002c02:	fec40593          	addi	a1,s0,-20
    80002c06:	4501                	li	a0,0
    80002c08:	00000097          	auipc	ra,0x0
    80002c0c:	f12080e7          	jalr	-238(ra) # 80002b1a <argint>
    return -1;
    80002c10:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c12:	00054963          	bltz	a0,80002c24 <sys_exit+0x2a>
  exit(n);
    80002c16:	fec42503          	lw	a0,-20(s0)
    80002c1a:	fffff097          	auipc	ra,0xfffff
    80002c1e:	4ee080e7          	jalr	1262(ra) # 80002108 <exit>
  return 0;  // not reached
    80002c22:	4781                	li	a5,0
}
    80002c24:	853e                	mv	a0,a5
    80002c26:	60e2                	ld	ra,24(sp)
    80002c28:	6442                	ld	s0,16(sp)
    80002c2a:	6105                	addi	sp,sp,32
    80002c2c:	8082                	ret

0000000080002c2e <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c2e:	1141                	addi	sp,sp,-16
    80002c30:	e406                	sd	ra,8(sp)
    80002c32:	e022                	sd	s0,0(sp)
    80002c34:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c36:	fffff097          	auipc	ra,0xfffff
    80002c3a:	df8080e7          	jalr	-520(ra) # 80001a2e <myproc>
}
    80002c3e:	5d08                	lw	a0,56(a0)
    80002c40:	60a2                	ld	ra,8(sp)
    80002c42:	6402                	ld	s0,0(sp)
    80002c44:	0141                	addi	sp,sp,16
    80002c46:	8082                	ret

0000000080002c48 <sys_fork>:

uint64
sys_fork(void)
{
    80002c48:	1141                	addi	sp,sp,-16
    80002c4a:	e406                	sd	ra,8(sp)
    80002c4c:	e022                	sd	s0,0(sp)
    80002c4e:	0800                	addi	s0,sp,16
  return fork();
    80002c50:	fffff097          	auipc	ra,0xfffff
    80002c54:	1ae080e7          	jalr	430(ra) # 80001dfe <fork>
}
    80002c58:	60a2                	ld	ra,8(sp)
    80002c5a:	6402                	ld	s0,0(sp)
    80002c5c:	0141                	addi	sp,sp,16
    80002c5e:	8082                	ret

0000000080002c60 <sys_wait>:

uint64
sys_wait(void)
{
    80002c60:	1101                	addi	sp,sp,-32
    80002c62:	ec06                	sd	ra,24(sp)
    80002c64:	e822                	sd	s0,16(sp)
    80002c66:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002c68:	fe840593          	addi	a1,s0,-24
    80002c6c:	4501                	li	a0,0
    80002c6e:	00000097          	auipc	ra,0x0
    80002c72:	ece080e7          	jalr	-306(ra) # 80002b3c <argaddr>
    80002c76:	87aa                	mv	a5,a0
    return -1;
    80002c78:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002c7a:	0007c863          	bltz	a5,80002c8a <sys_wait+0x2a>
  return wait(p);
    80002c7e:	fe843503          	ld	a0,-24(s0)
    80002c82:	fffff097          	auipc	ra,0xfffff
    80002c86:	64a080e7          	jalr	1610(ra) # 800022cc <wait>
}
    80002c8a:	60e2                	ld	ra,24(sp)
    80002c8c:	6442                	ld	s0,16(sp)
    80002c8e:	6105                	addi	sp,sp,32
    80002c90:	8082                	ret

0000000080002c92 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002c92:	7179                	addi	sp,sp,-48
    80002c94:	f406                	sd	ra,40(sp)
    80002c96:	f022                	sd	s0,32(sp)
    80002c98:	ec26                	sd	s1,24(sp)
    80002c9a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002c9c:	fdc40593          	addi	a1,s0,-36
    80002ca0:	4501                	li	a0,0
    80002ca2:	00000097          	auipc	ra,0x0
    80002ca6:	e78080e7          	jalr	-392(ra) # 80002b1a <argint>
    return -1;
    80002caa:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002cac:	00054f63          	bltz	a0,80002cca <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002cb0:	fffff097          	auipc	ra,0xfffff
    80002cb4:	d7e080e7          	jalr	-642(ra) # 80001a2e <myproc>
    80002cb8:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002cba:	fdc42503          	lw	a0,-36(s0)
    80002cbe:	fffff097          	auipc	ra,0xfffff
    80002cc2:	0cc080e7          	jalr	204(ra) # 80001d8a <growproc>
    80002cc6:	00054863          	bltz	a0,80002cd6 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002cca:	8526                	mv	a0,s1
    80002ccc:	70a2                	ld	ra,40(sp)
    80002cce:	7402                	ld	s0,32(sp)
    80002cd0:	64e2                	ld	s1,24(sp)
    80002cd2:	6145                	addi	sp,sp,48
    80002cd4:	8082                	ret
    return -1;
    80002cd6:	54fd                	li	s1,-1
    80002cd8:	bfcd                	j	80002cca <sys_sbrk+0x38>

0000000080002cda <sys_sleep>:

uint64
sys_sleep(void)
{
    80002cda:	7139                	addi	sp,sp,-64
    80002cdc:	fc06                	sd	ra,56(sp)
    80002cde:	f822                	sd	s0,48(sp)
    80002ce0:	f426                	sd	s1,40(sp)
    80002ce2:	f04a                	sd	s2,32(sp)
    80002ce4:	ec4e                	sd	s3,24(sp)
    80002ce6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002ce8:	fcc40593          	addi	a1,s0,-52
    80002cec:	4501                	li	a0,0
    80002cee:	00000097          	auipc	ra,0x0
    80002cf2:	e2c080e7          	jalr	-468(ra) # 80002b1a <argint>
    return -1;
    80002cf6:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002cf8:	06054963          	bltz	a0,80002d6a <sys_sleep+0x90>
  acquire(&tickslock);
    80002cfc:	00015517          	auipc	a0,0x15
    80002d00:	26c50513          	addi	a0,a0,620 # 80017f68 <tickslock>
    80002d04:	ffffe097          	auipc	ra,0xffffe
    80002d08:	f5e080e7          	jalr	-162(ra) # 80000c62 <acquire>
  ticks0 = ticks;
    80002d0c:	00006917          	auipc	s2,0x6
    80002d10:	31492903          	lw	s2,788(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002d14:	fcc42783          	lw	a5,-52(s0)
    80002d18:	cf85                	beqz	a5,80002d50 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d1a:	00015997          	auipc	s3,0x15
    80002d1e:	24e98993          	addi	s3,s3,590 # 80017f68 <tickslock>
    80002d22:	00006497          	auipc	s1,0x6
    80002d26:	2fe48493          	addi	s1,s1,766 # 80009020 <ticks>
    if(myproc()->killed){
    80002d2a:	fffff097          	auipc	ra,0xfffff
    80002d2e:	d04080e7          	jalr	-764(ra) # 80001a2e <myproc>
    80002d32:	591c                	lw	a5,48(a0)
    80002d34:	e3b9                	bnez	a5,80002d7a <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    80002d36:	85ce                	mv	a1,s3
    80002d38:	8526                	mv	a0,s1
    80002d3a:	fffff097          	auipc	ra,0xfffff
    80002d3e:	514080e7          	jalr	1300(ra) # 8000224e <sleep>
  while(ticks - ticks0 < n){
    80002d42:	409c                	lw	a5,0(s1)
    80002d44:	412787bb          	subw	a5,a5,s2
    80002d48:	fcc42703          	lw	a4,-52(s0)
    80002d4c:	fce7efe3          	bltu	a5,a4,80002d2a <sys_sleep+0x50>
  }
  release(&tickslock);
    80002d50:	00015517          	auipc	a0,0x15
    80002d54:	21850513          	addi	a0,a0,536 # 80017f68 <tickslock>
    80002d58:	ffffe097          	auipc	ra,0xffffe
    80002d5c:	fbe080e7          	jalr	-66(ra) # 80000d16 <release>
  backtrace();  // lab4-2
    80002d60:	ffffe097          	auipc	ra,0xffffe
    80002d64:	814080e7          	jalr	-2028(ra) # 80000574 <backtrace>
  return 0;
    80002d68:	4781                	li	a5,0
}
    80002d6a:	853e                	mv	a0,a5
    80002d6c:	70e2                	ld	ra,56(sp)
    80002d6e:	7442                	ld	s0,48(sp)
    80002d70:	74a2                	ld	s1,40(sp)
    80002d72:	7902                	ld	s2,32(sp)
    80002d74:	69e2                	ld	s3,24(sp)
    80002d76:	6121                	addi	sp,sp,64
    80002d78:	8082                	ret
      release(&tickslock);
    80002d7a:	00015517          	auipc	a0,0x15
    80002d7e:	1ee50513          	addi	a0,a0,494 # 80017f68 <tickslock>
    80002d82:	ffffe097          	auipc	ra,0xffffe
    80002d86:	f94080e7          	jalr	-108(ra) # 80000d16 <release>
      return -1;
    80002d8a:	57fd                	li	a5,-1
    80002d8c:	bff9                	j	80002d6a <sys_sleep+0x90>

0000000080002d8e <sys_kill>:

uint64
sys_kill(void)
{
    80002d8e:	1101                	addi	sp,sp,-32
    80002d90:	ec06                	sd	ra,24(sp)
    80002d92:	e822                	sd	s0,16(sp)
    80002d94:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002d96:	fec40593          	addi	a1,s0,-20
    80002d9a:	4501                	li	a0,0
    80002d9c:	00000097          	auipc	ra,0x0
    80002da0:	d7e080e7          	jalr	-642(ra) # 80002b1a <argint>
    80002da4:	87aa                	mv	a5,a0
    return -1;
    80002da6:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002da8:	0007c863          	bltz	a5,80002db8 <sys_kill+0x2a>
  return kill(pid);
    80002dac:	fec42503          	lw	a0,-20(s0)
    80002db0:	fffff097          	auipc	ra,0xfffff
    80002db4:	688080e7          	jalr	1672(ra) # 80002438 <kill>
}
    80002db8:	60e2                	ld	ra,24(sp)
    80002dba:	6442                	ld	s0,16(sp)
    80002dbc:	6105                	addi	sp,sp,32
    80002dbe:	8082                	ret

0000000080002dc0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002dc0:	1101                	addi	sp,sp,-32
    80002dc2:	ec06                	sd	ra,24(sp)
    80002dc4:	e822                	sd	s0,16(sp)
    80002dc6:	e426                	sd	s1,8(sp)
    80002dc8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002dca:	00015517          	auipc	a0,0x15
    80002dce:	19e50513          	addi	a0,a0,414 # 80017f68 <tickslock>
    80002dd2:	ffffe097          	auipc	ra,0xffffe
    80002dd6:	e90080e7          	jalr	-368(ra) # 80000c62 <acquire>
  xticks = ticks;
    80002dda:	00006497          	auipc	s1,0x6
    80002dde:	2464a483          	lw	s1,582(s1) # 80009020 <ticks>
  release(&tickslock);
    80002de2:	00015517          	auipc	a0,0x15
    80002de6:	18650513          	addi	a0,a0,390 # 80017f68 <tickslock>
    80002dea:	ffffe097          	auipc	ra,0xffffe
    80002dee:	f2c080e7          	jalr	-212(ra) # 80000d16 <release>
  return xticks;
}
    80002df2:	02049513          	slli	a0,s1,0x20
    80002df6:	9101                	srli	a0,a0,0x20
    80002df8:	60e2                	ld	ra,24(sp)
    80002dfa:	6442                	ld	s0,16(sp)
    80002dfc:	64a2                	ld	s1,8(sp)
    80002dfe:	6105                	addi	sp,sp,32
    80002e00:	8082                	ret

0000000080002e02 <sys_sigalarm>:

// lab4-3
uint64 sys_sigalarm(void) {
    80002e02:	1101                	addi	sp,sp,-32
    80002e04:	ec06                	sd	ra,24(sp)
    80002e06:	e822                	sd	s0,16(sp)
    80002e08:	1000                	addi	s0,sp,32
    int interval;
    uint64 handler;
    struct proc *p;//保存到proc结构体当中

    if (argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    80002e0a:	fec40593          	addi	a1,s0,-20
    80002e0e:	4501                	li	a0,0
    80002e10:	00000097          	auipc	ra,0x0
    80002e14:	d0a080e7          	jalr	-758(ra) # 80002b1a <argint>
        return -1;
    80002e18:	57fd                	li	a5,-1
    if (argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    80002e1a:	02054f63          	bltz	a0,80002e58 <sys_sigalarm+0x56>
    80002e1e:	fe040593          	addi	a1,s0,-32
    80002e22:	4505                	li	a0,1
    80002e24:	00000097          	auipc	ra,0x0
    80002e28:	d18080e7          	jalr	-744(ra) # 80002b3c <argaddr>
    80002e2c:	02054b63          	bltz	a0,80002e62 <sys_sigalarm+0x60>
    80002e30:	fec42703          	lw	a4,-20(s0)
        return -1;
    80002e34:	57fd                	li	a5,-1
    if (argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    80002e36:	02074163          	bltz	a4,80002e58 <sys_sigalarm+0x56>
    }
    // lab4-3
    p = myproc();//用myproc函数获得当前的进程
    80002e3a:	fffff097          	auipc	ra,0xfffff
    80002e3e:	bf4080e7          	jalr	-1036(ra) # 80001a2e <myproc>
    p->interval = interval;
    80002e42:	fec42783          	lw	a5,-20(s0)
    80002e46:	16f52423          	sw	a5,360(a0)
    p->handler = handler;
    80002e4a:	fe043783          	ld	a5,-32(s0)
    80002e4e:	16f53823          	sd	a5,368(a0)
    p->passedticks = 0;
    80002e52:	16052c23          	sw	zero,376(a0)

    return 0;
    80002e56:	4781                	li	a5,0
}
    80002e58:	853e                	mv	a0,a5
    80002e5a:	60e2                	ld	ra,24(sp)
    80002e5c:	6442                	ld	s0,16(sp)
    80002e5e:	6105                	addi	sp,sp,32
    80002e60:	8082                	ret
        return -1;
    80002e62:	57fd                	li	a5,-1
    80002e64:	bfd5                	j	80002e58 <sys_sigalarm+0x56>

0000000080002e66 <sys_sigreturn>:

// lab4-3
uint64 sys_sigreturn(void) {
    80002e66:	1101                	addi	sp,sp,-32
    80002e68:	ec06                	sd	ra,24(sp)
    80002e6a:	e822                	sd	s0,16(sp)
    80002e6c:	e426                	sd	s1,8(sp)
    80002e6e:	1000                	addi	s0,sp,32
    struct proc* p = myproc();
    80002e70:	fffff097          	auipc	ra,0xfffff
    80002e74:	bbe080e7          	jalr	-1090(ra) # 80001a2e <myproc>
    80002e78:	84aa                	mv	s1,a0
    // trapframecopy 必须是和 trapframe一样的，或者差个大小
    if(p->trapframecopy != p->trapframe + 512) {
    80002e7a:	18053583          	ld	a1,384(a0)
    80002e7e:	6d38                	ld	a4,88(a0)
    80002e80:	000247b7          	lui	a5,0x24
    80002e84:	97ba                	add	a5,a5,a4
        return -1;
    80002e86:	557d                	li	a0,-1
    if(p->trapframecopy != p->trapframe + 512) {
    80002e88:	00f58763          	beq	a1,a5,80002e96 <sys_sigreturn+0x30>
    }
    memmove(p->trapframe, p->trapframecopy, sizeof(struct trapframe));   // 拷贝
    p->passedticks = 0;     // 初始化，为下一次恢复
    p->trapframecopy = 0;
    return 0;
    80002e8c:	60e2                	ld	ra,24(sp)
    80002e8e:	6442                	ld	s0,16(sp)
    80002e90:	64a2                	ld	s1,8(sp)
    80002e92:	6105                	addi	sp,sp,32
    80002e94:	8082                	ret
    memmove(p->trapframe, p->trapframecopy, sizeof(struct trapframe));   // 拷贝
    80002e96:	12000613          	li	a2,288
    80002e9a:	853a                	mv	a0,a4
    80002e9c:	ffffe097          	auipc	ra,0xffffe
    80002ea0:	f1e080e7          	jalr	-226(ra) # 80000dba <memmove>
    p->passedticks = 0;     // 初始化，为下一次恢复
    80002ea4:	1604ac23          	sw	zero,376(s1)
    p->trapframecopy = 0;
    80002ea8:	1804b023          	sd	zero,384(s1)
    return 0;
    80002eac:	4501                	li	a0,0
    80002eae:	bff9                	j	80002e8c <sys_sigreturn+0x26>

0000000080002eb0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002eb0:	7179                	addi	sp,sp,-48
    80002eb2:	f406                	sd	ra,40(sp)
    80002eb4:	f022                	sd	s0,32(sp)
    80002eb6:	ec26                	sd	s1,24(sp)
    80002eb8:	e84a                	sd	s2,16(sp)
    80002eba:	e44e                	sd	s3,8(sp)
    80002ebc:	e052                	sd	s4,0(sp)
    80002ebe:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ec0:	00005597          	auipc	a1,0x5
    80002ec4:	63058593          	addi	a1,a1,1584 # 800084f0 <syscalls+0xc0>
    80002ec8:	00015517          	auipc	a0,0x15
    80002ecc:	0b850513          	addi	a0,a0,184 # 80017f80 <bcache>
    80002ed0:	ffffe097          	auipc	ra,0xffffe
    80002ed4:	d02080e7          	jalr	-766(ra) # 80000bd2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002ed8:	0001d797          	auipc	a5,0x1d
    80002edc:	0a878793          	addi	a5,a5,168 # 8001ff80 <bcache+0x8000>
    80002ee0:	0001d717          	auipc	a4,0x1d
    80002ee4:	30870713          	addi	a4,a4,776 # 800201e8 <bcache+0x8268>
    80002ee8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002eec:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ef0:	00015497          	auipc	s1,0x15
    80002ef4:	0a848493          	addi	s1,s1,168 # 80017f98 <bcache+0x18>
    b->next = bcache.head.next;
    80002ef8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002efa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002efc:	00005a17          	auipc	s4,0x5
    80002f00:	5fca0a13          	addi	s4,s4,1532 # 800084f8 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002f04:	2b893783          	ld	a5,696(s2)
    80002f08:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002f0a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f0e:	85d2                	mv	a1,s4
    80002f10:	01048513          	addi	a0,s1,16
    80002f14:	00001097          	auipc	ra,0x1
    80002f18:	4ac080e7          	jalr	1196(ra) # 800043c0 <initsleeplock>
    bcache.head.next->prev = b;
    80002f1c:	2b893783          	ld	a5,696(s2)
    80002f20:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f22:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f26:	45848493          	addi	s1,s1,1112
    80002f2a:	fd349de3          	bne	s1,s3,80002f04 <binit+0x54>
  }
}
    80002f2e:	70a2                	ld	ra,40(sp)
    80002f30:	7402                	ld	s0,32(sp)
    80002f32:	64e2                	ld	s1,24(sp)
    80002f34:	6942                	ld	s2,16(sp)
    80002f36:	69a2                	ld	s3,8(sp)
    80002f38:	6a02                	ld	s4,0(sp)
    80002f3a:	6145                	addi	sp,sp,48
    80002f3c:	8082                	ret

0000000080002f3e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f3e:	7179                	addi	sp,sp,-48
    80002f40:	f406                	sd	ra,40(sp)
    80002f42:	f022                	sd	s0,32(sp)
    80002f44:	ec26                	sd	s1,24(sp)
    80002f46:	e84a                	sd	s2,16(sp)
    80002f48:	e44e                	sd	s3,8(sp)
    80002f4a:	1800                	addi	s0,sp,48
    80002f4c:	892a                	mv	s2,a0
    80002f4e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002f50:	00015517          	auipc	a0,0x15
    80002f54:	03050513          	addi	a0,a0,48 # 80017f80 <bcache>
    80002f58:	ffffe097          	auipc	ra,0xffffe
    80002f5c:	d0a080e7          	jalr	-758(ra) # 80000c62 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002f60:	0001d497          	auipc	s1,0x1d
    80002f64:	2d84b483          	ld	s1,728(s1) # 80020238 <bcache+0x82b8>
    80002f68:	0001d797          	auipc	a5,0x1d
    80002f6c:	28078793          	addi	a5,a5,640 # 800201e8 <bcache+0x8268>
    80002f70:	02f48f63          	beq	s1,a5,80002fae <bread+0x70>
    80002f74:	873e                	mv	a4,a5
    80002f76:	a021                	j	80002f7e <bread+0x40>
    80002f78:	68a4                	ld	s1,80(s1)
    80002f7a:	02e48a63          	beq	s1,a4,80002fae <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002f7e:	449c                	lw	a5,8(s1)
    80002f80:	ff279ce3          	bne	a5,s2,80002f78 <bread+0x3a>
    80002f84:	44dc                	lw	a5,12(s1)
    80002f86:	ff3799e3          	bne	a5,s3,80002f78 <bread+0x3a>
      b->refcnt++;
    80002f8a:	40bc                	lw	a5,64(s1)
    80002f8c:	2785                	addiw	a5,a5,1
    80002f8e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f90:	00015517          	auipc	a0,0x15
    80002f94:	ff050513          	addi	a0,a0,-16 # 80017f80 <bcache>
    80002f98:	ffffe097          	auipc	ra,0xffffe
    80002f9c:	d7e080e7          	jalr	-642(ra) # 80000d16 <release>
      acquiresleep(&b->lock);
    80002fa0:	01048513          	addi	a0,s1,16
    80002fa4:	00001097          	auipc	ra,0x1
    80002fa8:	456080e7          	jalr	1110(ra) # 800043fa <acquiresleep>
      return b;
    80002fac:	a8b9                	j	8000300a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fae:	0001d497          	auipc	s1,0x1d
    80002fb2:	2824b483          	ld	s1,642(s1) # 80020230 <bcache+0x82b0>
    80002fb6:	0001d797          	auipc	a5,0x1d
    80002fba:	23278793          	addi	a5,a5,562 # 800201e8 <bcache+0x8268>
    80002fbe:	00f48863          	beq	s1,a5,80002fce <bread+0x90>
    80002fc2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002fc4:	40bc                	lw	a5,64(s1)
    80002fc6:	cf81                	beqz	a5,80002fde <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fc8:	64a4                	ld	s1,72(s1)
    80002fca:	fee49de3          	bne	s1,a4,80002fc4 <bread+0x86>
  panic("bget: no buffers");
    80002fce:	00005517          	auipc	a0,0x5
    80002fd2:	53250513          	addi	a0,a0,1330 # 80008500 <syscalls+0xd0>
    80002fd6:	ffffd097          	auipc	ra,0xffffd
    80002fda:	5fa080e7          	jalr	1530(ra) # 800005d0 <panic>
      b->dev = dev;
    80002fde:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002fe2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002fe6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002fea:	4785                	li	a5,1
    80002fec:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fee:	00015517          	auipc	a0,0x15
    80002ff2:	f9250513          	addi	a0,a0,-110 # 80017f80 <bcache>
    80002ff6:	ffffe097          	auipc	ra,0xffffe
    80002ffa:	d20080e7          	jalr	-736(ra) # 80000d16 <release>
      acquiresleep(&b->lock);
    80002ffe:	01048513          	addi	a0,s1,16
    80003002:	00001097          	auipc	ra,0x1
    80003006:	3f8080e7          	jalr	1016(ra) # 800043fa <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000300a:	409c                	lw	a5,0(s1)
    8000300c:	cb89                	beqz	a5,8000301e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000300e:	8526                	mv	a0,s1
    80003010:	70a2                	ld	ra,40(sp)
    80003012:	7402                	ld	s0,32(sp)
    80003014:	64e2                	ld	s1,24(sp)
    80003016:	6942                	ld	s2,16(sp)
    80003018:	69a2                	ld	s3,8(sp)
    8000301a:	6145                	addi	sp,sp,48
    8000301c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000301e:	4581                	li	a1,0
    80003020:	8526                	mv	a0,s1
    80003022:	00003097          	auipc	ra,0x3
    80003026:	f2a080e7          	jalr	-214(ra) # 80005f4c <virtio_disk_rw>
    b->valid = 1;
    8000302a:	4785                	li	a5,1
    8000302c:	c09c                	sw	a5,0(s1)
  return b;
    8000302e:	b7c5                	j	8000300e <bread+0xd0>

0000000080003030 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003030:	1101                	addi	sp,sp,-32
    80003032:	ec06                	sd	ra,24(sp)
    80003034:	e822                	sd	s0,16(sp)
    80003036:	e426                	sd	s1,8(sp)
    80003038:	1000                	addi	s0,sp,32
    8000303a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000303c:	0541                	addi	a0,a0,16
    8000303e:	00001097          	auipc	ra,0x1
    80003042:	456080e7          	jalr	1110(ra) # 80004494 <holdingsleep>
    80003046:	cd01                	beqz	a0,8000305e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003048:	4585                	li	a1,1
    8000304a:	8526                	mv	a0,s1
    8000304c:	00003097          	auipc	ra,0x3
    80003050:	f00080e7          	jalr	-256(ra) # 80005f4c <virtio_disk_rw>
}
    80003054:	60e2                	ld	ra,24(sp)
    80003056:	6442                	ld	s0,16(sp)
    80003058:	64a2                	ld	s1,8(sp)
    8000305a:	6105                	addi	sp,sp,32
    8000305c:	8082                	ret
    panic("bwrite");
    8000305e:	00005517          	auipc	a0,0x5
    80003062:	4ba50513          	addi	a0,a0,1210 # 80008518 <syscalls+0xe8>
    80003066:	ffffd097          	auipc	ra,0xffffd
    8000306a:	56a080e7          	jalr	1386(ra) # 800005d0 <panic>

000000008000306e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000306e:	1101                	addi	sp,sp,-32
    80003070:	ec06                	sd	ra,24(sp)
    80003072:	e822                	sd	s0,16(sp)
    80003074:	e426                	sd	s1,8(sp)
    80003076:	e04a                	sd	s2,0(sp)
    80003078:	1000                	addi	s0,sp,32
    8000307a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000307c:	01050913          	addi	s2,a0,16
    80003080:	854a                	mv	a0,s2
    80003082:	00001097          	auipc	ra,0x1
    80003086:	412080e7          	jalr	1042(ra) # 80004494 <holdingsleep>
    8000308a:	c92d                	beqz	a0,800030fc <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000308c:	854a                	mv	a0,s2
    8000308e:	00001097          	auipc	ra,0x1
    80003092:	3c2080e7          	jalr	962(ra) # 80004450 <releasesleep>

  acquire(&bcache.lock);
    80003096:	00015517          	auipc	a0,0x15
    8000309a:	eea50513          	addi	a0,a0,-278 # 80017f80 <bcache>
    8000309e:	ffffe097          	auipc	ra,0xffffe
    800030a2:	bc4080e7          	jalr	-1084(ra) # 80000c62 <acquire>
  b->refcnt--;
    800030a6:	40bc                	lw	a5,64(s1)
    800030a8:	37fd                	addiw	a5,a5,-1
    800030aa:	0007871b          	sext.w	a4,a5
    800030ae:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800030b0:	eb05                	bnez	a4,800030e0 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800030b2:	68bc                	ld	a5,80(s1)
    800030b4:	64b8                	ld	a4,72(s1)
    800030b6:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800030b8:	64bc                	ld	a5,72(s1)
    800030ba:	68b8                	ld	a4,80(s1)
    800030bc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800030be:	0001d797          	auipc	a5,0x1d
    800030c2:	ec278793          	addi	a5,a5,-318 # 8001ff80 <bcache+0x8000>
    800030c6:	2b87b703          	ld	a4,696(a5)
    800030ca:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800030cc:	0001d717          	auipc	a4,0x1d
    800030d0:	11c70713          	addi	a4,a4,284 # 800201e8 <bcache+0x8268>
    800030d4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800030d6:	2b87b703          	ld	a4,696(a5)
    800030da:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800030dc:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800030e0:	00015517          	auipc	a0,0x15
    800030e4:	ea050513          	addi	a0,a0,-352 # 80017f80 <bcache>
    800030e8:	ffffe097          	auipc	ra,0xffffe
    800030ec:	c2e080e7          	jalr	-978(ra) # 80000d16 <release>
}
    800030f0:	60e2                	ld	ra,24(sp)
    800030f2:	6442                	ld	s0,16(sp)
    800030f4:	64a2                	ld	s1,8(sp)
    800030f6:	6902                	ld	s2,0(sp)
    800030f8:	6105                	addi	sp,sp,32
    800030fa:	8082                	ret
    panic("brelse");
    800030fc:	00005517          	auipc	a0,0x5
    80003100:	42450513          	addi	a0,a0,1060 # 80008520 <syscalls+0xf0>
    80003104:	ffffd097          	auipc	ra,0xffffd
    80003108:	4cc080e7          	jalr	1228(ra) # 800005d0 <panic>

000000008000310c <bpin>:

void
bpin(struct buf *b) {
    8000310c:	1101                	addi	sp,sp,-32
    8000310e:	ec06                	sd	ra,24(sp)
    80003110:	e822                	sd	s0,16(sp)
    80003112:	e426                	sd	s1,8(sp)
    80003114:	1000                	addi	s0,sp,32
    80003116:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003118:	00015517          	auipc	a0,0x15
    8000311c:	e6850513          	addi	a0,a0,-408 # 80017f80 <bcache>
    80003120:	ffffe097          	auipc	ra,0xffffe
    80003124:	b42080e7          	jalr	-1214(ra) # 80000c62 <acquire>
  b->refcnt++;
    80003128:	40bc                	lw	a5,64(s1)
    8000312a:	2785                	addiw	a5,a5,1
    8000312c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000312e:	00015517          	auipc	a0,0x15
    80003132:	e5250513          	addi	a0,a0,-430 # 80017f80 <bcache>
    80003136:	ffffe097          	auipc	ra,0xffffe
    8000313a:	be0080e7          	jalr	-1056(ra) # 80000d16 <release>
}
    8000313e:	60e2                	ld	ra,24(sp)
    80003140:	6442                	ld	s0,16(sp)
    80003142:	64a2                	ld	s1,8(sp)
    80003144:	6105                	addi	sp,sp,32
    80003146:	8082                	ret

0000000080003148 <bunpin>:

void
bunpin(struct buf *b) {
    80003148:	1101                	addi	sp,sp,-32
    8000314a:	ec06                	sd	ra,24(sp)
    8000314c:	e822                	sd	s0,16(sp)
    8000314e:	e426                	sd	s1,8(sp)
    80003150:	1000                	addi	s0,sp,32
    80003152:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003154:	00015517          	auipc	a0,0x15
    80003158:	e2c50513          	addi	a0,a0,-468 # 80017f80 <bcache>
    8000315c:	ffffe097          	auipc	ra,0xffffe
    80003160:	b06080e7          	jalr	-1274(ra) # 80000c62 <acquire>
  b->refcnt--;
    80003164:	40bc                	lw	a5,64(s1)
    80003166:	37fd                	addiw	a5,a5,-1
    80003168:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000316a:	00015517          	auipc	a0,0x15
    8000316e:	e1650513          	addi	a0,a0,-490 # 80017f80 <bcache>
    80003172:	ffffe097          	auipc	ra,0xffffe
    80003176:	ba4080e7          	jalr	-1116(ra) # 80000d16 <release>
}
    8000317a:	60e2                	ld	ra,24(sp)
    8000317c:	6442                	ld	s0,16(sp)
    8000317e:	64a2                	ld	s1,8(sp)
    80003180:	6105                	addi	sp,sp,32
    80003182:	8082                	ret

0000000080003184 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003184:	1101                	addi	sp,sp,-32
    80003186:	ec06                	sd	ra,24(sp)
    80003188:	e822                	sd	s0,16(sp)
    8000318a:	e426                	sd	s1,8(sp)
    8000318c:	e04a                	sd	s2,0(sp)
    8000318e:	1000                	addi	s0,sp,32
    80003190:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003192:	00d5d59b          	srliw	a1,a1,0xd
    80003196:	0001d797          	auipc	a5,0x1d
    8000319a:	4c67a783          	lw	a5,1222(a5) # 8002065c <sb+0x1c>
    8000319e:	9dbd                	addw	a1,a1,a5
    800031a0:	00000097          	auipc	ra,0x0
    800031a4:	d9e080e7          	jalr	-610(ra) # 80002f3e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800031a8:	0074f713          	andi	a4,s1,7
    800031ac:	4785                	li	a5,1
    800031ae:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800031b2:	14ce                	slli	s1,s1,0x33
    800031b4:	90d9                	srli	s1,s1,0x36
    800031b6:	00950733          	add	a4,a0,s1
    800031ba:	05874703          	lbu	a4,88(a4)
    800031be:	00e7f6b3          	and	a3,a5,a4
    800031c2:	c69d                	beqz	a3,800031f0 <bfree+0x6c>
    800031c4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800031c6:	94aa                	add	s1,s1,a0
    800031c8:	fff7c793          	not	a5,a5
    800031cc:	8ff9                	and	a5,a5,a4
    800031ce:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800031d2:	00001097          	auipc	ra,0x1
    800031d6:	100080e7          	jalr	256(ra) # 800042d2 <log_write>
  brelse(bp);
    800031da:	854a                	mv	a0,s2
    800031dc:	00000097          	auipc	ra,0x0
    800031e0:	e92080e7          	jalr	-366(ra) # 8000306e <brelse>
}
    800031e4:	60e2                	ld	ra,24(sp)
    800031e6:	6442                	ld	s0,16(sp)
    800031e8:	64a2                	ld	s1,8(sp)
    800031ea:	6902                	ld	s2,0(sp)
    800031ec:	6105                	addi	sp,sp,32
    800031ee:	8082                	ret
    panic("freeing free block");
    800031f0:	00005517          	auipc	a0,0x5
    800031f4:	33850513          	addi	a0,a0,824 # 80008528 <syscalls+0xf8>
    800031f8:	ffffd097          	auipc	ra,0xffffd
    800031fc:	3d8080e7          	jalr	984(ra) # 800005d0 <panic>

0000000080003200 <balloc>:
{
    80003200:	711d                	addi	sp,sp,-96
    80003202:	ec86                	sd	ra,88(sp)
    80003204:	e8a2                	sd	s0,80(sp)
    80003206:	e4a6                	sd	s1,72(sp)
    80003208:	e0ca                	sd	s2,64(sp)
    8000320a:	fc4e                	sd	s3,56(sp)
    8000320c:	f852                	sd	s4,48(sp)
    8000320e:	f456                	sd	s5,40(sp)
    80003210:	f05a                	sd	s6,32(sp)
    80003212:	ec5e                	sd	s7,24(sp)
    80003214:	e862                	sd	s8,16(sp)
    80003216:	e466                	sd	s9,8(sp)
    80003218:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000321a:	0001d797          	auipc	a5,0x1d
    8000321e:	42a7a783          	lw	a5,1066(a5) # 80020644 <sb+0x4>
    80003222:	cbd1                	beqz	a5,800032b6 <balloc+0xb6>
    80003224:	8baa                	mv	s7,a0
    80003226:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003228:	0001db17          	auipc	s6,0x1d
    8000322c:	418b0b13          	addi	s6,s6,1048 # 80020640 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003230:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003232:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003234:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003236:	6c89                	lui	s9,0x2
    80003238:	a831                	j	80003254 <balloc+0x54>
    brelse(bp);
    8000323a:	854a                	mv	a0,s2
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	e32080e7          	jalr	-462(ra) # 8000306e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003244:	015c87bb          	addw	a5,s9,s5
    80003248:	00078a9b          	sext.w	s5,a5
    8000324c:	004b2703          	lw	a4,4(s6)
    80003250:	06eaf363          	bgeu	s5,a4,800032b6 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003254:	41fad79b          	sraiw	a5,s5,0x1f
    80003258:	0137d79b          	srliw	a5,a5,0x13
    8000325c:	015787bb          	addw	a5,a5,s5
    80003260:	40d7d79b          	sraiw	a5,a5,0xd
    80003264:	01cb2583          	lw	a1,28(s6)
    80003268:	9dbd                	addw	a1,a1,a5
    8000326a:	855e                	mv	a0,s7
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	cd2080e7          	jalr	-814(ra) # 80002f3e <bread>
    80003274:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003276:	004b2503          	lw	a0,4(s6)
    8000327a:	000a849b          	sext.w	s1,s5
    8000327e:	8662                	mv	a2,s8
    80003280:	faa4fde3          	bgeu	s1,a0,8000323a <balloc+0x3a>
      m = 1 << (bi % 8);
    80003284:	41f6579b          	sraiw	a5,a2,0x1f
    80003288:	01d7d69b          	srliw	a3,a5,0x1d
    8000328c:	00c6873b          	addw	a4,a3,a2
    80003290:	00777793          	andi	a5,a4,7
    80003294:	9f95                	subw	a5,a5,a3
    80003296:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000329a:	4037571b          	sraiw	a4,a4,0x3
    8000329e:	00e906b3          	add	a3,s2,a4
    800032a2:	0586c683          	lbu	a3,88(a3)
    800032a6:	00d7f5b3          	and	a1,a5,a3
    800032aa:	cd91                	beqz	a1,800032c6 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032ac:	2605                	addiw	a2,a2,1
    800032ae:	2485                	addiw	s1,s1,1
    800032b0:	fd4618e3          	bne	a2,s4,80003280 <balloc+0x80>
    800032b4:	b759                	j	8000323a <balloc+0x3a>
  panic("balloc: out of blocks");
    800032b6:	00005517          	auipc	a0,0x5
    800032ba:	28a50513          	addi	a0,a0,650 # 80008540 <syscalls+0x110>
    800032be:	ffffd097          	auipc	ra,0xffffd
    800032c2:	312080e7          	jalr	786(ra) # 800005d0 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800032c6:	974a                	add	a4,a4,s2
    800032c8:	8fd5                	or	a5,a5,a3
    800032ca:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800032ce:	854a                	mv	a0,s2
    800032d0:	00001097          	auipc	ra,0x1
    800032d4:	002080e7          	jalr	2(ra) # 800042d2 <log_write>
        brelse(bp);
    800032d8:	854a                	mv	a0,s2
    800032da:	00000097          	auipc	ra,0x0
    800032de:	d94080e7          	jalr	-620(ra) # 8000306e <brelse>
  bp = bread(dev, bno);
    800032e2:	85a6                	mv	a1,s1
    800032e4:	855e                	mv	a0,s7
    800032e6:	00000097          	auipc	ra,0x0
    800032ea:	c58080e7          	jalr	-936(ra) # 80002f3e <bread>
    800032ee:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800032f0:	40000613          	li	a2,1024
    800032f4:	4581                	li	a1,0
    800032f6:	05850513          	addi	a0,a0,88
    800032fa:	ffffe097          	auipc	ra,0xffffe
    800032fe:	a64080e7          	jalr	-1436(ra) # 80000d5e <memset>
  log_write(bp);
    80003302:	854a                	mv	a0,s2
    80003304:	00001097          	auipc	ra,0x1
    80003308:	fce080e7          	jalr	-50(ra) # 800042d2 <log_write>
  brelse(bp);
    8000330c:	854a                	mv	a0,s2
    8000330e:	00000097          	auipc	ra,0x0
    80003312:	d60080e7          	jalr	-672(ra) # 8000306e <brelse>
}
    80003316:	8526                	mv	a0,s1
    80003318:	60e6                	ld	ra,88(sp)
    8000331a:	6446                	ld	s0,80(sp)
    8000331c:	64a6                	ld	s1,72(sp)
    8000331e:	6906                	ld	s2,64(sp)
    80003320:	79e2                	ld	s3,56(sp)
    80003322:	7a42                	ld	s4,48(sp)
    80003324:	7aa2                	ld	s5,40(sp)
    80003326:	7b02                	ld	s6,32(sp)
    80003328:	6be2                	ld	s7,24(sp)
    8000332a:	6c42                	ld	s8,16(sp)
    8000332c:	6ca2                	ld	s9,8(sp)
    8000332e:	6125                	addi	sp,sp,96
    80003330:	8082                	ret

0000000080003332 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003332:	7179                	addi	sp,sp,-48
    80003334:	f406                	sd	ra,40(sp)
    80003336:	f022                	sd	s0,32(sp)
    80003338:	ec26                	sd	s1,24(sp)
    8000333a:	e84a                	sd	s2,16(sp)
    8000333c:	e44e                	sd	s3,8(sp)
    8000333e:	e052                	sd	s4,0(sp)
    80003340:	1800                	addi	s0,sp,48
    80003342:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003344:	47ad                	li	a5,11
    80003346:	04b7fe63          	bgeu	a5,a1,800033a2 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000334a:	ff45849b          	addiw	s1,a1,-12
    8000334e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003352:	0ff00793          	li	a5,255
    80003356:	0ae7e363          	bltu	a5,a4,800033fc <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000335a:	08052583          	lw	a1,128(a0)
    8000335e:	c5ad                	beqz	a1,800033c8 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003360:	00092503          	lw	a0,0(s2)
    80003364:	00000097          	auipc	ra,0x0
    80003368:	bda080e7          	jalr	-1062(ra) # 80002f3e <bread>
    8000336c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000336e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003372:	02049593          	slli	a1,s1,0x20
    80003376:	9181                	srli	a1,a1,0x20
    80003378:	058a                	slli	a1,a1,0x2
    8000337a:	00b784b3          	add	s1,a5,a1
    8000337e:	0004a983          	lw	s3,0(s1)
    80003382:	04098d63          	beqz	s3,800033dc <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003386:	8552                	mv	a0,s4
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	ce6080e7          	jalr	-794(ra) # 8000306e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003390:	854e                	mv	a0,s3
    80003392:	70a2                	ld	ra,40(sp)
    80003394:	7402                	ld	s0,32(sp)
    80003396:	64e2                	ld	s1,24(sp)
    80003398:	6942                	ld	s2,16(sp)
    8000339a:	69a2                	ld	s3,8(sp)
    8000339c:	6a02                	ld	s4,0(sp)
    8000339e:	6145                	addi	sp,sp,48
    800033a0:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800033a2:	02059493          	slli	s1,a1,0x20
    800033a6:	9081                	srli	s1,s1,0x20
    800033a8:	048a                	slli	s1,s1,0x2
    800033aa:	94aa                	add	s1,s1,a0
    800033ac:	0504a983          	lw	s3,80(s1)
    800033b0:	fe0990e3          	bnez	s3,80003390 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800033b4:	4108                	lw	a0,0(a0)
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	e4a080e7          	jalr	-438(ra) # 80003200 <balloc>
    800033be:	0005099b          	sext.w	s3,a0
    800033c2:	0534a823          	sw	s3,80(s1)
    800033c6:	b7e9                	j	80003390 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800033c8:	4108                	lw	a0,0(a0)
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	e36080e7          	jalr	-458(ra) # 80003200 <balloc>
    800033d2:	0005059b          	sext.w	a1,a0
    800033d6:	08b92023          	sw	a1,128(s2)
    800033da:	b759                	j	80003360 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800033dc:	00092503          	lw	a0,0(s2)
    800033e0:	00000097          	auipc	ra,0x0
    800033e4:	e20080e7          	jalr	-480(ra) # 80003200 <balloc>
    800033e8:	0005099b          	sext.w	s3,a0
    800033ec:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800033f0:	8552                	mv	a0,s4
    800033f2:	00001097          	auipc	ra,0x1
    800033f6:	ee0080e7          	jalr	-288(ra) # 800042d2 <log_write>
    800033fa:	b771                	j	80003386 <bmap+0x54>
  panic("bmap: out of range");
    800033fc:	00005517          	auipc	a0,0x5
    80003400:	15c50513          	addi	a0,a0,348 # 80008558 <syscalls+0x128>
    80003404:	ffffd097          	auipc	ra,0xffffd
    80003408:	1cc080e7          	jalr	460(ra) # 800005d0 <panic>

000000008000340c <iget>:
{
    8000340c:	7179                	addi	sp,sp,-48
    8000340e:	f406                	sd	ra,40(sp)
    80003410:	f022                	sd	s0,32(sp)
    80003412:	ec26                	sd	s1,24(sp)
    80003414:	e84a                	sd	s2,16(sp)
    80003416:	e44e                	sd	s3,8(sp)
    80003418:	e052                	sd	s4,0(sp)
    8000341a:	1800                	addi	s0,sp,48
    8000341c:	89aa                	mv	s3,a0
    8000341e:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    80003420:	0001d517          	auipc	a0,0x1d
    80003424:	24050513          	addi	a0,a0,576 # 80020660 <icache>
    80003428:	ffffe097          	auipc	ra,0xffffe
    8000342c:	83a080e7          	jalr	-1990(ra) # 80000c62 <acquire>
  empty = 0;
    80003430:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003432:	0001d497          	auipc	s1,0x1d
    80003436:	24648493          	addi	s1,s1,582 # 80020678 <icache+0x18>
    8000343a:	0001f697          	auipc	a3,0x1f
    8000343e:	cce68693          	addi	a3,a3,-818 # 80022108 <log>
    80003442:	a039                	j	80003450 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003444:	02090b63          	beqz	s2,8000347a <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003448:	08848493          	addi	s1,s1,136
    8000344c:	02d48a63          	beq	s1,a3,80003480 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003450:	449c                	lw	a5,8(s1)
    80003452:	fef059e3          	blez	a5,80003444 <iget+0x38>
    80003456:	4098                	lw	a4,0(s1)
    80003458:	ff3716e3          	bne	a4,s3,80003444 <iget+0x38>
    8000345c:	40d8                	lw	a4,4(s1)
    8000345e:	ff4713e3          	bne	a4,s4,80003444 <iget+0x38>
      ip->ref++;
    80003462:	2785                	addiw	a5,a5,1
    80003464:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003466:	0001d517          	auipc	a0,0x1d
    8000346a:	1fa50513          	addi	a0,a0,506 # 80020660 <icache>
    8000346e:	ffffe097          	auipc	ra,0xffffe
    80003472:	8a8080e7          	jalr	-1880(ra) # 80000d16 <release>
      return ip;
    80003476:	8926                	mv	s2,s1
    80003478:	a03d                	j	800034a6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000347a:	f7f9                	bnez	a5,80003448 <iget+0x3c>
    8000347c:	8926                	mv	s2,s1
    8000347e:	b7e9                	j	80003448 <iget+0x3c>
  if(empty == 0)
    80003480:	02090c63          	beqz	s2,800034b8 <iget+0xac>
  ip->dev = dev;
    80003484:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003488:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000348c:	4785                	li	a5,1
    8000348e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003492:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003496:	0001d517          	auipc	a0,0x1d
    8000349a:	1ca50513          	addi	a0,a0,458 # 80020660 <icache>
    8000349e:	ffffe097          	auipc	ra,0xffffe
    800034a2:	878080e7          	jalr	-1928(ra) # 80000d16 <release>
}
    800034a6:	854a                	mv	a0,s2
    800034a8:	70a2                	ld	ra,40(sp)
    800034aa:	7402                	ld	s0,32(sp)
    800034ac:	64e2                	ld	s1,24(sp)
    800034ae:	6942                	ld	s2,16(sp)
    800034b0:	69a2                	ld	s3,8(sp)
    800034b2:	6a02                	ld	s4,0(sp)
    800034b4:	6145                	addi	sp,sp,48
    800034b6:	8082                	ret
    panic("iget: no inodes");
    800034b8:	00005517          	auipc	a0,0x5
    800034bc:	0b850513          	addi	a0,a0,184 # 80008570 <syscalls+0x140>
    800034c0:	ffffd097          	auipc	ra,0xffffd
    800034c4:	110080e7          	jalr	272(ra) # 800005d0 <panic>

00000000800034c8 <fsinit>:
fsinit(int dev) {
    800034c8:	7179                	addi	sp,sp,-48
    800034ca:	f406                	sd	ra,40(sp)
    800034cc:	f022                	sd	s0,32(sp)
    800034ce:	ec26                	sd	s1,24(sp)
    800034d0:	e84a                	sd	s2,16(sp)
    800034d2:	e44e                	sd	s3,8(sp)
    800034d4:	1800                	addi	s0,sp,48
    800034d6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800034d8:	4585                	li	a1,1
    800034da:	00000097          	auipc	ra,0x0
    800034de:	a64080e7          	jalr	-1436(ra) # 80002f3e <bread>
    800034e2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800034e4:	0001d997          	auipc	s3,0x1d
    800034e8:	15c98993          	addi	s3,s3,348 # 80020640 <sb>
    800034ec:	02000613          	li	a2,32
    800034f0:	05850593          	addi	a1,a0,88
    800034f4:	854e                	mv	a0,s3
    800034f6:	ffffe097          	auipc	ra,0xffffe
    800034fa:	8c4080e7          	jalr	-1852(ra) # 80000dba <memmove>
  brelse(bp);
    800034fe:	8526                	mv	a0,s1
    80003500:	00000097          	auipc	ra,0x0
    80003504:	b6e080e7          	jalr	-1170(ra) # 8000306e <brelse>
  if(sb.magic != FSMAGIC)
    80003508:	0009a703          	lw	a4,0(s3)
    8000350c:	102037b7          	lui	a5,0x10203
    80003510:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003514:	02f71263          	bne	a4,a5,80003538 <fsinit+0x70>
  initlog(dev, &sb);
    80003518:	0001d597          	auipc	a1,0x1d
    8000351c:	12858593          	addi	a1,a1,296 # 80020640 <sb>
    80003520:	854a                	mv	a0,s2
    80003522:	00001097          	auipc	ra,0x1
    80003526:	b38080e7          	jalr	-1224(ra) # 8000405a <initlog>
}
    8000352a:	70a2                	ld	ra,40(sp)
    8000352c:	7402                	ld	s0,32(sp)
    8000352e:	64e2                	ld	s1,24(sp)
    80003530:	6942                	ld	s2,16(sp)
    80003532:	69a2                	ld	s3,8(sp)
    80003534:	6145                	addi	sp,sp,48
    80003536:	8082                	ret
    panic("invalid file system");
    80003538:	00005517          	auipc	a0,0x5
    8000353c:	04850513          	addi	a0,a0,72 # 80008580 <syscalls+0x150>
    80003540:	ffffd097          	auipc	ra,0xffffd
    80003544:	090080e7          	jalr	144(ra) # 800005d0 <panic>

0000000080003548 <iinit>:
{
    80003548:	7179                	addi	sp,sp,-48
    8000354a:	f406                	sd	ra,40(sp)
    8000354c:	f022                	sd	s0,32(sp)
    8000354e:	ec26                	sd	s1,24(sp)
    80003550:	e84a                	sd	s2,16(sp)
    80003552:	e44e                	sd	s3,8(sp)
    80003554:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003556:	00005597          	auipc	a1,0x5
    8000355a:	04258593          	addi	a1,a1,66 # 80008598 <syscalls+0x168>
    8000355e:	0001d517          	auipc	a0,0x1d
    80003562:	10250513          	addi	a0,a0,258 # 80020660 <icache>
    80003566:	ffffd097          	auipc	ra,0xffffd
    8000356a:	66c080e7          	jalr	1644(ra) # 80000bd2 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000356e:	0001d497          	auipc	s1,0x1d
    80003572:	11a48493          	addi	s1,s1,282 # 80020688 <icache+0x28>
    80003576:	0001f997          	auipc	s3,0x1f
    8000357a:	ba298993          	addi	s3,s3,-1118 # 80022118 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    8000357e:	00005917          	auipc	s2,0x5
    80003582:	02290913          	addi	s2,s2,34 # 800085a0 <syscalls+0x170>
    80003586:	85ca                	mv	a1,s2
    80003588:	8526                	mv	a0,s1
    8000358a:	00001097          	auipc	ra,0x1
    8000358e:	e36080e7          	jalr	-458(ra) # 800043c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003592:	08848493          	addi	s1,s1,136
    80003596:	ff3498e3          	bne	s1,s3,80003586 <iinit+0x3e>
}
    8000359a:	70a2                	ld	ra,40(sp)
    8000359c:	7402                	ld	s0,32(sp)
    8000359e:	64e2                	ld	s1,24(sp)
    800035a0:	6942                	ld	s2,16(sp)
    800035a2:	69a2                	ld	s3,8(sp)
    800035a4:	6145                	addi	sp,sp,48
    800035a6:	8082                	ret

00000000800035a8 <ialloc>:
{
    800035a8:	715d                	addi	sp,sp,-80
    800035aa:	e486                	sd	ra,72(sp)
    800035ac:	e0a2                	sd	s0,64(sp)
    800035ae:	fc26                	sd	s1,56(sp)
    800035b0:	f84a                	sd	s2,48(sp)
    800035b2:	f44e                	sd	s3,40(sp)
    800035b4:	f052                	sd	s4,32(sp)
    800035b6:	ec56                	sd	s5,24(sp)
    800035b8:	e85a                	sd	s6,16(sp)
    800035ba:	e45e                	sd	s7,8(sp)
    800035bc:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800035be:	0001d717          	auipc	a4,0x1d
    800035c2:	08e72703          	lw	a4,142(a4) # 8002064c <sb+0xc>
    800035c6:	4785                	li	a5,1
    800035c8:	04e7fa63          	bgeu	a5,a4,8000361c <ialloc+0x74>
    800035cc:	8aaa                	mv	s5,a0
    800035ce:	8bae                	mv	s7,a1
    800035d0:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800035d2:	0001da17          	auipc	s4,0x1d
    800035d6:	06ea0a13          	addi	s4,s4,110 # 80020640 <sb>
    800035da:	00048b1b          	sext.w	s6,s1
    800035de:	0044d793          	srli	a5,s1,0x4
    800035e2:	018a2583          	lw	a1,24(s4)
    800035e6:	9dbd                	addw	a1,a1,a5
    800035e8:	8556                	mv	a0,s5
    800035ea:	00000097          	auipc	ra,0x0
    800035ee:	954080e7          	jalr	-1708(ra) # 80002f3e <bread>
    800035f2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800035f4:	05850993          	addi	s3,a0,88
    800035f8:	00f4f793          	andi	a5,s1,15
    800035fc:	079a                	slli	a5,a5,0x6
    800035fe:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003600:	00099783          	lh	a5,0(s3)
    80003604:	c785                	beqz	a5,8000362c <ialloc+0x84>
    brelse(bp);
    80003606:	00000097          	auipc	ra,0x0
    8000360a:	a68080e7          	jalr	-1432(ra) # 8000306e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000360e:	0485                	addi	s1,s1,1
    80003610:	00ca2703          	lw	a4,12(s4)
    80003614:	0004879b          	sext.w	a5,s1
    80003618:	fce7e1e3          	bltu	a5,a4,800035da <ialloc+0x32>
  panic("ialloc: no inodes");
    8000361c:	00005517          	auipc	a0,0x5
    80003620:	f8c50513          	addi	a0,a0,-116 # 800085a8 <syscalls+0x178>
    80003624:	ffffd097          	auipc	ra,0xffffd
    80003628:	fac080e7          	jalr	-84(ra) # 800005d0 <panic>
      memset(dip, 0, sizeof(*dip));
    8000362c:	04000613          	li	a2,64
    80003630:	4581                	li	a1,0
    80003632:	854e                	mv	a0,s3
    80003634:	ffffd097          	auipc	ra,0xffffd
    80003638:	72a080e7          	jalr	1834(ra) # 80000d5e <memset>
      dip->type = type;
    8000363c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003640:	854a                	mv	a0,s2
    80003642:	00001097          	auipc	ra,0x1
    80003646:	c90080e7          	jalr	-880(ra) # 800042d2 <log_write>
      brelse(bp);
    8000364a:	854a                	mv	a0,s2
    8000364c:	00000097          	auipc	ra,0x0
    80003650:	a22080e7          	jalr	-1502(ra) # 8000306e <brelse>
      return iget(dev, inum);
    80003654:	85da                	mv	a1,s6
    80003656:	8556                	mv	a0,s5
    80003658:	00000097          	auipc	ra,0x0
    8000365c:	db4080e7          	jalr	-588(ra) # 8000340c <iget>
}
    80003660:	60a6                	ld	ra,72(sp)
    80003662:	6406                	ld	s0,64(sp)
    80003664:	74e2                	ld	s1,56(sp)
    80003666:	7942                	ld	s2,48(sp)
    80003668:	79a2                	ld	s3,40(sp)
    8000366a:	7a02                	ld	s4,32(sp)
    8000366c:	6ae2                	ld	s5,24(sp)
    8000366e:	6b42                	ld	s6,16(sp)
    80003670:	6ba2                	ld	s7,8(sp)
    80003672:	6161                	addi	sp,sp,80
    80003674:	8082                	ret

0000000080003676 <iupdate>:
{
    80003676:	1101                	addi	sp,sp,-32
    80003678:	ec06                	sd	ra,24(sp)
    8000367a:	e822                	sd	s0,16(sp)
    8000367c:	e426                	sd	s1,8(sp)
    8000367e:	e04a                	sd	s2,0(sp)
    80003680:	1000                	addi	s0,sp,32
    80003682:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003684:	415c                	lw	a5,4(a0)
    80003686:	0047d79b          	srliw	a5,a5,0x4
    8000368a:	0001d597          	auipc	a1,0x1d
    8000368e:	fce5a583          	lw	a1,-50(a1) # 80020658 <sb+0x18>
    80003692:	9dbd                	addw	a1,a1,a5
    80003694:	4108                	lw	a0,0(a0)
    80003696:	00000097          	auipc	ra,0x0
    8000369a:	8a8080e7          	jalr	-1880(ra) # 80002f3e <bread>
    8000369e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800036a0:	05850793          	addi	a5,a0,88
    800036a4:	40c8                	lw	a0,4(s1)
    800036a6:	893d                	andi	a0,a0,15
    800036a8:	051a                	slli	a0,a0,0x6
    800036aa:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800036ac:	04449703          	lh	a4,68(s1)
    800036b0:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800036b4:	04649703          	lh	a4,70(s1)
    800036b8:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800036bc:	04849703          	lh	a4,72(s1)
    800036c0:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800036c4:	04a49703          	lh	a4,74(s1)
    800036c8:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800036cc:	44f8                	lw	a4,76(s1)
    800036ce:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800036d0:	03400613          	li	a2,52
    800036d4:	05048593          	addi	a1,s1,80
    800036d8:	0531                	addi	a0,a0,12
    800036da:	ffffd097          	auipc	ra,0xffffd
    800036de:	6e0080e7          	jalr	1760(ra) # 80000dba <memmove>
  log_write(bp);
    800036e2:	854a                	mv	a0,s2
    800036e4:	00001097          	auipc	ra,0x1
    800036e8:	bee080e7          	jalr	-1042(ra) # 800042d2 <log_write>
  brelse(bp);
    800036ec:	854a                	mv	a0,s2
    800036ee:	00000097          	auipc	ra,0x0
    800036f2:	980080e7          	jalr	-1664(ra) # 8000306e <brelse>
}
    800036f6:	60e2                	ld	ra,24(sp)
    800036f8:	6442                	ld	s0,16(sp)
    800036fa:	64a2                	ld	s1,8(sp)
    800036fc:	6902                	ld	s2,0(sp)
    800036fe:	6105                	addi	sp,sp,32
    80003700:	8082                	ret

0000000080003702 <idup>:
{
    80003702:	1101                	addi	sp,sp,-32
    80003704:	ec06                	sd	ra,24(sp)
    80003706:	e822                	sd	s0,16(sp)
    80003708:	e426                	sd	s1,8(sp)
    8000370a:	1000                	addi	s0,sp,32
    8000370c:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000370e:	0001d517          	auipc	a0,0x1d
    80003712:	f5250513          	addi	a0,a0,-174 # 80020660 <icache>
    80003716:	ffffd097          	auipc	ra,0xffffd
    8000371a:	54c080e7          	jalr	1356(ra) # 80000c62 <acquire>
  ip->ref++;
    8000371e:	449c                	lw	a5,8(s1)
    80003720:	2785                	addiw	a5,a5,1
    80003722:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003724:	0001d517          	auipc	a0,0x1d
    80003728:	f3c50513          	addi	a0,a0,-196 # 80020660 <icache>
    8000372c:	ffffd097          	auipc	ra,0xffffd
    80003730:	5ea080e7          	jalr	1514(ra) # 80000d16 <release>
}
    80003734:	8526                	mv	a0,s1
    80003736:	60e2                	ld	ra,24(sp)
    80003738:	6442                	ld	s0,16(sp)
    8000373a:	64a2                	ld	s1,8(sp)
    8000373c:	6105                	addi	sp,sp,32
    8000373e:	8082                	ret

0000000080003740 <ilock>:
{
    80003740:	1101                	addi	sp,sp,-32
    80003742:	ec06                	sd	ra,24(sp)
    80003744:	e822                	sd	s0,16(sp)
    80003746:	e426                	sd	s1,8(sp)
    80003748:	e04a                	sd	s2,0(sp)
    8000374a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000374c:	c115                	beqz	a0,80003770 <ilock+0x30>
    8000374e:	84aa                	mv	s1,a0
    80003750:	451c                	lw	a5,8(a0)
    80003752:	00f05f63          	blez	a5,80003770 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003756:	0541                	addi	a0,a0,16
    80003758:	00001097          	auipc	ra,0x1
    8000375c:	ca2080e7          	jalr	-862(ra) # 800043fa <acquiresleep>
  if(ip->valid == 0){
    80003760:	40bc                	lw	a5,64(s1)
    80003762:	cf99                	beqz	a5,80003780 <ilock+0x40>
}
    80003764:	60e2                	ld	ra,24(sp)
    80003766:	6442                	ld	s0,16(sp)
    80003768:	64a2                	ld	s1,8(sp)
    8000376a:	6902                	ld	s2,0(sp)
    8000376c:	6105                	addi	sp,sp,32
    8000376e:	8082                	ret
    panic("ilock");
    80003770:	00005517          	auipc	a0,0x5
    80003774:	e5050513          	addi	a0,a0,-432 # 800085c0 <syscalls+0x190>
    80003778:	ffffd097          	auipc	ra,0xffffd
    8000377c:	e58080e7          	jalr	-424(ra) # 800005d0 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003780:	40dc                	lw	a5,4(s1)
    80003782:	0047d79b          	srliw	a5,a5,0x4
    80003786:	0001d597          	auipc	a1,0x1d
    8000378a:	ed25a583          	lw	a1,-302(a1) # 80020658 <sb+0x18>
    8000378e:	9dbd                	addw	a1,a1,a5
    80003790:	4088                	lw	a0,0(s1)
    80003792:	fffff097          	auipc	ra,0xfffff
    80003796:	7ac080e7          	jalr	1964(ra) # 80002f3e <bread>
    8000379a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000379c:	05850593          	addi	a1,a0,88
    800037a0:	40dc                	lw	a5,4(s1)
    800037a2:	8bbd                	andi	a5,a5,15
    800037a4:	079a                	slli	a5,a5,0x6
    800037a6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800037a8:	00059783          	lh	a5,0(a1)
    800037ac:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800037b0:	00259783          	lh	a5,2(a1)
    800037b4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800037b8:	00459783          	lh	a5,4(a1)
    800037bc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800037c0:	00659783          	lh	a5,6(a1)
    800037c4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800037c8:	459c                	lw	a5,8(a1)
    800037ca:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800037cc:	03400613          	li	a2,52
    800037d0:	05b1                	addi	a1,a1,12
    800037d2:	05048513          	addi	a0,s1,80
    800037d6:	ffffd097          	auipc	ra,0xffffd
    800037da:	5e4080e7          	jalr	1508(ra) # 80000dba <memmove>
    brelse(bp);
    800037de:	854a                	mv	a0,s2
    800037e0:	00000097          	auipc	ra,0x0
    800037e4:	88e080e7          	jalr	-1906(ra) # 8000306e <brelse>
    ip->valid = 1;
    800037e8:	4785                	li	a5,1
    800037ea:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800037ec:	04449783          	lh	a5,68(s1)
    800037f0:	fbb5                	bnez	a5,80003764 <ilock+0x24>
      panic("ilock: no type");
    800037f2:	00005517          	auipc	a0,0x5
    800037f6:	dd650513          	addi	a0,a0,-554 # 800085c8 <syscalls+0x198>
    800037fa:	ffffd097          	auipc	ra,0xffffd
    800037fe:	dd6080e7          	jalr	-554(ra) # 800005d0 <panic>

0000000080003802 <iunlock>:
{
    80003802:	1101                	addi	sp,sp,-32
    80003804:	ec06                	sd	ra,24(sp)
    80003806:	e822                	sd	s0,16(sp)
    80003808:	e426                	sd	s1,8(sp)
    8000380a:	e04a                	sd	s2,0(sp)
    8000380c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000380e:	c905                	beqz	a0,8000383e <iunlock+0x3c>
    80003810:	84aa                	mv	s1,a0
    80003812:	01050913          	addi	s2,a0,16
    80003816:	854a                	mv	a0,s2
    80003818:	00001097          	auipc	ra,0x1
    8000381c:	c7c080e7          	jalr	-900(ra) # 80004494 <holdingsleep>
    80003820:	cd19                	beqz	a0,8000383e <iunlock+0x3c>
    80003822:	449c                	lw	a5,8(s1)
    80003824:	00f05d63          	blez	a5,8000383e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003828:	854a                	mv	a0,s2
    8000382a:	00001097          	auipc	ra,0x1
    8000382e:	c26080e7          	jalr	-986(ra) # 80004450 <releasesleep>
}
    80003832:	60e2                	ld	ra,24(sp)
    80003834:	6442                	ld	s0,16(sp)
    80003836:	64a2                	ld	s1,8(sp)
    80003838:	6902                	ld	s2,0(sp)
    8000383a:	6105                	addi	sp,sp,32
    8000383c:	8082                	ret
    panic("iunlock");
    8000383e:	00005517          	auipc	a0,0x5
    80003842:	d9a50513          	addi	a0,a0,-614 # 800085d8 <syscalls+0x1a8>
    80003846:	ffffd097          	auipc	ra,0xffffd
    8000384a:	d8a080e7          	jalr	-630(ra) # 800005d0 <panic>

000000008000384e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000384e:	7179                	addi	sp,sp,-48
    80003850:	f406                	sd	ra,40(sp)
    80003852:	f022                	sd	s0,32(sp)
    80003854:	ec26                	sd	s1,24(sp)
    80003856:	e84a                	sd	s2,16(sp)
    80003858:	e44e                	sd	s3,8(sp)
    8000385a:	e052                	sd	s4,0(sp)
    8000385c:	1800                	addi	s0,sp,48
    8000385e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003860:	05050493          	addi	s1,a0,80
    80003864:	08050913          	addi	s2,a0,128
    80003868:	a021                	j	80003870 <itrunc+0x22>
    8000386a:	0491                	addi	s1,s1,4
    8000386c:	01248d63          	beq	s1,s2,80003886 <itrunc+0x38>
    if(ip->addrs[i]){
    80003870:	408c                	lw	a1,0(s1)
    80003872:	dde5                	beqz	a1,8000386a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003874:	0009a503          	lw	a0,0(s3)
    80003878:	00000097          	auipc	ra,0x0
    8000387c:	90c080e7          	jalr	-1780(ra) # 80003184 <bfree>
      ip->addrs[i] = 0;
    80003880:	0004a023          	sw	zero,0(s1)
    80003884:	b7dd                	j	8000386a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003886:	0809a583          	lw	a1,128(s3)
    8000388a:	e185                	bnez	a1,800038aa <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000388c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003890:	854e                	mv	a0,s3
    80003892:	00000097          	auipc	ra,0x0
    80003896:	de4080e7          	jalr	-540(ra) # 80003676 <iupdate>
}
    8000389a:	70a2                	ld	ra,40(sp)
    8000389c:	7402                	ld	s0,32(sp)
    8000389e:	64e2                	ld	s1,24(sp)
    800038a0:	6942                	ld	s2,16(sp)
    800038a2:	69a2                	ld	s3,8(sp)
    800038a4:	6a02                	ld	s4,0(sp)
    800038a6:	6145                	addi	sp,sp,48
    800038a8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800038aa:	0009a503          	lw	a0,0(s3)
    800038ae:	fffff097          	auipc	ra,0xfffff
    800038b2:	690080e7          	jalr	1680(ra) # 80002f3e <bread>
    800038b6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800038b8:	05850493          	addi	s1,a0,88
    800038bc:	45850913          	addi	s2,a0,1112
    800038c0:	a021                	j	800038c8 <itrunc+0x7a>
    800038c2:	0491                	addi	s1,s1,4
    800038c4:	01248b63          	beq	s1,s2,800038da <itrunc+0x8c>
      if(a[j])
    800038c8:	408c                	lw	a1,0(s1)
    800038ca:	dde5                	beqz	a1,800038c2 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    800038cc:	0009a503          	lw	a0,0(s3)
    800038d0:	00000097          	auipc	ra,0x0
    800038d4:	8b4080e7          	jalr	-1868(ra) # 80003184 <bfree>
    800038d8:	b7ed                	j	800038c2 <itrunc+0x74>
    brelse(bp);
    800038da:	8552                	mv	a0,s4
    800038dc:	fffff097          	auipc	ra,0xfffff
    800038e0:	792080e7          	jalr	1938(ra) # 8000306e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800038e4:	0809a583          	lw	a1,128(s3)
    800038e8:	0009a503          	lw	a0,0(s3)
    800038ec:	00000097          	auipc	ra,0x0
    800038f0:	898080e7          	jalr	-1896(ra) # 80003184 <bfree>
    ip->addrs[NDIRECT] = 0;
    800038f4:	0809a023          	sw	zero,128(s3)
    800038f8:	bf51                	j	8000388c <itrunc+0x3e>

00000000800038fa <iput>:
{
    800038fa:	1101                	addi	sp,sp,-32
    800038fc:	ec06                	sd	ra,24(sp)
    800038fe:	e822                	sd	s0,16(sp)
    80003900:	e426                	sd	s1,8(sp)
    80003902:	e04a                	sd	s2,0(sp)
    80003904:	1000                	addi	s0,sp,32
    80003906:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003908:	0001d517          	auipc	a0,0x1d
    8000390c:	d5850513          	addi	a0,a0,-680 # 80020660 <icache>
    80003910:	ffffd097          	auipc	ra,0xffffd
    80003914:	352080e7          	jalr	850(ra) # 80000c62 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003918:	4498                	lw	a4,8(s1)
    8000391a:	4785                	li	a5,1
    8000391c:	02f70363          	beq	a4,a5,80003942 <iput+0x48>
  ip->ref--;
    80003920:	449c                	lw	a5,8(s1)
    80003922:	37fd                	addiw	a5,a5,-1
    80003924:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003926:	0001d517          	auipc	a0,0x1d
    8000392a:	d3a50513          	addi	a0,a0,-710 # 80020660 <icache>
    8000392e:	ffffd097          	auipc	ra,0xffffd
    80003932:	3e8080e7          	jalr	1000(ra) # 80000d16 <release>
}
    80003936:	60e2                	ld	ra,24(sp)
    80003938:	6442                	ld	s0,16(sp)
    8000393a:	64a2                	ld	s1,8(sp)
    8000393c:	6902                	ld	s2,0(sp)
    8000393e:	6105                	addi	sp,sp,32
    80003940:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003942:	40bc                	lw	a5,64(s1)
    80003944:	dff1                	beqz	a5,80003920 <iput+0x26>
    80003946:	04a49783          	lh	a5,74(s1)
    8000394a:	fbf9                	bnez	a5,80003920 <iput+0x26>
    acquiresleep(&ip->lock);
    8000394c:	01048913          	addi	s2,s1,16
    80003950:	854a                	mv	a0,s2
    80003952:	00001097          	auipc	ra,0x1
    80003956:	aa8080e7          	jalr	-1368(ra) # 800043fa <acquiresleep>
    release(&icache.lock);
    8000395a:	0001d517          	auipc	a0,0x1d
    8000395e:	d0650513          	addi	a0,a0,-762 # 80020660 <icache>
    80003962:	ffffd097          	auipc	ra,0xffffd
    80003966:	3b4080e7          	jalr	948(ra) # 80000d16 <release>
    itrunc(ip);
    8000396a:	8526                	mv	a0,s1
    8000396c:	00000097          	auipc	ra,0x0
    80003970:	ee2080e7          	jalr	-286(ra) # 8000384e <itrunc>
    ip->type = 0;
    80003974:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003978:	8526                	mv	a0,s1
    8000397a:	00000097          	auipc	ra,0x0
    8000397e:	cfc080e7          	jalr	-772(ra) # 80003676 <iupdate>
    ip->valid = 0;
    80003982:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003986:	854a                	mv	a0,s2
    80003988:	00001097          	auipc	ra,0x1
    8000398c:	ac8080e7          	jalr	-1336(ra) # 80004450 <releasesleep>
    acquire(&icache.lock);
    80003990:	0001d517          	auipc	a0,0x1d
    80003994:	cd050513          	addi	a0,a0,-816 # 80020660 <icache>
    80003998:	ffffd097          	auipc	ra,0xffffd
    8000399c:	2ca080e7          	jalr	714(ra) # 80000c62 <acquire>
    800039a0:	b741                	j	80003920 <iput+0x26>

00000000800039a2 <iunlockput>:
{
    800039a2:	1101                	addi	sp,sp,-32
    800039a4:	ec06                	sd	ra,24(sp)
    800039a6:	e822                	sd	s0,16(sp)
    800039a8:	e426                	sd	s1,8(sp)
    800039aa:	1000                	addi	s0,sp,32
    800039ac:	84aa                	mv	s1,a0
  iunlock(ip);
    800039ae:	00000097          	auipc	ra,0x0
    800039b2:	e54080e7          	jalr	-428(ra) # 80003802 <iunlock>
  iput(ip);
    800039b6:	8526                	mv	a0,s1
    800039b8:	00000097          	auipc	ra,0x0
    800039bc:	f42080e7          	jalr	-190(ra) # 800038fa <iput>
}
    800039c0:	60e2                	ld	ra,24(sp)
    800039c2:	6442                	ld	s0,16(sp)
    800039c4:	64a2                	ld	s1,8(sp)
    800039c6:	6105                	addi	sp,sp,32
    800039c8:	8082                	ret

00000000800039ca <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800039ca:	1141                	addi	sp,sp,-16
    800039cc:	e422                	sd	s0,8(sp)
    800039ce:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800039d0:	411c                	lw	a5,0(a0)
    800039d2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800039d4:	415c                	lw	a5,4(a0)
    800039d6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800039d8:	04451783          	lh	a5,68(a0)
    800039dc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800039e0:	04a51783          	lh	a5,74(a0)
    800039e4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800039e8:	04c56783          	lwu	a5,76(a0)
    800039ec:	e99c                	sd	a5,16(a1)
}
    800039ee:	6422                	ld	s0,8(sp)
    800039f0:	0141                	addi	sp,sp,16
    800039f2:	8082                	ret

00000000800039f4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800039f4:	457c                	lw	a5,76(a0)
    800039f6:	0ed7e863          	bltu	a5,a3,80003ae6 <readi+0xf2>
{
    800039fa:	7159                	addi	sp,sp,-112
    800039fc:	f486                	sd	ra,104(sp)
    800039fe:	f0a2                	sd	s0,96(sp)
    80003a00:	eca6                	sd	s1,88(sp)
    80003a02:	e8ca                	sd	s2,80(sp)
    80003a04:	e4ce                	sd	s3,72(sp)
    80003a06:	e0d2                	sd	s4,64(sp)
    80003a08:	fc56                	sd	s5,56(sp)
    80003a0a:	f85a                	sd	s6,48(sp)
    80003a0c:	f45e                	sd	s7,40(sp)
    80003a0e:	f062                	sd	s8,32(sp)
    80003a10:	ec66                	sd	s9,24(sp)
    80003a12:	e86a                	sd	s10,16(sp)
    80003a14:	e46e                	sd	s11,8(sp)
    80003a16:	1880                	addi	s0,sp,112
    80003a18:	8baa                	mv	s7,a0
    80003a1a:	8c2e                	mv	s8,a1
    80003a1c:	8ab2                	mv	s5,a2
    80003a1e:	84b6                	mv	s1,a3
    80003a20:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003a22:	9f35                	addw	a4,a4,a3
    return 0;
    80003a24:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a26:	08d76f63          	bltu	a4,a3,80003ac4 <readi+0xd0>
  if(off + n > ip->size)
    80003a2a:	00e7f463          	bgeu	a5,a4,80003a32 <readi+0x3e>
    n = ip->size - off;
    80003a2e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a32:	0a0b0863          	beqz	s6,80003ae2 <readi+0xee>
    80003a36:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a38:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a3c:	5cfd                	li	s9,-1
    80003a3e:	a82d                	j	80003a78 <readi+0x84>
    80003a40:	020a1d93          	slli	s11,s4,0x20
    80003a44:	020ddd93          	srli	s11,s11,0x20
    80003a48:	05890793          	addi	a5,s2,88
    80003a4c:	86ee                	mv	a3,s11
    80003a4e:	963e                	add	a2,a2,a5
    80003a50:	85d6                	mv	a1,s5
    80003a52:	8562                	mv	a0,s8
    80003a54:	fffff097          	auipc	ra,0xfffff
    80003a58:	a54080e7          	jalr	-1452(ra) # 800024a8 <either_copyout>
    80003a5c:	05950d63          	beq	a0,s9,80003ab6 <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003a60:	854a                	mv	a0,s2
    80003a62:	fffff097          	auipc	ra,0xfffff
    80003a66:	60c080e7          	jalr	1548(ra) # 8000306e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a6a:	013a09bb          	addw	s3,s4,s3
    80003a6e:	009a04bb          	addw	s1,s4,s1
    80003a72:	9aee                	add	s5,s5,s11
    80003a74:	0569f663          	bgeu	s3,s6,80003ac0 <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a78:	000ba903          	lw	s2,0(s7)
    80003a7c:	00a4d59b          	srliw	a1,s1,0xa
    80003a80:	855e                	mv	a0,s7
    80003a82:	00000097          	auipc	ra,0x0
    80003a86:	8b0080e7          	jalr	-1872(ra) # 80003332 <bmap>
    80003a8a:	0005059b          	sext.w	a1,a0
    80003a8e:	854a                	mv	a0,s2
    80003a90:	fffff097          	auipc	ra,0xfffff
    80003a94:	4ae080e7          	jalr	1198(ra) # 80002f3e <bread>
    80003a98:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a9a:	3ff4f613          	andi	a2,s1,1023
    80003a9e:	40cd07bb          	subw	a5,s10,a2
    80003aa2:	413b073b          	subw	a4,s6,s3
    80003aa6:	8a3e                	mv	s4,a5
    80003aa8:	2781                	sext.w	a5,a5
    80003aaa:	0007069b          	sext.w	a3,a4
    80003aae:	f8f6f9e3          	bgeu	a3,a5,80003a40 <readi+0x4c>
    80003ab2:	8a3a                	mv	s4,a4
    80003ab4:	b771                	j	80003a40 <readi+0x4c>
      brelse(bp);
    80003ab6:	854a                	mv	a0,s2
    80003ab8:	fffff097          	auipc	ra,0xfffff
    80003abc:	5b6080e7          	jalr	1462(ra) # 8000306e <brelse>
  }
  return tot;
    80003ac0:	0009851b          	sext.w	a0,s3
}
    80003ac4:	70a6                	ld	ra,104(sp)
    80003ac6:	7406                	ld	s0,96(sp)
    80003ac8:	64e6                	ld	s1,88(sp)
    80003aca:	6946                	ld	s2,80(sp)
    80003acc:	69a6                	ld	s3,72(sp)
    80003ace:	6a06                	ld	s4,64(sp)
    80003ad0:	7ae2                	ld	s5,56(sp)
    80003ad2:	7b42                	ld	s6,48(sp)
    80003ad4:	7ba2                	ld	s7,40(sp)
    80003ad6:	7c02                	ld	s8,32(sp)
    80003ad8:	6ce2                	ld	s9,24(sp)
    80003ada:	6d42                	ld	s10,16(sp)
    80003adc:	6da2                	ld	s11,8(sp)
    80003ade:	6165                	addi	sp,sp,112
    80003ae0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ae2:	89da                	mv	s3,s6
    80003ae4:	bff1                	j	80003ac0 <readi+0xcc>
    return 0;
    80003ae6:	4501                	li	a0,0
}
    80003ae8:	8082                	ret

0000000080003aea <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003aea:	457c                	lw	a5,76(a0)
    80003aec:	10d7e663          	bltu	a5,a3,80003bf8 <writei+0x10e>
{
    80003af0:	7159                	addi	sp,sp,-112
    80003af2:	f486                	sd	ra,104(sp)
    80003af4:	f0a2                	sd	s0,96(sp)
    80003af6:	eca6                	sd	s1,88(sp)
    80003af8:	e8ca                	sd	s2,80(sp)
    80003afa:	e4ce                	sd	s3,72(sp)
    80003afc:	e0d2                	sd	s4,64(sp)
    80003afe:	fc56                	sd	s5,56(sp)
    80003b00:	f85a                	sd	s6,48(sp)
    80003b02:	f45e                	sd	s7,40(sp)
    80003b04:	f062                	sd	s8,32(sp)
    80003b06:	ec66                	sd	s9,24(sp)
    80003b08:	e86a                	sd	s10,16(sp)
    80003b0a:	e46e                	sd	s11,8(sp)
    80003b0c:	1880                	addi	s0,sp,112
    80003b0e:	8baa                	mv	s7,a0
    80003b10:	8c2e                	mv	s8,a1
    80003b12:	8ab2                	mv	s5,a2
    80003b14:	8936                	mv	s2,a3
    80003b16:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b18:	00e687bb          	addw	a5,a3,a4
    80003b1c:	0ed7e063          	bltu	a5,a3,80003bfc <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b20:	00043737          	lui	a4,0x43
    80003b24:	0cf76e63          	bltu	a4,a5,80003c00 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b28:	0a0b0763          	beqz	s6,80003bd6 <writei+0xec>
    80003b2c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b2e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b32:	5cfd                	li	s9,-1
    80003b34:	a091                	j	80003b78 <writei+0x8e>
    80003b36:	02099d93          	slli	s11,s3,0x20
    80003b3a:	020ddd93          	srli	s11,s11,0x20
    80003b3e:	05848793          	addi	a5,s1,88
    80003b42:	86ee                	mv	a3,s11
    80003b44:	8656                	mv	a2,s5
    80003b46:	85e2                	mv	a1,s8
    80003b48:	953e                	add	a0,a0,a5
    80003b4a:	fffff097          	auipc	ra,0xfffff
    80003b4e:	9b4080e7          	jalr	-1612(ra) # 800024fe <either_copyin>
    80003b52:	07950263          	beq	a0,s9,80003bb6 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003b56:	8526                	mv	a0,s1
    80003b58:	00000097          	auipc	ra,0x0
    80003b5c:	77a080e7          	jalr	1914(ra) # 800042d2 <log_write>
    brelse(bp);
    80003b60:	8526                	mv	a0,s1
    80003b62:	fffff097          	auipc	ra,0xfffff
    80003b66:	50c080e7          	jalr	1292(ra) # 8000306e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b6a:	01498a3b          	addw	s4,s3,s4
    80003b6e:	0129893b          	addw	s2,s3,s2
    80003b72:	9aee                	add	s5,s5,s11
    80003b74:	056a7663          	bgeu	s4,s6,80003bc0 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b78:	000ba483          	lw	s1,0(s7)
    80003b7c:	00a9559b          	srliw	a1,s2,0xa
    80003b80:	855e                	mv	a0,s7
    80003b82:	fffff097          	auipc	ra,0xfffff
    80003b86:	7b0080e7          	jalr	1968(ra) # 80003332 <bmap>
    80003b8a:	0005059b          	sext.w	a1,a0
    80003b8e:	8526                	mv	a0,s1
    80003b90:	fffff097          	auipc	ra,0xfffff
    80003b94:	3ae080e7          	jalr	942(ra) # 80002f3e <bread>
    80003b98:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b9a:	3ff97513          	andi	a0,s2,1023
    80003b9e:	40ad07bb          	subw	a5,s10,a0
    80003ba2:	414b073b          	subw	a4,s6,s4
    80003ba6:	89be                	mv	s3,a5
    80003ba8:	2781                	sext.w	a5,a5
    80003baa:	0007069b          	sext.w	a3,a4
    80003bae:	f8f6f4e3          	bgeu	a3,a5,80003b36 <writei+0x4c>
    80003bb2:	89ba                	mv	s3,a4
    80003bb4:	b749                	j	80003b36 <writei+0x4c>
      brelse(bp);
    80003bb6:	8526                	mv	a0,s1
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	4b6080e7          	jalr	1206(ra) # 8000306e <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003bc0:	04cba783          	lw	a5,76(s7)
    80003bc4:	0127f463          	bgeu	a5,s2,80003bcc <writei+0xe2>
      ip->size = off;
    80003bc8:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003bcc:	855e                	mv	a0,s7
    80003bce:	00000097          	auipc	ra,0x0
    80003bd2:	aa8080e7          	jalr	-1368(ra) # 80003676 <iupdate>
  }

  return n;
    80003bd6:	000b051b          	sext.w	a0,s6
}
    80003bda:	70a6                	ld	ra,104(sp)
    80003bdc:	7406                	ld	s0,96(sp)
    80003bde:	64e6                	ld	s1,88(sp)
    80003be0:	6946                	ld	s2,80(sp)
    80003be2:	69a6                	ld	s3,72(sp)
    80003be4:	6a06                	ld	s4,64(sp)
    80003be6:	7ae2                	ld	s5,56(sp)
    80003be8:	7b42                	ld	s6,48(sp)
    80003bea:	7ba2                	ld	s7,40(sp)
    80003bec:	7c02                	ld	s8,32(sp)
    80003bee:	6ce2                	ld	s9,24(sp)
    80003bf0:	6d42                	ld	s10,16(sp)
    80003bf2:	6da2                	ld	s11,8(sp)
    80003bf4:	6165                	addi	sp,sp,112
    80003bf6:	8082                	ret
    return -1;
    80003bf8:	557d                	li	a0,-1
}
    80003bfa:	8082                	ret
    return -1;
    80003bfc:	557d                	li	a0,-1
    80003bfe:	bff1                	j	80003bda <writei+0xf0>
    return -1;
    80003c00:	557d                	li	a0,-1
    80003c02:	bfe1                	j	80003bda <writei+0xf0>

0000000080003c04 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c04:	1141                	addi	sp,sp,-16
    80003c06:	e406                	sd	ra,8(sp)
    80003c08:	e022                	sd	s0,0(sp)
    80003c0a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c0c:	4639                	li	a2,14
    80003c0e:	ffffd097          	auipc	ra,0xffffd
    80003c12:	228080e7          	jalr	552(ra) # 80000e36 <strncmp>
}
    80003c16:	60a2                	ld	ra,8(sp)
    80003c18:	6402                	ld	s0,0(sp)
    80003c1a:	0141                	addi	sp,sp,16
    80003c1c:	8082                	ret

0000000080003c1e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c1e:	7139                	addi	sp,sp,-64
    80003c20:	fc06                	sd	ra,56(sp)
    80003c22:	f822                	sd	s0,48(sp)
    80003c24:	f426                	sd	s1,40(sp)
    80003c26:	f04a                	sd	s2,32(sp)
    80003c28:	ec4e                	sd	s3,24(sp)
    80003c2a:	e852                	sd	s4,16(sp)
    80003c2c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c2e:	04451703          	lh	a4,68(a0)
    80003c32:	4785                	li	a5,1
    80003c34:	00f71a63          	bne	a4,a5,80003c48 <dirlookup+0x2a>
    80003c38:	892a                	mv	s2,a0
    80003c3a:	89ae                	mv	s3,a1
    80003c3c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c3e:	457c                	lw	a5,76(a0)
    80003c40:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c42:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c44:	e79d                	bnez	a5,80003c72 <dirlookup+0x54>
    80003c46:	a8a5                	j	80003cbe <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003c48:	00005517          	auipc	a0,0x5
    80003c4c:	99850513          	addi	a0,a0,-1640 # 800085e0 <syscalls+0x1b0>
    80003c50:	ffffd097          	auipc	ra,0xffffd
    80003c54:	980080e7          	jalr	-1664(ra) # 800005d0 <panic>
      panic("dirlookup read");
    80003c58:	00005517          	auipc	a0,0x5
    80003c5c:	9a050513          	addi	a0,a0,-1632 # 800085f8 <syscalls+0x1c8>
    80003c60:	ffffd097          	auipc	ra,0xffffd
    80003c64:	970080e7          	jalr	-1680(ra) # 800005d0 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c68:	24c1                	addiw	s1,s1,16
    80003c6a:	04c92783          	lw	a5,76(s2)
    80003c6e:	04f4f763          	bgeu	s1,a5,80003cbc <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c72:	4741                	li	a4,16
    80003c74:	86a6                	mv	a3,s1
    80003c76:	fc040613          	addi	a2,s0,-64
    80003c7a:	4581                	li	a1,0
    80003c7c:	854a                	mv	a0,s2
    80003c7e:	00000097          	auipc	ra,0x0
    80003c82:	d76080e7          	jalr	-650(ra) # 800039f4 <readi>
    80003c86:	47c1                	li	a5,16
    80003c88:	fcf518e3          	bne	a0,a5,80003c58 <dirlookup+0x3a>
    if(de.inum == 0)
    80003c8c:	fc045783          	lhu	a5,-64(s0)
    80003c90:	dfe1                	beqz	a5,80003c68 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003c92:	fc240593          	addi	a1,s0,-62
    80003c96:	854e                	mv	a0,s3
    80003c98:	00000097          	auipc	ra,0x0
    80003c9c:	f6c080e7          	jalr	-148(ra) # 80003c04 <namecmp>
    80003ca0:	f561                	bnez	a0,80003c68 <dirlookup+0x4a>
      if(poff)
    80003ca2:	000a0463          	beqz	s4,80003caa <dirlookup+0x8c>
        *poff = off;
    80003ca6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003caa:	fc045583          	lhu	a1,-64(s0)
    80003cae:	00092503          	lw	a0,0(s2)
    80003cb2:	fffff097          	auipc	ra,0xfffff
    80003cb6:	75a080e7          	jalr	1882(ra) # 8000340c <iget>
    80003cba:	a011                	j	80003cbe <dirlookup+0xa0>
  return 0;
    80003cbc:	4501                	li	a0,0
}
    80003cbe:	70e2                	ld	ra,56(sp)
    80003cc0:	7442                	ld	s0,48(sp)
    80003cc2:	74a2                	ld	s1,40(sp)
    80003cc4:	7902                	ld	s2,32(sp)
    80003cc6:	69e2                	ld	s3,24(sp)
    80003cc8:	6a42                	ld	s4,16(sp)
    80003cca:	6121                	addi	sp,sp,64
    80003ccc:	8082                	ret

0000000080003cce <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003cce:	711d                	addi	sp,sp,-96
    80003cd0:	ec86                	sd	ra,88(sp)
    80003cd2:	e8a2                	sd	s0,80(sp)
    80003cd4:	e4a6                	sd	s1,72(sp)
    80003cd6:	e0ca                	sd	s2,64(sp)
    80003cd8:	fc4e                	sd	s3,56(sp)
    80003cda:	f852                	sd	s4,48(sp)
    80003cdc:	f456                	sd	s5,40(sp)
    80003cde:	f05a                	sd	s6,32(sp)
    80003ce0:	ec5e                	sd	s7,24(sp)
    80003ce2:	e862                	sd	s8,16(sp)
    80003ce4:	e466                	sd	s9,8(sp)
    80003ce6:	1080                	addi	s0,sp,96
    80003ce8:	84aa                	mv	s1,a0
    80003cea:	8aae                	mv	s5,a1
    80003cec:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003cee:	00054703          	lbu	a4,0(a0)
    80003cf2:	02f00793          	li	a5,47
    80003cf6:	02f70363          	beq	a4,a5,80003d1c <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003cfa:	ffffe097          	auipc	ra,0xffffe
    80003cfe:	d34080e7          	jalr	-716(ra) # 80001a2e <myproc>
    80003d02:	15053503          	ld	a0,336(a0)
    80003d06:	00000097          	auipc	ra,0x0
    80003d0a:	9fc080e7          	jalr	-1540(ra) # 80003702 <idup>
    80003d0e:	89aa                	mv	s3,a0
  while(*path == '/')
    80003d10:	02f00913          	li	s2,47
  len = path - s;
    80003d14:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003d16:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d18:	4b85                	li	s7,1
    80003d1a:	a865                	j	80003dd2 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003d1c:	4585                	li	a1,1
    80003d1e:	4505                	li	a0,1
    80003d20:	fffff097          	auipc	ra,0xfffff
    80003d24:	6ec080e7          	jalr	1772(ra) # 8000340c <iget>
    80003d28:	89aa                	mv	s3,a0
    80003d2a:	b7dd                	j	80003d10 <namex+0x42>
      iunlockput(ip);
    80003d2c:	854e                	mv	a0,s3
    80003d2e:	00000097          	auipc	ra,0x0
    80003d32:	c74080e7          	jalr	-908(ra) # 800039a2 <iunlockput>
      return 0;
    80003d36:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d38:	854e                	mv	a0,s3
    80003d3a:	60e6                	ld	ra,88(sp)
    80003d3c:	6446                	ld	s0,80(sp)
    80003d3e:	64a6                	ld	s1,72(sp)
    80003d40:	6906                	ld	s2,64(sp)
    80003d42:	79e2                	ld	s3,56(sp)
    80003d44:	7a42                	ld	s4,48(sp)
    80003d46:	7aa2                	ld	s5,40(sp)
    80003d48:	7b02                	ld	s6,32(sp)
    80003d4a:	6be2                	ld	s7,24(sp)
    80003d4c:	6c42                	ld	s8,16(sp)
    80003d4e:	6ca2                	ld	s9,8(sp)
    80003d50:	6125                	addi	sp,sp,96
    80003d52:	8082                	ret
      iunlock(ip);
    80003d54:	854e                	mv	a0,s3
    80003d56:	00000097          	auipc	ra,0x0
    80003d5a:	aac080e7          	jalr	-1364(ra) # 80003802 <iunlock>
      return ip;
    80003d5e:	bfe9                	j	80003d38 <namex+0x6a>
      iunlockput(ip);
    80003d60:	854e                	mv	a0,s3
    80003d62:	00000097          	auipc	ra,0x0
    80003d66:	c40080e7          	jalr	-960(ra) # 800039a2 <iunlockput>
      return 0;
    80003d6a:	89e6                	mv	s3,s9
    80003d6c:	b7f1                	j	80003d38 <namex+0x6a>
  len = path - s;
    80003d6e:	40b48633          	sub	a2,s1,a1
    80003d72:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003d76:	099c5463          	bge	s8,s9,80003dfe <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003d7a:	4639                	li	a2,14
    80003d7c:	8552                	mv	a0,s4
    80003d7e:	ffffd097          	auipc	ra,0xffffd
    80003d82:	03c080e7          	jalr	60(ra) # 80000dba <memmove>
  while(*path == '/')
    80003d86:	0004c783          	lbu	a5,0(s1)
    80003d8a:	01279763          	bne	a5,s2,80003d98 <namex+0xca>
    path++;
    80003d8e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d90:	0004c783          	lbu	a5,0(s1)
    80003d94:	ff278de3          	beq	a5,s2,80003d8e <namex+0xc0>
    ilock(ip);
    80003d98:	854e                	mv	a0,s3
    80003d9a:	00000097          	auipc	ra,0x0
    80003d9e:	9a6080e7          	jalr	-1626(ra) # 80003740 <ilock>
    if(ip->type != T_DIR){
    80003da2:	04499783          	lh	a5,68(s3)
    80003da6:	f97793e3          	bne	a5,s7,80003d2c <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003daa:	000a8563          	beqz	s5,80003db4 <namex+0xe6>
    80003dae:	0004c783          	lbu	a5,0(s1)
    80003db2:	d3cd                	beqz	a5,80003d54 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003db4:	865a                	mv	a2,s6
    80003db6:	85d2                	mv	a1,s4
    80003db8:	854e                	mv	a0,s3
    80003dba:	00000097          	auipc	ra,0x0
    80003dbe:	e64080e7          	jalr	-412(ra) # 80003c1e <dirlookup>
    80003dc2:	8caa                	mv	s9,a0
    80003dc4:	dd51                	beqz	a0,80003d60 <namex+0x92>
    iunlockput(ip);
    80003dc6:	854e                	mv	a0,s3
    80003dc8:	00000097          	auipc	ra,0x0
    80003dcc:	bda080e7          	jalr	-1062(ra) # 800039a2 <iunlockput>
    ip = next;
    80003dd0:	89e6                	mv	s3,s9
  while(*path == '/')
    80003dd2:	0004c783          	lbu	a5,0(s1)
    80003dd6:	05279763          	bne	a5,s2,80003e24 <namex+0x156>
    path++;
    80003dda:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003ddc:	0004c783          	lbu	a5,0(s1)
    80003de0:	ff278de3          	beq	a5,s2,80003dda <namex+0x10c>
  if(*path == 0)
    80003de4:	c79d                	beqz	a5,80003e12 <namex+0x144>
    path++;
    80003de6:	85a6                	mv	a1,s1
  len = path - s;
    80003de8:	8cda                	mv	s9,s6
    80003dea:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003dec:	01278963          	beq	a5,s2,80003dfe <namex+0x130>
    80003df0:	dfbd                	beqz	a5,80003d6e <namex+0xa0>
    path++;
    80003df2:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003df4:	0004c783          	lbu	a5,0(s1)
    80003df8:	ff279ce3          	bne	a5,s2,80003df0 <namex+0x122>
    80003dfc:	bf8d                	j	80003d6e <namex+0xa0>
    memmove(name, s, len);
    80003dfe:	2601                	sext.w	a2,a2
    80003e00:	8552                	mv	a0,s4
    80003e02:	ffffd097          	auipc	ra,0xffffd
    80003e06:	fb8080e7          	jalr	-72(ra) # 80000dba <memmove>
    name[len] = 0;
    80003e0a:	9cd2                	add	s9,s9,s4
    80003e0c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003e10:	bf9d                	j	80003d86 <namex+0xb8>
  if(nameiparent){
    80003e12:	f20a83e3          	beqz	s5,80003d38 <namex+0x6a>
    iput(ip);
    80003e16:	854e                	mv	a0,s3
    80003e18:	00000097          	auipc	ra,0x0
    80003e1c:	ae2080e7          	jalr	-1310(ra) # 800038fa <iput>
    return 0;
    80003e20:	4981                	li	s3,0
    80003e22:	bf19                	j	80003d38 <namex+0x6a>
  if(*path == 0)
    80003e24:	d7fd                	beqz	a5,80003e12 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003e26:	0004c783          	lbu	a5,0(s1)
    80003e2a:	85a6                	mv	a1,s1
    80003e2c:	b7d1                	j	80003df0 <namex+0x122>

0000000080003e2e <dirlink>:
{
    80003e2e:	7139                	addi	sp,sp,-64
    80003e30:	fc06                	sd	ra,56(sp)
    80003e32:	f822                	sd	s0,48(sp)
    80003e34:	f426                	sd	s1,40(sp)
    80003e36:	f04a                	sd	s2,32(sp)
    80003e38:	ec4e                	sd	s3,24(sp)
    80003e3a:	e852                	sd	s4,16(sp)
    80003e3c:	0080                	addi	s0,sp,64
    80003e3e:	892a                	mv	s2,a0
    80003e40:	8a2e                	mv	s4,a1
    80003e42:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e44:	4601                	li	a2,0
    80003e46:	00000097          	auipc	ra,0x0
    80003e4a:	dd8080e7          	jalr	-552(ra) # 80003c1e <dirlookup>
    80003e4e:	e93d                	bnez	a0,80003ec4 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e50:	04c92483          	lw	s1,76(s2)
    80003e54:	c49d                	beqz	s1,80003e82 <dirlink+0x54>
    80003e56:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e58:	4741                	li	a4,16
    80003e5a:	86a6                	mv	a3,s1
    80003e5c:	fc040613          	addi	a2,s0,-64
    80003e60:	4581                	li	a1,0
    80003e62:	854a                	mv	a0,s2
    80003e64:	00000097          	auipc	ra,0x0
    80003e68:	b90080e7          	jalr	-1136(ra) # 800039f4 <readi>
    80003e6c:	47c1                	li	a5,16
    80003e6e:	06f51163          	bne	a0,a5,80003ed0 <dirlink+0xa2>
    if(de.inum == 0)
    80003e72:	fc045783          	lhu	a5,-64(s0)
    80003e76:	c791                	beqz	a5,80003e82 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e78:	24c1                	addiw	s1,s1,16
    80003e7a:	04c92783          	lw	a5,76(s2)
    80003e7e:	fcf4ede3          	bltu	s1,a5,80003e58 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e82:	4639                	li	a2,14
    80003e84:	85d2                	mv	a1,s4
    80003e86:	fc240513          	addi	a0,s0,-62
    80003e8a:	ffffd097          	auipc	ra,0xffffd
    80003e8e:	fe8080e7          	jalr	-24(ra) # 80000e72 <strncpy>
  de.inum = inum;
    80003e92:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e96:	4741                	li	a4,16
    80003e98:	86a6                	mv	a3,s1
    80003e9a:	fc040613          	addi	a2,s0,-64
    80003e9e:	4581                	li	a1,0
    80003ea0:	854a                	mv	a0,s2
    80003ea2:	00000097          	auipc	ra,0x0
    80003ea6:	c48080e7          	jalr	-952(ra) # 80003aea <writei>
    80003eaa:	872a                	mv	a4,a0
    80003eac:	47c1                	li	a5,16
  return 0;
    80003eae:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003eb0:	02f71863          	bne	a4,a5,80003ee0 <dirlink+0xb2>
}
    80003eb4:	70e2                	ld	ra,56(sp)
    80003eb6:	7442                	ld	s0,48(sp)
    80003eb8:	74a2                	ld	s1,40(sp)
    80003eba:	7902                	ld	s2,32(sp)
    80003ebc:	69e2                	ld	s3,24(sp)
    80003ebe:	6a42                	ld	s4,16(sp)
    80003ec0:	6121                	addi	sp,sp,64
    80003ec2:	8082                	ret
    iput(ip);
    80003ec4:	00000097          	auipc	ra,0x0
    80003ec8:	a36080e7          	jalr	-1482(ra) # 800038fa <iput>
    return -1;
    80003ecc:	557d                	li	a0,-1
    80003ece:	b7dd                	j	80003eb4 <dirlink+0x86>
      panic("dirlink read");
    80003ed0:	00004517          	auipc	a0,0x4
    80003ed4:	73850513          	addi	a0,a0,1848 # 80008608 <syscalls+0x1d8>
    80003ed8:	ffffc097          	auipc	ra,0xffffc
    80003edc:	6f8080e7          	jalr	1784(ra) # 800005d0 <panic>
    panic("dirlink");
    80003ee0:	00005517          	auipc	a0,0x5
    80003ee4:	84850513          	addi	a0,a0,-1976 # 80008728 <syscalls+0x2f8>
    80003ee8:	ffffc097          	auipc	ra,0xffffc
    80003eec:	6e8080e7          	jalr	1768(ra) # 800005d0 <panic>

0000000080003ef0 <namei>:

struct inode*
namei(char *path)
{
    80003ef0:	1101                	addi	sp,sp,-32
    80003ef2:	ec06                	sd	ra,24(sp)
    80003ef4:	e822                	sd	s0,16(sp)
    80003ef6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003ef8:	fe040613          	addi	a2,s0,-32
    80003efc:	4581                	li	a1,0
    80003efe:	00000097          	auipc	ra,0x0
    80003f02:	dd0080e7          	jalr	-560(ra) # 80003cce <namex>
}
    80003f06:	60e2                	ld	ra,24(sp)
    80003f08:	6442                	ld	s0,16(sp)
    80003f0a:	6105                	addi	sp,sp,32
    80003f0c:	8082                	ret

0000000080003f0e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f0e:	1141                	addi	sp,sp,-16
    80003f10:	e406                	sd	ra,8(sp)
    80003f12:	e022                	sd	s0,0(sp)
    80003f14:	0800                	addi	s0,sp,16
    80003f16:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f18:	4585                	li	a1,1
    80003f1a:	00000097          	auipc	ra,0x0
    80003f1e:	db4080e7          	jalr	-588(ra) # 80003cce <namex>
}
    80003f22:	60a2                	ld	ra,8(sp)
    80003f24:	6402                	ld	s0,0(sp)
    80003f26:	0141                	addi	sp,sp,16
    80003f28:	8082                	ret

0000000080003f2a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f2a:	1101                	addi	sp,sp,-32
    80003f2c:	ec06                	sd	ra,24(sp)
    80003f2e:	e822                	sd	s0,16(sp)
    80003f30:	e426                	sd	s1,8(sp)
    80003f32:	e04a                	sd	s2,0(sp)
    80003f34:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f36:	0001e917          	auipc	s2,0x1e
    80003f3a:	1d290913          	addi	s2,s2,466 # 80022108 <log>
    80003f3e:	01892583          	lw	a1,24(s2)
    80003f42:	02892503          	lw	a0,40(s2)
    80003f46:	fffff097          	auipc	ra,0xfffff
    80003f4a:	ff8080e7          	jalr	-8(ra) # 80002f3e <bread>
    80003f4e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f50:	02c92683          	lw	a3,44(s2)
    80003f54:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f56:	02d05763          	blez	a3,80003f84 <write_head+0x5a>
    80003f5a:	0001e797          	auipc	a5,0x1e
    80003f5e:	1de78793          	addi	a5,a5,478 # 80022138 <log+0x30>
    80003f62:	05c50713          	addi	a4,a0,92
    80003f66:	36fd                	addiw	a3,a3,-1
    80003f68:	1682                	slli	a3,a3,0x20
    80003f6a:	9281                	srli	a3,a3,0x20
    80003f6c:	068a                	slli	a3,a3,0x2
    80003f6e:	0001e617          	auipc	a2,0x1e
    80003f72:	1ce60613          	addi	a2,a2,462 # 8002213c <log+0x34>
    80003f76:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003f78:	4390                	lw	a2,0(a5)
    80003f7a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f7c:	0791                	addi	a5,a5,4
    80003f7e:	0711                	addi	a4,a4,4
    80003f80:	fed79ce3          	bne	a5,a3,80003f78 <write_head+0x4e>
  }
  bwrite(buf);
    80003f84:	8526                	mv	a0,s1
    80003f86:	fffff097          	auipc	ra,0xfffff
    80003f8a:	0aa080e7          	jalr	170(ra) # 80003030 <bwrite>
  brelse(buf);
    80003f8e:	8526                	mv	a0,s1
    80003f90:	fffff097          	auipc	ra,0xfffff
    80003f94:	0de080e7          	jalr	222(ra) # 8000306e <brelse>
}
    80003f98:	60e2                	ld	ra,24(sp)
    80003f9a:	6442                	ld	s0,16(sp)
    80003f9c:	64a2                	ld	s1,8(sp)
    80003f9e:	6902                	ld	s2,0(sp)
    80003fa0:	6105                	addi	sp,sp,32
    80003fa2:	8082                	ret

0000000080003fa4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fa4:	0001e797          	auipc	a5,0x1e
    80003fa8:	1907a783          	lw	a5,400(a5) # 80022134 <log+0x2c>
    80003fac:	0af05663          	blez	a5,80004058 <install_trans+0xb4>
{
    80003fb0:	7139                	addi	sp,sp,-64
    80003fb2:	fc06                	sd	ra,56(sp)
    80003fb4:	f822                	sd	s0,48(sp)
    80003fb6:	f426                	sd	s1,40(sp)
    80003fb8:	f04a                	sd	s2,32(sp)
    80003fba:	ec4e                	sd	s3,24(sp)
    80003fbc:	e852                	sd	s4,16(sp)
    80003fbe:	e456                	sd	s5,8(sp)
    80003fc0:	0080                	addi	s0,sp,64
    80003fc2:	0001ea97          	auipc	s5,0x1e
    80003fc6:	176a8a93          	addi	s5,s5,374 # 80022138 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fca:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fcc:	0001e997          	auipc	s3,0x1e
    80003fd0:	13c98993          	addi	s3,s3,316 # 80022108 <log>
    80003fd4:	0189a583          	lw	a1,24(s3)
    80003fd8:	014585bb          	addw	a1,a1,s4
    80003fdc:	2585                	addiw	a1,a1,1
    80003fde:	0289a503          	lw	a0,40(s3)
    80003fe2:	fffff097          	auipc	ra,0xfffff
    80003fe6:	f5c080e7          	jalr	-164(ra) # 80002f3e <bread>
    80003fea:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003fec:	000aa583          	lw	a1,0(s5)
    80003ff0:	0289a503          	lw	a0,40(s3)
    80003ff4:	fffff097          	auipc	ra,0xfffff
    80003ff8:	f4a080e7          	jalr	-182(ra) # 80002f3e <bread>
    80003ffc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003ffe:	40000613          	li	a2,1024
    80004002:	05890593          	addi	a1,s2,88
    80004006:	05850513          	addi	a0,a0,88
    8000400a:	ffffd097          	auipc	ra,0xffffd
    8000400e:	db0080e7          	jalr	-592(ra) # 80000dba <memmove>
    bwrite(dbuf);  // write dst to disk
    80004012:	8526                	mv	a0,s1
    80004014:	fffff097          	auipc	ra,0xfffff
    80004018:	01c080e7          	jalr	28(ra) # 80003030 <bwrite>
    bunpin(dbuf);
    8000401c:	8526                	mv	a0,s1
    8000401e:	fffff097          	auipc	ra,0xfffff
    80004022:	12a080e7          	jalr	298(ra) # 80003148 <bunpin>
    brelse(lbuf);
    80004026:	854a                	mv	a0,s2
    80004028:	fffff097          	auipc	ra,0xfffff
    8000402c:	046080e7          	jalr	70(ra) # 8000306e <brelse>
    brelse(dbuf);
    80004030:	8526                	mv	a0,s1
    80004032:	fffff097          	auipc	ra,0xfffff
    80004036:	03c080e7          	jalr	60(ra) # 8000306e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000403a:	2a05                	addiw	s4,s4,1
    8000403c:	0a91                	addi	s5,s5,4
    8000403e:	02c9a783          	lw	a5,44(s3)
    80004042:	f8fa49e3          	blt	s4,a5,80003fd4 <install_trans+0x30>
}
    80004046:	70e2                	ld	ra,56(sp)
    80004048:	7442                	ld	s0,48(sp)
    8000404a:	74a2                	ld	s1,40(sp)
    8000404c:	7902                	ld	s2,32(sp)
    8000404e:	69e2                	ld	s3,24(sp)
    80004050:	6a42                	ld	s4,16(sp)
    80004052:	6aa2                	ld	s5,8(sp)
    80004054:	6121                	addi	sp,sp,64
    80004056:	8082                	ret
    80004058:	8082                	ret

000000008000405a <initlog>:
{
    8000405a:	7179                	addi	sp,sp,-48
    8000405c:	f406                	sd	ra,40(sp)
    8000405e:	f022                	sd	s0,32(sp)
    80004060:	ec26                	sd	s1,24(sp)
    80004062:	e84a                	sd	s2,16(sp)
    80004064:	e44e                	sd	s3,8(sp)
    80004066:	1800                	addi	s0,sp,48
    80004068:	892a                	mv	s2,a0
    8000406a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000406c:	0001e497          	auipc	s1,0x1e
    80004070:	09c48493          	addi	s1,s1,156 # 80022108 <log>
    80004074:	00004597          	auipc	a1,0x4
    80004078:	5a458593          	addi	a1,a1,1444 # 80008618 <syscalls+0x1e8>
    8000407c:	8526                	mv	a0,s1
    8000407e:	ffffd097          	auipc	ra,0xffffd
    80004082:	b54080e7          	jalr	-1196(ra) # 80000bd2 <initlock>
  log.start = sb->logstart;
    80004086:	0149a583          	lw	a1,20(s3)
    8000408a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000408c:	0109a783          	lw	a5,16(s3)
    80004090:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004092:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004096:	854a                	mv	a0,s2
    80004098:	fffff097          	auipc	ra,0xfffff
    8000409c:	ea6080e7          	jalr	-346(ra) # 80002f3e <bread>
  log.lh.n = lh->n;
    800040a0:	4d34                	lw	a3,88(a0)
    800040a2:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800040a4:	02d05563          	blez	a3,800040ce <initlog+0x74>
    800040a8:	05c50793          	addi	a5,a0,92
    800040ac:	0001e717          	auipc	a4,0x1e
    800040b0:	08c70713          	addi	a4,a4,140 # 80022138 <log+0x30>
    800040b4:	36fd                	addiw	a3,a3,-1
    800040b6:	1682                	slli	a3,a3,0x20
    800040b8:	9281                	srli	a3,a3,0x20
    800040ba:	068a                	slli	a3,a3,0x2
    800040bc:	06050613          	addi	a2,a0,96
    800040c0:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800040c2:	4390                	lw	a2,0(a5)
    800040c4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800040c6:	0791                	addi	a5,a5,4
    800040c8:	0711                	addi	a4,a4,4
    800040ca:	fed79ce3          	bne	a5,a3,800040c2 <initlog+0x68>
  brelse(buf);
    800040ce:	fffff097          	auipc	ra,0xfffff
    800040d2:	fa0080e7          	jalr	-96(ra) # 8000306e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    800040d6:	00000097          	auipc	ra,0x0
    800040da:	ece080e7          	jalr	-306(ra) # 80003fa4 <install_trans>
  log.lh.n = 0;
    800040de:	0001e797          	auipc	a5,0x1e
    800040e2:	0407ab23          	sw	zero,86(a5) # 80022134 <log+0x2c>
  write_head(); // clear the log
    800040e6:	00000097          	auipc	ra,0x0
    800040ea:	e44080e7          	jalr	-444(ra) # 80003f2a <write_head>
}
    800040ee:	70a2                	ld	ra,40(sp)
    800040f0:	7402                	ld	s0,32(sp)
    800040f2:	64e2                	ld	s1,24(sp)
    800040f4:	6942                	ld	s2,16(sp)
    800040f6:	69a2                	ld	s3,8(sp)
    800040f8:	6145                	addi	sp,sp,48
    800040fa:	8082                	ret

00000000800040fc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800040fc:	1101                	addi	sp,sp,-32
    800040fe:	ec06                	sd	ra,24(sp)
    80004100:	e822                	sd	s0,16(sp)
    80004102:	e426                	sd	s1,8(sp)
    80004104:	e04a                	sd	s2,0(sp)
    80004106:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004108:	0001e517          	auipc	a0,0x1e
    8000410c:	00050513          	mv	a0,a0
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	b52080e7          	jalr	-1198(ra) # 80000c62 <acquire>
  while(1){
    if(log.committing){
    80004118:	0001e497          	auipc	s1,0x1e
    8000411c:	ff048493          	addi	s1,s1,-16 # 80022108 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004120:	4979                	li	s2,30
    80004122:	a039                	j	80004130 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004124:	85a6                	mv	a1,s1
    80004126:	8526                	mv	a0,s1
    80004128:	ffffe097          	auipc	ra,0xffffe
    8000412c:	126080e7          	jalr	294(ra) # 8000224e <sleep>
    if(log.committing){
    80004130:	50dc                	lw	a5,36(s1)
    80004132:	fbed                	bnez	a5,80004124 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004134:	509c                	lw	a5,32(s1)
    80004136:	0017871b          	addiw	a4,a5,1
    8000413a:	0007069b          	sext.w	a3,a4
    8000413e:	0027179b          	slliw	a5,a4,0x2
    80004142:	9fb9                	addw	a5,a5,a4
    80004144:	0017979b          	slliw	a5,a5,0x1
    80004148:	54d8                	lw	a4,44(s1)
    8000414a:	9fb9                	addw	a5,a5,a4
    8000414c:	00f95963          	bge	s2,a5,8000415e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004150:	85a6                	mv	a1,s1
    80004152:	8526                	mv	a0,s1
    80004154:	ffffe097          	auipc	ra,0xffffe
    80004158:	0fa080e7          	jalr	250(ra) # 8000224e <sleep>
    8000415c:	bfd1                	j	80004130 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000415e:	0001e517          	auipc	a0,0x1e
    80004162:	faa50513          	addi	a0,a0,-86 # 80022108 <log>
    80004166:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004168:	ffffd097          	auipc	ra,0xffffd
    8000416c:	bae080e7          	jalr	-1106(ra) # 80000d16 <release>
      break;
    }
  }
}
    80004170:	60e2                	ld	ra,24(sp)
    80004172:	6442                	ld	s0,16(sp)
    80004174:	64a2                	ld	s1,8(sp)
    80004176:	6902                	ld	s2,0(sp)
    80004178:	6105                	addi	sp,sp,32
    8000417a:	8082                	ret

000000008000417c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000417c:	7139                	addi	sp,sp,-64
    8000417e:	fc06                	sd	ra,56(sp)
    80004180:	f822                	sd	s0,48(sp)
    80004182:	f426                	sd	s1,40(sp)
    80004184:	f04a                	sd	s2,32(sp)
    80004186:	ec4e                	sd	s3,24(sp)
    80004188:	e852                	sd	s4,16(sp)
    8000418a:	e456                	sd	s5,8(sp)
    8000418c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000418e:	0001e497          	auipc	s1,0x1e
    80004192:	f7a48493          	addi	s1,s1,-134 # 80022108 <log>
    80004196:	8526                	mv	a0,s1
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	aca080e7          	jalr	-1334(ra) # 80000c62 <acquire>
  log.outstanding -= 1;
    800041a0:	509c                	lw	a5,32(s1)
    800041a2:	37fd                	addiw	a5,a5,-1
    800041a4:	0007891b          	sext.w	s2,a5
    800041a8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800041aa:	50dc                	lw	a5,36(s1)
    800041ac:	e7b9                	bnez	a5,800041fa <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800041ae:	04091e63          	bnez	s2,8000420a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800041b2:	0001e497          	auipc	s1,0x1e
    800041b6:	f5648493          	addi	s1,s1,-170 # 80022108 <log>
    800041ba:	4785                	li	a5,1
    800041bc:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800041be:	8526                	mv	a0,s1
    800041c0:	ffffd097          	auipc	ra,0xffffd
    800041c4:	b56080e7          	jalr	-1194(ra) # 80000d16 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800041c8:	54dc                	lw	a5,44(s1)
    800041ca:	06f04763          	bgtz	a5,80004238 <end_op+0xbc>
    acquire(&log.lock);
    800041ce:	0001e497          	auipc	s1,0x1e
    800041d2:	f3a48493          	addi	s1,s1,-198 # 80022108 <log>
    800041d6:	8526                	mv	a0,s1
    800041d8:	ffffd097          	auipc	ra,0xffffd
    800041dc:	a8a080e7          	jalr	-1398(ra) # 80000c62 <acquire>
    log.committing = 0;
    800041e0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800041e4:	8526                	mv	a0,s1
    800041e6:	ffffe097          	auipc	ra,0xffffe
    800041ea:	1e8080e7          	jalr	488(ra) # 800023ce <wakeup>
    release(&log.lock);
    800041ee:	8526                	mv	a0,s1
    800041f0:	ffffd097          	auipc	ra,0xffffd
    800041f4:	b26080e7          	jalr	-1242(ra) # 80000d16 <release>
}
    800041f8:	a03d                	j	80004226 <end_op+0xaa>
    panic("log.committing");
    800041fa:	00004517          	auipc	a0,0x4
    800041fe:	42650513          	addi	a0,a0,1062 # 80008620 <syscalls+0x1f0>
    80004202:	ffffc097          	auipc	ra,0xffffc
    80004206:	3ce080e7          	jalr	974(ra) # 800005d0 <panic>
    wakeup(&log);
    8000420a:	0001e497          	auipc	s1,0x1e
    8000420e:	efe48493          	addi	s1,s1,-258 # 80022108 <log>
    80004212:	8526                	mv	a0,s1
    80004214:	ffffe097          	auipc	ra,0xffffe
    80004218:	1ba080e7          	jalr	442(ra) # 800023ce <wakeup>
  release(&log.lock);
    8000421c:	8526                	mv	a0,s1
    8000421e:	ffffd097          	auipc	ra,0xffffd
    80004222:	af8080e7          	jalr	-1288(ra) # 80000d16 <release>
}
    80004226:	70e2                	ld	ra,56(sp)
    80004228:	7442                	ld	s0,48(sp)
    8000422a:	74a2                	ld	s1,40(sp)
    8000422c:	7902                	ld	s2,32(sp)
    8000422e:	69e2                	ld	s3,24(sp)
    80004230:	6a42                	ld	s4,16(sp)
    80004232:	6aa2                	ld	s5,8(sp)
    80004234:	6121                	addi	sp,sp,64
    80004236:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004238:	0001ea97          	auipc	s5,0x1e
    8000423c:	f00a8a93          	addi	s5,s5,-256 # 80022138 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004240:	0001ea17          	auipc	s4,0x1e
    80004244:	ec8a0a13          	addi	s4,s4,-312 # 80022108 <log>
    80004248:	018a2583          	lw	a1,24(s4)
    8000424c:	012585bb          	addw	a1,a1,s2
    80004250:	2585                	addiw	a1,a1,1
    80004252:	028a2503          	lw	a0,40(s4)
    80004256:	fffff097          	auipc	ra,0xfffff
    8000425a:	ce8080e7          	jalr	-792(ra) # 80002f3e <bread>
    8000425e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004260:	000aa583          	lw	a1,0(s5)
    80004264:	028a2503          	lw	a0,40(s4)
    80004268:	fffff097          	auipc	ra,0xfffff
    8000426c:	cd6080e7          	jalr	-810(ra) # 80002f3e <bread>
    80004270:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004272:	40000613          	li	a2,1024
    80004276:	05850593          	addi	a1,a0,88
    8000427a:	05848513          	addi	a0,s1,88
    8000427e:	ffffd097          	auipc	ra,0xffffd
    80004282:	b3c080e7          	jalr	-1220(ra) # 80000dba <memmove>
    bwrite(to);  // write the log
    80004286:	8526                	mv	a0,s1
    80004288:	fffff097          	auipc	ra,0xfffff
    8000428c:	da8080e7          	jalr	-600(ra) # 80003030 <bwrite>
    brelse(from);
    80004290:	854e                	mv	a0,s3
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	ddc080e7          	jalr	-548(ra) # 8000306e <brelse>
    brelse(to);
    8000429a:	8526                	mv	a0,s1
    8000429c:	fffff097          	auipc	ra,0xfffff
    800042a0:	dd2080e7          	jalr	-558(ra) # 8000306e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042a4:	2905                	addiw	s2,s2,1
    800042a6:	0a91                	addi	s5,s5,4
    800042a8:	02ca2783          	lw	a5,44(s4)
    800042ac:	f8f94ee3          	blt	s2,a5,80004248 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800042b0:	00000097          	auipc	ra,0x0
    800042b4:	c7a080e7          	jalr	-902(ra) # 80003f2a <write_head>
    install_trans(); // Now install writes to home locations
    800042b8:	00000097          	auipc	ra,0x0
    800042bc:	cec080e7          	jalr	-788(ra) # 80003fa4 <install_trans>
    log.lh.n = 0;
    800042c0:	0001e797          	auipc	a5,0x1e
    800042c4:	e607aa23          	sw	zero,-396(a5) # 80022134 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800042c8:	00000097          	auipc	ra,0x0
    800042cc:	c62080e7          	jalr	-926(ra) # 80003f2a <write_head>
    800042d0:	bdfd                	j	800041ce <end_op+0x52>

00000000800042d2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800042d2:	1101                	addi	sp,sp,-32
    800042d4:	ec06                	sd	ra,24(sp)
    800042d6:	e822                	sd	s0,16(sp)
    800042d8:	e426                	sd	s1,8(sp)
    800042da:	e04a                	sd	s2,0(sp)
    800042dc:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800042de:	0001e717          	auipc	a4,0x1e
    800042e2:	e5672703          	lw	a4,-426(a4) # 80022134 <log+0x2c>
    800042e6:	47f5                	li	a5,29
    800042e8:	08e7c063          	blt	a5,a4,80004368 <log_write+0x96>
    800042ec:	84aa                	mv	s1,a0
    800042ee:	0001e797          	auipc	a5,0x1e
    800042f2:	e367a783          	lw	a5,-458(a5) # 80022124 <log+0x1c>
    800042f6:	37fd                	addiw	a5,a5,-1
    800042f8:	06f75863          	bge	a4,a5,80004368 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800042fc:	0001e797          	auipc	a5,0x1e
    80004300:	e2c7a783          	lw	a5,-468(a5) # 80022128 <log+0x20>
    80004304:	06f05a63          	blez	a5,80004378 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80004308:	0001e917          	auipc	s2,0x1e
    8000430c:	e0090913          	addi	s2,s2,-512 # 80022108 <log>
    80004310:	854a                	mv	a0,s2
    80004312:	ffffd097          	auipc	ra,0xffffd
    80004316:	950080e7          	jalr	-1712(ra) # 80000c62 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    8000431a:	02c92603          	lw	a2,44(s2)
    8000431e:	06c05563          	blez	a2,80004388 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004322:	44cc                	lw	a1,12(s1)
    80004324:	0001e717          	auipc	a4,0x1e
    80004328:	e1470713          	addi	a4,a4,-492 # 80022138 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000432c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000432e:	4314                	lw	a3,0(a4)
    80004330:	04b68d63          	beq	a3,a1,8000438a <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80004334:	2785                	addiw	a5,a5,1
    80004336:	0711                	addi	a4,a4,4
    80004338:	fec79be3          	bne	a5,a2,8000432e <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000433c:	0621                	addi	a2,a2,8
    8000433e:	060a                	slli	a2,a2,0x2
    80004340:	0001e797          	auipc	a5,0x1e
    80004344:	dc878793          	addi	a5,a5,-568 # 80022108 <log>
    80004348:	963e                	add	a2,a2,a5
    8000434a:	44dc                	lw	a5,12(s1)
    8000434c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000434e:	8526                	mv	a0,s1
    80004350:	fffff097          	auipc	ra,0xfffff
    80004354:	dbc080e7          	jalr	-580(ra) # 8000310c <bpin>
    log.lh.n++;
    80004358:	0001e717          	auipc	a4,0x1e
    8000435c:	db070713          	addi	a4,a4,-592 # 80022108 <log>
    80004360:	575c                	lw	a5,44(a4)
    80004362:	2785                	addiw	a5,a5,1
    80004364:	d75c                	sw	a5,44(a4)
    80004366:	a83d                	j	800043a4 <log_write+0xd2>
    panic("too big a transaction");
    80004368:	00004517          	auipc	a0,0x4
    8000436c:	2c850513          	addi	a0,a0,712 # 80008630 <syscalls+0x200>
    80004370:	ffffc097          	auipc	ra,0xffffc
    80004374:	260080e7          	jalr	608(ra) # 800005d0 <panic>
    panic("log_write outside of trans");
    80004378:	00004517          	auipc	a0,0x4
    8000437c:	2d050513          	addi	a0,a0,720 # 80008648 <syscalls+0x218>
    80004380:	ffffc097          	auipc	ra,0xffffc
    80004384:	250080e7          	jalr	592(ra) # 800005d0 <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004388:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    8000438a:	00878713          	addi	a4,a5,8
    8000438e:	00271693          	slli	a3,a4,0x2
    80004392:	0001e717          	auipc	a4,0x1e
    80004396:	d7670713          	addi	a4,a4,-650 # 80022108 <log>
    8000439a:	9736                	add	a4,a4,a3
    8000439c:	44d4                	lw	a3,12(s1)
    8000439e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800043a0:	faf607e3          	beq	a2,a5,8000434e <log_write+0x7c>
  }
  release(&log.lock);
    800043a4:	0001e517          	auipc	a0,0x1e
    800043a8:	d6450513          	addi	a0,a0,-668 # 80022108 <log>
    800043ac:	ffffd097          	auipc	ra,0xffffd
    800043b0:	96a080e7          	jalr	-1686(ra) # 80000d16 <release>
}
    800043b4:	60e2                	ld	ra,24(sp)
    800043b6:	6442                	ld	s0,16(sp)
    800043b8:	64a2                	ld	s1,8(sp)
    800043ba:	6902                	ld	s2,0(sp)
    800043bc:	6105                	addi	sp,sp,32
    800043be:	8082                	ret

00000000800043c0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800043c0:	1101                	addi	sp,sp,-32
    800043c2:	ec06                	sd	ra,24(sp)
    800043c4:	e822                	sd	s0,16(sp)
    800043c6:	e426                	sd	s1,8(sp)
    800043c8:	e04a                	sd	s2,0(sp)
    800043ca:	1000                	addi	s0,sp,32
    800043cc:	84aa                	mv	s1,a0
    800043ce:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800043d0:	00004597          	auipc	a1,0x4
    800043d4:	29858593          	addi	a1,a1,664 # 80008668 <syscalls+0x238>
    800043d8:	0521                	addi	a0,a0,8
    800043da:	ffffc097          	auipc	ra,0xffffc
    800043de:	7f8080e7          	jalr	2040(ra) # 80000bd2 <initlock>
  lk->name = name;
    800043e2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800043e6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043ea:	0204a423          	sw	zero,40(s1)
}
    800043ee:	60e2                	ld	ra,24(sp)
    800043f0:	6442                	ld	s0,16(sp)
    800043f2:	64a2                	ld	s1,8(sp)
    800043f4:	6902                	ld	s2,0(sp)
    800043f6:	6105                	addi	sp,sp,32
    800043f8:	8082                	ret

00000000800043fa <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800043fa:	1101                	addi	sp,sp,-32
    800043fc:	ec06                	sd	ra,24(sp)
    800043fe:	e822                	sd	s0,16(sp)
    80004400:	e426                	sd	s1,8(sp)
    80004402:	e04a                	sd	s2,0(sp)
    80004404:	1000                	addi	s0,sp,32
    80004406:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004408:	00850913          	addi	s2,a0,8
    8000440c:	854a                	mv	a0,s2
    8000440e:	ffffd097          	auipc	ra,0xffffd
    80004412:	854080e7          	jalr	-1964(ra) # 80000c62 <acquire>
  while (lk->locked) {
    80004416:	409c                	lw	a5,0(s1)
    80004418:	cb89                	beqz	a5,8000442a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000441a:	85ca                	mv	a1,s2
    8000441c:	8526                	mv	a0,s1
    8000441e:	ffffe097          	auipc	ra,0xffffe
    80004422:	e30080e7          	jalr	-464(ra) # 8000224e <sleep>
  while (lk->locked) {
    80004426:	409c                	lw	a5,0(s1)
    80004428:	fbed                	bnez	a5,8000441a <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000442a:	4785                	li	a5,1
    8000442c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000442e:	ffffd097          	auipc	ra,0xffffd
    80004432:	600080e7          	jalr	1536(ra) # 80001a2e <myproc>
    80004436:	5d1c                	lw	a5,56(a0)
    80004438:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000443a:	854a                	mv	a0,s2
    8000443c:	ffffd097          	auipc	ra,0xffffd
    80004440:	8da080e7          	jalr	-1830(ra) # 80000d16 <release>
}
    80004444:	60e2                	ld	ra,24(sp)
    80004446:	6442                	ld	s0,16(sp)
    80004448:	64a2                	ld	s1,8(sp)
    8000444a:	6902                	ld	s2,0(sp)
    8000444c:	6105                	addi	sp,sp,32
    8000444e:	8082                	ret

0000000080004450 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004450:	1101                	addi	sp,sp,-32
    80004452:	ec06                	sd	ra,24(sp)
    80004454:	e822                	sd	s0,16(sp)
    80004456:	e426                	sd	s1,8(sp)
    80004458:	e04a                	sd	s2,0(sp)
    8000445a:	1000                	addi	s0,sp,32
    8000445c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000445e:	00850913          	addi	s2,a0,8
    80004462:	854a                	mv	a0,s2
    80004464:	ffffc097          	auipc	ra,0xffffc
    80004468:	7fe080e7          	jalr	2046(ra) # 80000c62 <acquire>
  lk->locked = 0;
    8000446c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004470:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004474:	8526                	mv	a0,s1
    80004476:	ffffe097          	auipc	ra,0xffffe
    8000447a:	f58080e7          	jalr	-168(ra) # 800023ce <wakeup>
  release(&lk->lk);
    8000447e:	854a                	mv	a0,s2
    80004480:	ffffd097          	auipc	ra,0xffffd
    80004484:	896080e7          	jalr	-1898(ra) # 80000d16 <release>
}
    80004488:	60e2                	ld	ra,24(sp)
    8000448a:	6442                	ld	s0,16(sp)
    8000448c:	64a2                	ld	s1,8(sp)
    8000448e:	6902                	ld	s2,0(sp)
    80004490:	6105                	addi	sp,sp,32
    80004492:	8082                	ret

0000000080004494 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004494:	7179                	addi	sp,sp,-48
    80004496:	f406                	sd	ra,40(sp)
    80004498:	f022                	sd	s0,32(sp)
    8000449a:	ec26                	sd	s1,24(sp)
    8000449c:	e84a                	sd	s2,16(sp)
    8000449e:	e44e                	sd	s3,8(sp)
    800044a0:	1800                	addi	s0,sp,48
    800044a2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800044a4:	00850913          	addi	s2,a0,8
    800044a8:	854a                	mv	a0,s2
    800044aa:	ffffc097          	auipc	ra,0xffffc
    800044ae:	7b8080e7          	jalr	1976(ra) # 80000c62 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800044b2:	409c                	lw	a5,0(s1)
    800044b4:	ef99                	bnez	a5,800044d2 <holdingsleep+0x3e>
    800044b6:	4481                	li	s1,0
  release(&lk->lk);
    800044b8:	854a                	mv	a0,s2
    800044ba:	ffffd097          	auipc	ra,0xffffd
    800044be:	85c080e7          	jalr	-1956(ra) # 80000d16 <release>
  return r;
}
    800044c2:	8526                	mv	a0,s1
    800044c4:	70a2                	ld	ra,40(sp)
    800044c6:	7402                	ld	s0,32(sp)
    800044c8:	64e2                	ld	s1,24(sp)
    800044ca:	6942                	ld	s2,16(sp)
    800044cc:	69a2                	ld	s3,8(sp)
    800044ce:	6145                	addi	sp,sp,48
    800044d0:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800044d2:	0284a983          	lw	s3,40(s1)
    800044d6:	ffffd097          	auipc	ra,0xffffd
    800044da:	558080e7          	jalr	1368(ra) # 80001a2e <myproc>
    800044de:	5d04                	lw	s1,56(a0)
    800044e0:	413484b3          	sub	s1,s1,s3
    800044e4:	0014b493          	seqz	s1,s1
    800044e8:	bfc1                	j	800044b8 <holdingsleep+0x24>

00000000800044ea <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800044ea:	1141                	addi	sp,sp,-16
    800044ec:	e406                	sd	ra,8(sp)
    800044ee:	e022                	sd	s0,0(sp)
    800044f0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800044f2:	00004597          	auipc	a1,0x4
    800044f6:	18658593          	addi	a1,a1,390 # 80008678 <syscalls+0x248>
    800044fa:	0001e517          	auipc	a0,0x1e
    800044fe:	d5650513          	addi	a0,a0,-682 # 80022250 <ftable>
    80004502:	ffffc097          	auipc	ra,0xffffc
    80004506:	6d0080e7          	jalr	1744(ra) # 80000bd2 <initlock>
}
    8000450a:	60a2                	ld	ra,8(sp)
    8000450c:	6402                	ld	s0,0(sp)
    8000450e:	0141                	addi	sp,sp,16
    80004510:	8082                	ret

0000000080004512 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004512:	1101                	addi	sp,sp,-32
    80004514:	ec06                	sd	ra,24(sp)
    80004516:	e822                	sd	s0,16(sp)
    80004518:	e426                	sd	s1,8(sp)
    8000451a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000451c:	0001e517          	auipc	a0,0x1e
    80004520:	d3450513          	addi	a0,a0,-716 # 80022250 <ftable>
    80004524:	ffffc097          	auipc	ra,0xffffc
    80004528:	73e080e7          	jalr	1854(ra) # 80000c62 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000452c:	0001e497          	auipc	s1,0x1e
    80004530:	d3c48493          	addi	s1,s1,-708 # 80022268 <ftable+0x18>
    80004534:	0001f717          	auipc	a4,0x1f
    80004538:	cd470713          	addi	a4,a4,-812 # 80023208 <ftable+0xfb8>
    if(f->ref == 0){
    8000453c:	40dc                	lw	a5,4(s1)
    8000453e:	cf99                	beqz	a5,8000455c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004540:	02848493          	addi	s1,s1,40
    80004544:	fee49ce3          	bne	s1,a4,8000453c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004548:	0001e517          	auipc	a0,0x1e
    8000454c:	d0850513          	addi	a0,a0,-760 # 80022250 <ftable>
    80004550:	ffffc097          	auipc	ra,0xffffc
    80004554:	7c6080e7          	jalr	1990(ra) # 80000d16 <release>
  return 0;
    80004558:	4481                	li	s1,0
    8000455a:	a819                	j	80004570 <filealloc+0x5e>
      f->ref = 1;
    8000455c:	4785                	li	a5,1
    8000455e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004560:	0001e517          	auipc	a0,0x1e
    80004564:	cf050513          	addi	a0,a0,-784 # 80022250 <ftable>
    80004568:	ffffc097          	auipc	ra,0xffffc
    8000456c:	7ae080e7          	jalr	1966(ra) # 80000d16 <release>
}
    80004570:	8526                	mv	a0,s1
    80004572:	60e2                	ld	ra,24(sp)
    80004574:	6442                	ld	s0,16(sp)
    80004576:	64a2                	ld	s1,8(sp)
    80004578:	6105                	addi	sp,sp,32
    8000457a:	8082                	ret

000000008000457c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000457c:	1101                	addi	sp,sp,-32
    8000457e:	ec06                	sd	ra,24(sp)
    80004580:	e822                	sd	s0,16(sp)
    80004582:	e426                	sd	s1,8(sp)
    80004584:	1000                	addi	s0,sp,32
    80004586:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004588:	0001e517          	auipc	a0,0x1e
    8000458c:	cc850513          	addi	a0,a0,-824 # 80022250 <ftable>
    80004590:	ffffc097          	auipc	ra,0xffffc
    80004594:	6d2080e7          	jalr	1746(ra) # 80000c62 <acquire>
  if(f->ref < 1)
    80004598:	40dc                	lw	a5,4(s1)
    8000459a:	02f05263          	blez	a5,800045be <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000459e:	2785                	addiw	a5,a5,1
    800045a0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800045a2:	0001e517          	auipc	a0,0x1e
    800045a6:	cae50513          	addi	a0,a0,-850 # 80022250 <ftable>
    800045aa:	ffffc097          	auipc	ra,0xffffc
    800045ae:	76c080e7          	jalr	1900(ra) # 80000d16 <release>
  return f;
}
    800045b2:	8526                	mv	a0,s1
    800045b4:	60e2                	ld	ra,24(sp)
    800045b6:	6442                	ld	s0,16(sp)
    800045b8:	64a2                	ld	s1,8(sp)
    800045ba:	6105                	addi	sp,sp,32
    800045bc:	8082                	ret
    panic("filedup");
    800045be:	00004517          	auipc	a0,0x4
    800045c2:	0c250513          	addi	a0,a0,194 # 80008680 <syscalls+0x250>
    800045c6:	ffffc097          	auipc	ra,0xffffc
    800045ca:	00a080e7          	jalr	10(ra) # 800005d0 <panic>

00000000800045ce <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800045ce:	7139                	addi	sp,sp,-64
    800045d0:	fc06                	sd	ra,56(sp)
    800045d2:	f822                	sd	s0,48(sp)
    800045d4:	f426                	sd	s1,40(sp)
    800045d6:	f04a                	sd	s2,32(sp)
    800045d8:	ec4e                	sd	s3,24(sp)
    800045da:	e852                	sd	s4,16(sp)
    800045dc:	e456                	sd	s5,8(sp)
    800045de:	0080                	addi	s0,sp,64
    800045e0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800045e2:	0001e517          	auipc	a0,0x1e
    800045e6:	c6e50513          	addi	a0,a0,-914 # 80022250 <ftable>
    800045ea:	ffffc097          	auipc	ra,0xffffc
    800045ee:	678080e7          	jalr	1656(ra) # 80000c62 <acquire>
  if(f->ref < 1)
    800045f2:	40dc                	lw	a5,4(s1)
    800045f4:	06f05163          	blez	a5,80004656 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800045f8:	37fd                	addiw	a5,a5,-1
    800045fa:	0007871b          	sext.w	a4,a5
    800045fe:	c0dc                	sw	a5,4(s1)
    80004600:	06e04363          	bgtz	a4,80004666 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004604:	0004a903          	lw	s2,0(s1)
    80004608:	0094ca83          	lbu	s5,9(s1)
    8000460c:	0104ba03          	ld	s4,16(s1)
    80004610:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004614:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004618:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000461c:	0001e517          	auipc	a0,0x1e
    80004620:	c3450513          	addi	a0,a0,-972 # 80022250 <ftable>
    80004624:	ffffc097          	auipc	ra,0xffffc
    80004628:	6f2080e7          	jalr	1778(ra) # 80000d16 <release>

  if(ff.type == FD_PIPE){
    8000462c:	4785                	li	a5,1
    8000462e:	04f90d63          	beq	s2,a5,80004688 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004632:	3979                	addiw	s2,s2,-2
    80004634:	4785                	li	a5,1
    80004636:	0527e063          	bltu	a5,s2,80004676 <fileclose+0xa8>
    begin_op();
    8000463a:	00000097          	auipc	ra,0x0
    8000463e:	ac2080e7          	jalr	-1342(ra) # 800040fc <begin_op>
    iput(ff.ip);
    80004642:	854e                	mv	a0,s3
    80004644:	fffff097          	auipc	ra,0xfffff
    80004648:	2b6080e7          	jalr	694(ra) # 800038fa <iput>
    end_op();
    8000464c:	00000097          	auipc	ra,0x0
    80004650:	b30080e7          	jalr	-1232(ra) # 8000417c <end_op>
    80004654:	a00d                	j	80004676 <fileclose+0xa8>
    panic("fileclose");
    80004656:	00004517          	auipc	a0,0x4
    8000465a:	03250513          	addi	a0,a0,50 # 80008688 <syscalls+0x258>
    8000465e:	ffffc097          	auipc	ra,0xffffc
    80004662:	f72080e7          	jalr	-142(ra) # 800005d0 <panic>
    release(&ftable.lock);
    80004666:	0001e517          	auipc	a0,0x1e
    8000466a:	bea50513          	addi	a0,a0,-1046 # 80022250 <ftable>
    8000466e:	ffffc097          	auipc	ra,0xffffc
    80004672:	6a8080e7          	jalr	1704(ra) # 80000d16 <release>
  }
}
    80004676:	70e2                	ld	ra,56(sp)
    80004678:	7442                	ld	s0,48(sp)
    8000467a:	74a2                	ld	s1,40(sp)
    8000467c:	7902                	ld	s2,32(sp)
    8000467e:	69e2                	ld	s3,24(sp)
    80004680:	6a42                	ld	s4,16(sp)
    80004682:	6aa2                	ld	s5,8(sp)
    80004684:	6121                	addi	sp,sp,64
    80004686:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004688:	85d6                	mv	a1,s5
    8000468a:	8552                	mv	a0,s4
    8000468c:	00000097          	auipc	ra,0x0
    80004690:	372080e7          	jalr	882(ra) # 800049fe <pipeclose>
    80004694:	b7cd                	j	80004676 <fileclose+0xa8>

0000000080004696 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004696:	715d                	addi	sp,sp,-80
    80004698:	e486                	sd	ra,72(sp)
    8000469a:	e0a2                	sd	s0,64(sp)
    8000469c:	fc26                	sd	s1,56(sp)
    8000469e:	f84a                	sd	s2,48(sp)
    800046a0:	f44e                	sd	s3,40(sp)
    800046a2:	0880                	addi	s0,sp,80
    800046a4:	84aa                	mv	s1,a0
    800046a6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800046a8:	ffffd097          	auipc	ra,0xffffd
    800046ac:	386080e7          	jalr	902(ra) # 80001a2e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800046b0:	409c                	lw	a5,0(s1)
    800046b2:	37f9                	addiw	a5,a5,-2
    800046b4:	4705                	li	a4,1
    800046b6:	04f76763          	bltu	a4,a5,80004704 <filestat+0x6e>
    800046ba:	892a                	mv	s2,a0
    ilock(f->ip);
    800046bc:	6c88                	ld	a0,24(s1)
    800046be:	fffff097          	auipc	ra,0xfffff
    800046c2:	082080e7          	jalr	130(ra) # 80003740 <ilock>
    stati(f->ip, &st);
    800046c6:	fb840593          	addi	a1,s0,-72
    800046ca:	6c88                	ld	a0,24(s1)
    800046cc:	fffff097          	auipc	ra,0xfffff
    800046d0:	2fe080e7          	jalr	766(ra) # 800039ca <stati>
    iunlock(f->ip);
    800046d4:	6c88                	ld	a0,24(s1)
    800046d6:	fffff097          	auipc	ra,0xfffff
    800046da:	12c080e7          	jalr	300(ra) # 80003802 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800046de:	46e1                	li	a3,24
    800046e0:	fb840613          	addi	a2,s0,-72
    800046e4:	85ce                	mv	a1,s3
    800046e6:	05093503          	ld	a0,80(s2)
    800046ea:	ffffd097          	auipc	ra,0xffffd
    800046ee:	036080e7          	jalr	54(ra) # 80001720 <copyout>
    800046f2:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800046f6:	60a6                	ld	ra,72(sp)
    800046f8:	6406                	ld	s0,64(sp)
    800046fa:	74e2                	ld	s1,56(sp)
    800046fc:	7942                	ld	s2,48(sp)
    800046fe:	79a2                	ld	s3,40(sp)
    80004700:	6161                	addi	sp,sp,80
    80004702:	8082                	ret
  return -1;
    80004704:	557d                	li	a0,-1
    80004706:	bfc5                	j	800046f6 <filestat+0x60>

0000000080004708 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004708:	7179                	addi	sp,sp,-48
    8000470a:	f406                	sd	ra,40(sp)
    8000470c:	f022                	sd	s0,32(sp)
    8000470e:	ec26                	sd	s1,24(sp)
    80004710:	e84a                	sd	s2,16(sp)
    80004712:	e44e                	sd	s3,8(sp)
    80004714:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004716:	00854783          	lbu	a5,8(a0)
    8000471a:	c3d5                	beqz	a5,800047be <fileread+0xb6>
    8000471c:	84aa                	mv	s1,a0
    8000471e:	89ae                	mv	s3,a1
    80004720:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004722:	411c                	lw	a5,0(a0)
    80004724:	4705                	li	a4,1
    80004726:	04e78963          	beq	a5,a4,80004778 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000472a:	470d                	li	a4,3
    8000472c:	04e78d63          	beq	a5,a4,80004786 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004730:	4709                	li	a4,2
    80004732:	06e79e63          	bne	a5,a4,800047ae <fileread+0xa6>
    ilock(f->ip);
    80004736:	6d08                	ld	a0,24(a0)
    80004738:	fffff097          	auipc	ra,0xfffff
    8000473c:	008080e7          	jalr	8(ra) # 80003740 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004740:	874a                	mv	a4,s2
    80004742:	5094                	lw	a3,32(s1)
    80004744:	864e                	mv	a2,s3
    80004746:	4585                	li	a1,1
    80004748:	6c88                	ld	a0,24(s1)
    8000474a:	fffff097          	auipc	ra,0xfffff
    8000474e:	2aa080e7          	jalr	682(ra) # 800039f4 <readi>
    80004752:	892a                	mv	s2,a0
    80004754:	00a05563          	blez	a0,8000475e <fileread+0x56>
      f->off += r;
    80004758:	509c                	lw	a5,32(s1)
    8000475a:	9fa9                	addw	a5,a5,a0
    8000475c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000475e:	6c88                	ld	a0,24(s1)
    80004760:	fffff097          	auipc	ra,0xfffff
    80004764:	0a2080e7          	jalr	162(ra) # 80003802 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004768:	854a                	mv	a0,s2
    8000476a:	70a2                	ld	ra,40(sp)
    8000476c:	7402                	ld	s0,32(sp)
    8000476e:	64e2                	ld	s1,24(sp)
    80004770:	6942                	ld	s2,16(sp)
    80004772:	69a2                	ld	s3,8(sp)
    80004774:	6145                	addi	sp,sp,48
    80004776:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004778:	6908                	ld	a0,16(a0)
    8000477a:	00000097          	auipc	ra,0x0
    8000477e:	3f4080e7          	jalr	1012(ra) # 80004b6e <piperead>
    80004782:	892a                	mv	s2,a0
    80004784:	b7d5                	j	80004768 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004786:	02451783          	lh	a5,36(a0)
    8000478a:	03079693          	slli	a3,a5,0x30
    8000478e:	92c1                	srli	a3,a3,0x30
    80004790:	4725                	li	a4,9
    80004792:	02d76863          	bltu	a4,a3,800047c2 <fileread+0xba>
    80004796:	0792                	slli	a5,a5,0x4
    80004798:	0001e717          	auipc	a4,0x1e
    8000479c:	a1870713          	addi	a4,a4,-1512 # 800221b0 <devsw>
    800047a0:	97ba                	add	a5,a5,a4
    800047a2:	639c                	ld	a5,0(a5)
    800047a4:	c38d                	beqz	a5,800047c6 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800047a6:	4505                	li	a0,1
    800047a8:	9782                	jalr	a5
    800047aa:	892a                	mv	s2,a0
    800047ac:	bf75                	j	80004768 <fileread+0x60>
    panic("fileread");
    800047ae:	00004517          	auipc	a0,0x4
    800047b2:	eea50513          	addi	a0,a0,-278 # 80008698 <syscalls+0x268>
    800047b6:	ffffc097          	auipc	ra,0xffffc
    800047ba:	e1a080e7          	jalr	-486(ra) # 800005d0 <panic>
    return -1;
    800047be:	597d                	li	s2,-1
    800047c0:	b765                	j	80004768 <fileread+0x60>
      return -1;
    800047c2:	597d                	li	s2,-1
    800047c4:	b755                	j	80004768 <fileread+0x60>
    800047c6:	597d                	li	s2,-1
    800047c8:	b745                	j	80004768 <fileread+0x60>

00000000800047ca <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800047ca:	00954783          	lbu	a5,9(a0)
    800047ce:	14078563          	beqz	a5,80004918 <filewrite+0x14e>
{
    800047d2:	715d                	addi	sp,sp,-80
    800047d4:	e486                	sd	ra,72(sp)
    800047d6:	e0a2                	sd	s0,64(sp)
    800047d8:	fc26                	sd	s1,56(sp)
    800047da:	f84a                	sd	s2,48(sp)
    800047dc:	f44e                	sd	s3,40(sp)
    800047de:	f052                	sd	s4,32(sp)
    800047e0:	ec56                	sd	s5,24(sp)
    800047e2:	e85a                	sd	s6,16(sp)
    800047e4:	e45e                	sd	s7,8(sp)
    800047e6:	e062                	sd	s8,0(sp)
    800047e8:	0880                	addi	s0,sp,80
    800047ea:	892a                	mv	s2,a0
    800047ec:	8aae                	mv	s5,a1
    800047ee:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800047f0:	411c                	lw	a5,0(a0)
    800047f2:	4705                	li	a4,1
    800047f4:	02e78263          	beq	a5,a4,80004818 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047f8:	470d                	li	a4,3
    800047fa:	02e78563          	beq	a5,a4,80004824 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800047fe:	4709                	li	a4,2
    80004800:	10e79463          	bne	a5,a4,80004908 <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004804:	0ec05e63          	blez	a2,80004900 <filewrite+0x136>
    int i = 0;
    80004808:	4981                	li	s3,0
    8000480a:	6b05                	lui	s6,0x1
    8000480c:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004810:	6b85                	lui	s7,0x1
    80004812:	c00b8b9b          	addiw	s7,s7,-1024
    80004816:	a851                	j	800048aa <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004818:	6908                	ld	a0,16(a0)
    8000481a:	00000097          	auipc	ra,0x0
    8000481e:	254080e7          	jalr	596(ra) # 80004a6e <pipewrite>
    80004822:	a85d                	j	800048d8 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004824:	02451783          	lh	a5,36(a0)
    80004828:	03079693          	slli	a3,a5,0x30
    8000482c:	92c1                	srli	a3,a3,0x30
    8000482e:	4725                	li	a4,9
    80004830:	0ed76663          	bltu	a4,a3,8000491c <filewrite+0x152>
    80004834:	0792                	slli	a5,a5,0x4
    80004836:	0001e717          	auipc	a4,0x1e
    8000483a:	97a70713          	addi	a4,a4,-1670 # 800221b0 <devsw>
    8000483e:	97ba                	add	a5,a5,a4
    80004840:	679c                	ld	a5,8(a5)
    80004842:	cff9                	beqz	a5,80004920 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004844:	4505                	li	a0,1
    80004846:	9782                	jalr	a5
    80004848:	a841                	j	800048d8 <filewrite+0x10e>
    8000484a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000484e:	00000097          	auipc	ra,0x0
    80004852:	8ae080e7          	jalr	-1874(ra) # 800040fc <begin_op>
      ilock(f->ip);
    80004856:	01893503          	ld	a0,24(s2)
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	ee6080e7          	jalr	-282(ra) # 80003740 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004862:	8762                	mv	a4,s8
    80004864:	02092683          	lw	a3,32(s2)
    80004868:	01598633          	add	a2,s3,s5
    8000486c:	4585                	li	a1,1
    8000486e:	01893503          	ld	a0,24(s2)
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	278080e7          	jalr	632(ra) # 80003aea <writei>
    8000487a:	84aa                	mv	s1,a0
    8000487c:	02a05f63          	blez	a0,800048ba <filewrite+0xf0>
        f->off += r;
    80004880:	02092783          	lw	a5,32(s2)
    80004884:	9fa9                	addw	a5,a5,a0
    80004886:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000488a:	01893503          	ld	a0,24(s2)
    8000488e:	fffff097          	auipc	ra,0xfffff
    80004892:	f74080e7          	jalr	-140(ra) # 80003802 <iunlock>
      end_op();
    80004896:	00000097          	auipc	ra,0x0
    8000489a:	8e6080e7          	jalr	-1818(ra) # 8000417c <end_op>

      if(r < 0)
        break;
      if(r != n1)
    8000489e:	049c1963          	bne	s8,s1,800048f0 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    800048a2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800048a6:	0349d663          	bge	s3,s4,800048d2 <filewrite+0x108>
      int n1 = n - i;
    800048aa:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800048ae:	84be                	mv	s1,a5
    800048b0:	2781                	sext.w	a5,a5
    800048b2:	f8fb5ce3          	bge	s6,a5,8000484a <filewrite+0x80>
    800048b6:	84de                	mv	s1,s7
    800048b8:	bf49                	j	8000484a <filewrite+0x80>
      iunlock(f->ip);
    800048ba:	01893503          	ld	a0,24(s2)
    800048be:	fffff097          	auipc	ra,0xfffff
    800048c2:	f44080e7          	jalr	-188(ra) # 80003802 <iunlock>
      end_op();
    800048c6:	00000097          	auipc	ra,0x0
    800048ca:	8b6080e7          	jalr	-1866(ra) # 8000417c <end_op>
      if(r < 0)
    800048ce:	fc04d8e3          	bgez	s1,8000489e <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    800048d2:	8552                	mv	a0,s4
    800048d4:	033a1863          	bne	s4,s3,80004904 <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800048d8:	60a6                	ld	ra,72(sp)
    800048da:	6406                	ld	s0,64(sp)
    800048dc:	74e2                	ld	s1,56(sp)
    800048de:	7942                	ld	s2,48(sp)
    800048e0:	79a2                	ld	s3,40(sp)
    800048e2:	7a02                	ld	s4,32(sp)
    800048e4:	6ae2                	ld	s5,24(sp)
    800048e6:	6b42                	ld	s6,16(sp)
    800048e8:	6ba2                	ld	s7,8(sp)
    800048ea:	6c02                	ld	s8,0(sp)
    800048ec:	6161                	addi	sp,sp,80
    800048ee:	8082                	ret
        panic("short filewrite");
    800048f0:	00004517          	auipc	a0,0x4
    800048f4:	db850513          	addi	a0,a0,-584 # 800086a8 <syscalls+0x278>
    800048f8:	ffffc097          	auipc	ra,0xffffc
    800048fc:	cd8080e7          	jalr	-808(ra) # 800005d0 <panic>
    int i = 0;
    80004900:	4981                	li	s3,0
    80004902:	bfc1                	j	800048d2 <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004904:	557d                	li	a0,-1
    80004906:	bfc9                	j	800048d8 <filewrite+0x10e>
    panic("filewrite");
    80004908:	00004517          	auipc	a0,0x4
    8000490c:	db050513          	addi	a0,a0,-592 # 800086b8 <syscalls+0x288>
    80004910:	ffffc097          	auipc	ra,0xffffc
    80004914:	cc0080e7          	jalr	-832(ra) # 800005d0 <panic>
    return -1;
    80004918:	557d                	li	a0,-1
}
    8000491a:	8082                	ret
      return -1;
    8000491c:	557d                	li	a0,-1
    8000491e:	bf6d                	j	800048d8 <filewrite+0x10e>
    80004920:	557d                	li	a0,-1
    80004922:	bf5d                	j	800048d8 <filewrite+0x10e>

0000000080004924 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004924:	7179                	addi	sp,sp,-48
    80004926:	f406                	sd	ra,40(sp)
    80004928:	f022                	sd	s0,32(sp)
    8000492a:	ec26                	sd	s1,24(sp)
    8000492c:	e84a                	sd	s2,16(sp)
    8000492e:	e44e                	sd	s3,8(sp)
    80004930:	e052                	sd	s4,0(sp)
    80004932:	1800                	addi	s0,sp,48
    80004934:	84aa                	mv	s1,a0
    80004936:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004938:	0005b023          	sd	zero,0(a1)
    8000493c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004940:	00000097          	auipc	ra,0x0
    80004944:	bd2080e7          	jalr	-1070(ra) # 80004512 <filealloc>
    80004948:	e088                	sd	a0,0(s1)
    8000494a:	c551                	beqz	a0,800049d6 <pipealloc+0xb2>
    8000494c:	00000097          	auipc	ra,0x0
    80004950:	bc6080e7          	jalr	-1082(ra) # 80004512 <filealloc>
    80004954:	00aa3023          	sd	a0,0(s4)
    80004958:	c92d                	beqz	a0,800049ca <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000495a:	ffffc097          	auipc	ra,0xffffc
    8000495e:	218080e7          	jalr	536(ra) # 80000b72 <kalloc>
    80004962:	892a                	mv	s2,a0
    80004964:	c125                	beqz	a0,800049c4 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004966:	4985                	li	s3,1
    80004968:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000496c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004970:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004974:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004978:	00004597          	auipc	a1,0x4
    8000497c:	d5058593          	addi	a1,a1,-688 # 800086c8 <syscalls+0x298>
    80004980:	ffffc097          	auipc	ra,0xffffc
    80004984:	252080e7          	jalr	594(ra) # 80000bd2 <initlock>
  (*f0)->type = FD_PIPE;
    80004988:	609c                	ld	a5,0(s1)
    8000498a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000498e:	609c                	ld	a5,0(s1)
    80004990:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004994:	609c                	ld	a5,0(s1)
    80004996:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000499a:	609c                	ld	a5,0(s1)
    8000499c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800049a0:	000a3783          	ld	a5,0(s4)
    800049a4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800049a8:	000a3783          	ld	a5,0(s4)
    800049ac:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800049b0:	000a3783          	ld	a5,0(s4)
    800049b4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800049b8:	000a3783          	ld	a5,0(s4)
    800049bc:	0127b823          	sd	s2,16(a5)
  return 0;
    800049c0:	4501                	li	a0,0
    800049c2:	a025                	j	800049ea <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800049c4:	6088                	ld	a0,0(s1)
    800049c6:	e501                	bnez	a0,800049ce <pipealloc+0xaa>
    800049c8:	a039                	j	800049d6 <pipealloc+0xb2>
    800049ca:	6088                	ld	a0,0(s1)
    800049cc:	c51d                	beqz	a0,800049fa <pipealloc+0xd6>
    fileclose(*f0);
    800049ce:	00000097          	auipc	ra,0x0
    800049d2:	c00080e7          	jalr	-1024(ra) # 800045ce <fileclose>
  if(*f1)
    800049d6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800049da:	557d                	li	a0,-1
  if(*f1)
    800049dc:	c799                	beqz	a5,800049ea <pipealloc+0xc6>
    fileclose(*f1);
    800049de:	853e                	mv	a0,a5
    800049e0:	00000097          	auipc	ra,0x0
    800049e4:	bee080e7          	jalr	-1042(ra) # 800045ce <fileclose>
  return -1;
    800049e8:	557d                	li	a0,-1
}
    800049ea:	70a2                	ld	ra,40(sp)
    800049ec:	7402                	ld	s0,32(sp)
    800049ee:	64e2                	ld	s1,24(sp)
    800049f0:	6942                	ld	s2,16(sp)
    800049f2:	69a2                	ld	s3,8(sp)
    800049f4:	6a02                	ld	s4,0(sp)
    800049f6:	6145                	addi	sp,sp,48
    800049f8:	8082                	ret
  return -1;
    800049fa:	557d                	li	a0,-1
    800049fc:	b7fd                	j	800049ea <pipealloc+0xc6>

00000000800049fe <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800049fe:	1101                	addi	sp,sp,-32
    80004a00:	ec06                	sd	ra,24(sp)
    80004a02:	e822                	sd	s0,16(sp)
    80004a04:	e426                	sd	s1,8(sp)
    80004a06:	e04a                	sd	s2,0(sp)
    80004a08:	1000                	addi	s0,sp,32
    80004a0a:	84aa                	mv	s1,a0
    80004a0c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004a0e:	ffffc097          	auipc	ra,0xffffc
    80004a12:	254080e7          	jalr	596(ra) # 80000c62 <acquire>
  if(writable){
    80004a16:	02090d63          	beqz	s2,80004a50 <pipeclose+0x52>
    pi->writeopen = 0;
    80004a1a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a1e:	21848513          	addi	a0,s1,536
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	9ac080e7          	jalr	-1620(ra) # 800023ce <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a2a:	2204b783          	ld	a5,544(s1)
    80004a2e:	eb95                	bnez	a5,80004a62 <pipeclose+0x64>
    release(&pi->lock);
    80004a30:	8526                	mv	a0,s1
    80004a32:	ffffc097          	auipc	ra,0xffffc
    80004a36:	2e4080e7          	jalr	740(ra) # 80000d16 <release>
    kfree((char*)pi);
    80004a3a:	8526                	mv	a0,s1
    80004a3c:	ffffc097          	auipc	ra,0xffffc
    80004a40:	03a080e7          	jalr	58(ra) # 80000a76 <kfree>
  } else
    release(&pi->lock);
}
    80004a44:	60e2                	ld	ra,24(sp)
    80004a46:	6442                	ld	s0,16(sp)
    80004a48:	64a2                	ld	s1,8(sp)
    80004a4a:	6902                	ld	s2,0(sp)
    80004a4c:	6105                	addi	sp,sp,32
    80004a4e:	8082                	ret
    pi->readopen = 0;
    80004a50:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a54:	21c48513          	addi	a0,s1,540
    80004a58:	ffffe097          	auipc	ra,0xffffe
    80004a5c:	976080e7          	jalr	-1674(ra) # 800023ce <wakeup>
    80004a60:	b7e9                	j	80004a2a <pipeclose+0x2c>
    release(&pi->lock);
    80004a62:	8526                	mv	a0,s1
    80004a64:	ffffc097          	auipc	ra,0xffffc
    80004a68:	2b2080e7          	jalr	690(ra) # 80000d16 <release>
}
    80004a6c:	bfe1                	j	80004a44 <pipeclose+0x46>

0000000080004a6e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a6e:	711d                	addi	sp,sp,-96
    80004a70:	ec86                	sd	ra,88(sp)
    80004a72:	e8a2                	sd	s0,80(sp)
    80004a74:	e4a6                	sd	s1,72(sp)
    80004a76:	e0ca                	sd	s2,64(sp)
    80004a78:	fc4e                	sd	s3,56(sp)
    80004a7a:	f852                	sd	s4,48(sp)
    80004a7c:	f456                	sd	s5,40(sp)
    80004a7e:	f05a                	sd	s6,32(sp)
    80004a80:	ec5e                	sd	s7,24(sp)
    80004a82:	e862                	sd	s8,16(sp)
    80004a84:	1080                	addi	s0,sp,96
    80004a86:	84aa                	mv	s1,a0
    80004a88:	8b2e                	mv	s6,a1
    80004a8a:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004a8c:	ffffd097          	auipc	ra,0xffffd
    80004a90:	fa2080e7          	jalr	-94(ra) # 80001a2e <myproc>
    80004a94:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004a96:	8526                	mv	a0,s1
    80004a98:	ffffc097          	auipc	ra,0xffffc
    80004a9c:	1ca080e7          	jalr	458(ra) # 80000c62 <acquire>
  for(i = 0; i < n; i++){
    80004aa0:	09505763          	blez	s5,80004b2e <pipewrite+0xc0>
    80004aa4:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004aa6:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004aaa:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004aae:	5c7d                	li	s8,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004ab0:	2184a783          	lw	a5,536(s1)
    80004ab4:	21c4a703          	lw	a4,540(s1)
    80004ab8:	2007879b          	addiw	a5,a5,512
    80004abc:	02f71b63          	bne	a4,a5,80004af2 <pipewrite+0x84>
      if(pi->readopen == 0 || pr->killed){
    80004ac0:	2204a783          	lw	a5,544(s1)
    80004ac4:	c3d1                	beqz	a5,80004b48 <pipewrite+0xda>
    80004ac6:	03092783          	lw	a5,48(s2)
    80004aca:	efbd                	bnez	a5,80004b48 <pipewrite+0xda>
      wakeup(&pi->nread);
    80004acc:	8552                	mv	a0,s4
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	900080e7          	jalr	-1792(ra) # 800023ce <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004ad6:	85a6                	mv	a1,s1
    80004ad8:	854e                	mv	a0,s3
    80004ada:	ffffd097          	auipc	ra,0xffffd
    80004ade:	774080e7          	jalr	1908(ra) # 8000224e <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004ae2:	2184a783          	lw	a5,536(s1)
    80004ae6:	21c4a703          	lw	a4,540(s1)
    80004aea:	2007879b          	addiw	a5,a5,512
    80004aee:	fcf709e3          	beq	a4,a5,80004ac0 <pipewrite+0x52>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004af2:	4685                	li	a3,1
    80004af4:	865a                	mv	a2,s6
    80004af6:	faf40593          	addi	a1,s0,-81
    80004afa:	05093503          	ld	a0,80(s2)
    80004afe:	ffffd097          	auipc	ra,0xffffd
    80004b02:	cae080e7          	jalr	-850(ra) # 800017ac <copyin>
    80004b06:	03850563          	beq	a0,s8,80004b30 <pipewrite+0xc2>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b0a:	21c4a783          	lw	a5,540(s1)
    80004b0e:	0017871b          	addiw	a4,a5,1
    80004b12:	20e4ae23          	sw	a4,540(s1)
    80004b16:	1ff7f793          	andi	a5,a5,511
    80004b1a:	97a6                	add	a5,a5,s1
    80004b1c:	faf44703          	lbu	a4,-81(s0)
    80004b20:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004b24:	2b85                	addiw	s7,s7,1
    80004b26:	0b05                	addi	s6,s6,1
    80004b28:	f97a94e3          	bne	s5,s7,80004ab0 <pipewrite+0x42>
    80004b2c:	a011                	j	80004b30 <pipewrite+0xc2>
    80004b2e:	4b81                	li	s7,0
  }
  wakeup(&pi->nread);
    80004b30:	21848513          	addi	a0,s1,536
    80004b34:	ffffe097          	auipc	ra,0xffffe
    80004b38:	89a080e7          	jalr	-1894(ra) # 800023ce <wakeup>
  release(&pi->lock);
    80004b3c:	8526                	mv	a0,s1
    80004b3e:	ffffc097          	auipc	ra,0xffffc
    80004b42:	1d8080e7          	jalr	472(ra) # 80000d16 <release>
  return i;
    80004b46:	a039                	j	80004b54 <pipewrite+0xe6>
        release(&pi->lock);
    80004b48:	8526                	mv	a0,s1
    80004b4a:	ffffc097          	auipc	ra,0xffffc
    80004b4e:	1cc080e7          	jalr	460(ra) # 80000d16 <release>
        return -1;
    80004b52:	5bfd                	li	s7,-1
}
    80004b54:	855e                	mv	a0,s7
    80004b56:	60e6                	ld	ra,88(sp)
    80004b58:	6446                	ld	s0,80(sp)
    80004b5a:	64a6                	ld	s1,72(sp)
    80004b5c:	6906                	ld	s2,64(sp)
    80004b5e:	79e2                	ld	s3,56(sp)
    80004b60:	7a42                	ld	s4,48(sp)
    80004b62:	7aa2                	ld	s5,40(sp)
    80004b64:	7b02                	ld	s6,32(sp)
    80004b66:	6be2                	ld	s7,24(sp)
    80004b68:	6c42                	ld	s8,16(sp)
    80004b6a:	6125                	addi	sp,sp,96
    80004b6c:	8082                	ret

0000000080004b6e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b6e:	715d                	addi	sp,sp,-80
    80004b70:	e486                	sd	ra,72(sp)
    80004b72:	e0a2                	sd	s0,64(sp)
    80004b74:	fc26                	sd	s1,56(sp)
    80004b76:	f84a                	sd	s2,48(sp)
    80004b78:	f44e                	sd	s3,40(sp)
    80004b7a:	f052                	sd	s4,32(sp)
    80004b7c:	ec56                	sd	s5,24(sp)
    80004b7e:	e85a                	sd	s6,16(sp)
    80004b80:	0880                	addi	s0,sp,80
    80004b82:	84aa                	mv	s1,a0
    80004b84:	892e                	mv	s2,a1
    80004b86:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004b88:	ffffd097          	auipc	ra,0xffffd
    80004b8c:	ea6080e7          	jalr	-346(ra) # 80001a2e <myproc>
    80004b90:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004b92:	8526                	mv	a0,s1
    80004b94:	ffffc097          	auipc	ra,0xffffc
    80004b98:	0ce080e7          	jalr	206(ra) # 80000c62 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b9c:	2184a703          	lw	a4,536(s1)
    80004ba0:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004ba4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ba8:	02f71463          	bne	a4,a5,80004bd0 <piperead+0x62>
    80004bac:	2244a783          	lw	a5,548(s1)
    80004bb0:	c385                	beqz	a5,80004bd0 <piperead+0x62>
    if(pr->killed){
    80004bb2:	030a2783          	lw	a5,48(s4)
    80004bb6:	ebc1                	bnez	a5,80004c46 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004bb8:	85a6                	mv	a1,s1
    80004bba:	854e                	mv	a0,s3
    80004bbc:	ffffd097          	auipc	ra,0xffffd
    80004bc0:	692080e7          	jalr	1682(ra) # 8000224e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004bc4:	2184a703          	lw	a4,536(s1)
    80004bc8:	21c4a783          	lw	a5,540(s1)
    80004bcc:	fef700e3          	beq	a4,a5,80004bac <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bd0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bd2:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bd4:	05505363          	blez	s5,80004c1a <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004bd8:	2184a783          	lw	a5,536(s1)
    80004bdc:	21c4a703          	lw	a4,540(s1)
    80004be0:	02f70d63          	beq	a4,a5,80004c1a <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004be4:	0017871b          	addiw	a4,a5,1
    80004be8:	20e4ac23          	sw	a4,536(s1)
    80004bec:	1ff7f793          	andi	a5,a5,511
    80004bf0:	97a6                	add	a5,a5,s1
    80004bf2:	0187c783          	lbu	a5,24(a5)
    80004bf6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bfa:	4685                	li	a3,1
    80004bfc:	fbf40613          	addi	a2,s0,-65
    80004c00:	85ca                	mv	a1,s2
    80004c02:	050a3503          	ld	a0,80(s4)
    80004c06:	ffffd097          	auipc	ra,0xffffd
    80004c0a:	b1a080e7          	jalr	-1254(ra) # 80001720 <copyout>
    80004c0e:	01650663          	beq	a0,s6,80004c1a <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c12:	2985                	addiw	s3,s3,1
    80004c14:	0905                	addi	s2,s2,1
    80004c16:	fd3a91e3          	bne	s5,s3,80004bd8 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004c1a:	21c48513          	addi	a0,s1,540
    80004c1e:	ffffd097          	auipc	ra,0xffffd
    80004c22:	7b0080e7          	jalr	1968(ra) # 800023ce <wakeup>
  release(&pi->lock);
    80004c26:	8526                	mv	a0,s1
    80004c28:	ffffc097          	auipc	ra,0xffffc
    80004c2c:	0ee080e7          	jalr	238(ra) # 80000d16 <release>
  return i;
}
    80004c30:	854e                	mv	a0,s3
    80004c32:	60a6                	ld	ra,72(sp)
    80004c34:	6406                	ld	s0,64(sp)
    80004c36:	74e2                	ld	s1,56(sp)
    80004c38:	7942                	ld	s2,48(sp)
    80004c3a:	79a2                	ld	s3,40(sp)
    80004c3c:	7a02                	ld	s4,32(sp)
    80004c3e:	6ae2                	ld	s5,24(sp)
    80004c40:	6b42                	ld	s6,16(sp)
    80004c42:	6161                	addi	sp,sp,80
    80004c44:	8082                	ret
      release(&pi->lock);
    80004c46:	8526                	mv	a0,s1
    80004c48:	ffffc097          	auipc	ra,0xffffc
    80004c4c:	0ce080e7          	jalr	206(ra) # 80000d16 <release>
      return -1;
    80004c50:	59fd                	li	s3,-1
    80004c52:	bff9                	j	80004c30 <piperead+0xc2>

0000000080004c54 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004c54:	de010113          	addi	sp,sp,-544
    80004c58:	20113c23          	sd	ra,536(sp)
    80004c5c:	20813823          	sd	s0,528(sp)
    80004c60:	20913423          	sd	s1,520(sp)
    80004c64:	21213023          	sd	s2,512(sp)
    80004c68:	ffce                	sd	s3,504(sp)
    80004c6a:	fbd2                	sd	s4,496(sp)
    80004c6c:	f7d6                	sd	s5,488(sp)
    80004c6e:	f3da                	sd	s6,480(sp)
    80004c70:	efde                	sd	s7,472(sp)
    80004c72:	ebe2                	sd	s8,464(sp)
    80004c74:	e7e6                	sd	s9,456(sp)
    80004c76:	e3ea                	sd	s10,448(sp)
    80004c78:	ff6e                	sd	s11,440(sp)
    80004c7a:	1400                	addi	s0,sp,544
    80004c7c:	892a                	mv	s2,a0
    80004c7e:	dea43423          	sd	a0,-536(s0)
    80004c82:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004c86:	ffffd097          	auipc	ra,0xffffd
    80004c8a:	da8080e7          	jalr	-600(ra) # 80001a2e <myproc>
    80004c8e:	84aa                	mv	s1,a0

  begin_op();
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	46c080e7          	jalr	1132(ra) # 800040fc <begin_op>

  if((ip = namei(path)) == 0){
    80004c98:	854a                	mv	a0,s2
    80004c9a:	fffff097          	auipc	ra,0xfffff
    80004c9e:	256080e7          	jalr	598(ra) # 80003ef0 <namei>
    80004ca2:	c93d                	beqz	a0,80004d18 <exec+0xc4>
    80004ca4:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	a9a080e7          	jalr	-1382(ra) # 80003740 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004cae:	04000713          	li	a4,64
    80004cb2:	4681                	li	a3,0
    80004cb4:	e4840613          	addi	a2,s0,-440
    80004cb8:	4581                	li	a1,0
    80004cba:	8556                	mv	a0,s5
    80004cbc:	fffff097          	auipc	ra,0xfffff
    80004cc0:	d38080e7          	jalr	-712(ra) # 800039f4 <readi>
    80004cc4:	04000793          	li	a5,64
    80004cc8:	00f51a63          	bne	a0,a5,80004cdc <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004ccc:	e4842703          	lw	a4,-440(s0)
    80004cd0:	464c47b7          	lui	a5,0x464c4
    80004cd4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004cd8:	04f70663          	beq	a4,a5,80004d24 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004cdc:	8556                	mv	a0,s5
    80004cde:	fffff097          	auipc	ra,0xfffff
    80004ce2:	cc4080e7          	jalr	-828(ra) # 800039a2 <iunlockput>
    end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	496080e7          	jalr	1174(ra) # 8000417c <end_op>
  }
  return -1;
    80004cee:	557d                	li	a0,-1
}
    80004cf0:	21813083          	ld	ra,536(sp)
    80004cf4:	21013403          	ld	s0,528(sp)
    80004cf8:	20813483          	ld	s1,520(sp)
    80004cfc:	20013903          	ld	s2,512(sp)
    80004d00:	79fe                	ld	s3,504(sp)
    80004d02:	7a5e                	ld	s4,496(sp)
    80004d04:	7abe                	ld	s5,488(sp)
    80004d06:	7b1e                	ld	s6,480(sp)
    80004d08:	6bfe                	ld	s7,472(sp)
    80004d0a:	6c5e                	ld	s8,464(sp)
    80004d0c:	6cbe                	ld	s9,456(sp)
    80004d0e:	6d1e                	ld	s10,448(sp)
    80004d10:	7dfa                	ld	s11,440(sp)
    80004d12:	22010113          	addi	sp,sp,544
    80004d16:	8082                	ret
    end_op();
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	464080e7          	jalr	1124(ra) # 8000417c <end_op>
    return -1;
    80004d20:	557d                	li	a0,-1
    80004d22:	b7f9                	j	80004cf0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004d24:	8526                	mv	a0,s1
    80004d26:	ffffd097          	auipc	ra,0xffffd
    80004d2a:	dcc080e7          	jalr	-564(ra) # 80001af2 <proc_pagetable>
    80004d2e:	8b2a                	mv	s6,a0
    80004d30:	d555                	beqz	a0,80004cdc <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d32:	e6842783          	lw	a5,-408(s0)
    80004d36:	e8045703          	lhu	a4,-384(s0)
    80004d3a:	c735                	beqz	a4,80004da6 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004d3c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d3e:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004d42:	6a05                	lui	s4,0x1
    80004d44:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004d48:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80004d4c:	6d85                	lui	s11,0x1
    80004d4e:	7d7d                	lui	s10,0xfffff
    80004d50:	ac1d                	j	80004f86 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004d52:	00004517          	auipc	a0,0x4
    80004d56:	97e50513          	addi	a0,a0,-1666 # 800086d0 <syscalls+0x2a0>
    80004d5a:	ffffc097          	auipc	ra,0xffffc
    80004d5e:	876080e7          	jalr	-1930(ra) # 800005d0 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004d62:	874a                	mv	a4,s2
    80004d64:	009c86bb          	addw	a3,s9,s1
    80004d68:	4581                	li	a1,0
    80004d6a:	8556                	mv	a0,s5
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	c88080e7          	jalr	-888(ra) # 800039f4 <readi>
    80004d74:	2501                	sext.w	a0,a0
    80004d76:	1aa91863          	bne	s2,a0,80004f26 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004d7a:	009d84bb          	addw	s1,s11,s1
    80004d7e:	013d09bb          	addw	s3,s10,s3
    80004d82:	1f74f263          	bgeu	s1,s7,80004f66 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004d86:	02049593          	slli	a1,s1,0x20
    80004d8a:	9181                	srli	a1,a1,0x20
    80004d8c:	95e2                	add	a1,a1,s8
    80004d8e:	855a                	mv	a0,s6
    80004d90:	ffffc097          	auipc	ra,0xffffc
    80004d94:	35c080e7          	jalr	860(ra) # 800010ec <walkaddr>
    80004d98:	862a                	mv	a2,a0
    if(pa == 0)
    80004d9a:	dd45                	beqz	a0,80004d52 <exec+0xfe>
      n = PGSIZE;
    80004d9c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004d9e:	fd49f2e3          	bgeu	s3,s4,80004d62 <exec+0x10e>
      n = sz - i;
    80004da2:	894e                	mv	s2,s3
    80004da4:	bf7d                	j	80004d62 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004da6:	4481                	li	s1,0
  iunlockput(ip);
    80004da8:	8556                	mv	a0,s5
    80004daa:	fffff097          	auipc	ra,0xfffff
    80004dae:	bf8080e7          	jalr	-1032(ra) # 800039a2 <iunlockput>
  end_op();
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	3ca080e7          	jalr	970(ra) # 8000417c <end_op>
  p = myproc();
    80004dba:	ffffd097          	auipc	ra,0xffffd
    80004dbe:	c74080e7          	jalr	-908(ra) # 80001a2e <myproc>
    80004dc2:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004dc4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004dc8:	6785                	lui	a5,0x1
    80004dca:	17fd                	addi	a5,a5,-1
    80004dcc:	94be                	add	s1,s1,a5
    80004dce:	77fd                	lui	a5,0xfffff
    80004dd0:	8fe5                	and	a5,a5,s1
    80004dd2:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004dd6:	6609                	lui	a2,0x2
    80004dd8:	963e                	add	a2,a2,a5
    80004dda:	85be                	mv	a1,a5
    80004ddc:	855a                	mv	a0,s6
    80004dde:	ffffc097          	auipc	ra,0xffffc
    80004de2:	6f2080e7          	jalr	1778(ra) # 800014d0 <uvmalloc>
    80004de6:	8c2a                	mv	s8,a0
  ip = 0;
    80004de8:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004dea:	12050e63          	beqz	a0,80004f26 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004dee:	75f9                	lui	a1,0xffffe
    80004df0:	95aa                	add	a1,a1,a0
    80004df2:	855a                	mv	a0,s6
    80004df4:	ffffd097          	auipc	ra,0xffffd
    80004df8:	8fa080e7          	jalr	-1798(ra) # 800016ee <uvmclear>
  stackbase = sp - PGSIZE;
    80004dfc:	7afd                	lui	s5,0xfffff
    80004dfe:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e00:	df043783          	ld	a5,-528(s0)
    80004e04:	6388                	ld	a0,0(a5)
    80004e06:	c925                	beqz	a0,80004e76 <exec+0x222>
    80004e08:	e8840993          	addi	s3,s0,-376
    80004e0c:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80004e10:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e12:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004e14:	ffffc097          	auipc	ra,0xffffc
    80004e18:	0ce080e7          	jalr	206(ra) # 80000ee2 <strlen>
    80004e1c:	0015079b          	addiw	a5,a0,1
    80004e20:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e24:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004e28:	13596363          	bltu	s2,s5,80004f4e <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004e2c:	df043d83          	ld	s11,-528(s0)
    80004e30:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004e34:	8552                	mv	a0,s4
    80004e36:	ffffc097          	auipc	ra,0xffffc
    80004e3a:	0ac080e7          	jalr	172(ra) # 80000ee2 <strlen>
    80004e3e:	0015069b          	addiw	a3,a0,1
    80004e42:	8652                	mv	a2,s4
    80004e44:	85ca                	mv	a1,s2
    80004e46:	855a                	mv	a0,s6
    80004e48:	ffffd097          	auipc	ra,0xffffd
    80004e4c:	8d8080e7          	jalr	-1832(ra) # 80001720 <copyout>
    80004e50:	10054363          	bltz	a0,80004f56 <exec+0x302>
    ustack[argc] = sp;
    80004e54:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e58:	0485                	addi	s1,s1,1
    80004e5a:	008d8793          	addi	a5,s11,8
    80004e5e:	def43823          	sd	a5,-528(s0)
    80004e62:	008db503          	ld	a0,8(s11)
    80004e66:	c911                	beqz	a0,80004e7a <exec+0x226>
    if(argc >= MAXARG)
    80004e68:	09a1                	addi	s3,s3,8
    80004e6a:	fb3c95e3          	bne	s9,s3,80004e14 <exec+0x1c0>
  sz = sz1;
    80004e6e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e72:	4a81                	li	s5,0
    80004e74:	a84d                	j	80004f26 <exec+0x2d2>
  sp = sz;
    80004e76:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e78:	4481                	li	s1,0
  ustack[argc] = 0;
    80004e7a:	00349793          	slli	a5,s1,0x3
    80004e7e:	f9040713          	addi	a4,s0,-112
    80004e82:	97ba                	add	a5,a5,a4
    80004e84:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd7ef8>
  sp -= (argc+1) * sizeof(uint64);
    80004e88:	00148693          	addi	a3,s1,1
    80004e8c:	068e                	slli	a3,a3,0x3
    80004e8e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004e92:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004e96:	01597663          	bgeu	s2,s5,80004ea2 <exec+0x24e>
  sz = sz1;
    80004e9a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e9e:	4a81                	li	s5,0
    80004ea0:	a059                	j	80004f26 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004ea2:	e8840613          	addi	a2,s0,-376
    80004ea6:	85ca                	mv	a1,s2
    80004ea8:	855a                	mv	a0,s6
    80004eaa:	ffffd097          	auipc	ra,0xffffd
    80004eae:	876080e7          	jalr	-1930(ra) # 80001720 <copyout>
    80004eb2:	0a054663          	bltz	a0,80004f5e <exec+0x30a>
  p->trapframe->a1 = sp;
    80004eb6:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004eba:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004ebe:	de843783          	ld	a5,-536(s0)
    80004ec2:	0007c703          	lbu	a4,0(a5)
    80004ec6:	cf11                	beqz	a4,80004ee2 <exec+0x28e>
    80004ec8:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004eca:	02f00693          	li	a3,47
    80004ece:	a039                	j	80004edc <exec+0x288>
      last = s+1;
    80004ed0:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004ed4:	0785                	addi	a5,a5,1
    80004ed6:	fff7c703          	lbu	a4,-1(a5)
    80004eda:	c701                	beqz	a4,80004ee2 <exec+0x28e>
    if(*s == '/')
    80004edc:	fed71ce3          	bne	a4,a3,80004ed4 <exec+0x280>
    80004ee0:	bfc5                	j	80004ed0 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004ee2:	4641                	li	a2,16
    80004ee4:	de843583          	ld	a1,-536(s0)
    80004ee8:	158b8513          	addi	a0,s7,344
    80004eec:	ffffc097          	auipc	ra,0xffffc
    80004ef0:	fc4080e7          	jalr	-60(ra) # 80000eb0 <safestrcpy>
  oldpagetable = p->pagetable;
    80004ef4:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004ef8:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004efc:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004f00:	058bb783          	ld	a5,88(s7)
    80004f04:	e6043703          	ld	a4,-416(s0)
    80004f08:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004f0a:	058bb783          	ld	a5,88(s7)
    80004f0e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004f12:	85ea                	mv	a1,s10
    80004f14:	ffffd097          	auipc	ra,0xffffd
    80004f18:	c7a080e7          	jalr	-902(ra) # 80001b8e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f1c:	0004851b          	sext.w	a0,s1
    80004f20:	bbc1                	j	80004cf0 <exec+0x9c>
    80004f22:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004f26:	df843583          	ld	a1,-520(s0)
    80004f2a:	855a                	mv	a0,s6
    80004f2c:	ffffd097          	auipc	ra,0xffffd
    80004f30:	c62080e7          	jalr	-926(ra) # 80001b8e <proc_freepagetable>
  if(ip){
    80004f34:	da0a94e3          	bnez	s5,80004cdc <exec+0x88>
  return -1;
    80004f38:	557d                	li	a0,-1
    80004f3a:	bb5d                	j	80004cf0 <exec+0x9c>
    80004f3c:	de943c23          	sd	s1,-520(s0)
    80004f40:	b7dd                	j	80004f26 <exec+0x2d2>
    80004f42:	de943c23          	sd	s1,-520(s0)
    80004f46:	b7c5                	j	80004f26 <exec+0x2d2>
    80004f48:	de943c23          	sd	s1,-520(s0)
    80004f4c:	bfe9                	j	80004f26 <exec+0x2d2>
  sz = sz1;
    80004f4e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f52:	4a81                	li	s5,0
    80004f54:	bfc9                	j	80004f26 <exec+0x2d2>
  sz = sz1;
    80004f56:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f5a:	4a81                	li	s5,0
    80004f5c:	b7e9                	j	80004f26 <exec+0x2d2>
  sz = sz1;
    80004f5e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f62:	4a81                	li	s5,0
    80004f64:	b7c9                	j	80004f26 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004f66:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f6a:	e0843783          	ld	a5,-504(s0)
    80004f6e:	0017869b          	addiw	a3,a5,1
    80004f72:	e0d43423          	sd	a3,-504(s0)
    80004f76:	e0043783          	ld	a5,-512(s0)
    80004f7a:	0387879b          	addiw	a5,a5,56
    80004f7e:	e8045703          	lhu	a4,-384(s0)
    80004f82:	e2e6d3e3          	bge	a3,a4,80004da8 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004f86:	2781                	sext.w	a5,a5
    80004f88:	e0f43023          	sd	a5,-512(s0)
    80004f8c:	03800713          	li	a4,56
    80004f90:	86be                	mv	a3,a5
    80004f92:	e1040613          	addi	a2,s0,-496
    80004f96:	4581                	li	a1,0
    80004f98:	8556                	mv	a0,s5
    80004f9a:	fffff097          	auipc	ra,0xfffff
    80004f9e:	a5a080e7          	jalr	-1446(ra) # 800039f4 <readi>
    80004fa2:	03800793          	li	a5,56
    80004fa6:	f6f51ee3          	bne	a0,a5,80004f22 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004faa:	e1042783          	lw	a5,-496(s0)
    80004fae:	4705                	li	a4,1
    80004fb0:	fae79de3          	bne	a5,a4,80004f6a <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004fb4:	e3843603          	ld	a2,-456(s0)
    80004fb8:	e3043783          	ld	a5,-464(s0)
    80004fbc:	f8f660e3          	bltu	a2,a5,80004f3c <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004fc0:	e2043783          	ld	a5,-480(s0)
    80004fc4:	963e                	add	a2,a2,a5
    80004fc6:	f6f66ee3          	bltu	a2,a5,80004f42 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004fca:	85a6                	mv	a1,s1
    80004fcc:	855a                	mv	a0,s6
    80004fce:	ffffc097          	auipc	ra,0xffffc
    80004fd2:	502080e7          	jalr	1282(ra) # 800014d0 <uvmalloc>
    80004fd6:	dea43c23          	sd	a0,-520(s0)
    80004fda:	d53d                	beqz	a0,80004f48 <exec+0x2f4>
    if(ph.vaddr % PGSIZE != 0)
    80004fdc:	e2043c03          	ld	s8,-480(s0)
    80004fe0:	de043783          	ld	a5,-544(s0)
    80004fe4:	00fc77b3          	and	a5,s8,a5
    80004fe8:	ff9d                	bnez	a5,80004f26 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004fea:	e1842c83          	lw	s9,-488(s0)
    80004fee:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004ff2:	f60b8ae3          	beqz	s7,80004f66 <exec+0x312>
    80004ff6:	89de                	mv	s3,s7
    80004ff8:	4481                	li	s1,0
    80004ffa:	b371                	j	80004d86 <exec+0x132>

0000000080004ffc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004ffc:	7179                	addi	sp,sp,-48
    80004ffe:	f406                	sd	ra,40(sp)
    80005000:	f022                	sd	s0,32(sp)
    80005002:	ec26                	sd	s1,24(sp)
    80005004:	e84a                	sd	s2,16(sp)
    80005006:	1800                	addi	s0,sp,48
    80005008:	892e                	mv	s2,a1
    8000500a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000500c:	fdc40593          	addi	a1,s0,-36
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	b0a080e7          	jalr	-1270(ra) # 80002b1a <argint>
    80005018:	04054063          	bltz	a0,80005058 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000501c:	fdc42703          	lw	a4,-36(s0)
    80005020:	47bd                	li	a5,15
    80005022:	02e7ed63          	bltu	a5,a4,8000505c <argfd+0x60>
    80005026:	ffffd097          	auipc	ra,0xffffd
    8000502a:	a08080e7          	jalr	-1528(ra) # 80001a2e <myproc>
    8000502e:	fdc42703          	lw	a4,-36(s0)
    80005032:	01a70793          	addi	a5,a4,26
    80005036:	078e                	slli	a5,a5,0x3
    80005038:	953e                	add	a0,a0,a5
    8000503a:	611c                	ld	a5,0(a0)
    8000503c:	c395                	beqz	a5,80005060 <argfd+0x64>
    return -1;
  if(pfd)
    8000503e:	00090463          	beqz	s2,80005046 <argfd+0x4a>
    *pfd = fd;
    80005042:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005046:	4501                	li	a0,0
  if(pf)
    80005048:	c091                	beqz	s1,8000504c <argfd+0x50>
    *pf = f;
    8000504a:	e09c                	sd	a5,0(s1)
}
    8000504c:	70a2                	ld	ra,40(sp)
    8000504e:	7402                	ld	s0,32(sp)
    80005050:	64e2                	ld	s1,24(sp)
    80005052:	6942                	ld	s2,16(sp)
    80005054:	6145                	addi	sp,sp,48
    80005056:	8082                	ret
    return -1;
    80005058:	557d                	li	a0,-1
    8000505a:	bfcd                	j	8000504c <argfd+0x50>
    return -1;
    8000505c:	557d                	li	a0,-1
    8000505e:	b7fd                	j	8000504c <argfd+0x50>
    80005060:	557d                	li	a0,-1
    80005062:	b7ed                	j	8000504c <argfd+0x50>

0000000080005064 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005064:	1101                	addi	sp,sp,-32
    80005066:	ec06                	sd	ra,24(sp)
    80005068:	e822                	sd	s0,16(sp)
    8000506a:	e426                	sd	s1,8(sp)
    8000506c:	1000                	addi	s0,sp,32
    8000506e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005070:	ffffd097          	auipc	ra,0xffffd
    80005074:	9be080e7          	jalr	-1602(ra) # 80001a2e <myproc>
    80005078:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000507a:	0d050793          	addi	a5,a0,208
    8000507e:	4501                	li	a0,0
    80005080:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005082:	6398                	ld	a4,0(a5)
    80005084:	cb19                	beqz	a4,8000509a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005086:	2505                	addiw	a0,a0,1
    80005088:	07a1                	addi	a5,a5,8
    8000508a:	fed51ce3          	bne	a0,a3,80005082 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000508e:	557d                	li	a0,-1
}
    80005090:	60e2                	ld	ra,24(sp)
    80005092:	6442                	ld	s0,16(sp)
    80005094:	64a2                	ld	s1,8(sp)
    80005096:	6105                	addi	sp,sp,32
    80005098:	8082                	ret
      p->ofile[fd] = f;
    8000509a:	01a50793          	addi	a5,a0,26
    8000509e:	078e                	slli	a5,a5,0x3
    800050a0:	963e                	add	a2,a2,a5
    800050a2:	e204                	sd	s1,0(a2)
      return fd;
    800050a4:	b7f5                	j	80005090 <fdalloc+0x2c>

00000000800050a6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800050a6:	715d                	addi	sp,sp,-80
    800050a8:	e486                	sd	ra,72(sp)
    800050aa:	e0a2                	sd	s0,64(sp)
    800050ac:	fc26                	sd	s1,56(sp)
    800050ae:	f84a                	sd	s2,48(sp)
    800050b0:	f44e                	sd	s3,40(sp)
    800050b2:	f052                	sd	s4,32(sp)
    800050b4:	ec56                	sd	s5,24(sp)
    800050b6:	0880                	addi	s0,sp,80
    800050b8:	89ae                	mv	s3,a1
    800050ba:	8ab2                	mv	s5,a2
    800050bc:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800050be:	fb040593          	addi	a1,s0,-80
    800050c2:	fffff097          	auipc	ra,0xfffff
    800050c6:	e4c080e7          	jalr	-436(ra) # 80003f0e <nameiparent>
    800050ca:	892a                	mv	s2,a0
    800050cc:	12050e63          	beqz	a0,80005208 <create+0x162>
    return 0;

  ilock(dp);
    800050d0:	ffffe097          	auipc	ra,0xffffe
    800050d4:	670080e7          	jalr	1648(ra) # 80003740 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800050d8:	4601                	li	a2,0
    800050da:	fb040593          	addi	a1,s0,-80
    800050de:	854a                	mv	a0,s2
    800050e0:	fffff097          	auipc	ra,0xfffff
    800050e4:	b3e080e7          	jalr	-1218(ra) # 80003c1e <dirlookup>
    800050e8:	84aa                	mv	s1,a0
    800050ea:	c921                	beqz	a0,8000513a <create+0x94>
    iunlockput(dp);
    800050ec:	854a                	mv	a0,s2
    800050ee:	fffff097          	auipc	ra,0xfffff
    800050f2:	8b4080e7          	jalr	-1868(ra) # 800039a2 <iunlockput>
    ilock(ip);
    800050f6:	8526                	mv	a0,s1
    800050f8:	ffffe097          	auipc	ra,0xffffe
    800050fc:	648080e7          	jalr	1608(ra) # 80003740 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005100:	2981                	sext.w	s3,s3
    80005102:	4789                	li	a5,2
    80005104:	02f99463          	bne	s3,a5,8000512c <create+0x86>
    80005108:	0444d783          	lhu	a5,68(s1)
    8000510c:	37f9                	addiw	a5,a5,-2
    8000510e:	17c2                	slli	a5,a5,0x30
    80005110:	93c1                	srli	a5,a5,0x30
    80005112:	4705                	li	a4,1
    80005114:	00f76c63          	bltu	a4,a5,8000512c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005118:	8526                	mv	a0,s1
    8000511a:	60a6                	ld	ra,72(sp)
    8000511c:	6406                	ld	s0,64(sp)
    8000511e:	74e2                	ld	s1,56(sp)
    80005120:	7942                	ld	s2,48(sp)
    80005122:	79a2                	ld	s3,40(sp)
    80005124:	7a02                	ld	s4,32(sp)
    80005126:	6ae2                	ld	s5,24(sp)
    80005128:	6161                	addi	sp,sp,80
    8000512a:	8082                	ret
    iunlockput(ip);
    8000512c:	8526                	mv	a0,s1
    8000512e:	fffff097          	auipc	ra,0xfffff
    80005132:	874080e7          	jalr	-1932(ra) # 800039a2 <iunlockput>
    return 0;
    80005136:	4481                	li	s1,0
    80005138:	b7c5                	j	80005118 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000513a:	85ce                	mv	a1,s3
    8000513c:	00092503          	lw	a0,0(s2)
    80005140:	ffffe097          	auipc	ra,0xffffe
    80005144:	468080e7          	jalr	1128(ra) # 800035a8 <ialloc>
    80005148:	84aa                	mv	s1,a0
    8000514a:	c521                	beqz	a0,80005192 <create+0xec>
  ilock(ip);
    8000514c:	ffffe097          	auipc	ra,0xffffe
    80005150:	5f4080e7          	jalr	1524(ra) # 80003740 <ilock>
  ip->major = major;
    80005154:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005158:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000515c:	4a05                	li	s4,1
    8000515e:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005162:	8526                	mv	a0,s1
    80005164:	ffffe097          	auipc	ra,0xffffe
    80005168:	512080e7          	jalr	1298(ra) # 80003676 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000516c:	2981                	sext.w	s3,s3
    8000516e:	03498a63          	beq	s3,s4,800051a2 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005172:	40d0                	lw	a2,4(s1)
    80005174:	fb040593          	addi	a1,s0,-80
    80005178:	854a                	mv	a0,s2
    8000517a:	fffff097          	auipc	ra,0xfffff
    8000517e:	cb4080e7          	jalr	-844(ra) # 80003e2e <dirlink>
    80005182:	06054b63          	bltz	a0,800051f8 <create+0x152>
  iunlockput(dp);
    80005186:	854a                	mv	a0,s2
    80005188:	fffff097          	auipc	ra,0xfffff
    8000518c:	81a080e7          	jalr	-2022(ra) # 800039a2 <iunlockput>
  return ip;
    80005190:	b761                	j	80005118 <create+0x72>
    panic("create: ialloc");
    80005192:	00003517          	auipc	a0,0x3
    80005196:	55e50513          	addi	a0,a0,1374 # 800086f0 <syscalls+0x2c0>
    8000519a:	ffffb097          	auipc	ra,0xffffb
    8000519e:	436080e7          	jalr	1078(ra) # 800005d0 <panic>
    dp->nlink++;  // for ".."
    800051a2:	04a95783          	lhu	a5,74(s2)
    800051a6:	2785                	addiw	a5,a5,1
    800051a8:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800051ac:	854a                	mv	a0,s2
    800051ae:	ffffe097          	auipc	ra,0xffffe
    800051b2:	4c8080e7          	jalr	1224(ra) # 80003676 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800051b6:	40d0                	lw	a2,4(s1)
    800051b8:	00003597          	auipc	a1,0x3
    800051bc:	54858593          	addi	a1,a1,1352 # 80008700 <syscalls+0x2d0>
    800051c0:	8526                	mv	a0,s1
    800051c2:	fffff097          	auipc	ra,0xfffff
    800051c6:	c6c080e7          	jalr	-916(ra) # 80003e2e <dirlink>
    800051ca:	00054f63          	bltz	a0,800051e8 <create+0x142>
    800051ce:	00492603          	lw	a2,4(s2)
    800051d2:	00003597          	auipc	a1,0x3
    800051d6:	53658593          	addi	a1,a1,1334 # 80008708 <syscalls+0x2d8>
    800051da:	8526                	mv	a0,s1
    800051dc:	fffff097          	auipc	ra,0xfffff
    800051e0:	c52080e7          	jalr	-942(ra) # 80003e2e <dirlink>
    800051e4:	f80557e3          	bgez	a0,80005172 <create+0xcc>
      panic("create dots");
    800051e8:	00003517          	auipc	a0,0x3
    800051ec:	52850513          	addi	a0,a0,1320 # 80008710 <syscalls+0x2e0>
    800051f0:	ffffb097          	auipc	ra,0xffffb
    800051f4:	3e0080e7          	jalr	992(ra) # 800005d0 <panic>
    panic("create: dirlink");
    800051f8:	00003517          	auipc	a0,0x3
    800051fc:	52850513          	addi	a0,a0,1320 # 80008720 <syscalls+0x2f0>
    80005200:	ffffb097          	auipc	ra,0xffffb
    80005204:	3d0080e7          	jalr	976(ra) # 800005d0 <panic>
    return 0;
    80005208:	84aa                	mv	s1,a0
    8000520a:	b739                	j	80005118 <create+0x72>

000000008000520c <sys_dup>:
{
    8000520c:	7179                	addi	sp,sp,-48
    8000520e:	f406                	sd	ra,40(sp)
    80005210:	f022                	sd	s0,32(sp)
    80005212:	ec26                	sd	s1,24(sp)
    80005214:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005216:	fd840613          	addi	a2,s0,-40
    8000521a:	4581                	li	a1,0
    8000521c:	4501                	li	a0,0
    8000521e:	00000097          	auipc	ra,0x0
    80005222:	dde080e7          	jalr	-546(ra) # 80004ffc <argfd>
    return -1;
    80005226:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005228:	02054363          	bltz	a0,8000524e <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000522c:	fd843503          	ld	a0,-40(s0)
    80005230:	00000097          	auipc	ra,0x0
    80005234:	e34080e7          	jalr	-460(ra) # 80005064 <fdalloc>
    80005238:	84aa                	mv	s1,a0
    return -1;
    8000523a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000523c:	00054963          	bltz	a0,8000524e <sys_dup+0x42>
  filedup(f);
    80005240:	fd843503          	ld	a0,-40(s0)
    80005244:	fffff097          	auipc	ra,0xfffff
    80005248:	338080e7          	jalr	824(ra) # 8000457c <filedup>
  return fd;
    8000524c:	87a6                	mv	a5,s1
}
    8000524e:	853e                	mv	a0,a5
    80005250:	70a2                	ld	ra,40(sp)
    80005252:	7402                	ld	s0,32(sp)
    80005254:	64e2                	ld	s1,24(sp)
    80005256:	6145                	addi	sp,sp,48
    80005258:	8082                	ret

000000008000525a <sys_read>:
{
    8000525a:	7179                	addi	sp,sp,-48
    8000525c:	f406                	sd	ra,40(sp)
    8000525e:	f022                	sd	s0,32(sp)
    80005260:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005262:	fe840613          	addi	a2,s0,-24
    80005266:	4581                	li	a1,0
    80005268:	4501                	li	a0,0
    8000526a:	00000097          	auipc	ra,0x0
    8000526e:	d92080e7          	jalr	-622(ra) # 80004ffc <argfd>
    return -1;
    80005272:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005274:	04054163          	bltz	a0,800052b6 <sys_read+0x5c>
    80005278:	fe440593          	addi	a1,s0,-28
    8000527c:	4509                	li	a0,2
    8000527e:	ffffe097          	auipc	ra,0xffffe
    80005282:	89c080e7          	jalr	-1892(ra) # 80002b1a <argint>
    return -1;
    80005286:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005288:	02054763          	bltz	a0,800052b6 <sys_read+0x5c>
    8000528c:	fd840593          	addi	a1,s0,-40
    80005290:	4505                	li	a0,1
    80005292:	ffffe097          	auipc	ra,0xffffe
    80005296:	8aa080e7          	jalr	-1878(ra) # 80002b3c <argaddr>
    return -1;
    8000529a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000529c:	00054d63          	bltz	a0,800052b6 <sys_read+0x5c>
  return fileread(f, p, n);
    800052a0:	fe442603          	lw	a2,-28(s0)
    800052a4:	fd843583          	ld	a1,-40(s0)
    800052a8:	fe843503          	ld	a0,-24(s0)
    800052ac:	fffff097          	auipc	ra,0xfffff
    800052b0:	45c080e7          	jalr	1116(ra) # 80004708 <fileread>
    800052b4:	87aa                	mv	a5,a0
}
    800052b6:	853e                	mv	a0,a5
    800052b8:	70a2                	ld	ra,40(sp)
    800052ba:	7402                	ld	s0,32(sp)
    800052bc:	6145                	addi	sp,sp,48
    800052be:	8082                	ret

00000000800052c0 <sys_write>:
{
    800052c0:	7179                	addi	sp,sp,-48
    800052c2:	f406                	sd	ra,40(sp)
    800052c4:	f022                	sd	s0,32(sp)
    800052c6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052c8:	fe840613          	addi	a2,s0,-24
    800052cc:	4581                	li	a1,0
    800052ce:	4501                	li	a0,0
    800052d0:	00000097          	auipc	ra,0x0
    800052d4:	d2c080e7          	jalr	-724(ra) # 80004ffc <argfd>
    return -1;
    800052d8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052da:	04054163          	bltz	a0,8000531c <sys_write+0x5c>
    800052de:	fe440593          	addi	a1,s0,-28
    800052e2:	4509                	li	a0,2
    800052e4:	ffffe097          	auipc	ra,0xffffe
    800052e8:	836080e7          	jalr	-1994(ra) # 80002b1a <argint>
    return -1;
    800052ec:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052ee:	02054763          	bltz	a0,8000531c <sys_write+0x5c>
    800052f2:	fd840593          	addi	a1,s0,-40
    800052f6:	4505                	li	a0,1
    800052f8:	ffffe097          	auipc	ra,0xffffe
    800052fc:	844080e7          	jalr	-1980(ra) # 80002b3c <argaddr>
    return -1;
    80005300:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005302:	00054d63          	bltz	a0,8000531c <sys_write+0x5c>
  return filewrite(f, p, n);
    80005306:	fe442603          	lw	a2,-28(s0)
    8000530a:	fd843583          	ld	a1,-40(s0)
    8000530e:	fe843503          	ld	a0,-24(s0)
    80005312:	fffff097          	auipc	ra,0xfffff
    80005316:	4b8080e7          	jalr	1208(ra) # 800047ca <filewrite>
    8000531a:	87aa                	mv	a5,a0
}
    8000531c:	853e                	mv	a0,a5
    8000531e:	70a2                	ld	ra,40(sp)
    80005320:	7402                	ld	s0,32(sp)
    80005322:	6145                	addi	sp,sp,48
    80005324:	8082                	ret

0000000080005326 <sys_close>:
{
    80005326:	1101                	addi	sp,sp,-32
    80005328:	ec06                	sd	ra,24(sp)
    8000532a:	e822                	sd	s0,16(sp)
    8000532c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000532e:	fe040613          	addi	a2,s0,-32
    80005332:	fec40593          	addi	a1,s0,-20
    80005336:	4501                	li	a0,0
    80005338:	00000097          	auipc	ra,0x0
    8000533c:	cc4080e7          	jalr	-828(ra) # 80004ffc <argfd>
    return -1;
    80005340:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005342:	02054463          	bltz	a0,8000536a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005346:	ffffc097          	auipc	ra,0xffffc
    8000534a:	6e8080e7          	jalr	1768(ra) # 80001a2e <myproc>
    8000534e:	fec42783          	lw	a5,-20(s0)
    80005352:	07e9                	addi	a5,a5,26
    80005354:	078e                	slli	a5,a5,0x3
    80005356:	97aa                	add	a5,a5,a0
    80005358:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000535c:	fe043503          	ld	a0,-32(s0)
    80005360:	fffff097          	auipc	ra,0xfffff
    80005364:	26e080e7          	jalr	622(ra) # 800045ce <fileclose>
  return 0;
    80005368:	4781                	li	a5,0
}
    8000536a:	853e                	mv	a0,a5
    8000536c:	60e2                	ld	ra,24(sp)
    8000536e:	6442                	ld	s0,16(sp)
    80005370:	6105                	addi	sp,sp,32
    80005372:	8082                	ret

0000000080005374 <sys_fstat>:
{
    80005374:	1101                	addi	sp,sp,-32
    80005376:	ec06                	sd	ra,24(sp)
    80005378:	e822                	sd	s0,16(sp)
    8000537a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000537c:	fe840613          	addi	a2,s0,-24
    80005380:	4581                	li	a1,0
    80005382:	4501                	li	a0,0
    80005384:	00000097          	auipc	ra,0x0
    80005388:	c78080e7          	jalr	-904(ra) # 80004ffc <argfd>
    return -1;
    8000538c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000538e:	02054563          	bltz	a0,800053b8 <sys_fstat+0x44>
    80005392:	fe040593          	addi	a1,s0,-32
    80005396:	4505                	li	a0,1
    80005398:	ffffd097          	auipc	ra,0xffffd
    8000539c:	7a4080e7          	jalr	1956(ra) # 80002b3c <argaddr>
    return -1;
    800053a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800053a2:	00054b63          	bltz	a0,800053b8 <sys_fstat+0x44>
  return filestat(f, st);
    800053a6:	fe043583          	ld	a1,-32(s0)
    800053aa:	fe843503          	ld	a0,-24(s0)
    800053ae:	fffff097          	auipc	ra,0xfffff
    800053b2:	2e8080e7          	jalr	744(ra) # 80004696 <filestat>
    800053b6:	87aa                	mv	a5,a0
}
    800053b8:	853e                	mv	a0,a5
    800053ba:	60e2                	ld	ra,24(sp)
    800053bc:	6442                	ld	s0,16(sp)
    800053be:	6105                	addi	sp,sp,32
    800053c0:	8082                	ret

00000000800053c2 <sys_link>:
{
    800053c2:	7169                	addi	sp,sp,-304
    800053c4:	f606                	sd	ra,296(sp)
    800053c6:	f222                	sd	s0,288(sp)
    800053c8:	ee26                	sd	s1,280(sp)
    800053ca:	ea4a                	sd	s2,272(sp)
    800053cc:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053ce:	08000613          	li	a2,128
    800053d2:	ed040593          	addi	a1,s0,-304
    800053d6:	4501                	li	a0,0
    800053d8:	ffffd097          	auipc	ra,0xffffd
    800053dc:	786080e7          	jalr	1926(ra) # 80002b5e <argstr>
    return -1;
    800053e0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053e2:	10054e63          	bltz	a0,800054fe <sys_link+0x13c>
    800053e6:	08000613          	li	a2,128
    800053ea:	f5040593          	addi	a1,s0,-176
    800053ee:	4505                	li	a0,1
    800053f0:	ffffd097          	auipc	ra,0xffffd
    800053f4:	76e080e7          	jalr	1902(ra) # 80002b5e <argstr>
    return -1;
    800053f8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053fa:	10054263          	bltz	a0,800054fe <sys_link+0x13c>
  begin_op();
    800053fe:	fffff097          	auipc	ra,0xfffff
    80005402:	cfe080e7          	jalr	-770(ra) # 800040fc <begin_op>
  if((ip = namei(old)) == 0){
    80005406:	ed040513          	addi	a0,s0,-304
    8000540a:	fffff097          	auipc	ra,0xfffff
    8000540e:	ae6080e7          	jalr	-1306(ra) # 80003ef0 <namei>
    80005412:	84aa                	mv	s1,a0
    80005414:	c551                	beqz	a0,800054a0 <sys_link+0xde>
  ilock(ip);
    80005416:	ffffe097          	auipc	ra,0xffffe
    8000541a:	32a080e7          	jalr	810(ra) # 80003740 <ilock>
  if(ip->type == T_DIR){
    8000541e:	04449703          	lh	a4,68(s1)
    80005422:	4785                	li	a5,1
    80005424:	08f70463          	beq	a4,a5,800054ac <sys_link+0xea>
  ip->nlink++;
    80005428:	04a4d783          	lhu	a5,74(s1)
    8000542c:	2785                	addiw	a5,a5,1
    8000542e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005432:	8526                	mv	a0,s1
    80005434:	ffffe097          	auipc	ra,0xffffe
    80005438:	242080e7          	jalr	578(ra) # 80003676 <iupdate>
  iunlock(ip);
    8000543c:	8526                	mv	a0,s1
    8000543e:	ffffe097          	auipc	ra,0xffffe
    80005442:	3c4080e7          	jalr	964(ra) # 80003802 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005446:	fd040593          	addi	a1,s0,-48
    8000544a:	f5040513          	addi	a0,s0,-176
    8000544e:	fffff097          	auipc	ra,0xfffff
    80005452:	ac0080e7          	jalr	-1344(ra) # 80003f0e <nameiparent>
    80005456:	892a                	mv	s2,a0
    80005458:	c935                	beqz	a0,800054cc <sys_link+0x10a>
  ilock(dp);
    8000545a:	ffffe097          	auipc	ra,0xffffe
    8000545e:	2e6080e7          	jalr	742(ra) # 80003740 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005462:	00092703          	lw	a4,0(s2)
    80005466:	409c                	lw	a5,0(s1)
    80005468:	04f71d63          	bne	a4,a5,800054c2 <sys_link+0x100>
    8000546c:	40d0                	lw	a2,4(s1)
    8000546e:	fd040593          	addi	a1,s0,-48
    80005472:	854a                	mv	a0,s2
    80005474:	fffff097          	auipc	ra,0xfffff
    80005478:	9ba080e7          	jalr	-1606(ra) # 80003e2e <dirlink>
    8000547c:	04054363          	bltz	a0,800054c2 <sys_link+0x100>
  iunlockput(dp);
    80005480:	854a                	mv	a0,s2
    80005482:	ffffe097          	auipc	ra,0xffffe
    80005486:	520080e7          	jalr	1312(ra) # 800039a2 <iunlockput>
  iput(ip);
    8000548a:	8526                	mv	a0,s1
    8000548c:	ffffe097          	auipc	ra,0xffffe
    80005490:	46e080e7          	jalr	1134(ra) # 800038fa <iput>
  end_op();
    80005494:	fffff097          	auipc	ra,0xfffff
    80005498:	ce8080e7          	jalr	-792(ra) # 8000417c <end_op>
  return 0;
    8000549c:	4781                	li	a5,0
    8000549e:	a085                	j	800054fe <sys_link+0x13c>
    end_op();
    800054a0:	fffff097          	auipc	ra,0xfffff
    800054a4:	cdc080e7          	jalr	-804(ra) # 8000417c <end_op>
    return -1;
    800054a8:	57fd                	li	a5,-1
    800054aa:	a891                	j	800054fe <sys_link+0x13c>
    iunlockput(ip);
    800054ac:	8526                	mv	a0,s1
    800054ae:	ffffe097          	auipc	ra,0xffffe
    800054b2:	4f4080e7          	jalr	1268(ra) # 800039a2 <iunlockput>
    end_op();
    800054b6:	fffff097          	auipc	ra,0xfffff
    800054ba:	cc6080e7          	jalr	-826(ra) # 8000417c <end_op>
    return -1;
    800054be:	57fd                	li	a5,-1
    800054c0:	a83d                	j	800054fe <sys_link+0x13c>
    iunlockput(dp);
    800054c2:	854a                	mv	a0,s2
    800054c4:	ffffe097          	auipc	ra,0xffffe
    800054c8:	4de080e7          	jalr	1246(ra) # 800039a2 <iunlockput>
  ilock(ip);
    800054cc:	8526                	mv	a0,s1
    800054ce:	ffffe097          	auipc	ra,0xffffe
    800054d2:	272080e7          	jalr	626(ra) # 80003740 <ilock>
  ip->nlink--;
    800054d6:	04a4d783          	lhu	a5,74(s1)
    800054da:	37fd                	addiw	a5,a5,-1
    800054dc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054e0:	8526                	mv	a0,s1
    800054e2:	ffffe097          	auipc	ra,0xffffe
    800054e6:	194080e7          	jalr	404(ra) # 80003676 <iupdate>
  iunlockput(ip);
    800054ea:	8526                	mv	a0,s1
    800054ec:	ffffe097          	auipc	ra,0xffffe
    800054f0:	4b6080e7          	jalr	1206(ra) # 800039a2 <iunlockput>
  end_op();
    800054f4:	fffff097          	auipc	ra,0xfffff
    800054f8:	c88080e7          	jalr	-888(ra) # 8000417c <end_op>
  return -1;
    800054fc:	57fd                	li	a5,-1
}
    800054fe:	853e                	mv	a0,a5
    80005500:	70b2                	ld	ra,296(sp)
    80005502:	7412                	ld	s0,288(sp)
    80005504:	64f2                	ld	s1,280(sp)
    80005506:	6952                	ld	s2,272(sp)
    80005508:	6155                	addi	sp,sp,304
    8000550a:	8082                	ret

000000008000550c <sys_unlink>:
{
    8000550c:	7151                	addi	sp,sp,-240
    8000550e:	f586                	sd	ra,232(sp)
    80005510:	f1a2                	sd	s0,224(sp)
    80005512:	eda6                	sd	s1,216(sp)
    80005514:	e9ca                	sd	s2,208(sp)
    80005516:	e5ce                	sd	s3,200(sp)
    80005518:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000551a:	08000613          	li	a2,128
    8000551e:	f3040593          	addi	a1,s0,-208
    80005522:	4501                	li	a0,0
    80005524:	ffffd097          	auipc	ra,0xffffd
    80005528:	63a080e7          	jalr	1594(ra) # 80002b5e <argstr>
    8000552c:	18054163          	bltz	a0,800056ae <sys_unlink+0x1a2>
  begin_op();
    80005530:	fffff097          	auipc	ra,0xfffff
    80005534:	bcc080e7          	jalr	-1076(ra) # 800040fc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005538:	fb040593          	addi	a1,s0,-80
    8000553c:	f3040513          	addi	a0,s0,-208
    80005540:	fffff097          	auipc	ra,0xfffff
    80005544:	9ce080e7          	jalr	-1586(ra) # 80003f0e <nameiparent>
    80005548:	84aa                	mv	s1,a0
    8000554a:	c979                	beqz	a0,80005620 <sys_unlink+0x114>
  ilock(dp);
    8000554c:	ffffe097          	auipc	ra,0xffffe
    80005550:	1f4080e7          	jalr	500(ra) # 80003740 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005554:	00003597          	auipc	a1,0x3
    80005558:	1ac58593          	addi	a1,a1,428 # 80008700 <syscalls+0x2d0>
    8000555c:	fb040513          	addi	a0,s0,-80
    80005560:	ffffe097          	auipc	ra,0xffffe
    80005564:	6a4080e7          	jalr	1700(ra) # 80003c04 <namecmp>
    80005568:	14050a63          	beqz	a0,800056bc <sys_unlink+0x1b0>
    8000556c:	00003597          	auipc	a1,0x3
    80005570:	19c58593          	addi	a1,a1,412 # 80008708 <syscalls+0x2d8>
    80005574:	fb040513          	addi	a0,s0,-80
    80005578:	ffffe097          	auipc	ra,0xffffe
    8000557c:	68c080e7          	jalr	1676(ra) # 80003c04 <namecmp>
    80005580:	12050e63          	beqz	a0,800056bc <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005584:	f2c40613          	addi	a2,s0,-212
    80005588:	fb040593          	addi	a1,s0,-80
    8000558c:	8526                	mv	a0,s1
    8000558e:	ffffe097          	auipc	ra,0xffffe
    80005592:	690080e7          	jalr	1680(ra) # 80003c1e <dirlookup>
    80005596:	892a                	mv	s2,a0
    80005598:	12050263          	beqz	a0,800056bc <sys_unlink+0x1b0>
  ilock(ip);
    8000559c:	ffffe097          	auipc	ra,0xffffe
    800055a0:	1a4080e7          	jalr	420(ra) # 80003740 <ilock>
  if(ip->nlink < 1)
    800055a4:	04a91783          	lh	a5,74(s2)
    800055a8:	08f05263          	blez	a5,8000562c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800055ac:	04491703          	lh	a4,68(s2)
    800055b0:	4785                	li	a5,1
    800055b2:	08f70563          	beq	a4,a5,8000563c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800055b6:	4641                	li	a2,16
    800055b8:	4581                	li	a1,0
    800055ba:	fc040513          	addi	a0,s0,-64
    800055be:	ffffb097          	auipc	ra,0xffffb
    800055c2:	7a0080e7          	jalr	1952(ra) # 80000d5e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055c6:	4741                	li	a4,16
    800055c8:	f2c42683          	lw	a3,-212(s0)
    800055cc:	fc040613          	addi	a2,s0,-64
    800055d0:	4581                	li	a1,0
    800055d2:	8526                	mv	a0,s1
    800055d4:	ffffe097          	auipc	ra,0xffffe
    800055d8:	516080e7          	jalr	1302(ra) # 80003aea <writei>
    800055dc:	47c1                	li	a5,16
    800055de:	0af51563          	bne	a0,a5,80005688 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800055e2:	04491703          	lh	a4,68(s2)
    800055e6:	4785                	li	a5,1
    800055e8:	0af70863          	beq	a4,a5,80005698 <sys_unlink+0x18c>
  iunlockput(dp);
    800055ec:	8526                	mv	a0,s1
    800055ee:	ffffe097          	auipc	ra,0xffffe
    800055f2:	3b4080e7          	jalr	948(ra) # 800039a2 <iunlockput>
  ip->nlink--;
    800055f6:	04a95783          	lhu	a5,74(s2)
    800055fa:	37fd                	addiw	a5,a5,-1
    800055fc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005600:	854a                	mv	a0,s2
    80005602:	ffffe097          	auipc	ra,0xffffe
    80005606:	074080e7          	jalr	116(ra) # 80003676 <iupdate>
  iunlockput(ip);
    8000560a:	854a                	mv	a0,s2
    8000560c:	ffffe097          	auipc	ra,0xffffe
    80005610:	396080e7          	jalr	918(ra) # 800039a2 <iunlockput>
  end_op();
    80005614:	fffff097          	auipc	ra,0xfffff
    80005618:	b68080e7          	jalr	-1176(ra) # 8000417c <end_op>
  return 0;
    8000561c:	4501                	li	a0,0
    8000561e:	a84d                	j	800056d0 <sys_unlink+0x1c4>
    end_op();
    80005620:	fffff097          	auipc	ra,0xfffff
    80005624:	b5c080e7          	jalr	-1188(ra) # 8000417c <end_op>
    return -1;
    80005628:	557d                	li	a0,-1
    8000562a:	a05d                	j	800056d0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000562c:	00003517          	auipc	a0,0x3
    80005630:	10450513          	addi	a0,a0,260 # 80008730 <syscalls+0x300>
    80005634:	ffffb097          	auipc	ra,0xffffb
    80005638:	f9c080e7          	jalr	-100(ra) # 800005d0 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000563c:	04c92703          	lw	a4,76(s2)
    80005640:	02000793          	li	a5,32
    80005644:	f6e7f9e3          	bgeu	a5,a4,800055b6 <sys_unlink+0xaa>
    80005648:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000564c:	4741                	li	a4,16
    8000564e:	86ce                	mv	a3,s3
    80005650:	f1840613          	addi	a2,s0,-232
    80005654:	4581                	li	a1,0
    80005656:	854a                	mv	a0,s2
    80005658:	ffffe097          	auipc	ra,0xffffe
    8000565c:	39c080e7          	jalr	924(ra) # 800039f4 <readi>
    80005660:	47c1                	li	a5,16
    80005662:	00f51b63          	bne	a0,a5,80005678 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005666:	f1845783          	lhu	a5,-232(s0)
    8000566a:	e7a1                	bnez	a5,800056b2 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000566c:	29c1                	addiw	s3,s3,16
    8000566e:	04c92783          	lw	a5,76(s2)
    80005672:	fcf9ede3          	bltu	s3,a5,8000564c <sys_unlink+0x140>
    80005676:	b781                	j	800055b6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005678:	00003517          	auipc	a0,0x3
    8000567c:	0d050513          	addi	a0,a0,208 # 80008748 <syscalls+0x318>
    80005680:	ffffb097          	auipc	ra,0xffffb
    80005684:	f50080e7          	jalr	-176(ra) # 800005d0 <panic>
    panic("unlink: writei");
    80005688:	00003517          	auipc	a0,0x3
    8000568c:	0d850513          	addi	a0,a0,216 # 80008760 <syscalls+0x330>
    80005690:	ffffb097          	auipc	ra,0xffffb
    80005694:	f40080e7          	jalr	-192(ra) # 800005d0 <panic>
    dp->nlink--;
    80005698:	04a4d783          	lhu	a5,74(s1)
    8000569c:	37fd                	addiw	a5,a5,-1
    8000569e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800056a2:	8526                	mv	a0,s1
    800056a4:	ffffe097          	auipc	ra,0xffffe
    800056a8:	fd2080e7          	jalr	-46(ra) # 80003676 <iupdate>
    800056ac:	b781                	j	800055ec <sys_unlink+0xe0>
    return -1;
    800056ae:	557d                	li	a0,-1
    800056b0:	a005                	j	800056d0 <sys_unlink+0x1c4>
    iunlockput(ip);
    800056b2:	854a                	mv	a0,s2
    800056b4:	ffffe097          	auipc	ra,0xffffe
    800056b8:	2ee080e7          	jalr	750(ra) # 800039a2 <iunlockput>
  iunlockput(dp);
    800056bc:	8526                	mv	a0,s1
    800056be:	ffffe097          	auipc	ra,0xffffe
    800056c2:	2e4080e7          	jalr	740(ra) # 800039a2 <iunlockput>
  end_op();
    800056c6:	fffff097          	auipc	ra,0xfffff
    800056ca:	ab6080e7          	jalr	-1354(ra) # 8000417c <end_op>
  return -1;
    800056ce:	557d                	li	a0,-1
}
    800056d0:	70ae                	ld	ra,232(sp)
    800056d2:	740e                	ld	s0,224(sp)
    800056d4:	64ee                	ld	s1,216(sp)
    800056d6:	694e                	ld	s2,208(sp)
    800056d8:	69ae                	ld	s3,200(sp)
    800056da:	616d                	addi	sp,sp,240
    800056dc:	8082                	ret

00000000800056de <sys_open>:

uint64
sys_open(void)
{
    800056de:	7131                	addi	sp,sp,-192
    800056e0:	fd06                	sd	ra,184(sp)
    800056e2:	f922                	sd	s0,176(sp)
    800056e4:	f526                	sd	s1,168(sp)
    800056e6:	f14a                	sd	s2,160(sp)
    800056e8:	ed4e                	sd	s3,152(sp)
    800056ea:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800056ec:	08000613          	li	a2,128
    800056f0:	f5040593          	addi	a1,s0,-176
    800056f4:	4501                	li	a0,0
    800056f6:	ffffd097          	auipc	ra,0xffffd
    800056fa:	468080e7          	jalr	1128(ra) # 80002b5e <argstr>
    return -1;
    800056fe:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005700:	0c054163          	bltz	a0,800057c2 <sys_open+0xe4>
    80005704:	f4c40593          	addi	a1,s0,-180
    80005708:	4505                	li	a0,1
    8000570a:	ffffd097          	auipc	ra,0xffffd
    8000570e:	410080e7          	jalr	1040(ra) # 80002b1a <argint>
    80005712:	0a054863          	bltz	a0,800057c2 <sys_open+0xe4>

  begin_op();
    80005716:	fffff097          	auipc	ra,0xfffff
    8000571a:	9e6080e7          	jalr	-1562(ra) # 800040fc <begin_op>

  if(omode & O_CREATE){
    8000571e:	f4c42783          	lw	a5,-180(s0)
    80005722:	2007f793          	andi	a5,a5,512
    80005726:	cbdd                	beqz	a5,800057dc <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005728:	4681                	li	a3,0
    8000572a:	4601                	li	a2,0
    8000572c:	4589                	li	a1,2
    8000572e:	f5040513          	addi	a0,s0,-176
    80005732:	00000097          	auipc	ra,0x0
    80005736:	974080e7          	jalr	-1676(ra) # 800050a6 <create>
    8000573a:	892a                	mv	s2,a0
    if(ip == 0){
    8000573c:	c959                	beqz	a0,800057d2 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000573e:	04491703          	lh	a4,68(s2)
    80005742:	478d                	li	a5,3
    80005744:	00f71763          	bne	a4,a5,80005752 <sys_open+0x74>
    80005748:	04695703          	lhu	a4,70(s2)
    8000574c:	47a5                	li	a5,9
    8000574e:	0ce7ec63          	bltu	a5,a4,80005826 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005752:	fffff097          	auipc	ra,0xfffff
    80005756:	dc0080e7          	jalr	-576(ra) # 80004512 <filealloc>
    8000575a:	89aa                	mv	s3,a0
    8000575c:	10050263          	beqz	a0,80005860 <sys_open+0x182>
    80005760:	00000097          	auipc	ra,0x0
    80005764:	904080e7          	jalr	-1788(ra) # 80005064 <fdalloc>
    80005768:	84aa                	mv	s1,a0
    8000576a:	0e054663          	bltz	a0,80005856 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000576e:	04491703          	lh	a4,68(s2)
    80005772:	478d                	li	a5,3
    80005774:	0cf70463          	beq	a4,a5,8000583c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005778:	4789                	li	a5,2
    8000577a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000577e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005782:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005786:	f4c42783          	lw	a5,-180(s0)
    8000578a:	0017c713          	xori	a4,a5,1
    8000578e:	8b05                	andi	a4,a4,1
    80005790:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005794:	0037f713          	andi	a4,a5,3
    80005798:	00e03733          	snez	a4,a4
    8000579c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800057a0:	4007f793          	andi	a5,a5,1024
    800057a4:	c791                	beqz	a5,800057b0 <sys_open+0xd2>
    800057a6:	04491703          	lh	a4,68(s2)
    800057aa:	4789                	li	a5,2
    800057ac:	08f70f63          	beq	a4,a5,8000584a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    800057b0:	854a                	mv	a0,s2
    800057b2:	ffffe097          	auipc	ra,0xffffe
    800057b6:	050080e7          	jalr	80(ra) # 80003802 <iunlock>
  end_op();
    800057ba:	fffff097          	auipc	ra,0xfffff
    800057be:	9c2080e7          	jalr	-1598(ra) # 8000417c <end_op>

  return fd;
}
    800057c2:	8526                	mv	a0,s1
    800057c4:	70ea                	ld	ra,184(sp)
    800057c6:	744a                	ld	s0,176(sp)
    800057c8:	74aa                	ld	s1,168(sp)
    800057ca:	790a                	ld	s2,160(sp)
    800057cc:	69ea                	ld	s3,152(sp)
    800057ce:	6129                	addi	sp,sp,192
    800057d0:	8082                	ret
      end_op();
    800057d2:	fffff097          	auipc	ra,0xfffff
    800057d6:	9aa080e7          	jalr	-1622(ra) # 8000417c <end_op>
      return -1;
    800057da:	b7e5                	j	800057c2 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800057dc:	f5040513          	addi	a0,s0,-176
    800057e0:	ffffe097          	auipc	ra,0xffffe
    800057e4:	710080e7          	jalr	1808(ra) # 80003ef0 <namei>
    800057e8:	892a                	mv	s2,a0
    800057ea:	c905                	beqz	a0,8000581a <sys_open+0x13c>
    ilock(ip);
    800057ec:	ffffe097          	auipc	ra,0xffffe
    800057f0:	f54080e7          	jalr	-172(ra) # 80003740 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800057f4:	04491703          	lh	a4,68(s2)
    800057f8:	4785                	li	a5,1
    800057fa:	f4f712e3          	bne	a4,a5,8000573e <sys_open+0x60>
    800057fe:	f4c42783          	lw	a5,-180(s0)
    80005802:	dba1                	beqz	a5,80005752 <sys_open+0x74>
      iunlockput(ip);
    80005804:	854a                	mv	a0,s2
    80005806:	ffffe097          	auipc	ra,0xffffe
    8000580a:	19c080e7          	jalr	412(ra) # 800039a2 <iunlockput>
      end_op();
    8000580e:	fffff097          	auipc	ra,0xfffff
    80005812:	96e080e7          	jalr	-1682(ra) # 8000417c <end_op>
      return -1;
    80005816:	54fd                	li	s1,-1
    80005818:	b76d                	j	800057c2 <sys_open+0xe4>
      end_op();
    8000581a:	fffff097          	auipc	ra,0xfffff
    8000581e:	962080e7          	jalr	-1694(ra) # 8000417c <end_op>
      return -1;
    80005822:	54fd                	li	s1,-1
    80005824:	bf79                	j	800057c2 <sys_open+0xe4>
    iunlockput(ip);
    80005826:	854a                	mv	a0,s2
    80005828:	ffffe097          	auipc	ra,0xffffe
    8000582c:	17a080e7          	jalr	378(ra) # 800039a2 <iunlockput>
    end_op();
    80005830:	fffff097          	auipc	ra,0xfffff
    80005834:	94c080e7          	jalr	-1716(ra) # 8000417c <end_op>
    return -1;
    80005838:	54fd                	li	s1,-1
    8000583a:	b761                	j	800057c2 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000583c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005840:	04691783          	lh	a5,70(s2)
    80005844:	02f99223          	sh	a5,36(s3)
    80005848:	bf2d                	j	80005782 <sys_open+0xa4>
    itrunc(ip);
    8000584a:	854a                	mv	a0,s2
    8000584c:	ffffe097          	auipc	ra,0xffffe
    80005850:	002080e7          	jalr	2(ra) # 8000384e <itrunc>
    80005854:	bfb1                	j	800057b0 <sys_open+0xd2>
      fileclose(f);
    80005856:	854e                	mv	a0,s3
    80005858:	fffff097          	auipc	ra,0xfffff
    8000585c:	d76080e7          	jalr	-650(ra) # 800045ce <fileclose>
    iunlockput(ip);
    80005860:	854a                	mv	a0,s2
    80005862:	ffffe097          	auipc	ra,0xffffe
    80005866:	140080e7          	jalr	320(ra) # 800039a2 <iunlockput>
    end_op();
    8000586a:	fffff097          	auipc	ra,0xfffff
    8000586e:	912080e7          	jalr	-1774(ra) # 8000417c <end_op>
    return -1;
    80005872:	54fd                	li	s1,-1
    80005874:	b7b9                	j	800057c2 <sys_open+0xe4>

0000000080005876 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005876:	7175                	addi	sp,sp,-144
    80005878:	e506                	sd	ra,136(sp)
    8000587a:	e122                	sd	s0,128(sp)
    8000587c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000587e:	fffff097          	auipc	ra,0xfffff
    80005882:	87e080e7          	jalr	-1922(ra) # 800040fc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005886:	08000613          	li	a2,128
    8000588a:	f7040593          	addi	a1,s0,-144
    8000588e:	4501                	li	a0,0
    80005890:	ffffd097          	auipc	ra,0xffffd
    80005894:	2ce080e7          	jalr	718(ra) # 80002b5e <argstr>
    80005898:	02054963          	bltz	a0,800058ca <sys_mkdir+0x54>
    8000589c:	4681                	li	a3,0
    8000589e:	4601                	li	a2,0
    800058a0:	4585                	li	a1,1
    800058a2:	f7040513          	addi	a0,s0,-144
    800058a6:	00000097          	auipc	ra,0x0
    800058aa:	800080e7          	jalr	-2048(ra) # 800050a6 <create>
    800058ae:	cd11                	beqz	a0,800058ca <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058b0:	ffffe097          	auipc	ra,0xffffe
    800058b4:	0f2080e7          	jalr	242(ra) # 800039a2 <iunlockput>
  end_op();
    800058b8:	fffff097          	auipc	ra,0xfffff
    800058bc:	8c4080e7          	jalr	-1852(ra) # 8000417c <end_op>
  return 0;
    800058c0:	4501                	li	a0,0
}
    800058c2:	60aa                	ld	ra,136(sp)
    800058c4:	640a                	ld	s0,128(sp)
    800058c6:	6149                	addi	sp,sp,144
    800058c8:	8082                	ret
    end_op();
    800058ca:	fffff097          	auipc	ra,0xfffff
    800058ce:	8b2080e7          	jalr	-1870(ra) # 8000417c <end_op>
    return -1;
    800058d2:	557d                	li	a0,-1
    800058d4:	b7fd                	j	800058c2 <sys_mkdir+0x4c>

00000000800058d6 <sys_mknod>:

uint64
sys_mknod(void)
{
    800058d6:	7135                	addi	sp,sp,-160
    800058d8:	ed06                	sd	ra,152(sp)
    800058da:	e922                	sd	s0,144(sp)
    800058dc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800058de:	fffff097          	auipc	ra,0xfffff
    800058e2:	81e080e7          	jalr	-2018(ra) # 800040fc <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800058e6:	08000613          	li	a2,128
    800058ea:	f7040593          	addi	a1,s0,-144
    800058ee:	4501                	li	a0,0
    800058f0:	ffffd097          	auipc	ra,0xffffd
    800058f4:	26e080e7          	jalr	622(ra) # 80002b5e <argstr>
    800058f8:	04054a63          	bltz	a0,8000594c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800058fc:	f6c40593          	addi	a1,s0,-148
    80005900:	4505                	li	a0,1
    80005902:	ffffd097          	auipc	ra,0xffffd
    80005906:	218080e7          	jalr	536(ra) # 80002b1a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000590a:	04054163          	bltz	a0,8000594c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    8000590e:	f6840593          	addi	a1,s0,-152
    80005912:	4509                	li	a0,2
    80005914:	ffffd097          	auipc	ra,0xffffd
    80005918:	206080e7          	jalr	518(ra) # 80002b1a <argint>
     argint(1, &major) < 0 ||
    8000591c:	02054863          	bltz	a0,8000594c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005920:	f6841683          	lh	a3,-152(s0)
    80005924:	f6c41603          	lh	a2,-148(s0)
    80005928:	458d                	li	a1,3
    8000592a:	f7040513          	addi	a0,s0,-144
    8000592e:	fffff097          	auipc	ra,0xfffff
    80005932:	778080e7          	jalr	1912(ra) # 800050a6 <create>
     argint(2, &minor) < 0 ||
    80005936:	c919                	beqz	a0,8000594c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005938:	ffffe097          	auipc	ra,0xffffe
    8000593c:	06a080e7          	jalr	106(ra) # 800039a2 <iunlockput>
  end_op();
    80005940:	fffff097          	auipc	ra,0xfffff
    80005944:	83c080e7          	jalr	-1988(ra) # 8000417c <end_op>
  return 0;
    80005948:	4501                	li	a0,0
    8000594a:	a031                	j	80005956 <sys_mknod+0x80>
    end_op();
    8000594c:	fffff097          	auipc	ra,0xfffff
    80005950:	830080e7          	jalr	-2000(ra) # 8000417c <end_op>
    return -1;
    80005954:	557d                	li	a0,-1
}
    80005956:	60ea                	ld	ra,152(sp)
    80005958:	644a                	ld	s0,144(sp)
    8000595a:	610d                	addi	sp,sp,160
    8000595c:	8082                	ret

000000008000595e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000595e:	7135                	addi	sp,sp,-160
    80005960:	ed06                	sd	ra,152(sp)
    80005962:	e922                	sd	s0,144(sp)
    80005964:	e526                	sd	s1,136(sp)
    80005966:	e14a                	sd	s2,128(sp)
    80005968:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000596a:	ffffc097          	auipc	ra,0xffffc
    8000596e:	0c4080e7          	jalr	196(ra) # 80001a2e <myproc>
    80005972:	892a                	mv	s2,a0
  
  begin_op();
    80005974:	ffffe097          	auipc	ra,0xffffe
    80005978:	788080e7          	jalr	1928(ra) # 800040fc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000597c:	08000613          	li	a2,128
    80005980:	f6040593          	addi	a1,s0,-160
    80005984:	4501                	li	a0,0
    80005986:	ffffd097          	auipc	ra,0xffffd
    8000598a:	1d8080e7          	jalr	472(ra) # 80002b5e <argstr>
    8000598e:	04054b63          	bltz	a0,800059e4 <sys_chdir+0x86>
    80005992:	f6040513          	addi	a0,s0,-160
    80005996:	ffffe097          	auipc	ra,0xffffe
    8000599a:	55a080e7          	jalr	1370(ra) # 80003ef0 <namei>
    8000599e:	84aa                	mv	s1,a0
    800059a0:	c131                	beqz	a0,800059e4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800059a2:	ffffe097          	auipc	ra,0xffffe
    800059a6:	d9e080e7          	jalr	-610(ra) # 80003740 <ilock>
  if(ip->type != T_DIR){
    800059aa:	04449703          	lh	a4,68(s1)
    800059ae:	4785                	li	a5,1
    800059b0:	04f71063          	bne	a4,a5,800059f0 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800059b4:	8526                	mv	a0,s1
    800059b6:	ffffe097          	auipc	ra,0xffffe
    800059ba:	e4c080e7          	jalr	-436(ra) # 80003802 <iunlock>
  iput(p->cwd);
    800059be:	15093503          	ld	a0,336(s2)
    800059c2:	ffffe097          	auipc	ra,0xffffe
    800059c6:	f38080e7          	jalr	-200(ra) # 800038fa <iput>
  end_op();
    800059ca:	ffffe097          	auipc	ra,0xffffe
    800059ce:	7b2080e7          	jalr	1970(ra) # 8000417c <end_op>
  p->cwd = ip;
    800059d2:	14993823          	sd	s1,336(s2)
  return 0;
    800059d6:	4501                	li	a0,0
}
    800059d8:	60ea                	ld	ra,152(sp)
    800059da:	644a                	ld	s0,144(sp)
    800059dc:	64aa                	ld	s1,136(sp)
    800059de:	690a                	ld	s2,128(sp)
    800059e0:	610d                	addi	sp,sp,160
    800059e2:	8082                	ret
    end_op();
    800059e4:	ffffe097          	auipc	ra,0xffffe
    800059e8:	798080e7          	jalr	1944(ra) # 8000417c <end_op>
    return -1;
    800059ec:	557d                	li	a0,-1
    800059ee:	b7ed                	j	800059d8 <sys_chdir+0x7a>
    iunlockput(ip);
    800059f0:	8526                	mv	a0,s1
    800059f2:	ffffe097          	auipc	ra,0xffffe
    800059f6:	fb0080e7          	jalr	-80(ra) # 800039a2 <iunlockput>
    end_op();
    800059fa:	ffffe097          	auipc	ra,0xffffe
    800059fe:	782080e7          	jalr	1922(ra) # 8000417c <end_op>
    return -1;
    80005a02:	557d                	li	a0,-1
    80005a04:	bfd1                	j	800059d8 <sys_chdir+0x7a>

0000000080005a06 <sys_exec>:

uint64
sys_exec(void)
{
    80005a06:	7145                	addi	sp,sp,-464
    80005a08:	e786                	sd	ra,456(sp)
    80005a0a:	e3a2                	sd	s0,448(sp)
    80005a0c:	ff26                	sd	s1,440(sp)
    80005a0e:	fb4a                	sd	s2,432(sp)
    80005a10:	f74e                	sd	s3,424(sp)
    80005a12:	f352                	sd	s4,416(sp)
    80005a14:	ef56                	sd	s5,408(sp)
    80005a16:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005a18:	08000613          	li	a2,128
    80005a1c:	f4040593          	addi	a1,s0,-192
    80005a20:	4501                	li	a0,0
    80005a22:	ffffd097          	auipc	ra,0xffffd
    80005a26:	13c080e7          	jalr	316(ra) # 80002b5e <argstr>
    return -1;
    80005a2a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005a2c:	0c054a63          	bltz	a0,80005b00 <sys_exec+0xfa>
    80005a30:	e3840593          	addi	a1,s0,-456
    80005a34:	4505                	li	a0,1
    80005a36:	ffffd097          	auipc	ra,0xffffd
    80005a3a:	106080e7          	jalr	262(ra) # 80002b3c <argaddr>
    80005a3e:	0c054163          	bltz	a0,80005b00 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005a42:	10000613          	li	a2,256
    80005a46:	4581                	li	a1,0
    80005a48:	e4040513          	addi	a0,s0,-448
    80005a4c:	ffffb097          	auipc	ra,0xffffb
    80005a50:	312080e7          	jalr	786(ra) # 80000d5e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005a54:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005a58:	89a6                	mv	s3,s1
    80005a5a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005a5c:	02000a13          	li	s4,32
    80005a60:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a64:	00391793          	slli	a5,s2,0x3
    80005a68:	e3040593          	addi	a1,s0,-464
    80005a6c:	e3843503          	ld	a0,-456(s0)
    80005a70:	953e                	add	a0,a0,a5
    80005a72:	ffffd097          	auipc	ra,0xffffd
    80005a76:	00e080e7          	jalr	14(ra) # 80002a80 <fetchaddr>
    80005a7a:	02054a63          	bltz	a0,80005aae <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005a7e:	e3043783          	ld	a5,-464(s0)
    80005a82:	c3b9                	beqz	a5,80005ac8 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005a84:	ffffb097          	auipc	ra,0xffffb
    80005a88:	0ee080e7          	jalr	238(ra) # 80000b72 <kalloc>
    80005a8c:	85aa                	mv	a1,a0
    80005a8e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005a92:	cd11                	beqz	a0,80005aae <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005a94:	6605                	lui	a2,0x1
    80005a96:	e3043503          	ld	a0,-464(s0)
    80005a9a:	ffffd097          	auipc	ra,0xffffd
    80005a9e:	038080e7          	jalr	56(ra) # 80002ad2 <fetchstr>
    80005aa2:	00054663          	bltz	a0,80005aae <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005aa6:	0905                	addi	s2,s2,1
    80005aa8:	09a1                	addi	s3,s3,8
    80005aaa:	fb491be3          	bne	s2,s4,80005a60 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005aae:	10048913          	addi	s2,s1,256
    80005ab2:	6088                	ld	a0,0(s1)
    80005ab4:	c529                	beqz	a0,80005afe <sys_exec+0xf8>
    kfree(argv[i]);
    80005ab6:	ffffb097          	auipc	ra,0xffffb
    80005aba:	fc0080e7          	jalr	-64(ra) # 80000a76 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005abe:	04a1                	addi	s1,s1,8
    80005ac0:	ff2499e3          	bne	s1,s2,80005ab2 <sys_exec+0xac>
  return -1;
    80005ac4:	597d                	li	s2,-1
    80005ac6:	a82d                	j	80005b00 <sys_exec+0xfa>
      argv[i] = 0;
    80005ac8:	0a8e                	slli	s5,s5,0x3
    80005aca:	fc040793          	addi	a5,s0,-64
    80005ace:	9abe                	add	s5,s5,a5
    80005ad0:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd7e80>
  int ret = exec(path, argv);
    80005ad4:	e4040593          	addi	a1,s0,-448
    80005ad8:	f4040513          	addi	a0,s0,-192
    80005adc:	fffff097          	auipc	ra,0xfffff
    80005ae0:	178080e7          	jalr	376(ra) # 80004c54 <exec>
    80005ae4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ae6:	10048993          	addi	s3,s1,256
    80005aea:	6088                	ld	a0,0(s1)
    80005aec:	c911                	beqz	a0,80005b00 <sys_exec+0xfa>
    kfree(argv[i]);
    80005aee:	ffffb097          	auipc	ra,0xffffb
    80005af2:	f88080e7          	jalr	-120(ra) # 80000a76 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005af6:	04a1                	addi	s1,s1,8
    80005af8:	ff3499e3          	bne	s1,s3,80005aea <sys_exec+0xe4>
    80005afc:	a011                	j	80005b00 <sys_exec+0xfa>
  return -1;
    80005afe:	597d                	li	s2,-1
}
    80005b00:	854a                	mv	a0,s2
    80005b02:	60be                	ld	ra,456(sp)
    80005b04:	641e                	ld	s0,448(sp)
    80005b06:	74fa                	ld	s1,440(sp)
    80005b08:	795a                	ld	s2,432(sp)
    80005b0a:	79ba                	ld	s3,424(sp)
    80005b0c:	7a1a                	ld	s4,416(sp)
    80005b0e:	6afa                	ld	s5,408(sp)
    80005b10:	6179                	addi	sp,sp,464
    80005b12:	8082                	ret

0000000080005b14 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b14:	7139                	addi	sp,sp,-64
    80005b16:	fc06                	sd	ra,56(sp)
    80005b18:	f822                	sd	s0,48(sp)
    80005b1a:	f426                	sd	s1,40(sp)
    80005b1c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005b1e:	ffffc097          	auipc	ra,0xffffc
    80005b22:	f10080e7          	jalr	-240(ra) # 80001a2e <myproc>
    80005b26:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005b28:	fd840593          	addi	a1,s0,-40
    80005b2c:	4501                	li	a0,0
    80005b2e:	ffffd097          	auipc	ra,0xffffd
    80005b32:	00e080e7          	jalr	14(ra) # 80002b3c <argaddr>
    return -1;
    80005b36:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005b38:	0e054063          	bltz	a0,80005c18 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005b3c:	fc840593          	addi	a1,s0,-56
    80005b40:	fd040513          	addi	a0,s0,-48
    80005b44:	fffff097          	auipc	ra,0xfffff
    80005b48:	de0080e7          	jalr	-544(ra) # 80004924 <pipealloc>
    return -1;
    80005b4c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005b4e:	0c054563          	bltz	a0,80005c18 <sys_pipe+0x104>
  fd0 = -1;
    80005b52:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005b56:	fd043503          	ld	a0,-48(s0)
    80005b5a:	fffff097          	auipc	ra,0xfffff
    80005b5e:	50a080e7          	jalr	1290(ra) # 80005064 <fdalloc>
    80005b62:	fca42223          	sw	a0,-60(s0)
    80005b66:	08054c63          	bltz	a0,80005bfe <sys_pipe+0xea>
    80005b6a:	fc843503          	ld	a0,-56(s0)
    80005b6e:	fffff097          	auipc	ra,0xfffff
    80005b72:	4f6080e7          	jalr	1270(ra) # 80005064 <fdalloc>
    80005b76:	fca42023          	sw	a0,-64(s0)
    80005b7a:	06054863          	bltz	a0,80005bea <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b7e:	4691                	li	a3,4
    80005b80:	fc440613          	addi	a2,s0,-60
    80005b84:	fd843583          	ld	a1,-40(s0)
    80005b88:	68a8                	ld	a0,80(s1)
    80005b8a:	ffffc097          	auipc	ra,0xffffc
    80005b8e:	b96080e7          	jalr	-1130(ra) # 80001720 <copyout>
    80005b92:	02054063          	bltz	a0,80005bb2 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005b96:	4691                	li	a3,4
    80005b98:	fc040613          	addi	a2,s0,-64
    80005b9c:	fd843583          	ld	a1,-40(s0)
    80005ba0:	0591                	addi	a1,a1,4
    80005ba2:	68a8                	ld	a0,80(s1)
    80005ba4:	ffffc097          	auipc	ra,0xffffc
    80005ba8:	b7c080e7          	jalr	-1156(ra) # 80001720 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005bac:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005bae:	06055563          	bgez	a0,80005c18 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005bb2:	fc442783          	lw	a5,-60(s0)
    80005bb6:	07e9                	addi	a5,a5,26
    80005bb8:	078e                	slli	a5,a5,0x3
    80005bba:	97a6                	add	a5,a5,s1
    80005bbc:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005bc0:	fc042503          	lw	a0,-64(s0)
    80005bc4:	0569                	addi	a0,a0,26
    80005bc6:	050e                	slli	a0,a0,0x3
    80005bc8:	9526                	add	a0,a0,s1
    80005bca:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005bce:	fd043503          	ld	a0,-48(s0)
    80005bd2:	fffff097          	auipc	ra,0xfffff
    80005bd6:	9fc080e7          	jalr	-1540(ra) # 800045ce <fileclose>
    fileclose(wf);
    80005bda:	fc843503          	ld	a0,-56(s0)
    80005bde:	fffff097          	auipc	ra,0xfffff
    80005be2:	9f0080e7          	jalr	-1552(ra) # 800045ce <fileclose>
    return -1;
    80005be6:	57fd                	li	a5,-1
    80005be8:	a805                	j	80005c18 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005bea:	fc442783          	lw	a5,-60(s0)
    80005bee:	0007c863          	bltz	a5,80005bfe <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005bf2:	01a78513          	addi	a0,a5,26
    80005bf6:	050e                	slli	a0,a0,0x3
    80005bf8:	9526                	add	a0,a0,s1
    80005bfa:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005bfe:	fd043503          	ld	a0,-48(s0)
    80005c02:	fffff097          	auipc	ra,0xfffff
    80005c06:	9cc080e7          	jalr	-1588(ra) # 800045ce <fileclose>
    fileclose(wf);
    80005c0a:	fc843503          	ld	a0,-56(s0)
    80005c0e:	fffff097          	auipc	ra,0xfffff
    80005c12:	9c0080e7          	jalr	-1600(ra) # 800045ce <fileclose>
    return -1;
    80005c16:	57fd                	li	a5,-1
}
    80005c18:	853e                	mv	a0,a5
    80005c1a:	70e2                	ld	ra,56(sp)
    80005c1c:	7442                	ld	s0,48(sp)
    80005c1e:	74a2                	ld	s1,40(sp)
    80005c20:	6121                	addi	sp,sp,64
    80005c22:	8082                	ret
	...

0000000080005c30 <kernelvec>:
    80005c30:	7111                	addi	sp,sp,-256
    80005c32:	e006                	sd	ra,0(sp)
    80005c34:	e40a                	sd	sp,8(sp)
    80005c36:	e80e                	sd	gp,16(sp)
    80005c38:	ec12                	sd	tp,24(sp)
    80005c3a:	f016                	sd	t0,32(sp)
    80005c3c:	f41a                	sd	t1,40(sp)
    80005c3e:	f81e                	sd	t2,48(sp)
    80005c40:	fc22                	sd	s0,56(sp)
    80005c42:	e0a6                	sd	s1,64(sp)
    80005c44:	e4aa                	sd	a0,72(sp)
    80005c46:	e8ae                	sd	a1,80(sp)
    80005c48:	ecb2                	sd	a2,88(sp)
    80005c4a:	f0b6                	sd	a3,96(sp)
    80005c4c:	f4ba                	sd	a4,104(sp)
    80005c4e:	f8be                	sd	a5,112(sp)
    80005c50:	fcc2                	sd	a6,120(sp)
    80005c52:	e146                	sd	a7,128(sp)
    80005c54:	e54a                	sd	s2,136(sp)
    80005c56:	e94e                	sd	s3,144(sp)
    80005c58:	ed52                	sd	s4,152(sp)
    80005c5a:	f156                	sd	s5,160(sp)
    80005c5c:	f55a                	sd	s6,168(sp)
    80005c5e:	f95e                	sd	s7,176(sp)
    80005c60:	fd62                	sd	s8,184(sp)
    80005c62:	e1e6                	sd	s9,192(sp)
    80005c64:	e5ea                	sd	s10,200(sp)
    80005c66:	e9ee                	sd	s11,208(sp)
    80005c68:	edf2                	sd	t3,216(sp)
    80005c6a:	f1f6                	sd	t4,224(sp)
    80005c6c:	f5fa                	sd	t5,232(sp)
    80005c6e:	f9fe                	sd	t6,240(sp)
    80005c70:	cddfc0ef          	jal	ra,8000294c <kerneltrap>
    80005c74:	6082                	ld	ra,0(sp)
    80005c76:	6122                	ld	sp,8(sp)
    80005c78:	61c2                	ld	gp,16(sp)
    80005c7a:	7282                	ld	t0,32(sp)
    80005c7c:	7322                	ld	t1,40(sp)
    80005c7e:	73c2                	ld	t2,48(sp)
    80005c80:	7462                	ld	s0,56(sp)
    80005c82:	6486                	ld	s1,64(sp)
    80005c84:	6526                	ld	a0,72(sp)
    80005c86:	65c6                	ld	a1,80(sp)
    80005c88:	6666                	ld	a2,88(sp)
    80005c8a:	7686                	ld	a3,96(sp)
    80005c8c:	7726                	ld	a4,104(sp)
    80005c8e:	77c6                	ld	a5,112(sp)
    80005c90:	7866                	ld	a6,120(sp)
    80005c92:	688a                	ld	a7,128(sp)
    80005c94:	692a                	ld	s2,136(sp)
    80005c96:	69ca                	ld	s3,144(sp)
    80005c98:	6a6a                	ld	s4,152(sp)
    80005c9a:	7a8a                	ld	s5,160(sp)
    80005c9c:	7b2a                	ld	s6,168(sp)
    80005c9e:	7bca                	ld	s7,176(sp)
    80005ca0:	7c6a                	ld	s8,184(sp)
    80005ca2:	6c8e                	ld	s9,192(sp)
    80005ca4:	6d2e                	ld	s10,200(sp)
    80005ca6:	6dce                	ld	s11,208(sp)
    80005ca8:	6e6e                	ld	t3,216(sp)
    80005caa:	7e8e                	ld	t4,224(sp)
    80005cac:	7f2e                	ld	t5,232(sp)
    80005cae:	7fce                	ld	t6,240(sp)
    80005cb0:	6111                	addi	sp,sp,256
    80005cb2:	10200073          	sret
    80005cb6:	00000013          	nop
    80005cba:	00000013          	nop
    80005cbe:	0001                	nop

0000000080005cc0 <timervec>:
    80005cc0:	34051573          	csrrw	a0,mscratch,a0
    80005cc4:	e10c                	sd	a1,0(a0)
    80005cc6:	e510                	sd	a2,8(a0)
    80005cc8:	e914                	sd	a3,16(a0)
    80005cca:	710c                	ld	a1,32(a0)
    80005ccc:	7510                	ld	a2,40(a0)
    80005cce:	6194                	ld	a3,0(a1)
    80005cd0:	96b2                	add	a3,a3,a2
    80005cd2:	e194                	sd	a3,0(a1)
    80005cd4:	4589                	li	a1,2
    80005cd6:	14459073          	csrw	sip,a1
    80005cda:	6914                	ld	a3,16(a0)
    80005cdc:	6510                	ld	a2,8(a0)
    80005cde:	610c                	ld	a1,0(a0)
    80005ce0:	34051573          	csrrw	a0,mscratch,a0
    80005ce4:	30200073          	mret
	...

0000000080005cea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005cea:	1141                	addi	sp,sp,-16
    80005cec:	e422                	sd	s0,8(sp)
    80005cee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005cf0:	0c0007b7          	lui	a5,0xc000
    80005cf4:	4705                	li	a4,1
    80005cf6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005cf8:	c3d8                	sw	a4,4(a5)
}
    80005cfa:	6422                	ld	s0,8(sp)
    80005cfc:	0141                	addi	sp,sp,16
    80005cfe:	8082                	ret

0000000080005d00 <plicinithart>:

void
plicinithart(void)
{
    80005d00:	1141                	addi	sp,sp,-16
    80005d02:	e406                	sd	ra,8(sp)
    80005d04:	e022                	sd	s0,0(sp)
    80005d06:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005d08:	ffffc097          	auipc	ra,0xffffc
    80005d0c:	cfa080e7          	jalr	-774(ra) # 80001a02 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005d10:	0085171b          	slliw	a4,a0,0x8
    80005d14:	0c0027b7          	lui	a5,0xc002
    80005d18:	97ba                	add	a5,a5,a4
    80005d1a:	40200713          	li	a4,1026
    80005d1e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005d22:	00d5151b          	slliw	a0,a0,0xd
    80005d26:	0c2017b7          	lui	a5,0xc201
    80005d2a:	953e                	add	a0,a0,a5
    80005d2c:	00052023          	sw	zero,0(a0)
}
    80005d30:	60a2                	ld	ra,8(sp)
    80005d32:	6402                	ld	s0,0(sp)
    80005d34:	0141                	addi	sp,sp,16
    80005d36:	8082                	ret

0000000080005d38 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005d38:	1141                	addi	sp,sp,-16
    80005d3a:	e406                	sd	ra,8(sp)
    80005d3c:	e022                	sd	s0,0(sp)
    80005d3e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005d40:	ffffc097          	auipc	ra,0xffffc
    80005d44:	cc2080e7          	jalr	-830(ra) # 80001a02 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005d48:	00d5179b          	slliw	a5,a0,0xd
    80005d4c:	0c201537          	lui	a0,0xc201
    80005d50:	953e                	add	a0,a0,a5
  return irq;
}
    80005d52:	4148                	lw	a0,4(a0)
    80005d54:	60a2                	ld	ra,8(sp)
    80005d56:	6402                	ld	s0,0(sp)
    80005d58:	0141                	addi	sp,sp,16
    80005d5a:	8082                	ret

0000000080005d5c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005d5c:	1101                	addi	sp,sp,-32
    80005d5e:	ec06                	sd	ra,24(sp)
    80005d60:	e822                	sd	s0,16(sp)
    80005d62:	e426                	sd	s1,8(sp)
    80005d64:	1000                	addi	s0,sp,32
    80005d66:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005d68:	ffffc097          	auipc	ra,0xffffc
    80005d6c:	c9a080e7          	jalr	-870(ra) # 80001a02 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005d70:	00d5151b          	slliw	a0,a0,0xd
    80005d74:	0c2017b7          	lui	a5,0xc201
    80005d78:	97aa                	add	a5,a5,a0
    80005d7a:	c3c4                	sw	s1,4(a5)
}
    80005d7c:	60e2                	ld	ra,24(sp)
    80005d7e:	6442                	ld	s0,16(sp)
    80005d80:	64a2                	ld	s1,8(sp)
    80005d82:	6105                	addi	sp,sp,32
    80005d84:	8082                	ret

0000000080005d86 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005d86:	1141                	addi	sp,sp,-16
    80005d88:	e406                	sd	ra,8(sp)
    80005d8a:	e022                	sd	s0,0(sp)
    80005d8c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005d8e:	479d                	li	a5,7
    80005d90:	04a7cc63          	blt	a5,a0,80005de8 <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005d94:	0001e797          	auipc	a5,0x1e
    80005d98:	26c78793          	addi	a5,a5,620 # 80024000 <disk>
    80005d9c:	00a78733          	add	a4,a5,a0
    80005da0:	6789                	lui	a5,0x2
    80005da2:	97ba                	add	a5,a5,a4
    80005da4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005da8:	eba1                	bnez	a5,80005df8 <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005daa:	00451713          	slli	a4,a0,0x4
    80005dae:	00020797          	auipc	a5,0x20
    80005db2:	2527b783          	ld	a5,594(a5) # 80026000 <disk+0x2000>
    80005db6:	97ba                	add	a5,a5,a4
    80005db8:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005dbc:	0001e797          	auipc	a5,0x1e
    80005dc0:	24478793          	addi	a5,a5,580 # 80024000 <disk>
    80005dc4:	97aa                	add	a5,a5,a0
    80005dc6:	6509                	lui	a0,0x2
    80005dc8:	953e                	add	a0,a0,a5
    80005dca:	4785                	li	a5,1
    80005dcc:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005dd0:	00020517          	auipc	a0,0x20
    80005dd4:	24850513          	addi	a0,a0,584 # 80026018 <disk+0x2018>
    80005dd8:	ffffc097          	auipc	ra,0xffffc
    80005ddc:	5f6080e7          	jalr	1526(ra) # 800023ce <wakeup>
}
    80005de0:	60a2                	ld	ra,8(sp)
    80005de2:	6402                	ld	s0,0(sp)
    80005de4:	0141                	addi	sp,sp,16
    80005de6:	8082                	ret
    panic("virtio_disk_intr 1");
    80005de8:	00003517          	auipc	a0,0x3
    80005dec:	98850513          	addi	a0,a0,-1656 # 80008770 <syscalls+0x340>
    80005df0:	ffffa097          	auipc	ra,0xffffa
    80005df4:	7e0080e7          	jalr	2016(ra) # 800005d0 <panic>
    panic("virtio_disk_intr 2");
    80005df8:	00003517          	auipc	a0,0x3
    80005dfc:	99050513          	addi	a0,a0,-1648 # 80008788 <syscalls+0x358>
    80005e00:	ffffa097          	auipc	ra,0xffffa
    80005e04:	7d0080e7          	jalr	2000(ra) # 800005d0 <panic>

0000000080005e08 <virtio_disk_init>:
{
    80005e08:	1101                	addi	sp,sp,-32
    80005e0a:	ec06                	sd	ra,24(sp)
    80005e0c:	e822                	sd	s0,16(sp)
    80005e0e:	e426                	sd	s1,8(sp)
    80005e10:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005e12:	00003597          	auipc	a1,0x3
    80005e16:	98e58593          	addi	a1,a1,-1650 # 800087a0 <syscalls+0x370>
    80005e1a:	00020517          	auipc	a0,0x20
    80005e1e:	28e50513          	addi	a0,a0,654 # 800260a8 <disk+0x20a8>
    80005e22:	ffffb097          	auipc	ra,0xffffb
    80005e26:	db0080e7          	jalr	-592(ra) # 80000bd2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e2a:	100017b7          	lui	a5,0x10001
    80005e2e:	4398                	lw	a4,0(a5)
    80005e30:	2701                	sext.w	a4,a4
    80005e32:	747277b7          	lui	a5,0x74727
    80005e36:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005e3a:	0ef71163          	bne	a4,a5,80005f1c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005e3e:	100017b7          	lui	a5,0x10001
    80005e42:	43dc                	lw	a5,4(a5)
    80005e44:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e46:	4705                	li	a4,1
    80005e48:	0ce79a63          	bne	a5,a4,80005f1c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e4c:	100017b7          	lui	a5,0x10001
    80005e50:	479c                	lw	a5,8(a5)
    80005e52:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005e54:	4709                	li	a4,2
    80005e56:	0ce79363          	bne	a5,a4,80005f1c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005e5a:	100017b7          	lui	a5,0x10001
    80005e5e:	47d8                	lw	a4,12(a5)
    80005e60:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e62:	554d47b7          	lui	a5,0x554d4
    80005e66:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005e6a:	0af71963          	bne	a4,a5,80005f1c <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e6e:	100017b7          	lui	a5,0x10001
    80005e72:	4705                	li	a4,1
    80005e74:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e76:	470d                	li	a4,3
    80005e78:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005e7a:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005e7c:	c7ffe737          	lui	a4,0xc7ffe
    80005e80:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd775f>
    80005e84:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e86:	2701                	sext.w	a4,a4
    80005e88:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e8a:	472d                	li	a4,11
    80005e8c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e8e:	473d                	li	a4,15
    80005e90:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005e92:	6705                	lui	a4,0x1
    80005e94:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e96:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005e9a:	5bdc                	lw	a5,52(a5)
    80005e9c:	2781                	sext.w	a5,a5
  if(max == 0)
    80005e9e:	c7d9                	beqz	a5,80005f2c <virtio_disk_init+0x124>
  if(max < NUM)
    80005ea0:	471d                	li	a4,7
    80005ea2:	08f77d63          	bgeu	a4,a5,80005f3c <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005ea6:	100014b7          	lui	s1,0x10001
    80005eaa:	47a1                	li	a5,8
    80005eac:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005eae:	6609                	lui	a2,0x2
    80005eb0:	4581                	li	a1,0
    80005eb2:	0001e517          	auipc	a0,0x1e
    80005eb6:	14e50513          	addi	a0,a0,334 # 80024000 <disk>
    80005eba:	ffffb097          	auipc	ra,0xffffb
    80005ebe:	ea4080e7          	jalr	-348(ra) # 80000d5e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005ec2:	0001e717          	auipc	a4,0x1e
    80005ec6:	13e70713          	addi	a4,a4,318 # 80024000 <disk>
    80005eca:	00c75793          	srli	a5,a4,0xc
    80005ece:	2781                	sext.w	a5,a5
    80005ed0:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005ed2:	00020797          	auipc	a5,0x20
    80005ed6:	12e78793          	addi	a5,a5,302 # 80026000 <disk+0x2000>
    80005eda:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005edc:	0001e717          	auipc	a4,0x1e
    80005ee0:	1a470713          	addi	a4,a4,420 # 80024080 <disk+0x80>
    80005ee4:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005ee6:	0001f717          	auipc	a4,0x1f
    80005eea:	11a70713          	addi	a4,a4,282 # 80025000 <disk+0x1000>
    80005eee:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005ef0:	4705                	li	a4,1
    80005ef2:	00e78c23          	sb	a4,24(a5)
    80005ef6:	00e78ca3          	sb	a4,25(a5)
    80005efa:	00e78d23          	sb	a4,26(a5)
    80005efe:	00e78da3          	sb	a4,27(a5)
    80005f02:	00e78e23          	sb	a4,28(a5)
    80005f06:	00e78ea3          	sb	a4,29(a5)
    80005f0a:	00e78f23          	sb	a4,30(a5)
    80005f0e:	00e78fa3          	sb	a4,31(a5)
}
    80005f12:	60e2                	ld	ra,24(sp)
    80005f14:	6442                	ld	s0,16(sp)
    80005f16:	64a2                	ld	s1,8(sp)
    80005f18:	6105                	addi	sp,sp,32
    80005f1a:	8082                	ret
    panic("could not find virtio disk");
    80005f1c:	00003517          	auipc	a0,0x3
    80005f20:	89450513          	addi	a0,a0,-1900 # 800087b0 <syscalls+0x380>
    80005f24:	ffffa097          	auipc	ra,0xffffa
    80005f28:	6ac080e7          	jalr	1708(ra) # 800005d0 <panic>
    panic("virtio disk has no queue 0");
    80005f2c:	00003517          	auipc	a0,0x3
    80005f30:	8a450513          	addi	a0,a0,-1884 # 800087d0 <syscalls+0x3a0>
    80005f34:	ffffa097          	auipc	ra,0xffffa
    80005f38:	69c080e7          	jalr	1692(ra) # 800005d0 <panic>
    panic("virtio disk max queue too short");
    80005f3c:	00003517          	auipc	a0,0x3
    80005f40:	8b450513          	addi	a0,a0,-1868 # 800087f0 <syscalls+0x3c0>
    80005f44:	ffffa097          	auipc	ra,0xffffa
    80005f48:	68c080e7          	jalr	1676(ra) # 800005d0 <panic>

0000000080005f4c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005f4c:	7175                	addi	sp,sp,-144
    80005f4e:	e506                	sd	ra,136(sp)
    80005f50:	e122                	sd	s0,128(sp)
    80005f52:	fca6                	sd	s1,120(sp)
    80005f54:	f8ca                	sd	s2,112(sp)
    80005f56:	f4ce                	sd	s3,104(sp)
    80005f58:	f0d2                	sd	s4,96(sp)
    80005f5a:	ecd6                	sd	s5,88(sp)
    80005f5c:	e8da                	sd	s6,80(sp)
    80005f5e:	e4de                	sd	s7,72(sp)
    80005f60:	e0e2                	sd	s8,64(sp)
    80005f62:	fc66                	sd	s9,56(sp)
    80005f64:	f86a                	sd	s10,48(sp)
    80005f66:	f46e                	sd	s11,40(sp)
    80005f68:	0900                	addi	s0,sp,144
    80005f6a:	8aaa                	mv	s5,a0
    80005f6c:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005f6e:	00c52c83          	lw	s9,12(a0)
    80005f72:	001c9c9b          	slliw	s9,s9,0x1
    80005f76:	1c82                	slli	s9,s9,0x20
    80005f78:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005f7c:	00020517          	auipc	a0,0x20
    80005f80:	12c50513          	addi	a0,a0,300 # 800260a8 <disk+0x20a8>
    80005f84:	ffffb097          	auipc	ra,0xffffb
    80005f88:	cde080e7          	jalr	-802(ra) # 80000c62 <acquire>
  for(int i = 0; i < 3; i++){
    80005f8c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005f8e:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005f90:	0001ec17          	auipc	s8,0x1e
    80005f94:	070c0c13          	addi	s8,s8,112 # 80024000 <disk>
    80005f98:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005f9a:	4b0d                	li	s6,3
    80005f9c:	a0ad                	j	80006006 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005f9e:	00fc0733          	add	a4,s8,a5
    80005fa2:	975e                	add	a4,a4,s7
    80005fa4:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005fa8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005faa:	0207c563          	bltz	a5,80005fd4 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005fae:	2905                	addiw	s2,s2,1
    80005fb0:	0611                	addi	a2,a2,4
    80005fb2:	19690d63          	beq	s2,s6,8000614c <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80005fb6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005fb8:	00020717          	auipc	a4,0x20
    80005fbc:	06070713          	addi	a4,a4,96 # 80026018 <disk+0x2018>
    80005fc0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005fc2:	00074683          	lbu	a3,0(a4)
    80005fc6:	fee1                	bnez	a3,80005f9e <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005fc8:	2785                	addiw	a5,a5,1
    80005fca:	0705                	addi	a4,a4,1
    80005fcc:	fe979be3          	bne	a5,s1,80005fc2 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005fd0:	57fd                	li	a5,-1
    80005fd2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005fd4:	01205d63          	blez	s2,80005fee <virtio_disk_rw+0xa2>
    80005fd8:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005fda:	000a2503          	lw	a0,0(s4)
    80005fde:	00000097          	auipc	ra,0x0
    80005fe2:	da8080e7          	jalr	-600(ra) # 80005d86 <free_desc>
      for(int j = 0; j < i; j++)
    80005fe6:	2d85                	addiw	s11,s11,1
    80005fe8:	0a11                	addi	s4,s4,4
    80005fea:	ffb918e3          	bne	s2,s11,80005fda <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005fee:	00020597          	auipc	a1,0x20
    80005ff2:	0ba58593          	addi	a1,a1,186 # 800260a8 <disk+0x20a8>
    80005ff6:	00020517          	auipc	a0,0x20
    80005ffa:	02250513          	addi	a0,a0,34 # 80026018 <disk+0x2018>
    80005ffe:	ffffc097          	auipc	ra,0xffffc
    80006002:	250080e7          	jalr	592(ra) # 8000224e <sleep>
  for(int i = 0; i < 3; i++){
    80006006:	f8040a13          	addi	s4,s0,-128
{
    8000600a:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000600c:	894e                	mv	s2,s3
    8000600e:	b765                	j	80005fb6 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006010:	00020717          	auipc	a4,0x20
    80006014:	ff073703          	ld	a4,-16(a4) # 80026000 <disk+0x2000>
    80006018:	973e                	add	a4,a4,a5
    8000601a:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000601e:	0001e517          	auipc	a0,0x1e
    80006022:	fe250513          	addi	a0,a0,-30 # 80024000 <disk>
    80006026:	00020717          	auipc	a4,0x20
    8000602a:	fda70713          	addi	a4,a4,-38 # 80026000 <disk+0x2000>
    8000602e:	6314                	ld	a3,0(a4)
    80006030:	96be                	add	a3,a3,a5
    80006032:	00c6d603          	lhu	a2,12(a3)
    80006036:	00166613          	ori	a2,a2,1
    8000603a:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000603e:	f8842683          	lw	a3,-120(s0)
    80006042:	6310                	ld	a2,0(a4)
    80006044:	97b2                	add	a5,a5,a2
    80006046:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    8000604a:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    8000604e:	0612                	slli	a2,a2,0x4
    80006050:	962a                	add	a2,a2,a0
    80006052:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006056:	00469793          	slli	a5,a3,0x4
    8000605a:	630c                	ld	a1,0(a4)
    8000605c:	95be                	add	a1,a1,a5
    8000605e:	6689                	lui	a3,0x2
    80006060:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80006064:	96ca                	add	a3,a3,s2
    80006066:	96aa                	add	a3,a3,a0
    80006068:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    8000606a:	6314                	ld	a3,0(a4)
    8000606c:	96be                	add	a3,a3,a5
    8000606e:	4585                	li	a1,1
    80006070:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006072:	6314                	ld	a3,0(a4)
    80006074:	96be                	add	a3,a3,a5
    80006076:	4509                	li	a0,2
    80006078:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    8000607c:	6314                	ld	a3,0(a4)
    8000607e:	97b6                	add	a5,a5,a3
    80006080:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006084:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80006088:	03563423          	sd	s5,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    8000608c:	6714                	ld	a3,8(a4)
    8000608e:	0026d783          	lhu	a5,2(a3)
    80006092:	8b9d                	andi	a5,a5,7
    80006094:	0789                	addi	a5,a5,2
    80006096:	0786                	slli	a5,a5,0x1
    80006098:	97b6                	add	a5,a5,a3
    8000609a:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    8000609e:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    800060a2:	6718                	ld	a4,8(a4)
    800060a4:	00275783          	lhu	a5,2(a4)
    800060a8:	2785                	addiw	a5,a5,1
    800060aa:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800060ae:	100017b7          	lui	a5,0x10001
    800060b2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800060b6:	004aa783          	lw	a5,4(s5)
    800060ba:	02b79163          	bne	a5,a1,800060dc <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800060be:	00020917          	auipc	s2,0x20
    800060c2:	fea90913          	addi	s2,s2,-22 # 800260a8 <disk+0x20a8>
  while(b->disk == 1) {
    800060c6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800060c8:	85ca                	mv	a1,s2
    800060ca:	8556                	mv	a0,s5
    800060cc:	ffffc097          	auipc	ra,0xffffc
    800060d0:	182080e7          	jalr	386(ra) # 8000224e <sleep>
  while(b->disk == 1) {
    800060d4:	004aa783          	lw	a5,4(s5)
    800060d8:	fe9788e3          	beq	a5,s1,800060c8 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800060dc:	f8042483          	lw	s1,-128(s0)
    800060e0:	20048793          	addi	a5,s1,512
    800060e4:	00479713          	slli	a4,a5,0x4
    800060e8:	0001e797          	auipc	a5,0x1e
    800060ec:	f1878793          	addi	a5,a5,-232 # 80024000 <disk>
    800060f0:	97ba                	add	a5,a5,a4
    800060f2:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800060f6:	00020917          	auipc	s2,0x20
    800060fa:	f0a90913          	addi	s2,s2,-246 # 80026000 <disk+0x2000>
    800060fe:	a019                	j	80006104 <virtio_disk_rw+0x1b8>
      i = disk.desc[i].next;
    80006100:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    80006104:	8526                	mv	a0,s1
    80006106:	00000097          	auipc	ra,0x0
    8000610a:	c80080e7          	jalr	-896(ra) # 80005d86 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    8000610e:	0492                	slli	s1,s1,0x4
    80006110:	00093783          	ld	a5,0(s2)
    80006114:	94be                	add	s1,s1,a5
    80006116:	00c4d783          	lhu	a5,12(s1)
    8000611a:	8b85                	andi	a5,a5,1
    8000611c:	f3f5                	bnez	a5,80006100 <virtio_disk_rw+0x1b4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000611e:	00020517          	auipc	a0,0x20
    80006122:	f8a50513          	addi	a0,a0,-118 # 800260a8 <disk+0x20a8>
    80006126:	ffffb097          	auipc	ra,0xffffb
    8000612a:	bf0080e7          	jalr	-1040(ra) # 80000d16 <release>
}
    8000612e:	60aa                	ld	ra,136(sp)
    80006130:	640a                	ld	s0,128(sp)
    80006132:	74e6                	ld	s1,120(sp)
    80006134:	7946                	ld	s2,112(sp)
    80006136:	79a6                	ld	s3,104(sp)
    80006138:	7a06                	ld	s4,96(sp)
    8000613a:	6ae6                	ld	s5,88(sp)
    8000613c:	6b46                	ld	s6,80(sp)
    8000613e:	6ba6                	ld	s7,72(sp)
    80006140:	6c06                	ld	s8,64(sp)
    80006142:	7ce2                	ld	s9,56(sp)
    80006144:	7d42                	ld	s10,48(sp)
    80006146:	7da2                	ld	s11,40(sp)
    80006148:	6149                	addi	sp,sp,144
    8000614a:	8082                	ret
  if(write)
    8000614c:	01a037b3          	snez	a5,s10
    80006150:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    80006154:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    80006158:	f7943c23          	sd	s9,-136(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    8000615c:	f8042483          	lw	s1,-128(s0)
    80006160:	00449913          	slli	s2,s1,0x4
    80006164:	00020997          	auipc	s3,0x20
    80006168:	e9c98993          	addi	s3,s3,-356 # 80026000 <disk+0x2000>
    8000616c:	0009ba03          	ld	s4,0(s3)
    80006170:	9a4a                	add	s4,s4,s2
    80006172:	f7040513          	addi	a0,s0,-144
    80006176:	ffffb097          	auipc	ra,0xffffb
    8000617a:	fb8080e7          	jalr	-72(ra) # 8000112e <kvmpa>
    8000617e:	00aa3023          	sd	a0,0(s4)
  disk.desc[idx[0]].len = sizeof(buf0);
    80006182:	0009b783          	ld	a5,0(s3)
    80006186:	97ca                	add	a5,a5,s2
    80006188:	4741                	li	a4,16
    8000618a:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000618c:	0009b783          	ld	a5,0(s3)
    80006190:	97ca                	add	a5,a5,s2
    80006192:	4705                	li	a4,1
    80006194:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006198:	f8442783          	lw	a5,-124(s0)
    8000619c:	0009b703          	ld	a4,0(s3)
    800061a0:	974a                	add	a4,a4,s2
    800061a2:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800061a6:	0792                	slli	a5,a5,0x4
    800061a8:	0009b703          	ld	a4,0(s3)
    800061ac:	973e                	add	a4,a4,a5
    800061ae:	058a8693          	addi	a3,s5,88
    800061b2:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    800061b4:	0009b703          	ld	a4,0(s3)
    800061b8:	973e                	add	a4,a4,a5
    800061ba:	40000693          	li	a3,1024
    800061be:	c714                	sw	a3,8(a4)
  if(write)
    800061c0:	e40d18e3          	bnez	s10,80006010 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800061c4:	00020717          	auipc	a4,0x20
    800061c8:	e3c73703          	ld	a4,-452(a4) # 80026000 <disk+0x2000>
    800061cc:	973e                	add	a4,a4,a5
    800061ce:	4689                	li	a3,2
    800061d0:	00d71623          	sh	a3,12(a4)
    800061d4:	b5a9                	j	8000601e <virtio_disk_rw+0xd2>

00000000800061d6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800061d6:	1101                	addi	sp,sp,-32
    800061d8:	ec06                	sd	ra,24(sp)
    800061da:	e822                	sd	s0,16(sp)
    800061dc:	e426                	sd	s1,8(sp)
    800061de:	e04a                	sd	s2,0(sp)
    800061e0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800061e2:	00020517          	auipc	a0,0x20
    800061e6:	ec650513          	addi	a0,a0,-314 # 800260a8 <disk+0x20a8>
    800061ea:	ffffb097          	auipc	ra,0xffffb
    800061ee:	a78080e7          	jalr	-1416(ra) # 80000c62 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800061f2:	00020717          	auipc	a4,0x20
    800061f6:	e0e70713          	addi	a4,a4,-498 # 80026000 <disk+0x2000>
    800061fa:	02075783          	lhu	a5,32(a4)
    800061fe:	6b18                	ld	a4,16(a4)
    80006200:	00275683          	lhu	a3,2(a4)
    80006204:	8ebd                	xor	a3,a3,a5
    80006206:	8a9d                	andi	a3,a3,7
    80006208:	cab9                	beqz	a3,8000625e <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    8000620a:	0001e917          	auipc	s2,0x1e
    8000620e:	df690913          	addi	s2,s2,-522 # 80024000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006212:	00020497          	auipc	s1,0x20
    80006216:	dee48493          	addi	s1,s1,-530 # 80026000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    8000621a:	078e                	slli	a5,a5,0x3
    8000621c:	97ba                	add	a5,a5,a4
    8000621e:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80006220:	20078713          	addi	a4,a5,512
    80006224:	0712                	slli	a4,a4,0x4
    80006226:	974a                	add	a4,a4,s2
    80006228:	03074703          	lbu	a4,48(a4)
    8000622c:	ef21                	bnez	a4,80006284 <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    8000622e:	20078793          	addi	a5,a5,512
    80006232:	0792                	slli	a5,a5,0x4
    80006234:	97ca                	add	a5,a5,s2
    80006236:	7798                	ld	a4,40(a5)
    80006238:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    8000623c:	7788                	ld	a0,40(a5)
    8000623e:	ffffc097          	auipc	ra,0xffffc
    80006242:	190080e7          	jalr	400(ra) # 800023ce <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006246:	0204d783          	lhu	a5,32(s1)
    8000624a:	2785                	addiw	a5,a5,1
    8000624c:	8b9d                	andi	a5,a5,7
    8000624e:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006252:	6898                	ld	a4,16(s1)
    80006254:	00275683          	lhu	a3,2(a4)
    80006258:	8a9d                	andi	a3,a3,7
    8000625a:	fcf690e3          	bne	a3,a5,8000621a <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000625e:	10001737          	lui	a4,0x10001
    80006262:	533c                	lw	a5,96(a4)
    80006264:	8b8d                	andi	a5,a5,3
    80006266:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    80006268:	00020517          	auipc	a0,0x20
    8000626c:	e4050513          	addi	a0,a0,-448 # 800260a8 <disk+0x20a8>
    80006270:	ffffb097          	auipc	ra,0xffffb
    80006274:	aa6080e7          	jalr	-1370(ra) # 80000d16 <release>
}
    80006278:	60e2                	ld	ra,24(sp)
    8000627a:	6442                	ld	s0,16(sp)
    8000627c:	64a2                	ld	s1,8(sp)
    8000627e:	6902                	ld	s2,0(sp)
    80006280:	6105                	addi	sp,sp,32
    80006282:	8082                	ret
      panic("virtio_disk_intr status");
    80006284:	00002517          	auipc	a0,0x2
    80006288:	58c50513          	addi	a0,a0,1420 # 80008810 <syscalls+0x3e0>
    8000628c:	ffffa097          	auipc	ra,0xffffa
    80006290:	344080e7          	jalr	836(ra) # 800005d0 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
