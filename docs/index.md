## Cloth Simulation
A project by Henry Huynh (huynh407@umn.edu) / (henryh1404@gmail.com)

## About

A project for _CSCI 5611: Animation and Planning in Games_. The directive was to use numerical integration techniques to simulate physical-systems that follow well-known rules. Particularly, the simulation of a cloth using nodes (particles) and an interconnected system of springs.

The code is currently written in a data-oriented manner. This is mainly for performance reasons, but could be easily rewritten in a more object-oriented fashion by splitting the cloth into node and spring objects.

The system is currently initialized with a total of one hundred nodes (10x10). For each node, a position, velocity, and acceleration is stored. A spring force is currently generated across all horizontal and vertical neighbors.

There are a number of adjustable parameters that can completely change how the simulation runs. They are currently set to a stable and effective amount.
- spring constant and scaling dampening force
- coefficient of restitution (how much the nodes bounce off the sphere)
- resting length vs initial length
- gravity vector
- node mass
- timestep

On each update, the new velocities are saved for the entire system before they are then used to update the positions.

The overall system is rendered in 3D and is set to collide with a sphere. The Peasy camera library is utilized for a free view camera.

## Code

The source code is available for download [here](https://github.com/h-huynh/Cloth-Simulation).

## Media

### Cloth without texture

{% include youtubePlayer.html id=page._Q1cTTiUKx4 %}

### Textured cloth

{% include youtubePlayer.html id=page.53tUS3384AQ %}

### Adding a pointlight - van Gogh makes the sun disappear [possible art submission]

{% include youtubePlayer.html id=page.9VKu5EA2pZI %}

## Credit

For the camera, the [Peasy camera library](http://mrfeinberg.com/peasycam/) was used.

Textures:
- [Sun](https://www.123rf.com/photo_70124417_abstract-yellow-background-texture.html)
- [Cloth](https://arstechnica.com/science/2019/04/what-starry-night-has-in-common-with-gassy-clouds-where-stars-are-born/)


