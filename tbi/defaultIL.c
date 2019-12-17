#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define aByte unsigned char


char* DefaultIL() {
  static char s[9000];    // be sure to increase size if you add text
  strcpy(s,"0000 ;       1 .  ORIGINAL TINY BASIC INTERMEDIATE INTERPRETER\n");
  strcat(s,"0000 ;       2 .\n");
  strcat(s,"0000 ;       3 .  EXECUTIVE INITIALIZATION\n");
  strcat(s,"0000 ;       4 .\n");
  strcat(s,"0000 ;       5 :STRT PC \":Q^\"        COLON, X-ON\n");
  strcat(s,"0000 243A91;\n");
  strcat(s,"0003 ;       6       GL\n");
  strcat(s,"0003 27;     7       SB\n");
  strcat(s,"0004 10;     8       BE L0           BRANCH IF NOT EMPTY\n");
  strcat(s,"0005 E1;     9       BR STRT         TRY AGAIN IF NULL LINE\n");
  strcat(s,"0006 59;    10 :L0   BN STMT         TEST FOR LINE NUMBER\n");
  strcat(s,"0007 C5;    11       IL              IF SO, INSERT INTO PROGRAM\n");
  strcat(s,"0008 2A;    12       BR STRT         GO GET NEXT\n");
  strcat(s,"0009 56;    13 :XEC  SB              SAVE POINTERS FOR RUN WITH\n");
  strcat(s,"000A 10;    14       RB                CONCATENATED INPUT\n");
  strcat(s,"000B 11;    15       XQ\n");
  strcat(s,"000C 2C;    16 .\n");
  strcat(s,"000D ;      17 .  STATEMENT EXECUTOR\n");
  strcat(s,"000D ;      18 .\n");
  strcat(s,"000D ;      19 :STMT BC GOTO \"LET\"\n");
  strcat(s,"000D 8B4C45D4;\n");
  strcat(s,"0011 ;      20       BV *            MUST BE A VARIABLE NAME\n");
  strcat(s,"0011 A0;    21       BC * \"=\"\n");
  strcat(s,"0012 80BD;  22 :LET  JS EXPR         GO GET EXPRESSION\n");
  strcat(s,"0014 30BC;  23       BE *            IF STATEMENT END,\n");
  strcat(s,"0016 E0;    24       SV                STORE RESULT\n");
  strcat(s,"0017 13;    25       NX\n");
  strcat(s,"0018 1D;    26 .\n");
  strcat(s,"0019 ;      27 :GOTO BC PRNT \"GO\"\n");
  strcat(s,"0019 9447CF;\n");
  strcat(s,"001C ;      28       BC GOSB \"TO\"\n");
  strcat(s,"001C 8854CF;\n");
  strcat(s,"001F ;      29       JS EXPR         GET LINE NUMBER\n");
  strcat(s,"001F 30BC;  30       BE *\n");
  strcat(s,"0021 E0;    31       SB              (DO THIS FOR STARTING)\n");
  strcat(s,"0022 10;    32       RB\n");
  strcat(s,"0023 11;    33       GO              GO THERE\n");
  strcat(s,"0024 16;    34 .\n");
  strcat(s,"0025 ;      35 :GOSB BC * \"SUB\"      NO OTHER WORD BEGINS \"GO...\"\n");
  strcat(s,"0025 805355C2;\n");
  strcat(s,"0029 ;      36       JS EXPR\n");
  strcat(s,"0029 30BC;  37       BE *\n");
  strcat(s,"002B E0;    38       GS\n");
  strcat(s,"002C 14;    39       GO\n");
  strcat(s,"002D 16;    40 .\n");
  strcat(s,"002E ;      41 :PRNT BC SKIP \"PR\"\n");
  strcat(s,"002E 9050D2;\n");
  strcat(s,"0031 ;      42       BC P0 \"INT\"     OPTIONALLY OMIT \"INT\"\n");
  strcat(s,"0031 83494ED4;\n");
  strcat(s,"0035 ;      43 :P0   BE P3\n");
  strcat(s,"0035 E5;    44       BR P6           IF DONE, GO TO END\n");
  strcat(s,"0036 71;    45 :P1   BC P4 \";\"\n");
  strcat(s,"0037 88BB;  46 :P2   BE P3\n");
  strcat(s,"0039 E1;    47       NX              NO CRLF IF ENDED BY ; OR ,\n");
  strcat(s,"003A 1D;    48 :P3   BC P7 '\"'\n");
  strcat(s,"003B 8FA2;  49       PQ              QUOTE MARKS STRING\n");
  strcat(s,"003D 21;    50       BR P1           GO CHECK DELIMITER\n");
  strcat(s,"003E 58;    51 :SKIP BR IF           (ON THE WAY THRU)\n");
  strcat(s,"003F 6F;    52 :P4   BC P5 \",\"\n");
  strcat(s,"0040 83AC;  53       PT              COMMA SPACING\n");
  strcat(s,"0042 22;    54       BR P2\n");
  strcat(s,"0043 55;    55 :P5   BC P6 \":\"\n");
  strcat(s,"0044 83BA;  56       PC \"S^\"         OUTPUT X-OFF\n");
  strcat(s,"0046 2493;  57 :P6   BE *\n");
  strcat(s,"0048 E0;    58       NL              THEN CRLF\n");
  strcat(s,"0049 23;    59       NX\n");
  strcat(s,"004A 1D;    60 :P7   JS EXPR         TRY FOR AN EXPRESSION\n");
  strcat(s,"004B 30BC;  61       PN\n");
  strcat(s,"004D 20;    62       BR P1\n");
  strcat(s,"004E 48;    63 .\n");
  strcat(s,"004F ;      64 :IF   BC INPT \"IF\"\n");
  strcat(s,"004F 9149C6;\n");
  strcat(s,"0052 ;      65       JS EXPR\n");
  strcat(s,"0052 30BC;  66       JS RELO\n");
  strcat(s,"0054 3134;  67       JS EXPR\n");
  strcat(s,"0056 30BC;  68       BC I1 \"THEN\"    OPTIONAL NOISEWORD\n");
  strcat(s,"0058 84544845CE;\n");
  strcat(s,"005D ;      69 :I1   CP              COMPARE SKIPS NEXT IF TRUE\n");
  strcat(s,"005D 1C;    70       NX              FALSE.\n");
  strcat(s,"005E 1D;    71       J STMT          TRUE. GO PROCESS STATEMENT\n");
  strcat(s,"005F 380D;  72 .\n");
  strcat(s,"0061 ;      73 :INPT BC RETN \"INPUT\"\n");
  strcat(s,"0061 9A494E5055D4;\n");
  strcat(s,"0067 ;      74 :I2   BV *            GET VARIABLE\n");
  strcat(s,"0067 A0;    75       SB              SWAP POINTERS\n");
  strcat(s,"0068 10;    76       BE I4\n");
  strcat(s,"0069 E7;    77 :I3   PC \"? Q^\"       LINE IS EMPTY; TYPE PROMPT\n");
  strcat(s,"006A 243F2091;\n");
  strcat(s,"006E ;      78       GL              READ INPUT LINE\n");
  strcat(s,"006E 27;    79       BE I4           DID ANYTHING COME?\n");
  strcat(s,"006F E1;    80       BR I3           NO, TRY AGAIN\n");
  strcat(s,"0070 59;    81 :I4   BC I5 \",\"       OPTIONAL COMMA\n");
  strcat(s,"0071 81AC;  82 :I5   JS EXPR         READ A NUMBER\n");
  strcat(s,"0073 30BC;  83       SV              STORE INTO VARIABLE\n");
  strcat(s,"0075 13;    84       RB              SWAP BACK\n");
  strcat(s,"0076 11;    85       BC I6 \",\"       ANOTHER?\n");
  strcat(s,"0077 82AC;  86       BR I2           YES IF COMMA\n");
  strcat(s,"0079 4D;    87 :I6   BE *            OTHERWISE QUIT\n");
  strcat(s,"007A E0;    88       NX\n");
  strcat(s,"007B 1D;    89 .\n");
  strcat(s,"007C ;      90 :RETN BC END \"RETURN\"\n");
  strcat(s,"007C 895245545552CE;\n");
  strcat(s,"0083 ;      91       BE *\n");
  strcat(s,"0083 E0;    92       RS              RECOVER SAVED LINE\n");
  strcat(s,"0084 15;    93       NX\n");
  strcat(s,"0085 1D;    94 .\n");
  strcat(s,"0086 ;      95 :END  BC LIST \"END\"\n");
  strcat(s,"0086 85454EC4;\n");
  strcat(s,"008A ;      96       BE *\n");
  strcat(s,"008A E0;    97       WS\n");
  strcat(s,"008B 2D;    98 .\n");
  strcat(s,"008C ;      99 :LIST BC RUN \"LIST\"\n");
  strcat(s,"008C 984C4953D4;\n");
  strcat(s,"0091 ;     100       BE L2\n");
  strcat(s,"0091 EC;   101 :L1   PC \"@^@^@^@^J^@^\" PUNCH LEADER\n");
  strcat(s,"0092 24000000000A80;\n");
  strcat(s,"0099 ;     102       LS              LIST\n");
  strcat(s,"0099 1F;   103       PC \"S^\"         PUNCH X-OFF\n");
  strcat(s,"009A 2493; 104       NL\n");
  strcat(s,"009C 23;   105       NX\n");
  strcat(s,"009D 1D;   106 :L2   JS EXPR         GET A LINE NUMBER\n");
  strcat(s,"009E 30BC; 107       BE L3\n");
  strcat(s,"00A0 E1;   108       BR L1\n");
  strcat(s,"00A1 50;   109 :L3   BC * \",\"        SEPARATED BY COMMAS\n");
  strcat(s,"00A2 80AC; 110       BR L2\n");
  strcat(s,"00A4 59;   111 .\n");
  strcat(s,"00A5 ;     112 :RUN  BC CLER \"RUN\"\n");
  strcat(s,"00A5 855255CE;\n");
  strcat(s,"00A9 ;     113       J XEC\n");
  strcat(s,"00A9 380A; 114 .\n");
  strcat(s,"00AB ;     115 :CLER BC REM \"CLEAR\"\n");
  strcat(s,"00AB 86434C4541D2;\n");
  strcat(s,"00B1 ;     116       MT\n");
  strcat(s,"00B1 2B;   117 .\n");
  strcat(s,"00B2 ;     118 :REM  BC DFLT \"REM\"\n");
  strcat(s,"00B2 845245CD;\n");
  strcat(s,"00B6 ;     119       NX\n");
  strcat(s,"00B6 1D;   120 .\n");
  strcat(s,"00B7 ;     121 :DFLT BV *            NO KEYWORD...\n");
  strcat(s,"00B7 A0;   122       BC * \"=\"        TRY FOR LET\n");
  strcat(s,"00B8 80BD; 123       J LET           IT'S A GOOD BET.\n");
  strcat(s,"00BA 3814; 124 .\n");
  strcat(s,"00BC ;     125 .  SUBROUTINES\n");
  strcat(s,"00BC ;     126 .\n");
  strcat(s,"00BC ;     127 :EXPR BC E0 \"-\"       TRY FOR UNARY MINUS\n");
  strcat(s,"00BC 85AD; 128       JS TERM         AHA\n");
  strcat(s,"00BE 30D3; 129       NE\n");
  strcat(s,"00C0 17;   130       BR E1\n");
  strcat(s,"00C1 64;   131 :E0   BC E4 \"+\"       IGNORE UNARY PLUS\n");
  strcat(s,"00C2 81AB; 132 :E4   JS TERM\n");
  strcat(s,"00C4 30D3; 133 :E1   BC E2 \"+\"       TERMS SEPARATED BY PLUS\n");
  strcat(s,"00C6 85AB; 134       JS TERM\n");
  strcat(s,"00C8 30D3; 135       AD\n");
  strcat(s,"00CA 18;   136       BR E1\n");
  strcat(s,"00CB 5A;   137 :E2   BC E3 \"-\"       TERMS SEPARATED BY MINUS\n");
  strcat(s,"00CC 85AD; 138       JS TERM\n");
  strcat(s,"00CE 30D3; 139       SU\n");
  strcat(s,"00D0 19;   140       BR E1\n");
  strcat(s,"00D1 54;   141 :E3   RT\n");
  strcat(s,"00D2 2F;   142 .\n");
  strcat(s,"00D3 ;     143 :TERM JS FACT\n");
  strcat(s,"00D3 30E2; 144 :T0   BC T1 \"*\"       FACTORS SEPARATED BY TIMES\n");
  strcat(s,"00D5 85AA; 145       JS FACT\n");
  strcat(s,"00D7 30E2; 146       MP\n");
  strcat(s,"00D9 1A;   147       BR T0\n");
  strcat(s,"00DA 5A;   148 :T1   BC T2 \"/\"       FACTORS SEPARATED BY DIVIDE\n");
  strcat(s,"00DB 85AF; 149       JS  FACT\n");
  strcat(s,"00DD 30E2; 150       DV\n");
  strcat(s,"00DF 1B;   151       BR T0\n");
  strcat(s,"00E0 54;   152 :T2   RT\n");
  strcat(s,"00E1 2F;   153 .\n");
  strcat(s,"00E2 ;     154 :FACT BC F0 \"RND\"     *RND FUNCTION*\n");
  strcat(s,"00E2 97524EC4;\n");
  strcat(s,"00E6 ;     155       LN 257*128      STACK POINTER FOR STORE\n");
  strcat(s,"00E6 0A;\n");
  strcat(s,"00E7 8080; 156       FV              THEN GET RNDM\n");
  strcat(s,"00E9 12;   157       LN 2345         R:=R*2345+6789\n");
  strcat(s,"00EA 0A;\n");
  strcat(s,"00EB 0929; 158       MP\n");
  strcat(s,"00ED 1A;   159       LN 6789\n");
  strcat(s,"00EE 0A;\n");
  strcat(s,"00EF 1A85; 160       AD\n");
  strcat(s,"00F1 18;   161       SV\n");
  strcat(s,"00F2 13;   162       LB 128          GET IT AGAIN\n");
  strcat(s,"00F3 0980; 163       FV\n");
  strcat(s,"00F5 12;   164       DS\n");
  strcat(s,"00F6 0B;   165       JS FUNC         GET ARGUMENT\n");
  strcat(s,"00F7 3130; 166       BR F1\n");
  strcat(s,"00F9 61;   167 :F0   BR F2           (SKIPPING)\n");
  strcat(s,"00FA 73;   168 :F1   DS\n");
  strcat(s,"00FB 0B;   169       SX 2            PUSH TOP INTO STACK\n");
  strcat(s,"00FC 02;   170       SX 4\n");
  strcat(s,"00FD 04;   171       SX 2\n");
  strcat(s,"00FE 02;   172       SX 3\n");
  strcat(s,"00FF 03;   173       SX 5\n");
  strcat(s,"0100 05;   174       SX 3\n");
  strcat(s,"0101 03;   175       DV              PERFORM MOD FUNCTION\n");
  strcat(s,"0102 1B;   176       MP\n");
  strcat(s,"0103 1A;   177       SU\n");
  strcat(s,"0104 19;   178       DS              PERFORM ABS FUNCTION\n");
  strcat(s,"0105 0B;   179       LB 6\n");
  strcat(s,"0106 0906; 180       LN 0\n");
  strcat(s,"0108 0A;\n");
  strcat(s,"0109 0000; 181       CP              (SKIP IF + OR 0)\n");
  strcat(s,"010B 1C;   182       NE\n");
  strcat(s,"010C 17;   183       RT\n");
  strcat(s,"010D 2F;   184 :F2   BC F3 \"USR\"     *USR FUNCTION*\n");
  strcat(s,"010E 8F5553D2;\n");
  strcat(s,"0112 ;     185       BC * \"(\"        3 ARGUMENTS POSSIBLE\n");
  strcat(s,"0112 80A8; 186       JS EXPR         ONE REQUIRED\n");
  strcat(s,"0114 30BC; 187       JS ARG\n");
  strcat(s,"0116 312A; 188       JS ARG\n");
  strcat(s,"0118 312A; 189       BC * \")\"\n");
  strcat(s,"011A 80A9; 190       US              GO DO IT\n");
  strcat(s,"011C 2E;   191       RT\n");
  strcat(s,"011D 2F;   192 :F3   BV F4           VARIABLE?\n");
  strcat(s,"011E A2;   193       FV              YES.  GET IT\n");
  strcat(s,"011F 12;   194       RT\n");
  strcat(s,"0120 2F;   195 :F4   BN F5           NUMBER?\n");
  strcat(s,"0121 C1;   196       RT              GOT IT.\n");
  strcat(s,"0122 2F;   197 :F5   BC * \"(\"        OTHERWISE MUST BE (EXPR)\n");
  strcat(s,"0123 80A8; 198 :F6   JS EXPR\n");
  strcat(s,"0125 30BC; 199       BC * \")\"\n");
  strcat(s,"0127 80A9; 200       RT\n");
  strcat(s,"0129 2F;   201 .\n");
  strcat(s,"012A ;     202 :ARG  BC A0 \",\"        COMMA?\n");
  strcat(s,"012A 83AC; 203       J  EXPR          YES, GET EXPRESSION\n");
  strcat(s,"012C 38BC; 204 :A0   DS               NO, DUPLICATE STACK TOP\n");
  strcat(s,"012E 0B;   205       RT\n");
  strcat(s,"012F 2F;   206 .\n");
  strcat(s,"0130 ;     207 :FUNC BC * \"(\"\n");
  strcat(s,"0130 80A8; 208       BR F6\n");
  strcat(s,"0132 52;   209       RT\n");
  strcat(s,"0133 2F;   210 .\n");
  strcat(s,"0134 ;     211 :RELO BC R0 \"=\"        CONVERT RELATION OPERATORS\n");
  strcat(s,"0134 84BD; 212       LB 2             TO CODE BYTE ON STACK\n");
  strcat(s,"0136 0902; 213       RT               =\n");
  strcat(s,"0138 2F;   214 :R0   BC R4 \"<\"\n");
  strcat(s,"0139 8EBC; 215       BC R1 \"=\"\n");
  strcat(s,"013B 84BD; 216       LB 3             <=\n");
  strcat(s,"013D 0903; 217       RT\n");
  strcat(s,"013F 2F;   218 :R1   BC R3 \">\"\n");
  strcat(s,"0140 84BE; 219       LB 5             <>\n");
  strcat(s,"0142 0905; 220       RT\n");
  strcat(s,"0144 2F;   221 :R3   LB 1             <\n");
  strcat(s,"0145 0901; 222       RT\n");
  strcat(s,"0147 2F;   223 :R4   BC * \">\"\n");
  strcat(s,"0148 80BE; 224       BC R5 \"=\"\n");
  strcat(s,"014A 84BD; 225       LB 6             >=\n");
  strcat(s,"014C 0906; 226       RT\n");
  strcat(s,"014E 2F;   227 :R5   BC R6 \"<\"\n");
  strcat(s,"014F 84BC; 228       LB 5             ><\n");
  strcat(s,"0151 0905; 229       RT\n");
  strcat(s,"0153 2F;   230 :R6   LB 4             >\n");
  strcat(s,"0154 0904; 231       RT\n");
  strcat(s,"0156 2F;   232 .\n");
  strcat(s,"0157 ;    0000\n");
  return s;}  /* ~DefaultIL */

aByte DeCaps[128];      /* capitalization table */

int DeHex(char* txt, int ndigs) {/* decode hex -> int */
  int num = 0;
  char ch = ' ';
  while (ch<'0')                              /* first skip to num... */
    if (ch == '\0') return -1; else ch = DeCaps[((int)*txt++)&127];
  if (ch>'F' || ch>'9' && ch<'A') return -1;               /* not hex */
  while ((ndigs--) >0) {                 /* only get requested digits */
    if (ch<'0' || ch>'F') return num;              /* not a hex digit */
    if (ch>='A') num = num*16-55+((int)ch);      /* A-F */
    else if (ch<='9') num = num*16-48+((int)ch); /* 0-9 */
      else return num;          /* something in between, i.e. not hex */
    ch = DeCaps[((int)*txt++)&127];}
  return num;} /* ~DeHex */

  void ConvtIL(char* txt) {                 /* convert & load TBIL code */
  int valu;
  FILE* oFile; 

  oFile=fopen("tb_interp_il.c",w);
  ILend = ILfront+2;
  Poke2(ILfront,ILend);    /* initialize pointers as promised in TBEK */
  Poke2(ColdGo+1,ILend);
  Core[ILend] = (aByte)BadOp;   /* illegal op, in case nothing loaded */
  if (txt == NULL) return;
  while (*txt != '\0') {                            /* get the data.. */
    while (*txt > '\r') txt++;               /* (no code on 1st line) */
    if (*txt++ == '\0') break;                      /* no code at all */
    while (*txt > ' ') txt++;                    /* skip over address */
    if (*txt++ == '\0') break;
    while (true) {
      valu = DeHex(txt++, 2);                           /* get a byte */
      if (valu<0) break;                      /* no more on this line */
      Core[ILend++] = (aByte)valu;      /* insert this byte into code */
      txt++;}}
  XQhere = 0;                        /* requires new XQ to initialize */
  Core[ILend] = 0;} /* ~ConvtIL */

void InitDeCaps() {
  int nx;
  for (nx=0; nx<32; nx++) DeCaps[nx] = '\0';     /* fill caps table.. */
  for (nx=32; nx<127; nx++) DeCaps[nx] = (char)nx;
  for (nx=65; nx<91; nx++) DeCaps[nx+32] = (char)nx;
  DeCaps[9] = ' ';
  DeCaps[10] = '\r';
  DeCaps[13] = '\r';
  DeCaps[127] = '\0';

int main(){
    InitDeCaps();
    ConvIL(DefaultIL());
    return 0;
}

