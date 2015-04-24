#ifndef MOZART_CSTINTVAR_DECL_H
#define MOZART_CSTINTVAR_DECL_H

#include "mozartcore-decl.hh"
#include <gecode/kernel.hh>
#include <gecode/int.hh>
#include <gecode/set.hh>
namespace mozart {

class CstIntVar;

#ifndef MOZART_GENERATOR
#include "CstIntVar-implem-decl.hh"
#endif

class CstIntVar: public WithHome,
  public DataType<CstIntVar>,
  public Transient,
  public WithVariableBehavior<5> {
	 
public:  
  CstIntVar(VM vm, size_t index)
    : WithHome(vm), _varIndex(index) {}
  
  // Constructor from min and max elements in the domain
  inline
  CstIntVar(VM vm, RichNode min, RichNode max); 
	  
  // Constructor from a list (?) describing the domain
  CstIntVar(VM vm, RichNode domain)
    : WithHome(vm), _varIndex(0) {
      // TODO
      assert(false);
  }
  
  CstIntVar(VM vm, GR gr, CstIntVar from)
    //    : WithHome(vm,gr,from->home()), _varIndex(from->_varIndex) {}
    : WithHome(vm,gr,from), _varIndex(from._varIndex) {}
  
  inline
  static bool validAsElement(nativeint x);
  
public:
  Gecode::IntVar& getVar(void) {
    return home()->getCstSpace(false).intVar(_varIndex);
  }
  
public:
  //IntVarLike interface
  bool isIntVarLike(VM vm) {
    return true;
  }

  Gecode::IntVar& intVar(VM vm) {
    return getVar();
  }

  inline
  UnstableNode min(VM vm);

  inline
  UnstableNode max(VM vm);

  inline
  UnstableNode value(VM vm);

  inline
  UnstableNode isIn(VM vm, RichNode right);
public:
  // ConstraintVar interface
  inline
  bool assigned(VM vm) {
    return getVar().assigned();
  }
public:
  // Miscellaneous
  void printReprToStream(RichNode self, VM vm, std::ostream& out, int depth, int width) {
    out << "("<<_varIndex<<"):"<<getVar().min()<<"#"<<getVar().max();
  }
private:
  // The actual representation of a constraint integer variable is a 
  // Gecode::IntVar, here we store the index of an object of that class
  // inside an array stored by a Gecode::Space
  size_t _varIndex;
};// End class CstIntVar

#ifndef MOZART_GENERATOR
#include "CstIntVar-implem-decl-after.hh"
#endif	
} // End namespace mozart

#endif // MOZART_CSTINTVAR_DECL_H
