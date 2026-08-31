SHELL := /usr/bin/env bash

cluster-up:
	./scripts/cluster-up.sh

cluster-down:
	./scripts/cluster-down.sh

reset: timer-stop
	kubectl delete ns project-01 project-02 project-03 project-04 project-05 project-r500 project-gwfix project-snake project-09 project-10 project-11 project-12 project-13 project-rbac project-15a project-15b project-16 project-17 project-18 project-19 project-20 --ignore-not-found
	rm -rf /tmp/cka-prep-labs

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
