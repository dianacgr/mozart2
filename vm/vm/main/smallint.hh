// Copyright © 2011, Université catholique de Louvain
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// *  Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
// *  Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#ifndef MOZART_SMALLINT_H
#define MOZART_SMALLINT_H

#include "mozartcore.hh"

#include <string>
#include <limits>

#ifdef VM_HAS_CSS
#include <gecode/int.hh>
#endif

#ifndef MOZART_GENERATOR

namespace mozart {

//////////////
// SmallInt //
//////////////

#include "SmallInt-implem.hh"

void SmallInt::create(nativeint& self, VM vm, GR gr, SmallInt from) {
  self = from.value();
}

bool SmallInt::equals(VM vm, RichNode right) {
  return value() == right.as<SmallInt>().value();
}

int SmallInt::compareFeatures(VM vm, RichNode right) {
  auto rhs = right.as<SmallInt>().value();

  if (value() == rhs)
    return 0;
  else if (value() < rhs)
    return -1;
  else
    return 1;
}

// Comparable ------------------------------------------------------------------

int SmallInt::compare(RichNode self, VM vm, RichNode right) {
  using namespace mozart::patternmatching;

  nativeint smallInt;
  if (matches(vm, right, capture(smallInt))) {
    return (value() == smallInt) ? 0 : (value() < smallInt) ? -1 : 1;
  } else if (right.is<BigInt>()) {
    return -Comparable(right).compare(vm, self);
  } else {
    raiseTypeError(vm, "Integer", right);
  }
}

// Numeric ---------------------------------------------------------------------

UnstableNode SmallInt::opposite(VM vm) {
  // Detecting overflow - platform dependent (2's complement)
  if (value() != min()) {
    // No overflow
    return SmallInt::build(vm, -value());
  } else {
    UnstableNode big = BigInt::build(vm, min());
    return Numeric(big).opposite(vm);
  }
}

UnstableNode SmallInt::add(VM vm, RichNode right) {
  using namespace mozart::patternmatching;

  nativeint smallInt;
  if (matches(vm, right, capture(smallInt))) {
    return add(vm, smallInt);
  } else if (right.is<BigInt>()) {
    UnstableNode big = BigInt::build(vm, value());
    return Numeric(big).add(vm, right);
  } else {
    raiseTypeError(vm, "Integer", right);
  }
}

UnstableNode SmallInt::add(VM vm, nativeint b) {
  nativeint a = value();
  nativeint c = a + b;

  // Detecting overflow - platform dependent (2's complement)
  if ((((a ^ c) & (b ^ c)) >> std::numeric_limits<nativeint>::digits) == 0) {
    // No overflow
    return SmallInt::build(vm, c);
  } else {
    UnstableNode left = BigInt::build(vm, a);
    UnstableNode right = SmallInt::build(vm, b);
    return Numeric(left).add(vm, right);
  }
}

UnstableNode SmallInt::subtract(VM vm, RichNode right) {
  using namespace mozart::patternmatching;

  nativeint smallInt;
  if (matches(vm, right, capture(smallInt))) {
    return subtractValue(vm, smallInt);
  } else if (right.is<BigInt>()) {
    UnstableNode big = BigInt::build(vm, value());
    return Numeric(big).subtract(vm, right);
  } else {
    raiseTypeError(vm, "Integer", right);
  }
}

UnstableNode SmallInt::subtractValue(VM vm, nativeint b) {
  nativeint a = value();
  nativeint c = a - b;

  // Detecting overflow - platform dependent (2's complement)
  if (((~(a ^ ~b) & (a ^ c)) >> std::numeric_limits<nativeint>::digits) == 0) {
    // No overflow
    return SmallInt::build(vm, c);
  } else {
    UnstableNode left = BigInt::build(vm, a);
    UnstableNode right = SmallInt::build(vm, b);
    return Numeric(left).subtract(vm, right);
  }
}

UnstableNode SmallInt::multiply(VM vm, RichNode right) {
  using namespace mozart::patternmatching;

  nativeint smallInt;
  if (matches(vm, right, capture(smallInt))) {
    return multiplyValue(vm, smallInt);
  } else if (right.is<BigInt>()) {
    UnstableNode big = BigInt::build(vm, value());
    return Numeric(big).multiply(vm, right);
  } else {
    raiseTypeError(vm, "Integer", right);
  }
}

bool SmallInt::testMultiplyOverflow(nativeint a, nativeint b) {
  // This is platform dependent (2's complement)

  nativeint absa = a < 0 ? -a : a;
  nativeint absb = b < 0 ? -b : b;

  // Fast test first
  // If both absa and absb < sqrt(max()), then obviously there is no overflow
  const int bits = std::numeric_limits<nativeint>::digits / 2;
  if (((absa | absb) >> bits) == 0)
    return false;

  // Slow test (because of the division)
  return (a == min()) ||
         ((b != 0) && (absa >= max() / absb));
}

UnstableNode SmallInt::multiplyValue(VM vm, nativeint b) {
  nativeint a = value();

  // Detecting overflow
  if (!testMultiplyOverflow(a, b)) {
    // No overflow
    return SmallInt::build(vm, a * b);
  } else {
    UnstableNode left = BigInt::build(vm, a);
    UnstableNode right = SmallInt::build(vm, b);
    return Numeric(left).multiply(vm, right);
  }
}

UnstableNode SmallInt::div(VM vm, RichNode right) {
  using namespace mozart::patternmatching;

  nativeint smallInt;
  if (matches(vm, right, capture(smallInt))) {
    return divValue(vm, smallInt);
  } else if (right.is<BigInt>()) {
    UnstableNode big = BigInt::build(vm, value());
    return Numeric(big).div(vm, right);
  } else {
    raiseTypeError(vm, "Integer", right);
  }
}

UnstableNode SmallInt::divValue(VM vm, nativeint b) {
  nativeint a = value();
  if (b == 0) {
    raiseKernelError(vm, "Integer division: Division by zero");
  }

  // Detecting overflow
  if ((a != min()) || (b != -1)) {
    // No overflow
    return SmallInt::build(vm, a / b);
  } else {
    UnstableNode left = BigInt::build(vm, a);
    UnstableNode right = SmallInt::build(vm, b);
    return Numeric(left).div(vm, right);
  }
}

UnstableNode SmallInt::mod(VM vm, RichNode right) {
  using namespace mozart::patternmatching;

  nativeint smallInt;
  if (matches(vm, right, capture(smallInt))) {
    return modValue(vm, smallInt);
  } else if (right.is<BigInt>()) {
    UnstableNode big = BigInt::build(vm, value());
    return Numeric(big).mod(vm, right);
  } else {
    raiseTypeError(vm, "Integer", right);
  }
}

UnstableNode SmallInt::modValue(VM vm, nativeint b) {
  nativeint a = value();

  // Detecting overflow
  if ((a != min()) || (b != -1)) {
    // No overflow
    return SmallInt::build(vm, a % b);
  } else {
    UnstableNode left = BigInt::build(vm, a);
    UnstableNode right = SmallInt::build(vm, b);
    return Numeric(left).mod(vm, right);
  }
}

UnstableNode SmallInt::abs(VM vm) {
  nativeint a = value();
  // Detecting overflow - platform dependent (2's complement)
  if (a != min()) {
    // No overflow
    return SmallInt::build(vm, a >= 0 ? a : -a);
  } else {
    UnstableNode big = BigInt::build(vm, min());
    return Numeric(big).opposite(vm);
  }
}

#ifdef VM_HAS_CSS
  //CstintVar ------------------------------------------------------------
bool SmallInt::assigned(VM vm) {
  if(!isIntVarLike(vm))
    raiseTypeError(vm, "ConstraintVar", value());
  return true;
}
// IntVarLike ---------------------------------------------------------------
bool SmallInt::isIntVarLike(VM vm) {
  return (Gecode::Int::Limits::min <= value()) &&
         (value() <= Gecode::Int::Limits::max); 
}

  Gecode::IntVar& SmallInt::intVar(RichNode self, VM vm) {
    CstIntVar x(vm,self,self);
    return x.getVar();
  }

UnstableNode SmallInt::min(VM vm) {
  if(!isIntVarLike(vm))
    raiseTypeError(vm, "IntVarLike",value());
  return SmallInt::build(vm,value());  
}

UnstableNode SmallInt::max(VM vm) {
  if(!isIntVarLike(vm))
    raiseTypeError(vm, "IntVarLike",value());
  return SmallInt::build(vm,value());  
}

UnstableNode SmallInt::value(VM vm) {
  if(!isIntVarLike(vm))
    raiseTypeError(vm, "IntVarLike",value());
  return SmallInt::build(vm,value());  
}

UnstableNode SmallInt::isIn(VM vm, RichNode right) {
  nativeint r = getArgument<nativeint>(vm,right,"integer");
  if (r < Gecode::Int::Limits::min || r > Gecode::Int::Limits::max)
    raiseTypeError(vm,"IntVarLike",right);
  return r == value() ? 
         Boolean::build(vm,true) : Boolean::build(vm,false);
}
#endif

}

#endif // MOZART_GENERATOR

#endif // MOZART_SMALLINT_H
