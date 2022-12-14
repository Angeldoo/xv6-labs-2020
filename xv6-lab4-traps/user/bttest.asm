
user/_bttest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  sleep(1);
   8:	4505                	li	a0,1
   a:	00000097          	auipc	ra,0x0
   e:	310080e7          	jalr	784(ra) # 31a <sleep>
  exit(0);
  12:	4501                	li	a0,0
  14:	00000097          	auipc	ra,0x0
  18:	276080e7          	jalr	630(ra) # 28a <exit>

000000000000001c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  1c:	1141                	addi	sp,sp,-16
  1e:	e422                	sd	s0,8(sp)
  20:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  22:	87aa                	mv	a5,a0
  24:	0585                	addi	a1,a1,1
  26:	0785                	addi	a5,a5,1
  28:	fff5c703          	lbu	a4,-1(a1)
  2c:	fee78fa3          	sb	a4,-1(a5)
  30:	fb75                	bnez	a4,24 <strcpy+0x8>
    ;
  return os;
}
  32:	6422                	ld	s0,8(sp)
  34:	0141                	addi	sp,sp,16
  36:	8082                	ret

0000000000000038 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  38:	1141                	addi	sp,sp,-16
  3a:	e422                	sd	s0,8(sp)
  3c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  3e:	00054783          	lbu	a5,0(a0)
  42:	cb91                	beqz	a5,56 <strcmp+0x1e>
  44:	0005c703          	lbu	a4,0(a1)
  48:	00f71763          	bne	a4,a5,56 <strcmp+0x1e>
    p++, q++;
  4c:	0505                	addi	a0,a0,1
  4e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  50:	00054783          	lbu	a5,0(a0)
  54:	fbe5                	bnez	a5,44 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  56:	0005c503          	lbu	a0,0(a1)
}
  5a:	40a7853b          	subw	a0,a5,a0
  5e:	6422                	ld	s0,8(sp)
  60:	0141                	addi	sp,sp,16
  62:	8082                	ret

0000000000000064 <strlen>:

uint
strlen(const char *s)
{
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	cf91                	beqz	a5,8a <strlen+0x26>
  70:	0505                	addi	a0,a0,1
  72:	87aa                	mv	a5,a0
  74:	4685                	li	a3,1
  76:	9e89                	subw	a3,a3,a0
  78:	00f6853b          	addw	a0,a3,a5
  7c:	0785                	addi	a5,a5,1
  7e:	fff7c703          	lbu	a4,-1(a5)
  82:	fb7d                	bnez	a4,78 <strlen+0x14>
    ;
  return n;
}
  84:	6422                	ld	s0,8(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret
  for(n = 0; s[n]; n++)
  8a:	4501                	li	a0,0
  8c:	bfe5                	j	84 <strlen+0x20>

000000000000008e <memset>:

void*
memset(void *dst, int c, uint n)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e422                	sd	s0,8(sp)
  92:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  94:	ca19                	beqz	a2,aa <memset+0x1c>
  96:	87aa                	mv	a5,a0
  98:	1602                	slli	a2,a2,0x20
  9a:	9201                	srli	a2,a2,0x20
  9c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  a4:	0785                	addi	a5,a5,1
  a6:	fee79de3          	bne	a5,a4,a0 <memset+0x12>
  }
  return dst;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strchr>:

char*
strchr(const char *s, char c)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cb99                	beqz	a5,d0 <strchr+0x20>
    if(*s == c)
  bc:	00f58763          	beq	a1,a5,ca <strchr+0x1a>
  for(; *s; s++)
  c0:	0505                	addi	a0,a0,1
  c2:	00054783          	lbu	a5,0(a0)
  c6:	fbfd                	bnez	a5,bc <strchr+0xc>
      return (char*)s;
  return 0;
  c8:	4501                	li	a0,0
}
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret
  return 0;
  d0:	4501                	li	a0,0
  d2:	bfe5                	j	ca <strchr+0x1a>

00000000000000d4 <gets>:

char*
gets(char *buf, int max)
{
  d4:	711d                	addi	sp,sp,-96
  d6:	ec86                	sd	ra,88(sp)
  d8:	e8a2                	sd	s0,80(sp)
  da:	e4a6                	sd	s1,72(sp)
  dc:	e0ca                	sd	s2,64(sp)
  de:	fc4e                	sd	s3,56(sp)
  e0:	f852                	sd	s4,48(sp)
  e2:	f456                	sd	s5,40(sp)
  e4:	f05a                	sd	s6,32(sp)
  e6:	ec5e                	sd	s7,24(sp)
  e8:	1080                	addi	s0,sp,96
  ea:	8baa                	mv	s7,a0
  ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  ee:	892a                	mv	s2,a0
  f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  f2:	4aa9                	li	s5,10
  f4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
  f6:	89a6                	mv	s3,s1
  f8:	2485                	addiw	s1,s1,1
  fa:	0344d863          	bge	s1,s4,12a <gets+0x56>
    cc = read(0, &c, 1);
  fe:	4605                	li	a2,1
 100:	faf40593          	addi	a1,s0,-81
 104:	4501                	li	a0,0
 106:	00000097          	auipc	ra,0x0
 10a:	19c080e7          	jalr	412(ra) # 2a2 <read>
    if(cc < 1)
 10e:	00a05e63          	blez	a0,12a <gets+0x56>
    buf[i++] = c;
 112:	faf44783          	lbu	a5,-81(s0)
 116:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 11a:	01578763          	beq	a5,s5,128 <gets+0x54>
 11e:	0905                	addi	s2,s2,1
 120:	fd679be3          	bne	a5,s6,f6 <gets+0x22>
  for(i=0; i+1 < max; ){
 124:	89a6                	mv	s3,s1
 126:	a011                	j	12a <gets+0x56>
 128:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 12a:	99de                	add	s3,s3,s7
 12c:	00098023          	sb	zero,0(s3)
  return buf;
}
 130:	855e                	mv	a0,s7
 132:	60e6                	ld	ra,88(sp)
 134:	6446                	ld	s0,80(sp)
 136:	64a6                	ld	s1,72(sp)
 138:	6906                	ld	s2,64(sp)
 13a:	79e2                	ld	s3,56(sp)
 13c:	7a42                	ld	s4,48(sp)
 13e:	7aa2                	ld	s5,40(sp)
 140:	7b02                	ld	s6,32(sp)
 142:	6be2                	ld	s7,24(sp)
 144:	6125                	addi	sp,sp,96
 146:	8082                	ret

0000000000000148 <stat>:

int
stat(const char *n, struct stat *st)
{
 148:	1101                	addi	sp,sp,-32
 14a:	ec06                	sd	ra,24(sp)
 14c:	e822                	sd	s0,16(sp)
 14e:	e426                	sd	s1,8(sp)
 150:	e04a                	sd	s2,0(sp)
 152:	1000                	addi	s0,sp,32
 154:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 156:	4581                	li	a1,0
 158:	00000097          	auipc	ra,0x0
 15c:	172080e7          	jalr	370(ra) # 2ca <open>
  if(fd < 0)
 160:	02054563          	bltz	a0,18a <stat+0x42>
 164:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 166:	85ca                	mv	a1,s2
 168:	00000097          	auipc	ra,0x0
 16c:	17a080e7          	jalr	378(ra) # 2e2 <fstat>
 170:	892a                	mv	s2,a0
  close(fd);
 172:	8526                	mv	a0,s1
 174:	00000097          	auipc	ra,0x0
 178:	13e080e7          	jalr	318(ra) # 2b2 <close>
  return r;
}
 17c:	854a                	mv	a0,s2
 17e:	60e2                	ld	ra,24(sp)
 180:	6442                	ld	s0,16(sp)
 182:	64a2                	ld	s1,8(sp)
 184:	6902                	ld	s2,0(sp)
 186:	6105                	addi	sp,sp,32
 188:	8082                	ret
    return -1;
 18a:	597d                	li	s2,-1
 18c:	bfc5                	j	17c <stat+0x34>

000000000000018e <atoi>:

int
atoi(const char *s)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 194:	00054603          	lbu	a2,0(a0)
 198:	fd06079b          	addiw	a5,a2,-48
 19c:	0ff7f793          	andi	a5,a5,255
 1a0:	4725                	li	a4,9
 1a2:	02f76963          	bltu	a4,a5,1d4 <atoi+0x46>
 1a6:	86aa                	mv	a3,a0
  n = 0;
 1a8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1aa:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1ac:	0685                	addi	a3,a3,1
 1ae:	0025179b          	slliw	a5,a0,0x2
 1b2:	9fa9                	addw	a5,a5,a0
 1b4:	0017979b          	slliw	a5,a5,0x1
 1b8:	9fb1                	addw	a5,a5,a2
 1ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1be:	0006c603          	lbu	a2,0(a3)
 1c2:	fd06071b          	addiw	a4,a2,-48
 1c6:	0ff77713          	andi	a4,a4,255
 1ca:	fee5f1e3          	bgeu	a1,a4,1ac <atoi+0x1e>
  return n;
}
 1ce:	6422                	ld	s0,8(sp)
 1d0:	0141                	addi	sp,sp,16
 1d2:	8082                	ret
  n = 0;
 1d4:	4501                	li	a0,0
 1d6:	bfe5                	j	1ce <atoi+0x40>

00000000000001d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1de:	02b57463          	bgeu	a0,a1,206 <memmove+0x2e>
    while(n-- > 0)
 1e2:	00c05f63          	blez	a2,200 <memmove+0x28>
 1e6:	1602                	slli	a2,a2,0x20
 1e8:	9201                	srli	a2,a2,0x20
 1ea:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1ee:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f0:	0585                	addi	a1,a1,1
 1f2:	0705                	addi	a4,a4,1
 1f4:	fff5c683          	lbu	a3,-1(a1)
 1f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fc:	fee79ae3          	bne	a5,a4,1f0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret
    dst += n;
 206:	00c50733          	add	a4,a0,a2
    src += n;
 20a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20c:	fec05ae3          	blez	a2,200 <memmove+0x28>
 210:	fff6079b          	addiw	a5,a2,-1
 214:	1782                	slli	a5,a5,0x20
 216:	9381                	srli	a5,a5,0x20
 218:	fff7c793          	not	a5,a5
 21c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 21e:	15fd                	addi	a1,a1,-1
 220:	177d                	addi	a4,a4,-1
 222:	0005c683          	lbu	a3,0(a1)
 226:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22a:	fee79ae3          	bne	a5,a4,21e <memmove+0x46>
 22e:	bfc9                	j	200 <memmove+0x28>

0000000000000230 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 236:	ca05                	beqz	a2,266 <memcmp+0x36>
 238:	fff6069b          	addiw	a3,a2,-1
 23c:	1682                	slli	a3,a3,0x20
 23e:	9281                	srli	a3,a3,0x20
 240:	0685                	addi	a3,a3,1
 242:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 244:	00054783          	lbu	a5,0(a0)
 248:	0005c703          	lbu	a4,0(a1)
 24c:	00e79863          	bne	a5,a4,25c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 250:	0505                	addi	a0,a0,1
    p2++;
 252:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 254:	fed518e3          	bne	a0,a3,244 <memcmp+0x14>
  }
  return 0;
 258:	4501                	li	a0,0
 25a:	a019                	j	260 <memcmp+0x30>
      return *p1 - *p2;
 25c:	40e7853b          	subw	a0,a5,a4
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
  return 0;
 266:	4501                	li	a0,0
 268:	bfe5                	j	260 <memcmp+0x30>

000000000000026a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e406                	sd	ra,8(sp)
 26e:	e022                	sd	s0,0(sp)
 270:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 272:	00000097          	auipc	ra,0x0
 276:	f66080e7          	jalr	-154(ra) # 1d8 <memmove>
}
 27a:	60a2                	ld	ra,8(sp)
 27c:	6402                	ld	s0,0(sp)
 27e:	0141                	addi	sp,sp,16
 280:	8082                	ret

0000000000000282 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 282:	4885                	li	a7,1
 ecall
 284:	00000073          	ecall
 ret
 288:	8082                	ret

000000000000028a <exit>:
.global exit
exit:
 li a7, SYS_exit
 28a:	4889                	li	a7,2
 ecall
 28c:	00000073          	ecall
 ret
 290:	8082                	ret

0000000000000292 <wait>:
.global wait
wait:
 li a7, SYS_wait
 292:	488d                	li	a7,3
 ecall
 294:	00000073          	ecall
 ret
 298:	8082                	ret

000000000000029a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 29a:	4891                	li	a7,4
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <read>:
.global read
read:
 li a7, SYS_read
 2a2:	4895                	li	a7,5
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <write>:
.global write
write:
 li a7, SYS_write
 2aa:	48c1                	li	a7,16
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <close>:
.global close
close:
 li a7, SYS_close
 2b2:	48d5                	li	a7,21
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ba:	4899                	li	a7,6
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c2:	489d                	li	a7,7
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <open>:
.global open
open:
 li a7, SYS_open
 2ca:	48bd                	li	a7,15
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d2:	48c5                	li	a7,17
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2da:	48c9                	li	a7,18
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e2:	48a1                	li	a7,8
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <link>:
.global link
link:
 li a7, SYS_link
 2ea:	48cd                	li	a7,19
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f2:	48d1                	li	a7,20
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2fa:	48a5                	li	a7,9
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <dup>:
.global dup
dup:
 li a7, SYS_dup
 302:	48a9                	li	a7,10
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 30a:	48ad                	li	a7,11
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 312:	48b1                	li	a7,12
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 31a:	48b5                	li	a7,13
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 322:	48b9                	li	a7,14
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 32a:	48d9                	li	a7,22
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 332:	48dd                	li	a7,23
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 33a:	1101                	addi	sp,sp,-32
 33c:	ec06                	sd	ra,24(sp)
 33e:	e822                	sd	s0,16(sp)
 340:	1000                	addi	s0,sp,32
 342:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 346:	4605                	li	a2,1
 348:	fef40593          	addi	a1,s0,-17
 34c:	00000097          	auipc	ra,0x0
 350:	f5e080e7          	jalr	-162(ra) # 2aa <write>
}
 354:	60e2                	ld	ra,24(sp)
 356:	6442                	ld	s0,16(sp)
 358:	6105                	addi	sp,sp,32
 35a:	8082                	ret

000000000000035c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35c:	7139                	addi	sp,sp,-64
 35e:	fc06                	sd	ra,56(sp)
 360:	f822                	sd	s0,48(sp)
 362:	f426                	sd	s1,40(sp)
 364:	f04a                	sd	s2,32(sp)
 366:	ec4e                	sd	s3,24(sp)
 368:	0080                	addi	s0,sp,64
 36a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36c:	c299                	beqz	a3,372 <printint+0x16>
 36e:	0805c863          	bltz	a1,3fe <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 372:	2581                	sext.w	a1,a1
  neg = 0;
 374:	4881                	li	a7,0
 376:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 37a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 37c:	2601                	sext.w	a2,a2
 37e:	00000517          	auipc	a0,0x0
 382:	44250513          	addi	a0,a0,1090 # 7c0 <digits>
 386:	883a                	mv	a6,a4
 388:	2705                	addiw	a4,a4,1
 38a:	02c5f7bb          	remuw	a5,a1,a2
 38e:	1782                	slli	a5,a5,0x20
 390:	9381                	srli	a5,a5,0x20
 392:	97aa                	add	a5,a5,a0
 394:	0007c783          	lbu	a5,0(a5)
 398:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 39c:	0005879b          	sext.w	a5,a1
 3a0:	02c5d5bb          	divuw	a1,a1,a2
 3a4:	0685                	addi	a3,a3,1
 3a6:	fec7f0e3          	bgeu	a5,a2,386 <printint+0x2a>
  if(neg)
 3aa:	00088b63          	beqz	a7,3c0 <printint+0x64>
    buf[i++] = '-';
 3ae:	fd040793          	addi	a5,s0,-48
 3b2:	973e                	add	a4,a4,a5
 3b4:	02d00793          	li	a5,45
 3b8:	fef70823          	sb	a5,-16(a4)
 3bc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3c0:	02e05863          	blez	a4,3f0 <printint+0x94>
 3c4:	fc040793          	addi	a5,s0,-64
 3c8:	00e78933          	add	s2,a5,a4
 3cc:	fff78993          	addi	s3,a5,-1
 3d0:	99ba                	add	s3,s3,a4
 3d2:	377d                	addiw	a4,a4,-1
 3d4:	1702                	slli	a4,a4,0x20
 3d6:	9301                	srli	a4,a4,0x20
 3d8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3dc:	fff94583          	lbu	a1,-1(s2)
 3e0:	8526                	mv	a0,s1
 3e2:	00000097          	auipc	ra,0x0
 3e6:	f58080e7          	jalr	-168(ra) # 33a <putc>
  while(--i >= 0)
 3ea:	197d                	addi	s2,s2,-1
 3ec:	ff3918e3          	bne	s2,s3,3dc <printint+0x80>
}
 3f0:	70e2                	ld	ra,56(sp)
 3f2:	7442                	ld	s0,48(sp)
 3f4:	74a2                	ld	s1,40(sp)
 3f6:	7902                	ld	s2,32(sp)
 3f8:	69e2                	ld	s3,24(sp)
 3fa:	6121                	addi	sp,sp,64
 3fc:	8082                	ret
    x = -xx;
 3fe:	40b005bb          	negw	a1,a1
    neg = 1;
 402:	4885                	li	a7,1
    x = -xx;
 404:	bf8d                	j	376 <printint+0x1a>

0000000000000406 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 406:	7119                	addi	sp,sp,-128
 408:	fc86                	sd	ra,120(sp)
 40a:	f8a2                	sd	s0,112(sp)
 40c:	f4a6                	sd	s1,104(sp)
 40e:	f0ca                	sd	s2,96(sp)
 410:	ecce                	sd	s3,88(sp)
 412:	e8d2                	sd	s4,80(sp)
 414:	e4d6                	sd	s5,72(sp)
 416:	e0da                	sd	s6,64(sp)
 418:	fc5e                	sd	s7,56(sp)
 41a:	f862                	sd	s8,48(sp)
 41c:	f466                	sd	s9,40(sp)
 41e:	f06a                	sd	s10,32(sp)
 420:	ec6e                	sd	s11,24(sp)
 422:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 424:	0005c903          	lbu	s2,0(a1)
 428:	18090f63          	beqz	s2,5c6 <vprintf+0x1c0>
 42c:	8aaa                	mv	s5,a0
 42e:	8b32                	mv	s6,a2
 430:	00158493          	addi	s1,a1,1
  state = 0;
 434:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 436:	02500a13          	li	s4,37
      if(c == 'd'){
 43a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 43e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 442:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 446:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 44a:	00000b97          	auipc	s7,0x0
 44e:	376b8b93          	addi	s7,s7,886 # 7c0 <digits>
 452:	a839                	j	470 <vprintf+0x6a>
        putc(fd, c);
 454:	85ca                	mv	a1,s2
 456:	8556                	mv	a0,s5
 458:	00000097          	auipc	ra,0x0
 45c:	ee2080e7          	jalr	-286(ra) # 33a <putc>
 460:	a019                	j	466 <vprintf+0x60>
    } else if(state == '%'){
 462:	01498f63          	beq	s3,s4,480 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 466:	0485                	addi	s1,s1,1
 468:	fff4c903          	lbu	s2,-1(s1)
 46c:	14090d63          	beqz	s2,5c6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 470:	0009079b          	sext.w	a5,s2
    if(state == 0){
 474:	fe0997e3          	bnez	s3,462 <vprintf+0x5c>
      if(c == '%'){
 478:	fd479ee3          	bne	a5,s4,454 <vprintf+0x4e>
        state = '%';
 47c:	89be                	mv	s3,a5
 47e:	b7e5                	j	466 <vprintf+0x60>
      if(c == 'd'){
 480:	05878063          	beq	a5,s8,4c0 <vprintf+0xba>
      } else if(c == 'l') {
 484:	05978c63          	beq	a5,s9,4dc <vprintf+0xd6>
      } else if(c == 'x') {
 488:	07a78863          	beq	a5,s10,4f8 <vprintf+0xf2>
      } else if(c == 'p') {
 48c:	09b78463          	beq	a5,s11,514 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 490:	07300713          	li	a4,115
 494:	0ce78663          	beq	a5,a4,560 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 498:	06300713          	li	a4,99
 49c:	0ee78e63          	beq	a5,a4,598 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4a0:	11478863          	beq	a5,s4,5b0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4a4:	85d2                	mv	a1,s4
 4a6:	8556                	mv	a0,s5
 4a8:	00000097          	auipc	ra,0x0
 4ac:	e92080e7          	jalr	-366(ra) # 33a <putc>
        putc(fd, c);
 4b0:	85ca                	mv	a1,s2
 4b2:	8556                	mv	a0,s5
 4b4:	00000097          	auipc	ra,0x0
 4b8:	e86080e7          	jalr	-378(ra) # 33a <putc>
      }
      state = 0;
 4bc:	4981                	li	s3,0
 4be:	b765                	j	466 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4c0:	008b0913          	addi	s2,s6,8
 4c4:	4685                	li	a3,1
 4c6:	4629                	li	a2,10
 4c8:	000b2583          	lw	a1,0(s6)
 4cc:	8556                	mv	a0,s5
 4ce:	00000097          	auipc	ra,0x0
 4d2:	e8e080e7          	jalr	-370(ra) # 35c <printint>
 4d6:	8b4a                	mv	s6,s2
      state = 0;
 4d8:	4981                	li	s3,0
 4da:	b771                	j	466 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4dc:	008b0913          	addi	s2,s6,8
 4e0:	4681                	li	a3,0
 4e2:	4629                	li	a2,10
 4e4:	000b2583          	lw	a1,0(s6)
 4e8:	8556                	mv	a0,s5
 4ea:	00000097          	auipc	ra,0x0
 4ee:	e72080e7          	jalr	-398(ra) # 35c <printint>
 4f2:	8b4a                	mv	s6,s2
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	bf85                	j	466 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4f8:	008b0913          	addi	s2,s6,8
 4fc:	4681                	li	a3,0
 4fe:	4641                	li	a2,16
 500:	000b2583          	lw	a1,0(s6)
 504:	8556                	mv	a0,s5
 506:	00000097          	auipc	ra,0x0
 50a:	e56080e7          	jalr	-426(ra) # 35c <printint>
 50e:	8b4a                	mv	s6,s2
      state = 0;
 510:	4981                	li	s3,0
 512:	bf91                	j	466 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 514:	008b0793          	addi	a5,s6,8
 518:	f8f43423          	sd	a5,-120(s0)
 51c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 520:	03000593          	li	a1,48
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	e14080e7          	jalr	-492(ra) # 33a <putc>
  putc(fd, 'x');
 52e:	85ea                	mv	a1,s10
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	e08080e7          	jalr	-504(ra) # 33a <putc>
 53a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 53c:	03c9d793          	srli	a5,s3,0x3c
 540:	97de                	add	a5,a5,s7
 542:	0007c583          	lbu	a1,0(a5)
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	df2080e7          	jalr	-526(ra) # 33a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 550:	0992                	slli	s3,s3,0x4
 552:	397d                	addiw	s2,s2,-1
 554:	fe0914e3          	bnez	s2,53c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 558:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 55c:	4981                	li	s3,0
 55e:	b721                	j	466 <vprintf+0x60>
        s = va_arg(ap, char*);
 560:	008b0993          	addi	s3,s6,8
 564:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 568:	02090163          	beqz	s2,58a <vprintf+0x184>
        while(*s != 0){
 56c:	00094583          	lbu	a1,0(s2)
 570:	c9a1                	beqz	a1,5c0 <vprintf+0x1ba>
          putc(fd, *s);
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	dc6080e7          	jalr	-570(ra) # 33a <putc>
          s++;
 57c:	0905                	addi	s2,s2,1
        while(*s != 0){
 57e:	00094583          	lbu	a1,0(s2)
 582:	f9e5                	bnez	a1,572 <vprintf+0x16c>
        s = va_arg(ap, char*);
 584:	8b4e                	mv	s6,s3
      state = 0;
 586:	4981                	li	s3,0
 588:	bdf9                	j	466 <vprintf+0x60>
          s = "(null)";
 58a:	00000917          	auipc	s2,0x0
 58e:	22e90913          	addi	s2,s2,558 # 7b8 <malloc+0xe8>
        while(*s != 0){
 592:	02800593          	li	a1,40
 596:	bff1                	j	572 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 598:	008b0913          	addi	s2,s6,8
 59c:	000b4583          	lbu	a1,0(s6)
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	d98080e7          	jalr	-616(ra) # 33a <putc>
 5aa:	8b4a                	mv	s6,s2
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	bd65                	j	466 <vprintf+0x60>
        putc(fd, c);
 5b0:	85d2                	mv	a1,s4
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	d86080e7          	jalr	-634(ra) # 33a <putc>
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b565                	j	466 <vprintf+0x60>
        s = va_arg(ap, char*);
 5c0:	8b4e                	mv	s6,s3
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b54d                	j	466 <vprintf+0x60>
    }
  }
}
 5c6:	70e6                	ld	ra,120(sp)
 5c8:	7446                	ld	s0,112(sp)
 5ca:	74a6                	ld	s1,104(sp)
 5cc:	7906                	ld	s2,96(sp)
 5ce:	69e6                	ld	s3,88(sp)
 5d0:	6a46                	ld	s4,80(sp)
 5d2:	6aa6                	ld	s5,72(sp)
 5d4:	6b06                	ld	s6,64(sp)
 5d6:	7be2                	ld	s7,56(sp)
 5d8:	7c42                	ld	s8,48(sp)
 5da:	7ca2                	ld	s9,40(sp)
 5dc:	7d02                	ld	s10,32(sp)
 5de:	6de2                	ld	s11,24(sp)
 5e0:	6109                	addi	sp,sp,128
 5e2:	8082                	ret

00000000000005e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5e4:	715d                	addi	sp,sp,-80
 5e6:	ec06                	sd	ra,24(sp)
 5e8:	e822                	sd	s0,16(sp)
 5ea:	1000                	addi	s0,sp,32
 5ec:	e010                	sd	a2,0(s0)
 5ee:	e414                	sd	a3,8(s0)
 5f0:	e818                	sd	a4,16(s0)
 5f2:	ec1c                	sd	a5,24(s0)
 5f4:	03043023          	sd	a6,32(s0)
 5f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 600:	8622                	mv	a2,s0
 602:	00000097          	auipc	ra,0x0
 606:	e04080e7          	jalr	-508(ra) # 406 <vprintf>
}
 60a:	60e2                	ld	ra,24(sp)
 60c:	6442                	ld	s0,16(sp)
 60e:	6161                	addi	sp,sp,80
 610:	8082                	ret

0000000000000612 <printf>:

void
printf(const char *fmt, ...)
{
 612:	711d                	addi	sp,sp,-96
 614:	ec06                	sd	ra,24(sp)
 616:	e822                	sd	s0,16(sp)
 618:	1000                	addi	s0,sp,32
 61a:	e40c                	sd	a1,8(s0)
 61c:	e810                	sd	a2,16(s0)
 61e:	ec14                	sd	a3,24(s0)
 620:	f018                	sd	a4,32(s0)
 622:	f41c                	sd	a5,40(s0)
 624:	03043823          	sd	a6,48(s0)
 628:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 62c:	00840613          	addi	a2,s0,8
 630:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 634:	85aa                	mv	a1,a0
 636:	4505                	li	a0,1
 638:	00000097          	auipc	ra,0x0
 63c:	dce080e7          	jalr	-562(ra) # 406 <vprintf>
}
 640:	60e2                	ld	ra,24(sp)
 642:	6442                	ld	s0,16(sp)
 644:	6125                	addi	sp,sp,96
 646:	8082                	ret

0000000000000648 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 648:	1141                	addi	sp,sp,-16
 64a:	e422                	sd	s0,8(sp)
 64c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 64e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 652:	00000797          	auipc	a5,0x0
 656:	1867b783          	ld	a5,390(a5) # 7d8 <freep>
 65a:	a805                	j	68a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 65c:	4618                	lw	a4,8(a2)
 65e:	9db9                	addw	a1,a1,a4
 660:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 664:	6398                	ld	a4,0(a5)
 666:	6318                	ld	a4,0(a4)
 668:	fee53823          	sd	a4,-16(a0)
 66c:	a091                	j	6b0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 66e:	ff852703          	lw	a4,-8(a0)
 672:	9e39                	addw	a2,a2,a4
 674:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 676:	ff053703          	ld	a4,-16(a0)
 67a:	e398                	sd	a4,0(a5)
 67c:	a099                	j	6c2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67e:	6398                	ld	a4,0(a5)
 680:	00e7e463          	bltu	a5,a4,688 <free+0x40>
 684:	00e6ea63          	bltu	a3,a4,698 <free+0x50>
{
 688:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68a:	fed7fae3          	bgeu	a5,a3,67e <free+0x36>
 68e:	6398                	ld	a4,0(a5)
 690:	00e6e463          	bltu	a3,a4,698 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 694:	fee7eae3          	bltu	a5,a4,688 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 698:	ff852583          	lw	a1,-8(a0)
 69c:	6390                	ld	a2,0(a5)
 69e:	02059713          	slli	a4,a1,0x20
 6a2:	9301                	srli	a4,a4,0x20
 6a4:	0712                	slli	a4,a4,0x4
 6a6:	9736                	add	a4,a4,a3
 6a8:	fae60ae3          	beq	a2,a4,65c <free+0x14>
    bp->s.ptr = p->s.ptr;
 6ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6b0:	4790                	lw	a2,8(a5)
 6b2:	02061713          	slli	a4,a2,0x20
 6b6:	9301                	srli	a4,a4,0x20
 6b8:	0712                	slli	a4,a4,0x4
 6ba:	973e                	add	a4,a4,a5
 6bc:	fae689e3          	beq	a3,a4,66e <free+0x26>
  } else
    p->s.ptr = bp;
 6c0:	e394                	sd	a3,0(a5)
  freep = p;
 6c2:	00000717          	auipc	a4,0x0
 6c6:	10f73b23          	sd	a5,278(a4) # 7d8 <freep>
}
 6ca:	6422                	ld	s0,8(sp)
 6cc:	0141                	addi	sp,sp,16
 6ce:	8082                	ret

00000000000006d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d0:	7139                	addi	sp,sp,-64
 6d2:	fc06                	sd	ra,56(sp)
 6d4:	f822                	sd	s0,48(sp)
 6d6:	f426                	sd	s1,40(sp)
 6d8:	f04a                	sd	s2,32(sp)
 6da:	ec4e                	sd	s3,24(sp)
 6dc:	e852                	sd	s4,16(sp)
 6de:	e456                	sd	s5,8(sp)
 6e0:	e05a                	sd	s6,0(sp)
 6e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e4:	02051493          	slli	s1,a0,0x20
 6e8:	9081                	srli	s1,s1,0x20
 6ea:	04bd                	addi	s1,s1,15
 6ec:	8091                	srli	s1,s1,0x4
 6ee:	0014899b          	addiw	s3,s1,1
 6f2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6f4:	00000517          	auipc	a0,0x0
 6f8:	0e453503          	ld	a0,228(a0) # 7d8 <freep>
 6fc:	c515                	beqz	a0,728 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 700:	4798                	lw	a4,8(a5)
 702:	02977f63          	bgeu	a4,s1,740 <malloc+0x70>
 706:	8a4e                	mv	s4,s3
 708:	0009871b          	sext.w	a4,s3
 70c:	6685                	lui	a3,0x1
 70e:	00d77363          	bgeu	a4,a3,714 <malloc+0x44>
 712:	6a05                	lui	s4,0x1
 714:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 718:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 71c:	00000917          	auipc	s2,0x0
 720:	0bc90913          	addi	s2,s2,188 # 7d8 <freep>
  if(p == (char*)-1)
 724:	5afd                	li	s5,-1
 726:	a88d                	j	798 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 728:	00000797          	auipc	a5,0x0
 72c:	0b878793          	addi	a5,a5,184 # 7e0 <base>
 730:	00000717          	auipc	a4,0x0
 734:	0af73423          	sd	a5,168(a4) # 7d8 <freep>
 738:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 73a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 73e:	b7e1                	j	706 <malloc+0x36>
      if(p->s.size == nunits)
 740:	02e48b63          	beq	s1,a4,776 <malloc+0xa6>
        p->s.size -= nunits;
 744:	4137073b          	subw	a4,a4,s3
 748:	c798                	sw	a4,8(a5)
        p += p->s.size;
 74a:	1702                	slli	a4,a4,0x20
 74c:	9301                	srli	a4,a4,0x20
 74e:	0712                	slli	a4,a4,0x4
 750:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 752:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 756:	00000717          	auipc	a4,0x0
 75a:	08a73123          	sd	a0,130(a4) # 7d8 <freep>
      return (void*)(p + 1);
 75e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 762:	70e2                	ld	ra,56(sp)
 764:	7442                	ld	s0,48(sp)
 766:	74a2                	ld	s1,40(sp)
 768:	7902                	ld	s2,32(sp)
 76a:	69e2                	ld	s3,24(sp)
 76c:	6a42                	ld	s4,16(sp)
 76e:	6aa2                	ld	s5,8(sp)
 770:	6b02                	ld	s6,0(sp)
 772:	6121                	addi	sp,sp,64
 774:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 776:	6398                	ld	a4,0(a5)
 778:	e118                	sd	a4,0(a0)
 77a:	bff1                	j	756 <malloc+0x86>
  hp->s.size = nu;
 77c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 780:	0541                	addi	a0,a0,16
 782:	00000097          	auipc	ra,0x0
 786:	ec6080e7          	jalr	-314(ra) # 648 <free>
  return freep;
 78a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 78e:	d971                	beqz	a0,762 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 790:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 792:	4798                	lw	a4,8(a5)
 794:	fa9776e3          	bgeu	a4,s1,740 <malloc+0x70>
    if(p == freep)
 798:	00093703          	ld	a4,0(s2)
 79c:	853e                	mv	a0,a5
 79e:	fef719e3          	bne	a4,a5,790 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7a2:	8552                	mv	a0,s4
 7a4:	00000097          	auipc	ra,0x0
 7a8:	b6e080e7          	jalr	-1170(ra) # 312 <sbrk>
  if(p == (char*)-1)
 7ac:	fd5518e3          	bne	a0,s5,77c <malloc+0xac>
        return 0;
 7b0:	4501                	li	a0,0
 7b2:	bf45                	j	762 <malloc+0x92>
