grammar ASM;

asmfile: (function | directive)+ EOF;
function: function_header line+;
function_header: 'thumb_func_start' name=WORD WORD ':';

line: (instruction | directive | label);
label: name=WORD ':';
instruction: push | pop | arithmetic | logic | lsl | lsr | asl | asr | mov | branch | ldr | store | cmp | cmn;

push: push_multiple;
push_multiple: PUSH '{' reg (COMMA reg)* '}';

pop: pop_multiple;
pop_multiple: POP '{' reg (COMMA reg)* '}';

arithmetic: add | sub | mul | rsb | neg;

add: ADD rd=reg (COMMA rn=reg)? COMMA rm=regimm;
sub: SUB rd=reg (COMMA rn=reg)? COMMA rm=regimm;

mul: mul1 | mul2;
mul1: MUL rd=reg COMMA rn=reg;
mul2: MUL rd=reg COMMA rn=reg COMMA rm=reg;

rsb: RSB rd=reg COMMA rn=reg COMMA imm;
neg: NEG rd=reg COMMA rm=reg;

logic: land | orr | eor;
land: AND rd=reg (COMMA rn=reg)? COMMA rm=regimm;
orr: ORR rd=reg (COMMA rn=reg)? COMMA rm=regimm;
eor: EOR rd=reg (COMMA rn=reg)? COMMA rm=regimm;

lsl: LSL rd=reg (COMMA rn=reg)? COMMA rm=regimm;
lsr: LSR rd=reg (COMMA rn=reg)? COMMA rm=regimm;
asl: ASL rd=reg (COMMA rn=reg)? COMMA rm=regimm;
asr: ASR rd=reg (COMMA rn=reg)? COMMA rm=regimm;

mov: MOV rd=reg COMMA rm=regimm;

branch: b | bl | bx | beq | bne | bhs | blo | bmi | bpl | bvs | bvc | bhi | bls | bge | blt | bgt | ble;
b: B target=WORD;
bl: BL target=WORD;
bx: BX rm=reg;
beq: BEQ target=WORD;
bne: BNE target=WORD;
bhs: BCS | BHS target=WORD;
blo: BCC | BLO target=WORD;
bmi: BMI target=WORD;
bpl: BPL target=WORD;
bvs: BVS target=WORD;
bvc: BVC target=WORD;
bhi: BHI target=WORD;
bls: BLS target=WORD;
bge: BGE target=WORD;
blt: BLT target=WORD;
bgt: BGT target=WORD;
ble: BLE target=WORD;

ldr: ldr_pc | ldr_offset | ldrh_offset | ldrsh_offset | ldrb_offset | ldrsb_offset;
ldr_pc: LDR rt=reg COMMA target=WORD;
ldr_offset: LDR rt=reg COMMA '[' rn=reg (COMMA rm=regimm)? ']';
ldrh_offset: LDRH rt=reg COMMA '[' rn=reg (COMMA rm=regimm)? ']';
ldrsh_offset: LDRSH rt=reg COMMA '[' rn=reg (COMMA rm=regimm)? ']';
ldrb_offset: LDRB rt=reg COMMA '[' rn=reg (COMMA rm=regimm)? ']';
ldrsb_offset: LDRSB rt=reg COMMA '[' rn=reg (COMMA rm=regimm)? ']';
store: str_offset | strh_offset | strb_offset;
str_offset: STR rt=reg COMMA '[' rn=reg (COMMA rm=regimm)? ']';
strh_offset: STRH rt=reg COMMA '[' rn=reg (COMMA rm=regimm)? ']';
strb_offset: STRB rt=reg COMMA '[' rn=reg (COMMA rm=regimm)? ']';

cmp: CMP rn=reg COMMA rm=regimm;
cmn: CMN rn=reg COMMA rm=regimm;

directive: align | data | include | syntax | text;
align: '.align' '2' COMMA '0';

data: data1 | data2 | data4;
data1: DATA1 WORD;
data2: DATA2 WORD;
data4: DATA4 WORD;

include: '.include' '"' path '"';
path: WORD ('/' WORD)+ '.' WORD;

syntax: '.syntax' ('divided' | 'unified');

text: '.text';

regimm: reg|imm;
reg: REG;
imm: IMM;

PUSH: 'push';
POP: 'pop';
ADD: 'add' | 'adds';
SUB: 'sub' | 'subs';
MUL: 'mul' | 'muls';
RSB: 'rsb' | 'rsbs';
NEG: 'neg';
AND: 'and' | 'ands';
ORR: 'orr' | 'orrs';
EOR: 'eor' | 'eors';
LSL: 'lsl' | 'lsls';
LSR: 'lsr' | 'lsrs';
ASL: 'asl' | 'asls';
ASR: 'asr' | 'asrs';
MOV: 'mov' | 'movs';
B: 'b';
BL: 'bl';
BX: 'bx';
BEQ: 'beq';
BNE: 'bne';
BCS: 'bcs';
BHS: 'bhs';
BCC: 'bcc';
BLO: 'blo';
BMI: 'bmi';
BPL: 'bpl';
BVS: 'bvs';
BVC: 'bvc';
BHI: 'bhi';
BLS: 'bls';
BGE: 'bge';
BLT: 'blt';
BGT: 'bgt';
BLE: 'ble';
LDR: 'ldr';
LDRH: 'ldrh';
LDRSH: 'ldrsh';
LDRB: 'ldrb';
LDRSB: 'ldrsb';
STR: 'str';
STRH: 'strh';
STRB: 'strb';
CMP: 'cmp';
CMN: 'cmn';

DATA1: '.1byte' | '.byte';
DATA2: '.2byte' | '.half';
DATA4: '.4byte' | '.word';

COMMA: ',';
REG: ('r' [0-9]) | 'lr' | 'pc' | 'sl' | 'sb' | 'ip' | 'sp';
IMM: '#' '-'? '0x'? [0-9a-fA-F]+;
COMMENT: ('@' .*? NL) -> skip;
WORD: [A-Za-z0-9_-]+;
WS: (' ' | '\t') -> skip;
NL: ('\r' | '\r'?'\n') -> skip;