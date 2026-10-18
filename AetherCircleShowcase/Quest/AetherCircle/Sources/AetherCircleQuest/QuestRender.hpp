#pragma once

// OpenXR stereo renderer. Included after SwiftBridge in AetherCircleQuest.cpp.
// All GL, OpenXR and Swift bridge operations run on the NativeActivity thread.

inline void xrCheck(XrResult result, const char* operation) {
    if (XR_FAILED(result)) {
        __android_log_print(ANDROID_LOG_ERROR, logTag, "%s failed: %d", operation, result);
        throw std::runtime_error(operation);
    }
}

struct Matrix {
    std::array<float, 16> m{};
    static Matrix identity() { Matrix a; a.m = {1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1}; return a; }
    static Matrix translation(float x, float y, float z) {
        Matrix a = identity(); a.m[12]=x; a.m[13]=y; a.m[14]=z; return a;
    }
    static Matrix scale(float x, float y, float z) {
        Matrix a = identity(); a.m[0]=x; a.m[5]=y; a.m[10]=z; return a;
    }
    Matrix operator*(const Matrix& b) const {
        Matrix out;
        for (int c=0;c<4;++c) for (int r=0;r<4;++r) for (int k=0;k<4;++k)
            out.m[c*4+r] += m[k*4+r]*b.m[c*4+k];
        return out;
    }
    static Matrix quaternion(XrQuaternionf q) {
        Matrix a=identity();
        const float x=q.x,y=q.y,z=q.z,w=q.w;
        a.m[0]=1-2*y*y-2*z*z; a.m[1]=2*x*y+2*w*z; a.m[2]=2*x*z-2*w*y;
        a.m[4]=2*x*y-2*w*z; a.m[5]=1-2*x*x-2*z*z; a.m[6]=2*y*z+2*w*x;
        a.m[8]=2*x*z+2*w*y; a.m[9]=2*y*z-2*w*x; a.m[10]=1-2*x*x-2*y*y;
        return a;
    }
    static Matrix euler(float x,float y,float z) {
        return quaternion({0,0,std::sin(z/2),std::cos(z/2)})*
               quaternion({0,std::sin(y/2),0,std::cos(y/2)})*
               quaternion({std::sin(x/2),0,0,std::cos(x/2)});
    }
    static Matrix view(XrPosef pose) {
        auto q=pose.orientation;
        return quaternion({-q.x,-q.y,-q.z,q.w})*
               translation(-pose.position.x,-pose.position.y,-pose.position.z);
    }
    static Matrix projection(XrFovf fov) {
        float l=std::tan(fov.angleLeft),r=std::tan(fov.angleRight);
        float d=std::tan(fov.angleDown),u=std::tan(fov.angleUp);
        const float n=0.05f,f=100.f;
        Matrix a;
        a.m[0]=2/(r-l); a.m[5]=2/(u-d); a.m[8]=(r+l)/(r-l); a.m[9]=(u+d)/(u-d);
        a.m[10]=-(f+n)/(f-n); a.m[11]=-1; a.m[14]=-2*f*n/(f-n);
        return a;
    }
};

// Original compact 5x7 glyphs. Lowercase uses uppercase forms in this first pass.
inline std::array<unsigned char,7> glyph(char c) {
    switch (std::toupper(static_cast<unsigned char>(c))) {
#define G(c,a,b,d,e,f,g,h) case c: return {a,b,d,e,f,g,h}
    G('A',14,17,17,31,17,17,17); G('B',30,17,17,30,17,17,30);
    G('C',14,17,16,16,16,17,14); G('D',30,17,17,17,17,17,30);
    G('E',31,16,16,30,16,16,31); G('F',31,16,16,30,16,16,16);
    G('G',14,17,16,23,17,17,15); G('H',17,17,17,31,17,17,17);
    G('I',31,4,4,4,4,4,31); G('J',7,2,2,2,18,18,12);
    G('K',17,18,20,24,20,18,17); G('L',16,16,16,16,16,16,31);
    G('M',17,27,21,21,17,17,17); G('N',17,25,21,19,17,17,17);
    G('O',14,17,17,17,17,17,14); G('P',30,17,17,30,16,16,16);
    G('Q',14,17,17,17,21,18,13); G('R',30,17,17,30,20,18,17);
    G('S',15,16,16,14,1,1,30); G('T',31,4,4,4,4,4,4);
    G('U',17,17,17,17,17,17,14); G('V',17,17,17,17,17,10,4);
    G('W',17,17,17,21,21,21,10); G('X',17,17,10,4,10,17,17);
    G('Y',17,17,10,4,4,4,4); G('Z',31,1,2,4,8,16,31);
    G('0',14,17,19,21,25,17,14); G('1',4,12,4,4,4,4,14);
    G('2',14,17,1,2,4,8,31); G('3',30,1,1,14,1,1,30);
    G('4',2,6,10,18,31,2,2); G('5',31,16,16,30,1,1,30);
    G('6',14,16,16,30,17,17,14); G('7',31,1,2,4,8,8,8);
    G('8',14,17,17,14,17,17,14); G('9',14,17,17,15,1,1,14);
    G('-',0,0,0,31,0,0,0); G('.',0,0,0,0,0,12,12);
    G(':',0,12,12,0,12,12,0); G('?',14,17,1,2,4,0,4);
    G(' ',0,0,0,0,0,0,0);
#undef G
    default: return {31,17,21,21,21,17,31};
    }
}

struct EyeTarget {
    XrSwapchain swapchain=XR_NULL_HANDLE;
    int width=0,height=0;
    GLuint framebuffer=0,depth=0;
    std::vector<XrSwapchainImageOpenGLESKHR> images;
};

class QuestRenderer {
    EGLDisplay display=EGL_NO_DISPLAY;
    EGLContext context=EGL_NO_CONTEXT;
    EGLSurface surface=EGL_NO_SURFACE;
    EGLConfig config=nullptr;
    GLuint program=0,vao=0,vbo=0;
    GLint matrixLocation=-1,colorLocation=-1;
    XrInstance instance=XR_NULL_HANDLE;
    SwiftBridge& swift;
    XrPassthroughFB passthrough=XR_NULL_HANDLE;
    XrPassthroughLayerFB passthroughLayer=XR_NULL_HANDLE;
    PFN_xrDestroyPassthroughFB destroyPassthrough=nullptr;
    PFN_xrDestroyPassthroughLayerFB destroyPassthroughLayer=nullptr;
    bool loggedFrame=false;
    bool focused=false,placementReady=false,loggedDrawing=false;
    Matrix sceneOrigin=Matrix::identity();
    int drawCalls=0;

    double elapsed=0;
    XrTime firstTime=0;
    std::vector<Matrix> transforms;
    XrActionSet actionSet=XR_NULL_HANDLE;
    XrAction aimAction=XR_NULL_HANDLE,triggerAction=XR_NULL_HANDLE;
    std::array<XrPath,2> handPaths{};
    std::array<XrSpace,2> aimSpaces{};
    std::array<Matrix,2> aims{};
    std::array<bool,2> rayVisible{},triggerArmed{},loggedController{};
    std::array<int,2> targets{{-1,-1}};
    std::array<float,2> rayLengths{{3,3}};

    void updateTransforms() {
        const int count=swift.objectCount();
        transforms.resize(count);
        for(int i=0;i<count;++i) {
            auto v=[&](int k){return swift.objectValue(i,k);};
            Matrix local=Matrix::translation(v(0),v(1),v(2))*
                Matrix::euler(v(6)+v(9)*elapsed,v(7)+v(10)*elapsed,v(8)+v(11)*elapsed);
            int parent=swift.objectParent(i);
            transforms[i]=(parent>=0 && parent<i)?transforms[parent]*local:local;
        }
    }
    void initializeControllers() {
        XrActionSetCreateInfo set{XR_TYPE_ACTION_SET_CREATE_INFO};
        std::strcpy(set.actionSetName,"showcase_input");
        std::strcpy(set.localizedActionSetName,"Showcase Input");
        xrCheck(xrCreateActionSet(instance,&set,&actionSet),"create controller action set");
        xrCheck(xrStringToPath(instance,"/user/hand/left",&handPaths[0]),"left hand path");
        xrCheck(xrStringToPath(instance,"/user/hand/right",&handPaths[1]),"right hand path");
        auto makeAction=[&](const char* name,const char* label,XrActionType type,XrAction& action) {
            XrActionCreateInfo info{XR_TYPE_ACTION_CREATE_INFO};
            std::strcpy(info.actionName,name);std::strcpy(info.localizedActionName,label);
            info.actionType=type;info.countSubactionPaths=2;info.subactionPaths=handPaths.data();
            xrCheck(xrCreateAction(actionSet,&info,&action),"create controller action");
        };
        makeAction("aim","Point",XR_ACTION_TYPE_POSE_INPUT,aimAction);
        makeAction("trigger","Activate",XR_ACTION_TYPE_FLOAT_INPUT,triggerAction);
        std::array<XrActionSuggestedBinding,4> bindings{};
        for(int hand=0;hand<2;++hand) {
            std::string prefix=hand==0?"/user/hand/left":"/user/hand/right";
            XrPath aimPath=XR_NULL_PATH,triggerPath=XR_NULL_PATH;
            xrCheck(xrStringToPath(instance,(prefix+"/input/aim/pose").c_str(),&aimPath),"aim binding path");
            xrCheck(xrStringToPath(instance,(prefix+"/input/trigger/value").c_str(),&triggerPath),"trigger binding path");
            bindings[hand*2]={aimAction,aimPath};bindings[hand*2+1]={triggerAction,triggerPath};
        }
        XrPath profile=XR_NULL_PATH;
        xrCheck(xrStringToPath(instance,"/interaction_profiles/oculus/touch_controller",&profile),"Touch profile path");
        XrInteractionProfileSuggestedBinding suggested{XR_TYPE_INTERACTION_PROFILE_SUGGESTED_BINDING};
        suggested.interactionProfile=profile;suggested.countSuggestedBindings=4;suggested.suggestedBindings=bindings.data();
        xrCheck(xrSuggestInteractionProfileBindings(instance,&suggested),"suggest Touch controller bindings");
        for(int hand=0;hand<2;++hand) {
            XrActionSpaceCreateInfo info{XR_TYPE_ACTION_SPACE_CREATE_INFO};
            info.action=aimAction;info.subactionPath=handPaths[hand];info.poseInActionSpace.orientation.w=1;
            xrCheck(xrCreateActionSpace(session,&info,&aimSpaces[hand]),"create controller aim space");
        }
        XrSessionActionSetsAttachInfo attach{XR_TYPE_SESSION_ACTION_SETS_ATTACH_INFO};
        attach.countActionSets=1;attach.actionSets=&actionSet;
        xrCheck(xrAttachSessionActionSets(session,&attach),"attach controller actions");
        log("Touch controller aim and trigger actions attached.");
    }
    // Ray/OBB intersection: inverse rigid transform leaves distance in meters.
    static float boxHit(const Matrix& world,const Matrix& aim,const std::array<float,3>& size) {
        float delta[3]={aim.m[12]-world.m[12],aim.m[13]-world.m[13],aim.m[14]-world.m[14]};
        float direction[3]={-aim.m[8],-aim.m[9],-aim.m[10]};
        float near=0,far=10;
        for(int axis=0;axis<3;++axis) {
            float origin=0,ray=0;
            for(int k=0;k<3;++k){origin+=world.m[axis*4+k]*delta[k];ray+=world.m[axis*4+k]*direction[k];}
            float half=std::max(size[axis]*.5f,.003f);
            if(std::abs(ray)<1e-6f) {if(std::abs(origin)>half)return -1;continue;}
            float a=(-half-origin)/ray,b=(half-origin)/ray;
            if(a>b)std::swap(a,b);
            near=std::max(near,a);far=std::min(far,b);
            if(near>far)return -1;
        }
        return far>=0?near:-1;
    }
    void updateControllers(XrTime time) {
        targets={-1,-1};rayVisible={false,false};
        if(!swift.userInteractionEnabled() || !focused || !placementReady) {triggerArmed={false,false};return;}
        XrActiveActionSet active{actionSet,XR_NULL_PATH};
        XrActionsSyncInfo sync{XR_TYPE_ACTIONS_SYNC_INFO};sync.countActiveActionSets=1;sync.activeActionSets=&active;
        XrResult result=xrSyncActions(session,&sync);
        if(result==XR_SESSION_NOT_FOCUSED)return;
        xrCheck(result,"sync controllers");
        for(int hand=0;hand<2;++hand) {
            XrActionStateGetInfo get{XR_TYPE_ACTION_STATE_GET_INFO};get.subactionPath=handPaths[hand];get.action=aimAction;
            XrActionStatePose poseState{XR_TYPE_ACTION_STATE_POSE};xrCheck(xrGetActionStatePose(session,&get,&poseState),"controller pose state");
            get.action=triggerAction;
            XrActionStateFloat trigger{XR_TYPE_ACTION_STATE_FLOAT};xrCheck(xrGetActionStateFloat(session,&get,&trigger),"controller trigger state");
            if(!poseState.isActive || !trigger.isActive){triggerArmed[hand]=false;continue;}
            XrSpaceLocation location{XR_TYPE_SPACE_LOCATION};xrCheck(xrLocateSpace(aimSpaces[hand],space,time,&location),"locate controller");
            const XrSpaceLocationFlags valid=XR_SPACE_LOCATION_POSITION_VALID_BIT|XR_SPACE_LOCATION_ORIENTATION_VALID_BIT;
            if((location.locationFlags&valid)!=valid){triggerArmed[hand]=false;continue;}
            if(!loggedController[hand]) {
                __android_log_print(ANDROID_LOG_INFO,logTag,"Controller %s tracking active.",hand==0?"left":"right");
                loggedController[hand]=true;
            }
            auto& p=location.pose.position;
            aims[hand]=Matrix::translation(p.x,p.y,p.z)*Matrix::quaternion(location.pose.orientation);
            rayVisible[hand]=true;rayLengths[hand]=3;
            float nearest=10;
            for(int i=0;i<swift.objectCount();++i) {
                if(swift.objectPrimitive(i)==2 || swift.objectValue(i,12)==0)continue;
                // Hit test currently rendered box geometry only.
                int primitive=swift.objectPrimitive(i);if(primitive!=0 && primitive!=3)continue;
                float hit=boxHit(sceneOrigin*transforms[i],aims[hand],
                    {swift.objectValue(i,3),swift.objectValue(i,4),swift.objectValue(i,5)});
                if(hit>=0 && hit<nearest) {nearest=hit;targets[hand]=swift.objectTarget(i);}
            }
            if(nearest<10)rayLengths[hand]=nearest;
            if(trigger.currentState<.35f)triggerArmed[hand]=true;
            if(trigger.currentState>.65f && triggerArmed[hand]) {
                triggerArmed[hand]=false;
                if(targets[hand]>=0) {
                    __android_log_print(ANDROID_LOG_INFO,logTag,"Controller activated target %d.",targets[hand]);
                    swift.activate(targets[hand]);
                    // A callback can replace the scene and invalidate every index.
                    targets={-1,-1};
                    if(!swift.userInteractionEnabled()) {
                        rayVisible={false,false};triggerArmed={false,false};
                    }
                    updateTransforms();return;
                }
            }
        }
    }


    AAssetManager* assets=nullptr;
    std::map<std::string,GLuint> textures;
    std::map<int,std::vector<float>> meshes;
    GLint panoramaLayoutLocation=-1,panoramaEyeLocation=-1;
    GLint textureLocation=-1,texturedLocation=-1,lightingLocation=-1;
    GLint roughnessLocation=-1,metallicLocation=-1,modelLocation=-1;

    GLuint textureFor(int object) {
        int length=swift.objectTexture(object,nullptr,0);
        if(length<=0)return 0;
        std::vector<char> name(length+1);swift.objectTexture(object,name.data(),length+1);
        std::string filename(name.data());
        if(auto found=textures.find(filename);found!=textures.end())return found->second;
        GLuint texture=0;
        const std::string path="aethercircle/"+filename;
        AAsset* asset=AAssetManager_open(assets,path.c_str(),AASSET_MODE_BUFFER);
        AImageDecoder* decoder=nullptr;
        int result=asset?AImageDecoder_createFromAAsset(asset,&decoder):-1;
        int width=0,height=0;
        if(result==ANDROID_IMAGE_DECODER_SUCCESS) {
            auto header=AImageDecoder_getHeaderInfo(decoder);
            width=AImageDecoderHeaderInfo_getWidth(header);height=AImageDecoderHeaderInfo_getHeight(header);
            const int panoramaLayout=object==-1?int(swift.objectValue(-1,3)):-1;
            const int panoramaRatio=panoramaLayout==1?1:(panoramaLayout==2?4:2);
            if(panoramaLayout>=0 && width!=height*panoramaRatio) {
                __android_log_print(ANDROID_LOG_ERROR,logTag,"Invalid 360 image dimensions: %s (%dx%d)",filename.c_str(),width,height);
                width=0;
            }
            if(width<=0 || height<=0 || width>8192 || height>8192)result=-1;
            else result=AImageDecoder_setAndroidBitmapFormat(decoder,ANDROID_BITMAP_FORMAT_RGBA_8888);
            if(result==ANDROID_IMAGE_DECODER_SUCCESS) {
                std::vector<unsigned char> pixels(static_cast<size_t>(width)*height*4);
                result=AImageDecoder_decodeImage(decoder,pixels.data(),width*4,pixels.size());
                if(result==ANDROID_IMAGE_DECODER_SUCCESS) {
                    glGenTextures(1,&texture);glBindTexture(GL_TEXTURE_2D,texture);
                    glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA8,width,height,0,GL_RGBA,GL_UNSIGNED_BYTE,pixels.data());
                    // Packed stereo eyes must never blend across eye boundaries in mipmaps.
                    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,panoramaLayout>=0?GL_LINEAR:GL_LINEAR_MIPMAP_LINEAR);
                    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
                    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
                    glGenerateMipmap(GL_TEXTURE_2D);
                }
            }
        }
        if(decoder)AImageDecoder_delete(decoder);if(asset)AAsset_close(asset);
        textures[filename]=texture;
        __android_log_print(texture?ANDROID_LOG_INFO:ANDROID_LOG_ERROR,logTag,
            "Texture %s: %s (%dx%d, decoder=%d)",filename.c_str(),texture?"loaded":"FAILED",width,height,result);
        return texture;
    }
    const std::vector<float>& meshFor(int id,const std::vector<float>& cube) {
        if(id==0 || id==3)return cube;
        if(auto found=meshes.find(id);found!=meshes.end())return found->second;
        auto& out=meshes[id];
        using P=std::array<float,3>;
        auto tri=[&](P a,P b,P c){for(auto p:{a,b,c})out.insert(out.end(),p.begin(),p.end());};
        auto quad=[&](P a,P b,P c,P d){tri(a,b,c);tri(a,c,d);};
        constexpr float pi=3.141592653589793f;constexpr int steps=48,rings=24;
        if(id==1 || id==4 || id==5 || id==8) {
            auto point=[&](float u,float v)->P {
                float phi=(id==4?pi/2:pi)*v;
                float radius=id==8?.25f:.5f;
                float y=radius*std::cos(phi);
                if(id==8)y+=(y>=0?.25f:-.25f);
                return {radius*std::sin(phi)*std::cos(u),y,radius*std::sin(phi)*std::sin(u)};
            };
            for(int j=0;j<rings;++j)for(int i=0;i<steps;++i) {
                float a=2*pi*i/steps,b=2*pi*(i+1)/steps,v=float(j)/rings,w=float(j+1)/rings;
                quad(point(a,v),point(a,w),point(b,w),point(b,v));
            }
            if(id==4)for(int i=0;i<steps;++i)tri({0,0,0},point(2*pi*i/steps,1),point(2*pi*(i+1)/steps,1));
        } else if(id==6 || id==7 || id==17 || id==13) {
            int n=id==13?6:steps;
            auto point=[](float angle,float y,float radius)->P{return {radius*std::cos(angle),y,radius*std::sin(angle)};};
            for(int i=0;i<n;++i) {
                float a=2*pi*i/n,b=2*pi*(i+1)/n;
                float bottom=id==17?0:-.5f,top=id==17?0:.5f,r=id==7?0:.5f;
                quad(point(a,bottom,.5f),point(b,bottom,.5f),point(b,top,r),point(a,top,r));
                tri({0,bottom,0},point(b,bottom,.5f),point(a,bottom,.5f));
                if(id!=7)tri({0,top,0},point(a,top,r),point(b,top,r));
            }
        } else if(id==14 || id==18) {
            int tubes=id==18?1:16;
            auto point=[&](float a,float b)->P {
                if(id==18) {float r=b==0?.5f:.34f;return {r*std::cos(a),0,r*std::sin(a)};}
                float r=.35f+.15f*std::cos(b);return {r*std::cos(a),.5f*std::sin(b),r*std::sin(a)};
            };
            for(int i=0;i<steps;++i)for(int j=0;j<tubes;++j) {
                float a=2*pi*i/steps,b=2*pi*(i+1)/steps,c=2*pi*j/tubes,d=2*pi*(j+1)/tubes;
                quad(point(a,c),point(b,c),point(b,d),point(a,d));
            }
        } else if(id==15)quad({-.5f,-.5f,0},{.5f,-.5f,0},{.5f,.5f,0},{-.5f,.5f,0});
        else if(id==16)tri({-.5f,-.5f,0},{.5f,-.5f,0},{0,.5f,0});
        else if(id==9 || id==10) {
            int n=id==10?3:4;P apex={0,.5f,0};
            for(int i=0;i<n;++i) {
                auto p=[&](int k)->P {float a=2*pi*k/n+pi/4;return {.5f*std::cos(a),-.5f,.5f*std::sin(a)};};
                tri(p(i),p(i+1),apex);tri({0,-.5f,0},p(i+1),p(i));
            }
        } else if(id==11) {
            P top={0,.5f,0},bottom={0,-.5f,0};
            for(int i=0;i<4;++i) {
                auto p=[&](int k)->P {float a=pi*k/2;return {.5f*std::cos(a),0,.5f*std::sin(a)};};
                tri(p(i),p(i+1),top);tri(p(i+1),p(i),bottom);
            }
        } else if(id==12) {
            P a={-.5f,-.5f,-.5f},b={.5f,-.5f,-.5f},c={-.5f,.5f,-.5f};
            P d={-.5f,-.5f,.5f},e={.5f,-.5f,.5f},f={-.5f,.5f,.5f};
            tri(a,b,c);tri(d,f,e);quad(a,d,e,b);quad(a,c,f,d);quad(b,e,f,c);
        }
        return out;
    }

    GLuint shader(GLenum type,const char* source) {
        GLuint s=glCreateShader(type); glShaderSource(s,1,&source,nullptr); glCompileShader(s);
        GLint ok=0; glGetShaderiv(s,GL_COMPILE_STATUS,&ok);
        if (!ok) { char message[2048]; glGetShaderInfoLog(s,sizeof(message),nullptr,message);
            __android_log_print(ANDROID_LOG_ERROR,logTag,"Shader: %s",message); glDeleteShader(s); throw std::runtime_error("shader compilation"); }
        return s;
    }
    void geometry(const std::vector<float>& vertices,const Matrix& matrix,const std::array<float,4>& color,
                  GLuint texture=0,float roughness=.5f,float metallic=0,bool lit=false,
                  const Matrix& model=Matrix::identity(),bool spherical=false,float repeatU=1,float repeatV=1,int panoramaLayout=-1,int panoramaEye=0) {
        if(vertices.empty() || color[3]<=0)return;
        std::vector<float> data;data.reserve(vertices.size()/3*8);
        for(size_t i=0;i+8<vertices.size();i+=9) {
            float ax=vertices[i+3]-vertices[i],ay=vertices[i+4]-vertices[i+1],az=vertices[i+5]-vertices[i+2];
            float bx=vertices[i+6]-vertices[i],by=vertices[i+7]-vertices[i+1],bz=vertices[i+8]-vertices[i+2];
            float nx=ay*bz-az*by,ny=az*bx-ax*bz,nz=ax*by-ay*bx;
            float length=std::sqrt(nx*nx+ny*ny+nz*nz);
            if(length>1e-8f){nx/=length;ny/=length;nz/=length;}else{nx=0;ny=0;nz=1;}
            // Unwrap each triangle across the longitude seam before interpolation.
            std::array<float,3> longitude{};
            if(spherical) {
                for(int v=0;v<3;++v) {
                    const float x=vertices[i+v*3],z=vertices[i+v*3+2];
                    longitude[v]=(panoramaLayout>=0?std::atan2(x,-z):std::atan2(z,x))/(2*3.14159265f)+.5f;
                }
                auto bounds=std::minmax_element(longitude.begin(),longitude.end());
                if(*bounds.second-*bounds.first>.5f)for(float& u:longitude)if(u<.5f)u+=1;
                for(int v=0;v<3;++v)if(std::abs(vertices[i+v*3+1])>.49999f)
                    longitude[v]=(longitude[(v+1)%3]+longitude[(v+2)%3])/2;
            }
            for(int vertex=0;vertex<3;++vertex) {
                float x=vertices[i+vertex*3],y=vertices[i+vertex*3+1],z=vertices[i+vertex*3+2];
                float u=x+.5f,v=y+.5f;
                if(std::abs(ny)>std::abs(nx) && std::abs(ny)>std::abs(nz)){u=x+.5f;v=z+.5f;}
                else if(std::abs(nx)>std::abs(nz)){u=z+.5f;v=y+.5f;}
                if(spherical){u=longitude[vertex];v=std::acos(std::clamp(y*2,-1.f,1.f))/3.14159265f;}
                data.insert(data.end(),{x,y,z,nx,ny,nz,u*repeatU,(1-v)*repeatV});
            }
        }
        glUniformMatrix4fv(matrixLocation,1,GL_FALSE,matrix.m.data());
        glUniformMatrix4fv(modelLocation,1,GL_FALSE,model.m.data());
        glUniform4fv(colorLocation,1,color.data());
        glUniform1i(panoramaLayoutLocation,panoramaLayout);glUniform1i(panoramaEyeLocation,panoramaEye);
        glUniform1i(texturedLocation,texture?1:0);glUniform1i(lightingLocation,lit?1:0);
        glUniform1f(roughnessLocation,std::clamp(roughness,0.f,1.f));glUniform1f(metallicLocation,std::clamp(metallic,0.f,1.f));
        glActiveTexture(GL_TEXTURE0);glBindTexture(GL_TEXTURE_2D,texture);glUniform1i(textureLocation,0);
        glBufferData(GL_ARRAY_BUFFER,static_cast<GLsizeiptr>(data.size()*sizeof(float)),data.data(),GL_STREAM_DRAW);
        glDrawArrays(GL_TRIANGLES,0,static_cast<GLsizei>(data.size()/8));++drawCalls;
    }
    void drawScene(const Matrix& camera) {
        const int count=swift.objectCount();
        transforms.resize(count);
        const std::vector<float> cube={
            -.5f,-.5f,.5f, .5f,-.5f,.5f, .5f,.5f,.5f, -.5f,-.5f,.5f, .5f,.5f,.5f, -.5f,.5f,.5f,
            .5f,-.5f,-.5f, -.5f,-.5f,-.5f, -.5f,.5f,-.5f, .5f,-.5f,-.5f, -.5f,.5f,-.5f, .5f,.5f,-.5f,
            -.5f,-.5f,-.5f, -.5f,-.5f,.5f, -.5f,.5f,.5f, -.5f,-.5f,-.5f, -.5f,.5f,.5f, -.5f,.5f,-.5f,
            .5f,-.5f,.5f, .5f,-.5f,-.5f, .5f,.5f,-.5f, .5f,-.5f,.5f, .5f,.5f,-.5f, .5f,.5f,.5f,
            -.5f,.5f,.5f, .5f,.5f,.5f, .5f,.5f,-.5f, -.5f,.5f,.5f, .5f,.5f,-.5f, -.5f,.5f,-.5f,
            -.5f,-.5f,-.5f, .5f,-.5f,-.5f, .5f,-.5f,.5f, -.5f,-.5f,-.5f, .5f,-.5f,.5f, -.5f,-.5f,.5f};
        for (int i=0;i<count;++i) {
            auto value=[&](int k){return swift.objectValue(i,k);};
            if (!value(12)) continue;
            std::array<float,4> color{}; for(int c=0;c<4;++c)color[c]=swift.objectColor(i,c);
            int owner=swift.objectTarget(i);
            if(owner>=0 && (targets[0]==owner || targets[1]==owner) && value(13)==0)
                color={1.f,.72f,.12f,color[3]};
            const float height=value(13);
            if (height>0) {
                int length=swift.objectText(i,nullptr,0);
                std::vector<char> text(static_cast<size_t>(std::max(0,length))+1);
                swift.objectText(i,text.data(),static_cast<int>(text.size()));
                std::vector<float> vertices;
                float advance=height*.62f, pixelX=advance/6, pixelY=height/7;
                float start=-advance*length/2;
                for(int c=0;c<length;++c) {
                    auto rows=glyph(text[c]);
                    for(int row=0;row<7;++row)for(int col=0;col<5;++col) if(rows[row]&(1<<(4-col))) {
                        float x=start+c*advance+col*pixelX,y=height/2-row*pixelY;
                        float x1=x+pixelX*.92f,y1=y-pixelY*.92f;
                        vertices.insert(vertices.end(),{x,y1,0,x1,y1,0,x1,y,0,x,y1,0,x1,y,0,x,y,0});
                    }
                }
                geometry(vertices,camera*sceneOrigin*transforms[i],color);
            } else {
                int primitive=swift.objectPrimitive(i);
                if(primitive!=2) {
                    Matrix model=sceneOrigin*transforms[i]*Matrix::scale(value(3),value(4),value(5));
                    geometry(meshFor(primitive,cube),camera*model,color,textureFor(i),value(14),value(15),true,model,
                             primitive==1 || primitive==4 || primitive==5);
                }
            }
        }
        for(int hand=0;hand<2;++hand) if(rayVisible[hand]) {
            Matrix ray=aims[hand]*Matrix::translation(0,0,-rayLengths[hand]/2)*
                Matrix::scale(.004f,.004f,rayLengths[hand]);
            geometry(cube,camera*ray,targets[hand]>=0?std::array<float,4>{1, .75f, .1f,1}:std::array<float,4>{.2f,.85f,1,1});
        }
    }
public:
    XrSession session=XR_NULL_HANDLE;
    XrSpace space=XR_NULL_HANDLE;
    std::vector<EyeTarget> eyes;
    bool running=false,exitRequested=false;
    QuestRenderer(SwiftBridge& bridge,AAssetManager* manager):swift(bridge),assets(manager) {}
    ~QuestRenderer() {
        if(display!=EGL_NO_DISPLAY && context!=EGL_NO_CONTEXT)
            eglMakeCurrent(display,surface,surface,context);
        for(auto& eye:eyes) {
            if(eye.framebuffer)glDeleteFramebuffers(1,&eye.framebuffer);
            if(eye.depth)glDeleteRenderbuffers(1,&eye.depth);
            if(eye.swapchain)xrDestroySwapchain(eye.swapchain);
        }
        for(const auto& texture:textures)if(texture.second)glDeleteTextures(1,&texture.second);
        if(vbo)glDeleteBuffers(1,&vbo); if(vao)glDeleteVertexArrays(1,&vao); if(program)glDeleteProgram(program);
        for(auto aimSpace:aimSpaces)if(aimSpace)xrDestroySpace(aimSpace);
        if(passthroughLayer && destroyPassthroughLayer)destroyPassthroughLayer(passthroughLayer);
        if(passthrough && destroyPassthrough)destroyPassthrough(passthrough);
        if(space)xrDestroySpace(space); if(session)xrDestroySession(session);
        if(actionSet)xrDestroyActionSet(actionSet);
        if(display!=EGL_NO_DISPLAY) {
            eglMakeCurrent(display,EGL_NO_SURFACE,EGL_NO_SURFACE,EGL_NO_CONTEXT);
            if(surface!=EGL_NO_SURFACE)eglDestroySurface(display,surface);
            if(context!=EGL_NO_CONTEXT)eglDestroyContext(display,context);
            eglTerminate(display);
        }
    }
    void initialize(XrInstance xrInstance,XrSystemId system,bool passthroughSupported) {
        instance=xrInstance;
        PFN_xrGetOpenGLESGraphicsRequirementsKHR getRequirements=nullptr;
        xrCheck(xrGetInstanceProcAddr(instance,"xrGetOpenGLESGraphicsRequirementsKHR",reinterpret_cast<PFN_xrVoidFunction*>(&getRequirements)),"resolve GLES requirements");
        XrGraphicsRequirementsOpenGLESKHR requirements{XR_TYPE_GRAPHICS_REQUIREMENTS_OPENGL_ES_KHR};
        xrCheck(getRequirements(instance,system,&requirements),"GLES requirements");
        display=eglGetDisplay(EGL_DEFAULT_DISPLAY);
        if(display==EGL_NO_DISPLAY || !eglInitialize(display,nullptr,nullptr) || !eglBindAPI(EGL_OPENGL_ES_API))throw std::runtime_error("EGL initialization");
        const EGLint attrs[]={EGL_RENDERABLE_TYPE,EGL_OPENGL_ES3_BIT,EGL_SURFACE_TYPE,EGL_PBUFFER_BIT,EGL_RED_SIZE,8,EGL_GREEN_SIZE,8,EGL_BLUE_SIZE,8,EGL_ALPHA_SIZE,8,EGL_DEPTH_SIZE,24,EGL_NONE};
        EGLint found=0;
        if(!eglChooseConfig(display,attrs,&config,1,&found) || !found)throw std::runtime_error("EGL configuration");
        const EGLint contextAttrs[]={EGL_CONTEXT_CLIENT_VERSION,3,EGL_NONE};
        context=eglCreateContext(display,config,EGL_NO_CONTEXT,contextAttrs);
        const EGLint pbufferAttrs[]={EGL_WIDTH,16,EGL_HEIGHT,16,EGL_NONE};
        surface=eglCreatePbufferSurface(display,config,pbufferAttrs);
        if(context==EGL_NO_CONTEXT || surface==EGL_NO_SURFACE || !eglMakeCurrent(display,surface,surface,context))throw std::runtime_error("EGL context");
        GLint major=0,minor=0;glGetIntegerv(GL_MAJOR_VERSION,&major);glGetIntegerv(GL_MINOR_VERSION,&minor);
        XrVersion version=XR_MAKE_VERSION(major,minor,0);
        if(version<requirements.minApiVersionSupported || version>requirements.maxApiVersionSupported)throw std::runtime_error("GLES version outside OpenXR requirements");
        XrGraphicsBindingOpenGLESAndroidKHR binding{XR_TYPE_GRAPHICS_BINDING_OPENGL_ES_ANDROID_KHR};
        binding.display=display;binding.config=config;binding.context=context;
        XrSessionCreateInfo info{XR_TYPE_SESSION_CREATE_INFO};info.next=&binding;info.systemId=system;
        xrCheck(xrCreateSession(instance,&info,&session),"create GLES session");
        uint32_t count=0;
        xrCheck(xrEnumerateReferenceSpaces(session,0,&count,nullptr),"enumerate reference spaces");
        std::vector<XrReferenceSpaceType> spaces(count);
        xrCheck(xrEnumerateReferenceSpaces(session,count,&count,spaces.data()),"reference spaces");
        XrReferenceSpaceCreateInfo reference{XR_TYPE_REFERENCE_SPACE_CREATE_INFO};reference.poseInReferenceSpace.orientation.w=1;
        reference.referenceSpaceType=std::find(spaces.begin(),spaces.end(),XR_REFERENCE_SPACE_TYPE_STAGE)!=spaces.end()?XR_REFERENCE_SPACE_TYPE_STAGE:XR_REFERENCE_SPACE_TYPE_LOCAL;
        // Showcase uses floor-relative heights. LOCAL fallback assumes 1.6m eye height.
        if(reference.referenceSpaceType==XR_REFERENCE_SPACE_TYPE_LOCAL)reference.poseInReferenceSpace.position.y=-1.6f;
        xrCheck(xrCreateReferenceSpace(session,&reference,&space),"create scene reference space");
        xrCheck(xrEnumerateViewConfigurationViews(instance,system,XR_VIEW_CONFIGURATION_TYPE_PRIMARY_STEREO,0,&count,nullptr),"enumerate eye views");
        if(count!=2)throw std::runtime_error("Expected stereo view configuration");
        std::vector<XrViewConfigurationView> views(count,{XR_TYPE_VIEW_CONFIGURATION_VIEW});
        xrCheck(xrEnumerateViewConfigurationViews(instance,system,XR_VIEW_CONFIGURATION_TYPE_PRIMARY_STEREO,count,&count,views.data()),"eye views");
        xrCheck(xrEnumerateSwapchainFormats(session,0,&count,nullptr),"enumerate formats");
        std::vector<int64_t> formats(count);xrCheck(xrEnumerateSwapchainFormats(session,count,&count,formats.data()),"swapchain formats");
        if(std::find(formats.begin(),formats.end(),GL_RGBA8)==formats.end())throw std::runtime_error("RGBA8 swapchain format unavailable");
        eyes.resize(2);
        for(size_t i=0;i<eyes.size();++i) {
            auto& eye=eyes[i];eye.width=views[i].recommendedImageRectWidth;eye.height=views[i].recommendedImageRectHeight;
            XrSwapchainCreateInfo swap{XR_TYPE_SWAPCHAIN_CREATE_INFO};
            swap.usageFlags=XR_SWAPCHAIN_USAGE_COLOR_ATTACHMENT_BIT;swap.format=GL_RGBA8;
            swap.sampleCount=1;swap.width=eye.width;swap.height=eye.height;swap.faceCount=1;swap.arraySize=1;swap.mipCount=1;
            xrCheck(xrCreateSwapchain(session,&swap,&eye.swapchain),"create eye swapchain");
            xrCheck(xrEnumerateSwapchainImages(eye.swapchain,0,&count,nullptr),"enumerate eye images");
            eye.images.resize(count,{XR_TYPE_SWAPCHAIN_IMAGE_OPENGL_ES_KHR});
            xrCheck(xrEnumerateSwapchainImages(eye.swapchain,count,&count,reinterpret_cast<XrSwapchainImageBaseHeader*>(eye.images.data())),"eye images");
            glGenFramebuffers(1,&eye.framebuffer);glGenRenderbuffers(1,&eye.depth);
            glBindRenderbuffer(GL_RENDERBUFFER,eye.depth);glRenderbufferStorage(GL_RENDERBUFFER,GL_DEPTH_COMPONENT24,eye.width,eye.height);
        }
        const char* vs=R"(#version 300 es
layout(location=0) in vec3 position;
layout(location=1) in vec3 normal;
layout(location=2) in vec2 uv;
uniform mat4 matrix;uniform mat4 model;
out vec3 surfaceNormal;out vec2 textureUV;
void main(){gl_Position=matrix*vec4(position,1.0);surfaceNormal=transpose(inverse(mat3(model)))*normal;textureUV=uv;}
)";
        const char* fs=R"(#version 300 es
precision highp float;
uniform vec4 color;uniform sampler2D baseTexture;
uniform int panoramaLayout;uniform int panoramaEye;
uniform int textured;uniform int lighting;uniform float roughness;uniform float metallic;
in vec3 surfaceNormal;in vec2 textureUV;out vec4 outputColor;
void main(){
 vec2 uv=textureUV;
 if(panoramaLayout>=0){
   // Decoder rows begin at the image top. Sphere UVs begin at the bottom.
   vec2 texel=1.0/vec2(textureSize(baseTexture,0));
   uv=vec2(fract(uv.x),clamp(1.0-uv.y,texel.y*.5,1.0-texel.y*.5));
   if(panoramaLayout==1){
     uv.y=clamp((uv.y+float(panoramaEye))*.5,float(panoramaEye)*.5+texel.y*.5,float(panoramaEye+1)*.5-texel.y*.5);
   } else if(panoramaLayout==2){
     uv.x=clamp((uv.x+float(panoramaEye))*.5,float(panoramaEye)*.5+texel.x*.5,float(panoramaEye+1)*.5-texel.x*.5);
   }
 }
 vec4 base=color;if(textured==1)base*=texture(baseTexture,uv);
 vec3 result=base.rgb;
 if(lighting==1){
   vec3 n=normalize(surfaceNormal);if(!gl_FrontFacing)n=-n;
   vec3 light=normalize(vec3(.4,.8,1.));float diffuse=max(dot(n,light),0.);
   vec3 halfVector=normalize(light+vec3(0,0,1));
   float spec=pow(max(dot(n,halfVector),0.),mix(96.,4.,roughness))*(1.-roughness*.7);
   vec3 f0=mix(vec3(.04),base.rgb,metallic);
   result=base.rgb*(.32+.68*diffuse)*(1.-metallic*.35)+f0*spec;
 }
 outputColor=vec4(result,base.a);
}
)";
        GLuint vertex=shader(GL_VERTEX_SHADER,vs),fragment=shader(GL_FRAGMENT_SHADER,fs);
        program=glCreateProgram();glAttachShader(program,vertex);glAttachShader(program,fragment);glLinkProgram(program);
        glDeleteShader(vertex);glDeleteShader(fragment);
        GLint linked=0;glGetProgramiv(program,GL_LINK_STATUS,&linked);if(!linked)throw std::runtime_error("shader program link");
        matrixLocation=glGetUniformLocation(program,"matrix");colorLocation=glGetUniformLocation(program,"color");
        panoramaLayoutLocation=glGetUniformLocation(program,"panoramaLayout");panoramaEyeLocation=glGetUniformLocation(program,"panoramaEye");
        textureLocation=glGetUniformLocation(program,"baseTexture");texturedLocation=glGetUniformLocation(program,"textured");
        lightingLocation=glGetUniformLocation(program,"lighting");roughnessLocation=glGetUniformLocation(program,"roughness");
        metallicLocation=glGetUniformLocation(program,"metallic");modelLocation=glGetUniformLocation(program,"model");
        glGenVertexArrays(1,&vao);glBindVertexArray(vao);glGenBuffers(1,&vbo);glBindBuffer(GL_ARRAY_BUFFER,vbo);
        glEnableVertexAttribArray(0);glVertexAttribPointer(0,3,GL_FLOAT,GL_FALSE,8*sizeof(float),nullptr);
        glEnableVertexAttribArray(1);glVertexAttribPointer(1,3,GL_FLOAT,GL_FALSE,8*sizeof(float),reinterpret_cast<void*>(3*sizeof(float)));
        glEnableVertexAttribArray(2);glVertexAttribPointer(2,2,GL_FLOAT,GL_FALSE,8*sizeof(float),reinterpret_cast<void*>(6*sizeof(float)));
        if(passthroughSupported) {
            PFN_xrCreatePassthroughFB createPassthrough=nullptr;
            PFN_xrCreatePassthroughLayerFB createLayer=nullptr;
            auto resolve=[&](const char* name,auto& function) {
                xrCheck(xrGetInstanceProcAddr(instance,name,reinterpret_cast<PFN_xrVoidFunction*>(&function)),name);
            };
            resolve("xrCreatePassthroughFB",createPassthrough);
            resolve("xrCreatePassthroughLayerFB",createLayer);
            resolve("xrDestroyPassthroughFB",destroyPassthrough);
            resolve("xrDestroyPassthroughLayerFB",destroyPassthroughLayer);
            XrPassthroughCreateInfoFB passInfo{XR_TYPE_PASSTHROUGH_CREATE_INFO_FB};
            passInfo.flags=XR_PASSTHROUGH_IS_RUNNING_AT_CREATION_BIT_FB;
            XrResult result=createPassthrough(session,&passInfo,&passthrough);
            if(XR_SUCCEEDED(result)) {
                XrPassthroughLayerCreateInfoFB layerInfo{XR_TYPE_PASSTHROUGH_LAYER_CREATE_INFO_FB};
                layerInfo.passthrough=passthrough;
                layerInfo.flags=XR_PASSTHROUGH_IS_RUNNING_AT_CREATION_BIT_FB;
                layerInfo.purpose=XR_PASSTHROUGH_LAYER_PURPOSE_RECONSTRUCTION_FB;
                result=createLayer(session,&layerInfo,&passthroughLayer);
            }
            if(XR_FAILED(result)) {
                __android_log_print(ANDROID_LOG_ERROR,logTag,"Passthrough initialization failed: %d; using full VR.",result);
            } else log("Quest passthrough underlay is ready; using the shared environment mode.");
        } else log("Quest passthrough is unavailable; using full VR.");
        initializeControllers();
        log("OpenXR GLES session, floor space and stereo swapchains are ready.");
    }
    void pollEvents() {
        XrEventDataBuffer event{XR_TYPE_EVENT_DATA_BUFFER};
        XrResult result;
        while((result=xrPollEvent(instance,&event))==XR_SUCCESS) {
            if(event.type==XR_TYPE_EVENT_DATA_SESSION_STATE_CHANGED) {
                auto& state=*reinterpret_cast<XrEventDataSessionStateChanged*>(&event);
                focused=state.state==XR_SESSION_STATE_FOCUSED;
                __android_log_print(ANDROID_LOG_INFO,logTag,"OpenXR session state: %d",state.state);
                if(state.state==XR_SESSION_STATE_READY && !running) {
                    XrSessionBeginInfo begin{XR_TYPE_SESSION_BEGIN_INFO};begin.primaryViewConfigurationType=XR_VIEW_CONFIGURATION_TYPE_PRIMARY_STEREO;
                    xrCheck(xrBeginSession(session,&begin),"begin session");running=true;
                } else if(state.state==XR_SESSION_STATE_STOPPING && running) {
                    xrCheck(xrEndSession(session),"end session");running=false;
                } else if(state.state==XR_SESSION_STATE_EXITING || state.state==XR_SESSION_STATE_LOSS_PENDING) {
                    running=false;exitRequested=true;
                }
            } else if(event.type==XR_TYPE_EVENT_DATA_INSTANCE_LOSS_PENDING) {exitRequested=true;running=false;}
            event={XR_TYPE_EVENT_DATA_BUFFER};
        }
        if(result!=XR_EVENT_UNAVAILABLE)xrCheck(result,"poll OpenXR events");
    }
    void frame() {
        XrFrameWaitInfo wait{XR_TYPE_FRAME_WAIT_INFO};XrFrameState state{XR_TYPE_FRAME_STATE};
        xrCheck(xrWaitFrame(session,&wait,&state),"wait frame");
        XrFrameBeginInfo begin{XR_TYPE_FRAME_BEGIN_INFO};xrCheck(xrBeginFrame(session,&begin),"begin frame");
        XrCompositionLayerProjection layer{XR_TYPE_COMPOSITION_LAYER_PROJECTION};layer.space=space;
        std::array<XrCompositionLayerProjectionView,2> projectionViews{};
        const bool usePassthrough=passthroughLayer && swift.passthroughRequested();
        XrCompositionLayerPassthroughFB background{XR_TYPE_COMPOSITION_LAYER_PASSTHROUGH_FB};
        background.layerHandle=passthroughLayer;
        const XrCompositionLayerBaseHeader* layers[2]{};
        if(usePassthrough)layer.layerFlags=XR_COMPOSITION_LAYER_BLEND_TEXTURE_SOURCE_ALPHA_BIT;
        uint32_t layerCount=0;
        if(state.shouldRender) {
            std::array<XrView,2> views{{{XR_TYPE_VIEW},{XR_TYPE_VIEW}}};uint32_t count=0;
            XrViewLocateInfo locate{XR_TYPE_VIEW_LOCATE_INFO};locate.viewConfigurationType=XR_VIEW_CONFIGURATION_TYPE_PRIMARY_STEREO;locate.displayTime=state.predictedDisplayTime;locate.space=space;
            XrViewState viewState{XR_TYPE_VIEW_STATE};
            xrCheck(xrLocateViews(session,&locate,&viewState,2,&count,views.data()),"locate views");
            const XrViewStateFlags valid=XR_VIEW_STATE_POSITION_VALID_BIT|XR_VIEW_STATE_ORIENTATION_VALID_BIT;
            if(count==2 && (viewState.viewStateFlags&valid)==valid) {
                if(!firstTime)firstTime=state.predictedDisplayTime;
                elapsed=static_cast<double>(state.predictedDisplayTime-firstTime)*1e-9;
                if(focused && !placementReady) {
                    const auto& q=views[0].pose.orientation;
                    Matrix rotation=Matrix::quaternion(q);
                    const float yaw=std::atan2(rotation.m[8],rotation.m[10]);
                    const auto& left=views[0].pose.position;
                    const auto& right=views[1].pose.position;
                    const float x=(left.x+right.x)*.5f;
                    const float y=(left.y+right.y)*.5f;
                    const float z=(left.z+right.z)*.5f;
                    // Anchor once at launch, not to the moving head each frame.
                    // Sample coordinates assume a 1.6m eye height.
                    sceneOrigin=Matrix::translation(x,y-1.6f,z)*Matrix::euler(0,yaw,0);
                    placementReady=true;
                    __android_log_print(ANDROID_LOG_INFO,logTag,
                        "Home anchored at head=(%.3f,%.3f,%.3f), yaw=%.3f",x,y,z,yaw);
                }
                swift.prepareScene();
                updateTransforms();
                updateControllers(state.predictedDisplayTime);
                for(size_t i=0;i<eyes.size();++i) {
                    auto& eye=eyes[i];uint32_t index=0;
                    XrSwapchainImageAcquireInfo acquire{XR_TYPE_SWAPCHAIN_IMAGE_ACQUIRE_INFO};xrCheck(xrAcquireSwapchainImage(eye.swapchain,&acquire,&index),"acquire eye");
                    XrSwapchainImageWaitInfo imageWait{XR_TYPE_SWAPCHAIN_IMAGE_WAIT_INFO};imageWait.timeout=XR_INFINITE_DURATION;
                    xrCheck(xrWaitSwapchainImage(eye.swapchain,&imageWait),"wait eye image");
                    glBindFramebuffer(GL_FRAMEBUFFER,eye.framebuffer);
                    glFramebufferTexture2D(GL_FRAMEBUFFER,GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D,eye.images.at(index).image,0);
                    glFramebufferRenderbuffer(GL_FRAMEBUFFER,GL_DEPTH_ATTACHMENT,GL_RENDERBUFFER,eye.depth);
                    if(glCheckFramebufferStatus(GL_FRAMEBUFFER)!=GL_FRAMEBUFFER_COMPLETE)throw std::runtime_error("incomplete eye framebuffer");
                    glViewport(0,0,eye.width,eye.height);glDisable(GL_SCISSOR_TEST);glDisable(GL_CULL_FACE);
                    glEnable(GL_DEPTH_TEST);glDepthFunc(GL_LEQUAL);glDepthMask(GL_TRUE);
                    glEnable(GL_BLEND);glBlendFuncSeparate(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA,GL_ONE,GL_ONE_MINUS_SRC_ALPHA);
                    if(usePassthrough)glClearColor(0,0,0,0);else glClearColor(.025f,.035f,.065f,1);glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
                    glUseProgram(program);glBindVertexArray(vao);glBindBuffer(GL_ARRAY_BUFFER,vbo);
                    drawCalls=0;
                    // Draw a head-centered globe first, without writing depth or receiving lighting.
                    if(swift.objectValue(-1,0)>0) {
                        std::array<float,4> color{};
                        for(int c=0;c<3;++c)color[c]=swift.objectColor(-1,c);
                        color[3]=1;
                        const bool followsUser=swift.objectValue(-1,4)>0;
                        const XrVector3f center=followsUser?XrVector3f{
                            (views[0].pose.position.x+views[1].pose.position.x)*.5f,
                            (views[0].pose.position.y+views[1].pose.position.y)*.5f,
                            (views[0].pose.position.z+views[1].pose.position.z)*.5f
                        }:XrVector3f{0,0,0};
                        Matrix model=Matrix::translation(center.x,center.y,center.z)*Matrix::scale(100,100,100);
                        glDepthMask(GL_FALSE);
                        geometry(meshFor(1,{}),Matrix::projection(views[i].fov)*Matrix::view(views[i].pose)*model,
                                 color,textureFor(-1),1,0,false,model,true,swift.objectValue(-1,1),swift.objectValue(-1,2),
                                 int(swift.objectValue(-1,3)),int(i));
                        glDepthMask(GL_TRUE);
                    }
                    if(swift.objectValue(-2,0)>0) {
                        std::array<float,4> color{};for(int c=0;c<4;++c)color[c]=swift.objectColor(-2,c);
                        const float x=(views[0].pose.position.x+views[1].pose.position.x)*.5f;
                        const float z=(views[0].pose.position.z+views[1].pose.position.z)*.5f;
                        Matrix model=Matrix::translation(std::floor(x/256)*256,0,std::floor(z/256)*256)*Matrix::scale(2048,1,2048);
                        static const std::vector<float> floor={-.5f,0,-.5f, -.5f,0,.5f, .5f,0,.5f, -.5f,0,-.5f, .5f,0,.5f, .5f,0,-.5f};
                        geometry(floor,Matrix::projection(views[i].fov)*Matrix::view(views[i].pose)*model,
                                 color,textureFor(-2),swift.objectValue(-2,14),swift.objectValue(-2,15),true,model,false,2048,2048);
                    }
                    drawScene(Matrix::projection(views[i].fov)*Matrix::view(views[i].pose));
                    if(placementReady && !loggedDrawing && i==0) {
                        GLenum error=glGetError();
                        __android_log_print(ANDROID_LOG_INFO,logTag,
                            "Draw diagnostics: objects=%d draws=%d GL=0x%x",
                            swift.objectCount(),drawCalls,error);
                        for(int object=0;object<std::min(3,swift.objectCount());++object) {
                            __android_log_print(ANDROID_LOG_INFO,logTag,
                                "Object %d: primitive=%d pos=(%.3f,%.3f,%.3f) visible=%.0f textHeight=%.3f alpha=%.3f",
                                object,swift.objectPrimitive(object),
                                swift.objectValue(object,0),swift.objectValue(object,1),swift.objectValue(object,2),
                                swift.objectValue(object,12),swift.objectValue(object,13),swift.objectColor(object,3));
                        }
                        loggedDrawing=true;
                    }
                    glBindFramebuffer(GL_FRAMEBUFFER,0);glFlush();
                    XrSwapchainImageReleaseInfo release{XR_TYPE_SWAPCHAIN_IMAGE_RELEASE_INFO};xrCheck(xrReleaseSwapchainImage(eye.swapchain,&release),"release eye");
                    auto& projection=projectionViews[i];projection.type=XR_TYPE_COMPOSITION_LAYER_PROJECTION_VIEW;
                    projection.pose=views[i].pose;projection.fov=views[i].fov;projection.subImage.swapchain=eye.swapchain;
                    projection.subImage.imageRect.extent={eye.width,eye.height};
                }
                layer.viewCount=2;layer.views=projectionViews.data();
                if(usePassthrough)layers[layerCount++]=reinterpret_cast<const XrCompositionLayerBaseHeader*>(&background);
                layers[layerCount++]=reinterpret_cast<const XrCompositionLayerBaseHeader*>(&layer);
            }
        }
        XrFrameEndInfo end{XR_TYPE_FRAME_END_INFO};end.displayTime=state.predictedDisplayTime;end.environmentBlendMode=XR_ENVIRONMENT_BLEND_MODE_OPAQUE;end.layerCount=layerCount;end.layers=layerCount?layers:nullptr;
        xrCheck(xrEndFrame(session,&end),"submit frame");
        if(layerCount && !loggedFrame){log("First stereo Showcase frame submitted.");loggedFrame=true;}
    }
};



