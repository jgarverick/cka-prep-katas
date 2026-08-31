SHELL := /usr/bin/env bash

cluster-up:
	./scripts/cluster-up.sh

cluster-down:
	./scripts/cluster-down.sh

reset: timer-stop
	kubectl delete ns project-01 project-r500 project-snake --ignore-not-found

seed:
	@if [[ -z "$(EXERCISE)" ]]; then echo "Usage: make seed EXERCISE=n"; exit 1; fi
	./scripts/run-seed.sh $(EXERCISE)

verify:
	@if [[ -z "$(EXERCISE)" ]]; then echo "Usage: make verify EXERCISE=n"; exit 1; fi
	./scripts/run-verify.sh $(EXERCISE)

solve:
	@if [[ -z "$(EXERCISE)" ]]; then echo "Usage: make solve EXERCISE=n"; exit 1; fi
	./scripts/solve.sh $(EXERCISE)

timer-stop:
	./scripts/timer.sh stop

timer-status:
	./scripts/timer.sh status

stats:
	./scripts/stats.sh

exam:
	./scripts/exam.sh
