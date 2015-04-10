%% Copyright © 2013, Université catholique de Louvain
%% All rights reserved.
%%
%% Redistribution and use in source and binary forms, with or without
%% modification, are permitted provided that the following conditions are met:
%%
%% *  Redistributions of source code must retain the above copyright notice,
%%    this list of conditions and the following disclaimer.
%% *  Redistributions in binary form must reproduce the above copyright notice,
%%    this list of conditions and the following disclaimer in the documentation
%%    and/or other materials provided with the distribution.
%%
%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
%% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
%% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
%% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
%% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
%% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
%% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
%% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
%% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
%% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
%% POSSIBILITY OF SUCH DAMAGE.

%%
%% Authors:
%%   Andrés F. Barco <anfelbar@javerianacali.edu.co>
%%   Alejandro Cardona <carealejo@gmail.com>
%%



functor

require
   FDB at 'x-oz://boot/IntVar'
   FDP at 'x-oz://boot/IntVarProp'
   %Space(waitStable)
   Error(registerFormatter)
   %System(nbSusps)
prepare
   
   FdRelType = '#'('=:':   'IRT_EQ'
		   '\\=:': 'IRT_NQ'
		   '<:':   'IRT_LE'
		   '<=:':  'IRT_LQ'
		   '>:':   'IRT_GR'
		   '>=:':  'IRT_LQ')
   
   % FdConLevel = '#'(val: 'ICL_VAL'
   % 		    bnd: 'ICL_BND'
   % 		    dom: 'ICL_DOM')

   FdIntVarBranch = '#'(none:            'INT_VAR_NONE'
                        rnd:             'INT_VAR_RND'
                        degree_min:      'INT_VAR_DEGREE_MIN'
                        degree_max:      'INT_VAR_DEGREE_MAX'
                        afc_min:         'INT_VAR_AFC_MIN'
                        min_min:         'INT_VAR_MIN_MIN'
                        min_max:         'INT_VAR_MIN_MAX'
                        max_min:         'INT_VAR_MAX_MIN'
                        max_max:         'INT_VAR_MAX_MAX'
                        size_min:        'INT_VAR_SIZE_MIN'
                        size_max:        'INT_VAR_SIZE_MAX'
                        size_degree_min: 'INT_VAR_SIZE_DEGREE_MIN'
                        size_degree_max: 'INT_VAR_SIZE_DEGREE_MAX'
                        size_afc_min:    'INT_VAR_SIZE_AFC_MIN'
                        size_afc_max:    'INT_VAR_SIZE_AFC_MAX'
                        regret_min_min:  'INT_VAR_REGRET_MIN_MIN'
                        regret_min_max:  'INT_VAR_REGRET_MIN_MAX'
                        regret_max_min:  'INT_VAR_REGRET_MAX_MIN'
                        regret_max_max:  'INT_VAR_REGRET_MAX_MAX')

   FdIntValBranch = '#'(val_min:         'INT_VAL_MIN'
                        val_med:         'INT_VAL_MED'
                        val_max:         'INT_VAL_MAX'
                        val_rad:         'INT_VAL_RND'
                        val_split_min:   'INT_VAL_SPLIT_MIN'
                        val_split_max:   'INT_VAL_SPLIT_MAX'
                        val_range_min:   'INT_VAL_RANGE_MIN'
                        val_range_max:   'INT_VAL_RANGE_MAX'
                        values_min:      'INT_VALUES_MIN'
                        values_max:      'INT_VALUES_MAX')

%% Old oz distribution strategies.   
%    FddOptVarMap = map(naive:   0
%                       size:    1
%                       min:     2
%                       max:     3
%                       nbSusps: 4
%                       width:   5)

%    FddOptValMap = map(min:      0
%                       mid:      1
%                       max:      2
%                       splitMin: 3
%                       splitMax: 4)
   
export
%%% Finite domains
   inf:             FdInf
   sup:             FdSup
   is:              FdIs
   isIn:            FdIsIn
   value:           FdValue


%%% Telling Domains
   int:            FdInt
   dom:            FdDom
   decl:           FdDecl   
   list:           FdList
   tuple:          FdTuple
   record:         FdRecord
   %    bool:           FdBool

%%% Reflection
   reflect:        FdReflect




%%% Simple relation
   rel:            FdRel

%    %% Watching Domains
%    watch:          FdWatch

%    %% Generic Propagators
   domain:         FdDomain
   linear: 	   FdpLinear
   count:          FdpCount
   member:	   FdpMember
   binpacking:     FdpBinpacking
   channel:        FdpChannel
   element:	   FdpElement
   sorted:	   FdpSorted
   cumulative:     FdpCumulative
   sequence:	   FdpSequence
%    sum:            FdpSum
%    sumC:           FdpSumC
%    sumCN:          FdpSumCN
%    sumAC:          FdpSumAC
%    sumACN:         GenSumACN
%    sumD:           FdpDSum
%    sumCD:          FdpDSumC

%%% Arithmetic propagators
    min:           Fdpmin
    max:           Fdpmax
    abs:           Fdpabs
    mult:          Fdpmult
    sqr:           Fdpsqr 
    sqrt:          Fdpsqrt
    divmod:        Fdpdivmod 
    divI:	   FdpdivI
    modI:	   FdpmodI

%%% Symbolic Propagators
   distinct:       FdpDistinct
%    distinct2:      FdpDistinct2
%    distinctB:      FdpDistinctB
%    distinctD:      FdpDistinctD
%    distinctOffset: FdpDistinctOffset
%    atMost:         FdpAtMost
%    atLeast:        FdpAtLeast
%    exactly:        FdpExactly
%    element:        FdpElement

%%% Graph Propagators

   circuit:	   FdpCircuit
   path:	   FdpPath

%%% Geometrical packing Propagator
    
   nooverlap:      FdpNooverlap

%    %% 0/1 Propagators
%    conj:           FdpConj
%    disj:           FdpDisj
%    nega:           FdpNega
%    exor:           FdpExor
%    impl:           FdpImpl
%    equi:           FdpEqui

%    %% Reified Propagators
%    reified:        FdReified

%    %% Miscellaneous Propagators
%    plus:           FdpPlus
%    minus:          FdpMinus
%    times:          FdpTimes
%    plusD:          FdpPlusD
%    minusD:         FdpMinusD
%    timesD:         FdpTimesD
%    power:          FdpPower
%    divI:           FdpDivI
%    divD:           FdpDivD
%    modI:           FdpModI
%    modD:           FdpModD
%    max:            FdpMaximum
%    min:            FdpMinimum
%    distance:       FdpDistance
%    tasksOverlap:   FdpTasksOverlap
%    less:           FdLess
%    greater:        FdGreater
%    lesseq:         FdLesseq
%    greatereq:      FdGreatereq
%    disjointC:      FdDisjointC
%    disjoint:       FdpDisjoint

%    %% Distribution
%    assign:         FdAssign
     distribute:     FdpDistribute
%    choose:         FdChoose
     branch:     FdpBranch

define

   %%
   %% Telling Domains
   %%
   local
      FdIntVar = FDB.new
   in
      proc {FdInt D1#D2 Var}
	 {FdIntVar D1 D2 Var}
      end
   end
   
   local
   %anfelbar: This function is copied from CpSupport.oz
   %          I do not know whether that file is going to
   %          be used in the future. If yes, we remove this
   %          function from here and include the file.
      fun {VectorToType V}
	 if {IsList V}       then list
	 elseif {IsTuple V}  then tuple
	 elseif {IsRecord V} then record
	 else
	    {Exception.raiseError
	     kernel(type VectorToType [V] vector 1
		 'Vector as input argument expected.')} illegal
	 end
      end
      proc {ListDom Xs Dom}
	 case Xs of nil then skip
	 [] X|Xr then {FdInt Dom X} {ListDom Xr Dom}
	 end
      end
      
      proc {TupleDom N T Dom}
	 if N>0 then {FdInt Dom T.N} {TupleDom N-1 T Dom} end
      end
      
      proc {RecordDom As R Dom}
	 case As of nil then skip
	 [] A|Ar then {FdInt Dom R.A} {RecordDom Ar R Dom}
	 end
      end
   in
      FdInf = FDB.inf
      FdSup = FDB.sup
      proc {FdDecl V}
	 {FdInt {FdInf}#{FdSup} V}
      end
      fun {FdList N Dom}
	 if N>0 then {FdInt Dom}|{FdList N-1 Dom}
	 else nil
	 end
      end
      
      proc {FdTuple L N Dom ?T}
	 T={MakeTuple L N} {TupleDom N T Dom}
      end
      
      proc {FdRecord L As Dom ?R}
	 R={MakeRecord L As} {RecordDom As R Dom}
      end
      
      proc {FdDom Dom Vec}
	case {VectorToType Vec}
	of list   then {ListDom Vec Dom}
	[] tuple  then {TupleDom {Width Vec} Vec Dom}
	[] record then {RecordDom {Arity Vec} Vec Dom}
	end
      end
   end
   
   FdIs = FDB.is
   FdIsIn = FDB.isIn
   FdValue = FDB.value
   

   %local
   %   GetDomCompact = FDB.'reflect.dom'
   %in
   FdReflect = reflect(min:           FDB.min
		       %mid:           FDB.mid'
		       max:           FDB.max
		       %nextLarger:    FDB.'reflect.nextLarger'
		       %nextSmaller:   FDB.'reflect.nextSmaller'
		       %size:          FDB.'reflect.size'
		       %width:         FDB.'reflect.width'
		       %nbSusps:       System.nbSusps
		       %domList:       fun {$ X}
		       %			 {Expand {GetDomCompact X}}
		       %		      end
		       %dom:           GetDomCompact
		      )
   %end
   
   %%% Simple relation over integer variables
   
   proc {FdRel Post} 
     W = {Record.width Post} 
     R = Post.2
   in
   	case W
   	of 2 then {FDP.rel2 Post.1 FdRelType.R}
   	[] 3 then {FDP.rel3 Post.1 FdRelType.R Post.3}
	[] 4 then {FDP.rel4 Post.1 FdRelType.R Post.3 Post.4}
   	else
   	   raise malFormed(post) end
   	end
   end

   %% linear constraint for interger variable

      proc{FdpLinear Post}
   	W = {Record.width Post}
      in

	case W
	of 3 then
	   {FDP.linear3 Post.1 FdRelType.(Post.2) Post.3}
	[] 4 then
	   if{IsAtom Post.2} then
	      {FDP.linear4 Post.1 FdRelType.(Post.2) Post.3 Post.4}
	   elseif{IsAtom Post.3} then
	      {FDP.linear4 Post.1 FdRelType.(Post.3) Post.2 Post.4}
	   end
	[] 5 then 
	   {FDP.linear5 Post.1 FdRelType.(Post.3) Post.2 Post.4 Post.5}
	else
	    raise malFormed(post)
	end
     end
   end

   %%% Element constraints
   proc {FdpElement Post}
     W = {Record.width Post}
   in
	case W
	of 3 then {FDP.element3 Post.1 Post.2 Post.3}
	[] 6 then {FDP.element6 Post.1 Post.2 Post.3 Post.4 Post.5 Post.6}
	else
	   raise malFormed(post) end
	end
   end

   %%%Sorted constraint
   proc {FdpSorted Post}
     	W = {Record.width Post}	
   in
	case W
	of 2 then {FDP.sorted2 Post.1 Post.2}
	[] 3 then {FDP.sorted3 Post.1 Post.2 Post.3}
	else
	   raise malFormed(post)
	end
      end
   end
	
   %%%Sequence constraint
   proc {FdpSequence Post}
     	W = {Record.width Post}	
   in
	case W
	of 5 then {FDP.sorted5 Post.1 Post.2 Post.3 Post.4 Post.5}
	else
	   raise malFormed(post)
	end
      end
   end
   
   %%% Membership constraints

   proc {FdpMember Post}
     W = {Record.width Post}
   in
	case W
	of 2 then {FDP.member2 Post.1 Post.2}
	[] 3 then {FDP.member3 Post.1 Post.2 Post.3}
	else
           raise malFormed(post) end
   	end
   end	 

   
   %%%Binpacking constraints
   
   proc {FdpBinpacking Post}
     W = {Record.width Post}
   in
	case W
	of 3 then {FDP.binpacking Post.1 Post.2 Post.3}
	else
    	   raise malFormed(post) end
	end
   end
   
   %%%Scheduling constraints
   proc {FdpCumulative Post}
     W = {Record.width Post}
   in 
      case W
      of 5 then {FDP.cumulative5 Post.1 Post.2 Post.3 Post.4 Post.5}
      else
	 raise malFormed(post) end
      end
   end
   
   %%%Channel constraints
   proc {FdpChannel Post}
     W = {Record.width Post}
   in
	case W
	of 2 then {FDP.channel2 Post.1 Post.2}
	else
	   raise malFormed(post) end
	end
   end


   %%% Arithmetic propagators

   proc {Fdpmin Post}
     W = {Record.width Post}
   in
	case W
   	of 2 then {FDP.min2 Post.1 Post.2}
   	[] 3 then {FDP.min3 Post.1 Post.2 Post.3}
   	else
   	   raise malFormed(post) end
   	end
   end
		
   proc {Fdpmax Post}
     W = {Record.width Post}
   in
	case W
   	of 2 then {FDP.max2 Post.1 Post.2}
   	[] 3 then {FDP.max3 Post.1 Post.2 Post.3}
   	else
   	   raise malFormed(post) end
   	end
   end

   proc {Fdpabs Post}
     W = {Record.width Post}
   in
	case W
   	of 2 then {FDP.abs Post.1 Post.2}
   	else
   	   raise malFormed(post) end
   	end
   end
   
   proc {Fdpmult Post}
     W = {Record.width Post}
   in
	case W
   	of 3 then {FDP.mult Post.1 Post.2 Post.3}
   	else
   	   raise malFormed(post) end
   	end
   end

   proc {Fdpsqr Post}
     W = {Record.width Post}
   in
	case W
   	of 2 then {FDP.sqr Post.1 Post.2}
   	else
   	   raise malFormed(post) end
   	end
   end

   proc {Fdpsqrt Post}
     W = {Record.width Post}
   in
	case W
   	of 2 then {FDP.sqrt Post.1 Post.2}
   	else
   	   raise malFormed(post) end
   	end
   end

   proc {Fdpdivmod Post}
     W = {Record.width Post}
   in
	case W
   	of 4 then {FDP.divmod Post.1 Post.2 Post.3 Post.4}
   	else
   	   raise malFormed(post) end
   	end
   end   

   proc {FdpdivI Post}
     W = {Record.width Post}
   in
	case W
   	of 3 then {FDP.divI Post.1 Post.2 Post.3}
   	else
   	   raise malFormed(post) end
   	end
   end

   proc {FdpmodI Post}
     W = {Record.width Post}
   in
	case W
   	of 3 then {FDP.modI Post.1 Post.2 Post.3}
   	else
   	   raise malFormed(post) end
   	end
   end

   %%% Graph propagators
   
   proc {FdpCircuit Post}
     W = {Record.width Post}
   in
	case W
	of 1 then {FDP.circuit1 Post.1}
	[] 2 then {FDP.circuit2 Post.1 Post.2}
	[] 3 then {FDP.circuit3 Post.1 Post.2 Post.3}
	[] 4 then {FDP.circuit4 Post.1 Post.2 Post.3 Post.4}
	[] 5 then {FDP.circuit5 Post.1 Post.2 Post.3 Post.4 Post.5}
	else
	   raise malFormed(post) end
	end
   end

   proc {FdpPath Post}
     W = {Record.width Post}
   in
	case W
	of 3 then {FDP.path3 Post.1 Post.2 Post.3}
	[] 4 then {FDP.path4 Post.1 Post.2 Post.3 Post.4}
	[] 5 then {FDP.path5 Post.1 Post.2 Post.3 Post.4 Post.5}
	[] 6 then {FDP.path6 Post.1 Post.2 Post.3 Post.4 Post.5 Post.6}
	[] 7 then {FDP.path7 Post.1 Post.2 Post.3 Post.4 Post.5 Post.6 Post.7}
	else
	   raise malFormed(post) end
	end
   end

   %%% Geometrical packing constraints
   
   proc {FdpNooverlap Post}
      W = {Record.width Post}
   in
        case W
	of 4 then {FDP.nooverlap4 Post.1 Post.2 Post.3 Post.4}
	[] 5 then {FDP.nooverlap5 Post.1 Post.2 Post.3 Post.4 Post.5}
	[] 6 then {FDP.nooverlap6 Post.1 Post.2 Post.3 Post.4 Post.5 Post.6}
	[] 7 then {FDP.nooverlap7 Post.1 Post.2 Post.3 Post.4 Post.5 Post.6 Post.7}
	else
	   raise malFormed(post) end
	end
   end

   %%% Generic propagators
   
   proc {FdpCount Post}
      W = {Record.width Post}
   in
        case W
	of 2 then {FDP.count2 Post.1 Post.2}
	[] 4 then {FDP.count4 Post.1 Post.2 Post.3 Post.4}
	else
	   raise malFormed(post) end
	end
   end

   proc {FdpDistinct Post} 
     W = {Record.width Post}
   in
   	case W
   	of 1 then {FDP.distinct Post.1}
   	[] 2 then {FDP.distinct2 Post.1 Post.2}	
   	else
   	   raise malFormed(post) end
   	end
   end


   proc {FdDomain Post}
        W = {Record.width Post}
   in
   	case W
   	of 2 then {FDP.dom2 Post.1 Post.2}
   	[] 3 then {FDP.dom3 Post.1 Post.2 Post.3}
	[] 4 then {FDP.dom3 Post.1 Post.2 Post.3 Post.4}	
   	else
   	   raise malFormed(post) end
   	end
   end

   %%% Distributor
   FdpDistribute = FDP.distribute
   local
      Distributor = FDP.branch
   in
      proc {FdpBranch IV1 Evar Eval}
	 {Distributor IV1 FdIntVarBranch.Evar FdIntValBranch.Eval}
      end
   end

   
end



% require
%    CpSupport(vectorToType:   VectorToType
%              vectorToList:   VectorToList
%              vectorToTuple:  VectorToTuple
%              vectorMap:      VectorMap

%              expand:         Expand

%              formatOrigin:   FormatOrigin)


% prepare
%    NegRelTable = negRelTable('=:':   '\\=:'
%                              '=<:':  '>:'
%                              '<:' :  '>=:'
%                              '>=:':  '<:'
%                              '>:':   '=<:'
%                              '\\=:': '=:')

% import
%    FDB at 'x-oz://boot/FDB'
%    FDP at 'x-oz://boot/FDP'
% define

%    {Wait Space.waitStable}
%    {Wait FDB.int}

%    FdpPlus = FDP.plus
%    proc {FdpMinus X Y Z}
%       {FdpPlus Z Y X}
%    end
%    FdpTimes = FDP.times
%    FdpPlusD = FDP.plusD
%    proc {FdpMinusD X Y Z}
%       {FdpPlusD Z Y X}
%    end
%    FdpTimesD = FDP.timesD
%    FdpPower = FDP.power
%    FdpDivD = FDP.divD
%    FdpDivI = FDP.divI
%    FdpModD = FDP.modD
%    FdpModI = FDP.modI
%    FdpConj = FDP.conj
%    FdpDisj = FDP.disj
%    FdpExor = FDP.exor
%    FdpImpl = FDP.impl
%    FdpNega = FDP.nega
%    FdpEqui = FDP.equi
%    FdpIntR = FDP.'reified.int'
%    FdpCard = FDP.'reified.card'
%    FdpExactly = FDP.exactly
%    FdpAtLeast = FDP.atLeast
%    FdpAtMost = FDP.atMost
%    FdpElement = FDP.element
%    FdpLessEqOff = FDP.lessEqOff
%    FdpMinimum = FDP.min
%    FdpMaximum = FDP.max

%    FdpDistinct2 = FDP.distinct2
%    FdpDistinctD = FDP.distinctD
%    FdpDistinctB = FDP.distinctB
%    FdpDistinctOffset = FDP.distinctOffset

%    FdpDisjoint = FDP.disjoint
%    FdpDisjointC = FDP.disjointC
%    FdpDistance = FDP.distance
%    FdpTasksOverlap = FDP.tasksOverlap

%    FdpSum = FDP.sum
%    FdpSumC = FDP.sumC
%    FdpDSum = FDP.sumD
%    FdpDSumC = FDP.sumCD
%    FdpSumAC = FDP.sumAC
%    FdpSumCN = FDP.sumCN
%    FdpSumR = FDP.'reified.sum'
%    FdpSumCR = FDP.'reified.sumC'
%    % FdpSumCNR = FDP.'reified.sumCN' not used in this functor




%    FdIs = FDB.'is'


%    %%
%    %% Reflection
%    %%


%    %%
%    %% Generic Propagators
%    %%

%    proc {GenSumACN IV DDV Rel D}
%       NIV = {VectorMap IV Number.'~'}
%    in
%       if FwdRelTable.Rel then
%          {FdpSumCN IV  DDV Rel D}
%          {FdpSumCN NIV DDV Rel D}
%       else
%          thread
%             or {FdpSumCN IV  DDV Rel D}
%             [] {FdpSumCN NIV DDV Rel D}
%             end
%          end
%       end
%    end

%    %%
%    %% Reified constraints
%    %%

%    local
%       FdIntR = FdpIntR

%       GenSumR   = FdpSumR
%       GenSumCR  = FdpSumCR

%       %% was: GenSumCNR = FdpSumCNR, but the latter blocks until the
%       %% polynom becomes linear (bug fix)
%       proc {GenSumCNR IV DDV Rel D B}
%          NegRel = NegRelTable.Rel
%       in
%          {FdBool B}
%          thread
%             or B=1 {FdpSumCN IV DDV Rel    D}
%             [] B=0 {FdpSumCN IV DDV NegRel D}
%             end
%          end
%       end

%       local
%          proc {MapIntR N T TR Dom}
%             if N\=0 then
%                {FdIntR Dom T.N TR.N} {MapIntR N-1 T TR Dom}
%             end
%          end
%       in
%          proc {FdDomR Dom V B}
%             thread
%                T  = {VectorToTuple V}
%                N  = {Width T}
%                TR = {MakeTuple '#' N}
%             in
%                {MapIntR N T TR Dom}
%                {GenSumR TR '=:' N B}
%             end
%          end
%       end

%       proc {Card Low Ds Up B}
%          thread
%             if {FdIs Low} andthen {FdIs Up} then
%                if {IsLiteral Ds} then
%                   {FdBool B}
%                   or B=1 Low=0
%                   [] B=0 {FdInt 1#FdSup Low}
%                   end
%                else
%                   {FdpCard {VectorToTuple Ds} Low Up B}
%                end
%             else
%                {Exception.raiseError
%                 kernel(type
%                        'FD.reified.card'
%                        [Low Ds Up B]
%                        fd
%                        if {FdIs Low} then 3 else 1 end
%                        'Cardinality limits must be finite domain.')}
%             end
%          end
%       end

%       proc {GenSumACR IV DV Rel D B}
%          NegRel = NegRelTable.Rel
%       in
%          {FdBool B}
%          thread
%             or B=1 {FdpSumAC IV DV Rel    D}
%             [] B=0 {FdpSumAC IV DV NegRel D}
%             end
%          end
%       end

%       proc {GenSumACNR IV DDV Rel D B}
%          NegRel = NegRelTable.Rel
%       in
%          {FdBool B}
%          thread
%             or B=1 {GenSumACN IV DDV Rel    D}
%             [] B=0 {GenSumACN IV DDV NegRel D}
%             end
%          end
%       end

%       proc {DistanceR X Y Rel D B}
%          {GenSumACR 1#~1 X#Y Rel D B}
%       end

%    in

%       FdReified = reified(int:        FdIntR
%                           dom:        FdDomR
%                           sum:        GenSumR
%                           sumC:       GenSumCR
%                           sumCN:      GenSumCNR
%                           sumAC:      GenSumACR
%                           sumACN:     GenSumACNR
%                           distance:   DistanceR
%                           card:       Card)
%    end


%    %%
%    %% Distribution
%    %%

%    local

%       proc {MakeDistrTuple V ?T}
%          T = {VectorToTuple V}
%          if {Record.all T FdIs} then skip else
%             {Exception.raiseError
%              kernel(type MakeDistrTuple [V T] 'vector(fd)' 1
%                     'Distribution vector must contain finite domains.')}
%          end
%       end

%       %% Optimized and generic
%       SelVal = map(min:      FdReflect.min
%                    max:      FdReflect.max
%                    mid:      FdReflect.mid
%                    splitMin: fun {$ V}
%                                 0#{FdReflect.mid V}
%                              end
%                    splitMax: fun {$ V}
%                                 {FdReflect.mid V}+1#FdSup
%                              end)

%       %% Generic only
%       GenSelVar = map(naive:   fun {$ _ _}
%                                   false
%                                end
%                       size:    fun {$ X Y}
%                                   {FdReflect.size X}<{FdReflect.size Y}
%                                end
%                       width:   fun {$ X Y}
%                                   {FdReflect.width X}<{FdReflect.width Y}
%                                end
%                       nbSusps: fun {$ X Y}
%                                   L1={FdReflect.nbSusps X}
%                                   L2={FdReflect.nbSusps Y}
%                                in
%                                   L1>L2 orelse
%                                   (L1==L2 andthen
%                                    {FdReflect.size X}<{FdReflect.size Y})
%                                end
%                       min:     fun {$ X Y}
%                                   {FdReflect.min X}<{FdReflect.min Y}
%                                end
%                       max:     fun {$ X Y}
%                                   {FdReflect.max X}>{FdReflect.max Y}
%                                end)

%       GenSelFil = map(undet:  fun {$ X}
%                                  {FdReflect.size X} > 1
%                               end)

%       %% use unit as default value to recognize the case when
%       %% we can void the overhead of a procedure call and a synchronization
%       %% on stability
%       GenSelPro = map(noProc: unit)

%       GenSelSel = map(id:     fun {$ X}
%                                  X
%                               end)

%       fun {MapSelect Map AOP}
%          if {IsAtom AOP} then Map.AOP else AOP end
%       end

%       fun {PreProcessSpec Spec}
%          FullSpec = {Adjoin
%                      generic(order:     size
%                              filter:    undet
%                              select:    id
%                              value:     min
%                              procedure: noProc)
%                      case Spec
%                      of naive then generic(order:naive)
%                      [] ff    then generic
%                      [] split then generic(value:splitMin)
%                      else Spec
%                      end}
%          IsOpt =    case FullSpec
%                     of generic(select:id filter:undet procedure:noProc
%                                order:OrdSpec value:ValSpec) then
%                        {IsAtom OrdSpec} andthen {IsAtom ValSpec}
%                     else false
%                     end
%       in
%          if IsOpt then
%             opt(order: FullSpec.order
%                 value: FullSpec.value)
%          else
%             gen(order:     {MapSelect GenSelVar FullSpec.order}
%                 value:     {MapSelect SelVal FullSpec.value}
%                 select:    {MapSelect GenSelSel FullSpec.select}
%                 filter:    {MapSelect GenSelFil FullSpec.filter}
%                 procedure: {MapSelect GenSelPro FullSpec.procedure})
%          end
%       end

%       %% 1st argument must be a list, records are too slow
%       fun {Choose Vars Order Filter}
%          fun {Loop Vars Accu}
%             case Vars of nil then Accu
%             [] H|T then
%                {Loop T
%                 if {Filter H} andthen (Accu==unit orelse {Order H Accu})
%                 then H else Accu end}
%             end
%          end
%       in
%          {Loop Vars unit}
%       end

%       %% Same as Choose,  but returns the filtered list of vars
%       %% as well as the chosen variable.
%       fun {ChooseAndRetFiltVars Vars Order Filter}
%          NewVars
%          fun {Loop Vars Accu NewTail}
%             case Vars of nil then
%                NewTail=nil
%                Accu|NewVars
%             [] H|T then
%                if {Filter H} then LL in NewTail=(H|LL)
%                   {Loop T
%                    if Accu==unit orelse {Order H Accu}
%                    then H else Accu end
%                    LL}
%                else {Loop T Accu NewTail} end
%             end
%          end
%       in
%          {Loop Vars unit NewVars}
%       end

%    in

%       proc {FdDistribute RawSpec Vec}
%          case {PreProcessSpec RawSpec}
%          of opt(value:SelVal order:SelVar) then
%             {Wait {FDP.distribute FddOptVarMap.SelVar FddOptValMap.SelVal Vec}}
%          [] gen(value:     SelVal
%                 order:     Order
%                 select:    Select
%                 filter:    Fil
%                 procedure: Proc) then
%             if {Width Vec}>0 then
%                proc {Do Xs}
%                   {Space.waitStable}
%                   E|Fs={ChooseAndRetFiltVars Xs Order Fil}
%                in
%                   if E\=unit then
%                      V={Select E}
%                      D={SelVal V}
%                   in
%                      if Proc\=unit then
%                         {Proc}
%                         {Space.waitStable}
%                      end
%                      choice {FdInt D        V}
%                      []     {FdInt compl(D) V}
%                      end
%                      {Do Fs}
%                   end
%                end
%             in
%                {Do {VectorToList Vec}}
%             end
%          end
%       end

%       proc {FdChoose RawSpec Vec ?V ?D}
%          {Space.waitStable}
% %        try
%             case {PreProcessSpec RawSpec}
%             of opt(value:SelValSpec order:SelVarSpec) then
%                case {Filter {VectorToList Vec} GenSelFil.undet}
%                of nil then D=unit
%                [] X|Xs then
%                   {Choose Xs X {MapSelect GenSelVar SelVarSpec} V}
%                   {{MapSelect SelVal SelValSpec} V D}
%                end
%             [] gen(value:     SelVal
%                    order:     Order
%                    select:    Select
%                    filter:    Fil
%                    procedure: _)
%             then
%                case {Filter {VectorToList Vec} Fil} of nil then
%                   D=unit
%                [] X|Xr then
%                   V={Select {Choose Xr X Order}}
%                   D={SelVal V}
%                end
%             end
% %        catch ~1 then
% %           {Exception.raiseError
% %            fd(noChoice 'FD.choose' [RawSpec Vec V D] 2
% %               'Vector must contain non-determined elements.')}
% %        end
%       end
%    end

%    proc {FdAssign Spec V}
%       {Wait {FDP.assign Spec V}}
%    end

%    %%
%    %% Watching variables
%    %%

%    FdWatch = watch(size: FDB.'watch.size'
%                    min:  FDB.'watch.min'
%                    max:  FDB.'watch.max')


%    %%
%    %% Miscalleanous
%    %%

%    proc {FdLess X Y}
%       {FdpLessEqOff X Y ~1}
%    end
%    proc {FdGreater X Y}
%       {FdpLessEqOff Y X ~1}
%    end
%    proc {FdLesseq X Y}
%       {FdpLessEqOff X Y 0}
%    end
%    proc {FdGreatereq X Y}
%       {FdpLessEqOff Y X 0}
%    end

%    FdDisjointC = FdpDisjointC

%    %%
%    %% Register error formatter
%    %%

%    {Error.registerFormatter fd
%     fun {$ E}
%        T = 'error in finite domain system'
%     in
%        case E
%        of fd(noChoice A Xs P S) then
%           %% expected Xs:list, P:int, S:virtualString
%           error(kind: T
%                 items: (hint(l:'At argument' m:P)|
%                         hint(l:'In statement' m:apply(A Xs))|
%                         {Append {FormatOrigin A} [line(S)]}))

%        else
%           error(kind: T
%                 items: [line(oz(E))])
%        end
%     end}

% end
