# makefiles

A collection of Makefiles.

## Description

This is a collection of Makefiles to facilitate development for GitHub Actions.

## Usage

At the beginning of your `Makefile` add, the following:

```makefile
-include .makefiles/reusable-workflows/Makefile
.makefiles/reusable-workflows/Makefile:
	@git clone https://github.com/tmknom/makefiles.git .makefiles >/dev/null 2>&1
```

After running the `make` command, the repository will be downloaded to the `.makefiles` directory,
and the specified `Makefile` will be included at runtime.

Run `make help` to view a list of available targets.

> [!NOTE]
> Highly recommend adding the `.makefiles` directory to your `.gitignore`.

## Release notes

See [GitHub Releases](https://github.com/tmknom/makefiles/releases).

## License

Apache 2 Licensed. See [LICENSE](/LICENSE) for full details.
