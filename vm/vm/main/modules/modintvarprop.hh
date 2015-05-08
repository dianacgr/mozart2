#ifndef MOZART_MODINTVARPROP_H
#define MOZART_MODINTVARPROP_H

#include "../mozartcore.hh"
#include <gecode/int.hh>
#include "cstsupport/intsupport.hh"

namespace mozart {

  namespace builtins {

    // Notes:
    // - All the constraints are posted in vm->getCurrentSpace()
    //   TODO: can I assume that the current space is the same space each
    //   variable belongs to?
    class ModIntVarProp: public Module {
    public:
      ModIntVarProp(): Module("IntVarProp") {}

      class Distinct: public Builtin<Distinct> {
      public:
	Distinct(): Builtin("distinct") {}
    
	static void call(VM vm, In x) {
	  assert(vm->getCurrentSpace()->hasConstraintSpace());
	  GecodeSpace& home = vm->getCurrentSpace()->getCstSpace(true);
      
	  if(isIntVarArgs(vm,x)){
	    Gecode::distinct(home,getIntVarArgs(vm,x));
	  }else{
	    raiseTypeError(vm, ("Propagator posting distinct malformed"), x);
	  }
	}
      };

      class Distinct2: public Builtin<Distinct2> {
      public:
	Distinct2(): Builtin("distinct2") {}
    
	static void call(VM vm, In v, In x) {
	  assert(vm->getCurrentSpace()->hasConstraintSpace());
	  GecodeSpace& home = vm->getCurrentSpace()->getCstSpace(true);
      
	  if(isIntArgs(vm,v) and isIntVarArgs(vm,x)){
	    Gecode::distinct(home,getIntArgs(vm,v),getIntVarArgs(vm,x));
	  }else{
	    raiseTypeError(vm, ("Propagator posting distinct malformed"), x);
	  }
	}
      };
  
  //Contraint between array elements
      class RelBetweenArray: public Builtin<RelBetweenArray> {
      public:
	RelBetweenArray(): Builtin("relBetweenArray") {}
	
	static void call(VM vm, In x, In r) {
	  assert(vm->getCurrentSpace()->hasConstraintSpace());
	  GecodeSpace& home = vm->getCurrentSpace()->getCstSpace(true);
	  
	  if(isIntVarArgs(vm,x) and isAtomToRelType(vm,r)){
	    Gecode::IntRelType rt = atomToRelType(vm,r);
	    Gecode::rel(home,getIntVarArgs(vm,x),rt);
	  }else{
	    raiseTypeError(vm, ("Propagator posting rel malformed"), x);
	  }
	}
      };
      

  //Binary relation contraint    
      class BinaryRel: public Builtin<BinaryRel> {
      public:
	BinaryRel(): Builtin("binaryRel") {}

	static void call(VM vm, In x, In r, In y) {
	  assert(vm->getCurrentSpace()->hasConstraintSpace());
	  GecodeSpace& home = vm->getCurrentSpace()->getCstSpace(true);
      
	  if(IntVarLike(x).isIntVarLike(vm) and isAtomToRelType(vm,r) and IntVarLike(y).isIntVarLike(vm)){
	    Gecode::IntRelType rt = atomToRelType(vm,r);
	    Gecode::rel(home,IntVarLike(x).intVar(vm),rt,IntVarLike(y).intVar(vm));
	  }else if(isIntVarArgs(vm,x) and isAtomToRelType(vm,r) and IntVarLike(y).isIntVarLike(vm)){
	    Gecode::IntRelType rt = atomToRelType(vm,r);
	    Gecode::rel(home,getIntVarArgs(vm,x),rt,IntVarLike(y).intVar(vm));
	  }else if(IntVarLike(x).isIntVarLike(vm) and isAtomToRelType(vm,r) and y.is<SmallInt>()){
	    Gecode::IntRelType rt = atomToRelType(vm,r);
	    nativeint num = y.as<SmallInt>().value();
	    Gecode::rel(home,IntVarLike(x).intVar(vm),rt,(int)(num));
	  }else if(isIntVarArgs(vm,x) and isAtomToRelType(vm,r) and y.is<SmallInt>()){
	    Gecode::IntRelType rt = atomToRelType(vm,r);
	    nativeint num = y.as<SmallInt>().value();
	    Gecode::rel(home,getIntVarArgs(vm,x),rt,(int)(num));
	  }else if(isIntVarArgs(vm,x) and isAtomToRelType(vm,r) and isIntVarArgs(vm,y)){
	    Gecode::IntRelType rt = atomToRelType(vm,r);
	    Gecode::rel(home,getIntVarArgs(vm,x),rt,getIntVarArgs(vm,y));
	  }else{
	    raiseTypeError(vm, ("Propagator posting rel malformed"), x);
	  }
	}
      };
      
  //linear constraints 
  
  class Linear3: public Builtin<Linear3> {
      public:
	Linear3(): Builtin("linear3") {}
    
	static void call(VM vm, In v, In r, In x) {
	  assert(vm->getCurrentSpace()->hasConstraintSpace());
	  GecodeSpace& home = vm->getCurrentSpace()->getCstSpace(true);
	  if(isIntVarArgs(vm,v) and isAtomToRelType(vm,r) and x.is<SmallInt>()){
	    nativeint val=x.as<SmallInt>().value();
	    Gecode::IntRelType rt = atomToRelType(vm,r);
	    Gecode::linear(home,getIntVarArgs(vm,v),rt,(int)(val));
	  }else if(isIntVarArgs(vm,v) and isAtomToRelType(vm,r) and IntVarLike(x).isIntVarLike(vm)){
	    Gecode::IntRelType rt = atomToRelType(vm,r);
	    Gecode::linear(home,getIntVarArgs(vm,v),rt,IntVarLike(x).intVar(vm));
	  }else{
	    raiseTypeError(vm, ("Propagator posting linear malformed"), v);
	  }
	}
      };
      
  //Distribute
  class Distribute: public Builtin<Distribute> {
      public:
	Distribute(): Builtin("distribute") {}
	static void call(VM vm, In selVar, In selVal, In v) {
	  assert(vm->getCurrentSpace()->hasConstraintSpace());
	  Space* homeSpace = vm->getCurrentSpace();
	  if(homeSpace->isStable()){
		std::cout << "el espacio es estable"<< std::endl;
	  }
	  GecodeSpace& homeCst = vm->getCurrentSpace()->getCstSpace(true);
	  nativeint var=selVar.as<SmallInt>().value();
	  nativeint val=selVal.as<SmallInt>().value();
	  std::cout << "will choose a distributor var: " <<var<<"val: "<<val<< std::endl; 
	}
      };

    }; // class ModIntVarProp
  } // namespace builtins
} // namespace mozart
#endif // __MODINTVARPROP_H
