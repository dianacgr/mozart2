%% Copyright © 2011, Université catholique de Louvain
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
%%   Sébastien Doeraene <sjrdoeraene@gmail.com>
%%

functor

require
   FDB at 'x-oz://boot/IntVar'
   FDP at 'x-oz://boot/IntVarProp'
   Error(registerFormatter)

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

   FddOptVarMap = map(naive:   0
		      size:    1
		      min:     2
		      max:     3
		      nbSusps: 4
		      width:   5)
   
   FddOptValMap = map(min:      0
		       mid:      1
		       max:      2
		       splitMin: 3
		       splitMax: 4)
   
export

   New
%%% Finite Domains
   inf:             FdInf
   sup:             FdSup
   is:              FdIs
   isIn:            FdIsIn
   value:           FdValue
   
%%% Telling Domains
   int:            FdInt
   dom:		   FdDom
   decl:           FdDecl   
   list:           FdList
   tuple:          FdTuple
   record:         FdRecord

%%% Symbolic propagators   
   distinct:       FdpDistinct

%%% Miscellaneous Propagator
   rel:            FdRel
   linear:         FdpLinear
%%% Distribution
   distribute:     FdDistribute

   
define

   %%% Finite Domains
   FdIs = FDB.is
   FdIsIn = FDB.isIn
   FdValue = FDB.value

   FdInf = FDB.inf
   FdSup = FDB.sup

   
   %%% Telling Domains

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

%%% Generic propagators

   proc {FdpDistinct Post}
      {FDP.distinct Post}
   end  

%%% Simple relation over integer variables
   
   proc {FdRel Post}
      if {IsRecord Post} 
      then
	 W = {Record.width Post} 
	 R = Post.2
      in
	 case W
	 of 2 then {FDP.relBetweenArray Post.1 FdRelType.R}
	 [] 3 then {FDP.binaryRel Post.1 FdRelType.R Post.3}
%	[] 4 then {FDP.rel4 Post.1 FdRelType.R Post.3 Post.4}
	 else
	    raise malFormed(post)
	    end
	 end
      else
	 raise malFormed(post hola)
	 end 
      end
   end

%%% linear constraint for interger variable

      proc{FdpLinear Post}
   	W = {Record.width Post}
      in
	case W
	of 3 then
	   {FDP.linear3 Post.1 FdRelType.(Post.2) Post.3}
%	[] 4 then
%	   if{IsAtom Post.2} then
%	      {FDP.linear4 Post.1 FdRelType.(Post.2) Post.3 Post.4}
%	   elseif{IsAtom Post.3} then
%	      {FDP.linear4 Post.1 FdRelType.(Post.3) Post.2 Post.4}
%	   end
%	[] 5 then 
%	   {FDP.linear5 Post.1 FdRelType.(Post.3) Post.2 Post.4 Post.5}
	else
	   raise malFormed(post)
	    end
	end
      end

%%% DISTRIBUTION

      fun {PreProcessSpec Spec}
	 case Spec of naive then generic(value:min order:naive)
	 [] ff then generic(value:min order:size)
	 [] split then generic(value:splitMin order:size)
	 else
	    raise malFormed(spec)
	    end
	 end
      end

      proc {FdDistribute RawSpec Vec}
	 case {PreProcessSpec RawSpec}
	 of generic(value:SelVal order:SelVar) then
	    {FDP.distribute FddOptVarMap.SelVar FddOptValMap.SelVal Vec}
	 else
	    raise malFormed(post)
	    end
	 end
      end

end
