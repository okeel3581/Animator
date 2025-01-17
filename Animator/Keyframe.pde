class Keyframe{
  PVector pos1;
  float size;
  float rotation;
  boolean guidingKeyframe;
  
  Keyframe(PVector p, float s, float r, boolean gk){
    this.pos1 = p;
    this.size = s;
    this.rotation = r;
    this.guidingKeyframe = gk;
  }
  
  // used by shape for updating keyframes
  void fillThroughSet(Keyframe keyframe){
    pos1 = keyframe.pos1;
    size = keyframe.size;
    rotation = keyframe.rotation;
    guidingKeyframe = false;
  }
}
