#!/bin/sh

# Self path.
__self="$0"
if [ ! -f "$__self" ]; then
	__self="`which "$__self"`"
fi

# Resolve symlinks.
while [ -h "$__self" ]; do
	__file="`readlink "$__self"`"
	case "$__file" in
	/*)
		__self="$__file"
		;;
	*)
		__self="`dirname "$__self"`/$__file"
		;;
	esac
done

# Assemble paths.
__filename="`basename "$__self"`"
__dir="`dirname "$__self"`"
__dir="`cd "$__dir" > /dev/null && pwd`"
__file="$__dir/$__filename"
__suffix='.data'

# Run projector.
exec "$__file$__suffix/$__filename" "$@"
