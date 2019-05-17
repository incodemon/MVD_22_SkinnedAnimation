#version 330

layout(location = 0) in vec3 a_vertex;
layout(location = 1) in vec2 a_uv;
layout(location = 2) in vec3 a_normal;

uniform mat4 u_mvp;
uniform mat4 u_vp;
uniform mat4 u_model;
uniform mat4 u_normal_matrix;
uniform vec3 u_cam_pos;

out vec2 v_uv;
out vec3 v_normal;
out vec3 v_vertex_world_pos;
out vec3 v_cam_dir;


void main(){
    
    //uvs
    v_uv = a_uv;
    
    //calculate direction to camera in world space
    v_cam_dir = u_cam_pos - v_vertex_world_pos;
    
    //unweighted position of vertex
    vec4 vertex4 = vec4(a_vertex, 1.0);
    
    //variables to store final position and normal
    vec4 final_vert = vec4(0.0);
    vec3 final_normal = vec3(0.0);
    
    
    //TODO: skeletal animation here

    
    final_vert = vertex4;
    final_normal = (u_normal_matrix * vec4(a_normal, 1.0)).xyz;
    
    //set the final position and normal
    v_vertex_world_pos = final_vert.xyz;
    v_normal = final_normal;
    

    //output vertex to NDC
    gl_Position = u_vp * final_vert;
}

