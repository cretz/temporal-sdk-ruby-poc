(under development)

## Development

### Build

Prerequisites:

* [Ruby](https://www.ruby-lang.org/) (i.e. `ruby` and `bundle` on the `PATH`)
* [Rust](https://www.rust-lang.org/) (i.e. `cargo` on the `PATH`)
* [Protobuf Compiler](https://protobuf.dev/) (i.e. `protoc` on the `PATH`)
* This repository, cloned recursively

To build shared library for development use:

    bundle exec rake compile:dev

To build and test release:

    bundle exec rake

### Testing

This project uses `minitest`. To test:

    bundle exec test

Single test:

    bundle exec test TESTOPTS=

### Code Formatting and Type Checking

This project uses `rubocop`:

    bundle exec rake rubocop:autocorrect

This project uses `steep`:

    bundle exec rake steep

### Proto Generation

Run:

    bundle exec rake proto:generate

## TODO

* Try to use wrap instead of TypedData
* Note that https://github.com/square/rbs_protobuf doesn't yet support google-protobuf, so it is unreasonable to have typed protobuf at this time