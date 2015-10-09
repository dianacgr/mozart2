#ifndef MOZART_GECODESPACE_H
#define MOZART_GECODESPACE_H


#ifndef MOZART_GENERATOR


namespace mozart {
  GecodeSpace::GecodeSpace(void)
    : Gecode::Space(), lastStatus(Gecode::SS_BRANCH){
    //alive.push_back(this);
  }
  
GecodeSpace::GecodeSpace(bool share, GecodeSpace& other) 
  : Gecode::Space(share,other), lastStatus(Gecode::SS_BRANCH),
    _intVars(other._intVars),
    _setVars(other._setVars),
    _boolVars(other._boolVars)
{
  for(auto i = _intVars.size(); i--;)
    _intVars[i].update(*this,share,other._intVars[i]);
  for(auto i = _setVars.size(); i--;)
    _setVars[i].update(*this,share,other._setVars[i]);
  for(auto i = _boolVars.size(); i--;)
    _boolVars[i].update(*this,share,other._boolVars[i]);
  //alive.push_back(this);
}

GecodeSpace::~GecodeSpace(void) {
  //std::cout << "Destructed gecode space" << std::endl;
}
  
void GecodeSpace::propagate(void){
  //std::cout << "GecodeSpace: propagating... " <<  std::endl;
  lastStatus= this->status();
}

int GecodeSpace::getLastStatus(void){
	return (int) lastStatus;
}

  void GecodeSpace::fail(){
    Gecode::Space::fail();
    lastStatus = Gecode::SS_FAILED;
  }
//This methods updates all the vars of *this* gecodeSpace with
//the information available in *other* gecodeSpace.
void GecodeSpace::reflectVars(GecodeSpace& other){
  for(unsigned int i = 0; i<_intVars.size(); ++i)
    _intVars[i].update(*this,false,other._intVars[i]);
  for(unsigned int i = 0; i<_setVars.size(); ++i)
    _setVars[i].update(*this,false,other._setVars[i]);
  for(unsigned int i = 0; i<_boolVars.size(); ++i)
    _boolVars[i].update(*this,false,other._boolVars[i]);
}
  
Gecode::Space* GecodeSpace::copy(bool share) {
  return new GecodeSpace(share,*this);
}
  
Gecode::IntVar& GecodeSpace::intVar(size_t index) {
  if (index >= _intVars.size())
    std::cerr << "Accessing intVar at invalid index" << std::endl;
  return _intVars[index];
}
  
size_t GecodeSpace::newIntVar(int min, int max) {
  _intVars.push_back(Gecode::IntVar(*this,min,max));
  return _intVars.size() - 1;
}
  
Gecode::SetVar& GecodeSpace::setVar(size_t index) {
  if (index >= _setVars.size())
    std::cerr << "Accessing setVar at invalid index" << std::endl;
  return _setVars[index];
}
size_t GecodeSpace::newSetVar() {
  _setVars.push_back(Gecode::SetVar());
  return _setVars.size() - 1;
}
Gecode::BoolVar& GecodeSpace::boolVar(size_t index) {
  if (index >= _boolVars.size())
    std::cerr << "Accessing boolVar at invalid index" << std::endl;
  return _boolVars[index];
}
size_t GecodeSpace::newBoolVar() {
  _boolVars.push_back(Gecode::BoolVar(*this,0,1));
  return _boolVars.size() - 1;
}

void GecodeSpace::inspect(){
  for (auto i=0;i<_intVars.size();i++){
	std::cout<<i<<" "<<_intVars[i]<<std::endl;
  }
  
}
	
}

#endif

#endif