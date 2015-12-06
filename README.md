PSueer
================

Automated Installation Kit

<img src="https://img.shields.io/dub/l/vibe-d.svg" />

PSueer is a set of software installation aids, with command-line parameters and batch execution in two ways, built-in functions that allow you to create file, registry, Windows, desktop, system, service operations, and support the system environment variables and CMD command can be written directly without conversion.

<h2><a name="usage" class="anchor" href="#usage"><span class="mini-icon mini-icon-link"></span></a>Usage</h2>

Run from command line. For example:

```shell
Start /wait PSueer.exe "Example\example_run.rcini2"
Start /wait PSueer.exe "Example\example_sendwinbycontrol.rcini2"
```

The file <code>PSueer.rcini2</code> is optional.

```shell
Start /wait PSueer.exe "PSueer.rcini2"
```

<h2><a name="example" class="anchor" href="#example"><span class="mini-icon mini-icon-link"></span></a>Example</h2>

Create the automatically script in <code>PSueer.rcini2</code>.

```shell

```

<h2><a name="hotkey" class="anchor" href="#hotkey"><span class="mini-icon mini-icon-link"></span></a>Hotkey</h2>

```shell
Esc: exit
Pause:  pause a program
```

```shell
F2: recording mouse coordinates
F3: recording input text
F4: recording keyboard input
F5: undo the last
F6: exit
TAB: next control
```

<h2><a name="author" class="anchor" href="#author"><span class="mini-icon mini-icon-link"></span></a>Author</h2>
* 2010 rchockxm (rchockxm.silver@gmail.com)

<h2><a name="credits" class="anchor" href="#credits"><span class="mini-icon mini-icon-link"></span></a>Credits</h2>

* zorphnog - Busy function.
* trancexx - GIFAnimation, _CRC32ForFile function.
* Shafayat - _FileIsPathValid function.
