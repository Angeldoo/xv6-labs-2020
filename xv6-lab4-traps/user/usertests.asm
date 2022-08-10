
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	39e080e7          	jalr	926(ra) # 53ae <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	38c080e7          	jalr	908(ra) # 53ae <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	b5a50513          	addi	a0,a0,-1190 # 5b98 <malloc+0x3e4>
      46:	00005097          	auipc	ra,0x5
      4a:	6b0080e7          	jalr	1712(ra) # 56f6 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	31e080e7          	jalr	798(ra) # 536e <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	fd078793          	addi	a5,a5,-48 # 9028 <uninit>
      60:	0000b697          	auipc	a3,0xb
      64:	6d868693          	addi	a3,a3,1752 # b738 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	b3850513          	addi	a0,a0,-1224 # 5bb8 <malloc+0x404>
      88:	00005097          	auipc	ra,0x5
      8c:	66e080e7          	jalr	1646(ra) # 56f6 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	2dc080e7          	jalr	732(ra) # 536e <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	b2850513          	addi	a0,a0,-1240 # 5bd0 <malloc+0x41c>
      b0:	00005097          	auipc	ra,0x5
      b4:	2fe080e7          	jalr	766(ra) # 53ae <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	2da080e7          	jalr	730(ra) # 5396 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	b2a50513          	addi	a0,a0,-1238 # 5bf0 <malloc+0x43c>
      ce:	00005097          	auipc	ra,0x5
      d2:	2e0080e7          	jalr	736(ra) # 53ae <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	af250513          	addi	a0,a0,-1294 # 5bd8 <malloc+0x424>
      ee:	00005097          	auipc	ra,0x5
      f2:	608080e7          	jalr	1544(ra) # 56f6 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	276080e7          	jalr	630(ra) # 536e <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	afe50513          	addi	a0,a0,-1282 # 5c00 <malloc+0x44c>
     10a:	00005097          	auipc	ra,0x5
     10e:	5ec080e7          	jalr	1516(ra) # 56f6 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	25a080e7          	jalr	602(ra) # 536e <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	afc50513          	addi	a0,a0,-1284 # 5c28 <malloc+0x474>
     134:	00005097          	auipc	ra,0x5
     138:	28a080e7          	jalr	650(ra) # 53be <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	ae850513          	addi	a0,a0,-1304 # 5c28 <malloc+0x474>
     148:	00005097          	auipc	ra,0x5
     14c:	266080e7          	jalr	614(ra) # 53ae <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	ae458593          	addi	a1,a1,-1308 # 5c38 <malloc+0x484>
     15c:	00005097          	auipc	ra,0x5
     160:	232080e7          	jalr	562(ra) # 538e <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	ac050513          	addi	a0,a0,-1344 # 5c28 <malloc+0x474>
     170:	00005097          	auipc	ra,0x5
     174:	23e080e7          	jalr	574(ra) # 53ae <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	ac458593          	addi	a1,a1,-1340 # 5c40 <malloc+0x48c>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	208080e7          	jalr	520(ra) # 538e <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	a9450513          	addi	a0,a0,-1388 # 5c28 <malloc+0x474>
     19c:	00005097          	auipc	ra,0x5
     1a0:	222080e7          	jalr	546(ra) # 53be <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	1f0080e7          	jalr	496(ra) # 5396 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	1e6080e7          	jalr	486(ra) # 5396 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	a7e50513          	addi	a0,a0,-1410 # 5c48 <malloc+0x494>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	524080e7          	jalr	1316(ra) # 56f6 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	192080e7          	jalr	402(ra) # 536e <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	e44e                	sd	s3,8(sp)
     1f0:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f2:	00008797          	auipc	a5,0x8
     1f6:	d1e78793          	addi	a5,a5,-738 # 7f10 <name>
     1fa:	06100713          	li	a4,97
     1fe:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     202:	00078123          	sb	zero,2(a5)
     206:	03000493          	li	s1,48
    name[1] = '0' + i;
     20a:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     20c:	06400993          	li	s3,100
    name[1] = '0' + i;
     210:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     214:	20200593          	li	a1,514
     218:	854a                	mv	a0,s2
     21a:	00005097          	auipc	ra,0x5
     21e:	194080e7          	jalr	404(ra) # 53ae <open>
    close(fd);
     222:	00005097          	auipc	ra,0x5
     226:	174080e7          	jalr	372(ra) # 5396 <close>
  for(i = 0; i < N; i++){
     22a:	2485                	addiw	s1,s1,1
     22c:	0ff4f493          	andi	s1,s1,255
     230:	ff3490e3          	bne	s1,s3,210 <createtest+0x2c>
  name[0] = 'a';
     234:	00008797          	auipc	a5,0x8
     238:	cdc78793          	addi	a5,a5,-804 # 7f10 <name>
     23c:	06100713          	li	a4,97
     240:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     244:	00078123          	sb	zero,2(a5)
     248:	03000493          	li	s1,48
    name[1] = '0' + i;
     24c:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     24e:	06400993          	li	s3,100
    name[1] = '0' + i;
     252:	009900a3          	sb	s1,1(s2)
    unlink(name);
     256:	854a                	mv	a0,s2
     258:	00005097          	auipc	ra,0x5
     25c:	166080e7          	jalr	358(ra) # 53be <unlink>
  for(i = 0; i < N; i++){
     260:	2485                	addiw	s1,s1,1
     262:	0ff4f493          	andi	s1,s1,255
     266:	ff3496e3          	bne	s1,s3,252 <createtest+0x6e>
}
     26a:	70a2                	ld	ra,40(sp)
     26c:	7402                	ld	s0,32(sp)
     26e:	64e2                	ld	s1,24(sp)
     270:	6942                	ld	s2,16(sp)
     272:	69a2                	ld	s3,8(sp)
     274:	6145                	addi	sp,sp,48
     276:	8082                	ret

0000000000000278 <bigwrite>:
{
     278:	715d                	addi	sp,sp,-80
     27a:	e486                	sd	ra,72(sp)
     27c:	e0a2                	sd	s0,64(sp)
     27e:	fc26                	sd	s1,56(sp)
     280:	f84a                	sd	s2,48(sp)
     282:	f44e                	sd	s3,40(sp)
     284:	f052                	sd	s4,32(sp)
     286:	ec56                	sd	s5,24(sp)
     288:	e85a                	sd	s6,16(sp)
     28a:	e45e                	sd	s7,8(sp)
     28c:	0880                	addi	s0,sp,80
     28e:	8baa                	mv	s7,a0
  unlink("bigwrite");
     290:	00005517          	auipc	a0,0x5
     294:	7b850513          	addi	a0,a0,1976 # 5a48 <malloc+0x294>
     298:	00005097          	auipc	ra,0x5
     29c:	126080e7          	jalr	294(ra) # 53be <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a4:	00005a97          	auipc	s5,0x5
     2a8:	7a4a8a93          	addi	s5,s5,1956 # 5a48 <malloc+0x294>
      int cc = write(fd, buf, sz);
     2ac:	0000ba17          	auipc	s4,0xb
     2b0:	48ca0a13          	addi	s4,s4,1164 # b738 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	6b0d                	lui	s6,0x3
     2b6:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x4ef>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ba:	20200593          	li	a1,514
     2be:	8556                	mv	a0,s5
     2c0:	00005097          	auipc	ra,0x5
     2c4:	0ee080e7          	jalr	238(ra) # 53ae <open>
     2c8:	892a                	mv	s2,a0
    if(fd < 0){
     2ca:	04054d63          	bltz	a0,324 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ce:	8626                	mv	a2,s1
     2d0:	85d2                	mv	a1,s4
     2d2:	00005097          	auipc	ra,0x5
     2d6:	0bc080e7          	jalr	188(ra) # 538e <write>
     2da:	89aa                	mv	s3,a0
      if(cc != sz){
     2dc:	06a49463          	bne	s1,a0,344 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2e0:	8626                	mv	a2,s1
     2e2:	85d2                	mv	a1,s4
     2e4:	854a                	mv	a0,s2
     2e6:	00005097          	auipc	ra,0x5
     2ea:	0a8080e7          	jalr	168(ra) # 538e <write>
      if(cc != sz){
     2ee:	04951963          	bne	a0,s1,340 <bigwrite+0xc8>
    close(fd);
     2f2:	854a                	mv	a0,s2
     2f4:	00005097          	auipc	ra,0x5
     2f8:	0a2080e7          	jalr	162(ra) # 5396 <close>
    unlink("bigwrite");
     2fc:	8556                	mv	a0,s5
     2fe:	00005097          	auipc	ra,0x5
     302:	0c0080e7          	jalr	192(ra) # 53be <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     306:	1d74849b          	addiw	s1,s1,471
     30a:	fb6498e3          	bne	s1,s6,2ba <bigwrite+0x42>
}
     30e:	60a6                	ld	ra,72(sp)
     310:	6406                	ld	s0,64(sp)
     312:	74e2                	ld	s1,56(sp)
     314:	7942                	ld	s2,48(sp)
     316:	79a2                	ld	s3,40(sp)
     318:	7a02                	ld	s4,32(sp)
     31a:	6ae2                	ld	s5,24(sp)
     31c:	6b42                	ld	s6,16(sp)
     31e:	6ba2                	ld	s7,8(sp)
     320:	6161                	addi	sp,sp,80
     322:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     324:	85de                	mv	a1,s7
     326:	00006517          	auipc	a0,0x6
     32a:	94a50513          	addi	a0,a0,-1718 # 5c70 <malloc+0x4bc>
     32e:	00005097          	auipc	ra,0x5
     332:	3c8080e7          	jalr	968(ra) # 56f6 <printf>
      exit(1);
     336:	4505                	li	a0,1
     338:	00005097          	auipc	ra,0x5
     33c:	036080e7          	jalr	54(ra) # 536e <exit>
     340:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     342:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     344:	86ce                	mv	a3,s3
     346:	8626                	mv	a2,s1
     348:	85de                	mv	a1,s7
     34a:	00006517          	auipc	a0,0x6
     34e:	94650513          	addi	a0,a0,-1722 # 5c90 <malloc+0x4dc>
     352:	00005097          	auipc	ra,0x5
     356:	3a4080e7          	jalr	932(ra) # 56f6 <printf>
        exit(1);
     35a:	4505                	li	a0,1
     35c:	00005097          	auipc	ra,0x5
     360:	012080e7          	jalr	18(ra) # 536e <exit>

0000000000000364 <copyin>:
{
     364:	715d                	addi	sp,sp,-80
     366:	e486                	sd	ra,72(sp)
     368:	e0a2                	sd	s0,64(sp)
     36a:	fc26                	sd	s1,56(sp)
     36c:	f84a                	sd	s2,48(sp)
     36e:	f44e                	sd	s3,40(sp)
     370:	f052                	sd	s4,32(sp)
     372:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     374:	4785                	li	a5,1
     376:	07fe                	slli	a5,a5,0x1f
     378:	fcf43023          	sd	a5,-64(s0)
     37c:	57fd                	li	a5,-1
     37e:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     382:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     386:	00006a17          	auipc	s4,0x6
     38a:	922a0a13          	addi	s4,s4,-1758 # 5ca8 <malloc+0x4f4>
    uint64 addr = addrs[ai];
     38e:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     392:	20100593          	li	a1,513
     396:	8552                	mv	a0,s4
     398:	00005097          	auipc	ra,0x5
     39c:	016080e7          	jalr	22(ra) # 53ae <open>
     3a0:	84aa                	mv	s1,a0
    if(fd < 0){
     3a2:	08054863          	bltz	a0,432 <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     3a6:	6609                	lui	a2,0x2
     3a8:	85ce                	mv	a1,s3
     3aa:	00005097          	auipc	ra,0x5
     3ae:	fe4080e7          	jalr	-28(ra) # 538e <write>
    if(n >= 0){
     3b2:	08055d63          	bgez	a0,44c <copyin+0xe8>
    close(fd);
     3b6:	8526                	mv	a0,s1
     3b8:	00005097          	auipc	ra,0x5
     3bc:	fde080e7          	jalr	-34(ra) # 5396 <close>
    unlink("copyin1");
     3c0:	8552                	mv	a0,s4
     3c2:	00005097          	auipc	ra,0x5
     3c6:	ffc080e7          	jalr	-4(ra) # 53be <unlink>
    n = write(1, (char*)addr, 8192);
     3ca:	6609                	lui	a2,0x2
     3cc:	85ce                	mv	a1,s3
     3ce:	4505                	li	a0,1
     3d0:	00005097          	auipc	ra,0x5
     3d4:	fbe080e7          	jalr	-66(ra) # 538e <write>
    if(n > 0){
     3d8:	08a04963          	bgtz	a0,46a <copyin+0x106>
    if(pipe(fds) < 0){
     3dc:	fb840513          	addi	a0,s0,-72
     3e0:	00005097          	auipc	ra,0x5
     3e4:	f9e080e7          	jalr	-98(ra) # 537e <pipe>
     3e8:	0a054063          	bltz	a0,488 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3ec:	6609                	lui	a2,0x2
     3ee:	85ce                	mv	a1,s3
     3f0:	fbc42503          	lw	a0,-68(s0)
     3f4:	00005097          	auipc	ra,0x5
     3f8:	f9a080e7          	jalr	-102(ra) # 538e <write>
    if(n > 0){
     3fc:	0aa04363          	bgtz	a0,4a2 <copyin+0x13e>
    close(fds[0]);
     400:	fb842503          	lw	a0,-72(s0)
     404:	00005097          	auipc	ra,0x5
     408:	f92080e7          	jalr	-110(ra) # 5396 <close>
    close(fds[1]);
     40c:	fbc42503          	lw	a0,-68(s0)
     410:	00005097          	auipc	ra,0x5
     414:	f86080e7          	jalr	-122(ra) # 5396 <close>
  for(int ai = 0; ai < 2; ai++){
     418:	0921                	addi	s2,s2,8
     41a:	fd040793          	addi	a5,s0,-48
     41e:	f6f918e3          	bne	s2,a5,38e <copyin+0x2a>
}
     422:	60a6                	ld	ra,72(sp)
     424:	6406                	ld	s0,64(sp)
     426:	74e2                	ld	s1,56(sp)
     428:	7942                	ld	s2,48(sp)
     42a:	79a2                	ld	s3,40(sp)
     42c:	7a02                	ld	s4,32(sp)
     42e:	6161                	addi	sp,sp,80
     430:	8082                	ret
      printf("open(copyin1) failed\n");
     432:	00006517          	auipc	a0,0x6
     436:	87e50513          	addi	a0,a0,-1922 # 5cb0 <malloc+0x4fc>
     43a:	00005097          	auipc	ra,0x5
     43e:	2bc080e7          	jalr	700(ra) # 56f6 <printf>
      exit(1);
     442:	4505                	li	a0,1
     444:	00005097          	auipc	ra,0x5
     448:	f2a080e7          	jalr	-214(ra) # 536e <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     44c:	862a                	mv	a2,a0
     44e:	85ce                	mv	a1,s3
     450:	00006517          	auipc	a0,0x6
     454:	87850513          	addi	a0,a0,-1928 # 5cc8 <malloc+0x514>
     458:	00005097          	auipc	ra,0x5
     45c:	29e080e7          	jalr	670(ra) # 56f6 <printf>
      exit(1);
     460:	4505                	li	a0,1
     462:	00005097          	auipc	ra,0x5
     466:	f0c080e7          	jalr	-244(ra) # 536e <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     46a:	862a                	mv	a2,a0
     46c:	85ce                	mv	a1,s3
     46e:	00006517          	auipc	a0,0x6
     472:	88a50513          	addi	a0,a0,-1910 # 5cf8 <malloc+0x544>
     476:	00005097          	auipc	ra,0x5
     47a:	280080e7          	jalr	640(ra) # 56f6 <printf>
      exit(1);
     47e:	4505                	li	a0,1
     480:	00005097          	auipc	ra,0x5
     484:	eee080e7          	jalr	-274(ra) # 536e <exit>
      printf("pipe() failed\n");
     488:	00006517          	auipc	a0,0x6
     48c:	8a050513          	addi	a0,a0,-1888 # 5d28 <malloc+0x574>
     490:	00005097          	auipc	ra,0x5
     494:	266080e7          	jalr	614(ra) # 56f6 <printf>
      exit(1);
     498:	4505                	li	a0,1
     49a:	00005097          	auipc	ra,0x5
     49e:	ed4080e7          	jalr	-300(ra) # 536e <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     4a2:	862a                	mv	a2,a0
     4a4:	85ce                	mv	a1,s3
     4a6:	00006517          	auipc	a0,0x6
     4aa:	89250513          	addi	a0,a0,-1902 # 5d38 <malloc+0x584>
     4ae:	00005097          	auipc	ra,0x5
     4b2:	248080e7          	jalr	584(ra) # 56f6 <printf>
      exit(1);
     4b6:	4505                	li	a0,1
     4b8:	00005097          	auipc	ra,0x5
     4bc:	eb6080e7          	jalr	-330(ra) # 536e <exit>

00000000000004c0 <copyout>:
{
     4c0:	711d                	addi	sp,sp,-96
     4c2:	ec86                	sd	ra,88(sp)
     4c4:	e8a2                	sd	s0,80(sp)
     4c6:	e4a6                	sd	s1,72(sp)
     4c8:	e0ca                	sd	s2,64(sp)
     4ca:	fc4e                	sd	s3,56(sp)
     4cc:	f852                	sd	s4,48(sp)
     4ce:	f456                	sd	s5,40(sp)
     4d0:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4d2:	4785                	li	a5,1
     4d4:	07fe                	slli	a5,a5,0x1f
     4d6:	faf43823          	sd	a5,-80(s0)
     4da:	57fd                	li	a5,-1
     4dc:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4e0:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4e4:	00006a17          	auipc	s4,0x6
     4e8:	884a0a13          	addi	s4,s4,-1916 # 5d68 <malloc+0x5b4>
    n = write(fds[1], "x", 1);
     4ec:	00005a97          	auipc	s5,0x5
     4f0:	754a8a93          	addi	s5,s5,1876 # 5c40 <malloc+0x48c>
    uint64 addr = addrs[ai];
     4f4:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4f8:	4581                	li	a1,0
     4fa:	8552                	mv	a0,s4
     4fc:	00005097          	auipc	ra,0x5
     500:	eb2080e7          	jalr	-334(ra) # 53ae <open>
     504:	84aa                	mv	s1,a0
    if(fd < 0){
     506:	08054663          	bltz	a0,592 <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     50a:	6609                	lui	a2,0x2
     50c:	85ce                	mv	a1,s3
     50e:	00005097          	auipc	ra,0x5
     512:	e78080e7          	jalr	-392(ra) # 5386 <read>
    if(n > 0){
     516:	08a04b63          	bgtz	a0,5ac <copyout+0xec>
    close(fd);
     51a:	8526                	mv	a0,s1
     51c:	00005097          	auipc	ra,0x5
     520:	e7a080e7          	jalr	-390(ra) # 5396 <close>
    if(pipe(fds) < 0){
     524:	fa840513          	addi	a0,s0,-88
     528:	00005097          	auipc	ra,0x5
     52c:	e56080e7          	jalr	-426(ra) # 537e <pipe>
     530:	08054d63          	bltz	a0,5ca <copyout+0x10a>
    n = write(fds[1], "x", 1);
     534:	4605                	li	a2,1
     536:	85d6                	mv	a1,s5
     538:	fac42503          	lw	a0,-84(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	e52080e7          	jalr	-430(ra) # 538e <write>
    if(n != 1){
     544:	4785                	li	a5,1
     546:	08f51f63          	bne	a0,a5,5e4 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     54a:	6609                	lui	a2,0x2
     54c:	85ce                	mv	a1,s3
     54e:	fa842503          	lw	a0,-88(s0)
     552:	00005097          	auipc	ra,0x5
     556:	e34080e7          	jalr	-460(ra) # 5386 <read>
    if(n > 0){
     55a:	0aa04263          	bgtz	a0,5fe <copyout+0x13e>
    close(fds[0]);
     55e:	fa842503          	lw	a0,-88(s0)
     562:	00005097          	auipc	ra,0x5
     566:	e34080e7          	jalr	-460(ra) # 5396 <close>
    close(fds[1]);
     56a:	fac42503          	lw	a0,-84(s0)
     56e:	00005097          	auipc	ra,0x5
     572:	e28080e7          	jalr	-472(ra) # 5396 <close>
  for(int ai = 0; ai < 2; ai++){
     576:	0921                	addi	s2,s2,8
     578:	fc040793          	addi	a5,s0,-64
     57c:	f6f91ce3          	bne	s2,a5,4f4 <copyout+0x34>
}
     580:	60e6                	ld	ra,88(sp)
     582:	6446                	ld	s0,80(sp)
     584:	64a6                	ld	s1,72(sp)
     586:	6906                	ld	s2,64(sp)
     588:	79e2                	ld	s3,56(sp)
     58a:	7a42                	ld	s4,48(sp)
     58c:	7aa2                	ld	s5,40(sp)
     58e:	6125                	addi	sp,sp,96
     590:	8082                	ret
      printf("open(README) failed\n");
     592:	00005517          	auipc	a0,0x5
     596:	7de50513          	addi	a0,a0,2014 # 5d70 <malloc+0x5bc>
     59a:	00005097          	auipc	ra,0x5
     59e:	15c080e7          	jalr	348(ra) # 56f6 <printf>
      exit(1);
     5a2:	4505                	li	a0,1
     5a4:	00005097          	auipc	ra,0x5
     5a8:	dca080e7          	jalr	-566(ra) # 536e <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ac:	862a                	mv	a2,a0
     5ae:	85ce                	mv	a1,s3
     5b0:	00005517          	auipc	a0,0x5
     5b4:	7d850513          	addi	a0,a0,2008 # 5d88 <malloc+0x5d4>
     5b8:	00005097          	auipc	ra,0x5
     5bc:	13e080e7          	jalr	318(ra) # 56f6 <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	00005097          	auipc	ra,0x5
     5c6:	dac080e7          	jalr	-596(ra) # 536e <exit>
      printf("pipe() failed\n");
     5ca:	00005517          	auipc	a0,0x5
     5ce:	75e50513          	addi	a0,a0,1886 # 5d28 <malloc+0x574>
     5d2:	00005097          	auipc	ra,0x5
     5d6:	124080e7          	jalr	292(ra) # 56f6 <printf>
      exit(1);
     5da:	4505                	li	a0,1
     5dc:	00005097          	auipc	ra,0x5
     5e0:	d92080e7          	jalr	-622(ra) # 536e <exit>
      printf("pipe write failed\n");
     5e4:	00005517          	auipc	a0,0x5
     5e8:	7d450513          	addi	a0,a0,2004 # 5db8 <malloc+0x604>
     5ec:	00005097          	auipc	ra,0x5
     5f0:	10a080e7          	jalr	266(ra) # 56f6 <printf>
      exit(1);
     5f4:	4505                	li	a0,1
     5f6:	00005097          	auipc	ra,0x5
     5fa:	d78080e7          	jalr	-648(ra) # 536e <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5fe:	862a                	mv	a2,a0
     600:	85ce                	mv	a1,s3
     602:	00005517          	auipc	a0,0x5
     606:	7ce50513          	addi	a0,a0,1998 # 5dd0 <malloc+0x61c>
     60a:	00005097          	auipc	ra,0x5
     60e:	0ec080e7          	jalr	236(ra) # 56f6 <printf>
      exit(1);
     612:	4505                	li	a0,1
     614:	00005097          	auipc	ra,0x5
     618:	d5a080e7          	jalr	-678(ra) # 536e <exit>

000000000000061c <truncate1>:
{
     61c:	711d                	addi	sp,sp,-96
     61e:	ec86                	sd	ra,88(sp)
     620:	e8a2                	sd	s0,80(sp)
     622:	e4a6                	sd	s1,72(sp)
     624:	e0ca                	sd	s2,64(sp)
     626:	fc4e                	sd	s3,56(sp)
     628:	f852                	sd	s4,48(sp)
     62a:	f456                	sd	s5,40(sp)
     62c:	1080                	addi	s0,sp,96
     62e:	8aaa                	mv	s5,a0
  unlink("truncfile");
     630:	00005517          	auipc	a0,0x5
     634:	5f850513          	addi	a0,a0,1528 # 5c28 <malloc+0x474>
     638:	00005097          	auipc	ra,0x5
     63c:	d86080e7          	jalr	-634(ra) # 53be <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     640:	60100593          	li	a1,1537
     644:	00005517          	auipc	a0,0x5
     648:	5e450513          	addi	a0,a0,1508 # 5c28 <malloc+0x474>
     64c:	00005097          	auipc	ra,0x5
     650:	d62080e7          	jalr	-670(ra) # 53ae <open>
     654:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     656:	4611                	li	a2,4
     658:	00005597          	auipc	a1,0x5
     65c:	5e058593          	addi	a1,a1,1504 # 5c38 <malloc+0x484>
     660:	00005097          	auipc	ra,0x5
     664:	d2e080e7          	jalr	-722(ra) # 538e <write>
  close(fd1);
     668:	8526                	mv	a0,s1
     66a:	00005097          	auipc	ra,0x5
     66e:	d2c080e7          	jalr	-724(ra) # 5396 <close>
  int fd2 = open("truncfile", O_RDONLY);
     672:	4581                	li	a1,0
     674:	00005517          	auipc	a0,0x5
     678:	5b450513          	addi	a0,a0,1460 # 5c28 <malloc+0x474>
     67c:	00005097          	auipc	ra,0x5
     680:	d32080e7          	jalr	-718(ra) # 53ae <open>
     684:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     686:	02000613          	li	a2,32
     68a:	fa040593          	addi	a1,s0,-96
     68e:	00005097          	auipc	ra,0x5
     692:	cf8080e7          	jalr	-776(ra) # 5386 <read>
  if(n != 4){
     696:	4791                	li	a5,4
     698:	0cf51e63          	bne	a0,a5,774 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     69c:	40100593          	li	a1,1025
     6a0:	00005517          	auipc	a0,0x5
     6a4:	58850513          	addi	a0,a0,1416 # 5c28 <malloc+0x474>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	d06080e7          	jalr	-762(ra) # 53ae <open>
     6b0:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6b2:	4581                	li	a1,0
     6b4:	00005517          	auipc	a0,0x5
     6b8:	57450513          	addi	a0,a0,1396 # 5c28 <malloc+0x474>
     6bc:	00005097          	auipc	ra,0x5
     6c0:	cf2080e7          	jalr	-782(ra) # 53ae <open>
     6c4:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	00005097          	auipc	ra,0x5
     6d2:	cb8080e7          	jalr	-840(ra) # 5386 <read>
     6d6:	8a2a                	mv	s4,a0
  if(n != 0){
     6d8:	ed4d                	bnez	a0,792 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6da:	02000613          	li	a2,32
     6de:	fa040593          	addi	a1,s0,-96
     6e2:	8526                	mv	a0,s1
     6e4:	00005097          	auipc	ra,0x5
     6e8:	ca2080e7          	jalr	-862(ra) # 5386 <read>
     6ec:	8a2a                	mv	s4,a0
  if(n != 0){
     6ee:	e971                	bnez	a0,7c2 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6f0:	4619                	li	a2,6
     6f2:	00005597          	auipc	a1,0x5
     6f6:	76e58593          	addi	a1,a1,1902 # 5e60 <malloc+0x6ac>
     6fa:	854e                	mv	a0,s3
     6fc:	00005097          	auipc	ra,0x5
     700:	c92080e7          	jalr	-878(ra) # 538e <write>
  n = read(fd3, buf, sizeof(buf));
     704:	02000613          	li	a2,32
     708:	fa040593          	addi	a1,s0,-96
     70c:	854a                	mv	a0,s2
     70e:	00005097          	auipc	ra,0x5
     712:	c78080e7          	jalr	-904(ra) # 5386 <read>
  if(n != 6){
     716:	4799                	li	a5,6
     718:	0cf51d63          	bne	a0,a5,7f2 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     71c:	02000613          	li	a2,32
     720:	fa040593          	addi	a1,s0,-96
     724:	8526                	mv	a0,s1
     726:	00005097          	auipc	ra,0x5
     72a:	c60080e7          	jalr	-928(ra) # 5386 <read>
  if(n != 2){
     72e:	4789                	li	a5,2
     730:	0ef51063          	bne	a0,a5,810 <truncate1+0x1f4>
  unlink("truncfile");
     734:	00005517          	auipc	a0,0x5
     738:	4f450513          	addi	a0,a0,1268 # 5c28 <malloc+0x474>
     73c:	00005097          	auipc	ra,0x5
     740:	c82080e7          	jalr	-894(ra) # 53be <unlink>
  close(fd1);
     744:	854e                	mv	a0,s3
     746:	00005097          	auipc	ra,0x5
     74a:	c50080e7          	jalr	-944(ra) # 5396 <close>
  close(fd2);
     74e:	8526                	mv	a0,s1
     750:	00005097          	auipc	ra,0x5
     754:	c46080e7          	jalr	-954(ra) # 5396 <close>
  close(fd3);
     758:	854a                	mv	a0,s2
     75a:	00005097          	auipc	ra,0x5
     75e:	c3c080e7          	jalr	-964(ra) # 5396 <close>
}
     762:	60e6                	ld	ra,88(sp)
     764:	6446                	ld	s0,80(sp)
     766:	64a6                	ld	s1,72(sp)
     768:	6906                	ld	s2,64(sp)
     76a:	79e2                	ld	s3,56(sp)
     76c:	7a42                	ld	s4,48(sp)
     76e:	7aa2                	ld	s5,40(sp)
     770:	6125                	addi	sp,sp,96
     772:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     774:	862a                	mv	a2,a0
     776:	85d6                	mv	a1,s5
     778:	00005517          	auipc	a0,0x5
     77c:	68850513          	addi	a0,a0,1672 # 5e00 <malloc+0x64c>
     780:	00005097          	auipc	ra,0x5
     784:	f76080e7          	jalr	-138(ra) # 56f6 <printf>
    exit(1);
     788:	4505                	li	a0,1
     78a:	00005097          	auipc	ra,0x5
     78e:	be4080e7          	jalr	-1052(ra) # 536e <exit>
    printf("aaa fd3=%d\n", fd3);
     792:	85ca                	mv	a1,s2
     794:	00005517          	auipc	a0,0x5
     798:	68c50513          	addi	a0,a0,1676 # 5e20 <malloc+0x66c>
     79c:	00005097          	auipc	ra,0x5
     7a0:	f5a080e7          	jalr	-166(ra) # 56f6 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7a4:	8652                	mv	a2,s4
     7a6:	85d6                	mv	a1,s5
     7a8:	00005517          	auipc	a0,0x5
     7ac:	68850513          	addi	a0,a0,1672 # 5e30 <malloc+0x67c>
     7b0:	00005097          	auipc	ra,0x5
     7b4:	f46080e7          	jalr	-186(ra) # 56f6 <printf>
    exit(1);
     7b8:	4505                	li	a0,1
     7ba:	00005097          	auipc	ra,0x5
     7be:	bb4080e7          	jalr	-1100(ra) # 536e <exit>
    printf("bbb fd2=%d\n", fd2);
     7c2:	85a6                	mv	a1,s1
     7c4:	00005517          	auipc	a0,0x5
     7c8:	68c50513          	addi	a0,a0,1676 # 5e50 <malloc+0x69c>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	f2a080e7          	jalr	-214(ra) # 56f6 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7d4:	8652                	mv	a2,s4
     7d6:	85d6                	mv	a1,s5
     7d8:	00005517          	auipc	a0,0x5
     7dc:	65850513          	addi	a0,a0,1624 # 5e30 <malloc+0x67c>
     7e0:	00005097          	auipc	ra,0x5
     7e4:	f16080e7          	jalr	-234(ra) # 56f6 <printf>
    exit(1);
     7e8:	4505                	li	a0,1
     7ea:	00005097          	auipc	ra,0x5
     7ee:	b84080e7          	jalr	-1148(ra) # 536e <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7f2:	862a                	mv	a2,a0
     7f4:	85d6                	mv	a1,s5
     7f6:	00005517          	auipc	a0,0x5
     7fa:	67250513          	addi	a0,a0,1650 # 5e68 <malloc+0x6b4>
     7fe:	00005097          	auipc	ra,0x5
     802:	ef8080e7          	jalr	-264(ra) # 56f6 <printf>
    exit(1);
     806:	4505                	li	a0,1
     808:	00005097          	auipc	ra,0x5
     80c:	b66080e7          	jalr	-1178(ra) # 536e <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     810:	862a                	mv	a2,a0
     812:	85d6                	mv	a1,s5
     814:	00005517          	auipc	a0,0x5
     818:	67450513          	addi	a0,a0,1652 # 5e88 <malloc+0x6d4>
     81c:	00005097          	auipc	ra,0x5
     820:	eda080e7          	jalr	-294(ra) # 56f6 <printf>
    exit(1);
     824:	4505                	li	a0,1
     826:	00005097          	auipc	ra,0x5
     82a:	b48080e7          	jalr	-1208(ra) # 536e <exit>

000000000000082e <writetest>:
{
     82e:	7139                	addi	sp,sp,-64
     830:	fc06                	sd	ra,56(sp)
     832:	f822                	sd	s0,48(sp)
     834:	f426                	sd	s1,40(sp)
     836:	f04a                	sd	s2,32(sp)
     838:	ec4e                	sd	s3,24(sp)
     83a:	e852                	sd	s4,16(sp)
     83c:	e456                	sd	s5,8(sp)
     83e:	e05a                	sd	s6,0(sp)
     840:	0080                	addi	s0,sp,64
     842:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     844:	20200593          	li	a1,514
     848:	00005517          	auipc	a0,0x5
     84c:	66050513          	addi	a0,a0,1632 # 5ea8 <malloc+0x6f4>
     850:	00005097          	auipc	ra,0x5
     854:	b5e080e7          	jalr	-1186(ra) # 53ae <open>
  if(fd < 0){
     858:	0a054d63          	bltz	a0,912 <writetest+0xe4>
     85c:	892a                	mv	s2,a0
     85e:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	00005997          	auipc	s3,0x5
     864:	67098993          	addi	s3,s3,1648 # 5ed0 <malloc+0x71c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     868:	00005a97          	auipc	s5,0x5
     86c:	6a0a8a93          	addi	s5,s5,1696 # 5f08 <malloc+0x754>
  for(i = 0; i < N; i++){
     870:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85ce                	mv	a1,s3
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	b14080e7          	jalr	-1260(ra) # 538e <write>
     882:	47a9                	li	a5,10
     884:	0af51563          	bne	a0,a5,92e <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     888:	4629                	li	a2,10
     88a:	85d6                	mv	a1,s5
     88c:	854a                	mv	a0,s2
     88e:	00005097          	auipc	ra,0x5
     892:	b00080e7          	jalr	-1280(ra) # 538e <write>
     896:	47a9                	li	a5,10
     898:	0af51963          	bne	a0,a5,94a <writetest+0x11c>
  for(i = 0; i < N; i++){
     89c:	2485                	addiw	s1,s1,1
     89e:	fd449be3          	bne	s1,s4,874 <writetest+0x46>
  close(fd);
     8a2:	854a                	mv	a0,s2
     8a4:	00005097          	auipc	ra,0x5
     8a8:	af2080e7          	jalr	-1294(ra) # 5396 <close>
  fd = open("small", O_RDONLY);
     8ac:	4581                	li	a1,0
     8ae:	00005517          	auipc	a0,0x5
     8b2:	5fa50513          	addi	a0,a0,1530 # 5ea8 <malloc+0x6f4>
     8b6:	00005097          	auipc	ra,0x5
     8ba:	af8080e7          	jalr	-1288(ra) # 53ae <open>
     8be:	84aa                	mv	s1,a0
  if(fd < 0){
     8c0:	0a054363          	bltz	a0,966 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
     8c4:	7d000613          	li	a2,2000
     8c8:	0000b597          	auipc	a1,0xb
     8cc:	e7058593          	addi	a1,a1,-400 # b738 <buf>
     8d0:	00005097          	auipc	ra,0x5
     8d4:	ab6080e7          	jalr	-1354(ra) # 5386 <read>
  if(i != N*SZ*2){
     8d8:	7d000793          	li	a5,2000
     8dc:	0af51363          	bne	a0,a5,982 <writetest+0x154>
  close(fd);
     8e0:	8526                	mv	a0,s1
     8e2:	00005097          	auipc	ra,0x5
     8e6:	ab4080e7          	jalr	-1356(ra) # 5396 <close>
  if(unlink("small") < 0){
     8ea:	00005517          	auipc	a0,0x5
     8ee:	5be50513          	addi	a0,a0,1470 # 5ea8 <malloc+0x6f4>
     8f2:	00005097          	auipc	ra,0x5
     8f6:	acc080e7          	jalr	-1332(ra) # 53be <unlink>
     8fa:	0a054263          	bltz	a0,99e <writetest+0x170>
}
     8fe:	70e2                	ld	ra,56(sp)
     900:	7442                	ld	s0,48(sp)
     902:	74a2                	ld	s1,40(sp)
     904:	7902                	ld	s2,32(sp)
     906:	69e2                	ld	s3,24(sp)
     908:	6a42                	ld	s4,16(sp)
     90a:	6aa2                	ld	s5,8(sp)
     90c:	6b02                	ld	s6,0(sp)
     90e:	6121                	addi	sp,sp,64
     910:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     912:	85da                	mv	a1,s6
     914:	00005517          	auipc	a0,0x5
     918:	59c50513          	addi	a0,a0,1436 # 5eb0 <malloc+0x6fc>
     91c:	00005097          	auipc	ra,0x5
     920:	dda080e7          	jalr	-550(ra) # 56f6 <printf>
    exit(1);
     924:	4505                	li	a0,1
     926:	00005097          	auipc	ra,0x5
     92a:	a48080e7          	jalr	-1464(ra) # 536e <exit>
      printf("%s: error: write aa %d new file failed\n", i);
     92e:	85a6                	mv	a1,s1
     930:	00005517          	auipc	a0,0x5
     934:	5b050513          	addi	a0,a0,1456 # 5ee0 <malloc+0x72c>
     938:	00005097          	auipc	ra,0x5
     93c:	dbe080e7          	jalr	-578(ra) # 56f6 <printf>
      exit(1);
     940:	4505                	li	a0,1
     942:	00005097          	auipc	ra,0x5
     946:	a2c080e7          	jalr	-1492(ra) # 536e <exit>
      printf("%s: error: write bb %d new file failed\n", i);
     94a:	85a6                	mv	a1,s1
     94c:	00005517          	auipc	a0,0x5
     950:	5cc50513          	addi	a0,a0,1484 # 5f18 <malloc+0x764>
     954:	00005097          	auipc	ra,0x5
     958:	da2080e7          	jalr	-606(ra) # 56f6 <printf>
      exit(1);
     95c:	4505                	li	a0,1
     95e:	00005097          	auipc	ra,0x5
     962:	a10080e7          	jalr	-1520(ra) # 536e <exit>
    printf("%s: error: open small failed!\n", s);
     966:	85da                	mv	a1,s6
     968:	00005517          	auipc	a0,0x5
     96c:	5d850513          	addi	a0,a0,1496 # 5f40 <malloc+0x78c>
     970:	00005097          	auipc	ra,0x5
     974:	d86080e7          	jalr	-634(ra) # 56f6 <printf>
    exit(1);
     978:	4505                	li	a0,1
     97a:	00005097          	auipc	ra,0x5
     97e:	9f4080e7          	jalr	-1548(ra) # 536e <exit>
    printf("%s: read failed\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	5dc50513          	addi	a0,a0,1500 # 5f60 <malloc+0x7ac>
     98c:	00005097          	auipc	ra,0x5
     990:	d6a080e7          	jalr	-662(ra) # 56f6 <printf>
    exit(1);
     994:	4505                	li	a0,1
     996:	00005097          	auipc	ra,0x5
     99a:	9d8080e7          	jalr	-1576(ra) # 536e <exit>
    printf("%s: unlink small failed\n", s);
     99e:	85da                	mv	a1,s6
     9a0:	00005517          	auipc	a0,0x5
     9a4:	5d850513          	addi	a0,a0,1496 # 5f78 <malloc+0x7c4>
     9a8:	00005097          	auipc	ra,0x5
     9ac:	d4e080e7          	jalr	-690(ra) # 56f6 <printf>
    exit(1);
     9b0:	4505                	li	a0,1
     9b2:	00005097          	auipc	ra,0x5
     9b6:	9bc080e7          	jalr	-1604(ra) # 536e <exit>

00000000000009ba <writebig>:
{
     9ba:	7139                	addi	sp,sp,-64
     9bc:	fc06                	sd	ra,56(sp)
     9be:	f822                	sd	s0,48(sp)
     9c0:	f426                	sd	s1,40(sp)
     9c2:	f04a                	sd	s2,32(sp)
     9c4:	ec4e                	sd	s3,24(sp)
     9c6:	e852                	sd	s4,16(sp)
     9c8:	e456                	sd	s5,8(sp)
     9ca:	0080                	addi	s0,sp,64
     9cc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9ce:	20200593          	li	a1,514
     9d2:	00005517          	auipc	a0,0x5
     9d6:	5c650513          	addi	a0,a0,1478 # 5f98 <malloc+0x7e4>
     9da:	00005097          	auipc	ra,0x5
     9de:	9d4080e7          	jalr	-1580(ra) # 53ae <open>
     9e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e6:	0000b917          	auipc	s2,0xb
     9ea:	d5290913          	addi	s2,s2,-686 # b738 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ee:	10c00a13          	li	s4,268
  if(fd < 0){
     9f2:	06054c63          	bltz	a0,a6a <writebig+0xb0>
    ((int*)buf)[0] = i;
     9f6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fa:	40000613          	li	a2,1024
     9fe:	85ca                	mv	a1,s2
     a00:	854e                	mv	a0,s3
     a02:	00005097          	auipc	ra,0x5
     a06:	98c080e7          	jalr	-1652(ra) # 538e <write>
     a0a:	40000793          	li	a5,1024
     a0e:	06f51c63          	bne	a0,a5,a86 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a12:	2485                	addiw	s1,s1,1
     a14:	ff4491e3          	bne	s1,s4,9f6 <writebig+0x3c>
  close(fd);
     a18:	854e                	mv	a0,s3
     a1a:	00005097          	auipc	ra,0x5
     a1e:	97c080e7          	jalr	-1668(ra) # 5396 <close>
  fd = open("big", O_RDONLY);
     a22:	4581                	li	a1,0
     a24:	00005517          	auipc	a0,0x5
     a28:	57450513          	addi	a0,a0,1396 # 5f98 <malloc+0x7e4>
     a2c:	00005097          	auipc	ra,0x5
     a30:	982080e7          	jalr	-1662(ra) # 53ae <open>
     a34:	89aa                	mv	s3,a0
  n = 0;
     a36:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a38:	0000b917          	auipc	s2,0xb
     a3c:	d0090913          	addi	s2,s2,-768 # b738 <buf>
  if(fd < 0){
     a40:	06054163          	bltz	a0,aa2 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     a44:	40000613          	li	a2,1024
     a48:	85ca                	mv	a1,s2
     a4a:	854e                	mv	a0,s3
     a4c:	00005097          	auipc	ra,0x5
     a50:	93a080e7          	jalr	-1734(ra) # 5386 <read>
    if(i == 0){
     a54:	c52d                	beqz	a0,abe <writebig+0x104>
    } else if(i != BSIZE){
     a56:	40000793          	li	a5,1024
     a5a:	0af51d63          	bne	a0,a5,b14 <writebig+0x15a>
    if(((int*)buf)[0] != n){
     a5e:	00092603          	lw	a2,0(s2)
     a62:	0c961763          	bne	a2,s1,b30 <writebig+0x176>
    n++;
     a66:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a68:	bff1                	j	a44 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a6a:	85d6                	mv	a1,s5
     a6c:	00005517          	auipc	a0,0x5
     a70:	53450513          	addi	a0,a0,1332 # 5fa0 <malloc+0x7ec>
     a74:	00005097          	auipc	ra,0x5
     a78:	c82080e7          	jalr	-894(ra) # 56f6 <printf>
    exit(1);
     a7c:	4505                	li	a0,1
     a7e:	00005097          	auipc	ra,0x5
     a82:	8f0080e7          	jalr	-1808(ra) # 536e <exit>
      printf("%s: error: write big file failed\n", i);
     a86:	85a6                	mv	a1,s1
     a88:	00005517          	auipc	a0,0x5
     a8c:	53850513          	addi	a0,a0,1336 # 5fc0 <malloc+0x80c>
     a90:	00005097          	auipc	ra,0x5
     a94:	c66080e7          	jalr	-922(ra) # 56f6 <printf>
      exit(1);
     a98:	4505                	li	a0,1
     a9a:	00005097          	auipc	ra,0x5
     a9e:	8d4080e7          	jalr	-1836(ra) # 536e <exit>
    printf("%s: error: open big failed!\n", s);
     aa2:	85d6                	mv	a1,s5
     aa4:	00005517          	auipc	a0,0x5
     aa8:	54450513          	addi	a0,a0,1348 # 5fe8 <malloc+0x834>
     aac:	00005097          	auipc	ra,0x5
     ab0:	c4a080e7          	jalr	-950(ra) # 56f6 <printf>
    exit(1);
     ab4:	4505                	li	a0,1
     ab6:	00005097          	auipc	ra,0x5
     aba:	8b8080e7          	jalr	-1864(ra) # 536e <exit>
      if(n == MAXFILE - 1){
     abe:	10b00793          	li	a5,267
     ac2:	02f48a63          	beq	s1,a5,af6 <writebig+0x13c>
  close(fd);
     ac6:	854e                	mv	a0,s3
     ac8:	00005097          	auipc	ra,0x5
     acc:	8ce080e7          	jalr	-1842(ra) # 5396 <close>
  if(unlink("big") < 0){
     ad0:	00005517          	auipc	a0,0x5
     ad4:	4c850513          	addi	a0,a0,1224 # 5f98 <malloc+0x7e4>
     ad8:	00005097          	auipc	ra,0x5
     adc:	8e6080e7          	jalr	-1818(ra) # 53be <unlink>
     ae0:	06054663          	bltz	a0,b4c <writebig+0x192>
}
     ae4:	70e2                	ld	ra,56(sp)
     ae6:	7442                	ld	s0,48(sp)
     ae8:	74a2                	ld	s1,40(sp)
     aea:	7902                	ld	s2,32(sp)
     aec:	69e2                	ld	s3,24(sp)
     aee:	6a42                	ld	s4,16(sp)
     af0:	6aa2                	ld	s5,8(sp)
     af2:	6121                	addi	sp,sp,64
     af4:	8082                	ret
        printf("%s: read only %d blocks from big", n);
     af6:	10b00593          	li	a1,267
     afa:	00005517          	auipc	a0,0x5
     afe:	50e50513          	addi	a0,a0,1294 # 6008 <malloc+0x854>
     b02:	00005097          	auipc	ra,0x5
     b06:	bf4080e7          	jalr	-1036(ra) # 56f6 <printf>
        exit(1);
     b0a:	4505                	li	a0,1
     b0c:	00005097          	auipc	ra,0x5
     b10:	862080e7          	jalr	-1950(ra) # 536e <exit>
      printf("%s: read failed %d\n", i);
     b14:	85aa                	mv	a1,a0
     b16:	00005517          	auipc	a0,0x5
     b1a:	51a50513          	addi	a0,a0,1306 # 6030 <malloc+0x87c>
     b1e:	00005097          	auipc	ra,0x5
     b22:	bd8080e7          	jalr	-1064(ra) # 56f6 <printf>
      exit(1);
     b26:	4505                	li	a0,1
     b28:	00005097          	auipc	ra,0x5
     b2c:	846080e7          	jalr	-1978(ra) # 536e <exit>
      printf("%s: read content of block %d is %d\n",
     b30:	85a6                	mv	a1,s1
     b32:	00005517          	auipc	a0,0x5
     b36:	51650513          	addi	a0,a0,1302 # 6048 <malloc+0x894>
     b3a:	00005097          	auipc	ra,0x5
     b3e:	bbc080e7          	jalr	-1092(ra) # 56f6 <printf>
      exit(1);
     b42:	4505                	li	a0,1
     b44:	00005097          	auipc	ra,0x5
     b48:	82a080e7          	jalr	-2006(ra) # 536e <exit>
    printf("%s: unlink big failed\n", s);
     b4c:	85d6                	mv	a1,s5
     b4e:	00005517          	auipc	a0,0x5
     b52:	52250513          	addi	a0,a0,1314 # 6070 <malloc+0x8bc>
     b56:	00005097          	auipc	ra,0x5
     b5a:	ba0080e7          	jalr	-1120(ra) # 56f6 <printf>
    exit(1);
     b5e:	4505                	li	a0,1
     b60:	00005097          	auipc	ra,0x5
     b64:	80e080e7          	jalr	-2034(ra) # 536e <exit>

0000000000000b68 <unlinkread>:
{
     b68:	7179                	addi	sp,sp,-48
     b6a:	f406                	sd	ra,40(sp)
     b6c:	f022                	sd	s0,32(sp)
     b6e:	ec26                	sd	s1,24(sp)
     b70:	e84a                	sd	s2,16(sp)
     b72:	e44e                	sd	s3,8(sp)
     b74:	1800                	addi	s0,sp,48
     b76:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b78:	20200593          	li	a1,514
     b7c:	00005517          	auipc	a0,0x5
     b80:	e6450513          	addi	a0,a0,-412 # 59e0 <malloc+0x22c>
     b84:	00005097          	auipc	ra,0x5
     b88:	82a080e7          	jalr	-2006(ra) # 53ae <open>
  if(fd < 0){
     b8c:	0e054563          	bltz	a0,c76 <unlinkread+0x10e>
     b90:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b92:	4615                	li	a2,5
     b94:	00005597          	auipc	a1,0x5
     b98:	51458593          	addi	a1,a1,1300 # 60a8 <malloc+0x8f4>
     b9c:	00004097          	auipc	ra,0x4
     ba0:	7f2080e7          	jalr	2034(ra) # 538e <write>
  close(fd);
     ba4:	8526                	mv	a0,s1
     ba6:	00004097          	auipc	ra,0x4
     baa:	7f0080e7          	jalr	2032(ra) # 5396 <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	e3050513          	addi	a0,a0,-464 # 59e0 <malloc+0x22c>
     bb8:	00004097          	auipc	ra,0x4
     bbc:	7f6080e7          	jalr	2038(ra) # 53ae <open>
     bc0:	84aa                	mv	s1,a0
  if(fd < 0){
     bc2:	0c054863          	bltz	a0,c92 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bc6:	00005517          	auipc	a0,0x5
     bca:	e1a50513          	addi	a0,a0,-486 # 59e0 <malloc+0x22c>
     bce:	00004097          	auipc	ra,0x4
     bd2:	7f0080e7          	jalr	2032(ra) # 53be <unlink>
     bd6:	ed61                	bnez	a0,cae <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd8:	20200593          	li	a1,514
     bdc:	00005517          	auipc	a0,0x5
     be0:	e0450513          	addi	a0,a0,-508 # 59e0 <malloc+0x22c>
     be4:	00004097          	auipc	ra,0x4
     be8:	7ca080e7          	jalr	1994(ra) # 53ae <open>
     bec:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     bee:	460d                	li	a2,3
     bf0:	00005597          	auipc	a1,0x5
     bf4:	50058593          	addi	a1,a1,1280 # 60f0 <malloc+0x93c>
     bf8:	00004097          	auipc	ra,0x4
     bfc:	796080e7          	jalr	1942(ra) # 538e <write>
  close(fd1);
     c00:	854a                	mv	a0,s2
     c02:	00004097          	auipc	ra,0x4
     c06:	794080e7          	jalr	1940(ra) # 5396 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c0a:	660d                	lui	a2,0x3
     c0c:	0000b597          	auipc	a1,0xb
     c10:	b2c58593          	addi	a1,a1,-1236 # b738 <buf>
     c14:	8526                	mv	a0,s1
     c16:	00004097          	auipc	ra,0x4
     c1a:	770080e7          	jalr	1904(ra) # 5386 <read>
     c1e:	4795                	li	a5,5
     c20:	0af51563          	bne	a0,a5,cca <unlinkread+0x162>
  if(buf[0] != 'h'){
     c24:	0000b717          	auipc	a4,0xb
     c28:	b1474703          	lbu	a4,-1260(a4) # b738 <buf>
     c2c:	06800793          	li	a5,104
     c30:	0af71b63          	bne	a4,a5,ce6 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c34:	4629                	li	a2,10
     c36:	0000b597          	auipc	a1,0xb
     c3a:	b0258593          	addi	a1,a1,-1278 # b738 <buf>
     c3e:	8526                	mv	a0,s1
     c40:	00004097          	auipc	ra,0x4
     c44:	74e080e7          	jalr	1870(ra) # 538e <write>
     c48:	47a9                	li	a5,10
     c4a:	0af51c63          	bne	a0,a5,d02 <unlinkread+0x19a>
  close(fd);
     c4e:	8526                	mv	a0,s1
     c50:	00004097          	auipc	ra,0x4
     c54:	746080e7          	jalr	1862(ra) # 5396 <close>
  unlink("unlinkread");
     c58:	00005517          	auipc	a0,0x5
     c5c:	d8850513          	addi	a0,a0,-632 # 59e0 <malloc+0x22c>
     c60:	00004097          	auipc	ra,0x4
     c64:	75e080e7          	jalr	1886(ra) # 53be <unlink>
}
     c68:	70a2                	ld	ra,40(sp)
     c6a:	7402                	ld	s0,32(sp)
     c6c:	64e2                	ld	s1,24(sp)
     c6e:	6942                	ld	s2,16(sp)
     c70:	69a2                	ld	s3,8(sp)
     c72:	6145                	addi	sp,sp,48
     c74:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c76:	85ce                	mv	a1,s3
     c78:	00005517          	auipc	a0,0x5
     c7c:	41050513          	addi	a0,a0,1040 # 6088 <malloc+0x8d4>
     c80:	00005097          	auipc	ra,0x5
     c84:	a76080e7          	jalr	-1418(ra) # 56f6 <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	00004097          	auipc	ra,0x4
     c8e:	6e4080e7          	jalr	1764(ra) # 536e <exit>
    printf("%s: open unlinkread failed\n", s);
     c92:	85ce                	mv	a1,s3
     c94:	00005517          	auipc	a0,0x5
     c98:	41c50513          	addi	a0,a0,1052 # 60b0 <malloc+0x8fc>
     c9c:	00005097          	auipc	ra,0x5
     ca0:	a5a080e7          	jalr	-1446(ra) # 56f6 <printf>
    exit(1);
     ca4:	4505                	li	a0,1
     ca6:	00004097          	auipc	ra,0x4
     caa:	6c8080e7          	jalr	1736(ra) # 536e <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cae:	85ce                	mv	a1,s3
     cb0:	00005517          	auipc	a0,0x5
     cb4:	42050513          	addi	a0,a0,1056 # 60d0 <malloc+0x91c>
     cb8:	00005097          	auipc	ra,0x5
     cbc:	a3e080e7          	jalr	-1474(ra) # 56f6 <printf>
    exit(1);
     cc0:	4505                	li	a0,1
     cc2:	00004097          	auipc	ra,0x4
     cc6:	6ac080e7          	jalr	1708(ra) # 536e <exit>
    printf("%s: unlinkread read failed", s);
     cca:	85ce                	mv	a1,s3
     ccc:	00005517          	auipc	a0,0x5
     cd0:	42c50513          	addi	a0,a0,1068 # 60f8 <malloc+0x944>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	a22080e7          	jalr	-1502(ra) # 56f6 <printf>
    exit(1);
     cdc:	4505                	li	a0,1
     cde:	00004097          	auipc	ra,0x4
     ce2:	690080e7          	jalr	1680(ra) # 536e <exit>
    printf("%s: unlinkread wrong data\n", s);
     ce6:	85ce                	mv	a1,s3
     ce8:	00005517          	auipc	a0,0x5
     cec:	43050513          	addi	a0,a0,1072 # 6118 <malloc+0x964>
     cf0:	00005097          	auipc	ra,0x5
     cf4:	a06080e7          	jalr	-1530(ra) # 56f6 <printf>
    exit(1);
     cf8:	4505                	li	a0,1
     cfa:	00004097          	auipc	ra,0x4
     cfe:	674080e7          	jalr	1652(ra) # 536e <exit>
    printf("%s: unlinkread write failed\n", s);
     d02:	85ce                	mv	a1,s3
     d04:	00005517          	auipc	a0,0x5
     d08:	43450513          	addi	a0,a0,1076 # 6138 <malloc+0x984>
     d0c:	00005097          	auipc	ra,0x5
     d10:	9ea080e7          	jalr	-1558(ra) # 56f6 <printf>
    exit(1);
     d14:	4505                	li	a0,1
     d16:	00004097          	auipc	ra,0x4
     d1a:	658080e7          	jalr	1624(ra) # 536e <exit>

0000000000000d1e <linktest>:
{
     d1e:	1101                	addi	sp,sp,-32
     d20:	ec06                	sd	ra,24(sp)
     d22:	e822                	sd	s0,16(sp)
     d24:	e426                	sd	s1,8(sp)
     d26:	e04a                	sd	s2,0(sp)
     d28:	1000                	addi	s0,sp,32
     d2a:	892a                	mv	s2,a0
  unlink("lf1");
     d2c:	00005517          	auipc	a0,0x5
     d30:	42c50513          	addi	a0,a0,1068 # 6158 <malloc+0x9a4>
     d34:	00004097          	auipc	ra,0x4
     d38:	68a080e7          	jalr	1674(ra) # 53be <unlink>
  unlink("lf2");
     d3c:	00005517          	auipc	a0,0x5
     d40:	42450513          	addi	a0,a0,1060 # 6160 <malloc+0x9ac>
     d44:	00004097          	auipc	ra,0x4
     d48:	67a080e7          	jalr	1658(ra) # 53be <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d4c:	20200593          	li	a1,514
     d50:	00005517          	auipc	a0,0x5
     d54:	40850513          	addi	a0,a0,1032 # 6158 <malloc+0x9a4>
     d58:	00004097          	auipc	ra,0x4
     d5c:	656080e7          	jalr	1622(ra) # 53ae <open>
  if(fd < 0){
     d60:	10054763          	bltz	a0,e6e <linktest+0x150>
     d64:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d66:	4615                	li	a2,5
     d68:	00005597          	auipc	a1,0x5
     d6c:	34058593          	addi	a1,a1,832 # 60a8 <malloc+0x8f4>
     d70:	00004097          	auipc	ra,0x4
     d74:	61e080e7          	jalr	1566(ra) # 538e <write>
     d78:	4795                	li	a5,5
     d7a:	10f51863          	bne	a0,a5,e8a <linktest+0x16c>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	00004097          	auipc	ra,0x4
     d84:	616080e7          	jalr	1558(ra) # 5396 <close>
  if(link("lf1", "lf2") < 0){
     d88:	00005597          	auipc	a1,0x5
     d8c:	3d858593          	addi	a1,a1,984 # 6160 <malloc+0x9ac>
     d90:	00005517          	auipc	a0,0x5
     d94:	3c850513          	addi	a0,a0,968 # 6158 <malloc+0x9a4>
     d98:	00004097          	auipc	ra,0x4
     d9c:	636080e7          	jalr	1590(ra) # 53ce <link>
     da0:	10054363          	bltz	a0,ea6 <linktest+0x188>
  unlink("lf1");
     da4:	00005517          	auipc	a0,0x5
     da8:	3b450513          	addi	a0,a0,948 # 6158 <malloc+0x9a4>
     dac:	00004097          	auipc	ra,0x4
     db0:	612080e7          	jalr	1554(ra) # 53be <unlink>
  if(open("lf1", 0) >= 0){
     db4:	4581                	li	a1,0
     db6:	00005517          	auipc	a0,0x5
     dba:	3a250513          	addi	a0,a0,930 # 6158 <malloc+0x9a4>
     dbe:	00004097          	auipc	ra,0x4
     dc2:	5f0080e7          	jalr	1520(ra) # 53ae <open>
     dc6:	0e055e63          	bgez	a0,ec2 <linktest+0x1a4>
  fd = open("lf2", 0);
     dca:	4581                	li	a1,0
     dcc:	00005517          	auipc	a0,0x5
     dd0:	39450513          	addi	a0,a0,916 # 6160 <malloc+0x9ac>
     dd4:	00004097          	auipc	ra,0x4
     dd8:	5da080e7          	jalr	1498(ra) # 53ae <open>
     ddc:	84aa                	mv	s1,a0
  if(fd < 0){
     dde:	10054063          	bltz	a0,ede <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000b597          	auipc	a1,0xb
     de8:	95458593          	addi	a1,a1,-1708 # b738 <buf>
     dec:	00004097          	auipc	ra,0x4
     df0:	59a080e7          	jalr	1434(ra) # 5386 <read>
     df4:	4795                	li	a5,5
     df6:	10f51263          	bne	a0,a5,efa <linktest+0x1dc>
  close(fd);
     dfa:	8526                	mv	a0,s1
     dfc:	00004097          	auipc	ra,0x4
     e00:	59a080e7          	jalr	1434(ra) # 5396 <close>
  if(link("lf2", "lf2") >= 0){
     e04:	00005597          	auipc	a1,0x5
     e08:	35c58593          	addi	a1,a1,860 # 6160 <malloc+0x9ac>
     e0c:	852e                	mv	a0,a1
     e0e:	00004097          	auipc	ra,0x4
     e12:	5c0080e7          	jalr	1472(ra) # 53ce <link>
     e16:	10055063          	bgez	a0,f16 <linktest+0x1f8>
  unlink("lf2");
     e1a:	00005517          	auipc	a0,0x5
     e1e:	34650513          	addi	a0,a0,838 # 6160 <malloc+0x9ac>
     e22:	00004097          	auipc	ra,0x4
     e26:	59c080e7          	jalr	1436(ra) # 53be <unlink>
  if(link("lf2", "lf1") >= 0){
     e2a:	00005597          	auipc	a1,0x5
     e2e:	32e58593          	addi	a1,a1,814 # 6158 <malloc+0x9a4>
     e32:	00005517          	auipc	a0,0x5
     e36:	32e50513          	addi	a0,a0,814 # 6160 <malloc+0x9ac>
     e3a:	00004097          	auipc	ra,0x4
     e3e:	594080e7          	jalr	1428(ra) # 53ce <link>
     e42:	0e055863          	bgez	a0,f32 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e46:	00005597          	auipc	a1,0x5
     e4a:	31258593          	addi	a1,a1,786 # 6158 <malloc+0x9a4>
     e4e:	00005517          	auipc	a0,0x5
     e52:	41a50513          	addi	a0,a0,1050 # 6268 <malloc+0xab4>
     e56:	00004097          	auipc	ra,0x4
     e5a:	578080e7          	jalr	1400(ra) # 53ce <link>
     e5e:	0e055863          	bgez	a0,f4e <linktest+0x230>
}
     e62:	60e2                	ld	ra,24(sp)
     e64:	6442                	ld	s0,16(sp)
     e66:	64a2                	ld	s1,8(sp)
     e68:	6902                	ld	s2,0(sp)
     e6a:	6105                	addi	sp,sp,32
     e6c:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e6e:	85ca                	mv	a1,s2
     e70:	00005517          	auipc	a0,0x5
     e74:	2f850513          	addi	a0,a0,760 # 6168 <malloc+0x9b4>
     e78:	00005097          	auipc	ra,0x5
     e7c:	87e080e7          	jalr	-1922(ra) # 56f6 <printf>
    exit(1);
     e80:	4505                	li	a0,1
     e82:	00004097          	auipc	ra,0x4
     e86:	4ec080e7          	jalr	1260(ra) # 536e <exit>
    printf("%s: write lf1 failed\n", s);
     e8a:	85ca                	mv	a1,s2
     e8c:	00005517          	auipc	a0,0x5
     e90:	2f450513          	addi	a0,a0,756 # 6180 <malloc+0x9cc>
     e94:	00005097          	auipc	ra,0x5
     e98:	862080e7          	jalr	-1950(ra) # 56f6 <printf>
    exit(1);
     e9c:	4505                	li	a0,1
     e9e:	00004097          	auipc	ra,0x4
     ea2:	4d0080e7          	jalr	1232(ra) # 536e <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ea6:	85ca                	mv	a1,s2
     ea8:	00005517          	auipc	a0,0x5
     eac:	2f050513          	addi	a0,a0,752 # 6198 <malloc+0x9e4>
     eb0:	00005097          	auipc	ra,0x5
     eb4:	846080e7          	jalr	-1978(ra) # 56f6 <printf>
    exit(1);
     eb8:	4505                	li	a0,1
     eba:	00004097          	auipc	ra,0x4
     ebe:	4b4080e7          	jalr	1204(ra) # 536e <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ec2:	85ca                	mv	a1,s2
     ec4:	00005517          	auipc	a0,0x5
     ec8:	2f450513          	addi	a0,a0,756 # 61b8 <malloc+0xa04>
     ecc:	00005097          	auipc	ra,0x5
     ed0:	82a080e7          	jalr	-2006(ra) # 56f6 <printf>
    exit(1);
     ed4:	4505                	li	a0,1
     ed6:	00004097          	auipc	ra,0x4
     eda:	498080e7          	jalr	1176(ra) # 536e <exit>
    printf("%s: open lf2 failed\n", s);
     ede:	85ca                	mv	a1,s2
     ee0:	00005517          	auipc	a0,0x5
     ee4:	30850513          	addi	a0,a0,776 # 61e8 <malloc+0xa34>
     ee8:	00005097          	auipc	ra,0x5
     eec:	80e080e7          	jalr	-2034(ra) # 56f6 <printf>
    exit(1);
     ef0:	4505                	li	a0,1
     ef2:	00004097          	auipc	ra,0x4
     ef6:	47c080e7          	jalr	1148(ra) # 536e <exit>
    printf("%s: read lf2 failed\n", s);
     efa:	85ca                	mv	a1,s2
     efc:	00005517          	auipc	a0,0x5
     f00:	30450513          	addi	a0,a0,772 # 6200 <malloc+0xa4c>
     f04:	00004097          	auipc	ra,0x4
     f08:	7f2080e7          	jalr	2034(ra) # 56f6 <printf>
    exit(1);
     f0c:	4505                	li	a0,1
     f0e:	00004097          	auipc	ra,0x4
     f12:	460080e7          	jalr	1120(ra) # 536e <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f16:	85ca                	mv	a1,s2
     f18:	00005517          	auipc	a0,0x5
     f1c:	30050513          	addi	a0,a0,768 # 6218 <malloc+0xa64>
     f20:	00004097          	auipc	ra,0x4
     f24:	7d6080e7          	jalr	2006(ra) # 56f6 <printf>
    exit(1);
     f28:	4505                	li	a0,1
     f2a:	00004097          	auipc	ra,0x4
     f2e:	444080e7          	jalr	1092(ra) # 536e <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f32:	85ca                	mv	a1,s2
     f34:	00005517          	auipc	a0,0x5
     f38:	30c50513          	addi	a0,a0,780 # 6240 <malloc+0xa8c>
     f3c:	00004097          	auipc	ra,0x4
     f40:	7ba080e7          	jalr	1978(ra) # 56f6 <printf>
    exit(1);
     f44:	4505                	li	a0,1
     f46:	00004097          	auipc	ra,0x4
     f4a:	428080e7          	jalr	1064(ra) # 536e <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f4e:	85ca                	mv	a1,s2
     f50:	00005517          	auipc	a0,0x5
     f54:	32050513          	addi	a0,a0,800 # 6270 <malloc+0xabc>
     f58:	00004097          	auipc	ra,0x4
     f5c:	79e080e7          	jalr	1950(ra) # 56f6 <printf>
    exit(1);
     f60:	4505                	li	a0,1
     f62:	00004097          	auipc	ra,0x4
     f66:	40c080e7          	jalr	1036(ra) # 536e <exit>

0000000000000f6a <bigdir>:
{
     f6a:	715d                	addi	sp,sp,-80
     f6c:	e486                	sd	ra,72(sp)
     f6e:	e0a2                	sd	s0,64(sp)
     f70:	fc26                	sd	s1,56(sp)
     f72:	f84a                	sd	s2,48(sp)
     f74:	f44e                	sd	s3,40(sp)
     f76:	f052                	sd	s4,32(sp)
     f78:	ec56                	sd	s5,24(sp)
     f7a:	e85a                	sd	s6,16(sp)
     f7c:	0880                	addi	s0,sp,80
     f7e:	89aa                	mv	s3,a0
  unlink("bd");
     f80:	00005517          	auipc	a0,0x5
     f84:	31050513          	addi	a0,a0,784 # 6290 <malloc+0xadc>
     f88:	00004097          	auipc	ra,0x4
     f8c:	436080e7          	jalr	1078(ra) # 53be <unlink>
  fd = open("bd", O_CREATE);
     f90:	20000593          	li	a1,512
     f94:	00005517          	auipc	a0,0x5
     f98:	2fc50513          	addi	a0,a0,764 # 6290 <malloc+0xadc>
     f9c:	00004097          	auipc	ra,0x4
     fa0:	412080e7          	jalr	1042(ra) # 53ae <open>
  if(fd < 0){
     fa4:	0c054963          	bltz	a0,1076 <bigdir+0x10c>
  close(fd);
     fa8:	00004097          	auipc	ra,0x4
     fac:	3ee080e7          	jalr	1006(ra) # 5396 <close>
  for(i = 0; i < N; i++){
     fb0:	4901                	li	s2,0
    name[0] = 'x';
     fb2:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fb6:	00005a17          	auipc	s4,0x5
     fba:	2daa0a13          	addi	s4,s4,730 # 6290 <malloc+0xadc>
  for(i = 0; i < N; i++){
     fbe:	1f400b13          	li	s6,500
    name[0] = 'x';
     fc2:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fc6:	41f9579b          	sraiw	a5,s2,0x1f
     fca:	01a7d71b          	srliw	a4,a5,0x1a
     fce:	012707bb          	addw	a5,a4,s2
     fd2:	4067d69b          	sraiw	a3,a5,0x6
     fd6:	0306869b          	addiw	a3,a3,48
     fda:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fde:	03f7f793          	andi	a5,a5,63
     fe2:	9f99                	subw	a5,a5,a4
     fe4:	0307879b          	addiw	a5,a5,48
     fe8:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fec:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     ff0:	fb040593          	addi	a1,s0,-80
     ff4:	8552                	mv	a0,s4
     ff6:	00004097          	auipc	ra,0x4
     ffa:	3d8080e7          	jalr	984(ra) # 53ce <link>
     ffe:	84aa                	mv	s1,a0
    1000:	e949                	bnez	a0,1092 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1002:	2905                	addiw	s2,s2,1
    1004:	fb691fe3          	bne	s2,s6,fc2 <bigdir+0x58>
  unlink("bd");
    1008:	00005517          	auipc	a0,0x5
    100c:	28850513          	addi	a0,a0,648 # 6290 <malloc+0xadc>
    1010:	00004097          	auipc	ra,0x4
    1014:	3ae080e7          	jalr	942(ra) # 53be <unlink>
    name[0] = 'x';
    1018:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    101c:	1f400a13          	li	s4,500
    name[0] = 'x';
    1020:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1024:	41f4d79b          	sraiw	a5,s1,0x1f
    1028:	01a7d71b          	srliw	a4,a5,0x1a
    102c:	009707bb          	addw	a5,a4,s1
    1030:	4067d69b          	sraiw	a3,a5,0x6
    1034:	0306869b          	addiw	a3,a3,48
    1038:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    103c:	03f7f793          	andi	a5,a5,63
    1040:	9f99                	subw	a5,a5,a4
    1042:	0307879b          	addiw	a5,a5,48
    1046:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    104a:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    104e:	fb040513          	addi	a0,s0,-80
    1052:	00004097          	auipc	ra,0x4
    1056:	36c080e7          	jalr	876(ra) # 53be <unlink>
    105a:	ed21                	bnez	a0,10b2 <bigdir+0x148>
  for(i = 0; i < N; i++){
    105c:	2485                	addiw	s1,s1,1
    105e:	fd4491e3          	bne	s1,s4,1020 <bigdir+0xb6>
}
    1062:	60a6                	ld	ra,72(sp)
    1064:	6406                	ld	s0,64(sp)
    1066:	74e2                	ld	s1,56(sp)
    1068:	7942                	ld	s2,48(sp)
    106a:	79a2                	ld	s3,40(sp)
    106c:	7a02                	ld	s4,32(sp)
    106e:	6ae2                	ld	s5,24(sp)
    1070:	6b42                	ld	s6,16(sp)
    1072:	6161                	addi	sp,sp,80
    1074:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1076:	85ce                	mv	a1,s3
    1078:	00005517          	auipc	a0,0x5
    107c:	22050513          	addi	a0,a0,544 # 6298 <malloc+0xae4>
    1080:	00004097          	auipc	ra,0x4
    1084:	676080e7          	jalr	1654(ra) # 56f6 <printf>
    exit(1);
    1088:	4505                	li	a0,1
    108a:	00004097          	auipc	ra,0x4
    108e:	2e4080e7          	jalr	740(ra) # 536e <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1092:	fb040613          	addi	a2,s0,-80
    1096:	85ce                	mv	a1,s3
    1098:	00005517          	auipc	a0,0x5
    109c:	22050513          	addi	a0,a0,544 # 62b8 <malloc+0xb04>
    10a0:	00004097          	auipc	ra,0x4
    10a4:	656080e7          	jalr	1622(ra) # 56f6 <printf>
      exit(1);
    10a8:	4505                	li	a0,1
    10aa:	00004097          	auipc	ra,0x4
    10ae:	2c4080e7          	jalr	708(ra) # 536e <exit>
      printf("%s: bigdir unlink failed", s);
    10b2:	85ce                	mv	a1,s3
    10b4:	00005517          	auipc	a0,0x5
    10b8:	22450513          	addi	a0,a0,548 # 62d8 <malloc+0xb24>
    10bc:	00004097          	auipc	ra,0x4
    10c0:	63a080e7          	jalr	1594(ra) # 56f6 <printf>
      exit(1);
    10c4:	4505                	li	a0,1
    10c6:	00004097          	auipc	ra,0x4
    10ca:	2a8080e7          	jalr	680(ra) # 536e <exit>

00000000000010ce <validatetest>:
{
    10ce:	7139                	addi	sp,sp,-64
    10d0:	fc06                	sd	ra,56(sp)
    10d2:	f822                	sd	s0,48(sp)
    10d4:	f426                	sd	s1,40(sp)
    10d6:	f04a                	sd	s2,32(sp)
    10d8:	ec4e                	sd	s3,24(sp)
    10da:	e852                	sd	s4,16(sp)
    10dc:	e456                	sd	s5,8(sp)
    10de:	e05a                	sd	s6,0(sp)
    10e0:	0080                	addi	s0,sp,64
    10e2:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e4:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10e6:	00005997          	auipc	s3,0x5
    10ea:	21298993          	addi	s3,s3,530 # 62f8 <malloc+0xb44>
    10ee:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10f0:	6a85                	lui	s5,0x1
    10f2:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10f6:	85a6                	mv	a1,s1
    10f8:	854e                	mv	a0,s3
    10fa:	00004097          	auipc	ra,0x4
    10fe:	2d4080e7          	jalr	724(ra) # 53ce <link>
    1102:	01251f63          	bne	a0,s2,1120 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1106:	94d6                	add	s1,s1,s5
    1108:	ff4497e3          	bne	s1,s4,10f6 <validatetest+0x28>
}
    110c:	70e2                	ld	ra,56(sp)
    110e:	7442                	ld	s0,48(sp)
    1110:	74a2                	ld	s1,40(sp)
    1112:	7902                	ld	s2,32(sp)
    1114:	69e2                	ld	s3,24(sp)
    1116:	6a42                	ld	s4,16(sp)
    1118:	6aa2                	ld	s5,8(sp)
    111a:	6b02                	ld	s6,0(sp)
    111c:	6121                	addi	sp,sp,64
    111e:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1120:	85da                	mv	a1,s6
    1122:	00005517          	auipc	a0,0x5
    1126:	1e650513          	addi	a0,a0,486 # 6308 <malloc+0xb54>
    112a:	00004097          	auipc	ra,0x4
    112e:	5cc080e7          	jalr	1484(ra) # 56f6 <printf>
      exit(1);
    1132:	4505                	li	a0,1
    1134:	00004097          	auipc	ra,0x4
    1138:	23a080e7          	jalr	570(ra) # 536e <exit>

000000000000113c <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    113c:	7179                	addi	sp,sp,-48
    113e:	f406                	sd	ra,40(sp)
    1140:	f022                	sd	s0,32(sp)
    1142:	ec26                	sd	s1,24(sp)
    1144:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1146:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    114a:	00007497          	auipc	s1,0x7
    114e:	db64b483          	ld	s1,-586(s1) # 7f00 <__SDATA_BEGIN__>
    1152:	fd840593          	addi	a1,s0,-40
    1156:	8526                	mv	a0,s1
    1158:	00004097          	auipc	ra,0x4
    115c:	24e080e7          	jalr	590(ra) # 53a6 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1160:	8526                	mv	a0,s1
    1162:	00004097          	auipc	ra,0x4
    1166:	21c080e7          	jalr	540(ra) # 537e <pipe>

  exit(0);
    116a:	4501                	li	a0,0
    116c:	00004097          	auipc	ra,0x4
    1170:	202080e7          	jalr	514(ra) # 536e <exit>

0000000000001174 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1174:	7139                	addi	sp,sp,-64
    1176:	fc06                	sd	ra,56(sp)
    1178:	f822                	sd	s0,48(sp)
    117a:	f426                	sd	s1,40(sp)
    117c:	f04a                	sd	s2,32(sp)
    117e:	ec4e                	sd	s3,24(sp)
    1180:	0080                	addi	s0,sp,64
    1182:	64b1                	lui	s1,0xc
    1184:	35048493          	addi	s1,s1,848 # c350 <buf+0xc18>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1188:	597d                	li	s2,-1
    118a:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    118e:	00005997          	auipc	s3,0x5
    1192:	a4298993          	addi	s3,s3,-1470 # 5bd0 <malloc+0x41c>
    argv[0] = (char*)0xffffffff;
    1196:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    119a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    119e:	fc040593          	addi	a1,s0,-64
    11a2:	854e                	mv	a0,s3
    11a4:	00004097          	auipc	ra,0x4
    11a8:	202080e7          	jalr	514(ra) # 53a6 <exec>
  for(int i = 0; i < 50000; i++){
    11ac:	34fd                	addiw	s1,s1,-1
    11ae:	f4e5                	bnez	s1,1196 <badarg+0x22>
  }
  
  exit(0);
    11b0:	4501                	li	a0,0
    11b2:	00004097          	auipc	ra,0x4
    11b6:	1bc080e7          	jalr	444(ra) # 536e <exit>

00000000000011ba <copyinstr2>:
{
    11ba:	7155                	addi	sp,sp,-208
    11bc:	e586                	sd	ra,200(sp)
    11be:	e1a2                	sd	s0,192(sp)
    11c0:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11c2:	f6840793          	addi	a5,s0,-152
    11c6:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11ca:	07800713          	li	a4,120
    11ce:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11d2:	0785                	addi	a5,a5,1
    11d4:	fed79de3          	bne	a5,a3,11ce <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d8:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11dc:	f6840513          	addi	a0,s0,-152
    11e0:	00004097          	auipc	ra,0x4
    11e4:	1de080e7          	jalr	478(ra) # 53be <unlink>
  if(ret != -1){
    11e8:	57fd                	li	a5,-1
    11ea:	0ef51063          	bne	a0,a5,12ca <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11ee:	20100593          	li	a1,513
    11f2:	f6840513          	addi	a0,s0,-152
    11f6:	00004097          	auipc	ra,0x4
    11fa:	1b8080e7          	jalr	440(ra) # 53ae <open>
  if(fd != -1){
    11fe:	57fd                	li	a5,-1
    1200:	0ef51563          	bne	a0,a5,12ea <copyinstr2+0x130>
  ret = link(b, b);
    1204:	f6840593          	addi	a1,s0,-152
    1208:	852e                	mv	a0,a1
    120a:	00004097          	auipc	ra,0x4
    120e:	1c4080e7          	jalr	452(ra) # 53ce <link>
  if(ret != -1){
    1212:	57fd                	li	a5,-1
    1214:	0ef51b63          	bne	a0,a5,130a <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1218:	00006797          	auipc	a5,0x6
    121c:	1b078793          	addi	a5,a5,432 # 73c8 <malloc+0x1c14>
    1220:	f4f43c23          	sd	a5,-168(s0)
    1224:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1228:	f5840593          	addi	a1,s0,-168
    122c:	f6840513          	addi	a0,s0,-152
    1230:	00004097          	auipc	ra,0x4
    1234:	176080e7          	jalr	374(ra) # 53a6 <exec>
  if(ret != -1){
    1238:	57fd                	li	a5,-1
    123a:	0ef51963          	bne	a0,a5,132c <copyinstr2+0x172>
  int pid = fork();
    123e:	00004097          	auipc	ra,0x4
    1242:	128080e7          	jalr	296(ra) # 5366 <fork>
  if(pid < 0){
    1246:	10054363          	bltz	a0,134c <copyinstr2+0x192>
  if(pid == 0){
    124a:	12051463          	bnez	a0,1372 <copyinstr2+0x1b8>
    124e:	00007797          	auipc	a5,0x7
    1252:	dd278793          	addi	a5,a5,-558 # 8020 <big.0>
    1256:	00008697          	auipc	a3,0x8
    125a:	dca68693          	addi	a3,a3,-566 # 9020 <__global_pointer$+0x920>
      big[i] = 'x';
    125e:	07800713          	li	a4,120
    1262:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1266:	0785                	addi	a5,a5,1
    1268:	fed79de3          	bne	a5,a3,1262 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    126c:	00008797          	auipc	a5,0x8
    1270:	da078a23          	sb	zero,-588(a5) # 9020 <__global_pointer$+0x920>
    char *args2[] = { big, big, big, 0 };
    1274:	00007797          	auipc	a5,0x7
    1278:	8cc78793          	addi	a5,a5,-1844 # 7b40 <malloc+0x238c>
    127c:	6390                	ld	a2,0(a5)
    127e:	6794                	ld	a3,8(a5)
    1280:	6b98                	ld	a4,16(a5)
    1282:	6f9c                	ld	a5,24(a5)
    1284:	f2c43823          	sd	a2,-208(s0)
    1288:	f2d43c23          	sd	a3,-200(s0)
    128c:	f4e43023          	sd	a4,-192(s0)
    1290:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1294:	f3040593          	addi	a1,s0,-208
    1298:	00005517          	auipc	a0,0x5
    129c:	93850513          	addi	a0,a0,-1736 # 5bd0 <malloc+0x41c>
    12a0:	00004097          	auipc	ra,0x4
    12a4:	106080e7          	jalr	262(ra) # 53a6 <exec>
    if(ret != -1){
    12a8:	57fd                	li	a5,-1
    12aa:	0af50e63          	beq	a0,a5,1366 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12ae:	55fd                	li	a1,-1
    12b0:	00005517          	auipc	a0,0x5
    12b4:	10050513          	addi	a0,a0,256 # 63b0 <malloc+0xbfc>
    12b8:	00004097          	auipc	ra,0x4
    12bc:	43e080e7          	jalr	1086(ra) # 56f6 <printf>
      exit(1);
    12c0:	4505                	li	a0,1
    12c2:	00004097          	auipc	ra,0x4
    12c6:	0ac080e7          	jalr	172(ra) # 536e <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12ca:	862a                	mv	a2,a0
    12cc:	f6840593          	addi	a1,s0,-152
    12d0:	00005517          	auipc	a0,0x5
    12d4:	05850513          	addi	a0,a0,88 # 6328 <malloc+0xb74>
    12d8:	00004097          	auipc	ra,0x4
    12dc:	41e080e7          	jalr	1054(ra) # 56f6 <printf>
    exit(1);
    12e0:	4505                	li	a0,1
    12e2:	00004097          	auipc	ra,0x4
    12e6:	08c080e7          	jalr	140(ra) # 536e <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12ea:	862a                	mv	a2,a0
    12ec:	f6840593          	addi	a1,s0,-152
    12f0:	00005517          	auipc	a0,0x5
    12f4:	05850513          	addi	a0,a0,88 # 6348 <malloc+0xb94>
    12f8:	00004097          	auipc	ra,0x4
    12fc:	3fe080e7          	jalr	1022(ra) # 56f6 <printf>
    exit(1);
    1300:	4505                	li	a0,1
    1302:	00004097          	auipc	ra,0x4
    1306:	06c080e7          	jalr	108(ra) # 536e <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    130a:	86aa                	mv	a3,a0
    130c:	f6840613          	addi	a2,s0,-152
    1310:	85b2                	mv	a1,a2
    1312:	00005517          	auipc	a0,0x5
    1316:	05650513          	addi	a0,a0,86 # 6368 <malloc+0xbb4>
    131a:	00004097          	auipc	ra,0x4
    131e:	3dc080e7          	jalr	988(ra) # 56f6 <printf>
    exit(1);
    1322:	4505                	li	a0,1
    1324:	00004097          	auipc	ra,0x4
    1328:	04a080e7          	jalr	74(ra) # 536e <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    132c:	567d                	li	a2,-1
    132e:	f6840593          	addi	a1,s0,-152
    1332:	00005517          	auipc	a0,0x5
    1336:	05e50513          	addi	a0,a0,94 # 6390 <malloc+0xbdc>
    133a:	00004097          	auipc	ra,0x4
    133e:	3bc080e7          	jalr	956(ra) # 56f6 <printf>
    exit(1);
    1342:	4505                	li	a0,1
    1344:	00004097          	auipc	ra,0x4
    1348:	02a080e7          	jalr	42(ra) # 536e <exit>
    printf("fork failed\n");
    134c:	00005517          	auipc	a0,0x5
    1350:	4ac50513          	addi	a0,a0,1196 # 67f8 <malloc+0x1044>
    1354:	00004097          	auipc	ra,0x4
    1358:	3a2080e7          	jalr	930(ra) # 56f6 <printf>
    exit(1);
    135c:	4505                	li	a0,1
    135e:	00004097          	auipc	ra,0x4
    1362:	010080e7          	jalr	16(ra) # 536e <exit>
    exit(747); // OK
    1366:	2eb00513          	li	a0,747
    136a:	00004097          	auipc	ra,0x4
    136e:	004080e7          	jalr	4(ra) # 536e <exit>
  int st = 0;
    1372:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1376:	f5440513          	addi	a0,s0,-172
    137a:	00004097          	auipc	ra,0x4
    137e:	ffc080e7          	jalr	-4(ra) # 5376 <wait>
  if(st != 747){
    1382:	f5442703          	lw	a4,-172(s0)
    1386:	2eb00793          	li	a5,747
    138a:	00f71663          	bne	a4,a5,1396 <copyinstr2+0x1dc>
}
    138e:	60ae                	ld	ra,200(sp)
    1390:	640e                	ld	s0,192(sp)
    1392:	6169                	addi	sp,sp,208
    1394:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1396:	00005517          	auipc	a0,0x5
    139a:	04250513          	addi	a0,a0,66 # 63d8 <malloc+0xc24>
    139e:	00004097          	auipc	ra,0x4
    13a2:	358080e7          	jalr	856(ra) # 56f6 <printf>
    exit(1);
    13a6:	4505                	li	a0,1
    13a8:	00004097          	auipc	ra,0x4
    13ac:	fc6080e7          	jalr	-58(ra) # 536e <exit>

00000000000013b0 <truncate3>:
{
    13b0:	7159                	addi	sp,sp,-112
    13b2:	f486                	sd	ra,104(sp)
    13b4:	f0a2                	sd	s0,96(sp)
    13b6:	eca6                	sd	s1,88(sp)
    13b8:	e8ca                	sd	s2,80(sp)
    13ba:	e4ce                	sd	s3,72(sp)
    13bc:	e0d2                	sd	s4,64(sp)
    13be:	fc56                	sd	s5,56(sp)
    13c0:	1880                	addi	s0,sp,112
    13c2:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13c4:	60100593          	li	a1,1537
    13c8:	00005517          	auipc	a0,0x5
    13cc:	86050513          	addi	a0,a0,-1952 # 5c28 <malloc+0x474>
    13d0:	00004097          	auipc	ra,0x4
    13d4:	fde080e7          	jalr	-34(ra) # 53ae <open>
    13d8:	00004097          	auipc	ra,0x4
    13dc:	fbe080e7          	jalr	-66(ra) # 5396 <close>
  pid = fork();
    13e0:	00004097          	auipc	ra,0x4
    13e4:	f86080e7          	jalr	-122(ra) # 5366 <fork>
  if(pid < 0){
    13e8:	08054063          	bltz	a0,1468 <truncate3+0xb8>
  if(pid == 0){
    13ec:	e969                	bnez	a0,14be <truncate3+0x10e>
    13ee:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13f2:	00005a17          	auipc	s4,0x5
    13f6:	836a0a13          	addi	s4,s4,-1994 # 5c28 <malloc+0x474>
      int n = write(fd, "1234567890", 10);
    13fa:	00005a97          	auipc	s5,0x5
    13fe:	03ea8a93          	addi	s5,s5,62 # 6438 <malloc+0xc84>
      int fd = open("truncfile", O_WRONLY);
    1402:	4585                	li	a1,1
    1404:	8552                	mv	a0,s4
    1406:	00004097          	auipc	ra,0x4
    140a:	fa8080e7          	jalr	-88(ra) # 53ae <open>
    140e:	84aa                	mv	s1,a0
      if(fd < 0){
    1410:	06054a63          	bltz	a0,1484 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1414:	4629                	li	a2,10
    1416:	85d6                	mv	a1,s5
    1418:	00004097          	auipc	ra,0x4
    141c:	f76080e7          	jalr	-138(ra) # 538e <write>
      if(n != 10){
    1420:	47a9                	li	a5,10
    1422:	06f51f63          	bne	a0,a5,14a0 <truncate3+0xf0>
      close(fd);
    1426:	8526                	mv	a0,s1
    1428:	00004097          	auipc	ra,0x4
    142c:	f6e080e7          	jalr	-146(ra) # 5396 <close>
      fd = open("truncfile", O_RDONLY);
    1430:	4581                	li	a1,0
    1432:	8552                	mv	a0,s4
    1434:	00004097          	auipc	ra,0x4
    1438:	f7a080e7          	jalr	-134(ra) # 53ae <open>
    143c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    143e:	02000613          	li	a2,32
    1442:	f9840593          	addi	a1,s0,-104
    1446:	00004097          	auipc	ra,0x4
    144a:	f40080e7          	jalr	-192(ra) # 5386 <read>
      close(fd);
    144e:	8526                	mv	a0,s1
    1450:	00004097          	auipc	ra,0x4
    1454:	f46080e7          	jalr	-186(ra) # 5396 <close>
    for(int i = 0; i < 100; i++){
    1458:	39fd                	addiw	s3,s3,-1
    145a:	fa0994e3          	bnez	s3,1402 <truncate3+0x52>
    exit(0);
    145e:	4501                	li	a0,0
    1460:	00004097          	auipc	ra,0x4
    1464:	f0e080e7          	jalr	-242(ra) # 536e <exit>
    printf("%s: fork failed\n", s);
    1468:	85ca                	mv	a1,s2
    146a:	00005517          	auipc	a0,0x5
    146e:	f9e50513          	addi	a0,a0,-98 # 6408 <malloc+0xc54>
    1472:	00004097          	auipc	ra,0x4
    1476:	284080e7          	jalr	644(ra) # 56f6 <printf>
    exit(1);
    147a:	4505                	li	a0,1
    147c:	00004097          	auipc	ra,0x4
    1480:	ef2080e7          	jalr	-270(ra) # 536e <exit>
        printf("%s: open failed\n", s);
    1484:	85ca                	mv	a1,s2
    1486:	00005517          	auipc	a0,0x5
    148a:	f9a50513          	addi	a0,a0,-102 # 6420 <malloc+0xc6c>
    148e:	00004097          	auipc	ra,0x4
    1492:	268080e7          	jalr	616(ra) # 56f6 <printf>
        exit(1);
    1496:	4505                	li	a0,1
    1498:	00004097          	auipc	ra,0x4
    149c:	ed6080e7          	jalr	-298(ra) # 536e <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    14a0:	862a                	mv	a2,a0
    14a2:	85ca                	mv	a1,s2
    14a4:	00005517          	auipc	a0,0x5
    14a8:	fa450513          	addi	a0,a0,-92 # 6448 <malloc+0xc94>
    14ac:	00004097          	auipc	ra,0x4
    14b0:	24a080e7          	jalr	586(ra) # 56f6 <printf>
        exit(1);
    14b4:	4505                	li	a0,1
    14b6:	00004097          	auipc	ra,0x4
    14ba:	eb8080e7          	jalr	-328(ra) # 536e <exit>
    14be:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14c2:	00004a17          	auipc	s4,0x4
    14c6:	766a0a13          	addi	s4,s4,1894 # 5c28 <malloc+0x474>
    int n = write(fd, "xxx", 3);
    14ca:	00005a97          	auipc	s5,0x5
    14ce:	f9ea8a93          	addi	s5,s5,-98 # 6468 <malloc+0xcb4>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14d2:	60100593          	li	a1,1537
    14d6:	8552                	mv	a0,s4
    14d8:	00004097          	auipc	ra,0x4
    14dc:	ed6080e7          	jalr	-298(ra) # 53ae <open>
    14e0:	84aa                	mv	s1,a0
    if(fd < 0){
    14e2:	04054763          	bltz	a0,1530 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14e6:	460d                	li	a2,3
    14e8:	85d6                	mv	a1,s5
    14ea:	00004097          	auipc	ra,0x4
    14ee:	ea4080e7          	jalr	-348(ra) # 538e <write>
    if(n != 3){
    14f2:	478d                	li	a5,3
    14f4:	04f51c63          	bne	a0,a5,154c <truncate3+0x19c>
    close(fd);
    14f8:	8526                	mv	a0,s1
    14fa:	00004097          	auipc	ra,0x4
    14fe:	e9c080e7          	jalr	-356(ra) # 5396 <close>
  for(int i = 0; i < 150; i++){
    1502:	39fd                	addiw	s3,s3,-1
    1504:	fc0997e3          	bnez	s3,14d2 <truncate3+0x122>
  wait(&xstatus);
    1508:	fbc40513          	addi	a0,s0,-68
    150c:	00004097          	auipc	ra,0x4
    1510:	e6a080e7          	jalr	-406(ra) # 5376 <wait>
  unlink("truncfile");
    1514:	00004517          	auipc	a0,0x4
    1518:	71450513          	addi	a0,a0,1812 # 5c28 <malloc+0x474>
    151c:	00004097          	auipc	ra,0x4
    1520:	ea2080e7          	jalr	-350(ra) # 53be <unlink>
  exit(xstatus);
    1524:	fbc42503          	lw	a0,-68(s0)
    1528:	00004097          	auipc	ra,0x4
    152c:	e46080e7          	jalr	-442(ra) # 536e <exit>
      printf("%s: open failed\n", s);
    1530:	85ca                	mv	a1,s2
    1532:	00005517          	auipc	a0,0x5
    1536:	eee50513          	addi	a0,a0,-274 # 6420 <malloc+0xc6c>
    153a:	00004097          	auipc	ra,0x4
    153e:	1bc080e7          	jalr	444(ra) # 56f6 <printf>
      exit(1);
    1542:	4505                	li	a0,1
    1544:	00004097          	auipc	ra,0x4
    1548:	e2a080e7          	jalr	-470(ra) # 536e <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    154c:	862a                	mv	a2,a0
    154e:	85ca                	mv	a1,s2
    1550:	00005517          	auipc	a0,0x5
    1554:	f2050513          	addi	a0,a0,-224 # 6470 <malloc+0xcbc>
    1558:	00004097          	auipc	ra,0x4
    155c:	19e080e7          	jalr	414(ra) # 56f6 <printf>
      exit(1);
    1560:	4505                	li	a0,1
    1562:	00004097          	auipc	ra,0x4
    1566:	e0c080e7          	jalr	-500(ra) # 536e <exit>

000000000000156a <exectest>:
{
    156a:	715d                	addi	sp,sp,-80
    156c:	e486                	sd	ra,72(sp)
    156e:	e0a2                	sd	s0,64(sp)
    1570:	fc26                	sd	s1,56(sp)
    1572:	f84a                	sd	s2,48(sp)
    1574:	0880                	addi	s0,sp,80
    1576:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1578:	00004797          	auipc	a5,0x4
    157c:	65878793          	addi	a5,a5,1624 # 5bd0 <malloc+0x41c>
    1580:	fcf43023          	sd	a5,-64(s0)
    1584:	00005797          	auipc	a5,0x5
    1588:	f0c78793          	addi	a5,a5,-244 # 6490 <malloc+0xcdc>
    158c:	fcf43423          	sd	a5,-56(s0)
    1590:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1594:	00005517          	auipc	a0,0x5
    1598:	f0450513          	addi	a0,a0,-252 # 6498 <malloc+0xce4>
    159c:	00004097          	auipc	ra,0x4
    15a0:	e22080e7          	jalr	-478(ra) # 53be <unlink>
  pid = fork();
    15a4:	00004097          	auipc	ra,0x4
    15a8:	dc2080e7          	jalr	-574(ra) # 5366 <fork>
  if(pid < 0) {
    15ac:	04054663          	bltz	a0,15f8 <exectest+0x8e>
    15b0:	84aa                	mv	s1,a0
  if(pid == 0) {
    15b2:	e959                	bnez	a0,1648 <exectest+0xde>
    close(1);
    15b4:	4505                	li	a0,1
    15b6:	00004097          	auipc	ra,0x4
    15ba:	de0080e7          	jalr	-544(ra) # 5396 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15be:	20100593          	li	a1,513
    15c2:	00005517          	auipc	a0,0x5
    15c6:	ed650513          	addi	a0,a0,-298 # 6498 <malloc+0xce4>
    15ca:	00004097          	auipc	ra,0x4
    15ce:	de4080e7          	jalr	-540(ra) # 53ae <open>
    if(fd < 0) {
    15d2:	04054163          	bltz	a0,1614 <exectest+0xaa>
    if(fd != 1) {
    15d6:	4785                	li	a5,1
    15d8:	04f50c63          	beq	a0,a5,1630 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15dc:	85ca                	mv	a1,s2
    15de:	00005517          	auipc	a0,0x5
    15e2:	eda50513          	addi	a0,a0,-294 # 64b8 <malloc+0xd04>
    15e6:	00004097          	auipc	ra,0x4
    15ea:	110080e7          	jalr	272(ra) # 56f6 <printf>
      exit(1);
    15ee:	4505                	li	a0,1
    15f0:	00004097          	auipc	ra,0x4
    15f4:	d7e080e7          	jalr	-642(ra) # 536e <exit>
     printf("%s: fork failed\n", s);
    15f8:	85ca                	mv	a1,s2
    15fa:	00005517          	auipc	a0,0x5
    15fe:	e0e50513          	addi	a0,a0,-498 # 6408 <malloc+0xc54>
    1602:	00004097          	auipc	ra,0x4
    1606:	0f4080e7          	jalr	244(ra) # 56f6 <printf>
     exit(1);
    160a:	4505                	li	a0,1
    160c:	00004097          	auipc	ra,0x4
    1610:	d62080e7          	jalr	-670(ra) # 536e <exit>
      printf("%s: create failed\n", s);
    1614:	85ca                	mv	a1,s2
    1616:	00005517          	auipc	a0,0x5
    161a:	e8a50513          	addi	a0,a0,-374 # 64a0 <malloc+0xcec>
    161e:	00004097          	auipc	ra,0x4
    1622:	0d8080e7          	jalr	216(ra) # 56f6 <printf>
      exit(1);
    1626:	4505                	li	a0,1
    1628:	00004097          	auipc	ra,0x4
    162c:	d46080e7          	jalr	-698(ra) # 536e <exit>
    if(exec("echo", echoargv) < 0){
    1630:	fc040593          	addi	a1,s0,-64
    1634:	00004517          	auipc	a0,0x4
    1638:	59c50513          	addi	a0,a0,1436 # 5bd0 <malloc+0x41c>
    163c:	00004097          	auipc	ra,0x4
    1640:	d6a080e7          	jalr	-662(ra) # 53a6 <exec>
    1644:	02054163          	bltz	a0,1666 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1648:	fdc40513          	addi	a0,s0,-36
    164c:	00004097          	auipc	ra,0x4
    1650:	d2a080e7          	jalr	-726(ra) # 5376 <wait>
    1654:	02951763          	bne	a0,s1,1682 <exectest+0x118>
  if(xstatus != 0)
    1658:	fdc42503          	lw	a0,-36(s0)
    165c:	cd0d                	beqz	a0,1696 <exectest+0x12c>
    exit(xstatus);
    165e:	00004097          	auipc	ra,0x4
    1662:	d10080e7          	jalr	-752(ra) # 536e <exit>
      printf("%s: exec echo failed\n", s);
    1666:	85ca                	mv	a1,s2
    1668:	00005517          	auipc	a0,0x5
    166c:	e6050513          	addi	a0,a0,-416 # 64c8 <malloc+0xd14>
    1670:	00004097          	auipc	ra,0x4
    1674:	086080e7          	jalr	134(ra) # 56f6 <printf>
      exit(1);
    1678:	4505                	li	a0,1
    167a:	00004097          	auipc	ra,0x4
    167e:	cf4080e7          	jalr	-780(ra) # 536e <exit>
    printf("%s: wait failed!\n", s);
    1682:	85ca                	mv	a1,s2
    1684:	00005517          	auipc	a0,0x5
    1688:	e5c50513          	addi	a0,a0,-420 # 64e0 <malloc+0xd2c>
    168c:	00004097          	auipc	ra,0x4
    1690:	06a080e7          	jalr	106(ra) # 56f6 <printf>
    1694:	b7d1                	j	1658 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1696:	4581                	li	a1,0
    1698:	00005517          	auipc	a0,0x5
    169c:	e0050513          	addi	a0,a0,-512 # 6498 <malloc+0xce4>
    16a0:	00004097          	auipc	ra,0x4
    16a4:	d0e080e7          	jalr	-754(ra) # 53ae <open>
  if(fd < 0) {
    16a8:	02054a63          	bltz	a0,16dc <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16ac:	4609                	li	a2,2
    16ae:	fb840593          	addi	a1,s0,-72
    16b2:	00004097          	auipc	ra,0x4
    16b6:	cd4080e7          	jalr	-812(ra) # 5386 <read>
    16ba:	4789                	li	a5,2
    16bc:	02f50e63          	beq	a0,a5,16f8 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16c0:	85ca                	mv	a1,s2
    16c2:	00005517          	auipc	a0,0x5
    16c6:	89e50513          	addi	a0,a0,-1890 # 5f60 <malloc+0x7ac>
    16ca:	00004097          	auipc	ra,0x4
    16ce:	02c080e7          	jalr	44(ra) # 56f6 <printf>
    exit(1);
    16d2:	4505                	li	a0,1
    16d4:	00004097          	auipc	ra,0x4
    16d8:	c9a080e7          	jalr	-870(ra) # 536e <exit>
    printf("%s: open failed\n", s);
    16dc:	85ca                	mv	a1,s2
    16de:	00005517          	auipc	a0,0x5
    16e2:	d4250513          	addi	a0,a0,-702 # 6420 <malloc+0xc6c>
    16e6:	00004097          	auipc	ra,0x4
    16ea:	010080e7          	jalr	16(ra) # 56f6 <printf>
    exit(1);
    16ee:	4505                	li	a0,1
    16f0:	00004097          	auipc	ra,0x4
    16f4:	c7e080e7          	jalr	-898(ra) # 536e <exit>
  unlink("echo-ok");
    16f8:	00005517          	auipc	a0,0x5
    16fc:	da050513          	addi	a0,a0,-608 # 6498 <malloc+0xce4>
    1700:	00004097          	auipc	ra,0x4
    1704:	cbe080e7          	jalr	-834(ra) # 53be <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1708:	fb844703          	lbu	a4,-72(s0)
    170c:	04f00793          	li	a5,79
    1710:	00f71863          	bne	a4,a5,1720 <exectest+0x1b6>
    1714:	fb944703          	lbu	a4,-71(s0)
    1718:	04b00793          	li	a5,75
    171c:	02f70063          	beq	a4,a5,173c <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1720:	85ca                	mv	a1,s2
    1722:	00005517          	auipc	a0,0x5
    1726:	dd650513          	addi	a0,a0,-554 # 64f8 <malloc+0xd44>
    172a:	00004097          	auipc	ra,0x4
    172e:	fcc080e7          	jalr	-52(ra) # 56f6 <printf>
    exit(1);
    1732:	4505                	li	a0,1
    1734:	00004097          	auipc	ra,0x4
    1738:	c3a080e7          	jalr	-966(ra) # 536e <exit>
    exit(0);
    173c:	4501                	li	a0,0
    173e:	00004097          	auipc	ra,0x4
    1742:	c30080e7          	jalr	-976(ra) # 536e <exit>

0000000000001746 <pipe1>:
{
    1746:	711d                	addi	sp,sp,-96
    1748:	ec86                	sd	ra,88(sp)
    174a:	e8a2                	sd	s0,80(sp)
    174c:	e4a6                	sd	s1,72(sp)
    174e:	e0ca                	sd	s2,64(sp)
    1750:	fc4e                	sd	s3,56(sp)
    1752:	f852                	sd	s4,48(sp)
    1754:	f456                	sd	s5,40(sp)
    1756:	f05a                	sd	s6,32(sp)
    1758:	ec5e                	sd	s7,24(sp)
    175a:	1080                	addi	s0,sp,96
    175c:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    175e:	fa840513          	addi	a0,s0,-88
    1762:	00004097          	auipc	ra,0x4
    1766:	c1c080e7          	jalr	-996(ra) # 537e <pipe>
    176a:	ed25                	bnez	a0,17e2 <pipe1+0x9c>
    176c:	84aa                	mv	s1,a0
  pid = fork();
    176e:	00004097          	auipc	ra,0x4
    1772:	bf8080e7          	jalr	-1032(ra) # 5366 <fork>
    1776:	8a2a                	mv	s4,a0
  if(pid == 0){
    1778:	c159                	beqz	a0,17fe <pipe1+0xb8>
  } else if(pid > 0){
    177a:	16a05e63          	blez	a0,18f6 <pipe1+0x1b0>
    close(fds[1]);
    177e:	fac42503          	lw	a0,-84(s0)
    1782:	00004097          	auipc	ra,0x4
    1786:	c14080e7          	jalr	-1004(ra) # 5396 <close>
    total = 0;
    178a:	8a26                	mv	s4,s1
    cc = 1;
    178c:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    178e:	0000aa97          	auipc	s5,0xa
    1792:	faaa8a93          	addi	s5,s5,-86 # b738 <buf>
      if(cc > sizeof(buf))
    1796:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1798:	864e                	mv	a2,s3
    179a:	85d6                	mv	a1,s5
    179c:	fa842503          	lw	a0,-88(s0)
    17a0:	00004097          	auipc	ra,0x4
    17a4:	be6080e7          	jalr	-1050(ra) # 5386 <read>
    17a8:	10a05263          	blez	a0,18ac <pipe1+0x166>
      for(i = 0; i < n; i++){
    17ac:	0000a717          	auipc	a4,0xa
    17b0:	f8c70713          	addi	a4,a4,-116 # b738 <buf>
    17b4:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b8:	00074683          	lbu	a3,0(a4)
    17bc:	0ff4f793          	andi	a5,s1,255
    17c0:	2485                	addiw	s1,s1,1
    17c2:	0cf69163          	bne	a3,a5,1884 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17c6:	0705                	addi	a4,a4,1
    17c8:	fec498e3          	bne	s1,a2,17b8 <pipe1+0x72>
      total += n;
    17cc:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17d0:	0019979b          	slliw	a5,s3,0x1
    17d4:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d8:	013b7363          	bgeu	s6,s3,17de <pipe1+0x98>
        cc = sizeof(buf);
    17dc:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17de:	84b2                	mv	s1,a2
    17e0:	bf65                	j	1798 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17e2:	85ca                	mv	a1,s2
    17e4:	00005517          	auipc	a0,0x5
    17e8:	d2c50513          	addi	a0,a0,-724 # 6510 <malloc+0xd5c>
    17ec:	00004097          	auipc	ra,0x4
    17f0:	f0a080e7          	jalr	-246(ra) # 56f6 <printf>
    exit(1);
    17f4:	4505                	li	a0,1
    17f6:	00004097          	auipc	ra,0x4
    17fa:	b78080e7          	jalr	-1160(ra) # 536e <exit>
    close(fds[0]);
    17fe:	fa842503          	lw	a0,-88(s0)
    1802:	00004097          	auipc	ra,0x4
    1806:	b94080e7          	jalr	-1132(ra) # 5396 <close>
    for(n = 0; n < N; n++){
    180a:	0000ab17          	auipc	s6,0xa
    180e:	f2eb0b13          	addi	s6,s6,-210 # b738 <buf>
    1812:	416004bb          	negw	s1,s6
    1816:	0ff4f493          	andi	s1,s1,255
    181a:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    181e:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1820:	6a85                	lui	s5,0x1
    1822:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x7d>
{
    1826:	87da                	mv	a5,s6
        buf[i] = seq++;
    1828:	0097873b          	addw	a4,a5,s1
    182c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1830:	0785                	addi	a5,a5,1
    1832:	fef99be3          	bne	s3,a5,1828 <pipe1+0xe2>
        buf[i] = seq++;
    1836:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    183a:	40900613          	li	a2,1033
    183e:	85de                	mv	a1,s7
    1840:	fac42503          	lw	a0,-84(s0)
    1844:	00004097          	auipc	ra,0x4
    1848:	b4a080e7          	jalr	-1206(ra) # 538e <write>
    184c:	40900793          	li	a5,1033
    1850:	00f51c63          	bne	a0,a5,1868 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1854:	24a5                	addiw	s1,s1,9
    1856:	0ff4f493          	andi	s1,s1,255
    185a:	fd5a16e3          	bne	s4,s5,1826 <pipe1+0xe0>
    exit(0);
    185e:	4501                	li	a0,0
    1860:	00004097          	auipc	ra,0x4
    1864:	b0e080e7          	jalr	-1266(ra) # 536e <exit>
        printf("%s: pipe1 oops 1\n", s);
    1868:	85ca                	mv	a1,s2
    186a:	00005517          	auipc	a0,0x5
    186e:	cbe50513          	addi	a0,a0,-834 # 6528 <malloc+0xd74>
    1872:	00004097          	auipc	ra,0x4
    1876:	e84080e7          	jalr	-380(ra) # 56f6 <printf>
        exit(1);
    187a:	4505                	li	a0,1
    187c:	00004097          	auipc	ra,0x4
    1880:	af2080e7          	jalr	-1294(ra) # 536e <exit>
          printf("%s: pipe1 oops 2\n", s);
    1884:	85ca                	mv	a1,s2
    1886:	00005517          	auipc	a0,0x5
    188a:	cba50513          	addi	a0,a0,-838 # 6540 <malloc+0xd8c>
    188e:	00004097          	auipc	ra,0x4
    1892:	e68080e7          	jalr	-408(ra) # 56f6 <printf>
}
    1896:	60e6                	ld	ra,88(sp)
    1898:	6446                	ld	s0,80(sp)
    189a:	64a6                	ld	s1,72(sp)
    189c:	6906                	ld	s2,64(sp)
    189e:	79e2                	ld	s3,56(sp)
    18a0:	7a42                	ld	s4,48(sp)
    18a2:	7aa2                	ld	s5,40(sp)
    18a4:	7b02                	ld	s6,32(sp)
    18a6:	6be2                	ld	s7,24(sp)
    18a8:	6125                	addi	sp,sp,96
    18aa:	8082                	ret
    if(total != N * SZ){
    18ac:	6785                	lui	a5,0x1
    18ae:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x7d>
    18b2:	02fa0063          	beq	s4,a5,18d2 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18b6:	85d2                	mv	a1,s4
    18b8:	00005517          	auipc	a0,0x5
    18bc:	ca050513          	addi	a0,a0,-864 # 6558 <malloc+0xda4>
    18c0:	00004097          	auipc	ra,0x4
    18c4:	e36080e7          	jalr	-458(ra) # 56f6 <printf>
      exit(1);
    18c8:	4505                	li	a0,1
    18ca:	00004097          	auipc	ra,0x4
    18ce:	aa4080e7          	jalr	-1372(ra) # 536e <exit>
    close(fds[0]);
    18d2:	fa842503          	lw	a0,-88(s0)
    18d6:	00004097          	auipc	ra,0x4
    18da:	ac0080e7          	jalr	-1344(ra) # 5396 <close>
    wait(&xstatus);
    18de:	fa440513          	addi	a0,s0,-92
    18e2:	00004097          	auipc	ra,0x4
    18e6:	a94080e7          	jalr	-1388(ra) # 5376 <wait>
    exit(xstatus);
    18ea:	fa442503          	lw	a0,-92(s0)
    18ee:	00004097          	auipc	ra,0x4
    18f2:	a80080e7          	jalr	-1408(ra) # 536e <exit>
    printf("%s: fork() failed\n", s);
    18f6:	85ca                	mv	a1,s2
    18f8:	00005517          	auipc	a0,0x5
    18fc:	c8050513          	addi	a0,a0,-896 # 6578 <malloc+0xdc4>
    1900:	00004097          	auipc	ra,0x4
    1904:	df6080e7          	jalr	-522(ra) # 56f6 <printf>
    exit(1);
    1908:	4505                	li	a0,1
    190a:	00004097          	auipc	ra,0x4
    190e:	a64080e7          	jalr	-1436(ra) # 536e <exit>

0000000000001912 <exitwait>:
{
    1912:	7139                	addi	sp,sp,-64
    1914:	fc06                	sd	ra,56(sp)
    1916:	f822                	sd	s0,48(sp)
    1918:	f426                	sd	s1,40(sp)
    191a:	f04a                	sd	s2,32(sp)
    191c:	ec4e                	sd	s3,24(sp)
    191e:	e852                	sd	s4,16(sp)
    1920:	0080                	addi	s0,sp,64
    1922:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1924:	4901                	li	s2,0
    1926:	06400993          	li	s3,100
    pid = fork();
    192a:	00004097          	auipc	ra,0x4
    192e:	a3c080e7          	jalr	-1476(ra) # 5366 <fork>
    1932:	84aa                	mv	s1,a0
    if(pid < 0){
    1934:	02054a63          	bltz	a0,1968 <exitwait+0x56>
    if(pid){
    1938:	c151                	beqz	a0,19bc <exitwait+0xaa>
      if(wait(&xstate) != pid){
    193a:	fcc40513          	addi	a0,s0,-52
    193e:	00004097          	auipc	ra,0x4
    1942:	a38080e7          	jalr	-1480(ra) # 5376 <wait>
    1946:	02951f63          	bne	a0,s1,1984 <exitwait+0x72>
      if(i != xstate) {
    194a:	fcc42783          	lw	a5,-52(s0)
    194e:	05279963          	bne	a5,s2,19a0 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1952:	2905                	addiw	s2,s2,1
    1954:	fd391be3          	bne	s2,s3,192a <exitwait+0x18>
}
    1958:	70e2                	ld	ra,56(sp)
    195a:	7442                	ld	s0,48(sp)
    195c:	74a2                	ld	s1,40(sp)
    195e:	7902                	ld	s2,32(sp)
    1960:	69e2                	ld	s3,24(sp)
    1962:	6a42                	ld	s4,16(sp)
    1964:	6121                	addi	sp,sp,64
    1966:	8082                	ret
      printf("%s: fork failed\n", s);
    1968:	85d2                	mv	a1,s4
    196a:	00005517          	auipc	a0,0x5
    196e:	a9e50513          	addi	a0,a0,-1378 # 6408 <malloc+0xc54>
    1972:	00004097          	auipc	ra,0x4
    1976:	d84080e7          	jalr	-636(ra) # 56f6 <printf>
      exit(1);
    197a:	4505                	li	a0,1
    197c:	00004097          	auipc	ra,0x4
    1980:	9f2080e7          	jalr	-1550(ra) # 536e <exit>
        printf("%s: wait wrong pid\n", s);
    1984:	85d2                	mv	a1,s4
    1986:	00005517          	auipc	a0,0x5
    198a:	c0a50513          	addi	a0,a0,-1014 # 6590 <malloc+0xddc>
    198e:	00004097          	auipc	ra,0x4
    1992:	d68080e7          	jalr	-664(ra) # 56f6 <printf>
        exit(1);
    1996:	4505                	li	a0,1
    1998:	00004097          	auipc	ra,0x4
    199c:	9d6080e7          	jalr	-1578(ra) # 536e <exit>
        printf("%s: wait wrong exit status\n", s);
    19a0:	85d2                	mv	a1,s4
    19a2:	00005517          	auipc	a0,0x5
    19a6:	c0650513          	addi	a0,a0,-1018 # 65a8 <malloc+0xdf4>
    19aa:	00004097          	auipc	ra,0x4
    19ae:	d4c080e7          	jalr	-692(ra) # 56f6 <printf>
        exit(1);
    19b2:	4505                	li	a0,1
    19b4:	00004097          	auipc	ra,0x4
    19b8:	9ba080e7          	jalr	-1606(ra) # 536e <exit>
      exit(i);
    19bc:	854a                	mv	a0,s2
    19be:	00004097          	auipc	ra,0x4
    19c2:	9b0080e7          	jalr	-1616(ra) # 536e <exit>

00000000000019c6 <twochildren>:
{
    19c6:	1101                	addi	sp,sp,-32
    19c8:	ec06                	sd	ra,24(sp)
    19ca:	e822                	sd	s0,16(sp)
    19cc:	e426                	sd	s1,8(sp)
    19ce:	e04a                	sd	s2,0(sp)
    19d0:	1000                	addi	s0,sp,32
    19d2:	892a                	mv	s2,a0
    19d4:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d8:	00004097          	auipc	ra,0x4
    19dc:	98e080e7          	jalr	-1650(ra) # 5366 <fork>
    if(pid1 < 0){
    19e0:	02054c63          	bltz	a0,1a18 <twochildren+0x52>
    if(pid1 == 0){
    19e4:	c921                	beqz	a0,1a34 <twochildren+0x6e>
      int pid2 = fork();
    19e6:	00004097          	auipc	ra,0x4
    19ea:	980080e7          	jalr	-1664(ra) # 5366 <fork>
      if(pid2 < 0){
    19ee:	04054763          	bltz	a0,1a3c <twochildren+0x76>
      if(pid2 == 0){
    19f2:	c13d                	beqz	a0,1a58 <twochildren+0x92>
        wait(0);
    19f4:	4501                	li	a0,0
    19f6:	00004097          	auipc	ra,0x4
    19fa:	980080e7          	jalr	-1664(ra) # 5376 <wait>
        wait(0);
    19fe:	4501                	li	a0,0
    1a00:	00004097          	auipc	ra,0x4
    1a04:	976080e7          	jalr	-1674(ra) # 5376 <wait>
  for(int i = 0; i < 1000; i++){
    1a08:	34fd                	addiw	s1,s1,-1
    1a0a:	f4f9                	bnez	s1,19d8 <twochildren+0x12>
}
    1a0c:	60e2                	ld	ra,24(sp)
    1a0e:	6442                	ld	s0,16(sp)
    1a10:	64a2                	ld	s1,8(sp)
    1a12:	6902                	ld	s2,0(sp)
    1a14:	6105                	addi	sp,sp,32
    1a16:	8082                	ret
      printf("%s: fork failed\n", s);
    1a18:	85ca                	mv	a1,s2
    1a1a:	00005517          	auipc	a0,0x5
    1a1e:	9ee50513          	addi	a0,a0,-1554 # 6408 <malloc+0xc54>
    1a22:	00004097          	auipc	ra,0x4
    1a26:	cd4080e7          	jalr	-812(ra) # 56f6 <printf>
      exit(1);
    1a2a:	4505                	li	a0,1
    1a2c:	00004097          	auipc	ra,0x4
    1a30:	942080e7          	jalr	-1726(ra) # 536e <exit>
      exit(0);
    1a34:	00004097          	auipc	ra,0x4
    1a38:	93a080e7          	jalr	-1734(ra) # 536e <exit>
        printf("%s: fork failed\n", s);
    1a3c:	85ca                	mv	a1,s2
    1a3e:	00005517          	auipc	a0,0x5
    1a42:	9ca50513          	addi	a0,a0,-1590 # 6408 <malloc+0xc54>
    1a46:	00004097          	auipc	ra,0x4
    1a4a:	cb0080e7          	jalr	-848(ra) # 56f6 <printf>
        exit(1);
    1a4e:	4505                	li	a0,1
    1a50:	00004097          	auipc	ra,0x4
    1a54:	91e080e7          	jalr	-1762(ra) # 536e <exit>
        exit(0);
    1a58:	00004097          	auipc	ra,0x4
    1a5c:	916080e7          	jalr	-1770(ra) # 536e <exit>

0000000000001a60 <forkfork>:
{
    1a60:	7179                	addi	sp,sp,-48
    1a62:	f406                	sd	ra,40(sp)
    1a64:	f022                	sd	s0,32(sp)
    1a66:	ec26                	sd	s1,24(sp)
    1a68:	1800                	addi	s0,sp,48
    1a6a:	84aa                	mv	s1,a0
    int pid = fork();
    1a6c:	00004097          	auipc	ra,0x4
    1a70:	8fa080e7          	jalr	-1798(ra) # 5366 <fork>
    if(pid < 0){
    1a74:	04054163          	bltz	a0,1ab6 <forkfork+0x56>
    if(pid == 0){
    1a78:	cd29                	beqz	a0,1ad2 <forkfork+0x72>
    int pid = fork();
    1a7a:	00004097          	auipc	ra,0x4
    1a7e:	8ec080e7          	jalr	-1812(ra) # 5366 <fork>
    if(pid < 0){
    1a82:	02054a63          	bltz	a0,1ab6 <forkfork+0x56>
    if(pid == 0){
    1a86:	c531                	beqz	a0,1ad2 <forkfork+0x72>
    wait(&xstatus);
    1a88:	fdc40513          	addi	a0,s0,-36
    1a8c:	00004097          	auipc	ra,0x4
    1a90:	8ea080e7          	jalr	-1814(ra) # 5376 <wait>
    if(xstatus != 0) {
    1a94:	fdc42783          	lw	a5,-36(s0)
    1a98:	ebbd                	bnez	a5,1b0e <forkfork+0xae>
    wait(&xstatus);
    1a9a:	fdc40513          	addi	a0,s0,-36
    1a9e:	00004097          	auipc	ra,0x4
    1aa2:	8d8080e7          	jalr	-1832(ra) # 5376 <wait>
    if(xstatus != 0) {
    1aa6:	fdc42783          	lw	a5,-36(s0)
    1aaa:	e3b5                	bnez	a5,1b0e <forkfork+0xae>
}
    1aac:	70a2                	ld	ra,40(sp)
    1aae:	7402                	ld	s0,32(sp)
    1ab0:	64e2                	ld	s1,24(sp)
    1ab2:	6145                	addi	sp,sp,48
    1ab4:	8082                	ret
      printf("%s: fork failed", s);
    1ab6:	85a6                	mv	a1,s1
    1ab8:	00005517          	auipc	a0,0x5
    1abc:	b1050513          	addi	a0,a0,-1264 # 65c8 <malloc+0xe14>
    1ac0:	00004097          	auipc	ra,0x4
    1ac4:	c36080e7          	jalr	-970(ra) # 56f6 <printf>
      exit(1);
    1ac8:	4505                	li	a0,1
    1aca:	00004097          	auipc	ra,0x4
    1ace:	8a4080e7          	jalr	-1884(ra) # 536e <exit>
{
    1ad2:	0c800493          	li	s1,200
        int pid1 = fork();
    1ad6:	00004097          	auipc	ra,0x4
    1ada:	890080e7          	jalr	-1904(ra) # 5366 <fork>
        if(pid1 < 0){
    1ade:	00054f63          	bltz	a0,1afc <forkfork+0x9c>
        if(pid1 == 0){
    1ae2:	c115                	beqz	a0,1b06 <forkfork+0xa6>
        wait(0);
    1ae4:	4501                	li	a0,0
    1ae6:	00004097          	auipc	ra,0x4
    1aea:	890080e7          	jalr	-1904(ra) # 5376 <wait>
      for(int j = 0; j < 200; j++){
    1aee:	34fd                	addiw	s1,s1,-1
    1af0:	f0fd                	bnez	s1,1ad6 <forkfork+0x76>
      exit(0);
    1af2:	4501                	li	a0,0
    1af4:	00004097          	auipc	ra,0x4
    1af8:	87a080e7          	jalr	-1926(ra) # 536e <exit>
          exit(1);
    1afc:	4505                	li	a0,1
    1afe:	00004097          	auipc	ra,0x4
    1b02:	870080e7          	jalr	-1936(ra) # 536e <exit>
          exit(0);
    1b06:	00004097          	auipc	ra,0x4
    1b0a:	868080e7          	jalr	-1944(ra) # 536e <exit>
      printf("%s: fork in child failed", s);
    1b0e:	85a6                	mv	a1,s1
    1b10:	00005517          	auipc	a0,0x5
    1b14:	ac850513          	addi	a0,a0,-1336 # 65d8 <malloc+0xe24>
    1b18:	00004097          	auipc	ra,0x4
    1b1c:	bde080e7          	jalr	-1058(ra) # 56f6 <printf>
      exit(1);
    1b20:	4505                	li	a0,1
    1b22:	00004097          	auipc	ra,0x4
    1b26:	84c080e7          	jalr	-1972(ra) # 536e <exit>

0000000000001b2a <reparent2>:
{
    1b2a:	1101                	addi	sp,sp,-32
    1b2c:	ec06                	sd	ra,24(sp)
    1b2e:	e822                	sd	s0,16(sp)
    1b30:	e426                	sd	s1,8(sp)
    1b32:	1000                	addi	s0,sp,32
    1b34:	32000493          	li	s1,800
    int pid1 = fork();
    1b38:	00004097          	auipc	ra,0x4
    1b3c:	82e080e7          	jalr	-2002(ra) # 5366 <fork>
    if(pid1 < 0){
    1b40:	00054f63          	bltz	a0,1b5e <reparent2+0x34>
    if(pid1 == 0){
    1b44:	c915                	beqz	a0,1b78 <reparent2+0x4e>
    wait(0);
    1b46:	4501                	li	a0,0
    1b48:	00004097          	auipc	ra,0x4
    1b4c:	82e080e7          	jalr	-2002(ra) # 5376 <wait>
  for(int i = 0; i < 800; i++){
    1b50:	34fd                	addiw	s1,s1,-1
    1b52:	f0fd                	bnez	s1,1b38 <reparent2+0xe>
  exit(0);
    1b54:	4501                	li	a0,0
    1b56:	00004097          	auipc	ra,0x4
    1b5a:	818080e7          	jalr	-2024(ra) # 536e <exit>
      printf("fork failed\n");
    1b5e:	00005517          	auipc	a0,0x5
    1b62:	c9a50513          	addi	a0,a0,-870 # 67f8 <malloc+0x1044>
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	b90080e7          	jalr	-1136(ra) # 56f6 <printf>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	00003097          	auipc	ra,0x3
    1b74:	7fe080e7          	jalr	2046(ra) # 536e <exit>
      fork();
    1b78:	00003097          	auipc	ra,0x3
    1b7c:	7ee080e7          	jalr	2030(ra) # 5366 <fork>
      fork();
    1b80:	00003097          	auipc	ra,0x3
    1b84:	7e6080e7          	jalr	2022(ra) # 5366 <fork>
      exit(0);
    1b88:	4501                	li	a0,0
    1b8a:	00003097          	auipc	ra,0x3
    1b8e:	7e4080e7          	jalr	2020(ra) # 536e <exit>

0000000000001b92 <createdelete>:
{
    1b92:	7175                	addi	sp,sp,-144
    1b94:	e506                	sd	ra,136(sp)
    1b96:	e122                	sd	s0,128(sp)
    1b98:	fca6                	sd	s1,120(sp)
    1b9a:	f8ca                	sd	s2,112(sp)
    1b9c:	f4ce                	sd	s3,104(sp)
    1b9e:	f0d2                	sd	s4,96(sp)
    1ba0:	ecd6                	sd	s5,88(sp)
    1ba2:	e8da                	sd	s6,80(sp)
    1ba4:	e4de                	sd	s7,72(sp)
    1ba6:	e0e2                	sd	s8,64(sp)
    1ba8:	fc66                	sd	s9,56(sp)
    1baa:	0900                	addi	s0,sp,144
    1bac:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1bae:	4901                	li	s2,0
    1bb0:	4991                	li	s3,4
    pid = fork();
    1bb2:	00003097          	auipc	ra,0x3
    1bb6:	7b4080e7          	jalr	1972(ra) # 5366 <fork>
    1bba:	84aa                	mv	s1,a0
    if(pid < 0){
    1bbc:	02054f63          	bltz	a0,1bfa <createdelete+0x68>
    if(pid == 0){
    1bc0:	c939                	beqz	a0,1c16 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bc2:	2905                	addiw	s2,s2,1
    1bc4:	ff3917e3          	bne	s2,s3,1bb2 <createdelete+0x20>
    1bc8:	4491                	li	s1,4
    wait(&xstatus);
    1bca:	f7c40513          	addi	a0,s0,-132
    1bce:	00003097          	auipc	ra,0x3
    1bd2:	7a8080e7          	jalr	1960(ra) # 5376 <wait>
    if(xstatus != 0)
    1bd6:	f7c42903          	lw	s2,-132(s0)
    1bda:	0e091263          	bnez	s2,1cbe <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bde:	34fd                	addiw	s1,s1,-1
    1be0:	f4ed                	bnez	s1,1bca <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1be2:	f8040123          	sb	zero,-126(s0)
    1be6:	03000993          	li	s3,48
    1bea:	5a7d                	li	s4,-1
    1bec:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bf0:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bf2:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bf4:	07400a93          	li	s5,116
    1bf8:	a29d                	j	1d5e <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bfa:	85e6                	mv	a1,s9
    1bfc:	00005517          	auipc	a0,0x5
    1c00:	bfc50513          	addi	a0,a0,-1028 # 67f8 <malloc+0x1044>
    1c04:	00004097          	auipc	ra,0x4
    1c08:	af2080e7          	jalr	-1294(ra) # 56f6 <printf>
      exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	00003097          	auipc	ra,0x3
    1c12:	760080e7          	jalr	1888(ra) # 536e <exit>
      name[0] = 'p' + pi;
    1c16:	0709091b          	addiw	s2,s2,112
    1c1a:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c1e:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c22:	4951                	li	s2,20
    1c24:	a015                	j	1c48 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c26:	85e6                	mv	a1,s9
    1c28:	00005517          	auipc	a0,0x5
    1c2c:	87850513          	addi	a0,a0,-1928 # 64a0 <malloc+0xcec>
    1c30:	00004097          	auipc	ra,0x4
    1c34:	ac6080e7          	jalr	-1338(ra) # 56f6 <printf>
          exit(1);
    1c38:	4505                	li	a0,1
    1c3a:	00003097          	auipc	ra,0x3
    1c3e:	734080e7          	jalr	1844(ra) # 536e <exit>
      for(i = 0; i < N; i++){
    1c42:	2485                	addiw	s1,s1,1
    1c44:	07248863          	beq	s1,s2,1cb4 <createdelete+0x122>
        name[1] = '0' + i;
    1c48:	0304879b          	addiw	a5,s1,48
    1c4c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c50:	20200593          	li	a1,514
    1c54:	f8040513          	addi	a0,s0,-128
    1c58:	00003097          	auipc	ra,0x3
    1c5c:	756080e7          	jalr	1878(ra) # 53ae <open>
        if(fd < 0){
    1c60:	fc0543e3          	bltz	a0,1c26 <createdelete+0x94>
        close(fd);
    1c64:	00003097          	auipc	ra,0x3
    1c68:	732080e7          	jalr	1842(ra) # 5396 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c6c:	fc905be3          	blez	s1,1c42 <createdelete+0xb0>
    1c70:	0014f793          	andi	a5,s1,1
    1c74:	f7f9                	bnez	a5,1c42 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c76:	01f4d79b          	srliw	a5,s1,0x1f
    1c7a:	9fa5                	addw	a5,a5,s1
    1c7c:	4017d79b          	sraiw	a5,a5,0x1
    1c80:	0307879b          	addiw	a5,a5,48
    1c84:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c88:	f8040513          	addi	a0,s0,-128
    1c8c:	00003097          	auipc	ra,0x3
    1c90:	732080e7          	jalr	1842(ra) # 53be <unlink>
    1c94:	fa0557e3          	bgez	a0,1c42 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c98:	85e6                	mv	a1,s9
    1c9a:	00005517          	auipc	a0,0x5
    1c9e:	95e50513          	addi	a0,a0,-1698 # 65f8 <malloc+0xe44>
    1ca2:	00004097          	auipc	ra,0x4
    1ca6:	a54080e7          	jalr	-1452(ra) # 56f6 <printf>
            exit(1);
    1caa:	4505                	li	a0,1
    1cac:	00003097          	auipc	ra,0x3
    1cb0:	6c2080e7          	jalr	1730(ra) # 536e <exit>
      exit(0);
    1cb4:	4501                	li	a0,0
    1cb6:	00003097          	auipc	ra,0x3
    1cba:	6b8080e7          	jalr	1720(ra) # 536e <exit>
      exit(1);
    1cbe:	4505                	li	a0,1
    1cc0:	00003097          	auipc	ra,0x3
    1cc4:	6ae080e7          	jalr	1710(ra) # 536e <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc8:	f8040613          	addi	a2,s0,-128
    1ccc:	85e6                	mv	a1,s9
    1cce:	00005517          	auipc	a0,0x5
    1cd2:	94250513          	addi	a0,a0,-1726 # 6610 <malloc+0xe5c>
    1cd6:	00004097          	auipc	ra,0x4
    1cda:	a20080e7          	jalr	-1504(ra) # 56f6 <printf>
        exit(1);
    1cde:	4505                	li	a0,1
    1ce0:	00003097          	auipc	ra,0x3
    1ce4:	68e080e7          	jalr	1678(ra) # 536e <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce8:	054b7163          	bgeu	s6,s4,1d2a <createdelete+0x198>
      if(fd >= 0)
    1cec:	02055a63          	bgez	a0,1d20 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1cf0:	2485                	addiw	s1,s1,1
    1cf2:	0ff4f493          	andi	s1,s1,255
    1cf6:	05548c63          	beq	s1,s5,1d4e <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cfa:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cfe:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1d02:	4581                	li	a1,0
    1d04:	f8040513          	addi	a0,s0,-128
    1d08:	00003097          	auipc	ra,0x3
    1d0c:	6a6080e7          	jalr	1702(ra) # 53ae <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d10:	00090463          	beqz	s2,1d18 <createdelete+0x186>
    1d14:	fd2bdae3          	bge	s7,s2,1ce8 <createdelete+0x156>
    1d18:	fa0548e3          	bltz	a0,1cc8 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d1c:	014b7963          	bgeu	s6,s4,1d2e <createdelete+0x19c>
        close(fd);
    1d20:	00003097          	auipc	ra,0x3
    1d24:	676080e7          	jalr	1654(ra) # 5396 <close>
    1d28:	b7e1                	j	1cf0 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d2a:	fc0543e3          	bltz	a0,1cf0 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d2e:	f8040613          	addi	a2,s0,-128
    1d32:	85e6                	mv	a1,s9
    1d34:	00005517          	auipc	a0,0x5
    1d38:	90450513          	addi	a0,a0,-1788 # 6638 <malloc+0xe84>
    1d3c:	00004097          	auipc	ra,0x4
    1d40:	9ba080e7          	jalr	-1606(ra) # 56f6 <printf>
        exit(1);
    1d44:	4505                	li	a0,1
    1d46:	00003097          	auipc	ra,0x3
    1d4a:	628080e7          	jalr	1576(ra) # 536e <exit>
  for(i = 0; i < N; i++){
    1d4e:	2905                	addiw	s2,s2,1
    1d50:	2a05                	addiw	s4,s4,1
    1d52:	2985                	addiw	s3,s3,1
    1d54:	0ff9f993          	andi	s3,s3,255
    1d58:	47d1                	li	a5,20
    1d5a:	02f90a63          	beq	s2,a5,1d8e <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d5e:	84e2                	mv	s1,s8
    1d60:	bf69                	j	1cfa <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d62:	2905                	addiw	s2,s2,1
    1d64:	0ff97913          	andi	s2,s2,255
    1d68:	2985                	addiw	s3,s3,1
    1d6a:	0ff9f993          	andi	s3,s3,255
    1d6e:	03490863          	beq	s2,s4,1d9e <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d72:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d74:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d78:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d7c:	f8040513          	addi	a0,s0,-128
    1d80:	00003097          	auipc	ra,0x3
    1d84:	63e080e7          	jalr	1598(ra) # 53be <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d88:	34fd                	addiw	s1,s1,-1
    1d8a:	f4ed                	bnez	s1,1d74 <createdelete+0x1e2>
    1d8c:	bfd9                	j	1d62 <createdelete+0x1d0>
    1d8e:	03000993          	li	s3,48
    1d92:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d96:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d98:	08400a13          	li	s4,132
    1d9c:	bfd9                	j	1d72 <createdelete+0x1e0>
}
    1d9e:	60aa                	ld	ra,136(sp)
    1da0:	640a                	ld	s0,128(sp)
    1da2:	74e6                	ld	s1,120(sp)
    1da4:	7946                	ld	s2,112(sp)
    1da6:	79a6                	ld	s3,104(sp)
    1da8:	7a06                	ld	s4,96(sp)
    1daa:	6ae6                	ld	s5,88(sp)
    1dac:	6b46                	ld	s6,80(sp)
    1dae:	6ba6                	ld	s7,72(sp)
    1db0:	6c06                	ld	s8,64(sp)
    1db2:	7ce2                	ld	s9,56(sp)
    1db4:	6149                	addi	sp,sp,144
    1db6:	8082                	ret

0000000000001db8 <linkunlink>:
{
    1db8:	711d                	addi	sp,sp,-96
    1dba:	ec86                	sd	ra,88(sp)
    1dbc:	e8a2                	sd	s0,80(sp)
    1dbe:	e4a6                	sd	s1,72(sp)
    1dc0:	e0ca                	sd	s2,64(sp)
    1dc2:	fc4e                	sd	s3,56(sp)
    1dc4:	f852                	sd	s4,48(sp)
    1dc6:	f456                	sd	s5,40(sp)
    1dc8:	f05a                	sd	s6,32(sp)
    1dca:	ec5e                	sd	s7,24(sp)
    1dcc:	e862                	sd	s8,16(sp)
    1dce:	e466                	sd	s9,8(sp)
    1dd0:	1080                	addi	s0,sp,96
    1dd2:	84aa                	mv	s1,a0
  unlink("x");
    1dd4:	00004517          	auipc	a0,0x4
    1dd8:	e6c50513          	addi	a0,a0,-404 # 5c40 <malloc+0x48c>
    1ddc:	00003097          	auipc	ra,0x3
    1de0:	5e2080e7          	jalr	1506(ra) # 53be <unlink>
  pid = fork();
    1de4:	00003097          	auipc	ra,0x3
    1de8:	582080e7          	jalr	1410(ra) # 5366 <fork>
  if(pid < 0){
    1dec:	02054b63          	bltz	a0,1e22 <linkunlink+0x6a>
    1df0:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1df2:	4c85                	li	s9,1
    1df4:	e119                	bnez	a0,1dfa <linkunlink+0x42>
    1df6:	06100c93          	li	s9,97
    1dfa:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1dfe:	41c659b7          	lui	s3,0x41c65
    1e02:	e6d9899b          	addiw	s3,s3,-403
    1e06:	690d                	lui	s2,0x3
    1e08:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e0c:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e0e:	4b05                	li	s6,1
      unlink("x");
    1e10:	00004a97          	auipc	s5,0x4
    1e14:	e30a8a93          	addi	s5,s5,-464 # 5c40 <malloc+0x48c>
      link("cat", "x");
    1e18:	00005b97          	auipc	s7,0x5
    1e1c:	848b8b93          	addi	s7,s7,-1976 # 6660 <malloc+0xeac>
    1e20:	a825                	j	1e58 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e22:	85a6                	mv	a1,s1
    1e24:	00004517          	auipc	a0,0x4
    1e28:	5e450513          	addi	a0,a0,1508 # 6408 <malloc+0xc54>
    1e2c:	00004097          	auipc	ra,0x4
    1e30:	8ca080e7          	jalr	-1846(ra) # 56f6 <printf>
    exit(1);
    1e34:	4505                	li	a0,1
    1e36:	00003097          	auipc	ra,0x3
    1e3a:	538080e7          	jalr	1336(ra) # 536e <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e3e:	20200593          	li	a1,514
    1e42:	8556                	mv	a0,s5
    1e44:	00003097          	auipc	ra,0x3
    1e48:	56a080e7          	jalr	1386(ra) # 53ae <open>
    1e4c:	00003097          	auipc	ra,0x3
    1e50:	54a080e7          	jalr	1354(ra) # 5396 <close>
  for(i = 0; i < 100; i++){
    1e54:	34fd                	addiw	s1,s1,-1
    1e56:	c88d                	beqz	s1,1e88 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e58:	033c87bb          	mulw	a5,s9,s3
    1e5c:	012787bb          	addw	a5,a5,s2
    1e60:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e64:	0347f7bb          	remuw	a5,a5,s4
    1e68:	dbf9                	beqz	a5,1e3e <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e6a:	01678863          	beq	a5,s6,1e7a <linkunlink+0xc2>
      unlink("x");
    1e6e:	8556                	mv	a0,s5
    1e70:	00003097          	auipc	ra,0x3
    1e74:	54e080e7          	jalr	1358(ra) # 53be <unlink>
    1e78:	bff1                	j	1e54 <linkunlink+0x9c>
      link("cat", "x");
    1e7a:	85d6                	mv	a1,s5
    1e7c:	855e                	mv	a0,s7
    1e7e:	00003097          	auipc	ra,0x3
    1e82:	550080e7          	jalr	1360(ra) # 53ce <link>
    1e86:	b7f9                	j	1e54 <linkunlink+0x9c>
  if(pid)
    1e88:	020c0463          	beqz	s8,1eb0 <linkunlink+0xf8>
    wait(0);
    1e8c:	4501                	li	a0,0
    1e8e:	00003097          	auipc	ra,0x3
    1e92:	4e8080e7          	jalr	1256(ra) # 5376 <wait>
}
    1e96:	60e6                	ld	ra,88(sp)
    1e98:	6446                	ld	s0,80(sp)
    1e9a:	64a6                	ld	s1,72(sp)
    1e9c:	6906                	ld	s2,64(sp)
    1e9e:	79e2                	ld	s3,56(sp)
    1ea0:	7a42                	ld	s4,48(sp)
    1ea2:	7aa2                	ld	s5,40(sp)
    1ea4:	7b02                	ld	s6,32(sp)
    1ea6:	6be2                	ld	s7,24(sp)
    1ea8:	6c42                	ld	s8,16(sp)
    1eaa:	6ca2                	ld	s9,8(sp)
    1eac:	6125                	addi	sp,sp,96
    1eae:	8082                	ret
    exit(0);
    1eb0:	4501                	li	a0,0
    1eb2:	00003097          	auipc	ra,0x3
    1eb6:	4bc080e7          	jalr	1212(ra) # 536e <exit>

0000000000001eba <forktest>:
{
    1eba:	7179                	addi	sp,sp,-48
    1ebc:	f406                	sd	ra,40(sp)
    1ebe:	f022                	sd	s0,32(sp)
    1ec0:	ec26                	sd	s1,24(sp)
    1ec2:	e84a                	sd	s2,16(sp)
    1ec4:	e44e                	sd	s3,8(sp)
    1ec6:	1800                	addi	s0,sp,48
    1ec8:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1eca:	4481                	li	s1,0
    1ecc:	3e800913          	li	s2,1000
    pid = fork();
    1ed0:	00003097          	auipc	ra,0x3
    1ed4:	496080e7          	jalr	1174(ra) # 5366 <fork>
    if(pid < 0)
    1ed8:	02054863          	bltz	a0,1f08 <forktest+0x4e>
    if(pid == 0)
    1edc:	c115                	beqz	a0,1f00 <forktest+0x46>
  for(n=0; n<N; n++){
    1ede:	2485                	addiw	s1,s1,1
    1ee0:	ff2498e3          	bne	s1,s2,1ed0 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ee4:	85ce                	mv	a1,s3
    1ee6:	00004517          	auipc	a0,0x4
    1eea:	79a50513          	addi	a0,a0,1946 # 6680 <malloc+0xecc>
    1eee:	00004097          	auipc	ra,0x4
    1ef2:	808080e7          	jalr	-2040(ra) # 56f6 <printf>
    exit(1);
    1ef6:	4505                	li	a0,1
    1ef8:	00003097          	auipc	ra,0x3
    1efc:	476080e7          	jalr	1142(ra) # 536e <exit>
      exit(0);
    1f00:	00003097          	auipc	ra,0x3
    1f04:	46e080e7          	jalr	1134(ra) # 536e <exit>
  if (n == 0) {
    1f08:	cc9d                	beqz	s1,1f46 <forktest+0x8c>
  if(n == N){
    1f0a:	3e800793          	li	a5,1000
    1f0e:	fcf48be3          	beq	s1,a5,1ee4 <forktest+0x2a>
  for(; n > 0; n--){
    1f12:	00905b63          	blez	s1,1f28 <forktest+0x6e>
    if(wait(0) < 0){
    1f16:	4501                	li	a0,0
    1f18:	00003097          	auipc	ra,0x3
    1f1c:	45e080e7          	jalr	1118(ra) # 5376 <wait>
    1f20:	04054163          	bltz	a0,1f62 <forktest+0xa8>
  for(; n > 0; n--){
    1f24:	34fd                	addiw	s1,s1,-1
    1f26:	f8e5                	bnez	s1,1f16 <forktest+0x5c>
  if(wait(0) != -1){
    1f28:	4501                	li	a0,0
    1f2a:	00003097          	auipc	ra,0x3
    1f2e:	44c080e7          	jalr	1100(ra) # 5376 <wait>
    1f32:	57fd                	li	a5,-1
    1f34:	04f51563          	bne	a0,a5,1f7e <forktest+0xc4>
}
    1f38:	70a2                	ld	ra,40(sp)
    1f3a:	7402                	ld	s0,32(sp)
    1f3c:	64e2                	ld	s1,24(sp)
    1f3e:	6942                	ld	s2,16(sp)
    1f40:	69a2                	ld	s3,8(sp)
    1f42:	6145                	addi	sp,sp,48
    1f44:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1f46:	85ce                	mv	a1,s3
    1f48:	00004517          	auipc	a0,0x4
    1f4c:	72050513          	addi	a0,a0,1824 # 6668 <malloc+0xeb4>
    1f50:	00003097          	auipc	ra,0x3
    1f54:	7a6080e7          	jalr	1958(ra) # 56f6 <printf>
    exit(1);
    1f58:	4505                	li	a0,1
    1f5a:	00003097          	auipc	ra,0x3
    1f5e:	414080e7          	jalr	1044(ra) # 536e <exit>
      printf("%s: wait stopped early\n", s);
    1f62:	85ce                	mv	a1,s3
    1f64:	00004517          	auipc	a0,0x4
    1f68:	74450513          	addi	a0,a0,1860 # 66a8 <malloc+0xef4>
    1f6c:	00003097          	auipc	ra,0x3
    1f70:	78a080e7          	jalr	1930(ra) # 56f6 <printf>
      exit(1);
    1f74:	4505                	li	a0,1
    1f76:	00003097          	auipc	ra,0x3
    1f7a:	3f8080e7          	jalr	1016(ra) # 536e <exit>
    printf("%s: wait got too many\n", s);
    1f7e:	85ce                	mv	a1,s3
    1f80:	00004517          	auipc	a0,0x4
    1f84:	74050513          	addi	a0,a0,1856 # 66c0 <malloc+0xf0c>
    1f88:	00003097          	auipc	ra,0x3
    1f8c:	76e080e7          	jalr	1902(ra) # 56f6 <printf>
    exit(1);
    1f90:	4505                	li	a0,1
    1f92:	00003097          	auipc	ra,0x3
    1f96:	3dc080e7          	jalr	988(ra) # 536e <exit>

0000000000001f9a <kernmem>:
{
    1f9a:	715d                	addi	sp,sp,-80
    1f9c:	e486                	sd	ra,72(sp)
    1f9e:	e0a2                	sd	s0,64(sp)
    1fa0:	fc26                	sd	s1,56(sp)
    1fa2:	f84a                	sd	s2,48(sp)
    1fa4:	f44e                	sd	s3,40(sp)
    1fa6:	f052                	sd	s4,32(sp)
    1fa8:	ec56                	sd	s5,24(sp)
    1faa:	0880                	addi	s0,sp,80
    1fac:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fae:	4485                	li	s1,1
    1fb0:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1fb2:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fb4:	69b1                	lui	s3,0xc
    1fb6:	35098993          	addi	s3,s3,848 # c350 <buf+0xc18>
    1fba:	1003d937          	lui	s2,0x1003d
    1fbe:	090e                	slli	s2,s2,0x3
    1fc0:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002ed38>
    pid = fork();
    1fc4:	00003097          	auipc	ra,0x3
    1fc8:	3a2080e7          	jalr	930(ra) # 5366 <fork>
    if(pid < 0){
    1fcc:	02054963          	bltz	a0,1ffe <kernmem+0x64>
    if(pid == 0){
    1fd0:	c529                	beqz	a0,201a <kernmem+0x80>
    wait(&xstatus);
    1fd2:	fbc40513          	addi	a0,s0,-68
    1fd6:	00003097          	auipc	ra,0x3
    1fda:	3a0080e7          	jalr	928(ra) # 5376 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1fde:	fbc42783          	lw	a5,-68(s0)
    1fe2:	05579c63          	bne	a5,s5,203a <kernmem+0xa0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fe6:	94ce                	add	s1,s1,s3
    1fe8:	fd249ee3          	bne	s1,s2,1fc4 <kernmem+0x2a>
}
    1fec:	60a6                	ld	ra,72(sp)
    1fee:	6406                	ld	s0,64(sp)
    1ff0:	74e2                	ld	s1,56(sp)
    1ff2:	7942                	ld	s2,48(sp)
    1ff4:	79a2                	ld	s3,40(sp)
    1ff6:	7a02                	ld	s4,32(sp)
    1ff8:	6ae2                	ld	s5,24(sp)
    1ffa:	6161                	addi	sp,sp,80
    1ffc:	8082                	ret
      printf("%s: fork failed\n", s);
    1ffe:	85d2                	mv	a1,s4
    2000:	00004517          	auipc	a0,0x4
    2004:	40850513          	addi	a0,a0,1032 # 6408 <malloc+0xc54>
    2008:	00003097          	auipc	ra,0x3
    200c:	6ee080e7          	jalr	1774(ra) # 56f6 <printf>
      exit(1);
    2010:	4505                	li	a0,1
    2012:	00003097          	auipc	ra,0x3
    2016:	35c080e7          	jalr	860(ra) # 536e <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
    201a:	0004c603          	lbu	a2,0(s1)
    201e:	85a6                	mv	a1,s1
    2020:	00004517          	auipc	a0,0x4
    2024:	6b850513          	addi	a0,a0,1720 # 66d8 <malloc+0xf24>
    2028:	00003097          	auipc	ra,0x3
    202c:	6ce080e7          	jalr	1742(ra) # 56f6 <printf>
      exit(1);
    2030:	4505                	li	a0,1
    2032:	00003097          	auipc	ra,0x3
    2036:	33c080e7          	jalr	828(ra) # 536e <exit>
      exit(1);
    203a:	4505                	li	a0,1
    203c:	00003097          	auipc	ra,0x3
    2040:	332080e7          	jalr	818(ra) # 536e <exit>

0000000000002044 <bigargtest>:
{
    2044:	7179                	addi	sp,sp,-48
    2046:	f406                	sd	ra,40(sp)
    2048:	f022                	sd	s0,32(sp)
    204a:	ec26                	sd	s1,24(sp)
    204c:	1800                	addi	s0,sp,48
    204e:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2050:	00004517          	auipc	a0,0x4
    2054:	6a850513          	addi	a0,a0,1704 # 66f8 <malloc+0xf44>
    2058:	00003097          	auipc	ra,0x3
    205c:	366080e7          	jalr	870(ra) # 53be <unlink>
  pid = fork();
    2060:	00003097          	auipc	ra,0x3
    2064:	306080e7          	jalr	774(ra) # 5366 <fork>
  if(pid == 0){
    2068:	c121                	beqz	a0,20a8 <bigargtest+0x64>
  } else if(pid < 0){
    206a:	0a054063          	bltz	a0,210a <bigargtest+0xc6>
  wait(&xstatus);
    206e:	fdc40513          	addi	a0,s0,-36
    2072:	00003097          	auipc	ra,0x3
    2076:	304080e7          	jalr	772(ra) # 5376 <wait>
  if(xstatus != 0)
    207a:	fdc42503          	lw	a0,-36(s0)
    207e:	e545                	bnez	a0,2126 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2080:	4581                	li	a1,0
    2082:	00004517          	auipc	a0,0x4
    2086:	67650513          	addi	a0,a0,1654 # 66f8 <malloc+0xf44>
    208a:	00003097          	auipc	ra,0x3
    208e:	324080e7          	jalr	804(ra) # 53ae <open>
  if(fd < 0){
    2092:	08054e63          	bltz	a0,212e <bigargtest+0xea>
  close(fd);
    2096:	00003097          	auipc	ra,0x3
    209a:	300080e7          	jalr	768(ra) # 5396 <close>
}
    209e:	70a2                	ld	ra,40(sp)
    20a0:	7402                	ld	s0,32(sp)
    20a2:	64e2                	ld	s1,24(sp)
    20a4:	6145                	addi	sp,sp,48
    20a6:	8082                	ret
    20a8:	00006797          	auipc	a5,0x6
    20ac:	e7878793          	addi	a5,a5,-392 # 7f20 <args.1>
    20b0:	00006697          	auipc	a3,0x6
    20b4:	f6868693          	addi	a3,a3,-152 # 8018 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    20b8:	00004717          	auipc	a4,0x4
    20bc:	65070713          	addi	a4,a4,1616 # 6708 <malloc+0xf54>
    20c0:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    20c2:	07a1                	addi	a5,a5,8
    20c4:	fed79ee3          	bne	a5,a3,20c0 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    20c8:	00006597          	auipc	a1,0x6
    20cc:	e5858593          	addi	a1,a1,-424 # 7f20 <args.1>
    20d0:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    20d4:	00004517          	auipc	a0,0x4
    20d8:	afc50513          	addi	a0,a0,-1284 # 5bd0 <malloc+0x41c>
    20dc:	00003097          	auipc	ra,0x3
    20e0:	2ca080e7          	jalr	714(ra) # 53a6 <exec>
    fd = open("bigarg-ok", O_CREATE);
    20e4:	20000593          	li	a1,512
    20e8:	00004517          	auipc	a0,0x4
    20ec:	61050513          	addi	a0,a0,1552 # 66f8 <malloc+0xf44>
    20f0:	00003097          	auipc	ra,0x3
    20f4:	2be080e7          	jalr	702(ra) # 53ae <open>
    close(fd);
    20f8:	00003097          	auipc	ra,0x3
    20fc:	29e080e7          	jalr	670(ra) # 5396 <close>
    exit(0);
    2100:	4501                	li	a0,0
    2102:	00003097          	auipc	ra,0x3
    2106:	26c080e7          	jalr	620(ra) # 536e <exit>
    printf("%s: bigargtest: fork failed\n", s);
    210a:	85a6                	mv	a1,s1
    210c:	00004517          	auipc	a0,0x4
    2110:	6dc50513          	addi	a0,a0,1756 # 67e8 <malloc+0x1034>
    2114:	00003097          	auipc	ra,0x3
    2118:	5e2080e7          	jalr	1506(ra) # 56f6 <printf>
    exit(1);
    211c:	4505                	li	a0,1
    211e:	00003097          	auipc	ra,0x3
    2122:	250080e7          	jalr	592(ra) # 536e <exit>
    exit(xstatus);
    2126:	00003097          	auipc	ra,0x3
    212a:	248080e7          	jalr	584(ra) # 536e <exit>
    printf("%s: bigarg test failed!\n", s);
    212e:	85a6                	mv	a1,s1
    2130:	00004517          	auipc	a0,0x4
    2134:	6d850513          	addi	a0,a0,1752 # 6808 <malloc+0x1054>
    2138:	00003097          	auipc	ra,0x3
    213c:	5be080e7          	jalr	1470(ra) # 56f6 <printf>
    exit(1);
    2140:	4505                	li	a0,1
    2142:	00003097          	auipc	ra,0x3
    2146:	22c080e7          	jalr	556(ra) # 536e <exit>

000000000000214a <stacktest>:
{
    214a:	7179                	addi	sp,sp,-48
    214c:	f406                	sd	ra,40(sp)
    214e:	f022                	sd	s0,32(sp)
    2150:	ec26                	sd	s1,24(sp)
    2152:	1800                	addi	s0,sp,48
    2154:	84aa                	mv	s1,a0
  pid = fork();
    2156:	00003097          	auipc	ra,0x3
    215a:	210080e7          	jalr	528(ra) # 5366 <fork>
  if(pid == 0) {
    215e:	c115                	beqz	a0,2182 <stacktest+0x38>
  } else if(pid < 0){
    2160:	04054363          	bltz	a0,21a6 <stacktest+0x5c>
  wait(&xstatus);
    2164:	fdc40513          	addi	a0,s0,-36
    2168:	00003097          	auipc	ra,0x3
    216c:	20e080e7          	jalr	526(ra) # 5376 <wait>
  if(xstatus == -1)  // kernel killed child?
    2170:	fdc42503          	lw	a0,-36(s0)
    2174:	57fd                	li	a5,-1
    2176:	04f50663          	beq	a0,a5,21c2 <stacktest+0x78>
    exit(xstatus);
    217a:	00003097          	auipc	ra,0x3
    217e:	1f4080e7          	jalr	500(ra) # 536e <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2182:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
    2184:	77fd                	lui	a5,0xfffff
    2186:	97ba                	add	a5,a5,a4
    2188:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff08b8>
    218c:	00004517          	auipc	a0,0x4
    2190:	69c50513          	addi	a0,a0,1692 # 6828 <malloc+0x1074>
    2194:	00003097          	auipc	ra,0x3
    2198:	562080e7          	jalr	1378(ra) # 56f6 <printf>
    exit(1);
    219c:	4505                	li	a0,1
    219e:	00003097          	auipc	ra,0x3
    21a2:	1d0080e7          	jalr	464(ra) # 536e <exit>
    printf("%s: fork failed\n", s);
    21a6:	85a6                	mv	a1,s1
    21a8:	00004517          	auipc	a0,0x4
    21ac:	26050513          	addi	a0,a0,608 # 6408 <malloc+0xc54>
    21b0:	00003097          	auipc	ra,0x3
    21b4:	546080e7          	jalr	1350(ra) # 56f6 <printf>
    exit(1);
    21b8:	4505                	li	a0,1
    21ba:	00003097          	auipc	ra,0x3
    21be:	1b4080e7          	jalr	436(ra) # 536e <exit>
    exit(0);
    21c2:	4501                	li	a0,0
    21c4:	00003097          	auipc	ra,0x3
    21c8:	1aa080e7          	jalr	426(ra) # 536e <exit>

00000000000021cc <copyinstr3>:
{
    21cc:	7179                	addi	sp,sp,-48
    21ce:	f406                	sd	ra,40(sp)
    21d0:	f022                	sd	s0,32(sp)
    21d2:	ec26                	sd	s1,24(sp)
    21d4:	1800                	addi	s0,sp,48
  sbrk(8192);
    21d6:	6509                	lui	a0,0x2
    21d8:	00003097          	auipc	ra,0x3
    21dc:	21e080e7          	jalr	542(ra) # 53f6 <sbrk>
  uint64 top = (uint64) sbrk(0);
    21e0:	4501                	li	a0,0
    21e2:	00003097          	auipc	ra,0x3
    21e6:	214080e7          	jalr	532(ra) # 53f6 <sbrk>
  if((top % PGSIZE) != 0){
    21ea:	03451793          	slli	a5,a0,0x34
    21ee:	e3c9                	bnez	a5,2270 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    21f0:	4501                	li	a0,0
    21f2:	00003097          	auipc	ra,0x3
    21f6:	204080e7          	jalr	516(ra) # 53f6 <sbrk>
  if(top % PGSIZE){
    21fa:	03451793          	slli	a5,a0,0x34
    21fe:	e3d9                	bnez	a5,2284 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2200:	fff50493          	addi	s1,a0,-1 # 1fff <kernmem+0x65>
  *b = 'x';
    2204:	07800793          	li	a5,120
    2208:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    220c:	8526                	mv	a0,s1
    220e:	00003097          	auipc	ra,0x3
    2212:	1b0080e7          	jalr	432(ra) # 53be <unlink>
  if(ret != -1){
    2216:	57fd                	li	a5,-1
    2218:	08f51363          	bne	a0,a5,229e <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    221c:	20100593          	li	a1,513
    2220:	8526                	mv	a0,s1
    2222:	00003097          	auipc	ra,0x3
    2226:	18c080e7          	jalr	396(ra) # 53ae <open>
  if(fd != -1){
    222a:	57fd                	li	a5,-1
    222c:	08f51863          	bne	a0,a5,22bc <copyinstr3+0xf0>
  ret = link(b, b);
    2230:	85a6                	mv	a1,s1
    2232:	8526                	mv	a0,s1
    2234:	00003097          	auipc	ra,0x3
    2238:	19a080e7          	jalr	410(ra) # 53ce <link>
  if(ret != -1){
    223c:	57fd                	li	a5,-1
    223e:	08f51e63          	bne	a0,a5,22da <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2242:	00005797          	auipc	a5,0x5
    2246:	18678793          	addi	a5,a5,390 # 73c8 <malloc+0x1c14>
    224a:	fcf43823          	sd	a5,-48(s0)
    224e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2252:	fd040593          	addi	a1,s0,-48
    2256:	8526                	mv	a0,s1
    2258:	00003097          	auipc	ra,0x3
    225c:	14e080e7          	jalr	334(ra) # 53a6 <exec>
  if(ret != -1){
    2260:	57fd                	li	a5,-1
    2262:	08f51c63          	bne	a0,a5,22fa <copyinstr3+0x12e>
}
    2266:	70a2                	ld	ra,40(sp)
    2268:	7402                	ld	s0,32(sp)
    226a:	64e2                	ld	s1,24(sp)
    226c:	6145                	addi	sp,sp,48
    226e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2270:	0347d513          	srli	a0,a5,0x34
    2274:	6785                	lui	a5,0x1
    2276:	40a7853b          	subw	a0,a5,a0
    227a:	00003097          	auipc	ra,0x3
    227e:	17c080e7          	jalr	380(ra) # 53f6 <sbrk>
    2282:	b7bd                	j	21f0 <copyinstr3+0x24>
    printf("oops\n");
    2284:	00004517          	auipc	a0,0x4
    2288:	5cc50513          	addi	a0,a0,1484 # 6850 <malloc+0x109c>
    228c:	00003097          	auipc	ra,0x3
    2290:	46a080e7          	jalr	1130(ra) # 56f6 <printf>
    exit(1);
    2294:	4505                	li	a0,1
    2296:	00003097          	auipc	ra,0x3
    229a:	0d8080e7          	jalr	216(ra) # 536e <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    229e:	862a                	mv	a2,a0
    22a0:	85a6                	mv	a1,s1
    22a2:	00004517          	auipc	a0,0x4
    22a6:	08650513          	addi	a0,a0,134 # 6328 <malloc+0xb74>
    22aa:	00003097          	auipc	ra,0x3
    22ae:	44c080e7          	jalr	1100(ra) # 56f6 <printf>
    exit(1);
    22b2:	4505                	li	a0,1
    22b4:	00003097          	auipc	ra,0x3
    22b8:	0ba080e7          	jalr	186(ra) # 536e <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    22bc:	862a                	mv	a2,a0
    22be:	85a6                	mv	a1,s1
    22c0:	00004517          	auipc	a0,0x4
    22c4:	08850513          	addi	a0,a0,136 # 6348 <malloc+0xb94>
    22c8:	00003097          	auipc	ra,0x3
    22cc:	42e080e7          	jalr	1070(ra) # 56f6 <printf>
    exit(1);
    22d0:	4505                	li	a0,1
    22d2:	00003097          	auipc	ra,0x3
    22d6:	09c080e7          	jalr	156(ra) # 536e <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    22da:	86aa                	mv	a3,a0
    22dc:	8626                	mv	a2,s1
    22de:	85a6                	mv	a1,s1
    22e0:	00004517          	auipc	a0,0x4
    22e4:	08850513          	addi	a0,a0,136 # 6368 <malloc+0xbb4>
    22e8:	00003097          	auipc	ra,0x3
    22ec:	40e080e7          	jalr	1038(ra) # 56f6 <printf>
    exit(1);
    22f0:	4505                	li	a0,1
    22f2:	00003097          	auipc	ra,0x3
    22f6:	07c080e7          	jalr	124(ra) # 536e <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    22fa:	567d                	li	a2,-1
    22fc:	85a6                	mv	a1,s1
    22fe:	00004517          	auipc	a0,0x4
    2302:	09250513          	addi	a0,a0,146 # 6390 <malloc+0xbdc>
    2306:	00003097          	auipc	ra,0x3
    230a:	3f0080e7          	jalr	1008(ra) # 56f6 <printf>
    exit(1);
    230e:	4505                	li	a0,1
    2310:	00003097          	auipc	ra,0x3
    2314:	05e080e7          	jalr	94(ra) # 536e <exit>

0000000000002318 <sbrkbasic>:
{
    2318:	7139                	addi	sp,sp,-64
    231a:	fc06                	sd	ra,56(sp)
    231c:	f822                	sd	s0,48(sp)
    231e:	f426                	sd	s1,40(sp)
    2320:	f04a                	sd	s2,32(sp)
    2322:	ec4e                	sd	s3,24(sp)
    2324:	e852                	sd	s4,16(sp)
    2326:	0080                	addi	s0,sp,64
    2328:	8a2a                	mv	s4,a0
  pid = fork();
    232a:	00003097          	auipc	ra,0x3
    232e:	03c080e7          	jalr	60(ra) # 5366 <fork>
  if(pid < 0){
    2332:	02054c63          	bltz	a0,236a <sbrkbasic+0x52>
  if(pid == 0){
    2336:	ed21                	bnez	a0,238e <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    2338:	40000537          	lui	a0,0x40000
    233c:	00003097          	auipc	ra,0x3
    2340:	0ba080e7          	jalr	186(ra) # 53f6 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2344:	57fd                	li	a5,-1
    2346:	02f50f63          	beq	a0,a5,2384 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    234a:	400007b7          	lui	a5,0x40000
    234e:	97aa                	add	a5,a5,a0
      *b = 99;
    2350:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2354:	6705                	lui	a4,0x1
      *b = 99;
    2356:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff18b8>
    for(b = a; b < a+TOOMUCH; b += 4096){
    235a:	953a                	add	a0,a0,a4
    235c:	fef51de3          	bne	a0,a5,2356 <sbrkbasic+0x3e>
    exit(1);
    2360:	4505                	li	a0,1
    2362:	00003097          	auipc	ra,0x3
    2366:	00c080e7          	jalr	12(ra) # 536e <exit>
    printf("fork failed in sbrkbasic\n");
    236a:	00004517          	auipc	a0,0x4
    236e:	4ee50513          	addi	a0,a0,1262 # 6858 <malloc+0x10a4>
    2372:	00003097          	auipc	ra,0x3
    2376:	384080e7          	jalr	900(ra) # 56f6 <printf>
    exit(1);
    237a:	4505                	li	a0,1
    237c:	00003097          	auipc	ra,0x3
    2380:	ff2080e7          	jalr	-14(ra) # 536e <exit>
      exit(0);
    2384:	4501                	li	a0,0
    2386:	00003097          	auipc	ra,0x3
    238a:	fe8080e7          	jalr	-24(ra) # 536e <exit>
  wait(&xstatus);
    238e:	fcc40513          	addi	a0,s0,-52
    2392:	00003097          	auipc	ra,0x3
    2396:	fe4080e7          	jalr	-28(ra) # 5376 <wait>
  if(xstatus == 1){
    239a:	fcc42703          	lw	a4,-52(s0)
    239e:	4785                	li	a5,1
    23a0:	00f70d63          	beq	a4,a5,23ba <sbrkbasic+0xa2>
  a = sbrk(0);
    23a4:	4501                	li	a0,0
    23a6:	00003097          	auipc	ra,0x3
    23aa:	050080e7          	jalr	80(ra) # 53f6 <sbrk>
    23ae:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    23b0:	4901                	li	s2,0
    23b2:	6985                	lui	s3,0x1
    23b4:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1ce>
    23b8:	a005                	j	23d8 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    23ba:	85d2                	mv	a1,s4
    23bc:	00004517          	auipc	a0,0x4
    23c0:	4bc50513          	addi	a0,a0,1212 # 6878 <malloc+0x10c4>
    23c4:	00003097          	auipc	ra,0x3
    23c8:	332080e7          	jalr	818(ra) # 56f6 <printf>
    exit(1);
    23cc:	4505                	li	a0,1
    23ce:	00003097          	auipc	ra,0x3
    23d2:	fa0080e7          	jalr	-96(ra) # 536e <exit>
    a = b + 1;
    23d6:	84be                	mv	s1,a5
    b = sbrk(1);
    23d8:	4505                	li	a0,1
    23da:	00003097          	auipc	ra,0x3
    23de:	01c080e7          	jalr	28(ra) # 53f6 <sbrk>
    if(b != a){
    23e2:	04951c63          	bne	a0,s1,243a <sbrkbasic+0x122>
    *b = 1;
    23e6:	4785                	li	a5,1
    23e8:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    23ec:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    23f0:	2905                	addiw	s2,s2,1
    23f2:	ff3912e3          	bne	s2,s3,23d6 <sbrkbasic+0xbe>
  pid = fork();
    23f6:	00003097          	auipc	ra,0x3
    23fa:	f70080e7          	jalr	-144(ra) # 5366 <fork>
    23fe:	892a                	mv	s2,a0
  if(pid < 0){
    2400:	04054d63          	bltz	a0,245a <sbrkbasic+0x142>
  c = sbrk(1);
    2404:	4505                	li	a0,1
    2406:	00003097          	auipc	ra,0x3
    240a:	ff0080e7          	jalr	-16(ra) # 53f6 <sbrk>
  c = sbrk(1);
    240e:	4505                	li	a0,1
    2410:	00003097          	auipc	ra,0x3
    2414:	fe6080e7          	jalr	-26(ra) # 53f6 <sbrk>
  if(c != a + 1){
    2418:	0489                	addi	s1,s1,2
    241a:	04a48e63          	beq	s1,a0,2476 <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    241e:	85d2                	mv	a1,s4
    2420:	00004517          	auipc	a0,0x4
    2424:	4b850513          	addi	a0,a0,1208 # 68d8 <malloc+0x1124>
    2428:	00003097          	auipc	ra,0x3
    242c:	2ce080e7          	jalr	718(ra) # 56f6 <printf>
    exit(1);
    2430:	4505                	li	a0,1
    2432:	00003097          	auipc	ra,0x3
    2436:	f3c080e7          	jalr	-196(ra) # 536e <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    243a:	86aa                	mv	a3,a0
    243c:	8626                	mv	a2,s1
    243e:	85ca                	mv	a1,s2
    2440:	00004517          	auipc	a0,0x4
    2444:	45850513          	addi	a0,a0,1112 # 6898 <malloc+0x10e4>
    2448:	00003097          	auipc	ra,0x3
    244c:	2ae080e7          	jalr	686(ra) # 56f6 <printf>
      exit(1);
    2450:	4505                	li	a0,1
    2452:	00003097          	auipc	ra,0x3
    2456:	f1c080e7          	jalr	-228(ra) # 536e <exit>
    printf("%s: sbrk test fork failed\n", s);
    245a:	85d2                	mv	a1,s4
    245c:	00004517          	auipc	a0,0x4
    2460:	45c50513          	addi	a0,a0,1116 # 68b8 <malloc+0x1104>
    2464:	00003097          	auipc	ra,0x3
    2468:	292080e7          	jalr	658(ra) # 56f6 <printf>
    exit(1);
    246c:	4505                	li	a0,1
    246e:	00003097          	auipc	ra,0x3
    2472:	f00080e7          	jalr	-256(ra) # 536e <exit>
  if(pid == 0)
    2476:	00091763          	bnez	s2,2484 <sbrkbasic+0x16c>
    exit(0);
    247a:	4501                	li	a0,0
    247c:	00003097          	auipc	ra,0x3
    2480:	ef2080e7          	jalr	-270(ra) # 536e <exit>
  wait(&xstatus);
    2484:	fcc40513          	addi	a0,s0,-52
    2488:	00003097          	auipc	ra,0x3
    248c:	eee080e7          	jalr	-274(ra) # 5376 <wait>
  exit(xstatus);
    2490:	fcc42503          	lw	a0,-52(s0)
    2494:	00003097          	auipc	ra,0x3
    2498:	eda080e7          	jalr	-294(ra) # 536e <exit>

000000000000249c <sbrkmuch>:
{
    249c:	7179                	addi	sp,sp,-48
    249e:	f406                	sd	ra,40(sp)
    24a0:	f022                	sd	s0,32(sp)
    24a2:	ec26                	sd	s1,24(sp)
    24a4:	e84a                	sd	s2,16(sp)
    24a6:	e44e                	sd	s3,8(sp)
    24a8:	e052                	sd	s4,0(sp)
    24aa:	1800                	addi	s0,sp,48
    24ac:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    24ae:	4501                	li	a0,0
    24b0:	00003097          	auipc	ra,0x3
    24b4:	f46080e7          	jalr	-186(ra) # 53f6 <sbrk>
    24b8:	892a                	mv	s2,a0
  a = sbrk(0);
    24ba:	4501                	li	a0,0
    24bc:	00003097          	auipc	ra,0x3
    24c0:	f3a080e7          	jalr	-198(ra) # 53f6 <sbrk>
    24c4:	84aa                	mv	s1,a0
  p = sbrk(amt);
    24c6:	06400537          	lui	a0,0x6400
    24ca:	9d05                	subw	a0,a0,s1
    24cc:	00003097          	auipc	ra,0x3
    24d0:	f2a080e7          	jalr	-214(ra) # 53f6 <sbrk>
  if (p != a) {
    24d4:	0ca49863          	bne	s1,a0,25a4 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    24d8:	4501                	li	a0,0
    24da:	00003097          	auipc	ra,0x3
    24de:	f1c080e7          	jalr	-228(ra) # 53f6 <sbrk>
    24e2:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    24e4:	00a4f963          	bgeu	s1,a0,24f6 <sbrkmuch+0x5a>
    *pp = 1;
    24e8:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    24ea:	6705                	lui	a4,0x1
    *pp = 1;
    24ec:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    24f0:	94ba                	add	s1,s1,a4
    24f2:	fef4ede3          	bltu	s1,a5,24ec <sbrkmuch+0x50>
  *lastaddr = 99;
    24f6:	064007b7          	lui	a5,0x6400
    24fa:	06300713          	li	a4,99
    24fe:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f18b7>
  a = sbrk(0);
    2502:	4501                	li	a0,0
    2504:	00003097          	auipc	ra,0x3
    2508:	ef2080e7          	jalr	-270(ra) # 53f6 <sbrk>
    250c:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    250e:	757d                	lui	a0,0xfffff
    2510:	00003097          	auipc	ra,0x3
    2514:	ee6080e7          	jalr	-282(ra) # 53f6 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2518:	57fd                	li	a5,-1
    251a:	0af50363          	beq	a0,a5,25c0 <sbrkmuch+0x124>
  c = sbrk(0);
    251e:	4501                	li	a0,0
    2520:	00003097          	auipc	ra,0x3
    2524:	ed6080e7          	jalr	-298(ra) # 53f6 <sbrk>
  if(c != a - PGSIZE){
    2528:	77fd                	lui	a5,0xfffff
    252a:	97a6                	add	a5,a5,s1
    252c:	0af51863          	bne	a0,a5,25dc <sbrkmuch+0x140>
  a = sbrk(0);
    2530:	4501                	li	a0,0
    2532:	00003097          	auipc	ra,0x3
    2536:	ec4080e7          	jalr	-316(ra) # 53f6 <sbrk>
    253a:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    253c:	6505                	lui	a0,0x1
    253e:	00003097          	auipc	ra,0x3
    2542:	eb8080e7          	jalr	-328(ra) # 53f6 <sbrk>
    2546:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2548:	0aa49963          	bne	s1,a0,25fa <sbrkmuch+0x15e>
    254c:	4501                	li	a0,0
    254e:	00003097          	auipc	ra,0x3
    2552:	ea8080e7          	jalr	-344(ra) # 53f6 <sbrk>
    2556:	6785                	lui	a5,0x1
    2558:	97a6                	add	a5,a5,s1
    255a:	0af51063          	bne	a0,a5,25fa <sbrkmuch+0x15e>
  if(*lastaddr == 99){
    255e:	064007b7          	lui	a5,0x6400
    2562:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f18b7>
    2566:	06300793          	li	a5,99
    256a:	0af70763          	beq	a4,a5,2618 <sbrkmuch+0x17c>
  a = sbrk(0);
    256e:	4501                	li	a0,0
    2570:	00003097          	auipc	ra,0x3
    2574:	e86080e7          	jalr	-378(ra) # 53f6 <sbrk>
    2578:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    257a:	4501                	li	a0,0
    257c:	00003097          	auipc	ra,0x3
    2580:	e7a080e7          	jalr	-390(ra) # 53f6 <sbrk>
    2584:	40a9053b          	subw	a0,s2,a0
    2588:	00003097          	auipc	ra,0x3
    258c:	e6e080e7          	jalr	-402(ra) # 53f6 <sbrk>
  if(c != a){
    2590:	0aa49263          	bne	s1,a0,2634 <sbrkmuch+0x198>
}
    2594:	70a2                	ld	ra,40(sp)
    2596:	7402                	ld	s0,32(sp)
    2598:	64e2                	ld	s1,24(sp)
    259a:	6942                	ld	s2,16(sp)
    259c:	69a2                	ld	s3,8(sp)
    259e:	6a02                	ld	s4,0(sp)
    25a0:	6145                	addi	sp,sp,48
    25a2:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    25a4:	85ce                	mv	a1,s3
    25a6:	00004517          	auipc	a0,0x4
    25aa:	35250513          	addi	a0,a0,850 # 68f8 <malloc+0x1144>
    25ae:	00003097          	auipc	ra,0x3
    25b2:	148080e7          	jalr	328(ra) # 56f6 <printf>
    exit(1);
    25b6:	4505                	li	a0,1
    25b8:	00003097          	auipc	ra,0x3
    25bc:	db6080e7          	jalr	-586(ra) # 536e <exit>
    printf("%s: sbrk could not deallocate\n", s);
    25c0:	85ce                	mv	a1,s3
    25c2:	00004517          	auipc	a0,0x4
    25c6:	37e50513          	addi	a0,a0,894 # 6940 <malloc+0x118c>
    25ca:	00003097          	auipc	ra,0x3
    25ce:	12c080e7          	jalr	300(ra) # 56f6 <printf>
    exit(1);
    25d2:	4505                	li	a0,1
    25d4:	00003097          	auipc	ra,0x3
    25d8:	d9a080e7          	jalr	-614(ra) # 536e <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    25dc:	862a                	mv	a2,a0
    25de:	85a6                	mv	a1,s1
    25e0:	00004517          	auipc	a0,0x4
    25e4:	38050513          	addi	a0,a0,896 # 6960 <malloc+0x11ac>
    25e8:	00003097          	auipc	ra,0x3
    25ec:	10e080e7          	jalr	270(ra) # 56f6 <printf>
    exit(1);
    25f0:	4505                	li	a0,1
    25f2:	00003097          	auipc	ra,0x3
    25f6:	d7c080e7          	jalr	-644(ra) # 536e <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    25fa:	8652                	mv	a2,s4
    25fc:	85a6                	mv	a1,s1
    25fe:	00004517          	auipc	a0,0x4
    2602:	3a250513          	addi	a0,a0,930 # 69a0 <malloc+0x11ec>
    2606:	00003097          	auipc	ra,0x3
    260a:	0f0080e7          	jalr	240(ra) # 56f6 <printf>
    exit(1);
    260e:	4505                	li	a0,1
    2610:	00003097          	auipc	ra,0x3
    2614:	d5e080e7          	jalr	-674(ra) # 536e <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2618:	85ce                	mv	a1,s3
    261a:	00004517          	auipc	a0,0x4
    261e:	3b650513          	addi	a0,a0,950 # 69d0 <malloc+0x121c>
    2622:	00003097          	auipc	ra,0x3
    2626:	0d4080e7          	jalr	212(ra) # 56f6 <printf>
    exit(1);
    262a:	4505                	li	a0,1
    262c:	00003097          	auipc	ra,0x3
    2630:	d42080e7          	jalr	-702(ra) # 536e <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    2634:	862a                	mv	a2,a0
    2636:	85a6                	mv	a1,s1
    2638:	00004517          	auipc	a0,0x4
    263c:	3d050513          	addi	a0,a0,976 # 6a08 <malloc+0x1254>
    2640:	00003097          	auipc	ra,0x3
    2644:	0b6080e7          	jalr	182(ra) # 56f6 <printf>
    exit(1);
    2648:	4505                	li	a0,1
    264a:	00003097          	auipc	ra,0x3
    264e:	d24080e7          	jalr	-732(ra) # 536e <exit>

0000000000002652 <sbrkarg>:
{
    2652:	7179                	addi	sp,sp,-48
    2654:	f406                	sd	ra,40(sp)
    2656:	f022                	sd	s0,32(sp)
    2658:	ec26                	sd	s1,24(sp)
    265a:	e84a                	sd	s2,16(sp)
    265c:	e44e                	sd	s3,8(sp)
    265e:	1800                	addi	s0,sp,48
    2660:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2662:	6505                	lui	a0,0x1
    2664:	00003097          	auipc	ra,0x3
    2668:	d92080e7          	jalr	-622(ra) # 53f6 <sbrk>
    266c:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    266e:	20100593          	li	a1,513
    2672:	00004517          	auipc	a0,0x4
    2676:	3be50513          	addi	a0,a0,958 # 6a30 <malloc+0x127c>
    267a:	00003097          	auipc	ra,0x3
    267e:	d34080e7          	jalr	-716(ra) # 53ae <open>
    2682:	84aa                	mv	s1,a0
  unlink("sbrk");
    2684:	00004517          	auipc	a0,0x4
    2688:	3ac50513          	addi	a0,a0,940 # 6a30 <malloc+0x127c>
    268c:	00003097          	auipc	ra,0x3
    2690:	d32080e7          	jalr	-718(ra) # 53be <unlink>
  if(fd < 0)  {
    2694:	0404c163          	bltz	s1,26d6 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2698:	6605                	lui	a2,0x1
    269a:	85ca                	mv	a1,s2
    269c:	8526                	mv	a0,s1
    269e:	00003097          	auipc	ra,0x3
    26a2:	cf0080e7          	jalr	-784(ra) # 538e <write>
    26a6:	04054663          	bltz	a0,26f2 <sbrkarg+0xa0>
  close(fd);
    26aa:	8526                	mv	a0,s1
    26ac:	00003097          	auipc	ra,0x3
    26b0:	cea080e7          	jalr	-790(ra) # 5396 <close>
  a = sbrk(PGSIZE);
    26b4:	6505                	lui	a0,0x1
    26b6:	00003097          	auipc	ra,0x3
    26ba:	d40080e7          	jalr	-704(ra) # 53f6 <sbrk>
  if(pipe((int *) a) != 0){
    26be:	00003097          	auipc	ra,0x3
    26c2:	cc0080e7          	jalr	-832(ra) # 537e <pipe>
    26c6:	e521                	bnez	a0,270e <sbrkarg+0xbc>
}
    26c8:	70a2                	ld	ra,40(sp)
    26ca:	7402                	ld	s0,32(sp)
    26cc:	64e2                	ld	s1,24(sp)
    26ce:	6942                	ld	s2,16(sp)
    26d0:	69a2                	ld	s3,8(sp)
    26d2:	6145                	addi	sp,sp,48
    26d4:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    26d6:	85ce                	mv	a1,s3
    26d8:	00004517          	auipc	a0,0x4
    26dc:	36050513          	addi	a0,a0,864 # 6a38 <malloc+0x1284>
    26e0:	00003097          	auipc	ra,0x3
    26e4:	016080e7          	jalr	22(ra) # 56f6 <printf>
    exit(1);
    26e8:	4505                	li	a0,1
    26ea:	00003097          	auipc	ra,0x3
    26ee:	c84080e7          	jalr	-892(ra) # 536e <exit>
    printf("%s: write sbrk failed\n", s);
    26f2:	85ce                	mv	a1,s3
    26f4:	00004517          	auipc	a0,0x4
    26f8:	35c50513          	addi	a0,a0,860 # 6a50 <malloc+0x129c>
    26fc:	00003097          	auipc	ra,0x3
    2700:	ffa080e7          	jalr	-6(ra) # 56f6 <printf>
    exit(1);
    2704:	4505                	li	a0,1
    2706:	00003097          	auipc	ra,0x3
    270a:	c68080e7          	jalr	-920(ra) # 536e <exit>
    printf("%s: pipe() failed\n", s);
    270e:	85ce                	mv	a1,s3
    2710:	00004517          	auipc	a0,0x4
    2714:	e0050513          	addi	a0,a0,-512 # 6510 <malloc+0xd5c>
    2718:	00003097          	auipc	ra,0x3
    271c:	fde080e7          	jalr	-34(ra) # 56f6 <printf>
    exit(1);
    2720:	4505                	li	a0,1
    2722:	00003097          	auipc	ra,0x3
    2726:	c4c080e7          	jalr	-948(ra) # 536e <exit>

000000000000272a <argptest>:
{
    272a:	1101                	addi	sp,sp,-32
    272c:	ec06                	sd	ra,24(sp)
    272e:	e822                	sd	s0,16(sp)
    2730:	e426                	sd	s1,8(sp)
    2732:	e04a                	sd	s2,0(sp)
    2734:	1000                	addi	s0,sp,32
    2736:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2738:	4581                	li	a1,0
    273a:	00004517          	auipc	a0,0x4
    273e:	32e50513          	addi	a0,a0,814 # 6a68 <malloc+0x12b4>
    2742:	00003097          	auipc	ra,0x3
    2746:	c6c080e7          	jalr	-916(ra) # 53ae <open>
  if (fd < 0) {
    274a:	02054b63          	bltz	a0,2780 <argptest+0x56>
    274e:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2750:	4501                	li	a0,0
    2752:	00003097          	auipc	ra,0x3
    2756:	ca4080e7          	jalr	-860(ra) # 53f6 <sbrk>
    275a:	567d                	li	a2,-1
    275c:	fff50593          	addi	a1,a0,-1
    2760:	8526                	mv	a0,s1
    2762:	00003097          	auipc	ra,0x3
    2766:	c24080e7          	jalr	-988(ra) # 5386 <read>
  close(fd);
    276a:	8526                	mv	a0,s1
    276c:	00003097          	auipc	ra,0x3
    2770:	c2a080e7          	jalr	-982(ra) # 5396 <close>
}
    2774:	60e2                	ld	ra,24(sp)
    2776:	6442                	ld	s0,16(sp)
    2778:	64a2                	ld	s1,8(sp)
    277a:	6902                	ld	s2,0(sp)
    277c:	6105                	addi	sp,sp,32
    277e:	8082                	ret
    printf("%s: open failed\n", s);
    2780:	85ca                	mv	a1,s2
    2782:	00004517          	auipc	a0,0x4
    2786:	c9e50513          	addi	a0,a0,-866 # 6420 <malloc+0xc6c>
    278a:	00003097          	auipc	ra,0x3
    278e:	f6c080e7          	jalr	-148(ra) # 56f6 <printf>
    exit(1);
    2792:	4505                	li	a0,1
    2794:	00003097          	auipc	ra,0x3
    2798:	bda080e7          	jalr	-1062(ra) # 536e <exit>

000000000000279c <sbrkbugs>:
{
    279c:	1141                	addi	sp,sp,-16
    279e:	e406                	sd	ra,8(sp)
    27a0:	e022                	sd	s0,0(sp)
    27a2:	0800                	addi	s0,sp,16
  int pid = fork();
    27a4:	00003097          	auipc	ra,0x3
    27a8:	bc2080e7          	jalr	-1086(ra) # 5366 <fork>
  if(pid < 0){
    27ac:	02054263          	bltz	a0,27d0 <sbrkbugs+0x34>
  if(pid == 0){
    27b0:	ed0d                	bnez	a0,27ea <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    27b2:	00003097          	auipc	ra,0x3
    27b6:	c44080e7          	jalr	-956(ra) # 53f6 <sbrk>
    sbrk(-sz);
    27ba:	40a0053b          	negw	a0,a0
    27be:	00003097          	auipc	ra,0x3
    27c2:	c38080e7          	jalr	-968(ra) # 53f6 <sbrk>
    exit(0);
    27c6:	4501                	li	a0,0
    27c8:	00003097          	auipc	ra,0x3
    27cc:	ba6080e7          	jalr	-1114(ra) # 536e <exit>
    printf("fork failed\n");
    27d0:	00004517          	auipc	a0,0x4
    27d4:	02850513          	addi	a0,a0,40 # 67f8 <malloc+0x1044>
    27d8:	00003097          	auipc	ra,0x3
    27dc:	f1e080e7          	jalr	-226(ra) # 56f6 <printf>
    exit(1);
    27e0:	4505                	li	a0,1
    27e2:	00003097          	auipc	ra,0x3
    27e6:	b8c080e7          	jalr	-1140(ra) # 536e <exit>
  wait(0);
    27ea:	4501                	li	a0,0
    27ec:	00003097          	auipc	ra,0x3
    27f0:	b8a080e7          	jalr	-1142(ra) # 5376 <wait>
  pid = fork();
    27f4:	00003097          	auipc	ra,0x3
    27f8:	b72080e7          	jalr	-1166(ra) # 5366 <fork>
  if(pid < 0){
    27fc:	02054563          	bltz	a0,2826 <sbrkbugs+0x8a>
  if(pid == 0){
    2800:	e121                	bnez	a0,2840 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2802:	00003097          	auipc	ra,0x3
    2806:	bf4080e7          	jalr	-1036(ra) # 53f6 <sbrk>
    sbrk(-(sz - 3500));
    280a:	6785                	lui	a5,0x1
    280c:	dac7879b          	addiw	a5,a5,-596
    2810:	40a7853b          	subw	a0,a5,a0
    2814:	00003097          	auipc	ra,0x3
    2818:	be2080e7          	jalr	-1054(ra) # 53f6 <sbrk>
    exit(0);
    281c:	4501                	li	a0,0
    281e:	00003097          	auipc	ra,0x3
    2822:	b50080e7          	jalr	-1200(ra) # 536e <exit>
    printf("fork failed\n");
    2826:	00004517          	auipc	a0,0x4
    282a:	fd250513          	addi	a0,a0,-46 # 67f8 <malloc+0x1044>
    282e:	00003097          	auipc	ra,0x3
    2832:	ec8080e7          	jalr	-312(ra) # 56f6 <printf>
    exit(1);
    2836:	4505                	li	a0,1
    2838:	00003097          	auipc	ra,0x3
    283c:	b36080e7          	jalr	-1226(ra) # 536e <exit>
  wait(0);
    2840:	4501                	li	a0,0
    2842:	00003097          	auipc	ra,0x3
    2846:	b34080e7          	jalr	-1228(ra) # 5376 <wait>
  pid = fork();
    284a:	00003097          	auipc	ra,0x3
    284e:	b1c080e7          	jalr	-1252(ra) # 5366 <fork>
  if(pid < 0){
    2852:	02054a63          	bltz	a0,2886 <sbrkbugs+0xea>
  if(pid == 0){
    2856:	e529                	bnez	a0,28a0 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2858:	00003097          	auipc	ra,0x3
    285c:	b9e080e7          	jalr	-1122(ra) # 53f6 <sbrk>
    2860:	67ad                	lui	a5,0xb
    2862:	8007879b          	addiw	a5,a5,-2048
    2866:	40a7853b          	subw	a0,a5,a0
    286a:	00003097          	auipc	ra,0x3
    286e:	b8c080e7          	jalr	-1140(ra) # 53f6 <sbrk>
    sbrk(-10);
    2872:	5559                	li	a0,-10
    2874:	00003097          	auipc	ra,0x3
    2878:	b82080e7          	jalr	-1150(ra) # 53f6 <sbrk>
    exit(0);
    287c:	4501                	li	a0,0
    287e:	00003097          	auipc	ra,0x3
    2882:	af0080e7          	jalr	-1296(ra) # 536e <exit>
    printf("fork failed\n");
    2886:	00004517          	auipc	a0,0x4
    288a:	f7250513          	addi	a0,a0,-142 # 67f8 <malloc+0x1044>
    288e:	00003097          	auipc	ra,0x3
    2892:	e68080e7          	jalr	-408(ra) # 56f6 <printf>
    exit(1);
    2896:	4505                	li	a0,1
    2898:	00003097          	auipc	ra,0x3
    289c:	ad6080e7          	jalr	-1322(ra) # 536e <exit>
  wait(0);
    28a0:	4501                	li	a0,0
    28a2:	00003097          	auipc	ra,0x3
    28a6:	ad4080e7          	jalr	-1324(ra) # 5376 <wait>
  exit(0);
    28aa:	4501                	li	a0,0
    28ac:	00003097          	auipc	ra,0x3
    28b0:	ac2080e7          	jalr	-1342(ra) # 536e <exit>

00000000000028b4 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    28b4:	715d                	addi	sp,sp,-80
    28b6:	e486                	sd	ra,72(sp)
    28b8:	e0a2                	sd	s0,64(sp)
    28ba:	fc26                	sd	s1,56(sp)
    28bc:	f84a                	sd	s2,48(sp)
    28be:	f44e                	sd	s3,40(sp)
    28c0:	f052                	sd	s4,32(sp)
    28c2:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    28c4:	4901                	li	s2,0
    28c6:	49bd                	li	s3,15
    int pid = fork();
    28c8:	00003097          	auipc	ra,0x3
    28cc:	a9e080e7          	jalr	-1378(ra) # 5366 <fork>
    28d0:	84aa                	mv	s1,a0
    if(pid < 0){
    28d2:	02054063          	bltz	a0,28f2 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    28d6:	c91d                	beqz	a0,290c <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    28d8:	4501                	li	a0,0
    28da:	00003097          	auipc	ra,0x3
    28de:	a9c080e7          	jalr	-1380(ra) # 5376 <wait>
  for(int avail = 0; avail < 15; avail++){
    28e2:	2905                	addiw	s2,s2,1
    28e4:	ff3912e3          	bne	s2,s3,28c8 <execout+0x14>
    }
  }

  exit(0);
    28e8:	4501                	li	a0,0
    28ea:	00003097          	auipc	ra,0x3
    28ee:	a84080e7          	jalr	-1404(ra) # 536e <exit>
      printf("fork failed\n");
    28f2:	00004517          	auipc	a0,0x4
    28f6:	f0650513          	addi	a0,a0,-250 # 67f8 <malloc+0x1044>
    28fa:	00003097          	auipc	ra,0x3
    28fe:	dfc080e7          	jalr	-516(ra) # 56f6 <printf>
      exit(1);
    2902:	4505                	li	a0,1
    2904:	00003097          	auipc	ra,0x3
    2908:	a6a080e7          	jalr	-1430(ra) # 536e <exit>
        if(a == 0xffffffffffffffffLL)
    290c:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    290e:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2910:	6505                	lui	a0,0x1
    2912:	00003097          	auipc	ra,0x3
    2916:	ae4080e7          	jalr	-1308(ra) # 53f6 <sbrk>
        if(a == 0xffffffffffffffffLL)
    291a:	01350763          	beq	a0,s3,2928 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    291e:	6785                	lui	a5,0x1
    2920:	953e                	add	a0,a0,a5
    2922:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x95>
      while(1){
    2926:	b7ed                	j	2910 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2928:	01205a63          	blez	s2,293c <execout+0x88>
        sbrk(-4096);
    292c:	757d                	lui	a0,0xfffff
    292e:	00003097          	auipc	ra,0x3
    2932:	ac8080e7          	jalr	-1336(ra) # 53f6 <sbrk>
      for(int i = 0; i < avail; i++)
    2936:	2485                	addiw	s1,s1,1
    2938:	ff249ae3          	bne	s1,s2,292c <execout+0x78>
      close(1);
    293c:	4505                	li	a0,1
    293e:	00003097          	auipc	ra,0x3
    2942:	a58080e7          	jalr	-1448(ra) # 5396 <close>
      char *args[] = { "echo", "x", 0 };
    2946:	00003517          	auipc	a0,0x3
    294a:	28a50513          	addi	a0,a0,650 # 5bd0 <malloc+0x41c>
    294e:	faa43c23          	sd	a0,-72(s0)
    2952:	00003797          	auipc	a5,0x3
    2956:	2ee78793          	addi	a5,a5,750 # 5c40 <malloc+0x48c>
    295a:	fcf43023          	sd	a5,-64(s0)
    295e:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2962:	fb840593          	addi	a1,s0,-72
    2966:	00003097          	auipc	ra,0x3
    296a:	a40080e7          	jalr	-1472(ra) # 53a6 <exec>
      exit(0);
    296e:	4501                	li	a0,0
    2970:	00003097          	auipc	ra,0x3
    2974:	9fe080e7          	jalr	-1538(ra) # 536e <exit>

0000000000002978 <fourteen>:
{
    2978:	1101                	addi	sp,sp,-32
    297a:	ec06                	sd	ra,24(sp)
    297c:	e822                	sd	s0,16(sp)
    297e:	e426                	sd	s1,8(sp)
    2980:	1000                	addi	s0,sp,32
    2982:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2984:	00004517          	auipc	a0,0x4
    2988:	2bc50513          	addi	a0,a0,700 # 6c40 <malloc+0x148c>
    298c:	00003097          	auipc	ra,0x3
    2990:	a4a080e7          	jalr	-1462(ra) # 53d6 <mkdir>
    2994:	e165                	bnez	a0,2a74 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2996:	00004517          	auipc	a0,0x4
    299a:	10250513          	addi	a0,a0,258 # 6a98 <malloc+0x12e4>
    299e:	00003097          	auipc	ra,0x3
    29a2:	a38080e7          	jalr	-1480(ra) # 53d6 <mkdir>
    29a6:	e56d                	bnez	a0,2a90 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    29a8:	20000593          	li	a1,512
    29ac:	00004517          	auipc	a0,0x4
    29b0:	14450513          	addi	a0,a0,324 # 6af0 <malloc+0x133c>
    29b4:	00003097          	auipc	ra,0x3
    29b8:	9fa080e7          	jalr	-1542(ra) # 53ae <open>
  if(fd < 0){
    29bc:	0e054863          	bltz	a0,2aac <fourteen+0x134>
  close(fd);
    29c0:	00003097          	auipc	ra,0x3
    29c4:	9d6080e7          	jalr	-1578(ra) # 5396 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    29c8:	4581                	li	a1,0
    29ca:	00004517          	auipc	a0,0x4
    29ce:	19e50513          	addi	a0,a0,414 # 6b68 <malloc+0x13b4>
    29d2:	00003097          	auipc	ra,0x3
    29d6:	9dc080e7          	jalr	-1572(ra) # 53ae <open>
  if(fd < 0){
    29da:	0e054763          	bltz	a0,2ac8 <fourteen+0x150>
  close(fd);
    29de:	00003097          	auipc	ra,0x3
    29e2:	9b8080e7          	jalr	-1608(ra) # 5396 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    29e6:	00004517          	auipc	a0,0x4
    29ea:	1f250513          	addi	a0,a0,498 # 6bd8 <malloc+0x1424>
    29ee:	00003097          	auipc	ra,0x3
    29f2:	9e8080e7          	jalr	-1560(ra) # 53d6 <mkdir>
    29f6:	c57d                	beqz	a0,2ae4 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    29f8:	00004517          	auipc	a0,0x4
    29fc:	23850513          	addi	a0,a0,568 # 6c30 <malloc+0x147c>
    2a00:	00003097          	auipc	ra,0x3
    2a04:	9d6080e7          	jalr	-1578(ra) # 53d6 <mkdir>
    2a08:	cd65                	beqz	a0,2b00 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2a0a:	00004517          	auipc	a0,0x4
    2a0e:	22650513          	addi	a0,a0,550 # 6c30 <malloc+0x147c>
    2a12:	00003097          	auipc	ra,0x3
    2a16:	9ac080e7          	jalr	-1620(ra) # 53be <unlink>
  unlink("12345678901234/12345678901234");
    2a1a:	00004517          	auipc	a0,0x4
    2a1e:	1be50513          	addi	a0,a0,446 # 6bd8 <malloc+0x1424>
    2a22:	00003097          	auipc	ra,0x3
    2a26:	99c080e7          	jalr	-1636(ra) # 53be <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2a2a:	00004517          	auipc	a0,0x4
    2a2e:	13e50513          	addi	a0,a0,318 # 6b68 <malloc+0x13b4>
    2a32:	00003097          	auipc	ra,0x3
    2a36:	98c080e7          	jalr	-1652(ra) # 53be <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2a3a:	00004517          	auipc	a0,0x4
    2a3e:	0b650513          	addi	a0,a0,182 # 6af0 <malloc+0x133c>
    2a42:	00003097          	auipc	ra,0x3
    2a46:	97c080e7          	jalr	-1668(ra) # 53be <unlink>
  unlink("12345678901234/123456789012345");
    2a4a:	00004517          	auipc	a0,0x4
    2a4e:	04e50513          	addi	a0,a0,78 # 6a98 <malloc+0x12e4>
    2a52:	00003097          	auipc	ra,0x3
    2a56:	96c080e7          	jalr	-1684(ra) # 53be <unlink>
  unlink("12345678901234");
    2a5a:	00004517          	auipc	a0,0x4
    2a5e:	1e650513          	addi	a0,a0,486 # 6c40 <malloc+0x148c>
    2a62:	00003097          	auipc	ra,0x3
    2a66:	95c080e7          	jalr	-1700(ra) # 53be <unlink>
}
    2a6a:	60e2                	ld	ra,24(sp)
    2a6c:	6442                	ld	s0,16(sp)
    2a6e:	64a2                	ld	s1,8(sp)
    2a70:	6105                	addi	sp,sp,32
    2a72:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2a74:	85a6                	mv	a1,s1
    2a76:	00004517          	auipc	a0,0x4
    2a7a:	ffa50513          	addi	a0,a0,-6 # 6a70 <malloc+0x12bc>
    2a7e:	00003097          	auipc	ra,0x3
    2a82:	c78080e7          	jalr	-904(ra) # 56f6 <printf>
    exit(1);
    2a86:	4505                	li	a0,1
    2a88:	00003097          	auipc	ra,0x3
    2a8c:	8e6080e7          	jalr	-1818(ra) # 536e <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2a90:	85a6                	mv	a1,s1
    2a92:	00004517          	auipc	a0,0x4
    2a96:	02650513          	addi	a0,a0,38 # 6ab8 <malloc+0x1304>
    2a9a:	00003097          	auipc	ra,0x3
    2a9e:	c5c080e7          	jalr	-932(ra) # 56f6 <printf>
    exit(1);
    2aa2:	4505                	li	a0,1
    2aa4:	00003097          	auipc	ra,0x3
    2aa8:	8ca080e7          	jalr	-1846(ra) # 536e <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2aac:	85a6                	mv	a1,s1
    2aae:	00004517          	auipc	a0,0x4
    2ab2:	07250513          	addi	a0,a0,114 # 6b20 <malloc+0x136c>
    2ab6:	00003097          	auipc	ra,0x3
    2aba:	c40080e7          	jalr	-960(ra) # 56f6 <printf>
    exit(1);
    2abe:	4505                	li	a0,1
    2ac0:	00003097          	auipc	ra,0x3
    2ac4:	8ae080e7          	jalr	-1874(ra) # 536e <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2ac8:	85a6                	mv	a1,s1
    2aca:	00004517          	auipc	a0,0x4
    2ace:	0ce50513          	addi	a0,a0,206 # 6b98 <malloc+0x13e4>
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	c24080e7          	jalr	-988(ra) # 56f6 <printf>
    exit(1);
    2ada:	4505                	li	a0,1
    2adc:	00003097          	auipc	ra,0x3
    2ae0:	892080e7          	jalr	-1902(ra) # 536e <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2ae4:	85a6                	mv	a1,s1
    2ae6:	00004517          	auipc	a0,0x4
    2aea:	11250513          	addi	a0,a0,274 # 6bf8 <malloc+0x1444>
    2aee:	00003097          	auipc	ra,0x3
    2af2:	c08080e7          	jalr	-1016(ra) # 56f6 <printf>
    exit(1);
    2af6:	4505                	li	a0,1
    2af8:	00003097          	auipc	ra,0x3
    2afc:	876080e7          	jalr	-1930(ra) # 536e <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2b00:	85a6                	mv	a1,s1
    2b02:	00004517          	auipc	a0,0x4
    2b06:	14e50513          	addi	a0,a0,334 # 6c50 <malloc+0x149c>
    2b0a:	00003097          	auipc	ra,0x3
    2b0e:	bec080e7          	jalr	-1044(ra) # 56f6 <printf>
    exit(1);
    2b12:	4505                	li	a0,1
    2b14:	00003097          	auipc	ra,0x3
    2b18:	85a080e7          	jalr	-1958(ra) # 536e <exit>

0000000000002b1c <iputtest>:
{
    2b1c:	1101                	addi	sp,sp,-32
    2b1e:	ec06                	sd	ra,24(sp)
    2b20:	e822                	sd	s0,16(sp)
    2b22:	e426                	sd	s1,8(sp)
    2b24:	1000                	addi	s0,sp,32
    2b26:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2b28:	00004517          	auipc	a0,0x4
    2b2c:	16050513          	addi	a0,a0,352 # 6c88 <malloc+0x14d4>
    2b30:	00003097          	auipc	ra,0x3
    2b34:	8a6080e7          	jalr	-1882(ra) # 53d6 <mkdir>
    2b38:	04054563          	bltz	a0,2b82 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2b3c:	00004517          	auipc	a0,0x4
    2b40:	14c50513          	addi	a0,a0,332 # 6c88 <malloc+0x14d4>
    2b44:	00003097          	auipc	ra,0x3
    2b48:	89a080e7          	jalr	-1894(ra) # 53de <chdir>
    2b4c:	04054963          	bltz	a0,2b9e <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2b50:	00004517          	auipc	a0,0x4
    2b54:	17850513          	addi	a0,a0,376 # 6cc8 <malloc+0x1514>
    2b58:	00003097          	auipc	ra,0x3
    2b5c:	866080e7          	jalr	-1946(ra) # 53be <unlink>
    2b60:	04054d63          	bltz	a0,2bba <iputtest+0x9e>
  if(chdir("/") < 0){
    2b64:	00004517          	auipc	a0,0x4
    2b68:	19450513          	addi	a0,a0,404 # 6cf8 <malloc+0x1544>
    2b6c:	00003097          	auipc	ra,0x3
    2b70:	872080e7          	jalr	-1934(ra) # 53de <chdir>
    2b74:	06054163          	bltz	a0,2bd6 <iputtest+0xba>
}
    2b78:	60e2                	ld	ra,24(sp)
    2b7a:	6442                	ld	s0,16(sp)
    2b7c:	64a2                	ld	s1,8(sp)
    2b7e:	6105                	addi	sp,sp,32
    2b80:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b82:	85a6                	mv	a1,s1
    2b84:	00004517          	auipc	a0,0x4
    2b88:	10c50513          	addi	a0,a0,268 # 6c90 <malloc+0x14dc>
    2b8c:	00003097          	auipc	ra,0x3
    2b90:	b6a080e7          	jalr	-1174(ra) # 56f6 <printf>
    exit(1);
    2b94:	4505                	li	a0,1
    2b96:	00002097          	auipc	ra,0x2
    2b9a:	7d8080e7          	jalr	2008(ra) # 536e <exit>
    printf("%s: chdir iputdir failed\n", s);
    2b9e:	85a6                	mv	a1,s1
    2ba0:	00004517          	auipc	a0,0x4
    2ba4:	10850513          	addi	a0,a0,264 # 6ca8 <malloc+0x14f4>
    2ba8:	00003097          	auipc	ra,0x3
    2bac:	b4e080e7          	jalr	-1202(ra) # 56f6 <printf>
    exit(1);
    2bb0:	4505                	li	a0,1
    2bb2:	00002097          	auipc	ra,0x2
    2bb6:	7bc080e7          	jalr	1980(ra) # 536e <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2bba:	85a6                	mv	a1,s1
    2bbc:	00004517          	auipc	a0,0x4
    2bc0:	11c50513          	addi	a0,a0,284 # 6cd8 <malloc+0x1524>
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	b32080e7          	jalr	-1230(ra) # 56f6 <printf>
    exit(1);
    2bcc:	4505                	li	a0,1
    2bce:	00002097          	auipc	ra,0x2
    2bd2:	7a0080e7          	jalr	1952(ra) # 536e <exit>
    printf("%s: chdir / failed\n", s);
    2bd6:	85a6                	mv	a1,s1
    2bd8:	00004517          	auipc	a0,0x4
    2bdc:	12850513          	addi	a0,a0,296 # 6d00 <malloc+0x154c>
    2be0:	00003097          	auipc	ra,0x3
    2be4:	b16080e7          	jalr	-1258(ra) # 56f6 <printf>
    exit(1);
    2be8:	4505                	li	a0,1
    2bea:	00002097          	auipc	ra,0x2
    2bee:	784080e7          	jalr	1924(ra) # 536e <exit>

0000000000002bf2 <exitiputtest>:
{
    2bf2:	7179                	addi	sp,sp,-48
    2bf4:	f406                	sd	ra,40(sp)
    2bf6:	f022                	sd	s0,32(sp)
    2bf8:	ec26                	sd	s1,24(sp)
    2bfa:	1800                	addi	s0,sp,48
    2bfc:	84aa                	mv	s1,a0
  pid = fork();
    2bfe:	00002097          	auipc	ra,0x2
    2c02:	768080e7          	jalr	1896(ra) # 5366 <fork>
  if(pid < 0){
    2c06:	04054663          	bltz	a0,2c52 <exitiputtest+0x60>
  if(pid == 0){
    2c0a:	ed45                	bnez	a0,2cc2 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2c0c:	00004517          	auipc	a0,0x4
    2c10:	07c50513          	addi	a0,a0,124 # 6c88 <malloc+0x14d4>
    2c14:	00002097          	auipc	ra,0x2
    2c18:	7c2080e7          	jalr	1986(ra) # 53d6 <mkdir>
    2c1c:	04054963          	bltz	a0,2c6e <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2c20:	00004517          	auipc	a0,0x4
    2c24:	06850513          	addi	a0,a0,104 # 6c88 <malloc+0x14d4>
    2c28:	00002097          	auipc	ra,0x2
    2c2c:	7b6080e7          	jalr	1974(ra) # 53de <chdir>
    2c30:	04054d63          	bltz	a0,2c8a <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2c34:	00004517          	auipc	a0,0x4
    2c38:	09450513          	addi	a0,a0,148 # 6cc8 <malloc+0x1514>
    2c3c:	00002097          	auipc	ra,0x2
    2c40:	782080e7          	jalr	1922(ra) # 53be <unlink>
    2c44:	06054163          	bltz	a0,2ca6 <exitiputtest+0xb4>
    exit(0);
    2c48:	4501                	li	a0,0
    2c4a:	00002097          	auipc	ra,0x2
    2c4e:	724080e7          	jalr	1828(ra) # 536e <exit>
    printf("%s: fork failed\n", s);
    2c52:	85a6                	mv	a1,s1
    2c54:	00003517          	auipc	a0,0x3
    2c58:	7b450513          	addi	a0,a0,1972 # 6408 <malloc+0xc54>
    2c5c:	00003097          	auipc	ra,0x3
    2c60:	a9a080e7          	jalr	-1382(ra) # 56f6 <printf>
    exit(1);
    2c64:	4505                	li	a0,1
    2c66:	00002097          	auipc	ra,0x2
    2c6a:	708080e7          	jalr	1800(ra) # 536e <exit>
      printf("%s: mkdir failed\n", s);
    2c6e:	85a6                	mv	a1,s1
    2c70:	00004517          	auipc	a0,0x4
    2c74:	02050513          	addi	a0,a0,32 # 6c90 <malloc+0x14dc>
    2c78:	00003097          	auipc	ra,0x3
    2c7c:	a7e080e7          	jalr	-1410(ra) # 56f6 <printf>
      exit(1);
    2c80:	4505                	li	a0,1
    2c82:	00002097          	auipc	ra,0x2
    2c86:	6ec080e7          	jalr	1772(ra) # 536e <exit>
      printf("%s: child chdir failed\n", s);
    2c8a:	85a6                	mv	a1,s1
    2c8c:	00004517          	auipc	a0,0x4
    2c90:	08c50513          	addi	a0,a0,140 # 6d18 <malloc+0x1564>
    2c94:	00003097          	auipc	ra,0x3
    2c98:	a62080e7          	jalr	-1438(ra) # 56f6 <printf>
      exit(1);
    2c9c:	4505                	li	a0,1
    2c9e:	00002097          	auipc	ra,0x2
    2ca2:	6d0080e7          	jalr	1744(ra) # 536e <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2ca6:	85a6                	mv	a1,s1
    2ca8:	00004517          	auipc	a0,0x4
    2cac:	03050513          	addi	a0,a0,48 # 6cd8 <malloc+0x1524>
    2cb0:	00003097          	auipc	ra,0x3
    2cb4:	a46080e7          	jalr	-1466(ra) # 56f6 <printf>
      exit(1);
    2cb8:	4505                	li	a0,1
    2cba:	00002097          	auipc	ra,0x2
    2cbe:	6b4080e7          	jalr	1716(ra) # 536e <exit>
  wait(&xstatus);
    2cc2:	fdc40513          	addi	a0,s0,-36
    2cc6:	00002097          	auipc	ra,0x2
    2cca:	6b0080e7          	jalr	1712(ra) # 5376 <wait>
  exit(xstatus);
    2cce:	fdc42503          	lw	a0,-36(s0)
    2cd2:	00002097          	auipc	ra,0x2
    2cd6:	69c080e7          	jalr	1692(ra) # 536e <exit>

0000000000002cda <subdir>:
{
    2cda:	1101                	addi	sp,sp,-32
    2cdc:	ec06                	sd	ra,24(sp)
    2cde:	e822                	sd	s0,16(sp)
    2ce0:	e426                	sd	s1,8(sp)
    2ce2:	e04a                	sd	s2,0(sp)
    2ce4:	1000                	addi	s0,sp,32
    2ce6:	892a                	mv	s2,a0
  unlink("ff");
    2ce8:	00004517          	auipc	a0,0x4
    2cec:	17850513          	addi	a0,a0,376 # 6e60 <malloc+0x16ac>
    2cf0:	00002097          	auipc	ra,0x2
    2cf4:	6ce080e7          	jalr	1742(ra) # 53be <unlink>
  if(mkdir("dd") != 0){
    2cf8:	00004517          	auipc	a0,0x4
    2cfc:	03850513          	addi	a0,a0,56 # 6d30 <malloc+0x157c>
    2d00:	00002097          	auipc	ra,0x2
    2d04:	6d6080e7          	jalr	1750(ra) # 53d6 <mkdir>
    2d08:	38051663          	bnez	a0,3094 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d0c:	20200593          	li	a1,514
    2d10:	00004517          	auipc	a0,0x4
    2d14:	04050513          	addi	a0,a0,64 # 6d50 <malloc+0x159c>
    2d18:	00002097          	auipc	ra,0x2
    2d1c:	696080e7          	jalr	1686(ra) # 53ae <open>
    2d20:	84aa                	mv	s1,a0
  if(fd < 0){
    2d22:	38054763          	bltz	a0,30b0 <subdir+0x3d6>
  write(fd, "ff", 2);
    2d26:	4609                	li	a2,2
    2d28:	00004597          	auipc	a1,0x4
    2d2c:	13858593          	addi	a1,a1,312 # 6e60 <malloc+0x16ac>
    2d30:	00002097          	auipc	ra,0x2
    2d34:	65e080e7          	jalr	1630(ra) # 538e <write>
  close(fd);
    2d38:	8526                	mv	a0,s1
    2d3a:	00002097          	auipc	ra,0x2
    2d3e:	65c080e7          	jalr	1628(ra) # 5396 <close>
  if(unlink("dd") >= 0){
    2d42:	00004517          	auipc	a0,0x4
    2d46:	fee50513          	addi	a0,a0,-18 # 6d30 <malloc+0x157c>
    2d4a:	00002097          	auipc	ra,0x2
    2d4e:	674080e7          	jalr	1652(ra) # 53be <unlink>
    2d52:	36055d63          	bgez	a0,30cc <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2d56:	00004517          	auipc	a0,0x4
    2d5a:	05250513          	addi	a0,a0,82 # 6da8 <malloc+0x15f4>
    2d5e:	00002097          	auipc	ra,0x2
    2d62:	678080e7          	jalr	1656(ra) # 53d6 <mkdir>
    2d66:	38051163          	bnez	a0,30e8 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2d6a:	20200593          	li	a1,514
    2d6e:	00004517          	auipc	a0,0x4
    2d72:	06250513          	addi	a0,a0,98 # 6dd0 <malloc+0x161c>
    2d76:	00002097          	auipc	ra,0x2
    2d7a:	638080e7          	jalr	1592(ra) # 53ae <open>
    2d7e:	84aa                	mv	s1,a0
  if(fd < 0){
    2d80:	38054263          	bltz	a0,3104 <subdir+0x42a>
  write(fd, "FF", 2);
    2d84:	4609                	li	a2,2
    2d86:	00004597          	auipc	a1,0x4
    2d8a:	07a58593          	addi	a1,a1,122 # 6e00 <malloc+0x164c>
    2d8e:	00002097          	auipc	ra,0x2
    2d92:	600080e7          	jalr	1536(ra) # 538e <write>
  close(fd);
    2d96:	8526                	mv	a0,s1
    2d98:	00002097          	auipc	ra,0x2
    2d9c:	5fe080e7          	jalr	1534(ra) # 5396 <close>
  fd = open("dd/dd/../ff", 0);
    2da0:	4581                	li	a1,0
    2da2:	00004517          	auipc	a0,0x4
    2da6:	06650513          	addi	a0,a0,102 # 6e08 <malloc+0x1654>
    2daa:	00002097          	auipc	ra,0x2
    2dae:	604080e7          	jalr	1540(ra) # 53ae <open>
    2db2:	84aa                	mv	s1,a0
  if(fd < 0){
    2db4:	36054663          	bltz	a0,3120 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2db8:	660d                	lui	a2,0x3
    2dba:	00009597          	auipc	a1,0x9
    2dbe:	97e58593          	addi	a1,a1,-1666 # b738 <buf>
    2dc2:	00002097          	auipc	ra,0x2
    2dc6:	5c4080e7          	jalr	1476(ra) # 5386 <read>
  if(cc != 2 || buf[0] != 'f'){
    2dca:	4789                	li	a5,2
    2dcc:	36f51863          	bne	a0,a5,313c <subdir+0x462>
    2dd0:	00009717          	auipc	a4,0x9
    2dd4:	96874703          	lbu	a4,-1688(a4) # b738 <buf>
    2dd8:	06600793          	li	a5,102
    2ddc:	36f71063          	bne	a4,a5,313c <subdir+0x462>
  close(fd);
    2de0:	8526                	mv	a0,s1
    2de2:	00002097          	auipc	ra,0x2
    2de6:	5b4080e7          	jalr	1460(ra) # 5396 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2dea:	00004597          	auipc	a1,0x4
    2dee:	06e58593          	addi	a1,a1,110 # 6e58 <malloc+0x16a4>
    2df2:	00004517          	auipc	a0,0x4
    2df6:	fde50513          	addi	a0,a0,-34 # 6dd0 <malloc+0x161c>
    2dfa:	00002097          	auipc	ra,0x2
    2dfe:	5d4080e7          	jalr	1492(ra) # 53ce <link>
    2e02:	34051b63          	bnez	a0,3158 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2e06:	00004517          	auipc	a0,0x4
    2e0a:	fca50513          	addi	a0,a0,-54 # 6dd0 <malloc+0x161c>
    2e0e:	00002097          	auipc	ra,0x2
    2e12:	5b0080e7          	jalr	1456(ra) # 53be <unlink>
    2e16:	34051f63          	bnez	a0,3174 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e1a:	4581                	li	a1,0
    2e1c:	00004517          	auipc	a0,0x4
    2e20:	fb450513          	addi	a0,a0,-76 # 6dd0 <malloc+0x161c>
    2e24:	00002097          	auipc	ra,0x2
    2e28:	58a080e7          	jalr	1418(ra) # 53ae <open>
    2e2c:	36055263          	bgez	a0,3190 <subdir+0x4b6>
  if(chdir("dd") != 0){
    2e30:	00004517          	auipc	a0,0x4
    2e34:	f0050513          	addi	a0,a0,-256 # 6d30 <malloc+0x157c>
    2e38:	00002097          	auipc	ra,0x2
    2e3c:	5a6080e7          	jalr	1446(ra) # 53de <chdir>
    2e40:	36051663          	bnez	a0,31ac <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2e44:	00004517          	auipc	a0,0x4
    2e48:	0ac50513          	addi	a0,a0,172 # 6ef0 <malloc+0x173c>
    2e4c:	00002097          	auipc	ra,0x2
    2e50:	592080e7          	jalr	1426(ra) # 53de <chdir>
    2e54:	36051a63          	bnez	a0,31c8 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    2e58:	00004517          	auipc	a0,0x4
    2e5c:	0c850513          	addi	a0,a0,200 # 6f20 <malloc+0x176c>
    2e60:	00002097          	auipc	ra,0x2
    2e64:	57e080e7          	jalr	1406(ra) # 53de <chdir>
    2e68:	36051e63          	bnez	a0,31e4 <subdir+0x50a>
  if(chdir("./..") != 0){
    2e6c:	00004517          	auipc	a0,0x4
    2e70:	0e450513          	addi	a0,a0,228 # 6f50 <malloc+0x179c>
    2e74:	00002097          	auipc	ra,0x2
    2e78:	56a080e7          	jalr	1386(ra) # 53de <chdir>
    2e7c:	38051263          	bnez	a0,3200 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2e80:	4581                	li	a1,0
    2e82:	00004517          	auipc	a0,0x4
    2e86:	fd650513          	addi	a0,a0,-42 # 6e58 <malloc+0x16a4>
    2e8a:	00002097          	auipc	ra,0x2
    2e8e:	524080e7          	jalr	1316(ra) # 53ae <open>
    2e92:	84aa                	mv	s1,a0
  if(fd < 0){
    2e94:	38054463          	bltz	a0,321c <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    2e98:	660d                	lui	a2,0x3
    2e9a:	00009597          	auipc	a1,0x9
    2e9e:	89e58593          	addi	a1,a1,-1890 # b738 <buf>
    2ea2:	00002097          	auipc	ra,0x2
    2ea6:	4e4080e7          	jalr	1252(ra) # 5386 <read>
    2eaa:	4789                	li	a5,2
    2eac:	38f51663          	bne	a0,a5,3238 <subdir+0x55e>
  close(fd);
    2eb0:	8526                	mv	a0,s1
    2eb2:	00002097          	auipc	ra,0x2
    2eb6:	4e4080e7          	jalr	1252(ra) # 5396 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2eba:	4581                	li	a1,0
    2ebc:	00004517          	auipc	a0,0x4
    2ec0:	f1450513          	addi	a0,a0,-236 # 6dd0 <malloc+0x161c>
    2ec4:	00002097          	auipc	ra,0x2
    2ec8:	4ea080e7          	jalr	1258(ra) # 53ae <open>
    2ecc:	38055463          	bgez	a0,3254 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2ed0:	20200593          	li	a1,514
    2ed4:	00004517          	auipc	a0,0x4
    2ed8:	10c50513          	addi	a0,a0,268 # 6fe0 <malloc+0x182c>
    2edc:	00002097          	auipc	ra,0x2
    2ee0:	4d2080e7          	jalr	1234(ra) # 53ae <open>
    2ee4:	38055663          	bgez	a0,3270 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2ee8:	20200593          	li	a1,514
    2eec:	00004517          	auipc	a0,0x4
    2ef0:	12450513          	addi	a0,a0,292 # 7010 <malloc+0x185c>
    2ef4:	00002097          	auipc	ra,0x2
    2ef8:	4ba080e7          	jalr	1210(ra) # 53ae <open>
    2efc:	38055863          	bgez	a0,328c <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    2f00:	20000593          	li	a1,512
    2f04:	00004517          	auipc	a0,0x4
    2f08:	e2c50513          	addi	a0,a0,-468 # 6d30 <malloc+0x157c>
    2f0c:	00002097          	auipc	ra,0x2
    2f10:	4a2080e7          	jalr	1186(ra) # 53ae <open>
    2f14:	38055a63          	bgez	a0,32a8 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    2f18:	4589                	li	a1,2
    2f1a:	00004517          	auipc	a0,0x4
    2f1e:	e1650513          	addi	a0,a0,-490 # 6d30 <malloc+0x157c>
    2f22:	00002097          	auipc	ra,0x2
    2f26:	48c080e7          	jalr	1164(ra) # 53ae <open>
    2f2a:	38055d63          	bgez	a0,32c4 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    2f2e:	4585                	li	a1,1
    2f30:	00004517          	auipc	a0,0x4
    2f34:	e0050513          	addi	a0,a0,-512 # 6d30 <malloc+0x157c>
    2f38:	00002097          	auipc	ra,0x2
    2f3c:	476080e7          	jalr	1142(ra) # 53ae <open>
    2f40:	3a055063          	bgez	a0,32e0 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2f44:	00004597          	auipc	a1,0x4
    2f48:	15c58593          	addi	a1,a1,348 # 70a0 <malloc+0x18ec>
    2f4c:	00004517          	auipc	a0,0x4
    2f50:	09450513          	addi	a0,a0,148 # 6fe0 <malloc+0x182c>
    2f54:	00002097          	auipc	ra,0x2
    2f58:	47a080e7          	jalr	1146(ra) # 53ce <link>
    2f5c:	3a050063          	beqz	a0,32fc <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2f60:	00004597          	auipc	a1,0x4
    2f64:	14058593          	addi	a1,a1,320 # 70a0 <malloc+0x18ec>
    2f68:	00004517          	auipc	a0,0x4
    2f6c:	0a850513          	addi	a0,a0,168 # 7010 <malloc+0x185c>
    2f70:	00002097          	auipc	ra,0x2
    2f74:	45e080e7          	jalr	1118(ra) # 53ce <link>
    2f78:	3a050063          	beqz	a0,3318 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2f7c:	00004597          	auipc	a1,0x4
    2f80:	edc58593          	addi	a1,a1,-292 # 6e58 <malloc+0x16a4>
    2f84:	00004517          	auipc	a0,0x4
    2f88:	dcc50513          	addi	a0,a0,-564 # 6d50 <malloc+0x159c>
    2f8c:	00002097          	auipc	ra,0x2
    2f90:	442080e7          	jalr	1090(ra) # 53ce <link>
    2f94:	3a050063          	beqz	a0,3334 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    2f98:	00004517          	auipc	a0,0x4
    2f9c:	04850513          	addi	a0,a0,72 # 6fe0 <malloc+0x182c>
    2fa0:	00002097          	auipc	ra,0x2
    2fa4:	436080e7          	jalr	1078(ra) # 53d6 <mkdir>
    2fa8:	3a050463          	beqz	a0,3350 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    2fac:	00004517          	auipc	a0,0x4
    2fb0:	06450513          	addi	a0,a0,100 # 7010 <malloc+0x185c>
    2fb4:	00002097          	auipc	ra,0x2
    2fb8:	422080e7          	jalr	1058(ra) # 53d6 <mkdir>
    2fbc:	3a050863          	beqz	a0,336c <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    2fc0:	00004517          	auipc	a0,0x4
    2fc4:	e9850513          	addi	a0,a0,-360 # 6e58 <malloc+0x16a4>
    2fc8:	00002097          	auipc	ra,0x2
    2fcc:	40e080e7          	jalr	1038(ra) # 53d6 <mkdir>
    2fd0:	3a050c63          	beqz	a0,3388 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    2fd4:	00004517          	auipc	a0,0x4
    2fd8:	03c50513          	addi	a0,a0,60 # 7010 <malloc+0x185c>
    2fdc:	00002097          	auipc	ra,0x2
    2fe0:	3e2080e7          	jalr	994(ra) # 53be <unlink>
    2fe4:	3c050063          	beqz	a0,33a4 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    2fe8:	00004517          	auipc	a0,0x4
    2fec:	ff850513          	addi	a0,a0,-8 # 6fe0 <malloc+0x182c>
    2ff0:	00002097          	auipc	ra,0x2
    2ff4:	3ce080e7          	jalr	974(ra) # 53be <unlink>
    2ff8:	3c050463          	beqz	a0,33c0 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    2ffc:	00004517          	auipc	a0,0x4
    3000:	d5450513          	addi	a0,a0,-684 # 6d50 <malloc+0x159c>
    3004:	00002097          	auipc	ra,0x2
    3008:	3da080e7          	jalr	986(ra) # 53de <chdir>
    300c:	3c050863          	beqz	a0,33dc <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3010:	00004517          	auipc	a0,0x4
    3014:	1e050513          	addi	a0,a0,480 # 71f0 <malloc+0x1a3c>
    3018:	00002097          	auipc	ra,0x2
    301c:	3c6080e7          	jalr	966(ra) # 53de <chdir>
    3020:	3c050c63          	beqz	a0,33f8 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3024:	00004517          	auipc	a0,0x4
    3028:	e3450513          	addi	a0,a0,-460 # 6e58 <malloc+0x16a4>
    302c:	00002097          	auipc	ra,0x2
    3030:	392080e7          	jalr	914(ra) # 53be <unlink>
    3034:	3e051063          	bnez	a0,3414 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3038:	00004517          	auipc	a0,0x4
    303c:	d1850513          	addi	a0,a0,-744 # 6d50 <malloc+0x159c>
    3040:	00002097          	auipc	ra,0x2
    3044:	37e080e7          	jalr	894(ra) # 53be <unlink>
    3048:	3e051463          	bnez	a0,3430 <subdir+0x756>
  if(unlink("dd") == 0){
    304c:	00004517          	auipc	a0,0x4
    3050:	ce450513          	addi	a0,a0,-796 # 6d30 <malloc+0x157c>
    3054:	00002097          	auipc	ra,0x2
    3058:	36a080e7          	jalr	874(ra) # 53be <unlink>
    305c:	3e050863          	beqz	a0,344c <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3060:	00004517          	auipc	a0,0x4
    3064:	20050513          	addi	a0,a0,512 # 7260 <malloc+0x1aac>
    3068:	00002097          	auipc	ra,0x2
    306c:	356080e7          	jalr	854(ra) # 53be <unlink>
    3070:	3e054c63          	bltz	a0,3468 <subdir+0x78e>
  if(unlink("dd") < 0){
    3074:	00004517          	auipc	a0,0x4
    3078:	cbc50513          	addi	a0,a0,-836 # 6d30 <malloc+0x157c>
    307c:	00002097          	auipc	ra,0x2
    3080:	342080e7          	jalr	834(ra) # 53be <unlink>
    3084:	40054063          	bltz	a0,3484 <subdir+0x7aa>
}
    3088:	60e2                	ld	ra,24(sp)
    308a:	6442                	ld	s0,16(sp)
    308c:	64a2                	ld	s1,8(sp)
    308e:	6902                	ld	s2,0(sp)
    3090:	6105                	addi	sp,sp,32
    3092:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3094:	85ca                	mv	a1,s2
    3096:	00004517          	auipc	a0,0x4
    309a:	ca250513          	addi	a0,a0,-862 # 6d38 <malloc+0x1584>
    309e:	00002097          	auipc	ra,0x2
    30a2:	658080e7          	jalr	1624(ra) # 56f6 <printf>
    exit(1);
    30a6:	4505                	li	a0,1
    30a8:	00002097          	auipc	ra,0x2
    30ac:	2c6080e7          	jalr	710(ra) # 536e <exit>
    printf("%s: create dd/ff failed\n", s);
    30b0:	85ca                	mv	a1,s2
    30b2:	00004517          	auipc	a0,0x4
    30b6:	ca650513          	addi	a0,a0,-858 # 6d58 <malloc+0x15a4>
    30ba:	00002097          	auipc	ra,0x2
    30be:	63c080e7          	jalr	1596(ra) # 56f6 <printf>
    exit(1);
    30c2:	4505                	li	a0,1
    30c4:	00002097          	auipc	ra,0x2
    30c8:	2aa080e7          	jalr	682(ra) # 536e <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    30cc:	85ca                	mv	a1,s2
    30ce:	00004517          	auipc	a0,0x4
    30d2:	caa50513          	addi	a0,a0,-854 # 6d78 <malloc+0x15c4>
    30d6:	00002097          	auipc	ra,0x2
    30da:	620080e7          	jalr	1568(ra) # 56f6 <printf>
    exit(1);
    30de:	4505                	li	a0,1
    30e0:	00002097          	auipc	ra,0x2
    30e4:	28e080e7          	jalr	654(ra) # 536e <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    30e8:	85ca                	mv	a1,s2
    30ea:	00004517          	auipc	a0,0x4
    30ee:	cc650513          	addi	a0,a0,-826 # 6db0 <malloc+0x15fc>
    30f2:	00002097          	auipc	ra,0x2
    30f6:	604080e7          	jalr	1540(ra) # 56f6 <printf>
    exit(1);
    30fa:	4505                	li	a0,1
    30fc:	00002097          	auipc	ra,0x2
    3100:	272080e7          	jalr	626(ra) # 536e <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3104:	85ca                	mv	a1,s2
    3106:	00004517          	auipc	a0,0x4
    310a:	cda50513          	addi	a0,a0,-806 # 6de0 <malloc+0x162c>
    310e:	00002097          	auipc	ra,0x2
    3112:	5e8080e7          	jalr	1512(ra) # 56f6 <printf>
    exit(1);
    3116:	4505                	li	a0,1
    3118:	00002097          	auipc	ra,0x2
    311c:	256080e7          	jalr	598(ra) # 536e <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3120:	85ca                	mv	a1,s2
    3122:	00004517          	auipc	a0,0x4
    3126:	cf650513          	addi	a0,a0,-778 # 6e18 <malloc+0x1664>
    312a:	00002097          	auipc	ra,0x2
    312e:	5cc080e7          	jalr	1484(ra) # 56f6 <printf>
    exit(1);
    3132:	4505                	li	a0,1
    3134:	00002097          	auipc	ra,0x2
    3138:	23a080e7          	jalr	570(ra) # 536e <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    313c:	85ca                	mv	a1,s2
    313e:	00004517          	auipc	a0,0x4
    3142:	cfa50513          	addi	a0,a0,-774 # 6e38 <malloc+0x1684>
    3146:	00002097          	auipc	ra,0x2
    314a:	5b0080e7          	jalr	1456(ra) # 56f6 <printf>
    exit(1);
    314e:	4505                	li	a0,1
    3150:	00002097          	auipc	ra,0x2
    3154:	21e080e7          	jalr	542(ra) # 536e <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3158:	85ca                	mv	a1,s2
    315a:	00004517          	auipc	a0,0x4
    315e:	d0e50513          	addi	a0,a0,-754 # 6e68 <malloc+0x16b4>
    3162:	00002097          	auipc	ra,0x2
    3166:	594080e7          	jalr	1428(ra) # 56f6 <printf>
    exit(1);
    316a:	4505                	li	a0,1
    316c:	00002097          	auipc	ra,0x2
    3170:	202080e7          	jalr	514(ra) # 536e <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3174:	85ca                	mv	a1,s2
    3176:	00004517          	auipc	a0,0x4
    317a:	d1a50513          	addi	a0,a0,-742 # 6e90 <malloc+0x16dc>
    317e:	00002097          	auipc	ra,0x2
    3182:	578080e7          	jalr	1400(ra) # 56f6 <printf>
    exit(1);
    3186:	4505                	li	a0,1
    3188:	00002097          	auipc	ra,0x2
    318c:	1e6080e7          	jalr	486(ra) # 536e <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3190:	85ca                	mv	a1,s2
    3192:	00004517          	auipc	a0,0x4
    3196:	d1e50513          	addi	a0,a0,-738 # 6eb0 <malloc+0x16fc>
    319a:	00002097          	auipc	ra,0x2
    319e:	55c080e7          	jalr	1372(ra) # 56f6 <printf>
    exit(1);
    31a2:	4505                	li	a0,1
    31a4:	00002097          	auipc	ra,0x2
    31a8:	1ca080e7          	jalr	458(ra) # 536e <exit>
    printf("%s: chdir dd failed\n", s);
    31ac:	85ca                	mv	a1,s2
    31ae:	00004517          	auipc	a0,0x4
    31b2:	d2a50513          	addi	a0,a0,-726 # 6ed8 <malloc+0x1724>
    31b6:	00002097          	auipc	ra,0x2
    31ba:	540080e7          	jalr	1344(ra) # 56f6 <printf>
    exit(1);
    31be:	4505                	li	a0,1
    31c0:	00002097          	auipc	ra,0x2
    31c4:	1ae080e7          	jalr	430(ra) # 536e <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    31c8:	85ca                	mv	a1,s2
    31ca:	00004517          	auipc	a0,0x4
    31ce:	d3650513          	addi	a0,a0,-714 # 6f00 <malloc+0x174c>
    31d2:	00002097          	auipc	ra,0x2
    31d6:	524080e7          	jalr	1316(ra) # 56f6 <printf>
    exit(1);
    31da:	4505                	li	a0,1
    31dc:	00002097          	auipc	ra,0x2
    31e0:	192080e7          	jalr	402(ra) # 536e <exit>
    printf("chdir dd/../../dd failed\n", s);
    31e4:	85ca                	mv	a1,s2
    31e6:	00004517          	auipc	a0,0x4
    31ea:	d4a50513          	addi	a0,a0,-694 # 6f30 <malloc+0x177c>
    31ee:	00002097          	auipc	ra,0x2
    31f2:	508080e7          	jalr	1288(ra) # 56f6 <printf>
    exit(1);
    31f6:	4505                	li	a0,1
    31f8:	00002097          	auipc	ra,0x2
    31fc:	176080e7          	jalr	374(ra) # 536e <exit>
    printf("%s: chdir ./.. failed\n", s);
    3200:	85ca                	mv	a1,s2
    3202:	00004517          	auipc	a0,0x4
    3206:	d5650513          	addi	a0,a0,-682 # 6f58 <malloc+0x17a4>
    320a:	00002097          	auipc	ra,0x2
    320e:	4ec080e7          	jalr	1260(ra) # 56f6 <printf>
    exit(1);
    3212:	4505                	li	a0,1
    3214:	00002097          	auipc	ra,0x2
    3218:	15a080e7          	jalr	346(ra) # 536e <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    321c:	85ca                	mv	a1,s2
    321e:	00004517          	auipc	a0,0x4
    3222:	d5250513          	addi	a0,a0,-686 # 6f70 <malloc+0x17bc>
    3226:	00002097          	auipc	ra,0x2
    322a:	4d0080e7          	jalr	1232(ra) # 56f6 <printf>
    exit(1);
    322e:	4505                	li	a0,1
    3230:	00002097          	auipc	ra,0x2
    3234:	13e080e7          	jalr	318(ra) # 536e <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3238:	85ca                	mv	a1,s2
    323a:	00004517          	auipc	a0,0x4
    323e:	d5650513          	addi	a0,a0,-682 # 6f90 <malloc+0x17dc>
    3242:	00002097          	auipc	ra,0x2
    3246:	4b4080e7          	jalr	1204(ra) # 56f6 <printf>
    exit(1);
    324a:	4505                	li	a0,1
    324c:	00002097          	auipc	ra,0x2
    3250:	122080e7          	jalr	290(ra) # 536e <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3254:	85ca                	mv	a1,s2
    3256:	00004517          	auipc	a0,0x4
    325a:	d5a50513          	addi	a0,a0,-678 # 6fb0 <malloc+0x17fc>
    325e:	00002097          	auipc	ra,0x2
    3262:	498080e7          	jalr	1176(ra) # 56f6 <printf>
    exit(1);
    3266:	4505                	li	a0,1
    3268:	00002097          	auipc	ra,0x2
    326c:	106080e7          	jalr	262(ra) # 536e <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3270:	85ca                	mv	a1,s2
    3272:	00004517          	auipc	a0,0x4
    3276:	d7e50513          	addi	a0,a0,-642 # 6ff0 <malloc+0x183c>
    327a:	00002097          	auipc	ra,0x2
    327e:	47c080e7          	jalr	1148(ra) # 56f6 <printf>
    exit(1);
    3282:	4505                	li	a0,1
    3284:	00002097          	auipc	ra,0x2
    3288:	0ea080e7          	jalr	234(ra) # 536e <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    328c:	85ca                	mv	a1,s2
    328e:	00004517          	auipc	a0,0x4
    3292:	d9250513          	addi	a0,a0,-622 # 7020 <malloc+0x186c>
    3296:	00002097          	auipc	ra,0x2
    329a:	460080e7          	jalr	1120(ra) # 56f6 <printf>
    exit(1);
    329e:	4505                	li	a0,1
    32a0:	00002097          	auipc	ra,0x2
    32a4:	0ce080e7          	jalr	206(ra) # 536e <exit>
    printf("%s: create dd succeeded!\n", s);
    32a8:	85ca                	mv	a1,s2
    32aa:	00004517          	auipc	a0,0x4
    32ae:	d9650513          	addi	a0,a0,-618 # 7040 <malloc+0x188c>
    32b2:	00002097          	auipc	ra,0x2
    32b6:	444080e7          	jalr	1092(ra) # 56f6 <printf>
    exit(1);
    32ba:	4505                	li	a0,1
    32bc:	00002097          	auipc	ra,0x2
    32c0:	0b2080e7          	jalr	178(ra) # 536e <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    32c4:	85ca                	mv	a1,s2
    32c6:	00004517          	auipc	a0,0x4
    32ca:	d9a50513          	addi	a0,a0,-614 # 7060 <malloc+0x18ac>
    32ce:	00002097          	auipc	ra,0x2
    32d2:	428080e7          	jalr	1064(ra) # 56f6 <printf>
    exit(1);
    32d6:	4505                	li	a0,1
    32d8:	00002097          	auipc	ra,0x2
    32dc:	096080e7          	jalr	150(ra) # 536e <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    32e0:	85ca                	mv	a1,s2
    32e2:	00004517          	auipc	a0,0x4
    32e6:	d9e50513          	addi	a0,a0,-610 # 7080 <malloc+0x18cc>
    32ea:	00002097          	auipc	ra,0x2
    32ee:	40c080e7          	jalr	1036(ra) # 56f6 <printf>
    exit(1);
    32f2:	4505                	li	a0,1
    32f4:	00002097          	auipc	ra,0x2
    32f8:	07a080e7          	jalr	122(ra) # 536e <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    32fc:	85ca                	mv	a1,s2
    32fe:	00004517          	auipc	a0,0x4
    3302:	db250513          	addi	a0,a0,-590 # 70b0 <malloc+0x18fc>
    3306:	00002097          	auipc	ra,0x2
    330a:	3f0080e7          	jalr	1008(ra) # 56f6 <printf>
    exit(1);
    330e:	4505                	li	a0,1
    3310:	00002097          	auipc	ra,0x2
    3314:	05e080e7          	jalr	94(ra) # 536e <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3318:	85ca                	mv	a1,s2
    331a:	00004517          	auipc	a0,0x4
    331e:	dbe50513          	addi	a0,a0,-578 # 70d8 <malloc+0x1924>
    3322:	00002097          	auipc	ra,0x2
    3326:	3d4080e7          	jalr	980(ra) # 56f6 <printf>
    exit(1);
    332a:	4505                	li	a0,1
    332c:	00002097          	auipc	ra,0x2
    3330:	042080e7          	jalr	66(ra) # 536e <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3334:	85ca                	mv	a1,s2
    3336:	00004517          	auipc	a0,0x4
    333a:	dca50513          	addi	a0,a0,-566 # 7100 <malloc+0x194c>
    333e:	00002097          	auipc	ra,0x2
    3342:	3b8080e7          	jalr	952(ra) # 56f6 <printf>
    exit(1);
    3346:	4505                	li	a0,1
    3348:	00002097          	auipc	ra,0x2
    334c:	026080e7          	jalr	38(ra) # 536e <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3350:	85ca                	mv	a1,s2
    3352:	00004517          	auipc	a0,0x4
    3356:	dd650513          	addi	a0,a0,-554 # 7128 <malloc+0x1974>
    335a:	00002097          	auipc	ra,0x2
    335e:	39c080e7          	jalr	924(ra) # 56f6 <printf>
    exit(1);
    3362:	4505                	li	a0,1
    3364:	00002097          	auipc	ra,0x2
    3368:	00a080e7          	jalr	10(ra) # 536e <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    336c:	85ca                	mv	a1,s2
    336e:	00004517          	auipc	a0,0x4
    3372:	dda50513          	addi	a0,a0,-550 # 7148 <malloc+0x1994>
    3376:	00002097          	auipc	ra,0x2
    337a:	380080e7          	jalr	896(ra) # 56f6 <printf>
    exit(1);
    337e:	4505                	li	a0,1
    3380:	00002097          	auipc	ra,0x2
    3384:	fee080e7          	jalr	-18(ra) # 536e <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3388:	85ca                	mv	a1,s2
    338a:	00004517          	auipc	a0,0x4
    338e:	dde50513          	addi	a0,a0,-546 # 7168 <malloc+0x19b4>
    3392:	00002097          	auipc	ra,0x2
    3396:	364080e7          	jalr	868(ra) # 56f6 <printf>
    exit(1);
    339a:	4505                	li	a0,1
    339c:	00002097          	auipc	ra,0x2
    33a0:	fd2080e7          	jalr	-46(ra) # 536e <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    33a4:	85ca                	mv	a1,s2
    33a6:	00004517          	auipc	a0,0x4
    33aa:	dea50513          	addi	a0,a0,-534 # 7190 <malloc+0x19dc>
    33ae:	00002097          	auipc	ra,0x2
    33b2:	348080e7          	jalr	840(ra) # 56f6 <printf>
    exit(1);
    33b6:	4505                	li	a0,1
    33b8:	00002097          	auipc	ra,0x2
    33bc:	fb6080e7          	jalr	-74(ra) # 536e <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    33c0:	85ca                	mv	a1,s2
    33c2:	00004517          	auipc	a0,0x4
    33c6:	dee50513          	addi	a0,a0,-530 # 71b0 <malloc+0x19fc>
    33ca:	00002097          	auipc	ra,0x2
    33ce:	32c080e7          	jalr	812(ra) # 56f6 <printf>
    exit(1);
    33d2:	4505                	li	a0,1
    33d4:	00002097          	auipc	ra,0x2
    33d8:	f9a080e7          	jalr	-102(ra) # 536e <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    33dc:	85ca                	mv	a1,s2
    33de:	00004517          	auipc	a0,0x4
    33e2:	df250513          	addi	a0,a0,-526 # 71d0 <malloc+0x1a1c>
    33e6:	00002097          	auipc	ra,0x2
    33ea:	310080e7          	jalr	784(ra) # 56f6 <printf>
    exit(1);
    33ee:	4505                	li	a0,1
    33f0:	00002097          	auipc	ra,0x2
    33f4:	f7e080e7          	jalr	-130(ra) # 536e <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    33f8:	85ca                	mv	a1,s2
    33fa:	00004517          	auipc	a0,0x4
    33fe:	dfe50513          	addi	a0,a0,-514 # 71f8 <malloc+0x1a44>
    3402:	00002097          	auipc	ra,0x2
    3406:	2f4080e7          	jalr	756(ra) # 56f6 <printf>
    exit(1);
    340a:	4505                	li	a0,1
    340c:	00002097          	auipc	ra,0x2
    3410:	f62080e7          	jalr	-158(ra) # 536e <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3414:	85ca                	mv	a1,s2
    3416:	00004517          	auipc	a0,0x4
    341a:	a7a50513          	addi	a0,a0,-1414 # 6e90 <malloc+0x16dc>
    341e:	00002097          	auipc	ra,0x2
    3422:	2d8080e7          	jalr	728(ra) # 56f6 <printf>
    exit(1);
    3426:	4505                	li	a0,1
    3428:	00002097          	auipc	ra,0x2
    342c:	f46080e7          	jalr	-186(ra) # 536e <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3430:	85ca                	mv	a1,s2
    3432:	00004517          	auipc	a0,0x4
    3436:	de650513          	addi	a0,a0,-538 # 7218 <malloc+0x1a64>
    343a:	00002097          	auipc	ra,0x2
    343e:	2bc080e7          	jalr	700(ra) # 56f6 <printf>
    exit(1);
    3442:	4505                	li	a0,1
    3444:	00002097          	auipc	ra,0x2
    3448:	f2a080e7          	jalr	-214(ra) # 536e <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    344c:	85ca                	mv	a1,s2
    344e:	00004517          	auipc	a0,0x4
    3452:	dea50513          	addi	a0,a0,-534 # 7238 <malloc+0x1a84>
    3456:	00002097          	auipc	ra,0x2
    345a:	2a0080e7          	jalr	672(ra) # 56f6 <printf>
    exit(1);
    345e:	4505                	li	a0,1
    3460:	00002097          	auipc	ra,0x2
    3464:	f0e080e7          	jalr	-242(ra) # 536e <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3468:	85ca                	mv	a1,s2
    346a:	00004517          	auipc	a0,0x4
    346e:	dfe50513          	addi	a0,a0,-514 # 7268 <malloc+0x1ab4>
    3472:	00002097          	auipc	ra,0x2
    3476:	284080e7          	jalr	644(ra) # 56f6 <printf>
    exit(1);
    347a:	4505                	li	a0,1
    347c:	00002097          	auipc	ra,0x2
    3480:	ef2080e7          	jalr	-270(ra) # 536e <exit>
    printf("%s: unlink dd failed\n", s);
    3484:	85ca                	mv	a1,s2
    3486:	00004517          	auipc	a0,0x4
    348a:	e0250513          	addi	a0,a0,-510 # 7288 <malloc+0x1ad4>
    348e:	00002097          	auipc	ra,0x2
    3492:	268080e7          	jalr	616(ra) # 56f6 <printf>
    exit(1);
    3496:	4505                	li	a0,1
    3498:	00002097          	auipc	ra,0x2
    349c:	ed6080e7          	jalr	-298(ra) # 536e <exit>

00000000000034a0 <rmdot>:
{
    34a0:	1101                	addi	sp,sp,-32
    34a2:	ec06                	sd	ra,24(sp)
    34a4:	e822                	sd	s0,16(sp)
    34a6:	e426                	sd	s1,8(sp)
    34a8:	1000                	addi	s0,sp,32
    34aa:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    34ac:	00004517          	auipc	a0,0x4
    34b0:	df450513          	addi	a0,a0,-524 # 72a0 <malloc+0x1aec>
    34b4:	00002097          	auipc	ra,0x2
    34b8:	f22080e7          	jalr	-222(ra) # 53d6 <mkdir>
    34bc:	e549                	bnez	a0,3546 <rmdot+0xa6>
  if(chdir("dots") != 0){
    34be:	00004517          	auipc	a0,0x4
    34c2:	de250513          	addi	a0,a0,-542 # 72a0 <malloc+0x1aec>
    34c6:	00002097          	auipc	ra,0x2
    34ca:	f18080e7          	jalr	-232(ra) # 53de <chdir>
    34ce:	e951                	bnez	a0,3562 <rmdot+0xc2>
  if(unlink(".") == 0){
    34d0:	00003517          	auipc	a0,0x3
    34d4:	d9850513          	addi	a0,a0,-616 # 6268 <malloc+0xab4>
    34d8:	00002097          	auipc	ra,0x2
    34dc:	ee6080e7          	jalr	-282(ra) # 53be <unlink>
    34e0:	cd59                	beqz	a0,357e <rmdot+0xde>
  if(unlink("..") == 0){
    34e2:	00004517          	auipc	a0,0x4
    34e6:	e0e50513          	addi	a0,a0,-498 # 72f0 <malloc+0x1b3c>
    34ea:	00002097          	auipc	ra,0x2
    34ee:	ed4080e7          	jalr	-300(ra) # 53be <unlink>
    34f2:	c545                	beqz	a0,359a <rmdot+0xfa>
  if(chdir("/") != 0){
    34f4:	00004517          	auipc	a0,0x4
    34f8:	80450513          	addi	a0,a0,-2044 # 6cf8 <malloc+0x1544>
    34fc:	00002097          	auipc	ra,0x2
    3500:	ee2080e7          	jalr	-286(ra) # 53de <chdir>
    3504:	e94d                	bnez	a0,35b6 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3506:	00004517          	auipc	a0,0x4
    350a:	e0a50513          	addi	a0,a0,-502 # 7310 <malloc+0x1b5c>
    350e:	00002097          	auipc	ra,0x2
    3512:	eb0080e7          	jalr	-336(ra) # 53be <unlink>
    3516:	cd55                	beqz	a0,35d2 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3518:	00004517          	auipc	a0,0x4
    351c:	e2050513          	addi	a0,a0,-480 # 7338 <malloc+0x1b84>
    3520:	00002097          	auipc	ra,0x2
    3524:	e9e080e7          	jalr	-354(ra) # 53be <unlink>
    3528:	c179                	beqz	a0,35ee <rmdot+0x14e>
  if(unlink("dots") != 0){
    352a:	00004517          	auipc	a0,0x4
    352e:	d7650513          	addi	a0,a0,-650 # 72a0 <malloc+0x1aec>
    3532:	00002097          	auipc	ra,0x2
    3536:	e8c080e7          	jalr	-372(ra) # 53be <unlink>
    353a:	e961                	bnez	a0,360a <rmdot+0x16a>
}
    353c:	60e2                	ld	ra,24(sp)
    353e:	6442                	ld	s0,16(sp)
    3540:	64a2                	ld	s1,8(sp)
    3542:	6105                	addi	sp,sp,32
    3544:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3546:	85a6                	mv	a1,s1
    3548:	00004517          	auipc	a0,0x4
    354c:	d6050513          	addi	a0,a0,-672 # 72a8 <malloc+0x1af4>
    3550:	00002097          	auipc	ra,0x2
    3554:	1a6080e7          	jalr	422(ra) # 56f6 <printf>
    exit(1);
    3558:	4505                	li	a0,1
    355a:	00002097          	auipc	ra,0x2
    355e:	e14080e7          	jalr	-492(ra) # 536e <exit>
    printf("%s: chdir dots failed\n", s);
    3562:	85a6                	mv	a1,s1
    3564:	00004517          	auipc	a0,0x4
    3568:	d5c50513          	addi	a0,a0,-676 # 72c0 <malloc+0x1b0c>
    356c:	00002097          	auipc	ra,0x2
    3570:	18a080e7          	jalr	394(ra) # 56f6 <printf>
    exit(1);
    3574:	4505                	li	a0,1
    3576:	00002097          	auipc	ra,0x2
    357a:	df8080e7          	jalr	-520(ra) # 536e <exit>
    printf("%s: rm . worked!\n", s);
    357e:	85a6                	mv	a1,s1
    3580:	00004517          	auipc	a0,0x4
    3584:	d5850513          	addi	a0,a0,-680 # 72d8 <malloc+0x1b24>
    3588:	00002097          	auipc	ra,0x2
    358c:	16e080e7          	jalr	366(ra) # 56f6 <printf>
    exit(1);
    3590:	4505                	li	a0,1
    3592:	00002097          	auipc	ra,0x2
    3596:	ddc080e7          	jalr	-548(ra) # 536e <exit>
    printf("%s: rm .. worked!\n", s);
    359a:	85a6                	mv	a1,s1
    359c:	00004517          	auipc	a0,0x4
    35a0:	d5c50513          	addi	a0,a0,-676 # 72f8 <malloc+0x1b44>
    35a4:	00002097          	auipc	ra,0x2
    35a8:	152080e7          	jalr	338(ra) # 56f6 <printf>
    exit(1);
    35ac:	4505                	li	a0,1
    35ae:	00002097          	auipc	ra,0x2
    35b2:	dc0080e7          	jalr	-576(ra) # 536e <exit>
    printf("%s: chdir / failed\n", s);
    35b6:	85a6                	mv	a1,s1
    35b8:	00003517          	auipc	a0,0x3
    35bc:	74850513          	addi	a0,a0,1864 # 6d00 <malloc+0x154c>
    35c0:	00002097          	auipc	ra,0x2
    35c4:	136080e7          	jalr	310(ra) # 56f6 <printf>
    exit(1);
    35c8:	4505                	li	a0,1
    35ca:	00002097          	auipc	ra,0x2
    35ce:	da4080e7          	jalr	-604(ra) # 536e <exit>
    printf("%s: unlink dots/. worked!\n", s);
    35d2:	85a6                	mv	a1,s1
    35d4:	00004517          	auipc	a0,0x4
    35d8:	d4450513          	addi	a0,a0,-700 # 7318 <malloc+0x1b64>
    35dc:	00002097          	auipc	ra,0x2
    35e0:	11a080e7          	jalr	282(ra) # 56f6 <printf>
    exit(1);
    35e4:	4505                	li	a0,1
    35e6:	00002097          	auipc	ra,0x2
    35ea:	d88080e7          	jalr	-632(ra) # 536e <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    35ee:	85a6                	mv	a1,s1
    35f0:	00004517          	auipc	a0,0x4
    35f4:	d5050513          	addi	a0,a0,-688 # 7340 <malloc+0x1b8c>
    35f8:	00002097          	auipc	ra,0x2
    35fc:	0fe080e7          	jalr	254(ra) # 56f6 <printf>
    exit(1);
    3600:	4505                	li	a0,1
    3602:	00002097          	auipc	ra,0x2
    3606:	d6c080e7          	jalr	-660(ra) # 536e <exit>
    printf("%s: unlink dots failed!\n", s);
    360a:	85a6                	mv	a1,s1
    360c:	00004517          	auipc	a0,0x4
    3610:	d5450513          	addi	a0,a0,-684 # 7360 <malloc+0x1bac>
    3614:	00002097          	auipc	ra,0x2
    3618:	0e2080e7          	jalr	226(ra) # 56f6 <printf>
    exit(1);
    361c:	4505                	li	a0,1
    361e:	00002097          	auipc	ra,0x2
    3622:	d50080e7          	jalr	-688(ra) # 536e <exit>

0000000000003626 <dirfile>:
{
    3626:	1101                	addi	sp,sp,-32
    3628:	ec06                	sd	ra,24(sp)
    362a:	e822                	sd	s0,16(sp)
    362c:	e426                	sd	s1,8(sp)
    362e:	e04a                	sd	s2,0(sp)
    3630:	1000                	addi	s0,sp,32
    3632:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3634:	20000593          	li	a1,512
    3638:	00002517          	auipc	a0,0x2
    363c:	53850513          	addi	a0,a0,1336 # 5b70 <malloc+0x3bc>
    3640:	00002097          	auipc	ra,0x2
    3644:	d6e080e7          	jalr	-658(ra) # 53ae <open>
  if(fd < 0){
    3648:	0e054d63          	bltz	a0,3742 <dirfile+0x11c>
  close(fd);
    364c:	00002097          	auipc	ra,0x2
    3650:	d4a080e7          	jalr	-694(ra) # 5396 <close>
  if(chdir("dirfile") == 0){
    3654:	00002517          	auipc	a0,0x2
    3658:	51c50513          	addi	a0,a0,1308 # 5b70 <malloc+0x3bc>
    365c:	00002097          	auipc	ra,0x2
    3660:	d82080e7          	jalr	-638(ra) # 53de <chdir>
    3664:	cd6d                	beqz	a0,375e <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3666:	4581                	li	a1,0
    3668:	00004517          	auipc	a0,0x4
    366c:	d5850513          	addi	a0,a0,-680 # 73c0 <malloc+0x1c0c>
    3670:	00002097          	auipc	ra,0x2
    3674:	d3e080e7          	jalr	-706(ra) # 53ae <open>
  if(fd >= 0){
    3678:	10055163          	bgez	a0,377a <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    367c:	20000593          	li	a1,512
    3680:	00004517          	auipc	a0,0x4
    3684:	d4050513          	addi	a0,a0,-704 # 73c0 <malloc+0x1c0c>
    3688:	00002097          	auipc	ra,0x2
    368c:	d26080e7          	jalr	-730(ra) # 53ae <open>
  if(fd >= 0){
    3690:	10055363          	bgez	a0,3796 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3694:	00004517          	auipc	a0,0x4
    3698:	d2c50513          	addi	a0,a0,-724 # 73c0 <malloc+0x1c0c>
    369c:	00002097          	auipc	ra,0x2
    36a0:	d3a080e7          	jalr	-710(ra) # 53d6 <mkdir>
    36a4:	10050763          	beqz	a0,37b2 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    36a8:	00004517          	auipc	a0,0x4
    36ac:	d1850513          	addi	a0,a0,-744 # 73c0 <malloc+0x1c0c>
    36b0:	00002097          	auipc	ra,0x2
    36b4:	d0e080e7          	jalr	-754(ra) # 53be <unlink>
    36b8:	10050b63          	beqz	a0,37ce <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    36bc:	00004597          	auipc	a1,0x4
    36c0:	d0458593          	addi	a1,a1,-764 # 73c0 <malloc+0x1c0c>
    36c4:	00002517          	auipc	a0,0x2
    36c8:	6a450513          	addi	a0,a0,1700 # 5d68 <malloc+0x5b4>
    36cc:	00002097          	auipc	ra,0x2
    36d0:	d02080e7          	jalr	-766(ra) # 53ce <link>
    36d4:	10050b63          	beqz	a0,37ea <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    36d8:	00002517          	auipc	a0,0x2
    36dc:	49850513          	addi	a0,a0,1176 # 5b70 <malloc+0x3bc>
    36e0:	00002097          	auipc	ra,0x2
    36e4:	cde080e7          	jalr	-802(ra) # 53be <unlink>
    36e8:	10051f63          	bnez	a0,3806 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    36ec:	4589                	li	a1,2
    36ee:	00003517          	auipc	a0,0x3
    36f2:	b7a50513          	addi	a0,a0,-1158 # 6268 <malloc+0xab4>
    36f6:	00002097          	auipc	ra,0x2
    36fa:	cb8080e7          	jalr	-840(ra) # 53ae <open>
  if(fd >= 0){
    36fe:	12055263          	bgez	a0,3822 <dirfile+0x1fc>
  fd = open(".", 0);
    3702:	4581                	li	a1,0
    3704:	00003517          	auipc	a0,0x3
    3708:	b6450513          	addi	a0,a0,-1180 # 6268 <malloc+0xab4>
    370c:	00002097          	auipc	ra,0x2
    3710:	ca2080e7          	jalr	-862(ra) # 53ae <open>
    3714:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3716:	4605                	li	a2,1
    3718:	00002597          	auipc	a1,0x2
    371c:	52858593          	addi	a1,a1,1320 # 5c40 <malloc+0x48c>
    3720:	00002097          	auipc	ra,0x2
    3724:	c6e080e7          	jalr	-914(ra) # 538e <write>
    3728:	10a04b63          	bgtz	a0,383e <dirfile+0x218>
  close(fd);
    372c:	8526                	mv	a0,s1
    372e:	00002097          	auipc	ra,0x2
    3732:	c68080e7          	jalr	-920(ra) # 5396 <close>
}
    3736:	60e2                	ld	ra,24(sp)
    3738:	6442                	ld	s0,16(sp)
    373a:	64a2                	ld	s1,8(sp)
    373c:	6902                	ld	s2,0(sp)
    373e:	6105                	addi	sp,sp,32
    3740:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3742:	85ca                	mv	a1,s2
    3744:	00004517          	auipc	a0,0x4
    3748:	c3c50513          	addi	a0,a0,-964 # 7380 <malloc+0x1bcc>
    374c:	00002097          	auipc	ra,0x2
    3750:	faa080e7          	jalr	-86(ra) # 56f6 <printf>
    exit(1);
    3754:	4505                	li	a0,1
    3756:	00002097          	auipc	ra,0x2
    375a:	c18080e7          	jalr	-1000(ra) # 536e <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    375e:	85ca                	mv	a1,s2
    3760:	00004517          	auipc	a0,0x4
    3764:	c4050513          	addi	a0,a0,-960 # 73a0 <malloc+0x1bec>
    3768:	00002097          	auipc	ra,0x2
    376c:	f8e080e7          	jalr	-114(ra) # 56f6 <printf>
    exit(1);
    3770:	4505                	li	a0,1
    3772:	00002097          	auipc	ra,0x2
    3776:	bfc080e7          	jalr	-1028(ra) # 536e <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    377a:	85ca                	mv	a1,s2
    377c:	00004517          	auipc	a0,0x4
    3780:	c5450513          	addi	a0,a0,-940 # 73d0 <malloc+0x1c1c>
    3784:	00002097          	auipc	ra,0x2
    3788:	f72080e7          	jalr	-142(ra) # 56f6 <printf>
    exit(1);
    378c:	4505                	li	a0,1
    378e:	00002097          	auipc	ra,0x2
    3792:	be0080e7          	jalr	-1056(ra) # 536e <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3796:	85ca                	mv	a1,s2
    3798:	00004517          	auipc	a0,0x4
    379c:	c3850513          	addi	a0,a0,-968 # 73d0 <malloc+0x1c1c>
    37a0:	00002097          	auipc	ra,0x2
    37a4:	f56080e7          	jalr	-170(ra) # 56f6 <printf>
    exit(1);
    37a8:	4505                	li	a0,1
    37aa:	00002097          	auipc	ra,0x2
    37ae:	bc4080e7          	jalr	-1084(ra) # 536e <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    37b2:	85ca                	mv	a1,s2
    37b4:	00004517          	auipc	a0,0x4
    37b8:	c4450513          	addi	a0,a0,-956 # 73f8 <malloc+0x1c44>
    37bc:	00002097          	auipc	ra,0x2
    37c0:	f3a080e7          	jalr	-198(ra) # 56f6 <printf>
    exit(1);
    37c4:	4505                	li	a0,1
    37c6:	00002097          	auipc	ra,0x2
    37ca:	ba8080e7          	jalr	-1112(ra) # 536e <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    37ce:	85ca                	mv	a1,s2
    37d0:	00004517          	auipc	a0,0x4
    37d4:	c5050513          	addi	a0,a0,-944 # 7420 <malloc+0x1c6c>
    37d8:	00002097          	auipc	ra,0x2
    37dc:	f1e080e7          	jalr	-226(ra) # 56f6 <printf>
    exit(1);
    37e0:	4505                	li	a0,1
    37e2:	00002097          	auipc	ra,0x2
    37e6:	b8c080e7          	jalr	-1140(ra) # 536e <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    37ea:	85ca                	mv	a1,s2
    37ec:	00004517          	auipc	a0,0x4
    37f0:	c5c50513          	addi	a0,a0,-932 # 7448 <malloc+0x1c94>
    37f4:	00002097          	auipc	ra,0x2
    37f8:	f02080e7          	jalr	-254(ra) # 56f6 <printf>
    exit(1);
    37fc:	4505                	li	a0,1
    37fe:	00002097          	auipc	ra,0x2
    3802:	b70080e7          	jalr	-1168(ra) # 536e <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3806:	85ca                	mv	a1,s2
    3808:	00004517          	auipc	a0,0x4
    380c:	c6850513          	addi	a0,a0,-920 # 7470 <malloc+0x1cbc>
    3810:	00002097          	auipc	ra,0x2
    3814:	ee6080e7          	jalr	-282(ra) # 56f6 <printf>
    exit(1);
    3818:	4505                	li	a0,1
    381a:	00002097          	auipc	ra,0x2
    381e:	b54080e7          	jalr	-1196(ra) # 536e <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3822:	85ca                	mv	a1,s2
    3824:	00004517          	auipc	a0,0x4
    3828:	c6c50513          	addi	a0,a0,-916 # 7490 <malloc+0x1cdc>
    382c:	00002097          	auipc	ra,0x2
    3830:	eca080e7          	jalr	-310(ra) # 56f6 <printf>
    exit(1);
    3834:	4505                	li	a0,1
    3836:	00002097          	auipc	ra,0x2
    383a:	b38080e7          	jalr	-1224(ra) # 536e <exit>
    printf("%s: write . succeeded!\n", s);
    383e:	85ca                	mv	a1,s2
    3840:	00004517          	auipc	a0,0x4
    3844:	c7850513          	addi	a0,a0,-904 # 74b8 <malloc+0x1d04>
    3848:	00002097          	auipc	ra,0x2
    384c:	eae080e7          	jalr	-338(ra) # 56f6 <printf>
    exit(1);
    3850:	4505                	li	a0,1
    3852:	00002097          	auipc	ra,0x2
    3856:	b1c080e7          	jalr	-1252(ra) # 536e <exit>

000000000000385a <iref>:
{
    385a:	7139                	addi	sp,sp,-64
    385c:	fc06                	sd	ra,56(sp)
    385e:	f822                	sd	s0,48(sp)
    3860:	f426                	sd	s1,40(sp)
    3862:	f04a                	sd	s2,32(sp)
    3864:	ec4e                	sd	s3,24(sp)
    3866:	e852                	sd	s4,16(sp)
    3868:	e456                	sd	s5,8(sp)
    386a:	e05a                	sd	s6,0(sp)
    386c:	0080                	addi	s0,sp,64
    386e:	8b2a                	mv	s6,a0
    3870:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3874:	00004a17          	auipc	s4,0x4
    3878:	c5ca0a13          	addi	s4,s4,-932 # 74d0 <malloc+0x1d1c>
    mkdir("");
    387c:	00003497          	auipc	s1,0x3
    3880:	75c48493          	addi	s1,s1,1884 # 6fd8 <malloc+0x1824>
    link("README", "");
    3884:	00002a97          	auipc	s5,0x2
    3888:	4e4a8a93          	addi	s5,s5,1252 # 5d68 <malloc+0x5b4>
    fd = open("xx", O_CREATE);
    388c:	00004997          	auipc	s3,0x4
    3890:	b3c98993          	addi	s3,s3,-1220 # 73c8 <malloc+0x1c14>
    3894:	a891                	j	38e8 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3896:	85da                	mv	a1,s6
    3898:	00004517          	auipc	a0,0x4
    389c:	c4050513          	addi	a0,a0,-960 # 74d8 <malloc+0x1d24>
    38a0:	00002097          	auipc	ra,0x2
    38a4:	e56080e7          	jalr	-426(ra) # 56f6 <printf>
      exit(1);
    38a8:	4505                	li	a0,1
    38aa:	00002097          	auipc	ra,0x2
    38ae:	ac4080e7          	jalr	-1340(ra) # 536e <exit>
      printf("%s: chdir irefd failed\n", s);
    38b2:	85da                	mv	a1,s6
    38b4:	00004517          	auipc	a0,0x4
    38b8:	c3c50513          	addi	a0,a0,-964 # 74f0 <malloc+0x1d3c>
    38bc:	00002097          	auipc	ra,0x2
    38c0:	e3a080e7          	jalr	-454(ra) # 56f6 <printf>
      exit(1);
    38c4:	4505                	li	a0,1
    38c6:	00002097          	auipc	ra,0x2
    38ca:	aa8080e7          	jalr	-1368(ra) # 536e <exit>
      close(fd);
    38ce:	00002097          	auipc	ra,0x2
    38d2:	ac8080e7          	jalr	-1336(ra) # 5396 <close>
    38d6:	a889                	j	3928 <iref+0xce>
    unlink("xx");
    38d8:	854e                	mv	a0,s3
    38da:	00002097          	auipc	ra,0x2
    38de:	ae4080e7          	jalr	-1308(ra) # 53be <unlink>
  for(i = 0; i < NINODE + 1; i++){
    38e2:	397d                	addiw	s2,s2,-1
    38e4:	06090063          	beqz	s2,3944 <iref+0xea>
    if(mkdir("irefd") != 0){
    38e8:	8552                	mv	a0,s4
    38ea:	00002097          	auipc	ra,0x2
    38ee:	aec080e7          	jalr	-1300(ra) # 53d6 <mkdir>
    38f2:	f155                	bnez	a0,3896 <iref+0x3c>
    if(chdir("irefd") != 0){
    38f4:	8552                	mv	a0,s4
    38f6:	00002097          	auipc	ra,0x2
    38fa:	ae8080e7          	jalr	-1304(ra) # 53de <chdir>
    38fe:	f955                	bnez	a0,38b2 <iref+0x58>
    mkdir("");
    3900:	8526                	mv	a0,s1
    3902:	00002097          	auipc	ra,0x2
    3906:	ad4080e7          	jalr	-1324(ra) # 53d6 <mkdir>
    link("README", "");
    390a:	85a6                	mv	a1,s1
    390c:	8556                	mv	a0,s5
    390e:	00002097          	auipc	ra,0x2
    3912:	ac0080e7          	jalr	-1344(ra) # 53ce <link>
    fd = open("", O_CREATE);
    3916:	20000593          	li	a1,512
    391a:	8526                	mv	a0,s1
    391c:	00002097          	auipc	ra,0x2
    3920:	a92080e7          	jalr	-1390(ra) # 53ae <open>
    if(fd >= 0)
    3924:	fa0555e3          	bgez	a0,38ce <iref+0x74>
    fd = open("xx", O_CREATE);
    3928:	20000593          	li	a1,512
    392c:	854e                	mv	a0,s3
    392e:	00002097          	auipc	ra,0x2
    3932:	a80080e7          	jalr	-1408(ra) # 53ae <open>
    if(fd >= 0)
    3936:	fa0541e3          	bltz	a0,38d8 <iref+0x7e>
      close(fd);
    393a:	00002097          	auipc	ra,0x2
    393e:	a5c080e7          	jalr	-1444(ra) # 5396 <close>
    3942:	bf59                	j	38d8 <iref+0x7e>
    3944:	03300493          	li	s1,51
    chdir("..");
    3948:	00004997          	auipc	s3,0x4
    394c:	9a898993          	addi	s3,s3,-1624 # 72f0 <malloc+0x1b3c>
    unlink("irefd");
    3950:	00004917          	auipc	s2,0x4
    3954:	b8090913          	addi	s2,s2,-1152 # 74d0 <malloc+0x1d1c>
    chdir("..");
    3958:	854e                	mv	a0,s3
    395a:	00002097          	auipc	ra,0x2
    395e:	a84080e7          	jalr	-1404(ra) # 53de <chdir>
    unlink("irefd");
    3962:	854a                	mv	a0,s2
    3964:	00002097          	auipc	ra,0x2
    3968:	a5a080e7          	jalr	-1446(ra) # 53be <unlink>
  for(i = 0; i < NINODE + 1; i++){
    396c:	34fd                	addiw	s1,s1,-1
    396e:	f4ed                	bnez	s1,3958 <iref+0xfe>
  chdir("/");
    3970:	00003517          	auipc	a0,0x3
    3974:	38850513          	addi	a0,a0,904 # 6cf8 <malloc+0x1544>
    3978:	00002097          	auipc	ra,0x2
    397c:	a66080e7          	jalr	-1434(ra) # 53de <chdir>
}
    3980:	70e2                	ld	ra,56(sp)
    3982:	7442                	ld	s0,48(sp)
    3984:	74a2                	ld	s1,40(sp)
    3986:	7902                	ld	s2,32(sp)
    3988:	69e2                	ld	s3,24(sp)
    398a:	6a42                	ld	s4,16(sp)
    398c:	6aa2                	ld	s5,8(sp)
    398e:	6b02                	ld	s6,0(sp)
    3990:	6121                	addi	sp,sp,64
    3992:	8082                	ret

0000000000003994 <openiputtest>:
{
    3994:	7179                	addi	sp,sp,-48
    3996:	f406                	sd	ra,40(sp)
    3998:	f022                	sd	s0,32(sp)
    399a:	ec26                	sd	s1,24(sp)
    399c:	1800                	addi	s0,sp,48
    399e:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    39a0:	00004517          	auipc	a0,0x4
    39a4:	b6850513          	addi	a0,a0,-1176 # 7508 <malloc+0x1d54>
    39a8:	00002097          	auipc	ra,0x2
    39ac:	a2e080e7          	jalr	-1490(ra) # 53d6 <mkdir>
    39b0:	04054263          	bltz	a0,39f4 <openiputtest+0x60>
  pid = fork();
    39b4:	00002097          	auipc	ra,0x2
    39b8:	9b2080e7          	jalr	-1614(ra) # 5366 <fork>
  if(pid < 0){
    39bc:	04054a63          	bltz	a0,3a10 <openiputtest+0x7c>
  if(pid == 0){
    39c0:	e93d                	bnez	a0,3a36 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    39c2:	4589                	li	a1,2
    39c4:	00004517          	auipc	a0,0x4
    39c8:	b4450513          	addi	a0,a0,-1212 # 7508 <malloc+0x1d54>
    39cc:	00002097          	auipc	ra,0x2
    39d0:	9e2080e7          	jalr	-1566(ra) # 53ae <open>
    if(fd >= 0){
    39d4:	04054c63          	bltz	a0,3a2c <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    39d8:	85a6                	mv	a1,s1
    39da:	00004517          	auipc	a0,0x4
    39de:	b4e50513          	addi	a0,a0,-1202 # 7528 <malloc+0x1d74>
    39e2:	00002097          	auipc	ra,0x2
    39e6:	d14080e7          	jalr	-748(ra) # 56f6 <printf>
      exit(1);
    39ea:	4505                	li	a0,1
    39ec:	00002097          	auipc	ra,0x2
    39f0:	982080e7          	jalr	-1662(ra) # 536e <exit>
    printf("%s: mkdir oidir failed\n", s);
    39f4:	85a6                	mv	a1,s1
    39f6:	00004517          	auipc	a0,0x4
    39fa:	b1a50513          	addi	a0,a0,-1254 # 7510 <malloc+0x1d5c>
    39fe:	00002097          	auipc	ra,0x2
    3a02:	cf8080e7          	jalr	-776(ra) # 56f6 <printf>
    exit(1);
    3a06:	4505                	li	a0,1
    3a08:	00002097          	auipc	ra,0x2
    3a0c:	966080e7          	jalr	-1690(ra) # 536e <exit>
    printf("%s: fork failed\n", s);
    3a10:	85a6                	mv	a1,s1
    3a12:	00003517          	auipc	a0,0x3
    3a16:	9f650513          	addi	a0,a0,-1546 # 6408 <malloc+0xc54>
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	cdc080e7          	jalr	-804(ra) # 56f6 <printf>
    exit(1);
    3a22:	4505                	li	a0,1
    3a24:	00002097          	auipc	ra,0x2
    3a28:	94a080e7          	jalr	-1718(ra) # 536e <exit>
    exit(0);
    3a2c:	4501                	li	a0,0
    3a2e:	00002097          	auipc	ra,0x2
    3a32:	940080e7          	jalr	-1728(ra) # 536e <exit>
  sleep(1);
    3a36:	4505                	li	a0,1
    3a38:	00002097          	auipc	ra,0x2
    3a3c:	9c6080e7          	jalr	-1594(ra) # 53fe <sleep>
  if(unlink("oidir") != 0){
    3a40:	00004517          	auipc	a0,0x4
    3a44:	ac850513          	addi	a0,a0,-1336 # 7508 <malloc+0x1d54>
    3a48:	00002097          	auipc	ra,0x2
    3a4c:	976080e7          	jalr	-1674(ra) # 53be <unlink>
    3a50:	cd19                	beqz	a0,3a6e <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3a52:	85a6                	mv	a1,s1
    3a54:	00003517          	auipc	a0,0x3
    3a58:	ba450513          	addi	a0,a0,-1116 # 65f8 <malloc+0xe44>
    3a5c:	00002097          	auipc	ra,0x2
    3a60:	c9a080e7          	jalr	-870(ra) # 56f6 <printf>
    exit(1);
    3a64:	4505                	li	a0,1
    3a66:	00002097          	auipc	ra,0x2
    3a6a:	908080e7          	jalr	-1784(ra) # 536e <exit>
  wait(&xstatus);
    3a6e:	fdc40513          	addi	a0,s0,-36
    3a72:	00002097          	auipc	ra,0x2
    3a76:	904080e7          	jalr	-1788(ra) # 5376 <wait>
  exit(xstatus);
    3a7a:	fdc42503          	lw	a0,-36(s0)
    3a7e:	00002097          	auipc	ra,0x2
    3a82:	8f0080e7          	jalr	-1808(ra) # 536e <exit>

0000000000003a86 <forkforkfork>:
{
    3a86:	1101                	addi	sp,sp,-32
    3a88:	ec06                	sd	ra,24(sp)
    3a8a:	e822                	sd	s0,16(sp)
    3a8c:	e426                	sd	s1,8(sp)
    3a8e:	1000                	addi	s0,sp,32
    3a90:	84aa                	mv	s1,a0
  unlink("stopforking");
    3a92:	00004517          	auipc	a0,0x4
    3a96:	abe50513          	addi	a0,a0,-1346 # 7550 <malloc+0x1d9c>
    3a9a:	00002097          	auipc	ra,0x2
    3a9e:	924080e7          	jalr	-1756(ra) # 53be <unlink>
  int pid = fork();
    3aa2:	00002097          	auipc	ra,0x2
    3aa6:	8c4080e7          	jalr	-1852(ra) # 5366 <fork>
  if(pid < 0){
    3aaa:	04054563          	bltz	a0,3af4 <forkforkfork+0x6e>
  if(pid == 0){
    3aae:	c12d                	beqz	a0,3b10 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3ab0:	4551                	li	a0,20
    3ab2:	00002097          	auipc	ra,0x2
    3ab6:	94c080e7          	jalr	-1716(ra) # 53fe <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3aba:	20200593          	li	a1,514
    3abe:	00004517          	auipc	a0,0x4
    3ac2:	a9250513          	addi	a0,a0,-1390 # 7550 <malloc+0x1d9c>
    3ac6:	00002097          	auipc	ra,0x2
    3aca:	8e8080e7          	jalr	-1816(ra) # 53ae <open>
    3ace:	00002097          	auipc	ra,0x2
    3ad2:	8c8080e7          	jalr	-1848(ra) # 5396 <close>
  wait(0);
    3ad6:	4501                	li	a0,0
    3ad8:	00002097          	auipc	ra,0x2
    3adc:	89e080e7          	jalr	-1890(ra) # 5376 <wait>
  sleep(10); // one second
    3ae0:	4529                	li	a0,10
    3ae2:	00002097          	auipc	ra,0x2
    3ae6:	91c080e7          	jalr	-1764(ra) # 53fe <sleep>
}
    3aea:	60e2                	ld	ra,24(sp)
    3aec:	6442                	ld	s0,16(sp)
    3aee:	64a2                	ld	s1,8(sp)
    3af0:	6105                	addi	sp,sp,32
    3af2:	8082                	ret
    printf("%s: fork failed", s);
    3af4:	85a6                	mv	a1,s1
    3af6:	00003517          	auipc	a0,0x3
    3afa:	ad250513          	addi	a0,a0,-1326 # 65c8 <malloc+0xe14>
    3afe:	00002097          	auipc	ra,0x2
    3b02:	bf8080e7          	jalr	-1032(ra) # 56f6 <printf>
    exit(1);
    3b06:	4505                	li	a0,1
    3b08:	00002097          	auipc	ra,0x2
    3b0c:	866080e7          	jalr	-1946(ra) # 536e <exit>
      int fd = open("stopforking", 0);
    3b10:	00004497          	auipc	s1,0x4
    3b14:	a4048493          	addi	s1,s1,-1472 # 7550 <malloc+0x1d9c>
    3b18:	4581                	li	a1,0
    3b1a:	8526                	mv	a0,s1
    3b1c:	00002097          	auipc	ra,0x2
    3b20:	892080e7          	jalr	-1902(ra) # 53ae <open>
      if(fd >= 0){
    3b24:	02055463          	bgez	a0,3b4c <forkforkfork+0xc6>
      if(fork() < 0){
    3b28:	00002097          	auipc	ra,0x2
    3b2c:	83e080e7          	jalr	-1986(ra) # 5366 <fork>
    3b30:	fe0554e3          	bgez	a0,3b18 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3b34:	20200593          	li	a1,514
    3b38:	8526                	mv	a0,s1
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	874080e7          	jalr	-1932(ra) # 53ae <open>
    3b42:	00002097          	auipc	ra,0x2
    3b46:	854080e7          	jalr	-1964(ra) # 5396 <close>
    3b4a:	b7f9                	j	3b18 <forkforkfork+0x92>
        exit(0);
    3b4c:	4501                	li	a0,0
    3b4e:	00002097          	auipc	ra,0x2
    3b52:	820080e7          	jalr	-2016(ra) # 536e <exit>

0000000000003b56 <preempt>:
{
    3b56:	7139                	addi	sp,sp,-64
    3b58:	fc06                	sd	ra,56(sp)
    3b5a:	f822                	sd	s0,48(sp)
    3b5c:	f426                	sd	s1,40(sp)
    3b5e:	f04a                	sd	s2,32(sp)
    3b60:	ec4e                	sd	s3,24(sp)
    3b62:	e852                	sd	s4,16(sp)
    3b64:	0080                	addi	s0,sp,64
    3b66:	892a                	mv	s2,a0
  pid1 = fork();
    3b68:	00001097          	auipc	ra,0x1
    3b6c:	7fe080e7          	jalr	2046(ra) # 5366 <fork>
  if(pid1 < 0) {
    3b70:	00054563          	bltz	a0,3b7a <preempt+0x24>
    3b74:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3b76:	ed19                	bnez	a0,3b94 <preempt+0x3e>
    for(;;)
    3b78:	a001                	j	3b78 <preempt+0x22>
    printf("%s: fork failed");
    3b7a:	00003517          	auipc	a0,0x3
    3b7e:	a4e50513          	addi	a0,a0,-1458 # 65c8 <malloc+0xe14>
    3b82:	00002097          	auipc	ra,0x2
    3b86:	b74080e7          	jalr	-1164(ra) # 56f6 <printf>
    exit(1);
    3b8a:	4505                	li	a0,1
    3b8c:	00001097          	auipc	ra,0x1
    3b90:	7e2080e7          	jalr	2018(ra) # 536e <exit>
  pid2 = fork();
    3b94:	00001097          	auipc	ra,0x1
    3b98:	7d2080e7          	jalr	2002(ra) # 5366 <fork>
    3b9c:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3b9e:	00054463          	bltz	a0,3ba6 <preempt+0x50>
  if(pid2 == 0)
    3ba2:	e105                	bnez	a0,3bc2 <preempt+0x6c>
    for(;;)
    3ba4:	a001                	j	3ba4 <preempt+0x4e>
    printf("%s: fork failed\n", s);
    3ba6:	85ca                	mv	a1,s2
    3ba8:	00003517          	auipc	a0,0x3
    3bac:	86050513          	addi	a0,a0,-1952 # 6408 <malloc+0xc54>
    3bb0:	00002097          	auipc	ra,0x2
    3bb4:	b46080e7          	jalr	-1210(ra) # 56f6 <printf>
    exit(1);
    3bb8:	4505                	li	a0,1
    3bba:	00001097          	auipc	ra,0x1
    3bbe:	7b4080e7          	jalr	1972(ra) # 536e <exit>
  pipe(pfds);
    3bc2:	fc840513          	addi	a0,s0,-56
    3bc6:	00001097          	auipc	ra,0x1
    3bca:	7b8080e7          	jalr	1976(ra) # 537e <pipe>
  pid3 = fork();
    3bce:	00001097          	auipc	ra,0x1
    3bd2:	798080e7          	jalr	1944(ra) # 5366 <fork>
    3bd6:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3bd8:	02054e63          	bltz	a0,3c14 <preempt+0xbe>
  if(pid3 == 0){
    3bdc:	e13d                	bnez	a0,3c42 <preempt+0xec>
    close(pfds[0]);
    3bde:	fc842503          	lw	a0,-56(s0)
    3be2:	00001097          	auipc	ra,0x1
    3be6:	7b4080e7          	jalr	1972(ra) # 5396 <close>
    if(write(pfds[1], "x", 1) != 1)
    3bea:	4605                	li	a2,1
    3bec:	00002597          	auipc	a1,0x2
    3bf0:	05458593          	addi	a1,a1,84 # 5c40 <malloc+0x48c>
    3bf4:	fcc42503          	lw	a0,-52(s0)
    3bf8:	00001097          	auipc	ra,0x1
    3bfc:	796080e7          	jalr	1942(ra) # 538e <write>
    3c00:	4785                	li	a5,1
    3c02:	02f51763          	bne	a0,a5,3c30 <preempt+0xda>
    close(pfds[1]);
    3c06:	fcc42503          	lw	a0,-52(s0)
    3c0a:	00001097          	auipc	ra,0x1
    3c0e:	78c080e7          	jalr	1932(ra) # 5396 <close>
    for(;;)
    3c12:	a001                	j	3c12 <preempt+0xbc>
     printf("%s: fork failed\n", s);
    3c14:	85ca                	mv	a1,s2
    3c16:	00002517          	auipc	a0,0x2
    3c1a:	7f250513          	addi	a0,a0,2034 # 6408 <malloc+0xc54>
    3c1e:	00002097          	auipc	ra,0x2
    3c22:	ad8080e7          	jalr	-1320(ra) # 56f6 <printf>
     exit(1);
    3c26:	4505                	li	a0,1
    3c28:	00001097          	auipc	ra,0x1
    3c2c:	746080e7          	jalr	1862(ra) # 536e <exit>
      printf("%s: preempt write error");
    3c30:	00004517          	auipc	a0,0x4
    3c34:	93050513          	addi	a0,a0,-1744 # 7560 <malloc+0x1dac>
    3c38:	00002097          	auipc	ra,0x2
    3c3c:	abe080e7          	jalr	-1346(ra) # 56f6 <printf>
    3c40:	b7d9                	j	3c06 <preempt+0xb0>
  close(pfds[1]);
    3c42:	fcc42503          	lw	a0,-52(s0)
    3c46:	00001097          	auipc	ra,0x1
    3c4a:	750080e7          	jalr	1872(ra) # 5396 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3c4e:	660d                	lui	a2,0x3
    3c50:	00008597          	auipc	a1,0x8
    3c54:	ae858593          	addi	a1,a1,-1304 # b738 <buf>
    3c58:	fc842503          	lw	a0,-56(s0)
    3c5c:	00001097          	auipc	ra,0x1
    3c60:	72a080e7          	jalr	1834(ra) # 5386 <read>
    3c64:	4785                	li	a5,1
    3c66:	02f50263          	beq	a0,a5,3c8a <preempt+0x134>
    printf("%s: preempt read error");
    3c6a:	00004517          	auipc	a0,0x4
    3c6e:	90e50513          	addi	a0,a0,-1778 # 7578 <malloc+0x1dc4>
    3c72:	00002097          	auipc	ra,0x2
    3c76:	a84080e7          	jalr	-1404(ra) # 56f6 <printf>
}
    3c7a:	70e2                	ld	ra,56(sp)
    3c7c:	7442                	ld	s0,48(sp)
    3c7e:	74a2                	ld	s1,40(sp)
    3c80:	7902                	ld	s2,32(sp)
    3c82:	69e2                	ld	s3,24(sp)
    3c84:	6a42                	ld	s4,16(sp)
    3c86:	6121                	addi	sp,sp,64
    3c88:	8082                	ret
  close(pfds[0]);
    3c8a:	fc842503          	lw	a0,-56(s0)
    3c8e:	00001097          	auipc	ra,0x1
    3c92:	708080e7          	jalr	1800(ra) # 5396 <close>
  printf("kill... ");
    3c96:	00004517          	auipc	a0,0x4
    3c9a:	8fa50513          	addi	a0,a0,-1798 # 7590 <malloc+0x1ddc>
    3c9e:	00002097          	auipc	ra,0x2
    3ca2:	a58080e7          	jalr	-1448(ra) # 56f6 <printf>
  kill(pid1);
    3ca6:	8526                	mv	a0,s1
    3ca8:	00001097          	auipc	ra,0x1
    3cac:	6f6080e7          	jalr	1782(ra) # 539e <kill>
  kill(pid2);
    3cb0:	854e                	mv	a0,s3
    3cb2:	00001097          	auipc	ra,0x1
    3cb6:	6ec080e7          	jalr	1772(ra) # 539e <kill>
  kill(pid3);
    3cba:	8552                	mv	a0,s4
    3cbc:	00001097          	auipc	ra,0x1
    3cc0:	6e2080e7          	jalr	1762(ra) # 539e <kill>
  printf("wait... ");
    3cc4:	00004517          	auipc	a0,0x4
    3cc8:	8dc50513          	addi	a0,a0,-1828 # 75a0 <malloc+0x1dec>
    3ccc:	00002097          	auipc	ra,0x2
    3cd0:	a2a080e7          	jalr	-1494(ra) # 56f6 <printf>
  wait(0);
    3cd4:	4501                	li	a0,0
    3cd6:	00001097          	auipc	ra,0x1
    3cda:	6a0080e7          	jalr	1696(ra) # 5376 <wait>
  wait(0);
    3cde:	4501                	li	a0,0
    3ce0:	00001097          	auipc	ra,0x1
    3ce4:	696080e7          	jalr	1686(ra) # 5376 <wait>
  wait(0);
    3ce8:	4501                	li	a0,0
    3cea:	00001097          	auipc	ra,0x1
    3cee:	68c080e7          	jalr	1676(ra) # 5376 <wait>
    3cf2:	b761                	j	3c7a <preempt+0x124>

0000000000003cf4 <sbrkfail>:
{
    3cf4:	7119                	addi	sp,sp,-128
    3cf6:	fc86                	sd	ra,120(sp)
    3cf8:	f8a2                	sd	s0,112(sp)
    3cfa:	f4a6                	sd	s1,104(sp)
    3cfc:	f0ca                	sd	s2,96(sp)
    3cfe:	ecce                	sd	s3,88(sp)
    3d00:	e8d2                	sd	s4,80(sp)
    3d02:	e4d6                	sd	s5,72(sp)
    3d04:	0100                	addi	s0,sp,128
    3d06:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    3d08:	fb040513          	addi	a0,s0,-80
    3d0c:	00001097          	auipc	ra,0x1
    3d10:	672080e7          	jalr	1650(ra) # 537e <pipe>
    3d14:	e901                	bnez	a0,3d24 <sbrkfail+0x30>
    3d16:	f8040493          	addi	s1,s0,-128
    3d1a:	fa840993          	addi	s3,s0,-88
    3d1e:	8926                	mv	s2,s1
    if(pids[i] != -1)
    3d20:	5a7d                	li	s4,-1
    3d22:	a085                	j	3d82 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    3d24:	85d6                	mv	a1,s5
    3d26:	00002517          	auipc	a0,0x2
    3d2a:	7ea50513          	addi	a0,a0,2026 # 6510 <malloc+0xd5c>
    3d2e:	00002097          	auipc	ra,0x2
    3d32:	9c8080e7          	jalr	-1592(ra) # 56f6 <printf>
    exit(1);
    3d36:	4505                	li	a0,1
    3d38:	00001097          	auipc	ra,0x1
    3d3c:	636080e7          	jalr	1590(ra) # 536e <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3d40:	00001097          	auipc	ra,0x1
    3d44:	6b6080e7          	jalr	1718(ra) # 53f6 <sbrk>
    3d48:	064007b7          	lui	a5,0x6400
    3d4c:	40a7853b          	subw	a0,a5,a0
    3d50:	00001097          	auipc	ra,0x1
    3d54:	6a6080e7          	jalr	1702(ra) # 53f6 <sbrk>
      write(fds[1], "x", 1);
    3d58:	4605                	li	a2,1
    3d5a:	00002597          	auipc	a1,0x2
    3d5e:	ee658593          	addi	a1,a1,-282 # 5c40 <malloc+0x48c>
    3d62:	fb442503          	lw	a0,-76(s0)
    3d66:	00001097          	auipc	ra,0x1
    3d6a:	628080e7          	jalr	1576(ra) # 538e <write>
      for(;;) sleep(1000);
    3d6e:	3e800513          	li	a0,1000
    3d72:	00001097          	auipc	ra,0x1
    3d76:	68c080e7          	jalr	1676(ra) # 53fe <sleep>
    3d7a:	bfd5                	j	3d6e <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3d7c:	0911                	addi	s2,s2,4
    3d7e:	03390563          	beq	s2,s3,3da8 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    3d82:	00001097          	auipc	ra,0x1
    3d86:	5e4080e7          	jalr	1508(ra) # 5366 <fork>
    3d8a:	00a92023          	sw	a0,0(s2)
    3d8e:	d94d                	beqz	a0,3d40 <sbrkfail+0x4c>
    if(pids[i] != -1)
    3d90:	ff4506e3          	beq	a0,s4,3d7c <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    3d94:	4605                	li	a2,1
    3d96:	faf40593          	addi	a1,s0,-81
    3d9a:	fb042503          	lw	a0,-80(s0)
    3d9e:	00001097          	auipc	ra,0x1
    3da2:	5e8080e7          	jalr	1512(ra) # 5386 <read>
    3da6:	bfd9                	j	3d7c <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    3da8:	6505                	lui	a0,0x1
    3daa:	00001097          	auipc	ra,0x1
    3dae:	64c080e7          	jalr	1612(ra) # 53f6 <sbrk>
    3db2:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    3db4:	597d                	li	s2,-1
    3db6:	a021                	j	3dbe <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3db8:	0491                	addi	s1,s1,4
    3dba:	01348f63          	beq	s1,s3,3dd8 <sbrkfail+0xe4>
    if(pids[i] == -1)
    3dbe:	4088                	lw	a0,0(s1)
    3dc0:	ff250ce3          	beq	a0,s2,3db8 <sbrkfail+0xc4>
    kill(pids[i]);
    3dc4:	00001097          	auipc	ra,0x1
    3dc8:	5da080e7          	jalr	1498(ra) # 539e <kill>
    wait(0);
    3dcc:	4501                	li	a0,0
    3dce:	00001097          	auipc	ra,0x1
    3dd2:	5a8080e7          	jalr	1448(ra) # 5376 <wait>
    3dd6:	b7cd                	j	3db8 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    3dd8:	57fd                	li	a5,-1
    3dda:	04fa0163          	beq	s4,a5,3e1c <sbrkfail+0x128>
  pid = fork();
    3dde:	00001097          	auipc	ra,0x1
    3de2:	588080e7          	jalr	1416(ra) # 5366 <fork>
    3de6:	84aa                	mv	s1,a0
  if(pid < 0){
    3de8:	04054863          	bltz	a0,3e38 <sbrkfail+0x144>
  if(pid == 0){
    3dec:	c525                	beqz	a0,3e54 <sbrkfail+0x160>
  wait(&xstatus);
    3dee:	fbc40513          	addi	a0,s0,-68
    3df2:	00001097          	auipc	ra,0x1
    3df6:	584080e7          	jalr	1412(ra) # 5376 <wait>
  if(xstatus != -1 && xstatus != 2)
    3dfa:	fbc42783          	lw	a5,-68(s0)
    3dfe:	577d                	li	a4,-1
    3e00:	00e78563          	beq	a5,a4,3e0a <sbrkfail+0x116>
    3e04:	4709                	li	a4,2
    3e06:	08e79c63          	bne	a5,a4,3e9e <sbrkfail+0x1aa>
}
    3e0a:	70e6                	ld	ra,120(sp)
    3e0c:	7446                	ld	s0,112(sp)
    3e0e:	74a6                	ld	s1,104(sp)
    3e10:	7906                	ld	s2,96(sp)
    3e12:	69e6                	ld	s3,88(sp)
    3e14:	6a46                	ld	s4,80(sp)
    3e16:	6aa6                	ld	s5,72(sp)
    3e18:	6109                	addi	sp,sp,128
    3e1a:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3e1c:	85d6                	mv	a1,s5
    3e1e:	00003517          	auipc	a0,0x3
    3e22:	79250513          	addi	a0,a0,1938 # 75b0 <malloc+0x1dfc>
    3e26:	00002097          	auipc	ra,0x2
    3e2a:	8d0080e7          	jalr	-1840(ra) # 56f6 <printf>
    exit(1);
    3e2e:	4505                	li	a0,1
    3e30:	00001097          	auipc	ra,0x1
    3e34:	53e080e7          	jalr	1342(ra) # 536e <exit>
    printf("%s: fork failed\n", s);
    3e38:	85d6                	mv	a1,s5
    3e3a:	00002517          	auipc	a0,0x2
    3e3e:	5ce50513          	addi	a0,a0,1486 # 6408 <malloc+0xc54>
    3e42:	00002097          	auipc	ra,0x2
    3e46:	8b4080e7          	jalr	-1868(ra) # 56f6 <printf>
    exit(1);
    3e4a:	4505                	li	a0,1
    3e4c:	00001097          	auipc	ra,0x1
    3e50:	522080e7          	jalr	1314(ra) # 536e <exit>
    a = sbrk(0);
    3e54:	4501                	li	a0,0
    3e56:	00001097          	auipc	ra,0x1
    3e5a:	5a0080e7          	jalr	1440(ra) # 53f6 <sbrk>
    3e5e:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3e60:	3e800537          	lui	a0,0x3e800
    3e64:	00001097          	auipc	ra,0x1
    3e68:	592080e7          	jalr	1426(ra) # 53f6 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3e6c:	87ca                	mv	a5,s2
    3e6e:	3e800737          	lui	a4,0x3e800
    3e72:	993a                	add	s2,s2,a4
    3e74:	6705                	lui	a4,0x1
      n += *(a+i);
    3e76:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f18b8>
    3e7a:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3e7c:	97ba                	add	a5,a5,a4
    3e7e:	ff279ce3          	bne	a5,s2,3e76 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    3e82:	85a6                	mv	a1,s1
    3e84:	00003517          	auipc	a0,0x3
    3e88:	74c50513          	addi	a0,a0,1868 # 75d0 <malloc+0x1e1c>
    3e8c:	00002097          	auipc	ra,0x2
    3e90:	86a080e7          	jalr	-1942(ra) # 56f6 <printf>
    exit(1);
    3e94:	4505                	li	a0,1
    3e96:	00001097          	auipc	ra,0x1
    3e9a:	4d8080e7          	jalr	1240(ra) # 536e <exit>
    exit(1);
    3e9e:	4505                	li	a0,1
    3ea0:	00001097          	auipc	ra,0x1
    3ea4:	4ce080e7          	jalr	1230(ra) # 536e <exit>

0000000000003ea8 <reparent>:
{
    3ea8:	7179                	addi	sp,sp,-48
    3eaa:	f406                	sd	ra,40(sp)
    3eac:	f022                	sd	s0,32(sp)
    3eae:	ec26                	sd	s1,24(sp)
    3eb0:	e84a                	sd	s2,16(sp)
    3eb2:	e44e                	sd	s3,8(sp)
    3eb4:	e052                	sd	s4,0(sp)
    3eb6:	1800                	addi	s0,sp,48
    3eb8:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3eba:	00001097          	auipc	ra,0x1
    3ebe:	534080e7          	jalr	1332(ra) # 53ee <getpid>
    3ec2:	8a2a                	mv	s4,a0
    3ec4:	0c800913          	li	s2,200
    int pid = fork();
    3ec8:	00001097          	auipc	ra,0x1
    3ecc:	49e080e7          	jalr	1182(ra) # 5366 <fork>
    3ed0:	84aa                	mv	s1,a0
    if(pid < 0){
    3ed2:	02054263          	bltz	a0,3ef6 <reparent+0x4e>
    if(pid){
    3ed6:	cd21                	beqz	a0,3f2e <reparent+0x86>
      if(wait(0) != pid){
    3ed8:	4501                	li	a0,0
    3eda:	00001097          	auipc	ra,0x1
    3ede:	49c080e7          	jalr	1180(ra) # 5376 <wait>
    3ee2:	02951863          	bne	a0,s1,3f12 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    3ee6:	397d                	addiw	s2,s2,-1
    3ee8:	fe0910e3          	bnez	s2,3ec8 <reparent+0x20>
  exit(0);
    3eec:	4501                	li	a0,0
    3eee:	00001097          	auipc	ra,0x1
    3ef2:	480080e7          	jalr	1152(ra) # 536e <exit>
      printf("%s: fork failed\n", s);
    3ef6:	85ce                	mv	a1,s3
    3ef8:	00002517          	auipc	a0,0x2
    3efc:	51050513          	addi	a0,a0,1296 # 6408 <malloc+0xc54>
    3f00:	00001097          	auipc	ra,0x1
    3f04:	7f6080e7          	jalr	2038(ra) # 56f6 <printf>
      exit(1);
    3f08:	4505                	li	a0,1
    3f0a:	00001097          	auipc	ra,0x1
    3f0e:	464080e7          	jalr	1124(ra) # 536e <exit>
        printf("%s: wait wrong pid\n", s);
    3f12:	85ce                	mv	a1,s3
    3f14:	00002517          	auipc	a0,0x2
    3f18:	67c50513          	addi	a0,a0,1660 # 6590 <malloc+0xddc>
    3f1c:	00001097          	auipc	ra,0x1
    3f20:	7da080e7          	jalr	2010(ra) # 56f6 <printf>
        exit(1);
    3f24:	4505                	li	a0,1
    3f26:	00001097          	auipc	ra,0x1
    3f2a:	448080e7          	jalr	1096(ra) # 536e <exit>
      int pid2 = fork();
    3f2e:	00001097          	auipc	ra,0x1
    3f32:	438080e7          	jalr	1080(ra) # 5366 <fork>
      if(pid2 < 0){
    3f36:	00054763          	bltz	a0,3f44 <reparent+0x9c>
      exit(0);
    3f3a:	4501                	li	a0,0
    3f3c:	00001097          	auipc	ra,0x1
    3f40:	432080e7          	jalr	1074(ra) # 536e <exit>
        kill(master_pid);
    3f44:	8552                	mv	a0,s4
    3f46:	00001097          	auipc	ra,0x1
    3f4a:	458080e7          	jalr	1112(ra) # 539e <kill>
        exit(1);
    3f4e:	4505                	li	a0,1
    3f50:	00001097          	auipc	ra,0x1
    3f54:	41e080e7          	jalr	1054(ra) # 536e <exit>

0000000000003f58 <mem>:
{
    3f58:	7139                	addi	sp,sp,-64
    3f5a:	fc06                	sd	ra,56(sp)
    3f5c:	f822                	sd	s0,48(sp)
    3f5e:	f426                	sd	s1,40(sp)
    3f60:	f04a                	sd	s2,32(sp)
    3f62:	ec4e                	sd	s3,24(sp)
    3f64:	0080                	addi	s0,sp,64
    3f66:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3f68:	00001097          	auipc	ra,0x1
    3f6c:	3fe080e7          	jalr	1022(ra) # 5366 <fork>
    m1 = 0;
    3f70:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3f72:	6909                	lui	s2,0x2
    3f74:	71190913          	addi	s2,s2,1809 # 2711 <sbrkarg+0xbf>
  if((pid = fork()) == 0){
    3f78:	c115                	beqz	a0,3f9c <mem+0x44>
    wait(&xstatus);
    3f7a:	fcc40513          	addi	a0,s0,-52
    3f7e:	00001097          	auipc	ra,0x1
    3f82:	3f8080e7          	jalr	1016(ra) # 5376 <wait>
    if(xstatus == -1){
    3f86:	fcc42503          	lw	a0,-52(s0)
    3f8a:	57fd                	li	a5,-1
    3f8c:	06f50363          	beq	a0,a5,3ff2 <mem+0x9a>
    exit(xstatus);
    3f90:	00001097          	auipc	ra,0x1
    3f94:	3de080e7          	jalr	990(ra) # 536e <exit>
      *(char**)m2 = m1;
    3f98:	e104                	sd	s1,0(a0)
      m1 = m2;
    3f9a:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3f9c:	854a                	mv	a0,s2
    3f9e:	00002097          	auipc	ra,0x2
    3fa2:	816080e7          	jalr	-2026(ra) # 57b4 <malloc>
    3fa6:	f96d                	bnez	a0,3f98 <mem+0x40>
    while(m1){
    3fa8:	c881                	beqz	s1,3fb8 <mem+0x60>
      m2 = *(char**)m1;
    3faa:	8526                	mv	a0,s1
    3fac:	6084                	ld	s1,0(s1)
      free(m1);
    3fae:	00001097          	auipc	ra,0x1
    3fb2:	77e080e7          	jalr	1918(ra) # 572c <free>
    while(m1){
    3fb6:	f8f5                	bnez	s1,3faa <mem+0x52>
    m1 = malloc(1024*20);
    3fb8:	6515                	lui	a0,0x5
    3fba:	00001097          	auipc	ra,0x1
    3fbe:	7fa080e7          	jalr	2042(ra) # 57b4 <malloc>
    if(m1 == 0){
    3fc2:	c911                	beqz	a0,3fd6 <mem+0x7e>
    free(m1);
    3fc4:	00001097          	auipc	ra,0x1
    3fc8:	768080e7          	jalr	1896(ra) # 572c <free>
    exit(0);
    3fcc:	4501                	li	a0,0
    3fce:	00001097          	auipc	ra,0x1
    3fd2:	3a0080e7          	jalr	928(ra) # 536e <exit>
      printf("couldn't allocate mem?!!\n", s);
    3fd6:	85ce                	mv	a1,s3
    3fd8:	00003517          	auipc	a0,0x3
    3fdc:	62850513          	addi	a0,a0,1576 # 7600 <malloc+0x1e4c>
    3fe0:	00001097          	auipc	ra,0x1
    3fe4:	716080e7          	jalr	1814(ra) # 56f6 <printf>
      exit(1);
    3fe8:	4505                	li	a0,1
    3fea:	00001097          	auipc	ra,0x1
    3fee:	384080e7          	jalr	900(ra) # 536e <exit>
      exit(0);
    3ff2:	4501                	li	a0,0
    3ff4:	00001097          	auipc	ra,0x1
    3ff8:	37a080e7          	jalr	890(ra) # 536e <exit>

0000000000003ffc <sharedfd>:
{
    3ffc:	7159                	addi	sp,sp,-112
    3ffe:	f486                	sd	ra,104(sp)
    4000:	f0a2                	sd	s0,96(sp)
    4002:	eca6                	sd	s1,88(sp)
    4004:	e8ca                	sd	s2,80(sp)
    4006:	e4ce                	sd	s3,72(sp)
    4008:	e0d2                	sd	s4,64(sp)
    400a:	fc56                	sd	s5,56(sp)
    400c:	f85a                	sd	s6,48(sp)
    400e:	f45e                	sd	s7,40(sp)
    4010:	1880                	addi	s0,sp,112
    4012:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4014:	00002517          	auipc	a0,0x2
    4018:	a0450513          	addi	a0,a0,-1532 # 5a18 <malloc+0x264>
    401c:	00001097          	auipc	ra,0x1
    4020:	3a2080e7          	jalr	930(ra) # 53be <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4024:	20200593          	li	a1,514
    4028:	00002517          	auipc	a0,0x2
    402c:	9f050513          	addi	a0,a0,-1552 # 5a18 <malloc+0x264>
    4030:	00001097          	auipc	ra,0x1
    4034:	37e080e7          	jalr	894(ra) # 53ae <open>
  if(fd < 0){
    4038:	04054a63          	bltz	a0,408c <sharedfd+0x90>
    403c:	892a                	mv	s2,a0
  pid = fork();
    403e:	00001097          	auipc	ra,0x1
    4042:	328080e7          	jalr	808(ra) # 5366 <fork>
    4046:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4048:	06300593          	li	a1,99
    404c:	c119                	beqz	a0,4052 <sharedfd+0x56>
    404e:	07000593          	li	a1,112
    4052:	4629                	li	a2,10
    4054:	fa040513          	addi	a0,s0,-96
    4058:	00001097          	auipc	ra,0x1
    405c:	11a080e7          	jalr	282(ra) # 5172 <memset>
    4060:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4064:	4629                	li	a2,10
    4066:	fa040593          	addi	a1,s0,-96
    406a:	854a                	mv	a0,s2
    406c:	00001097          	auipc	ra,0x1
    4070:	322080e7          	jalr	802(ra) # 538e <write>
    4074:	47a9                	li	a5,10
    4076:	02f51963          	bne	a0,a5,40a8 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    407a:	34fd                	addiw	s1,s1,-1
    407c:	f4e5                	bnez	s1,4064 <sharedfd+0x68>
  if(pid == 0) {
    407e:	04099363          	bnez	s3,40c4 <sharedfd+0xc8>
    exit(0);
    4082:	4501                	li	a0,0
    4084:	00001097          	auipc	ra,0x1
    4088:	2ea080e7          	jalr	746(ra) # 536e <exit>
    printf("%s: cannot open sharedfd for writing", s);
    408c:	85d2                	mv	a1,s4
    408e:	00003517          	auipc	a0,0x3
    4092:	59250513          	addi	a0,a0,1426 # 7620 <malloc+0x1e6c>
    4096:	00001097          	auipc	ra,0x1
    409a:	660080e7          	jalr	1632(ra) # 56f6 <printf>
    exit(1);
    409e:	4505                	li	a0,1
    40a0:	00001097          	auipc	ra,0x1
    40a4:	2ce080e7          	jalr	718(ra) # 536e <exit>
      printf("%s: write sharedfd failed\n", s);
    40a8:	85d2                	mv	a1,s4
    40aa:	00003517          	auipc	a0,0x3
    40ae:	59e50513          	addi	a0,a0,1438 # 7648 <malloc+0x1e94>
    40b2:	00001097          	auipc	ra,0x1
    40b6:	644080e7          	jalr	1604(ra) # 56f6 <printf>
      exit(1);
    40ba:	4505                	li	a0,1
    40bc:	00001097          	auipc	ra,0x1
    40c0:	2b2080e7          	jalr	690(ra) # 536e <exit>
    wait(&xstatus);
    40c4:	f9c40513          	addi	a0,s0,-100
    40c8:	00001097          	auipc	ra,0x1
    40cc:	2ae080e7          	jalr	686(ra) # 5376 <wait>
    if(xstatus != 0)
    40d0:	f9c42983          	lw	s3,-100(s0)
    40d4:	00098763          	beqz	s3,40e2 <sharedfd+0xe6>
      exit(xstatus);
    40d8:	854e                	mv	a0,s3
    40da:	00001097          	auipc	ra,0x1
    40de:	294080e7          	jalr	660(ra) # 536e <exit>
  close(fd);
    40e2:	854a                	mv	a0,s2
    40e4:	00001097          	auipc	ra,0x1
    40e8:	2b2080e7          	jalr	690(ra) # 5396 <close>
  fd = open("sharedfd", 0);
    40ec:	4581                	li	a1,0
    40ee:	00002517          	auipc	a0,0x2
    40f2:	92a50513          	addi	a0,a0,-1750 # 5a18 <malloc+0x264>
    40f6:	00001097          	auipc	ra,0x1
    40fa:	2b8080e7          	jalr	696(ra) # 53ae <open>
    40fe:	8baa                	mv	s7,a0
  nc = np = 0;
    4100:	8ace                	mv	s5,s3
  if(fd < 0){
    4102:	02054563          	bltz	a0,412c <sharedfd+0x130>
    4106:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    410a:	06300493          	li	s1,99
      if(buf[i] == 'p')
    410e:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4112:	4629                	li	a2,10
    4114:	fa040593          	addi	a1,s0,-96
    4118:	855e                	mv	a0,s7
    411a:	00001097          	auipc	ra,0x1
    411e:	26c080e7          	jalr	620(ra) # 5386 <read>
    4122:	02a05f63          	blez	a0,4160 <sharedfd+0x164>
    4126:	fa040793          	addi	a5,s0,-96
    412a:	a01d                	j	4150 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    412c:	85d2                	mv	a1,s4
    412e:	00003517          	auipc	a0,0x3
    4132:	53a50513          	addi	a0,a0,1338 # 7668 <malloc+0x1eb4>
    4136:	00001097          	auipc	ra,0x1
    413a:	5c0080e7          	jalr	1472(ra) # 56f6 <printf>
    exit(1);
    413e:	4505                	li	a0,1
    4140:	00001097          	auipc	ra,0x1
    4144:	22e080e7          	jalr	558(ra) # 536e <exit>
        nc++;
    4148:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    414a:	0785                	addi	a5,a5,1
    414c:	fd2783e3          	beq	a5,s2,4112 <sharedfd+0x116>
      if(buf[i] == 'c')
    4150:	0007c703          	lbu	a4,0(a5)
    4154:	fe970ae3          	beq	a4,s1,4148 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4158:	ff6719e3          	bne	a4,s6,414a <sharedfd+0x14e>
        np++;
    415c:	2a85                	addiw	s5,s5,1
    415e:	b7f5                	j	414a <sharedfd+0x14e>
  close(fd);
    4160:	855e                	mv	a0,s7
    4162:	00001097          	auipc	ra,0x1
    4166:	234080e7          	jalr	564(ra) # 5396 <close>
  unlink("sharedfd");
    416a:	00002517          	auipc	a0,0x2
    416e:	8ae50513          	addi	a0,a0,-1874 # 5a18 <malloc+0x264>
    4172:	00001097          	auipc	ra,0x1
    4176:	24c080e7          	jalr	588(ra) # 53be <unlink>
  if(nc == N*SZ && np == N*SZ){
    417a:	6789                	lui	a5,0x2
    417c:	71078793          	addi	a5,a5,1808 # 2710 <sbrkarg+0xbe>
    4180:	00f99763          	bne	s3,a5,418e <sharedfd+0x192>
    4184:	6789                	lui	a5,0x2
    4186:	71078793          	addi	a5,a5,1808 # 2710 <sbrkarg+0xbe>
    418a:	02fa8063          	beq	s5,a5,41aa <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    418e:	85d2                	mv	a1,s4
    4190:	00003517          	auipc	a0,0x3
    4194:	50050513          	addi	a0,a0,1280 # 7690 <malloc+0x1edc>
    4198:	00001097          	auipc	ra,0x1
    419c:	55e080e7          	jalr	1374(ra) # 56f6 <printf>
    exit(1);
    41a0:	4505                	li	a0,1
    41a2:	00001097          	auipc	ra,0x1
    41a6:	1cc080e7          	jalr	460(ra) # 536e <exit>
    exit(0);
    41aa:	4501                	li	a0,0
    41ac:	00001097          	auipc	ra,0x1
    41b0:	1c2080e7          	jalr	450(ra) # 536e <exit>

00000000000041b4 <fourfiles>:
{
    41b4:	7171                	addi	sp,sp,-176
    41b6:	f506                	sd	ra,168(sp)
    41b8:	f122                	sd	s0,160(sp)
    41ba:	ed26                	sd	s1,152(sp)
    41bc:	e94a                	sd	s2,144(sp)
    41be:	e54e                	sd	s3,136(sp)
    41c0:	e152                	sd	s4,128(sp)
    41c2:	fcd6                	sd	s5,120(sp)
    41c4:	f8da                	sd	s6,112(sp)
    41c6:	f4de                	sd	s7,104(sp)
    41c8:	f0e2                	sd	s8,96(sp)
    41ca:	ece6                	sd	s9,88(sp)
    41cc:	e8ea                	sd	s10,80(sp)
    41ce:	e4ee                	sd	s11,72(sp)
    41d0:	1900                	addi	s0,sp,176
    41d2:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    41d6:	00001797          	auipc	a5,0x1
    41da:	6c278793          	addi	a5,a5,1730 # 5898 <malloc+0xe4>
    41de:	f6f43823          	sd	a5,-144(s0)
    41e2:	00001797          	auipc	a5,0x1
    41e6:	6be78793          	addi	a5,a5,1726 # 58a0 <malloc+0xec>
    41ea:	f6f43c23          	sd	a5,-136(s0)
    41ee:	00001797          	auipc	a5,0x1
    41f2:	6ba78793          	addi	a5,a5,1722 # 58a8 <malloc+0xf4>
    41f6:	f8f43023          	sd	a5,-128(s0)
    41fa:	00001797          	auipc	a5,0x1
    41fe:	6b678793          	addi	a5,a5,1718 # 58b0 <malloc+0xfc>
    4202:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4206:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    420a:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    420c:	4481                	li	s1,0
    420e:	4a11                	li	s4,4
    fname = names[pi];
    4210:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4214:	854e                	mv	a0,s3
    4216:	00001097          	auipc	ra,0x1
    421a:	1a8080e7          	jalr	424(ra) # 53be <unlink>
    pid = fork();
    421e:	00001097          	auipc	ra,0x1
    4222:	148080e7          	jalr	328(ra) # 5366 <fork>
    if(pid < 0){
    4226:	04054463          	bltz	a0,426e <fourfiles+0xba>
    if(pid == 0){
    422a:	c12d                	beqz	a0,428c <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    422c:	2485                	addiw	s1,s1,1
    422e:	0921                	addi	s2,s2,8
    4230:	ff4490e3          	bne	s1,s4,4210 <fourfiles+0x5c>
    4234:	4491                	li	s1,4
    wait(&xstatus);
    4236:	f6c40513          	addi	a0,s0,-148
    423a:	00001097          	auipc	ra,0x1
    423e:	13c080e7          	jalr	316(ra) # 5376 <wait>
    if(xstatus != 0)
    4242:	f6c42b03          	lw	s6,-148(s0)
    4246:	0c0b1e63          	bnez	s6,4322 <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    424a:	34fd                	addiw	s1,s1,-1
    424c:	f4ed                	bnez	s1,4236 <fourfiles+0x82>
    424e:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4252:	00007a17          	auipc	s4,0x7
    4256:	4e6a0a13          	addi	s4,s4,1254 # b738 <buf>
    425a:	00007a97          	auipc	s5,0x7
    425e:	4dfa8a93          	addi	s5,s5,1247 # b739 <buf+0x1>
    if(total != N*SZ){
    4262:	6d85                	lui	s11,0x1
    4264:	770d8d93          	addi	s11,s11,1904 # 1770 <pipe1+0x2a>
  for(i = 0; i < NCHILD; i++){
    4268:	03400d13          	li	s10,52
    426c:	aa1d                	j	43a2 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    426e:	f5843583          	ld	a1,-168(s0)
    4272:	00002517          	auipc	a0,0x2
    4276:	58650513          	addi	a0,a0,1414 # 67f8 <malloc+0x1044>
    427a:	00001097          	auipc	ra,0x1
    427e:	47c080e7          	jalr	1148(ra) # 56f6 <printf>
      exit(1);
    4282:	4505                	li	a0,1
    4284:	00001097          	auipc	ra,0x1
    4288:	0ea080e7          	jalr	234(ra) # 536e <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    428c:	20200593          	li	a1,514
    4290:	854e                	mv	a0,s3
    4292:	00001097          	auipc	ra,0x1
    4296:	11c080e7          	jalr	284(ra) # 53ae <open>
    429a:	892a                	mv	s2,a0
      if(fd < 0){
    429c:	04054763          	bltz	a0,42ea <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    42a0:	1f400613          	li	a2,500
    42a4:	0304859b          	addiw	a1,s1,48
    42a8:	00007517          	auipc	a0,0x7
    42ac:	49050513          	addi	a0,a0,1168 # b738 <buf>
    42b0:	00001097          	auipc	ra,0x1
    42b4:	ec2080e7          	jalr	-318(ra) # 5172 <memset>
    42b8:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    42ba:	00007997          	auipc	s3,0x7
    42be:	47e98993          	addi	s3,s3,1150 # b738 <buf>
    42c2:	1f400613          	li	a2,500
    42c6:	85ce                	mv	a1,s3
    42c8:	854a                	mv	a0,s2
    42ca:	00001097          	auipc	ra,0x1
    42ce:	0c4080e7          	jalr	196(ra) # 538e <write>
    42d2:	85aa                	mv	a1,a0
    42d4:	1f400793          	li	a5,500
    42d8:	02f51863          	bne	a0,a5,4308 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    42dc:	34fd                	addiw	s1,s1,-1
    42de:	f0f5                	bnez	s1,42c2 <fourfiles+0x10e>
      exit(0);
    42e0:	4501                	li	a0,0
    42e2:	00001097          	auipc	ra,0x1
    42e6:	08c080e7          	jalr	140(ra) # 536e <exit>
        printf("create failed\n", s);
    42ea:	f5843583          	ld	a1,-168(s0)
    42ee:	00003517          	auipc	a0,0x3
    42f2:	3ba50513          	addi	a0,a0,954 # 76a8 <malloc+0x1ef4>
    42f6:	00001097          	auipc	ra,0x1
    42fa:	400080e7          	jalr	1024(ra) # 56f6 <printf>
        exit(1);
    42fe:	4505                	li	a0,1
    4300:	00001097          	auipc	ra,0x1
    4304:	06e080e7          	jalr	110(ra) # 536e <exit>
          printf("write failed %d\n", n);
    4308:	00003517          	auipc	a0,0x3
    430c:	3b050513          	addi	a0,a0,944 # 76b8 <malloc+0x1f04>
    4310:	00001097          	auipc	ra,0x1
    4314:	3e6080e7          	jalr	998(ra) # 56f6 <printf>
          exit(1);
    4318:	4505                	li	a0,1
    431a:	00001097          	auipc	ra,0x1
    431e:	054080e7          	jalr	84(ra) # 536e <exit>
      exit(xstatus);
    4322:	855a                	mv	a0,s6
    4324:	00001097          	auipc	ra,0x1
    4328:	04a080e7          	jalr	74(ra) # 536e <exit>
          printf("wrong char\n", s);
    432c:	f5843583          	ld	a1,-168(s0)
    4330:	00003517          	auipc	a0,0x3
    4334:	3a050513          	addi	a0,a0,928 # 76d0 <malloc+0x1f1c>
    4338:	00001097          	auipc	ra,0x1
    433c:	3be080e7          	jalr	958(ra) # 56f6 <printf>
          exit(1);
    4340:	4505                	li	a0,1
    4342:	00001097          	auipc	ra,0x1
    4346:	02c080e7          	jalr	44(ra) # 536e <exit>
      total += n;
    434a:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    434e:	660d                	lui	a2,0x3
    4350:	85d2                	mv	a1,s4
    4352:	854e                	mv	a0,s3
    4354:	00001097          	auipc	ra,0x1
    4358:	032080e7          	jalr	50(ra) # 5386 <read>
    435c:	02a05363          	blez	a0,4382 <fourfiles+0x1ce>
    4360:	00007797          	auipc	a5,0x7
    4364:	3d878793          	addi	a5,a5,984 # b738 <buf>
    4368:	fff5069b          	addiw	a3,a0,-1
    436c:	1682                	slli	a3,a3,0x20
    436e:	9281                	srli	a3,a3,0x20
    4370:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4372:	0007c703          	lbu	a4,0(a5)
    4376:	fa971be3          	bne	a4,s1,432c <fourfiles+0x178>
      for(j = 0; j < n; j++){
    437a:	0785                	addi	a5,a5,1
    437c:	fed79be3          	bne	a5,a3,4372 <fourfiles+0x1be>
    4380:	b7e9                	j	434a <fourfiles+0x196>
    close(fd);
    4382:	854e                	mv	a0,s3
    4384:	00001097          	auipc	ra,0x1
    4388:	012080e7          	jalr	18(ra) # 5396 <close>
    if(total != N*SZ){
    438c:	03b91863          	bne	s2,s11,43bc <fourfiles+0x208>
    unlink(fname);
    4390:	8566                	mv	a0,s9
    4392:	00001097          	auipc	ra,0x1
    4396:	02c080e7          	jalr	44(ra) # 53be <unlink>
  for(i = 0; i < NCHILD; i++){
    439a:	0c21                	addi	s8,s8,8
    439c:	2b85                	addiw	s7,s7,1
    439e:	03ab8d63          	beq	s7,s10,43d8 <fourfiles+0x224>
    fname = names[i];
    43a2:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    43a6:	4581                	li	a1,0
    43a8:	8566                	mv	a0,s9
    43aa:	00001097          	auipc	ra,0x1
    43ae:	004080e7          	jalr	4(ra) # 53ae <open>
    43b2:	89aa                	mv	s3,a0
    total = 0;
    43b4:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    43b6:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    43ba:	bf51                	j	434e <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    43bc:	85ca                	mv	a1,s2
    43be:	00003517          	auipc	a0,0x3
    43c2:	32250513          	addi	a0,a0,802 # 76e0 <malloc+0x1f2c>
    43c6:	00001097          	auipc	ra,0x1
    43ca:	330080e7          	jalr	816(ra) # 56f6 <printf>
      exit(1);
    43ce:	4505                	li	a0,1
    43d0:	00001097          	auipc	ra,0x1
    43d4:	f9e080e7          	jalr	-98(ra) # 536e <exit>
}
    43d8:	70aa                	ld	ra,168(sp)
    43da:	740a                	ld	s0,160(sp)
    43dc:	64ea                	ld	s1,152(sp)
    43de:	694a                	ld	s2,144(sp)
    43e0:	69aa                	ld	s3,136(sp)
    43e2:	6a0a                	ld	s4,128(sp)
    43e4:	7ae6                	ld	s5,120(sp)
    43e6:	7b46                	ld	s6,112(sp)
    43e8:	7ba6                	ld	s7,104(sp)
    43ea:	7c06                	ld	s8,96(sp)
    43ec:	6ce6                	ld	s9,88(sp)
    43ee:	6d46                	ld	s10,80(sp)
    43f0:	6da6                	ld	s11,72(sp)
    43f2:	614d                	addi	sp,sp,176
    43f4:	8082                	ret

00000000000043f6 <concreate>:
{
    43f6:	7135                	addi	sp,sp,-160
    43f8:	ed06                	sd	ra,152(sp)
    43fa:	e922                	sd	s0,144(sp)
    43fc:	e526                	sd	s1,136(sp)
    43fe:	e14a                	sd	s2,128(sp)
    4400:	fcce                	sd	s3,120(sp)
    4402:	f8d2                	sd	s4,112(sp)
    4404:	f4d6                	sd	s5,104(sp)
    4406:	f0da                	sd	s6,96(sp)
    4408:	ecde                	sd	s7,88(sp)
    440a:	1100                	addi	s0,sp,160
    440c:	89aa                	mv	s3,a0
  file[0] = 'C';
    440e:	04300793          	li	a5,67
    4412:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4416:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    441a:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    441c:	4b0d                	li	s6,3
    441e:	4a85                	li	s5,1
      link("C0", file);
    4420:	00003b97          	auipc	s7,0x3
    4424:	2d8b8b93          	addi	s7,s7,728 # 76f8 <malloc+0x1f44>
  for(i = 0; i < N; i++){
    4428:	02800a13          	li	s4,40
    442c:	acc1                	j	46fc <concreate+0x306>
      link("C0", file);
    442e:	fa840593          	addi	a1,s0,-88
    4432:	855e                	mv	a0,s7
    4434:	00001097          	auipc	ra,0x1
    4438:	f9a080e7          	jalr	-102(ra) # 53ce <link>
    if(pid == 0) {
    443c:	a45d                	j	46e2 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    443e:	4795                	li	a5,5
    4440:	02f9693b          	remw	s2,s2,a5
    4444:	4785                	li	a5,1
    4446:	02f90b63          	beq	s2,a5,447c <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    444a:	20200593          	li	a1,514
    444e:	fa840513          	addi	a0,s0,-88
    4452:	00001097          	auipc	ra,0x1
    4456:	f5c080e7          	jalr	-164(ra) # 53ae <open>
      if(fd < 0){
    445a:	26055b63          	bgez	a0,46d0 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    445e:	fa840593          	addi	a1,s0,-88
    4462:	00003517          	auipc	a0,0x3
    4466:	29e50513          	addi	a0,a0,670 # 7700 <malloc+0x1f4c>
    446a:	00001097          	auipc	ra,0x1
    446e:	28c080e7          	jalr	652(ra) # 56f6 <printf>
        exit(1);
    4472:	4505                	li	a0,1
    4474:	00001097          	auipc	ra,0x1
    4478:	efa080e7          	jalr	-262(ra) # 536e <exit>
      link("C0", file);
    447c:	fa840593          	addi	a1,s0,-88
    4480:	00003517          	auipc	a0,0x3
    4484:	27850513          	addi	a0,a0,632 # 76f8 <malloc+0x1f44>
    4488:	00001097          	auipc	ra,0x1
    448c:	f46080e7          	jalr	-186(ra) # 53ce <link>
      exit(0);
    4490:	4501                	li	a0,0
    4492:	00001097          	auipc	ra,0x1
    4496:	edc080e7          	jalr	-292(ra) # 536e <exit>
        exit(1);
    449a:	4505                	li	a0,1
    449c:	00001097          	auipc	ra,0x1
    44a0:	ed2080e7          	jalr	-302(ra) # 536e <exit>
  memset(fa, 0, sizeof(fa));
    44a4:	02800613          	li	a2,40
    44a8:	4581                	li	a1,0
    44aa:	f8040513          	addi	a0,s0,-128
    44ae:	00001097          	auipc	ra,0x1
    44b2:	cc4080e7          	jalr	-828(ra) # 5172 <memset>
  fd = open(".", 0);
    44b6:	4581                	li	a1,0
    44b8:	00002517          	auipc	a0,0x2
    44bc:	db050513          	addi	a0,a0,-592 # 6268 <malloc+0xab4>
    44c0:	00001097          	auipc	ra,0x1
    44c4:	eee080e7          	jalr	-274(ra) # 53ae <open>
    44c8:	892a                	mv	s2,a0
  n = 0;
    44ca:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    44cc:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    44d0:	02700b13          	li	s6,39
      fa[i] = 1;
    44d4:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    44d6:	4641                	li	a2,16
    44d8:	f7040593          	addi	a1,s0,-144
    44dc:	854a                	mv	a0,s2
    44de:	00001097          	auipc	ra,0x1
    44e2:	ea8080e7          	jalr	-344(ra) # 5386 <read>
    44e6:	08a05163          	blez	a0,4568 <concreate+0x172>
    if(de.inum == 0)
    44ea:	f7045783          	lhu	a5,-144(s0)
    44ee:	d7e5                	beqz	a5,44d6 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    44f0:	f7244783          	lbu	a5,-142(s0)
    44f4:	ff4791e3          	bne	a5,s4,44d6 <concreate+0xe0>
    44f8:	f7444783          	lbu	a5,-140(s0)
    44fc:	ffe9                	bnez	a5,44d6 <concreate+0xe0>
      i = de.name[1] - '0';
    44fe:	f7344783          	lbu	a5,-141(s0)
    4502:	fd07879b          	addiw	a5,a5,-48
    4506:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    450a:	00eb6f63          	bltu	s6,a4,4528 <concreate+0x132>
      if(fa[i]){
    450e:	fb040793          	addi	a5,s0,-80
    4512:	97ba                	add	a5,a5,a4
    4514:	fd07c783          	lbu	a5,-48(a5)
    4518:	eb85                	bnez	a5,4548 <concreate+0x152>
      fa[i] = 1;
    451a:	fb040793          	addi	a5,s0,-80
    451e:	973e                	add	a4,a4,a5
    4520:	fd770823          	sb	s7,-48(a4) # fd0 <bigdir+0x66>
      n++;
    4524:	2a85                	addiw	s5,s5,1
    4526:	bf45                	j	44d6 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4528:	f7240613          	addi	a2,s0,-142
    452c:	85ce                	mv	a1,s3
    452e:	00003517          	auipc	a0,0x3
    4532:	1f250513          	addi	a0,a0,498 # 7720 <malloc+0x1f6c>
    4536:	00001097          	auipc	ra,0x1
    453a:	1c0080e7          	jalr	448(ra) # 56f6 <printf>
        exit(1);
    453e:	4505                	li	a0,1
    4540:	00001097          	auipc	ra,0x1
    4544:	e2e080e7          	jalr	-466(ra) # 536e <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4548:	f7240613          	addi	a2,s0,-142
    454c:	85ce                	mv	a1,s3
    454e:	00003517          	auipc	a0,0x3
    4552:	1f250513          	addi	a0,a0,498 # 7740 <malloc+0x1f8c>
    4556:	00001097          	auipc	ra,0x1
    455a:	1a0080e7          	jalr	416(ra) # 56f6 <printf>
        exit(1);
    455e:	4505                	li	a0,1
    4560:	00001097          	auipc	ra,0x1
    4564:	e0e080e7          	jalr	-498(ra) # 536e <exit>
  close(fd);
    4568:	854a                	mv	a0,s2
    456a:	00001097          	auipc	ra,0x1
    456e:	e2c080e7          	jalr	-468(ra) # 5396 <close>
  if(n != N){
    4572:	02800793          	li	a5,40
    4576:	00fa9763          	bne	s5,a5,4584 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    457a:	4a8d                	li	s5,3
    457c:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    457e:	02800a13          	li	s4,40
    4582:	a8c9                	j	4654 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4584:	85ce                	mv	a1,s3
    4586:	00003517          	auipc	a0,0x3
    458a:	1e250513          	addi	a0,a0,482 # 7768 <malloc+0x1fb4>
    458e:	00001097          	auipc	ra,0x1
    4592:	168080e7          	jalr	360(ra) # 56f6 <printf>
    exit(1);
    4596:	4505                	li	a0,1
    4598:	00001097          	auipc	ra,0x1
    459c:	dd6080e7          	jalr	-554(ra) # 536e <exit>
      printf("%s: fork failed\n", s);
    45a0:	85ce                	mv	a1,s3
    45a2:	00002517          	auipc	a0,0x2
    45a6:	e6650513          	addi	a0,a0,-410 # 6408 <malloc+0xc54>
    45aa:	00001097          	auipc	ra,0x1
    45ae:	14c080e7          	jalr	332(ra) # 56f6 <printf>
      exit(1);
    45b2:	4505                	li	a0,1
    45b4:	00001097          	auipc	ra,0x1
    45b8:	dba080e7          	jalr	-582(ra) # 536e <exit>
      close(open(file, 0));
    45bc:	4581                	li	a1,0
    45be:	fa840513          	addi	a0,s0,-88
    45c2:	00001097          	auipc	ra,0x1
    45c6:	dec080e7          	jalr	-532(ra) # 53ae <open>
    45ca:	00001097          	auipc	ra,0x1
    45ce:	dcc080e7          	jalr	-564(ra) # 5396 <close>
      close(open(file, 0));
    45d2:	4581                	li	a1,0
    45d4:	fa840513          	addi	a0,s0,-88
    45d8:	00001097          	auipc	ra,0x1
    45dc:	dd6080e7          	jalr	-554(ra) # 53ae <open>
    45e0:	00001097          	auipc	ra,0x1
    45e4:	db6080e7          	jalr	-586(ra) # 5396 <close>
      close(open(file, 0));
    45e8:	4581                	li	a1,0
    45ea:	fa840513          	addi	a0,s0,-88
    45ee:	00001097          	auipc	ra,0x1
    45f2:	dc0080e7          	jalr	-576(ra) # 53ae <open>
    45f6:	00001097          	auipc	ra,0x1
    45fa:	da0080e7          	jalr	-608(ra) # 5396 <close>
      close(open(file, 0));
    45fe:	4581                	li	a1,0
    4600:	fa840513          	addi	a0,s0,-88
    4604:	00001097          	auipc	ra,0x1
    4608:	daa080e7          	jalr	-598(ra) # 53ae <open>
    460c:	00001097          	auipc	ra,0x1
    4610:	d8a080e7          	jalr	-630(ra) # 5396 <close>
      close(open(file, 0));
    4614:	4581                	li	a1,0
    4616:	fa840513          	addi	a0,s0,-88
    461a:	00001097          	auipc	ra,0x1
    461e:	d94080e7          	jalr	-620(ra) # 53ae <open>
    4622:	00001097          	auipc	ra,0x1
    4626:	d74080e7          	jalr	-652(ra) # 5396 <close>
      close(open(file, 0));
    462a:	4581                	li	a1,0
    462c:	fa840513          	addi	a0,s0,-88
    4630:	00001097          	auipc	ra,0x1
    4634:	d7e080e7          	jalr	-642(ra) # 53ae <open>
    4638:	00001097          	auipc	ra,0x1
    463c:	d5e080e7          	jalr	-674(ra) # 5396 <close>
    if(pid == 0)
    4640:	08090363          	beqz	s2,46c6 <concreate+0x2d0>
      wait(0);
    4644:	4501                	li	a0,0
    4646:	00001097          	auipc	ra,0x1
    464a:	d30080e7          	jalr	-720(ra) # 5376 <wait>
  for(i = 0; i < N; i++){
    464e:	2485                	addiw	s1,s1,1
    4650:	0f448563          	beq	s1,s4,473a <concreate+0x344>
    file[1] = '0' + i;
    4654:	0304879b          	addiw	a5,s1,48
    4658:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    465c:	00001097          	auipc	ra,0x1
    4660:	d0a080e7          	jalr	-758(ra) # 5366 <fork>
    4664:	892a                	mv	s2,a0
    if(pid < 0){
    4666:	f2054de3          	bltz	a0,45a0 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    466a:	0354e73b          	remw	a4,s1,s5
    466e:	00a767b3          	or	a5,a4,a0
    4672:	2781                	sext.w	a5,a5
    4674:	d7a1                	beqz	a5,45bc <concreate+0x1c6>
    4676:	01671363          	bne	a4,s6,467c <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    467a:	f129                	bnez	a0,45bc <concreate+0x1c6>
      unlink(file);
    467c:	fa840513          	addi	a0,s0,-88
    4680:	00001097          	auipc	ra,0x1
    4684:	d3e080e7          	jalr	-706(ra) # 53be <unlink>
      unlink(file);
    4688:	fa840513          	addi	a0,s0,-88
    468c:	00001097          	auipc	ra,0x1
    4690:	d32080e7          	jalr	-718(ra) # 53be <unlink>
      unlink(file);
    4694:	fa840513          	addi	a0,s0,-88
    4698:	00001097          	auipc	ra,0x1
    469c:	d26080e7          	jalr	-730(ra) # 53be <unlink>
      unlink(file);
    46a0:	fa840513          	addi	a0,s0,-88
    46a4:	00001097          	auipc	ra,0x1
    46a8:	d1a080e7          	jalr	-742(ra) # 53be <unlink>
      unlink(file);
    46ac:	fa840513          	addi	a0,s0,-88
    46b0:	00001097          	auipc	ra,0x1
    46b4:	d0e080e7          	jalr	-754(ra) # 53be <unlink>
      unlink(file);
    46b8:	fa840513          	addi	a0,s0,-88
    46bc:	00001097          	auipc	ra,0x1
    46c0:	d02080e7          	jalr	-766(ra) # 53be <unlink>
    46c4:	bfb5                	j	4640 <concreate+0x24a>
      exit(0);
    46c6:	4501                	li	a0,0
    46c8:	00001097          	auipc	ra,0x1
    46cc:	ca6080e7          	jalr	-858(ra) # 536e <exit>
      close(fd);
    46d0:	00001097          	auipc	ra,0x1
    46d4:	cc6080e7          	jalr	-826(ra) # 5396 <close>
    if(pid == 0) {
    46d8:	bb65                	j	4490 <concreate+0x9a>
      close(fd);
    46da:	00001097          	auipc	ra,0x1
    46de:	cbc080e7          	jalr	-836(ra) # 5396 <close>
      wait(&xstatus);
    46e2:	f6c40513          	addi	a0,s0,-148
    46e6:	00001097          	auipc	ra,0x1
    46ea:	c90080e7          	jalr	-880(ra) # 5376 <wait>
      if(xstatus != 0)
    46ee:	f6c42483          	lw	s1,-148(s0)
    46f2:	da0494e3          	bnez	s1,449a <concreate+0xa4>
  for(i = 0; i < N; i++){
    46f6:	2905                	addiw	s2,s2,1
    46f8:	db4906e3          	beq	s2,s4,44a4 <concreate+0xae>
    file[1] = '0' + i;
    46fc:	0309079b          	addiw	a5,s2,48
    4700:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4704:	fa840513          	addi	a0,s0,-88
    4708:	00001097          	auipc	ra,0x1
    470c:	cb6080e7          	jalr	-842(ra) # 53be <unlink>
    pid = fork();
    4710:	00001097          	auipc	ra,0x1
    4714:	c56080e7          	jalr	-938(ra) # 5366 <fork>
    if(pid && (i % 3) == 1){
    4718:	d20503e3          	beqz	a0,443e <concreate+0x48>
    471c:	036967bb          	remw	a5,s2,s6
    4720:	d15787e3          	beq	a5,s5,442e <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4724:	20200593          	li	a1,514
    4728:	fa840513          	addi	a0,s0,-88
    472c:	00001097          	auipc	ra,0x1
    4730:	c82080e7          	jalr	-894(ra) # 53ae <open>
      if(fd < 0){
    4734:	fa0553e3          	bgez	a0,46da <concreate+0x2e4>
    4738:	b31d                	j	445e <concreate+0x68>
}
    473a:	60ea                	ld	ra,152(sp)
    473c:	644a                	ld	s0,144(sp)
    473e:	64aa                	ld	s1,136(sp)
    4740:	690a                	ld	s2,128(sp)
    4742:	79e6                	ld	s3,120(sp)
    4744:	7a46                	ld	s4,112(sp)
    4746:	7aa6                	ld	s5,104(sp)
    4748:	7b06                	ld	s6,96(sp)
    474a:	6be6                	ld	s7,88(sp)
    474c:	610d                	addi	sp,sp,160
    474e:	8082                	ret

0000000000004750 <bigfile>:
{
    4750:	7139                	addi	sp,sp,-64
    4752:	fc06                	sd	ra,56(sp)
    4754:	f822                	sd	s0,48(sp)
    4756:	f426                	sd	s1,40(sp)
    4758:	f04a                	sd	s2,32(sp)
    475a:	ec4e                	sd	s3,24(sp)
    475c:	e852                	sd	s4,16(sp)
    475e:	e456                	sd	s5,8(sp)
    4760:	0080                	addi	s0,sp,64
    4762:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4764:	00003517          	auipc	a0,0x3
    4768:	03c50513          	addi	a0,a0,60 # 77a0 <malloc+0x1fec>
    476c:	00001097          	auipc	ra,0x1
    4770:	c52080e7          	jalr	-942(ra) # 53be <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4774:	20200593          	li	a1,514
    4778:	00003517          	auipc	a0,0x3
    477c:	02850513          	addi	a0,a0,40 # 77a0 <malloc+0x1fec>
    4780:	00001097          	auipc	ra,0x1
    4784:	c2e080e7          	jalr	-978(ra) # 53ae <open>
    4788:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    478a:	4481                	li	s1,0
    memset(buf, i, SZ);
    478c:	00007917          	auipc	s2,0x7
    4790:	fac90913          	addi	s2,s2,-84 # b738 <buf>
  for(i = 0; i < N; i++){
    4794:	4a51                	li	s4,20
  if(fd < 0){
    4796:	0a054063          	bltz	a0,4836 <bigfile+0xe6>
    memset(buf, i, SZ);
    479a:	25800613          	li	a2,600
    479e:	85a6                	mv	a1,s1
    47a0:	854a                	mv	a0,s2
    47a2:	00001097          	auipc	ra,0x1
    47a6:	9d0080e7          	jalr	-1584(ra) # 5172 <memset>
    if(write(fd, buf, SZ) != SZ){
    47aa:	25800613          	li	a2,600
    47ae:	85ca                	mv	a1,s2
    47b0:	854e                	mv	a0,s3
    47b2:	00001097          	auipc	ra,0x1
    47b6:	bdc080e7          	jalr	-1060(ra) # 538e <write>
    47ba:	25800793          	li	a5,600
    47be:	08f51a63          	bne	a0,a5,4852 <bigfile+0x102>
  for(i = 0; i < N; i++){
    47c2:	2485                	addiw	s1,s1,1
    47c4:	fd449be3          	bne	s1,s4,479a <bigfile+0x4a>
  close(fd);
    47c8:	854e                	mv	a0,s3
    47ca:	00001097          	auipc	ra,0x1
    47ce:	bcc080e7          	jalr	-1076(ra) # 5396 <close>
  fd = open("bigfile.dat", 0);
    47d2:	4581                	li	a1,0
    47d4:	00003517          	auipc	a0,0x3
    47d8:	fcc50513          	addi	a0,a0,-52 # 77a0 <malloc+0x1fec>
    47dc:	00001097          	auipc	ra,0x1
    47e0:	bd2080e7          	jalr	-1070(ra) # 53ae <open>
    47e4:	8a2a                	mv	s4,a0
  total = 0;
    47e6:	4981                	li	s3,0
  for(i = 0; ; i++){
    47e8:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    47ea:	00007917          	auipc	s2,0x7
    47ee:	f4e90913          	addi	s2,s2,-178 # b738 <buf>
  if(fd < 0){
    47f2:	06054e63          	bltz	a0,486e <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    47f6:	12c00613          	li	a2,300
    47fa:	85ca                	mv	a1,s2
    47fc:	8552                	mv	a0,s4
    47fe:	00001097          	auipc	ra,0x1
    4802:	b88080e7          	jalr	-1144(ra) # 5386 <read>
    if(cc < 0){
    4806:	08054263          	bltz	a0,488a <bigfile+0x13a>
    if(cc == 0)
    480a:	c971                	beqz	a0,48de <bigfile+0x18e>
    if(cc != SZ/2){
    480c:	12c00793          	li	a5,300
    4810:	08f51b63          	bne	a0,a5,48a6 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4814:	01f4d79b          	srliw	a5,s1,0x1f
    4818:	9fa5                	addw	a5,a5,s1
    481a:	4017d79b          	sraiw	a5,a5,0x1
    481e:	00094703          	lbu	a4,0(s2)
    4822:	0af71063          	bne	a4,a5,48c2 <bigfile+0x172>
    4826:	12b94703          	lbu	a4,299(s2)
    482a:	08f71c63          	bne	a4,a5,48c2 <bigfile+0x172>
    total += cc;
    482e:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4832:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4834:	b7c9                	j	47f6 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4836:	85d6                	mv	a1,s5
    4838:	00003517          	auipc	a0,0x3
    483c:	f7850513          	addi	a0,a0,-136 # 77b0 <malloc+0x1ffc>
    4840:	00001097          	auipc	ra,0x1
    4844:	eb6080e7          	jalr	-330(ra) # 56f6 <printf>
    exit(1);
    4848:	4505                	li	a0,1
    484a:	00001097          	auipc	ra,0x1
    484e:	b24080e7          	jalr	-1244(ra) # 536e <exit>
      printf("%s: write bigfile failed\n", s);
    4852:	85d6                	mv	a1,s5
    4854:	00003517          	auipc	a0,0x3
    4858:	f7c50513          	addi	a0,a0,-132 # 77d0 <malloc+0x201c>
    485c:	00001097          	auipc	ra,0x1
    4860:	e9a080e7          	jalr	-358(ra) # 56f6 <printf>
      exit(1);
    4864:	4505                	li	a0,1
    4866:	00001097          	auipc	ra,0x1
    486a:	b08080e7          	jalr	-1272(ra) # 536e <exit>
    printf("%s: cannot open bigfile\n", s);
    486e:	85d6                	mv	a1,s5
    4870:	00003517          	auipc	a0,0x3
    4874:	f8050513          	addi	a0,a0,-128 # 77f0 <malloc+0x203c>
    4878:	00001097          	auipc	ra,0x1
    487c:	e7e080e7          	jalr	-386(ra) # 56f6 <printf>
    exit(1);
    4880:	4505                	li	a0,1
    4882:	00001097          	auipc	ra,0x1
    4886:	aec080e7          	jalr	-1300(ra) # 536e <exit>
      printf("%s: read bigfile failed\n", s);
    488a:	85d6                	mv	a1,s5
    488c:	00003517          	auipc	a0,0x3
    4890:	f8450513          	addi	a0,a0,-124 # 7810 <malloc+0x205c>
    4894:	00001097          	auipc	ra,0x1
    4898:	e62080e7          	jalr	-414(ra) # 56f6 <printf>
      exit(1);
    489c:	4505                	li	a0,1
    489e:	00001097          	auipc	ra,0x1
    48a2:	ad0080e7          	jalr	-1328(ra) # 536e <exit>
      printf("%s: short read bigfile\n", s);
    48a6:	85d6                	mv	a1,s5
    48a8:	00003517          	auipc	a0,0x3
    48ac:	f8850513          	addi	a0,a0,-120 # 7830 <malloc+0x207c>
    48b0:	00001097          	auipc	ra,0x1
    48b4:	e46080e7          	jalr	-442(ra) # 56f6 <printf>
      exit(1);
    48b8:	4505                	li	a0,1
    48ba:	00001097          	auipc	ra,0x1
    48be:	ab4080e7          	jalr	-1356(ra) # 536e <exit>
      printf("%s: read bigfile wrong data\n", s);
    48c2:	85d6                	mv	a1,s5
    48c4:	00003517          	auipc	a0,0x3
    48c8:	f8450513          	addi	a0,a0,-124 # 7848 <malloc+0x2094>
    48cc:	00001097          	auipc	ra,0x1
    48d0:	e2a080e7          	jalr	-470(ra) # 56f6 <printf>
      exit(1);
    48d4:	4505                	li	a0,1
    48d6:	00001097          	auipc	ra,0x1
    48da:	a98080e7          	jalr	-1384(ra) # 536e <exit>
  close(fd);
    48de:	8552                	mv	a0,s4
    48e0:	00001097          	auipc	ra,0x1
    48e4:	ab6080e7          	jalr	-1354(ra) # 5396 <close>
  if(total != N*SZ){
    48e8:	678d                	lui	a5,0x3
    48ea:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x206>
    48ee:	02f99363          	bne	s3,a5,4914 <bigfile+0x1c4>
  unlink("bigfile.dat");
    48f2:	00003517          	auipc	a0,0x3
    48f6:	eae50513          	addi	a0,a0,-338 # 77a0 <malloc+0x1fec>
    48fa:	00001097          	auipc	ra,0x1
    48fe:	ac4080e7          	jalr	-1340(ra) # 53be <unlink>
}
    4902:	70e2                	ld	ra,56(sp)
    4904:	7442                	ld	s0,48(sp)
    4906:	74a2                	ld	s1,40(sp)
    4908:	7902                	ld	s2,32(sp)
    490a:	69e2                	ld	s3,24(sp)
    490c:	6a42                	ld	s4,16(sp)
    490e:	6aa2                	ld	s5,8(sp)
    4910:	6121                	addi	sp,sp,64
    4912:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4914:	85d6                	mv	a1,s5
    4916:	00003517          	auipc	a0,0x3
    491a:	f5250513          	addi	a0,a0,-174 # 7868 <malloc+0x20b4>
    491e:	00001097          	auipc	ra,0x1
    4922:	dd8080e7          	jalr	-552(ra) # 56f6 <printf>
    exit(1);
    4926:	4505                	li	a0,1
    4928:	00001097          	auipc	ra,0x1
    492c:	a46080e7          	jalr	-1466(ra) # 536e <exit>

0000000000004930 <dirtest>:
{
    4930:	1101                	addi	sp,sp,-32
    4932:	ec06                	sd	ra,24(sp)
    4934:	e822                	sd	s0,16(sp)
    4936:	e426                	sd	s1,8(sp)
    4938:	1000                	addi	s0,sp,32
    493a:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    493c:	00003517          	auipc	a0,0x3
    4940:	f4c50513          	addi	a0,a0,-180 # 7888 <malloc+0x20d4>
    4944:	00001097          	auipc	ra,0x1
    4948:	db2080e7          	jalr	-590(ra) # 56f6 <printf>
  if(mkdir("dir0") < 0){
    494c:	00003517          	auipc	a0,0x3
    4950:	f4c50513          	addi	a0,a0,-180 # 7898 <malloc+0x20e4>
    4954:	00001097          	auipc	ra,0x1
    4958:	a82080e7          	jalr	-1406(ra) # 53d6 <mkdir>
    495c:	04054d63          	bltz	a0,49b6 <dirtest+0x86>
  if(chdir("dir0") < 0){
    4960:	00003517          	auipc	a0,0x3
    4964:	f3850513          	addi	a0,a0,-200 # 7898 <malloc+0x20e4>
    4968:	00001097          	auipc	ra,0x1
    496c:	a76080e7          	jalr	-1418(ra) # 53de <chdir>
    4970:	06054163          	bltz	a0,49d2 <dirtest+0xa2>
  if(chdir("..") < 0){
    4974:	00003517          	auipc	a0,0x3
    4978:	97c50513          	addi	a0,a0,-1668 # 72f0 <malloc+0x1b3c>
    497c:	00001097          	auipc	ra,0x1
    4980:	a62080e7          	jalr	-1438(ra) # 53de <chdir>
    4984:	06054563          	bltz	a0,49ee <dirtest+0xbe>
  if(unlink("dir0") < 0){
    4988:	00003517          	auipc	a0,0x3
    498c:	f1050513          	addi	a0,a0,-240 # 7898 <malloc+0x20e4>
    4990:	00001097          	auipc	ra,0x1
    4994:	a2e080e7          	jalr	-1490(ra) # 53be <unlink>
    4998:	06054963          	bltz	a0,4a0a <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    499c:	00003517          	auipc	a0,0x3
    49a0:	f4c50513          	addi	a0,a0,-180 # 78e8 <malloc+0x2134>
    49a4:	00001097          	auipc	ra,0x1
    49a8:	d52080e7          	jalr	-686(ra) # 56f6 <printf>
}
    49ac:	60e2                	ld	ra,24(sp)
    49ae:	6442                	ld	s0,16(sp)
    49b0:	64a2                	ld	s1,8(sp)
    49b2:	6105                	addi	sp,sp,32
    49b4:	8082                	ret
    printf("%s: mkdir failed\n", s);
    49b6:	85a6                	mv	a1,s1
    49b8:	00002517          	auipc	a0,0x2
    49bc:	2d850513          	addi	a0,a0,728 # 6c90 <malloc+0x14dc>
    49c0:	00001097          	auipc	ra,0x1
    49c4:	d36080e7          	jalr	-714(ra) # 56f6 <printf>
    exit(1);
    49c8:	4505                	li	a0,1
    49ca:	00001097          	auipc	ra,0x1
    49ce:	9a4080e7          	jalr	-1628(ra) # 536e <exit>
    printf("%s: chdir dir0 failed\n", s);
    49d2:	85a6                	mv	a1,s1
    49d4:	00003517          	auipc	a0,0x3
    49d8:	ecc50513          	addi	a0,a0,-308 # 78a0 <malloc+0x20ec>
    49dc:	00001097          	auipc	ra,0x1
    49e0:	d1a080e7          	jalr	-742(ra) # 56f6 <printf>
    exit(1);
    49e4:	4505                	li	a0,1
    49e6:	00001097          	auipc	ra,0x1
    49ea:	988080e7          	jalr	-1656(ra) # 536e <exit>
    printf("%s: chdir .. failed\n", s);
    49ee:	85a6                	mv	a1,s1
    49f0:	00003517          	auipc	a0,0x3
    49f4:	ec850513          	addi	a0,a0,-312 # 78b8 <malloc+0x2104>
    49f8:	00001097          	auipc	ra,0x1
    49fc:	cfe080e7          	jalr	-770(ra) # 56f6 <printf>
    exit(1);
    4a00:	4505                	li	a0,1
    4a02:	00001097          	auipc	ra,0x1
    4a06:	96c080e7          	jalr	-1684(ra) # 536e <exit>
    printf("%s: unlink dir0 failed\n", s);
    4a0a:	85a6                	mv	a1,s1
    4a0c:	00003517          	auipc	a0,0x3
    4a10:	ec450513          	addi	a0,a0,-316 # 78d0 <malloc+0x211c>
    4a14:	00001097          	auipc	ra,0x1
    4a18:	ce2080e7          	jalr	-798(ra) # 56f6 <printf>
    exit(1);
    4a1c:	4505                	li	a0,1
    4a1e:	00001097          	auipc	ra,0x1
    4a22:	950080e7          	jalr	-1712(ra) # 536e <exit>

0000000000004a26 <fsfull>:
{
    4a26:	7171                	addi	sp,sp,-176
    4a28:	f506                	sd	ra,168(sp)
    4a2a:	f122                	sd	s0,160(sp)
    4a2c:	ed26                	sd	s1,152(sp)
    4a2e:	e94a                	sd	s2,144(sp)
    4a30:	e54e                	sd	s3,136(sp)
    4a32:	e152                	sd	s4,128(sp)
    4a34:	fcd6                	sd	s5,120(sp)
    4a36:	f8da                	sd	s6,112(sp)
    4a38:	f4de                	sd	s7,104(sp)
    4a3a:	f0e2                	sd	s8,96(sp)
    4a3c:	ece6                	sd	s9,88(sp)
    4a3e:	e8ea                	sd	s10,80(sp)
    4a40:	e4ee                	sd	s11,72(sp)
    4a42:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4a44:	00003517          	auipc	a0,0x3
    4a48:	ebc50513          	addi	a0,a0,-324 # 7900 <malloc+0x214c>
    4a4c:	00001097          	auipc	ra,0x1
    4a50:	caa080e7          	jalr	-854(ra) # 56f6 <printf>
  for(nfiles = 0; ; nfiles++){
    4a54:	4481                	li	s1,0
    name[0] = 'f';
    4a56:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4a5a:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4a5e:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4a62:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    4a64:	00003c97          	auipc	s9,0x3
    4a68:	eacc8c93          	addi	s9,s9,-340 # 7910 <malloc+0x215c>
    int total = 0;
    4a6c:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4a6e:	00007a17          	auipc	s4,0x7
    4a72:	ccaa0a13          	addi	s4,s4,-822 # b738 <buf>
    name[0] = 'f';
    4a76:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4a7a:	0384c7bb          	divw	a5,s1,s8
    4a7e:	0307879b          	addiw	a5,a5,48
    4a82:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4a86:	0384e7bb          	remw	a5,s1,s8
    4a8a:	0377c7bb          	divw	a5,a5,s7
    4a8e:	0307879b          	addiw	a5,a5,48
    4a92:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4a96:	0374e7bb          	remw	a5,s1,s7
    4a9a:	0367c7bb          	divw	a5,a5,s6
    4a9e:	0307879b          	addiw	a5,a5,48
    4aa2:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4aa6:	0364e7bb          	remw	a5,s1,s6
    4aaa:	0307879b          	addiw	a5,a5,48
    4aae:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4ab2:	f4040aa3          	sb	zero,-171(s0)
    printf("%s: writing %s\n", name);
    4ab6:	f5040593          	addi	a1,s0,-176
    4aba:	8566                	mv	a0,s9
    4abc:	00001097          	auipc	ra,0x1
    4ac0:	c3a080e7          	jalr	-966(ra) # 56f6 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4ac4:	20200593          	li	a1,514
    4ac8:	f5040513          	addi	a0,s0,-176
    4acc:	00001097          	auipc	ra,0x1
    4ad0:	8e2080e7          	jalr	-1822(ra) # 53ae <open>
    4ad4:	892a                	mv	s2,a0
    if(fd < 0){
    4ad6:	0a055663          	bgez	a0,4b82 <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    4ada:	f5040593          	addi	a1,s0,-176
    4ade:	00003517          	auipc	a0,0x3
    4ae2:	e4250513          	addi	a0,a0,-446 # 7920 <malloc+0x216c>
    4ae6:	00001097          	auipc	ra,0x1
    4aea:	c10080e7          	jalr	-1008(ra) # 56f6 <printf>
  while(nfiles >= 0){
    4aee:	0604c363          	bltz	s1,4b54 <fsfull+0x12e>
    name[0] = 'f';
    4af2:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4af6:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4afa:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4afe:	4929                	li	s2,10
  while(nfiles >= 0){
    4b00:	5afd                	li	s5,-1
    name[0] = 'f';
    4b02:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4b06:	0344c7bb          	divw	a5,s1,s4
    4b0a:	0307879b          	addiw	a5,a5,48
    4b0e:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4b12:	0344e7bb          	remw	a5,s1,s4
    4b16:	0337c7bb          	divw	a5,a5,s3
    4b1a:	0307879b          	addiw	a5,a5,48
    4b1e:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4b22:	0334e7bb          	remw	a5,s1,s3
    4b26:	0327c7bb          	divw	a5,a5,s2
    4b2a:	0307879b          	addiw	a5,a5,48
    4b2e:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4b32:	0324e7bb          	remw	a5,s1,s2
    4b36:	0307879b          	addiw	a5,a5,48
    4b3a:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4b3e:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4b42:	f5040513          	addi	a0,s0,-176
    4b46:	00001097          	auipc	ra,0x1
    4b4a:	878080e7          	jalr	-1928(ra) # 53be <unlink>
    nfiles--;
    4b4e:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4b50:	fb5499e3          	bne	s1,s5,4b02 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4b54:	00003517          	auipc	a0,0x3
    4b58:	dfc50513          	addi	a0,a0,-516 # 7950 <malloc+0x219c>
    4b5c:	00001097          	auipc	ra,0x1
    4b60:	b9a080e7          	jalr	-1126(ra) # 56f6 <printf>
}
    4b64:	70aa                	ld	ra,168(sp)
    4b66:	740a                	ld	s0,160(sp)
    4b68:	64ea                	ld	s1,152(sp)
    4b6a:	694a                	ld	s2,144(sp)
    4b6c:	69aa                	ld	s3,136(sp)
    4b6e:	6a0a                	ld	s4,128(sp)
    4b70:	7ae6                	ld	s5,120(sp)
    4b72:	7b46                	ld	s6,112(sp)
    4b74:	7ba6                	ld	s7,104(sp)
    4b76:	7c06                	ld	s8,96(sp)
    4b78:	6ce6                	ld	s9,88(sp)
    4b7a:	6d46                	ld	s10,80(sp)
    4b7c:	6da6                	ld	s11,72(sp)
    4b7e:	614d                	addi	sp,sp,176
    4b80:	8082                	ret
    int total = 0;
    4b82:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4b84:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4b88:	40000613          	li	a2,1024
    4b8c:	85d2                	mv	a1,s4
    4b8e:	854a                	mv	a0,s2
    4b90:	00000097          	auipc	ra,0x0
    4b94:	7fe080e7          	jalr	2046(ra) # 538e <write>
      if(cc < BSIZE)
    4b98:	00aad563          	bge	s5,a0,4ba2 <fsfull+0x17c>
      total += cc;
    4b9c:	00a989bb          	addw	s3,s3,a0
    while(1){
    4ba0:	b7e5                	j	4b88 <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    4ba2:	85ce                	mv	a1,s3
    4ba4:	00003517          	auipc	a0,0x3
    4ba8:	d9450513          	addi	a0,a0,-620 # 7938 <malloc+0x2184>
    4bac:	00001097          	auipc	ra,0x1
    4bb0:	b4a080e7          	jalr	-1206(ra) # 56f6 <printf>
    close(fd);
    4bb4:	854a                	mv	a0,s2
    4bb6:	00000097          	auipc	ra,0x0
    4bba:	7e0080e7          	jalr	2016(ra) # 5396 <close>
    if(total == 0)
    4bbe:	f20988e3          	beqz	s3,4aee <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4bc2:	2485                	addiw	s1,s1,1
    4bc4:	bd4d                	j	4a76 <fsfull+0x50>

0000000000004bc6 <rand>:
{
    4bc6:	1141                	addi	sp,sp,-16
    4bc8:	e422                	sd	s0,8(sp)
    4bca:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4bcc:	00003717          	auipc	a4,0x3
    4bd0:	33c70713          	addi	a4,a4,828 # 7f08 <randstate>
    4bd4:	6308                	ld	a0,0(a4)
    4bd6:	001967b7          	lui	a5,0x196
    4bda:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187ec5>
    4bde:	02f50533          	mul	a0,a0,a5
    4be2:	3c6ef7b7          	lui	a5,0x3c6ef
    4be6:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e0c17>
    4bea:	953e                	add	a0,a0,a5
    4bec:	e308                	sd	a0,0(a4)
}
    4bee:	2501                	sext.w	a0,a0
    4bf0:	6422                	ld	s0,8(sp)
    4bf2:	0141                	addi	sp,sp,16
    4bf4:	8082                	ret

0000000000004bf6 <badwrite>:
{
    4bf6:	7179                	addi	sp,sp,-48
    4bf8:	f406                	sd	ra,40(sp)
    4bfa:	f022                	sd	s0,32(sp)
    4bfc:	ec26                	sd	s1,24(sp)
    4bfe:	e84a                	sd	s2,16(sp)
    4c00:	e44e                	sd	s3,8(sp)
    4c02:	e052                	sd	s4,0(sp)
    4c04:	1800                	addi	s0,sp,48
  unlink("junk");
    4c06:	00003517          	auipc	a0,0x3
    4c0a:	d6250513          	addi	a0,a0,-670 # 7968 <malloc+0x21b4>
    4c0e:	00000097          	auipc	ra,0x0
    4c12:	7b0080e7          	jalr	1968(ra) # 53be <unlink>
    4c16:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4c1a:	00003997          	auipc	s3,0x3
    4c1e:	d4e98993          	addi	s3,s3,-690 # 7968 <malloc+0x21b4>
    write(fd, (char*)0xffffffffffL, 1);
    4c22:	5a7d                	li	s4,-1
    4c24:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4c28:	20100593          	li	a1,513
    4c2c:	854e                	mv	a0,s3
    4c2e:	00000097          	auipc	ra,0x0
    4c32:	780080e7          	jalr	1920(ra) # 53ae <open>
    4c36:	84aa                	mv	s1,a0
    if(fd < 0){
    4c38:	06054b63          	bltz	a0,4cae <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4c3c:	4605                	li	a2,1
    4c3e:	85d2                	mv	a1,s4
    4c40:	00000097          	auipc	ra,0x0
    4c44:	74e080e7          	jalr	1870(ra) # 538e <write>
    close(fd);
    4c48:	8526                	mv	a0,s1
    4c4a:	00000097          	auipc	ra,0x0
    4c4e:	74c080e7          	jalr	1868(ra) # 5396 <close>
    unlink("junk");
    4c52:	854e                	mv	a0,s3
    4c54:	00000097          	auipc	ra,0x0
    4c58:	76a080e7          	jalr	1898(ra) # 53be <unlink>
  for(int i = 0; i < assumed_free; i++){
    4c5c:	397d                	addiw	s2,s2,-1
    4c5e:	fc0915e3          	bnez	s2,4c28 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4c62:	20100593          	li	a1,513
    4c66:	00003517          	auipc	a0,0x3
    4c6a:	d0250513          	addi	a0,a0,-766 # 7968 <malloc+0x21b4>
    4c6e:	00000097          	auipc	ra,0x0
    4c72:	740080e7          	jalr	1856(ra) # 53ae <open>
    4c76:	84aa                	mv	s1,a0
  if(fd < 0){
    4c78:	04054863          	bltz	a0,4cc8 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4c7c:	4605                	li	a2,1
    4c7e:	00001597          	auipc	a1,0x1
    4c82:	fc258593          	addi	a1,a1,-62 # 5c40 <malloc+0x48c>
    4c86:	00000097          	auipc	ra,0x0
    4c8a:	708080e7          	jalr	1800(ra) # 538e <write>
    4c8e:	4785                	li	a5,1
    4c90:	04f50963          	beq	a0,a5,4ce2 <badwrite+0xec>
    printf("write failed\n");
    4c94:	00003517          	auipc	a0,0x3
    4c98:	cf450513          	addi	a0,a0,-780 # 7988 <malloc+0x21d4>
    4c9c:	00001097          	auipc	ra,0x1
    4ca0:	a5a080e7          	jalr	-1446(ra) # 56f6 <printf>
    exit(1);
    4ca4:	4505                	li	a0,1
    4ca6:	00000097          	auipc	ra,0x0
    4caa:	6c8080e7          	jalr	1736(ra) # 536e <exit>
      printf("open junk failed\n");
    4cae:	00003517          	auipc	a0,0x3
    4cb2:	cc250513          	addi	a0,a0,-830 # 7970 <malloc+0x21bc>
    4cb6:	00001097          	auipc	ra,0x1
    4cba:	a40080e7          	jalr	-1472(ra) # 56f6 <printf>
      exit(1);
    4cbe:	4505                	li	a0,1
    4cc0:	00000097          	auipc	ra,0x0
    4cc4:	6ae080e7          	jalr	1710(ra) # 536e <exit>
    printf("open junk failed\n");
    4cc8:	00003517          	auipc	a0,0x3
    4ccc:	ca850513          	addi	a0,a0,-856 # 7970 <malloc+0x21bc>
    4cd0:	00001097          	auipc	ra,0x1
    4cd4:	a26080e7          	jalr	-1498(ra) # 56f6 <printf>
    exit(1);
    4cd8:	4505                	li	a0,1
    4cda:	00000097          	auipc	ra,0x0
    4cde:	694080e7          	jalr	1684(ra) # 536e <exit>
  close(fd);
    4ce2:	8526                	mv	a0,s1
    4ce4:	00000097          	auipc	ra,0x0
    4ce8:	6b2080e7          	jalr	1714(ra) # 5396 <close>
  unlink("junk");
    4cec:	00003517          	auipc	a0,0x3
    4cf0:	c7c50513          	addi	a0,a0,-900 # 7968 <malloc+0x21b4>
    4cf4:	00000097          	auipc	ra,0x0
    4cf8:	6ca080e7          	jalr	1738(ra) # 53be <unlink>
  exit(0);
    4cfc:	4501                	li	a0,0
    4cfe:	00000097          	auipc	ra,0x0
    4d02:	670080e7          	jalr	1648(ra) # 536e <exit>

0000000000004d06 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4d06:	7139                	addi	sp,sp,-64
    4d08:	fc06                	sd	ra,56(sp)
    4d0a:	f822                	sd	s0,48(sp)
    4d0c:	f426                	sd	s1,40(sp)
    4d0e:	f04a                	sd	s2,32(sp)
    4d10:	ec4e                	sd	s3,24(sp)
    4d12:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4d14:	fc840513          	addi	a0,s0,-56
    4d18:	00000097          	auipc	ra,0x0
    4d1c:	666080e7          	jalr	1638(ra) # 537e <pipe>
    4d20:	06054763          	bltz	a0,4d8e <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4d24:	00000097          	auipc	ra,0x0
    4d28:	642080e7          	jalr	1602(ra) # 5366 <fork>

  if(pid < 0){
    4d2c:	06054e63          	bltz	a0,4da8 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4d30:	ed51                	bnez	a0,4dcc <countfree+0xc6>
    close(fds[0]);
    4d32:	fc842503          	lw	a0,-56(s0)
    4d36:	00000097          	auipc	ra,0x0
    4d3a:	660080e7          	jalr	1632(ra) # 5396 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4d3e:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4d40:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4d42:	00001997          	auipc	s3,0x1
    4d46:	efe98993          	addi	s3,s3,-258 # 5c40 <malloc+0x48c>
      uint64 a = (uint64) sbrk(4096);
    4d4a:	6505                	lui	a0,0x1
    4d4c:	00000097          	auipc	ra,0x0
    4d50:	6aa080e7          	jalr	1706(ra) # 53f6 <sbrk>
      if(a == 0xffffffffffffffff){
    4d54:	07250763          	beq	a0,s2,4dc2 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    4d58:	6785                	lui	a5,0x1
    4d5a:	953e                	add	a0,a0,a5
    4d5c:	fe950fa3          	sb	s1,-1(a0) # fff <bigdir+0x95>
      if(write(fds[1], "x", 1) != 1){
    4d60:	8626                	mv	a2,s1
    4d62:	85ce                	mv	a1,s3
    4d64:	fcc42503          	lw	a0,-52(s0)
    4d68:	00000097          	auipc	ra,0x0
    4d6c:	626080e7          	jalr	1574(ra) # 538e <write>
    4d70:	fc950de3          	beq	a0,s1,4d4a <countfree+0x44>
        printf("write() failed in countfree()\n");
    4d74:	00003517          	auipc	a0,0x3
    4d78:	c6450513          	addi	a0,a0,-924 # 79d8 <malloc+0x2224>
    4d7c:	00001097          	auipc	ra,0x1
    4d80:	97a080e7          	jalr	-1670(ra) # 56f6 <printf>
        exit(1);
    4d84:	4505                	li	a0,1
    4d86:	00000097          	auipc	ra,0x0
    4d8a:	5e8080e7          	jalr	1512(ra) # 536e <exit>
    printf("pipe() failed in countfree()\n");
    4d8e:	00003517          	auipc	a0,0x3
    4d92:	c0a50513          	addi	a0,a0,-1014 # 7998 <malloc+0x21e4>
    4d96:	00001097          	auipc	ra,0x1
    4d9a:	960080e7          	jalr	-1696(ra) # 56f6 <printf>
    exit(1);
    4d9e:	4505                	li	a0,1
    4da0:	00000097          	auipc	ra,0x0
    4da4:	5ce080e7          	jalr	1486(ra) # 536e <exit>
    printf("fork failed in countfree()\n");
    4da8:	00003517          	auipc	a0,0x3
    4dac:	c1050513          	addi	a0,a0,-1008 # 79b8 <malloc+0x2204>
    4db0:	00001097          	auipc	ra,0x1
    4db4:	946080e7          	jalr	-1722(ra) # 56f6 <printf>
    exit(1);
    4db8:	4505                	li	a0,1
    4dba:	00000097          	auipc	ra,0x0
    4dbe:	5b4080e7          	jalr	1460(ra) # 536e <exit>
      }
    }

    exit(0);
    4dc2:	4501                	li	a0,0
    4dc4:	00000097          	auipc	ra,0x0
    4dc8:	5aa080e7          	jalr	1450(ra) # 536e <exit>
  }

  close(fds[1]);
    4dcc:	fcc42503          	lw	a0,-52(s0)
    4dd0:	00000097          	auipc	ra,0x0
    4dd4:	5c6080e7          	jalr	1478(ra) # 5396 <close>

  int n = 0;
    4dd8:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    4dda:	4605                	li	a2,1
    4ddc:	fc740593          	addi	a1,s0,-57
    4de0:	fc842503          	lw	a0,-56(s0)
    4de4:	00000097          	auipc	ra,0x0
    4de8:	5a2080e7          	jalr	1442(ra) # 5386 <read>
    if(cc < 0){
    4dec:	00054563          	bltz	a0,4df6 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    4df0:	c105                	beqz	a0,4e10 <countfree+0x10a>
      break;
    n += 1;
    4df2:	2485                	addiw	s1,s1,1
  while(1){
    4df4:	b7dd                	j	4dda <countfree+0xd4>
      printf("read() failed in countfree()\n");
    4df6:	00003517          	auipc	a0,0x3
    4dfa:	c0250513          	addi	a0,a0,-1022 # 79f8 <malloc+0x2244>
    4dfe:	00001097          	auipc	ra,0x1
    4e02:	8f8080e7          	jalr	-1800(ra) # 56f6 <printf>
      exit(1);
    4e06:	4505                	li	a0,1
    4e08:	00000097          	auipc	ra,0x0
    4e0c:	566080e7          	jalr	1382(ra) # 536e <exit>
  }

  close(fds[0]);
    4e10:	fc842503          	lw	a0,-56(s0)
    4e14:	00000097          	auipc	ra,0x0
    4e18:	582080e7          	jalr	1410(ra) # 5396 <close>
  wait((int*)0);
    4e1c:	4501                	li	a0,0
    4e1e:	00000097          	auipc	ra,0x0
    4e22:	558080e7          	jalr	1368(ra) # 5376 <wait>
  
  return n;
}
    4e26:	8526                	mv	a0,s1
    4e28:	70e2                	ld	ra,56(sp)
    4e2a:	7442                	ld	s0,48(sp)
    4e2c:	74a2                	ld	s1,40(sp)
    4e2e:	7902                	ld	s2,32(sp)
    4e30:	69e2                	ld	s3,24(sp)
    4e32:	6121                	addi	sp,sp,64
    4e34:	8082                	ret

0000000000004e36 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4e36:	7179                	addi	sp,sp,-48
    4e38:	f406                	sd	ra,40(sp)
    4e3a:	f022                	sd	s0,32(sp)
    4e3c:	ec26                	sd	s1,24(sp)
    4e3e:	e84a                	sd	s2,16(sp)
    4e40:	1800                	addi	s0,sp,48
    4e42:	84aa                	mv	s1,a0
    4e44:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4e46:	00003517          	auipc	a0,0x3
    4e4a:	bd250513          	addi	a0,a0,-1070 # 7a18 <malloc+0x2264>
    4e4e:	00001097          	auipc	ra,0x1
    4e52:	8a8080e7          	jalr	-1880(ra) # 56f6 <printf>
  if((pid = fork()) < 0) {
    4e56:	00000097          	auipc	ra,0x0
    4e5a:	510080e7          	jalr	1296(ra) # 5366 <fork>
    4e5e:	02054e63          	bltz	a0,4e9a <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4e62:	c929                	beqz	a0,4eb4 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4e64:	fdc40513          	addi	a0,s0,-36
    4e68:	00000097          	auipc	ra,0x0
    4e6c:	50e080e7          	jalr	1294(ra) # 5376 <wait>
    if(xstatus != 0) 
    4e70:	fdc42783          	lw	a5,-36(s0)
    4e74:	c7b9                	beqz	a5,4ec2 <run+0x8c>
      printf("FAILED\n");
    4e76:	00003517          	auipc	a0,0x3
    4e7a:	bca50513          	addi	a0,a0,-1078 # 7a40 <malloc+0x228c>
    4e7e:	00001097          	auipc	ra,0x1
    4e82:	878080e7          	jalr	-1928(ra) # 56f6 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4e86:	fdc42503          	lw	a0,-36(s0)
  }
}
    4e8a:	00153513          	seqz	a0,a0
    4e8e:	70a2                	ld	ra,40(sp)
    4e90:	7402                	ld	s0,32(sp)
    4e92:	64e2                	ld	s1,24(sp)
    4e94:	6942                	ld	s2,16(sp)
    4e96:	6145                	addi	sp,sp,48
    4e98:	8082                	ret
    printf("runtest: fork error\n");
    4e9a:	00003517          	auipc	a0,0x3
    4e9e:	b8e50513          	addi	a0,a0,-1138 # 7a28 <malloc+0x2274>
    4ea2:	00001097          	auipc	ra,0x1
    4ea6:	854080e7          	jalr	-1964(ra) # 56f6 <printf>
    exit(1);
    4eaa:	4505                	li	a0,1
    4eac:	00000097          	auipc	ra,0x0
    4eb0:	4c2080e7          	jalr	1218(ra) # 536e <exit>
    f(s);
    4eb4:	854a                	mv	a0,s2
    4eb6:	9482                	jalr	s1
    exit(0);
    4eb8:	4501                	li	a0,0
    4eba:	00000097          	auipc	ra,0x0
    4ebe:	4b4080e7          	jalr	1204(ra) # 536e <exit>
      printf("OK\n");
    4ec2:	00003517          	auipc	a0,0x3
    4ec6:	b8650513          	addi	a0,a0,-1146 # 7a48 <malloc+0x2294>
    4eca:	00001097          	auipc	ra,0x1
    4ece:	82c080e7          	jalr	-2004(ra) # 56f6 <printf>
    4ed2:	bf55                	j	4e86 <run+0x50>

0000000000004ed4 <main>:

int
main(int argc, char *argv[])
{
    4ed4:	c4010113          	addi	sp,sp,-960
    4ed8:	3a113c23          	sd	ra,952(sp)
    4edc:	3a813823          	sd	s0,944(sp)
    4ee0:	3a913423          	sd	s1,936(sp)
    4ee4:	3b213023          	sd	s2,928(sp)
    4ee8:	39313c23          	sd	s3,920(sp)
    4eec:	39413823          	sd	s4,912(sp)
    4ef0:	39513423          	sd	s5,904(sp)
    4ef4:	39613023          	sd	s6,896(sp)
    4ef8:	0780                	addi	s0,sp,960
    4efa:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4efc:	4789                	li	a5,2
    4efe:	08f50763          	beq	a0,a5,4f8c <main+0xb8>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4f02:	4785                	li	a5,1
  char *justone = 0;
    4f04:	4901                	li	s2,0
  } else if(argc > 1){
    4f06:	0ca7c163          	blt	a5,a0,4fc8 <main+0xf4>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    4f0a:	00003797          	auipc	a5,0x3
    4f0e:	c5678793          	addi	a5,a5,-938 # 7b60 <malloc+0x23ac>
    4f12:	c4040713          	addi	a4,s0,-960
    4f16:	00003817          	auipc	a6,0x3
    4f1a:	fca80813          	addi	a6,a6,-54 # 7ee0 <malloc+0x272c>
    4f1e:	6388                	ld	a0,0(a5)
    4f20:	678c                	ld	a1,8(a5)
    4f22:	6b90                	ld	a2,16(a5)
    4f24:	6f94                	ld	a3,24(a5)
    4f26:	e308                	sd	a0,0(a4)
    4f28:	e70c                	sd	a1,8(a4)
    4f2a:	eb10                	sd	a2,16(a4)
    4f2c:	ef14                	sd	a3,24(a4)
    4f2e:	02078793          	addi	a5,a5,32
    4f32:	02070713          	addi	a4,a4,32
    4f36:	ff0794e3          	bne	a5,a6,4f1e <main+0x4a>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    4f3a:	00003517          	auipc	a0,0x3
    4f3e:	bc650513          	addi	a0,a0,-1082 # 7b00 <malloc+0x234c>
    4f42:	00000097          	auipc	ra,0x0
    4f46:	7b4080e7          	jalr	1972(ra) # 56f6 <printf>
  int free0 = countfree();
    4f4a:	00000097          	auipc	ra,0x0
    4f4e:	dbc080e7          	jalr	-580(ra) # 4d06 <countfree>
    4f52:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4f54:	c4843503          	ld	a0,-952(s0)
    4f58:	c4040493          	addi	s1,s0,-960
  int fail = 0;
    4f5c:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    4f5e:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    4f60:	e55d                	bnez	a0,500e <main+0x13a>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    4f62:	00000097          	auipc	ra,0x0
    4f66:	da4080e7          	jalr	-604(ra) # 4d06 <countfree>
    4f6a:	85aa                	mv	a1,a0
    4f6c:	0f455163          	bge	a0,s4,504e <main+0x17a>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4f70:	8652                	mv	a2,s4
    4f72:	00003517          	auipc	a0,0x3
    4f76:	b4650513          	addi	a0,a0,-1210 # 7ab8 <malloc+0x2304>
    4f7a:	00000097          	auipc	ra,0x0
    4f7e:	77c080e7          	jalr	1916(ra) # 56f6 <printf>
    exit(1);
    4f82:	4505                	li	a0,1
    4f84:	00000097          	auipc	ra,0x0
    4f88:	3ea080e7          	jalr	1002(ra) # 536e <exit>
    4f8c:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4f8e:	00003597          	auipc	a1,0x3
    4f92:	ac258593          	addi	a1,a1,-1342 # 7a50 <malloc+0x229c>
    4f96:	6488                	ld	a0,8(s1)
    4f98:	00000097          	auipc	ra,0x0
    4f9c:	184080e7          	jalr	388(ra) # 511c <strcmp>
    4fa0:	10050563          	beqz	a0,50aa <main+0x1d6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4fa4:	00003597          	auipc	a1,0x3
    4fa8:	b9458593          	addi	a1,a1,-1132 # 7b38 <malloc+0x2384>
    4fac:	6488                	ld	a0,8(s1)
    4fae:	00000097          	auipc	ra,0x0
    4fb2:	16e080e7          	jalr	366(ra) # 511c <strcmp>
    4fb6:	c97d                	beqz	a0,50ac <main+0x1d8>
  } else if(argc == 2 && argv[1][0] != '-'){
    4fb8:	0084b903          	ld	s2,8(s1)
    4fbc:	00094703          	lbu	a4,0(s2)
    4fc0:	02d00793          	li	a5,45
    4fc4:	f4f713e3          	bne	a4,a5,4f0a <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    4fc8:	00003517          	auipc	a0,0x3
    4fcc:	a9050513          	addi	a0,a0,-1392 # 7a58 <malloc+0x22a4>
    4fd0:	00000097          	auipc	ra,0x0
    4fd4:	726080e7          	jalr	1830(ra) # 56f6 <printf>
    exit(1);
    4fd8:	4505                	li	a0,1
    4fda:	00000097          	auipc	ra,0x0
    4fde:	394080e7          	jalr	916(ra) # 536e <exit>
          exit(1);
    4fe2:	4505                	li	a0,1
    4fe4:	00000097          	auipc	ra,0x0
    4fe8:	38a080e7          	jalr	906(ra) # 536e <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    4fec:	40a905bb          	subw	a1,s2,a0
    4ff0:	855a                	mv	a0,s6
    4ff2:	00000097          	auipc	ra,0x0
    4ff6:	704080e7          	jalr	1796(ra) # 56f6 <printf>
        if(continuous != 2)
    4ffa:	09498463          	beq	s3,s4,5082 <main+0x1ae>
          exit(1);
    4ffe:	4505                	li	a0,1
    5000:	00000097          	auipc	ra,0x0
    5004:	36e080e7          	jalr	878(ra) # 536e <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5008:	04c1                	addi	s1,s1,16
    500a:	6488                	ld	a0,8(s1)
    500c:	c115                	beqz	a0,5030 <main+0x15c>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    500e:	00090863          	beqz	s2,501e <main+0x14a>
    5012:	85ca                	mv	a1,s2
    5014:	00000097          	auipc	ra,0x0
    5018:	108080e7          	jalr	264(ra) # 511c <strcmp>
    501c:	f575                	bnez	a0,5008 <main+0x134>
      if(!run(t->f, t->s))
    501e:	648c                	ld	a1,8(s1)
    5020:	6088                	ld	a0,0(s1)
    5022:	00000097          	auipc	ra,0x0
    5026:	e14080e7          	jalr	-492(ra) # 4e36 <run>
    502a:	fd79                	bnez	a0,5008 <main+0x134>
        fail = 1;
    502c:	89d6                	mv	s3,s5
    502e:	bfe9                	j	5008 <main+0x134>
  if(fail){
    5030:	f20989e3          	beqz	s3,4f62 <main+0x8e>
    printf("SOME TESTS FAILED\n");
    5034:	00003517          	auipc	a0,0x3
    5038:	a6c50513          	addi	a0,a0,-1428 # 7aa0 <malloc+0x22ec>
    503c:	00000097          	auipc	ra,0x0
    5040:	6ba080e7          	jalr	1722(ra) # 56f6 <printf>
    exit(1);
    5044:	4505                	li	a0,1
    5046:	00000097          	auipc	ra,0x0
    504a:	328080e7          	jalr	808(ra) # 536e <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    504e:	00003517          	auipc	a0,0x3
    5052:	a9a50513          	addi	a0,a0,-1382 # 7ae8 <malloc+0x2334>
    5056:	00000097          	auipc	ra,0x0
    505a:	6a0080e7          	jalr	1696(ra) # 56f6 <printf>
    exit(0);
    505e:	4501                	li	a0,0
    5060:	00000097          	auipc	ra,0x0
    5064:	30e080e7          	jalr	782(ra) # 536e <exit>
        printf("SOME TESTS FAILED\n");
    5068:	8556                	mv	a0,s5
    506a:	00000097          	auipc	ra,0x0
    506e:	68c080e7          	jalr	1676(ra) # 56f6 <printf>
        if(continuous != 2)
    5072:	f74998e3          	bne	s3,s4,4fe2 <main+0x10e>
      int free1 = countfree();
    5076:	00000097          	auipc	ra,0x0
    507a:	c90080e7          	jalr	-880(ra) # 4d06 <countfree>
      if(free1 < free0){
    507e:	f72547e3          	blt	a0,s2,4fec <main+0x118>
      int free0 = countfree();
    5082:	00000097          	auipc	ra,0x0
    5086:	c84080e7          	jalr	-892(ra) # 4d06 <countfree>
    508a:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    508c:	c4843583          	ld	a1,-952(s0)
    5090:	d1fd                	beqz	a1,5076 <main+0x1a2>
    5092:	c4040493          	addi	s1,s0,-960
        if(!run(t->f, t->s)){
    5096:	6088                	ld	a0,0(s1)
    5098:	00000097          	auipc	ra,0x0
    509c:	d9e080e7          	jalr	-610(ra) # 4e36 <run>
    50a0:	d561                	beqz	a0,5068 <main+0x194>
      for (struct test *t = tests; t->s != 0; t++) {
    50a2:	04c1                	addi	s1,s1,16
    50a4:	648c                	ld	a1,8(s1)
    50a6:	f9e5                	bnez	a1,5096 <main+0x1c2>
    50a8:	b7f9                	j	5076 <main+0x1a2>
    continuous = 1;
    50aa:	4985                	li	s3,1
  } tests[] = {
    50ac:	00003797          	auipc	a5,0x3
    50b0:	ab478793          	addi	a5,a5,-1356 # 7b60 <malloc+0x23ac>
    50b4:	c4040713          	addi	a4,s0,-960
    50b8:	00003817          	auipc	a6,0x3
    50bc:	e2880813          	addi	a6,a6,-472 # 7ee0 <malloc+0x272c>
    50c0:	6388                	ld	a0,0(a5)
    50c2:	678c                	ld	a1,8(a5)
    50c4:	6b90                	ld	a2,16(a5)
    50c6:	6f94                	ld	a3,24(a5)
    50c8:	e308                	sd	a0,0(a4)
    50ca:	e70c                	sd	a1,8(a4)
    50cc:	eb10                	sd	a2,16(a4)
    50ce:	ef14                	sd	a3,24(a4)
    50d0:	02078793          	addi	a5,a5,32
    50d4:	02070713          	addi	a4,a4,32
    50d8:	ff0794e3          	bne	a5,a6,50c0 <main+0x1ec>
    printf("continuous usertests starting\n");
    50dc:	00003517          	auipc	a0,0x3
    50e0:	a3c50513          	addi	a0,a0,-1476 # 7b18 <malloc+0x2364>
    50e4:	00000097          	auipc	ra,0x0
    50e8:	612080e7          	jalr	1554(ra) # 56f6 <printf>
        printf("SOME TESTS FAILED\n");
    50ec:	00003a97          	auipc	s5,0x3
    50f0:	9b4a8a93          	addi	s5,s5,-1612 # 7aa0 <malloc+0x22ec>
        if(continuous != 2)
    50f4:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    50f6:	00003b17          	auipc	s6,0x3
    50fa:	98ab0b13          	addi	s6,s6,-1654 # 7a80 <malloc+0x22cc>
    50fe:	b751                	j	5082 <main+0x1ae>

0000000000005100 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    5100:	1141                	addi	sp,sp,-16
    5102:	e422                	sd	s0,8(sp)
    5104:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5106:	87aa                	mv	a5,a0
    5108:	0585                	addi	a1,a1,1
    510a:	0785                	addi	a5,a5,1
    510c:	fff5c703          	lbu	a4,-1(a1)
    5110:	fee78fa3          	sb	a4,-1(a5)
    5114:	fb75                	bnez	a4,5108 <strcpy+0x8>
    ;
  return os;
}
    5116:	6422                	ld	s0,8(sp)
    5118:	0141                	addi	sp,sp,16
    511a:	8082                	ret

000000000000511c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    511c:	1141                	addi	sp,sp,-16
    511e:	e422                	sd	s0,8(sp)
    5120:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5122:	00054783          	lbu	a5,0(a0)
    5126:	cb91                	beqz	a5,513a <strcmp+0x1e>
    5128:	0005c703          	lbu	a4,0(a1)
    512c:	00f71763          	bne	a4,a5,513a <strcmp+0x1e>
    p++, q++;
    5130:	0505                	addi	a0,a0,1
    5132:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5134:	00054783          	lbu	a5,0(a0)
    5138:	fbe5                	bnez	a5,5128 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    513a:	0005c503          	lbu	a0,0(a1)
}
    513e:	40a7853b          	subw	a0,a5,a0
    5142:	6422                	ld	s0,8(sp)
    5144:	0141                	addi	sp,sp,16
    5146:	8082                	ret

0000000000005148 <strlen>:

uint
strlen(const char *s)
{
    5148:	1141                	addi	sp,sp,-16
    514a:	e422                	sd	s0,8(sp)
    514c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    514e:	00054783          	lbu	a5,0(a0)
    5152:	cf91                	beqz	a5,516e <strlen+0x26>
    5154:	0505                	addi	a0,a0,1
    5156:	87aa                	mv	a5,a0
    5158:	4685                	li	a3,1
    515a:	9e89                	subw	a3,a3,a0
    515c:	00f6853b          	addw	a0,a3,a5
    5160:	0785                	addi	a5,a5,1
    5162:	fff7c703          	lbu	a4,-1(a5)
    5166:	fb7d                	bnez	a4,515c <strlen+0x14>
    ;
  return n;
}
    5168:	6422                	ld	s0,8(sp)
    516a:	0141                	addi	sp,sp,16
    516c:	8082                	ret
  for(n = 0; s[n]; n++)
    516e:	4501                	li	a0,0
    5170:	bfe5                	j	5168 <strlen+0x20>

0000000000005172 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5172:	1141                	addi	sp,sp,-16
    5174:	e422                	sd	s0,8(sp)
    5176:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5178:	ca19                	beqz	a2,518e <memset+0x1c>
    517a:	87aa                	mv	a5,a0
    517c:	1602                	slli	a2,a2,0x20
    517e:	9201                	srli	a2,a2,0x20
    5180:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5184:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5188:	0785                	addi	a5,a5,1
    518a:	fee79de3          	bne	a5,a4,5184 <memset+0x12>
  }
  return dst;
}
    518e:	6422                	ld	s0,8(sp)
    5190:	0141                	addi	sp,sp,16
    5192:	8082                	ret

0000000000005194 <strchr>:

char*
strchr(const char *s, char c)
{
    5194:	1141                	addi	sp,sp,-16
    5196:	e422                	sd	s0,8(sp)
    5198:	0800                	addi	s0,sp,16
  for(; *s; s++)
    519a:	00054783          	lbu	a5,0(a0)
    519e:	cb99                	beqz	a5,51b4 <strchr+0x20>
    if(*s == c)
    51a0:	00f58763          	beq	a1,a5,51ae <strchr+0x1a>
  for(; *s; s++)
    51a4:	0505                	addi	a0,a0,1
    51a6:	00054783          	lbu	a5,0(a0)
    51aa:	fbfd                	bnez	a5,51a0 <strchr+0xc>
      return (char*)s;
  return 0;
    51ac:	4501                	li	a0,0
}
    51ae:	6422                	ld	s0,8(sp)
    51b0:	0141                	addi	sp,sp,16
    51b2:	8082                	ret
  return 0;
    51b4:	4501                	li	a0,0
    51b6:	bfe5                	j	51ae <strchr+0x1a>

00000000000051b8 <gets>:

char*
gets(char *buf, int max)
{
    51b8:	711d                	addi	sp,sp,-96
    51ba:	ec86                	sd	ra,88(sp)
    51bc:	e8a2                	sd	s0,80(sp)
    51be:	e4a6                	sd	s1,72(sp)
    51c0:	e0ca                	sd	s2,64(sp)
    51c2:	fc4e                	sd	s3,56(sp)
    51c4:	f852                	sd	s4,48(sp)
    51c6:	f456                	sd	s5,40(sp)
    51c8:	f05a                	sd	s6,32(sp)
    51ca:	ec5e                	sd	s7,24(sp)
    51cc:	1080                	addi	s0,sp,96
    51ce:	8baa                	mv	s7,a0
    51d0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    51d2:	892a                	mv	s2,a0
    51d4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    51d6:	4aa9                	li	s5,10
    51d8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    51da:	89a6                	mv	s3,s1
    51dc:	2485                	addiw	s1,s1,1
    51de:	0344d863          	bge	s1,s4,520e <gets+0x56>
    cc = read(0, &c, 1);
    51e2:	4605                	li	a2,1
    51e4:	faf40593          	addi	a1,s0,-81
    51e8:	4501                	li	a0,0
    51ea:	00000097          	auipc	ra,0x0
    51ee:	19c080e7          	jalr	412(ra) # 5386 <read>
    if(cc < 1)
    51f2:	00a05e63          	blez	a0,520e <gets+0x56>
    buf[i++] = c;
    51f6:	faf44783          	lbu	a5,-81(s0)
    51fa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    51fe:	01578763          	beq	a5,s5,520c <gets+0x54>
    5202:	0905                	addi	s2,s2,1
    5204:	fd679be3          	bne	a5,s6,51da <gets+0x22>
  for(i=0; i+1 < max; ){
    5208:	89a6                	mv	s3,s1
    520a:	a011                	j	520e <gets+0x56>
    520c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    520e:	99de                	add	s3,s3,s7
    5210:	00098023          	sb	zero,0(s3)
  return buf;
}
    5214:	855e                	mv	a0,s7
    5216:	60e6                	ld	ra,88(sp)
    5218:	6446                	ld	s0,80(sp)
    521a:	64a6                	ld	s1,72(sp)
    521c:	6906                	ld	s2,64(sp)
    521e:	79e2                	ld	s3,56(sp)
    5220:	7a42                	ld	s4,48(sp)
    5222:	7aa2                	ld	s5,40(sp)
    5224:	7b02                	ld	s6,32(sp)
    5226:	6be2                	ld	s7,24(sp)
    5228:	6125                	addi	sp,sp,96
    522a:	8082                	ret

000000000000522c <stat>:

int
stat(const char *n, struct stat *st)
{
    522c:	1101                	addi	sp,sp,-32
    522e:	ec06                	sd	ra,24(sp)
    5230:	e822                	sd	s0,16(sp)
    5232:	e426                	sd	s1,8(sp)
    5234:	e04a                	sd	s2,0(sp)
    5236:	1000                	addi	s0,sp,32
    5238:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    523a:	4581                	li	a1,0
    523c:	00000097          	auipc	ra,0x0
    5240:	172080e7          	jalr	370(ra) # 53ae <open>
  if(fd < 0)
    5244:	02054563          	bltz	a0,526e <stat+0x42>
    5248:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    524a:	85ca                	mv	a1,s2
    524c:	00000097          	auipc	ra,0x0
    5250:	17a080e7          	jalr	378(ra) # 53c6 <fstat>
    5254:	892a                	mv	s2,a0
  close(fd);
    5256:	8526                	mv	a0,s1
    5258:	00000097          	auipc	ra,0x0
    525c:	13e080e7          	jalr	318(ra) # 5396 <close>
  return r;
}
    5260:	854a                	mv	a0,s2
    5262:	60e2                	ld	ra,24(sp)
    5264:	6442                	ld	s0,16(sp)
    5266:	64a2                	ld	s1,8(sp)
    5268:	6902                	ld	s2,0(sp)
    526a:	6105                	addi	sp,sp,32
    526c:	8082                	ret
    return -1;
    526e:	597d                	li	s2,-1
    5270:	bfc5                	j	5260 <stat+0x34>

0000000000005272 <atoi>:

int
atoi(const char *s)
{
    5272:	1141                	addi	sp,sp,-16
    5274:	e422                	sd	s0,8(sp)
    5276:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5278:	00054603          	lbu	a2,0(a0)
    527c:	fd06079b          	addiw	a5,a2,-48
    5280:	0ff7f793          	andi	a5,a5,255
    5284:	4725                	li	a4,9
    5286:	02f76963          	bltu	a4,a5,52b8 <atoi+0x46>
    528a:	86aa                	mv	a3,a0
  n = 0;
    528c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    528e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5290:	0685                	addi	a3,a3,1
    5292:	0025179b          	slliw	a5,a0,0x2
    5296:	9fa9                	addw	a5,a5,a0
    5298:	0017979b          	slliw	a5,a5,0x1
    529c:	9fb1                	addw	a5,a5,a2
    529e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    52a2:	0006c603          	lbu	a2,0(a3)
    52a6:	fd06071b          	addiw	a4,a2,-48
    52aa:	0ff77713          	andi	a4,a4,255
    52ae:	fee5f1e3          	bgeu	a1,a4,5290 <atoi+0x1e>
  return n;
}
    52b2:	6422                	ld	s0,8(sp)
    52b4:	0141                	addi	sp,sp,16
    52b6:	8082                	ret
  n = 0;
    52b8:	4501                	li	a0,0
    52ba:	bfe5                	j	52b2 <atoi+0x40>

00000000000052bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    52bc:	1141                	addi	sp,sp,-16
    52be:	e422                	sd	s0,8(sp)
    52c0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    52c2:	02b57463          	bgeu	a0,a1,52ea <memmove+0x2e>
    while(n-- > 0)
    52c6:	00c05f63          	blez	a2,52e4 <memmove+0x28>
    52ca:	1602                	slli	a2,a2,0x20
    52cc:	9201                	srli	a2,a2,0x20
    52ce:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    52d2:	872a                	mv	a4,a0
      *dst++ = *src++;
    52d4:	0585                	addi	a1,a1,1
    52d6:	0705                	addi	a4,a4,1
    52d8:	fff5c683          	lbu	a3,-1(a1)
    52dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    52e0:	fee79ae3          	bne	a5,a4,52d4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    52e4:	6422                	ld	s0,8(sp)
    52e6:	0141                	addi	sp,sp,16
    52e8:	8082                	ret
    dst += n;
    52ea:	00c50733          	add	a4,a0,a2
    src += n;
    52ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    52f0:	fec05ae3          	blez	a2,52e4 <memmove+0x28>
    52f4:	fff6079b          	addiw	a5,a2,-1
    52f8:	1782                	slli	a5,a5,0x20
    52fa:	9381                	srli	a5,a5,0x20
    52fc:	fff7c793          	not	a5,a5
    5300:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5302:	15fd                	addi	a1,a1,-1
    5304:	177d                	addi	a4,a4,-1
    5306:	0005c683          	lbu	a3,0(a1)
    530a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    530e:	fee79ae3          	bne	a5,a4,5302 <memmove+0x46>
    5312:	bfc9                	j	52e4 <memmove+0x28>

0000000000005314 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5314:	1141                	addi	sp,sp,-16
    5316:	e422                	sd	s0,8(sp)
    5318:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    531a:	ca05                	beqz	a2,534a <memcmp+0x36>
    531c:	fff6069b          	addiw	a3,a2,-1
    5320:	1682                	slli	a3,a3,0x20
    5322:	9281                	srli	a3,a3,0x20
    5324:	0685                	addi	a3,a3,1
    5326:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5328:	00054783          	lbu	a5,0(a0)
    532c:	0005c703          	lbu	a4,0(a1)
    5330:	00e79863          	bne	a5,a4,5340 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5334:	0505                	addi	a0,a0,1
    p2++;
    5336:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5338:	fed518e3          	bne	a0,a3,5328 <memcmp+0x14>
  }
  return 0;
    533c:	4501                	li	a0,0
    533e:	a019                	j	5344 <memcmp+0x30>
      return *p1 - *p2;
    5340:	40e7853b          	subw	a0,a5,a4
}
    5344:	6422                	ld	s0,8(sp)
    5346:	0141                	addi	sp,sp,16
    5348:	8082                	ret
  return 0;
    534a:	4501                	li	a0,0
    534c:	bfe5                	j	5344 <memcmp+0x30>

000000000000534e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    534e:	1141                	addi	sp,sp,-16
    5350:	e406                	sd	ra,8(sp)
    5352:	e022                	sd	s0,0(sp)
    5354:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5356:	00000097          	auipc	ra,0x0
    535a:	f66080e7          	jalr	-154(ra) # 52bc <memmove>
}
    535e:	60a2                	ld	ra,8(sp)
    5360:	6402                	ld	s0,0(sp)
    5362:	0141                	addi	sp,sp,16
    5364:	8082                	ret

0000000000005366 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5366:	4885                	li	a7,1
 ecall
    5368:	00000073          	ecall
 ret
    536c:	8082                	ret

000000000000536e <exit>:
.global exit
exit:
 li a7, SYS_exit
    536e:	4889                	li	a7,2
 ecall
    5370:	00000073          	ecall
 ret
    5374:	8082                	ret

0000000000005376 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5376:	488d                	li	a7,3
 ecall
    5378:	00000073          	ecall
 ret
    537c:	8082                	ret

000000000000537e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    537e:	4891                	li	a7,4
 ecall
    5380:	00000073          	ecall
 ret
    5384:	8082                	ret

0000000000005386 <read>:
.global read
read:
 li a7, SYS_read
    5386:	4895                	li	a7,5
 ecall
    5388:	00000073          	ecall
 ret
    538c:	8082                	ret

000000000000538e <write>:
.global write
write:
 li a7, SYS_write
    538e:	48c1                	li	a7,16
 ecall
    5390:	00000073          	ecall
 ret
    5394:	8082                	ret

0000000000005396 <close>:
.global close
close:
 li a7, SYS_close
    5396:	48d5                	li	a7,21
 ecall
    5398:	00000073          	ecall
 ret
    539c:	8082                	ret

000000000000539e <kill>:
.global kill
kill:
 li a7, SYS_kill
    539e:	4899                	li	a7,6
 ecall
    53a0:	00000073          	ecall
 ret
    53a4:	8082                	ret

00000000000053a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
    53a6:	489d                	li	a7,7
 ecall
    53a8:	00000073          	ecall
 ret
    53ac:	8082                	ret

00000000000053ae <open>:
.global open
open:
 li a7, SYS_open
    53ae:	48bd                	li	a7,15
 ecall
    53b0:	00000073          	ecall
 ret
    53b4:	8082                	ret

00000000000053b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    53b6:	48c5                	li	a7,17
 ecall
    53b8:	00000073          	ecall
 ret
    53bc:	8082                	ret

00000000000053be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    53be:	48c9                	li	a7,18
 ecall
    53c0:	00000073          	ecall
 ret
    53c4:	8082                	ret

00000000000053c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    53c6:	48a1                	li	a7,8
 ecall
    53c8:	00000073          	ecall
 ret
    53cc:	8082                	ret

00000000000053ce <link>:
.global link
link:
 li a7, SYS_link
    53ce:	48cd                	li	a7,19
 ecall
    53d0:	00000073          	ecall
 ret
    53d4:	8082                	ret

00000000000053d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    53d6:	48d1                	li	a7,20
 ecall
    53d8:	00000073          	ecall
 ret
    53dc:	8082                	ret

00000000000053de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    53de:	48a5                	li	a7,9
 ecall
    53e0:	00000073          	ecall
 ret
    53e4:	8082                	ret

00000000000053e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
    53e6:	48a9                	li	a7,10
 ecall
    53e8:	00000073          	ecall
 ret
    53ec:	8082                	ret

00000000000053ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    53ee:	48ad                	li	a7,11
 ecall
    53f0:	00000073          	ecall
 ret
    53f4:	8082                	ret

00000000000053f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    53f6:	48b1                	li	a7,12
 ecall
    53f8:	00000073          	ecall
 ret
    53fc:	8082                	ret

00000000000053fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    53fe:	48b5                	li	a7,13
 ecall
    5400:	00000073          	ecall
 ret
    5404:	8082                	ret

0000000000005406 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5406:	48b9                	li	a7,14
 ecall
    5408:	00000073          	ecall
 ret
    540c:	8082                	ret

000000000000540e <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
    540e:	48d9                	li	a7,22
 ecall
    5410:	00000073          	ecall
 ret
    5414:	8082                	ret

0000000000005416 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
    5416:	48dd                	li	a7,23
 ecall
    5418:	00000073          	ecall
 ret
    541c:	8082                	ret

000000000000541e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    541e:	1101                	addi	sp,sp,-32
    5420:	ec06                	sd	ra,24(sp)
    5422:	e822                	sd	s0,16(sp)
    5424:	1000                	addi	s0,sp,32
    5426:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    542a:	4605                	li	a2,1
    542c:	fef40593          	addi	a1,s0,-17
    5430:	00000097          	auipc	ra,0x0
    5434:	f5e080e7          	jalr	-162(ra) # 538e <write>
}
    5438:	60e2                	ld	ra,24(sp)
    543a:	6442                	ld	s0,16(sp)
    543c:	6105                	addi	sp,sp,32
    543e:	8082                	ret

0000000000005440 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5440:	7139                	addi	sp,sp,-64
    5442:	fc06                	sd	ra,56(sp)
    5444:	f822                	sd	s0,48(sp)
    5446:	f426                	sd	s1,40(sp)
    5448:	f04a                	sd	s2,32(sp)
    544a:	ec4e                	sd	s3,24(sp)
    544c:	0080                	addi	s0,sp,64
    544e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5450:	c299                	beqz	a3,5456 <printint+0x16>
    5452:	0805c863          	bltz	a1,54e2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5456:	2581                	sext.w	a1,a1
  neg = 0;
    5458:	4881                	li	a7,0
    545a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    545e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5460:	2601                	sext.w	a2,a2
    5462:	00003517          	auipc	a0,0x3
    5466:	a8650513          	addi	a0,a0,-1402 # 7ee8 <digits>
    546a:	883a                	mv	a6,a4
    546c:	2705                	addiw	a4,a4,1
    546e:	02c5f7bb          	remuw	a5,a1,a2
    5472:	1782                	slli	a5,a5,0x20
    5474:	9381                	srli	a5,a5,0x20
    5476:	97aa                	add	a5,a5,a0
    5478:	0007c783          	lbu	a5,0(a5)
    547c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5480:	0005879b          	sext.w	a5,a1
    5484:	02c5d5bb          	divuw	a1,a1,a2
    5488:	0685                	addi	a3,a3,1
    548a:	fec7f0e3          	bgeu	a5,a2,546a <printint+0x2a>
  if(neg)
    548e:	00088b63          	beqz	a7,54a4 <printint+0x64>
    buf[i++] = '-';
    5492:	fd040793          	addi	a5,s0,-48
    5496:	973e                	add	a4,a4,a5
    5498:	02d00793          	li	a5,45
    549c:	fef70823          	sb	a5,-16(a4)
    54a0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    54a4:	02e05863          	blez	a4,54d4 <printint+0x94>
    54a8:	fc040793          	addi	a5,s0,-64
    54ac:	00e78933          	add	s2,a5,a4
    54b0:	fff78993          	addi	s3,a5,-1
    54b4:	99ba                	add	s3,s3,a4
    54b6:	377d                	addiw	a4,a4,-1
    54b8:	1702                	slli	a4,a4,0x20
    54ba:	9301                	srli	a4,a4,0x20
    54bc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    54c0:	fff94583          	lbu	a1,-1(s2)
    54c4:	8526                	mv	a0,s1
    54c6:	00000097          	auipc	ra,0x0
    54ca:	f58080e7          	jalr	-168(ra) # 541e <putc>
  while(--i >= 0)
    54ce:	197d                	addi	s2,s2,-1
    54d0:	ff3918e3          	bne	s2,s3,54c0 <printint+0x80>
}
    54d4:	70e2                	ld	ra,56(sp)
    54d6:	7442                	ld	s0,48(sp)
    54d8:	74a2                	ld	s1,40(sp)
    54da:	7902                	ld	s2,32(sp)
    54dc:	69e2                	ld	s3,24(sp)
    54de:	6121                	addi	sp,sp,64
    54e0:	8082                	ret
    x = -xx;
    54e2:	40b005bb          	negw	a1,a1
    neg = 1;
    54e6:	4885                	li	a7,1
    x = -xx;
    54e8:	bf8d                	j	545a <printint+0x1a>

00000000000054ea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    54ea:	7119                	addi	sp,sp,-128
    54ec:	fc86                	sd	ra,120(sp)
    54ee:	f8a2                	sd	s0,112(sp)
    54f0:	f4a6                	sd	s1,104(sp)
    54f2:	f0ca                	sd	s2,96(sp)
    54f4:	ecce                	sd	s3,88(sp)
    54f6:	e8d2                	sd	s4,80(sp)
    54f8:	e4d6                	sd	s5,72(sp)
    54fa:	e0da                	sd	s6,64(sp)
    54fc:	fc5e                	sd	s7,56(sp)
    54fe:	f862                	sd	s8,48(sp)
    5500:	f466                	sd	s9,40(sp)
    5502:	f06a                	sd	s10,32(sp)
    5504:	ec6e                	sd	s11,24(sp)
    5506:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5508:	0005c903          	lbu	s2,0(a1)
    550c:	18090f63          	beqz	s2,56aa <vprintf+0x1c0>
    5510:	8aaa                	mv	s5,a0
    5512:	8b32                	mv	s6,a2
    5514:	00158493          	addi	s1,a1,1
  state = 0;
    5518:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    551a:	02500a13          	li	s4,37
      if(c == 'd'){
    551e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5522:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5526:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    552a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    552e:	00003b97          	auipc	s7,0x3
    5532:	9bab8b93          	addi	s7,s7,-1606 # 7ee8 <digits>
    5536:	a839                	j	5554 <vprintf+0x6a>
        putc(fd, c);
    5538:	85ca                	mv	a1,s2
    553a:	8556                	mv	a0,s5
    553c:	00000097          	auipc	ra,0x0
    5540:	ee2080e7          	jalr	-286(ra) # 541e <putc>
    5544:	a019                	j	554a <vprintf+0x60>
    } else if(state == '%'){
    5546:	01498f63          	beq	s3,s4,5564 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    554a:	0485                	addi	s1,s1,1
    554c:	fff4c903          	lbu	s2,-1(s1)
    5550:	14090d63          	beqz	s2,56aa <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5554:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5558:	fe0997e3          	bnez	s3,5546 <vprintf+0x5c>
      if(c == '%'){
    555c:	fd479ee3          	bne	a5,s4,5538 <vprintf+0x4e>
        state = '%';
    5560:	89be                	mv	s3,a5
    5562:	b7e5                	j	554a <vprintf+0x60>
      if(c == 'd'){
    5564:	05878063          	beq	a5,s8,55a4 <vprintf+0xba>
      } else if(c == 'l') {
    5568:	05978c63          	beq	a5,s9,55c0 <vprintf+0xd6>
      } else if(c == 'x') {
    556c:	07a78863          	beq	a5,s10,55dc <vprintf+0xf2>
      } else if(c == 'p') {
    5570:	09b78463          	beq	a5,s11,55f8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5574:	07300713          	li	a4,115
    5578:	0ce78663          	beq	a5,a4,5644 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    557c:	06300713          	li	a4,99
    5580:	0ee78e63          	beq	a5,a4,567c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5584:	11478863          	beq	a5,s4,5694 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5588:	85d2                	mv	a1,s4
    558a:	8556                	mv	a0,s5
    558c:	00000097          	auipc	ra,0x0
    5590:	e92080e7          	jalr	-366(ra) # 541e <putc>
        putc(fd, c);
    5594:	85ca                	mv	a1,s2
    5596:	8556                	mv	a0,s5
    5598:	00000097          	auipc	ra,0x0
    559c:	e86080e7          	jalr	-378(ra) # 541e <putc>
      }
      state = 0;
    55a0:	4981                	li	s3,0
    55a2:	b765                	j	554a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    55a4:	008b0913          	addi	s2,s6,8
    55a8:	4685                	li	a3,1
    55aa:	4629                	li	a2,10
    55ac:	000b2583          	lw	a1,0(s6)
    55b0:	8556                	mv	a0,s5
    55b2:	00000097          	auipc	ra,0x0
    55b6:	e8e080e7          	jalr	-370(ra) # 5440 <printint>
    55ba:	8b4a                	mv	s6,s2
      state = 0;
    55bc:	4981                	li	s3,0
    55be:	b771                	j	554a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    55c0:	008b0913          	addi	s2,s6,8
    55c4:	4681                	li	a3,0
    55c6:	4629                	li	a2,10
    55c8:	000b2583          	lw	a1,0(s6)
    55cc:	8556                	mv	a0,s5
    55ce:	00000097          	auipc	ra,0x0
    55d2:	e72080e7          	jalr	-398(ra) # 5440 <printint>
    55d6:	8b4a                	mv	s6,s2
      state = 0;
    55d8:	4981                	li	s3,0
    55da:	bf85                	j	554a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    55dc:	008b0913          	addi	s2,s6,8
    55e0:	4681                	li	a3,0
    55e2:	4641                	li	a2,16
    55e4:	000b2583          	lw	a1,0(s6)
    55e8:	8556                	mv	a0,s5
    55ea:	00000097          	auipc	ra,0x0
    55ee:	e56080e7          	jalr	-426(ra) # 5440 <printint>
    55f2:	8b4a                	mv	s6,s2
      state = 0;
    55f4:	4981                	li	s3,0
    55f6:	bf91                	j	554a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    55f8:	008b0793          	addi	a5,s6,8
    55fc:	f8f43423          	sd	a5,-120(s0)
    5600:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5604:	03000593          	li	a1,48
    5608:	8556                	mv	a0,s5
    560a:	00000097          	auipc	ra,0x0
    560e:	e14080e7          	jalr	-492(ra) # 541e <putc>
  putc(fd, 'x');
    5612:	85ea                	mv	a1,s10
    5614:	8556                	mv	a0,s5
    5616:	00000097          	auipc	ra,0x0
    561a:	e08080e7          	jalr	-504(ra) # 541e <putc>
    561e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5620:	03c9d793          	srli	a5,s3,0x3c
    5624:	97de                	add	a5,a5,s7
    5626:	0007c583          	lbu	a1,0(a5)
    562a:	8556                	mv	a0,s5
    562c:	00000097          	auipc	ra,0x0
    5630:	df2080e7          	jalr	-526(ra) # 541e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5634:	0992                	slli	s3,s3,0x4
    5636:	397d                	addiw	s2,s2,-1
    5638:	fe0914e3          	bnez	s2,5620 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    563c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5640:	4981                	li	s3,0
    5642:	b721                	j	554a <vprintf+0x60>
        s = va_arg(ap, char*);
    5644:	008b0993          	addi	s3,s6,8
    5648:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    564c:	02090163          	beqz	s2,566e <vprintf+0x184>
        while(*s != 0){
    5650:	00094583          	lbu	a1,0(s2)
    5654:	c9a1                	beqz	a1,56a4 <vprintf+0x1ba>
          putc(fd, *s);
    5656:	8556                	mv	a0,s5
    5658:	00000097          	auipc	ra,0x0
    565c:	dc6080e7          	jalr	-570(ra) # 541e <putc>
          s++;
    5660:	0905                	addi	s2,s2,1
        while(*s != 0){
    5662:	00094583          	lbu	a1,0(s2)
    5666:	f9e5                	bnez	a1,5656 <vprintf+0x16c>
        s = va_arg(ap, char*);
    5668:	8b4e                	mv	s6,s3
      state = 0;
    566a:	4981                	li	s3,0
    566c:	bdf9                	j	554a <vprintf+0x60>
          s = "(null)";
    566e:	00003917          	auipc	s2,0x3
    5672:	87290913          	addi	s2,s2,-1934 # 7ee0 <malloc+0x272c>
        while(*s != 0){
    5676:	02800593          	li	a1,40
    567a:	bff1                	j	5656 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    567c:	008b0913          	addi	s2,s6,8
    5680:	000b4583          	lbu	a1,0(s6)
    5684:	8556                	mv	a0,s5
    5686:	00000097          	auipc	ra,0x0
    568a:	d98080e7          	jalr	-616(ra) # 541e <putc>
    568e:	8b4a                	mv	s6,s2
      state = 0;
    5690:	4981                	li	s3,0
    5692:	bd65                	j	554a <vprintf+0x60>
        putc(fd, c);
    5694:	85d2                	mv	a1,s4
    5696:	8556                	mv	a0,s5
    5698:	00000097          	auipc	ra,0x0
    569c:	d86080e7          	jalr	-634(ra) # 541e <putc>
      state = 0;
    56a0:	4981                	li	s3,0
    56a2:	b565                	j	554a <vprintf+0x60>
        s = va_arg(ap, char*);
    56a4:	8b4e                	mv	s6,s3
      state = 0;
    56a6:	4981                	li	s3,0
    56a8:	b54d                	j	554a <vprintf+0x60>
    }
  }
}
    56aa:	70e6                	ld	ra,120(sp)
    56ac:	7446                	ld	s0,112(sp)
    56ae:	74a6                	ld	s1,104(sp)
    56b0:	7906                	ld	s2,96(sp)
    56b2:	69e6                	ld	s3,88(sp)
    56b4:	6a46                	ld	s4,80(sp)
    56b6:	6aa6                	ld	s5,72(sp)
    56b8:	6b06                	ld	s6,64(sp)
    56ba:	7be2                	ld	s7,56(sp)
    56bc:	7c42                	ld	s8,48(sp)
    56be:	7ca2                	ld	s9,40(sp)
    56c0:	7d02                	ld	s10,32(sp)
    56c2:	6de2                	ld	s11,24(sp)
    56c4:	6109                	addi	sp,sp,128
    56c6:	8082                	ret

00000000000056c8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    56c8:	715d                	addi	sp,sp,-80
    56ca:	ec06                	sd	ra,24(sp)
    56cc:	e822                	sd	s0,16(sp)
    56ce:	1000                	addi	s0,sp,32
    56d0:	e010                	sd	a2,0(s0)
    56d2:	e414                	sd	a3,8(s0)
    56d4:	e818                	sd	a4,16(s0)
    56d6:	ec1c                	sd	a5,24(s0)
    56d8:	03043023          	sd	a6,32(s0)
    56dc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    56e0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    56e4:	8622                	mv	a2,s0
    56e6:	00000097          	auipc	ra,0x0
    56ea:	e04080e7          	jalr	-508(ra) # 54ea <vprintf>
}
    56ee:	60e2                	ld	ra,24(sp)
    56f0:	6442                	ld	s0,16(sp)
    56f2:	6161                	addi	sp,sp,80
    56f4:	8082                	ret

00000000000056f6 <printf>:

void
printf(const char *fmt, ...)
{
    56f6:	711d                	addi	sp,sp,-96
    56f8:	ec06                	sd	ra,24(sp)
    56fa:	e822                	sd	s0,16(sp)
    56fc:	1000                	addi	s0,sp,32
    56fe:	e40c                	sd	a1,8(s0)
    5700:	e810                	sd	a2,16(s0)
    5702:	ec14                	sd	a3,24(s0)
    5704:	f018                	sd	a4,32(s0)
    5706:	f41c                	sd	a5,40(s0)
    5708:	03043823          	sd	a6,48(s0)
    570c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5710:	00840613          	addi	a2,s0,8
    5714:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5718:	85aa                	mv	a1,a0
    571a:	4505                	li	a0,1
    571c:	00000097          	auipc	ra,0x0
    5720:	dce080e7          	jalr	-562(ra) # 54ea <vprintf>
}
    5724:	60e2                	ld	ra,24(sp)
    5726:	6442                	ld	s0,16(sp)
    5728:	6125                	addi	sp,sp,96
    572a:	8082                	ret

000000000000572c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    572c:	1141                	addi	sp,sp,-16
    572e:	e422                	sd	s0,8(sp)
    5730:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5732:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5736:	00002797          	auipc	a5,0x2
    573a:	7e27b783          	ld	a5,2018(a5) # 7f18 <freep>
    573e:	a805                	j	576e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5740:	4618                	lw	a4,8(a2)
    5742:	9db9                	addw	a1,a1,a4
    5744:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5748:	6398                	ld	a4,0(a5)
    574a:	6318                	ld	a4,0(a4)
    574c:	fee53823          	sd	a4,-16(a0)
    5750:	a091                	j	5794 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5752:	ff852703          	lw	a4,-8(a0)
    5756:	9e39                	addw	a2,a2,a4
    5758:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    575a:	ff053703          	ld	a4,-16(a0)
    575e:	e398                	sd	a4,0(a5)
    5760:	a099                	j	57a6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5762:	6398                	ld	a4,0(a5)
    5764:	00e7e463          	bltu	a5,a4,576c <free+0x40>
    5768:	00e6ea63          	bltu	a3,a4,577c <free+0x50>
{
    576c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    576e:	fed7fae3          	bgeu	a5,a3,5762 <free+0x36>
    5772:	6398                	ld	a4,0(a5)
    5774:	00e6e463          	bltu	a3,a4,577c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5778:	fee7eae3          	bltu	a5,a4,576c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    577c:	ff852583          	lw	a1,-8(a0)
    5780:	6390                	ld	a2,0(a5)
    5782:	02059713          	slli	a4,a1,0x20
    5786:	9301                	srli	a4,a4,0x20
    5788:	0712                	slli	a4,a4,0x4
    578a:	9736                	add	a4,a4,a3
    578c:	fae60ae3          	beq	a2,a4,5740 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5790:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5794:	4790                	lw	a2,8(a5)
    5796:	02061713          	slli	a4,a2,0x20
    579a:	9301                	srli	a4,a4,0x20
    579c:	0712                	slli	a4,a4,0x4
    579e:	973e                	add	a4,a4,a5
    57a0:	fae689e3          	beq	a3,a4,5752 <free+0x26>
  } else
    p->s.ptr = bp;
    57a4:	e394                	sd	a3,0(a5)
  freep = p;
    57a6:	00002717          	auipc	a4,0x2
    57aa:	76f73923          	sd	a5,1906(a4) # 7f18 <freep>
}
    57ae:	6422                	ld	s0,8(sp)
    57b0:	0141                	addi	sp,sp,16
    57b2:	8082                	ret

00000000000057b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    57b4:	7139                	addi	sp,sp,-64
    57b6:	fc06                	sd	ra,56(sp)
    57b8:	f822                	sd	s0,48(sp)
    57ba:	f426                	sd	s1,40(sp)
    57bc:	f04a                	sd	s2,32(sp)
    57be:	ec4e                	sd	s3,24(sp)
    57c0:	e852                	sd	s4,16(sp)
    57c2:	e456                	sd	s5,8(sp)
    57c4:	e05a                	sd	s6,0(sp)
    57c6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    57c8:	02051493          	slli	s1,a0,0x20
    57cc:	9081                	srli	s1,s1,0x20
    57ce:	04bd                	addi	s1,s1,15
    57d0:	8091                	srli	s1,s1,0x4
    57d2:	0014899b          	addiw	s3,s1,1
    57d6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    57d8:	00002517          	auipc	a0,0x2
    57dc:	74053503          	ld	a0,1856(a0) # 7f18 <freep>
    57e0:	c515                	beqz	a0,580c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    57e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    57e4:	4798                	lw	a4,8(a5)
    57e6:	02977f63          	bgeu	a4,s1,5824 <malloc+0x70>
    57ea:	8a4e                	mv	s4,s3
    57ec:	0009871b          	sext.w	a4,s3
    57f0:	6685                	lui	a3,0x1
    57f2:	00d77363          	bgeu	a4,a3,57f8 <malloc+0x44>
    57f6:	6a05                	lui	s4,0x1
    57f8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    57fc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5800:	00002917          	auipc	s2,0x2
    5804:	71890913          	addi	s2,s2,1816 # 7f18 <freep>
  if(p == (char*)-1)
    5808:	5afd                	li	s5,-1
    580a:	a88d                	j	587c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    580c:	00009797          	auipc	a5,0x9
    5810:	f2c78793          	addi	a5,a5,-212 # e738 <base>
    5814:	00002717          	auipc	a4,0x2
    5818:	70f73223          	sd	a5,1796(a4) # 7f18 <freep>
    581c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    581e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5822:	b7e1                	j	57ea <malloc+0x36>
      if(p->s.size == nunits)
    5824:	02e48b63          	beq	s1,a4,585a <malloc+0xa6>
        p->s.size -= nunits;
    5828:	4137073b          	subw	a4,a4,s3
    582c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    582e:	1702                	slli	a4,a4,0x20
    5830:	9301                	srli	a4,a4,0x20
    5832:	0712                	slli	a4,a4,0x4
    5834:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5836:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    583a:	00002717          	auipc	a4,0x2
    583e:	6ca73f23          	sd	a0,1758(a4) # 7f18 <freep>
      return (void*)(p + 1);
    5842:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5846:	70e2                	ld	ra,56(sp)
    5848:	7442                	ld	s0,48(sp)
    584a:	74a2                	ld	s1,40(sp)
    584c:	7902                	ld	s2,32(sp)
    584e:	69e2                	ld	s3,24(sp)
    5850:	6a42                	ld	s4,16(sp)
    5852:	6aa2                	ld	s5,8(sp)
    5854:	6b02                	ld	s6,0(sp)
    5856:	6121                	addi	sp,sp,64
    5858:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    585a:	6398                	ld	a4,0(a5)
    585c:	e118                	sd	a4,0(a0)
    585e:	bff1                	j	583a <malloc+0x86>
  hp->s.size = nu;
    5860:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5864:	0541                	addi	a0,a0,16
    5866:	00000097          	auipc	ra,0x0
    586a:	ec6080e7          	jalr	-314(ra) # 572c <free>
  return freep;
    586e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5872:	d971                	beqz	a0,5846 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5874:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5876:	4798                	lw	a4,8(a5)
    5878:	fa9776e3          	bgeu	a4,s1,5824 <malloc+0x70>
    if(p == freep)
    587c:	00093703          	ld	a4,0(s2)
    5880:	853e                	mv	a0,a5
    5882:	fef719e3          	bne	a4,a5,5874 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    5886:	8552                	mv	a0,s4
    5888:	00000097          	auipc	ra,0x0
    588c:	b6e080e7          	jalr	-1170(ra) # 53f6 <sbrk>
  if(p == (char*)-1)
    5890:	fd5518e3          	bne	a0,s5,5860 <malloc+0xac>
        return 0;
    5894:	4501                	li	a0,0
    5896:	bf45                	j	5846 <malloc+0x92>
