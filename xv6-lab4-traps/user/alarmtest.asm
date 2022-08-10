
user/_alarmtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <periodic>:

volatile static int count;

void
periodic()
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  count = count + 1;
   8:	00001797          	auipc	a5,0x1
   c:	d107a783          	lw	a5,-752(a5) # d18 <count>
  10:	2785                	addiw	a5,a5,1
  12:	00001717          	auipc	a4,0x1
  16:	d0f72323          	sw	a5,-762(a4) # d18 <count>
  printf("alarm!\n");
  1a:	00001517          	auipc	a0,0x1
  1e:	b4650513          	addi	a0,a0,-1210 # b60 <malloc+0xe6>
  22:	00001097          	auipc	ra,0x1
  26:	99a080e7          	jalr	-1638(ra) # 9bc <printf>
  sigreturn();
  2a:	00000097          	auipc	ra,0x0
  2e:	6b2080e7          	jalr	1714(ra) # 6dc <sigreturn>
}
  32:	60a2                	ld	ra,8(sp)
  34:	6402                	ld	s0,0(sp)
  36:	0141                	addi	sp,sp,16
  38:	8082                	ret

000000000000003a <slow_handler>:
  }
}

void
slow_handler()
{
  3a:	1101                	addi	sp,sp,-32
  3c:	ec06                	sd	ra,24(sp)
  3e:	e822                	sd	s0,16(sp)
  40:	e426                	sd	s1,8(sp)
  42:	1000                	addi	s0,sp,32
  count++;
  44:	00001497          	auipc	s1,0x1
  48:	cd448493          	addi	s1,s1,-812 # d18 <count>
  4c:	00001797          	auipc	a5,0x1
  50:	ccc7a783          	lw	a5,-820(a5) # d18 <count>
  54:	2785                	addiw	a5,a5,1
  56:	c09c                	sw	a5,0(s1)
  printf("alarm!\n");
  58:	00001517          	auipc	a0,0x1
  5c:	b0850513          	addi	a0,a0,-1272 # b60 <malloc+0xe6>
  60:	00001097          	auipc	ra,0x1
  64:	95c080e7          	jalr	-1700(ra) # 9bc <printf>
  if (count > 1) {
  68:	4098                	lw	a4,0(s1)
  6a:	2701                	sext.w	a4,a4
  6c:	4685                	li	a3,1
  6e:	1dcd67b7          	lui	a5,0x1dcd6
  72:	50078793          	addi	a5,a5,1280 # 1dcd6500 <__global_pointer$+0x1dcd4fef>
  76:	02e6c463          	blt	a3,a4,9e <slow_handler+0x64>
    printf("test2 failed: alarm handler called more than once\n");
    exit(1);
  }
  for (int i = 0; i < 1000*500000; i++) {
    asm volatile("nop"); // avoid compiler optimizing away loop
  7a:	0001                	nop
  for (int i = 0; i < 1000*500000; i++) {
  7c:	37fd                	addiw	a5,a5,-1
  7e:	fff5                	bnez	a5,7a <slow_handler+0x40>
  }
  sigalarm(0, 0);
  80:	4581                	li	a1,0
  82:	4501                	li	a0,0
  84:	00000097          	auipc	ra,0x0
  88:	650080e7          	jalr	1616(ra) # 6d4 <sigalarm>
  sigreturn();
  8c:	00000097          	auipc	ra,0x0
  90:	650080e7          	jalr	1616(ra) # 6dc <sigreturn>
}
  94:	60e2                	ld	ra,24(sp)
  96:	6442                	ld	s0,16(sp)
  98:	64a2                	ld	s1,8(sp)
  9a:	6105                	addi	sp,sp,32
  9c:	8082                	ret
    printf("test2 failed: alarm handler called more than once\n");
  9e:	00001517          	auipc	a0,0x1
  a2:	aca50513          	addi	a0,a0,-1334 # b68 <malloc+0xee>
  a6:	00001097          	auipc	ra,0x1
  aa:	916080e7          	jalr	-1770(ra) # 9bc <printf>
    exit(1);
  ae:	4505                	li	a0,1
  b0:	00000097          	auipc	ra,0x0
  b4:	584080e7          	jalr	1412(ra) # 634 <exit>

00000000000000b8 <test0>:
{
  b8:	7139                	addi	sp,sp,-64
  ba:	fc06                	sd	ra,56(sp)
  bc:	f822                	sd	s0,48(sp)
  be:	f426                	sd	s1,40(sp)
  c0:	f04a                	sd	s2,32(sp)
  c2:	ec4e                	sd	s3,24(sp)
  c4:	e852                	sd	s4,16(sp)
  c6:	e456                	sd	s5,8(sp)
  c8:	0080                	addi	s0,sp,64
  printf("test0 start\n");
  ca:	00001517          	auipc	a0,0x1
  ce:	ad650513          	addi	a0,a0,-1322 # ba0 <malloc+0x126>
  d2:	00001097          	auipc	ra,0x1
  d6:	8ea080e7          	jalr	-1814(ra) # 9bc <printf>
  count = 0;
  da:	00001797          	auipc	a5,0x1
  de:	c207af23          	sw	zero,-962(a5) # d18 <count>
  sigalarm(2, periodic);
  e2:	00000597          	auipc	a1,0x0
  e6:	f1e58593          	addi	a1,a1,-226 # 0 <periodic>
  ea:	4509                	li	a0,2
  ec:	00000097          	auipc	ra,0x0
  f0:	5e8080e7          	jalr	1512(ra) # 6d4 <sigalarm>
  for(i = 0; i < 1000*500000; i++){
  f4:	4481                	li	s1,0
    if((i % 1000000) == 0)
  f6:	000f4937          	lui	s2,0xf4
  fa:	2409091b          	addiw	s2,s2,576
      write(2, ".", 1);
  fe:	00001a97          	auipc	s5,0x1
 102:	ab2a8a93          	addi	s5,s5,-1358 # bb0 <malloc+0x136>
    if(count > 0)
 106:	00001a17          	auipc	s4,0x1
 10a:	c12a0a13          	addi	s4,s4,-1006 # d18 <count>
  for(i = 0; i < 1000*500000; i++){
 10e:	1dcd69b7          	lui	s3,0x1dcd6
 112:	50098993          	addi	s3,s3,1280 # 1dcd6500 <__global_pointer$+0x1dcd4fef>
 116:	a809                	j	128 <test0+0x70>
    if(count > 0)
 118:	000a2783          	lw	a5,0(s4)
 11c:	2781                	sext.w	a5,a5
 11e:	02f04063          	bgtz	a5,13e <test0+0x86>
  for(i = 0; i < 1000*500000; i++){
 122:	2485                	addiw	s1,s1,1
 124:	01348d63          	beq	s1,s3,13e <test0+0x86>
    if((i % 1000000) == 0)
 128:	0324e7bb          	remw	a5,s1,s2
 12c:	f7f5                	bnez	a5,118 <test0+0x60>
      write(2, ".", 1);
 12e:	4605                	li	a2,1
 130:	85d6                	mv	a1,s5
 132:	4509                	li	a0,2
 134:	00000097          	auipc	ra,0x0
 138:	520080e7          	jalr	1312(ra) # 654 <write>
 13c:	bff1                	j	118 <test0+0x60>
  sigalarm(0, 0);
 13e:	4581                	li	a1,0
 140:	4501                	li	a0,0
 142:	00000097          	auipc	ra,0x0
 146:	592080e7          	jalr	1426(ra) # 6d4 <sigalarm>
  if(count > 0){
 14a:	00001797          	auipc	a5,0x1
 14e:	bce7a783          	lw	a5,-1074(a5) # d18 <count>
 152:	02f05363          	blez	a5,178 <test0+0xc0>
    printf("test0 passed\n");
 156:	00001517          	auipc	a0,0x1
 15a:	a6250513          	addi	a0,a0,-1438 # bb8 <malloc+0x13e>
 15e:	00001097          	auipc	ra,0x1
 162:	85e080e7          	jalr	-1954(ra) # 9bc <printf>
}
 166:	70e2                	ld	ra,56(sp)
 168:	7442                	ld	s0,48(sp)
 16a:	74a2                	ld	s1,40(sp)
 16c:	7902                	ld	s2,32(sp)
 16e:	69e2                	ld	s3,24(sp)
 170:	6a42                	ld	s4,16(sp)
 172:	6aa2                	ld	s5,8(sp)
 174:	6121                	addi	sp,sp,64
 176:	8082                	ret
    printf("\ntest0 failed: the kernel never called the alarm handler\n");
 178:	00001517          	auipc	a0,0x1
 17c:	a5050513          	addi	a0,a0,-1456 # bc8 <malloc+0x14e>
 180:	00001097          	auipc	ra,0x1
 184:	83c080e7          	jalr	-1988(ra) # 9bc <printf>
}
 188:	bff9                	j	166 <test0+0xae>

000000000000018a <foo>:
void __attribute__ ((noinline)) foo(int i, int *j) {
 18a:	1101                	addi	sp,sp,-32
 18c:	ec06                	sd	ra,24(sp)
 18e:	e822                	sd	s0,16(sp)
 190:	e426                	sd	s1,8(sp)
 192:	1000                	addi	s0,sp,32
 194:	84ae                	mv	s1,a1
  if((i % 2500000) == 0) {
 196:	002627b7          	lui	a5,0x262
 19a:	5a07879b          	addiw	a5,a5,1440
 19e:	02f5653b          	remw	a0,a0,a5
 1a2:	c909                	beqz	a0,1b4 <foo+0x2a>
  *j += 1;
 1a4:	409c                	lw	a5,0(s1)
 1a6:	2785                	addiw	a5,a5,1
 1a8:	c09c                	sw	a5,0(s1)
}
 1aa:	60e2                	ld	ra,24(sp)
 1ac:	6442                	ld	s0,16(sp)
 1ae:	64a2                	ld	s1,8(sp)
 1b0:	6105                	addi	sp,sp,32
 1b2:	8082                	ret
    write(2, ".", 1);
 1b4:	4605                	li	a2,1
 1b6:	00001597          	auipc	a1,0x1
 1ba:	9fa58593          	addi	a1,a1,-1542 # bb0 <malloc+0x136>
 1be:	4509                	li	a0,2
 1c0:	00000097          	auipc	ra,0x0
 1c4:	494080e7          	jalr	1172(ra) # 654 <write>
 1c8:	bff1                	j	1a4 <foo+0x1a>

00000000000001ca <test1>:
{
 1ca:	7139                	addi	sp,sp,-64
 1cc:	fc06                	sd	ra,56(sp)
 1ce:	f822                	sd	s0,48(sp)
 1d0:	f426                	sd	s1,40(sp)
 1d2:	f04a                	sd	s2,32(sp)
 1d4:	ec4e                	sd	s3,24(sp)
 1d6:	e852                	sd	s4,16(sp)
 1d8:	0080                	addi	s0,sp,64
  printf("test1 start\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	a2e50513          	addi	a0,a0,-1490 # c08 <malloc+0x18e>
 1e2:	00000097          	auipc	ra,0x0
 1e6:	7da080e7          	jalr	2010(ra) # 9bc <printf>
  count = 0;
 1ea:	00001797          	auipc	a5,0x1
 1ee:	b207a723          	sw	zero,-1234(a5) # d18 <count>
  j = 0;
 1f2:	fc042623          	sw	zero,-52(s0)
  sigalarm(2, periodic);
 1f6:	00000597          	auipc	a1,0x0
 1fa:	e0a58593          	addi	a1,a1,-502 # 0 <periodic>
 1fe:	4509                	li	a0,2
 200:	00000097          	auipc	ra,0x0
 204:	4d4080e7          	jalr	1236(ra) # 6d4 <sigalarm>
  for(i = 0; i < 500000000; i++){
 208:	4481                	li	s1,0
    if(count >= 10)
 20a:	00001a17          	auipc	s4,0x1
 20e:	b0ea0a13          	addi	s4,s4,-1266 # d18 <count>
 212:	49a5                	li	s3,9
  for(i = 0; i < 500000000; i++){
 214:	1dcd6937          	lui	s2,0x1dcd6
 218:	50090913          	addi	s2,s2,1280 # 1dcd6500 <__global_pointer$+0x1dcd4fef>
    if(count >= 10)
 21c:	000a2783          	lw	a5,0(s4)
 220:	2781                	sext.w	a5,a5
 222:	00f9cc63          	blt	s3,a5,23a <test1+0x70>
    foo(i, &j);
 226:	fcc40593          	addi	a1,s0,-52
 22a:	8526                	mv	a0,s1
 22c:	00000097          	auipc	ra,0x0
 230:	f5e080e7          	jalr	-162(ra) # 18a <foo>
  for(i = 0; i < 500000000; i++){
 234:	2485                	addiw	s1,s1,1
 236:	ff2493e3          	bne	s1,s2,21c <test1+0x52>
  if(count < 10){
 23a:	00001717          	auipc	a4,0x1
 23e:	ade72703          	lw	a4,-1314(a4) # d18 <count>
 242:	47a5                	li	a5,9
 244:	02e7d663          	bge	a5,a4,270 <test1+0xa6>
  } else if(i != j){
 248:	fcc42783          	lw	a5,-52(s0)
 24c:	02978b63          	beq	a5,s1,282 <test1+0xb8>
    printf("\ntest1 failed: foo() executed fewer times than it was called\n");
 250:	00001517          	auipc	a0,0x1
 254:	9f850513          	addi	a0,a0,-1544 # c48 <malloc+0x1ce>
 258:	00000097          	auipc	ra,0x0
 25c:	764080e7          	jalr	1892(ra) # 9bc <printf>
}
 260:	70e2                	ld	ra,56(sp)
 262:	7442                	ld	s0,48(sp)
 264:	74a2                	ld	s1,40(sp)
 266:	7902                	ld	s2,32(sp)
 268:	69e2                	ld	s3,24(sp)
 26a:	6a42                	ld	s4,16(sp)
 26c:	6121                	addi	sp,sp,64
 26e:	8082                	ret
    printf("\ntest1 failed: too few calls to the handler\n");
 270:	00001517          	auipc	a0,0x1
 274:	9a850513          	addi	a0,a0,-1624 # c18 <malloc+0x19e>
 278:	00000097          	auipc	ra,0x0
 27c:	744080e7          	jalr	1860(ra) # 9bc <printf>
 280:	b7c5                	j	260 <test1+0x96>
    printf("test1 passed\n");
 282:	00001517          	auipc	a0,0x1
 286:	a0650513          	addi	a0,a0,-1530 # c88 <malloc+0x20e>
 28a:	00000097          	auipc	ra,0x0
 28e:	732080e7          	jalr	1842(ra) # 9bc <printf>
}
 292:	b7f9                	j	260 <test1+0x96>

0000000000000294 <test2>:
{
 294:	715d                	addi	sp,sp,-80
 296:	e486                	sd	ra,72(sp)
 298:	e0a2                	sd	s0,64(sp)
 29a:	fc26                	sd	s1,56(sp)
 29c:	f84a                	sd	s2,48(sp)
 29e:	f44e                	sd	s3,40(sp)
 2a0:	f052                	sd	s4,32(sp)
 2a2:	ec56                	sd	s5,24(sp)
 2a4:	0880                	addi	s0,sp,80
  printf("test2 start\n");
 2a6:	00001517          	auipc	a0,0x1
 2aa:	9f250513          	addi	a0,a0,-1550 # c98 <malloc+0x21e>
 2ae:	00000097          	auipc	ra,0x0
 2b2:	70e080e7          	jalr	1806(ra) # 9bc <printf>
  if ((pid = fork()) < 0) {
 2b6:	00000097          	auipc	ra,0x0
 2ba:	376080e7          	jalr	886(ra) # 62c <fork>
 2be:	04054263          	bltz	a0,302 <test2+0x6e>
 2c2:	84aa                	mv	s1,a0
  if (pid == 0) {
 2c4:	e539                	bnez	a0,312 <test2+0x7e>
    count = 0;
 2c6:	00001797          	auipc	a5,0x1
 2ca:	a407a923          	sw	zero,-1454(a5) # d18 <count>
    sigalarm(2, slow_handler);
 2ce:	00000597          	auipc	a1,0x0
 2d2:	d6c58593          	addi	a1,a1,-660 # 3a <slow_handler>
 2d6:	4509                	li	a0,2
 2d8:	00000097          	auipc	ra,0x0
 2dc:	3fc080e7          	jalr	1020(ra) # 6d4 <sigalarm>
      if((i % 1000000) == 0)
 2e0:	000f4937          	lui	s2,0xf4
 2e4:	2409091b          	addiw	s2,s2,576
        write(2, ".", 1);
 2e8:	00001a97          	auipc	s5,0x1
 2ec:	8c8a8a93          	addi	s5,s5,-1848 # bb0 <malloc+0x136>
      if(count > 0)
 2f0:	00001a17          	auipc	s4,0x1
 2f4:	a28a0a13          	addi	s4,s4,-1496 # d18 <count>
    for(i = 0; i < 1000*500000; i++){
 2f8:	1dcd69b7          	lui	s3,0x1dcd6
 2fc:	50098993          	addi	s3,s3,1280 # 1dcd6500 <__global_pointer$+0x1dcd4fef>
 300:	a099                	j	346 <test2+0xb2>
    printf("test2: fork failed\n");
 302:	00001517          	auipc	a0,0x1
 306:	9a650513          	addi	a0,a0,-1626 # ca8 <malloc+0x22e>
 30a:	00000097          	auipc	ra,0x0
 30e:	6b2080e7          	jalr	1714(ra) # 9bc <printf>
  wait(&status);
 312:	fbc40513          	addi	a0,s0,-68
 316:	00000097          	auipc	ra,0x0
 31a:	326080e7          	jalr	806(ra) # 63c <wait>
  if (status == 0) {
 31e:	fbc42783          	lw	a5,-68(s0)
 322:	c7a5                	beqz	a5,38a <test2+0xf6>
}
 324:	60a6                	ld	ra,72(sp)
 326:	6406                	ld	s0,64(sp)
 328:	74e2                	ld	s1,56(sp)
 32a:	7942                	ld	s2,48(sp)
 32c:	79a2                	ld	s3,40(sp)
 32e:	7a02                	ld	s4,32(sp)
 330:	6ae2                	ld	s5,24(sp)
 332:	6161                	addi	sp,sp,80
 334:	8082                	ret
      if(count > 0)
 336:	000a2783          	lw	a5,0(s4)
 33a:	2781                	sext.w	a5,a5
 33c:	02f04063          	bgtz	a5,35c <test2+0xc8>
    for(i = 0; i < 1000*500000; i++){
 340:	2485                	addiw	s1,s1,1
 342:	01348d63          	beq	s1,s3,35c <test2+0xc8>
      if((i % 1000000) == 0)
 346:	0324e7bb          	remw	a5,s1,s2
 34a:	f7f5                	bnez	a5,336 <test2+0xa2>
        write(2, ".", 1);
 34c:	4605                	li	a2,1
 34e:	85d6                	mv	a1,s5
 350:	4509                	li	a0,2
 352:	00000097          	auipc	ra,0x0
 356:	302080e7          	jalr	770(ra) # 654 <write>
 35a:	bff1                	j	336 <test2+0xa2>
    if (count == 0) {
 35c:	00001797          	auipc	a5,0x1
 360:	9bc7a783          	lw	a5,-1604(a5) # d18 <count>
 364:	ef91                	bnez	a5,380 <test2+0xec>
      printf("\ntest2 failed: alarm not called\n");
 366:	00001517          	auipc	a0,0x1
 36a:	95a50513          	addi	a0,a0,-1702 # cc0 <malloc+0x246>
 36e:	00000097          	auipc	ra,0x0
 372:	64e080e7          	jalr	1614(ra) # 9bc <printf>
      exit(1);
 376:	4505                	li	a0,1
 378:	00000097          	auipc	ra,0x0
 37c:	2bc080e7          	jalr	700(ra) # 634 <exit>
    exit(0);
 380:	4501                	li	a0,0
 382:	00000097          	auipc	ra,0x0
 386:	2b2080e7          	jalr	690(ra) # 634 <exit>
    printf("test2 passed\n");
 38a:	00001517          	auipc	a0,0x1
 38e:	95e50513          	addi	a0,a0,-1698 # ce8 <malloc+0x26e>
 392:	00000097          	auipc	ra,0x0
 396:	62a080e7          	jalr	1578(ra) # 9bc <printf>
}
 39a:	b769                	j	324 <test2+0x90>

000000000000039c <main>:
{
 39c:	1141                	addi	sp,sp,-16
 39e:	e406                	sd	ra,8(sp)
 3a0:	e022                	sd	s0,0(sp)
 3a2:	0800                	addi	s0,sp,16
  test0();
 3a4:	00000097          	auipc	ra,0x0
 3a8:	d14080e7          	jalr	-748(ra) # b8 <test0>
  test1();
 3ac:	00000097          	auipc	ra,0x0
 3b0:	e1e080e7          	jalr	-482(ra) # 1ca <test1>
  test2();
 3b4:	00000097          	auipc	ra,0x0
 3b8:	ee0080e7          	jalr	-288(ra) # 294 <test2>
  exit(0);
 3bc:	4501                	li	a0,0
 3be:	00000097          	auipc	ra,0x0
 3c2:	276080e7          	jalr	630(ra) # 634 <exit>

00000000000003c6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e422                	sd	s0,8(sp)
 3ca:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3cc:	87aa                	mv	a5,a0
 3ce:	0585                	addi	a1,a1,1
 3d0:	0785                	addi	a5,a5,1
 3d2:	fff5c703          	lbu	a4,-1(a1)
 3d6:	fee78fa3          	sb	a4,-1(a5)
 3da:	fb75                	bnez	a4,3ce <strcpy+0x8>
    ;
  return os;
}
 3dc:	6422                	ld	s0,8(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret

00000000000003e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3e2:	1141                	addi	sp,sp,-16
 3e4:	e422                	sd	s0,8(sp)
 3e6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3e8:	00054783          	lbu	a5,0(a0)
 3ec:	cb91                	beqz	a5,400 <strcmp+0x1e>
 3ee:	0005c703          	lbu	a4,0(a1)
 3f2:	00f71763          	bne	a4,a5,400 <strcmp+0x1e>
    p++, q++;
 3f6:	0505                	addi	a0,a0,1
 3f8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3fa:	00054783          	lbu	a5,0(a0)
 3fe:	fbe5                	bnez	a5,3ee <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 400:	0005c503          	lbu	a0,0(a1)
}
 404:	40a7853b          	subw	a0,a5,a0
 408:	6422                	ld	s0,8(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret

000000000000040e <strlen>:

uint
strlen(const char *s)
{
 40e:	1141                	addi	sp,sp,-16
 410:	e422                	sd	s0,8(sp)
 412:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 414:	00054783          	lbu	a5,0(a0)
 418:	cf91                	beqz	a5,434 <strlen+0x26>
 41a:	0505                	addi	a0,a0,1
 41c:	87aa                	mv	a5,a0
 41e:	4685                	li	a3,1
 420:	9e89                	subw	a3,a3,a0
 422:	00f6853b          	addw	a0,a3,a5
 426:	0785                	addi	a5,a5,1
 428:	fff7c703          	lbu	a4,-1(a5)
 42c:	fb7d                	bnez	a4,422 <strlen+0x14>
    ;
  return n;
}
 42e:	6422                	ld	s0,8(sp)
 430:	0141                	addi	sp,sp,16
 432:	8082                	ret
  for(n = 0; s[n]; n++)
 434:	4501                	li	a0,0
 436:	bfe5                	j	42e <strlen+0x20>

0000000000000438 <memset>:

void*
memset(void *dst, int c, uint n)
{
 438:	1141                	addi	sp,sp,-16
 43a:	e422                	sd	s0,8(sp)
 43c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 43e:	ca19                	beqz	a2,454 <memset+0x1c>
 440:	87aa                	mv	a5,a0
 442:	1602                	slli	a2,a2,0x20
 444:	9201                	srli	a2,a2,0x20
 446:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 44a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 44e:	0785                	addi	a5,a5,1
 450:	fee79de3          	bne	a5,a4,44a <memset+0x12>
  }
  return dst;
}
 454:	6422                	ld	s0,8(sp)
 456:	0141                	addi	sp,sp,16
 458:	8082                	ret

000000000000045a <strchr>:

char*
strchr(const char *s, char c)
{
 45a:	1141                	addi	sp,sp,-16
 45c:	e422                	sd	s0,8(sp)
 45e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 460:	00054783          	lbu	a5,0(a0)
 464:	cb99                	beqz	a5,47a <strchr+0x20>
    if(*s == c)
 466:	00f58763          	beq	a1,a5,474 <strchr+0x1a>
  for(; *s; s++)
 46a:	0505                	addi	a0,a0,1
 46c:	00054783          	lbu	a5,0(a0)
 470:	fbfd                	bnez	a5,466 <strchr+0xc>
      return (char*)s;
  return 0;
 472:	4501                	li	a0,0
}
 474:	6422                	ld	s0,8(sp)
 476:	0141                	addi	sp,sp,16
 478:	8082                	ret
  return 0;
 47a:	4501                	li	a0,0
 47c:	bfe5                	j	474 <strchr+0x1a>

000000000000047e <gets>:

char*
gets(char *buf, int max)
{
 47e:	711d                	addi	sp,sp,-96
 480:	ec86                	sd	ra,88(sp)
 482:	e8a2                	sd	s0,80(sp)
 484:	e4a6                	sd	s1,72(sp)
 486:	e0ca                	sd	s2,64(sp)
 488:	fc4e                	sd	s3,56(sp)
 48a:	f852                	sd	s4,48(sp)
 48c:	f456                	sd	s5,40(sp)
 48e:	f05a                	sd	s6,32(sp)
 490:	ec5e                	sd	s7,24(sp)
 492:	1080                	addi	s0,sp,96
 494:	8baa                	mv	s7,a0
 496:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 498:	892a                	mv	s2,a0
 49a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 49c:	4aa9                	li	s5,10
 49e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4a0:	89a6                	mv	s3,s1
 4a2:	2485                	addiw	s1,s1,1
 4a4:	0344d863          	bge	s1,s4,4d4 <gets+0x56>
    cc = read(0, &c, 1);
 4a8:	4605                	li	a2,1
 4aa:	faf40593          	addi	a1,s0,-81
 4ae:	4501                	li	a0,0
 4b0:	00000097          	auipc	ra,0x0
 4b4:	19c080e7          	jalr	412(ra) # 64c <read>
    if(cc < 1)
 4b8:	00a05e63          	blez	a0,4d4 <gets+0x56>
    buf[i++] = c;
 4bc:	faf44783          	lbu	a5,-81(s0)
 4c0:	00f90023          	sb	a5,0(s2) # f4000 <__global_pointer$+0xf2aef>
    if(c == '\n' || c == '\r')
 4c4:	01578763          	beq	a5,s5,4d2 <gets+0x54>
 4c8:	0905                	addi	s2,s2,1
 4ca:	fd679be3          	bne	a5,s6,4a0 <gets+0x22>
  for(i=0; i+1 < max; ){
 4ce:	89a6                	mv	s3,s1
 4d0:	a011                	j	4d4 <gets+0x56>
 4d2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4d4:	99de                	add	s3,s3,s7
 4d6:	00098023          	sb	zero,0(s3)
  return buf;
}
 4da:	855e                	mv	a0,s7
 4dc:	60e6                	ld	ra,88(sp)
 4de:	6446                	ld	s0,80(sp)
 4e0:	64a6                	ld	s1,72(sp)
 4e2:	6906                	ld	s2,64(sp)
 4e4:	79e2                	ld	s3,56(sp)
 4e6:	7a42                	ld	s4,48(sp)
 4e8:	7aa2                	ld	s5,40(sp)
 4ea:	7b02                	ld	s6,32(sp)
 4ec:	6be2                	ld	s7,24(sp)
 4ee:	6125                	addi	sp,sp,96
 4f0:	8082                	ret

00000000000004f2 <stat>:

int
stat(const char *n, struct stat *st)
{
 4f2:	1101                	addi	sp,sp,-32
 4f4:	ec06                	sd	ra,24(sp)
 4f6:	e822                	sd	s0,16(sp)
 4f8:	e426                	sd	s1,8(sp)
 4fa:	e04a                	sd	s2,0(sp)
 4fc:	1000                	addi	s0,sp,32
 4fe:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 500:	4581                	li	a1,0
 502:	00000097          	auipc	ra,0x0
 506:	172080e7          	jalr	370(ra) # 674 <open>
  if(fd < 0)
 50a:	02054563          	bltz	a0,534 <stat+0x42>
 50e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 510:	85ca                	mv	a1,s2
 512:	00000097          	auipc	ra,0x0
 516:	17a080e7          	jalr	378(ra) # 68c <fstat>
 51a:	892a                	mv	s2,a0
  close(fd);
 51c:	8526                	mv	a0,s1
 51e:	00000097          	auipc	ra,0x0
 522:	13e080e7          	jalr	318(ra) # 65c <close>
  return r;
}
 526:	854a                	mv	a0,s2
 528:	60e2                	ld	ra,24(sp)
 52a:	6442                	ld	s0,16(sp)
 52c:	64a2                	ld	s1,8(sp)
 52e:	6902                	ld	s2,0(sp)
 530:	6105                	addi	sp,sp,32
 532:	8082                	ret
    return -1;
 534:	597d                	li	s2,-1
 536:	bfc5                	j	526 <stat+0x34>

0000000000000538 <atoi>:

int
atoi(const char *s)
{
 538:	1141                	addi	sp,sp,-16
 53a:	e422                	sd	s0,8(sp)
 53c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 53e:	00054603          	lbu	a2,0(a0)
 542:	fd06079b          	addiw	a5,a2,-48
 546:	0ff7f793          	andi	a5,a5,255
 54a:	4725                	li	a4,9
 54c:	02f76963          	bltu	a4,a5,57e <atoi+0x46>
 550:	86aa                	mv	a3,a0
  n = 0;
 552:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 554:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 556:	0685                	addi	a3,a3,1
 558:	0025179b          	slliw	a5,a0,0x2
 55c:	9fa9                	addw	a5,a5,a0
 55e:	0017979b          	slliw	a5,a5,0x1
 562:	9fb1                	addw	a5,a5,a2
 564:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 568:	0006c603          	lbu	a2,0(a3)
 56c:	fd06071b          	addiw	a4,a2,-48
 570:	0ff77713          	andi	a4,a4,255
 574:	fee5f1e3          	bgeu	a1,a4,556 <atoi+0x1e>
  return n;
}
 578:	6422                	ld	s0,8(sp)
 57a:	0141                	addi	sp,sp,16
 57c:	8082                	ret
  n = 0;
 57e:	4501                	li	a0,0
 580:	bfe5                	j	578 <atoi+0x40>

0000000000000582 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 582:	1141                	addi	sp,sp,-16
 584:	e422                	sd	s0,8(sp)
 586:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 588:	02b57463          	bgeu	a0,a1,5b0 <memmove+0x2e>
    while(n-- > 0)
 58c:	00c05f63          	blez	a2,5aa <memmove+0x28>
 590:	1602                	slli	a2,a2,0x20
 592:	9201                	srli	a2,a2,0x20
 594:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 598:	872a                	mv	a4,a0
      *dst++ = *src++;
 59a:	0585                	addi	a1,a1,1
 59c:	0705                	addi	a4,a4,1
 59e:	fff5c683          	lbu	a3,-1(a1)
 5a2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5a6:	fee79ae3          	bne	a5,a4,59a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5aa:	6422                	ld	s0,8(sp)
 5ac:	0141                	addi	sp,sp,16
 5ae:	8082                	ret
    dst += n;
 5b0:	00c50733          	add	a4,a0,a2
    src += n;
 5b4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5b6:	fec05ae3          	blez	a2,5aa <memmove+0x28>
 5ba:	fff6079b          	addiw	a5,a2,-1
 5be:	1782                	slli	a5,a5,0x20
 5c0:	9381                	srli	a5,a5,0x20
 5c2:	fff7c793          	not	a5,a5
 5c6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5c8:	15fd                	addi	a1,a1,-1
 5ca:	177d                	addi	a4,a4,-1
 5cc:	0005c683          	lbu	a3,0(a1)
 5d0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5d4:	fee79ae3          	bne	a5,a4,5c8 <memmove+0x46>
 5d8:	bfc9                	j	5aa <memmove+0x28>

00000000000005da <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5da:	1141                	addi	sp,sp,-16
 5dc:	e422                	sd	s0,8(sp)
 5de:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5e0:	ca05                	beqz	a2,610 <memcmp+0x36>
 5e2:	fff6069b          	addiw	a3,a2,-1
 5e6:	1682                	slli	a3,a3,0x20
 5e8:	9281                	srli	a3,a3,0x20
 5ea:	0685                	addi	a3,a3,1
 5ec:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5ee:	00054783          	lbu	a5,0(a0)
 5f2:	0005c703          	lbu	a4,0(a1)
 5f6:	00e79863          	bne	a5,a4,606 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5fa:	0505                	addi	a0,a0,1
    p2++;
 5fc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5fe:	fed518e3          	bne	a0,a3,5ee <memcmp+0x14>
  }
  return 0;
 602:	4501                	li	a0,0
 604:	a019                	j	60a <memcmp+0x30>
      return *p1 - *p2;
 606:	40e7853b          	subw	a0,a5,a4
}
 60a:	6422                	ld	s0,8(sp)
 60c:	0141                	addi	sp,sp,16
 60e:	8082                	ret
  return 0;
 610:	4501                	li	a0,0
 612:	bfe5                	j	60a <memcmp+0x30>

0000000000000614 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 614:	1141                	addi	sp,sp,-16
 616:	e406                	sd	ra,8(sp)
 618:	e022                	sd	s0,0(sp)
 61a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 61c:	00000097          	auipc	ra,0x0
 620:	f66080e7          	jalr	-154(ra) # 582 <memmove>
}
 624:	60a2                	ld	ra,8(sp)
 626:	6402                	ld	s0,0(sp)
 628:	0141                	addi	sp,sp,16
 62a:	8082                	ret

000000000000062c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 62c:	4885                	li	a7,1
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <exit>:
.global exit
exit:
 li a7, SYS_exit
 634:	4889                	li	a7,2
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <wait>:
.global wait
wait:
 li a7, SYS_wait
 63c:	488d                	li	a7,3
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 644:	4891                	li	a7,4
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <read>:
.global read
read:
 li a7, SYS_read
 64c:	4895                	li	a7,5
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <write>:
.global write
write:
 li a7, SYS_write
 654:	48c1                	li	a7,16
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <close>:
.global close
close:
 li a7, SYS_close
 65c:	48d5                	li	a7,21
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <kill>:
.global kill
kill:
 li a7, SYS_kill
 664:	4899                	li	a7,6
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <exec>:
.global exec
exec:
 li a7, SYS_exec
 66c:	489d                	li	a7,7
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <open>:
.global open
open:
 li a7, SYS_open
 674:	48bd                	li	a7,15
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 67c:	48c5                	li	a7,17
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 684:	48c9                	li	a7,18
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 68c:	48a1                	li	a7,8
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <link>:
.global link
link:
 li a7, SYS_link
 694:	48cd                	li	a7,19
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 69c:	48d1                	li	a7,20
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6a4:	48a5                	li	a7,9
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <dup>:
.global dup
dup:
 li a7, SYS_dup
 6ac:	48a9                	li	a7,10
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6b4:	48ad                	li	a7,11
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6bc:	48b1                	li	a7,12
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6c4:	48b5                	li	a7,13
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6cc:	48b9                	li	a7,14
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 6d4:	48d9                	li	a7,22
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 6dc:	48dd                	li	a7,23
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6e4:	1101                	addi	sp,sp,-32
 6e6:	ec06                	sd	ra,24(sp)
 6e8:	e822                	sd	s0,16(sp)
 6ea:	1000                	addi	s0,sp,32
 6ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6f0:	4605                	li	a2,1
 6f2:	fef40593          	addi	a1,s0,-17
 6f6:	00000097          	auipc	ra,0x0
 6fa:	f5e080e7          	jalr	-162(ra) # 654 <write>
}
 6fe:	60e2                	ld	ra,24(sp)
 700:	6442                	ld	s0,16(sp)
 702:	6105                	addi	sp,sp,32
 704:	8082                	ret

0000000000000706 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 706:	7139                	addi	sp,sp,-64
 708:	fc06                	sd	ra,56(sp)
 70a:	f822                	sd	s0,48(sp)
 70c:	f426                	sd	s1,40(sp)
 70e:	f04a                	sd	s2,32(sp)
 710:	ec4e                	sd	s3,24(sp)
 712:	0080                	addi	s0,sp,64
 714:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 716:	c299                	beqz	a3,71c <printint+0x16>
 718:	0805c863          	bltz	a1,7a8 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 71c:	2581                	sext.w	a1,a1
  neg = 0;
 71e:	4881                	li	a7,0
 720:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 724:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 726:	2601                	sext.w	a2,a2
 728:	00000517          	auipc	a0,0x0
 72c:	5d850513          	addi	a0,a0,1496 # d00 <digits>
 730:	883a                	mv	a6,a4
 732:	2705                	addiw	a4,a4,1
 734:	02c5f7bb          	remuw	a5,a1,a2
 738:	1782                	slli	a5,a5,0x20
 73a:	9381                	srli	a5,a5,0x20
 73c:	97aa                	add	a5,a5,a0
 73e:	0007c783          	lbu	a5,0(a5)
 742:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 746:	0005879b          	sext.w	a5,a1
 74a:	02c5d5bb          	divuw	a1,a1,a2
 74e:	0685                	addi	a3,a3,1
 750:	fec7f0e3          	bgeu	a5,a2,730 <printint+0x2a>
  if(neg)
 754:	00088b63          	beqz	a7,76a <printint+0x64>
    buf[i++] = '-';
 758:	fd040793          	addi	a5,s0,-48
 75c:	973e                	add	a4,a4,a5
 75e:	02d00793          	li	a5,45
 762:	fef70823          	sb	a5,-16(a4)
 766:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 76a:	02e05863          	blez	a4,79a <printint+0x94>
 76e:	fc040793          	addi	a5,s0,-64
 772:	00e78933          	add	s2,a5,a4
 776:	fff78993          	addi	s3,a5,-1
 77a:	99ba                	add	s3,s3,a4
 77c:	377d                	addiw	a4,a4,-1
 77e:	1702                	slli	a4,a4,0x20
 780:	9301                	srli	a4,a4,0x20
 782:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 786:	fff94583          	lbu	a1,-1(s2)
 78a:	8526                	mv	a0,s1
 78c:	00000097          	auipc	ra,0x0
 790:	f58080e7          	jalr	-168(ra) # 6e4 <putc>
  while(--i >= 0)
 794:	197d                	addi	s2,s2,-1
 796:	ff3918e3          	bne	s2,s3,786 <printint+0x80>
}
 79a:	70e2                	ld	ra,56(sp)
 79c:	7442                	ld	s0,48(sp)
 79e:	74a2                	ld	s1,40(sp)
 7a0:	7902                	ld	s2,32(sp)
 7a2:	69e2                	ld	s3,24(sp)
 7a4:	6121                	addi	sp,sp,64
 7a6:	8082                	ret
    x = -xx;
 7a8:	40b005bb          	negw	a1,a1
    neg = 1;
 7ac:	4885                	li	a7,1
    x = -xx;
 7ae:	bf8d                	j	720 <printint+0x1a>

00000000000007b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7b0:	7119                	addi	sp,sp,-128
 7b2:	fc86                	sd	ra,120(sp)
 7b4:	f8a2                	sd	s0,112(sp)
 7b6:	f4a6                	sd	s1,104(sp)
 7b8:	f0ca                	sd	s2,96(sp)
 7ba:	ecce                	sd	s3,88(sp)
 7bc:	e8d2                	sd	s4,80(sp)
 7be:	e4d6                	sd	s5,72(sp)
 7c0:	e0da                	sd	s6,64(sp)
 7c2:	fc5e                	sd	s7,56(sp)
 7c4:	f862                	sd	s8,48(sp)
 7c6:	f466                	sd	s9,40(sp)
 7c8:	f06a                	sd	s10,32(sp)
 7ca:	ec6e                	sd	s11,24(sp)
 7cc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7ce:	0005c903          	lbu	s2,0(a1)
 7d2:	18090f63          	beqz	s2,970 <vprintf+0x1c0>
 7d6:	8aaa                	mv	s5,a0
 7d8:	8b32                	mv	s6,a2
 7da:	00158493          	addi	s1,a1,1
  state = 0;
 7de:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7e0:	02500a13          	li	s4,37
      if(c == 'd'){
 7e4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7e8:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 7ec:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 7f0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7f4:	00000b97          	auipc	s7,0x0
 7f8:	50cb8b93          	addi	s7,s7,1292 # d00 <digits>
 7fc:	a839                	j	81a <vprintf+0x6a>
        putc(fd, c);
 7fe:	85ca                	mv	a1,s2
 800:	8556                	mv	a0,s5
 802:	00000097          	auipc	ra,0x0
 806:	ee2080e7          	jalr	-286(ra) # 6e4 <putc>
 80a:	a019                	j	810 <vprintf+0x60>
    } else if(state == '%'){
 80c:	01498f63          	beq	s3,s4,82a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 810:	0485                	addi	s1,s1,1
 812:	fff4c903          	lbu	s2,-1(s1)
 816:	14090d63          	beqz	s2,970 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 81a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 81e:	fe0997e3          	bnez	s3,80c <vprintf+0x5c>
      if(c == '%'){
 822:	fd479ee3          	bne	a5,s4,7fe <vprintf+0x4e>
        state = '%';
 826:	89be                	mv	s3,a5
 828:	b7e5                	j	810 <vprintf+0x60>
      if(c == 'd'){
 82a:	05878063          	beq	a5,s8,86a <vprintf+0xba>
      } else if(c == 'l') {
 82e:	05978c63          	beq	a5,s9,886 <vprintf+0xd6>
      } else if(c == 'x') {
 832:	07a78863          	beq	a5,s10,8a2 <vprintf+0xf2>
      } else if(c == 'p') {
 836:	09b78463          	beq	a5,s11,8be <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 83a:	07300713          	li	a4,115
 83e:	0ce78663          	beq	a5,a4,90a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 842:	06300713          	li	a4,99
 846:	0ee78e63          	beq	a5,a4,942 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 84a:	11478863          	beq	a5,s4,95a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 84e:	85d2                	mv	a1,s4
 850:	8556                	mv	a0,s5
 852:	00000097          	auipc	ra,0x0
 856:	e92080e7          	jalr	-366(ra) # 6e4 <putc>
        putc(fd, c);
 85a:	85ca                	mv	a1,s2
 85c:	8556                	mv	a0,s5
 85e:	00000097          	auipc	ra,0x0
 862:	e86080e7          	jalr	-378(ra) # 6e4 <putc>
      }
      state = 0;
 866:	4981                	li	s3,0
 868:	b765                	j	810 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 86a:	008b0913          	addi	s2,s6,8
 86e:	4685                	li	a3,1
 870:	4629                	li	a2,10
 872:	000b2583          	lw	a1,0(s6)
 876:	8556                	mv	a0,s5
 878:	00000097          	auipc	ra,0x0
 87c:	e8e080e7          	jalr	-370(ra) # 706 <printint>
 880:	8b4a                	mv	s6,s2
      state = 0;
 882:	4981                	li	s3,0
 884:	b771                	j	810 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 886:	008b0913          	addi	s2,s6,8
 88a:	4681                	li	a3,0
 88c:	4629                	li	a2,10
 88e:	000b2583          	lw	a1,0(s6)
 892:	8556                	mv	a0,s5
 894:	00000097          	auipc	ra,0x0
 898:	e72080e7          	jalr	-398(ra) # 706 <printint>
 89c:	8b4a                	mv	s6,s2
      state = 0;
 89e:	4981                	li	s3,0
 8a0:	bf85                	j	810 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 8a2:	008b0913          	addi	s2,s6,8
 8a6:	4681                	li	a3,0
 8a8:	4641                	li	a2,16
 8aa:	000b2583          	lw	a1,0(s6)
 8ae:	8556                	mv	a0,s5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	e56080e7          	jalr	-426(ra) # 706 <printint>
 8b8:	8b4a                	mv	s6,s2
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	bf91                	j	810 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8be:	008b0793          	addi	a5,s6,8
 8c2:	f8f43423          	sd	a5,-120(s0)
 8c6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8ca:	03000593          	li	a1,48
 8ce:	8556                	mv	a0,s5
 8d0:	00000097          	auipc	ra,0x0
 8d4:	e14080e7          	jalr	-492(ra) # 6e4 <putc>
  putc(fd, 'x');
 8d8:	85ea                	mv	a1,s10
 8da:	8556                	mv	a0,s5
 8dc:	00000097          	auipc	ra,0x0
 8e0:	e08080e7          	jalr	-504(ra) # 6e4 <putc>
 8e4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8e6:	03c9d793          	srli	a5,s3,0x3c
 8ea:	97de                	add	a5,a5,s7
 8ec:	0007c583          	lbu	a1,0(a5)
 8f0:	8556                	mv	a0,s5
 8f2:	00000097          	auipc	ra,0x0
 8f6:	df2080e7          	jalr	-526(ra) # 6e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8fa:	0992                	slli	s3,s3,0x4
 8fc:	397d                	addiw	s2,s2,-1
 8fe:	fe0914e3          	bnez	s2,8e6 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 902:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 906:	4981                	li	s3,0
 908:	b721                	j	810 <vprintf+0x60>
        s = va_arg(ap, char*);
 90a:	008b0993          	addi	s3,s6,8
 90e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 912:	02090163          	beqz	s2,934 <vprintf+0x184>
        while(*s != 0){
 916:	00094583          	lbu	a1,0(s2)
 91a:	c9a1                	beqz	a1,96a <vprintf+0x1ba>
          putc(fd, *s);
 91c:	8556                	mv	a0,s5
 91e:	00000097          	auipc	ra,0x0
 922:	dc6080e7          	jalr	-570(ra) # 6e4 <putc>
          s++;
 926:	0905                	addi	s2,s2,1
        while(*s != 0){
 928:	00094583          	lbu	a1,0(s2)
 92c:	f9e5                	bnez	a1,91c <vprintf+0x16c>
        s = va_arg(ap, char*);
 92e:	8b4e                	mv	s6,s3
      state = 0;
 930:	4981                	li	s3,0
 932:	bdf9                	j	810 <vprintf+0x60>
          s = "(null)";
 934:	00000917          	auipc	s2,0x0
 938:	3c490913          	addi	s2,s2,964 # cf8 <malloc+0x27e>
        while(*s != 0){
 93c:	02800593          	li	a1,40
 940:	bff1                	j	91c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 942:	008b0913          	addi	s2,s6,8
 946:	000b4583          	lbu	a1,0(s6)
 94a:	8556                	mv	a0,s5
 94c:	00000097          	auipc	ra,0x0
 950:	d98080e7          	jalr	-616(ra) # 6e4 <putc>
 954:	8b4a                	mv	s6,s2
      state = 0;
 956:	4981                	li	s3,0
 958:	bd65                	j	810 <vprintf+0x60>
        putc(fd, c);
 95a:	85d2                	mv	a1,s4
 95c:	8556                	mv	a0,s5
 95e:	00000097          	auipc	ra,0x0
 962:	d86080e7          	jalr	-634(ra) # 6e4 <putc>
      state = 0;
 966:	4981                	li	s3,0
 968:	b565                	j	810 <vprintf+0x60>
        s = va_arg(ap, char*);
 96a:	8b4e                	mv	s6,s3
      state = 0;
 96c:	4981                	li	s3,0
 96e:	b54d                	j	810 <vprintf+0x60>
    }
  }
}
 970:	70e6                	ld	ra,120(sp)
 972:	7446                	ld	s0,112(sp)
 974:	74a6                	ld	s1,104(sp)
 976:	7906                	ld	s2,96(sp)
 978:	69e6                	ld	s3,88(sp)
 97a:	6a46                	ld	s4,80(sp)
 97c:	6aa6                	ld	s5,72(sp)
 97e:	6b06                	ld	s6,64(sp)
 980:	7be2                	ld	s7,56(sp)
 982:	7c42                	ld	s8,48(sp)
 984:	7ca2                	ld	s9,40(sp)
 986:	7d02                	ld	s10,32(sp)
 988:	6de2                	ld	s11,24(sp)
 98a:	6109                	addi	sp,sp,128
 98c:	8082                	ret

000000000000098e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 98e:	715d                	addi	sp,sp,-80
 990:	ec06                	sd	ra,24(sp)
 992:	e822                	sd	s0,16(sp)
 994:	1000                	addi	s0,sp,32
 996:	e010                	sd	a2,0(s0)
 998:	e414                	sd	a3,8(s0)
 99a:	e818                	sd	a4,16(s0)
 99c:	ec1c                	sd	a5,24(s0)
 99e:	03043023          	sd	a6,32(s0)
 9a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9aa:	8622                	mv	a2,s0
 9ac:	00000097          	auipc	ra,0x0
 9b0:	e04080e7          	jalr	-508(ra) # 7b0 <vprintf>
}
 9b4:	60e2                	ld	ra,24(sp)
 9b6:	6442                	ld	s0,16(sp)
 9b8:	6161                	addi	sp,sp,80
 9ba:	8082                	ret

00000000000009bc <printf>:

void
printf(const char *fmt, ...)
{
 9bc:	711d                	addi	sp,sp,-96
 9be:	ec06                	sd	ra,24(sp)
 9c0:	e822                	sd	s0,16(sp)
 9c2:	1000                	addi	s0,sp,32
 9c4:	e40c                	sd	a1,8(s0)
 9c6:	e810                	sd	a2,16(s0)
 9c8:	ec14                	sd	a3,24(s0)
 9ca:	f018                	sd	a4,32(s0)
 9cc:	f41c                	sd	a5,40(s0)
 9ce:	03043823          	sd	a6,48(s0)
 9d2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9d6:	00840613          	addi	a2,s0,8
 9da:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9de:	85aa                	mv	a1,a0
 9e0:	4505                	li	a0,1
 9e2:	00000097          	auipc	ra,0x0
 9e6:	dce080e7          	jalr	-562(ra) # 7b0 <vprintf>
}
 9ea:	60e2                	ld	ra,24(sp)
 9ec:	6442                	ld	s0,16(sp)
 9ee:	6125                	addi	sp,sp,96
 9f0:	8082                	ret

00000000000009f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9f2:	1141                	addi	sp,sp,-16
 9f4:	e422                	sd	s0,8(sp)
 9f6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9f8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9fc:	00000797          	auipc	a5,0x0
 a00:	3247b783          	ld	a5,804(a5) # d20 <freep>
 a04:	a805                	j	a34 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a06:	4618                	lw	a4,8(a2)
 a08:	9db9                	addw	a1,a1,a4
 a0a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a0e:	6398                	ld	a4,0(a5)
 a10:	6318                	ld	a4,0(a4)
 a12:	fee53823          	sd	a4,-16(a0)
 a16:	a091                	j	a5a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a18:	ff852703          	lw	a4,-8(a0)
 a1c:	9e39                	addw	a2,a2,a4
 a1e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a20:	ff053703          	ld	a4,-16(a0)
 a24:	e398                	sd	a4,0(a5)
 a26:	a099                	j	a6c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a28:	6398                	ld	a4,0(a5)
 a2a:	00e7e463          	bltu	a5,a4,a32 <free+0x40>
 a2e:	00e6ea63          	bltu	a3,a4,a42 <free+0x50>
{
 a32:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a34:	fed7fae3          	bgeu	a5,a3,a28 <free+0x36>
 a38:	6398                	ld	a4,0(a5)
 a3a:	00e6e463          	bltu	a3,a4,a42 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a3e:	fee7eae3          	bltu	a5,a4,a32 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a42:	ff852583          	lw	a1,-8(a0)
 a46:	6390                	ld	a2,0(a5)
 a48:	02059713          	slli	a4,a1,0x20
 a4c:	9301                	srli	a4,a4,0x20
 a4e:	0712                	slli	a4,a4,0x4
 a50:	9736                	add	a4,a4,a3
 a52:	fae60ae3          	beq	a2,a4,a06 <free+0x14>
    bp->s.ptr = p->s.ptr;
 a56:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a5a:	4790                	lw	a2,8(a5)
 a5c:	02061713          	slli	a4,a2,0x20
 a60:	9301                	srli	a4,a4,0x20
 a62:	0712                	slli	a4,a4,0x4
 a64:	973e                	add	a4,a4,a5
 a66:	fae689e3          	beq	a3,a4,a18 <free+0x26>
  } else
    p->s.ptr = bp;
 a6a:	e394                	sd	a3,0(a5)
  freep = p;
 a6c:	00000717          	auipc	a4,0x0
 a70:	2af73a23          	sd	a5,692(a4) # d20 <freep>
}
 a74:	6422                	ld	s0,8(sp)
 a76:	0141                	addi	sp,sp,16
 a78:	8082                	ret

0000000000000a7a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a7a:	7139                	addi	sp,sp,-64
 a7c:	fc06                	sd	ra,56(sp)
 a7e:	f822                	sd	s0,48(sp)
 a80:	f426                	sd	s1,40(sp)
 a82:	f04a                	sd	s2,32(sp)
 a84:	ec4e                	sd	s3,24(sp)
 a86:	e852                	sd	s4,16(sp)
 a88:	e456                	sd	s5,8(sp)
 a8a:	e05a                	sd	s6,0(sp)
 a8c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a8e:	02051493          	slli	s1,a0,0x20
 a92:	9081                	srli	s1,s1,0x20
 a94:	04bd                	addi	s1,s1,15
 a96:	8091                	srli	s1,s1,0x4
 a98:	0014899b          	addiw	s3,s1,1
 a9c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a9e:	00000517          	auipc	a0,0x0
 aa2:	28253503          	ld	a0,642(a0) # d20 <freep>
 aa6:	c515                	beqz	a0,ad2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aaa:	4798                	lw	a4,8(a5)
 aac:	02977f63          	bgeu	a4,s1,aea <malloc+0x70>
 ab0:	8a4e                	mv	s4,s3
 ab2:	0009871b          	sext.w	a4,s3
 ab6:	6685                	lui	a3,0x1
 ab8:	00d77363          	bgeu	a4,a3,abe <malloc+0x44>
 abc:	6a05                	lui	s4,0x1
 abe:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ac2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ac6:	00000917          	auipc	s2,0x0
 aca:	25a90913          	addi	s2,s2,602 # d20 <freep>
  if(p == (char*)-1)
 ace:	5afd                	li	s5,-1
 ad0:	a88d                	j	b42 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 ad2:	00000797          	auipc	a5,0x0
 ad6:	25678793          	addi	a5,a5,598 # d28 <base>
 ada:	00000717          	auipc	a4,0x0
 ade:	24f73323          	sd	a5,582(a4) # d20 <freep>
 ae2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ae4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ae8:	b7e1                	j	ab0 <malloc+0x36>
      if(p->s.size == nunits)
 aea:	02e48b63          	beq	s1,a4,b20 <malloc+0xa6>
        p->s.size -= nunits;
 aee:	4137073b          	subw	a4,a4,s3
 af2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 af4:	1702                	slli	a4,a4,0x20
 af6:	9301                	srli	a4,a4,0x20
 af8:	0712                	slli	a4,a4,0x4
 afa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 afc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b00:	00000717          	auipc	a4,0x0
 b04:	22a73023          	sd	a0,544(a4) # d20 <freep>
      return (void*)(p + 1);
 b08:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b0c:	70e2                	ld	ra,56(sp)
 b0e:	7442                	ld	s0,48(sp)
 b10:	74a2                	ld	s1,40(sp)
 b12:	7902                	ld	s2,32(sp)
 b14:	69e2                	ld	s3,24(sp)
 b16:	6a42                	ld	s4,16(sp)
 b18:	6aa2                	ld	s5,8(sp)
 b1a:	6b02                	ld	s6,0(sp)
 b1c:	6121                	addi	sp,sp,64
 b1e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b20:	6398                	ld	a4,0(a5)
 b22:	e118                	sd	a4,0(a0)
 b24:	bff1                	j	b00 <malloc+0x86>
  hp->s.size = nu;
 b26:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b2a:	0541                	addi	a0,a0,16
 b2c:	00000097          	auipc	ra,0x0
 b30:	ec6080e7          	jalr	-314(ra) # 9f2 <free>
  return freep;
 b34:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b38:	d971                	beqz	a0,b0c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b3a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b3c:	4798                	lw	a4,8(a5)
 b3e:	fa9776e3          	bgeu	a4,s1,aea <malloc+0x70>
    if(p == freep)
 b42:	00093703          	ld	a4,0(s2)
 b46:	853e                	mv	a0,a5
 b48:	fef719e3          	bne	a4,a5,b3a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b4c:	8552                	mv	a0,s4
 b4e:	00000097          	auipc	ra,0x0
 b52:	b6e080e7          	jalr	-1170(ra) # 6bc <sbrk>
  if(p == (char*)-1)
 b56:	fd5518e3          	bne	a0,s5,b26 <malloc+0xac>
        return 0;
 b5a:	4501                	li	a0,0
 b5c:	bf45                	j	b0c <malloc+0x92>
