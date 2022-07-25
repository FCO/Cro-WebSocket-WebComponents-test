# Cro WebSocket WebComponent

This is a test of something like a Islanf Architecture where the dev user
do not need to write JS and do the system completely in Raku using Cro.

This example is a "shared" todo list with several components:
- App      - the non-shared root of the components
- TodoList - a shared component that has the list of todos
- Todo     - the todo component itself. Has description and done attributes

Each component has its respective template on `resources/` dir.

The generic files are together with the components and templates and will be
removed in case of creating a module for that.

To try it out,
you'll need to have Cro installed; you can do so using:

```
zef install --/test cro
```

Then change directory to the app root (the directory containing this
`README.md` file), and run these commands:

```
zef install --depsonly .
cro run
```

You can also build and run a docker image while in the app root using:

```
docker build -t todo .
docker run --rm -p 10000:10000 todo
```
