#set page(paper:"a4",header: align(right)[OpenGL Notebook],numbering: "1",
margin: (top:100pt,left:70pt,right:70pt,bottom:50pt))
#set par(justify: true,first-line-indent: 20pt)
#set text(font:"Libertinus Serif",size:11pt)
#set heading(numbering:"1.1")
#set enum(indent: 10pt,spacing:15pt)

\
#align(center,text(30pt,)[OpenGL Notes])
#align(center,text[Alexander Lisborg])
#align(center,text[2025-02-05])

#pagebreak()
#text(size: 20pt,font:"Libertinus Serif",align(right)[= Introduction])
#text(font:"Libertinus Serif")[== Definition]
#block(inset: (left:23pt),par[
OpenGL is a specification that the graphics card manufacturers and those writing the graphics drivers adheer by. Since many different computers support this common standard, it can be used as an abstracted API. It is the graphics cards manufacturer's job to make sure their graphics card supports OpenGL so that the OpenGL API is useable with that graphics card. Drivers also play an important role in making it possible to use OpenGL. From the view of a programmer, OpenGL is merely the API used to make the graphics card work.])

#text(font:"Libertinus Serif")[== Core-profile vs Immediate mode]
#block(inset:(left:23pt), par[
Immediate mode is easier to use and abstracts away much of the flexibility of Core-profile. The Immediate mode used to be the standard when using OpenGL, however, as developers wanted more controll and flexibility, Core-profile was implemented to meet their needs.
])

#text(font:"Libertinus Serif")[== Extensions]
#block(inset:(left:23pt),par[
  OpenGL supports extentions. This means that whenever new technology arrives, extentions can be added to the drivers to support said functionality. If the hardware the program runs on supports an extention, it can be used to for example render things more effectively.

  For example, to make use of potentially avaliable extensions, one can choose to execute a set of instructions that make use of said extensions if they are avaliable, and handle the operation alternatively in the case that they are not. @extension_code highlights this.
#figure(block(fill:silver,inset: 10pt,width:100%,par[
```cpp
if(GL_ARB_extension_name)
{
// Do cool new and modern stuff supported by hardware
}
else
{
// Extension not supported: do it the old way
}
```
]),
caption: [Extension code example.]

)<extension_code>
])

#text(font:"Libertinus Serif")[== State machine behaviour]
#block(inset:(left:23pt),par[
OpenGL behaves as a state machine, it is used by manipulating the state of the program reffered to as the OpenGL #text(green)[context]. State changing functions are used to change the state so that state-using functions can use the context to evaluate. 

])

#text(font:"Libertinus Serif")[== Objects]
#block(inset:(left:23pt),par[
  In OpenGL, objects are collections of settings that represent a set of contexts. For example, the settings of the drawing window could be represented as an object that has fields for the settings like window size, avaliable colors and so on. @object_code highlights the typical OpenGL workflow using objects to manipulate the context.
  #figure(block(fill:silver,inset: 10pt,width:100%,par[
    ```cpp
    // The State of OpenGL
struct OpenGL_Context {
...
object_name* object_Window_Target;
...
};
// create object
unsigned int objectId = 0;
glGenObject(1, &objectId);
// bind/assign object to context
glBindObject(GL_WINDOW_TARGET, objectId);
// set options of object currently bound to GL_WINDOW_TARGET
glSetObjectOption(GL_WINDOW_TARGET, GL_OPTION_WINDOW_WIDTH, 800);
glSetObjectOption(GL_WINDOW_TARGET, GL_OPTION_WINDOW_HEIGHT, 600);
// set context target back to default
glBindObject(GL_WINDOW_TARGET, 0);
    ```
  ]),caption:[Object workflow])<object_code>
@object_code highlights the following workflow:

+ Create an object and store a reference to it as an id.
+ Bind the object to a context.
+ Set the window options.
+ Unbind the object by setting the current object id of the window to 0.

])
#text(font:"Libertinus Serif")[== GLFW]
#block(inset: (left : 23pt),par[
  GLFW stands for Graphics Library FrameWork and is the framework used to create and work with the OpenGL context. GLFW is the provider of the OpenGL API.
])

#text(font:"Libertinus Serif")[== GLAD]
#block(inset:(left:23pt),par[
  Since OpenGL is merely a specification, the actual operations behind function calls are left to the graphics card manufacturer to implement. This means that the functions are not avalaible during compile time, during runtime we need to specify the pointers to the functions on any specific machine. This task is up to the programmer to do. In Windows, it is done by extracting the pointers to the function locations and storing them in pointers for later use. @glad_code demonstrates the assignment of pointer values in Windows. Note that this approach is specific to Windows and would have to be rewritten to work on other operating systems. GLAD abstracts away the OS specific parts of this process and provides pointers to the functions without having to manually ask the OS.

  #figure(block(fill:silver,inset:10pt,width:100%,par[
    ```cpp
// define the function’s prototype
typedef void (*GL_GENBUFFERS) (GLsizei, GLuint*);
// find the function and assign it to a function pointer
GL_GENBUFFERS glGenBuffers =
(GL_GENBUFFERS)wglGetProcAddress("glGenBuffers");
// function can now be called as normal
unsigned int buffer;
glGenBuffers(1, &buffer);
    ```

  ]),caption:[Windows example])<glad_code>
])

#text(size:20pt,font:"Libertinus Serif",align(right)[= Examples])

#text(font:"Libertinus Serif")[== Window Creation]

#block(inset: (left:23pt),par[
  This section goes through how to create a "Hello World" window. First, make sure to include GLAD and GLFW in your project. Note that GLAD has to be included before GLFW.

#block(fill:silver,inset:10pt,width:100%,par[
    ```cpp
#include <glad/glad.h>
#include <GLFW/glfw3.h>
    ```
  ])
Initialize the OpenGL context. In this example to force version 3.3 and use the Core_profile.
#block(fill:silver,inset:10pt,width:100%,par[
    ```cpp
//Initialize OpenGL Context
glfwInit();
glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    ```
  ])
We need to initialize GLAD with the function that loads the addresses of the OpenGL function pointers for us to use. GLFW gives us glfwGetProcAddress for this.
#block(fill:silver,inset:10pt,width:100%,par[
    ```cpp
// Iitialize GLAD
if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
{
std::cout << "Failed to initialize GLAD" << std::endl;
return -1;
}
    ```
  ])
Create a window object and make it the current context.
#block(fill:silver,inset:10pt,width:100%,par[
    ```cpp
// Create window object
GLFWwindow* window = glfwCreateWindow(800, 600, "LearnOpenGL", NULL, NULL);
if (window == NULL)
{
  std::cout << "Failed to create GLFW window" << std::endl;
  glfwTerminate();
  return -1;
}
glfwMakeContextCurrent(window);
    ```
  ])
Initialize the viewport. The viewport is an "abstract" screen that we draw on, the window can render the viewport to display it fully. In this example, the viewport is set to the same size as the window.
#block(fill:silver,inset:10pt,width:100%,par[
    ```cpp
// Initialize viewport
glViewport(0, 0, 800, 600);
    ```
  ])
When resizing the window in the OS, we need to update the window and potentially the viewport settings so that it is in line with the actual window size. This can be done by adding callback hook to the resize window event already set up in GLFW.
#block(fill:silver,inset:10pt,width:100%,par[
    ```cpp
//Set resize window event callback function
void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
glViewport(0, 0, width, height);
}
glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
    ```
  ])
To render more than one frame in this example, a render loop is added. Here we check if the window has been ordered to close, if not, continue the loop. Inside the loop we poll events and swap the color buffer of the window which basically draws the color buffer on screen. The swapping of the buffer is better understood by looking up double buffers. 
#block(fill:silver,inset:10pt,width:100%,par[
    ```cpp
//Empty render loop
while(!glfwWindowShouldClose(window))
{
glfwSwapBuffers(window);
glfwPollEvents();
}
    ```
  ])
When closing the application, we need to clean the resources GLFW allocated by calling...
#block(fill:silver,inset:10pt,width:100%,par[
    ```cpp
glfwTerminate();
return 0; // To return out of main function.
    ```
  ])
])

== Input
#block(inset:(left:23pt),par[
  A basic polling based input implementation would look something like ...
  #block(fill:silver,inset:10pt,width:100%,par[
    ```cpp
//ProcessInput is to be called every frame in the update method
void processInput(GLFWwindow *window)
{
if(glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
glfwSetWindowShouldClose(window, true);
}
    ```
  ])
  However, one would probably want to implement this in an event based manner to enable efficient
  coding. When implementing a agem engine, the question of how to implement the input system is
  relevant to enable future programmers implementing games in the game engine to be able to easily write optimized games without unnessecary polling.
])
== Hello Triangle
=== Vertex shader
=== Fragment shader 






#pagebreak()
#text(size:20pt,align(right)[= Concepts])
#par[
  This section goes through different concepts relevant when using OpenGL and trying to understand how it operates. 
]

#text(font:"Libertinus Serif")[== Window]

=== Window Creation Hints
#block(inset:(left:26pt),par[
  Window hints need to be set before the creation of the window and context you wish to have the specified attributes. They function as additional arguments to glfwCreateWindow.

  Relevant hints:

  - *GLFW_CONTEXT_VERSION_MAJOR* / *GLFW_CONTEXT_VERSION_MINOR* Specifies the client API version that the created context must be compatible with. Ex. 3.1 means major is 3 and minor is 1. (3.3 is used in the learnopengl book)
  - *GLFW_OPENGL_PROFILE* specifies which OpenGL profile to create the context for. (*GLFW_OPENGL_CORE_PROFILE* or *GLFW_OPENGL_COMPAT_PROFILE*), we mostly use *GLFW_OPENGL_CORE_PROFILE* since we are working with the core-profile.

])

== Graphics pipeline
#block(inset:(left:23pt),par[
  The graphics pipeline takes as input a set of 3D coordinates and processes them to display a 2D image on screen. This is done through a number of steps, each applying algorithms / shaders to the data from the last step to in the end get the image to output. The main stages in the graphics pipeline can be abstracted to the steps shown in @graphics_pipeline_abstracted. Note that the programmer is *required* to define at least a vertex and fragment shader to use OpenGL, meaning they are not provided by the graphics card as a default.  

  #figure(
    image("graphics-pipeline.png", width:100%),
    caption: [Graphics pipeline abstracted.]
  )<graphics_pipeline_abstracted>

  === Vertex Shaders
  #block(inset:(left:26pt),par[
    In this first stage, given access to the verticies in world space that make up our world, we want to move our perspective to the campera position. The vertex shader step converts world space coordinates to coordinates in a new space that is aligned with the position of the camera.
  ])
  === Shape Assembly
  #block(inset:(left:26pt),par[
    Assembles shapes according to the shape types. Ex. triangle, point, line. In OpenGL : *GL_POINTS*,
    *GL_TRIANGLES* and *GL_LINE_STRIP* are hints passed alongside the 3D space vectors so that OpenGL knows how to interpret and assemble the shapes.
  ])
  === Rasterization
  #block(inset:(left:26pt),par[
    Rasterization is the process of taking an image in vector graphics format and converting it into a raster image. A raster image is a series of pixels dots or lines that when displayed together create the image which was represented via shapes on the 2D screen.  Basically converiting 3D shapes to a 2D raster image.
  ])
  === Fragment Shader
  #block(inset:(left:26pt),par[
    For each pixel covered by the rasterization, computes the expected color. Effects like lighting can effect this calculation. Clipping is performed before the fragment shader to improve performance. This is usually the shader that is manipulated to create complex effects with OpenGL.
  ])
  === Testing And Blending
  #block(inset:(left:26pt),par[
    Tests which pixels are visible by performin a depth test which only keeps the pixels closest to the camera. Things like transparency may have effect here. 
  ])

  == Vertex input In-depth
  #block(inset:(left:23pt),par[
    To send the vertex input to the first part of the OpenGL graphics pipeline, we first need the data. In the hello triangle example, the data  for a triangle is given as ...
    #block(fill:silver,inset:10pt,width:100%,par[
    ```cpp
float vertices[] = {
-0.5f, -0.5f, 0.0f,
0.5f, -0.5f, 0.0f,
0.0f, 0.5f, 0.0f
};
    ```
    ])
    This data is to be sent to the vertex shader by first creating memory on the GPU where we want to store it, then configure how OpenGL should interpret the data and specify how to send it to the graphics card. The vertex shader then processes as many verticies as we tell it to from it's memory.

    Sending small packets of data from the CPU to the graphics card is usually slow, therefore we instead want to send the data in larger chunks. To do this we use Vertex Buffer Objects (#text(green,[VBO])). VBOs can be generated with the ```cpp glGenBuffers()``` function.  
  ])

])





/*
Code for code figures...

#figure(block(fill:silver,inset:10pt,width:100%,par[
    ```cpp
    ```
  ]),caption:[caption])<figure_name>

'
#block(fill:silver,inset:10pt,width:100%,par[
    ```cpp
    ```
  ])

*/