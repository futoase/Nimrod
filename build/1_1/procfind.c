/* Generated by Nimrod Compiler v0.8.9 */
/*   (c) 2010 Andreas Rumpf */

typedef long int NI;
typedef unsigned long int NU;
#include "nimbase.h"

typedef struct TY49545 TY49545;
typedef struct TY100012 TY100012;
typedef struct TY53092 TY53092;
typedef struct TY48011 TY48011;
typedef struct TY49527 TY49527;
typedef struct TNimType TNimType;
typedef struct TNimNode TNimNode;
typedef struct TY49525 TY49525;
typedef struct TGenericSeq TGenericSeq;
typedef struct TY98002 TY98002;
typedef struct TNimObject TNimObject;
typedef struct TY100006 TY100006;
typedef struct TY49523 TY49523;
typedef struct TY53107 TY53107;
typedef struct TY53109 TY53109;
typedef struct TY49898 TY49898;
typedef struct TY49894 TY49894;
typedef struct TY49896 TY49896;
typedef struct TY37019 TY37019;
typedef struct TY37013 TY37013;
typedef struct NimStringDesc NimStringDesc;
typedef struct TY48005 TY48005;
typedef struct TY49549 TY49549;
typedef struct TY41532 TY41532;
typedef struct TY49537 TY49537;
typedef struct TY46008 TY46008;
typedef struct TY49541 TY49541;
typedef struct TY49517 TY49517;
typedef struct TY49547 TY49547;
struct TY53092 {
NI H;
TY48011* Name;
};
struct TNimType {
NI size;
NU8 kind;
NU8 flags;
TNimType* base;
TNimNode* node;
void* finalizer;
};
struct TGenericSeq {
NI len;
NI space;
};
struct TY49527 {
TNimType* m_type;
NI Counter;
TY49525* Data;
};
struct TNimObject {
TNimType* m_type;
};
struct TY98002 {
  TNimObject Sup;
};
struct TY53107 {
NI Tos;
TY53109* Stack;
};
struct TY49898 {
NI Counter;
NI Max;
TY49894* Head;
TY49896* Data;
};
struct TY37019 {
TNimType* m_type;
TY37013* Head;
TY37013* Tail;
NI Counter;
};
typedef N_NIMCALL_PTR(TY49523*, TY100032) (TY100012* C_100033, TY49523* N_100034);
typedef N_NIMCALL_PTR(TY49523*, TY100037) (TY100012* C_100038, TY49523* N_100039);
typedef NIM_CHAR TY239[100000001];
struct NimStringDesc {
  TGenericSeq Sup;
TY239 data;
};
struct TY100012 {
  TY98002 Sup;
TY49545* Module;
TY100006* P;
NI Instcounter;
TY49523* Generics;
NI Lastgenericidx;
TY53107 Tab;
TY49898 Ambiguoussymbols;
TY49525* Converters;
TY37019 Optionstack;
TY37019 Libs;
NIM_BOOL Fromcache;
TY100032 Semconstexpr;
TY100037 Semexpr;
TY49898 Includedfiles;
NimStringDesc* Filename;
TY49527 Userpragmas;
};
struct TY48005 {
  TNimObject Sup;
NI Id;
};
struct TY41532 {
NI16 Line;
NI16 Col;
NI32 Fileindex;
};
struct TY49537 {
NU8 K;
NU8 S;
NU8 Flags;
TY49549* T;
TY46008* R;
NI A;
};
struct TY49545 {
  TY48005 Sup;
NU8 Kind;
NU8 Magic;
TY49549* Typ;
TY48011* Name;
TY41532 Info;
TY49545* Owner;
NU32 Flags;
TY49527 Tab;
TY49523* Ast;
NU32 Options;
NI Position;
NI Offset;
TY49537 Loc;
TY49541* Annex;
};
struct TY49523 {
TY49549* Typ;
NimStringDesc* Comment;
TY41532 Info;
NU8 Flags;
NU8 Kind;
union {
struct {NI64 Intval;
} S1;
struct {NF64 Floatval;
} S2;
struct {NimStringDesc* Strval;
} S3;
struct {TY49545* Sym;
} S4;
struct {TY48011* Ident;
} S5;
struct {TY49517* Sons;
} S6;
} KindU;
};
struct TY48011 {
  TY48005 Sup;
NimStringDesc* S;
TY48011* Next;
NI H;
};
struct TY49549 {
  TY48005 Sup;
NU8 Kind;
TY49547* Sons;
TY49523* N;
NU8 Flags;
NU8 Callconv;
TY49545* Owner;
TY49545* Sym;
NI64 Size;
NI Align;
NI Containerid;
TY49537 Loc;
};
struct TNimNode {
NU8 kind;
NI offset;
TNimType* typ;
NCSTRING name;
NI len;
TNimNode** sons;
};
struct TY100006 {
TY49545* Owner;
TY49545* Resultsym;
NI Nestedloopcounter;
NI Nestedblockcounter;
};
typedef NI TY8214[16];
struct TY49894 {
TY49894* Next;
NI Key;
TY8214 Bits;
};
struct TY37013 {
  TNimObject Sup;
TY37013* Prev;
TY37013* Next;
};
struct TY46008 {
  TNimObject Sup;
TY46008* Left;
TY46008* Right;
NI Length;
NimStringDesc* Data;
};
struct TY49541 {
  TY37013 Sup;
NU8 Kind;
NIM_BOOL Generated;
TY46008* Name;
TY49523* Path;
};
struct TY49525 {
  TGenericSeq Sup;
  TY49545* data[SEQ_DECL_SIZE];
};
struct TY53109 {
  TGenericSeq Sup;
  TY49527 data[SEQ_DECL_SIZE];
};
struct TY49896 {
  TGenericSeq Sup;
  TY49894* data[SEQ_DECL_SIZE];
};
struct TY49517 {
  TGenericSeq Sup;
  TY49523* data[SEQ_DECL_SIZE];
};
struct TY49547 {
  TGenericSeq Sup;
  TY49549* data[SEQ_DECL_SIZE];
};
N_NIMCALL(TY49545*, Initidentiter_53095)(TY53092* Ti_53098, TY49527* Tab_53099, TY48011* S_53100);
N_NIMCALL(NIM_BOOL, Equalgenericparams_114014)(TY49523* Proca_114016, TY49523* Procb_114017);
N_NIMCALL(NI, Sonslen_49801)(TY49523* N_49803);
N_NIMCALL(void, Internalerror_41567)(TY41532 Info_41569, NimStringDesc* Errmsg_41570);
N_NIMCALL(NIM_BOOL, Sametypeornil_90052)(TY49549* A_90054, TY49549* B_90055);
N_NIMCALL(NIM_BOOL, Exprstructuralequivalent_89035)(TY49523* A_89037, TY49523* B_89038);
N_NIMCALL(NU8, Equalparams_90065)(TY49523* A_90067, TY49523* B_90068);
N_NIMCALL(void, Limessage_41562)(TY41532 Info_41564, NU8 Msg_41565, NimStringDesc* Arg_41566);
N_NIMCALL(TY49545*, Nextidentiter_53101)(TY53092* Ti_53104, TY49527* Tab_53105);
N_NIMCALL(NIM_BOOL, Paramsfitborrow_114251)(TY49523* A_114253, TY49523* B_114254);
N_NIMCALL(NIM_BOOL, Equalordistinctof_90056)(TY49549* X_90058, TY49549* Y_90059);
STRING_LITERAL(TMP191177, "equalGenericParams", 18);
N_NIMCALL(NIM_BOOL, Equalgenericparams_114014)(TY49523* Proca_114016, TY49523* Procb_114017) {
NIM_BOOL Result_114018;
TY49545* A_114019;
TY49545* B_114020;
NIM_BOOL LOC5;
NI LOC10;
NI LOC11;
NI I_114076;
NI HEX3Atmp_114192;
NI LOC14;
NI Res_114194;
NIM_BOOL LOC23;
NIM_BOOL LOC25;
NIM_BOOL LOC29;
NIM_BOOL LOC34;
Result_114018 = 0;
A_114019 = 0;
B_114020 = 0;
Result_114018 = (Proca_114016 == Procb_114017);
if (!Result_114018) goto LA2;
goto BeforeRet;
LA2: ;
LOC5 = (Proca_114016 == NIM_NIL);
if (LOC5) goto LA6;
LOC5 = (Procb_114017 == NIM_NIL);
LA6: ;
if (!LOC5) goto LA7;
goto BeforeRet;
LA7: ;
LOC10 = Sonslen_49801(Proca_114016);
LOC11 = Sonslen_49801(Procb_114017);
if (!!((LOC10 == LOC11))) goto LA12;
goto BeforeRet;
LA12: ;
I_114076 = 0;
HEX3Atmp_114192 = 0;
LOC14 = Sonslen_49801(Proca_114016);
HEX3Atmp_114192 = (NI32)(LOC14 - 1);
Res_114194 = 0;
Res_114194 = 0;
while (1) {
if (!(Res_114194 <= HEX3Atmp_114192)) goto LA15;
I_114076 = Res_114194;
if (!!(((*(*Proca_114016).KindU.S6.Sons->data[I_114076]).Kind == ((NU8) 3)))) goto LA17;
Internalerror_41567((*Proca_114016).Info, ((NimStringDesc*) &TMP191177));
LA17: ;
if (!!(((*(*Procb_114017).KindU.S6.Sons->data[I_114076]).Kind == ((NU8) 3)))) goto LA20;
Internalerror_41567((*Procb_114017).Info, ((NimStringDesc*) &TMP191177));
LA20: ;
A_114019 = (*(*Proca_114016).KindU.S6.Sons->data[I_114076]).KindU.S4.Sym;
B_114020 = (*(*Procb_114017).KindU.S6.Sons->data[I_114076]).KindU.S4.Sym;
LOC23 = !(((*(*A_114019).Name).Sup.Id == (*(*B_114020).Name).Sup.Id));
if (LOC23) goto LA24;
LOC25 = Sametypeornil_90052((*A_114019).Typ, (*B_114020).Typ);
LOC23 = !(LOC25);
LA24: ;
if (!LOC23) goto LA26;
goto BeforeRet;
LA26: ;
LOC29 = !(((*A_114019).Ast == NIM_NIL));
if (!(LOC29)) goto LA30;
LOC29 = !(((*B_114020).Ast == NIM_NIL));
LA30: ;
if (!LOC29) goto LA31;
LOC34 = Exprstructuralequivalent_89035((*A_114019).Ast, (*B_114020).Ast);
if (!!(LOC34)) goto LA35;
goto BeforeRet;
LA35: ;
LA31: ;
Res_114194 += 1;
} LA15: ;
Result_114018 = NIM_TRUE;
BeforeRet: ;
return Result_114018;
}
N_NIMCALL(TY49545*, Searchforproc_114004)(TY100012* C_114006, TY49545* Fn_114007, NI Tos_114008) {
TY49545* Result_114202;
TY53092 It_114203;
NIM_BOOL LOC6;
NU8 LOC9;
Result_114202 = 0;
memset((void*)&It_114203, 0, sizeof(It_114203));
Result_114202 = Initidentiter_53095(&It_114203, &(*C_114006).Tab.Stack->data[Tos_114008], (*Fn_114007).Name);
while (1) {
if (!!((Result_114202 == NIM_NIL))) goto LA1;
if (!((*Result_114202).Kind == (*Fn_114007).Kind)) goto LA3;
LOC6 = Equalgenericparams_114014((*(*Result_114202).Ast).KindU.S6.Sons->data[1], (*(*Fn_114007).Ast).KindU.S6.Sons->data[1]);
if (!LOC6) goto LA7;
LOC9 = Equalparams_90065((*(*Result_114202).Typ).N, (*(*Fn_114007).Typ).N);
switch (LOC9) {
case ((NU8) 1):
goto BeforeRet;
break;
case ((NU8) 2):
Limessage_41562((*Fn_114007).Info, ((NU8) 63), (*(*Fn_114007).Name).S);
goto BeforeRet;
break;
case ((NU8) 0):
break;
}
LA7: ;
LA3: ;
Result_114202 = Nextidentiter_53101(&It_114203, &(*C_114006).Tab.Stack->data[Tos_114008]);
} LA1: ;
BeforeRet: ;
return Result_114202;
}
N_NIMCALL(NIM_BOOL, Paramsfitborrow_114251)(TY49523* A_114253, TY49523* B_114254) {
NIM_BOOL Result_114255;
NI Length_114256;
TY49545* M_114257;
TY49545* N_114258;
NI LOC2;
NI I_114268;
NI HEX3Atmp_114360;
NI Res_114362;
NIM_BOOL LOC7;
NIM_BOOL LOC11;
Result_114255 = 0;
Length_114256 = 0;
M_114257 = 0;
N_114258 = 0;
Length_114256 = Sonslen_49801(A_114253);
Result_114255 = NIM_FALSE;
LOC2 = Sonslen_49801(B_114254);
if (!(Length_114256 == LOC2)) goto LA3;
I_114268 = 0;
HEX3Atmp_114360 = 0;
HEX3Atmp_114360 = (NI32)(Length_114256 - 1);
Res_114362 = 0;
Res_114362 = 1;
while (1) {
if (!(Res_114362 <= HEX3Atmp_114360)) goto LA5;
I_114268 = Res_114362;
M_114257 = (*(*A_114253).KindU.S6.Sons->data[I_114268]).KindU.S4.Sym;
N_114258 = (*(*B_114254).KindU.S6.Sons->data[I_114268]).KindU.S4.Sym;
LOC7 = Equalordistinctof_90056((*M_114257).Typ, (*N_114258).Typ);
if (!!(LOC7)) goto LA8;
goto BeforeRet;
LA8: ;
Res_114362 += 1;
} LA5: ;
LOC11 = Equalordistinctof_90056((*(*A_114253).KindU.S6.Sons->data[0]).Typ, (*(*B_114254).KindU.S6.Sons->data[0]).Typ);
if (!!(LOC11)) goto LA12;
goto BeforeRet;
LA12: ;
Result_114255 = NIM_TRUE;
LA3: ;
BeforeRet: ;
return Result_114255;
}
N_NIMCALL(TY49545*, Searchforborrowproc_114009)(TY100012* C_114011, TY49545* Fn_114012, NI Tos_114013) {
TY49545* Result_114370;
TY53092 It_114371;
NI Scope_114394;
NI Res_114446;
NIM_BOOL LOC4;
NIM_BOOL LOC9;
NIM_BOOL LOC13;
Result_114370 = 0;
memset((void*)&It_114371, 0, sizeof(It_114371));
Scope_114394 = 0;
Res_114446 = 0;
Res_114446 = Tos_114013;
while (1) {
if (!(0 <= Res_114446)) goto LA1;
Scope_114394 = Res_114446;
Result_114370 = Initidentiter_53095(&It_114371, &(*C_114011).Tab.Stack->data[Scope_114394], (*Fn_114012).Name);
while (1) {
if (!!((Result_114370 == NIM_NIL))) goto LA2;
LOC4 = ((*Result_114370).Kind == (*Fn_114012).Kind);
if (!(LOC4)) goto LA5;
LOC4 = !(((*Result_114370).Sup.Id == (*Fn_114012).Sup.Id));
LA5: ;
if (!LOC4) goto LA6;
LOC9 = Equalgenericparams_114014((*(*Result_114370).Ast).KindU.S6.Sons->data[1], (*(*Fn_114012).Ast).KindU.S6.Sons->data[1]);
if (!LOC9) goto LA10;
LOC13 = Paramsfitborrow_114251((*(*Fn_114012).Typ).N, (*(*Result_114370).Typ).N);
if (!LOC13) goto LA14;
goto BeforeRet;
LA14: ;
LA10: ;
LA6: ;
Result_114370 = Nextidentiter_53101(&It_114371, &(*C_114011).Tab.Stack->data[Scope_114394]);
} LA2: ;
Res_114446 -= 1;
} LA1: ;
BeforeRet: ;
return Result_114370;
}
N_NOINLINE(void, procfindInit)(void) {
}
